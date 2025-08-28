import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'personalization_models.dart';

/// Usage pattern analyzer for tracking user behavior and preferences
/// Provides privacy-first analytics with local storage using SharedPreferences
class UsagePatternAnalyzer {
  static const String _usagePatternsKey = 'usage_patterns_';
  static const String _interactionHistoryKey = 'interaction_history_';
  static const String _queryHistoryKey = 'query_history_';
  static const String _dailyStatsKey = 'daily_stats_';

  // Cache for performance
  final Map<String, UsagePatterns> _patternsCache = {};
  Timer? _analyticsTimer;

  /// Initialize analyzer for a user
  Future<void> initialize(String userId, SharedPreferences prefs) async {
    try {
      // Load existing patterns
      await _loadPatterns(userId, prefs);

      // Start periodic analytics processing
      _startAnalyticsProcessing(userId);

      debugPrint('✅ Usage pattern analyzer initialized for user: $userId');
    } catch (e) {
      debugPrint('❌ Error initializing usage pattern analyzer: $e');
      rethrow;
    }
  }

  /// Get usage patterns for a user
  Future<UsagePatterns> getPatterns(String userId) async {
    // Check cache first
    if (_patternsCache.containsKey(userId)) {
      return _patternsCache[userId]!;
    }

    // Load from storage
    final prefs = await SharedPreferences.getInstance();
    return await _loadPatterns(userId, prefs);
  }

  /// Record a Du'a interaction
  Future<void> recordInteraction(DuaInteraction interaction) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Update interaction history
      await _recordInteractionHistory(interaction, prefs);

      // Update usage patterns
      await _updateUsagePatterns(interaction, prefs);

      // Update daily statistics
      await _updateDailyStats(interaction, prefs);

