import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Forest background
  static const Color backgroundDark = Color(0xFF101817);
  static const Color backgroundCard = Color(0xFF182422);
  static const Color surfaceElevated = Color(0xFF1E2E2B);
  static const Color surfaceOverlay = Color(0xFF243834);

  // Copper accent
  static const Color copper = Color(0xFFD48A42);
  static const Color copperLight = Color(0xFFE8A860);
  static const Color copperDark = Color(0xFFB0702E);

  // Sage green secondary
  static const Color sage = Color(0xFF7A9E7E);
  static const Color sageLight = Color(0xFF9ABEA0);
  static const Color sageDark = Color(0xFF5A7E5E);

  // Text hierarchy
  static const Color textPrimary = Color(0xFFF2ECE4);
  static const Color textSecondary = Color(0xFFA8B0AC);
  static const Color textMuted = Color(0xFF687874);

  // Status
  static const Color error = Color(0xFFE05858);
  static const Color success = Color(0xFF58C278);

  // Glassmorphism
  static const Color glassWhite = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);

  // Gradients
  static const LinearGradient copperGradient = LinearGradient(
    colors: [copperDark, copper, copperLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2C28), Color(0xFF162420)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, backgroundCard, backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light theme overrides
  static const Color lightBackground = Color(0xFFF5F2ED);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF0EDE6);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightTextMuted = Color(0xFF9E9E9E);
  static const Color lightGlassWhite = Color(0x14000000);
  static const Color lightGlassBorder = Color(0x1A000000);
}
