import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/context_entity.dart';
import '../time/islamic_time_service.dart';
import 'personalization_models.dart';

/// Temporal pattern analyzer for understanding time-based user behavior
/// Analyzes prayer times, Islamic calendar events, and daily/weekly patterns
class TemporalPatternAnalyzer {
  static const String _temporalPatternsKey = 'temporal_patterns_';
  static const String _timeBasedInteractionsKey = 'time_interactions_';
  static const String _islamicCalendarPatternsKey = 'islamic_patterns_';
  static const String _habitStrengthKey = 'habit_strength_';

  // Cache for performance
  final Map<String, TemporalPatterns> _patternsCache = {};

  /// Initialize temporal analyzer for a user
  Future<void> initialize(String userId, SharedPreferences prefs) async {
    try {
      // Load existing temporal patterns
      await _loadPatterns(userId, prefs);

      debugPrint('âœ… Temporal pattern analyzer initialized for user: $userId');
    } catch (e) {
      debugPrint('âŒ Error initializing temporal pattern analyzer: $e');
      rethrow;
    }
  }

  /// Get temporal patterns for a user
  Future<TemporalPatterns> analyzePatterns(
    String userId,
    DateTime currentTime,
  ) async {
    // Check cache first
    if (_patternsCache.containsKey(userId)) {
      final cached = _patternsCache[userId]!;

      // Refresh if patterns are old (24 hours)
      if (currentTime.difference(cached.lastAnalyzed).inHours < 24) {
        return cached;
      }
    }

    // Analyze and refresh patterns
    final prefs = await SharedPreferences.getInstance();
    return await _analyzeAndUpdatePatterns(userId, currentTime, prefs);
  }

  /// Record interaction for temporal analysis
  Future<void> recordInteraction(DuaInteraction interaction) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Record time-based interaction data
      await _recordTimeBasedInteraction(interaction, prefs);

      // Update habit strength
      await _updateHabitStrength(interaction, prefs);

      // Update Islamic calendar patterns
      await _updateIslamicPatterns(interaction, prefs);

