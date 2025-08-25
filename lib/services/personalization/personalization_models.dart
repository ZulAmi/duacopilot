import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/context_entity.dart';
import '../../domain/entities/dua_entity.dart';

part 'personalization_models.freezed.dart';
part 'personalization_models.g.dart';

/// Enhanced recommendation with personalization scoring
@freezed
class EnhancedRecommendation with _$EnhancedRecommendation {
  const factory EnhancedRecommendation({
    required DuaEntity dua,
    required PersonalizationScore personalizationScore,
    required List<String> reasoning,
    required List<String> contextTags,
    required double confidence,
    @Default(false) bool isPersonalized,
    @Default([]) List<String> enhancementReasons,
    Map<String, dynamic>? metadata,
  }) = _EnhancedRecommendation;

  factory EnhancedRecommendation.fromJson(Map<String, dynamic> json) => _$EnhancedRecommendationFromJson(json);

  /// Create enhanced recommendation from basic Du'a entity
  factory EnhancedRecommendation.fromDua(DuaEntity dua) => EnhancedRecommendation(
    dua: dua,
    personalizationScore: PersonalizationScore.neutral(),
    reasoning: [],
    contextTags: [],
    confidence: 0.5,
  );
}

/// Personalization scoring system
@freezed
class PersonalizationScore with _$PersonalizationScore {
  const factory PersonalizationScore({
    required double usage,
    required double cultural,
    required double temporal,
    required double contextual,
    required double overall,
    @Default({}) Map<String, double> customScores,
  }) = _PersonalizationScore;

  factory PersonalizationScore.fromJson(Map<String, dynamic> json) => _$PersonalizationScoreFromJson(json);

  /// Create neutral personalization score
  factory PersonalizationScore.neutral() =>
      const PersonalizationScore(usage: 0.5, cultural: 0.5, temporal: 0.5, contextual: 0.5, overall: 0.5);
}

/// User session information
@freezed
class UserSession with _$UserSession {
  const factory UserSession({
    required String id,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    required Map<String, dynamic> context,
    required Map<String, dynamic> deviceInfo,
    @Default([]) List<String> interactions,
    @Default({}) Map<String, int> duaViews,
    @Default(0) int searchCount,
    @Default(0) int bookmarkCount,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);
}

/// Du'a interaction tracking
@freezed
class DuaInteraction with _$DuaInteraction {
  const factory DuaInteraction({
    required String duaId,
    required String userId,
    required String sessionId,
    required InteractionType type,
    required DateTime timestamp,
    required Duration duration,
    required Map<String, dynamic> context,
    @Default({}) Map<String, dynamic> metadata,
  }) = _DuaInteraction;

