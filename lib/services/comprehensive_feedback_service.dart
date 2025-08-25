import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive feedback system for RAG improvement
/// Handles analytics, A/B testing, and privacy-preserving data collection
class ComprehensiveFeedbackService {
  static const String _feedbackBoxName = 'feedback_data';
  static const String _analyticsBoxName = 'analytics_data';
  static const String _prefsPrefix = 'feedback_prefs_';

  final FirebaseAnalytics _analytics;
  final FirebaseRemoteConfig _remoteConfig;
  late Box<Map<String, dynamic>> _feedbackBox;
  late Box<Map<String, dynamic>> _analyticsBox;
  late SharedPreferences _prefs;

  bool _initialized = false;
  Timer? _batchUploadTimer;
  final List<Map<String, dynamic>> _pendingAnalytics = [];

  ComprehensiveFeedbackService({FirebaseAnalytics? analytics, FirebaseRemoteConfig? remoteConfig})
    : _analytics = analytics ?? FirebaseAnalytics.instance,
      _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  /// Initialize the feedback service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize storage
      _feedbackBox = await Hive.openBox<Map<String, dynamic>>(_feedbackBoxName);
      _analyticsBox = await Hive.openBox<Map<String, dynamic>>(_analyticsBoxName);
      _prefs = await SharedPreferences.getInstance();

