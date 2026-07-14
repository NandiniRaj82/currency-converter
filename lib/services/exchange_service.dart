import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/currency.dart';

/// Handles all communication with the exchange rate API.
/// Implements automatic fallback from jsDelivr CDN to Cloudflare Pages.
class ExchangeService {
  final http.Client _client;
  Map<String, double>? _cachedRates;
  String? _cachedRatesBase;
  DateTime? _lastFetchTime;

  ExchangeService({http.Client? client}) : _client = client ?? http.Client();

  DateTime? get lastFetchTime => _lastFetchTime;

  /// Fetches the list of all available currencies.
  Future<List<Currency>> fetchCurrencies() async {
    final data = await _fetchWithFallback(
      primary: ApiConstants.currenciesUrl(),
      fallback: ApiConstants.currenciesUrl(fallback: true),
    );

    return data.entries
        .where((e) => e.value is String && (e.value as String).isNotEmpty)
        .map((e) => Currency(
              code: e.key,
              name: _capitalize(e.value as String),
            ))
        .toList()
      ..sort((a, b) => a.code.compareTo(b.code));
  }

  /// Fetches exchange rates for [baseCurrency] against all other currencies.
  /// Caches the result to avoid redundant network calls within a session.
  Future<Map<String, double>> fetchRates(String baseCurrency, {bool forceRefresh = false}) async {
    final code = baseCurrency.toLowerCase();

    if (!forceRefresh && _cachedRatesBase == code && _cachedRates != null) {
      return _cachedRates!;
    }

    final data = await _fetchWithFallback(
      primary: ApiConstants.ratesUrl(code),
      fallback: ApiConstants.ratesUrl(code, fallback: true),
    );

    final ratesMap = data[code] as Map<String, dynamic>?;
    if (ratesMap == null) {
      throw ExchangeException('Invalid rate data for $code');
    }

    _cachedRates = ratesMap.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
    _cachedRatesBase = code;
    _lastFetchTime = DateTime.now();

    return _cachedRates!;
  }

  /// Converts [amount] from [fromCode] to [toCode].
  Future<double> convert({
    required double amount,
    required String fromCode,
    required String toCode,
    bool forceRefresh = false,
  }) async {
    final rates = await fetchRates(fromCode, forceRefresh: forceRefresh);
    final rate = rates[toCode.toLowerCase()];
    if (rate == null) {
      throw ExchangeException('Rate not found for ${toCode.toUpperCase()}');
    }
    return amount * rate;
  }

  /// Returns the exchange rate from [fromCode] to [toCode].
  Future<double> getRate(String fromCode, String toCode) async {
    final rates = await fetchRates(fromCode);
    return rates[toCode.toLowerCase()] ?? 0;
  }

  void clearCache() {
    _cachedRates = null;
    _cachedRatesBase = null;
    _lastFetchTime = null;
  }

  /// Tries the primary URL first, falls back to the secondary on any failure.
  Future<Map<String, dynamic>> _fetchWithFallback({
    required String primary,
    required String fallback,
  }) async {
    try {
      return await _fetch(primary);
    } catch (_) {
      return await _fetch(fallback);
    }
  }

  Future<Map<String, dynamic>> _fetch(String url) async {
    final response = await _client
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw ExchangeException('HTTP ${response.statusCode}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class ExchangeException implements Exception {
  final String message;
  const ExchangeException(this.message);

  @override
  String toString() => message;
}
