import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_dua_entity.freezed.dart';
part 'smart_dua_entity.g.dart';

/// Emotional state categories for AI analysis
enum EmotionalState {
  @JsonValue('anxious')
  anxious,
  @JsonValue('stressed')
  stressed,
  @JsonValue('hopeful')
  hopeful,
  @JsonValue('grateful')
  grateful,
  @JsonValue('worried')
  worried,
  @JsonValue('excited')
  excited,
  @JsonValue('sad')
  sad,
  @JsonValue('peaceful')
  peaceful,
  @JsonValue('fearful')
  fearful,
  @JsonValue('confident')
  confident,
  @JsonValue('uncertain')
  uncertain,
  @JsonValue('overwhelmed')
  overwhelmed,
  @JsonValue('seeking_guidance')
  seekingGuidance,
}

/// Context categories for situational awareness
enum DuaContext {
  @JsonValue('travel')
  travel,
  @JsonValue('health')
  health,
  @JsonValue('work_career')
  workCareer,
  @JsonValue('family')
  family,
  @JsonValue('education')
  education,
  @JsonValue('financial')
  financial,
  @JsonValue('spiritual')
  spiritual,
  @JsonValue('relationships')
  relationships,
  @JsonValue('protection')
  protection,
  @JsonValue('guidance')
  guidance,
  @JsonValue('gratitude')
  gratitude,
  @JsonValue('forgiveness')
  forgiveness,
}

/// AI confidence levels for recommendations
enum AIConfidenceLevel {
  @JsonValue('very_high')
  veryHigh,
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low,
}

/// Smart Dua Collection with AI-powered contextual intelligence
@freezed
class SmartDuaCollection with _$SmartDuaCollection {
  const factory SmartDuaCollection({
    required String id,
    required String userId,
    required String name,
    required String description,
    required List<String> duaIds,
    required EmotionalState primaryEmotion,
    required List<EmotionalState> secondaryEmotions,
    required DuaContext context,
    required List<String> triggers,
    required List<String> keywords,
    required AIConfidenceLevel confidenceLevel,
    required double relevanceScore,
    required Map<String, dynamic> aiMetadata,
    required int usageCount,
    required double effectivenessScore,
    required DateTime createdAt,
    required DateTime lastUsedAt,
    DateTime? updatedAt,
    @Default(true) bool isActive,
    @Default(true) bool isPersonalized,
  }) = _SmartDuaCollection;

  factory SmartDuaCollection.fromJson(Map<String, dynamic> json) =>
      _$SmartDuaCollectionFromJson(json);
}

/// User emotional pattern analysis
@freezed
class EmotionalPattern with _$EmotionalPattern {
  const factory EmotionalPattern({
    required String userId,
    required EmotionalState dominantEmotion,
    required Map<EmotionalState, double> emotionFrequency,
    required Map<DuaContext, int> contextPreferences,
    required List<String> frequentTriggers,
    required Map<String, double> timePatterns,
    required double stressLevel,
    required double spiritualEngagement,
    required DateTime analyzedAt,
    required DateTime dataStartDate,
    required DateTime dataEndDate,
    @Default(0) int totalInteractions,
    @Default(0.0) double predictionAccuracy,
  }) = _EmotionalPattern;

  factory EmotionalPattern.fromJson(Map<String, dynamic> json) =>
      _$EmotionalPatternFromJson(json);
}

/// AI-powered dua recommendation
@freezed
class SmartDuaRecommendation with _$SmartDuaRecommendation {
  const factory SmartDuaRecommendation({
    required String id,
    required String duaId,
    required String userId,
    required String title,
    required String arabicTitle,
    required String reason,
    required EmotionalState targetEmotion,
    required DuaContext context,
    required List<String> matchedKeywords,
    required double relevanceScore,
    required AIConfidenceLevel confidence,
    required Map<String, dynamic> aiReasoningData,
    required DateTime generatedAt,
    DateTime? dismissedAt,
    DateTime? acceptedAt,
    @Default(true) bool isPersonalized,
    @Default(false) bool wasAccurate,
    String? userFeedback,
  }) = _SmartDuaRecommendation;

  factory SmartDuaRecommendation.fromJson(Map<String, dynamic> json) =>
      _$SmartDuaRecommendationFromJson(json);
}

/// User input for contextual analysis
@freezed
class ContextualInput with _$ContextualInput {
  const factory ContextualInput({
    required String id,
    required String userId,
    required String rawInput,
    required List<String> processedKeywords,
    required EmotionalState detectedEmotion,
    required DuaContext detectedContext,
    required double emotionConfidence,
    required double contextConfidence,
    required Map<String, dynamic> nlpAnalysis,
    required DateTime timestamp,
    @Default(true) bool isEncrypted,
    String? encryptionKey,
  }) = _ContextualInput;

  factory ContextualInput.fromJson(Map<String, dynamic> json) =>
      _$ContextualInputFromJson(json);
}

