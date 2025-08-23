import 'dart:io' show Platform;

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/core/theme/modern_islamic_theme.dart';
import 'package:duacopilot/presentation/screens/modern_search_screen.dart';
import 'package:duacopilot/presentation/screens/modern_splash_screen.dart';
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

    AppLogger.debug('✅ DuaCopilot Modern UI initialized successfully');
  } catch (e) {
    AppLogger.debug('⚠️  DuaCopilot initialization error: $e');
    // Continue anyway with limited functionality
  }

  runApp(const ProviderScope(child: ModernDuaCopilotApp()));
}

/// Modern, award-winning DuaCopilot app with stunning UI/UX
class ModernDuaCopilotApp extends StatelessWidget {
  const ModernDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot - Modern Islamic AI Companion',
      debugShowCheckedModeBanner: false,

      // Apply our beautiful modern Islamic theme
      theme: ModernIslamicTheme.lightTheme,
      darkTheme: ModernIslamicTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Use modern app wrapper with splash screen
      home: const ModernAppWrapper(),

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
class ModernAppWrapper extends StatefulWidget {
  const ModernAppWrapper({super.key});

  @override
  State<ModernAppWrapper> createState() => _ModernAppWrapperState();
}

class _ModernAppWrapperState extends State<ModernAppWrapper> {
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

    // Show the beautiful modern search screen
    return _buildMainScreen();
  }

  Widget _buildMainScreen() {
    if (kIsWeb) {
      return const WebSafeLandingScreen();
    }

    // Mobile/Desktop main screen with full modern features
    return const ModernSearchScreen(enableVoiceSearch: true, enableArabicKeyboard: true, showSearchHistory: true);
  }
}

/// Web-safe landing screen for browsers
class WebSafeLandingScreen extends StatelessWidget {
  const WebSafeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF1B5E20).withOpacity(0.1), const Color(0xFF2E7D32).withOpacity(0.2)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque, size: 80, color: Color(0xFF1B5E20)),
              SizedBox(height: 24),
              Text('DuaCopilot', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
              SizedBox(height: 16),
              Text('Modern Islamic AI Companion', style: TextStyle(fontSize: 18, color: Color(0xFF2E7D32))),
              SizedBox(height: 32),
              CircularProgressIndicator(color: Color(0xFF4CAF50)),
              SizedBox(height: 16),
              Text('Loading modern experience...', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),
        ),
      ),
    );
  }
}
