import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Firebase Performance removed; using lightweight in-app tracing

/// Firebase Performance monitoring for RAG integration
class RagPerformanceMonitor {
  static final RagPerformanceMonitor _instance = RagPerformanceMonitor._internal();
  factory RagPerformanceMonitor() => _instance;
  RagPerformanceMonitor._internal();

  final Map<String, _InAppTrace> _activeTraces = {};

  /// Start monitoring a RAG query
  Future<String> startRagQueryTrace({
    required String queryText,
    required String queryType,
    Map<String, String>? customAttributes,
  }) async {
    final traceId = 'rag_query_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final trace = _InAppTrace('rag_query_processing')..start();
      _activeTraces[traceId] = trace;

      trace.attributes['query_type'] = queryType;
      trace.attributes['query_length'] = queryText.length.toString();
      trace.attributes['platform'] = Platform.operatingSystem;

      if (customAttributes != null) {
        for (final entry in customAttributes.entries) {
          trace.attributes[entry.key] = entry.value;
        }
      }

      return traceId;
    } catch (e) {
      debugPrint('Error starting RAG query trace: $e');
      return traceId;
    }
  }

  /// Stop monitoring a RAG query
  Future<void> stopRagQueryTrace({
    required String traceId,
    required bool success,
    String? errorMessage,
    int? responseLength,
    double? confidence,
  }) async {
    try {
      final trace = _activeTraces[traceId];
      if (trace == null) return;
      trace.attributes['success'] = success.toString();
      if (!success && errorMessage != null) trace.attributes['error'] = errorMessage;
      if (responseLength != null) trace.attributes['response_length'] = responseLength.toString();
      if (confidence != null) trace.attributes['confidence'] = confidence.toString();
      trace.stop();
      _activeTraces.remove(traceId);
    } catch (e) {
      debugPrint('Error stopping RAG query trace: $e');
    }
  }

  /// Record app start performance
  Future<void> recordAppStart() async {
    if (!kDebugMode) return;

    try {
      final trace = _InAppTrace('app_start')..start();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), trace.stop);
      });
    } catch (e) {
      debugPrint('Error recording app start: $e');
    }
  }

  /// Record custom performance metrics
  Future<void> recordCustomMetric({
    required String name,
    required int value,
    Map<String, String>? attributes,
  }) async {
    try {
      final trace = _InAppTrace(name)..start();
      trace.attributes['platform'] = Platform.operatingSystem;
      trace.attributes['value'] = value.toString();

      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.attributes[entry.key] = entry.value;
        }
      }
      trace.stop();
    } catch (e) {
      debugPrint('Error recording custom metric: $e');
    }
  }
}

/// Simple in-app trace replacement
class _InAppTrace {
  final String name;
  final Stopwatch _stopwatch = Stopwatch();
  // start wall time removed (not currently used)
  DateTime? _endWall;
  final Map<String, String> attributes = {};

  _InAppTrace(this.name);

  void start() => _stopwatch.start();
  void stop() {
    if (_endWall != null) return;
    _stopwatch.stop();
    _endWall = DateTime.now();
    // Could emit to logging/analytics here
    debugPrint('[TRACE] $name duration=${_stopwatch.elapsedMilliseconds}ms attrs=$attributes');
  }
}

/// Utility class for performance measurements
class PerformanceUtils {
  /// Measure execution time of a function
  static Future<T> measureExecutionTime<T>({
    required String operationName,
    required Future<T> Function() operation,
    Map<String, String>? attributes,
  }) async {
    final stopwatch = Stopwatch()..start();
    final monitor = RagPerformanceMonitor();

    try {
      final result = await operation();
      stopwatch.stop();

      await monitor.recordCustomMetric(
        name: 'execution_time_$operationName',
        value: stopwatch.elapsedMilliseconds,
        attributes: {
          'operation': operationName,
          'success': 'true',
          ...?attributes,
        },
      );

      return result;
    } catch (error) {
      stopwatch.stop();

      await monitor.recordCustomMetric(
        name: 'execution_time_$operationName',
        value: stopwatch.elapsedMilliseconds,
        attributes: {
          'operation': operationName,
          'success': 'false',
          'error': error.toString(),
          ...?attributes,
        },
      );

      rethrow;
    }
  }
}

/// Performance monitoring widget wrapper
class PerformanceMonitoredWidget extends StatefulWidget {
  final Widget child;
  final String widgetName;
  final Map<String, String>? attributes;

  const PerformanceMonitoredWidget({
    super.key,
    required this.child,
    required this.widgetName,
    this.attributes,
  });

  @override
  State<PerformanceMonitoredWidget> createState() => _PerformanceMonitoredWidgetState();
}

class _PerformanceMonitoredWidgetState extends State<PerformanceMonitoredWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Builder function for performance-monitored widgets
Widget buildPerformanceMonitoredWidget({
  required Widget child,
  required String name,
  Map<String, String>? attributes,
}) {
  return PerformanceMonitoredWidget(
    widgetName: name,
    attributes: attributes,
    child: child,
  );
}
