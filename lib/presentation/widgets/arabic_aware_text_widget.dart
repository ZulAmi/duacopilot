import 'package:flutter/material.dart';

import '../../core/accessibility/arabic_accessibility.dart';
import '../../core/layout/rtl_layout_support.dart';
import '../../core/typography/arabic_typography.dart';

/// Arabic-aware text widget that automatically adjusts font and direction based on content
class ArabicAwareTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final bool enableAccessibility;
  final EdgeInsetsGeometry? padding;

  const ArabicAwareTextWidget(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textScaleFactor,
    this.enableAccessibility = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text direction and alignment automatically
    final textDirection = ArabicTypography.getTextDirection(text);
    final alignment = textAlign ?? ArabicTypography.getTextAlign(text, textDirection);

    // Use Arabic typography for Arabic content
    final effectiveStyle =
        ArabicTypography.containsArabic(text)
            ? ArabicTextStyles.bodyLarge(context, fontType: 'readable').merge(style)
            : style ?? Theme.of(context).textTheme.bodyLarge;

    Widget textWidget = Text(
      text,
      style: effectiveStyle,
      textAlign: alignment,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
    );

    // Apply RTL-aware container if needed
    if (padding != null) {
      textWidget = RTLAwareContainer(content: text, padding: padding as EdgeInsets?, child: textWidget);
    }

    // Apply accessibility features for Arabic content
    if (enableAccessibility && ArabicTypography.containsArabic(text)) {
      textWidget = ArabicAccessibility.createAccessibleText(context: context, text: text, style: effectiveStyle);
    }

    return textWidget;
  }
}

/// Arabic-aware search field that integrates all Arabic/RTL features
class ArabicAwareSearchField extends StatefulWidget {
  final String? hintText;
  final String? arabicHintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final bool enableKeyboard;
  final bool showTransliteration;

  const ArabicAwareSearchField({
    super.key,
    this.hintText,
    this.arabicHintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.enableKeyboard = true,
    this.showTransliteration = true,
  });

  @override
  State<ArabicAwareSearchField> createState() => _ArabicAwareSearchFieldState();
}

class _ArabicAwareSearchFieldState extends State<ArabicAwareSearchField> {
  late TextEditingController _controller;
  TextDirection _currentDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final newDirection = ArabicTypography.getTextDirection(_controller.text);
    if (newDirection != _currentDirection) {
      setState(() {
        _currentDirection = newDirection;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final hasArabic = ArabicTypography.containsArabic(_controller.text);
    final currentText = _controller.text;

    // Build hint text with both languages
    final effectiveHintText = widget.hintText ?? 'Search Islamic content';
    final fullHintText =
        widget.arabicHintText != null ? '$effectiveHintText | ${widget.arabicHintText}' : effectiveHintText;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: _controller,
        textDirection: _currentDirection,
        textAlign: hasArabic ? ArabicTypography.getTextAlign(currentText, _currentDirection) : TextAlign.start,
        onSubmitted: widget.onSubmitted,
        style: textTheme.bodyLarge?.merge(hasArabic ? ArabicTextStyles.bodyLarge(context, fontType: 'readable') : null),
        decoration: InputDecoration(
          hintText: fullHintText,
          hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: hasArabic ? Icon(Icons.translate, color: colorScheme.primary, size: 20) : null,
        ),
      ),
    );
  }
}

/// Extension to easily integrate Arabic awareness into existing widgets
extension ArabicAwareExtensions on Widget {
  /// Wrap any widget with Arabic/RTL awareness
  Widget withArabicSupport({required String content, EdgeInsetsGeometry? padding, bool enableAccessibility = true}) {
    return Builder(
      builder: (context) {
        Widget result = this;

        // Apply RTL-aware padding
        if (padding != null) {
          result = RTLAwareContainer(content: content, padding: padding as EdgeInsets?, child: result);
        }

        // Apply directionality based on content
        final direction = ArabicTypography.getTextDirection(content);
        result = Directionality(textDirection: direction, child: result);

        return result;
      },
    );
  }
}
