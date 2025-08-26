import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Secure Admin Theme - Red Alert Design for Security
class AdminTheme {
  // SECURITY: Red color scheme to indicate admin/dangerous operations
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color lightRed = Color(0xFFFFCDD2);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color criticalRed = Color(0xFFE53935);

  // Background colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Color(0xFFFAFAFA);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnRed = Colors.white;

  // Status colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color infoBlue = Color(0xFF2196F3);
  static const Color errorRed = Color(0xFFE53935);

  // Spacing and sizing
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;

  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;

  /// Build secure light theme for admin app
  static ThemeData buildSecureTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // SECURITY: Red color scheme to indicate admin access
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.light,
        primary: primaryRed,
        secondary: warningOrange,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorRed,
        onPrimary: textOnRed,
        onSecondary: textOnRed,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textOnRed,
      ),

      // Scaffold theme
      scaffoldBackgroundColor: backgroundColor,

      // AppBar theme - Security red
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: textOnRed,
        elevation: 4,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(color: textOnRed, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: textOnRed),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
        margin: const EdgeInsets.all(spaceMd),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.all(spaceMd),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: textOnRed,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: spaceMd),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: spaceMd),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceSm),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryRed,
        foregroundColor: textOnRed,
        elevation: 4,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryRed,
        unselectedItemColor: textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Tab bar theme
      tabBarTheme: const TabBarTheme(
        labelColor: primaryRed,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryRed,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // Data table theme
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(lightRed),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightRed;
          }
          return surfaceColor;
        }),
        headingTextStyle: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
        dataTextStyle: const TextStyle(color: textPrimary, fontSize: 14),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: textPrimary, size: 24),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontSize: 28, fontWeight: FontWeight.w600),
        displaySmall: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w400),
      ),
    );
  }

  /// Build secure dark theme for admin app
  static ThemeData buildSecureDarkTheme() {
    return buildSecureTheme().copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.dark,
        primary: primaryRed,
        secondary: warningOrange,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: errorRed,
        onPrimary: textOnRed,
        onSecondary: textOnRed,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: textOnRed,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
        margin: const EdgeInsets.all(spaceMd),
      ),
    );
  }

  /// Get status color based on security level
  static Color getStatusColor(String level) {
    switch (level.toLowerCase()) {
      case 'info':
        return infoBlue;
      case 'warning':
        return warningOrange;
      case 'critical':
        return criticalRed;
      case 'emergency':
        return errorRed;
      default:
        return textSecondary;
    }
  }

  /// Get status icon based on security level
  static IconData getStatusIcon(String level) {
    switch (level.toLowerCase()) {
      case 'info':
        return Icons.info_outline;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'critical':
        return Icons.error_outline;
      case 'emergency':
        return Icons.crisis_alert;
      default:
        return Icons.help_outline;
    }
  }
}
