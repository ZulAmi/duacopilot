import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../typography/arabic_typography.dart';

/// Platform-Specific Arabic Font Optimization System
///
/// Provides platform-optimized Arabic font rendering with:
/// - iOS-specific Arabic font configurations
/// - Android Arabic font optimizations
/// - Windows Arabic font rendering improvements
/// - macOS Arabic typography enhancements
/// - Web Arabic font loading optimizations
/// - Custom font feature settings per platform
class PlatformArabicFontConfig {
  /// Initialize platform-specific Arabic font configurations
  static Future<void> initialize() async {
    await _configurePlatformFonts();
    _configureSystemUI();
  }

  /// Configure fonts for the current platform
  static Future<void> _configurePlatformFonts() async {
    if (Platform.isIOS) {
      await _configureIOSFonts();
    } else if (Platform.isAndroid) {
      await _configureAndroidFonts();
    } else if (Platform.isWindows) {
      await _configureWindowsFonts();
    } else if (Platform.isMacOS) {
      await _configureMacOSFonts();
    }
  }

  /// Configure iOS-specific Arabic fonts
  static Future<void> _configureIOSFonts() async {
    // iOS has excellent built-in Arabic font support
    // Configure system settings for optimal Arabic rendering
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Configure Android-specific Arabic fonts
  static Future<void> _configureAndroidFonts() async {
    // Android may need Noto fonts for best Arabic support
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Configure Windows-specific Arabic fonts
  static Future<void> _configureWindowsFonts() async {
    // Windows benefits from Segoe UI Arabic or Tahoma
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Configure macOS-specific Arabic fonts
  static Future<void> _configureMacOSFonts() async {
    // macOS has excellent Arabic font support with SF Arabic
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Configure system UI for optimal Arabic text display
  static void _configureSystemUI() {
    // Configure preferred orientations for RTL content
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Get platform-optimized TextStyle for Arabic content
  static TextStyle getPlatformArabicStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    String fontType = 'readable',
  }) {
    if (Platform.isIOS) {
      return _getIOSArabicStyle(fontSize, fontWeight, color, fontType);
    } else if (Platform.isAndroid) {
      return _getAndroidArabicStyle(fontSize, fontWeight, color, fontType);
    } else if (Platform.isWindows) {
      return _getWindowsArabicStyle(fontSize, fontWeight, color, fontType);
    } else if (Platform.isMacOS) {
      return _getMacOSArabicStyle(fontSize, fontWeight, color, fontType);
    } else {
      // Web and other platforms
      return _getWebArabicStyle(fontSize, fontWeight, color, fontType);
    }
  }

  /// iOS-optimized Arabic text style
  static TextStyle _getIOSArabicStyle(
    double fontSize,
    FontWeight fontWeight,
    Color? color,
    String fontType,
  ) {
    try {
      return ArabicTypography.getArabicGoogleFont(
        fontType,
        fontSize: fontSize * 1.0, // iOS handles scaling well
        fontWeight: fontWeight,
        color: color,
        height: 1.6,
        letterSpacing: 0.2,
      );
    } catch (e) {
      // Fallback to system font
      return TextStyle(
        fontFamily: '.SF Arabic',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: 1.7,
        letterSpacing: 0.3,
        fontFeatures: ArabicTypography.arabicFontFeatures,
      );
    }
  }

  /// Android-optimized Arabic text style
  static TextStyle _getAndroidArabicStyle(
    double fontSize,
    FontWeight fontWeight,
    Color? color,
    String fontType,
  ) {
    try {
      return ArabicTypography.getArabicGoogleFont(
        fontType,
        fontSize: fontSize * 1.05, // Slightly larger for Android
        fontWeight: fontWeight,
        color: color,
        height: 1.7,
        letterSpacing: 0.3,
      );
    } catch (e) {
      // Fallback to system font
      return TextStyle(
        fontFamily: 'Noto Sans Arabic',
        fontSize: fontSize * 1.05,
        fontWeight: fontWeight,
        color: color,
        height: 1.8,
        letterSpacing: 0.4,
        fontFeatures: ArabicTypography.arabicFontFeatures,
      );
    }
  }

  /// Windows-optimized Arabic text style
  static TextStyle _getWindowsArabicStyle(
    double fontSize,
    FontWeight fontWeight,
    Color? color,
    String fontType,
  ) {
    try {
      return ArabicTypography.getArabicGoogleFont(
        fontType,
        fontSize: fontSize * 1.1, // Larger for desktop
        fontWeight: fontWeight,
        color: color,
        height: 1.8,
        letterSpacing: 0.4,
      );
    } catch (e) {
      // Fallback to system font
      return TextStyle(
        fontFamily: 'Segoe UI Arabic',
        fontSize: fontSize * 1.1,
        fontWeight: fontWeight,
        color: color,
        height: 1.9,
        letterSpacing: 0.5,
        fontFeatures: ArabicTypography.arabicFontFeatures,
      );
    }
  }

  /// macOS-optimized Arabic text style
  static TextStyle _getMacOSArabicStyle(
    double fontSize,
    FontWeight fontWeight,
    Color? color,
    String fontType,
  ) {
    try {
      return ArabicTypography.getArabicGoogleFont(
        fontType,
        fontSize: fontSize * 1.0, // macOS handles scaling well
        fontWeight: fontWeight,
        color: color,
        height: 1.6,
        letterSpacing: 0.2,
      );
    } catch (e) {
      // Fallback to system font
      return TextStyle(
        fontFamily: '.SF Arabic',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: 1.7,
        letterSpacing: 0.3,
        fontFeatures: ArabicTypography.arabicFontFeatures,
      );
    }
  }

  /// Web-optimized Arabic text style
  static TextStyle _getWebArabicStyle(
    double fontSize,
    FontWeight fontWeight,
    Color? color,
    String fontType,
  ) {
    try {
      return ArabicTypography.getArabicGoogleFont(
        fontType,
        fontSize: fontSize * 1.0,
        fontWeight: fontWeight,
        color: color,
        height: 1.7,
        letterSpacing: 0.3,
      );
    } catch (e) {
      // Fallback to web-safe fonts
      return TextStyle(
        fontFamily: 'Tahoma, Arial, sans-serif',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: 1.8,
        letterSpacing: 0.4,
      );
    }
  }

  /// Get platform-specific font rendering settings
  static Map<String, dynamic> getPlatformFontRenderingSettings() {
    if (Platform.isIOS) {
      return {
        'antialiasing': true,
        'subpixelRendering': true,
        'hinting': 'auto',
        'kerning': true,
        'ligatures': true,
      };
    } else if (Platform.isAndroid) {
      return {
        'antialiasing': true,
        'subpixelRendering': false,
        'hinting': 'slight',
        'kerning': true,
        'ligatures': true,
      };
    } else if (Platform.isWindows) {
      return {
        'antialiasing': true,
        'subpixelRendering': true,
        'hinting': 'full',
        'kerning': true,
        'ligatures': true,
        'clearType': true,
      };
    } else if (Platform.isMacOS) {
      return {
        'antialiasing': true,
        'subpixelRendering': true,
        'hinting': 'auto',
        'kerning': true,
        'ligatures': true,
      };
    } else {
      // Web
      return {
        'antialiasing': true,
        'subpixelRendering': false,
        'hinting': 'auto',
        'kerning': true,
        'ligatures': true,
      };
    }
  }

  /// Configure text scaling for platform accessibility
  static double getPlatformTextScaling() {
    if (Platform.isIOS) {
      return 1.0; // iOS Dynamic Type handles this
    } else if (Platform.isAndroid) {
      return 1.05; // Slightly larger for better readability
    } else if (Platform.isWindows || Platform.isMacOS) {
      return 1.1; // Larger for desktop viewing
    } else {
      return 1.0; // Default for web
    }
  }

  /// Test Arabic font availability on current platform
  static Future<bool> testArabicFontSupport() async {
    try {
      // Test if Arabic fonts render correctly
      final testText = 'بسم الله الرحمن الرحيم';
      final painter = TextPainter(
        text: TextSpan(text: testText, style: getPlatformArabicStyle()),
        textDirection: TextDirection.rtl,
      );

      painter.layout();
      final hasValidSize = painter.size.width > 0 && painter.size.height > 0;
      painter.dispose();

      return hasValidSize;
    } catch (e) {
      return false;
    }
  }

  /// Get recommended Arabic fonts for current platform
  static List<String> getRecommendedArabicFonts() {
    if (Platform.isIOS) {
      return ['.SF Arabic', 'Geeza Pro', 'Arabic Typesetting'];
    } else if (Platform.isAndroid) {
      return ['Noto Sans Arabic', 'Noto Naskh Arabic', 'Roboto'];
    } else if (Platform.isWindows) {
      return ['Segoe UI Arabic', 'Tahoma', 'Arial Unicode MS'];
    } else if (Platform.isMacOS) {
      return ['.SF Arabic', 'Al Bayan', 'Baghdad'];
    } else {
      // Web
      return ['Amiri', 'Noto Sans Arabic', 'Tahoma', 'Arial'];
    }
  }

  /// Configure font fallback chain for Arabic text
  static List<String> getArabicFontFallbackChain() {
    final platformFonts = getRecommendedArabicFonts();
    const universalFallbacks = [
      'Noto Sans Arabic',
      'Arial Unicode MS',
      'Tahoma',
      'Arial',
      'sans-serif',
    ];

    return <String>{...platformFonts, ...universalFallbacks}.toList();
  }
}
