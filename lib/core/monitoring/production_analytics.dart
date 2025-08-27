// lib/core/monitoring/production_analytics.dart

import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Analytics Event Categories
class AnalyticsCategory {
  static const String rag = 'rag';
  static const String search = 'search';
  static const String ui = 'ui';
  static const String performance = 'performance';
  static const String error = 'error';
  static const String user = 'user';
  static const String navigation = 'navigation';
  static const String feature = 'feature';
  static const String system = 'system';
}

/// Analytics Event Names
class AnalyticsEvent {
  // RAG Events
  static const String ragQueryStarted = 'rag_query_started';
  static const String ragQueryCompleted = 'rag_query_completed';
  static const String ragQueryFailed = 'rag_query_failed';
  static const String ragCacheHit = 'rag_cache_hit';
  static const String ragCacheMiss = 'rag_cache_miss';
  static const String ragResponseStreamed = 'rag_response_streamed';
  static const String ragOfflineMode = 'rag_offline_mode';

  // Search Events
  static const String islamicSearchPerformed = 'islamic_search_performed';
  static const String searchResultClicked = 'search_result_clicked';
  static const String voiceSearchUsed = 'voice_search_used';

  // UI Events
  static const String screenViewed = 'screen_viewed';
  static const String buttonClicked = 'button_clicked';
  static const String featureUsed = 'feature_used';

  // Performance Events
  static const String appStartup = 'app_startup';
  static const String appBackground = 'app_background';
  static const String appForeground = 'app_foreground';
  static const String memoryWarning = 'memory_warning';

  // Error Events
  static const String errorOccurred = 'error_occurred';
  static const String crashReported = 'crash_reported';
  static const String networkError = 'network_error';

  // User Events
  static const String userEngagement = 'user_engagement';
  static const String feedbackSubmitted = 'feedback_submitted';
  static const String ratingGiven = 'rating_given';

  // System Events
  static const String featureFlagChanged = 'feature_flag_changed';
  static const String configUpdated = 'config_updated';
}

