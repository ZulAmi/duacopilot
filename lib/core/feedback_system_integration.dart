import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../presentation/widgets/feedback/scholar_feedback_system.dart';
import '../services/ab_testing_framework.dart';
import '../services/comprehensive_feedback_service.dart';

/// Main feedback system integration service
/// Coordinates all feedback, analytics, and A/B testing functionality
class FeedbackSystemIntegration {
  static const String _serviceName = 'FeedbackSystemIntegration';

  late final ComprehensiveFeedbackService _feedbackService;
  late final ABTestingFramework _abTestingFramework;
  late final ScholarFeedbackSystem _scholarFeedbackSystem;

  bool _initialized = false;

  /// Get singleton instance
  static FeedbackSystemIntegration get instance {
    if (GetIt.instance.isRegistered<FeedbackSystemIntegration>()) {
      return GetIt.instance<FeedbackSystemIntegration>();
    }

    final integration = FeedbackSystemIntegration._internal();
    GetIt.instance.registerSingleton<FeedbackSystemIntegration>(integration);
    return integration;
  }

  FeedbackSystemIntegration._internal();

  /// Initialize the entire feedback system
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize comprehensive feedback service
      _feedbackService = ComprehensiveFeedbackService();
      await _feedbackService.initialize();

      // Initialize A/B testing framework
      _abTestingFramework = ABTestingFramework(
        remoteConfig: FirebaseRemoteConfig.instance,
        feedbackService: _feedbackService,
      );
      await _abTestingFramework.initialize();

      // Initialize scholar feedback system
      _scholarFeedbackSystem = ScholarFeedbackSystem(_feedbackService);

      // Register services with GetIt
      if (!GetIt.instance.isRegistered<ComprehensiveFeedbackService>()) {
        GetIt.instance.registerSingleton<ComprehensiveFeedbackService>(
          _feedbackService,
        );
      }

      if (!GetIt.instance.isRegistered<ABTestingFramework>()) {
        GetIt.instance.registerSingleton<ABTestingFramework>(
          _abTestingFramework,
        );
      }

      if (!GetIt.instance.isRegistered<ScholarFeedbackSystem>()) {
        GetIt.instance.registerSingleton<ScholarFeedbackSystem>(
          _scholarFeedbackSystem,
        );
      }

      _initialized = true;

      // Log successful initialization
      debugPrint('Feedback System Integration initialized successfully');

