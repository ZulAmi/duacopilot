import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../typography/arabic_typography.dart';

/// Professional Islamic Theme System with Enterprise-Grade Design
class ProfessionalTheme {
  // Professional Color Palette - Inspired by premium Islamic apps
  static const Color primaryEmerald = Color(0xFF0F5132); // Rich Islamic green
  static const Color secondaryGold = Color(0xFFB8860B); // Elegant gold accent
  static const Color backgroundColor = Color(0xFFFAFAFA); // Clean background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure surface
  static const Color textPrimary = Color(0xFF1A1A1A); // High contrast text
  static const Color textSecondary = Color(0xFF6B7280); // Subtle secondary text
  static const Color textTertiary = Color(0xFF9CA3AF); // Muted text
  static const Color borderLight = Color(0xFFE5E7EB); // Subtle borders
  static const Color borderMedium = Color(0xFFD1D5DB); // Medium borders
  static const Color successGreen = Color(0xFF10B981); // Success state
  static const Color warningOrange = Color(0xFFF59E0B); // Warning state
  static const Color errorRed = Color(0xFFEF4444); // Error state
  static const Color infoBlue = Color(0xFF3B82F6); // Info state

  // Neutral Grays for Professional Look
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Professional Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryEmerald, Color(0xFF198155)],
  );

  static const LinearGradient goldAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryGold, Color(0xFFD4AF37)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceColor, gray50],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceColor, Color(0xFFFBFBFB)],
  );

  // Animation Durations
  static const Duration quickDuration = Duration(milliseconds: 150);
  static const Duration standardDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 400);

  // Animation Curves
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve emphasizedCurve = Curves.easeOutCubic;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  // Spacing System
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2Xl = 48.0;
  static const double space3Xl = 64.0;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2Xl = 24.0;

  // Shadow System
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(color: gray900.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: gray900.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
    BoxShadow(color: gray900.withOpacity(0.04), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(color: gray900.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4)),
    BoxShadow(color: gray900.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> get focusShadow => [
    BoxShadow(color: primaryEmerald.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 0), spreadRadius: 2),
  ];

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryEmerald,
        onPrimary: surfaceColor,
        secondary: secondaryGold,
        onSecondary: surfaceColor,
        surface: surfaceColor,
        onSurface: textPrimary,
        error: errorRed,
        onError: surfaceColor,
      ),

      // Typography
      textTheme: _buildTextTheme(),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: surfaceColor,
        surfaceTintColor: surfaceColor,
        foregroundColor: textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: _buildTextTheme().headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: textPrimary),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: borderLight, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: surfaceColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: spaceMd),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryEmerald,
          side: const BorderSide(color: borderMedium),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: spaceMd),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryEmerald,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceSm),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryEmerald, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.all(spaceMd),
        hintStyle: TextStyle(color: textTertiary),
        labelStyle: TextStyle(color: textSecondary),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1, space: 1),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: gray100,
        selectedColor: primaryEmerald.withOpacity(0.12),
        secondarySelectedColor: primaryEmerald.withOpacity(0.12),
        labelStyle: TextStyle(color: textPrimary),
        secondaryLabelStyle: TextStyle(color: primaryEmerald),
        padding: const EdgeInsets.symmetric(horizontal: spaceSm, vertical: spaceXs),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        side: const BorderSide(color: borderLight),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryEmerald,
        unselectedItemColor: textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        elevation: 24,
        shadowColor: gray900.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXl)),
        titleTextStyle: _buildTextTheme().headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: textPrimary),
        contentTextStyle: _buildTextTheme().bodyMedium?.copyWith(color: textSecondary),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryEmerald,
        foregroundColor: surfaceColor,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: CircleBorder(),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    const darkBackground = Color(0xFF0F1419);
    const darkSurface = Color(0xFF1A1F2E);
    const darkText = Color(0xFFF9FAFB);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: primaryEmerald,
        onPrimary: surfaceColor,
        secondary: secondaryGold,
        onSecondary: darkBackground,
        surface: darkSurface,
        onSurface: darkText,
        error: errorRed,
        onError: surfaceColor,
      ),

      textTheme: _buildTextTheme(isDark: true),

      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      cardTheme: CardTheme(
        elevation: 0,
        color: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      ),
    );
  }

  // Static getters for easy access
  static TextTheme get textTheme => _buildTextTheme();
  static Color get primaryColor => primaryEmerald;

  /// Build text theme with Arabic font support
  static TextTheme _buildTextTheme({bool isDark = false}) {
    final textColor = isDark ? const Color(0xFFF9FAFB) : textPrimary;

    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: textColor,
      ),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w400, color: textColor),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w400, color: textColor),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600, color: textColor),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: textColor),
      headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0, color: textColor),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: textColor),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: textColor),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: textColor),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: textColor),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: textColor),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: textColor),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: textColor),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: textColor),
    );
  }

  /// Get Arabic-aware text style for specific content
  static TextStyle getArabicAwareStyle(String text, TextStyle baseStyle) {
    if (ArabicTypography.containsArabic(text)) {
      return ArabicTypography.getArabicGoogleFont(
        'readable',
        fontSize: baseStyle.fontSize ?? 16,
        fontWeight: baseStyle.fontWeight ?? FontWeight.normal,
        color: baseStyle.color,
        height: baseStyle.height,
      );
    }
    return baseStyle;
  }
}

// Professional Theme Extensions
extension ProfessionalThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Quick access to professional colors
  Color get primaryColor => ProfessionalTheme.primaryEmerald;
  Color get secondaryColor => ProfessionalTheme.secondaryGold;
  Color get surfaceColor => ProfessionalTheme.surfaceColor;
  Color get backgroundColor => ProfessionalTheme.backgroundColor;
  Color get textPrimary => ProfessionalTheme.textPrimary;
  Color get textSecondary => ProfessionalTheme.textSecondary;
  Color get textTertiary => ProfessionalTheme.textTertiary;

  // Shadow system
  List<BoxShadow> get subtleShadow => ProfessionalTheme.subtleShadow;
  List<BoxShadow> get cardShadow => ProfessionalTheme.cardShadow;
  List<BoxShadow> get elevatedShadow => ProfessionalTheme.elevatedShadow;
  List<BoxShadow> get focusShadow => ProfessionalTheme.focusShadow;
}