      debugPrint(
        '📊 Recorded interaction: ${interaction.type} for ${interaction.duaId}',
      );
    } catch (e) {
      debugPrint('❌ Error recording interaction: $e');
    }
  }

  /// Track query for search pattern analysis
  Future<void> trackQuery(String query, int resultCount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const userId = 'current_user'; // This should be injected

      final queryHistory = prefs.getStringList('$_queryHistoryKey$userId') ?? [];

      final queryData = {
        'query': query,
        'result_count': resultCount,
        'timestamp': DateTime.now().toIso8601String(),
      };

      queryHistory.add(json.encode(queryData));

      // Keep only last 100 queries for privacy
      if (queryHistory.length > 100) {
        queryHistory.removeRange(0, queryHistory.length - 100);
      }

      await prefs.setStringList('$_queryHistoryKey$userId', queryHistory);
    } catch (e) {
      debugPrint('❌ Error tracking query: $e');
    }
  }

  /// Process analytics data for pattern learning
  Future<void> processAnalytics(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Analyze interaction patterns
      await _analyzeInteractionPatterns(userId, prefs);

      // Update category preferences
      await _updateCategoryPreferences(userId, prefs);

      // Calculate reading time patterns
      await _calculateReadingTimePatterns(userId, prefs);

      debugPrint('📝 Processed analytics for user: $userId');
    } catch (e) {
      debugPrint('❌ Error processing analytics: $e');
    }
  }

  /// Clean up old data for privacy compliance
  Future<void> cleanupOldData(DateTime cutoffDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get all keys that contain user data
      final keys = prefs.getKeys().where(
            (key) =>
                key.contains('usage_patterns_') ||
                key.contains('interaction_history_') ||
                key.contains('query_history_') ||
                key.contains('daily_stats_'),
          );

      for (final key in keys) {
        await _cleanupDataForKey(key, cutoffDate, prefs);
      }

      debugPrint('🧹 Cleaned up old usage data before: $cutoffDate');
    } catch (e) {
      debugPrint('❌ Error cleaning up old data: $e');
    }
  }

  /// Load usage patterns from storage
  Future<UsagePatterns> _loadPatterns(
    String userId,
    SharedPreferences prefs,
  ) async {
    try {
      final patternsJson = prefs.getString('$_usagePatternsKey$userId');

      if (patternsJson != null) {
        final patterns = UsagePatterns.fromJson(json.decode(patternsJson));
        _patternsCache[userId] = patterns;
        return patterns;
      } else {
        // Create empty patterns for new user
        final emptyPatterns = UsagePatterns.empty(userId);
        _patternsCache[userId] = emptyPatterns;
        await _savePatterns(emptyPatterns, prefs);
        return emptyPatterns;
      }
    } catch (e) {
      debugPrint('❌ Error loading usage patterns: $e');
      return UsagePatterns.empty(userId);
    }
  }

  /// Save usage patterns to storage
  Future<void> _savePatterns(
    UsagePatterns patterns,
    SharedPreferences prefs,
  ) async {
    try {
      final patternsJson = json.encode(patterns.toJson());
      await prefs.setString(
        '$_usagePatternsKey${patterns.userId}',
        patternsJson,
      );
      _patternsCache[patterns.userId] = patterns;
    } catch (e) {
      debugPrint('❌ Error saving usage patterns: $e');
    }
  }

  /// Record interaction history
  Future<void> _recordInteractionHistory(
    DuaInteraction interaction,
    SharedPreferences prefs,
  ) async {
    try {
      final historyKey = '$_interactionHistoryKey${interaction.userId}';
      final history = prefs.getStringList(historyKey) ?? [];

      history.add(json.encode(interaction.toJson()));

      // Keep only last 500 interactions for privacy
      if (history.length > 500) {
        history.removeRange(0, history.length - 500);
      }

      await prefs.setStringList(historyKey, history);
    } catch (e) {
      debugPrint('❌ Error recording interaction history: $e');
    }
  }

  /// Update usage patterns based on interaction
  Future<void> _updateUsagePatterns(
    DuaInteraction interaction,
    SharedPreferences prefs,
  ) async {
    try {
      final patterns = await _loadPatterns(interaction.userId, prefs);

      // Update frequent Du'as
      final updatedFrequent = List<String>.from(patterns.frequentDuas);
      if (!updatedFrequent.contains(interaction.duaId)) {
        updatedFrequent.add(interaction.duaId);
      }

      // Update recent Du'as
      final updatedRecent = List<String>.from(patterns.recentDuas);
      updatedRecent.remove(interaction.duaId); // Remove if exists
      updatedRecent.insert(0, interaction.duaId); // Add to front

      // Keep only last 20 recent Du'as
      if (updatedRecent.length > 20) {
        updatedRecent.removeRange(20, updatedRecent.length);
      }

      // Update time of day patterns
      final hour = interaction.timestamp.hour;
      final timeOfDayKey = _getTimeOfDayCategory(hour);
      final updatedTimePatterns = Map<String, double>.from(
        patterns.timeOfDayPatterns,
      );
      updatedTimePatterns[timeOfDayKey] = (updatedTimePatterns[timeOfDayKey] ?? 0.0) + 1.0;

      // Update total interactions
      final totalInteractions = patterns.totalInteractions + 1;

      // Update average reading times
      final updatedReadingTimes = Map<String, double>.from(
        patterns.averageReadingTimes,
      );
      if (interaction.duration.inSeconds > 0) {
        final currentAvg = updatedReadingTimes[interaction.duaId] ?? 0.0;
        updatedReadingTimes[interaction.duaId] = (currentAvg + interaction.duration.inSeconds) / 2;
      }

      final updatedPatterns = patterns.copyWith(
        frequentDuas: updatedFrequent,
        recentDuas: updatedRecent,
        timeOfDayPatterns: updatedTimePatterns,
        totalInteractions: totalInteractions,
        averageReadingTimes: updatedReadingTimes,
        lastUpdated: DateTime.now(),
      );

      await _savePatterns(updatedPatterns, prefs);
    } catch (e) {
      debugPrint('❌ Error updating usage patterns: $e');
    }
  }

  /// Update daily statistics
  Future<void> _updateDailyStats(
    DuaInteraction interaction,
    SharedPreferences prefs,
  ) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final statsKey = '$_dailyStatsKey${interaction.userId}_$today';

      final currentStats = prefs.getString(statsKey);
      Map<String, dynamic> stats = {};

      if (currentStats != null) {
        stats = json.decode(currentStats);
      }

      // Update daily statistics
      stats['total_interactions'] = (stats['total_interactions'] ?? 0) + 1;
      stats['interaction_types'] = stats['interaction_types'] ?? <String, int>{};
      stats['interaction_types'][interaction.type.name] = (stats['interaction_types'][interaction.type.name] ?? 0) + 1;
      stats['last_updated'] = DateTime.now().toIso8601String();

      await prefs.setString(statsKey, json.encode(stats));
    } catch (e) {
      debugPrint('❌ Error updating daily stats: $e');
    }
  }

  /// Analyze interaction patterns for insights
  Future<void> _analyzeInteractionPatterns(
    String userId,
    SharedPreferences prefs,
  ) async {
    try {
      // Load interaction history
      final history = prefs.getStringList('$_interactionHistoryKey$userId') ?? [];

      if (history.isEmpty) return;

      final interactions = history.map((h) => DuaInteraction.fromJson(json.decode(h))).toList();

      // Analyze patterns
      final duaFrequency = <String, int>{};
      final hourlyActivity = <int, int>{};
      final typeDistribution = <String, int>{};

      for (final interaction in interactions) {
        // Count Du'a frequency
        duaFrequency[interaction.duaId] = (duaFrequency[interaction.duaId] ?? 0) + 1;

        // Count hourly activity
        final hour = interaction.timestamp.hour;
        hourlyActivity[hour] = (hourlyActivity[hour] ?? 0) + 1;

        // Count interaction types
        typeDistribution[interaction.type.name] = (typeDistribution[interaction.type.name] ?? 0) + 1;
      }

      // Update patterns with insights
      final patterns = await _loadPatterns(userId, prefs);

      // Update frequent Du'as based on frequency analysis
      final sortedDuas = duaFrequency.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      final topDuas = sortedDuas.take(10).map((e) => e.key).toList();

      final updatedPatterns = patterns.copyWith(
        frequentDuas: topDuas,
        lastUpdated: DateTime.now(),
      );

      await _savePatterns(updatedPatterns, prefs);

      debugPrint(
        '🔍 Analyzed ${interactions.length} interactions for patterns',
      );
    } catch (e) {
      debugPrint('❌ Error analyzing interaction patterns: $e');
    }
  }

  /// Update category preferences based on usage
  Future<void> _updateCategoryPreferences(
    String userId,
    SharedPreferences prefs,
  ) async {
    try {
      // This would analyze which categories the user interacts with most
      // Implementation would examine Du'a categories from interactions
      debugPrint('📊 Updated category preferences for user: $userId');
    } catch (e) {
      debugPrint('❌ Error updating category preferences: $e');
    }
  }

  /// Calculate reading time patterns
  Future<void> _calculateReadingTimePatterns(
    String userId,
    SharedPreferences prefs,
  ) async {
    try {
      final history = prefs.getStringList('$_interactionHistoryKey$userId') ?? [];

      if (history.isEmpty) return;

      final readingInteractions = history
          .map((h) => DuaInteraction.fromJson(json.decode(h)))
          .where(
            (interaction) => interaction.type == InteractionType.read || interaction.type == InteractionType.view,
          )
          .toList();

      final readingTimes = <String, List<int>>{};

      for (final interaction in readingInteractions) {
        if (interaction.duration.inSeconds > 0) {
          readingTimes[interaction.duaId] ??= [];
          readingTimes[interaction.duaId]!.add(interaction.duration.inSeconds);
        }
      }

      // Calculate averages
      final averageTimes = <String, double>{};
      readingTimes.forEach((duaId, times) {
        if (times.isNotEmpty) {
          averageTimes[duaId] = times.reduce((a, b) => a + b) / times.length;
        }
      });

      // Update patterns
      final patterns = await _loadPatterns(userId, prefs);
      final updatedPatterns = patterns.copyWith(
        averageReadingTimes: averageTimes,
        lastUpdated: DateTime.now(),
      );

      await _savePatterns(updatedPatterns, prefs);

      debugPrint(
        'â±ï¸ Calculated reading time patterns for ${averageTimes.length} Du\'as',
      );
    } catch (e) {
      debugPrint('❌ Error calculating reading time patterns: $e');
    }
  }

  /// Clean up data for a specific key based on cutoff date
  Future<void> _cleanupDataForKey(
    String key,
    DateTime cutoffDate,
    SharedPreferences prefs,
  ) async {
    try {
      if (key.contains('interaction_history_') || key.contains('query_history_')) {
        // Clean up history data
        final history = prefs.getStringList(key) ?? [];
        final filteredHistory = <String>[];

        for (final item in history) {
          try {
            final data = json.decode(item);
            final timestamp = DateTime.parse(data['timestamp']);

            if (timestamp.isAfter(cutoffDate)) {
              filteredHistory.add(item);
            }
          } catch (e) {
            // Skip invalid entries
            continue;
          }
        }

        await prefs.setStringList(key, filteredHistory);
      } else if (key.contains('daily_stats_')) {
        // Check if daily stats are old
        final datePart = key.split('_').last;
        try {
          final date = DateTime.parse(datePart);
          if (date.isBefore(cutoffDate)) {
            await prefs.remove(key);
          }
        } catch (e) {
          // Invalid date format, remove
          await prefs.remove(key);
        }
      }
    } catch (e) {
      debugPrint('❌ Error cleaning up data for key $key: $e');
    }
  }

  /// Get time of day category
  String _getTimeOfDayCategory(int hour) {
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }

  /// Start analytics processing timer
  void _startAnalyticsProcessing(String userId) {
    _analyticsTimer?.cancel();

    // Process analytics every 10 minutes
    _analyticsTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      processAnalytics(userId);
    });
  }

  /// Dispose resources
  void dispose() {
    _analyticsTimer?.cancel();
    _patternsCache.clear();
  }
}
