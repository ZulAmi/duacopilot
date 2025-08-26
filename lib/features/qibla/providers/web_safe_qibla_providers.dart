import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/qibla_entity.dart';

/// Web-safe Qibla compass providers
final qiblaInitProvider = FutureProvider<bool>((ref) async {
  if (kIsWeb) {
    // Web platform - return mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Native platform initialization would go here
  return true;
});

final currentQiblaDirectionProvider = StateProvider<double>((ref) {
  if (kIsWeb) {
    // Mock Qibla direction for Mecca (rough estimate)
    return 45.0; // Placeholder direction
  }
  return 0.0;
});

final qiblaAccuracyProvider = StateProvider<LocationAccuracy>((ref) {
  return kIsWeb ? LocationAccuracy.high : LocationAccuracy.low;
});

final calibrationQualityProvider = StateProvider<CalibrationQuality>((ref) {
  return kIsWeb ? CalibrationQuality.good : CalibrationQuality.poor;
});

final nearbyMosquesProvider = StateProvider<List<MosqueLocation>>((ref) {
  if (kIsWeb) {
    // Mock mosque data for web
    return [
      MosqueLocation(
        id: 'mock_1',
        name: 'Central Mosque',
        latitude: 40.7128,
        longitude: -74.0060,
        distanceInMeters: 1200,
        qiblaDirection: 58.5,
        address: '123 Main St, City',
      ),
      MosqueLocation(
        id: 'mock_2',
        name: 'Community Islamic Center',
        latitude: 40.7200,
        longitude: -74.0100,
        distanceInMeters: 2100,
        qiblaDirection: 57.8,
        address: '456 Oak Ave, City',
      ),
    ];
  }
  return [];
});

final prayerTimesProvider = StateProvider<Map<PrayerType, DateTime>?>((ref) {
  if (kIsWeb) {
    // Mock prayer times for web
    final now = DateTime.now();
    return {
      PrayerType.fajr: DateTime(now.year, now.month, now.day, 5, 30),
      PrayerType.dhuhr: DateTime(now.year, now.month, now.day, 12, 15),
      PrayerType.asr: DateTime(now.year, now.month, now.day, 15, 30),
      PrayerType.maghrib: DateTime(now.year, now.month, now.day, 18, 45),
      PrayerType.isha: DateTime(now.year, now.month, now.day, 20, 0),
    };
  }
  return null;
});

final nextPrayerProvider = Provider<PrayerType?>((ref) {
  final prayerTimes = ref.watch(prayerTimesProvider);
  if (prayerTimes == null || !kIsWeb) return null;

  final now = DateTime.now();
  for (final entry in prayerTimes.entries) {
    if (entry.value.isAfter(now)) {
      return entry.key;
    }
  }
  return PrayerType.fajr; // Next day's first prayer
});

/// Web-safe Qibla compass state notifier
class WebSafeQiblaNotifier extends StateNotifier<QiblaCompass> {
  WebSafeQiblaNotifier()
    : super(
        QiblaCompass(
          qiblaDirection: kIsWeb ? 45.0 : 0.0,
          currentDirection: kIsWeb ? 42.0 : 0.0,
          deviceHeading: kIsWeb ? 43.0 : 0.0,
          accuracy: kIsWeb ? LocationAccuracy.high : LocationAccuracy.low,
          lastUpdated: DateTime.now(),
          isCalibrationNeeded: false,
          distanceToKaaba: kIsWeb ? 11000000.0 : null, // ~11,000 km to Mecca
        ),
      );

  void updateDirection(double direction) {
    if (kIsWeb) {
      // Simulate smooth direction updates on web
      state = state.copyWith(
        currentDirection: direction,
        deviceHeading: direction + 1.0,
        lastUpdated: DateTime.now(),
      );
    }
  }

  void startCompass() {
    if (kIsWeb) {
      // Mock compass updates for web demo
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          state = state.copyWith(
            currentDirection: 42.0 + (DateTime.now().millisecond % 10 - 5),
            deviceHeading: 43.0 + (DateTime.now().millisecond % 8 - 4),
            accuracy: LocationAccuracy.high,
            lastUpdated: DateTime.now(),
            isCalibrationNeeded: false,
          );
        }
      });
    }
  }

  void stopCompass() {
    // Stop compass updates
  }
}

final webSafeQiblaProvider =
    StateNotifierProvider<WebSafeQiblaNotifier, QiblaCompass>((ref) {
      return WebSafeQiblaNotifier();
    });
