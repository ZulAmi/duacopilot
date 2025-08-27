import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Custom scroll physics optimized for Arabic text rendering and RTL layouts
class ArabicScrollPhysics extends ClampingScrollPhysics {
  const ArabicScrollPhysics({super.parent});

  @override
  ArabicScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ArabicScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Adjust scroll behavior for RTL languages
    final tolerance = toleranceFor(position);

    // Optimize for Arabic text with different friction and spring constants
    if (velocity.abs() < tolerance.velocity ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }

    // Custom spring simulation optimized for Arabic text scrolling
    return ScrollSpringSimulation(
      _getOptimizedSpring(),
      position.pixels,
      position.pixels +
          velocity * 0.35, // Adjusted for smoother Arabic text scrolling
      velocity,
      tolerance: tolerance,
    );
  }

  /// Get optimized spring configuration based on platform and text direction
  SpringDescription _getOptimizedSpring() {
    // Platform-specific optimizations
    if (Platform.isIOS) {
      // iOS-specific spring for smoother Arabic text rendering
      return const SpringDescription(
        mass: 0.5,
        stiffness: 100.0,
        damping: 15.0,
      );
    } else if (Platform.isAndroid) {
      // Android-specific spring for better performance
      return const SpringDescription(
        mass: 0.4,
        stiffness: 120.0,
        damping: 16.0,
      );
    } else {
      // Default for web and other platforms
      return const SpringDescription(mass: 0.6, stiffness: 90.0, damping: 14.0);
    }
  }

  @override
  double get dragStartDistanceMotionThreshold {
    // Reduced threshold for more responsive Arabic text scrolling
    return Platform.isIOS ? 3.5 : 4.0;
  }

  @override
  double carriedMomentum(double existingVelocity) {
    // Optimize momentum for smooth Arabic text transitions
    return existingVelocity * 0.85;
  }
}

/// RTL-optimized scroll physics for Arabic layouts
class RTLScrollPhysics extends ArabicScrollPhysics {
  const RTLScrollPhysics({super.parent});

  @override
  RTLScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return RTLScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Invert scroll direction for natural RTL scrolling
    return super.applyPhysicsToUserOffset(position, -offset);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Adjust velocity for RTL scrolling
    return super.createBallisticSimulation(position, -velocity);
  }
}

/// Performance-optimized scroll physics for large Arabic text lists
class PerformantArabicScrollPhysics extends ArabicScrollPhysics {
  const PerformantArabicScrollPhysics({super.parent});

  @override
  PerformantArabicScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PerformantArabicScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final tolerance = toleranceFor(position);

    // Fast scrolling for large lists with optimized performance
    if (velocity.abs() < tolerance.velocity) {
      return null;
    }

    // Use friction simulation for better performance with large datasets
    return FrictionSimulation(
      _getOptimizedFriction(),
      position.pixels,
      velocity,
      tolerance: tolerance,
    );
  }

  /// Get optimized friction based on platform
  double _getOptimizedFriction() {
    if (Platform.isIOS) {
      return 0.015; // Lower friction for iOS for smoother scrolling
    } else if (Platform.isAndroid) {
      return 0.02; // Slightly higher friction for Android
    } else {
      return 0.025; // Default friction for web/desktop
    }
  }
}

/// Scroll configuration for Arabic text with performance optimizations
class ArabicScrollBehavior extends ScrollBehavior {
  const ArabicScrollBehavior({
    required this.isRTL,
    this.isLargeDataset = false,
  });

  final bool isRTL;
  final bool isLargeDataset;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    if (isLargeDataset) {
      return const PerformantArabicScrollPhysics();
    } else if (isRTL) {
      return const RTLScrollPhysics();
    } else {
      return const ArabicScrollPhysics();
    }
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Platform-specific scrollbar optimizations
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoScrollbar(controller: details.controller, child: child);
      case TargetPlatform.android:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: true,
          trackVisibility: false,
          thickness: 4.0,
          radius: const Radius.circular(2.0),
          child: child,
        );
      default:
        return Scrollbar(controller: details.controller, child: child);
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Platform-specific overscroll indicators
    if (Platform.isIOS) {
      return child; // iOS uses native bounce
    } else if (Platform.isAndroid) {
      return GlowingOverscrollIndicator(
        axisDirection: details.direction,
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        child: child,
      );
    } else {
      return child; // No overscroll indicator for web/desktop
    }
  }
}

/// Utility class for Arabic text scroll optimizations
class ArabicScrollUtils {
  /// Get optimal scroll physics based on context
  static ScrollPhysics getOptimalPhysics({
    required bool isRTL,
    required bool isLargeDataset,
    required bool isArabicText,
  }) {
    if (isLargeDataset && isArabicText) {
      return const PerformantArabicScrollPhysics();
    } else if (isRTL) {
      return const RTLScrollPhysics();
    } else if (isArabicText) {
      return const ArabicScrollPhysics();
    } else {
      return const ClampingScrollPhysics();
    }
  }

  /// Create scroll configuration for Arabic content
  static Widget wrapWithArabicScrolling({
    required Widget child,
    required bool isRTL,
    bool isLargeDataset = false,
  }) {
    return ScrollConfiguration(
      behavior: ArabicScrollBehavior(
        isRTL: isRTL,
        isLargeDataset: isLargeDataset,
      ),
      child: child,
    );
  }

  /// Calculate optimal item extent for Arabic text
  static double calculateItemExtent({
    required String text,
    required TextStyle textStyle,
    required double maxWidth,
    int maxLines = 3,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
    );

    textPainter.layout(maxWidth: maxWidth);

    // Add padding for Arabic text rendering
    final height = textPainter.size.height + 16.0; // 8px top + 8px bottom
    textPainter.dispose();

    return height;
  }

  /// Check if text contains Arabic characters
  static bool containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  /// Get text direction based on content
  static TextDirection getTextDirection(String text) {
    if (containsArabic(text)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
