import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../logging/app_logger.dart';
import '../platform/platform_service.dart';
import '../storage/secure_storage_adapter.dart';

/// Comprehensive monitoring service for Flutter RAG app
/// Tracks query success rates, user satisfaction, performance metrics,
/// geographic patterns, A/B testing, and crash reporting
class ComprehensiveMonitoringService {
  static ComprehensiveMonitoringService? _instance;
  static ComprehensiveMonitoringService get instance =>
      _instance ??= ComprehensiveMonitoringService._();

  ComprehensiveMonitoringService._();

  // Firebase services
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  final FirebasePerformance _performance = FirebasePerformance.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Internal tracking
  final Map<String, Trace> _activeTraces = {};
  final Map<String, QueryMetrics> _queryMetrics = {};
  final List<UserSatisfactionEvent> _satisfactionEvents = [];
  final List<GeographicEvent> _geographicEvents = [];
  final Map<String, ABTestVariant> _activeABTests = {};

  // Configuration
  late String _sessionId;
  Timer? _flushTimer;
  bool _isInitialized = false;

  /// Initialize comprehensive monitoring
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _sessionId = const Uuid().v4();
      final userId = await _getUserId();

      // Initialize Firebase services (with graceful fallback)
      try {
        await _initializeFirebaseServices();
        AppLogger.info('âœ… Firebase monitoring services initialized');
      } catch (e) {
        AppLogger.warning(
          'âš ï¸  Firebase monitoring services failed - continuing with limited monitoring: $e',
        );
        // Continue initialization even if Firebase fails
      }

      // Setup A/B testing (only if Firebase is available)
      try {
        await _setupABTesting();
        AppLogger.info('âœ… A/B testing setup completed');
      } catch (e) {
        AppLogger.warning('âš ï¸  A/B testing setup failed: $e');
      }

      // Start periodic data flush
      _startPeriodicFlush();

      // Track app initialization
      try {
        await _trackAppInitialization();
      } catch (e) {
        AppLogger.warning('âš ï¸  App initialization tracking failed: $e');
      }

