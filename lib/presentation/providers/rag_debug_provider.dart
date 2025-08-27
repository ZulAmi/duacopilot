import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Enhanced logger configuration for RAG state management
class RagLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    developer.log(message, name: 'RAG_DEBUG');
  }

  static void info(String message, [dynamic data]) {
    _logger.i(message, error: data);
    developer.log(message, name: 'RAG_INFO');
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    developer.log(message, name: 'RAG_WARNING');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'RAG_ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void performance(
    String operation,
    Duration duration, [
    Map<String, dynamic>? metadata,
  ]) {
    final message = '$operation completed in ${duration.inMilliseconds}ms';
    _logger.i(message, error: metadata);
    developer.log(message, name: 'RAG_PERFORMANCE');
  }

  static void apiCall(
    String endpoint,
    String method,
    Duration duration,
    int? statusCode,
  ) {
    final message = '$method $endpoint - ${statusCode ?? 'TIMEOUT'} (${duration.inMilliseconds}ms)';
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      info(message);
    } else {
      warning(message);
    }
  }

  static void cacheOperation(
    String operation,
    String key,
    bool hit, [
    Duration? duration,
  ]) {
    final message = 'Cache $operation: $key (${hit ? 'HIT' : 'MISS'})';
    if (duration != null) {
      debug('$message - ${duration.inMilliseconds}ms');
    } else {
      debug(message);
    }
  }

  static void websocketEvent(String event, [dynamic data]) {
    debug('WebSocket $event', data);
  }

  static void stateTransition(
    String provider,
    dynamic oldState,
    dynamic newState,
  ) {
    debug('$provider state transition', {
      'from': oldState.toString(),
      'to': newState.toString(),
    });
  }
}

/// State monitoring and debugging provider
class RagDebugNotifier extends StateNotifier<RagDebugState> {
  RagDebugNotifier() : super(const RagDebugState()) {
    _startPerformanceMonitoring();
  }

  void _startPerformanceMonitoring() {
    // Monitor memory usage and performance metrics
    // This would be implemented with actual monitoring tools
  }

  /// Enable/disable debug mode
  void setDebugMode(bool enabled) {
    state = state.copyWith(isDebugEnabled: enabled);
    RagLogger.info('Debug mode ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Enable/disable verbose logging
  void setVerboseLogging(bool enabled) {
    state = state.copyWith(isVerboseEnabled: enabled);
    RagLogger.info('Verbose logging ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Log API call metrics
  void logApiCall(
    String endpoint,
    String method,
    Duration duration,
    int? statusCode, {
    String? error,
  }) {
    final call = ApiCallLog(
      endpoint: endpoint,
      method: method,
      duration: duration,
      statusCode: statusCode,
      timestamp: DateTime.now(),
      error: error,
    );

    state = state.copyWith(
      apiCalls: [...state.apiCalls.take(99), call], // Keep last 100 calls
    );

    RagLogger.apiCall(endpoint, method, duration, statusCode);
    if (error != null) {
      RagLogger.error('API call failed: $endpoint', error);
    }
  }

  /// Log cache operation
  void logCacheOperation(
    String operation,
    String key,
    bool hit,
    Duration? duration,
  ) {
    final cacheOp = CacheOperationLog(
      operation: operation,
      key: key,
      hit: hit,
      duration: duration,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      cacheOperations: [...state.cacheOperations.take(99), cacheOp],
    );

    RagLogger.cacheOperation(operation, key, hit, duration);
  }

  /// Log WebSocket event
  void logWebSocketEvent(String event, dynamic data) {
    final wsEvent = WebSocketEventLog(
      event: event,
      data: data,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      webSocketEvents: [...state.webSocketEvents.take(99), wsEvent],
    );

    RagLogger.websocketEvent(event, data);
  }

  /// Log state transition
  void logStateTransition(String provider, dynamic oldState, dynamic newState) {
    final transition = StateTransitionLog(
      provider: provider,
      oldState: oldState.toString(),
      newState: newState.toString(),
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      stateTransitions: [...state.stateTransitions.take(99), transition],
    );

    if (state.isVerboseEnabled) {
      RagLogger.stateTransition(provider, oldState, newState);
    }
  }

  /// Log error with context
  void logError(
    String context,
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, dynamic>? metadata,
  }) {
    final errorLog = ErrorLog(
      context: context,
      error: error.toString(),
      stackTrace: stackTrace?.toString(),
      metadata: metadata,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      errors: [...state.errors.take(49), errorLog], // Keep last 50 errors
    );

    RagLogger.error('$context: $error', error, stackTrace);
  }

  /// Get performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    final apiCalls = state.apiCalls;
    final cacheOps = state.cacheOperations;

    if (apiCalls.isEmpty) {
      return {
        'apiCalls': 0,
        'averageResponseTime': 0,
        'cacheHitRate': 0,
        'errorRate': 0,
      };
    }

    final totalResponseTime = apiCalls.map((call) => call.duration.inMilliseconds).reduce((a, b) => a + b);

    final successfulCalls = apiCalls.where(
      (call) => call.statusCode != null && call.statusCode! >= 200 && call.statusCode! < 300,
    );

    final cacheHits = cacheOps.where((op) => op.hit).length;
    final totalCacheOps = cacheOps.length;

    return {
      'apiCalls': apiCalls.length,
      'averageResponseTime': totalResponseTime / apiCalls.length,
      'cacheHitRate': totalCacheOps > 0 ? (cacheHits / totalCacheOps) * 100 : 0,
      'errorRate': ((apiCalls.length - successfulCalls.length) / apiCalls.length) * 100,
      'errors': state.errors.length,
    };
  }

  /// Clear debug logs
  void clearLogs() {
    state = const RagDebugState();
    RagLogger.info('Debug logs cleared');
  }

  /// Export debug data
  Map<String, dynamic> exportDebugData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'debugState': state.toJson(),
      'performanceMetrics': getPerformanceMetrics(),
    };
  }
}