/// AI learning feedback for model improvement
@freezed
class AIFeedback with _$AIFeedback {
  const factory AIFeedback({
    required String id,
    required String userId,
    required String recommendationId,
    required bool wasHelpful,
    required int rating,
    required String feedbackType,
    String? textFeedback,
    Map<String, dynamic>? additionalData,
    DateTime? providedAt,
  }) = _AIFeedback;

  factory AIFeedback.fromJson(Map<String, dynamic> json) =>
      _$AIFeedbackFromJson(json);
}

/// Contextual dua analytics for privacy-compliant tracking
@freezed
class ContextualAnalytics with _$ContextualAnalytics {
  const factory ContextualAnalytics({
    required String userId,
    required Map<EmotionalState, int> emotionSuccessRate,
    required Map<DuaContext, double> contextEffectiveness,
    required int totalRecommendations,
    required int acceptedRecommendations,
    required int dismissedRecommendations,
    required double overallSatisfaction,
    required Map<String, dynamic> improvementAreas,
    required DateTime lastUpdated,
  }) = _ContextualAnalytics;

  factory ContextualAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ContextualAnalyticsFromJson(json);
}

/// Extension methods for emotional state analysis
extension EmotionalStateExtensions on EmotionalState {
  String get displayName {
    switch (this) {
      case EmotionalState.anxious:
        return 'Feeling Anxious';
      case EmotionalState.stressed:
        return 'Under Stress';
      case EmotionalState.hopeful:
        return 'Feeling Hopeful';
      case EmotionalState.grateful:
        return 'Grateful Heart';
      case EmotionalState.worried:
        return 'Worried Mind';
      case EmotionalState.excited:
        return 'Excited & Joyful';
      case EmotionalState.sad:
        return 'Feeling Sad';
      case EmotionalState.peaceful:
        return 'At Peace';
      case EmotionalState.fearful:
        return 'Feeling Fearful';
      case EmotionalState.confident:
        return 'Confident & Strong';
      case EmotionalState.uncertain:
        return 'Uncertain Path';
      case EmotionalState.overwhelmed:
        return 'Feeling Overwhelmed';
      case EmotionalState.seekingGuidance:
        return 'Seeking Guidance';
    }
  }

  String get arabicName {
    switch (this) {
      case EmotionalState.anxious:
        return 'Ø§Ù„Ù‚Ù„Ù‚';
      case EmotionalState.stressed:
        return 'Ø§Ù„ØªÙˆØªØ±';
      case EmotionalState.hopeful:
        return 'Ø§Ù„Ø£Ù…Ù„';
      case EmotionalState.grateful:
        return 'Ø§Ù„Ø§Ù…ØªÙ†Ø§Ù†';
      case EmotionalState.worried:
        return 'Ø§Ù„Ù‡Ù…';
      case EmotionalState.excited:
        return 'Ø§Ù„ÙØ±Ø­';
      case EmotionalState.sad:
        return 'Ø§Ù„Ø­Ø²Ù†';
      case EmotionalState.peaceful:
        return 'Ø§Ù„Ø³ÙƒÙŠÙ†Ø©';
      case EmotionalState.fearful:
        return 'Ø§Ù„Ø®ÙˆÙ';
      case EmotionalState.confident:
        return 'Ø§Ù„Ø«Ù‚Ø©';
      case EmotionalState.uncertain:
        return 'Ø§Ù„ØªØ±Ø¯Ø¯';
      case EmotionalState.overwhelmed:
        return 'Ø§Ù„Ø¥Ø±Ù‡Ø§Ù‚';
      case EmotionalState.seekingGuidance:
        return 'Ø·Ù„Ø¨ Ø§Ù„Ù‡Ø¯Ø§ÙŠØ©';
    }
  }

  List<String> get relatedKeywords {
    switch (this) {
      case EmotionalState.anxious:
        return ['nervous', 'worried', 'tense', 'restless', 'uneasy'];
      case EmotionalState.stressed:
        return ['overwhelmed', 'pressure', 'burden', 'exhausted', 'burned out'];
      case EmotionalState.hopeful:
        return ['optimistic', 'positive', 'expecting', 'trusting', 'faith'];
      case EmotionalState.grateful:
        return ['thankful', 'blessed', 'appreciative', 'content', 'satisfied'];
      case EmotionalState.worried:
        return ['concerned', 'troubled', 'anxious', 'fearful', 'apprehensive'];
      case EmotionalState.excited:
        return ['happy', 'joyful', 'enthusiastic', 'elated', 'thrilled'];
      case EmotionalState.sad:
        return ['depressed', 'down', 'melancholy', 'sorrowful', 'grief'];
      case EmotionalState.peaceful:
        return ['calm', 'serene', 'tranquil', 'relaxed', 'content'];
      case EmotionalState.fearful:
        return ['scared', 'afraid', 'terrified', 'frightened', 'paranoid'];
      case EmotionalState.confident:
        return ['sure', 'certain', 'strong', 'determined', 'assured'];
      case EmotionalState.uncertain:
        return ['confused', 'doubtful', 'hesitant', 'indecisive', 'lost'];
      case EmotionalState.overwhelmed:
        return [
          'too much',
          'overloaded',
          'stressed',
          'can\'t cope',
          'exhausted',
        ];
      case EmotionalState.seekingGuidance:
        return ['lost', 'searching', 'guidance', 'direction', 'help'];
    }
  }
}

