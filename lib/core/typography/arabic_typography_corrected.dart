import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comprehensive Arabic Typography and RTL Support System
///
/// This system provides enterprise-grade Arabic text rendering with:
/// - Platform-optimized Arabic fonts
/// - Proper RTL layout support
/// - Mixed text direction handling
/// - Accessibility features for Arabic content
/// - Custom text selection and copying
class ArabicTypography {
  /// Arabic Font Families by Platform
  static const Map<String, List<String>> platformFonts = {
    'ios': ['SF Arabic', '.SF Arabic', 'Arabic Typesetting', 'Geeza Pro'],
    'android': ['Noto Sans Arabic', 'Noto Naskh Arabic', 'Roboto'],
    'windows': ['Segoe UI Arabic', 'Tahoma', 'Arial Unicode MS'],
    'macos': ['.SF Arabic', 'Al Bayan', 'Baghdad', 'Geeza Pro'],
    'linux': ['Noto Sans Arabic', 'Liberation Sans', 'DejaVu Sans'],
    'web': ['Amiri', 'Noto Sans Arabic', 'Tahoma', 'Arial'],
  };

  /// Google Fonts Arabic Collections
  static const Map<String, String> arabicGoogleFonts = {
    'quran': 'Amiri Quran', // Specialized Quranic script
    'traditional': 'Amiri', // Traditional Arabic calligraphy
    'modern': 'Noto Sans Arabic', // Modern Arabic sans-serif
    'readable': 'Tajawal', // High readability
    'elegant': 'Scheherazade New', // Elegant script
    'compact': 'IBM Plex Sans Arabic', // Compact and clean
  };

  /// Font Features for Arabic Text Shaping
  static const List<FontFeature> arabicFontFeatures = [
    FontFeature.enable('liga'), // Enable ligatures
    FontFeature.enable('calt'), // Enable contextual alternates
    FontFeature.enable('kern'), // Enable kerning
    FontFeature.enable('mark'), // Enable mark positioning
    FontFeature.enable('mkmk'), // Enable mark-to-mark positioning
    FontFeature.enable('ccmp'), // Enable glyph composition/decomposition
    FontFeature.enable('locl'), // Enable localized forms
    FontFeature.enable('isol'), // Enable isolated forms
    FontFeature.enable('init'), // Enable initial forms
    FontFeature.enable('medi'), // Enable medial forms
    FontFeature.enable('fina'), // Enable final forms
    FontFeature.enable('rlig'), // Enable required ligatures
  ];

  /// Text Scale Factors for Different Arabic Font Styles
  static const Map<String, double> textScaleFactors = {
    'quran': 1.1, // Slightly larger for Quranic text
    'dua': 1.05, // Standard for Du'a text
    'hadith': 1.0, // Standard for Hadith
    'general': 1.0, // Standard for general Arabic text
    'ui': 0.95, // Slightly smaller for UI elements
  };

  /// Get platform-optimized Arabic font family
  static String getPlatformArabicFont() {
    final platform = Platform.operatingSystem;
    final fonts = platformFonts[platform] ?? platformFonts['web']!;
    return fonts.first;
  }

