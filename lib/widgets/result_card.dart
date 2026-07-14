import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_colors.dart';
import '../models/conversion_result.dart';
import '../utils/currency_flags.dart';
import '../utils/formatters.dart';
import 'glass_card.dart';

class ResultCard extends StatelessWidget {
  final ConversionResult result;
  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          _buildAmount(isDark),
          const SizedBox(height: 16),
          _buildRateBadge(isDark),
          const SizedBox(height: 8),
          _buildTimestamp(isDark),
          const SizedBox(height: 16),
          _buildActions(context, isDark),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildHeader(bool isDark) {
    final color = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${CurrencyFlags.getFlag(result.fromCode)} ${result.fromCode.toUpperCase()}',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.copper),
        ),
        Text('${CurrencyFlags.getFlag(result.toCode)} ${result.toCode.toUpperCase()}',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }

  Widget _buildAmount(bool isDark) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            Formatters.formatAmount(result.convertedAmount),
            style: GoogleFonts.outfit(fontSize: 44, fontWeight: FontWeight.w700, color: AppColors.copper),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut),
        Text(result.toCode.toUpperCase(),
            style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
      ],
    );
  }

  Widget _buildRateBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceOverlay.withValues(alpha: 0.5) : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '1 ${result.fromCode.toUpperCase()} = ${Formatters.formatRate(result.rate)} ${result.toCode.toUpperCase()}',
        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.sage),
      ),
    );
  }

  Widget _buildTimestamp(bool isDark) {
    return Text(
      'Updated ${Formatters.formatLastUpdated(result.timestamp)}',
      style: GoogleFonts.outfit(fontSize: 12, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
    );
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionChip(icon: Icons.copy_rounded, label: 'Copy', isDark: isDark, onTap: () {
          Clipboard.setData(ClipboardData(text: Formatters.formatAmount(result.convertedAmount)));
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 2)),
          );
        }),
        const SizedBox(width: 12),
        _ActionChip(icon: Icons.share_rounded, label: 'Share', isDark: isDark, onTap: () {
          final text = Formatters.buildShareText(
            amount: result.amount, fromCode: result.fromCode,
            toCode: result.toCode, result: result.convertedAmount, rate: result.rate,
          );
          SharePlus.instance.share(ShareParams(text: text));
          HapticFeedback.lightImpact();
        }),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  const _ActionChip({required this.icon, required this.label, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.glassBorder : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.copper),
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.outfit(
                fontSize: 13, fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
