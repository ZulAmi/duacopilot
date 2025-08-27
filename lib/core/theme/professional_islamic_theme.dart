import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../typography/arabic_typography.dart';

/// Professional Islamic Theme - Clean Muslim Green & White Design
/// Traditional Islamic color palette with modern professional aesthetics
class ProfessionalIslamicTheme {
  // Primary Islamic Colors - Traditional Muslim Green & Pure White
  static const Color islamicGreen = Color(
    0xFF006633,
  ); // Traditional Islamic green
  static const Color islamicGreenLight = Color(
    0xFF00994D,
  ); // Light Islamic green
  static const Color islamicGreenDark = Color(0xFF004D26); // Dark Islamic green

  static const Color pureWhite = Color(0xFFFFFFFF); // Pure white
  static const Color creamWhite = Color(0xFFFAFAFA); // Soft cream white
  static const Color pearlWhite = Color(0xFFF8F9FA); // Pearl white

  // Secondary Accent Colors - Complementary Islamic Palette
  static const Color goldAccent = Color(0xFFB8860B); // Islamic gold
  static const Color silverGray = Color(0xFF6C757D); // Subtle silver gray
  static const Color deepNavy = Color(0xFF1B365D); // Deep navy for contrast

  // Professional Neutral Scale
  static const Color gray50 = Color(0xFFF8F9FA);
  static const Color gray100 = Color(0xFFE9ECEF);
  static const Color gray200 = Color(0xFFDEE2E6);
  static const Color gray300 = Color(0xFFCED4DA);
  static const Color gray400 = Color(0xFFADB5BD);
  static const Color gray500 = Color(0xFF6C757D);
  static const Color gray600 = Color(0xFF495057);
  static const Color gray700 = Color(0xFF343A40);
  static const Color gray800 = Color(0xFF212529);
  static const Color gray900 = Color(0xFF000000);

  // Semantic Colors - Professional Status System
  static const Color success = Color(0xFF28A745); // Professional green
  static const Color warning = Color(0xFFFFC107); // Professional amber
  static const Color error = Color(0xFFDC3545); // Professional red
  static const Color info = Color(0xFF17A2B8); // Professional cyan

  // Background System - Clean & Professional
  static const Color backgroundPrimary = pureWhite;
  static const Color backgroundSecondary = creamWhite;
  static const Color backgroundAccent = pearlWhite;
  static const Color backgroundIslamic = islamicGreen;

  // Text System - High Contrast & Readable
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textMuted = gray500;
  static const Color textOnIslamic = pureWhite;
  static const Color textOnWhite = gray900;

  // Border System - Subtle & Clean
  static const Color borderLight = gray200;
  static const Color borderMedium = gray300;
  static const Color borderStrong = gray400;
  static const Color borderIslamic = islamicGreenLight;

