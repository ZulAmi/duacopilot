import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/screens/modern_search_screen.dart';

/// Simple web-compatible splash screen
class WebCompatibleSplashScreen extends ConsumerStatefulWidget {
  final VoidCallback onAnimationComplete;

  const WebCompatibleSplashScreen({super.key, required this.onAnimationComplete});

  @override
  ConsumerState<WebCompatibleSplashScreen> createState() => _WebCompatibleSplashScreenState();
}

class _WebCompatibleSplashScreenState extends ConsumerState<WebCompatibleSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startSimpleAnimation();
  }

  void _startSimpleAnimation() async {
    try {
      // Start fade in animation
      await _controller.forward();

      // Wait a moment
      await Future.delayed(const Duration(milliseconds: 1000));

      // Complete
      if (mounted) {
        widget.onAnimationComplete();
      }
    } catch (e) {
      debugPrint('Simple splash animation error: $e');
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
      backgroundColor: const Color(0xFF6A4C93),
      body: Center(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.mosque, size: 40, color: Color(0xFF6A4C93)),
                  ),
                  const SizedBox(height: 24),

                  // App name
                  const Text(
                    'DuaCopilot',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text('Premium Islamic AI Companion', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 48),

                  // Loading indicator
                  const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Web-compatible app wrapper
class WebCompatibleAppWrapper extends ConsumerStatefulWidget {
  const WebCompatibleAppWrapper({super.key});

  @override
  ConsumerState<WebCompatibleAppWrapper> createState() => _WebCompatibleAppWrapperState();
}

class _WebCompatibleAppWrapperState extends ConsumerState<WebCompatibleAppWrapper> {
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
      return WebCompatibleSplashScreen(onAnimationComplete: _onSplashComplete);
    }

    // Show the main search screen directly for web
    return const ModernSearchScreen(
      enableVoiceSearch: false, // Disable voice on web
      enableArabicKeyboard: true,
      showSearchHistory: true,
    );
  }
}
