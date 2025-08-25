import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/comprehensive_feedback_service.dart';

/// Mixin for tracking reading time analytics
mixin ReadingTimeTracker<T extends StatefulWidget> on State<T> {
  DateTime? _readingStartTime;
  Timer? _readingTimer;
  Duration _totalReadingTime = Duration.zero;
  String? _contentId;
  String? _contentCategory;
  bool _isVisible = false;

  ComprehensiveFeedbackService? _feedbackService;

  /// Initialize reading time tracking
  void initializeReadingTracker({
    required String contentId,
    String? contentCategory,
    ComprehensiveFeedbackService? feedbackService,
  }) {
    _contentId = contentId;
    _contentCategory = contentCategory;
    _feedbackService = feedbackService;
  }

  /// Start tracking reading time
  void startReadingTime() {
    if (_contentId == null) return;

    _readingStartTime = DateTime.now();
    _isVisible = true;

    // Start periodic timer to track reading sessions
    _readingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _trackReadingSession();
    });
  }

  /// Stop tracking reading time
  void stopReadingTime({bool completed = false}) {
    if (_readingStartTime == null || _contentId == null) return;

    final sessionDuration = DateTime.now().difference(_readingStartTime!);
    _totalReadingTime += sessionDuration;
    _isVisible = false;

    _readingTimer?.cancel();

    // Track the reading session
    _feedbackService?.trackReadingTime(
      contentId: _contentId!,
      readingTime: _totalReadingTime,
      contentCategory: _contentCategory,
      completed: completed,
    );

    _readingStartTime = null;
  }

  /// Pause reading time (e.g., when app goes to background)
  void pauseReadingTime() {
    if (_readingStartTime == null || !_isVisible) return;

    final sessionDuration = DateTime.now().difference(_readingStartTime!);
    _totalReadingTime += sessionDuration;
    _readingStartTime = null;
    _readingTimer?.cancel();
  }

  /// Resume reading time (e.g., when app comes to foreground)
  void resumeReadingTime() {
    if (!_isVisible) return;

    _readingStartTime = DateTime.now();
    _readingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _trackReadingSession();
    });
  }

  void _trackReadingSession() {
    if (_readingStartTime == null || _contentId == null) return;

    final sessionDuration = DateTime.now().difference(_readingStartTime!) + _totalReadingTime;

    // Track reading progress every 5 seconds for analytics
    _feedbackService?.trackUsageAnalytics(
      action: 'reading_progress',
      contentId: _contentId!,
      contentType: _contentCategory ?? 'dua',
      duration: sessionDuration,
    );
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    super.dispose();
  }
}

/// Widget that automatically tracks reading time for its child
class ReadingTimeTrackerWidget extends StatefulWidget {
  final Widget child;
  final String contentId;
  final String? contentCategory;
  final ComprehensiveFeedbackService? feedbackService;
  final Function(Duration)? onReadingTimeUpdate;

  const ReadingTimeTrackerWidget({
    super.key,
    required this.child,
    required this.contentId,
    this.contentCategory,
    this.feedbackService,
    this.onReadingTimeUpdate,
  });

  @override
  State<ReadingTimeTrackerWidget> createState() => _ReadingTimeTrackerWidgetState();
}

