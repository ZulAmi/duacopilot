import 'package:flutter/foundation.dart';

import '../logging/app_logger.dart';
import 'aws_monitoring_services.dart';

/// Simplified monitoring service that integrates with AWS instead of Firebase
/// Provides essential analytics and crash reporting without complexity
class SimpleMonitoringService {
  static bool _initialized = false;

  /// Initialize essential monitoring services
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize AWS monitoring services
      await AWSSimpleMonitoringService.initialize();

      // Initialize crash reporting for production
      if (!kDebugMode) {
        await AWSProductionCrashReporter.initialize();
      }

      _initialized = true;
      AppLogger.info('📊 Simple monitoring initialized with AWS');
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
      await AWSSimpleMonitoringService.trackUserAction(
        action: success ? 'rag_query_success' : 'rag_query_failure',
        category: 'rag_system',
        properties: {
          'query_type': queryType,
          'success': success,
          'query_length': query.length,
          if (processingTime != null) 'processing_time_ms': processingTime.inMilliseconds,
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
      await AWSComprehensiveMonitoringService.trackScreenView(screenName);
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
      AWSSimpleMonitoringService.recordError(
        exception,
        stackTrace,
        reason: context,
        fatal: false,
      );

      // Also log additional data if provided
      if (additionalData != null) {
        final contextString = additionalData.entries.map((e) => '${e.key}: ${e.value}').join(', ');
        AWSSimpleMonitoringService.log('Error context: $contextString');
      }
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
      await AWSSimpleMonitoringService.trackUserAction(
        action: action,
        category: category ?? 'user_interaction',
        properties: parameters?.cast<String, Object>(),
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
      await AWSSimpleMonitoringService.setUserProperty(name: name, value: value);
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
