import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/rag_response.dart';
import '../../domain/entities/dua_entity.dart';

/// RAG API call states for AsyncNotifierProvider
enum RagApiState { idle, loading, success, error, retrying }

/// Comprehensive RAG response data model
@immutable
class RagStateData {
  final RagApiState apiState;
  final RagResponse? response;
  final String? error;
  final String? currentQuery;
  final DateTime? lastUpdated;
  final int retryCount;
  final bool isFromCache;
  final Map<String, dynamic>? metadata;
  final List<DuaEntity>? filteredResults;
  final double? confidence;

  const RagStateData({
    this.apiState = RagApiState.idle,
    this.response,
    this.error,
    this.currentQuery,
    this.lastUpdated,
    this.retryCount = 0,
    this.isFromCache = false,
    this.metadata,
    this.filteredResults,
    this.confidence,
  });

  RagStateData copyWith({
    RagApiState? apiState,
    RagResponse? response,
    String? error,
    String? currentQuery,
    DateTime? lastUpdated,
    int? retryCount,
    bool? isFromCache,
    Map<String, dynamic>? metadata,
    List<DuaEntity>? filteredResults,
    double? confidence,
  }) {
    return RagStateData(
      apiState: apiState ?? this.apiState,
      response: response ?? this.response,
      error: error ?? this.error,
      currentQuery: currentQuery ?? this.currentQuery,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      retryCount: retryCount ?? this.retryCount,
      isFromCache: isFromCache ?? this.isFromCache,
      metadata: metadata ?? this.metadata,
      filteredResults: filteredResults ?? this.filteredResults,
      confidence: confidence ?? this.confidence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiState': apiState.index,
      'response': response != null ? _ragResponseToJson(response!) : null,
      'error': error,
      'currentQuery': currentQuery,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'retryCount': retryCount,
      'isFromCache': isFromCache,
      'metadata': metadata,
      'confidence': confidence,
    };
  }

  factory RagStateData.fromJson(Map<String, dynamic> json) {
    return RagStateData(
      apiState: RagApiState.values[json['apiState'] ?? 0],
      response:
          json['response'] != null
              ? _ragResponseFromJson(json['response'])
              : null,
      error: json['error'],
      currentQuery: json['currentQuery'],
      lastUpdated:
          json['lastUpdated'] != null
              ? DateTime.parse(json['lastUpdated'])
              : null,
      retryCount: json['retryCount'] ?? 0,
      isFromCache: json['isFromCache'] ?? false,
      metadata: json['metadata'],
      confidence: json['confidence']?.toDouble(),
    );
  }

  static Map<String, dynamic> _ragResponseToJson(RagResponse response) {
    return {
      'id': response.id,
      'query': response.query,
      'response': response.response,
      'timestamp': response.timestamp.toIso8601String(),
      'responseTime': response.responseTime,
      'metadata': response.metadata,
      'sources': response.sources,
      'confidence': response.confidence,
      'sessionId': response.sessionId,
      'tokensUsed': response.tokensUsed,
      'model': response.model,
    };
  }

  static RagResponse _ragResponseFromJson(Map<String, dynamic> json) {
    return RagResponse(
      id: json['id'],
      query: json['query'],
      response: json['response'],
      timestamp: DateTime.parse(json['timestamp']),
      responseTime: json['responseTime'],
      metadata: json['metadata'],
      sources: json['sources'],
      confidence: json['confidence']?.toDouble(),
      sessionId: json['sessionId'],
      tokensUsed: json['tokensUsed'],
      model: json['model'],
    );
  }

  bool get isLoading =>
      apiState == RagApiState.loading || apiState == RagApiState.retrying;
  bool get hasError => apiState == RagApiState.error;
  bool get hasData => response != null;
  bool get isSuccess => apiState == RagApiState.success;
}

/// Cache configuration for RAG responses
class RagCacheConfig {
  final Duration maxAge;
  final int maxEntries;
  final bool enablePersistence;
  final String cacheKey;

  const RagCacheConfig({
    this.maxAge = const Duration(hours: 1),
    this.maxEntries = 100,
    this.enablePersistence = true,
    this.cacheKey = 'rag_cache',
  });
}

