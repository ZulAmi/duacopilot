// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qibla_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QiblaCompassImpl _$$QiblaCompassImplFromJson(Map<String, dynamic> json) =>
    _$QiblaCompassImpl(
      qiblaDirection: (json['qiblaDirection'] as num).toDouble(),
      currentDirection: (json['currentDirection'] as num).toDouble(),
      deviceHeading: (json['deviceHeading'] as num).toDouble(),
      accuracy: $enumDecode(_$LocationAccuracyEnumMap, json['accuracy']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isCalibrationNeeded: json['isCalibrationNeeded'] as bool,
      nearestMosque: json['nearestMosque'] as String?,
      distanceToKaaba: (json['distanceToKaaba'] as num?)?.toDouble(),
      calibrationData:
          json['calibrationData'] == null
              ? null
              : QiblaCalibrationData.fromJson(
                json['calibrationData'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$QiblaCompassImplToJson(_$QiblaCompassImpl instance) =>
    <String, dynamic>{
      'qiblaDirection': instance.qiblaDirection,
      'currentDirection': instance.currentDirection,
      'deviceHeading': instance.deviceHeading,
      'accuracy': _$LocationAccuracyEnumMap[instance.accuracy]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isCalibrationNeeded': instance.isCalibrationNeeded,
      'nearestMosque': instance.nearestMosque,
      'distanceToKaaba': instance.distanceToKaaba,
      'calibrationData': instance.calibrationData,
    };

const _$LocationAccuracyEnumMap = {
  LocationAccuracy.high: 'high',
  LocationAccuracy.medium: 'medium',
  LocationAccuracy.low: 'low',
  LocationAccuracy.unavailable: 'unavailable',
};

_$QiblaCalibrationDataImpl _$$QiblaCalibrationDataImplFromJson(
  Map<String, dynamic> json,
) => _$QiblaCalibrationDataImpl(
  magneticDeclination: (json['magneticDeclination'] as num).toDouble(),
  lastCalibration: DateTime.parse(json['lastCalibration'] as String),
  quality: $enumDecode(_$CalibrationQualityEnumMap, json['quality']),
  calibrationReadings:
      (json['calibrationReadings'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
  deviceModel: json['deviceModel'] as String?,
  sensorInfo: json['sensorInfo'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$QiblaCalibrationDataImplToJson(
  _$QiblaCalibrationDataImpl instance,
) => <String, dynamic>{
  'magneticDeclination': instance.magneticDeclination,
  'lastCalibration': instance.lastCalibration.toIso8601String(),
  'quality': _$CalibrationQualityEnumMap[instance.quality]!,
  'calibrationReadings': instance.calibrationReadings,
  'deviceModel': instance.deviceModel,
  'sensorInfo': instance.sensorInfo,
};

const _$CalibrationQualityEnumMap = {
  CalibrationQuality.excellent: 'excellent',
  CalibrationQuality.good: 'good',
  CalibrationQuality.fair: 'fair',
  CalibrationQuality.poor: 'poor',
  CalibrationQuality.uncalibrated: 'uncalibrated',
};

_$PrayerTrackerImpl _$$PrayerTrackerImplFromJson(Map<String, dynamic> json) =>
    _$PrayerTrackerImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      prayers: (json['prayers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$PrayerTypeEnumMap, k),
          PrayerCompletion.fromJson(e as Map<String, dynamic>),
        ),
      ),
      dailyStats: PrayerStats.fromJson(
        json['dailyStats'] as Map<String, dynamic>,
      ),
      reminders:
          (json['reminders'] as List<dynamic>?)
              ?.map((e) => PrayerReminder.fromJson(e as Map<String, dynamic>))
              .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PrayerTrackerImplToJson(_$PrayerTrackerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'prayers': instance.prayers.map(
        (k, e) => MapEntry(_$PrayerTypeEnumMap[k]!, e),
      ),
      'dailyStats': instance.dailyStats,
      'reminders': instance.reminders,
      'metadata': instance.metadata,
    };

const _$PrayerTypeEnumMap = {
  PrayerType.fajr: 'fajr',
  PrayerType.dhuhr: 'dhuhr',
  PrayerType.asr: 'asr',
  PrayerType.maghrib: 'maghrib',
  PrayerType.isha: 'isha',
};

_$PrayerCompletionImpl _$$PrayerCompletionImplFromJson(
  Map<String, dynamic> json,
) => _$PrayerCompletionImpl(
  type: $enumDecode(_$PrayerTypeEnumMap, json['type']),
  scheduledTime: DateTime.parse(json['scheduledTime'] as String),
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
  status: $enumDecodeNullable(_$PrayerCompletionStatusEnumMap, json['status']),
  location: json['location'] as String?,
  isInCongregation: json['isInCongregation'] as bool?,
  duration:
      json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
  notes: json['notes'] as String?,
  qiblaAccuracy: (json['qiblaAccuracy'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$PrayerCompletionImplToJson(
  _$PrayerCompletionImpl instance,
) => <String, dynamic>{
  'type': _$PrayerTypeEnumMap[instance.type]!,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'status': _$PrayerCompletionStatusEnumMap[instance.status],
  'location': instance.location,
  'isInCongregation': instance.isInCongregation,
  'duration': instance.duration?.inMicroseconds,
  'notes': instance.notes,
  'qiblaAccuracy': instance.qiblaAccuracy,
};

const _$PrayerCompletionStatusEnumMap = {
  PrayerCompletionStatus.completed: 'completed',
  PrayerCompletionStatus.missed: 'missed',
  PrayerCompletionStatus.makeup: 'makeup',
  PrayerCompletionStatus.excused: 'excused',
};

_$PrayerStatsImpl _$$PrayerStatsImplFromJson(Map<String, dynamic> json) =>
    _$PrayerStatsImpl(
      totalPrayers: (json['totalPrayers'] as num).toInt(),
      completedPrayers: (json['completedPrayers'] as num).toInt(),
      missedPrayers: (json['missedPrayers'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      totalPrayerTime: Duration(
        microseconds: (json['totalPrayerTime'] as num).toInt(),
      ),
      prayerCounts: (json['prayerCounts'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$PrayerTypeEnumMap, k), (e as num).toInt()),
      ),
      bestStreak: json['bestStreak'] as String?,
      lastPrayerTime:
          json['lastPrayerTime'] == null
              ? null
              : DateTime.parse(json['lastPrayerTime'] as String),
    );

Map<String, dynamic> _$$PrayerStatsImplToJson(_$PrayerStatsImpl instance) =>
    <String, dynamic>{
      'totalPrayers': instance.totalPrayers,
      'completedPrayers': instance.completedPrayers,
      'missedPrayers': instance.missedPrayers,
      'completionRate': instance.completionRate,
      'totalPrayerTime': instance.totalPrayerTime.inMicroseconds,
      'prayerCounts': instance.prayerCounts.map(
        (k, e) => MapEntry(_$PrayerTypeEnumMap[k]!, e),
      ),
      'bestStreak': instance.bestStreak,
      'lastPrayerTime': instance.lastPrayerTime?.toIso8601String(),
    };

_$PrayerReminderImpl _$$PrayerReminderImplFromJson(Map<String, dynamic> json) =>
    _$PrayerReminderImpl(
      id: json['id'] as String,
      prayerType: $enumDecode(_$PrayerTypeEnumMap, json['prayerType']),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      isEnabled: json['isEnabled'] as bool,
      advanceNotification:
          json['advanceNotification'] == null
              ? null
              : Duration(
                microseconds: (json['advanceNotification'] as num).toInt(),
              ),
      customMessage: json['customMessage'] as String?,
      repeatType: $enumDecodeNullable(
        _$ReminderRepeatEnumMap,
        json['repeatType'],
      ),
      soundSettings: json['soundSettings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PrayerReminderImplToJson(
  _$PrayerReminderImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'prayerType': _$PrayerTypeEnumMap[instance.prayerType]!,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'isEnabled': instance.isEnabled,
  'advanceNotification': instance.advanceNotification?.inMicroseconds,
  'customMessage': instance.customMessage,
  'repeatType': _$ReminderRepeatEnumMap[instance.repeatType],
  'soundSettings': instance.soundSettings,
};

const _$ReminderRepeatEnumMap = {
  ReminderRepeat.daily: 'daily',
  ReminderRepeat.weekly: 'weekly',
  ReminderRepeat.custom: 'custom',
  ReminderRepeat.none: 'none',
};

_$MosqueLocationImpl _$$MosqueLocationImplFromJson(
  Map<String, dynamic> json,
) => _$MosqueLocationImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  distanceInMeters: (json['distanceInMeters'] as num).toDouble(),
  qiblaDirection: (json['qiblaDirection'] as num).toDouble(),
  address: json['address'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  website: json['website'] as String?,
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList(),
  prayerTimes: (json['prayerTimes'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      $enumDecode(_$PrayerTypeEnumMap, k),
      DateTime.parse(e as String),
    ),
  ),
  rating:
      json['rating'] == null
          ? null
          : MosqueRating.fromJson(json['rating'] as Map<String, dynamic>),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$MosqueLocationImplToJson(
  _$MosqueLocationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'distanceInMeters': instance.distanceInMeters,
  'qiblaDirection': instance.qiblaDirection,
  'address': instance.address,
  'phoneNumber': instance.phoneNumber,
  'website': instance.website,
  'amenities': instance.amenities,
  'prayerTimes': instance.prayerTimes?.map(
    (k, e) => MapEntry(_$PrayerTypeEnumMap[k]!, e.toIso8601String()),
  ),
  'rating': instance.rating,
  'images': instance.images,
};

_$MosqueRatingImpl _$$MosqueRatingImplFromJson(Map<String, dynamic> json) =>
    _$MosqueRatingImpl(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      categoryRatings: Map<String, int>.from(json['categoryRatings'] as Map),
      recentReviews:
          (json['recentReviews'] as List<dynamic>?)
              ?.map((e) => MosqueReview.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$MosqueRatingImplToJson(_$MosqueRatingImpl instance) =>
    <String, dynamic>{
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'categoryRatings': instance.categoryRatings,
      'recentReviews': instance.recentReviews,
    };

_$MosqueReviewImpl _$$MosqueReviewImplFromJson(Map<String, dynamic> json) =>
    _$MosqueReviewImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      rating: (json['rating'] as num).toInt(),
      reviewDate: DateTime.parse(json['reviewDate'] as String),
      comment: json['comment'] as String?,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$$MosqueReviewImplToJson(_$MosqueReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'rating': instance.rating,
      'reviewDate': instance.reviewDate.toIso8601String(),
      'comment': instance.comment,
      'categories': instance.categories,
      'isVerified': instance.isVerified,
    };
