import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../typography/arabic_typography.dart';

/// Universal Arabic Text Widget
/// Automatically detects Arabic content and applies appropriate styling
class ArabicAwareText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? textScaleFactor;

  const ArabicAwareText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    final bool containsArabic = ArabicTypography.containsArabic(text);

    // Determine text direction
    final TextDirection effectiveDirection = textDirection ?? (containsArabic ? TextDirection.rtl : TextDirection.ltr);

    // Determine text alignment
    final TextAlign effectiveAlign = textAlign ?? (containsArabic ? TextAlign.right : TextAlign.start);

    // Create appropriate text style
    final TextStyle effectiveStyle =
        containsArabic ? _getArabicStyle(context, style) : (style ?? Theme.of(context).textTheme.bodyMedium!);

    return Directionality(
      textDirection: effectiveDirection,
      child: Text(
        text,
        style: effectiveStyle,
        textAlign: effectiveAlign,
        maxLines: maxLines,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
      ),
    );
  }

  TextStyle _getArabicStyle(BuildContext context, TextStyle? baseStyle) {
    final defaultStyle = baseStyle ?? Theme.of(context).textTheme.bodyMedium!;

    return GoogleFonts.notoSansArabic(
      fontSize: defaultStyle.fontSize,
      fontWeight: defaultStyle.fontWeight,
      color: defaultStyle.color,
      height: (defaultStyle.height ?? 1.0) * 1.3, // Increase line height for Arabic
      letterSpacing: defaultStyle.letterSpacing,
      wordSpacing: defaultStyle.wordSpacing,
      decoration: defaultStyle.decoration,
      decorationColor: defaultStyle.decorationColor,
      decorationStyle: defaultStyle.decorationStyle,
      decorationThickness: defaultStyle.decorationThickness,
      fontFeatures: ArabicTypography.arabicFontFeatures,
    );
  }
}

/// Extension to make any Widget Arabic-aware
extension ArabicAwareWidgetExtension on Widget {
  Widget arabicAware() {
    return this;
  }
}

/// Extension to create Arabic-aware text styles
extension ArabicAwareTextStyleExtension on TextStyle {
  TextStyle arabicAware(String text, BuildContext context) {
    if (ArabicTypography.containsArabic(text)) {
      return GoogleFonts.notoSansArabic(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: (height ?? 1.0) * 1.3,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        fontFeatures: ArabicTypography.arabicFontFeatures,
      );
    }
    return this;
  }
}
