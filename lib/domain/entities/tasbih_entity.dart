import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasbih_entity.freezed.dart';
part 'tasbih_entity.g.dart';

@freezed
/// TasbihSession entity for digital tasbih tracking
class TasbihSession with _$TasbihSession {
  const factory TasbihSession({
    required String id,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    required TasbihType type,
    required int targetCount,
    required int currentCount,
    required List<TasbihEntry> entries,
    required TasbihSettings settings,
    TasbihGoal? goal,
    Duration? totalDuration,
    bool? isCompleted,
    Map<String, dynamic>? metadata,
  }) = _TasbihSession;

  factory TasbihSession.fromJson(Map<String, dynamic> json) => _$TasbihSessionFromJson(json);
}

@freezed
/// TasbihEntry for individual count tracking
class TasbihEntry with _$TasbihEntry {
  const factory TasbihEntry({
    required DateTime timestamp,
    required int count,
    required InputMethod inputMethod,
    String? dhikrText,
    Duration? timeSinceLastEntry,
    bool? isAutoDetected,
    double? confidence,
  }) = _TasbihEntry;

  factory TasbihEntry.fromJson(Map<String, dynamic> json) => _$TasbihEntryFromJson(json);
}

@freezed
/// TasbihSettings for session configuration
class TasbihSettings with _$TasbihSettings {
  const factory TasbihSettings({
    required bool hapticFeedback,
    required bool soundFeedback,
    required bool voiceRecognition,
    required double sensitivity,
    required AnimationType animation,
    required ThemeStyle theme,
    required bool autoSave,
    required bool familySharing,
    Map<String, dynamic>? customSounds,
    VibrationPattern? vibrationPattern,
  }) = _TasbihSettings;

  factory TasbihSettings.fromJson(Map<String, dynamic> json) => _$TasbihSettingsFromJson(json);
}

@freezed
/// TasbihGoal for smart goal tracking
class TasbihGoal with _$TasbihGoal {
  const factory TasbihGoal({
    required String id,
    required String title,
    required int targetCount,
    required Duration timeFrame,
    required GoalPeriod period,
    required DateTime startDate,
    DateTime? endDate,
    required int currentProgress,
    required List<String> dhikrTypes,
    required Map<DateTime, int> dailyProgress,
    String? description,
    String? reward,
    bool? isActive,
    GoalStatus? status,
  }) = _TasbihGoal;

  factory TasbihGoal.fromJson(Map<String, dynamic> json) => _$TasbihGoalFromJson(json);
}

@freezed
/// TasbihStats for comprehensive statistics
class TasbihStats with _$TasbihStats {
  const factory TasbihStats({
    required int totalSessions,
    required int totalCount,
    required Duration totalTime,
    required Map<TasbihType, int> countsByType,
    required Map<DateTime, int> dailyProgress,
    required int currentStreak,
    required int longestStreak,
    required DateTime lastSession,
    required double averageSessionDuration,
    required List<Achievement> achievements,
    Map<String, dynamic>? personalBests,
    FamilyStats? familyStats,
  }) = _TasbihStats;

  factory TasbihStats.fromJson(Map<String, dynamic> json) => _$TasbihStatsFromJson(json);
}

@freezed
/// Achievement for gamification
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String title,
    required String description,
    required String iconPath,
    required DateTime unlockedAt,
    required AchievementCategory category,
    required int pointsEarned,
    bool? isRare,
    Map<String, dynamic>? criteria,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
}

@freezed
/// FamilyStats for family sharing feature
class FamilyStats with _$FamilyStats {
  const factory FamilyStats({
    required String familyId,
    required Map<String, int> memberContributions,
    required int totalFamilyCount,
    required List<FamilyMember> members,
    required DateTime lastUpdated,
    FamilyGoal? currentGoal,
    List<FamilyChallenge>? activeChallenges,
  }) = _FamilyStats;

  factory FamilyStats.fromJson(Map<String, dynamic> json) => _$FamilyStatsFromJson(json);
}

@freezed
/// FamilyMember for family tracking
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String userId,
    required String displayName,
    required String role,
    required int totalCount,
    required DateTime lastActive,
    String? avatarUrl,
    bool? isOnline,
    Map<String, dynamic>? preferences,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => _$FamilyMemberFromJson(json);
}

