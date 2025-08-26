import 'dart:async';
import 'dart:io' show Platform;

import 'package:duacopilot/core/config/app_config.dart';
import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/core/monitoring/simple_monitoring_service.dart';
import 'package:duacopilot/core/theme/professional_theme.dart';
import 'package:duacopilot/core/theme/revolutionary_islamic_theme.dart';
import 'package:duacopilot/presentation/screens/enhanced_web_wrapper.dart';
import 'package:duacopilot/presentation/screens/professional_home_screen.dart';
import 'package:duacopilot/presentation/screens/revolutionary_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/security/production_config.dart';
import 'core/security/secure_telemetry.dart';
import 'firebase_options.dart';
import 'services/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Production security validation (only in production)
    if (AppConfig.environment == AppEnvironment.production) {
      ProductionSecurityAssertion.assertProductionSecurity();
    }

    // Initialize Firebase first
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

    // Initialize monitoring system based on environment
    try {
      if (AppConfig.environment == AppEnvironment.production) {
        await SecureTelemetry.initialize();
        await SecureTelemetry.trackUserAction(
          action: 'app_launched',
          category: 'lifecycle',
          properties: ProductionConfig.getAppInfo(),
        );
      } else {
        await SimpleMonitoringService.initialize();
        await SimpleMonitoringService.trackUserAction(action: 'app_launch', category: AppConfig.environment.name);
      }
      AppLogger.debug('✅ Monitoring system initialized');
    } catch (e) {
      AppLogger.debug('⚠️  Monitoring initialization failed: $e - continuing without monitoring');
    }

    AppLogger.debug('✅ DuaCopilot Islamic AI initialized successfully');
  } catch (e) {
    AppLogger.debug('⚠️  DuaCopilot initialization error: $e');
    // Continue anyway with limited functionality
  }

  runApp(const ProviderScope(child: DuaCopilotApp()));
}

/// Unified DuaCopilot App that adapts to environment
class DuaCopilotApp extends StatelessWidget {
  const DuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppConfig.settings;
    final features = AppConfig.features;

    return MaterialApp(
      title: settings.appTitle,
      debugShowCheckedModeBanner: settings.showDebugBanner,
      theme: _buildAppTheme(features),
      home: _buildHomeScreen(features),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                features.showRevolutionaryUI
                    ? RevolutionaryIslamicTheme.backgroundSecondary
                    : ProfessionalTheme.surfaceColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Ensure text scaling is reasonable for Islamic content
              textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
            ),
            child: Stack(
              children: [
                child!,
                // Performance overlay (dev/staging only)
                if (settings.enablePerformanceOverlay)
                  Positioned(top: 50, right: 16, child: _buildPerformanceOverlay()),
                // Debug tools (dev/staging only)
                if (features.enableDebugTools) Positioned(bottom: 50, right: 16, child: _buildDebugFab()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeScreen(FeatureFlags features) {
    if (kIsWeb) {
      return const EnhancedWebAppWrapper();
    }

    // Use Revolutionary UI if feature flag is enabled
    if (features.showRevolutionaryUI) {
      return const AppWrapper(showRevolutionaryUI: true);
    }

    // Use Professional UI for production
    return const ProfessionalHomeScreen();
  }

  ThemeData _buildAppTheme(FeatureFlags features) {
    if (features.showRevolutionaryUI) {
      return RevolutionaryIslamicTheme.revolutionaryTheme;
    }
    return _buildProfessionalTheme();
  }

  ThemeData _buildProfessionalTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ProfessionalTheme.primaryEmerald,
        brightness: Brightness.light,
        primary: ProfessionalTheme.primaryEmerald,
        secondary: ProfessionalTheme.secondaryGold,
        surface: ProfessionalTheme.surfaceColor,
        background: ProfessionalTheme.backgroundColor,
        onPrimary: ProfessionalTheme.surfaceColor,
        onSecondary: ProfessionalTheme.surfaceColor,
        onSurface: ProfessionalTheme.textPrimary,
        onBackground: ProfessionalTheme.textPrimary,
      ),
      scaffoldBackgroundColor: ProfessionalTheme.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: ProfessionalTheme.surfaceColor,
        foregroundColor: ProfessionalTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      // ... rest of professional theme
    );
  }

  Widget _buildPerformanceOverlay() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
      child: const Text('🔧 DEV MODE', style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildDebugFab() {
    return FloatingActionButton(
      mini: true,
      onPressed: () {
        // Show debug info
      },
      child: const Icon(Icons.bug_report),
    );
  }
}

/// App wrapper that handles splash screen and main navigation
class AppWrapper extends StatefulWidget {
  final bool showRevolutionaryUI;

  const AppWrapper({super.key, required this.showRevolutionaryUI});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with SingleTickerProviderStateMixin {
  bool _showSplash = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration:
          widget.showRevolutionaryUI ? RevolutionaryIslamicTheme.animationExtraSlow : const Duration(milliseconds: 800),
      vsync: this,
    );

    // Auto-complete splash after 3 seconds (or shorter for production)
    final splashDuration =
        AppConfig.environment == AppEnvironment.production ? const Duration(seconds: 2) : const Duration(seconds: 3);

    Timer(splashDuration, _onSplashComplete);
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
    if (_showSplash) {
      return _buildSplashScreen();
    }

    // Show the appropriate home screen
    return widget.showRevolutionaryUI ? const RevolutionaryHomeScreen() : const ProfessionalHomeScreen();
  }

  Widget _buildSplashScreen() {
    if (widget.showRevolutionaryUI) {
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
                    AppConfig.settings.appTitle.split(' - ')[1],
                    style: RevolutionaryIslamicTheme.body1.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor.withOpacity(0.9),
                    ),
                  ),
                  if (AppConfig.environment != AppEnvironment.production) ...[
                    const SizedBox(height: RevolutionaryIslamicTheme.space4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        AppConfig.environment.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
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

    // Professional splash screen
    return Scaffold(
      backgroundColor: ProfessionalTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque_rounded, size: 80, color: ProfessionalTheme.primaryEmerald),
            const SizedBox(height: 24),
            Text(
              'DuaCopilot',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ProfessionalTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              AppConfig.settings.appTitle.split(' - ')[1],
              style: TextStyle(fontSize: 16, color: ProfessionalTheme.textSecondary),
            ),
            if (AppConfig.environment != AppEnvironment.production) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  AppConfig.environment.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