  // Islamic Gradients - Professional & Elegant
  static LinearGradient get islamicGradient => const LinearGradient(
        colors: [islamicGreen, islamicGreenLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get whiteGradient => const LinearGradient(
        colors: [pureWhite, creamWhite],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get goldAccentGradient => const LinearGradient(
        colors: [goldAccent, islamicGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Professional Spacing Scale - 8pt Grid System
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

  // Professional Border Radius
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radius2Xl = 16.0;
  static const double radius3Xl = 24.0;
  static const double radiusFull = 50.0;

  // Professional Shadow System
  static List<BoxShadow> get shadowSoft => [
        BoxShadow(
          color: gray900.withOpacity(0.08),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: gray900.withOpacity(0.12),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowStrong => [
        BoxShadow(
          color: gray900.withOpacity(0.16),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowIslamic => [
        BoxShadow(
          color: islamicGreen.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // Professional Typography Scale
  static const TextStyle display1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.025,
    height: 1.1,
    color: textPrimary,
  );

  static const TextStyle display2 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
    height: 1.2,
    color: textPrimary,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.015,
    height: 1.3,
    color: textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.015,
    height: 1.3,
    color: textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
    color: textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.025,
    height: 1.4,
    color: textMuted,
  );

  // Arabic-aware text style builders
  static TextStyle getArabicDisplay1(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.025,
      height: 1.3, // Increased for Arabic
      color: textPrimary,
    );
  }

  static TextStyle getArabicDisplay2(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.025,
      height: 1.4, // Increased for Arabic
      color: textPrimary,
    );
  }

  static TextStyle getArabicHeading1(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.015,
      height: 1.5, // Increased for Arabic
      color: textPrimary,
    );
  }

  static TextStyle getArabicHeading2(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.015,
      height: 1.5, // Increased for Arabic
      color: textPrimary,
    );
  }

  static TextStyle getArabicHeading3(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.01,
      height: 1.6, // Increased for Arabic
      color: textPrimary,
    );
  }

  static TextStyle getArabicBody1(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: 1.7, // Increased for Arabic
      color: textPrimary,
    );
  }

  static TextStyle getArabicBody2(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: 1.6, // Increased for Arabic
      color: textSecondary,
    );
  }

  static TextStyle getArabicCaption(BuildContext context) {
    return GoogleFonts.notoSansArabic(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.025,
      height: 1.5, // Increased for Arabic
      color: textMuted,
    );
  }

  // Smart text style that detects Arabic and uses appropriate font
  static TextStyle getSmartTextStyle(String text, TextStyle baseStyle, BuildContext context) {
    if (ArabicTypography.containsArabic(text)) {
      // Use Arabic font for text containing Arabic characters
      return GoogleFonts.notoSansArabic(
        fontSize: baseStyle.fontSize,
        fontWeight: baseStyle.fontWeight,
        letterSpacing: baseStyle.letterSpacing,
        height: (baseStyle.height ?? 1.0) * 1.2, // Increase line height for Arabic
        color: baseStyle.color,
      );
    }
    return baseStyle; // Use original style for non-Arabic text
  }

  // Animation Durations - Professional & Responsive
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  // Professional Islamic Theme Data with Arabic Support
  static ThemeData get professionalIslamicTheme => ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.notoSansArabic().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: islamicGreen,
          brightness: Brightness.light,
          primary: islamicGreen,
          onPrimary: pureWhite,
          secondary: goldAccent,
          onSecondary: pureWhite,
          surface: backgroundPrimary,
          onSurface: textPrimary,
          error: error,
          onError: pureWhite,
        ),

        // Typography with Arabic support
        textTheme: TextTheme(
          displayLarge: GoogleFonts.notoSansArabic(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            height: 1.3,
            color: textPrimary,
          ),
          displayMedium: GoogleFonts.notoSansArabic(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            height: 1.3,
            color: textPrimary,
          ),
          displaySmall: GoogleFonts.notoSansArabic(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: textPrimary,
          ),
          headlineLarge: GoogleFonts.notoSansArabic(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.notoSansArabic(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: textPrimary,
          ),
          headlineSmall: GoogleFonts.notoSansArabic(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: textPrimary,
          ),
          titleLarge: GoogleFonts.notoSansArabic(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.notoSansArabic(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.6,
            color: textPrimary,
          ),
          titleSmall: GoogleFonts.notoSansArabic(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.6,
            color: textSecondary,
          ),
          bodyLarge: GoogleFonts.notoSansArabic(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.7,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.notoSansArabic(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: textPrimary,
          ),
          bodySmall: GoogleFonts.notoSansArabic(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: textSecondary,
          ),
          labelLarge: GoogleFonts.notoSansArabic(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: textPrimary,
          ),
          labelMedium: GoogleFonts.notoSansArabic(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: textSecondary,
          ),
          labelSmall: GoogleFonts.notoSansArabic(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: textMuted,
          ),
        ),

        // AppBar Theme - Professional Islamic Style
        appBarTheme: AppBarTheme(
          backgroundColor: islamicGreen,
          foregroundColor: pureWhite,
          elevation: 2,
          shadowColor: gray900.withOpacity(0.1),
          centerTitle: true,
          titleTextStyle: heading2.copyWith(color: pureWhite),
          toolbarHeight: 64,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(radiusLg)),
          ),
        ),

        // Card Theme - Clean Professional Cards
        cardTheme: CardTheme(
          color: backgroundPrimary,
          shadowColor: gray900.withOpacity(0.08),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
          margin: const EdgeInsets.all(space2),
        ),

        // Button Themes - Islamic Green Primary
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: islamicGreen,
            foregroundColor: pureWhite,
            elevation: 4,
            shadowColor: islamicGreen.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: space6,
              vertical: space4,
            ),
            textStyle: body1.copyWith(fontWeight: FontWeight.w600),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: islamicGreen,
            side: const BorderSide(color: islamicGreen, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: space6,
              vertical: space4,
            ),
            textStyle: body1.copyWith(fontWeight: FontWeight.w600),
          ),
        ),

        // Input Decoration - Clean & Professional
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: backgroundSecondary,
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
            borderSide: const BorderSide(color: islamicGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusLg),
            borderSide: const BorderSide(color: error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: space4,
            vertical: space4,
          ),
          hintStyle: body1.copyWith(color: textMuted),
          labelStyle: body2.copyWith(color: textSecondary),
        ),

        // Icon Theme - Consistent Islamic Colors
        iconTheme: const IconThemeData(color: islamicGreen, size: 24),

        primaryIconTheme: const IconThemeData(color: pureWhite, size: 24),

        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: borderLight,
          thickness: 1,
          space: space4,
        ),

        // Chip Theme - Professional Styling
        chipTheme: ChipThemeData(
          backgroundColor: backgroundAccent,
          selectedColor: islamicGreen,
          labelStyle: body2,
          padding: const EdgeInsets.symmetric(horizontal: space3, vertical: space1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundPrimary,
          selectedItemColor: islamicGreen,
          unselectedItemColor: textMuted,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: caption.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: caption,
        ),
      );
}
