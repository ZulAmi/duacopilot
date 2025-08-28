// lib/core/monitoring/production_crash_reporter.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Crash Severity Levels
enum CrashSeverity { low, medium, high, critical }

/// Custom Exception Types
class RagException implements Exception {
  final String message;
  final String? queryId;
  final Map<String, dynamic>? context;

  const RagException(this.message, {this.queryId, this.context});

  @override
  String toString() => 'RagException: $message${queryId != null ? ' (Query: $queryId)' : ''}';
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;

  const NetworkException(this.message, {this.statusCode, this.endpoint});

  @override
  String toString() => 'NetworkException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ValidationException implements Exception {
  final String message;
  final String? field;
  final dynamic value;

  const ValidationException(this.message, {this.field, this.value});

  @override
  String toString() => 'ValidationException: $message${field != null ? ' (Field: $field)' : ''}';
}

class PerformanceException implements Exception {
  final String message;
  final Duration? executionTime;
  final String? operationType;

  const PerformanceException(
    this.message, {
    this.executionTime,
    this.operationType,
  });

  @override
  String toString() => 'PerformanceException: $message${operationType != null ? ' (Operation: $operationType)' : ''}';
}

/// Production Crash Reporter
class ProductionCrashReporter {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static PackageInfo? _packageInfo;
  static SharedPreferences? _prefs;

  static const String _crashCountKey = 'crash_count';
  static const String _lastCrashKey = 'last_crash_timestamp';
  static const String _crashReportsKey = 'cached_crash_reports';

  /// Initialize crash reporting
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _prefs = await SharedPreferences.getInstance();

      // Crashlytics removed - collection toggle skipped

      // Set up Flutter error handling
      _setupFlutterErrorHandling();

      // Set up zone error handling
      _setupZoneErrorHandling();

      // Set custom keys
      await _setCustomKeys();

      // Process any cached crash reports
      await _processCachedCrashReports();

