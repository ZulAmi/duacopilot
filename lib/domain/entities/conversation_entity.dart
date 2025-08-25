import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_entity.freezed.dart';
part 'conversation_entity.g.dart';

/// Emotional states for conversation context
enum EmotionalState {
  neutral,
  anxious,
  grateful,
  sad,
  uncertain,
  seeking_guidance,
  hopeful,
  worried,
  excited,
  peaceful,
  fearful,
  confident,
  stressed,
}

/// Conversation update types
enum ConversationUpdateType { turnAdded, contextUpdated, conversationEnded, profileUpdated }

/// User profile for conversation personalization
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    required Map<String, dynamic> preferences,
    required String conversationStyle,
    required List<String> topicInterests,
    required Map<String, dynamic> emotionalPatterns,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

/// Conversation context for maintaining state
@freezed
class ConversationContext with _$ConversationContext {
  const factory ConversationContext({
    required String conversationId,
    required String userId,
    required DateTime startTime,
    required DateTime lastActivity,
    required int turnCount,
    required String? currentTopic,
    required EmotionalState emotionalState,
    required List<String> contextTags,
    required UserProfile userProfile,
    required Map<String, dynamic> semanticContext,
    DateTime? endTime,
    @Default(true) bool isActive,
  }) = _ConversationContext;

  factory ConversationContext.fromJson(Map<String, dynamic> json) => _$ConversationContextFromJson(json);
}

/// Individual conversation turn
@freezed
class ConversationTurn with _$ConversationTurn {
  const factory ConversationTurn({
    required String turnId,
    required String conversationId,
    required String userInput,
    required String systemResponse,
    required String intent,
    required DateTime timestamp,
    required EmotionalState emotionalState,
    required List<String> topicTags,
    required List<double> semanticEmbedding,
    required Map<String, dynamic> metadata,
  }) = _ConversationTurn;

  factory ConversationTurn.fromJson(Map<String, dynamic> json) => _$ConversationTurnFromJson(json);
}

/// Semantic memory for similar conversation finding
@freezed
class SemanticMemory with _$SemanticMemory {
  const factory SemanticMemory({
    required String userId,
    required String conversationId,
    required String turnId,
    required String userInput,
    required String systemResponse,
    required List<double> embedding,
    required List<String> topics,
    required EmotionalState emotionalState,
    required DateTime timestamp,
  }) = _SemanticMemory;

  factory SemanticMemory.fromJson(Map<String, dynamic> json) => _$SemanticMemoryFromJson(json);
}

/// Similar conversation for context enhancement
@freezed
class SimilarConversation with _$SimilarConversation {
  const factory SimilarConversation({
    required String conversationId,
    required String turnId,
    required double similarity,
    required String originalInput,
    required String response,
    required DateTime timestamp,
    required List<String> topics,
  }) = _SimilarConversation;

  factory SimilarConversation.fromJson(Map<String, dynamic> json) => _$SimilarConversationFromJson(json);
}

/// Conversation update notification
@freezed
class ConversationUpdate with _$ConversationUpdate {
  const factory ConversationUpdate({
    required String conversationId,
    required ConversationTurn turn,
    required ConversationContext updatedContext,
    required ConversationUpdateType updateType,
  }) = _ConversationUpdate;

  factory ConversationUpdate.fromJson(Map<String, dynamic> json) => _$ConversationUpdateFromJson(json);
}

/// Topic frequency for statistics
@freezed
class TopicFrequency with _$TopicFrequency {
  const factory TopicFrequency({required String topic, required int frequency}) = _TopicFrequency;

  factory TopicFrequency.fromJson(Map<String, dynamic> json) => _$TopicFrequencyFromJson(json);
}

/// Conversation statistics
@freezed
class ConversationStats with _$ConversationStats {
  const factory ConversationStats({
    required String userId,
    required int totalConversations,
    required int totalTurns,
    required double averageTurnsPerConversation,
    required List<TopicFrequency> mostDiscussedTopics,
    DateTime? lastConversationDate,
  }) = _ConversationStats;

  factory ConversationStats.fromJson(Map<String, dynamic> json) => _$ConversationStatsFromJson(json);
}

/// Voice query result with audio context
@freezed
class VoiceQueryResult with _$VoiceQueryResult {
  const factory VoiceQueryResult({
    required String transcription,
    required double confidence,
    required String detectedLanguage,
    required Duration duration,
    required bool containsArabic,
    required List<String> alternatives,
    required Map<String, dynamic> audioMetadata,
  }) = _VoiceQueryResult;

  factory VoiceQueryResult.fromJson(Map<String, dynamic> json) => _$VoiceQueryResultFromJson(json);
}

/// Contextual input with emotion and intent analysis
@freezed
class ContextualInput with _$ContextualInput {
  const factory ContextualInput({
    required String id,
    required String userId,
    required String rawInput,
    required List<String> processedKeywords,
    required EmotionalState detectedEmotion,
    required String detectedContext,
    required double emotionConfidence,
    required double contextConfidence,
    required Map<String, dynamic> nlpAnalysis,
    required DateTime timestamp,
    required bool isEncrypted,
    String? encryptionKey,
  }) = _ContextualInput;

  factory ContextualInput.fromJson(Map<String, dynamic> json) => _$ContextualInputFromJson(json);
}

/// Proactive suggestion with timing and relevance
@freezed
class ProactiveSuggestion with _$ProactiveSuggestion {
  const factory ProactiveSuggestion({
    required String id,
    required String userId,
    required String suggestionText,
    required String reason,
    required double relevanceScore,
    required DateTime suggestedAt,
    required String category,
    required Map<String, dynamic> context,
    @Default(false) bool isShown,
    @Default(false) bool isAccepted,
    DateTime? shownAt,
    DateTime? respondedAt,
  }) = _ProactiveSuggestion;

  factory ProactiveSuggestion.fromJson(Map<String, dynamic> json) => _$ProactiveSuggestionFromJson(json);
}

/// Calendar event integration
@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String eventId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required String description,
    required String location,
    required bool isIslamicEvent,
    required Map<String, dynamic> metadata,
    List<String>? suggestedDuas,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);
}

/// Cultural adaptation context
@freezed
class CulturalContext with _$CulturalContext {
  const factory CulturalContext({
    required String userId,
    required String country,
    required String region,
    required String primaryLanguage,
    required List<String> preferredLanguages,
    required String islamicSchool,
    required Map<String, dynamic> culturalPreferences,
    required DateTime lastUpdated,
  }) = _CulturalContext;

  factory CulturalContext.fromJson(Map<String, dynamic> json) => _$CulturalContextFromJson(json);
}
