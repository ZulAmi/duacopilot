// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalization_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnhancedRecommendationImpl _$$EnhancedRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$EnhancedRecommendationImpl(
      dua: DuaEntity.fromJson(json['dua'] as Map<String, dynamic>),
      personalizationScore: PersonalizationScore.fromJson(
          json['personalizationScore'] as Map<String, dynamic>),
      reasoning:
          (json['reasoning'] as List<dynamic>).map((e) => e as String).toList(),
      contextTags: (json['contextTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      isPersonalized: json['isPersonalized'] as bool? ?? false,
      enhancementReasons: (json['enhancementReasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$EnhancedRecommendationImplToJson(
        _$EnhancedRecommendationImpl instance) =>
    <String, dynamic>{
      'dua': instance.dua,
      'personalizationScore': instance.personalizationScore,
      'reasoning': instance.reasoning,
      'contextTags': instance.contextTags,
      'confidence': instance.confidence,
      'isPersonalized': instance.isPersonalized,
      'enhancementReasons': instance.enhancementReasons,
      'metadata': instance.metadata,
    };

_$PersonalizationScoreImpl _$$PersonalizationScoreImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalizationScoreImpl(
      usage: (json['usage'] as num).toDouble(),
      cultural: (json['cultural'] as num).toDouble(),
      temporal: (json['temporal'] as num).toDouble(),
      contextual: (json['contextual'] as num).toDouble(),
      overall: (json['overall'] as num).toDouble(),
      customScores: (json['customScores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$PersonalizationScoreImplToJson(
        _$PersonalizationScoreImpl instance) =>
    <String, dynamic>{
      'usage': instance.usage,
      'cultural': instance.cultural,
      'temporal': instance.temporal,
      'contextual': instance.contextual,
      'overall': instance.overall,
      'customScores': instance.customScores,
    };

_$UserSessionImpl _$$UserSessionImplFromJson(Map<String, dynamic> json) =>
    _$UserSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      context: json['context'] as Map<String, dynamic>,
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>,
      interactions: (json['interactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      duaViews: (json['duaViews'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      searchCount: (json['searchCount'] as num?)?.toInt() ?? 0,
      bookmarkCount: (json['bookmarkCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserSessionImplToJson(_$UserSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'context': instance.context,
      'deviceInfo': instance.deviceInfo,
      'interactions': instance.interactions,
      'duaViews': instance.duaViews,
      'searchCount': instance.searchCount,
      'bookmarkCount': instance.bookmarkCount,
    };

_$DuaInteractionImpl _$$DuaInteractionImplFromJson(Map<String, dynamic> json) =>
    _$DuaInteractionImpl(
      duaId: json['duaId'] as String,
      userId: json['userId'] as String,
      sessionId: json['sessionId'] as String,
      type: $enumDecode(_$InteractionTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      context: json['context'] as Map<String, dynamic>,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$DuaInteractionImplToJson(
        _$DuaInteractionImpl instance) =>
    <String, dynamic>{
      'duaId': instance.duaId,
      'userId': instance.userId,
      'sessionId': instance.sessionId,
      'type': _$InteractionTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'context': instance.context,
      'metadata': instance.metadata,
    };

const _$InteractionTypeEnumMap = {
  InteractionType.view: 'view',
  InteractionType.read: 'read',
  InteractionType.bookmark: 'bookmark',
  InteractionType.share: 'share',
  InteractionType.copy: 'copy',
  InteractionType.audio: 'audio',
  InteractionType.search: 'search',
  InteractionType.translation: 'translation',
};

_$PersonalizationUpdateImpl _$$PersonalizationUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalizationUpdateImpl(
      type: $enumDecode(_$UpdateTypeEnumMap, json['type']),
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PersonalizationUpdateImplToJson(
        _$PersonalizationUpdateImpl instance) =>
    <String, dynamic>{
      'type': _$UpdateTypeEnumMap[instance.type]!,
      'data': instance.data,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$UpdateTypeEnumMap = {
  UpdateType.interaction: 'interaction',
  UpdateType.culturalPreferences: 'culturalPreferences',
  UpdateType.usagePatterns: 'usagePatterns',
  UpdateType.temporalPatterns: 'temporalPatterns',
  UpdateType.sessionStart: 'sessionStart',
  UpdateType.sessionEnd: 'sessionEnd',
};

_$UsagePatternsImpl _$$UsagePatternsImplFromJson(Map<String, dynamic> json) =>
    _$UsagePatternsImpl(
      userId: json['userId'] as String,
      frequentDuas: (json['frequentDuas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recentDuas: (json['recentDuas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      categoryPreferences:
          Map<String, int>.from(json['categoryPreferences'] as Map),
      timeOfDayPatterns:
          (json['timeOfDayPatterns'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      dailyUsageStats: Map<String, int>.from(json['dailyUsageStats'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      totalInteractions: (json['totalInteractions'] as num?)?.toInt() ?? 0,
      averageReadingTimes:
          (json['averageReadingTimes'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
    );

Map<String, dynamic> _$$UsagePatternsImplToJson(_$UsagePatternsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'frequentDuas': instance.frequentDuas,
      'recentDuas': instance.recentDuas,
      'categoryPreferences': instance.categoryPreferences,
      'timeOfDayPatterns': instance.timeOfDayPatterns,
      'dailyUsageStats': instance.dailyUsageStats,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'totalInteractions': instance.totalInteractions,
      'averageReadingTimes': instance.averageReadingTimes,
    };

_$CulturalPreferencesImpl _$$CulturalPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$CulturalPreferencesImpl(
      userId: json['userId'] as String,
      preferredLanguages: (json['preferredLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      primaryLanguage: json['primaryLanguage'] as String,
      culturalTags: (json['culturalTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languagePreferences:
          (json['languagePreferences'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      customPreferences:
          json['customPreferences'] as Map<String, dynamic>? ?? const {},
      autoDetectLanguage: json['autoDetectLanguage'] as bool? ?? false,
      transliterationStyle:
          json['transliterationStyle'] as String? ?? 'balanced',
    );

Map<String, dynamic> _$$CulturalPreferencesImplToJson(
        _$CulturalPreferencesImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'preferredLanguages': instance.preferredLanguages,
      'primaryLanguage': instance.primaryLanguage,
      'culturalTags': instance.culturalTags,
      'languagePreferences': instance.languagePreferences,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'customPreferences': instance.customPreferences,
      'autoDetectLanguage': instance.autoDetectLanguage,
      'transliterationStyle': instance.transliterationStyle,
    };

_$CulturalPreferenceUpdateImpl _$$CulturalPreferenceUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$CulturalPreferenceUpdateImpl(
      userId: json['userId'] as String,
      preferredLanguages: (json['preferredLanguages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      primaryLanguage: json['primaryLanguage'] as String?,
      culturalTags: (json['culturalTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      languagePreferences:
          (json['languagePreferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      customPreferences: json['customPreferences'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$CulturalPreferenceUpdateImplToJson(
        _$CulturalPreferenceUpdateImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'preferredLanguages': instance.preferredLanguages,
      'primaryLanguage': instance.primaryLanguage,
      'culturalTags': instance.culturalTags,
      'languagePreferences': instance.languagePreferences,
      'customPreferences': instance.customPreferences,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$TemporalPatternsImpl _$$TemporalPatternsImplFromJson(
        Map<String, dynamic> json) =>
    _$TemporalPatternsImpl(
      userId: json['userId'] as String,
      hourlyPatterns: (json['hourlyPatterns'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), HourlyPattern.fromJson(e as Map<String, dynamic>)),
      ),
      dayOfWeekPatterns:
          (json['dayOfWeekPatterns'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, DayOfWeekPattern.fromJson(e as Map<String, dynamic>)),
      ),
      seasonalPatterns: (json['seasonalPatterns'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SeasonalPattern.fromJson(e as Map<String, dynamic>)),
      ),
      lastAnalyzed: DateTime.parse(json['lastAnalyzed'] as String),
      prayerTimePatterns:
          (json['prayerTimePatterns'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      habitStrengths: (json['habitStrengths'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$TemporalPatternsImplToJson(
        _$TemporalPatternsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'hourlyPatterns':
          instance.hourlyPatterns.map((k, e) => MapEntry(k.toString(), e)),
      'dayOfWeekPatterns': instance.dayOfWeekPatterns,
      'seasonalPatterns': instance.seasonalPatterns,
      'lastAnalyzed': instance.lastAnalyzed.toIso8601String(),
      'prayerTimePatterns': instance.prayerTimePatterns,
      'habitStrengths': instance.habitStrengths,
    };

_$HourlyPatternImpl _$$HourlyPatternImplFromJson(Map<String, dynamic> json) =>
    _$HourlyPatternImpl(
      hour: (json['hour'] as num).toInt(),
      popularDuas: (json['popularDuas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activityScore: (json['activityScore'] as num).toDouble(),
      categoryFrequency:
          Map<String, int>.from(json['categoryFrequency'] as Map),
      totalInteractions: (json['totalInteractions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HourlyPatternImplToJson(_$HourlyPatternImpl instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'popularDuas': instance.popularDuas,
      'activityScore': instance.activityScore,
      'categoryFrequency': instance.categoryFrequency,
      'totalInteractions': instance.totalInteractions,
    };

_$DayOfWeekPatternImpl _$$DayOfWeekPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$DayOfWeekPatternImpl(
      dayName: json['dayName'] as String,
      preferredDuas: (json['preferredDuas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      engagementScore: (json['engagementScore'] as num).toDouble(),
      timeDistribution: (json['timeDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DayOfWeekPatternImplToJson(
        _$DayOfWeekPatternImpl instance) =>
    <String, dynamic>{
      'dayName': instance.dayName,
      'preferredDuas': instance.preferredDuas,
      'engagementScore': instance.engagementScore,
      'timeDistribution': instance.timeDistribution,
      'totalSessions': instance.totalSessions,
    };

_$SeasonalPatternImpl _$$SeasonalPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$SeasonalPatternImpl(
      season: json['season'] as String,
      seasonalDuas: (json['seasonalDuas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      occasionFrequency:
          Map<String, int>.from(json['occasionFrequency'] as Map),
      specialOccasions: (json['specialOccasions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SeasonalPatternImplToJson(
        _$SeasonalPatternImpl instance) =>
    <String, dynamic>{
      'season': instance.season,
      'seasonalDuas': instance.seasonalDuas,
      'relevanceScore': instance.relevanceScore,
      'occasionFrequency': instance.occasionFrequency,
      'specialOccasions': instance.specialOccasions,
    };

_$PersonalizationContextImpl _$$PersonalizationContextImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalizationContextImpl(
      userId: json['userId'] as String,
      sessionId: json['sessionId'] as String,
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      usagePatterns:
          UsagePatterns.fromJson(json['usagePatterns'] as Map<String, dynamic>),
      culturalPreferences: CulturalPreferences.fromJson(
          json['culturalPreferences'] as Map<String, dynamic>),
      temporalPatterns: TemporalPatterns.fromJson(
          json['temporalPatterns'] as Map<String, dynamic>),
      islamicTimeContext: TimeContext.fromJson(
          json['islamicTimeContext'] as Map<String, dynamic>),
      locationContext: json['locationContext'] == null
          ? null
          : LocationContext.fromJson(
              json['locationContext'] as Map<String, dynamic>),
      sessionContext: json['sessionContext'] as Map<String, dynamic>,
      privacyLevel: $enumDecode(_$PrivacyLevelEnumMap, json['privacyLevel']),
      customContext: json['customContext'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$PersonalizationContextImplToJson(
        _$PersonalizationContextImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sessionId': instance.sessionId,
      'query': instance.query,
      'timestamp': instance.timestamp.toIso8601String(),
      'usagePatterns': instance.usagePatterns,
      'culturalPreferences': instance.culturalPreferences,
      'temporalPatterns': instance.temporalPatterns,
      'islamicTimeContext': instance.islamicTimeContext,
      'locationContext': instance.locationContext,
      'sessionContext': instance.sessionContext,
      'privacyLevel': _$PrivacyLevelEnumMap[instance.privacyLevel]!,
      'customContext': instance.customContext,
    };

const _$PrivacyLevelEnumMap = {
  PrivacyLevel.strict: 'strict',
  PrivacyLevel.balanced: 'balanced',
  PrivacyLevel.enhanced: 'enhanced',
};

_$LocationContextImpl _$$LocationContextImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationContextImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      city: json['city'] as String?,
      country: json['country'] as String?,
      isHome: json['isHome'] as bool? ?? false,
      isTraveling: json['isTraveling'] as bool? ?? false,
    );

Map<String, dynamic> _$$LocationContextImplToJson(
        _$LocationContextImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'timestamp': instance.timestamp.toIso8601String(),
      'city': instance.city,
      'country': instance.country,
      'isHome': instance.isHome,
      'isTraveling': instance.isTraveling,
    };

_$PersonalizationInputImpl _$$PersonalizationInputImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalizationInputImpl(
      query: json['query'] as String,
      candidateDuas: (json['candidateDuas'] as List<dynamic>)
          .map((e) => DuaEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      context: PersonalizationContext.fromJson(
          json['context'] as Map<String, dynamic>),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$PersonalizationInputImplToJson(
        _$PersonalizationInputImpl instance) =>
    <String, dynamic>{
      'query': instance.query,
      'candidateDuas': instance.candidateDuas,
      'context': instance.context,
      'userId': instance.userId,
    };

_$ContextualSuggestionInputImpl _$$ContextualSuggestionInputImplFromJson(
        Map<String, dynamic> json) =>
    _$ContextualSuggestionInputImpl(
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      islamicContext:
          TimeContext.fromJson(json['islamicContext'] as Map<String, dynamic>),
      timePatterns: TemporalPatterns.fromJson(
          json['timePatterns'] as Map<String, dynamic>),
      usagePatterns:
          UsagePatterns.fromJson(json['usagePatterns'] as Map<String, dynamic>),
      locationSuggestions: (json['locationSuggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$$ContextualSuggestionInputImplToJson(
        _$ContextualSuggestionInputImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'islamicContext': instance.islamicContext,
      'timePatterns': instance.timePatterns,
      'usagePatterns': instance.usagePatterns,
      'locationSuggestions': instance.locationSuggestions,
      'limit': instance.limit,
    };

_$AnalyticsDataPointImpl _$$AnalyticsDataPointImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsDataPointImpl(
      userId: json['userId'] as String,
      eventType: json['eventType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>,
      dimensions: (json['dimensions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      metrics: (json['metrics'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$AnalyticsDataPointImplToJson(
        _$AnalyticsDataPointImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'eventType': instance.eventType,
      'timestamp': instance.timestamp.toIso8601String(),
      'data': instance.data,
      'dimensions': instance.dimensions,
      'metrics': instance.metrics,
    };

_$HabitStrengthImpl _$$HabitStrengthImplFromJson(Map<String, dynamic> json) =>
    _$HabitStrengthImpl(
      duaId: json['duaId'] as String,
      strength: (json['strength'] as num).toDouble(),
      frequency: (json['frequency'] as num).toInt(),
      avgDuration: Duration(microseconds: (json['avgDuration'] as num).toInt()),
      lastPracticed: DateTime.parse(json['lastPracticed'] as String),
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      recentSessions: (json['recentSessions'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$HabitStrengthImplToJson(_$HabitStrengthImpl instance) =>
    <String, dynamic>{
      'duaId': instance.duaId,
      'strength': instance.strength,
      'frequency': instance.frequency,
      'avgDuration': instance.avgDuration.inMicroseconds,
      'lastPracticed': instance.lastPracticed.toIso8601String(),
      'streakDays': instance.streakDays,
      'recentSessions':
          instance.recentSessions.map((e) => e.toIso8601String()).toList(),
    };

_$RecommendationEnhancementImpl _$$RecommendationEnhancementImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationEnhancementImpl(
      type: json['type'] as String,
      description: json['description'] as String,
      confidenceBoost: (json['confidenceBoost'] as num).toDouble(),
      parameters: json['parameters'] as Map<String, dynamic>,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$RecommendationEnhancementImplToJson(
        _$RecommendationEnhancementImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'confidenceBoost': instance.confidenceBoost,
      'parameters': instance.parameters,
      'isActive': instance.isActive,
    };

_$PersonalizationSettingsImpl _$$PersonalizationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalizationSettingsImpl(
      isEnabled: json['isEnabled'] as bool,
      privacyLevel: $enumDecode(_$PrivacyLevelEnumMap, json['privacyLevel']),
      analyticsEnabled: json['analyticsEnabled'] as bool,
      locationEnabled: json['locationEnabled'] as bool,
      islamicCalendarEnabled: json['islamicCalendarEnabled'] as bool,
      featureFlags: (json['featureFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$$PersonalizationSettingsImplToJson(
        _$PersonalizationSettingsImpl instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'privacyLevel': _$PrivacyLevelEnumMap[instance.privacyLevel]!,
      'analyticsEnabled': instance.analyticsEnabled,
      'locationEnabled': instance.locationEnabled,
      'islamicCalendarEnabled': instance.islamicCalendarEnabled,
      'featureFlags': instance.featureFlags,
    };
