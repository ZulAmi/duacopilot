// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserContextImpl _$$UserContextImplFromJson(Map<String, dynamic> json) =>
    _$UserContextImpl(
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      location:
          LocationContext.fromJson(json['location'] as Map<String, dynamic>),
      time: TimeContext.fromJson(json['time'] as Map<String, dynamic>),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      habits: HabitStats.fromJson(json['habits'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserContextImplToJson(_$UserContextImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'location': instance.location,
      'time': instance.time,
      'preferences': instance.preferences,
      'habits': instance.habits,
      'metadata': instance.metadata,
    };

_$LocationContextImpl _$$LocationContextImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationContextImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      type: $enumDecodeNullable(_$LocationTypeEnumMap, json['type']),
      nearbyPlaces: (json['nearbyPlaces'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$LocationContextImplToJson(
        _$LocationContextImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'timestamp': instance.timestamp.toIso8601String(),
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'type': _$LocationTypeEnumMap[instance.type],
      'nearbyPlaces': instance.nearbyPlaces,
    };

const _$LocationTypeEnumMap = {
  LocationType.home: 'home',
  LocationType.work: 'work',
  LocationType.mosque: 'mosque',
  LocationType.travel: 'travel',
  LocationType.unknown: 'unknown',
};

_$TimeContextImpl _$$TimeContextImplFromJson(Map<String, dynamic> json) =>
    _$TimeContextImpl(
      currentTime: DateTime.parse(json['currentTime'] as String),
      timeOfDay: $enumDecode(_$TimeOfDayEnumMap, json['timeOfDay']),
      islamicDate:
          IslamicDate.fromJson(json['islamicDate'] as Map<String, dynamic>),
      prayerTimes:
          PrayerTimes.fromJson(json['prayerTimes'] as Map<String, dynamic>),
      specialOccasions: (json['specialOccasions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isRamadan: json['isRamadan'] as bool? ?? false,
      isHajjSeason: json['isHajjSeason'] as bool? ?? false,
    );

Map<String, dynamic> _$$TimeContextImplToJson(_$TimeContextImpl instance) =>
    <String, dynamic>{
      'currentTime': instance.currentTime.toIso8601String(),
      'timeOfDay': _$TimeOfDayEnumMap[instance.timeOfDay]!,
      'islamicDate': instance.islamicDate,
      'prayerTimes': instance.prayerTimes,
      'specialOccasions': instance.specialOccasions,
      'isRamadan': instance.isRamadan,
      'isHajjSeason': instance.isHajjSeason,
    };

const _$TimeOfDayEnumMap = {
  TimeOfDay.fajr: 'fajr',
  TimeOfDay.morning: 'morning',
  TimeOfDay.dhuhr: 'dhuhr',
  TimeOfDay.afternoon: 'afternoon',
  TimeOfDay.asr: 'asr',
  TimeOfDay.maghrib: 'maghrib',
  TimeOfDay.evening: 'evening',
  TimeOfDay.isha: 'isha',
  TimeOfDay.night: 'night',
};

_$IslamicDateImpl _$$IslamicDateImplFromJson(Map<String, dynamic> json) =>
    _$IslamicDateImpl(
      day: (json['day'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      monthName: json['monthName'] as String,
      isHolyMonth: json['isHolyMonth'] as bool,
      significantEvents: (json['significantEvents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$IslamicDateImplToJson(_$IslamicDateImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'month': instance.month,
      'year': instance.year,
      'monthName': instance.monthName,
      'isHolyMonth': instance.isHolyMonth,
      'significantEvents': instance.significantEvents,
    };

_$PrayerTimesImpl _$$PrayerTimesImplFromJson(Map<String, dynamic> json) =>
    _$PrayerTimesImpl(
      fajr: DateTime.parse(json['fajr'] as String),
      sunrise: DateTime.parse(json['sunrise'] as String),
      dhuhr: DateTime.parse(json['dhuhr'] as String),
      asr: DateTime.parse(json['asr'] as String),
      maghrib: DateTime.parse(json['maghrib'] as String),
      isha: DateTime.parse(json['isha'] as String),
      nextPrayer: json['nextPrayer'] == null
          ? null
          : NextPrayer.fromJson(json['nextPrayer'] as Map<String, dynamic>),
      timeToNext: json['timeToNext'] == null
          ? null
          : Duration(microseconds: (json['timeToNext'] as num).toInt()),
    );

Map<String, dynamic> _$$PrayerTimesImplToJson(_$PrayerTimesImpl instance) =>
    <String, dynamic>{
      'fajr': instance.fajr.toIso8601String(),
      'sunrise': instance.sunrise.toIso8601String(),
      'dhuhr': instance.dhuhr.toIso8601String(),
      'asr': instance.asr.toIso8601String(),
      'maghrib': instance.maghrib.toIso8601String(),
      'isha': instance.isha.toIso8601String(),
      'nextPrayer': instance.nextPrayer,
      'timeToNext': instance.timeToNext?.inMicroseconds,
    };

_$NextPrayerImpl _$$NextPrayerImplFromJson(Map<String, dynamic> json) =>
    _$NextPrayerImpl(
      type: $enumDecode(_$PrayerTypeEnumMap, json['type']),
      time: DateTime.parse(json['time'] as String),
      remaining: Duration(microseconds: (json['remaining'] as num).toInt()),
    );

Map<String, dynamic> _$$NextPrayerImplToJson(_$NextPrayerImpl instance) =>
    <String, dynamic>{
      'type': _$PrayerTypeEnumMap[instance.type]!,
      'time': instance.time.toIso8601String(),
      'remaining': instance.remaining.inMicroseconds,
    };

const _$PrayerTypeEnumMap = {
  PrayerType.fajr: 'fajr',
  PrayerType.dhuhr: 'dhuhr',
  PrayerType.asr: 'asr',
  PrayerType.maghrib: 'maghrib',
  PrayerType.isha: 'isha',
};

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      language: json['language'] as String,
      region: json['region'] as String,
      notifications: NotificationSettings.fromJson(
          json['notifications'] as Map<String, dynamic>),
      audio: AudioSettings.fromJson(json['audio'] as Map<String, dynamic>),
      locationEnabled: json['locationEnabled'] as bool? ?? true,
      smartSuggestions: json['smartSuggestions'] as bool? ?? true,
      favoriteCategories: (json['favoriteCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['general'],
      customSettings:
          json['customSettings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'region': instance.region,
      'notifications': instance.notifications,
      'audio': instance.audio,
      'locationEnabled': instance.locationEnabled,
      'smartSuggestions': instance.smartSuggestions,
      'favoriteCategories': instance.favoriteCategories,
      'customSettings': instance.customSettings,
    };

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      enabled: json['enabled'] as bool? ?? true,
      prayerReminders: json['prayerReminders'] as bool? ?? true,
      dailyDua: json['dailyDua'] as bool? ?? true,
      contextualSuggestions: json['contextualSuggestions'] as bool? ?? true,
      habitReminders: json['habitReminders'] as bool? ?? true,
      quietHours: (json['quietHours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      priority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['priority']) ??
          NotificationPriority.normal,
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'prayerReminders': instance.prayerReminders,
      'dailyDua': instance.dailyDua,
      'contextualSuggestions': instance.contextualSuggestions,
      'habitReminders': instance.habitReminders,
      'quietHours': instance.quietHours,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
    };

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};

_$AudioSettingsImpl _$$AudioSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AudioSettingsImpl(
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.8,
      autoPlay: json['autoPlay'] as bool? ?? true,
      preferredQuality: $enumDecodeNullable(
              _$AudioQualityEnumMap, json['preferredQuality']) ??
          AudioQuality.high,
      downloadOnWifi: json['downloadOnWifi'] as bool? ?? true,
    );

Map<String, dynamic> _$$AudioSettingsImplToJson(_$AudioSettingsImpl instance) =>
    <String, dynamic>{
      'playbackSpeed': instance.playbackSpeed,
      'volume': instance.volume,
      'autoPlay': instance.autoPlay,
      'preferredQuality': _$AudioQualityEnumMap[instance.preferredQuality]!,
      'downloadOnWifi': instance.downloadOnWifi,
    };

const _$AudioQualityEnumMap = {
  AudioQuality.low: 'low',
  AudioQuality.medium: 'medium',
  AudioQuality.high: 'high',
  AudioQuality.lossless: 'lossless',
};

_$HabitStatsImpl _$$HabitStatsImplFromJson(Map<String, dynamic> json) =>
    _$HabitStatsImpl(
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      totalDuas: (json['totalDuas'] as num).toInt(),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      categoryStats: Map<String, int>.from(json['categoryStats'] as Map),
      recentActivity: (json['recentActivity'] as List<dynamic>)
          .map((e) => DailyActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      weeklyGoal: (json['weeklyGoal'] as num?)?.toInt() ?? 0,
      monthlyGoal: (json['monthlyGoal'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HabitStatsImplToJson(_$HabitStatsImpl instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'totalDuas': instance.totalDuas,
      'lastActivity': instance.lastActivity.toIso8601String(),
      'categoryStats': instance.categoryStats,
      'recentActivity': instance.recentActivity,
      'weeklyGoal': instance.weeklyGoal,
      'monthlyGoal': instance.monthlyGoal,
    };

_$DailyActivityImpl _$$DailyActivityImplFromJson(Map<String, dynamic> json) =>
    _$DailyActivityImpl(
      date: DateTime.parse(json['date'] as String),
      duaCount: (json['duaCount'] as num).toInt(),
      totalTime: Duration(microseconds: (json['totalTime'] as num).toInt()),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      goalMet: json['goalMet'] as bool? ?? false,
    );

Map<String, dynamic> _$$DailyActivityImplToJson(_$DailyActivityImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'duaCount': instance.duaCount,
      'totalTime': instance.totalTime.inMicroseconds,
      'categories': instance.categories,
      'goalMet': instance.goalMet,
    };

_$SmartSuggestionImpl _$$SmartSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartSuggestionImpl(
      duaId: json['duaId'] as String,
      type: $enumDecode(_$SuggestionTypeEnumMap, json['type']),
      confidence: (json['confidence'] as num).toDouble(),
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      trigger: $enumDecode(_$SuggestionTriggerEnumMap, json['trigger']),
      context: json['context'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SmartSuggestionImplToJson(
        _$SmartSuggestionImpl instance) =>
    <String, dynamic>{
      'duaId': instance.duaId,
      'type': _$SuggestionTypeEnumMap[instance.type]!,
      'confidence': instance.confidence,
      'reason': instance.reason,
      'timestamp': instance.timestamp.toIso8601String(),
      'trigger': _$SuggestionTriggerEnumMap[instance.trigger]!,
      'context': instance.context,
    };

const _$SuggestionTypeEnumMap = {
  SuggestionType.timeBased: 'time_based',
  SuggestionType.locationBased: 'location_based',
  SuggestionType.habitBased: 'habit_based',
  SuggestionType.contextual: 'contextual',
  SuggestionType.trending: 'trending',
};

const _$SuggestionTriggerEnumMap = {
  SuggestionTrigger.prayerTime: 'prayer_time',
  SuggestionTrigger.locationChange: 'location_change',
  SuggestionTrigger.timePattern: 'time_pattern',
  SuggestionTrigger.habitReminder: 'habit_reminder',
  SuggestionTrigger.specialOccasion: 'special_occasion',
  SuggestionTrigger.manualRequest: 'manual_request',
};

_$NotificationScheduleImpl _$$NotificationScheduleImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationScheduleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      duaId: json['duaId'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      isRepeating: json['isRepeating'] as bool? ?? false,
      repeatInterval:
          $enumDecodeNullable(_$RepeatIntervalEnumMap, json['repeatInterval']),
    );

Map<String, dynamic> _$$NotificationScheduleImplToJson(
        _$NotificationScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'duaId': instance.duaId,
      'payload': instance.payload,
      'isRepeating': instance.isRepeating,
      'repeatInterval': _$RepeatIntervalEnumMap[instance.repeatInterval],
    };

const _$NotificationTypeEnumMap = {
  NotificationType.reminder: 'reminder',
  NotificationType.suggestion: 'suggestion',
  NotificationType.habit: 'habit',
  NotificationType.prayer: 'prayer',
  NotificationType.content: 'content',
};

const _$RepeatIntervalEnumMap = {
  RepeatInterval.daily: 'daily',
  RepeatInterval.weekly: 'weekly',
  RepeatInterval.monthly: 'monthly',
  RepeatInterval.custom: 'custom',
};