      debugPrint(
          'â° Recorded temporal interaction for: ${interaction.userId}');
    } catch (e) {
      debugPrint('âŒ Error recording temporal interaction: $e');
    }
  }

  /// Get time-based patterns for recommendations
  Future<TemporalPatterns> getTimeBasedPatterns(
    String userId,
    DateTime currentTime,
  ) async {
    try {
      final patterns = await analyzePatterns(userId, currentTime);

      // Add real-time context
      final islamicTime = IslamicTimeService.instance.getCurrentTimeContext();
      final enrichedPatterns = await _enrichWithIslamicContext(
        patterns,
        islamicTime,
      );

      return enrichedPatterns;
    } catch (e) {
      debugPrint('âŒ Error getting time-based patterns: $e');
      return TemporalPatterns.empty(userId);
    }
  }

  /// Process session data for temporal insights
  Future<void> processSessionData(UserSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Analyze session timing patterns
      await _analyzeSessionTiming(session, prefs);

      // Update daily patterns
      await _updateDailyPatterns(session, prefs);

      // Update weekly patterns
      await _updateWeeklyPatterns(session, prefs);

      debugPrint(
        'ðŸ“Š Processed session data for temporal analysis: ${session.id}',
      );
    } catch (e) {
      debugPrint('âŒ Error processing session data: $e');
    }
  }

  /// Get habit strength for specific Du'as
  Future<Map<String, HabitStrength>> getHabitStrengths(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final strengthData = prefs.getString('$_habitStrengthKey$userId');

      if (strengthData != null) {
        final data = json.decode(strengthData) as Map<String, dynamic>;
        final habits = <String, HabitStrength>{};

        data.forEach((duaId, habitJson) {
          try {
            habits[duaId] = HabitStrength.fromJson(habitJson);
          } catch (e) {
            // Skip invalid entries
          }
        });

        return habits;
      }

      return {};
    } catch (e) {
      debugPrint('âŒ Error getting habit strengths: $e');
      return {};
    }
  }

  /// Predict optimal times for Du'a recommendations
  Future<List<DateTime>> predictOptimalTimes(
    String userId,
    String duaId,
  ) async {
    try {
      final patterns = await analyzePatterns(userId, DateTime.now());
      final habitStrengths = await getHabitStrengths(userId);

      final optimalTimes = <DateTime>[];
      final now = DateTime.now();

      // Analyze hourly patterns
      patterns.hourlyPatterns.forEach((hour, pattern) {
        if (pattern.popularDuas.contains(duaId) &&
            pattern.activityScore > 0.5) {
          final nextOccurrence = _getNextOccurrenceOfHour(now, hour);
          optimalTimes.add(nextOccurrence);
        }
      });

      // Consider habit strength
      if (habitStrengths.containsKey(duaId)) {
        final habit = habitStrengths[duaId]!;
        if (habit.strength > 0.7) {
          // Add times based on historical practice
          for (final session in habit.recentSessions) {
            final nextSimilarTime = _getNextSimilarTime(now, session);
            if (!optimalTimes.any(
              (time) => time.difference(nextSimilarTime).inHours.abs() < 2,
            )) {
              optimalTimes.add(nextSimilarTime);
            }
          }
        }
      }

      // Sort by proximity to current time
      optimalTimes.sort(
        (a, b) => a
            .difference(now)
            .inMinutes
            .abs()
            .compareTo(b.difference(now).inMinutes.abs()),
      );

      return optimalTimes.take(5).toList();
    } catch (e) {
      debugPrint('âŒ Error predicting optimal times: $e');
      return [];
    }
  }

  /// Clean up old temporal data for privacy compliance
  Future<void> cleanupOldData(DateTime cutoffDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get all temporal data keys
      final keys = prefs.getKeys().where(
            (key) =>
                key.contains('temporal_patterns_') ||
                key.contains('time_interactions_') ||
                key.contains('islamic_patterns_') ||
                key.contains('habit_strength_'),
          );

      for (final key in keys) {
        await _cleanupDataForKey(key, cutoffDate, prefs);
      }

      debugPrint('ðŸ§¹ Cleaned up old temporal data before: $cutoffDate');
    } catch (e) {
      debugPrint('âŒ Error cleaning up temporal data: $e');
    }
  }

  /// Load temporal patterns from storage
  Future<TemporalPatterns> _loadPatterns(
    String userId,
    SharedPreferences prefs,
  ) async {
    try {
      final patternsJson = prefs.getString('$_temporalPatternsKey$userId');

      if (patternsJson != null) {
        final patterns = TemporalPatterns.fromJson(json.decode(patternsJson));
        _patternsCache[userId] = patterns;
        return patterns;
      } else {
        // Create empty patterns for new user
        final emptyPatterns = TemporalPatterns.empty(userId);
        _patternsCache[userId] = emptyPatterns;
        await _savePatterns(emptyPatterns, prefs);
        return emptyPatterns;
      }
    } catch (e) {
      debugPrint('âŒ Error loading temporal patterns: $e');
      return TemporalPatterns.empty(userId);
    }
  }

  /// Save temporal patterns to storage
  Future<void> _savePatterns(
    TemporalPatterns patterns,
    SharedPreferences prefs,
  ) async {
    try {
      final patternsJson = json.encode(patterns.toJson());
      await prefs.setString(
        '$_temporalPatternsKey${patterns.userId}',
        patternsJson,
      );
      _patternsCache[patterns.userId] = patterns;
    } catch (e) {
      debugPrint('âŒ Error saving temporal patterns: $e');
    }
  }

  /// Analyze and update temporal patterns
  Future<TemporalPatterns> _analyzeAndUpdatePatterns(
    String userId,
    DateTime currentTime,
    SharedPreferences prefs,
  ) async {
    try {
      // Load interaction history
      final interactions = await _loadTimeBasedInteractions(userId, prefs);

      // Analyze hourly patterns
      final hourlyPatterns = _analyzeHourlyPatterns(interactions);

      // Analyze day-of-week patterns
      final dayPatterns = _analyzeDayOfWeekPatterns(interactions);

      // Analyze seasonal patterns (Islamic calendar)
      final seasonalPatterns = await _analyzeSeasonalPatterns(interactions);

      // Calculate habit strengths
      final habitStrengths = _calculateHabitStrengths(interactions);

      final patterns = TemporalPatterns(
        userId: userId,
        hourlyPatterns: hourlyPatterns,
        dayOfWeekPatterns: dayPatterns,
        seasonalPatterns: seasonalPatterns,
        lastAnalyzed: currentTime,
        habitStrengths: habitStrengths,
      );

      await _savePatterns(patterns, prefs);
      return patterns;
    } catch (e) {
      debugPrint('âŒ Error analyzing temporal patterns: $e');
      return TemporalPatterns.empty(userId);
    }
  }

  /// Record time-based interaction data
  Future<void> _recordTimeBasedInteraction(
    DuaInteraction interaction,
    SharedPreferences prefs,
  ) async {
    try {
      final timeData = {
        'dua_id': interaction.duaId,
        'hour': interaction.timestamp.hour,
        'day_of_week': DateFormat('EEEE').format(interaction.timestamp),
        'timestamp': interaction.timestamp.toIso8601String(),
        'duration': interaction.duration.inSeconds,
        'interaction_type': interaction.type.name,
      };

      final interactions = prefs.getStringList(
            '$_timeBasedInteractionsKey${interaction.userId}',
          ) ??
          [];
      interactions.add(json.encode(timeData));

      // Keep only last 1000 interactions for performance
      if (interactions.length > 1000) {
        interactions.removeRange(0, interactions.length - 1000);
      }

      await prefs.setStringList(
        '$_timeBasedInteractionsKey${interaction.userId}',
        interactions,
      );
    } catch (e) {
      debugPrint('âŒ Error recording time-based interaction: $e');
    }
  }

  /// Update habit strength for a Du'a
  Future<void> _updateHabitStrength(
    DuaInteraction interaction,
    SharedPreferences prefs,
  ) async {
    try {
      final habits = await getHabitStrengths(interaction.userId);

      final currentHabit = habits[interaction.duaId] ??
          HabitStrength(
            duaId: interaction.duaId,
            strength: 0.0,
            frequency: 0,
            avgDuration: Duration.zero,
            lastPracticed: interaction.timestamp,
          );

      // Update habit metrics
      final newFrequency = currentHabit.frequency + 1;
      final newAvgDuration = Duration(
        seconds:
            ((currentHabit.avgDuration.inSeconds * currentHabit.frequency) +
                    interaction.duration.inSeconds) ~/
                newFrequency,
      );

      // Calculate strength based on frequency and recency
      final daysSinceLastPractice =
          interaction.timestamp.difference(currentHabit.lastPracticed).inDays;

      double strengthBoost = 0.1; // Base boost per interaction
      if (daysSinceLastPractice <= 1) {
        strengthBoost *= 2.0; // Double boost for consecutive days
      } else if (daysSinceLastPractice > 7) {
        strengthBoost *= 0.5; // Reduced boost for long gaps
      }

      final newStrength = (currentHabit.strength + strengthBoost).clamp(
        0.0,
        1.0,
      );

      // Update recent sessions
      final recentSessions = [
        ...currentHabit.recentSessions,
        interaction.timestamp,
      ];
      recentSessions.sort();
      if (recentSessions.length > 10) {
        recentSessions.removeRange(0, recentSessions.length - 10);
      }

      // Calculate streak
      int streakDays = _calculateStreak(recentSessions);

      final updatedHabit = currentHabit.copyWith(
        strength: newStrength,
        frequency: newFrequency,
        avgDuration: newAvgDuration,
        lastPracticed: interaction.timestamp,
        streakDays: streakDays,
        recentSessions: recentSessions,
      );

      habits[interaction.duaId] = updatedHabit;

      // Save updated habits
      final habitsJson = <String, dynamic>{};
      habits.forEach((duaId, habit) {
        habitsJson[duaId] = habit.toJson();
      });

      await prefs.setString(
        '$_habitStrengthKey${interaction.userId}',
        json.encode(habitsJson),
      );
    } catch (e) {
      debugPrint('âŒ Error updating habit strength: $e');
    }
  }

  /// Update Islamic calendar patterns
  Future<void> _updateIslamicPatterns(
    DuaInteraction interaction,
    SharedPreferences prefs,
  ) async {
    try {
      final islamicTime = IslamicTimeService.instance.getCurrentTimeContext();

      final patternData = {
        'dua_id': interaction.duaId,
        'islamic_month': islamicTime.islamicDate.monthName,
        'is_holy_month': islamicTime.islamicDate.isHolyMonth,
        'is_ramadan': islamicTime.isRamadan,
        'is_hajj_season': islamicTime.isHajjSeason,
        'special_occasions': islamicTime.specialOccasions,
        'prayer_time_context': _getPrayerTimeContext(islamicTime),
        'timestamp': interaction.timestamp.toIso8601String(),
      };

      final patterns = prefs.getStringList(
            '$_islamicCalendarPatternsKey${interaction.userId}',
          ) ??
          [];
      patterns.add(json.encode(patternData));

      // Keep only last 500 entries
      if (patterns.length > 500) {
        patterns.removeRange(0, patterns.length - 500);
      }

      await prefs.setStringList(
        '$_islamicCalendarPatternsKey${interaction.userId}',
        patterns,
      );
    } catch (e) {
      debugPrint('âŒ Error updating Islamic patterns: $e');
    }
  }

  /// Load time-based interactions
  Future<List<Map<String, dynamic>>> _loadTimeBasedInteractions(
    String userId,
    SharedPreferences prefs,
  ) async {
    try {
      final interactions =
          prefs.getStringList('$_timeBasedInteractionsKey$userId') ?? [];
      return interactions
          .map((i) => json.decode(i) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('âŒ Error loading time-based interactions: $e');
      return [];
    }
  }

  /// Analyze hourly patterns
  Map<int, HourlyPattern> _analyzeHourlyPatterns(
    List<Map<String, dynamic>> interactions,
  ) {
    final hourlyData = <int, Map<String, List<String>>>{};
    final hourlyActivity = <int, int>{};

    for (final interaction in interactions) {
      final hour = interaction['hour'] as int;
      final duaId = interaction['dua_id'] as String;

      hourlyData[hour] ??= {'duas': []};
      hourlyData[hour]!['duas']!.add(duaId);

      hourlyActivity[hour] = (hourlyActivity[hour] ?? 0) + 1;
    }

    final patterns = <int, HourlyPattern>{};

    hourlyData.forEach((hour, data) {
      final duas = data['duas']!;
      final duaFrequency = <String, int>{};

      for (final dua in duas) {
        duaFrequency[dua] = (duaFrequency[dua] ?? 0) + 1;
      }

      final popularDuas = duaFrequency.entries
          .where((entry) => entry.value >= 2) // At least 2 occurrences
          .map((entry) => entry.key)
          .toList();

      final totalActivity = hourlyActivity.values.fold(
        0,
        (sum, count) => sum + count,
      );
      final activityScore =
          totalActivity > 0 ? hourlyActivity[hour]! / totalActivity : 0.0;

      patterns[hour] = HourlyPattern(
        hour: hour,
        popularDuas: popularDuas,
        activityScore: activityScore,
        categoryFrequency: {}, // Would be populated with actual category data
        totalInteractions: hourlyActivity[hour] ?? 0,
      );
    });

    return patterns;
  }

  /// Analyze day of week patterns
  Map<String, DayOfWeekPattern> _analyzeDayOfWeekPatterns(
    List<Map<String, dynamic>> interactions,
  ) {
    final dailyData = <String, Map<String, List<String>>>{};
    final dailyActivity = <String, int>{};

    for (final interaction in interactions) {
      final day = interaction['day_of_week'] as String;
      final duaId = interaction['dua_id'] as String;

      dailyData[day] ??= {'duas': []};
      dailyData[day]!['duas']!.add(duaId);

      dailyActivity[day] = (dailyActivity[day] ?? 0) + 1;
    }

    final patterns = <String, DayOfWeekPattern>{};

    dailyData.forEach((day, data) {
      final duas = data['duas']!;
      final duaFrequency = <String, int>{};

      for (final dua in duas) {
        duaFrequency[dua] = (duaFrequency[dua] ?? 0) + 1;
      }

      final preferredDuas = duaFrequency.entries
          .where((entry) => entry.value >= 3) // At least 3 occurrences
          .map((entry) => entry.key)
          .toList();

      final totalActivity = dailyActivity.values.fold(
        0,
        (sum, count) => sum + count,
      );
      final engagementScore =
          totalActivity > 0 ? dailyActivity[day]! / totalActivity : 0.0;

      patterns[day] = DayOfWeekPattern(
        dayName: day,
        preferredDuas: preferredDuas,
        engagementScore: engagementScore,
        timeDistribution: {}, // Would be populated with hourly distribution
        totalSessions: dailyActivity[day] ?? 0,
      );
    });

    return patterns;
  }

  /// Analyze seasonal patterns
  Future<Map<String, SeasonalPattern>> _analyzeSeasonalPatterns(
    List<Map<String, dynamic>> interactions,
  ) async {
    // This would analyze Islamic calendar patterns
    // For now, returning basic structure

    return {
      'ramadan': const SeasonalPattern(
        season: 'ramadan',
        seasonalDuas: [],
        relevanceScore: 0.0,
        occasionFrequency: {},
      ),
    };
  }

  /// Calculate habit strengths
  Map<String, double> _calculateHabitStrengths(
    List<Map<String, dynamic>> interactions,
  ) {
    final duaFrequency = <String, int>{};
    final duaLastSeen = <String, DateTime>{};

    for (final interaction in interactions) {
      final duaId = interaction['dua_id'] as String;
      final timestamp = DateTime.parse(interaction['timestamp']);

      duaFrequency[duaId] = (duaFrequency[duaId] ?? 0) + 1;

      if (!duaLastSeen.containsKey(duaId) ||
          duaLastSeen[duaId]!.isBefore(timestamp)) {
        duaLastSeen[duaId] = timestamp;
      }
    }

    final habits = <String, double>{};
    final now = DateTime.now();

    duaFrequency.forEach((duaId, frequency) {
      final lastSeen = duaLastSeen[duaId]!;
      final daysSinceLastSeen = now.difference(lastSeen).inDays;

      // Calculate strength based on frequency and recency
      double strength = frequency / 100.0; // Base strength from frequency

      // Apply recency penalty
      if (daysSinceLastSeen > 7) {
        strength *= 0.5; // Reduce strength for inactive habits
      } else if (daysSinceLastSeen <= 1) {
        strength *= 1.5; // Boost for very recent habits
      }

      habits[duaId] = strength.clamp(0.0, 1.0);
    });

    return habits;
  }

  /// Enrich patterns with Islamic context
  Future<TemporalPatterns> _enrichWithIslamicContext(
    TemporalPatterns patterns,
    TimeContext islamicTime,
  ) async {
    // Add prayer time patterns
    final prayerPatterns = <String, int>{};

    if (islamicTime.isRamadan) {
      prayerPatterns['ramadan'] = 10;
    }

    if (islamicTime.isHajjSeason) {
      prayerPatterns['hajj'] = 8;
    }

    return patterns.copyWith(
      prayerTimePatterns: prayerPatterns,
      lastAnalyzed: DateTime.now(),
    );
  }

  /// Get prayer time context
  String _getPrayerTimeContext(TimeContext islamicTime) {
    if (islamicTime.prayerTimes.nextPrayer != null) {
      final nextPrayer = islamicTime.prayerTimes.nextPrayer!;
      final minutesUntilPrayer = nextPrayer.remaining.inMinutes;

      if (minutesUntilPrayer <= 30) {
        return 'before_${nextPrayer.type.name}';
      }
    }

    return 'general';
  }

  /// Calculate consecutive practice streak
  int _calculateStreak(List<DateTime> sessions) {
    if (sessions.isEmpty) return 0;

    sessions.sort((a, b) => b.compareTo(a)); // Sort descending

    int streak = 1;
    DateTime currentDate = sessions.first;

    for (int i = 1; i < sessions.length; i++) {
      final previousDate = sessions[i];
      final daysDiff = currentDate.difference(previousDate).inDays;

      if (daysDiff == 1) {
        streak++;
        currentDate = previousDate;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get next occurrence of a specific hour
  DateTime _getNextOccurrenceOfHour(DateTime now, int hour) {
    var nextOccurrence = DateTime(now.year, now.month, now.day, hour);

    if (nextOccurrence.isBefore(now)) {
      nextOccurrence = nextOccurrence.add(const Duration(days: 1));
    }

    return nextOccurrence;
  }

  /// Get next similar time based on historical session
  DateTime _getNextSimilarTime(DateTime now, DateTime historicalTime) {
    var nextSimilar = DateTime(
      now.year,
      now.month,
      now.day,
      historicalTime.hour,
      historicalTime.minute,
    );

    if (nextSimilar.isBefore(now)) {
      nextSimilar = nextSimilar.add(const Duration(days: 1));
    }

    return nextSimilar;
  }

  /// Analyze session timing patterns
  Future<void> _analyzeSessionTiming(
    UserSession session,
    SharedPreferences prefs,
  ) async {
    // Implementation would analyze session start times, durations, etc.
  }

  /// Update daily patterns
  Future<void> _updateDailyPatterns(
    UserSession session,
    SharedPreferences prefs,
  ) async {
    // Implementation would track daily usage patterns
  }

  /// Update weekly patterns
  Future<void> _updateWeeklyPatterns(
    UserSession session,
    SharedPreferences prefs,
  ) async {
    // Implementation would track weekly usage patterns
  }

  /// Clean up data for a specific key
  Future<void> _cleanupDataForKey(
    String key,
    DateTime cutoffDate,
    SharedPreferences prefs,
  ) async {
    try {
      if (key.contains('time_interactions_') ||
          key.contains('islamic_patterns_')) {
        final data = prefs.getStringList(key) ?? [];
        final filteredData = <String>[];

        for (final item in data) {
          try {
            final itemData = json.decode(item);
            final timestamp = DateTime.parse(itemData['timestamp']);

            if (timestamp.isAfter(cutoffDate)) {
              filteredData.add(item);
            }
          } catch (e) {
            continue;
          }
        }

        await prefs.setStringList(key, filteredData);
      }
    } catch (e) {
      debugPrint('âŒ Error cleaning up data for key $key: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _patternsCache.clear();
  }
}
