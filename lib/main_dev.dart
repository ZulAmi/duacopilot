import 'dart:io' show Platform;

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/core/theme/ultra_modern_theme.dart';
import 'package:duacopilot/presentation/screens/modern_splash_screen.dart';
import 'package:duacopilot/presentation/screens/ultra_modern_search_screen.dart';
import 'package:duacopilot/presentation/screens/web_compatible_wrapper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'services/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize dependency injection with platform awareness
    await di.init();

    // Initialize ad service only on supported platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await AdService.instance.initialize();
    }

    AppLogger.debug('✅ DuaCopilot Ultra-Modern UI initialized successfully');
  } catch (e) {
    AppLogger.debug('⚠️  DuaCopilot initialization error: $e');
    // Continue anyway with limited functionality
  }

  runApp(const ProviderScope(child: UltraModernDuaCopilotDevApp()));
}

/// Ultra-Modern Development Version with Enhanced UI/UX
class UltraModernDuaCopilotDevApp extends StatelessWidget {
  const UltraModernDuaCopilotDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot Dev - Ultra Modern Islamic AI Companion',
      debugShowCheckedModeBanner: false,

      // Apply our revolutionary ultra-modern theme
      theme: UltraModernTheme.lightTheme,
      darkTheme: UltraModernTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Use ultra-modern app wrapper with splash screen
      home: const UltraModernAppWrapper(),

      // App-wide configuration for better UX
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Ensure text scaling is reasonable for Islamic content
            textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
          ),
          child: child!,
        );
      },
    );
  }
}

/// App wrapper that handles splash screen and main navigation
class UltraModernAppWrapper extends StatefulWidget {
  const UltraModernAppWrapper({super.key});

  @override
  State<UltraModernAppWrapper> createState() => _UltraModernAppWrapperState();
}

class _UltraModernAppWrapperState extends State<UltraModernAppWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Use web-compatible wrapper for web platform
      return const WebCompatibleAppWrapper();
    }

    // Use full featured splash screen for native platforms
    if (_showSplash) {
      return ModernSplashScreen(onAnimationComplete: _onSplashComplete);
    }

    // Show the ultra-modern search screen
    return _buildMainScreen();
  }

  Widget _buildMainScreen() {
    if (kIsWeb) {
      return const UltraModernWebLandingScreen();
    }

    // Desktop/Mobile main screen with ultra-modern features
    return const UltraModernSearchScreen(enableVoiceSearch: true, enableArabicKeyboard: true, showSearchHistory: true);
  }
}

/// Ultra-modern web landing screen for browsers
class UltraModernWebLandingScreen extends StatefulWidget {
  const UltraModernWebLandingScreen({super.key});

  @override
  State<UltraModernWebLandingScreen> createState() => _UltraModernWebLandingScreenState();
}

class _UltraModernWebLandingScreenState extends State<UltraModernWebLandingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _pulseController.repeat(reverse: true);

    // Auto-navigate to main screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => const UltraModernSearchScreen(
                  enableVoiceSearch: false,
                  enableArabicKeyboard: true,
                  showSearchHistory: true,
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: UltraModernTheme.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      child: const Icon(Icons.mosque, size: 80, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'DuaCopilot',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1.0),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ultra-Modern Islamic AI Companion',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 0.5),
              ),
              const SizedBox(height: 48),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value * 0.5 + 0.5,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                      child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Launching ultra-modern experience...',
                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