/// Extension methods for context analysis
extension DuaContextExtensions on DuaContext {
  String get displayName {
    switch (this) {
      case DuaContext.travel:
        return 'Travel & Journey';
      case DuaContext.health:
        return 'Health & Healing';
      case DuaContext.workCareer:
        return 'Work & Career';
      case DuaContext.family:
        return 'Family Matters';
      case DuaContext.education:
        return 'Learning & Education';
      case DuaContext.financial:
        return 'Financial Concerns';
      case DuaContext.spiritual:
        return 'Spiritual Growth';
      case DuaContext.relationships:
        return 'Relationships';
      case DuaContext.protection:
        return 'Protection & Safety';
      case DuaContext.guidance:
        return 'Divine Guidance';
      case DuaContext.gratitude:
        return 'Gratitude & Thanks';
      case DuaContext.forgiveness:
        return 'Forgiveness & Mercy';
    }
  }

  String get arabicName {
    switch (this) {
      case DuaContext.travel:
        return 'Ø§Ù„Ø³ÙØ± ÙˆØ§Ù„Ø±Ø­Ù„Ø©';
      case DuaContext.health:
        return 'Ø§Ù„ØµØ­Ø© ÙˆØ§Ù„Ø´ÙØ§Ø¡';
      case DuaContext.workCareer:
        return 'Ø§Ù„Ø¹Ù…Ù„ ÙˆØ§Ù„Ù…Ù‡Ù†Ø©';
      case DuaContext.family:
        return 'Ø§Ù„Ø£Ø³Ø±Ø©';
      case DuaContext.education:
        return 'Ø§Ù„ØªØ¹Ù„Ù… ÙˆØ§Ù„ØªØ¹Ù„ÙŠÙ…';
      case DuaContext.financial:
        return 'Ø§Ù„Ø£Ù…ÙˆØ± Ø§Ù„Ù…Ø§Ù„ÙŠØ©';
      case DuaContext.spiritual:
        return 'Ø§Ù„Ù†Ù…Ùˆ Ø§Ù„Ø±ÙˆØ­ÙŠ';
      case DuaContext.relationships:
        return 'Ø§Ù„Ø¹Ù„Ø§Ù‚Ø§Øª';
      case DuaContext.protection:
        return 'Ø§Ù„Ø­Ù…Ø§ÙŠØ© ÙˆØ§Ù„Ø£Ù…Ø§Ù†';
      case DuaContext.guidance:
        return 'Ø§Ù„Ù‡Ø¯Ø§ÙŠØ© Ø§Ù„Ø¥Ù„Ù‡ÙŠØ©';
      case DuaContext.gratitude:
        return 'Ø§Ù„Ø§Ù…ØªÙ†Ø§Ù† ÙˆØ§Ù„Ø´ÙƒØ±';
      case DuaContext.forgiveness:
        return 'Ø§Ù„Ù…ØºÙØ±Ø© ÙˆØ§Ù„Ø±Ø­Ù…Ø©';
    }
  }

  List<String> get contextKeywords {
    switch (this) {
      case DuaContext.travel:
        return ['journey', 'trip', 'flight', 'road', 'destination', 'vacation'];
      case DuaContext.health:
        return ['sick', 'illness', 'doctor', 'hospital', 'medicine', 'healing'];
      case DuaContext.workCareer:
        return ['job', 'interview', 'promotion', 'boss', 'career', 'work'];
      case DuaContext.family:
        return ['parents', 'children', 'spouse', 'family', 'relatives'];
      case DuaContext.education:
        return ['exam', 'study', 'school', 'university', 'learning', 'test'];
      case DuaContext.financial:
        return ['money', 'debt', 'poverty', 'wealth', 'business', 'income'];
      case DuaContext.spiritual:
        return ['prayer', 'faith', 'worship', 'spirituality', 'religion'];
      case DuaContext.relationships:
        return ['marriage', 'friendship', 'love', 'conflict', 'relationship'];
      case DuaContext.protection:
        return ['danger', 'safety', 'protection', 'security', 'harm'];
      case DuaContext.guidance:
        return ['decision', 'choice', 'guidance', 'direction', 'path'];
      case DuaContext.gratitude:
        return ['thanks', 'grateful', 'blessing', 'appreciate', 'thankful'];
      case DuaContext.forgiveness:
        return ['forgiveness', 'mercy', 'sin', 'repentance', 'guilt'];
    }
  }
}
