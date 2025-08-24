import 'package:flutter/material.dart';

/// App-wide color constants for Islamic theming
class AppColors {
  // Primary Islamic colors
  static const Color islamicGreen = Color(0xFF2E7D32);
  static const Color islamicGold = Color(0xFFFFB300);
  static const Color islamicBlue = Color(0xFF1565C0);

  // Secondary colors
  static const Color lightGreen = Color(0xFFA5D6A7);
  static const Color darkGreen = Color(0xFF1B5E20);

  // Accent colors
  static const Color warmGold = Color(0xFFFFA000);
  static const Color deepBlue = Color(0xFF0D47A1);

  // Neutral colors
  static const Color softWhite = Color(0xFFFAFAFA);
  static const Color textGray = Color(0xFF424242);
  static const Color lightGray = Color(0xFFE0E0E0);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient colors
  static const LinearGradient islamicGradient = LinearGradient(
    colors: [islamicGreen, islamicGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient peaceGradient = LinearGradient(
    colors: [islamicBlue, lightGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