      // Track initialization analytics
      await _feedbackService.trackUsageAnalytics(
        action: 'feedback_system_initialized',
        contentId: _serviceName,
        contentType: 'system',
        additionalData: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'version': '1.0.0',
        },
      );
    } catch (e) {
      debugPrint('Error initializing Feedback System Integration: $e');
      rethrow;
    }
  }

  /// Dispose all services
  Future<void> dispose() async {
    if (_initialized) {
      await _feedbackService.dispose();
      _initialized = false;
    }
  }

  // Getters for services
  ComprehensiveFeedbackService get feedbackService => _feedbackService;
  ABTestingFramework get abTestingFramework => _abTestingFramework;
  ScholarFeedbackSystem get scholarFeedbackSystem => _scholarFeedbackSystem;

  /// Quick access methods for common operations

  /// Submit Du'a relevance rating
  Future<bool> rateDua({
    required String duaId,
    required String queryId,
    required double rating,
    String? comment,
    Map<String, dynamic>? context,
  }) async {
    return await _feedbackService.submitDuaRelevanceRating(
      duaId: duaId,
      queryId: queryId,
      rating: rating,
      comment: comment,
      context: context,
    );
  }

  /// Submit contextual feedback
  Future<bool> submitContextualFeedback({
    required String contentId,
    required String contentType,
    required Map<String, dynamic> feedbackData,
    List<String>? tags,
  }) async {
    return await _feedbackService.submitContextualFeedback(
      contentId: contentId,
      contentType: contentType,
      feedbackData: feedbackData,
      tags: tags,
    );
  }

  /// Track reading time
  Future<void> trackReadingTime({
    required String contentId,
    required Duration readingTime,
    String? contentCategory,
    bool completed = false,
  }) async {
    await _feedbackService.trackReadingTime(
      contentId: contentId,
      readingTime: readingTime,
      contentCategory: contentCategory,
      completed: completed,
    );
  }

  /// Track audio playback
  Future<void> trackAudioPlayback({
    required String contentId,
    required Duration playbackTime,
    Duration? totalDuration,
    bool completed = false,
  }) async {
    await _feedbackService.trackAudioPlay(
      contentId: contentId,
      playbackTime: playbackTime,
      totalDuration: totalDuration,
      completed: completed,
    );
  }

  /// Track sharing activity
  Future<void> trackShare({
    required String contentId,
    required String shareMethod,
    String? contentType,
  }) async {
    await _feedbackService.trackShare(
      contentId: contentId,
      shareMethod: shareMethod,
      contentType: contentType,
    );
  }

  /// Submit scholar verification
  Future<bool> submitScholarVerification({
    required String contentId,
    required String scholarId,
    required ScholarLevel scholarLevel,
    required bool isAuthentic,
    required String authenticity,
    List<String>? sources,
    String? comments,
    Map<String, String>? credentials,
  }) async {
    return await _scholarFeedbackSystem.submitScholarVerification(
      contentId: contentId,
      scholarId: scholarId,
      scholarLevel: scholarLevel,
      isAuthentic: isAuthentic,
      authenticity: authenticity,
      sources: sources,
      comments: comments,
      credentials: credentials,
    );
  }

  /// Get A/B test variant
  T getABTestVariant<T>(String experimentName, T defaultValue) {
    return _abTestingFramework.getVariant(experimentName, defaultValue);
  }

  /// Track A/B test conversion
  Future<void> trackABTestConversion({
    required String experimentName,
    required String conversionType,
    double? value,
  }) async {
    await _abTestingFramework.trackConversion(
      experimentName: experimentName,
      conversionType: conversionType,
      value: value,
    );
  }

  /// Get aggregated analytics
  Future<Map<String, dynamic>> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _feedbackService.getAggregatedAnalytics(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Export anonymized data for research
  Future<Map<String, dynamic>> exportAnonymizedData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _feedbackService.exportAnonymizedData(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Clear all user data (GDPR compliance)
  Future<void> clearAllUserData() async {
    await _feedbackService.clearAllData();
  }

  /// Check if advanced feedback UI is enabled
  bool get isAdvancedFeedbackUIEnabled {
    return _feedbackService.isAdvancedFeedbackUIEnabled;
  }

  /// Get rating widget style from A/B test
  String get ratingWidgetStyle {
    return _feedbackService.ratingWidgetStyle;
  }
}

/// Extension methods for easy integration with existing services
extension FeedbackIntegrationExtensions on GetIt {
  /// Get feedback service
  ComprehensiveFeedbackService get feedbackService {
    return get<ComprehensiveFeedbackService>();
  }

  /// Get A/B testing framework
  ABTestingFramework get abTestingFramework {
    return get<ABTestingFramework>();
  }

  /// Get scholar feedback system
  ScholarFeedbackSystem get scholarFeedbackSystem {
    return get<ScholarFeedbackSystem>();
  }

  /// Get main feedback integration
  FeedbackSystemIntegration get feedbackIntegration {
    return get<FeedbackSystemIntegration>();
  }
}

/// Mixin for widgets that need feedback functionality
mixin FeedbackMixin<T extends StatefulWidget> on State<T> {
  late final FeedbackSystemIntegration _feedbackIntegration;

  @override
  void initState() {
    super.initState();
    _feedbackIntegration = FeedbackSystemIntegration.instance;
  }

  /// Quick access to feedback services
  ComprehensiveFeedbackService get feedbackService => _feedbackIntegration.feedbackService;
  ABTestingFramework get abTesting => _feedbackIntegration.abTestingFramework;
  ScholarFeedbackSystem get scholarFeedback => _feedbackIntegration.scholarFeedbackSystem;

  /// Convenience methods
  Future<void> rateDua(String duaId, String queryId, double rating) async {
    await _feedbackIntegration.rateDua(
      duaId: duaId,
      queryId: queryId,
      rating: rating,
    );
  }

  Future<void> trackReading(String contentId, Duration duration) async {
    await _feedbackIntegration.trackReadingTime(
      contentId: contentId,
      readingTime: duration,
    );
  }

  Future<void> trackAudio(String contentId, Duration duration) async {
    await _feedbackIntegration.trackAudioPlayback(
      contentId: contentId,
      playbackTime: duration,
    );
  }

  Future<void> trackSharing(String contentId, String method) async {
    await _feedbackIntegration.trackShare(
      contentId: contentId,
      shareMethod: method,
    );
  }

  V getVariant<V>(String experiment, V defaultValue) {
    return _feedbackIntegration.getABTestVariant(experiment, defaultValue);
  }
}

/// Analytics event names for consistency
class AnalyticsEvents {
  static const String duaRated = 'dua_rated';
  static const String feedbackSubmitted = 'feedback_submitted';
  static const String scholarVerification = 'scholar_verification';
  static const String readingTimeTracked = 'reading_time_tracked';
  static const String audioPlaybackTracked = 'audio_playback_tracked';
  static const String contentShared = 'content_shared';
  static const String abTestConversion = 'ab_test_conversion';
  static const String feedbackFormOpened = 'feedback_form_opened';
  static const String ratingWidgetInteraction = 'rating_widget_interaction';
  static const String scholarFormSubmitted = 'scholar_form_submitted';
}

/// Feedback types for consistency
class FeedbackTypes {
  static const String duaRelevance = 'dua_relevance';
  static const String contentQuality = 'content_quality';
  static const String scholarVerification = 'scholar_verification';
  static const String bugReport = 'bug_report';
  static const String featureRequest = 'feature_request';
  static const String generalFeedback = 'general_feedback';
}
