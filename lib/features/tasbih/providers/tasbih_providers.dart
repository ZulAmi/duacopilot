import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage_service.dart';
import '../../../domain/entities/tasbih_entity.dart';
import '../services/digital_tasbih_service.dart';

// Service Provider
final digitalTasbihServiceProvider = Provider<DigitalTasbihService>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return DigitalTasbihService(secureStorage);
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// Tasbih Service Initialization Provider
final tasbihInitProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(digitalTasbihServiceProvider);
  return await service.initialize();
});

// Current Session Stream Provider
final currentTasbihSessionProvider = StreamProvider.autoDispose<TasbihSession?>((ref) {
  final service = ref.watch(digitalTasbihServiceProvider);
  return service.sessionStream;
});

// Tasbih Statistics Stream Provider
final tasbihStatsProvider = StreamProvider.autoDispose<TasbihStats?>((ref) {
  final service = ref.watch(digitalTasbihServiceProvider);
  return service.statsStream;
});

// Achievements Stream Provider
final tasbihAchievementsProvider = StreamProvider.autoDispose<List<Achievement>>((ref) {
  final service = ref.watch(digitalTasbihServiceProvider);
  return service.achievementsStream;
});

// Session Actions Provider
class TasbihSessionNotifier extends StateNotifier<AsyncValue<TasbihSession?>> {
  final DigitalTasbihService _service;

  TasbihSessionNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> startSession({required TasbihType type, required int targetCount, TasbihGoal? goal}) async {
    state = const AsyncValue.loading();
    try {
      final session = await _service.startSession(type: type, targetCount: targetCount, goal: goal);
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addCount({InputMethod method = InputMethod.touch}) async {
    try {
      await _service.addCount(method: method);
      // State will be updated through the stream
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> endSession() async {
    try {
      await _service.endSession();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final tasbihSessionProvider = StateNotifierProvider.autoDispose<TasbihSessionNotifier, AsyncValue<TasbihSession?>>((
  ref,
) {
  final service = ref.watch(digitalTasbihServiceProvider);
  return TasbihSessionNotifier(service);
});

// Settings Provider
class TasbihSettingsNotifier extends StateNotifier<TasbihSettings?> {
  final DigitalTasbihService _service;

  TasbihSettingsNotifier(this._service) : super(null) {
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    state = _service.currentSettings;
  }

  Future<void> updateSettings(TasbihSettings newSettings) async {
    await _service.saveSettings(newSettings);
    state = newSettings;
  }
}

final tasbihSettingsProvider = StateNotifierProvider<TasbihSettingsNotifier, TasbihSettings?>((ref) {
  final service = ref.watch(digitalTasbihServiceProvider);
  return TasbihSettingsNotifier(service);
});

// Current Session Simple Providers (for easier access)
final currentSessionProvider = Provider.autoDispose<TasbihSession?>((ref) {
  final sessionAsync = ref.watch(currentTasbihSessionProvider);
  return sessionAsync.when(data: (session) => session, loading: () => null, error: (_, __) => null);
});

final currentCountProvider = Provider.autoDispose<int>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.currentCount ?? 0;
});

final targetCountProvider = Provider.autoDispose<int>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.targetCount ?? 33;
});

final sessionProgressProvider = Provider.autoDispose<double>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null || session.targetCount == 0) return 0.0;
  return session.currentCount / session.targetCount;
});

final isSessionActiveProvider = Provider.autoDispose<bool>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session != null && session.isCompleted != true;
});

final sessionDurationProvider = Provider.autoDispose<Duration?>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return null;

  final endTime = session.endTime ?? DateTime.now();
  return endTime.difference(session.startTime);
});

final currentDhikrTextProvider = Provider.autoDispose<String>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return '';

  switch (session.type) {
    case TasbihType.subhanallah:
      return 'سُبْحَانَ اللهِ';
    case TasbihType.alhamdulillah:
      return 'اَلْحَمْدُ للهِ';
    case TasbihType.allahuakbar:
      return 'اَللهُ أَكْبَرُ';
    case TasbihType.lailahaillallah:
      return 'لَا إِلٰهَ إِلَّا اللهُ';
    case TasbihType.astaghfirullah:
      return 'أَسْتَغْفِرُ اللهَ';
    default:
      return 'ذِكْر';
  }
});

// Statistics Providers
final totalSessionsProvider = Provider.autoDispose<int>((ref) {
  final statsAsync = ref.watch(tasbihStatsProvider);
  return statsAsync.when(data: (stats) => stats?.totalSessions ?? 0, loading: () => 0, error: (_, __) => 0);
});

final totalCountProvider = Provider.autoDispose<int>((ref) {
  final statsAsync = ref.watch(tasbihStatsProvider);
  return statsAsync.when(data: (stats) => stats?.totalCount ?? 0, loading: () => 0, error: (_, __) => 0);
});

