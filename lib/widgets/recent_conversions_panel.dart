import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/conversion_result.dart';
import '../utils/currency_flags.dart';
import '../utils/formatters.dart';
import 'glass_card.dart';

class RecentConversionsPanel extends StatelessWidget {
  final List<ConversionResult> conversions;
  final ValueChanged<ConversionResult>? onTap;
  final VoidCallback? onClear;

  const RecentConversionsPanel({
    super.key,
    required this.conversions,
    this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (conversions.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent',
                  style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
              if (onClear != null)
                TextButton(
                  onPressed: onClear,
                  child: Text('Clear',
                      style: GoogleFonts.outfit(fontSize: 13, color: AppColors.copper)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...conversions.take(5).map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RecentTile(conversion: c, isDark: isDark, onTap: () => onTap?.call(c)),
            )),
      ],
    );
  }
}

class _RecentTile extends StatelessWidget {
  final ConversionResult conversion;
  final bool isDark;
  final VoidCallback onTap;

  const _RecentTile({required this.conversion, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Text(CurrencyFlags.getFlag(conversion.fromCode), style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(CurrencyFlags.getFlag(conversion.toCode), style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Formatters.formatAmount(conversion.amount)} ${conversion.fromCode.toUpperCase()}',
                    style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                  ),
                  Text(
                    '${Formatters.formatAmount(conversion.convertedAmount)} ${conversion.toCode.toUpperCase()}',
                    style: GoogleFonts.outfit(fontSize: 13, color: AppColors.sage),
                  ),
                ],
              ),
            ),
            Text(
              Formatters.formatLastUpdated(conversion.timestamp),
              style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
