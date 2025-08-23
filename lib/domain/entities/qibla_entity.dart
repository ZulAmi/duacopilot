import 'package:freezed_annotation/freezed_annotation.dart';

part 'qibla_entity.freezed.dart';
part 'qibla_entity.g.dart';

@freezed
/// QiblaCompass entity for prayer direction tracking
class QiblaCompass with _$QiblaCompass {
  const factory QiblaCompass({
    required double qiblaDirection,
    required double currentDirection,
    required double deviceHeading,
    required LocationAccuracy accuracy,
    required DateTime lastUpdated,
    required bool isCalibrationNeeded,
    String? nearestMosque,
    double? distanceToKaaba,
    QiblaCalibrationData? calibrationData,
  }) = _QiblaCompass;

  factory QiblaCompass.fromJson(Map<String, dynamic> json) => _$QiblaCompassFromJson(json);
}

@freezed
/// QiblaCalibrationData for compass accuracy
class QiblaCalibrationData with _$QiblaCalibrationData {
  const factory QiblaCalibrationData({
    required double magneticDeclination,
    required DateTime lastCalibration,
    required CalibrationQuality quality,
    required List<double> calibrationReadings,
    String? deviceModel,
    Map<String, dynamic>? sensorInfo,
  }) = _QiblaCalibrationData;

  factory QiblaCalibrationData.fromJson(Map<String, dynamic> json) => _$QiblaCalibrationDataFromJson(json);
}

@freezed
/// PrayerTracker entity for tracking prayer completions
class PrayerTracker with _$PrayerTracker {
  const factory PrayerTracker({
    required String id,
    required String userId,
    required DateTime date,
    required Map<PrayerType, PrayerCompletion> prayers,
    required PrayerStats dailyStats,
    List<PrayerReminder>? reminders,
    Map<String, dynamic>? metadata,
  }) = _PrayerTracker;

  factory PrayerTracker.fromJson(Map<String, dynamic> json) => _$PrayerTrackerFromJson(json);
}

@freezed
/// PrayerCompletion for individual prayer tracking
class PrayerCompletion with _$PrayerCompletion {
  const factory PrayerCompletion({
    required PrayerType type,
    required DateTime scheduledTime,
    DateTime? completedAt,
    PrayerCompletionStatus? status,
    String? location,
    bool? isInCongregation,
    Duration? duration,
    String? notes,
    double? qiblaAccuracy,
  }) = _PrayerCompletion;

  factory PrayerCompletion.fromJson(Map<String, dynamic> json) => _$PrayerCompletionFromJson(json);
}

@freezed
/// PrayerStats for daily prayer statistics
class PrayerStats with _$PrayerStats {
  const factory PrayerStats({
    required int totalPrayers,
    required int completedPrayers,
    required int missedPrayers,
    required double completionRate,
    required Duration totalPrayerTime,
    required Map<PrayerType, int> prayerCounts,
    String? bestStreak,
    DateTime? lastPrayerTime,
  }) = _PrayerStats;

  factory PrayerStats.fromJson(Map<String, dynamic> json) => _$PrayerStatsFromJson(json);
}

@freezed
/// PrayerReminder for scheduled prayer notifications
class PrayerReminder with _$PrayerReminder {
  const factory PrayerReminder({
    required String id,
    required PrayerType prayerType,
    required DateTime scheduledTime,
    required bool isEnabled,
    Duration? advanceNotification,
    String? customMessage,
    ReminderRepeat? repeatType,
    Map<String, dynamic>? soundSettings,
  }) = _PrayerReminder;

  factory PrayerReminder.fromJson(Map<String, dynamic> json) => _$PrayerReminderFromJson(json);
}

@freezed
/// MosqueLocation for nearby mosque tracking
class MosqueLocation with _$MosqueLocation {
  const factory MosqueLocation({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double distanceInMeters,
    required double qiblaDirection,
    String? address,
    String? phoneNumber,
    String? website,
    List<String>? amenities,
    Map<PrayerType, DateTime>? prayerTimes,
    MosqueRating? rating,
    List<String>? images,
  }) = _MosqueLocation;

  factory MosqueLocation.fromJson(Map<String, dynamic> json) => _$MosqueLocationFromJson(json);
}

@freezed
/// MosqueRating for community feedback
class MosqueRating with _$MosqueRating {
  const factory MosqueRating({
    required double averageRating,
    required int totalReviews,
    required Map<String, int> categoryRatings,
    List<MosqueReview>? recentReviews,
  }) = _MosqueRating;

  factory MosqueRating.fromJson(Map<String, dynamic> json) => _$MosqueRatingFromJson(json);
}

@freezed
/// MosqueReview for individual mosque reviews
class MosqueReview with _$MosqueReview {
  const factory MosqueReview({
    required String id,
    required String userId,
    required int rating,
    required DateTime reviewDate,
    String? comment,
    List<String>? categories,
    bool? isVerified,
  }) = _MosqueReview;

  factory MosqueReview.fromJson(Map<String, dynamic> json) => _$MosqueReviewFromJson(json);
}

// Enums
enum LocationAccuracy {
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low,
  @JsonValue('unavailable')
  unavailable,
}

enum CalibrationQuality {
  @JsonValue('excellent')
  excellent,
  @JsonValue('good')
  good,
  @JsonValue('fair')
  fair,
  @JsonValue('poor')
  poor,
  @JsonValue('uncalibrated')
  uncalibrated,
}

enum PrayerType {
  @JsonValue('fajr')
  fajr,
  @JsonValue('dhuhr')
  dhuhr,
  @JsonValue('asr')
  asr,
  @JsonValue('maghrib')
  maghrib,
  @JsonValue('isha')
  isha,
}

enum PrayerCompletionStatus {
  @JsonValue('completed')
  completed,
  @JsonValue('missed')
  missed,
  @JsonValue('makeup')
  makeup,
  @JsonValue('excused')
  excused,
}

enum ReminderRepeat {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('custom')
  custom,
  @JsonValue('none')
  none,
}