final totalTimeProvider = Provider.autoDispose<Duration>((ref) {
  final statsAsync = ref.watch(tasbihStatsProvider);
  return statsAsync.when(
    data: (stats) => stats?.totalTime ?? Duration.zero,
    loading: () => Duration.zero,
    error: (_, __) => Duration.zero,
  );
});

final currentStreakProvider = Provider.autoDispose<int>((ref) {
  final statsAsync = ref.watch(tasbihStatsProvider);
  return statsAsync.when(data: (stats) => stats?.currentStreak ?? 0, loading: () => 0, error: (_, __) => 0);
});

final longestStreakProvider = Provider.autoDispose<int>((ref) {
  final statsAsync = ref.watch(tasbihStatsProvider);
  return statsAsync.when(data: (stats) => stats?.longestStreak ?? 0, loading: () => 0, error: (_, __) => 0);
});

// Goals Providers
final activeGoalsProvider = Provider.autoDispose<List<TasbihGoal>>((ref) {
  final service = ref.watch(digitalTasbihServiceProvider);
  return service.activeGoals;
});

final currentGoalProvider = Provider.autoDispose<TasbihGoal?>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.goal;
});

final goalProgressProvider = Provider.autoDispose<double>((ref) {
  final goal = ref.watch(currentGoalProvider);
  if (goal == null || goal.targetCount == 0) return 0.0;
  return goal.currentProgress / goal.targetCount;
});

// Achievement Providers
final unlockedAchievementsProvider = Provider.autoDispose<List<Achievement>>((ref) {
  final achievementsAsync = ref.watch(tasbihAchievementsProvider);
  return achievementsAsync.when(data: (achievements) => achievements, loading: () => [], error: (_, __) => []);
});

final recentAchievementsProvider = Provider.autoDispose<List<Achievement>>((ref) {
  final achievements = ref.watch(unlockedAchievementsProvider);
  final now = DateTime.now();
  final threeDaysAgo = now.subtract(const Duration(days: 3));

  return achievements.where((achievement) => achievement.unlockedAt.isAfter(threeDaysAgo)).toList()
    ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
});

final totalAchievementPointsProvider = Provider.autoDispose<int>((ref) {
  final achievements = ref.watch(unlockedAchievementsProvider);
  return achievements.fold(0, (sum, achievement) => sum + achievement.pointsEarned);
});

// Quick Action Providers for Common Tasbih Types
final quickTasbihProvider = Provider.autoDispose<Map<TasbihType, String>>((ref) {
  return {
    TasbihType.subhanallah: 'سُبْحَانَ اللهِ',
    TasbihType.alhamdulillah: 'اَلْحَمْدُ للهِ',
    TasbihType.allahuakbar: 'اَللهُ أَكْبَرُ',
    TasbihType.lailahaillallah: 'لَا إِلٰهَ إِلَّا اللهُ',
    TasbihType.astaghfirullah: 'أَسْتَغْفِرُ اللهَ',
  };
});

// Daily Progress Provider
final todayProgressProvider = Provider.autoDispose<int>((ref) {
  final statsAsync = ref.watch(tasbihStatsProvider);
  return statsAsync.when(
    data: (stats) {
      if (stats?.dailyProgress.isEmpty == true) return 0;
      final today = DateTime.now();
      final todayKey = DateTime(today.year, today.month, today.day);
      return stats?.dailyProgress[todayKey] ?? 0;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Voice Recognition Status Provider
final voiceRecognitionEnabledProvider = Provider.autoDispose<bool>((ref) {
  final settings = ref.watch(tasbihSettingsProvider);
  return settings?.voiceRecognition ?? false;
});

// Haptic Feedback Status Provider
final hapticFeedbackEnabledProvider = Provider.autoDispose<bool>((ref) {
  final settings = ref.watch(tasbihSettingsProvider);
  return settings?.hapticFeedback ?? true;
});

// Sound Feedback Status Provider
final soundFeedbackEnabledProvider = Provider.autoDispose<bool>((ref) {
  final settings = ref.watch(tasbihSettingsProvider);
  return settings?.soundFeedback ?? false;
});

// Family Sharing Provider
final familySharingEnabledProvider = Provider.autoDispose<bool>((ref) {
  final settings = ref.watch(tasbihSettingsProvider);
  return settings?.familySharing ?? false;
});

// Session Completion Status Provider
final isSessionCompletedProvider = Provider.autoDispose<bool>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return false;
  return session.currentCount >= session.targetCount;
});

// Quick Start Session Actions
class QuickSessionActions {
  static Future<void> startQuickTasbih(WidgetRef ref, TasbihType type, {int count = 33}) async {
    final sessionNotifier = ref.read(tasbihSessionProvider.notifier);
    await sessionNotifier.startSession(type: type, targetCount: count);
  }

  static Future<void> quickCount(WidgetRef ref) async {
    final sessionNotifier = ref.read(tasbihSessionProvider.notifier);
    await sessionNotifier.addCount();
  }

  static Future<void> endCurrentSession(WidgetRef ref) async {
    final sessionNotifier = ref.read(tasbihSessionProvider.notifier);
    await sessionNotifier.endSession();
  }
}
