import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/revolutionary_islamic_theme.dart';
import 'revolutionary_home_screen.dart';

/// Enhanced Web-Compatible Splash Screen with Professional Theme
class EnhancedWebSplashScreen extends ConsumerStatefulWidget {
  final VoidCallback onAnimationComplete;

  const EnhancedWebSplashScreen({super.key, required this.onAnimationComplete});

  @override
  ConsumerState<EnhancedWebSplashScreen> createState() => _EnhancedWebSplashScreenState();
}

class _EnhancedWebSplashScreenState extends ConsumerState<EnhancedWebSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: RevolutionaryIslamicTheme.animationMedium, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _startProfessionalAnimation();
  }

  void _startProfessionalAnimation() async {
    try {
      // Start animations
      await _controller.forward();

      // Professional loading duration
      await Future.delayed(const Duration(milliseconds: 2000));

      // Complete splash
      if (mounted) {
        widget.onAnimationComplete();
      }
    } catch (e) {
      debugPrint('Professional splash animation error: $e');
      // Immediate fallback
      if (mounted) {
        widget.onAnimationComplete();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(color: RevolutionaryIslamicTheme.backgroundPrimary),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Professional Logo Container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: RevolutionaryIslamicTheme.heroGradient,
                          borderRadius: BorderRadius.circular(RevolutionaryIslamicTheme.radius2Xl),
                          boxShadow: RevolutionaryIslamicTheme.shadowLg,
                        ),
                        child: const Icon(Icons.mosque_rounded, size: 56, color: RevolutionaryIslamicTheme.textOnColor),
                      ),

                      const SizedBox(height: RevolutionaryIslamicTheme.space8),

                      // App Name with Professional Typography
                      const Text(
                        'DuaCopilot',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: RevolutionaryIslamicTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: RevolutionaryIslamicTheme.space2),

                      // Professional Subtitle
                      const Text(
                        'Professional Islamic AI Assistant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: RevolutionaryIslamicTheme.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: RevolutionaryIslamicTheme.space8),

                      // Enhanced Loading Indicator
                      Container(
                        padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
                        decoration: BoxDecoration(
                          color: RevolutionaryIslamicTheme.backgroundSecondary,
                          borderRadius: BorderRadius.circular(RevolutionaryIslamicTheme.radiusXl),
                          boxShadow: RevolutionaryIslamicTheme.shadowMd,
                        ),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(RevolutionaryIslamicTheme.primaryEmerald),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: RevolutionaryIslamicTheme.space4),
                            Text(
                              'Loading Islamic Knowledge...',
                              style: RevolutionaryIslamicTheme.body1.copyWith(
                                color: RevolutionaryIslamicTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: RevolutionaryIslamicTheme.space8),

                      // Professional Features Preview
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: RevolutionaryIslamicTheme.space8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeaturePreview(Icons.search_rounded, 'AI Search'),
                            const SizedBox(width: RevolutionaryIslamicTheme.space8),
                            _buildFeaturePreview(Icons.menu_book_rounded, 'Quran'),
                            const SizedBox(width: RevolutionaryIslamicTheme.space8),
                            _buildFeaturePreview(Icons.mosque_rounded, 'Prayer Times'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePreview(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space2),
          decoration: BoxDecoration(
            color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1),
            borderRadius: BorderRadius.circular(RevolutionaryIslamicTheme.radiusLg),
          ),
          child: Icon(icon, color: RevolutionaryIslamicTheme.primaryEmerald, size: 20),
        ),
        const SizedBox(height: RevolutionaryIslamicTheme.space2),
        Text(label, style: RevolutionaryIslamicTheme.caption.copyWith(color: RevolutionaryIslamicTheme.textTertiary)),
      ],
    );
  }
}

/// Enhanced Web-Compatible App Wrapper - Uses Same Screen as Windows
class EnhancedWebAppWrapper extends ConsumerStatefulWidget {
  const EnhancedWebAppWrapper({super.key});

  @override
  ConsumerState<EnhancedWebAppWrapper> createState() => _EnhancedWebAppWrapperState();
}

class _EnhancedWebAppWrapperState extends ConsumerState<EnhancedWebAppWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return EnhancedWebSplashScreen(onAnimationComplete: _onSplashComplete);
    }

    // Use the SAME professional home screen as Windows for consistency
    // But with web-specific optimizations through MediaQuery
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        // Optimize for web viewing
        textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.9, 1.2)),
      ),
      child: const RevolutionaryHomeScreen(
        // Web-specific optimizations can be passed as parameters
        // or detected internally via kIsWeb
      ),
    );
  }
}

/// Web-Optimized Professional Home Screen Wrapper
class WebOptimizedProfessionalHome extends ConsumerWidget {
  const WebOptimizedProfessionalHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    // For large screens (desktop web), add side padding
    if (screenWidth > 1200) {
      return Scaffold(
        backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
        body: Center(
          child: Container(constraints: const BoxConstraints(maxWidth: 1200), child: const RevolutionaryHomeScreen()),
        ),
      );
    }

    // For smaller screens, use full width
    return const RevolutionaryHomeScreen();
  }
}
