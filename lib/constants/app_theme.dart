import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.copper,
      secondary: AppColors.sage,
      surface: AppColors.backgroundCard,
      error: AppColors.error,
      onPrimary: AppColors.backgroundDark,
      onSecondary: AppColors.backgroundDark,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(AppColors.textPrimary),
    inputDecorationTheme: _inputThemeDark,
    elevatedButtonTheme: _elevatedButtonTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.copper),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.surfaceElevated,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.copper,
      secondary: AppColors.sage,
      surface: AppColors.lightCard,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(AppColors.lightTextPrimary),
    inputDecorationTheme: _inputThemeLight,
    elevatedButtonTheme: _elevatedButtonTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.copper),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightCard,
      contentTextStyle: const TextStyle(color: AppColors.lightTextPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );

  static TextTheme _buildTextTheme(Color primary) => TextTheme(
    displayLarge: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.w700, color: primary),
    displayMedium: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w700, color: primary),
    displaySmall: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w600, color: primary),
    headlineMedium: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
    titleLarge: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: primary),
    titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: primary),
    bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
    bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: primary),
    bodySmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: primary.withValues(alpha: 0.7)),
    labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
  );

  static final InputDecorationTheme _inputThemeDark = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.copper, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    floatingLabelStyle: GoogleFonts.outfit(color: AppColors.copper),
    labelStyle: GoogleFonts.outfit(color: AppColors.textMuted),
    hintStyle: GoogleFonts.outfit(color: AppColors.textMuted),
  );

  static final InputDecorationTheme _inputThemeLight = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurface.withValues(alpha: 0.5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.copper, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    floatingLabelStyle: GoogleFonts.outfit(color: AppColors.copper),
    labelStyle: GoogleFonts.outfit(color: AppColors.lightTextMuted),
    hintStyle: GoogleFonts.outfit(color: AppColors.lightTextMuted),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.copper,
      foregroundColor: AppColors.backgroundDark,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}
