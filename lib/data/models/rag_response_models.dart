import '../../domain/entities/dua_entity.dart';

/// Response model for RAG search queries
class RagSearchResponse {
  final List<DuaRecommendation> recommendations;
  final double confidence;
  final String reasoning;
  final String queryId;
  final Map<String, dynamic>? metadata;

  const RagSearchResponse({
    required this.recommendations,
    required this.confidence,
    required this.reasoning,
    required this.queryId,
    this.metadata,
  });

  factory RagSearchResponse.fromJson(Map<String, dynamic> json) {
    return RagSearchResponse(
      recommendations: (json['recommendations'] as List)
          .map((item) => DuaRecommendation.fromJson(item))
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      reasoning: json['reasoning'] as String,
      queryId: json['query_id'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'recommendations': recommendations.map((r) => r.toJson()).toList(),
        'confidence': confidence,
        'reasoning': reasoning,
        'query_id': queryId,
        if (metadata != null) 'metadata': metadata,
      };
}

/// Individual Du'a recommendation with context
class DuaRecommendation {
  final DuaEntity dua;
  final double relevanceScore;
  final String matchReason;
  final List<String> highlightedKeywords;
  final Map<String, dynamic>? context;

  const DuaRecommendation({
    required this.dua,
    required this.relevanceScore,
    required this.matchReason,
    required this.highlightedKeywords,
    this.context,
  });

  factory DuaRecommendation.fromJson(Map<String, dynamic> json) {
    return DuaRecommendation(
      dua: DuaEntity.fromJson(json['dua']),
      relevanceScore: (json['relevance_score'] as num).toDouble(),
      matchReason: json['match_reason'] as String,
      highlightedKeywords:
          (json['highlighted_keywords'] as List).cast<String>(),
      context: json['context'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'dua': dua.toJson(),
        'relevance_score': relevanceScore,
        'match_reason': matchReason,
        'highlighted_keywords': highlightedKeywords,
        if (context != null) 'context': context,
      };
}

/// Detailed Du'a response with audio and metadata
class DetailedDuaResponse {
  final DuaEntity dua;
  final AudioData? audio;
  final List<Translation> translations;
  final List<String> tags;
  final UsageStats? usageStats;
  final List<RelatedDua> relatedDuas;
  final Map<String, dynamic>? metadata;

  const DetailedDuaResponse({
    required this.dua,
    this.audio,
    required this.translations,
    required this.tags,
    this.usageStats,
    required this.relatedDuas,
    this.metadata,
  });

  factory DetailedDuaResponse.fromJson(Map<String, dynamic> json) {
    return DetailedDuaResponse(
      dua: DuaEntity.fromJson(json['dua']),
      audio: json['audio'] != null ? AudioData.fromJson(json['audio']) : null,
      translations: (json['translations'] as List)
          .map((item) => Translation.fromJson(item))
          .toList(),
      tags: (json['tags'] as List).cast<String>(),
      usageStats: json['usage_stats'] != null
          ? UsageStats.fromJson(json['usage_stats'])
          : null,
      relatedDuas: (json['related_duas'] as List)
          .map((item) => RelatedDua.fromJson(item))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'dua': dua.toJson(),
        if (audio != null) 'audio': audio!.toJson(),
        'translations': translations.map((t) => t.toJson()).toList(),
        'tags': tags,
        if (usageStats != null) 'usage_stats': usageStats!.toJson(),
        'related_duas': relatedDuas.map((r) => r.toJson()).toList(),
        if (metadata != null) 'metadata': metadata,
      };
}

/// Audio data for Du'a recitations
class AudioData {
  final String url;
  final String format;
  final int durationMs;
  final String quality;
  final String reciter;
  final int sizeBytes;
  final String? downloadUrl;

  const AudioData({
    required this.url,
    required this.format,
    required this.durationMs,
    required this.quality,
    required this.reciter,
    required this.sizeBytes,
    this.downloadUrl,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) {
    return AudioData(
      url: json['url'] as String,
      format: json['format'] as String,
      durationMs: json['duration_ms'] as int,
      quality: json['quality'] as String,
      reciter: json['reciter'] as String,
      sizeBytes: json['size_bytes'] as int,
      downloadUrl: json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'format': format,
        'duration_ms': durationMs,
        'quality': quality,
        'reciter': reciter,
        'size_bytes': sizeBytes,
        if (downloadUrl != null) 'download_url': downloadUrl,
      };
}

/// Translation data for Du'as
class Translation {
  final String language;
  final String text;
  final String? transliteration;
  final String translator;
  final double? confidence;

  const Translation({
    required this.language,
    required this.text,
    this.transliteration,
    required this.translator,
    this.confidence,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      language: json['language'] as String,
      text: json['text'] as String,
      transliteration: json['transliteration'] as String?,
      translator: json['translator'] as String,
      confidence: json['confidence']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'language': language,
        'text': text,
        if (transliteration != null) 'transliteration': transliteration,
        'translator': translator,
        if (confidence != null) 'confidence': confidence,
      };
}

/// Usage statistics for Du'as
class UsageStats {
  final int totalViews;
  final int totalFavorites;
  final int weeklyViews;
  final double averageRating;
  final int ratingCount;

  const UsageStats({
    required this.totalViews,
    required this.totalFavorites,
    required this.weeklyViews,
    required this.averageRating,
    required this.ratingCount,
  });

  factory UsageStats.fromJson(Map<String, dynamic> json) {
    return UsageStats(
      totalViews: json['total_views'] as int,
      totalFavorites: json['total_favorites'] as int,
      weeklyViews: json['weekly_views'] as int,
      averageRating: (json['average_rating'] as num).toDouble(),
      ratingCount: json['rating_count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_views': totalViews,
        'total_favorites': totalFavorites,
        'weekly_views': weeklyViews,
        'average_rating': averageRating,
        'rating_count': ratingCount,
      };
}

/// Related Du'a information
class RelatedDua {
  final String duaId;
  final String title;
  final double relevanceScore;
  final String relation;

  const RelatedDua({
    required this.duaId,
    required this.title,
    required this.relevanceScore,
    required this.relation,
  });

  factory RelatedDua.fromJson(Map<String, dynamic> json) {
    return RelatedDua(
      duaId: json['dua_id'] as String,
      title: json['title'] as String,
      relevanceScore: (json['relevance_score'] as num).toDouble(),
      relation: json['relation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'dua_id': duaId,
        'title': title,
        'relevance_score': relevanceScore,
        'relation': relation,
      };
}

/// Feedback submission response
class FeedbackResponse {
  final bool success;
  final String message;
  final String feedbackId;
  final DateTime timestamp;

  const FeedbackResponse({
    required this.success,
    required this.message,
    required this.feedbackId,
    required this.timestamp,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      feedbackId: json['feedback_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'feedback_id': feedbackId,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Popular Du'as response with pagination
class PopularDuasResponse {
  final List<PopularDuaItem> duas;
  final PaginationInfo pagination;
  final String timeframe;
  final Map<String, dynamic>? metadata;

  const PopularDuasResponse({
    required this.duas,
    required this.pagination,
    required this.timeframe,
    this.metadata,
  });

  factory PopularDuasResponse.fromJson(Map<String, dynamic> json) {
    return PopularDuasResponse(
      duas: (json['duas'] as List)
          .map((item) => PopularDuaItem.fromJson(item))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
      timeframe: json['timeframe'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'duas': duas.map((d) => d.toJson()).toList(),
        'pagination': pagination.toJson(),
        'timeframe': timeframe,
        if (metadata != null) 'metadata': metadata,
      };
}

/// Popular Du'a item with trend data
class PopularDuaItem {
  final DuaEntity dua;
  final int rank;
  final TrendData trendData;
  final String category;

  const PopularDuaItem({
    required this.dua,
    required this.rank,
    required this.trendData,
    required this.category,
  });

  factory PopularDuaItem.fromJson(Map<String, dynamic> json) {
    return PopularDuaItem(
      dua: DuaEntity.fromJson(json['dua']),
      rank: json['rank'] as int,
      trendData: TrendData.fromJson(json['trend_data']),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'dua': dua.toJson(),
        'rank': rank,
        'trend_data': trendData.toJson(),
        'category': category,
      };
}

/// Trend data for popular Du'as
class TrendData {
  final int views;
  final double growthRate;
  final String trendDirection;
  final Map<String, int>? dailyViews;

  const TrendData({
    required this.views,
    required this.growthRate,
    required this.trendDirection,
    this.dailyViews,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      views: json['views'] as int,
      growthRate: (json['growth_rate'] as num).toDouble(),
      trendDirection: json['trend_direction'] as String,
      dailyViews: json['daily_views']?.cast<String, int>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'views': views,
        'growth_rate': growthRate,
        'trend_direction': trendDirection,
        if (dailyViews != null) 'daily_views': dailyViews,
      };
}

/// Pagination information
class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
      totalItems: json['total_items'] as int,
      itemsPerPage: json['items_per_page'] as int,
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'total_pages': totalPages,
        'total_items': totalItems,
        'items_per_page': itemsPerPage,
        'has_next': hasNext,
        'has_previous': hasPrevious,
      };
}

/// Personalization update response
class PersonalizationResponse {
  final bool success;
  final String message;
  final PersonalizationProfile profile;
  final DateTime updatedAt;

  const PersonalizationResponse({
    required this.success,
    required this.message,
    required this.profile,
    required this.updatedAt,
  });

  factory PersonalizationResponse.fromJson(Map<String, dynamic> json) {
    return PersonalizationResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      profile: PersonalizationProfile.fromJson(json['profile']),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'profile': profile.toJson(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

/// User personalization profile
class PersonalizationProfile {
  final List<String> preferredCategories;
  final List<String> preferredLanguages;
  final Map<String, double> topicPreferences;
  final Map<String, dynamic>? demographics;
  final Map<String, dynamic>? customPreferences;

  const PersonalizationProfile({
    required this.preferredCategories,
    required this.preferredLanguages,
    required this.topicPreferences,
    this.demographics,
    this.customPreferences,
  });

  factory PersonalizationProfile.fromJson(Map<String, dynamic> json) {
    return PersonalizationProfile(
      preferredCategories:
          (json['preferred_categories'] as List).cast<String>(),
      preferredLanguages: (json['preferred_languages'] as List).cast<String>(),
      topicPreferences:
          (json['topic_preferences'] as Map).cast<String, double>(),
      demographics: json['demographics'] as Map<String, dynamic>?,
      customPreferences: json['custom_preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'preferred_categories': preferredCategories,
        'preferred_languages': preferredLanguages,
        'topic_preferences': topicPreferences,
        if (demographics != null) 'demographics': demographics,
        if (customPreferences != null) 'custom_preferences': customPreferences,
      };
}

/// Offline cache response
class OfflineCacheResponse {
  final List<OfflineDuaItem> duas;
  final List<AudioCacheItem> audioFiles;
  final String syncTimestamp;
  final CacheMetadata metadata;

  const OfflineCacheResponse({
    required this.duas,
    required this.audioFiles,
    required this.syncTimestamp,
    required this.metadata,
  });

  factory OfflineCacheResponse.fromJson(Map<String, dynamic> json) {
    return OfflineCacheResponse(
      duas: (json['duas'] as List)
          .map((item) => OfflineDuaItem.fromJson(item))
          .toList(),
      audioFiles: (json['audio_files'] as List)
          .map((item) => AudioCacheItem.fromJson(item))
          .toList(),
      syncTimestamp: json['sync_timestamp'] as String,
      metadata: CacheMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
        'duas': duas.map((d) => d.toJson()).toList(),
        'audio_files': audioFiles.map((a) => a.toJson()).toList(),
        'sync_timestamp': syncTimestamp,
        'metadata': metadata.toJson(),
      };
}

/// Offline Du'a item
class OfflineDuaItem {
  final DuaEntity dua;
  final int priority;
  final List<String> offlineLanguages;
  final bool hasAudio;

  const OfflineDuaItem({
    required this.dua,
    required this.priority,
    required this.offlineLanguages,
    required this.hasAudio,
  });

  factory OfflineDuaItem.fromJson(Map<String, dynamic> json) {
    return OfflineDuaItem(
      dua: DuaEntity.fromJson(json['dua']),
      priority: json['priority'] as int,
      offlineLanguages: (json['offline_languages'] as List).cast<String>(),
      hasAudio: json['has_audio'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'dua': dua.toJson(),
        'priority': priority,
        'offline_languages': offlineLanguages,
        'has_audio': hasAudio,
      };
}

/// Audio cache item for offline use
class AudioCacheItem {
  final String duaId;
  final String url;
  final String downloadUrl;
  final int sizeBytes;
  final String quality;
  final String format;

  const AudioCacheItem({
    required this.duaId,
    required this.url,
    required this.downloadUrl,
    required this.sizeBytes,
    required this.quality,
    required this.format,
  });

  factory AudioCacheItem.fromJson(Map<String, dynamic> json) {
    return AudioCacheItem(
      duaId: json['dua_id'] as String,
      url: json['url'] as String,
      downloadUrl: json['download_url'] as String,
      sizeBytes: json['size_bytes'] as int,
      quality: json['quality'] as String,
      format: json['format'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'dua_id': duaId,
        'url': url,
        'download_url': downloadUrl,
        'size_bytes': sizeBytes,
        'quality': quality,
        'format': format,
      };
}

/// Cache metadata
class CacheMetadata {
  final int totalSize;
  final int itemCount;
  final DateTime expiry;
  final String version;

  const CacheMetadata({
    required this.totalSize,
    required this.itemCount,
    required this.expiry,
    required this.version,
  });

  factory CacheMetadata.fromJson(Map<String, dynamic> json) {
    return CacheMetadata(
      totalSize: json['total_size'] as int,
      itemCount: json['item_count'] as int,
      expiry: DateTime.parse(json['expiry'] as String),
      version: json['version'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_size': totalSize,
        'item_count': itemCount,
        'expiry': expiry.toIso8601String(),
        'version': version,
      };
}
