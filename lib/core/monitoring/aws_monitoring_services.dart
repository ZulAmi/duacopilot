// AWS Monitoring Services
// Replaces Firebase-based monitoring with AWS CloudWatch integration

import 'package:flutter/material.dart';

import '../../services/aws_services.dart';
import '../logging/app_logger.dart';

/// Simple monitoring service using AWS instead of Firebase
class AWSSimpleMonitoringService {
  static bool _isInitialized = false;

  /// Initialize monitoring service
  static Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      // Initialize AWS Remote Config for monitoring configuration
      await AWSRemoteConfigService.fetchAndActivate();

      _isInitialized = true;
      AppLogger.debug('✅ AWS Simple Monitoring initialized');
    } catch (e) {
      AppLogger.error('AWS Simple Monitoring initialization failed: $e');
      rethrow;
    }
  }

  /// Track user action (replaces Firebase Analytics)
  static Future<void> trackUserAction({
    required String action,
    required String category,
    Map<String, Object>? properties,
  }) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: action,
        parameters: {
          'category': category,
          ...?properties,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to track user action: $e');
    }
  }

  /// Record error (replaces Firebase Crashlytics)
  static Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await AWSCrashReportingService.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      AppLogger.error('Failed to record error: $e');
    }
  }

  /// Log custom message
  static Future<void> log(String message) async {
    try {
      await AWSCrashReportingService.log(message);
    } catch (e) {
      AppLogger.error('Failed to log message: $e');
    }
  }

  /// Set user property
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await AWSAnalyticsService.setUserProperty(name: name, value: value);
    } catch (e) {
      AppLogger.error('Failed to set user property: $e');
    }
  }
}

/// Comprehensive monitoring service using AWS
class AWSComprehensiveMonitoringService {
  static bool _isInitialized = false;

  /// Initialize comprehensive monitoring
  static Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      await AWSSimpleMonitoringService.initialize();

      _isInitialized = true;
      AppLogger.debug('✅ AWS Comprehensive Monitoring initialized');
    } catch (e) {
      AppLogger.error('AWS Comprehensive Monitoring initialization failed: $e');
      rethrow;
    }
  }

  /// Track screen view
  static Future<void> trackScreenView(String screenName) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: 'screen_view',
        parameters: {
          'screen_name': screenName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to track screen view: $e');
    }
  }

  /// Track custom event
  static Future<void> trackEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await AWSAnalyticsService.logEvent(name: name, parameters: parameters);
    } catch (e) {
      AppLogger.error('Failed to track custom event: $e');
    }
  }

  /// Track performance metric
  static AWSTrace startPerformanceTrace(String name) {
    return AWSPerformanceService.trace(name);
  }

  /// Record application error
  static Future<void> recordApplicationError(
    String error,
    StackTrace stackTrace, {
    Map<String, dynamic>? context,
  }) async {
    try {
      await AWSCrashReportingService.recordError(
        error,
        stackTrace,
        reason: 'Application Error',
        fatal: false,
      );

      // Also log as analytics event
      await AWSAnalyticsService.logEvent(
        name: 'application_error',
        parameters: {
          'error': error,
          'context': context?.toString() ?? 'No context',
        },
      );
    } catch (e) {
      AppLogger.error('Failed to record application error: $e');
    }
  }
}

/// Production monitoring dashboard using AWS
class AWSProductionMonitoringDashboard {
  static bool _isInitialized = false;

  /// Initialize production monitoring dashboard
  static Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      await AWSComprehensiveMonitoringService.initialize();

      _isInitialized = true;
      AppLogger.debug('✅ AWS Production Monitoring Dashboard initialized');
    } catch (e) {
      AppLogger.error('AWS Production Monitoring Dashboard initialization failed: $e');
      rethrow;
    }
  }

  /// Get monitoring metrics
  static Future<Map<String, dynamic>> getMetrics() async {
    try {
      // This would integrate with AWS CloudWatch to fetch real metrics
      // For now, return mock data structure
      return {
        'users': {
          'daily_active': 0,
          'monthly_active': 0,
          'total': 0,
        },
        'performance': {
          'avg_response_time': 0.0,
          'error_rate': 0.0,
          'uptime': 100.0,
        },
        'features': {
          'dua_searches': 0,
          'audio_plays': 0,
          'favorites_added': 0,
        },
        'system': {
          'memory_usage': 0.0,
          'cpu_usage': 0.0,
          'network_requests': 0,
        },
      };
    } catch (e) {
      AppLogger.error('Failed to get monitoring metrics: $e');
      return {};
    }
  }

  /// Record system metric
  static Future<void> recordSystemMetric({
    required String name,
    required double value,
    String? unit,
    Map<String, String>? dimensions,
  }) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: 'system_metric',
        parameters: {
          'metric_name': name,
          'value': value,
          'unit': unit ?? 'Count',
          'dimensions': dimensions?.toString() ?? '{}',
        },
      );
    } catch (e) {
      AppLogger.error('Failed to record system metric: $e');
    }
  }

  /// Record user interaction
  static Future<void> recordUserInteraction({
    required String action,
    required String component,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: 'user_interaction',
        parameters: {
          'action': action,
          'component': component,
          'metadata': metadata?.toString() ?? '{}',
        },
      );
    } catch (e) {
      AppLogger.error('Failed to record user interaction: $e');
    }
  }
}

