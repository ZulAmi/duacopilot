// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DuaRecommendationImpl _$$DuaRecommendationImplFromJson(
  Map<String, dynamic> json,
) => _$DuaRecommendationImpl(
  id: json['id'] as String,
  arabicText: json['arabicText'] as String,
  transliteration: json['transliteration'] as String,
  translation: json['translation'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  category: json['category'] as String?,
  source: json['source'] as String?,
  reference: json['reference'] as String?,
  audioUrl: json['audioUrl'] as String?,
  audioFileName: json['audioFileName'] as String?,
  repetitions: (json['repetitions'] as num?)?.toInt(),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  metadata: json['metadata'] as Map<String, dynamic>?,
  isFavorite: json['isFavorite'] as bool? ?? false,
  hasAudio: json['hasAudio'] as bool? ?? false,
  isDownloaded: json['isDownloaded'] as bool? ?? false,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  lastAccessed:
      json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
);

Map<String, dynamic> _$$DuaRecommendationImplToJson(
  _$DuaRecommendationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicText': instance.arabicText,
  'transliteration': instance.transliteration,
  'translation': instance.translation,
  'confidence': instance.confidence,
  'category': instance.category,
  'source': instance.source,
  'reference': instance.reference,
  'audioUrl': instance.audioUrl,
  'audioFileName': instance.audioFileName,
  'repetitions': instance.repetitions,
  'tags': instance.tags,
  'metadata': instance.metadata,
  'isFavorite': instance.isFavorite,
  'hasAudio': instance.hasAudio,
  'isDownloaded': instance.isDownloaded,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastAccessed': instance.lastAccessed?.toIso8601String(),
};