  /// Get Google Fonts Arabic TextStyle
  static TextStyle getArabicGoogleFont(
    String fontType, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
  }) {
    final fontName =
        arabicGoogleFonts[fontType] ?? arabicGoogleFonts['modern']!;
    final scaleFactor = textScaleFactors[fontType] ?? 1.0;

    try {
      switch (fontName) {
        case 'Amiri Quran':
          return GoogleFonts.amiriQuran(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.8, // Increased line height for Arabic
            letterSpacing: letterSpacing ?? 0.5,
            wordSpacing: wordSpacing ?? 1.0,
            fontFeatures: arabicFontFeatures,
          );
        case 'Amiri':
          return GoogleFonts.amiri(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.7,
            letterSpacing: letterSpacing ?? 0.3,
            wordSpacing: wordSpacing ?? 0.8,
            fontFeatures: arabicFontFeatures,
          );
        case 'Noto Sans Arabic':
          return GoogleFonts.notoSansArabic(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.6,
            letterSpacing: letterSpacing ?? 0.2,
            fontFeatures: arabicFontFeatures,
          );
        case 'Tajawal':
          return GoogleFonts.tajawal(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.6,
            letterSpacing: letterSpacing ?? 0.2,
            fontFeatures: arabicFontFeatures,
          );
        case 'Scheherazade New':
          return GoogleFonts.scheherazadeNew(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.9, // Higher line height for elegant script
            letterSpacing: letterSpacing ?? 0.8,
            wordSpacing: wordSpacing ?? 1.2,
            fontFeatures: arabicFontFeatures,
          );
        case 'IBM Plex Sans Arabic':
          return GoogleFonts.ibmPlexSansArabic(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.5,
            letterSpacing: letterSpacing ?? 0.1,
            fontFeatures: arabicFontFeatures,
          );
        default:
          return GoogleFonts.notoSansArabic(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
            height: height ?? 1.6,
            letterSpacing: letterSpacing ?? 0.2,
            fontFeatures: arabicFontFeatures,
          );
      }
    } catch (e) {
      // Fallback to system fonts if Google Fonts fail
      return TextStyle(
        fontFamily: getPlatformArabicFont(),
        fontSize: fontSize * scaleFactor,
        fontWeight: fontWeight,
        color: color,
        height: height ?? 1.7,
        letterSpacing: letterSpacing ?? 0.3,
        fontFeatures: arabicFontFeatures,
      );
    }
  }

  /// Check if text contains Arabic characters
  static bool containsArabic(String text) {
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(text);
  }

  /// Check if text contains Hebrew characters (for mixed RTL support)
  static bool containsHebrew(String text) {
    return RegExp(r'[\u0590-\u05FF]').hasMatch(text);
  }

  /// Check if text is primarily RTL
  static bool isRTL(String text) {
    return containsArabic(text) || containsHebrew(text);
  }

  /// Get optimal text direction for mixed content
  static TextDirection getTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;

    final arabicMatches =
        RegExp(
          r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
        ).allMatches(text).length;
    final hebrewMatches = RegExp(r'[\u0590-\u05FF]').allMatches(text).length;

    final rtlChars = arabicMatches + hebrewMatches;
    final total = text.length;

    // If more than 30% RTL characters, use RTL direction
    if (rtlChars > total * 0.3) {
      return TextDirection.rtl;
    }

    return TextDirection.ltr;
  }

  /// Get text alignment based on content and locale
  static TextAlign getTextAlign(String text, TextDirection? explicitDirection) {
    final direction = explicitDirection ?? getTextDirection(text);
    return direction == TextDirection.rtl ? TextAlign.right : TextAlign.left;
  }

  /// Format Arabic numbers to Arabic-Indic digits
  static String formatArabicNumbers(String text) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = text;

    for (int i = 0; i <= 9; i++) {
      result = result.replaceAll(i.toString(), arabicDigits[i]);
    }

    return result;
  }

  /// Normalize Arabic text for better search and display
  static String normalizeArabicText(String text) {
    return text
        // Normalize Alif variations
        .replaceAll(RegExp(r'[آأإٱ]'), 'ا')
        // Normalize Taa Marbouta and Haa
        .replaceAll('ة', 'ه')
        // Remove diacritics for search
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
        // Normalize Yaa variations
        .replaceAll('ي', 'ی')
        .replaceAll('ى', 'ی')
        // Remove extra spaces
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Extract Arabic words from mixed content
  static List<String> extractArabicWords(String text) {
    final arabicRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s]+',
    );
    final matches = arabicRegex.allMatches(text);
    return matches
        .map((match) => match.group(0)?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Get appropriate line height based on font type and size
  static double getLineHeight(String fontType, double fontSize) {
    final baseHeight =
        {
          'quran': 2.2,
          'traditional': 2.0,
          'elegant': 1.9,
          'readable': 1.7,
          'modern': 1.6,
          'compact': 1.5,
        }[fontType] ??
        1.7;

    // Adjust line height based on font size
    if (fontSize > 30) {
      return baseHeight * 0.9; // Tighter for large text
    } else if (fontSize < 12) {
      return baseHeight * 1.1; // Looser for small text
    }

    return baseHeight;
  }

  /// Get appropriate letter spacing for Arabic fonts
  static double getLetterSpacing(String fontType, double fontSize) {
    final baseSpacing =
        {
          'quran': 0.8,
          'traditional': 0.5,
          'elegant': 0.8,
          'readable': 0.3,
          'modern': 0.2,
          'compact': 0.1,
        }[fontType] ??
        0.3;

    // Scale spacing with font size
    return baseSpacing * (fontSize / 16.0);
  }

  /// Platform-specific font optimization
  static Map<String, dynamic> getPlatformFontConfig() {
    if (Platform.isIOS) {
      return {
        'renderingMode': 'subpixel',
        'hinting': 'full',
        'antialiasing': true,
        'fontSmoothingType': 'lcd',
      };
    } else if (Platform.isAndroid) {
      return {
        'renderingMode': 'grayscale',
        'hinting': 'slight',
        'antialiasing': true,
        'fontSmoothingType': 'standard',
      };
    } else if (Platform.isWindows) {
      return {
        'renderingMode': 'cleartype',
        'hinting': 'full',
        'antialiasing': true,
        'fontSmoothingType': 'cleartype',
      };
    }

    return {
      'renderingMode': 'auto',
      'hinting': 'auto',
      'antialiasing': true,
      'fontSmoothingType': 'auto',
    };
  }
}