/// Production analytics service using AWS
class AWSProductionAnalytics {
  static bool _isInitialized = false;

  /// Initialize production analytics
  static Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      await AWSAnalyticsService.logEvent(
        name: 'analytics_initialized',
        parameters: {'platform': 'flutter'},
      );

      _isInitialized = true;
      AppLogger.debug('✅ AWS Production Analytics initialized');
    } catch (e) {
      AppLogger.error('AWS Production Analytics initialization failed: $e');
      rethrow;
    }
  }

  /// Track conversion event
  static Future<void> trackConversion({
    required String conversionName,
    double? value,
    String? currency,
    Map<String, Object>? parameters,
  }) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: 'conversion',
        parameters: {
          'conversion_name': conversionName,
          if (value != null) 'value': value,
          if (currency != null) 'currency': currency,
          ...?parameters,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to track conversion: $e');
    }
  }

  /// Track user engagement
  static Future<void> trackEngagement({
    required String engagementType,
    required int duration,
    Map<String, Object>? metadata,
  }) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: 'user_engagement',
        parameters: {
          'engagement_type': engagementType,
          'duration': duration,
          ...?metadata,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to track engagement: $e');
    }
  }

  /// Set user demographics
  static Future<void> setUserDemographics({
    String? ageGroup,
    String? gender,
    String? location,
    List<String>? interests,
  }) async {
    try {
      if (ageGroup != null) {
        await AWSAnalyticsService.setUserProperty(name: 'age_group', value: ageGroup);
      }
      if (gender != null) {
        await AWSAnalyticsService.setUserProperty(name: 'gender', value: gender);
      }
      if (location != null) {
        await AWSAnalyticsService.setUserProperty(name: 'location', value: location);
      }
      if (interests != null && interests.isNotEmpty) {
        await AWSAnalyticsService.setUserProperty(name: 'interests', value: interests.join(','));
      }
    } catch (e) {
      AppLogger.error('Failed to set user demographics: $e');
    }
  }
}

/// Production crash reporter using AWS
class AWSProductionCrashReporter {
  static bool _isInitialized = false;

  /// Initialize crash reporter
  static Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      // Set up global error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        recordFlutterError(details);
      };

      _isInitialized = true;
      AppLogger.debug('✅ AWS Production Crash Reporter initialized');
    } catch (e) {
      AppLogger.error('AWS Production Crash Reporter initialization failed: $e');
      rethrow;
    }
  }

  /// Record Flutter error
  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    try {
      await AWSCrashReportingService.recordError(
        details.exception,
        details.stack,
        reason: 'Flutter Error: ${details.library}',
        fatal: false, // Flutter errors are typically non-fatal
      );
    } catch (e) {
      AppLogger.error('Failed to record Flutter error: $e');
    }
  }

  /// Record custom error
  static Future<void> recordCustomError({
    required String error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await AWSCrashReportingService.recordError(
        error,
        stackTrace,
        reason: context,
        fatal: false,
      );

      // Also log metadata
      if (metadata != null) {
        await AWSCrashReportingService.log(
          'Error metadata: ${metadata.toString()}',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to record custom error: $e');
    }
  }
}

/// Production performance monitor using AWS
class AWSProductionPerformanceMonitor {
  static bool _isInitialized = false;

  /// Initialize performance monitor
  static Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      _isInitialized = true;
      AppLogger.debug('✅ AWS Production Performance Monitor initialized');
    } catch (e) {
      AppLogger.error('AWS Production Performance Monitor initialization failed: $e');
      rethrow;
    }
  }

  /// Start HTTP trace
  static AWSTrace startHttpTrace(String url) {
    final trace = AWSPerformanceService.trace('http_request');
    trace.putAttribute('url', url);
    return trace;
  }

  /// Start custom trace
  static AWSTrace startCustomTrace(String name) {
    return AWSPerformanceService.trace(name);
  }

  /// Record app start time
  static Future<void> recordAppStartTime(Duration startTime) async {
    try {
      await AWSAnalyticsService.logEvent(
        name: 'app_start_time',
        parameters: {
          'duration_ms': startTime.inMilliseconds,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to record app start time: $e');
    }
  }
}