class _ReadingTimeTrackerWidgetState extends State<ReadingTimeTrackerWidget>
    with WidgetsBindingObserver, ReadingTimeTracker {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initializeReadingTracker(
      contentId: widget.contentId,
      contentCategory: widget.contentCategory,
      feedbackService: widget.feedbackService,
    );

    // Start tracking when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startReadingTime();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopReadingTime(completed: true);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resumeReadingTime();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        pauseReadingTime();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Audio playback tracking widget
class AudioPlaybackTracker extends StatefulWidget {
  final Widget child;
  final String contentId;
  final Duration? totalDuration;
  final ComprehensiveFeedbackService? feedbackService;
  final Function(Duration)? onPlaybackTimeUpdate;

  const AudioPlaybackTracker({
    super.key,
    required this.child,
    required this.contentId,
    this.totalDuration,
    this.feedbackService,
    this.onPlaybackTimeUpdate,
  });

  @override
  State<AudioPlaybackTracker> createState() => _AudioPlaybackTrackerState();
}

class _AudioPlaybackTrackerState extends State<AudioPlaybackTracker> {
  DateTime? _playbackStartTime;
  Duration _totalPlaybackTime = Duration.zero;
  bool _isPlaying = false;
  Timer? _trackingTimer;

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }

  /// Start tracking audio playback
  void startPlaybackTracking() {
    _playbackStartTime = DateTime.now();
    _isPlaying = true;

    // Track playback progress periodically
    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _trackPlaybackProgress();
    });
  }

  /// Stop tracking audio playback
  void stopPlaybackTracking({bool completed = false}) {
    _stopTracking();

    // Final tracking
    widget.feedbackService?.trackAudioPlay(
      contentId: widget.contentId,
      playbackTime: _totalPlaybackTime,
      totalDuration: widget.totalDuration,
      completed: completed,
    );
  }

  /// Pause tracking
  void pausePlaybackTracking() {
    if (_playbackStartTime != null) {
      _totalPlaybackTime += DateTime.now().difference(_playbackStartTime!);
      _playbackStartTime = null;
    }
    _isPlaying = false;
    _trackingTimer?.cancel();
  }

  /// Resume tracking
  void resumePlaybackTracking() {
    _playbackStartTime = DateTime.now();
    _isPlaying = true;

    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _trackPlaybackProgress();
    });
  }

  void _stopTracking() {
    if (_playbackStartTime != null) {
      _totalPlaybackTime += DateTime.now().difference(_playbackStartTime!);
      _playbackStartTime = null;
    }
    _isPlaying = false;
    _trackingTimer?.cancel();
  }

  void _trackPlaybackProgress() {
    if (!_isPlaying || _playbackStartTime == null) return;

    final currentPlaybackTime = _totalPlaybackTime + DateTime.now().difference(_playbackStartTime!);

    widget.onPlaybackTimeUpdate?.call(currentPlaybackTime);

    // Track progress analytics
    widget.feedbackService?.trackUsageAnalytics(
      action: 'audio_progress',
      contentId: widget.contentId,
      contentType: 'audio',
      duration: currentPlaybackTime,
      additionalData: {
        'total_duration_ms': widget.totalDuration?.inMilliseconds,
        'completion_percentage':
            widget.totalDuration != null
                ? (currentPlaybackTime.inMilliseconds / widget.totalDuration!.inMilliseconds * 100).clamp(0, 100)
                : null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Share tracking widget
class ShareTrackingButton extends StatefulWidget {
  final String contentId;
  final String? contentType;
  final String shareMethod;
  final Widget child;
  final VoidCallback? onPressed;
  final ComprehensiveFeedbackService? feedbackService;

  const ShareTrackingButton({
    super.key,
    required this.contentId,
    this.contentType,
    required this.shareMethod,
    required this.child,
    this.onPressed,
    this.feedbackService,
  });

  @override
  State<ShareTrackingButton> createState() => _ShareTrackingButtonState();
}

class _ShareTrackingButtonState extends State<ShareTrackingButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleShare() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    // Animation feedback
    await _animationController.forward();
    await _animationController.reverse();

    // Track the share event
    widget.feedbackService?.trackShare(
      contentId: widget.contentId,
      shareMethod: widget.shareMethod,
      contentType: widget.contentType,
    );

    // Call the original onPressed
    widget.onPressed?.call();

    setState(() {
      _isSharing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder:
          (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(onTap: _handleShare, child: widget.child),
          ),
    );
  }
}

/// Usage analytics widget for tracking user interactions
class UsageAnalyticsWidget extends StatefulWidget {
  final Widget child;
  final String contentId;
  final String? contentType;
  final Map<String, dynamic>? additionalData;
  final ComprehensiveFeedbackService? feedbackService;

  const UsageAnalyticsWidget({
    super.key,
    required this.child,
    required this.contentId,
    this.contentType,
    this.additionalData,
    this.feedbackService,
  });

  @override
  State<UsageAnalyticsWidget> createState() => _UsageAnalyticsWidgetState();
}

class _UsageAnalyticsWidgetState extends State<UsageAnalyticsWidget> {
  DateTime? _viewStartTime;
  bool _hasTrackedView = false;

  @override
  void initState() {
    super.initState();
    _viewStartTime = DateTime.now();

    // Track initial view after a short delay to ensure meaningful view time
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_hasTrackedView) {
        _trackView();
      }
    });
  }

  @override
  void dispose() {
    _trackViewEnd();
    super.dispose();
  }

  void _trackView() {
    _hasTrackedView = true;
    widget.feedbackService?.trackUsageAnalytics(
      action: 'content_view',
      contentId: widget.contentId,
      contentType: widget.contentType ?? 'unknown',
      additionalData: {...?widget.additionalData, 'view_start_time': _viewStartTime?.millisecondsSinceEpoch},
    );
  }

  void _trackViewEnd() {
    if (!_hasTrackedView || _viewStartTime == null) return;

    final viewDuration = DateTime.now().difference(_viewStartTime!);

    widget.feedbackService?.trackUsageAnalytics(
      action: 'content_view_end',
      contentId: widget.contentId,
      contentType: widget.contentType ?? 'unknown',
      duration: viewDuration,
      additionalData: {...?widget.additionalData, 'meaningful_view': viewDuration.inSeconds > 3},
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Interaction tracking wrapper
class InteractionTracker extends StatelessWidget {
  final Widget child;
  final String actionName;
  final String contentId;
  final String? contentType;
  final VoidCallback? onTap;
  final ComprehensiveFeedbackService? feedbackService;
  final Map<String, dynamic>? additionalData;

  const InteractionTracker({
    super.key,
    required this.child,
    required this.actionName,
    required this.contentId,
    this.contentType,
    this.onTap,
    this.feedbackService,
    this.additionalData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Track the interaction
        feedbackService?.trackUsageAnalytics(
          action: actionName,
          contentId: contentId,
          contentType: contentType ?? 'unknown',
          additionalData: additionalData,
        );

        // Call the original onTap
        onTap?.call();
      },
      child: child,
    );
  }
}

/// Analytics dashboard data model
class AnalyticsDashboardData {
  final Map<String, int> actionCounts;
  final Map<String, int> contentTypeCounts;
  final Map<String, double> averageDurations;
  final int totalEvents;
  final DateTime startDate;
  final DateTime endDate;

  const AnalyticsDashboardData({
    required this.actionCounts,
    required this.contentTypeCounts,
    required this.averageDurations,
    required this.totalEvents,
    required this.startDate,
    required this.endDate,
  });

  factory AnalyticsDashboardData.fromMap(Map<String, dynamic> data) {
    return AnalyticsDashboardData(
      actionCounts: Map<String, int>.from(data['action_counts'] ?? {}),
      contentTypeCounts: Map<String, int>.from(data['content_type_counts'] ?? {}),
      averageDurations: Map<String, double>.from(data['average_durations_ms'] ?? {}),
      totalEvents: data['total_events'] ?? 0,
      startDate: DateTime.fromMillisecondsSinceEpoch(data['start_date'] ?? 0),
      endDate: DateTime.fromMillisecondsSinceEpoch(data['end_date'] ?? 0),
    );
  }
}
