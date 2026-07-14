import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/currency.dart';
import '../utils/currency_flags.dart';

/// A styled currency selector tile that opens the search sheet on tap.
class CurrencySelector extends StatelessWidget {
  final String label;
  final Currency? selected;
  final VoidCallback onTap;

  const CurrencySelector({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceElevated.withValues(alpha: 0.5)
                    : AppColors.lightSurface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.glassBorder : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  if (selected != null) ...[
                    Text(
                      CurrencyFlags.getFlag(selected!.code),
                      style: const TextStyle(fontSize: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected!.code.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            selected!.name,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Text(
                        'Select currency',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
