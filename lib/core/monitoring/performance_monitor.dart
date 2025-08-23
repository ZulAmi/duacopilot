import 'dart:async';
import 'dart:convert';

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Professional performance monitoring service
/// Tracks app performance, memory usage, and user interactions
class PerformanceMonitor {
  static PerformanceMonitor? _instance;
  static PerformanceMonitor get instance => _instance ??= PerformanceMonitor._();

  PerformanceMonitor._();

  final List<PerformanceMetric> _metrics = [];
  final Map<String, Stopwatch> _activeTimers = {};
  Timer? _memoryMonitorTimer;

  /// Initialize performance monitoring
  Future<void> initialize() async {
    if (kDebugMode) {
      AppLogger.debug('🔍 Initializing Performance Monitor');
    }

    // Start memory monitoring
    _startMemoryMonitoring();

    // Track app lifecycle events
    _trackAppLifecycle();
  }

  /// Start timing a specific operation
  void startTimer(String operation) {
    _activeTimers[operation] = Stopwatch()..start();
  }

  /// Stop timing and record the metric
  void stopTimer(String operation, {Map<String, dynamic>? metadata}) {
    final timer = _activeTimers.remove(operation);
    if (timer != null) {
      timer.stop();

      // Create concrete implementation instead of abstract class
      final metric = OperationMetric(
        name: operation,
        duration: timer.elapsed,
        timestamp: DateTime.now(),
        metadata: metadata ?? {},
      );

      _recordMetric(metric);
    }
  }

  /// Record a custom performance metric
  void recordMetric({required String name, required Duration duration, Map<String, dynamic>? metadata}) {
    // Create concrete implementation instead of abstract class
    final metric = OperationMetric(name: name, duration: duration, timestamp: DateTime.now(), metadata: metadata ?? {});

    _recordMetric(metric);
  }

  /// Track network request performance
  void trackNetworkRequest({
    required String url,
    required Duration duration,
    required int statusCode,
    int? responseSize,
  }) {
    final metric = NetworkMetric(
      url: url,
      duration: duration,
      statusCode: statusCode,
      responseSize: responseSize,
      timestamp: DateTime.now(),
    );

    _recordMetric(metric);
  }

  /// Track user interaction events
  void trackUserInteraction({required String action, required String screen, Map<String, dynamic>? properties}) {
    final metric = UserInteractionMetric(
      action: action,
      screen: screen,
      properties: properties ?? {},
      timestamp: DateTime.now(),
    );

    _recordMetric(metric);
  }

  /// Get performance statistics
  PerformanceStats getStats() {
    final now = DateTime.now();
    final recentMetrics = _metrics.where((m) => now.difference(m.timestamp).inHours < 1).toList();

    if (recentMetrics.isEmpty) {
      return PerformanceStats(
        averageResponseTime: Duration.zero,
        slowOperations: [],
        memoryUsage: _getCurrentMemoryUsage(),
        totalOperations: 0,
      );
    }

    final totalDuration = recentMetrics.map((m) => m.duration.inMilliseconds).reduce((a, b) => a + b);

    final averageMs = totalDuration / recentMetrics.length;

    final slowOperations =
        recentMetrics
            .where((m) => m.duration.inMilliseconds > 1000)
            .map((m) => SlowOperation(name: m.name, duration: m.duration, timestamp: m.timestamp))
            .toList();

    return PerformanceStats(
      averageResponseTime: Duration(milliseconds: averageMs.round()),
      slowOperations: slowOperations,
      memoryUsage: _getCurrentMemoryUsage(),
      totalOperations: recentMetrics.length,
    );
  }

  /// Export performance data for analysis
  String exportMetrics() {
    final data = {
      'metrics': _metrics.map((m) => m.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
      'stats': getStats().toJson(),
    };

    return jsonEncode(data);
  }

  /// Clear old metrics to prevent memory leaks
  void cleanupOldMetrics() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    _metrics.removeWhere((m) => m.timestamp.isBefore(cutoff));
  }