/// Cached RAG response entry
@immutable
class CachedRagEntry {
  final String query;
  final RagResponse response;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const CachedRagEntry({
    required this.query,
    required this.response,
    required this.timestamp,
    this.metadata,
  });

  bool isExpired(Duration maxAge) {
    return DateTime.now().difference(timestamp) > maxAge;
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'response': RagStateData._ragResponseToJson(response),
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory CachedRagEntry.fromJson(Map<String, dynamic> json) {
    return CachedRagEntry(
      query: json['query'],
      response: RagStateData._ragResponseFromJson(json['response']),
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }
}

/// WebSocket connection state for real-time updates
enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

@immutable
class WebSocketState {
  final WebSocketConnectionState connectionState;
  final String? error;
  final DateTime? lastConnected;
  final DateTime? lastDisconnected;
  final int reconnectAttempts;
  final List<Map<String, dynamic>> recentMessages;

  const WebSocketState({
    this.connectionState = WebSocketConnectionState.disconnected,
    this.error,
    this.lastConnected,
    this.lastDisconnected,
    this.reconnectAttempts = 0,
    this.recentMessages = const [],
  });

  WebSocketState copyWith({
    WebSocketConnectionState? connectionState,
    String? error,
    DateTime? lastConnected,
    DateTime? lastDisconnected,
    int? reconnectAttempts,
    List<Map<String, dynamic>>? recentMessages,
  }) {
    return WebSocketState(
      connectionState: connectionState ?? this.connectionState,
      error: error ?? this.error,
      lastConnected: lastConnected ?? this.lastConnected,
      lastDisconnected: lastDisconnected ?? this.lastDisconnected,
      reconnectAttempts: reconnectAttempts ?? this.reconnectAttempts,
      recentMessages: recentMessages ?? this.recentMessages,
    );
  }

  bool get isConnected => connectionState == WebSocketConnectionState.connected;
}

/// Filter configuration for RAG results
@immutable
class RagFilterConfig {
  final double minConfidence;
  final List<String> includeCategories;
  final List<String> excludeCategories;
  final bool sortByRelevance;
  final int maxResults;
  final Map<String, dynamic> customFilters;
  final int? maxResponseLength;
  final List<String> languageFilter;
  final List<String> contentTypeFilter;
  final List<String> requiredKeywords;
  final List<String> blacklistedKeywords;
  final bool enableSourceFiltering;

  const RagFilterConfig({
    this.minConfidence = 0.0,
    this.includeCategories = const [],
    this.excludeCategories = const [],
    this.sortByRelevance = true,
    this.maxResults = 50,
    this.customFilters = const {},
    this.maxResponseLength,
    this.languageFilter = const [],
    this.contentTypeFilter = const [],
    this.requiredKeywords = const [],
    this.blacklistedKeywords = const [],
    this.enableSourceFiltering = false,
  });

  RagFilterConfig copyWith({
    double? minConfidence,
    List<String>? includeCategories,
    List<String>? excludeCategories,
    bool? sortByRelevance,
    int? maxResults,
    Map<String, dynamic>? customFilters,
    int? maxResponseLength,
    List<String>? languageFilter,
    List<String>? contentTypeFilter,
    List<String>? requiredKeywords,
    List<String>? blacklistedKeywords,
    bool? enableSourceFiltering,
  }) {
    return RagFilterConfig(
      minConfidence: minConfidence ?? this.minConfidence,
      includeCategories: includeCategories ?? this.includeCategories,
      excludeCategories: excludeCategories ?? this.excludeCategories,
      sortByRelevance: sortByRelevance ?? this.sortByRelevance,
      maxResults: maxResults ?? this.maxResults,
      customFilters: customFilters ?? this.customFilters,
      maxResponseLength: maxResponseLength ?? this.maxResponseLength,
      languageFilter: languageFilter ?? this.languageFilter,
      contentTypeFilter: contentTypeFilter ?? this.contentTypeFilter,
      requiredKeywords: requiredKeywords ?? this.requiredKeywords,
      blacklistedKeywords: blacklistedKeywords ?? this.blacklistedKeywords,
      enableSourceFiltering:
          enableSourceFiltering ?? this.enableSourceFiltering,
    );
  }
}

/// State persistence utility
class RagStatePersistence {
  static const String _stateKey = 'rag_state_persistence';
  static const String _cacheKey = 'rag_cache_persistence';
  static const String _configKey = 'rag_config_persistence';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  /// Save current RAG state to persistent storage
  static Future<void> saveState(RagStateData state) async {
    try {
      final prefs = await _prefs;
      final stateJson = json.encode(state.toJson());
      await prefs.setString(_stateKey, stateJson);

      if (kDebugMode) {
        debugPrint('RAG State saved: ${state.currentQuery}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save RAG state: $e');
      }
    }
  }

  /// Load RAG state from persistent storage
  static Future<RagStateData?> loadState() async {
    try {
      final prefs = await _prefs;
      final stateJson = prefs.getString(_stateKey);

      if (stateJson != null) {
        final stateMap = json.decode(stateJson) as Map<String, dynamic>;
        return RagStateData.fromJson(stateMap);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load RAG state: $e');
      }
    }
    return null;
  }

  /// Save cache entries to persistent storage
  static Future<void> saveCache(Map<String, CachedRagEntry> cache) async {
    try {
      final prefs = await _prefs;
      final cacheMap = cache.map((key, value) => MapEntry(key, value.toJson()));
      final cacheJson = json.encode(cacheMap);
      await prefs.setString(_cacheKey, cacheJson);

      if (kDebugMode) {
        debugPrint('RAG Cache saved: ${cache.length} entries');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save RAG cache: $e');
      }
    }
  }

  /// Load cache entries from persistent storage
  static Future<Map<String, CachedRagEntry>> loadCache() async {
    try {
      final prefs = await _prefs;
      final cacheJson = prefs.getString(_cacheKey);

      if (cacheJson != null) {
        final cacheMap = json.decode(cacheJson) as Map<String, dynamic>;
        return cacheMap.map(
          (key, value) => MapEntry(key, CachedRagEntry.fromJson(value)),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load RAG cache: $e');
      }
    }
    return {};
  }

  /// Save filter configuration
  static Future<void> saveFilterConfig(RagFilterConfig config) async {
    try {
      final prefs = await _prefs;
      final configMap = {
        'minConfidence': config.minConfidence,
        'includeCategories': config.includeCategories,
        'excludeCategories': config.excludeCategories,
        'sortByRelevance': config.sortByRelevance,
        'maxResults': config.maxResults,
        'customFilters': config.customFilters,
      };
      final configJson = json.encode(configMap);
      await prefs.setString(_configKey, configJson);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save filter config: $e');
      }
    }
  }

  /// Load filter configuration
  static Future<RagFilterConfig?> loadFilterConfig() async {
    try {
      final prefs = await _prefs;
      final configJson = prefs.getString(_configKey);

      if (configJson != null) {
        final configMap = json.decode(configJson) as Map<String, dynamic>;
        return RagFilterConfig(
          minConfidence: configMap['minConfidence']?.toDouble() ?? 0.0,
          includeCategories: List<String>.from(
            configMap['includeCategories'] ?? [],
          ),
          excludeCategories: List<String>.from(
            configMap['excludeCategories'] ?? [],
          ),
          sortByRelevance: configMap['sortByRelevance'] ?? true,
          maxResults: configMap['maxResults'] ?? 50,
          customFilters: Map<String, dynamic>.from(
            configMap['customFilters'] ?? {},
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load filter config: $e');
      }
    }
    return null;
  }

  /// Clear all persisted data
  static Future<void> clearAll() async {
    try {
      final prefs = await _prefs;
      await Future.wait([
        prefs.remove(_stateKey),
        prefs.remove(_cacheKey),
        prefs.remove(_configKey),
      ]);

      if (kDebugMode) {
        debugPrint('All RAG persistent data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to clear persistent data: $e');
      }
    }
  }
}
