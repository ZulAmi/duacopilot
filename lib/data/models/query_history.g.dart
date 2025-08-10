// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueryHistoryImpl _$$QueryHistoryImplFromJson(Map<String, dynamic> json) =>
    _$QueryHistoryImpl(
      id: json['id'] as String,
      query: json['query'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseTime: (json['responseTime'] as num).toInt(),
      semanticHash: json['semanticHash'] as String,
      confidence: (json['confidence'] as num?)?.toDouble(),
      sessionId: json['sessionId'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      context: json['context'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isFromCache: json['isFromCache'] as bool? ?? false,
      lastAccessed:
          json['lastAccessed'] == null
              ? null
              : DateTime.parse(json['lastAccessed'] as String),
      accessCount: (json['accessCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QueryHistoryImplToJson(_$QueryHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'response': instance.response,
      'timestamp': instance.timestamp.toIso8601String(),
      'responseTime': instance.responseTime,
      'semanticHash': instance.semanticHash,
      'confidence': instance.confidence,
      'sessionId': instance.sessionId,
      'tags': instance.tags,
      'context': instance.context,
      'metadata': instance.metadata,
      'isFavorite': instance.isFavorite,
      'isFromCache': instance.isFromCache,
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
      'accessCount': instance.accessCount,
    };
