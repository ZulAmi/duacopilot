// Modern animated splash screen for DuaCopilot
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModernSplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const ModernSplashScreen({super.key, required this.onAnimationComplete});

  @override
  State<ModernSplashScreen> createState() => _ModernSplashScreenState();
}

class _ModernSplashScreenState extends State<ModernSplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _breatheController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();

    // Fallback timeout to ensure app doesn't hang
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        debugPrint('Splash screen timeout - forcing completion');
        widget.onAnimationComplete();
      }
    });
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Text animation controller
    _textController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    // Particle animation controller
    _particleController = AnimationController(duration: const Duration(seconds: 3), vsync: this);

    // Breathing effect controller
    _breatheController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Logo animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeInOut));

    // Text animations
    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
  }

  void _startAnimationSequence() async {
    try {
      // Add haptic feedback only on mobile platforms
      if (!kIsWeb) {
        HapticFeedback.lightImpact();
      }

      // Start particles and breathing effects
      _particleController.repeat();
      _breatheController.repeat(reverse: true);

      // Start logo animation
      await _logoController.forward();

      // Small delay then start text animation
      await Future.delayed(const Duration(milliseconds: 300));
      await _textController.forward();

      // Keep splash screen visible for a moment
      await Future.delayed(const Duration(seconds: 1));

      // Complete animation
      if (mounted) {
        widget.onAnimationComplete();
      }
    } catch (e) {
      // Fallback: immediately complete if animations fail
      debugPrint('Splash animation error: $e');
      if (mounted) {
        widget.onAnimationComplete();
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Animated background gradient
          _buildAnimatedBackground(theme),

          // Floating particles
          _buildFloatingParticles(theme, size),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                _buildAnimatedLogo(theme),

                const SizedBox(height: 40),

                // App title with animation
                _buildAnimatedTitle(theme),

                const SizedBox(height: 16),

                // Subtitle with animation
                _buildAnimatedSubtitle(theme),

                const SizedBox(height: 60),

                // Loading indicator
                _buildLoadingIndicator(theme),
              ],
            ),
          ),

          // Bottom branding
          _buildBottomBranding(theme),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    return AnimatedBuilder(
      animation: _breatheController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.2 + (_breatheController.value * 0.3),
              colors: [
                theme.colorScheme.primary.withOpacity(0.15),
                theme.colorScheme.secondary.withOpacity(0.08),
                theme.colorScheme.surface,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles(ThemeData theme, Size size) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final offset = _particleController.value * 2 * math.pi;
            final x = (size.width * 0.1) + (index * (size.width * 0.08)) + (40 * math.sin(offset + index));
            final y = (size.height * 0.1) + (index * (size.height * 0.07)) + (30 * math.cos(offset + index * 1.3));

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: 0.2 + (0.1 * math.sin(offset + index).abs()),
                child: Container(
                  width: 4 + (3 * math.sin(offset + index)),
                  height: 4 + (3 * math.sin(offset + index)),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildAnimatedLogo(ThemeData theme) {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _breatheController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value * (1.0 + (_breatheController.value * 0.05)),
          child: Transform.rotate(
            angle: _logoRotation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                  ),
                ],
              ),
              child: const Center(child: Icon(Icons.mosque_rounded, color: Colors.white, size: 60)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle(ThemeData theme) {
    return FadeTransition(
      opacity: _textFade,
      child: SlideTransition(
        position: _textSlide,
        child: Text(
          'DuaCopilot',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -1.0,
            shadows: [
              Shadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnimatedSubtitle(ThemeData theme) {
    return FadeTransition(
      opacity: _textFade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _textController, curve: const Interval(0.3, 1.0, curve: Curves.easeOut))),
        child: Text(
          'Your AI Islamic Companion',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return FadeTransition(
      opacity: _textFade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _textController, curve: const Interval(0.5, 1.0, curve: Curves.easeOut))),
        child: Column(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Islamic Knowledge...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBranding(ThemeData theme) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _textFade,
        child: Column(
          children: [
            Text(
              'Made with ❤️ for the Muslim Community',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.star_rounded, color: theme.colorScheme.primary.withOpacity(0.5), size: 16),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