      _isInitialized = true;
      _logger.i('ProductionCrashReporter initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize ProductionCrashReporter',
        error: e,
        stackTrace: stackTrace,
      );
      // Can't use crashlytics here as it's not initialized
    }
  }

  static void _setupFlutterErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log to console in debug mode
      if (kDebugMode) {
        FlutterError.presentError(details);
      }

      // Crashlytics removed - would send fatal flutter error here

      // Track crash analytics
      _trackCrashAnalytics('flutter_error', details.exception, details.stack);

      // Cache crash report for offline scenarios
      _cacheCrashReport(
        'flutter_error',
        details.exception.toString(),
        details.stack,
      );
    };
  }

  static void _setupZoneErrorHandling() {
    PlatformDispatcher.instance.onError = (error, stack) {
      // Log to console in debug mode
      if (kDebugMode) {
        _logger.e('Zone error caught', error: error, stackTrace: stack);
      }

      // Crashlytics removed - would send zone error here

      // Track crash analytics
      _trackCrashAnalytics('zone_error', error, stack);

      // Cache crash report
      _cacheCrashReport('zone_error', error.toString(), stack);

      return true;
    };
  }

  static Future<void> _setCustomKeys() async {
    try {
      // Custom key collection removed
    } catch (e) {
      _logger.w('Failed to set custom keys', error: e);
    }
  }

  /// Record an error with context
  static Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
    CrashSeverity severity = CrashSeverity.medium,
    bool fatal = false,
  }) async {
    try {
      // Set context-specific custom keys
      // Collect minimal local context only (no external service)

      // Track in analytics
      _trackCrashAnalytics(
        'recorded_error',
        error,
        stackTrace,
        context: context,
      );

      // Cache for offline scenarios
      _cacheCrashReport(
        'recorded_error',
        error.toString(),
        stackTrace,
        context: context,
        additionalData: additionalData,
      );

      // Update crash statistics
      await _updateCrashStatistics();

      _logger.w('Error recorded: $error', error: error, stackTrace: stackTrace);
    } catch (e, stack) {
      _logger.e(
        'Failed to record error to crashlytics',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Record RAG-specific error
  static Future<void> recordRagError(
    RagException ragError,
    StackTrace? stackTrace, {
    String? queryText,
    Duration? queryDuration,
    Map<String, dynamic>? ragContext,
  }) async {
    final context = <String, dynamic>{
      'query_id': ragError.queryId,
      'query_text': queryText?.substring(0, 100), // Truncate for privacy
      'query_duration_ms': queryDuration?.inMilliseconds,
      'rag_context': ragContext,
      ...?ragError.context,
    };

    await recordError(
      ragError,
      stackTrace,
      context: 'rag_system',
      additionalData: context,
      severity: CrashSeverity.high,
    );
  }

  /// Record network error
  static Future<void> recordNetworkError(
    NetworkException networkError,
    StackTrace? stackTrace, {
    Map<String, String>? headers,
    String? requestBody,
    Duration? requestDuration,
  }) async {
    final context = <String, dynamic>{
      'status_code': networkError.statusCode,
      'endpoint': networkError.endpoint,
      'headers': headers?.keys.join(
        ', ',
      ), // Don't log header values for security
      'request_body_length': requestBody?.length,
      'request_duration_ms': requestDuration?.inMilliseconds,
    };

    await recordError(
      networkError,
      stackTrace,
      context: 'network',
      additionalData: context,
      severity: _getNetworkErrorSeverity(networkError.statusCode),
    );
  }

  /// Record performance error
  static Future<void> recordPerformanceError(
    PerformanceException performanceError,
    StackTrace? stackTrace, {
    Map<String, dynamic>? performanceMetrics,
  }) async {
    final context = <String, dynamic>{
      'operation_type': performanceError.operationType,
      'execution_time_ms': performanceError.executionTime?.inMilliseconds,
      'performance_metrics': performanceMetrics,
    };

    await recordError(
      performanceError,
      stackTrace,
      context: 'performance',
      additionalData: context,
      severity: CrashSeverity.medium,
    );
  }

  /// Log custom message
  static Future<void> log(String message, {String? context}) async {
    try {
      final logMessage = context != null ? '[$context] $message' : message;
      // Crashlytics removed - log locally only
      _logger.i(logMessage);
    } catch (e) {
      _logger.w('Failed to log message to crashlytics', error: e);
    }
  }

  /// Set user identifier
  static Future<void> setUserIdentifier(String? userId) async {
    try {
      // Crashlytics removed - store user id locally only
    } catch (e) {
      _logger.w('Failed to set user identifier', error: e);
    }
  }

  /// Check if user opted in to crash reporting
  static Future<bool> isCrashlyticsEnabled() async {
    return true; // Always 'enabled' locally
  }

  /// Set crashlytics collection enabled
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    try {
      _logger.i('Crash collection flag set to $enabled (local placeholder)');
    } catch (e) {
      _logger.w('Failed to set crashlytics collection enabled', error: e);
    }
  }

  /// Get crash statistics
  static Future<Map<String, dynamic>> getCrashStatistics() async {
    try {
      final crashCount = _prefs?.getInt(_crashCountKey) ?? 0;
      final lastCrash = _prefs?.getInt(_lastCrashKey);

      return {
        'total_crashes': crashCount,
        'last_crash_timestamp': lastCrash,
        'last_crash_date': lastCrash != null
            ? DateTime.fromMillisecondsSinceEpoch(
                lastCrash,
              ).toIso8601String()
            : null,
        'crashes_this_session': 0, // Reset on app start
        'crashlytics_enabled': await isCrashlyticsEnabled(),
      };
    } catch (e) {
      _logger.w('Failed to get crash statistics', error: e);
      return {};
    }
  }

  /// Test crash reporting (debug only)
  static Future<void> testCrashReporting() async {
    if (kDebugMode) {
      try {
        await recordError(
          Exception('Test crash report'),
          StackTrace.current,
          context: 'debug_test',
          additionalData: {
            'test_type': 'manual_test',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        _logger.i('Test crash report sent');
      } catch (e) {
        _logger.w('Failed to send test crash report', error: e);
      }
    }
  }

  // Private helper methods
  static void _trackCrashAnalytics(
    String errorType,
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    // Note: This would integrate with ProductionAnalytics
    // Keeping it simple to avoid circular dependencies
    if (kDebugMode) {
      _logger.d('Crash analytics: $errorType - ${error.toString()}');
    }
  }

  static Future<void> _cacheCrashReport(
    String errorType,
    String errorMessage,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final crashReports = _prefs?.getStringList(_crashReportsKey) ?? [];

      final crashReport = json.encode({
        'error_type': errorType,
        'error_message': errorMessage,
        'stack_trace': stackTrace.toString(),
        'context': context,
        'additional_data': additionalData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'app_version': _packageInfo?.version,
        'platform': Platform.operatingSystem,
      });

      crashReports.add(crashReport);

      // Keep only last 10 crash reports
      if (crashReports.length > 10) {
        crashReports.removeAt(0);
      }

      await _prefs?.setStringList(_crashReportsKey, crashReports);
    } catch (e) {
      _logger.w('Failed to cache crash report', error: e);
    }
  }

  static Future<void> _processCachedCrashReports() async {
    try {
      final crashReports = _prefs?.getStringList(_crashReportsKey) ?? [];

      if (crashReports.isNotEmpty) {
        _logger.i('Processing ${crashReports.length} cached crash reports');

        for (final reportJson in crashReports) {
          try {
            final report = json.decode(reportJson) as Map<String, dynamic>;

            // Process the cached report
            await log(
              'Cached crash: ${report['error_type']} - ${report['error_message']}',
            );
          } catch (e) {
            _logger.w('Failed to process cached crash report', error: e);
          }
        }

        // Clear processed reports
        await _prefs?.remove(_crashReportsKey);
        _logger.i('Cached crash reports processed and cleared');
      }
    } catch (e) {
      _logger.w('Failed to process cached crash reports', error: e);
    }
  }

  static Future<void> _updateCrashStatistics() async {
    try {
      final currentCount = _prefs?.getInt(_crashCountKey) ?? 0;
      await _prefs?.setInt(_crashCountKey, currentCount + 1);
      await _prefs?.setInt(
        _lastCrashKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      _logger.w('Failed to update crash statistics', error: e);
    }
  }

  static CrashSeverity _getNetworkErrorSeverity(int? statusCode) {
    if (statusCode == null) return CrashSeverity.medium;

    if (statusCode >= 500) return CrashSeverity.high;
    if (statusCode >= 400) return CrashSeverity.medium;
    return CrashSeverity.low;
  }
}

/// Exception handler wrapper
class ExceptionHandler {
  static T? handleSync<T>(
    T Function() operation, {
    String? context,
    T? fallback,
    bool recordError = true,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      if (recordError) {
        ProductionCrashReporter.recordError(
          e,
          stackTrace,
          context: context ?? 'sync_operation',
        );
      }
      return fallback;
    }
  }

  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? context,
    T? fallback,
    bool recordError = true,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      if (recordError) {
        ProductionCrashReporter.recordError(
          e,
          stackTrace,
          context: context ?? 'async_operation',
        );
      }
      return fallback;
    }
  }
}

/// Global exception wrapper for widgets
class SafeWidget extends StatelessWidget {
  final Widget child;
  final Widget? errorWidget;
  final String? context;

  const SafeWidget({
    super.key,
    required this.child,
    this.errorWidget,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (error, stackTrace) {
      ProductionCrashReporter.recordError(
        error,
        stackTrace,
        context: this.context ?? 'widget_error',
      );

      return errorWidget ??
          const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            ),
          );
    }
  }
}