  factory DuaInteraction.fromJson(Map<String, dynamic> json) => _$DuaInteractionFromJson(json);
}

/// Types of user interactions
enum InteractionType { view, read, bookmark, share, copy, audio, search, translation }

/// Personalization update notifications
@freezed
class PersonalizationUpdate with _$PersonalizationUpdate {
  const factory PersonalizationUpdate({
    required UpdateType type,
    required dynamic data,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = _PersonalizationUpdate;

  factory PersonalizationUpdate.fromJson(Map<String, dynamic> json) => _$PersonalizationUpdateFromJson(json);
}

/// Types of personalization updates
enum UpdateType { interaction, culturalPreferences, usagePatterns, temporalPatterns, sessionStart, sessionEnd }

/// Usage patterns for a user
@freezed
class UsagePatterns with _$UsagePatterns {
  const factory UsagePatterns({
    required String userId,
    required List<String> frequentDuas,
    required List<String> recentDuas,
    required Map<String, int> categoryPreferences,
    required Map<String, double> timeOfDayPatterns,
    required Map<String, int> dailyUsageStats,
    required DateTime lastUpdated,
    @Default(0) int totalInteractions,
    @Default({}) Map<String, double> averageReadingTimes,
  }) = _UsagePatterns;

  factory UsagePatterns.fromJson(Map<String, dynamic> json) => _$UsagePatternsFromJson(json);

  /// Create empty usage patterns
  factory UsagePatterns.empty(String userId) => UsagePatterns(
    userId: userId,
    frequentDuas: [],
    recentDuas: [],
    categoryPreferences: {},
    timeOfDayPatterns: {},
    dailyUsageStats: {},
    lastUpdated: DateTime.now(),
  );
}

/// Cultural preferences for personalization
@freezed
class CulturalPreferences with _$CulturalPreferences {
  const factory CulturalPreferences({
    required String userId,
    required List<String> preferredLanguages,
    required String primaryLanguage,
    required List<String> culturalTags,
    required Map<String, double> languagePreferences,
    required DateTime lastUpdated,
    @Default({}) Map<String, dynamic> customPreferences,
    @Default(false) bool autoDetectLanguage,
    @Default('balanced') String transliterationStyle,
  }) = _CulturalPreferences;

  factory CulturalPreferences.fromJson(Map<String, dynamic> json) => _$CulturalPreferencesFromJson(json);

  /// Create default cultural preferences
  factory CulturalPreferences.defaultFor(String userId) => CulturalPreferences(
    userId: userId,
    preferredLanguages: ['en'],
    primaryLanguage: 'en',
    culturalTags: [],
    languagePreferences: {'en': 1.0},
    lastUpdated: DateTime.now(),
  );
}

/// Cultural preference update request
@freezed
class CulturalPreferenceUpdate with _$CulturalPreferenceUpdate {
  const factory CulturalPreferenceUpdate({
    required String userId,
    List<String>? preferredLanguages,
    String? primaryLanguage,
    List<String>? culturalTags,
    Map<String, double>? languagePreferences,
    Map<String, dynamic>? customPreferences,
    required DateTime timestamp,
  }) = _CulturalPreferenceUpdate;

  factory CulturalPreferenceUpdate.fromJson(Map<String, dynamic> json) => _$CulturalPreferenceUpdateFromJson(json);
}

/// Temporal patterns for time-based recommendations
@freezed
class TemporalPatterns with _$TemporalPatterns {
  const factory TemporalPatterns({
    required String userId,
    required Map<int, HourlyPattern> hourlyPatterns,
    required Map<String, DayOfWeekPattern> dayOfWeekPatterns,
    required Map<String, SeasonalPattern> seasonalPatterns,
    required DateTime lastAnalyzed,
    @Default({}) Map<String, int> prayerTimePatterns,
    @Default({}) Map<String, double> habitStrengths,
  }) = _TemporalPatterns;

  factory TemporalPatterns.fromJson(Map<String, dynamic> json) => _$TemporalPatternsFromJson(json);

  /// Create empty temporal patterns
  factory TemporalPatterns.empty(String userId) => TemporalPatterns(
    userId: userId,
    hourlyPatterns: {},
    dayOfWeekPatterns: {},
    seasonalPatterns: {},
    lastAnalyzed: DateTime.now(),
  );
}

/// Hourly usage patterns
@freezed
class HourlyPattern with _$HourlyPattern {
  const factory HourlyPattern({
    required int hour,
    required List<String> popularDuas,
    required double activityScore,
    required Map<String, int> categoryFrequency,
    @Default(0) int totalInteractions,
  }) = _HourlyPattern;

  factory HourlyPattern.fromJson(Map<String, dynamic> json) => _$HourlyPatternFromJson(json);
}

/// Day of week patterns
@freezed
class DayOfWeekPattern with _$DayOfWeekPattern {
  const factory DayOfWeekPattern({
    required String dayName,
    required List<String> preferredDuas,
    required double engagementScore,
    required Map<String, double> timeDistribution,
    @Default(0) int totalSessions,
  }) = _DayOfWeekPattern;

  factory DayOfWeekPattern.fromJson(Map<String, dynamic> json) => _$DayOfWeekPatternFromJson(json);
}

/// Seasonal patterns based on Islamic calendar
@freezed
class SeasonalPattern with _$SeasonalPattern {
  const factory SeasonalPattern({
    required String season,
    required List<String> seasonalDuas,
    required double relevanceScore,
    required Map<String, int> occasionFrequency,
    @Default([]) List<String> specialOccasions,
  }) = _SeasonalPattern;

  factory SeasonalPattern.fromJson(Map<String, dynamic> json) => _$SeasonalPatternFromJson(json);
}

/// Comprehensive personalization context
@freezed
class PersonalizationContext with _$PersonalizationContext {
  const factory PersonalizationContext({
    required String userId,
    required String sessionId,
    required String query,
    required DateTime timestamp,
    required UsagePatterns usagePatterns,
    required CulturalPreferences culturalPreferences,
    required TemporalPatterns temporalPatterns,
    required TimeContext islamicTimeContext,
    LocationContext? locationContext,
    required Map<String, dynamic> sessionContext,
    required PrivacyLevel privacyLevel,
    @Default({}) Map<String, dynamic> customContext,
  }) = _PersonalizationContext;

  factory PersonalizationContext.fromJson(Map<String, dynamic> json) => _$PersonalizationContextFromJson(json);
}

/// Location context for geospatial recommendations
@freezed
class LocationContext with _$LocationContext {
  const factory LocationContext({
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp,
    String? city,
    String? country,
    @Default(false) bool isHome,
    @Default(false) bool isTraveling,
  }) = _LocationContext;

  factory LocationContext.fromJson(Map<String, dynamic> json) => _$LocationContextFromJson(json);
}

/// Privacy level settings
enum PrivacyLevel {
  strict, // Minimal data collection, local processing only
  balanced, // Standard privacy with some analytics
  enhanced, // Full personalization with comprehensive analytics
}

/// Input for recommendation processing isolate
@freezed
class PersonalizationInput with _$PersonalizationInput {
  const factory PersonalizationInput({
    required String query,
    required List<DuaEntity> candidateDuas,
    required PersonalizationContext context,
    required String userId,
  }) = _PersonalizationInput;

  factory PersonalizationInput.fromJson(Map<String, dynamic> json) => _$PersonalizationInputFromJson(json);
}

/// Input for contextual suggestions isolate
@freezed
class ContextualSuggestionInput with _$ContextualSuggestionInput {
  const factory ContextualSuggestionInput({
    required String userId,
    required DateTime timestamp,
    required TimeContext islamicContext,
    required TemporalPatterns timePatterns,
    required UsagePatterns usagePatterns,
    required List<String> locationSuggestions,
    required int limit,
  }) = _ContextualSuggestionInput;

  factory ContextualSuggestionInput.fromJson(Map<String, dynamic> json) => _$ContextualSuggestionInputFromJson(json);
}

/// Analytics data point for pattern learning
@freezed
class AnalyticsDataPoint with _$AnalyticsDataPoint {
  const factory AnalyticsDataPoint({
    required String userId,
    required String eventType,
    required DateTime timestamp,
    required Map<String, dynamic> data,
    @Default({}) Map<String, String> dimensions,
    @Default({}) Map<String, double> metrics,
  }) = _AnalyticsDataPoint;

  factory AnalyticsDataPoint.fromJson(Map<String, dynamic> json) => _$AnalyticsDataPointFromJson(json);
}

/// Habit strength calculation
@freezed
class HabitStrength with _$HabitStrength {
  const factory HabitStrength({
    required String duaId,
    required double strength,
    required int frequency,
    required Duration avgDuration,
    required DateTime lastPracticed,
    @Default(0) int streakDays,
    @Default([]) List<DateTime> recentSessions,
  }) = _HabitStrength;

  factory HabitStrength.fromJson(Map<String, dynamic> json) => _$HabitStrengthFromJson(json);
}

/// Smart recommendation enhancement
@freezed
class RecommendationEnhancement with _$RecommendationEnhancement {
  const factory RecommendationEnhancement({
    required String type,
    required String description,
    required double confidenceBoost,
    required Map<String, dynamic> parameters,
    @Default(false) bool isActive,
  }) = _RecommendationEnhancement;

  factory RecommendationEnhancement.fromJson(Map<String, dynamic> json) => _$RecommendationEnhancementFromJson(json);
}

/// Personalization state for Riverpod state management
@freezed
class PersonalizationState with _$PersonalizationState {
  const factory PersonalizationState.initial() = PersonalizationInitial;

  const factory PersonalizationState.loading() = PersonalizationLoading;

  const factory PersonalizationState.loaded({
    required UsagePatterns usagePatterns,
    required CulturalPreferences culturalPreferences,
    @Default(true) bool isPersonalizationActive,
    @Default([]) List<EnhancedRecommendation> recommendations,
    @Default([]) List<EnhancedRecommendation> contextualSuggestions,
    TemporalPatterns? temporalPatterns,
    Map<String, dynamic>? metadata,
  }) = PersonalizationLoaded;

  const factory PersonalizationState.error(Object error, StackTrace stackTrace) = PersonalizationError;
}

/// Personalization settings model
@freezed
class PersonalizationSettings with _$PersonalizationSettings {
  const factory PersonalizationSettings({
    required bool isEnabled,
    required PrivacyLevel privacyLevel,
    required bool analyticsEnabled,
    required bool locationEnabled,
    required bool islamicCalendarEnabled,
    @Default({}) Map<String, bool> featureFlags,
  }) = _PersonalizationSettings;

  factory PersonalizationSettings.defaults() => const PersonalizationSettings(
    isEnabled: true,
    privacyLevel: PrivacyLevel.balanced,
    analyticsEnabled: true,
    locationEnabled: false,
    islamicCalendarEnabled: true,
  );

  factory PersonalizationSettings.fromJson(Map<String, dynamic> json) => _$PersonalizationSettingsFromJson(json);
}