      _isInitialized = true;
      AppLogger.info(
        'ðŸš€ Comprehensive monitoring initialized for user: $userId',
      );
    } catch (e) {
      AppLogger.error('Failed to initialize monitoring: $e');

      // Try to record error if Crashlytics is available
      try {
        await _crashlytics.recordError(
          e,
          StackTrace.current,
          reason: 'Failed to initialize ComprehensiveMonitoringService',
        );
      } catch (crashError) {
        AppLogger.warning('Could not record initialization error: $crashError');
      }

      rethrow; // Re-throw to let caller handle the error
    }
  }

  /// Track RAG query with comprehensive metrics
  Future<String> startRagQueryTracking({
    required String query,
    required String queryType,
    Map<String, dynamic>? metadata,
  }) async {
    final traceId = 'rag_query_${DateTime.now().millisecondsSinceEpoch}';

    try {
      // Start Firebase Performance trace
      final trace = _performance.newTrace('rag_query_processing');
      _activeTraces[traceId] = trace;
      await trace.start();

      // Set trace attributes
      trace.putAttribute('query_type', queryType);
      trace.putAttribute('query_length', query.length.toString());
      trace.putAttribute('session_id', _sessionId);
      trace.putAttribute('platform', PlatformService.instance.platformName);

      // Initialize query metrics
      _queryMetrics[traceId] = QueryMetrics(
        traceId: traceId,
        query: query,
        queryType: queryType,
        startTime: DateTime.now(),
        metadata: metadata ?? {},
      );

      // Track custom event
      await _analytics.logEvent(
        name: 'rag_query_started',
        parameters: {
          'trace_id': traceId,
          'query_type': queryType,
          'query_length': query.length,
          'session_id': _sessionId,
          ...?metadata,
        },
      );

      return traceId;
    } catch (e) {
      AppLogger.error('Failed to start RAG query tracking: $e');
      return traceId;
    }
  }

  /// Complete RAG query tracking with results
  Future<void> completeRagQueryTracking({
    required String traceId,
    required bool success,
    String? errorMessage,
    double? confidence,
    int? responseLength,
    List<String>? sources,
    Duration? cacheHitTime,
  }) async {
    try {
      final trace = _activeTraces[traceId];
      final metrics = _queryMetrics[traceId];

      if (trace != null && metrics != null) {
        // Update trace attributes
        trace.putAttribute('success', success.toString());
        if (errorMessage != null) {
          trace.putAttribute('error', errorMessage);
        }
        if (confidence != null) {
          trace.putAttribute('confidence', confidence.toString());
        }
        if (responseLength != null) {
          trace.putAttribute('response_length', responseLength.toString());
        }
        if (cacheHitTime != null) {
          trace.putAttribute('cache_hit', 'true');
          trace.putAttribute(
            'cache_time_ms',
            cacheHitTime.inMilliseconds.toString(),
          );
        }

        // Stop performance trace
        await trace.stop();
        _activeTraces.remove(traceId);

        // Update metrics
        metrics.endTime = DateTime.now();
        metrics.success = success;
        metrics.confidence = confidence;
        metrics.responseLength = responseLength;
        metrics.sources = sources ?? [];
        metrics.errorMessage = errorMessage;
        metrics.wasCacheHit = cacheHitTime != null;

        // Calculate processing time
        final processingTime = metrics.endTime!.difference(metrics.startTime);

        // Track detailed analytics event
        await _analytics.logEvent(
          name: success ? 'rag_query_success' : 'rag_query_failure',
          parameters: {
            'trace_id': traceId,
            'query_type': metrics.queryType,
            'processing_time_ms': processingTime.inMilliseconds,
            'success': success,
            if (confidence != null) 'confidence': confidence,
            if (responseLength != null) 'response_length': responseLength,
            'source_count': sources?.length ?? 0,
            'cache_hit': cacheHitTime != null,
            'session_id': _sessionId,
            if (errorMessage != null)
              'error_category': _categorizeError(errorMessage),
          },
        );

        // Track popular query types and trending topics
        await _trackPopularityMetrics(metrics);

        // Geographic tracking (if enabled)
        await _trackGeographicUsage(metrics);
      }
    } catch (e) {
      AppLogger.error('Failed to complete RAG query tracking: $e');
    }
  }

  /// Track user satisfaction with query results
  Future<void> trackUserSatisfaction({
    required String traceId,
    required int rating, // 1-5 scale
    String? feedback,
    List<String>? tags,
  }) async {
    try {
      final metrics = _queryMetrics[traceId];
      if (metrics == null) return;

      final satisfactionEvent = UserSatisfactionEvent(
        traceId: traceId,
        queryType: metrics.queryType,
        rating: rating,
        feedback: feedback,
        tags: tags ?? [],
        timestamp: DateTime.now(),
        sessionId: _sessionId,
      );

      _satisfactionEvents.add(satisfactionEvent);

      // Track analytics event
      await _analytics.logEvent(
        name: 'user_satisfaction',
        parameters: {
          'trace_id': traceId,
          'query_type': metrics.queryType,
          'rating': rating,
          'has_feedback': feedback != null,
          'tag_count': tags?.length ?? 0,
          'session_id': _sessionId,
        },
      );

      // Update query metrics
      metrics.userRating = rating;
      metrics.userFeedback = feedback;

      AppLogger.info('ðŸ“Š User satisfaction tracked: $rating/5 for $traceId');
    } catch (e) {
      AppLogger.error('Failed to track user satisfaction: $e');
    }
  }

  /// Track A/B test variant selection and results
  Future<void> trackABTestResult({
    required String experimentName,
    required String variant,
    required String outcome,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'ab_test_result',
        parameters: {
          'experiment_name': experimentName,
          'variant': variant,
          'outcome': outcome,
          'session_id': _sessionId,
          ...?additionalData,
        },
      );

      AppLogger.info(
        'ðŸ§ª A/B test result tracked: $experimentName -> $variant = $outcome',
      );
    } catch (e) {
      AppLogger.error('Failed to track A/B test result: $e');
    }
  }

  /// Get A/B test variant for experiment
  Future<String> getABTestVariant(String experimentName) async {
    try {
      // Check if we already have a variant for this session
      if (_activeABTests.containsKey(experimentName)) {
        return _activeABTests[experimentName]!.variant;
      }

      // Get variant from Remote Config with fallback
      final variant =
          _remoteConfig.getString('${experimentName}_variant').isNotEmpty
              ? _remoteConfig.getString('${experimentName}_variant')
              : await _determineABTestVariant(experimentName);

      // Store variant for consistency
      _activeABTests[experimentName] = ABTestVariant(
        experimentName: experimentName,
        variant: variant,
        assignmentTime: DateTime.now(),
      );

      // Track variant assignment
      await _analytics.logEvent(
        name: 'ab_test_assignment',
        parameters: {
          'experiment_name': experimentName,
          'variant': variant,
          'session_id': _sessionId,
        },
      );

      return variant;
    } catch (e) {
      AppLogger.error('Failed to get A/B test variant: $e');
      return 'default';
    }
  }

  /// Record custom exception with context
  Future<void> recordException({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? additionalInfo,
    bool fatal = false,
  }) async {
    try {
      // Set custom keys for additional context
      if (additionalInfo != null) {
        for (final entry in additionalInfo.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value.toString());
        }
      }

      // Set session context
      await _crashlytics.setCustomKey('session_id', _sessionId);
      await _crashlytics.setCustomKey(
        'platform',
        PlatformService.instance.platformName,
      );
      await _crashlytics.setCustomKey(
        'timestamp',
        DateTime.now().toIso8601String(),
      );

      // Record the exception
      await _crashlytics.recordError(
        exception,
        stackTrace ?? StackTrace.current,
        reason: reason,
        fatal: fatal,
      );

      // Also track as analytics event for non-fatal errors
      if (!fatal) {
        await _analytics.logEvent(
          name: 'custom_exception',
          parameters: {
            'exception_type': exception.runtimeType.toString(),
            'reason': reason ?? 'Unknown',
            'session_id': _sessionId,
            'platform': PlatformService.instance.platformName,
          },
        );
      }

      AppLogger.error('ðŸš¨ Exception recorded: ${exception.toString()}');
    } catch (e) {
      AppLogger.error('Failed to record exception: $e');
    }
  }

  /// Get comprehensive analytics summary
  Future<Map<String, dynamic>> getAnalyticsSummary({
    Duration? timeWindow,
  }) async {
    try {
      final cutoffTime = timeWindow != null
          ? DateTime.now().subtract(timeWindow)
          : DateTime.now().subtract(const Duration(hours: 24));

      // Filter recent metrics
      final recentMetrics = _queryMetrics.values
          .where((m) => m.startTime.isAfter(cutoffTime))
          .toList();

      final recentSatisfaction = _satisfactionEvents
          .where((s) => s.timestamp.isAfter(cutoffTime))
          .toList();

      // Calculate success rates
      final totalQueries = recentMetrics.length;
      final successfulQueries =
          recentMetrics.where((m) => m.success == true).length;
      final successRate =
          totalQueries > 0 ? successfulQueries / totalQueries : 0.0;

      // Calculate satisfaction metrics
      final avgRating = recentSatisfaction.isNotEmpty
          ? recentSatisfaction.map((s) => s.rating).reduce((a, b) => a + b) /
              recentSatisfaction.length
          : 0.0;

      // Query type analysis
      final queryTypeStats = <String, Map<String, dynamic>>{};
      for (final metric in recentMetrics) {
        queryTypeStats.putIfAbsent(
          metric.queryType,
          () => {
            'count': 0,
            'success_count': 0,
            'total_time_ms': 0,
            'avg_confidence': 0.0,
          },
        );

        final stats = queryTypeStats[metric.queryType]!;
        stats['count'] = stats['count'] + 1;
        if (metric.success == true) {
          stats['success_count'] = stats['success_count'] + 1;
        }
        if (metric.endTime != null) {
          stats['total_time_ms'] = stats['total_time_ms'] +
              metric.endTime!.difference(metric.startTime).inMilliseconds;
        }
        if (metric.confidence != null) {
          stats['avg_confidence'] =
              ((stats['avg_confidence'] * (stats['count'] - 1)) +
                      metric.confidence!) /
                  stats['count'];
        }
      }

      // Popular topics analysis
      final topicCounts = <String, int>{};
      for (final metric in recentMetrics) {
        // Simple topic extraction from query type
        final topic = metric.queryType.toLowerCase();
        topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
      }

      return {
        'session_id': _sessionId,
        'time_window_hours': timeWindow?.inHours ?? 24,
        'generated_at': DateTime.now().toIso8601String(),
        'overview': {
          'total_queries': totalQueries,
          'success_rate': successRate,
          'avg_user_rating': avgRating,
          'total_satisfaction_responses': recentSatisfaction.length,
        },
        'query_types': queryTypeStats,
        'trending_topics': topicCounts.entries
            .map((e) => {'topic': e.key, 'count': e.value})
            .toList()
          ..sort(
            (a, b) => (b['count'] as int).compareTo(a['count'] as int),
          ),
        'geographic_data': await _getGeographicSummary(cutoffTime),
        'ab_tests': _activeABTests.entries
            .map(
              (e) => {
                'experiment': e.key,
                'variant': e.value.variant,
                'assigned_at': e.value.assignmentTime.toIso8601String(),
              },
            )
            .toList(),
      };
    } catch (e) {
      AppLogger.error('Failed to get analytics summary: $e');
      return {'error': 'Failed to generate analytics summary'};
    }
  }

  /// Cleanup resources
  Future<void> dispose() async {
    _flushTimer?.cancel();
    await _flushPendingData();
    _isInitialized = false;
    AppLogger.info('ðŸ§¹ Comprehensive monitoring disposed');
  }

  // Private helper methods

  Future<void> _initializeFirebaseServices() async {
    try {
      // Check if Firebase is initialized
      try {
        FirebaseAnalytics.instance;
        AppLogger.info('âœ… Firebase Analytics available');
      } catch (e) {
        AppLogger.warning('âš ï¸  Firebase Analytics not available: $e');
        return; // Exit early if Firebase is not initialized
      }

      // Initialize Remote Config
      try {
        await _remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: const Duration(hours: 1),
          ),
        );

        // Set default Remote Config values
        await _remoteConfig.setDefaults({
          'rag_integration_variant': 'default',
          'ui_theme_variant': 'professional',
          'cache_strategy_variant': 'intelligent',
          'monitoring_enabled': true,
          'geographic_tracking_enabled': true,
          'satisfaction_prompt_frequency': 5, // Show after every 5 queries
        });

        try {
          await _remoteConfig.fetchAndActivate();
          AppLogger.info('âœ… Firebase Remote Config initialized');
        } catch (e) {
          AppLogger.warning(
            'âš ï¸  Remote Config fetch failed, using defaults: $e',
          );
        }
      } catch (e) {
        AppLogger.warning('âš ï¸  Remote Config initialization failed: $e');
      }

      // Initialize Crashlytics
      try {
        if (!kDebugMode) {
          FlutterError.onError = _crashlytics.recordFlutterError;
          AppLogger.info('âœ… Firebase Crashlytics initialized');
        }
      } catch (e) {
        AppLogger.warning('âš ï¸  Crashlytics initialization failed: $e');
      }
    } catch (e) {
      AppLogger.error('âŒ Firebase services initialization failed: $e');
      throw Exception('Firebase not available - monitoring will be limited');
    }
  }

  Future<void> _setupABTesting() async {
    // Define A/B test experiments
    final experiments = [
      'rag_integration_approach',
      'ui_response_format',
      'cache_strategy',
      'user_feedback_method',
    ];

    for (final experiment in experiments) {
      await getABTestVariant(experiment);
    }
  }

  Future<String> _determineABTestVariant(String experimentName) async {
    // Simple hash-based variant assignment for consistency
    final userId = await _getUserId();
    final hashInput = '$userId$experimentName';
    final hash = hashInput.hashCode.abs();

    switch (experimentName) {
      case 'rag_integration_approach':
        return ['api_first', 'cache_first', 'hybrid'][hash % 3];
      case 'ui_response_format':
        return ['detailed', 'concise', 'structured'][hash % 3];
      case 'cache_strategy':
        return ['aggressive', 'conservative', 'intelligent'][hash % 3];
      case 'user_feedback_method':
        return ['rating_only', 'quick_feedback', 'detailed_survey'][hash % 3];
      default:
        return 'default';
    }
  }

  Future<String> _getUserId() async {
    try {
      String? userId = await SecureStorageAdapter.read(key: 'user_id');
      if (userId == null) {
        userId = const Uuid().v4();
        await SecureStorageAdapter.write(key: 'user_id', value: userId);
      }
      return userId;
    } catch (e) {
      AppLogger.error('Failed to get user ID: $e');
      return 'anonymous_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _trackAppInitialization() async {
    try {
      await _analytics.logEvent(
        name: 'app_initialization',
        parameters: {
          'session_id': _sessionId,
          'platform': PlatformService.instance.platformName,
          'features_available':
              PlatformService.instance.availableFeatures.length,
          'monitoring_initialized': true,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to track app initialization: $e');
    }
  }

  Future<void> _trackPopularityMetrics(QueryMetrics metrics) async {
    // This would typically involve more sophisticated analysis
    // For now, we'll track basic popularity indicators
    try {
      await _analytics.logEvent(
        name: 'query_popularity',
        parameters: {
          'query_type': metrics.queryType,
          'success': metrics.success ?? false,
          'confidence': metrics.confidence ?? 0.0,
          'response_length': metrics.responseLength ?? 0,
          'session_id': _sessionId,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to track popularity metrics: $e');
    }
  }

  Future<void> _trackGeographicUsage(QueryMetrics metrics) async {
    if (!_remoteConfig.getBool('geographic_tracking_enabled')) return;

    try {
      // Check location permission and get approximate location
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // Low accuracy for privacy
        timeLimit: const Duration(seconds: 5),
      ).timeout(const Duration(seconds: 5));

      // Round coordinates for privacy (approximately 10km accuracy)
      final roundedLat = (position.latitude * 10).round() / 10;
      final roundedLon = (position.longitude * 10).round() / 10;

      final geographicEvent = GeographicEvent(
        traceId: metrics.traceId,
        latitude: roundedLat,
        longitude: roundedLon,
        queryType: metrics.queryType,
        timestamp: DateTime.now(),
      );

      _geographicEvents.add(geographicEvent);

      // Track aggregated geographic data
      await _analytics.logEvent(
        name: 'geographic_usage',
        parameters: {
          'query_type': metrics.queryType,
          'region_lat': roundedLat,
          'region_lon': roundedLon,
          'session_id': _sessionId,
        },
      );
    } catch (e) {
      // Silently fail for geographic tracking to maintain user privacy
      AppLogger.debug('Geographic tracking skipped: $e');
    }
  }

  String _categorizeError(String errorMessage) {
    final lowercaseError = errorMessage.toLowerCase();
    if (lowercaseError.contains('network') ||
        lowercaseError.contains('connection')) {
      return 'network_error';
    } else if (lowercaseError.contains('timeout')) {
      return 'timeout_error';
    } else if (lowercaseError.contains('authentication') ||
        lowercaseError.contains('unauthorized')) {
      return 'auth_error';
    } else if (lowercaseError.contains('server') ||
        lowercaseError.contains('500')) {
      return 'server_error';
    } else if (lowercaseError.contains('cache')) {
      return 'cache_error';
    } else {
      return 'unknown_error';
    }
  }

  Future<Map<String, dynamic>> _getGeographicSummary(
    DateTime cutoffTime,
  ) async {
    try {
      final recentEvents = _geographicEvents
          .where((e) => e.timestamp.isAfter(cutoffTime))
          .toList();

      final regionCounts = <String, int>{};
      for (final event in recentEvents) {
        final regionKey = '${event.latitude},${event.longitude}';
        regionCounts[regionKey] = (regionCounts[regionKey] ?? 0) + 1;
      }

      return {
        'total_geographic_queries': recentEvents.length,
        'unique_regions': regionCounts.length,
        'top_regions': regionCounts.entries
            .map((e) => {'region': e.key, 'count': e.value})
            .toList()
          ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int))
          ..take(5).toList(),
      };
    } catch (e) {
      return {'error': 'Failed to generate geographic summary'};
    }
  }

  void _startPeriodicFlush() {
    _flushTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _flushPendingData();
    });
  }

  Future<void> _flushPendingData() async {
    try {
      // Flush satisfaction data
      if (_satisfactionEvents.isNotEmpty) {
        final avgRating =
            _satisfactionEvents.map((s) => s.rating).reduce((a, b) => a + b) /
                _satisfactionEvents.length;

        await _analytics.logEvent(
          name: 'satisfaction_batch_flush',
          parameters: {
            'batch_size': _satisfactionEvents.length,
            'avg_rating': avgRating,
            'session_id': _sessionId,
          },
        );

        _satisfactionEvents.clear();
      }

      // Flush geographic data
      if (_geographicEvents.isNotEmpty) {
        await _analytics.logEvent(
          name: 'geographic_batch_flush',
          parameters: {
            'batch_size': _geographicEvents.length,
            'unique_regions': _geographicEvents
                .map((e) => '${e.latitude},${e.longitude}')
                .toSet()
                .length,
            'session_id': _sessionId,
          },
        );

        _geographicEvents.clear();
      }
    } catch (e) {
      AppLogger.error('Failed to flush pending data: $e');
    }
  }
}

