// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_dua_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartDuaCollectionImpl _$$SmartDuaCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartDuaCollectionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      duaIds:
          (json['duaIds'] as List<dynamic>).map((e) => e as String).toList(),
      primaryEmotion:
          $enumDecode(_$EmotionalStateEnumMap, json['primaryEmotion']),
      secondaryEmotions: (json['secondaryEmotions'] as List<dynamic>)
          .map((e) => $enumDecode(_$EmotionalStateEnumMap, e))
          .toList(),
      context: $enumDecode(_$DuaContextEnumMap, json['context']),
      triggers:
          (json['triggers'] as List<dynamic>).map((e) => e as String).toList(),
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      confidenceLevel:
          $enumDecode(_$AIConfidenceLevelEnumMap, json['confidenceLevel']),
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      aiMetadata: json['aiMetadata'] as Map<String, dynamic>,
      usageCount: (json['usageCount'] as num).toInt(),
      effectivenessScore: (json['effectivenessScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt: DateTime.parse(json['lastUsedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isPersonalized: json['isPersonalized'] as bool? ?? true,
    );

Map<String, dynamic> _$$SmartDuaCollectionImplToJson(
        _$SmartDuaCollectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'duaIds': instance.duaIds,
      'primaryEmotion': _$EmotionalStateEnumMap[instance.primaryEmotion]!,
      'secondaryEmotions': instance.secondaryEmotions
          .map((e) => _$EmotionalStateEnumMap[e]!)
          .toList(),
      'context': _$DuaContextEnumMap[instance.context]!,
      'triggers': instance.triggers,
      'keywords': instance.keywords,
      'confidenceLevel': _$AIConfidenceLevelEnumMap[instance.confidenceLevel]!,
      'relevanceScore': instance.relevanceScore,
      'aiMetadata': instance.aiMetadata,
      'usageCount': instance.usageCount,
      'effectivenessScore': instance.effectivenessScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUsedAt': instance.lastUsedAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'isPersonalized': instance.isPersonalized,
    };

const _$EmotionalStateEnumMap = {
  EmotionalState.anxious: 'anxious',
  EmotionalState.stressed: 'stressed',
  EmotionalState.hopeful: 'hopeful',
  EmotionalState.grateful: 'grateful',
  EmotionalState.worried: 'worried',
  EmotionalState.excited: 'excited',
  EmotionalState.sad: 'sad',
  EmotionalState.peaceful: 'peaceful',
  EmotionalState.fearful: 'fearful',
  EmotionalState.confident: 'confident',
  EmotionalState.uncertain: 'uncertain',
  EmotionalState.overwhelmed: 'overwhelmed',
  EmotionalState.seekingGuidance: 'seeking_guidance',
};

const _$DuaContextEnumMap = {
  DuaContext.travel: 'travel',
  DuaContext.health: 'health',
  DuaContext.workCareer: 'work_career',
  DuaContext.family: 'family',
  DuaContext.education: 'education',
  DuaContext.financial: 'financial',
  DuaContext.spiritual: 'spiritual',
  DuaContext.relationships: 'relationships',
  DuaContext.protection: 'protection',
  DuaContext.guidance: 'guidance',
  DuaContext.gratitude: 'gratitude',
  DuaContext.forgiveness: 'forgiveness',
};

const _$AIConfidenceLevelEnumMap = {
  AIConfidenceLevel.veryHigh: 'very_high',
  AIConfidenceLevel.high: 'high',
  AIConfidenceLevel.medium: 'medium',
  AIConfidenceLevel.low: 'low',
};

_$EmotionalPatternImpl _$$EmotionalPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$EmotionalPatternImpl(
      userId: json['userId'] as String,
      dominantEmotion:
          $enumDecode(_$EmotionalStateEnumMap, json['dominantEmotion']),
      emotionFrequency: (json['emotionFrequency'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$EmotionalStateEnumMap, k), (e as num).toDouble()),
      ),
      contextPreferences:
          (json['contextPreferences'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$DuaContextEnumMap, k), (e as num).toInt()),
      ),
      frequentTriggers: (json['frequentTriggers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timePatterns: (json['timePatterns'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      stressLevel: (json['stressLevel'] as num).toDouble(),
      spiritualEngagement: (json['spiritualEngagement'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      dataStartDate: DateTime.parse(json['dataStartDate'] as String),
      dataEndDate: DateTime.parse(json['dataEndDate'] as String),
      totalInteractions: (json['totalInteractions'] as num?)?.toInt() ?? 0,
      predictionAccuracy:
          (json['predictionAccuracy'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$EmotionalPatternImplToJson(
        _$EmotionalPatternImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'dominantEmotion': _$EmotionalStateEnumMap[instance.dominantEmotion]!,
      'emotionFrequency': instance.emotionFrequency
          .map((k, e) => MapEntry(_$EmotionalStateEnumMap[k]!, e)),
      'contextPreferences': instance.contextPreferences
          .map((k, e) => MapEntry(_$DuaContextEnumMap[k]!, e)),
      'frequentTriggers': instance.frequentTriggers,
      'timePatterns': instance.timePatterns,
      'stressLevel': instance.stressLevel,
      'spiritualEngagement': instance.spiritualEngagement,
      'analyzedAt': instance.analyzedAt.toIso8601String(),
      'dataStartDate': instance.dataStartDate.toIso8601String(),
      'dataEndDate': instance.dataEndDate.toIso8601String(),
      'totalInteractions': instance.totalInteractions,
      'predictionAccuracy': instance.predictionAccuracy,
    };

_$SmartDuaRecommendationImpl _$$SmartDuaRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartDuaRecommendationImpl(
      id: json['id'] as String,
      duaId: json['duaId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      arabicTitle: json['arabicTitle'] as String,
      reason: json['reason'] as String,
      targetEmotion:
          $enumDecode(_$EmotionalStateEnumMap, json['targetEmotion']),
      context: $enumDecode(_$DuaContextEnumMap, json['context']),
      matchedKeywords: (json['matchedKeywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      confidence: $enumDecode(_$AIConfidenceLevelEnumMap, json['confidence']),
      aiReasoningData: json['aiReasoningData'] as Map<String, dynamic>,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      dismissedAt: json['dismissedAt'] == null
          ? null
          : DateTime.parse(json['dismissedAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      isPersonalized: json['isPersonalized'] as bool? ?? true,
      wasAccurate: json['wasAccurate'] as bool? ?? false,
      userFeedback: json['userFeedback'] as String?,
    );

Map<String, dynamic> _$$SmartDuaRecommendationImplToJson(
        _$SmartDuaRecommendationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'duaId': instance.duaId,
      'userId': instance.userId,
      'title': instance.title,
      'arabicTitle': instance.arabicTitle,
      'reason': instance.reason,
      'targetEmotion': _$EmotionalStateEnumMap[instance.targetEmotion]!,
      'context': _$DuaContextEnumMap[instance.context]!,
      'matchedKeywords': instance.matchedKeywords,
      'relevanceScore': instance.relevanceScore,
      'confidence': _$AIConfidenceLevelEnumMap[instance.confidence]!,
      'aiReasoningData': instance.aiReasoningData,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'dismissedAt': instance.dismissedAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'isPersonalized': instance.isPersonalized,
      'wasAccurate': instance.wasAccurate,
      'userFeedback': instance.userFeedback,
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
      detectedContext:
          $enumDecode(_$DuaContextEnumMap, json['detectedContext']),
      emotionConfidence: (json['emotionConfidence'] as num).toDouble(),
      contextConfidence: (json['contextConfidence'] as num).toDouble(),
      nlpAnalysis: json['nlpAnalysis'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isEncrypted: json['isEncrypted'] as bool? ?? true,
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
      'detectedContext': _$DuaContextEnumMap[instance.detectedContext]!,
      'emotionConfidence': instance.emotionConfidence,
      'contextConfidence': instance.contextConfidence,
      'nlpAnalysis': instance.nlpAnalysis,
      'timestamp': instance.timestamp.toIso8601String(),
      'isEncrypted': instance.isEncrypted,
      'encryptionKey': instance.encryptionKey,
    };

_$AIFeedbackImpl _$$AIFeedbackImplFromJson(Map<String, dynamic> json) =>
    _$AIFeedbackImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      recommendationId: json['recommendationId'] as String,
      wasHelpful: json['wasHelpful'] as bool,
      rating: (json['rating'] as num).toInt(),
      feedbackType: json['feedbackType'] as String,
      textFeedback: json['textFeedback'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      providedAt: json['providedAt'] == null
          ? null
          : DateTime.parse(json['providedAt'] as String),
    );

Map<String, dynamic> _$$AIFeedbackImplToJson(_$AIFeedbackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'recommendationId': instance.recommendationId,
      'wasHelpful': instance.wasHelpful,
      'rating': instance.rating,
      'feedbackType': instance.feedbackType,
      'textFeedback': instance.textFeedback,
      'additionalData': instance.additionalData,
      'providedAt': instance.providedAt?.toIso8601String(),
    };

_$ContextualAnalyticsImpl _$$ContextualAnalyticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ContextualAnalyticsImpl(
      userId: json['userId'] as String,
      emotionSuccessRate:
          (json['emotionSuccessRate'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$EmotionalStateEnumMap, k), (e as num).toInt()),
      ),
      contextEffectiveness:
          (json['contextEffectiveness'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$DuaContextEnumMap, k), (e as num).toDouble()),
      ),
      totalRecommendations: (json['totalRecommendations'] as num).toInt(),
      acceptedRecommendations: (json['acceptedRecommendations'] as num).toInt(),
      dismissedRecommendations:
          (json['dismissedRecommendations'] as num).toInt(),
      overallSatisfaction: (json['overallSatisfaction'] as num).toDouble(),
      improvementAreas: json['improvementAreas'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ContextualAnalyticsImplToJson(
        _$ContextualAnalyticsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'emotionSuccessRate': instance.emotionSuccessRate
          .map((k, e) => MapEntry(_$EmotionalStateEnumMap[k]!, e)),
      'contextEffectiveness': instance.contextEffectiveness
          .map((k, e) => MapEntry(_$DuaContextEnumMap[k]!, e)),
      'totalRecommendations': instance.totalRecommendations,
      'acceptedRecommendations': instance.acceptedRecommendations,
      'dismissedRecommendations': instance.dismissedRecommendations,
      'overallSatisfaction': instance.overallSatisfaction,
      'improvementAreas': instance.improvementAreas,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
