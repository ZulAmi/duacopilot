// lib/presentation/widgets/ultra_modern_components.dart

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/ultra_modern_theme.dart';

/// Collection of ultra-modern UI components with award-winning design
class UltraModernComponents {
  /// Glassmorphic Container with backdrop blur effect
  static Widget glassmorphicContainer({
    required Widget child,
    double? width,
    double? height,
    double borderRadius = 20,
    double blurSigma = 20,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? UltraModernTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Animated Gradient Button with haptic feedback
  static Widget animatedGradientButton({
    required String text,
    required VoidCallback onPressed,
    double width = 200,
    double height = 56,
    IconData? icon,
    bool isLoading = false,
    bool enabled = true,
    LinearGradient? gradient,
    List<BoxShadow>? boxShadow,
    double borderRadius = 16,
  }) {
    return AnimatedGradientButtonWidget(
      text: text,
      onPressed: onPressed,
      width: width,
      height: height,
      icon: icon,
      isLoading: isLoading,
      enabled: enabled,
      gradient: gradient ?? UltraModernTheme.primaryGradient,
      boxShadow: boxShadow ?? UltraModernTheme.elevatedShadow,
      borderRadius: borderRadius,
    );
  }

  /// Floating Search Bar with modern design
  static Widget floatingSearchBar({
    required TextEditingController controller,
    required Function(String) onChanged,
    String hintText = 'Search...',
    VoidCallback? onMicrophonePressed,
    VoidCallback? onFilterPressed,
    bool showMicrophone = true,
    bool showFilter = true,
    EdgeInsetsGeometry? margin,
  }) {
    return FloatingSearchBarWidget(
      controller: controller,
      onChanged: onChanged,
      hintText: hintText,
      onMicrophonePressed: onMicrophonePressed,
      onFilterPressed: onFilterPressed,
      showMicrophone: showMicrophone,
      showFilter: showFilter,
      margin: margin,
    );
  }

  /// Modern Card with gradient and shadow
  static Widget modernCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    LinearGradient? gradient,
    List<BoxShadow>? boxShadow,
    double borderRadius = 20,
    VoidCallback? onTap,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    return ModernCardWidget(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin ?? const EdgeInsets.all(8),
      gradient: gradient ?? UltraModernTheme.cardGradient,
      boxShadow: boxShadow ?? UltraModernTheme.softShadow,
      borderRadius: borderRadius,
      onTap: onTap,
      animationDuration: animationDuration,
      child: child,
    );
  }

  /// Animated Loading Indicator
  static Widget modernLoadingIndicator({
    double size = 50,
    Color? color,
    double strokeWidth = 4,
  }) {
    return ModernLoadingIndicator(
      size: size,
      color: color,
      strokeWidth: strokeWidth,
    );
  }

  /// Floating Action Button with glow effect
  static Widget glowingFAB({
    required VoidCallback onPressed,
    required IconData icon,
    Color? backgroundColor,
    Color? foregroundColor,
    double size = 56,
    List<BoxShadow>? glowEffect,
  }) {
    return GlowingFABWidget(
      onPressed: onPressed,
      icon: icon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      size: size,
      glowEffect: glowEffect ?? UltraModernTheme.glowShadow,
    );
  }

  /// Animated Counter with smooth transitions
  static Widget animatedCounter({
    required int value,
    Duration duration = const Duration(milliseconds: 1000),
    TextStyle? textStyle,
    String prefix = '',
    String suffix = '',
  }) {
    return AnimatedCounterWidget(
      value: value,
      duration: duration,
      textStyle: textStyle,
      prefix: prefix,
      suffix: suffix,
    );
  }

  /// Parallax Scroll Effect
  static Widget parallaxEffect({
    required Widget child,
    required double offset,
    double factor = 0.5,
  }) {
    return Transform.translate(
      offset: Offset(0, offset * factor),
      child: child,
    );
  }
}

/// Animated Gradient Button Widget
class AnimatedGradientButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final LinearGradient gradient;
  final List<BoxShadow> boxShadow;
  final double borderRadius;

  const AnimatedGradientButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    required this.gradient,
    required this.boxShadow,
    required this.borderRadius,
  });

  @override
  State<AnimatedGradientButtonWidget> createState() =>
      _AnimatedGradientButtonWidgetState();
}

