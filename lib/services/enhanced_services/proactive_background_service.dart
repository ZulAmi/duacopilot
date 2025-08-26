import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';

/// Background processing service for proactive Du'a suggestions
/// Analyzes usage patterns and provides contextual recommendations
class ProactiveBackgroundService {
  static ProactiveBackgroundService? _instance;
  static ProactiveBackgroundService get instance =>
      _instance ??= ProactiveBackgroundService._();

  ProactiveBackgroundService._();

  // Service configuration
  static const Duration _analysisInterval = Duration(minutes: 30);
  static const Duration _suggestionInterval = Duration(hours: 2);

  // Data keys
  static const String _usagePatternsKey = 'usage_patterns';
  static const String _lastAnalysisKey = 'last_analysis';
  static const String _userPreferencesKey = 'background_preferences';

  // State management
  bool _isServiceRunning = false;
  Timer? _analysisTimer;
  final _suggestionController =
      StreamController<ProactiveSuggestion>.broadcast();

  // Stream for proactive suggestions
  Stream<ProactiveSuggestion> get suggestionStream =>
      _suggestionController.stream;

  // Usage pattern tracking
  final Map<String, UsagePattern> _usagePatterns = {};
  final List<ProactiveSuggestion> _recentSuggestions = [];

  /// Initialize and start the background service
  Future<void> startService() async {
    if (_isServiceRunning) {
      AppLogger.warning('Proactive background service already running');
      return;
    }

    try {
      AppLogger.info('Starting proactive background service...');

      // Initialize Flutter Background Service
      await _initializeBackgroundService();

      // Load existing usage patterns
      await _loadUsagePatterns();

      // Start periodic analysis
      _startPeriodicAnalysis();

      _isServiceRunning = true;
      AppLogger.info('Proactive background service started successfully');
    } catch (e) {
      AppLogger.error('Failed to start proactive background service: $e');
      rethrow;
    }
  }

  /// Stop the background service
  Future<void> stopService() async {
    if (!_isServiceRunning) return;

    try {
      AppLogger.info('Stopping proactive background service...');

      _analysisTimer?.cancel();
      final service = FlutterBackgroundService();
      service.invoke('stop_service');

      _isServiceRunning = false;
      AppLogger.info('Proactive background service stopped');
    } catch (e) {
      AppLogger.error('Error stopping proactive background service: $e');
    }
  }

  /// Record user interaction for pattern analysis
  Future<void> recordInteraction(UserInteraction interaction) async {
    try {
      final pattern =
          _usagePatterns[interaction.category] ??
          UsagePattern(category: interaction.category);

      pattern.addInteraction(interaction);
      _usagePatterns[interaction.category] = pattern;

      // Save updated patterns
      await _saveUsagePatterns();

      AppLogger.debug(
        'Recorded interaction: ${interaction.category} at ${interaction.timestamp}',
      );
    } catch (e) {
      AppLogger.error('Failed to record interaction: $e');
    }
  }

  /// Get current usage patterns for analysis
  Map<String, UsagePattern> get usagePatterns =>
      Map.unmodifiable(_usagePatterns);

  /// Check service status
  bool get isRunning => _isServiceRunning;

  /// Configure user preferences for background processing
  Future<void> setUserPreferences(
    BackgroundServicePreferences preferences,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _userPreferencesKey,
        jsonEncode(preferences.toJson()),
      );

      AppLogger.info('Updated background service preferences');

