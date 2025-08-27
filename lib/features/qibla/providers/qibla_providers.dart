import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage_service.dart';
import '../../../domain/entities/qibla_entity.dart';
import '../services/prayer_tracker_service.dart';
import '../services/qibla_compass_service.dart';

// Service Providers
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final notificationsProvider = Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final qiblaCompassServiceProvider = Provider<QiblaCompassService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return QiblaCompassService(secureStorage);
});

final prayerTrackerServiceProvider = Provider<PrayerTrackerService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final notifications = ref.watch(notificationsProvider);
  return PrayerTrackerService(secureStorage, notifications);
});

// Qibla Compass State Providers
final qiblaCompassProvider = StreamProvider.autoDispose<QiblaCompass?>((ref) {
  final service = ref.watch(qiblaCompassServiceProvider);
  return service.compassStream;
});

final qiblaCompassInitProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(qiblaCompassServiceProvider);
  return await service.initialize();
});

final nearbyMosquesProvider = FutureProvider.autoDispose<List<MosqueLocation>>((
  ref,
) async {
  final service = ref.watch(qiblaCompassServiceProvider);
  return await service.findNearbyMosques();
});

// Prayer Tracker State Providers
final prayerTrackerProvider = StreamProvider.autoDispose<PrayerTracker?>((ref) {
  final service = ref.watch(prayerTrackerServiceProvider);
  return service.trackerStream;
});

final prayerTrackerInitProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(prayerTrackerServiceProvider);
  return await service.initialize();
});

final todayPrayersProvider =
    StreamProvider.autoDispose<Map<PrayerType, PrayerCompletion>?>((ref) {
  final service = ref.watch(prayerTrackerServiceProvider);
  return service.prayersStream;
});

// Compass Calibration Provider
class CompassCalibrationNotifier extends StateNotifier<AsyncValue<bool>> {
  final QiblaCompassService _service;

  CompassCalibrationNotifier(this._service)
      : super(const AsyncValue.data(true));

  Future<void> calibrateCompass() async {
    state = const AsyncValue.loading();
    try {
      final success = await _service.calibrateCompass();
      state = AsyncValue.data(success);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final compassCalibrationProvider = StateNotifierProvider.autoDispose<
    CompassCalibrationNotifier, AsyncValue<bool>>((ref) {
  final service = ref.watch(qiblaCompassServiceProvider);
  return CompassCalibrationNotifier(service);
});

// Prayer Completion Actions Provider
class PrayerActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final PrayerTrackerService _service;

  PrayerActionsNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> markPrayerCompleted({
    required PrayerType prayerType,
    DateTime? completedAt,
    String? location,
    bool isInCongregation = false,
    Duration? duration,
    String? notes,
    double? qiblaAccuracy,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.markPrayerCompleted(
        prayerType: prayerType,
        completedAt: completedAt,
        location: location,
        isInCongregation: isInCongregation,
        duration: duration,
        notes: notes,
        qiblaAccuracy: qiblaAccuracy,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markPrayerMissed({
    required PrayerType prayerType,
    String? reason,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.markPrayerMissed(prayerType: prayerType, reason: reason);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> scheduleMakeupPrayer({
    required PrayerType prayerType,
    required DateTime makeupTime,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.scheduleMakeupPrayer(
        prayerType: prayerType,
        makeupTime: makeupTime,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final prayerActionsProvider =
    StateNotifierProvider.autoDispose<PrayerActionsNotifier, AsyncValue<void>>((
  ref,
) {
  final service = ref.watch(prayerTrackerServiceProvider);
  return PrayerActionsNotifier(service);
});

// Prayer Statistics Provider
final prayerStatsProvider = Provider.autoDispose<PrayerStats?>((ref) {
  final trackerAsync = ref.watch(prayerTrackerProvider);
  return trackerAsync.when(
    data: (tracker) => tracker?.dailyStats,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Prayer Completion Rate Provider
final todayCompletionRateProvider = Provider.autoDispose<double>((ref) {
  final stats = ref.watch(prayerStatsProvider);
  return stats?.completionRate ?? 0.0;
});

// Next Prayer Provider
final nextPrayerProvider = Provider.autoDispose<PrayerCompletion?>((ref) {
  final prayersAsync = ref.watch(todayPrayersProvider);
  final prayers = prayersAsync.when(
    data: (prayers) => prayers,
    loading: () => null,
    error: (_, __) => null,
  );

  if (prayers == null) return null;

  final now = DateTime.now();
  final upcomingPrayers = prayers.values
      .where(
        (prayer) =>
            prayer.status != PrayerCompletionStatus.completed &&
            prayer.scheduledTime.isAfter(now),
      )
      .toList()
    ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

  return upcomingPrayers.isNotEmpty ? upcomingPrayers.first : null;
});

// Current Prayer Provider (for prayer time)
final currentPrayerProvider = Provider.autoDispose<PrayerCompletion?>((ref) {
  final prayersAsync = ref.watch(todayPrayersProvider);
  final prayers = prayersAsync.when(
    data: (prayers) => prayers,
    loading: () => null,
    error: (_, __) => null,
  );

  if (prayers == null) return null;

  final now = DateTime.now();

  // Find current prayer time slot
  final prayerList = prayers.values.toList()
    ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

  for (int i = 0; i < prayerList.length; i++) {
    final prayer = prayerList[i];
    final nextPrayer = i < prayerList.length - 1 ? prayerList[i + 1] : null;

    if (now.isAfter(prayer.scheduledTime) &&
        (nextPrayer == null || now.isBefore(nextPrayer.scheduledTime))) {
      return prayer;
    }
  }

  return null;
});

// Qibla Direction Provider (simplified access)
final qiblaDirectionProvider = Provider.autoDispose<double?>((ref) {
  final compassAsync = ref.watch(qiblaCompassProvider);
  return compassAsync.when(
    data: (compass) => compass?.qiblaDirection,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Device Heading Provider
final deviceHeadingProvider = Provider.autoDispose<double?>((ref) {
  final compassAsync = ref.watch(qiblaCompassProvider);
  return compassAsync.when(
    data: (compass) => compass?.deviceHeading,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Compass Accuracy Provider
final compassAccuracyProvider = Provider.autoDispose<LocationAccuracy?>((ref) {
  final compassAsync = ref.watch(qiblaCompassProvider);
  return compassAsync.when(
    data: (compass) => compass?.accuracy,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Calibration Status Provider
final needsCalibrationProvider = Provider.autoDispose<bool>((ref) {
  final compassAsync = ref.watch(qiblaCompassProvider);
  return compassAsync.when(
    data: (compass) => compass?.isCalibrationNeeded ?? true,
    loading: () => true,
    error: (_, __) => true,
  );
});

// Distance to Kaaba Provider
final distanceToKaabaProvider = Provider.autoDispose<double?>((ref) {
  final compassAsync = ref.watch(qiblaCompassProvider);
  return compassAsync.when(
    data: (compass) => compass?.distanceToKaaba,
    loading: () => null,
    error: (_, __) => null,
  );
});
