// lib/core/feedback/user_feedback_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../monitoring/production_analytics.dart';
import '../monitoring/production_crash_reporter.dart';

/// Feedback Types
enum FeedbackType { general, bug, feature, rag, ui, performance, rating }

/// Feedback Severity
enum FeedbackSeverity { low, medium, high, critical }

/// User Feedback Model
class UserFeedback {
  final String id;
  final FeedbackType type;
  final FeedbackSeverity severity;
  final double rating;
  final String title;
  final String description;
  final String? email;
  final String? userId;
  final DateTime timestamp;
  final String appVersion;
  final String platform;
  final Map<String, dynamic> metadata;

  UserFeedback({
    required this.id,
    required this.type,
    required this.severity,
    required this.rating,
    required this.title,
    required this.description,
    this.email,
    this.userId,
    required this.timestamp,
    required this.appVersion,
    required this.platform,
    this.metadata = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'severity': severity.name,
      'rating': rating,
      'title': title,
      'description': description,
      'email': email,
      'user_id': userId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'app_version': appVersion,
      'platform': platform,
      'metadata': metadata,
    };
  }

  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      id: map['id'] ?? '',
      type: FeedbackType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => FeedbackType.general,
      ),
      severity: FeedbackSeverity.values.firstWhere(
        (e) => e.name == map['severity'],
        orElse: () => FeedbackSeverity.medium,
      ),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      email: map['email'],
      userId: map['user_id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      appVersion: map['app_version'] ?? 'unknown',
      platform: map['platform'] ?? 'unknown',
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }
}

/// User Feedback Service
class UserFeedbackService {
  static final Logger _logger = Logger();
  static SharedPreferences? _prefs;
  static PackageInfo? _packageInfo;
  static bool _isInitialized = false;

  static const String _feedbackCacheKey = 'cached_feedback';
  static const String _feedbackStatsKey = 'feedback_stats';
  static const String _lastFeedbackPromptKey = 'last_feedback_prompt';

  static final StreamController<UserFeedback> _feedbackController =
      StreamController<UserFeedback>.broadcast();

  /// Initialize feedback service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _packageInfo = await PackageInfo.fromPlatform();

      // Process any cached feedback
      await _processCachedFeedback();