      // Restart service with new preferences if running
      if (_isServiceRunning) {
        await stopService();
        await startService();
      }
    } catch (e) {
      AppLogger.error('Failed to set user preferences: $e');
    }
  }

  // Private methods

  Future<void> _initializeBackgroundService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        autoStart: true,
        isForegroundMode: false,
        autoStartOnBoot: true,
        initialNotificationTitle: 'DuaCopilot Background Service',
        initialNotificationContent:
            'Analyzing usage patterns for proactive suggestions',
        foregroundServiceNotificationId: 888,
      ),
    );

    // Only start if not already running
    if (!(await service.isRunning())) {
      await service.startService();
    }
  }

  @pragma('vm:entry-point')
  static void _onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    AppLogger.info('Background service isolate started');

    // Load services in background isolate
    final backgroundProcessor = BackgroundProcessor();
    await backgroundProcessor.initialize();

    // Set up periodic tasks
    Timer.periodic(_analysisInterval, (timer) async {
      try {
        await backgroundProcessor.performAnalysis();
      } catch (e) {
        AppLogger.error('Background analysis error: $e');
      }
    });

    Timer.periodic(_suggestionInterval, (timer) async {
      try {
        await backgroundProcessor.generateSuggestions();
      } catch (e) {
        AppLogger.error('Background suggestion error: $e');
      }
    });

    // Listen for service stop
    service.on('stop_service').listen((event) {
      service.stopSelf();
    });
  }

  @pragma('vm:entry-point')
  static bool _onIosBackground(ServiceInstance service) {
    AppLogger.info('iOS background service running');
    return true;
  }

  void _startPeriodicAnalysis() {
    _analysisTimer?.cancel();
    _analysisTimer = Timer.periodic(_analysisInterval, (_) async {
      await _performForegroundAnalysis();
    });
  }

  Future<void> _performForegroundAnalysis() async {
    try {
      AppLogger.debug('Performing foreground usage analysis...');

      // Analyze current patterns
      for (final pattern in _usagePatterns.values) {
        await _analyzePattern(pattern);
      }

      // Generate suggestions if appropriate
      await _generateContextualSuggestions();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastAnalysisKey, DateTime.now().toIso8601String());
    } catch (e) {
      AppLogger.error('Foreground analysis error: $e');
    }
  }

  Future<void> _analyzePattern(UsagePattern pattern) async {
    // Detect time-based patterns
    final timePatterns = _detectTimePatterns(pattern);

    // Detect emotional state patterns
    final emotionalPatterns = _detectEmotionalPatterns(pattern);

    // Detect location-based patterns
    final locationPatterns = _detectLocationPatterns(pattern);

    // Update pattern analysis
    pattern.updateAnalysis(
      timePatterns: timePatterns,
      emotionalPatterns: emotionalPatterns,
      locationPatterns: locationPatterns,
    );

    AppLogger.debug(
      'Analyzed pattern for ${pattern.category}: ${pattern.interactions.length} interactions',
    );
  }

  Map<String, dynamic> _detectTimePatterns(UsagePattern pattern) {
    final timeMap = <int, int>{}; // hour -> count
    final dayMap = <int, int>{}; // weekday -> count

    for (final interaction in pattern.interactions) {
      final hour = interaction.timestamp.hour;
      final weekday = interaction.timestamp.weekday;

      timeMap[hour] = (timeMap[hour] ?? 0) + 1;
      dayMap[weekday] = (dayMap[weekday] ?? 0) + 1;
    }

    return {
      'peak_hours': _findPeakTimes(timeMap),
      'peak_days': _findPeakDays(dayMap),
      'pattern_strength': _calculatePatternStrength(timeMap),
    };
  }

  Map<String, dynamic> _detectEmotionalPatterns(UsagePattern pattern) {
    final emotionMap = <EmotionalState, int>{};

    for (final interaction in pattern.interactions) {
      if (interaction.emotionalState != null) {
        final emotion = interaction.emotionalState!;
        emotionMap[emotion] = (emotionMap[emotion] ?? 0) + 1;
      }
    }

    return {
      'dominant_emotions': emotionMap.keys.toList(),
      'emotion_distribution': emotionMap,
    };
  }

  Map<String, dynamic> _detectLocationPatterns(UsagePattern pattern) {
    final locationMap = <String, int>{};

    for (final interaction in pattern.interactions) {
      if (interaction.location != null) {
        final location = interaction.location!;
        locationMap[location] = (locationMap[location] ?? 0) + 1;
      }
    }

    return {
      'common_locations': locationMap.keys.toList(),
      'location_distribution': locationMap,
    };
  }

  List<int> _findPeakTimes(Map<int, int> timeMap) {
    if (timeMap.isEmpty) return [];

    final sortedEntries =
        timeMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(3).map((e) => e.key).toList();
  }

  List<int> _findPeakDays(Map<int, int> dayMap) {
    if (dayMap.isEmpty) return [];

    final sortedEntries =
        dayMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(3).map((e) => e.key).toList();
  }

  double _calculatePatternStrength(Map<int, int> timeMap) {
    if (timeMap.isEmpty) return 0.0;

    final values = timeMap.values.toList();
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
        values.length;

    return variance / (mean + 1); // Normalized pattern strength
  }

  Future<void> _generateContextualSuggestions() async {
    try {
      final now = DateTime.now();

      // Check if it's time for suggestions based on patterns
      for (final pattern in _usagePatterns.values) {
        final suggestion = await _createSuggestionFromPattern(pattern, now);
        if (suggestion != null && !_isDuplicateSuggestion(suggestion)) {
          _suggestionController.add(suggestion);
          _recentSuggestions.add(suggestion);

          // Keep only recent suggestions
          if (_recentSuggestions.length > 20) {
            _recentSuggestions.removeAt(0);
          }
        }
      }
    } catch (e) {
      AppLogger.error('Failed to generate contextual suggestions: $e');
    }
  }

  Future<ProactiveSuggestion?> _createSuggestionFromPattern(
    UsagePattern pattern,
    DateTime now,
  ) async {
    final analysis = pattern.analysis;
    if (analysis == null) return null;

    // Check time-based triggers
    final peakHours = analysis['time_patterns']?['peak_hours'] as List<int>?;
    if (peakHours != null && peakHours.contains(now.hour)) {
      return ProactiveSuggestion(
        id: 'time_${pattern.category}_${now.millisecondsSinceEpoch}',
        category: pattern.category,
        trigger: SuggestionTrigger.timePattern,
        content: await _generateSuggestionContent(pattern, 'time_based'),
        confidence:
            analysis['time_patterns']?['pattern_strength'] as double? ?? 0.5,
        timestamp: now,
        metadata: {
          'pattern_type': 'time_based',
          'peak_hour': now.hour,
          'interaction_count': pattern.interactions.length,
        },
      );
    }

    return null;
  }

  bool _isDuplicateSuggestion(ProactiveSuggestion suggestion) {
    const duplicateWindow = Duration(hours: 6);
    final cutoff = DateTime.now().subtract(duplicateWindow);

    return _recentSuggestions.any(
      (recent) =>
          recent.category == suggestion.category &&
          recent.trigger == suggestion.trigger &&
          recent.timestamp.isAfter(cutoff),
    );
  }

  Future<String> _generateSuggestionContent(
    UsagePattern pattern,
    String triggerType,
  ) async {
    // This would integrate with the Islamic RAG provider for actual content generation
    return 'Based on your usage pattern for ${pattern.category}, here\'s a relevant Du\'a suggestion ($triggerType)';
  }

  Future<void> _loadUsagePatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patternsJson = prefs.getString(_usagePatternsKey);

      if (patternsJson != null) {
        final patternsData = jsonDecode(patternsJson) as Map<String, dynamic>;

        for (final entry in patternsData.entries) {
          _usagePatterns[entry.key] = UsagePattern.fromJson(entry.value);
        }

        AppLogger.debug('Loaded ${_usagePatterns.length} usage patterns');
      }
    } catch (e) {
      AppLogger.warning('Failed to load usage patterns: $e');
    }
  }

  Future<void> _saveUsagePatterns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patternsData = <String, dynamic>{};

      for (final entry in _usagePatterns.entries) {
        patternsData[entry.key] = entry.value.toJson();
      }

      await prefs.setString(_usagePatternsKey, jsonEncode(patternsData));
    } catch (e) {
      AppLogger.error('Failed to save usage patterns: $e');
    }
  }

  /// Cleanup resources
  void dispose() {
    _analysisTimer?.cancel();
    _suggestionController.close();
  }
}

