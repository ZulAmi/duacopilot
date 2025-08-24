// lib/presentation/screens/ultra_modern_onboarding_screen.dart

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/ultra_modern_theme.dart';

/// Ultra-modern onboarding screen with stunning animations
class UltraModernOnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const UltraModernOnboardingScreen({super.key, this.onComplete});

  @override
  State<UltraModernOnboardingScreen> createState() => _UltraModernOnboardingScreenState();
}

class _UltraModernOnboardingScreenState extends State<UltraModernOnboardingScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _particlesController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _currentPage = 0;
  final int _totalPages = 3;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      icon: Icons.mosque_rounded,
      title: 'Your AI Islamic Companion',
      subtitle: 'Discover the power of AI-enhanced Islamic guidance and spiritual support',
      description: 'Experience personalized Duas, Quran verses, and Islamic wisdom tailored to your spiritual journey.',
      gradient: UltraModernTheme.primaryGradient,
      particleColor: const Color(0xFF0D7C66),
    ),
    OnboardingPageData(
      icon: Icons.psychology_rounded,
      title: 'Intelligent Dua Recommendations',
      subtitle: 'Smart suggestions based on your needs and context',
      description:
          'Our AI understands your spiritual needs and provides contextually relevant Duas and Islamic content.',
      gradient: UltraModernTheme.secondaryGradient,
      particleColor: const Color(0xFF41A3B3),
    ),
    OnboardingPageData(
      icon: Icons.favorite_rounded,
      title: 'Personalized Spiritual Journey',
      subtitle: 'Your path to Islamic enlightenment, tailored just for you',
      description: 'Track your progress, save favorites, and grow spiritually with personalized Islamic guidance.',
      gradient: UltraModernTheme.accentGradient,
      particleColor: const Color(0xFFE6B17A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupControllers();
  }

  void _setupControllers() {
    _pageController = PageController();
  }

  void _setupAnimations() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _particlesController = AnimationController(duration: const Duration(seconds: 5), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
    _particlesController.repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      widget.onComplete?.call();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _skipToEnd() {
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                _buildTopBar(),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _totalPages,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      _animationController.reset();
                      _animationController.forward();
                    },
                    itemBuilder: (context, index) {
                      return _buildPageContent(_pages[index]);
                    },
                  ),
                ),

                // Bottom navigation
                _buildBottomNavigation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particlesController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(gradient: _pages[_currentPage].gradient),
          child: Stack(
            children: [
              // Floating particles
              Positioned.fill(
                child: CustomPaint(
                  painter: OnboardingParticlesPainter(
                    animationValue: _particlesController.value,
                    particleColor: _pages[_currentPage].particleColor.withOpacity(0.1),
                  ),
                ),
              ),

              // Glassmorphic overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.3)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page indicator dots
          Row(
            children: List.generate(_totalPages, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                width: index == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: index == _currentPage ? Colors.white : Colors.white.withOpacity(0.4),
                ),
              );
            }),
          ),

          // Skip button
          GestureDetector(
            onTap: _skipToEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Text('Skip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(OnboardingPageData page) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: _buildAnimatedIcon(page.icon),
                ),
              ),

              const SizedBox(height: 48),

              // Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Text(
                    page.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.1,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description
              FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Text(
                    page.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.2,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedIcon(IconData icon) {
    return Container(
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
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
              ),
            ),
            child: Icon(icon, size: 60, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (_currentPage > 0)
            _buildModernButton(onPressed: _previousPage, text: 'Previous', isSecondary: true, width: 120)
          else
            const SizedBox(width: 120),

          // Next/Get Started button
          _buildModernButton(
            onPressed: _nextPage,
            text: _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
            isSecondary: false,
            width: _currentPage == _totalPages - 1 ? 150 : 120,
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required String text,
    required bool isSecondary,
    double width = 120,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient:
              isSecondary
                  ? LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)])
                  : LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.9)]),
          border: isSecondary ? Border.all(color: Colors.white.withOpacity(0.3), width: 1) : null,
          boxShadow:
              isSecondary
                  ? null
                  : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSecondary ? Colors.white : _pages[_currentPage].gradient.colors.first,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Onboarding page data model
class OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final LinearGradient gradient;
  final Color particleColor;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.particleColor,
  });
}

/// Custom painter for onboarding particles
class OnboardingParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color particleColor;

  OnboardingParticlesPainter({required this.animationValue, required this.particleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = particleColor
          ..style = PaintingStyle.fill;

    final random = math.Random(456); // Fixed seed for consistent particles

    for (int i = 0; i < 60; i++) {
      final double baseX = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 3 + 1;
      final double speed = random.nextDouble() * 0.3 + 0.2;
      final double phase = random.nextDouble() * 2 * math.pi;

      // Create floating animation
      final double offsetX = math.sin(animationValue * 2 * math.pi * speed + phase) * 30;
      final double offsetY = math.cos(animationValue * 2 * math.pi * speed * 0.8 + phase) * 20;

      // Opacity animation
      final double opacity = (math.sin(animationValue * 2 * math.pi * speed * 0.3 + phase) + 1) / 2;

      paint.color = particleColor.withOpacity(opacity * 0.6);

      canvas.drawCircle(Offset(baseX + offsetX, baseY + offsetY), radius, paint);

      // Draw connection lines between nearby particles
      if (i % 5 == 0) {
        for (int j = i + 1; j < math.min(i + 3, 60); j++) {
          final double otherX = random.nextDouble() * size.width;
          final double otherY = random.nextDouble() * size.height;

          final double distance = math.sqrt(math.pow(baseX - otherX, 2) + math.pow(baseY - otherY, 2));

          if (distance < 100) {
            final Paint linePaint =
                Paint()
                  ..color = particleColor.withOpacity((1 - distance / 100) * 0.1)
                  ..strokeWidth = 0.5
                  ..style = PaintingStyle.stroke;

            canvas.drawLine(Offset(baseX + offsetX, baseY + offsetY), Offset(otherX, otherY), linePaint);
          }
        }
      }
    }

    // Draw floating geometric shapes
    for (int i = 0; i < 8; i++) {
      final double baseX = (i * size.width / 8) + (size.width / 16);
      final double baseY = (i % 2 == 0 ? size.height * 0.3 : size.height * 0.7);
      final double size2 = 40 + (i % 3) * 20;
      final double rotation = animationValue * 2 * math.pi * (0.1 + i * 0.05);

      canvas.save();
      canvas.translate(baseX, baseY);
      canvas.rotate(rotation);

      final Path path = Path();
      if (i % 2 == 0) {
        // Draw diamond
        path.moveTo(0, -size2 / 2);
        path.lineTo(size2 / 2, 0);
        path.lineTo(0, size2 / 2);
        path.lineTo(-size2 / 2, 0);
        path.close();
      } else {
        // Draw triangle
        path.moveTo(0, -size2 / 2);
        path.lineTo(size2 / 2, size2 / 2);
        path.lineTo(-size2 / 2, size2 / 2);
        path.close();
      }

      paint.color = particleColor.withOpacity(0.05);
      canvas.drawPath(path, paint);

      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = particleColor.withOpacity(0.15);
      canvas.drawPath(path, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
