import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../../../services/comprehensive_feedback_service.dart';

/// A/B Testing framework using Firebase Remote Config
class ABTestingFramework {
  final FirebaseRemoteConfig _remoteConfig;
  final ComprehensiveFeedbackService _feedbackService;

  static const Map<String, dynamic> _defaultConfigs = {
    // UI Variations
    'feedback_button_style': 'modern', // modern, classic, minimal
    'rating_widget_type': 'stars', // stars, hearts, thumbs
    'color_scheme': 'default', // default, dark, blue, green
    'navigation_style': 'bottom', // bottom, drawer, top
    // Feature Flags
    'enable_voice_feedback': false,
    'enable_advanced_analytics': true,
    'enable_offline_sync': true,
    'enable_push_notifications': true,

    // Content Variations
    'home_screen_layout': 'grid', // grid, list, cards
    'dua_display_style': 'modern', // modern, traditional, minimal
    'audio_player_style': 'compact', // compact, full, mini
    // Behavioral Experiments
    'feedback_prompt_frequency': 'moderate', // low, moderate, high
    'onboarding_steps': 3, // 3, 5, 7
    'reminder_style': 'gentle', // gentle, persistent, minimal
  };

  ABTestingFramework({
    required FirebaseRemoteConfig remoteConfig,
    required ComprehensiveFeedbackService feedbackService,
  })  : _remoteConfig = remoteConfig,
        _feedbackService = feedbackService;

  /// Initialize A/B testing framework
  Future<void> initialize() async {
    try {
      // Set defaults
      await _remoteConfig.setDefaults(_defaultConfigs);

      // Configure fetch settings
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();

      // Track A/B test initialization
      await _trackExperimentParticipation();
    } catch (e) {
      debugPrint('Error initializing A/B testing framework: $e');
    }
  }

  /// Get experiment variant for a given test
  T getVariant<T>(String experimentName, T defaultValue) {
    try {
      if (T == String) {
        return _remoteConfig.getString(experimentName) as T? ?? defaultValue;
      } else if (T == bool) {
        return _remoteConfig.getBool(experimentName) as T? ?? defaultValue;
      } else if (T == int) {
        return _remoteConfig.getInt(experimentName) as T? ?? defaultValue;
      } else if (T == double) {
        return _remoteConfig.getDouble(experimentName) as T? ?? defaultValue;
      }
      return defaultValue;
    } catch (e) {
      debugPrint('Error getting variant for $experimentName: $e');
      return defaultValue;
    }
  }

  /// Track experiment participation and outcomes
  Future<void> trackExperimentOutcome({
    required String experimentName,
    required String variant,
    required String outcome,
    Map<String, dynamic>? additionalData,
  }) async {
    await _feedbackService.trackUsageAnalytics(
      action: 'ab_test_outcome',
      contentId: experimentName,
      contentType: 'experiment',
      additionalData: {
        'variant': variant,
        'outcome': outcome,
        ...?additionalData,
      },
    );
  }

  /// Track conversion events for experiments
  Future<void> trackConversion({
    required String experimentName,
    required String conversionType,
    double? value,
  }) async {
    final variant = getVariant(experimentName, 'control');

    await _feedbackService.trackUsageAnalytics(
      action: 'ab_test_conversion',
      contentId: experimentName,
      contentType: 'conversion',
      additionalData: {
        'variant': variant,
        'conversion_type': conversionType,
        'value': value,
      },
    );
  }

  Future<void> _trackExperimentParticipation() async {
    for (final experiment in _defaultConfigs.keys) {
      final variant = getVariant(experiment, 'control');

      await _feedbackService.trackUsageAnalytics(
        action: 'ab_test_participation',
        contentId: experiment,
        contentType: 'experiment',
        additionalData: {'variant': variant},
      );
    }
  }
}

/// Widget that conditionally renders UI based on A/B test variants
class ABTestWidget extends StatelessWidget {
  final String experimentName;
  final Map<String, Widget Function(BuildContext)> variants;
  final Widget Function(BuildContext)? fallback;
  final ABTestingFramework? abTesting;

  const ABTestWidget({
    super.key,
    required this.experimentName,
    required this.variants,
    this.fallback,
    this.abTesting,
  });

  @override
  Widget build(BuildContext context) {
    if (abTesting == null) {
      return fallback?.call(context) ?? variants.values.first(context);
    }

    final variant = abTesting!.getVariant(experimentName, 'control');

    final builder = variants[variant] ?? fallback;
    if (builder == null) {
      return variants.values.first(context);
    }

    return builder(context);
  }
}

