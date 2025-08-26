import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../typography/arabic_typography.dart';

/// RTL Layout Support System for Arabic and Mixed Content
///
/// Provides comprehensive RTL layout support including:
/// - Automatic layout direction detection
/// - Mixed text direction handling
/// - RTL-aware widget positioning
/// - Platform-specific RTL optimizations
/// - Accessibility support for screen readers
class RTLLayoutSupport {
  /// Check if the current locale should use RTL layout
  static bool shouldUseRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return ['ar', 'fa', 'he', 'ur', 'ps', 'sd'].contains(locale.languageCode);
  }

  /// Get the optimal text direction for the current context
  static TextDirection getContextDirection(
    BuildContext context, [
    String? content,
  ]) {
    if (content != null && content.isNotEmpty) {
      return ArabicTypography.getTextDirection(content);
    }

    return shouldUseRTL(context) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Wrap widget with appropriate directionality
  static Widget wrapWithDirectionality({
    required Widget child,
    required BuildContext context,
    TextDirection? explicitDirection,
    String? content,
  }) {
    final direction =
        explicitDirection ?? getContextDirection(context, content);

    return Directionality(textDirection: direction, child: child);
  }

  /// Create RTL-aware EdgeInsets
  static EdgeInsets createRTLAwareInsets({
    required BuildContext context,
    double? start,
    double? end,
    double? top,
    double? bottom,
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }

    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    }

    final isRTL = getContextDirection(context) == TextDirection.rtl;

    return EdgeInsets.only(
      left: isRTL ? (end ?? 0) : (start ?? 0),
      right: isRTL ? (start ?? 0) : (end ?? 0),
      top: top ?? 0,
      bottom: bottom ?? 0,
    );
  }

  /// Create RTL-aware alignment
  static Alignment createRTLAwareAlignment(
    BuildContext context,
    AlignmentGeometry alignment,
  ) {
    if (getContextDirection(context) == TextDirection.rtl) {
      if (alignment == Alignment.centerLeft) return Alignment.centerRight;
      if (alignment == Alignment.centerRight) return Alignment.centerLeft;
      if (alignment == Alignment.topLeft) return Alignment.topRight;
      if (alignment == Alignment.topRight) return Alignment.topLeft;
      if (alignment == Alignment.bottomLeft) return Alignment.bottomRight;
      if (alignment == Alignment.bottomRight) return Alignment.bottomLeft;
    }

    return alignment as Alignment;
  }

  /// Create RTL-aware CrossAxisAlignment
  static CrossAxisAlignment createRTLAwareCrossAxisAlignment(
    BuildContext context,
    CrossAxisAlignment alignment,
  ) {
    if (getContextDirection(context) == TextDirection.rtl) {
      if (alignment == CrossAxisAlignment.start) return CrossAxisAlignment.end;
      if (alignment == CrossAxisAlignment.end) return CrossAxisAlignment.start;
    }

    return alignment;
  }

  /// Create RTL-aware MainAxisAlignment
  static MainAxisAlignment createRTLAwareMainAxisAlignment(
    BuildContext context,
    MainAxisAlignment alignment,
  ) {
    if (getContextDirection(context) == TextDirection.rtl) {
      if (alignment == MainAxisAlignment.start) return MainAxisAlignment.end;
      if (alignment == MainAxisAlignment.end) return MainAxisAlignment.start;
    }

    return alignment;
  }
}

/// Mixed Text Direction Widget for handling Arabic + English content
class MixedTextDirectionWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool selectable;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const MixedTextDirectionWidget({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
    this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = ArabicTypography.getTextDirection(text);
    final alignment =
        textAlign ?? ArabicTypography.getTextAlign(text, textDirection);

    Widget textWidget;

    if (selectable) {
      textWidget = SelectableText(
        text,
        style: style,
        textAlign: alignment,
        textDirection: textDirection,
        maxLines: maxLines,
        onTap: onTap,
      );
    } else {
      textWidget = GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: style,
          textAlign: alignment,
          textDirection: textDirection,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: Directionality(textDirection: textDirection, child: textWidget),
    );
  }
}

/// RTL-Aware Container that adapts its layout based on content
class RTLAwareContainer extends StatelessWidget {
  final Widget child;
  final String? content;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final Alignment? alignment;
  final double? width;
  final double? height;

