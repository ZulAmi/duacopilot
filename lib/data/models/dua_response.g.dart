// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DuaResponseImpl _$$DuaResponseImplFromJson(Map<String, dynamic> json) =>
    _$DuaResponseImpl(
      id: json['id'] as String,
      query: json['query'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseTime: (json['responseTime'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
      sources: (json['sources'] as List<dynamic>)
          .map((e) => DuaSource.fromJson(e as Map<String, dynamic>))
          .toList(),
      sessionId: json['sessionId'] as String?,
      tokensUsed: (json['tokensUsed'] as num?)?.toInt(),
      model: json['model'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isFromCache: json['isFromCache'] as bool? ?? false,
    );

Map<String, dynamic> _$$DuaResponseImplToJson(_$DuaResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'response': instance.response,
      'timestamp': instance.timestamp.toIso8601String(),
      'responseTime': instance.responseTime,
      'confidence': instance.confidence,
      'sources': instance.sources,
      'sessionId': instance.sessionId,
      'tokensUsed': instance.tokensUsed,
      'model': instance.model,
      'metadata': instance.metadata,
      'isFavorite': instance.isFavorite,
      'isFromCache': instance.isFromCache,
    };

_$DuaSourceImpl _$$DuaSourceImplFromJson(Map<String, dynamic> json) =>
    _$DuaSourceImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      url: json['url'] as String?,
      reference: json['reference'] as String?,
      category: json['category'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DuaSourceImplToJson(_$DuaSourceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'relevanceScore': instance.relevanceScore,
      'url': instance.url,
      'reference': instance.reference,
      'category': instance.category,
      'metadata': instance.metadata,
    };
