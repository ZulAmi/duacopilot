import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ultra-Modern Islamic Theme System with Glassmorphism & Modern Design Patterns
class UltraModernTheme {
  // Enhanced Color Palette
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color deepEmerald = Color(0xFF0D4F3C);
  static const Color pureWhite = Color(0xFFFFFFFE);
  static const Color charcoalBlack = Color(0xFF1A1A1A);
  static const Color softGray = Color(0xFFF8F9FA);
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color warmSand = Color(0xFFF5E6D3);
  static const Color crimsonRed = Color(0xFFDC143C);

  // Gradient Collections
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D4F3C), Color(0xFF1A6B47), Color(0xFF2E8B57)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFB8860B)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF41A3B3), Color(0xFF5BC0BE)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFE6B17A)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient glassMorphism = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40FFFFFF), Color(0x20FFFFFF), Color(0x10FFFFFF)],
  );

  static const LinearGradient darkGlassMorphism = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40000000), Color(0x20000000), Color(0x10000000)],
  );

  // Animation Durations
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve primaryCurve = Curves.easeInOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFBFDFF), Color(0xFFF5F8FA)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FFFE)],
    stops: [0.0, 1.0],
  );

  // Shadow System
  static List<BoxShadow> get softShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(color: deepEmerald.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(color: primaryGold.withOpacity(0.3), blurRadius: 24, spreadRadius: -4, offset: const Offset(0, 0)),
  ];

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(deepEmerald),

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: deepEmerald,
        onPrimary: pureWhite,
        secondary: primaryGold,
        onSecondary: charcoalBlack,
        tertiary: accentBlue,
        surface: pureWhite,
        onSurface: charcoalBlack,
        error: crimsonRed,
        onError: pureWhite,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: deepEmerald,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: deepEmerald, letterSpacing: -0.5),
      ),

      // Card Theme with Glassmorphism
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: deepEmerald.withOpacity(0.1), width: 1.5),
        ),
        color: pureWhite.withOpacity(0.95),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: deepEmerald,
          foregroundColor: pureWhite,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          foregroundColor: deepEmerald,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhite.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: deepEmerald.withOpacity(0.2), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: deepEmerald.withOpacity(0.2), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: deepEmerald, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: crimsonRed, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: charcoalBlack.withOpacity(0.6), fontSize: 16),
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w800,
          color: deepEmerald,
          letterSpacing: -1.0,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: deepEmerald,
          letterSpacing: -0.75,
          height: 1.15,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: deepEmerald,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: deepEmerald,
          letterSpacing: -0.5,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: deepEmerald,
          letterSpacing: -0.25,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: deepEmerald,
          letterSpacing: 0,
          height: 1.35,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: deepEmerald,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
          letterSpacing: 0.1,
          height: 1.43,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: deepEmerald, size: 24),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: primaryGold,
        foregroundColor: charcoalBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(color: deepEmerald.withOpacity(0.1), thickness: 1, space: 24),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(primaryGold),

      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        onPrimary: charcoalBlack,
        secondary: deepEmerald,
        onSecondary: pureWhite,
        tertiary: accentBlue,
        surface: Color(0xFF1E1E1E),
        onSurface: pureWhite,
        error: crimsonRed,
        onError: pureWhite,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGold,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primaryGold, letterSpacing: -0.5),
      ),

      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: primaryGold.withOpacity(0.2), width: 1.5),
        ),
        color: const Color(0xFF2A2A2A).withOpacity(0.95),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: primaryGold,
          foregroundColor: charcoalBlack,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A).withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryGold.withOpacity(0.3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryGold.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryGold, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: pureWhite.withOpacity(0.6), fontSize: 16),
      ),

      iconTheme: const IconThemeData(color: primaryGold, size: 24),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: primaryGold,
        foregroundColor: charcoalBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
    );
  }

  // Helper method to create MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

/// Custom decorations for glassmorphism effects
class GlassmorphicDecoration {
  static BoxDecoration light({double borderRadius = 24, double blur = 20, double opacity = 0.2}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.white.withOpacity(opacity),
      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: blur, offset: const Offset(0, 8))],
    );
  }

  static BoxDecoration dark({double borderRadius = 24, double blur = 20, double opacity = 0.2}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.black.withOpacity(opacity),
      border: Border.all(color: UltraModernTheme.primaryGold.withOpacity(0.3), width: 1.5),
      boxShadow: [
        BoxShadow(color: UltraModernTheme.primaryGold.withOpacity(0.1), blurRadius: blur, offset: const Offset(0, 8)),
      ],
    );
  }
}

/// Extension for easy access to theme properties
extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  LinearGradient get primaryGradient => UltraModernTheme.primaryGradient;
  LinearGradient get secondaryGradient => UltraModernTheme.secondaryGradient;
  LinearGradient get accentGradient => UltraModernTheme.accentGradient;
  LinearGradient get goldGradient => UltraModernTheme.goldGradient;
  LinearGradient get surfaceGradient => UltraModernTheme.surfaceGradient;
  LinearGradient get cardGradient => UltraModernTheme.cardGradient;

  // Shadow system
  List<BoxShadow> get softShadow => UltraModernTheme.softShadow;
  List<BoxShadow> get elevatedShadow => UltraModernTheme.elevatedShadow;
  List<BoxShadow> get glowShadow => UltraModernTheme.glowShadow;
}
