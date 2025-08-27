import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../typography/arabic_typography.dart';

/// Arabic Accessibility Support System
///
/// Provides comprehensive accessibility features for Arabic content:
/// - Screen reader optimization for Arabic text
/// - Voice control enhancements
/// - High contrast mode support
/// - Text scaling optimization
/// - Semantic markup for Islamic content
/// - Platform-specific accessibility features
class ArabicAccessibility {
  /// Configure system accessibility for Arabic content
  static void configureSystemAccessibility() {
    // Enable semantic labels
    SemanticsBinding.instance.ensureSemantics();

    // Configure platform-specific accessibility
    _configurePlatformAccessibility();
  }

  static void _configurePlatformAccessibility() {
    // Configure system UI for better accessibility
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Create accessible Arabic text widget with proper semantics
  static Widget createAccessibleText({
    required String text,
    required BuildContext context,
    TextStyle? style,
    String? semanticLabel,
    bool isHeading = false,
    bool isButton = false,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    final textDirection = ArabicTypography.getTextDirection(text);
    final isArabic = ArabicTypography.containsArabic(text);

    // Create appropriate text style for Arabic content
    final effectiveStyle = isArabic
        ? ArabicTextStyles.bodyLarge(context, fontType: 'readable')
        : style;

    Widget textWidget = Text(
      text,
      style: effectiveStyle,
      textDirection: textDirection,
      textAlign: ArabicTypography.getTextAlign(text, textDirection),
    );

    // Add tooltip if provided
    if (tooltip != null) {
      textWidget = Tooltip(message: tooltip, child: textWidget);
    }

    // Add gesture detection if needed
    if (onTap != null) {
      textWidget = GestureDetector(onTap: onTap, child: textWidget);
    }

    // Wrap with semantics
    return Semantics(
      label: semanticLabel ?? text,
      textDirection: textDirection,
      header: isHeading,
      button: isButton,
      child: Directionality(textDirection: textDirection, child: textWidget),
    );
  }

  /// Create accessible Islamic content with specialized semantics
  static Widget createIslamicContentWidget({
    required String arabicText,
    String? transliteration,
    String? translation,
    required BuildContext context,
    IslamicContentType contentType = IslamicContentType.general,
    VoidCallback? onTap,
  }) {
    final semanticLabel = _createIslamicSemanticLabel(
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      contentType: contentType,
    );

    return Semantics(
      label: semanticLabel,
      textDirection: TextDirection.rtl,
      readOnly: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Arabic text
              Text(
                arabicText,
                style: _getStyleForContentType(context, contentType),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),

              // Transliteration (if provided)
              if (transliteration != null) ...[
                const SizedBox(height: 8),
                Text(
                  transliteration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.left,
                ),
              ],

              // Translation (if provided)
              if (translation != null) ...[
                const SizedBox(height: 8),
                Text(
                  translation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.left,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Create accessible form field for Arabic input
  static Widget createAccessibleFormField({
    required String labelText,
    String? hintText,
    String? errorText,
    String? helperText,
    required BuildContext context,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    final accessibleLabel = isRequired ? '$labelText (Ù…Ø·Ù„ÙˆØ¨)' : labelText;

    return Semantics(
      label: accessibleLabel,
      textField: true,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: ArabicTextStyles.bodyLarge(context, fontType: 'readable'),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          helperText: helperText,
          border: const OutlineInputBorder(),
          semanticCounterText: '',
          suffixIcon: isRequired
              ? const Icon(Icons.star, size: 8, color: Colors.red)
              : null,
        ),
      ),
    );
  }

  /// Create accessible navigation element for Arabic content
  static Widget createAccessibleNavigation({
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
    IconData? icon,
    String? tooltip,
    bool isActive = false,
  }) {
    final textDirection = ArabicTypography.getTextDirection(label);

    return Semantics(
      label: label,
      button: true,
      selected: isActive,
      hint: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Tooltip(
          message: tooltip ?? label,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Directionality(
              textDirection: textDirection,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textDirection: textDirection,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// High contrast theme for better accessibility
  static ThemeData createHighContrastTheme(BuildContext context) {
    final baseTheme = Theme.of(context);

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: Colors.black,
        onSurface: Colors.white,
        primary: Colors.yellow,
        onPrimary: Colors.black,
        secondary: Colors.cyan,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  static String _createIslamicSemanticLabel({
    required String arabicText,
    String? transliteration,
    String? translation,
    required IslamicContentType contentType,
  }) {
    final buffer = StringBuffer();

    // Add content type prefix
    switch (contentType) {
      case IslamicContentType.quranVerse:
        buffer.write('Quran verse: ');
        break;
      case IslamicContentType.dua:
        buffer.write('Islamic supplication: ');
        break;
      case IslamicContentType.dhikr:
        buffer.write('Dhikr remembrance: ');
        break;
      case IslamicContentType.hadith:
        buffer.write('Prophetic saying: ');
        break;
      case IslamicContentType.general:
        buffer.write('Islamic text: ');
        break;
    }

    // Add Arabic text
    buffer.write('In Arabic: $arabicText');

    // Add transliteration if available
    if (transliteration != null) {
      buffer.write(', Transliteration: $transliteration');
    }

    // Add translation if available
    if (translation != null) {
      buffer.write(', Translation: $translation');
    }

    return buffer.toString();
  }

  static TextStyle _getStyleForContentType(
    BuildContext context,
    IslamicContentType contentType,
  ) {
    switch (contentType) {
      case IslamicContentType.quranVerse:
        return ArabicTextStyles.quranVerse(context);
      case IslamicContentType.dua:
        return ArabicTextStyles.duaText(context);
      case IslamicContentType.dhikr:
        return ArabicTextStyles.dhikrText(context);
      case IslamicContentType.hadith:
        return ArabicTextStyles.hadithText(context);
      case IslamicContentType.general:
        return ArabicTextStyles.bodyLarge(context, fontType: 'readable');
    }
  }
}

/// Types of Islamic content for specialized accessibility handling
enum IslamicContentType { quranVerse, dua, dhikr, hadith, general }

/// Accessible Arabic List Tile
class AccessibleArabicListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? transliteration;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isThreeLine;
  final IslamicContentType contentType;

  const AccessibleArabicListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.transliteration,
    this.leading,
    this.trailing,
    this.onTap,
    this.isThreeLine = false,
    this.contentType = IslamicContentType.general,
  });

  @override
  Widget build(BuildContext context) {
    final titleDirection = ArabicTypography.getTextDirection(title);
    final subtitleDirection = subtitle != null
        ? ArabicTypography.getTextDirection(subtitle!)
        : TextDirection.ltr;

    final semanticLabel = StringBuffer();
    semanticLabel.write(title);
    if (subtitle != null) {
      semanticLabel.write(', $subtitle');
    }
    if (transliteration != null) {
      semanticLabel.write(', Pronunciation: $transliteration');
    }

    return Semantics(
      label: semanticLabel.toString(),
      button: onTap != null,
      child: ListTile(
        leading: leading,
        title: Directionality(
          textDirection: titleDirection,
          child: Text(
            title,
            style: ArabicAccessibility._getStyleForContentType(
              context,
              contentType,
            ),
            textDirection: titleDirection,
            textAlign: ArabicTypography.getTextAlign(title, titleDirection),
          ),
        ),
        subtitle: subtitle != null || transliteration != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitle != null)
                    Directionality(
                      textDirection: subtitleDirection,
                      child: Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textDirection: subtitleDirection,
                        textAlign: ArabicTypography.getTextAlign(
                          subtitle!,
                          subtitleDirection,
                        ),
                      ),
                    ),
                  if (transliteration != null) ...[
                    if (subtitle != null) const SizedBox(height: 4),
                    Text(
                      transliteration!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              )
            : null,
        trailing: trailing,
        isThreeLine: isThreeLine,
        onTap: onTap,
      ),
    );
  }
}

/// Screen Reader Optimized Text Widget
class ScreenReaderOptimizedText extends StatelessWidget {
  final String text;
  final String? alternativeText;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isLive;

  const ScreenReaderOptimizedText({
    super.key,
    required this.text,
    this.alternativeText,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = ArabicTypography.getTextDirection(text);
    final effectiveStyle = ArabicTypography.containsArabic(text)
        ? ArabicTextStyles.bodyLarge(context, fontType: 'readable')
        : style;

    return Semantics(
      label: alternativeText ?? text,
      textDirection: textDirection,
      liveRegion: isLive,
      child: Directionality(
        textDirection: textDirection,
        child: Text(
          text,
          style: effectiveStyle,
          textAlign:
              textAlign ?? ArabicTypography.getTextAlign(text, textDirection),
          textDirection: textDirection,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}

/// Voice Control Enhanced Button for Arabic interfaces
class VoiceControlArabicButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;
  final String? voiceCommand;
  final String? tooltip;

  const VoiceControlArabicButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.style,
    this.voiceCommand,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = ArabicTypography.getTextDirection(label);
    final semanticHint =
        voiceCommand != null ? 'Voice command: $voiceCommand' : null;

    Widget button = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label, textDirection: textDirection),
            style: style,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: Text(label, textDirection: textDirection),
          );

    button = Semantics(
      label: label,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      child: button,
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return Directionality(textDirection: textDirection, child: button);
  }
}
