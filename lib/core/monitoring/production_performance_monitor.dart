// lib/core/monitoring/production_performance_monitor.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'production_analytics.dart';
import 'production_crash_reporter.dart';

/// Performance Metrics
class PerformanceMetrics {
  final String operationType;
  final Duration duration;
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic> attributes;
  final DateTime timestamp;

  PerformanceMetrics({
    required this.operationType,
    required this.duration,
    required this.success,
    this.errorMessage,
    this.attributes = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'operation_type': operationType,
      'duration_ms': duration.inMilliseconds,
      'success': success,
      'error_message': errorMessage,
      'attributes': attributes,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

/// RAG Query Performance Tracker
class RagPerformanceTracker {
  final String queryId;
  final Trace _trace;
  final Stopwatch _stopwatch;
  final Map<String, dynamic> _attributes = {};

  bool _isCompleted = false;

  RagPerformanceTracker._(this.queryId, this._trace, this._stopwatch);

  static Future<RagPerformanceTracker> start(String queryId) async {
    final trace = FirebasePerformance.instance.newTrace('rag_query');
    await trace.start();

    final stopwatch = Stopwatch()..start();
    final tracker = RagPerformanceTracker._(queryId, trace, stopwatch);

    tracker._attributes['query_id'] = queryId;
    tracker._attributes['start_time'] = DateTime.now().millisecondsSinceEpoch;

    return tracker;
  }

  void addAttribute(String key, String value) {
    if (!_isCompleted) {
      _attributes[key] = value;
      _trace.putAttribute(key, value);
    }
  }

  void incrementMetric(String metricName, [int value = 1]) {
    if (!_isCompleted) {
      _trace.incrementMetric(metricName, value);
    }
  }

  void setMetric(String metricName, int value) {
    if (!_isCompleted) {
      _trace.setMetric(metricName, value);
    }
  }

  Future<void> complete({
    bool success = true,
    String? errorMessage,
    int? resultCount,
    bool? cacheHit,
  }) async {
    if (_isCompleted) return;

    _stopwatch.stop();
    _isCompleted = true;

    // Set final attributes
    addAttribute('success', success.toString());
    if (errorMessage != null) addAttribute('error_message', errorMessage);
    if (resultCount != null)
      addAttribute('result_count', resultCount.toString());
    if (cacheHit != null) addAttribute('cache_hit', cacheHit.toString());

    // Set metrics
    setMetric('duration_ms', _stopwatch.elapsedMilliseconds);
    if (resultCount != null) setMetric('result_count', resultCount);

    // Stop trace
    await _trace.stop();

    // Track in analytics
    await ProductionAnalytics.trackRagQueryPerformance(
      queryId: queryId,
      duration: _stopwatch.elapsed,
      resultCount: resultCount ?? 0,
      queryType: _attributes['query_type'] ?? 'unknown',
      cacheHit: cacheHit,
      errorMessage: errorMessage,
    );
  }

  Duration get elapsed => _stopwatch.elapsed;
  bool get isCompleted => _isCompleted;
}

/// Production Performance Monitor
class ProductionPerformanceMonitor {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static SharedPreferences? _prefs;

  static const String _performanceDataKey = 'performance_metrics';
  static const String _performanceConfigKey = 'performance_config';

  static final Map<String, RagPerformanceTracker> _activeTrackers = {};
  static final List<PerformanceMetrics> _metricsBuffer = [];

  static Timer? _metricsFlushTimer;
  static final Duration _flushInterval = const Duration(minutes: 5);

  /// Initialize performance monitoring
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      // Enable performance monitoring
      await _performance.setPerformanceCollectionEnabled(true);

      // Setup automatic HTTP/HTTPS network request monitoring
      // This is automatically enabled by Firebase Performance

      // Setup metrics flushing
      _setupMetricsFlushTimer();

      // Process cached metrics
      await _processCachedMetrics();

      _isInitialized = true;
      _logger.i('ProductionPerformanceMonitor initialized successfully');

      // Track initialization performance
      await trackCustomMetric(
        'performance_monitor_init',
        Duration.zero, // No duration for initialization
        success: true,
        attributes: {
          'timestamp': DateTime.now().toIso8601String(),
          'platform': Platform.operatingSystem,
        },
      );
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize ProductionPerformanceMonitor',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'PerformanceMonitor.initialize',
      );
    }
  }