  const RTLAwareContainer({
    super.key,
    required this.child,
    this.content,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final direction = RTLLayoutSupport.getContextDirection(context, content);
    final adaptedAlignment =
        alignment != null
            ? RTLLayoutSupport.createRTLAwareAlignment(context, alignment!)
            : null;

    return Directionality(
      textDirection: direction,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        alignment: adaptedAlignment,
        child: child,
      ),
    );
  }
}

/// RTL-Aware Row that reverses children order for RTL content
class RTLAwareRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final String? content;

  const RTLAwareRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final direction = RTLLayoutSupport.getContextDirection(context, content);
    final adaptedMainAxis = RTLLayoutSupport.createRTLAwareMainAxisAlignment(
      context,
      mainAxisAlignment,
    );
    final adaptedCrossAxis = RTLLayoutSupport.createRTLAwareCrossAxisAlignment(
      context,
      crossAxisAlignment,
    );

    return Directionality(
      textDirection: direction,
      child: Row(
        mainAxisAlignment: adaptedMainAxis,
        crossAxisAlignment: adaptedCrossAxis,
        mainAxisSize: mainAxisSize,
        children:
            direction == TextDirection.rtl
                ? children.reversed.toList()
                : children,
      ),
    );
  }
}

/// RTL-Aware Column that adapts alignment for RTL content
class RTLAwareColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final String? content;

  const RTLAwareColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final direction = RTLLayoutSupport.getContextDirection(context, content);
    final adaptedCrossAxis = RTLLayoutSupport.createRTLAwareCrossAxisAlignment(
      context,
      crossAxisAlignment,
    );

    return Directionality(
      textDirection: direction,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: adaptedCrossAxis,
        mainAxisSize: mainAxisSize,
        children: children,
      ),
    );
  }
}

/// RTL-Aware Flexible/Expanded wrapper
class RTLAwareFlex extends StatelessWidget {
  final int flex;
  final FlexFit fit;
  final Widget child;
  final String? content;

  const RTLAwareFlex({
    super.key,
    this.flex = 1,
    this.fit = FlexFit.loose,
    required this.child,
    this.content,
  });

  const RTLAwareFlex.expanded({
    super.key,
    this.flex = 1,
    required this.child,
    this.content,
  }) : fit = FlexFit.tight;

  @override
  Widget build(BuildContext context) {
    final direction = RTLLayoutSupport.getContextDirection(context, content);

    return Directionality(
      textDirection: direction,
      child: Flexible(flex: flex, fit: fit, child: child),
    );
  }
}

/// RTL-Aware Positioned widget for Stack layouts
class RTLAwarePositioned extends StatelessWidget {
  final double? start;
  final double? end;
  final double? top;
  final double? bottom;
  final double? width;
  final double? height;
  final Widget child;
  final String? content;

  const RTLAwarePositioned({
    super.key,
    this.start,
    this.end,
    this.top,
    this.bottom,
    this.width,
    this.height,
    required this.child,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final direction = RTLLayoutSupport.getContextDirection(context, content);
    final isRTL = direction == TextDirection.rtl;

    return Positioned(
      left: isRTL ? end : start,
      right: isRTL ? start : end,
      top: top,
      bottom: bottom,
      width: width,
      height: height,
      child: Directionality(textDirection: direction, child: child),
    );
  }
}

/// Accessibility-enhanced Text widget for Arabic content
class AccessibleArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool selectable;
  final String? semanticsLabel;
  final String? tooltip;
  final VoidCallback? onTap;

  const AccessibleArabicText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
    this.semanticsLabel,
    this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = ArabicTypography.getTextDirection(text);
    final alignment =
        textAlign ?? ArabicTypography.getTextAlign(text, textDirection);

    Widget textWidget =
        selectable
            ? SelectableText(
              text,
              style: style,
              textAlign: alignment,
              textDirection: textDirection,
              maxLines: maxLines,
              onTap: onTap,
            )
            : GestureDetector(
              onTap: onTap,
              child: Text(
                text,
                style: style,
                textAlign: alignment,
                textDirection: textDirection,
                maxLines: maxLines,
                overflow: overflow,
              ),
            );

