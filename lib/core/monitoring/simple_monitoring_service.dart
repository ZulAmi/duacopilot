import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../logging/app_logger.dart';

/// Simplified monitoring service that actually integrates with main app
/// Provides essential analytics and crash reporting without complexity
class SimpleMonitoringService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static bool _initialized = false;

  /// Initialize essential monitoring services
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize Crashlytics for production
      if (!kDebugMode) {
        FlutterError.onError = _crashlytics.recordFlutterError;
      }

      _initialized = true;
      AppLogger.info('📊 Simple monitoring initialized');
    } catch (e) {
      AppLogger.warning('⚠️ Simple monitoring initialization failed: $e');
      // Continue without monitoring - app should not fail
    }
  }

  /// Track RAG queries (actually used in main app)
  static Future<void> trackRagQuery({
    required String query,
    required String queryType,
    required bool success,
    Duration? processingTime,
    int? resultCount,
  }) async {
    if (!_initialized) return;

    try {
      await _analytics.logEvent(
        name: success ? 'rag_query_success' : 'rag_query_failure',
        parameters: {
          'query_type': queryType,
          'success': success,
          'query_length': query.length,
          if (processingTime != null)
            'processing_time_ms': processingTime.inMilliseconds,
          if (resultCount != null) 'result_count': resultCount,
        },
      );
    } catch (e) {
      // Silent fail - monitoring shouldn't break app
      if (kDebugMode) {
        AppLogger.debug('Analytics tracking failed: $e');
      }
    }
  }

  /// Track screen navigation (actually useful for understanding user flow)
  static Future<void> trackScreenView(String screenName) async {
    if (!_initialized) return;

    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      // Silent fail
      if (kDebugMode) {
        AppLogger.debug('Screen view tracking failed: $e');
      }
    }
  }

  /// Record crashes and errors (essential for app health)
  static void recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    try {
      _crashlytics.recordError(
        exception,
        stackTrace,
        reason: context,
        information:
            additionalData?.entries
                .map((e) => '${e.key}: ${e.value}')
                .toList() ??
            [],
      );
    } catch (e) {
      // Silent fail - crash reporting shouldn't crash the app
      if (kDebugMode) {
        AppLogger.debug('Error recording failed: $e');
      }
    }
  }

  /// Track user actions (simple event tracking)
  static Future<void> trackUserAction({
    required String action,
    String? category,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_initialized) return;

    try {
      await _analytics.logEvent(
        name: 'user_action',
        parameters: {
          'action': action,
          if (category != null) 'category': category,
          ...?parameters,
        },
      );
    } catch (e) {
      // Silent fail
      if (kDebugMode) {
        AppLogger.debug('User action tracking failed: $e');
      }
    }
  }

  /// Set user properties for analytics
  static Future<void> setUserProperty(String name, String value) async {
    if (!_initialized) return;

    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      // Silent fail
      if (kDebugMode) {
        AppLogger.debug('User property setting failed: $e');
      }
    }
  }

  /// Check if monitoring is available
  static bool get isInitialized => _initialized;
}
