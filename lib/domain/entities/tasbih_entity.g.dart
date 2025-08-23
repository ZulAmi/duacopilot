// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbih_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TasbihSessionImpl _$$TasbihSessionImplFromJson(Map<String, dynamic> json) =>
    _$TasbihSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime:
          json['endTime'] == null
              ? null
              : DateTime.parse(json['endTime'] as String),
      type: $enumDecode(_$TasbihTypeEnumMap, json['type']),
      targetCount: (json['targetCount'] as num).toInt(),
      currentCount: (json['currentCount'] as num).toInt(),
      entries:
          (json['entries'] as List<dynamic>)
              .map((e) => TasbihEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
      settings: TasbihSettings.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      goal:
          json['goal'] == null
              ? null
              : TasbihGoal.fromJson(json['goal'] as Map<String, dynamic>),
      totalDuration:
          json['totalDuration'] == null
              ? null
              : Duration(microseconds: (json['totalDuration'] as num).toInt()),
      isCompleted: json['isCompleted'] as bool?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TasbihSessionImplToJson(_$TasbihSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'type': _$TasbihTypeEnumMap[instance.type]!,
      'targetCount': instance.targetCount,
      'currentCount': instance.currentCount,
      'entries': instance.entries,
      'settings': instance.settings,
      'goal': instance.goal,
      'totalDuration': instance.totalDuration?.inMicroseconds,
      'isCompleted': instance.isCompleted,
      'metadata': instance.metadata,
    };

const _$TasbihTypeEnumMap = {
  TasbihType.subhanallah: 'subhanallah',
  TasbihType.alhamdulillah: 'alhamdulillah',
  TasbihType.allahuakbar: 'allahuakbar',
  TasbihType.lailahaillallah: 'lailahaillallah',
  TasbihType.astaghfirullah: 'astaghfirullah',
  TasbihType.custom: 'custom',
  TasbihType.mixed: 'mixed',
};

_$TasbihEntryImpl _$$TasbihEntryImplFromJson(Map<String, dynamic> json) =>
    _$TasbihEntryImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      count: (json['count'] as num).toInt(),
      inputMethod: $enumDecode(_$InputMethodEnumMap, json['inputMethod']),
      dhikrText: json['dhikrText'] as String?,
      timeSinceLastEntry:
          json['timeSinceLastEntry'] == null
              ? null
              : Duration(
                microseconds: (json['timeSinceLastEntry'] as num).toInt(),
              ),
      isAutoDetected: json['isAutoDetected'] as bool?,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TasbihEntryImplToJson(_$TasbihEntryImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'count': instance.count,
      'inputMethod': _$InputMethodEnumMap[instance.inputMethod]!,
      'dhikrText': instance.dhikrText,
      'timeSinceLastEntry': instance.timeSinceLastEntry?.inMicroseconds,
      'isAutoDetected': instance.isAutoDetected,
      'confidence': instance.confidence,
    };

const _$InputMethodEnumMap = {
  InputMethod.touch: 'touch',
  InputMethod.voice: 'voice',
  InputMethod.gesture: 'gesture',
  InputMethod.automatic: 'automatic',
  InputMethod.physical: 'physical',
};

_$TasbihSettingsImpl _$$TasbihSettingsImplFromJson(Map<String, dynamic> json) =>
    _$TasbihSettingsImpl(
      hapticFeedback: json['hapticFeedback'] as bool,
      soundFeedback: json['soundFeedback'] as bool,
      voiceRecognition: json['voiceRecognition'] as bool,
      sensitivity: (json['sensitivity'] as num).toDouble(),
      animation: $enumDecode(_$AnimationTypeEnumMap, json['animation']),
      theme: $enumDecode(_$ThemeStyleEnumMap, json['theme']),
      autoSave: json['autoSave'] as bool,
      familySharing: json['familySharing'] as bool,
      customSounds: json['customSounds'] as Map<String, dynamic>?,
      vibrationPattern: $enumDecodeNullable(
        _$VibrationPatternEnumMap,
        json['vibrationPattern'],
      ),
    );

Map<String, dynamic> _$$TasbihSettingsImplToJson(
  _$TasbihSettingsImpl instance,
) => <String, dynamic>{
  'hapticFeedback': instance.hapticFeedback,
  'soundFeedback': instance.soundFeedback,
  'voiceRecognition': instance.voiceRecognition,
  'sensitivity': instance.sensitivity,
  'animation': _$AnimationTypeEnumMap[instance.animation]!,
  'theme': _$ThemeStyleEnumMap[instance.theme]!,
  'autoSave': instance.autoSave,
  'familySharing': instance.familySharing,
  'customSounds': instance.customSounds,
  'vibrationPattern': _$VibrationPatternEnumMap[instance.vibrationPattern],
};

const _$AnimationTypeEnumMap = {
  AnimationType.ripple: 'ripple',
  AnimationType.pulse: 'pulse',
  AnimationType.rotate: 'rotate',
  AnimationType.scale: 'scale',
  AnimationType.none: 'none',
};

const _$ThemeStyleEnumMap = {
  ThemeStyle.classic: 'classic',
  ThemeStyle.modern: 'modern',
  ThemeStyle.minimal: 'minimal',
  ThemeStyle.elegant: 'elegant',
  ThemeStyle.custom: 'custom',
};

const _$VibrationPatternEnumMap = {
  VibrationPattern.light: 'light',
  VibrationPattern.medium: 'medium',
  VibrationPattern.strong: 'strong',
  VibrationPattern.double: 'double',
  VibrationPattern.none: 'none',
};

_$TasbihGoalImpl _$$TasbihGoalImplFromJson(Map<String, dynamic> json) =>
    _$TasbihGoalImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      targetCount: (json['targetCount'] as num).toInt(),
      timeFrame: Duration(microseconds: (json['timeFrame'] as num).toInt()),
      period: $enumDecode(_$GoalPeriodEnumMap, json['period']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate:
          json['endDate'] == null
              ? null
              : DateTime.parse(json['endDate'] as String),
      currentProgress: (json['currentProgress'] as num).toInt(),
      dhikrTypes:
          (json['dhikrTypes'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      dailyProgress: (json['dailyProgress'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(DateTime.parse(k), (e as num).toInt()),
      ),
      description: json['description'] as String?,
      reward: json['reward'] as String?,
      isActive: json['isActive'] as bool?,
      status: $enumDecodeNullable(_$GoalStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$TasbihGoalImplToJson(_$TasbihGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'targetCount': instance.targetCount,
      'timeFrame': instance.timeFrame.inMicroseconds,
      'period': _$GoalPeriodEnumMap[instance.period]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'currentProgress': instance.currentProgress,
      'dhikrTypes': instance.dhikrTypes,
      'dailyProgress': instance.dailyProgress.map(
        (k, e) => MapEntry(k.toIso8601String(), e),
      ),
      'description': instance.description,
      'reward': instance.reward,
      'isActive': instance.isActive,
      'status': _$GoalStatusEnumMap[instance.status],
    };

const _$GoalPeriodEnumMap = {
  GoalPeriod.daily: 'daily',
  GoalPeriod.weekly: 'weekly',
  GoalPeriod.monthly: 'monthly',
  GoalPeriod.custom: 'custom',
};

const _$GoalStatusEnumMap = {
  GoalStatus.active: 'active',
  GoalStatus.completed: 'completed',
  GoalStatus.paused: 'paused',
  GoalStatus.expired: 'expired',
};

_$TasbihStatsImpl _$$TasbihStatsImplFromJson(
  Map<String, dynamic> json,
) => _$TasbihStatsImpl(
  totalSessions: (json['totalSessions'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalTime: Duration(microseconds: (json['totalTime'] as num).toInt()),
  countsByType: (json['countsByType'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$TasbihTypeEnumMap, k), (e as num).toInt()),
  ),
  dailyProgress: (json['dailyProgress'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(DateTime.parse(k), (e as num).toInt()),
  ),
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  lastSession: DateTime.parse(json['lastSession'] as String),
  averageSessionDuration: (json['averageSessionDuration'] as num).toDouble(),
  achievements:
      (json['achievements'] as List<dynamic>)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
  personalBests: json['personalBests'] as Map<String, dynamic>?,
  familyStats:
      json['familyStats'] == null
          ? null
          : FamilyStats.fromJson(json['familyStats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TasbihStatsImplToJson(_$TasbihStatsImpl instance) =>
    <String, dynamic>{
      'totalSessions': instance.totalSessions,
      'totalCount': instance.totalCount,
      'totalTime': instance.totalTime.inMicroseconds,
      'countsByType': instance.countsByType.map(
        (k, e) => MapEntry(_$TasbihTypeEnumMap[k]!, e),
      ),
      'dailyProgress': instance.dailyProgress.map(
        (k, e) => MapEntry(k.toIso8601String(), e),
      ),
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastSession': instance.lastSession.toIso8601String(),
      'averageSessionDuration': instance.averageSessionDuration,
      'achievements': instance.achievements,
      'personalBests': instance.personalBests,
      'familyStats': instance.familyStats,
    };

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
      pointsEarned: (json['pointsEarned'] as num).toInt(),
      isRare: json['isRare'] as bool?,
      criteria: json['criteria'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconPath': instance.iconPath,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'pointsEarned': instance.pointsEarned,
      'isRare': instance.isRare,
      'criteria': instance.criteria,
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.milestone: 'milestone',
  AchievementCategory.consistency: 'consistency',
  AchievementCategory.speed: 'speed',
  AchievementCategory.dedication: 'dedication',
  AchievementCategory.family: 'family',
  AchievementCategory.special: 'special',
};

_$FamilyStatsImpl _$$FamilyStatsImplFromJson(Map<String, dynamic> json) =>
    _$FamilyStatsImpl(
      familyId: json['familyId'] as String,
      memberContributions: Map<String, int>.from(
        json['memberContributions'] as Map,
      ),
      totalFamilyCount: (json['totalFamilyCount'] as num).toInt(),
      members:
          (json['members'] as List<dynamic>)
              .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
              .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      currentGoal:
          json['currentGoal'] == null
              ? null
              : FamilyGoal.fromJson(
                json['currentGoal'] as Map<String, dynamic>,
              ),
      activeChallenges:
          (json['activeChallenges'] as List<dynamic>?)
              ?.map((e) => FamilyChallenge.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$FamilyStatsImplToJson(_$FamilyStatsImpl instance) =>
    <String, dynamic>{
      'familyId': instance.familyId,
      'memberContributions': instance.memberContributions,
      'totalFamilyCount': instance.totalFamilyCount,
      'members': instance.members,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'currentGoal': instance.currentGoal,
      'activeChallenges': instance.activeChallenges,
    };

_$FamilyMemberImpl _$$FamilyMemberImplFromJson(Map<String, dynamic> json) =>
    _$FamilyMemberImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      totalCount: (json['totalCount'] as num).toInt(),
      lastActive: DateTime.parse(json['lastActive'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      isOnline: json['isOnline'] as bool?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$FamilyMemberImplToJson(_$FamilyMemberImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'role': instance.role,
      'totalCount': instance.totalCount,
      'lastActive': instance.lastActive.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
      'isOnline': instance.isOnline,
      'preferences': instance.preferences,
    };

_$FamilyGoalImpl _$$FamilyGoalImplFromJson(Map<String, dynamic> json) =>
    _$FamilyGoalImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      targetCount: (json['targetCount'] as num).toInt(),
      deadline: DateTime.parse(json['deadline'] as String),
      currentProgress: (json['currentProgress'] as num).toInt(),
      memberContributions: Map<String, int>.from(
        json['memberContributions'] as Map,
      ),
      description: json['description'] as String?,
      reward: json['reward'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$FamilyGoalImplToJson(_$FamilyGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'targetCount': instance.targetCount,
      'deadline': instance.deadline.toIso8601String(),
      'currentProgress': instance.currentProgress,
      'memberContributions': instance.memberContributions,
      'description': instance.description,
      'reward': instance.reward,
      'isActive': instance.isActive,
    };

_$FamilyChallengeImpl _$$FamilyChallengeImplFromJson(
  Map<String, dynamic> json,
) => _$FamilyChallengeImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  type: $enumDecode(_$ChallengeTypeEnumMap, json['type']),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  scores: Map<String, int>.from(json['scores'] as Map),
  participants:
      (json['participants'] as List<dynamic>).map((e) => e as String).toList(),
  description: json['description'] as String?,
  rules: json['rules'] as Map<String, dynamic>?,
  prizes: (json['prizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$FamilyChallengeImplToJson(
  _$FamilyChallengeImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': _$ChallengeTypeEnumMap[instance.type]!,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'scores': instance.scores,
  'participants': instance.participants,
  'description': instance.description,
  'rules': instance.rules,
  'prizes': instance.prizes,
};

const _$ChallengeTypeEnumMap = {
  ChallengeType.speed: 'speed',
  ChallengeType.endurance: 'endurance',
  ChallengeType.consistency: 'consistency',
  ChallengeType.collaboration: 'collaboration',
};

_$VoiceRecognitionImpl _$$VoiceRecognitionImplFromJson(
  Map<String, dynamic> json,
) => _$VoiceRecognitionImpl(
  isEnabled: json['isEnabled'] as bool,
  recognizedPhrases:
      (json['recognizedPhrases'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  confidenceThreshold: (json['confidenceThreshold'] as num).toDouble(),
  language: json['language'] as String,
  phraseConfidence: (json['phraseConfidence'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  backgroundListening: json['backgroundListening'] as bool?,
  sessionTimeout:
      json['sessionTimeout'] == null
          ? null
          : Duration(microseconds: (json['sessionTimeout'] as num).toInt()),
  customPhrases:
      (json['customPhrases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$$VoiceRecognitionImplToJson(
  _$VoiceRecognitionImpl instance,
) => <String, dynamic>{
  'isEnabled': instance.isEnabled,
  'recognizedPhrases': instance.recognizedPhrases,
  'confidenceThreshold': instance.confidenceThreshold,
  'language': instance.language,
  'phraseConfidence': instance.phraseConfidence,
  'backgroundListening': instance.backgroundListening,
  'sessionTimeout': instance.sessionTimeout?.inMicroseconds,
  'customPhrases': instance.customPhrases,
};

_$SmartReminderImpl _$$SmartReminderImplFromJson(Map<String, dynamic> json) =>
    _$SmartReminderImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      isEnabled: json['isEnabled'] as bool,
      message: json['message'] as String,
      frequency:
          json['frequency'] == null
              ? null
              : Duration(microseconds: (json['frequency'] as num).toInt()),
      conditions:
          (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      personalizedData: json['personalizedData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SmartReminderImplToJson(_$SmartReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ReminderTypeEnumMap[instance.type]!,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'isEnabled': instance.isEnabled,
      'message': instance.message,
      'frequency': instance.frequency?.inMicroseconds,
      'conditions': instance.conditions,
      'personalizedData': instance.personalizedData,
    };

const _$ReminderTypeEnumMap = {
  ReminderType.session: 'session',
  ReminderType.goal: 'goal',
  ReminderType.streak: 'streak',
  ReminderType.family: 'family',
  ReminderType.achievement: 'achievement',
};
