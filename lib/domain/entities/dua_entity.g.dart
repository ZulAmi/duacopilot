// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DuaEntityImpl _$$DuaEntityImplFromJson(Map<String, dynamic> json) =>
    _$DuaEntityImpl(
      id: json['id'] as String,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      authenticity: SourceAuthenticity.fromJson(
          json['authenticity'] as Map<String, dynamic>),
      ragConfidence:
          RAGConfidence.fromJson(json['ragConfidence'] as Map<String, dynamic>),
      audioUrl: json['audioUrl'] as String?,
      context: json['context'] as String?,
      benefits: json['benefits'] as String?,
      relatedDuas: (json['relatedDuas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
    );

Map<String, dynamic> _$$DuaEntityImplToJson(_$DuaEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicText': instance.arabicText,
      'transliteration': instance.transliteration,
      'translation': instance.translation,
      'category': instance.category,
      'tags': instance.tags,
      'authenticity': instance.authenticity,
      'ragConfidence': instance.ragConfidence,
      'audioUrl': instance.audioUrl,
      'context': instance.context,
      'benefits': instance.benefits,
      'relatedDuas': instance.relatedDuas,
      'isFavorite': instance.isFavorite,
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
    };

_$SourceAuthenticityImpl _$$SourceAuthenticityImplFromJson(
        Map<String, dynamic> json) =>
    _$SourceAuthenticityImpl(
      level: $enumDecode(_$AuthenticityLevelEnumMap, json['level']),
      source: json['source'] as String,
      reference: json['reference'] as String,
      hadithGrade: json['hadithGrade'] as String?,
      chain: json['chain'] as String?,
      scholar: json['scholar'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$SourceAuthenticityImplToJson(
        _$SourceAuthenticityImpl instance) =>
    <String, dynamic>{
      'level': _$AuthenticityLevelEnumMap[instance.level]!,
      'source': instance.source,
      'reference': instance.reference,
      'hadithGrade': instance.hadithGrade,
      'chain': instance.chain,
      'scholar': instance.scholar,
      'confidenceScore': instance.confidenceScore,
    };

const _$AuthenticityLevelEnumMap = {
  AuthenticityLevel.sahih: 'sahih',
  AuthenticityLevel.hasan: 'hasan',
  AuthenticityLevel.daif: 'daif',
  AuthenticityLevel.fabricated: 'fabricated',
  AuthenticityLevel.quran: 'quran',
  AuthenticityLevel.verified: 'verified',
};

_$RAGConfidenceImpl _$$RAGConfidenceImplFromJson(Map<String, dynamic> json) =>
    _$RAGConfidenceImpl(
      score: (json['score'] as num).toDouble(),
      reasoning: json['reasoning'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      contextMatch:
          ContextMatch.fromJson(json['contextMatch'] as Map<String, dynamic>),
      similarQueries: (json['similarQueries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      semanticSimilarity:
          (json['semanticSimilarity'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      supportingEvidence: (json['supportingEvidence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RAGConfidenceImplToJson(_$RAGConfidenceImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'reasoning': instance.reasoning,
      'keywords': instance.keywords,
      'contextMatch': instance.contextMatch,
      'similarQueries': instance.similarQueries,
      'semanticSimilarity': instance.semanticSimilarity,
      'supportingEvidence': instance.supportingEvidence,
    };

_$ContextMatchImpl _$$ContextMatchImplFromJson(Map<String, dynamic> json) =>
    _$ContextMatchImpl(
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      category: json['category'] as String,
      matchingCriteria: (json['matchingCriteria'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timeOfDay: json['timeOfDay'] as String?,
      situation: json['situation'] as String?,
      emotionalState: json['emotionalState'] as String?,
    );

Map<String, dynamic> _$$ContextMatchImplToJson(_$ContextMatchImpl instance) =>
    <String, dynamic>{
      'relevanceScore': instance.relevanceScore,
      'category': instance.category,
      'matchingCriteria': instance.matchingCriteria,
      'timeOfDay': instance.timeOfDay,
      'situation': instance.situation,
      'emotionalState': instance.emotionalState,
    };