      _isInitialized = true;
      _logger.i('UserFeedbackService initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize UserFeedbackService',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'UserFeedbackService.initialize',
      );
    }
  }

  /// Submit user feedback
  static Future<bool> submitFeedback({
    required FeedbackType type,
    required double rating,
    required String title,
    required String description,
    String? email,
    String? userId,
    FeedbackSeverity? severity,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final feedback = UserFeedback(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        severity: severity ?? _determineSeverity(rating, type),
        rating: rating,
        title: title,
        description: description,
        email: email,
        userId: userId,
        timestamp: DateTime.now(),
        appVersion: _packageInfo?.version ?? 'unknown',
        platform: defaultTargetPlatform.name,
        metadata: {
          'build_number': _packageInfo?.buildNumber ?? 'unknown',
          'debug_mode': kDebugMode,
          ...?metadata,
        },
      );

      // Cache feedback for offline scenarios
      await _cacheFeedback(feedback);

      // Try to submit immediately
      final submitted = await _submitFeedbackOnline(feedback);

      // Track analytics
      await ProductionAnalytics.trackFeedback(
        feedbackType: type.name,
        rating: rating,
        comment: description,
        metadata: feedback.metadata,
      );

      // Notify listeners
      _feedbackController.add(feedback);

      // Update statistics
      await _updateFeedbackStats(feedback);

      _logger.i(
        'Feedback submitted: ${feedback.id} (Type: ${type.name}, Rating: $rating)',
      );

      return submitted;
    } catch (e, stackTrace) {
      _logger.e('Failed to submit feedback', error: e, stackTrace: stackTrace);
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'UserFeedbackService.submitFeedback',
      );
      return false;
    }
  }

  /// Show feedback dialog
  static Future<bool?> showFeedbackDialog(
    BuildContext context, {
    FeedbackType type = FeedbackType.general,
    String? title,
    String? initialDescription,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => FeedbackDialog(
        type: type,
        title: title,
        initialDescription: initialDescription,
      ),
    );
  }

  /// Show rating dialog
  static Future<bool?> showRatingDialog(
    BuildContext context, {
    String? title,
    String? description,
    VoidCallback? onRatingComplete,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => RatingDialog(
        title: title ?? 'Rate DuaCopilot',
        description: description ?? 'How would you rate your experience?',
        onRatingComplete: onRatingComplete,
      ),
    );
  }

  /// Show quick feedback snackbar
  static void showQuickFeedbackSnackbar(
    BuildContext context, {
    required String message,
    VoidCallback? onFeedbackTap,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.feedback_outlined, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            TextButton(
              onPressed: onFeedbackTap,
              child: const Text(
                'FEEDBACK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'CLOSE',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Check if should prompt for feedback
  static Future<bool> shouldPromptForFeedback() async {
    try {
      final lastPrompt = _prefs?.getInt(_lastFeedbackPromptKey);
      if (lastPrompt == null) return true;

      final daysSinceLastPrompt = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastPrompt))
          .inDays;

      return daysSinceLastPrompt >= 7; // Prompt once per week max
    } catch (e) {
      _logger.w('Failed to check feedback prompt timing', error: e);
      return false;
    }
  }

  /// Mark feedback prompt as shown
  static Future<void> markFeedbackPromptShown() async {
    try {
      await _prefs?.setInt(
        _lastFeedbackPromptKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      _logger.w('Failed to mark feedback prompt as shown', error: e);
    }
  }

  /// Get feedback statistics
  static Future<Map<String, dynamic>> getFeedbackStats() async {
    try {
      final statsJson = _prefs?.getString(_feedbackStatsKey);
      if (statsJson != null) {
        return json.decode(statsJson) as Map<String, dynamic>;
      }
    } catch (e) {
      _logger.w('Failed to get feedback stats', error: e);
    }

    return {
      'total_feedback': 0,
      'average_rating': 0.0,
      'feedback_by_type': <String, int>{},
      'last_feedback': null,
    };
  }

  /// Stream of feedback submissions
  static Stream<UserFeedback> get feedbackStream => _feedbackController.stream;

  // Private helper methods
  static FeedbackSeverity _determineSeverity(double rating, FeedbackType type) {
    if (rating <= 2.0) return FeedbackSeverity.high;
    if (rating <= 3.0) return FeedbackSeverity.medium;
    if (type == FeedbackType.bug) return FeedbackSeverity.medium;
    return FeedbackSeverity.low;
  }

  static Future<bool> _submitFeedbackOnline(UserFeedback feedback) async {
    try {
      // Here you would integrate with your backend API
      // For now, we'll just simulate a successful submission
      await Future.delayed(const Duration(seconds: 1));

      // Track successful submission
      await ProductionAnalytics.trackEvent('feedback_submitted_online', {
        'feedback_id': feedback.id,
        'type': feedback.type.name,
        'rating': feedback.rating,
        'severity': feedback.severity.name,
      });

      return true;
    } catch (e) {
      _logger.w('Failed to submit feedback online', error: e);
      return false;
    }
  }

  static Future<void> _cacheFeedback(UserFeedback feedback) async {
    try {
      final cachedFeedback = _prefs?.getStringList(_feedbackCacheKey) ?? [];
      cachedFeedback.add(json.encode(feedback.toMap()));

      // Keep only last 20 feedback items
      if (cachedFeedback.length > 20) {
        cachedFeedback.removeAt(0);
      }

      await _prefs?.setStringList(_feedbackCacheKey, cachedFeedback);
    } catch (e) {
      _logger.w('Failed to cache feedback', error: e);
    }
  }

  static Future<void> _processCachedFeedback() async {
    try {
      final cachedFeedback = _prefs?.getStringList(_feedbackCacheKey) ?? [];

      if (cachedFeedback.isNotEmpty) {
        _logger.i('Processing ${cachedFeedback.length} cached feedback items');

        for (final feedbackJson in cachedFeedback) {
          try {
            final feedbackData =
                json.decode(feedbackJson) as Map<String, dynamic>;
            final feedback = UserFeedback.fromMap(feedbackData);

            // Try to submit cached feedback
            await _submitFeedbackOnline(feedback);
          } catch (e) {
            _logger.w('Failed to process cached feedback item', error: e);
          }
        }

        // Clear processed feedback
        await _prefs?.remove(_feedbackCacheKey);
      }
    } catch (e) {
      _logger.w('Failed to process cached feedback', error: e);
    }
  }

  static Future<void> _updateFeedbackStats(UserFeedback feedback) async {
    try {
      final stats = await getFeedbackStats();

      final totalFeedback = (stats['total_feedback'] as int) + 1;
      final currentAverage = (stats['average_rating'] as num).toDouble();
      final newAverage =
          ((currentAverage * (totalFeedback - 1)) + feedback.rating) /
              totalFeedback;

      final feedbackByType = Map<String, int>.from(
        stats['feedback_by_type'] as Map<String, dynamic>,
      );
      feedbackByType[feedback.type.name] =
          (feedbackByType[feedback.type.name] ?? 0) + 1;

      final updatedStats = {
        'total_feedback': totalFeedback,
        'average_rating': newAverage,
        'feedback_by_type': feedbackByType,
        'last_feedback': feedback.timestamp.millisecondsSinceEpoch,
      };

      await _prefs?.setString(_feedbackStatsKey, json.encode(updatedStats));
    } catch (e) {
      _logger.w('Failed to update feedback stats', error: e);
    }
  }
}

/// Feedback Dialog Widget
class FeedbackDialog extends StatefulWidget {
  final FeedbackType type;
  final String? title;
  final String? initialDescription;

  const FeedbackDialog({
    super.key,
    required this.type,
    this.title,
    this.initialDescription,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _titleController.text = widget.title!;
    }
    if (widget.initialDescription != null) {
      _descriptionController.text = widget.initialDescription!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${_getFeedbackTypeLabel(widget.type)} Feedback'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating
            const Text(
              'Rating:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),

            const SizedBox(height: 16),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Brief summary of your feedback',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),

            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Please describe your feedback in detail',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              maxLength: 1000,
            ),

            const SizedBox(height: 16),

            // Email (optional)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email (Optional)',
                hintText: 'For follow-up communication',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitFeedback,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _submitFeedback() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both title and description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await UserFeedbackService.submitFeedback(
        type: widget.type,
        rating: _rating,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you for your feedback!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback saved. Will be submitted when online.'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _getFeedbackTypeLabel(FeedbackType type) {
    switch (type) {
      case FeedbackType.general:
        return 'General';
      case FeedbackType.bug:
        return 'Bug Report';
      case FeedbackType.feature:
        return 'Feature Request';
      case FeedbackType.rag:
        return 'RAG System';
      case FeedbackType.ui:
        return 'User Interface';
      case FeedbackType.performance:
        return 'Performance';
      case FeedbackType.rating:
        return 'Rating';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

/// Rating Dialog Widget
class RatingDialog extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback? onRatingComplete;

  const RatingDialog({
    super.key,
    required this.title,
    required this.description,
    this.onRatingComplete,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0.0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.description),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 40,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() => _rating = rating);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting || _rating == 0 ? null : _submitRating,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    try {
      await UserFeedbackService.submitFeedback(
        type: FeedbackType.rating,
        rating: _rating,
        title: 'App Rating',
        description:
            'User provided a ${_rating.toStringAsFixed(1)} star rating',
      );

      widget.onRatingComplete?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your rating!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit rating. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
