import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/rag_api_client.dart';
import '../data/models/rag_response_models.dart';

/// Comprehensive RAG service with caching, offline support, and error handling
class RagService {
  static const String _cachePrefix = 'rag_cache_';
  static const String _offlineCacheKey = 'offline_duas_cache';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 6);
  static const Duration _offlineCacheExpiry = Duration(days: 7);

  final RagApiClient _apiClient;
  final SharedPreferences _prefs;
  final Map<String, RagSearchResponse> _memoryCache = {};
  final StreamController<RagSearchResponse> _searchResultsController =
      StreamController<RagSearchResponse>.broadcast();

  RagService(this._apiClient, this._prefs);

  /// Stream of search results for reactive UI updates
  Stream<RagSearchResponse> get searchResults =>
      _searchResultsController.stream;

  /// Initialize the service and sync offline cache if needed
  Future<void> initialize() async {
    try {
      await _syncOfflineCacheIfNeeded();
    } catch (e) {
      debugPrint('Failed to sync offline cache: $e');
    }
  }

  /// Search for Du'as with intelligent caching and fallback
  Future<RagSearchResponse> searchDuas({
    required String query,
    String language = 'en',
    String? location,
    Map<String, dynamic>? additionalContext,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _generateCacheKey(query, language, location);

    // Check memory cache first
    if (!forceRefresh && _memoryCache.containsKey(cacheKey)) {
      final cachedResponse = _memoryCache[cacheKey]!;
      _searchResultsController.add(cachedResponse);
      return cachedResponse;
    }

    // Check disk cache
    if (!forceRefresh) {
      final cachedResponse = await _getCachedResponse(cacheKey);
      if (cachedResponse != null) {
        _memoryCache[cacheKey] = cachedResponse;
        _searchResultsController.add(cachedResponse);
        return cachedResponse;
      }
    }

    try {
      // Make API request
      final response = await _apiClient.searchDuas(
        query: query,
        language: language,
        location: location,
        additionalContext: additionalContext,
      );

      // Cache the response
      await _cacheResponse(cacheKey, response);
      _memoryCache[cacheKey] = response;
      _searchResultsController.add(response);

      return response;
    } catch (e) {
      // Fallback to offline cache if available
      final offlineResponse = await _getOfflineFallbackResponse(query);
      if (offlineResponse != null) {
        _searchResultsController.add(offlineResponse);
        return offlineResponse;
      }
      rethrow;
    }
  }

  /// Get detailed Du'a information with caching
  Future<DetailedDuaResponse> getDuaDetails(String duaId) async {
    final cacheKey = 'dua_details_$duaId';

    // Check cache first
    final cachedJson = _prefs.getString(cacheKey);
    if (cachedJson != null) {
      final cacheData = json.decode(cachedJson);
      final cacheTime = DateTime.parse(cacheData['cached_at']);

      if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
        return DetailedDuaResponse.fromJson(cacheData['data']);
      }
    }

    try {
      final response = await _apiClient.getDuaById(duaId);

      // Cache the response
      await _prefs.setString(
        cacheKey,
        json.encode({
          'data': response.toJson(),
          'cached_at': DateTime.now().toIso8601String(),
        }),
      );

      return response;
    } catch (e) {
      // Return cached data even if expired in case of network issues
      if (cachedJson != null) {
        final cacheData = json.decode(cachedJson);
        return DetailedDuaResponse.fromJson(cacheData['data']);
      }
      rethrow;
    }
  }

  /// Submit feedback with retry logic
  Future<bool> submitFeedback({
    required String duaId,
    required String queryId,
    required FeedbackType feedbackType,
    double? rating,
    String? comment,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _apiClient.submitFeedback(
        duaId: duaId,
        queryId: queryId,
        feedbackType: feedbackType,
        rating: rating,
        comment: comment,
        metadata: metadata,
      );
      return response.success;
    } catch (e) {
      // Queue feedback for later submission if offline
      await _queueOfflineFeedback({
        'dua_id': duaId,
        'query_id': queryId,
        'feedback_type': feedbackType.name,
        'rating': rating,
        'comment': comment,
        'metadata': metadata,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true; // Return true to not disrupt user experience
    }
  }

  /// Get popular Du'as with pagination and caching
  Future<PopularDuasResponse> getPopularDuas({
    int page = 1,
    int limit = 20,
    String? category,
    String? timeframe,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
        'popular_duas_${page}_${limit}_${category ?? 'all'}_${timeframe ?? 'week'}';

    if (!forceRefresh) {
      final cachedResponse = await _getCachedPopularDuas(cacheKey);
      if (cachedResponse != null) {
        return cachedResponse;
      }
    }

    try {
      final response = await _apiClient.getPopularDuas(
        page: page,
        limit: limit,
        category: category,
        timeframe: timeframe,
      );

      await _cachePopularDuas(cacheKey, response);
      return response;
    } catch (e) {
      // Return cached data if available
      final cachedResponse = await _getCachedPopularDuas(cacheKey);
      if (cachedResponse != null) {
        return cachedResponse;
      }
      rethrow;
    }
  }

  /// Update user personalization preferences
  Future<bool> updatePersonalization({
    List<String>? preferredCategories,
    List<String>? preferredLanguages,
    Map<String, double>? topicPreferences,
    UserDemographics? demographics,
    Map<String, dynamic>? customPreferences,
  }) async {
    try {
      final response = await _apiClient.updatePersonalization(
        preferredCategories: preferredCategories,
        preferredLanguages: preferredLanguages,
        topicPreferences: topicPreferences,
        demographics: demographics,
        customPreferences: customPreferences,
      );

      // Cache user preferences locally
      await _cacheUserPreferences(response.profile);
      return response.success;
    } catch (e) {
      // Queue preferences for later sync
      await _queuePreferencesUpdate({
        'preferred_categories': preferredCategories,
        'preferred_languages': preferredLanguages,
        'topic_preferences': topicPreferences,
        'demographics': demographics?.toJson(),
        'custom_preferences': customPreferences,
      });
      return true;
    }
  }

  /// Sync offline cache with server
  Future<void> syncOfflineCache({bool force = false}) async {
    final lastSync = _prefs.getString(_lastSyncKey);
    final shouldSync =
        force ||
        lastSync == null ||
        DateTime.now().difference(DateTime.parse(lastSync)) >
            _offlineCacheExpiry;

    if (!shouldSync) return;

    try {
      final response = await _apiClient.getOfflineCache(
        lastSyncTimestamp: lastSync,
      );

      await _saveOfflineCache(response);
      await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      // Process queued feedback and preferences
      await _processQueuedFeedback();
      await _processQueuedPreferences();
    } catch (e) {
      debugPrint('Offline cache sync failed: $e');
      rethrow;
    }
  }

  /// Clear all caches
  Future<void> clearCache() async {
    _memoryCache.clear();

    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    final memorySize = _memoryCache.length;
    final diskSize = keys.length;

    return {
      'memory_cache_size': memorySize,
      'disk_cache_size': diskSize,
      'last_sync': _prefs.getString(_lastSyncKey),
      'cache_keys': keys.toList(),
    };
  }

  /// Check service health
  Future<bool> checkHealth() async {
    try {
      return await _apiClient.healthCheck();
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _searchResultsController.close();
    _apiClient.dispose();
  }

  // Private helper methods

  String _generateCacheKey(String query, String language, String? location) {
    final locationPart = location != null ? '_$location' : '';
    return '${_cachePrefix}search_${query.hashCode}_$language$locationPart';
  }

  Future<RagSearchResponse?> _getCachedResponse(String cacheKey) async {
    final cachedJson = _prefs.getString(cacheKey);
    if (cachedJson == null) return null;

    try {
      final cacheData = json.decode(cachedJson);
      final cacheTime = DateTime.parse(cacheData['cached_at']);

      if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
        return RagSearchResponse.fromJson(cacheData['data']);
      }
    } catch (e) {
      debugPrint('Error reading cache: $e');
    }

    return null;
  }

  Future<void> _cacheResponse(
    String cacheKey,
    RagSearchResponse response,
  ) async {
    try {
      final cacheData = {
        'data': response.toJson(),
        'cached_at': DateTime.now().toIso8601String(),
      };
      await _prefs.setString(cacheKey, json.encode(cacheData));
    } catch (e) {
      debugPrint('Error caching response: $e');
    }
  }

  Future<RagSearchResponse?> _getOfflineFallbackResponse(String query) async {
    final offlineJson = _prefs.getString(_offlineCacheKey);
    if (offlineJson == null) return null;

    try {
      final offlineData = json.decode(offlineJson);
      final offlineCache = OfflineCacheResponse.fromJson(offlineData);

      // Simple keyword matching for offline search
      final matchingDuas =
          offlineCache.duas.where((item) {
            final duaText =
                '${item.dua.arabicText} ${item.dua.translation} ${item.dua.transliteration}'
                    .toLowerCase();
            return query
                .toLowerCase()
                .split(' ')
                .any((word) => duaText.contains(word));
          }).toList();

      if (matchingDuas.isNotEmpty) {
        final recommendations =
            matchingDuas
                .take(5)
                .map(
                  (item) => DuaRecommendation(
                    dua: item.dua,
                    relevanceScore: 0.5, // Lower confidence for offline results
                    matchReason: 'offline_keyword_match',
                    highlightedKeywords: [],
                  ),
                )
                .toList();

        return RagSearchResponse(
          recommendations: recommendations,
          confidence: 0.5,
          reasoning: 'offline_fallback',
          queryId: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
    } catch (e) {
      debugPrint('Error processing offline fallback: $e');
    }

    return null;
  }

  Future<void> _syncOfflineCacheIfNeeded() async {
    try {
      await syncOfflineCache();
    } catch (e) {
      debugPrint('Initial cache sync failed: $e');
    }
  }

  Future<PopularDuasResponse?> _getCachedPopularDuas(String cacheKey) async {
    final cachedJson = _prefs.getString(cacheKey);
    if (cachedJson == null) return null;

    try {
      final cacheData = json.decode(cachedJson);
      final cacheTime = DateTime.parse(cacheData['cached_at']);

      if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
        return PopularDuasResponse.fromJson(cacheData['data']);
      }
    } catch (e) {
      debugPrint('Error reading popular duas cache: $e');
    }

    return null;
  }

  Future<void> _cachePopularDuas(
    String cacheKey,
    PopularDuasResponse response,
  ) async {
    try {
      final cacheData = {
        'data': response.toJson(),
        'cached_at': DateTime.now().toIso8601String(),
      };
      await _prefs.setString(cacheKey, json.encode(cacheData));
    } catch (e) {
      debugPrint('Error caching popular duas: $e');
    }
  }

  Future<void> _saveOfflineCache(OfflineCacheResponse response) async {
    try {
      await _prefs.setString(_offlineCacheKey, json.encode(response.toJson()));
    } catch (e) {
      debugPrint('Error saving offline cache: $e');
    }
  }

  Future<void> _queueOfflineFeedback(Map<String, dynamic> feedback) async {
    try {
      final queueKey = 'queued_feedback';
      final existing = _prefs.getStringList(queueKey) ?? [];
      existing.add(json.encode(feedback));
      await _prefs.setStringList(queueKey, existing);
    } catch (e) {
      debugPrint('Error queuing feedback: $e');
    }
  }

  Future<void> _queuePreferencesUpdate(Map<String, dynamic> preferences) async {
    try {
      await _prefs.setString('queued_preferences', json.encode(preferences));
    } catch (e) {
      debugPrint('Error queuing preferences: $e');
    }
  }

  Future<void> _processQueuedFeedback() async {
    try {
      final queueKey = 'queued_feedback';
      final queued = _prefs.getStringList(queueKey) ?? [];

      for (final feedbackJson in queued) {
        final feedback = json.decode(feedbackJson);
        try {
          await _apiClient.submitFeedback(
            duaId: feedback['dua_id'],
            queryId: feedback['query_id'],
            feedbackType: FeedbackType.values.firstWhere(
              (e) => e.name == feedback['feedback_type'],
            ),
            rating: feedback['rating']?.toDouble(),
            comment: feedback['comment'],
            metadata: feedback['metadata'],
          );
        } catch (e) {
          debugPrint('Failed to submit queued feedback: $e');
        }
      }

      await _prefs.remove(queueKey);
    } catch (e) {
      debugPrint('Error processing queued feedback: $e');
    }
  }

  Future<void> _processQueuedPreferences() async {
    try {
      final queuedJson = _prefs.getString('queued_preferences');
      if (queuedJson == null) return;

      final preferences = json.decode(queuedJson);

      await _apiClient.updatePersonalization(
        preferredCategories:
            preferences['preferred_categories']?.cast<String>(),
        preferredLanguages: preferences['preferred_languages']?.cast<String>(),
        topicPreferences:
            preferences['topic_preferences']?.cast<String, double>(),
        demographics:
            preferences['demographics'] != null
                ? UserDemographics.fromJson(preferences['demographics'])
                : null,
        customPreferences: preferences['custom_preferences'],
      );

      await _prefs.remove('queued_preferences');
    } catch (e) {
      debugPrint('Error processing queued preferences: $e');
    }
  }

  Future<void> _cacheUserPreferences(PersonalizationProfile profile) async {
    try {
      await _prefs.setString('user_preferences', json.encode(profile.toJson()));
    } catch (e) {
      debugPrint('Error caching user preferences: $e');
    }
  }
}
