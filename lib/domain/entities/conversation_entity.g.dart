// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: json['userId'] as String,
      preferences: json['preferences'] as Map<String, dynamic>,
      conversationStyle: json['conversationStyle'] as String,
      topicInterests: (json['topicInterests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      emotionalPatterns: json['emotionalPatterns'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'preferences': instance.preferences,
      'conversationStyle': instance.conversationStyle,
      'topicInterests': instance.topicInterests,
      'emotionalPatterns': instance.emotionalPatterns,
    };

_$ConversationContextImpl _$$ConversationContextImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationContextImpl(
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      turnCount: (json['turnCount'] as num).toInt(),
      currentTopic: json['currentTopic'] as String?,
      emotionalState:
          $enumDecode(_$EmotionalStateEnumMap, json['emotionalState']),
      contextTags: (json['contextTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      userProfile:
          UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      semanticContext: json['semanticContext'] as Map<String, dynamic>,
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$ConversationContextImplToJson(
        _$ConversationContextImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'startTime': instance.startTime.toIso8601String(),
      'lastActivity': instance.lastActivity.toIso8601String(),
      'turnCount': instance.turnCount,
      'currentTopic': instance.currentTopic,
      'emotionalState': _$EmotionalStateEnumMap[instance.emotionalState]!,
      'contextTags': instance.contextTags,
      'userProfile': instance.userProfile,
      'semanticContext': instance.semanticContext,
      'endTime': instance.endTime?.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$EmotionalStateEnumMap = {
  EmotionalState.neutral: 'neutral',
  EmotionalState.anxious: 'anxious',
  EmotionalState.grateful: 'grateful',
  EmotionalState.sad: 'sad',
  EmotionalState.uncertain: 'uncertain',
  EmotionalState.seekingGuidance: 'seekingGuidance',
  EmotionalState.hopeful: 'hopeful',
  EmotionalState.worried: 'worried',
  EmotionalState.excited: 'excited',
  EmotionalState.peaceful: 'peaceful',
  EmotionalState.fearful: 'fearful',
  EmotionalState.confident: 'confident',
  EmotionalState.stressed: 'stressed',
};

_$ConversationTurnImpl _$$ConversationTurnImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationTurnImpl(
      turnId: json['turnId'] as String,
      conversationId: json['conversationId'] as String,
      userInput: json['userInput'] as String,
      systemResponse: json['systemResponse'] as String,
      intent: json['intent'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      emotionalState:
          $enumDecode(_$EmotionalStateEnumMap, json['emotionalState']),
      topicTags:
          (json['topicTags'] as List<dynamic>).map((e) => e as String).toList(),
      semanticEmbedding: (json['semanticEmbedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ConversationTurnImplToJson(
        _$ConversationTurnImpl instance) =>
    <String, dynamic>{
      'turnId': instance.turnId,
      'conversationId': instance.conversationId,
      'userInput': instance.userInput,
      'systemResponse': instance.systemResponse,
      'intent': instance.intent,
      'timestamp': instance.timestamp.toIso8601String(),
      'emotionalState': _$EmotionalStateEnumMap[instance.emotionalState]!,
      'topicTags': instance.topicTags,
      'semanticEmbedding': instance.semanticEmbedding,
      'metadata': instance.metadata,
    };

_$SemanticMemoryImpl _$$SemanticMemoryImplFromJson(Map<String, dynamic> json) =>
    _$SemanticMemoryImpl(
      userId: json['userId'] as String,
      conversationId: json['conversationId'] as String,
      turnId: json['turnId'] as String,
      userInput: json['userInput'] as String,
      systemResponse: json['systemResponse'] as String,
      embedding: (json['embedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
      emotionalState:
          $enumDecode(_$EmotionalStateEnumMap, json['emotionalState']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$SemanticMemoryImplToJson(
        _$SemanticMemoryImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'conversationId': instance.conversationId,
      'turnId': instance.turnId,
      'userInput': instance.userInput,
      'systemResponse': instance.systemResponse,
      'embedding': instance.embedding,
      'topics': instance.topics,
      'emotionalState': _$EmotionalStateEnumMap[instance.emotionalState]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$SimilarConversationImpl _$$SimilarConversationImplFromJson(
        Map<String, dynamic> json) =>
    _$SimilarConversationImpl(
      conversationId: json['conversationId'] as String,
      turnId: json['turnId'] as String,
      similarity: (json['similarity'] as num).toDouble(),
      originalInput: json['originalInput'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SimilarConversationImplToJson(
        _$SimilarConversationImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'turnId': instance.turnId,
      'similarity': instance.similarity,
      'originalInput': instance.originalInput,
      'response': instance.response,
      'timestamp': instance.timestamp.toIso8601String(),
      'topics': instance.topics,
    };

_$ConversationUpdateImpl _$$ConversationUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationUpdateImpl(
      conversationId: json['conversationId'] as String,
      turn: ConversationTurn.fromJson(json['turn'] as Map<String, dynamic>),
      updatedContext: ConversationContext.fromJson(
          json['updatedContext'] as Map<String, dynamic>),
      updateType:
          $enumDecode(_$ConversationUpdateTypeEnumMap, json['updateType']),
    );

Map<String, dynamic> _$$ConversationUpdateImplToJson(
        _$ConversationUpdateImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'turn': instance.turn,
      'updatedContext': instance.updatedContext,
      'updateType': _$ConversationUpdateTypeEnumMap[instance.updateType]!,
    };

const _$ConversationUpdateTypeEnumMap = {
  ConversationUpdateType.turnAdded: 'turnAdded',
  ConversationUpdateType.contextUpdated: 'contextUpdated',
  ConversationUpdateType.conversationEnded: 'conversationEnded',
  ConversationUpdateType.profileUpdated: 'profileUpdated',
};

_$TopicFrequencyImpl _$$TopicFrequencyImplFromJson(Map<String, dynamic> json) =>
    _$TopicFrequencyImpl(
      topic: json['topic'] as String,
      frequency: (json['frequency'] as num).toInt(),
    );

Map<String, dynamic> _$$TopicFrequencyImplToJson(
        _$TopicFrequencyImpl instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'frequency': instance.frequency,
    };

_$ConversationStatsImpl _$$ConversationStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationStatsImpl(
      userId: json['userId'] as String,
      totalConversations: (json['totalConversations'] as num).toInt(),
      totalTurns: (json['totalTurns'] as num).toInt(),
      averageTurnsPerConversation:
          (json['averageTurnsPerConversation'] as num).toDouble(),
      mostDiscussedTopics: (json['mostDiscussedTopics'] as List<dynamic>)
          .map((e) => TopicFrequency.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastConversationDate: json['lastConversationDate'] == null
          ? null
          : DateTime.parse(json['lastConversationDate'] as String),
    );

Map<String, dynamic> _$$ConversationStatsImplToJson(
        _$ConversationStatsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalConversations': instance.totalConversations,
      'totalTurns': instance.totalTurns,
      'averageTurnsPerConversation': instance.averageTurnsPerConversation,
      'mostDiscussedTopics': instance.mostDiscussedTopics,
      'lastConversationDate': instance.lastConversationDate?.toIso8601String(),
    };

_$VoiceQueryResultImpl _$$VoiceQueryResultImplFromJson(
        Map<String, dynamic> json) =>
    _$VoiceQueryResultImpl(
      transcription: json['transcription'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      detectedLanguage: json['detectedLanguage'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      containsArabic: json['containsArabic'] as bool,
      alternatives: (json['alternatives'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      audioMetadata: json['audioMetadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$VoiceQueryResultImplToJson(
        _$VoiceQueryResultImpl instance) =>
    <String, dynamic>{
      'transcription': instance.transcription,
      'confidence': instance.confidence,
      'detectedLanguage': instance.detectedLanguage,
      'duration': instance.duration.inMicroseconds,
      'containsArabic': instance.containsArabic,
      'alternatives': instance.alternatives,
      'audioMetadata': instance.audioMetadata,
    };

_$ContextualInputImpl _$$ContextualInputImplFromJson(
        Map<String, dynamic> json) =>
    _$ContextualInputImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      rawInput: json['rawInput'] as String,
      processedKeywords: (json['processedKeywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      detectedEmotion:
          $enumDecode(_$EmotionalStateEnumMap, json['detectedEmotion']),
      detectedContext: json['detectedContext'] as String,
      emotionConfidence: (json['emotionConfidence'] as num).toDouble(),
      contextConfidence: (json['contextConfidence'] as num).toDouble(),
      nlpAnalysis: json['nlpAnalysis'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isEncrypted: json['isEncrypted'] as bool,
      encryptionKey: json['encryptionKey'] as String?,
    );

Map<String, dynamic> _$$ContextualInputImplToJson(
        _$ContextualInputImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'rawInput': instance.rawInput,
      'processedKeywords': instance.processedKeywords,
      'detectedEmotion': _$EmotionalStateEnumMap[instance.detectedEmotion]!,
      'detectedContext': instance.detectedContext,
      'emotionConfidence': instance.emotionConfidence,
      'contextConfidence': instance.contextConfidence,
      'nlpAnalysis': instance.nlpAnalysis,
      'timestamp': instance.timestamp.toIso8601String(),
      'isEncrypted': instance.isEncrypted,
      'encryptionKey': instance.encryptionKey,
    };

_$ProactiveSuggestionImpl _$$ProactiveSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$ProactiveSuggestionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      suggestionText: json['suggestionText'] as String,
      reason: json['reason'] as String,
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      suggestedAt: DateTime.parse(json['suggestedAt'] as String),
      category: json['category'] as String,
      context: json['context'] as Map<String, dynamic>,
      isShown: json['isShown'] as bool? ?? false,
      isAccepted: json['isAccepted'] as bool? ?? false,
      shownAt: json['shownAt'] == null
          ? null
          : DateTime.parse(json['shownAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$ProactiveSuggestionImplToJson(
        _$ProactiveSuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'suggestionText': instance.suggestionText,
      'reason': instance.reason,
      'relevanceScore': instance.relevanceScore,
      'suggestedAt': instance.suggestedAt.toIso8601String(),
      'category': instance.category,
      'context': instance.context,
      'isShown': instance.isShown,
      'isAccepted': instance.isAccepted,
      'shownAt': instance.shownAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      description: json['description'] as String,
      location: json['location'] as String,
      isIslamicEvent: json['isIslamicEvent'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>,
      suggestedDuas: (json['suggestedDuas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'description': instance.description,
      'location': instance.location,
      'isIslamicEvent': instance.isIslamicEvent,
      'metadata': instance.metadata,
      'suggestedDuas': instance.suggestedDuas,
    };

_$CulturalContextImpl _$$CulturalContextImplFromJson(
        Map<String, dynamic> json) =>
    _$CulturalContextImpl(
      userId: json['userId'] as String,
      country: json['country'] as String,
      region: json['region'] as String,
      primaryLanguage: json['primaryLanguage'] as String,
      preferredLanguages: (json['preferredLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      islamicSchool: json['islamicSchool'] as String,
      culturalPreferences: json['culturalPreferences'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$CulturalContextImplToJson(
        _$CulturalContextImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'country': instance.country,
      'region': instance.region,
      'primaryLanguage': instance.primaryLanguage,
      'preferredLanguages': instance.preferredLanguages,
      'islamicSchool': instance.islamicSchool,
      'culturalPreferences': instance.culturalPreferences,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
