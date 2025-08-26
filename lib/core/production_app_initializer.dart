// lib/core/production_app_initializer.dart

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../firebase_options.dart';
import 'deployment/deployment_config_service.dart';
import 'feature_flags/feature_flag_service.dart';
import 'feedback/user_feedback_service.dart';
import 'monitoring/production_analytics.dart';
import 'monitoring/production_crash_reporter.dart';
import 'monitoring/production_performance_monitor.dart';

/// Production App Initializer
class ProductionAppInitializer {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static late FeatureFlagService _featureFlagService;

  /// Initialize all production services
  static Future<void> initialize() async {
    if (_isInitialized) return;

    final initStopwatch = Stopwatch()..start();

    try {
      _logger.i('Starting production app initialization...');

      // 1. Initialize Firebase Core
      await _initializeFirebase();

      // 2. Initialize Crash Reporting (must be early)
      await _initializeCrashReporting();

      // 3. Initialize Deployment Configuration
      await _initializeDeploymentConfig();

      // 4. Initialize Feature Flags
      await _initializeFeatureFlags();

      // 5. Initialize Analytics
      await _initializeAnalytics();

      // 6. Initialize Performance Monitoring
      await _initializePerformanceMonitoring();

      // 7. Initialize User Feedback Service
      await _initializeUserFeedbackService();

      // 8. Validate all services
      await _validateServices();

      initStopwatch.stop();
      _isInitialized = true;

      _logger.i(
        'Production app initialization completed in ${initStopwatch.elapsedMilliseconds}ms',
      );

      // Track successful initialization
      await ProductionAnalytics.trackEvent('app_initialization_completed', {
        'duration_ms': initStopwatch.elapsedMilliseconds,
        'environment': DeploymentConfigService.config.environment.name,
        'platform': Platform.operatingSystem,
        'debug_mode': kDebugMode,
      });
    } catch (e, stackTrace) {
      initStopwatch.stop();
      _logger.e(
        'Failed to initialize production app',
        error: e,
        stackTrace: stackTrace,
      );

      // Still record the error even if crash reporting isn't fully initialized
      try {
        await ProductionCrashReporter.recordError(
          e,
          stackTrace,
          context: 'ProductionAppInitializer.initialize',
          severity: CrashSeverity.critical,
        );
      } catch (crashReportError) {
        _logger.e(
          'Failed to record initialization error',
          error: crashReportError,
        );
      }

      rethrow;
    }
  }