/// Arabic Typography Scale with specialized styles for Islamic content
class ArabicTextStyles {
  // Display Styles - For large headings
  static TextStyle displayLarge(
    BuildContext context, {
    String fontType = 'traditional',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.12,
  );

  static TextStyle displayMedium(
    BuildContext context, {
    String fontType = 'traditional',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.16,
  );

  static TextStyle displaySmall(
    BuildContext context, {
    String fontType = 'traditional',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.22,
  );

  // Headline Styles - For section titles
  static TextStyle headlineLarge(
    BuildContext context, {
    String fontType = 'modern',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.25,
  );

  static TextStyle headlineMedium(
    BuildContext context, {
    String fontType = 'modern',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.29,
  );

  static TextStyle headlineSmall(
    BuildContext context, {
    String fontType = 'modern',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.33,
  );

  // Title Styles - For card titles and important text
  static TextStyle titleLarge(
    BuildContext context, {
    String fontType = 'readable',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.27,
  );

  static TextStyle titleMedium(
    BuildContext context, {
    String fontType = 'readable',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.50,
  );

  static TextStyle titleSmall(
    BuildContext context, {
    String fontType = 'readable',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.43,
  );

  // Label Styles - For buttons and form labels
  static TextStyle labelLarge(
    BuildContext context, {
    String fontType = 'compact',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.43,
  );

  static TextStyle labelMedium(
    BuildContext context, {
    String fontType = 'compact',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.33,
  );

  static TextStyle labelSmall(
    BuildContext context, {
    String fontType = 'compact',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.45,
  );

  // Body Styles - For content and reading text
  static TextStyle bodyLarge(
    BuildContext context, {
    String fontType = 'readable',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.75, // Increased for better Arabic reading
  );

  static TextStyle bodyMedium(
    BuildContext context, {
    String fontType = 'readable',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.71,
  );

  static TextStyle bodySmall(
    BuildContext context, {
    String fontType = 'readable',
  }) => ArabicTypography.getArabicGoogleFont(
    fontType,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.67,
  );

  // Specialized Islamic Content Styles
  static TextStyle quranVerse(BuildContext context) =>
      ArabicTypography.getArabicGoogleFont(
        'quran',
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
        height: 2.2, // Extra spacing for Quranic verses
        wordSpacing: 2.0,
      );

  static TextStyle duaText(BuildContext context) =>
      ArabicTypography.getArabicGoogleFont(
        'traditional',
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
        height: 2.0,
        wordSpacing: 1.5,
      );

  static TextStyle hadithText(BuildContext context) =>
      ArabicTypography.getArabicGoogleFont(
        'readable',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.8,
      );

  static TextStyle dhikrText(BuildContext context) =>
      ArabicTypography.getArabicGoogleFont(
        'elegant',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.9,
        letterSpacing: 0.8,
      );
}
