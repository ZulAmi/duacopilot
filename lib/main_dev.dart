import 'dart:async';
import 'dart:io' show Platform;

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/core/monitoring/simple_monitoring_service.dart';
import 'package:duacopilot/core/theme/revolutionary_islamic_theme.dart';
import 'package:duacopilot/presentation/screens/enhanced_web_wrapper.dart';
import 'package:duacopilot/presentation/screens/revolutionary_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'firebase_options.dart';
import 'services/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase first (required for monitoring)
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      AppLogger.debug('✅ Firebase initialized successfully');
    } catch (e) {
      AppLogger.debug('⚠️  Firebase initialization failed: $e - continuing without Firebase features');
    }

    // Initialize dependency injection with platform awareness
    await di.init();

    // Initialize ad service only on supported platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await AdService.instance.initialize();
    }

    // Initialize simple monitoring system (will gracefully handle Firebase issues)
    try {
      await SimpleMonitoringService.initialize();
      await SimpleMonitoringService.trackUserAction(action: 'app_launch', category: 'dev');
      AppLogger.debug('✅ Simple monitoring system initialized');
    } catch (e) {
      AppLogger.debug('⚠️  Monitoring initialization failed: $e - continuing without monitoring');
    }

    AppLogger.debug('✅ DuaCopilot Revolutionary Islamic AI initialized successfully');
  } catch (e) {
    AppLogger.debug('⚠️  DuaCopilot initialization error: $e');
    // Continue anyway with limited functionality
  }

  runApp(const ProviderScope(child: RevolutionaryDuaCopilotDevApp()));
}

/// Revolutionary Development Version with Next-Generation Islamic UI/UX
class RevolutionaryDuaCopilotDevApp extends StatelessWidget {
  const RevolutionaryDuaCopilotDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Track screen view
    SimpleMonitoringService.trackScreenView('RevolutionaryHome');

    return MaterialApp(
      title: 'DuaCopilot Dev - Revolutionary Islamic AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: RevolutionaryIslamicTheme.revolutionaryTheme,
      home: const RevolutionaryAppWrapper(),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: RevolutionaryIslamicTheme.backgroundSecondary,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Ensure text scaling is reasonable for Islamic content
              textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
            ),
            child: child!,
          ),
        );
      },
    );
  }
}

/// App wrapper that handles splash screen and main navigation with revolutionary styling
class RevolutionaryAppWrapper extends StatefulWidget {
  const RevolutionaryAppWrapper({super.key});

  @override
  State<RevolutionaryAppWrapper> createState() => _RevolutionaryAppWrapperState();
}

class _RevolutionaryAppWrapperState extends State<RevolutionaryAppWrapper> with SingleTickerProviderStateMixin {
  bool _showSplash = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: RevolutionaryIslamicTheme.animationExtraSlow, vsync: this);

    // Auto-complete splash after 3 seconds
    Timer(const Duration(seconds: 3), _onSplashComplete);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSplashComplete() {
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Use enhanced web wrapper for web platform - this ensures identical hamburger menu
      return const EnhancedWebAppWrapper();
    }

    // Use revolutionary splash screen for native platforms
    if (_showSplash) {
      return Container(
        decoration: BoxDecoration(gradient: RevolutionaryIslamicTheme.heroGradient),
        child: Center(
          child: FadeTransition(
            opacity: _animationController,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space8),
                    decoration: BoxDecoration(
                      color: RevolutionaryIslamicTheme.backgroundSecondary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(RevolutionaryIslamicTheme.radius3Xl),
                      boxShadow: RevolutionaryIslamicTheme.shadowXl,
                    ),
                    child: const Icon(Icons.mosque_rounded, size: 80, color: RevolutionaryIslamicTheme.primaryEmerald),
                  ),
                  const SizedBox(height: RevolutionaryIslamicTheme.space8),
                  Text(
                    'DuaCopilot',
                    style: RevolutionaryIslamicTheme.display1.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: RevolutionaryIslamicTheme.space2),
                  Text(
                    'Revolutionary Islamic AI Assistant',
                    style: RevolutionaryIslamicTheme.body1.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: RevolutionaryIslamicTheme.space8),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(RevolutionaryIslamicTheme.textOnColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Show the revolutionary home screen
    return const RevolutionaryHomeScreen();
  }
}
