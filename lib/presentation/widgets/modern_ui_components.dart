// Modern UI components and widgets for award-winning design
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern glassmorphic container with beautiful effects
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool withShadow;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.opacity = 0.1,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bgColor.withOpacity(opacity),
            bgColor.withOpacity(opacity * 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow:
            withShadow
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
                : null,
      ),
      child: child,
    );
  }
}

/// Animated gradient button with modern styling
class ModernGradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final IconData? icon;
  final bool isLoading;

  const ModernGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.padding,
    this.borderRadius = 16,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<ModernGradientButton> createState() => _ModernGradientButtonState();
}

class _ModernGradientButtonState extends State<ModernGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors =
        widget.gradientColors ??
        [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)];

    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else if (widget.icon != null)
                    Icon(widget.icon, color: Colors.white, size: 18),
                  if (widget.icon != null || widget.isLoading)
                    const SizedBox(width: 8),
                  Text(
                    widget.text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Modern search input with glassmorphic design
class ModernSearchInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSend;
  final VoidCallback? onVoice;
  final bool showVoiceButton;
  final bool isListening;

  const ModernSearchInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSend,
    this.onVoice,
    this.showVoiceButton = true,
    this.isListening = false,
  });

  @override
  State<ModernSearchInput> createState() => _ModernSearchInputState();
}

class _ModernSearchInputState extends State<ModernSearchInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    if (widget.isListening) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(ModernSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _pulseController.repeat();
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color:
              _isFocused
                  ? theme.colorScheme.primary.withOpacity(0.5)
                  : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                _isFocused
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: _isFocused ? 20 : 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(
            Icons.search_rounded,
            color: theme.colorScheme.primary.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 16),

          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onSubmitted: (_) => widget.onSend?.call(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Voice search button
          if (widget.showVoiceButton)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      widget.isListening
                          ? 1.0 + (_pulseController.value * 0.1)
                          : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      gradient:
                          widget.isListening
                              ? LinearGradient(
                                colors: [
                                  Colors.red.withOpacity(0.8),
                                  Colors.redAccent.withOpacity(0.6),
                                ],
                              )
                              : LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withOpacity(0.1),
                                  theme.colorScheme.primary.withOpacity(0.05),
                                ],
                              ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: widget.onVoice,
                      icon: Icon(
                        widget.isListening
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        color:
                            widget.isListening
                                ? Colors.white
                                : theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Send button
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: widget.onSend,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Animated loading indicator with modern design
class ModernLoadingIndicator extends StatefulWidget {
  final String? message;
  final Color? color;

  const ModernLoadingIndicator({super.key, this.message, this.color});

  @override
  State<ModernLoadingIndicator> createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.color ?? theme.colorScheme.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _rotateController]),
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.1),
              child: Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        primaryColor.withOpacity(0.3),
                        primaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        if (widget.message != null) ...[
          const SizedBox(height: 24),
          Text(
            widget.message!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we process your request',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Modern card with hover effects and animations
class ModernAnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool enableHoverEffect;

  const ModernAnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.enableHoverEffect = true,
  });

  @override
  State<ModernAnimatedCard> createState() => _ModernAnimatedCardState();
}

class _ModernAnimatedCardState extends State<ModernAnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    if (widget.enableHoverEffect) {
      setState(() {
        _isHovered = true;
      });
      _hoverController.forward();
    }
  }

  void _onExit(PointerEvent details) {
    if (widget.enableHoverEffect) {
      setState(() {
        _isHovered = false;
      });
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            HapticFeedback.lightImpact();
            widget.onTap!();
          }
        },
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: widget.margin,
                padding: widget.padding ?? const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Modern floating action button with advanced styling
class ModernFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final List<Color>? gradientColors;

  const ModernFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.gradientColors,
  });

  @override
  State<ModernFloatingActionButton> createState() =>
      _ModernFloatingActionButtonState();
}

class _ModernFloatingActionButtonState extends State<ModernFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors =
        widget.gradientColors ??
        [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)];

    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) {
          _animationController.reverse();
          widget.onPressed();
          HapticFeedback.mediumImpact();
        },
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 24),
              ),
            );
          },
        ),
      ),
    );
  }
}
