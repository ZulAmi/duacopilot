import 'dart:io' show Platform;

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/core/monitoring/simple_monitoring_service.dart';
import 'package:duacopilot/core/theme/professional_theme.dart';
import 'package:duacopilot/presentation/screens/revolutionary_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'services/ads/ad_service.dart';
import 'services/aws_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize AWS services (all platforms supported)
    try {
      await AWSRemoteConfigService.fetchAndActivate();
      AppLogger.debug('✅ AWS services initialized successfully');
    } catch (e) {
      AppLogger.debug(
        '⚠️ AWS initialization failed: $e - continuing with default configuration',
      );
    }

    // Initialize dependency injection with platform awareness
    await di.init();

    // Initialize ad service only on supported platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await AdService.instance.initialize();
    }

    // Initialize simple monitoring system (uses AWS services)
    try {
      await SimpleMonitoringService.initialize();
      await SimpleMonitoringService.trackUserAction(
        action: 'app_launch',
        category: Platform.isWindows ? 'windows_dev' : 'dev',
      );
      AppLogger.debug('✅ Simple monitoring system initialized');
    } catch (e) {
      AppLogger.debug('⚠️ Monitoring initialization failed: $e');
    }

    // Set preferred orientations for mobile platforms
    if (!kIsWeb && !Platform.isWindows) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    AppLogger.info('🚀 DuaCopilot Development App Starting...');

    runApp(const ProviderScope(child: ProfessionalDuaCopilotDevApp()));
  } catch (e, stackTrace) {
    AppLogger.error('💥 Critical error during app initialization', e, stackTrace);

    // Show error dialog and still try to start the app
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.red.shade50,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Initialization Error',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The app encountered an error during startup but will try to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      runApp(const ProviderScope(child: ProfessionalDuaCopilotDevApp()));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Professional DuaCopilot Development App with Windows compatibility
class ProfessionalDuaCopilotDevApp extends StatelessWidget {
  const ProfessionalDuaCopilotDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DuaCopilot - Islamic AI Assistant (Dev)',
      theme: ProfessionalTheme.lightTheme,
      darkTheme: ProfessionalTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Use different home screen based on platform
      home: _getHomeScreen(),

      builder: (context, child) {
        // Enhanced error handling
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          AppLogger.error(
            'Widget Error: ${errorDetails.exception}',
            errorDetails.exception,
            errorDetails.stack,
          );

          return Scaffold(
            backgroundColor: Colors.red.shade50,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please restart the app',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                  ],
                ),
              ),
            ),
          );
        };

        return child ?? const SizedBox.shrink();
      },
    );
  }

  Widget _getHomeScreen() {
    // Platform-specific home screen selection
    if (kIsWeb) {
      return const RevolutionaryHomeScreen();
    } else if (Platform.isWindows) {
      // Windows-specific home screen with limited features
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mosque,
                  size: 64,
                  color: Color(0xFF0F5132),
                ),
                SizedBox(height: 16),
                Text(
                  'DuaCopilot',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F5132),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Islamic AI Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF0F5132),
                          size: 32,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Windows Development Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F5132),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Running with limited features for compatibility.\nFull features available on mobile and web.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Mobile platforms
      return const RevolutionaryHomeScreen();
    }
  }
}
