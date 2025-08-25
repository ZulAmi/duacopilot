import 'package:freezed_annotation/freezed_annotation.dart';

part 'offline_search_models.freezed.dart';
part 'offline_search_models.g.dart';

/// Represents an embedded vector for semantic similarity
@freezed
class DuaEmbedding with _$DuaEmbedding {
  const factory DuaEmbedding({
    required String id,
    required String duaId,
    required String text,
    required String language,
    required List<double> vector,
    required String category,
    @Default([]) List<String> keywords,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DuaEmbedding;

  factory DuaEmbedding.fromJson(Map<String, dynamic> json) => _$DuaEmbeddingFromJson(json);
}

/// Local search query with embedding
@freezed
class LocalSearchQuery with _$LocalSearchQuery {
  const factory LocalSearchQuery({
    required String id,
    required String query,
    required String language,
    required List<double> embedding,
    required DateTime timestamp,
    @Default({}) Map<String, dynamic> context,
    String? location,
  }) = _LocalSearchQuery;

  factory LocalSearchQuery.fromJson(Map<String, dynamic> json) => _$LocalSearchQueryFromJson(json);
}

/// Offline search result with quality indicators
@freezed
class OfflineSearchResult with _$OfflineSearchResult {
  const factory OfflineSearchResult({
    required String queryId,
    required List<OfflineDuaMatch> matches,
    required double confidence,
    required SearchQuality quality,
    required String reasoning,
    required DateTime timestamp,
    @Default(false) bool isFromCache,
    @Default({}) Map<String, dynamic> metadata,
  }) = _OfflineSearchResult;

  factory OfflineSearchResult.fromJson(Map<String, dynamic> json) => _$OfflineSearchResultFromJson(json);
}

/// Individual offline Du'a match
@freezed
class OfflineDuaMatch with _$OfflineDuaMatch {
  const factory OfflineDuaMatch({
    required String duaId,
    required String text,
    required String translation,
    required String transliteration,
    required String category,
    required double similarityScore,
    required List<String> matchedKeywords,
    required String matchReason,
    @Default({}) Map<String, dynamic> metadata,
  }) = _OfflineDuaMatch;

  factory OfflineDuaMatch.fromJson(Map<String, dynamic> json) => _$OfflineDuaMatchFromJson(json);
}

/// Queue item for pending online queries
@freezed
class PendingQuery with _$PendingQuery {
  const factory PendingQuery({
    required String id,
    required String query,
    required String language,
    required DateTime timestamp,
    required Map<String, dynamic> context,
    @Default(0) int retryCount,
    @Default(PendingQueryStatus.pending) PendingQueryStatus status,
    String? location,
    String? fallbackResultId,
  }) = _PendingQuery;

  factory PendingQuery.fromJson(Map<String, dynamic> json) => _$PendingQueryFromJson(json);
}

/// Fallback response template for offline use
@freezed
class FallbackTemplate with _$FallbackTemplate {
  const factory FallbackTemplate({
    required String id,
    required String category,
    required String language,
    required String template,
    required List<String> keywords,
    required double priority,
    @Default({}) Map<String, dynamic> variations,
    required DateTime createdAt,
  }) = _FallbackTemplate;

  factory FallbackTemplate.fromJson(Map<String, dynamic> json) => _$FallbackTemplateFromJson(json);
}

/// Search quality indicators
enum SearchQuality {
  @JsonValue('high')
  high, // Online RAG with full context

  @JsonValue('medium')
  medium, // Local semantic search with good match

  @JsonValue('low')
  low, // Fallback template or poor match

  @JsonValue('cached')
  cached, // Previously cached online result
}

/// Status of pending queries
enum PendingQueryStatus {
  @JsonValue('pending')
  pending,

  @JsonValue('processing')
  processing,

  @JsonValue('completed')
  completed,

  @JsonValue('failed')
  failed,

  @JsonValue('expired')
  expired,
}

/// Sync status for offline data
@freezed
class OfflineSyncStatus with _$OfflineSyncStatus {
  const factory OfflineSyncStatus({
    required DateTime lastSync,
    required int totalEmbeddings,
    required int pendingQueries,
    required List<String> availableLanguages,
    required List<String> availableCategories,
    @Default(false) bool isSyncing,
    DateTime? nextScheduledSync,
    String? lastError,
  }) = _OfflineSyncStatus;

  factory OfflineSyncStatus.fromJson(Map<String, dynamic> json) => _$OfflineSyncStatusFromJson(json);
}