/// Production Analytics Service
class ProductionAnalytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final Logger _logger = Logger();
  static const String _sessionKey = 'analytics_session';
  static const String _userPropertiesKey = 'analytics_user_properties';

  static String? _sessionId;
  static DateTime? _sessionStart;
  static bool _isInitialized = false;
  static PackageInfo? _packageInfo;
  static SharedPreferences? _prefs;

  /// Initialize analytics service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _prefs = await SharedPreferences.getInstance();

      // Set analytics collection enabled
      await _analytics.setAnalyticsCollectionEnabled(true);

      // Set user properties
      await _setUserProperties();

      // Start new session
      await _startNewSession();

      _isInitialized = true;
      _logger.i('ProductionAnalytics initialized successfully');

      // Track initialization
      await trackEvent(AnalyticsEvent.appStartup, {
        'app_version': _packageInfo?.version ?? 'unknown',
        'build_number': _packageInfo?.buildNumber ?? 'unknown',
        'platform': defaultTargetPlatform.name,
        'debug_mode': kDebugMode,
      });
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize ProductionAnalytics',
        error: e,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  static Future<void> _setUserProperties() async {
    try {
      await _analytics.setUserProperty(
        name: 'app_version',
        value: _packageInfo?.version ?? 'unknown',
      );

      await _analytics.setUserProperty(
        name: 'build_number',
        value: _packageInfo?.buildNumber ?? 'unknown',
      );

      await _analytics.setUserProperty(
        name: 'platform',
        value: defaultTargetPlatform.name,
      );

      await _analytics.setUserProperty(
        name: 'debug_mode',
        value: kDebugMode.toString(),
      );

      // Load and set custom user properties
      final savedProperties = _prefs?.getString(_userPropertiesKey);
      if (savedProperties != null) {
        final properties = json.decode(savedProperties) as Map<String, dynamic>;
        for (final entry in properties.entries) {
          await _analytics.setUserProperty(
            name: entry.key,
            value: entry.value?.toString(),
          );
        }
      }
    } catch (e) {
      _logger.w('Failed to set user properties', error: e);
    }
  }

  static Future<void> _startNewSession() async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _sessionStart = DateTime.now();

    await _prefs?.setString(
      _sessionKey,
      json.encode({
        'session_id': _sessionId,
        'start_time': _sessionStart?.millisecondsSinceEpoch,
      }),
    );
  }

  /// Track an analytics event
  static Future<void> trackEvent(
    String eventName, [
    Map<String, Object?>? parameters,
  ]) async {
    if (!_isInitialized) {
      _logger.w(
        'ProductionAnalytics not initialized, skipping event: $eventName',
      );
      return;
    }

    try {
      final enrichedParameters = <String, Object?>{
        'session_id': _sessionId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'app_version': _packageInfo?.version,
        'build_number': _packageInfo?.buildNumber,
        'platform': defaultTargetPlatform.name,
        ...?parameters,
      };

      // Remove null values and ensure proper types
      final filteredParameters = <String, Object>{};
      for (final entry in enrichedParameters.entries) {
        if (entry.value != null) {
          final value = entry.value!;
          if (value is String || value is num || value is bool) {
            filteredParameters[entry.key] = value;
          } else {
            filteredParameters[entry.key] = value.toString();
          }
        }
      }

      await _analytics.logEvent(
        name: _sanitizeEventName(eventName),
        parameters: filteredParameters,
      );

      if (kDebugMode) {
        _logger.d(
          'Analytics event tracked: $eventName with ${filteredParameters.length} parameters',
        );
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to track analytics event: $eventName',
        error: e,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  /// Track RAG query performance
  static Future<void> trackRagQueryPerformance({
    required String queryId,
    required Duration duration,
    required int resultCount,
    required String queryType,
    bool? cacheHit,
    String? errorMessage,
  }) async {
    await trackEvent(
      errorMessage == null ? AnalyticsEvent.ragQueryCompleted : AnalyticsEvent.ragQueryFailed,
      {
        'category': AnalyticsCategory.rag,
        'query_id': queryId,
        'duration_ms': duration.inMilliseconds,
        'result_count': resultCount,
        'query_type': queryType,
        'cache_hit': cacheHit,
        'error_message': errorMessage,
        'performance_category': _categorizePerformance(duration),
      },
    );
  }

  /// Track user engagement metrics
  static Future<void> trackUserEngagement({
    required String screen,
    required Duration timeSpent,
    int? interactionCount,
    Map<String, Object?>? customMetrics,
  }) async {
    await trackEvent(AnalyticsEvent.userEngagement, {
      'category': AnalyticsCategory.user,
      'screen': screen,
      'time_spent_seconds': timeSpent.inSeconds,
      'interaction_count': interactionCount,
      'engagement_level': _categorizeEngagement(timeSpent, interactionCount),
      ...?customMetrics,
    });
  }

  /// Track screen views
  static Future<void> trackScreenView(
    String screenName, [
    Map<String, Object?>? parameters,
  ]) async {
    await _analytics.logScreenView(screenName: screenName);

    await trackEvent(AnalyticsEvent.screenViewed, {
      'category': AnalyticsCategory.navigation,
      'screen_name': screenName,
      'session_time': _sessionStart != null ? DateTime.now().difference(_sessionStart!).inSeconds : 0,
      ...?parameters,
    });
  }

  /// Track feature usage
  static Future<void> trackFeatureUsage(
    String featureName,
    String action, [
    Map<String, Object?>? additionalData,
  ]) async {
    await trackEvent(AnalyticsEvent.featureUsed, {
      'category': AnalyticsCategory.feature,
      'feature_name': featureName,
      'action': action,
      ...?additionalData,
    });
  }

  /// Track performance metrics
  static Future<void> trackPerformanceMetric(
    String metricName,
    double value,
    String unit, [
    Map<String, Object?>? context,
  ]) async {
    await trackEvent('performance_metric', {
      'category': AnalyticsCategory.performance,
      'metric_name': metricName,
      'value': value,
      'unit': unit,
      'performance_tier': _categorizeMetricValue(metricName, value),
      ...?context,
    });
  }

  /// Track errors
  static Future<void> trackError(
    String errorType,
    String errorMessage, [
    Map<String, Object?>? errorContext,
  ]) async {
    await trackEvent(AnalyticsEvent.errorOccurred, {
      'category': AnalyticsCategory.error,
      'error_type': errorType,
      'error_message': errorMessage.length > 100 ? '${errorMessage.substring(0, 100)}...' : errorMessage,
      'timestamp': DateTime.now().toIso8601String(),
      ...?errorContext,
    });
  }

  /// Track user feedback
  static Future<void> trackFeedback({
    required String feedbackType,
    required double rating,
    String? comment,
    String? screen,
    Map<String, Object?>? metadata,
  }) async {
    await trackEvent(AnalyticsEvent.feedbackSubmitted, {
      'category': AnalyticsCategory.user,
      'feedback_type': feedbackType,
      'rating': rating,
      'has_comment': comment != null && comment.isNotEmpty,
      'comment_length': comment?.length ?? 0,
      'screen': screen,
      'feedback_quality': _categorizeFeedback(rating, comment),
      ...?metadata,
    });
  }

  /// Set custom user property
  static Future<void> setUserProperty(String name, String? value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);

      // Save to local cache
      final savedProperties = _prefs?.getString(_userPropertiesKey);
      Map<String, dynamic> properties = {};

      if (savedProperties != null) {
        properties = json.decode(savedProperties) as Map<String, dynamic>;
      }

      if (value != null) {
        properties[name] = value;
      } else {
        properties.remove(name);
      }

      await _prefs?.setString(_userPropertiesKey, json.encode(properties));
    } catch (e) {
      _logger.w('Failed to set user property: $name', error: e);
    }
  }

  /// Set user ID
  static Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      _logger.w('Failed to set user ID', error: e);
    }
  }

  /// Get current session ID
  static String? get sessionId => _sessionId;

  /// Get session duration
  static Duration get sessionDuration {
    if (_sessionStart != null) {
      return DateTime.now().difference(_sessionStart!);
    }
    return Duration.zero;
  }

  /// End current session
  static Future<void> endSession() async {
    if (_sessionStart != null) {
      await trackEvent('session_ended', {
        'session_duration_seconds': sessionDuration.inSeconds,
      });
    }
  }

  /// Utility methods
  static String _sanitizeEventName(String eventName) {
    return eventName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_').toLowerCase();
  }

  static String _categorizePerformance(Duration duration) {
    if (duration.inMilliseconds < 500) return 'fast';
    if (duration.inMilliseconds < 2000) return 'medium';
    if (duration.inMilliseconds < 5000) return 'slow';
    return 'very_slow';
  }

  static String _categorizeEngagement(Duration timeSpent, int? interactions) {
    final seconds = timeSpent.inSeconds;
    final interactionRate = interactions != null && seconds > 0 ? interactions / seconds : 0.0;

    if (seconds < 10) return 'brief';
    if (seconds < 60 && interactionRate > 0.1) return 'engaged';
    if (seconds < 300 && interactionRate > 0.05) return 'active';
    if (seconds >= 300) return 'deep';
    return 'passive';
  }

  static String _categorizeMetricValue(String metricName, double value) {
    // Define thresholds based on metric type
    switch (metricName.toLowerCase()) {
      case 'response_time_ms':
        if (value < 100) return 'excellent';
        if (value < 500) return 'good';
        if (value < 2000) return 'acceptable';
        return 'poor';
      case 'memory_usage_mb':
        if (value < 50) return 'low';
        if (value < 100) return 'normal';
        if (value < 200) return 'high';
        return 'critical';
      case 'cpu_usage_percent':
        if (value < 20) return 'low';
        if (value < 50) return 'normal';
        if (value < 80) return 'high';
        return 'critical';
      default:
        return 'unknown';
    }
  }

  static String _categorizeFeedback(double rating, String? comment) {
    final hasComment = comment != null && comment.trim().isNotEmpty;

    if (rating >= 4.0 && hasComment) return 'detailed_positive';
    if (rating >= 4.0) return 'positive';
    if (rating >= 3.0 && hasComment) return 'detailed_neutral';
    if (rating >= 3.0) return 'neutral';
    if (rating >= 1.0 && hasComment) return 'detailed_negative';
    return 'negative';
  }
}

