import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/context_entity.dart';
import '../../domain/entities/dua_entity.dart';

/// HabitTrackingService class implementation
class HabitTrackingService {
  static HabitTrackingService? _instance;
  static HabitTrackingService get instance =>
      _instance ??= HabitTrackingService._();

  HabitTrackingService._();

  bool _isInitialized = false;
  HabitStats? _currentStats;

  /// Stream of habit-based Du'a suggestions
  final StreamController<List<SmartSuggestion>> _suggestionsController =
      StreamController<List<SmartSuggestion>>.broadcast();
  Stream<List<SmartSuggestion>> get suggestionStream =>
      _suggestionsController.stream;

  /// Stream of habit statistics updates
  final StreamController<HabitStats> _statsController =
      StreamController<HabitStats>.broadcast();
  Stream<HabitStats> get statsStream => _statsController.stream;

  static const String _habitStatsKey = 'habit_stats';
  static const String _practicedDuasKey = 'practiced_duas_';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadHabitStats();
      _isInitialized = true;
      debugPrint('Habit tracking service initialized');
    } catch (e) {
      debugPrint('Failed to initialize habit tracking service: $e');
      rethrow;
    }
  }

  /// Get current habit statistics
  Future<HabitStats> getHabitStats() async {
    await _ensureInitialized();

    if (_currentStats == null) {
      await _loadHabitStats();
    }

    return _currentStats!;
  }

  /// Record Du'a practice session
  Future<void> recordDuaPractice(
    String duaId, {
    int duration = 1, // in minutes
    bool completed = true,
  }) async {
    await _ensureInitialized();

    try {
      final today = DateTime.now();
      final todayKey = _formatDateKey(today);

      // Load today's practiced Du'as
      final prefs = await SharedPreferences.getInstance();
      final practiceDataJson = prefs.getString('$_practicedDuasKey$todayKey');
      Map<String, dynamic> practiceData = {};

      if (practiceDataJson != null) {
        practiceData = json.decode(practiceDataJson);
      }

      // Update practice data
      if (practiceData.containsKey(duaId)) {
        practiceData[duaId]['count'] = (practiceData[duaId]['count'] ?? 0) + 1;
        practiceData[duaId]['totalDuration'] =
            (practiceData[duaId]['totalDuration'] ?? 0) + duration;
      } else {
        practiceData[duaId] = {
          'count': 1,
          'totalDuration': duration,
          'firstPractice': today.toIso8601String(),
          'lastPractice': today.toIso8601String(),
        };
      }

      practiceData[duaId]['lastPractice'] = today.toIso8601String();

      // Save updated practice data
      await prefs.setString(
          '$_practicedDuasKey$todayKey', json.encode(practiceData));

      // Update habit statistics
      await _updateHabitStats(today, practiceData);

      debugPrint('Recorded Du\'a practice: $duaId (${duration}min)');
    } catch (e) {
      debugPrint('Failed to record Du\'a practice: $e');
    }
  }

  /// Get daily practice statistics
  Future<Map<String, dynamic>> getDailyPracticeStats(DateTime date) async {
    await _ensureInitialized();

    try {
      final dateKey = _formatDateKey(date);
      final prefs = await SharedPreferences.getInstance();
      final practiceDataJson = prefs.getString('$_practicedDuasKey$dateKey');

      if (practiceDataJson != null) {
        return json.decode(practiceDataJson);
      }

      return {};
    } catch (e) {
      debugPrint('Failed to get daily practice stats: $e');
      return {};
    }
  }

  /// Get weekly practice summary
  Future<Map<String, dynamic>> getWeeklyPracticeStats() async {
    await _ensureInitialized();

    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));

    int totalSessions = 0;
    int totalMinutes = 0;
    int activeDays = 0;
    Map<String, int> duaCounts = {};

    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyStats = await getDailyPracticeStats(date);

      if (dailyStats.isNotEmpty) {
        activeDays++;

        for (final entry in dailyStats.entries) {
          final duaId = entry.key;
          final data = entry.value as Map<String, dynamic>;

          totalSessions += data['count'] as int;
          totalMinutes += data['totalDuration'] as int;
          duaCounts[duaId] = (duaCounts[duaId] ?? 0) + (data['count'] as int);
        }
      }
    }

    return {
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'activeDays': activeDays,
      'averageSessionsPerDay': activeDays > 0 ? totalSessions / activeDays : 0,
      'averageMinutesPerDay': activeDays > 0 ? totalMinutes / activeDays : 0,
      'mostPracticedDuas': duaCounts,
    };
  }

  /// Set weekly Du'a practice goal
  Future<void> setWeeklyGoal(int goalCount) async {
    await _ensureInitialized();

    try {
      // Update current stats
      if (_currentStats != null) {
        _currentStats = _currentStats!.copyWith(weeklyGoal: goalCount);
        await _saveHabitStats(_currentStats!);
        _statsController.add(_currentStats!);
      }

      debugPrint('Weekly goal set to $goalCount Du\'as');
    } catch (e) {
      debugPrint('Failed to set weekly goal: $e');
    }
  }

  /// Get habit-based Du'a suggestions
  Future<List<SmartSuggestion>> getHabitBasedSuggestions(
      List<DuaEntity> allDuas) async {
    await _ensureInitialized();

    final suggestions = <SmartSuggestion>[];
    final now = DateTime.now();
    final stats = await getHabitStats();

    // Streak maintenance suggestions
    if (stats.currentStreak > 0) {
      final lastActivityDaysAgo = now.difference(stats.lastActivity).inDays;

      if (lastActivityDaysAgo >= 1) {
        // User hasn't practiced today, suggest to maintain streak
        final favoriteCategories = await _getFavoriteCategories();
        final suggestedDuas = allDuas
            .where((dua) =>
                favoriteCategories.contains(dua.category.toLowerCase()))
            .toList();

        for (final dua in suggestedDuas.take(3)) {
          suggestions.add(
            SmartSuggestion(
              duaId: dua.id,
              type: SuggestionType.habitBased,
              confidence: 0.9,
              reason: 'Keep your ${stats.currentStreak}-day streak going!',
              timestamp: now,
              trigger: SuggestionTrigger.habitReminder,
            ),
          );
        }
      }
    }

    // Weekly goal progress suggestions
    final weeklyProgress = await _getWeeklyProgressDays();

    if (weeklyProgress < stats.weeklyGoal && now.weekday >= 5) {
      // Friday or later and behind on weekly goal
      final quickDuas = allDuas
          .where(
            (dua) =>
                dua.category.toLowerCase().contains('daily') ||
                dua.category.toLowerCase().contains('short'),
          )
          .toList();

      for (final dua in quickDuas.take(2)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.habitBased,
            confidence: 0.8,
            reason: 'Quick Du\'a to help reach your weekly goal',
            timestamp: now,
            trigger: SuggestionTrigger.habitReminder,
          ),
        );
      }
    }

    // Category diversity suggestions
    final categoriesUsedThisWeek = await _getCategoriesUsedThisWeek();
    final allCategories = allDuas.map((dua) => dua.category).toSet().toList();
    final underusedCategories = allCategories
        .where((cat) => !categoriesUsedThisWeek.contains(cat.toLowerCase()))
        .toList();

    if (underusedCategories.isNotEmpty) {
      final categoryToExplore = underusedCategories.first;
      final categoryDuas = allDuas
          .where((dua) =>
              dua.category.toLowerCase() == categoryToExplore.toLowerCase())
          .toList();

      for (final dua in categoryDuas.take(1)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.habitBased,
            confidence: 0.7,
            reason:
                'Explore $categoryToExplore Du\'as to diversify your practice',
            timestamp: now,
            trigger: SuggestionTrigger.habitReminder,
          ),
        );
      }
    }

    // Milestone celebration suggestions
    if (stats.currentStreak > 0 &&
        (stats.currentStreak % 7 == 0 || stats.currentStreak % 30 == 0)) {
      final celebratoryDuas = allDuas
          .where(
            (dua) =>
                dua.category.toLowerCase().contains('gratitude') ||
                dua.category.toLowerCase().contains('praise'),
          )
          .toList();

      for (final dua in celebratoryDuas.take(1)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.habitBased,
            confidence: 0.95,
            reason: 'Celebrate your ${stats.currentStreak}-day milestone!',
            timestamp: now,
            trigger: SuggestionTrigger.habitReminder,
          ),
        );
      }
    }

    return suggestions;
  }

  /// Get personalized Du'a recommendations based on practice history
  Future<List<String>> getPersonalizedRecommendations(
      List<DuaEntity> allDuas) async {
    await _ensureInitialized();

    final favoriteCategories = await _getFavoriteCategories();
    final weeklyStats = await getWeeklyPracticeStats();
    final mostPracticed = weeklyStats['mostPracticedDuas'] as Map<String, int>;

    // Recommend similar Du'as to frequently practiced ones
    final recommendations = <String>[];

    for (final entry in mostPracticed.entries) {
      final duaId = entry.key;
      final practiceCount = entry.value;

      if (practiceCount >= 3) {
        // Find the Du'a entity
        final practicedDua = allDuas.firstWhere((dua) => dua.id == duaId,
            orElse: () => allDuas.first);

        // Find similar Du'as in the same category
        final similarDuas = allDuas
            .where(
              (dua) =>
                  dua.category == practicedDua.category &&
                  dua.id != duaId &&
                  !mostPracticed.containsKey(dua.id),
            )
            .toList();

        recommendations.addAll(similarDuas.take(2).map((dua) => dua.id));
      }
    }

    // Add Du'as from favorite categories
    for (final category in favoriteCategories.take(3)) {
      final categoryDuas = allDuas
          .where(
            (dua) =>
                dua.category.toLowerCase() == category &&
                !recommendations.contains(dua.id) &&
                !mostPracticed.containsKey(dua.id),
          )
          .toList();

      recommendations.addAll(categoryDuas.take(1).map((dua) => dua.id));
    }

    return recommendations.take(10).toList();
  }

  /// Check if daily goal is achieved
  Future<bool> isDailyGoalAchieved() async {
    await _ensureInitialized();

    final stats = await getHabitStats();
    if (stats.weeklyGoal <= 0) return false;

    final todayProgress = await _getTodayProgress();
    return todayProgress >=
        (stats.weeklyGoal / 7).round(); // Daily portion of weekly goal
  }

  /// Get current streak information
  Future<Map<String, dynamic>> getStreakInfo() async {
    final stats = await getHabitStats();

    return {
      'currentStreak': stats.currentStreak,
      'longestStreak': stats.longestStreak,
      'lastActivity': stats.lastActivity,
      'daysSinceLastActivity':
          DateTime.now().difference(stats.lastActivity).inDays,
      'isActiveToday': _isSameDay(DateTime.now(), stats.lastActivity),
    };
  }

  Future<void> _loadHabitStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString(_habitStatsKey);

      if (statsJson != null) {
        final statsMap = json.decode(statsJson);
        _currentStats = HabitStats.fromJson(statsMap);
      } else {
        // Create default stats
        _currentStats = HabitStats(
          currentStreak: 0,
          longestStreak: 0,
          totalDuas: 0,
          lastActivity: DateTime.now().subtract(const Duration(days: 1)),
          categoryStats: {},
          recentActivity: [],
          weeklyGoal: 7, // Default 7 duas per week
          monthlyGoal: 30, // Default 30 duas per month
        );
        await _saveHabitStats(_currentStats!);
      }
    } catch (e) {
      debugPrint('Failed to load habit stats: $e');
      // Create default stats on error
      _currentStats = HabitStats(
        currentStreak: 0,
        longestStreak: 0,
        totalDuas: 0,
        lastActivity: DateTime.now().subtract(const Duration(days: 1)),
        categoryStats: {},
        recentActivity: [],
        weeklyGoal: 7,
        monthlyGoal: 30,
      );
    }
  }

  Future<void> _saveHabitStats(HabitStats stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = json.encode(stats.toJson());
      await prefs.setString(_habitStatsKey, statsJson);
    } catch (e) {
      debugPrint('Failed to save habit stats: $e');
    }
  }

  Future<void> _updateHabitStats(
      DateTime practiceDate, Map<String, dynamic> todayPractice) async {
    if (_currentStats == null) return;

    try {
      // Calculate today's session count
      int todaySessions = 0;

      for (final data in todayPractice.values) {
        final sessionData = data as Map<String, dynamic>;
        todaySessions += sessionData['count'] as int;
      }

      // Update streak
      int newStreak = _currentStats!.currentStreak;
      if (_isSameDay(practiceDate, _currentStats!.lastActivity)) {
        // Same day, maintain streak
      } else if (_isConsecutiveDay(practiceDate, _currentStats!.lastActivity)) {
        // Consecutive day, increment streak
        newStreak = _currentStats!.currentStreak + 1;
      } else {
        // Gap in practice, reset streak
        newStreak = 1;
      }

      // Update stats
      final updatedStats = _currentStats!.copyWith(
        totalDuas: _currentStats!.totalDuas + todaySessions,
        currentStreak: newStreak,
        longestStreak: newStreak > _currentStats!.longestStreak
            ? newStreak
            : _currentStats!.longestStreak,
        lastActivity: practiceDate,
      );

      _currentStats = updatedStats;
      await _saveHabitStats(_currentStats!);
      _statsController.add(_currentStats!);

      // Generate habit-based suggestions
      _suggestionsController.add([]); // Trigger suggestion update
    } catch (e) {
      debugPrint('Failed to update habit stats: $e');
    }
  }

  Future<List<String>> _getFavoriteCategories() async {
    // Get most practiced categories from the last 30 days
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));

    Map<String, int> categoryCounts = {};

    for (int i = 0; i < 30; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyStats = await getDailyPracticeStats(date);

      // Note: This is simplified. In a real implementation,
      // you would need to map duaId to category
      for (final entry in dailyStats.entries) {
        final data = entry.value as Map<String, dynamic>;
        final count = data['count'] as int;

        // For now, use a placeholder category mapping
        final category = 'general'; // This should map duaId to category
        categoryCounts[category] = (categoryCounts[category] ?? 0) + count;
      }
    }

    // Sort by practice count and return top categories
    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.take(5).map((e) => e.key).toList();
  }

  Future<int> _getTodayProgress() async {
    final today = DateTime.now();
    final dailyStats = await getDailyPracticeStats(today);

    int totalMinutes = 0;
    for (final data in dailyStats.values) {
      final sessionData = data as Map<String, dynamic>;
      totalMinutes += sessionData['totalDuration'] as int;
    }

    return totalMinutes;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isConsecutiveDay(DateTime current, DateTime previous) {
    final difference = current.difference(previous).inDays;
    return difference == 1;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get weekly progress in days
  Future<int> _getWeeklyProgressDays() async {
    final weeklyStats = await getWeeklyPracticeStats();
    return weeklyStats['activeDays'] as int;
  }

  /// Get categories used this week
  Future<List<String>> _getCategoriesUsedThisWeek() async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));
    final Set<String> categoriesUsed = {};

    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final dailyStats = await getDailyPracticeStats(date);

      if (dailyStats.isNotEmpty) {
        // For now, use a placeholder category mapping
        // In a real implementation, you would map duaId to category
        categoriesUsed.add('general');
      }
    }

    return categoriesUsed.toList();
  }

  void dispose() {
    _suggestionsController.close();
    _statsController.close();
  }
}