  /// Start tracking RAG query performance
  static Future<RagPerformanceTracker> startRagQuery(
    String queryId, {
    String? queryType,
    String? modelName,
    int? inputTokens,
  }) async {
    try {
      final tracker = await RagPerformanceTracker.start(queryId);

      if (queryType != null) tracker.addAttribute('query_type', queryType);
      if (modelName != null) tracker.addAttribute('model_name', modelName);
      if (inputTokens != null)
        tracker.addAttribute('input_tokens', inputTokens.toString());

      _activeTrackers[queryId] = tracker;

      _logger.d('Started RAG query performance tracking: $queryId');
      return tracker;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to start RAG query tracking',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'PerformanceMonitor.startRagQuery',
      );

      // Return a no-op tracker on error
      final trace = _performance.newTrace('rag_query_error');
      final stopwatch = Stopwatch()..start();
      return RagPerformanceTracker._('error', trace, stopwatch);
    }
  }

  /// Complete RAG query tracking
  static Future<void> completeRagQuery(
    String queryId, {
    bool success = true,
    String? errorMessage,
    int? resultCount,
    bool? cacheHit,
    int? outputTokens,
  }) async {
    try {
      final tracker = _activeTrackers.remove(queryId);
      if (tracker != null) {
        if (outputTokens != null)
          tracker.addAttribute('output_tokens', outputTokens.toString());

        await tracker.complete(
          success: success,
          errorMessage: errorMessage,
          resultCount: resultCount,
          cacheHit: cacheHit,
        );

        _logger.d(
          'Completed RAG query performance tracking: $queryId (${tracker.elapsed.inMilliseconds}ms)',
        );
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to complete RAG query tracking',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'PerformanceMonitor.completeRagQuery',
      );
    }
  }

  /// Track custom performance metric
  static Future<void> trackCustomMetric(
    String operationType,
    Duration duration, {
    bool success = true,
    String? errorMessage,
    Map<String, dynamic>? attributes,
  }) async {
    try {
      final trace = _performance.newTrace('custom_$operationType');

      await trace.start();

      // Add attributes
      trace.putAttribute('operation_type', operationType);
      trace.putAttribute('success', success.toString());
      if (errorMessage != null)
        trace.putAttribute('error_message', errorMessage);

      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.putAttribute(entry.key, entry.value?.toString() ?? 'null');
        }
      }

      // Add metrics
      trace.setMetric('duration_ms', duration.inMilliseconds);

      await trace.stop();

      // Store for analytics
      final metrics = PerformanceMetrics(
        operationType: operationType,
        duration: duration,
        success: success,
        errorMessage: errorMessage,
        attributes: attributes ?? {},
      );

      _metricsBuffer.add(metrics);
      await _cacheMetric(metrics);

      _logger.d(
        'Tracked custom metric: $operationType (${duration.inMilliseconds}ms)',
      );
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to track custom metric',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'PerformanceMonitor.trackCustomMetric',
      );
    }
  }

  /// Track network request performance
  static Future<void> trackNetworkRequest(
    String endpoint,
    String method,
    Duration duration,
    int statusCode, {
    int? requestSize,
    int? responseSize,
    String? errorMessage,
  }) async {
    try {
      // Track network performance using custom trace instead of HTTP trace
      await trackCustomMetric(
        'network_request',
        duration,
        success: statusCode < 400,
        errorMessage: statusCode >= 400 ? 'HTTP $statusCode' : null,
        attributes: {
          'endpoint': endpoint,
          'method': method,
          'status_code': statusCode.toString(),
          'request_size': requestSize?.toString(),
          'response_size': responseSize?.toString(),
        },
      );

      // Track in analytics
      await ProductionAnalytics.trackEvent('network_request_completed', {
        'endpoint': endpoint,
        'method': method,
        'duration_ms': duration.inMilliseconds,
        'status_code': statusCode,
        'request_size': requestSize,
        'response_size': responseSize,
        'success': statusCode < 400,
        'error_message': errorMessage,
      });
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to track network request',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'PerformanceMonitor.trackNetworkRequest',
      );
    }
  }

  /// Track app startup performance
  static Future<void> trackAppStartup(Duration startupDuration) async {
    await trackCustomMetric(
      'app_startup',
      startupDuration,
      attributes: {
        'cold_start': true, // This could be determined dynamically
        'platform': Platform.operatingSystem,
        'debug_mode': kDebugMode,
      },
    );
  }

  /// Track screen render performance
  static Future<void> trackScreenRender(
    String screenName,
    Duration renderDuration,
  ) async {
    await trackCustomMetric(
      'screen_render',
      renderDuration,
      attributes: {'screen_name': screenName},
    );
  }

  /// Track memory usage
  static Future<void> trackMemoryUsage() async {
    try {
      // Note: Memory usage tracking would require platform-specific implementation
      // This is a placeholder for the structure

      final memoryMetrics = <String, dynamic>{
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'platform': Platform.operatingSystem,
        // Add actual memory metrics here
      };

      await ProductionAnalytics.trackEvent('memory_usage', memoryMetrics);
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to track memory usage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get performance statistics
  static Map<String, dynamic> getPerformanceStats() {
    return {
      'active_rag_queries': _activeTrackers.length,
      'buffered_metrics': _metricsBuffer.length,
      'monitoring_enabled': _isInitialized,
      'last_flush': _metricsFlushTimer != null ? 'active' : 'inactive',
    };
  }

  /// Flush metrics to analytics
  static Future<void> flushMetrics() async {
    if (_metricsBuffer.isNotEmpty) {
      _logger.i('Flushing ${_metricsBuffer.length} performance metrics');

      for (final metric in _metricsBuffer) {
        await ProductionAnalytics.trackEvent('performance_metric', {
          'operation_type': metric.operationType,
          'duration_ms': metric.duration.inMilliseconds,
          'success': metric.success,
          'error_message': metric.errorMessage,
          ...metric.attributes,
        });
      }

      _metricsBuffer.clear();
      await _clearCachedMetrics();
    }
  }

  /// Set performance collection enabled
  static Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    try {
      await _performance.setPerformanceCollectionEnabled(enabled);
      _logger.i('Performance collection ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      _logger.w('Failed to set performance collection enabled', error: e);
    }
  }

  // Private helper methods
  static void _setupMetricsFlushTimer() {
    _metricsFlushTimer = Timer.periodic(_flushInterval, (timer) {
      flushMetrics();
    });
  }

  static Future<void> _cacheMetric(PerformanceMetrics metric) async {
    try {
      final cachedMetrics = _prefs?.getStringList(_performanceDataKey) ?? [];
      cachedMetrics.add(json.encode(metric.toMap()));

      // Keep only last 100 metrics
      if (cachedMetrics.length > 100) {
        cachedMetrics.removeAt(0);
      }

      await _prefs?.setStringList(_performanceDataKey, cachedMetrics);
    } catch (e) {
      _logger.w('Failed to cache performance metric', error: e);
    }
  }

  static Future<void> _processCachedMetrics() async {
    try {
      final cachedMetrics = _prefs?.getStringList(_performanceDataKey) ?? [];

      if (cachedMetrics.isNotEmpty) {
        _logger.i(
          'Processing ${cachedMetrics.length} cached performance metrics',
        );

        for (final metricJson in cachedMetrics) {
          try {
            final metricData = json.decode(metricJson) as Map<String, dynamic>;
            await ProductionAnalytics.trackEvent(
              'cached_performance_metric',
              metricData,
            );
          } catch (e) {
            _logger.w('Failed to process cached metric', error: e);
          }
        }

        await _clearCachedMetrics();
      }
    } catch (e) {
      _logger.w('Failed to process cached metrics', error: e);
    }
  }

  static Future<void> _clearCachedMetrics() async {
    try {
      await _prefs?.remove(_performanceDataKey);
    } catch (e) {
      _logger.w('Failed to clear cached metrics', error: e);
    }
  }

  /// Dispose resources
  static void dispose() {
    _metricsFlushTimer?.cancel();
    _activeTrackers.clear();
    _metricsBuffer.clear();
  }
}

/// Performance monitoring widget wrapper
class PerformanceMonitoredWidget extends StatefulWidget {
  final Widget child;
  final String widgetName;
  final bool trackRenderTime;

  const PerformanceMonitoredWidget({
    super.key,
    required this.child,
    required this.widgetName,
    this.trackRenderTime = true,
  });

  @override
  State<PerformanceMonitoredWidget> createState() =>
      _PerformanceMonitoredWidgetState();
}

class _PerformanceMonitoredWidgetState
    extends State<PerformanceMonitoredWidget> {
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    if (widget.trackRenderTime) {
      _stopwatch = Stopwatch()..start();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.trackRenderTime && _stopwatch.isRunning) {
      _stopwatch.stop();
      ProductionPerformanceMonitor.trackScreenRender(
        widget.widgetName,
        _stopwatch.elapsed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extensions for easy performance tracking
extension PerformanceTrackingExtension<T> on Future<T> Function() {
  Future<T> trackPerformance(
    String operationType, {
    Map<String, dynamic>? attributes,
  }) async {
    final stopwatch = Stopwatch()..start();
    String? errorMessage;
    bool success = true;

    try {
      final result = await this();
      return result;
    } catch (e) {
      success = false;
      errorMessage = e.toString();
      rethrow;
    } finally {
      stopwatch.stop();
      ProductionPerformanceMonitor.trackCustomMetric(
        operationType,
        stopwatch.elapsed,
        success: success,
        errorMessage: errorMessage,
        attributes: attributes,
      );
    }
  }
}