/// Custom Analytics Event
class CustomAnalyticsEvent {
  final String name;
  final String category;
  final Map<String, Object?> parameters;
  final DateTime timestamp;

  CustomAnalyticsEvent({
    required this.name,
    required this.category,
    required this.parameters,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'category': category,
      'parameters': parameters,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

/// Analytics Batch Manager for efficient event batching
class AnalyticsBatchManager {
  static const int _maxBatchSize = 50;
  static const Duration _maxBatchAge = Duration(minutes: 5);

  static final List<CustomAnalyticsEvent> _eventBatch = [];
  static Timer? _batchTimer;

  static void addEvent(CustomAnalyticsEvent event) {
    _eventBatch.add(event);

    if (_eventBatch.length >= _maxBatchSize) {
      _flushBatch();
    } else {
      _batchTimer ??= Timer(_maxBatchAge, _flushBatch);
    }
  }

  static void _flushBatch() {
    if (_eventBatch.isNotEmpty) {
      // Process batch events
      for (final event in _eventBatch) {
        ProductionAnalytics.trackEvent(event.name, {
          'category': event.category,
          'batch_size': _eventBatch.length,
          ...event.parameters,
        });
      }

      _eventBatch.clear();
    }

    _batchTimer?.cancel();
    _batchTimer = null;
  }

  static void dispose() {
    _flushBatch();
  }
}