/// Debug state data model
@immutable

/// RagDebugState class implementation
class RagDebugState {
  final bool isDebugEnabled;
  final bool isVerboseEnabled;
  final List<ApiCallLog> apiCalls;
  final List<CacheOperationLog> cacheOperations;
  final List<WebSocketEventLog> webSocketEvents;
  final List<StateTransitionLog> stateTransitions;
  final List<ErrorLog> errors;

  const RagDebugState({
    this.isDebugEnabled = false,
    this.isVerboseEnabled = false,
    this.apiCalls = const [],
    this.cacheOperations = const [],
    this.webSocketEvents = const [],
    this.stateTransitions = const [],
    this.errors = const [],
  });

  RagDebugState copyWith({
    bool? isDebugEnabled,
    bool? isVerboseEnabled,
    List<ApiCallLog>? apiCalls,
    List<CacheOperationLog>? cacheOperations,
    List<WebSocketEventLog>? webSocketEvents,
    List<StateTransitionLog>? stateTransitions,
    List<ErrorLog>? errors,
  }) {
    return RagDebugState(
      isDebugEnabled: isDebugEnabled ?? this.isDebugEnabled,
      isVerboseEnabled: isVerboseEnabled ?? this.isVerboseEnabled,
      apiCalls: apiCalls ?? this.apiCalls,
      cacheOperations: cacheOperations ?? this.cacheOperations,
      webSocketEvents: webSocketEvents ?? this.webSocketEvents,
      stateTransitions: stateTransitions ?? this.stateTransitions,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDebugEnabled': isDebugEnabled,
      'isVerboseEnabled': isVerboseEnabled,
      'apiCallsCount': apiCalls.length,
      'cacheOperationsCount': cacheOperations.length,
      'webSocketEventsCount': webSocketEvents.length,
      'stateTransitionsCount': stateTransitions.length,
      'errorsCount': errors.length,
    };
  }
}

/// API call log entry
@immutable

/// ApiCallLog class implementation
class ApiCallLog {
  final String endpoint;
  final String method;
  final Duration duration;
  final int? statusCode;
  final DateTime timestamp;
  final String? error;

  const ApiCallLog({
    required this.endpoint,
    required this.method,
    required this.duration,
    this.statusCode,
    required this.timestamp,
    this.error,
  });
}

/// Cache operation log entry
@immutable

/// CacheOperationLog class implementation
class CacheOperationLog {
  final String operation;
  final String key;
  final bool hit;
  final Duration? duration;
  final DateTime timestamp;

  const CacheOperationLog({
    required this.operation,
    required this.key,
    required this.hit,
    this.duration,
    required this.timestamp,
  });
}

/// WebSocket event log entry
@immutable

/// WebSocketEventLog class implementation
class WebSocketEventLog {
  final String event;
  final dynamic data;
  final DateTime timestamp;

  const WebSocketEventLog({
    required this.event,
    this.data,
    required this.timestamp,
  });
}

/// State transition log entry
@immutable

/// StateTransitionLog class implementation
class StateTransitionLog {
  final String provider;
  final String oldState;
  final String newState;
  final DateTime timestamp;

  const StateTransitionLog({
    required this.provider,
    required this.oldState,
    required this.newState,
    required this.timestamp,
  });
}

/// Error log entry
@immutable

/// ErrorLog class implementation
class ErrorLog {
  final String context;
  final String error;
  final String? stackTrace;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const ErrorLog({
    required this.context,
    required this.error,
    this.stackTrace,
    this.metadata,
    required this.timestamp,
  });
}

/// Provider for RAG debugging and monitoring
final ragDebugProvider = StateNotifierProvider<RagDebugNotifier, RagDebugState>(
  (ref) {
    return RagDebugNotifier();
  },
);
