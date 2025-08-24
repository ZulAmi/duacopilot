import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced Professional Islamic Theme System with Enterprise-Grade Design
/// Optimized for both web and desktop platforms
class EnhancedProfessionalTheme {
  // Enhanced Professional Color Palette - Corporate Islamic Design
  static const Color primaryDeepGreen = Color(0xFF0D4A2B); // Deeper Islamic green for professionalism
  static const Color primaryEmerald = Color(0xFF0F5132); // Rich Islamic green
  static const Color secondaryNavyBlue = Color(0xFF1E3A8A); // Professional navy blue
  static const Color secondaryGold = Color(0xFFB8860B); // Elegant gold accent
  static const Color accentBronze = Color(0xFF8B4513); // Sophisticated bronze

  // Professional Backgrounds
  static const Color backgroundColor = Color(0xFFF8FAFC); // Ultra clean background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure surface
  static const Color cardBackground = Color(0xFFFEFEFE); // Subtle card background
  static const Color elevatedSurface = Color(0xFFF5F7FA); // Elevated surface

  // Enhanced Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // High contrast primary text
  static const Color textSecondary = Color(0xFF475569); // Professional secondary text
  static const Color textTertiary = Color(0xFF64748B); // Subtle tertiary text
  static const Color textMuted = Color(0xFF94A3B8); // Muted text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Text on primary colors

  // Professional Border System
  static const Color borderLight = Color(0xFFE2E8F0); // Light borders
  static const Color borderMedium = Color(0xFFCBD5E1); // Medium borders
  static const Color borderStrong = Color(0xFF94A3B8); // Strong borders

  // Enhanced State Colors
  static const Color successGreen = Color(0xFF059669); // Professional success
  static const Color warningAmber = Color(0xFFD97706); // Professional warning
  static const Color errorRed = Color(0xFFDC2626); // Professional error
  static const Color infoBlue = Color(0xFF2563EB); // Professional info

  // Enhanced Neutral System
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // Enhanced Professional Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeepGreen, primaryEmerald],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryNavyBlue, Color(0xFF3B82F6)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryGold, Color(0xFFD4AF37)],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceColor, gray50],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [cardBackground, gray50],
  );

  // Enhanced Animation System
  static const Duration quickDuration = Duration(milliseconds: 150);
  static const Duration standardDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Enhanced Animation Curves
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve emphasizedCurve = Curves.easeOutCubic;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve professionalCurve = Curves.easeInOutQuart;

  // Enhanced Spacing System
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2Xl = 48.0;
  static const double space3Xl = 64.0;
  static const double space4Xl = 96.0;

  // Enhanced Border Radius System
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2Xl = 24.0;
  static const double radius3Xl = 32.0;

  // Enhanced Shadow System
  static List<BoxShadow> get microShadow => [
    BoxShadow(color: gray900.withOpacity(0.03), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(color: gray900.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: gray900.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(color: gray900.withOpacity(0.10), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> get dramaticShadow => [
    BoxShadow(color: gray900.withOpacity(0.15), blurRadius: 32, offset: const Offset(0, 16)),
  ];

  // Additional colors needed for main_dev.dart compatibility
  static const Color shadowColor = Color(0x1A000000);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Typography Scale - Professional Islamic App
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    letterSpacing: 0.4,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // Enhanced Component Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryEmerald,
    foregroundColor: textOnPrimary,
    elevation: 2,
    shadowColor: primaryEmerald.withOpacity(0.3),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: secondaryNavyBlue,
    foregroundColor: textOnPrimary,
    elevation: 2,
    shadowColor: secondaryNavyBlue.withOpacity(0.3),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
  );

  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryEmerald,
    side: const BorderSide(color: borderMedium),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
  );

  // System UI Overlay Styles
  static const SystemUiOverlayStyle lightSystemUI = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: surfaceColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle darkSystemUI = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: primaryDeepGreen,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  // Helper Methods
  static ThemeData buildThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryEmerald,
        brightness: Brightness.light,
        primary: primaryEmerald,
        secondary: secondaryNavyBlue,
        tertiary: secondaryGold,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorRed,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textOnPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: lightSystemUI,
        titleTextStyle: headlineMedium,
        iconTheme: const IconThemeData(color: textSecondary),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 2,
        shadowColor: gray900.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: primaryEmerald, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceMd),
      ),
    );
  }
}