      // Initialize Firebase Remote Config
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1), minimumFetchInterval: const Duration(hours: 1)),
      );

      // Set default values for A/B testing
      await _remoteConfig.setDefaults({
        'enable_advanced_feedback_ui': true,
        'feedback_form_version': 'v2',
        'rating_widget_style': 'modern',
        'analytics_batch_size': 10,
        'analytics_upload_interval_minutes': 5,
      });

      await _remoteConfig.fetchAndActivate();

      // Start batch upload timer for analytics
      _startBatchUploadTimer();

      _initialized = true;

      // Log initialization
      await _logEvent('feedback_service_initialized', {
        'version': '1.0.0',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('Error initializing ComprehensiveFeedbackService: $e');
      rethrow;
    }
  }

  /// Submit Du'a relevance rating
  Future<bool> submitDuaRelevanceRating({
    required String duaId,
    required String queryId,
    required double rating,
    String? comment,
    Map<String, dynamic>? context,
  }) async {
    await _ensureInitialized();

    try {
      final feedbackData = {
        'type': 'dua_relevance_rating',
        'dua_id': duaId,
        'query_id': queryId,
        'rating': rating,
        'comment': comment,
        'context': context,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'user_id': await _getUserId(),
      };

      // Store locally for privacy-preserving analytics
      await _storeFeedbackLocally(feedbackData);

      // Log analytics event
      await _logEvent('dua_rating_submitted', {
        'rating': rating,
        'has_comment': comment != null,
        'dua_category': context?['category'] ?? 'unknown',
      });

      return true;
    } catch (e) {
      debugPrint('Error submitting Du\'a relevance rating: $e');
      return false;
    }
  }

  /// Submit contextual feedback form
  Future<bool> submitContextualFeedback({
    required String contentId,
    required String contentType,
    required Map<String, dynamic> feedbackData,
    List<String>? tags,
  }) async {
    await _ensureInitialized();

    try {
      final feedback = {
        'type': 'contextual_feedback',
        'content_id': contentId,
        'content_type': contentType,
        'feedback_data': feedbackData,
        'tags': tags ?? [],
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'user_id': await _getUserId(),
        'form_version': _remoteConfig.getString('feedback_form_version'),
      };

      // Validate feedback data
      if (!_validateFeedbackData(feedbackData)) {
        throw ArgumentError('Invalid feedback data structure');
      }

      await _storeFeedbackLocally(feedback);

      // Log analytics
      await _logEvent('contextual_feedback_submitted', {
        'content_type': contentType,
        'feedback_fields': feedbackData.keys.toList(),
        'tag_count': tags?.length ?? 0,
      });

      return true;
    } catch (e) {
      debugPrint('Error submitting contextual feedback: $e');
      return false;
    }
  }

  /// Track usage analytics
  Future<void> trackUsageAnalytics({
    required String action,
    required String contentId,
    String? contentType,
    Duration? duration,
    Map<String, dynamic>? additionalData,
  }) async {
    await _ensureInitialized();

    try {
      final analyticsData = {
        'action': action,
        'content_id': contentId,
        'content_type': contentType,
        'duration_ms': duration?.inMilliseconds,
        'additional_data': additionalData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'user_id': await _getUserId(),
      };

      // Add to pending analytics for batch processing
      _pendingAnalytics.add(analyticsData);

      // Store locally for privacy preservation
      await _storeAnalyticsLocally(analyticsData);

      // Check if we should upload batch
      if (_pendingAnalytics.length >= _remoteConfig.getInt('analytics_batch_size')) {
        await _uploadAnalyticsBatch();
      }
    } catch (e) {
      debugPrint('Error tracking usage analytics: $e');
    }
  }

  /// Track reading time
  Future<void> trackReadingTime({
    required String contentId,
    required Duration readingTime,
    String? contentCategory,
    bool completed = false,
  }) async {
    await trackUsageAnalytics(
      action: 'reading_time',
      contentId: contentId,
      contentType: contentCategory ?? 'dua',
      duration: readingTime,
      additionalData: {'completed': completed, 'reading_speed_wpm': _calculateReadingSpeed(readingTime)},
    );
  }

  /// Track audio playback
  Future<void> trackAudioPlay({
    required String contentId,
    required Duration playbackTime,
    Duration? totalDuration,
    bool completed = false,
  }) async {
    await trackUsageAnalytics(
      action: 'audio_play',
      contentId: contentId,
      contentType: 'audio',
      duration: playbackTime,
      additionalData: {
        'total_duration_ms': totalDuration?.inMilliseconds,
        'completion_rate': totalDuration != null ? playbackTime.inMilliseconds / totalDuration.inMilliseconds : null,
        'completed': completed,
      },
    );
  }

  /// Track sharing activity
  Future<void> trackShare({required String contentId, required String shareMethod, String? contentType}) async {
    await trackUsageAnalytics(
      action: 'share',
      contentId: contentId,
      contentType: contentType ?? 'dua',
      additionalData: {'share_method': shareMethod},
    );
  }

  /// Submit scholar feedback for content authenticity
  Future<bool> submitScholarFeedback({
    required String contentId,
    required String scholarId,
    required Map<String, dynamic> authenticationData,
    required bool isAuthentic,
    String? comments,
    List<String>? sources,
  }) async {
    await _ensureInitialized();

    try {
      final scholarFeedback = {
        'type': 'scholar_feedback',
        'content_id': contentId,
        'scholar_id': scholarId,
        'authentication_data': authenticationData,
        'is_authentic': isAuthentic,
        'comments': comments,
        'sources': sources ?? [],
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'verification_level': _determineVerificationLevel(authenticationData),
      };

      await _storeFeedbackLocally(scholarFeedback);

      // This is high-priority feedback, attempt immediate upload
      await _uploadScholarFeedback(scholarFeedback);

      await _logEvent('scholar_feedback_submitted', {
        'is_authentic': isAuthentic,
        'has_sources': sources?.isNotEmpty ?? false,
        'verification_level': scholarFeedback['verification_level'] as Object,
      });

      return true;
    } catch (e) {
      debugPrint('Error submitting scholar feedback: $e');
      return false;
    }
  }

  /// Get A/B test variant for UI variations
  String getUIVariant(String testName, {String defaultVariant = 'control'}) {
    if (!_initialized) return defaultVariant;

    try {
      return _remoteConfig.getString('${testName}_variant');
    } catch (e) {
      debugPrint('Error getting UI variant for $testName: $e');
      return defaultVariant;
    }
  }

  /// Check if advanced feedback UI is enabled
  bool get isAdvancedFeedbackUIEnabled {
    return _remoteConfig.getBool('enable_advanced_feedback_ui');
  }

  /// Get rating widget style
  String get ratingWidgetStyle {
    return _remoteConfig.getString('rating_widget_style');
  }

  /// Get aggregated analytics (privacy-preserving)
  Future<Map<String, dynamic>> getAggregatedAnalytics({DateTime? startDate, DateTime? endDate}) async {
    await _ensureInitialized();

    try {
      final analytics = _analyticsBox.values.toList();

      // Filter by date range if provided
      final filteredAnalytics =
          analytics.where((data) {
            final timestamp = data['timestamp'] as int;
            final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

            if (startDate != null && date.isBefore(startDate)) return false;
            if (endDate != null && date.isAfter(endDate)) return false;

            return true;
          }).toList();

      // Aggregate data
      return _aggregateAnalyticsData(filteredAnalytics);
    } catch (e) {
      debugPrint('Error getting aggregated analytics: $e');
      return {};
    }
  }

  /// Export anonymized data for research
  Future<Map<String, dynamic>> exportAnonymizedData({DateTime? startDate, DateTime? endDate}) async {
    await _ensureInitialized();

    final analytics = await getAggregatedAnalytics(startDate: startDate, endDate: endDate);

    final feedback = _feedbackBox.values.toList();

    // Remove personally identifiable information
    final anonymizedFeedback =
        feedback
            .map((data) => {...data, 'user_id': 'anonymized', 'timestamp': _roundTimestamp(data['timestamp'] as int)})
            .toList();

    return {
      'analytics': analytics,
      'feedback': anonymizedFeedback,
      'metadata': {
        'export_date': DateTime.now().millisecondsSinceEpoch,
        'date_range': {'start': startDate?.millisecondsSinceEpoch, 'end': endDate?.millisecondsSinceEpoch},
      },
    };
  }

  /// Clear all stored data (for privacy compliance)
  Future<void> clearAllData() async {
    await _ensureInitialized();

    await _feedbackBox.clear();
    await _analyticsBox.clear();
    _pendingAnalytics.clear();

    // Clear preferences
    final keys = _prefs.getKeys().where((key) => key.startsWith(_prefsPrefix)).toList();

    for (final key in keys) {
      await _prefs.remove(key);
    }

    await _logEvent('user_data_cleared', {});
  }

  /// Dispose resources
  Future<void> dispose() async {
    _batchUploadTimer?.cancel();
    await _feedbackBox.close();
    await _analyticsBox.close();
  }

  // Private methods

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  Future<String> _getUserId() async {
    const key = '${_prefsPrefix}user_id';
    String? userId = _prefs.getString(key);

    if (userId == null) {
      userId = DateTime.now().millisecondsSinceEpoch.toString();
      await _prefs.setString(key, userId);
    }

    return userId;
  }

  Future<void> _storeFeedbackLocally(Map<String, dynamic> feedback) async {
    await _feedbackBox.add(feedback);
  }

  Future<void> _storeAnalyticsLocally(Map<String, dynamic> analytics) async {
    await _analyticsBox.add(analytics);
  }

  Future<void> _logEvent(String eventName, Map<String, Object> parameters) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      debugPrint('Error logging analytics event: $e');
    }
  }

  bool _validateFeedbackData(Map<String, dynamic> data) {
    // Basic validation - can be expanded based on requirements
    return data.isNotEmpty;
  }

  String _determineVerificationLevel(Map<String, dynamic> authData) {
    // Determine verification level based on authentication data
    // This would be customized based on your scholar verification system
    return 'verified'; // Placeholder
  }

  double _calculateReadingSpeed(Duration readingTime) {
    // Estimate reading speed in words per minute
    // This is a simplified calculation
    const averageWordsPerDua = 50; // Estimate
    return (averageWordsPerDua / readingTime.inMinutes).clamp(0, 300);
  }

  int _roundTimestamp(int timestamp) {
    // Round timestamp to hour for privacy (removes precise timing)
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final roundedDate = DateTime(date.year, date.month, date.day, date.hour);
    return roundedDate.millisecondsSinceEpoch;
  }

  Map<String, dynamic> _aggregateAnalyticsData(List<Map<String, dynamic>> data) {
    final Map<String, int> actionCounts = {};
    final Map<String, int> contentTypeCounts = {};
    final Map<String, List<int>> durationsByAction = {};

    for (final item in data) {
      final action = item['action'] as String;
      final contentType = item['content_type'] as String?;
      final duration = item['duration_ms'] as int?;

      actionCounts[action] = (actionCounts[action] ?? 0) + 1;

      if (contentType != null) {
        contentTypeCounts[contentType] = (contentTypeCounts[contentType] ?? 0) + 1;
      }

      if (duration != null) {
        durationsByAction.putIfAbsent(action, () => []).add(duration);
      }
    }

    // Calculate average durations
    final Map<String, double> averageDurations = {};
    durationsByAction.forEach((action, durations) {
      averageDurations[action] = durations.reduce((a, b) => a + b) / durations.length;
    });

    return {
      'action_counts': actionCounts,
      'content_type_counts': contentTypeCounts,
      'average_durations_ms': averageDurations,
      'total_events': data.length,
    };
  }

  void _startBatchUploadTimer() {
    final interval = Duration(minutes: _remoteConfig.getInt('analytics_upload_interval_minutes'));

    _batchUploadTimer = Timer.periodic(interval, (_) => _uploadAnalyticsBatch());
  }

  Future<void> _uploadAnalyticsBatch() async {
    if (_pendingAnalytics.isEmpty) return;

    try {
      // In a real implementation, this would upload to your backend
      // For now, we'll just log and clear the batch
      debugPrint('Uploading analytics batch: ${_pendingAnalytics.length} events');

      // Simulate upload
      await Future.delayed(const Duration(milliseconds: 500));

      _pendingAnalytics.clear();
    } catch (e) {
      debugPrint('Error uploading analytics batch: $e');
    }
  }

  Future<void> _uploadScholarFeedback(Map<String, dynamic> feedback) async {
    try {
      // High-priority upload for scholar feedback
      debugPrint('Uploading scholar feedback: ${feedback['content_id']}');

      // Simulate upload
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      debugPrint('Error uploading scholar feedback: $e');
    }
  }
}