class _AnimatedGradientButtonWidgetState
    extends State<AnimatedGradientButtonWidget> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: UltraModernTheme.fastDuration,
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: UltraModernTheme.primaryCurve,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _shimmerAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.enabled ? widget.boxShadow : null,
              gradient: widget.enabled ? widget.gradient : null,
              color: !widget.enabled ? Colors.grey.shade300 : null,
            ),
            child: Stack(
              children: [
                // Shimmer effect
                if (widget.enabled)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.transparent,
                              Colors.white24,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            transform: GradientRotation(
                              _shimmerAnimation.value,
                            ),
                          ).createShader(bounds);
                        },
                        child: Container(color: Colors.white),
                      ),
                    ),
                  ),

                // Button content
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    onTap: widget.enabled && !widget.isLoading
                        ? () {
                            HapticFeedback.lightImpact();
                            widget.onPressed();
                          }
                        : null,
                    onTapDown: (_) => _scaleController.forward(),
                    onTapUp: (_) => _scaleController.reverse(),
                    onTapCancel: () => _scaleController.reverse(),
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                      ),
                      child: Center(
                        child: widget.isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.enabled
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.icon != null) ...[
                                    Icon(
                                      widget.icon,
                                      color: widget.enabled
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    widget.text,
                                    style: TextStyle(
                                      color: widget.enabled
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Floating Search Bar Widget
class FloatingSearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final VoidCallback? onMicrophonePressed;
  final VoidCallback? onFilterPressed;
  final bool showMicrophone;
  final bool showFilter;
  final EdgeInsetsGeometry? margin;

  const FloatingSearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.onMicrophonePressed,
    this.onFilterPressed,
    this.showMicrophone = true,
    this.showFilter = true,
    this.margin,
  });

  @override
  State<FloatingSearchBarWidget> createState() =>
      _FloatingSearchBarWidgetState();
}

class _FloatingSearchBarWidgetState extends State<FloatingSearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UltraModernTheme.normalDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: UltraModernTheme.smoothCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: _isFocused
                  ? UltraModernTheme.elevatedShadow
                  : UltraModernTheme.softShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isFocused
                          ? context.colorScheme.primary.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          onChanged: widget.onChanged,
                          onTap: () {
                            setState(() => _isFocused = true);
                            _animationController.forward();
                          },
                          onSubmitted: (_) {
                            setState(() => _isFocused = false);
                            _animationController.reverse();
                          },
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (widget.showFilter) ...[
                        IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            widget.onFilterPressed?.call();
                          },
                          icon: Icon(
                            Icons.tune_rounded,
                            color: Colors.grey.shade600,
                            size: 24,
                          ),
                        ),
                      ],
                      if (widget.showMicrophone) ...[
                        IconButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            widget.onMicrophonePressed?.call();
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mic_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Modern Card Widget
class ModernCardWidget extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final LinearGradient gradient;
  final List<BoxShadow> boxShadow;
  final double borderRadius;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const ModernCardWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    required this.padding,
    required this.margin,
    required this.gradient,
    required this.boxShadow,
    required this.borderRadius,
    this.onTap,
    required this.animationDuration,
  });

  @override
  State<ModernCardWidget> createState() => _ModernCardWidgetState();
}

class _ModernCardWidgetState extends State<ModernCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: UltraModernTheme.smoothCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: _isHovered
                  ? UltraModernTheme.elevatedShadow
                  : widget.boxShadow,
              gradient: widget.gradient,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                onTap: widget.onTap != null
                    ? () {
                        HapticFeedback.lightImpact();
                        widget.onTap!();
                      }
                    : null,
                onHover: (hovering) {
                  setState(() => _isHovered = hovering);
                  if (hovering) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                child: Container(padding: widget.padding, child: widget.child),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Modern Loading Indicator
class ModernLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const ModernLoadingIndicator({
    super.key,
    required this.size,
    this.color,
    required this.strokeWidth,
  });

  @override
  State<ModernLoadingIndicator> createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: ModernLoadingPainter(
                color: widget.color ?? context.colorScheme.primary,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom Painter for Modern Loading Indicator
class ModernLoadingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  ModernLoadingPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    // Draw gradient arc
    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    const double startAngle = -math.pi / 2;
    const double sweepAngle = math.pi * 1.5;

    final Gradient gradient = SweepGradient(
      colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.3), color, color],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    paint.shader = gradient.createShader(rect);

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Glowing FAB Widget
class GlowingFABWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final List<BoxShadow> glowEffect;

  const GlowingFABWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    required this.size,
    required this.glowEffect,
  });

  @override
  State<GlowingFABWidget> createState() => _GlowingFABWidgetState();
}

class _GlowingFABWidgetState extends State<GlowingFABWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: widget.glowEffect,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.backgroundColor ?? context.colorScheme.primary,
                  (widget.backgroundColor ?? context.colorScheme.primary)
                      .withValues(alpha: 0.8),
                ],
              ),
            ),
            child: FloatingActionButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                widget.onPressed();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                widget.icon,
                color: widget.foregroundColor ?? Colors.white,
                size: widget.size * 0.4,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated Counter Widget
class AnimatedCounterWidget extends StatelessWidget {
  final int value;
  final Duration duration;
  final TextStyle? textStyle;
  final String prefix;
  final String suffix;

  const AnimatedCounterWidget({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1000),
    this.textStyle,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: UltraModernTheme.smoothCurve,
      builder: (context, value, child) {
        return Text(
          '$prefix$value$suffix',
          style: textStyle ??
              context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.primary,
              ),
        );
      },
    );
  }
}