/// Button styles for A/B testing
class ABFeedbackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final ABTestingFramework? abTesting;

  const ABFeedbackButton({
    super.key,
    this.onPressed,
    this.text = 'Feedback',
    this.abTesting,
  });

  @override
  Widget build(BuildContext context) {
    return ABTestWidget(
      experimentName: 'feedback_button_style',
      abTesting: abTesting,
      variants: {
        'modern': (context) =>
            _ModernFeedbackButton(onPressed: onPressed, text: text),
        'classic': (context) =>
            _ClassicFeedbackButton(onPressed: onPressed, text: text),
        'minimal': (context) =>
            _MinimalFeedbackButton(onPressed: onPressed, text: text),
      },
      fallback: (context) =>
          _ModernFeedbackButton(onPressed: onPressed, text: text),
    );
  }
}

class _ModernFeedbackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const _ModernFeedbackButton({this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.feedback, size: 18),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _ClassicFeedbackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const _ClassicFeedbackButton({this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.feedback),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _MinimalFeedbackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const _MinimalFeedbackButton({this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.feedback, size: 16),
      label: Text(text),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

/// Theme variations for A/B testing
class ABThemeProvider extends StatelessWidget {
  final Widget child;
  final ABTestingFramework? abTesting;

  const ABThemeProvider({super.key, required this.child, this.abTesting});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        abTesting?.getVariant('color_scheme', 'default') ?? 'default';

    return Theme(data: _getThemeData(context, colorScheme), child: child);
  }

  ThemeData _getThemeData(BuildContext context, String scheme) {
    final baseTheme = Theme.of(context);

    switch (scheme) {
      case 'dark':
        return baseTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
        );
      case 'blue':
        return baseTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: baseTheme.brightness,
          ),
        );
      case 'green':
        return baseTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: baseTheme.brightness,
          ),
        );
      default:
        return baseTheme;
    }
  }
}

/// Layout variations for A/B testing
class ABLayoutProvider extends StatelessWidget {
  final Widget child;
  final ABTestingFramework? abTesting;

  const ABLayoutProvider({super.key, required this.child, this.abTesting});

  @override
  Widget build(BuildContext context) {
    // Navigation style variant could be used here to change layout
    // For now, we'll just return the child as this would need app-wide navigation changes
    return child;
  }
}

/// Experiment tracking mixin
mixin ExperimentTracker<T extends StatefulWidget> on State<T> {
  ABTestingFramework? _abTesting;
  final Set<String> _trackedExperiments = {};

  void initializeExperimentTracking(ABTestingFramework abTesting) {
    _abTesting = abTesting;
  }

  void trackExperimentView(String experimentName) {
    if (_trackedExperiments.contains(experimentName)) return;

    _trackedExperiments.add(experimentName);
    final variant =
        _abTesting?.getVariant(experimentName, 'control') ?? 'control';

    _abTesting?.trackExperimentOutcome(
      experimentName: experimentName,
      variant: variant,
      outcome: 'view',
    );
  }

  void trackExperimentInteraction(
    String experimentName,
    String interactionType, {
    Map<String, dynamic>? data,
  }) {
    final variant =
        _abTesting?.getVariant(experimentName, 'control') ?? 'control';

    _abTesting?.trackExperimentOutcome(
      experimentName: experimentName,
      variant: variant,
      outcome: interactionType,
      additionalData: data,
    );
  }

  void trackExperimentConversion(
    String experimentName,
    String conversionType, {
    double? value,
  }) {
    _abTesting?.trackConversion(
      experimentName: experimentName,
      conversionType: conversionType,
      value: value,
    );
  }
}

/// Experiment results data model
class ExperimentResult {
  final String experimentName;
  final Map<String, ExperimentVariantData> variants;
  final double statisticalSignificance;
  final String winningVariant;
  final DateTime startDate;
  final DateTime endDate;

  const ExperimentResult({
    required this.experimentName,
    required this.variants,
    required this.statisticalSignificance,
    required this.winningVariant,
    required this.startDate,
    required this.endDate,
  });
}

class ExperimentVariantData {
  final String variant;
  final int participants;
  final int conversions;
  final double conversionRate;
  final Map<String, int> outcomes;

  const ExperimentVariantData({
    required this.variant,
    required this.participants,
    required this.conversions,
    required this.conversionRate,
    required this.outcomes,
  });
}