  static Future<void> _initializeFirebase() async {
    try {
      _logger.i('Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _logger.i('Firebase initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize Firebase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static Future<void> _initializeCrashReporting() async {
    try {
      _logger.i('Initializing crash reporting...');
      await ProductionCrashReporter.initialize();
      _logger.i('Crash reporting initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize crash reporting',
        error: e,
        stackTrace: stackTrace,
      );
      // Don't rethrow - continue without crash reporting if necessary
    }
  }

  static Future<void> _initializeDeploymentConfig() async {
    try {
      _logger.i('Initializing deployment configuration...');
      await DeploymentConfigService.initialize();
      _logger.i('Deployment configuration initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize deployment config',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'DeploymentConfig.initialize',
      );
      rethrow;
    }
  }

  static Future<void> _initializeFeatureFlags() async {
    try {
      _logger.i('Initializing feature flags...');
      _featureFlagService = await FeatureFlagService.initialize();
      _logger.i('Feature flags initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize feature flags',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'FeatureFlags.initialize',
      );
      // Continue without feature flags if necessary
    }
  }

  static Future<void> _initializeAnalytics() async {
    try {
      if (DeploymentConfigService.config.enableAnalytics) {
        _logger.i('Initializing analytics...');
        await ProductionAnalytics.initialize();
        _logger.i('Analytics initialized successfully');
      } else {
        _logger.i('Analytics disabled in configuration');
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize analytics',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'Analytics.initialize',
      );
      // Continue without analytics if necessary
    }
  }

  static Future<void> _initializePerformanceMonitoring() async {
    try {
      if (DeploymentConfigService.config.enablePerformanceMonitoring) {
        _logger.i('Initializing performance monitoring...');
        await ProductionPerformanceMonitor.initialize();
        _logger.i('Performance monitoring initialized successfully');
      } else {
        _logger.i('Performance monitoring disabled in configuration');
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize performance monitoring',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'PerformanceMonitor.initialize',
      );
      // Continue without performance monitoring if necessary
    }
  }

  static Future<void> _initializeUserFeedbackService() async {
    try {
      _logger.i('Initializing user feedback service...');
      await UserFeedbackService.initialize();
      _logger.i('User feedback service initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize user feedback service',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'UserFeedbackService.initialize',
      );
      // Continue without feedback service if necessary
    }
  }

  static Future<void> _validateServices() async {
    try {
      _logger.i('Validating production services...');

      final validationResults = <String, bool>{
        'deployment_config':
            await DeploymentConfigService.validateConfiguration(),
        'feature_flags': _isFeatureFlagsHealthy(),
        'analytics': _isAnalyticsHealthy(),
        'performance_monitor': _isPerformanceMonitorHealthy(),
        'crash_reporting': await ProductionCrashReporter.isCrashlyticsEnabled(),
      };

      final failedServices =
          validationResults.entries
              .where((entry) => !entry.value)
              .map((entry) => entry.key)
              .toList();

      if (failedServices.isNotEmpty) {
        _logger.w(
          'Some services failed validation: ${failedServices.join(', ')}',
        );

        // Track service validation issues
        await ProductionAnalytics.trackEvent('service_validation_issues', {
          'failed_services': failedServices,
          'total_services': validationResults.length,
        });
      } else {
        _logger.i('All production services validated successfully');
      }
    } catch (e, stackTrace) {
      _logger.e('Service validation failed', error: e, stackTrace: stackTrace);
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'ServiceValidation',
      );
    }
  }

  static bool _isFeatureFlagsHealthy() {
    try {
      return _featureFlagService.config.ragSystemEnabled;
    } catch (e) {
      return false;
    }
  }

  static bool _isAnalyticsHealthy() {
    try {
      return ProductionAnalytics.sessionId != null;
    } catch (e) {
      return false;
    }
  }

  static bool _isPerformanceMonitorHealthy() {
    try {
      final stats = ProductionPerformanceMonitor.getPerformanceStats();
      return stats['monitoring_enabled'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Get initialization status
  static bool get isInitialized => _isInitialized;

  /// Get feature flag service
  static FeatureFlagService get featureFlags => _featureFlagService;

  /// Get production services status
  static Map<String, dynamic> getServicesStatus() {
    return {
      'initialized': _isInitialized,
      'deployment_config': DeploymentConfigService.getDeploymentInfo(),
      'performance_monitor': ProductionPerformanceMonitor.getPerformanceStats(),
      'analytics_session': ProductionAnalytics.sessionId,
      'environment': DeploymentConfigService.config.environment.name,
    };
  }

  /// Cleanup resources on app termination
  static Future<void> cleanup() async {
    try {
      _logger.i('Cleaning up production services...');

      // Flush any pending analytics
      await ProductionAnalytics.endSession();

      // Flush performance metrics
      await ProductionPerformanceMonitor.flushMetrics();

      // Dispose services
      ProductionPerformanceMonitor.dispose();
      DeploymentConfigService.dispose();
      _featureFlagService.dispose();

      _logger.i('Production services cleanup completed');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to cleanup production services',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Production-ready Riverpod providers
final productionAppInitializerProvider = Provider<ProductionAppInitializer>((
  ref,
) {
  return ProductionAppInitializer();
});

final deploymentConfigProvider = Provider<DeploymentConfigService>((ref) {
  if (!ProductionAppInitializer.isInitialized) {
    throw StateError('ProductionAppInitializer not initialized');
  }
  return DeploymentConfigService();
});

// Update the existing feature flag provider to use initialized service
final featureFlagServiceProvider = Provider<FeatureFlagService>((ref) {
  if (!ProductionAppInitializer.isInitialized) {
    throw StateError('ProductionAppInitializer not initialized');
  }
  return ProductionAppInitializer.featureFlags;
});

/// Production app state provider
final productionAppStateProvider = StreamProvider<Map<String, dynamic>>((
  ref,
) async* {
  while (true) {
    yield ProductionAppInitializer.getServicesStatus();
    await Future.delayed(
      const Duration(seconds: 30),
    ); // Update every 30 seconds
  }
});

/// App lifecycle observer for production monitoring
class ProductionAppLifecycleObserver extends WidgetsBindingObserver {
  static final Logger _logger = Logger();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      case AppLifecycleState.inactive:
        // Handle inactive state if needed
        break;
      case AppLifecycleState.hidden:
        // Handle hidden state if needed
        break;
    }
  }

  void _handleAppResumed() {
    _logger.i('App resumed');

    // Update feature flags when app resumes
    if (ProductionAppInitializer.isInitialized) {
      ProductionAppInitializer.featureFlags.refreshConfig();
      DeploymentConfigService.updateFromRemoteConfig();
    }

    // Track app foreground
    ProductionAnalytics.trackEvent(AnalyticsEvent.appForeground, {
      'session_duration': ProductionAnalytics.sessionDuration.inSeconds,
    });
  }

  void _handleAppPaused() {
    _logger.i('App paused');

    // Track app background
    ProductionAnalytics.trackEvent(AnalyticsEvent.appBackground, {
      'session_duration': ProductionAnalytics.sessionDuration.inSeconds,
    });

    // Flush analytics and performance data
    ProductionPerformanceMonitor.flushMetrics();
  }

  void _handleAppDetached() {
    _logger.i('App detached');

    // Cleanup services when app is completely closed
    ProductionAppInitializer.cleanup();
  }
}

/// Production-ready app wrapper widget
class ProductionAppWrapper extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onInitializationError;

  const ProductionAppWrapper({
    super.key,
    required this.child,
    this.onInitializationError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(productionAppStateProvider);

    return appState.when(
      data: (state) {
        if (!ProductionAppInitializer.isInitialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Initializing DuaCopilot...'),
                  ],
                ),
              ),
            ),
          );
        }

        // Add lifecycle observer
        WidgetsBinding.instance.addObserver(ProductionAppLifecycleObserver());

        return child;
      },
      loading:
          () => const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading production services...'),
                  ],
                ),
              ),
            ),
          ),
      error: (error, stackTrace) {
        onInitializationError?.call();

        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(error.toString()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Restart app or retry initialization
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
