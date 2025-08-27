import 'package:freezed_annotation/freezed_annotation.dart';

part 'context_entity.freezed.dart';
part 'context_entity.g.dart';

@freezed

/// UserContext class implementation
class UserContext with _$UserContext {
  const factory UserContext({
    required String userId,
    required DateTime timestamp,
    required LocationContext location,
    required TimeContext time,
    required UserPreferences preferences,
    required HabitStats habits,
    Map<String, dynamic>? metadata,
  }) = _UserContext;

  factory UserContext.fromJson(Map<String, dynamic> json) =>
      _$UserContextFromJson(json);
}

@freezed

/// LocationContext class implementation
class LocationContext with _$LocationContext {
  const factory LocationContext({
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp,
    String? address,
    String? city,
    String? country,
    LocationType? type,
    List<String>? nearbyPlaces,
  }) = _LocationContext;

  factory LocationContext.fromJson(Map<String, dynamic> json) =>
      _$LocationContextFromJson(json);
}

@freezed

/// TimeContext class implementation
class TimeContext with _$TimeContext {
  const factory TimeContext({
    required DateTime currentTime,
    required TimeOfDay timeOfDay,
    required IslamicDate islamicDate,
    required PrayerTimes prayerTimes,
    @Default([]) List<String> specialOccasions,
    @Default(false) bool isRamadan,
    @Default(false) bool isHajjSeason,
  }) = _TimeContext;

  factory TimeContext.fromJson(Map<String, dynamic> json) =>
      _$TimeContextFromJson(json);
}

@freezed

/// IslamicDate class implementation
class IslamicDate with _$IslamicDate {
  const factory IslamicDate({
    required int day,
    required int month,
    required int year,
    required String monthName,
    required bool isHolyMonth,
    List<String>? significantEvents,
  }) = _IslamicDate;

  factory IslamicDate.fromJson(Map<String, dynamic> json) =>
      _$IslamicDateFromJson(json);
}

@freezed

/// PrayerTimes class implementation
class PrayerTimes with _$PrayerTimes {
  const factory PrayerTimes({
    required DateTime fajr,
    required DateTime sunrise,
    required DateTime dhuhr,
    required DateTime asr,
    required DateTime maghrib,
    required DateTime isha,
    NextPrayer? nextPrayer,
    Duration? timeToNext,
  }) = _PrayerTimes;

  factory PrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesFromJson(json);
}

@freezed

/// NextPrayer class implementation
class NextPrayer with _$NextPrayer {
  const factory NextPrayer({
    required PrayerType type,
    required DateTime time,
    required Duration remaining,
  }) = _NextPrayer;

  factory NextPrayer.fromJson(Map<String, dynamic> json) =>
      _$NextPrayerFromJson(json);
}

@freezed

/// UserPreferences class implementation
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required String language,
    required String region,
    required NotificationSettings notifications,
    required AudioSettings audio,
    @Default(true) bool locationEnabled,
    @Default(true) bool smartSuggestions,
    @Default(['general']) List<String> favoriteCategories,
    @Default({}) Map<String, dynamic> customSettings,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

@freezed

/// NotificationSettings class implementation
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool enabled,
    @Default(true) bool prayerReminders,
    @Default(true) bool dailyDua,
    @Default(true) bool contextualSuggestions,
    @Default(true) bool habitReminders,
    @Default([]) List<String> quietHours,
    @Default(NotificationPriority.normal) NotificationPriority priority,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

@freezed

/// AudioSettings class implementation
class AudioSettings with _$AudioSettings {
  const factory AudioSettings({
    @Default(1.0) double playbackSpeed,
    @Default(0.8) double volume,
    @Default(true) bool autoPlay,
    @Default(AudioQuality.high) AudioQuality preferredQuality,
    @Default(true) bool downloadOnWifi,
  }) = _AudioSettings;

  factory AudioSettings.fromJson(Map<String, dynamic> json) =>
      _$AudioSettingsFromJson(json);
}

@freezed

/// HabitStats class implementation
class HabitStats with _$HabitStats {
  const factory HabitStats({
    required int currentStreak,
    required int longestStreak,
    required int totalDuas,
    required DateTime lastActivity,
    required Map<String, int> categoryStats,
    required List<DailyActivity> recentActivity,
    @Default(0) int weeklyGoal,
    @Default(0) int monthlyGoal,
  }) = _HabitStats;

  factory HabitStats.fromJson(Map<String, dynamic> json) =>
      _$HabitStatsFromJson(json);
}

@freezed

/// DailyActivity class implementation
class DailyActivity with _$DailyActivity {
  const factory DailyActivity({
    required DateTime date,
    required int duaCount,
    required Duration totalTime,
    required List<String> categories,
    @Default(false) bool goalMet,
  }) = _DailyActivity;

  factory DailyActivity.fromJson(Map<String, dynamic> json) =>
      _$DailyActivityFromJson(json);
}

@freezed

/// SmartSuggestion class implementation
class SmartSuggestion with _$SmartSuggestion {
  const factory SmartSuggestion({
    required String duaId,
    required SuggestionType type,
    required double confidence,
    required String reason,
    required DateTime timestamp,
    required SuggestionTrigger trigger,
    Map<String, dynamic>? context,
  }) = _SmartSuggestion;

  factory SmartSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SmartSuggestionFromJson(json);
}

@freezed

/// NotificationSchedule class implementation
class NotificationSchedule with _$NotificationSchedule {
  const factory NotificationSchedule({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required NotificationType type,
    String? duaId,
    Map<String, dynamic>? payload,
    @Default(false) bool isRepeating,
    RepeatInterval? repeatInterval,
  }) = _NotificationSchedule;

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleFromJson(json);
}

// Enums
enum LocationType {
  @JsonValue('home')
  home,
  @JsonValue('work')
  work,
  @JsonValue('mosque')
  mosque,
  @JsonValue('travel')
  travel,
  @JsonValue('unknown')
  unknown,
}

enum TimeOfDay {
  @JsonValue('fajr')
  fajr,
  @JsonValue('morning')
  morning,
  @JsonValue('dhuhr')
  dhuhr,
  @JsonValue('afternoon')
  afternoon,
  @JsonValue('asr')
  asr,
  @JsonValue('maghrib')
  maghrib,
  @JsonValue('evening')
  evening,
  @JsonValue('isha')
  isha,
  @JsonValue('night')
  night,
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

enum SuggestionType {
  @JsonValue('time_based')
  timeBased,
  @JsonValue('location_based')
  locationBased,
  @JsonValue('habit_based')
  habitBased,
  @JsonValue('contextual')
  contextual,
  @JsonValue('trending')
  trending,
}

enum SuggestionTrigger {
  @JsonValue('prayer_time')
  prayerTime,
  @JsonValue('location_change')
  locationChange,
  @JsonValue('time_pattern')
  timePattern,
  @JsonValue('habit_reminder')
  habitReminder,
  @JsonValue('special_occasion')
  specialOccasion,
  @JsonValue('manual_request')
  manualRequest,
}

enum NotificationType {
  @JsonValue('reminder')
  reminder,
  @JsonValue('suggestion')
  suggestion,
  @JsonValue('habit')
  habit,
  @JsonValue('prayer')
  prayer,
  @JsonValue('content')
  content,
}

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

enum RepeatInterval {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('custom')
  custom,
}

enum AudioQuality {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('lossless')
  lossless,
}