/// Background processor for isolate-based analysis
class BackgroundProcessor {
  Future<void> initialize() async {
    // Initialize background processor
  }

  Future<void> performAnalysis() async {
    // Perform background analysis
    AppLogger.debug('Background analysis performed');
  }

  Future<void> generateSuggestions() async {
    // Generate background suggestions
    AppLogger.debug('Background suggestions generated');
  }
}

/// Usage pattern for a specific category
class UsagePattern {
  final String category;
  final List<UserInteraction> interactions = [];
  Map<String, dynamic>? analysis;

  UsagePattern({required this.category});

  void addInteraction(UserInteraction interaction) {
    interactions.add(interaction);

    // Keep only recent interactions (last 30 days)
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    interactions.removeWhere((i) => i.timestamp.isBefore(cutoff));
  }

  void updateAnalysis({
    required Map<String, dynamic> timePatterns,
    required Map<String, dynamic> emotionalPatterns,
    required Map<String, dynamic> locationPatterns,
  }) {
    analysis = {
      'time_patterns': timePatterns,
      'emotional_patterns': emotionalPatterns,
      'location_patterns': locationPatterns,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'interactions': interactions.map((i) => i.toJson()).toList(),
    'analysis': analysis,
  };

  static UsagePattern fromJson(Map<String, dynamic> json) {
    final pattern = UsagePattern(category: json['category']);

    if (json['interactions'] != null) {
      for (final interactionJson in json['interactions']) {
        pattern.interactions.add(UserInteraction.fromJson(interactionJson));
      }
    }

    pattern.analysis = json['analysis'];
    return pattern;
  }
}

/// User interaction record
class UserInteraction {
  final String id;
  final String category;
  final String action;
  final DateTime timestamp;
  final EmotionalState? emotionalState;
  final String? location;
  final Map<String, dynamic> metadata;