@freezed
/// FamilyGoal for collaborative goals
class FamilyGoal with _$FamilyGoal {
  const factory FamilyGoal({
    required String id,
    required String title,
    required int targetCount,
    required DateTime deadline,
    required int currentProgress,
    required Map<String, int> memberContributions,
    String? description,
    String? reward,
    bool? isActive,
  }) = _FamilyGoal;

  factory FamilyGoal.fromJson(Map<String, dynamic> json) => _$FamilyGoalFromJson(json);
}

@freezed
/// FamilyChallenge for competitive elements
class FamilyChallenge with _$FamilyChallenge {
  const factory FamilyChallenge({
    required String id,
    required String title,
    required ChallengeType type,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, int> scores,
    required List<String> participants,
    String? description,
    Map<String, dynamic>? rules,
    List<String>? prizes,
  }) = _FamilyChallenge;

  factory FamilyChallenge.fromJson(Map<String, dynamic> json) => _$FamilyChallengeFromJson(json);
}

@freezed
/// VoiceRecognition for smart voice detection
class VoiceRecognition with _$VoiceRecognition {
  const factory VoiceRecognition({
    required bool isEnabled,
    required List<String> recognizedPhrases,
    required double confidenceThreshold,
    required String language,
    required Map<String, double> phraseConfidence,
    bool? backgroundListening,
    Duration? sessionTimeout,
    List<String>? customPhrases,
  }) = _VoiceRecognition;

  factory VoiceRecognition.fromJson(Map<String, dynamic> json) => _$VoiceRecognitionFromJson(json);
}

@freezed
/// SmartReminder for intelligent notifications
class SmartReminder with _$SmartReminder {
  const factory SmartReminder({
    required String id,
    required ReminderType type,
    required DateTime scheduledTime,
    required bool isEnabled,
    required String message,
    Duration? frequency,
    List<String>? conditions,
    Map<String, dynamic>? personalizedData,
  }) = _SmartReminder;

  factory SmartReminder.fromJson(Map<String, dynamic> json) => _$SmartReminderFromJson(json);
}

// Enums for Tasbih System
enum TasbihType {
  @JsonValue('subhanallah')
  subhanallah,
  @JsonValue('alhamdulillah')
  alhamdulillah,
  @JsonValue('allahuakbar')
  allahuakbar,
  @JsonValue('lailahaillallah')
  lailahaillallah,
  @JsonValue('astaghfirullah')
  astaghfirullah,
  @JsonValue('custom')
  custom,
  @JsonValue('mixed')
  mixed,
}

enum InputMethod {
  @JsonValue('touch')
  touch,
  @JsonValue('voice')
  voice,
  @JsonValue('gesture')
  gesture,
  @JsonValue('automatic')
  automatic,
  @JsonValue('physical')
  physical,
}

enum AnimationType {
  @JsonValue('ripple')
  ripple,
  @JsonValue('pulse')
  pulse,
  @JsonValue('rotate')
  rotate,
  @JsonValue('scale')
  scale,
  @JsonValue('none')
  none,
}

enum ThemeStyle {
  @JsonValue('classic')
  classic,
  @JsonValue('modern')
  modern,
  @JsonValue('minimal')
  minimal,
  @JsonValue('elegant')
  elegant,
  @JsonValue('custom')
  custom,
}

enum VibrationPattern {
  @JsonValue('light')
  light,
  @JsonValue('medium')
  medium,
  @JsonValue('strong')
  strong,
  @JsonValue('double')
  double,
  @JsonValue('none')
  none,
}

enum GoalPeriod {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('custom')
  custom,
}

enum GoalStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('paused')
  paused,
  @JsonValue('expired')
  expired,
}

enum AchievementCategory {
  @JsonValue('milestone')
  milestone,
  @JsonValue('consistency')
  consistency,
  @JsonValue('speed')
  speed,
  @JsonValue('dedication')
  dedication,
  @JsonValue('family')
  family,
  @JsonValue('special')
  special,
}

enum ChallengeType {
  @JsonValue('speed')
  speed,
  @JsonValue('endurance')
  endurance,
  @JsonValue('consistency')
  consistency,
  @JsonValue('collaboration')
  collaboration,
}

enum ReminderType {
  @JsonValue('session')
  session,
  @JsonValue('goal')
  goal,
  @JsonValue('streak')
  streak,
  @JsonValue('family')
  family,
  @JsonValue('achievement')
  achievement,
}
