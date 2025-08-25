// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DuaEmbeddingImpl _$$DuaEmbeddingImplFromJson(Map<String, dynamic> json) =>
    _$DuaEmbeddingImpl(
      id: json['id'] as String,
      duaId: json['duaId'] as String,
      text: json['text'] as String,
      language: json['language'] as String,
      vector:
          (json['vector'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
      category: json['category'] as String,
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DuaEmbeddingImplToJson(_$DuaEmbeddingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'duaId': instance.duaId,
      'text': instance.text,
      'language': instance.language,
      'vector': instance.vector,
      'category': instance.category,
      'keywords': instance.keywords,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$LocalSearchQueryImpl _$$LocalSearchQueryImplFromJson(
  Map<String, dynamic> json,
) => _$LocalSearchQueryImpl(
  id: json['id'] as String,
  query: json['query'] as String,
  language: json['language'] as String,
  embedding:
      (json['embedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  context: json['context'] as Map<String, dynamic>? ?? const {},
  location: json['location'] as String?,
);

Map<String, dynamic> _$$LocalSearchQueryImplToJson(
  _$LocalSearchQueryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'query': instance.query,
  'language': instance.language,
  'embedding': instance.embedding,
  'timestamp': instance.timestamp.toIso8601String(),
  'context': instance.context,
  'location': instance.location,
};

_$OfflineSearchResultImpl _$$OfflineSearchResultImplFromJson(
  Map<String, dynamic> json,
) => _$OfflineSearchResultImpl(
  queryId: json['queryId'] as String,
  matches:
      (json['matches'] as List<dynamic>)
          .map((e) => OfflineDuaMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
  confidence: (json['confidence'] as num).toDouble(),
  quality: $enumDecode(_$SearchQualityEnumMap, json['quality']),
  reasoning: json['reasoning'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  isFromCache: json['isFromCache'] as bool? ?? false,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$OfflineSearchResultImplToJson(
  _$OfflineSearchResultImpl instance,
) => <String, dynamic>{
  'queryId': instance.queryId,
  'matches': instance.matches,
  'confidence': instance.confidence,
  'quality': _$SearchQualityEnumMap[instance.quality]!,
  'reasoning': instance.reasoning,
  'timestamp': instance.timestamp.toIso8601String(),
  'isFromCache': instance.isFromCache,
  'metadata': instance.metadata,
};

const _$SearchQualityEnumMap = {
  SearchQuality.high: 'high',
  SearchQuality.medium: 'medium',
  SearchQuality.low: 'low',
  SearchQuality.cached: 'cached',
};

_$OfflineDuaMatchImpl _$$OfflineDuaMatchImplFromJson(
  Map<String, dynamic> json,
) => _$OfflineDuaMatchImpl(
  duaId: json['duaId'] as String,
  text: json['text'] as String,
  translation: json['translation'] as String,
  transliteration: json['transliteration'] as String,
  category: json['category'] as String,
  similarityScore: (json['similarityScore'] as num).toDouble(),
  matchedKeywords:
      (json['matchedKeywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  matchReason: json['matchReason'] as String,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$OfflineDuaMatchImplToJson(
  _$OfflineDuaMatchImpl instance,
) => <String, dynamic>{
  'duaId': instance.duaId,
  'text': instance.text,
  'translation': instance.translation,
  'transliteration': instance.transliteration,
  'category': instance.category,
  'similarityScore': instance.similarityScore,
  'matchedKeywords': instance.matchedKeywords,
  'matchReason': instance.matchReason,
  'metadata': instance.metadata,
};

_$PendingQueryImpl _$$PendingQueryImplFromJson(Map<String, dynamic> json) =>
    _$PendingQueryImpl(
      id: json['id'] as String,
      query: json['query'] as String,
      language: json['language'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      context: json['context'] as Map<String, dynamic>,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      status:
          $enumDecodeNullable(_$PendingQueryStatusEnumMap, json['status']) ??
          PendingQueryStatus.pending,
      location: json['location'] as String?,
      fallbackResultId: json['fallbackResultId'] as String?,
    );

Map<String, dynamic> _$$PendingQueryImplToJson(_$PendingQueryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'language': instance.language,
      'timestamp': instance.timestamp.toIso8601String(),
      'context': instance.context,
      'retryCount': instance.retryCount,
      'status': _$PendingQueryStatusEnumMap[instance.status]!,
      'location': instance.location,
      'fallbackResultId': instance.fallbackResultId,
    };

const _$PendingQueryStatusEnumMap = {
  PendingQueryStatus.pending: 'pending',
  PendingQueryStatus.processing: 'processing',
  PendingQueryStatus.completed: 'completed',
  PendingQueryStatus.failed: 'failed',
  PendingQueryStatus.expired: 'expired',
};

_$FallbackTemplateImpl _$$FallbackTemplateImplFromJson(
  Map<String, dynamic> json,
) => _$FallbackTemplateImpl(
  id: json['id'] as String,
  category: json['category'] as String,
  language: json['language'] as String,
  template: json['template'] as String,
  keywords:
      (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
  priority: (json['priority'] as num).toDouble(),
  variations: json['variations'] as Map<String, dynamic>? ?? const {},
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$FallbackTemplateImplToJson(
  _$FallbackTemplateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'language': instance.language,
  'template': instance.template,
  'keywords': instance.keywords,
  'priority': instance.priority,
  'variations': instance.variations,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$OfflineSyncStatusImpl _$$OfflineSyncStatusImplFromJson(
  Map<String, dynamic> json,
) => _$OfflineSyncStatusImpl(
  lastSync: DateTime.parse(json['lastSync'] as String),
  totalEmbeddings: (json['totalEmbeddings'] as num).toInt(),
  pendingQueries: (json['pendingQueries'] as num).toInt(),
  availableLanguages:
      (json['availableLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  availableCategories:
      (json['availableCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  isSyncing: json['isSyncing'] as bool? ?? false,
  nextScheduledSync:
      json['nextScheduledSync'] == null
          ? null
          : DateTime.parse(json['nextScheduledSync'] as String),
  lastError: json['lastError'] as String?,
);

Map<String, dynamic> _$$OfflineSyncStatusImplToJson(
  _$OfflineSyncStatusImpl instance,
) => <String, dynamic>{
  'lastSync': instance.lastSync.toIso8601String(),
  'totalEmbeddings': instance.totalEmbeddings,
  'pendingQueries': instance.pendingQueries,
  'availableLanguages': instance.availableLanguages,
  'availableCategories': instance.availableCategories,
  'isSyncing': instance.isSyncing,
  'nextScheduledSync': instance.nextScheduledSync?.toIso8601String(),
  'lastError': instance.lastError,
};
