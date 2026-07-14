import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/currency.dart';
import '../utils/currency_flags.dart';

/// A searchable bottom sheet for selecting a currency.
/// Shows favorites at the top, then all currencies with live filtering.
class CurrencySearchSheet extends StatefulWidget {
  final List<Currency> currencies;
  final List<String> favorites;
  final Currency? selected;
  final ValueChanged<Currency> onSelected;

  const CurrencySearchSheet({
    super.key,
    required this.currencies,
    required this.favorites,
    this.selected,
    required this.onSelected,
  });

  static Future<Currency?> show(
    BuildContext context, {
    required List<Currency> currencies,
    required List<String> favorites,
    Currency? selected,
  }) {
    return showModalBottomSheet<Currency>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CurrencySearchSheet(
        currencies: currencies,
        favorites: favorites,
        selected: selected,
        onSelected: (c) => Navigator.of(ctx).pop(c),
      ),
    );
  }

  @override
  State<CurrencySearchSheet> createState() => _CurrencySearchSheetState();
}

class _CurrencySearchSheetState extends State<CurrencySearchSheet> {
  final _searchController = TextEditingController();
  late List<Currency> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.currencies;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _filtered = q.isEmpty
          ? widget.currencies
          : widget.currencies.where((c) {
              return c.code.contains(q) || c.name.toLowerCase().contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundCard : Colors.white;
    final screenHeight = MediaQuery.of(context).size.height;

    // Separate favorite currencies
    final favoriteCurrencies = widget.currencies
        .where((c) => widget.favorites.contains(c.code))
        .toList();

    return Container(
      height: screenHeight * 0.75,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.textMuted : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Select Currency',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: GoogleFonts.outfit(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search by code or name...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Favorites chips
          if (favoriteCurrencies.isNotEmpty && _searchController.text.isEmpty)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: favoriteCurrencies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cur = favoriteCurrencies[i];
                  final isSelected = cur == widget.selected;
                  return ActionChip(
                    label: Text(
                      '${CurrencyFlags.getFlag(cur.code)} ${cur.code.toUpperCase()}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.backgroundDark
                            : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                    backgroundColor: isSelected
                        ? AppColors.copper
                        : (isDark ? AppColors.surfaceElevated : AppColors.lightSurface),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.copper
                          : (isDark ? AppColors.glassBorder : Colors.grey.shade300),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () => widget.onSelected(cur),
                  );
                },
              ),
            ),

          const SizedBox(height: 8),

          // Currency list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'No currencies found',
                      style: GoogleFonts.outfit(color: AppColors.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final cur = _filtered[i];
                      final isSelected = cur == widget.selected;
                      return _CurrencyTile(
                        currency: cur,
                        isSelected: isSelected,
                        isFavorite: widget.favorites.contains(cur.code),
                        onTap: () => widget.onSelected(cur),
                        isDark: isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onTap;
  final bool isDark;

  const _CurrencyTile({
    required this.currency,
    required this.isSelected,
    required this.isFavorite,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selected: isSelected,
        selectedTileColor: AppColors.copper.withValues(alpha: 0.12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Text(
          CurrencyFlags.getFlag(currency.code),
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(
          currency.code.toUpperCase(),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isSelected
                ? AppColors.copper
                : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
          ),
        ),
        subtitle: Text(
          currency.name,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isFavorite
            ? Icon(Icons.star_rounded, size: 18, color: AppColors.copper.withValues(alpha: 0.6))
            : null,
      ),
    );
  }
}
