// lib/presentation/screens/ultra_modern_splash_screen.dart

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// Ultra-modern splash screen with stunning animations
class UltraModernSplashScreen extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final Duration animationDuration;

  const UltraModernSplashScreen({
    super.key,
    this.onAnimationComplete,
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  State<UltraModernSplashScreen> createState() => _UltraModernSplashScreenState();
}

class _UltraModernSplashScreenState extends State<UltraModernSplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particlesController;
  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _particlesAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _mainController = AnimationController(duration: widget.animationDuration, vsync: this);

    _particlesController = AnimationController(duration: const Duration(seconds: 4), vsync: this);

    _logoController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _textController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    // Setup animations
    _setupAnimations();

    // Start the splash sequence
    _startSplashSequence();
  }

  void _setupAnimations() {
    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)));

    // Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.7, curve: Curves.easeInOut)));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));

    // Text animations
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    // Particles animation
    _particlesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _particlesController, curve: Curves.easeInOut));
  }

  void _startSplashSequence() async {
    // Start background and particles
    _mainController.forward();
    _particlesController.repeat();

    // Delay and start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Delay and start text animation
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Wait for animations to complete
    await Future.delayed(widget.animationDuration);

    // Call completion callback
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particlesController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _particlesController, _logoController, _textController]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFF0D7C66), const Color(0xFF41A3B3), _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFF41A3B3), const Color(0xFFE6B17A), _backgroundAnimation.value)!,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                Positioned.fill(
                  child: CustomPaint(
                    painter: SplashParticlesPainter(
                      animationValue: _particlesAnimation.value,
                      particleColor: Colors.white.withOpacity(0.1),
                      particleCount: 80,
                    ),
                  ),
                ),

                // Floating geometric shapes
                _buildFloatingShapes(),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with advanced animations
                      _buildAnimatedLogo(),

                      const SizedBox(height: 40),

                      // App name with slide animation
                      _buildAnimatedText(),

                      const SizedBox(height: 60),

                      // Loading indicator
                      _buildLoadingIndicator(),
                    ],
                  ),
                ),

                // Bottom branding
                _buildBottomBranding(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotationAnimation.value,
            child: Opacity(
              opacity: _logoOpacityAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Icon(Icons.mosque_rounded, size: 60, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              children: [
                Text(
                  'DuaCopilot',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your AI Islamic Companion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Opacity(
          opacity: _mainController.value,
          child: Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Colors.white.withOpacity(0.2)),
            child: Stack(
              children: [
                Container(
                  width: 200 * _mainController.value,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(colors: [Colors.white, Colors.white70]),
                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 8, spreadRadius: 1)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingShapes() {
    return Stack(
      children: [
        // Top-left shape
        Positioned(
          top: 100,
          left: -50,
          child: AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.sin(_particlesAnimation.value * 2 * math.pi) * 20,
                  math.cos(_particlesAnimation.value * 2 * math.pi) * 15,
                ),
                child: Transform.rotate(
                  angle: _particlesAnimation.value * 2 * math.pi,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom-right shape
        Positioned(
          bottom: 150,
          right: -30,
          child: AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.cos(_particlesAnimation.value * 2 * math.pi) * -25,
                  math.sin(_particlesAnimation.value * 2 * math.pi) * 20,
                ),
                child: Transform.rotate(
                  angle: -_particlesAnimation.value * 2 * math.pi,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.03),
                      border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Center floating element
        Positioned(
          top: 200,
          right: 80,
          child: AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.sin(_particlesAnimation.value * 2 * math.pi * 0.8) * 15,
                  math.cos(_particlesAnimation.value * 2 * math.pi * 0.6) * 25,
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBranding() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              children: [
                Text(
                  'Powered by AI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.7)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for splash screen particles
class SplashParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color particleColor;
  final int particleCount;

  SplashParticlesPainter({required this.animationValue, required this.particleColor, required this.particleCount});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = particleColor
          ..style = PaintingStyle.fill;

    final random = math.Random(123); // Fixed seed for consistent particles

    for (int i = 0; i < particleCount; i++) {
      final double baseX = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 2 + 0.5;
      final double speed = random.nextDouble() * 0.5 + 0.3;
      final double phase = random.nextDouble() * 2 * math.pi;

      // Create floating animation
      final double offsetX = math.sin(animationValue * 2 * math.pi * speed + phase) * 20;
      final double offsetY = math.cos(animationValue * 2 * math.pi * speed * 0.7 + phase) * 15;

      // Opacity animation
      final double opacity = (math.sin(animationValue * 2 * math.pi * speed * 0.5 + phase) + 1) / 2;

      paint.color = particleColor.withOpacity(opacity * 0.8);

      canvas.drawCircle(Offset(baseX + offsetX, baseY + offsetY), radius, paint);

      // Draw connection lines between nearby particles
      for (int j = i + 1; j < math.min(i + 5, particleCount); j++) {
        final double otherX = random.nextDouble() * size.width;
        final double otherY = random.nextDouble() * size.height;

        final double distance = math.sqrt(math.pow(baseX - otherX, 2) + math.pow(baseY - otherY, 2));

        if (distance < 150) {
          final Paint linePaint =
              Paint()
                ..color = particleColor.withOpacity((1 - distance / 150) * 0.1)
                ..strokeWidth = 0.5
                ..style = PaintingStyle.stroke;

          canvas.drawLine(Offset(baseX + offsetX, baseY + offsetY), Offset(otherX, otherY), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