    // Add semantics for screen readers
    textWidget = Semantics(
      label: semanticsLabel ?? text,
      textDirection: textDirection,
      child: textWidget,
    );

    // Add tooltip if provided
    if (tooltip != null) {
      textWidget = Tooltip(
        message: tooltip!,
        textStyle: style,
        child: textWidget,
      );
    }

    return Directionality(textDirection: textDirection, child: textWidget);
  }
}

/// Custom text selection controls for Arabic content
class ArabicTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Adjust handle position for RTL text
    TextSelectionHandleType adjustedType = type;
    if (isRTL) {
      if (type == TextSelectionHandleType.left) {
        adjustedType = TextSelectionHandleType.right;
      } else if (type == TextSelectionHandleType.right) {
        adjustedType = TextSelectionHandleType.left;
      }
    }

    return super.buildHandle(context, adjustedType, textLineHeight, onTap);
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    return _ArabicTextSelectionToolbar(
      globalEditableRegion: globalEditableRegion,
      textLineHeight: textLineHeight,
      selectionMidpoint: selectionMidpoint,
      endpoints: endpoints,
      delegate: delegate,
      clipboardStatus: clipboardStatus,
      lastSecondaryTapDownPosition: lastSecondaryTapDownPosition,
    );
  }
}

class _ArabicTextSelectionToolbar extends StatelessWidget {
  final Rect globalEditableRegion;
  final double textLineHeight;
  final Offset selectionMidpoint;
  final List<TextSelectionPoint> endpoints;
  final TextSelectionDelegate delegate;
  final ValueListenable<ClipboardStatus>? clipboardStatus;
  final Offset? lastSecondaryTapDownPosition;

  const _ArabicTextSelectionToolbar({
    required this.globalEditableRegion,
    required this.textLineHeight,
    required this.selectionMidpoint,
    required this.endpoints,
    required this.delegate,
    this.clipboardStatus,
    this.lastSecondaryTapDownPosition,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return TextSelectionToolbar(
      anchorAbove: selectionMidpoint,
      anchorBelow: selectionMidpoint,
      children: [
        if (delegate.cutEnabled)
          TextSelectionToolbarTextButton(
            padding: EdgeInsets.zero,
            child: Text(isRTL ? 'قص' : 'Cut'),
            onPressed: () {
              delegate.cutSelection(SelectionChangedCause.toolbar);
            },
          ),
        if (delegate.copyEnabled)
          TextSelectionToolbarTextButton(
            padding: EdgeInsets.zero,
            child: Text(isRTL ? 'نسخ' : 'Copy'),
            onPressed: () {
              delegate.copySelection(SelectionChangedCause.toolbar);
            },
          ),
        if (delegate.pasteEnabled)
          TextSelectionToolbarTextButton(
            padding: EdgeInsets.zero,
            child: Text(isRTL ? 'لصق' : 'Paste'),
            onPressed: () {
              delegate.pasteText(SelectionChangedCause.toolbar);
            },
          ),
        if (delegate.selectAllEnabled)
          TextSelectionToolbarTextButton(
            padding: EdgeInsets.zero,
            child: Text(isRTL ? 'تحديد الكل' : 'Select All'),
            onPressed: () {
              delegate.selectAll(SelectionChangedCause.toolbar);
            },
          ),
      ],
    );
  }
}

/// Platform-specific RTL optimizations
class PlatformRTLOptimizations {
  /// Apply platform-specific RTL optimizations
  static void applyOptimizations(BuildContext context) {
    if (RTLLayoutSupport.shouldUseRTL(context)) {
      // iOS-specific RTL optimizations
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }

      // Android-specific RTL optimizations
      if (Theme.of(context).platform == TargetPlatform.android) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
      }
    }
  }

  /// Get platform-specific text scaling for Arabic content
  static double getPlatformTextScaling(BuildContext context) {
    final platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.iOS:
        return 1.0; // iOS handles text scaling well by default
      case TargetPlatform.android:
        return 1.05; // Slightly larger for better readability on Android
      case TargetPlatform.windows:
        return 1.1; // Larger for desktop screens
      case TargetPlatform.macOS:
        return 1.0; // macOS handles text scaling well
      default:
        return 1.0;
    }
  }
}