// Supporting data classes

class QueryMetrics {
  final String traceId;
  final String query;
  final String queryType;
  final DateTime startTime;
  final Map<String, dynamic> metadata;

  DateTime? endTime;
  bool? success;
  double? confidence;
  int? responseLength;
  List<String> sources = [];
  String? errorMessage;
  bool wasCacheHit = false;
  int? userRating;
  String? userFeedback;

  QueryMetrics({
    required this.traceId,
    required this.query,
    required this.queryType,
    required this.startTime,
    required this.metadata,
  });
}

class UserSatisfactionEvent {
  final String traceId;
  final String queryType;
  final int rating;
  final String? feedback;
  final List<String> tags;
  final DateTime timestamp;
  final String sessionId;

  UserSatisfactionEvent({
    required this.traceId,
    required this.queryType,
    required this.rating,
    this.feedback,
    required this.tags,
    required this.timestamp,
    required this.sessionId,
  });
}

class GeographicEvent {
  final String traceId;
  final double latitude;
  final double longitude;
  final String queryType;
  final DateTime timestamp;

  GeographicEvent({
    required this.traceId,
    required this.latitude,
    required this.longitude,
    required this.queryType,
    required this.timestamp,
  });
}

class ABTestVariant {
  final String experimentName;
  final String variant;
  final DateTime assignmentTime;

  ABTestVariant({
    required this.experimentName,
    required this.variant,
    required this.assignmentTime,
  });
}
