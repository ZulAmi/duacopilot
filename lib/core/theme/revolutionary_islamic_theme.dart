import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Revolutionary Islamic Theme - Next-Gen Professional Design
/// Sophisticated color scheme with modern accessibility standards
class RevolutionaryIslamicTheme {
  // Primary Colors - Sophisticated Emerald & Ocean Blue
  static const Color primaryEmerald = Color(0xFF059669); // Rich emerald green
  static const Color primaryEmeraldLight = Color(0xFF10B981); // Light emerald
  static const Color primaryEmeraldDark = Color(0xFF047857); // Dark emerald

  static const Color secondaryNavy = Color(0xFF1E40AF); // Deep navy blue
  static const Color secondaryNavyLight = Color(0xFF3B82F6); // Light navy
  static const Color accentPurple = Color(0xFF7C3AED); // Royal purple

  // Neutral Colors - Premium Grayscale
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralGray50 = Color(0xFFFAFAFA);
  static const Color neutralGray100 = Color(0xFFF4F4F5);
  static const Color neutralGray200 = Color(0xFFE4E4E7);
  static const Color neutralGray300 = Color(0xFFD4D4D8);
  static const Color neutralGray400 = Color(0xFFA1A1AA);
  static const Color neutralGray500 = Color(0xFF71717A);
  static const Color neutralGray600 = Color(0xFF52525B);
  static const Color neutralGray700 = Color(0xFF3F3F46);
  static const Color neutralGray800 = Color(0xFF27272A);
  static const Color neutralGray900 = Color(0xFF18181B);

  // Semantic Colors - Modern Status Indicators
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRose = Color(0xFFEF4444);
  static const Color infoSky = Color(0xFF0EA5E9);

  // Background System
  static const Color backgroundPrimary = neutralGray50;
  static const Color backgroundSecondary = neutralWhite;
  static const Color backgroundTertiary = neutralGray100;

  // Text System
  static const Color textPrimary = neutralGray900;
  static const Color textSecondary = neutralGray600;
  static const Color textTertiary = neutralGray400;
  static const Color textOnColor = neutralWhite;

  // Border System
  static const Color borderLight = neutralGray200;
  static const Color borderMedium = neutralGray300;
  static const Color borderStrong = neutralGray400;

  // Modern Gradients
  static LinearGradient get heroGradient => const LinearGradient(
        colors: [primaryEmerald, secondaryNavy],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get cardGradient => LinearGradient(
        colors: [neutralWhite, neutralGray50],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get accentGradient => const LinearGradient(
        colors: [accentPurple, primaryEmeraldLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Spacing Scale - Perfect 8pt Grid
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;

  // Border Radius Scale
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radius2Xl = 16.0;
  static const double radius3Xl = 24.0;
  static const double radiusFull = 9999.0;

  // Professional Shadow System
  static List<BoxShadow> get shadowXs => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.05),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: neutralGray900.withOpacity(0.1),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: neutralGray900.withOpacity(0.06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: neutralGray900.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.1),
          blurRadius: 25,
          offset: const Offset(0, 20),
        ),
        BoxShadow(
          color: neutralGray900.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 8),
        ),
      ];

  // Typography System - Modern & Accessible
  static const String fontFamily = 'Inter'; // Using Inter font for modern look

  static const TextStyle display1 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.1,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle display2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.25,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
    color: textSecondary,
    fontFamily: fontFamily,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: textSecondary,
    fontFamily: fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.3,
    color: textTertiary,
    fontFamily: fontFamily,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1,
    color: textOnColor,
    fontFamily: fontFamily,
  );

  // Animation Timings
  static const Duration animationQuick = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationExtraSlow = Duration(milliseconds: 800);

  // Complete Theme Configuration
  static ThemeData get revolutionaryTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryEmerald,
        brightness: Brightness.light,
        primary: primaryEmerald,
        secondary: secondaryNavy,
        tertiary: accentPurple,
        surface: backgroundSecondary,
        error: errorRose,
        onPrimary: textOnColor,
        onSecondary: textOnColor,
        onSurface: textPrimary,
        onError: textOnColor,
      ),

      scaffoldBackgroundColor: backgroundPrimary,

      // App Bar Theme - Clean & Modern
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundSecondary,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headline3,
        toolbarHeight: 72,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: backgroundSecondary,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
        actionsIconTheme: const IconThemeData(color: textSecondary, size: 24),
        shape: const Border(bottom: BorderSide(color: borderLight, width: 1)),
      ),

      // Card Theme - Elevated & Modern
      cardTheme: CardTheme(
        color: backgroundSecondary,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius2Xl),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: textOnColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
          textStyle: button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryEmerald,
          padding: const EdgeInsets.symmetric(
            horizontal: space4,
            vertical: space3,
          ),
          minimumSize: const Size(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: button.copyWith(color: primaryEmerald),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderMedium, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: space6,
            vertical: space4,
          ),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
          textStyle: button.copyWith(color: textPrimary),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius2Xl),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius2Xl),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius2Xl),
          borderSide: const BorderSide(color: primaryEmerald, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius2Xl),
          borderSide: const BorderSide(color: errorRose),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: space4,
          vertical: space4,
        ),
        hintStyle: body2.copyWith(color: textTertiary),
        labelStyle: body2.copyWith(color: textSecondary),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondary, size: 24),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: backgroundTertiary,
        selectedColor: primaryEmerald.withOpacity(0.1),
        labelStyle: caption.copyWith(color: textPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: space3,
          vertical: space1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
          side: const BorderSide(color: borderLight),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: space4,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundSecondary,
        selectedItemColor: primaryEmerald,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: display1,
        displayMedium: display2,
        headlineLarge: headline1,
        headlineMedium: headline2,
        headlineSmall: headline3,
        titleLarge: subtitle1,
        titleMedium: subtitle2,
        bodyLarge: body1,
        bodyMedium: body2,
        bodySmall: caption,
        labelLarge: button,
      ),
    );
  }
}
