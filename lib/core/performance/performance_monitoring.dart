import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// Firebase Performance monitoring for RAG integration
class RagPerformanceMonitor {
  static final RagPerformanceMonitor _instance =
      RagPerformanceMonitor._internal();
  factory RagPerformanceMonitor() => _instance;
  RagPerformanceMonitor._internal();

  final FirebasePerformance _performance = FirebasePerformance.instance;
  final Map<String, Trace> _activeTraces = {};

  /// Start monitoring a RAG query
  Future<String> startRagQueryTrace({
    required String queryText,
    required String queryType,
    Map<String, String>? customAttributes,
  }) async {
    final traceId = 'rag_query_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final trace = _performance.newTrace('rag_query_processing');
      _activeTraces[traceId] = trace;

      await trace.start();

      // Add custom attributes
      trace.putAttribute('query_type', queryType);
      trace.putAttribute('query_length', queryText.length.toString());
      trace.putAttribute('platform', Platform.operatingSystem);

      if (customAttributes != null) {
        for (final entry in customAttributes.entries) {
          trace.putAttribute(entry.key, entry.value);
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

      trace.putAttribute('success', success.toString());
      if (!success && errorMessage != null) {
        trace.putAttribute('error', errorMessage);
      }
      if (responseLength != null) {
        trace.putAttribute('response_length', responseLength.toString());
      }
      if (confidence != null) {
        trace.putAttribute('confidence', confidence.toString());
      }

      await trace.stop();
      _activeTraces.remove(traceId);
    } catch (e) {
      debugPrint('Error stopping RAG query trace: $e');
    }
  }

  /// Record app start performance
  Future<void> recordAppStart() async {
    if (!kDebugMode) return;

    try {
      final trace = _performance.newTrace('app_start');
      await trace.start();

      // This would typically be called when app is ready
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await trace.stop();
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
      final trace = _performance.newTrace(name);
      await trace.start();

      trace.putAttribute('platform', Platform.operatingSystem);
      trace.putAttribute('value', value.toString());

      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.putAttribute(entry.key, entry.value);
        }
      }

      await trace.stop();
    } catch (e) {
      debugPrint('Error recording custom metric: $e');
    }
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
  State<PerformanceMonitoredWidget> createState() =>
      _PerformanceMonitoredWidgetState();
}

class _PerformanceMonitoredWidgetState
    extends State<PerformanceMonitoredWidget> {
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
