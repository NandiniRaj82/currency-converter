import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_result.dart';

/// Persists user preferences: favorites, recent conversions, theme, and last-used currencies.
class StorageService {
  static const _favoritesKey = 'favorite_currencies';
  static const _recentsKey = 'recent_conversions';
  static const _themeKey = 'is_dark_mode';
  static const _lastFromKey = 'last_from_currency';
  static const _lastToKey = 'last_to_currency';
  static const _maxRecents = 20;

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Favorites ---

  List<String> getFavorites() {
    return _prefs.getStringList(_favoritesKey) ?? ['usd', 'eur', 'gbp', 'jpy', 'inr'];
  }

  Future<void> toggleFavorite(String currencyCode) async {
    final favorites = getFavorites();
    if (favorites.contains(currencyCode)) {
      favorites.remove(currencyCode);
    } else {
      favorites.add(currencyCode);
    }
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  bool isFavorite(String currencyCode) => getFavorites().contains(currencyCode);

  // --- Recent Conversions ---

  List<ConversionResult> getRecentConversions() {
    final raw = _prefs.getStringList(_recentsKey) ?? [];
    return raw
        .map((s) {
          try {
            return ConversionResult.fromJson(
                json.decode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .where((r) => r != null)
        .cast<ConversionResult>()
        .toList();
  }

  Future<void> addRecentConversion(ConversionResult result) async {
    final recents = getRecentConversions();
    recents.insert(0, result);
    if (recents.length > _maxRecents) {
      recents.removeRange(_maxRecents, recents.length);
    }
    await _prefs.setStringList(
      _recentsKey,
      recents.map((r) => json.encode(r.toJson())).toList(),
    );
  }

  Future<void> clearRecentConversions() async {
    await _prefs.remove(_recentsKey);
  }

  // --- Theme ---

  bool isDarkMode() => _prefs.getBool(_themeKey) ?? true;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_themeKey, value);
  }

  // --- Last Used Currencies ---

  String getLastFromCurrency() => _prefs.getString(_lastFromKey) ?? 'usd';
  String getLastToCurrency() => _prefs.getString(_lastToKey) ?? 'eur';

  Future<void> setLastCurrencies(String from, String to) async {
    await _prefs.setString(_lastFromKey, from);
    await _prefs.setString(_lastToKey, to);
  }
}