  UserInteraction({
    required this.id,
    required this.category,
    required this.action,
    required this.timestamp,
    this.emotionalState,
    this.location,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'action': action,
    'timestamp': timestamp.toIso8601String(),
    'emotional_state': emotionalState?.toString(),
    'location': location,
    'metadata': metadata,
  };

  static UserInteraction fromJson(Map<String, dynamic> json) => UserInteraction(
    id: json['id'],
    category: json['category'],
    action: json['action'],
    timestamp: DateTime.parse(json['timestamp']),
    emotionalState:
        json['emotional_state'] != null
            ? EmotionalState.values.firstWhere(
              (e) => e.toString() == json['emotional_state'],
            )
            : null,
    location: json['location'],
    metadata: json['metadata'] ?? {},
  );
}

/// Proactive suggestion generated by background analysis
class ProactiveSuggestion {
  final String id;
  final String category;
  final SuggestionTrigger trigger;
  final String content;
  final double confidence;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  ProactiveSuggestion({
    required this.id,
    required this.category,
    required this.trigger,
    required this.content,
    required this.confidence,
    required this.timestamp,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'trigger': trigger.toString(),
    'content': content,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };

  static ProactiveSuggestion fromJson(Map<String, dynamic> json) =>
      ProactiveSuggestion(
        id: json['id'],
        category: json['category'],
        trigger: SuggestionTrigger.values.firstWhere(
          (t) => t.toString() == json['trigger'],
        ),
        content: json['content'],
        confidence: json['confidence'],
        timestamp: DateTime.parse(json['timestamp']),
        metadata: json['metadata'] ?? {},
      );
}

/// Types of suggestion triggers
enum SuggestionTrigger {
  timePattern,
  locationPattern,
  emotionalState,
  calendarEvent,
  conversationContext,
  culturalEvent,
}

/// User preferences for background service
class BackgroundServicePreferences {
  final bool enableProactiveSuggestions;
  final List<String> enabledCategories;
  final Duration suggestionInterval;
  final bool enableLocationBasedSuggestions;
  final bool enableTimeBasedSuggestions;
  final bool enableEmotionBasedSuggestions;
  final double confidenceThreshold;

  BackgroundServicePreferences({
    this.enableProactiveSuggestions = true,
    this.enabledCategories = const ['dua', 'prayer', 'guidance', 'gratitude'],
    this.suggestionInterval = const Duration(hours: 2),
    this.enableLocationBasedSuggestions = true,
    this.enableTimeBasedSuggestions = true,
    this.enableEmotionBasedSuggestions = true,
    this.confidenceThreshold = 0.6,
  });

  Map<String, dynamic> toJson() => {
    'enable_proactive_suggestions': enableProactiveSuggestions,
    'enabled_categories': enabledCategories,
    'suggestion_interval_hours': suggestionInterval.inHours,
    'enable_location_based': enableLocationBasedSuggestions,
    'enable_time_based': enableTimeBasedSuggestions,
    'enable_emotion_based': enableEmotionBasedSuggestions,
    'confidence_threshold': confidenceThreshold,
  };

  static BackgroundServicePreferences fromJson(
    Map<String, dynamic> json,
  ) => BackgroundServicePreferences(
    enableProactiveSuggestions: json['enable_proactive_suggestions'] ?? true,
    enabledCategories:
        (json['enabled_categories'] as List<dynamic>?)?.cast<String>() ??
        ['dua', 'prayer', 'guidance', 'gratitude'],
    suggestionInterval: Duration(hours: json['suggestion_interval_hours'] ?? 2),
    enableLocationBasedSuggestions: json['enable_location_based'] ?? true,
    enableTimeBasedSuggestions: json['enable_time_based'] ?? true,
    enableEmotionBasedSuggestions: json['enable_emotion_based'] ?? true,
    confidenceThreshold: json['confidence_threshold'] ?? 0.6,
  );
}