  // Private methods
  void _recordMetric(PerformanceMetric metric) {
    _metrics.add(metric);

    if (kDebugMode && metric.duration.inMilliseconds > 1000) {
      AppLogger.debug('⚠️ Slow operation detected: ${metric.name} took ${metric.duration.inMilliseconds}ms');
    }

    // Prevent memory buildup
    if (_metrics.length > 10000) {
      _metrics.removeRange(0, 5000);
    }
  }

  void _startMemoryMonitoring() {
    _memoryMonitorTimer = Timer.periodic(const Duration(minutes: 1), (timer) => _checkMemoryUsage());
  }

  void _checkMemoryUsage() {
    final memoryUsage = _getCurrentMemoryUsage();

    if (memoryUsage > 200 * 1024 * 1024) {
      // 200MB threshold
      if (kDebugMode) {
        AppLogger.debug('⚠️ High memory usage detected: ${(memoryUsage / 1024 / 1024).toStringAsFixed(2)}MB');
      }

      // Trigger cleanup
      cleanupOldMetrics();
    }
  }

  int _getCurrentMemoryUsage() {
    // In a real implementation, this would get actual memory usage
    // For now, return a placeholder value
    return 50 * 1024 * 1024; // 50MB
  }

  void _trackAppLifecycle() {
    // Track app lifecycle events for performance analysis
    // This would integrate with actual app lifecycle callbacks
  }

  /// Dispose resources
  void dispose() {
    _memoryMonitorTimer?.cancel();
    _activeTimers.clear();
    _metrics.clear();
  }
}

/// Base class for performance metrics
abstract class PerformanceMetric {
  final String name;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const PerformanceMetric({
    required this.name,
    required this.duration,
    required this.timestamp,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'duration_ms': duration.inMilliseconds,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
    'type': runtimeType.toString(),
  };
}

/// Concrete implementation for general operation metrics
class OperationMetric extends PerformanceMetric {
  const OperationMetric({
    required super.name,
    required super.duration,
    required super.timestamp,
    required super.metadata,
  });

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'operation_type': 'general'};
}

/// Network request performance metric
class NetworkMetric extends PerformanceMetric {
  final String url;
  final int statusCode;
  final int? responseSize;

  const NetworkMetric({
    required this.url,
    required super.duration,
    required this.statusCode,
    this.responseSize,
    required super.timestamp,
  }) : super(name: 'network_request', metadata: const {});

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'url': url,
    'status_code': statusCode,
    'response_size': responseSize,
  };
}

/// User interaction performance metric
class UserInteractionMetric extends PerformanceMetric {
  final String action;
  final String screen;
  final Map<String, dynamic> properties;

  const UserInteractionMetric({
    required this.action,
    required this.screen,
    required this.properties,
    required super.timestamp,
  }) : super(name: 'user_interaction', duration: Duration.zero, metadata: properties);

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'action': action, 'screen': screen, 'properties': properties};
}

/// Performance statistics summary
class PerformanceStats {
  final Duration averageResponseTime;
  final List<SlowOperation> slowOperations;
  final int memoryUsage;
  final int totalOperations;

  const PerformanceStats({
    required this.averageResponseTime,
    required this.slowOperations,
    required this.memoryUsage,
    required this.totalOperations,
  });

  Map<String, dynamic> toJson() => {
    'average_response_time_ms': averageResponseTime.inMilliseconds,
    'slow_operations_count': slowOperations.length,
    'memory_usage_bytes': memoryUsage,
    'total_operations': totalOperations,
    'slow_operations': slowOperations.map((s) => s.toJson()).toList(),
  };
}

/// Slow operation details
class SlowOperation {
  final String name;
  final Duration duration;
  final DateTime timestamp;

  const SlowOperation({required this.name, required this.duration, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'name': name,
    'duration_ms': duration.inMilliseconds,
    'timestamp': timestamp.toIso8601String(),
  };
}
