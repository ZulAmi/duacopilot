import 'package:duacopilot/core/logging/app_logger.dart';

import 'dart:convert';

import '../models/dua_response.dart';
import '../models/dua_recommendation.dart';
import '../models/query_history.dart';
import '../models/user_preference.dart';
import '../models/audio_cache.dart';
import 'rag_database_helper.dart';

/// Comprehensive RAG caching service for Du'a Copilot
///
/// Handles semantic query caching, user preferences, audio file management,
/// and intelligent response caching for optimal RAG performance.
class RagCacheService {
  final RagDatabaseHelper _dbHelper = RagDatabaseHelper.instance;

  static const double _semanticSimilarityThreshold = 0.85;
  static const int _maxCacheAge =
      7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds
  static const int _maxCacheSize = 1000; // Maximum cached responses

  // ========== Query History and Semantic Caching ==========

  /// Cache a query and its response for future semantic matching
  Future<void> cacheQueryResponse({
    required String query,
    required String response,
    required double confidence,
    String? sessionId,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) async {
    try {
      final queryHistory = QueryHistory(
        id: _generateId(),
        query: query,
        response: response,
        timestamp: DateTime.now(),
        responseTime: 0, // Will be updated if needed
        semanticHash: QueryHistoryHelper.generateSemanticHash(query),
        confidence: confidence,
        sessionId: sessionId,
        tags: tags,
        context: context,
        metadata: metadata,
        isFavorite: false,
        isFromCache: false,
        lastAccessed: DateTime.now(),
        accessCount: 1,
      );

      await QueryHistoryHelper.insert(queryHistory);
      await _maintainCacheSize();
    } catch (e) {
      AppLogger.debug('âŒ Error caching query response: $e');
    }
  }

  /// Find semantically similar cached responses
  Future<QueryHistory?> findSimilarQuery(
    String query, {
    double? threshold,
  }) async {
    try {
      final semanticHash = QueryHistoryHelper.generateSemanticHash(query);
      final similarQueries = await QueryHistoryHelper.findBySemanticHash(
        semanticHash,
      );

      if (similarQueries.isNotEmpty) {
        // Return the most recent similar query
        final bestMatch = similarQueries.first;

        // Update access count and last accessed
        await QueryHistoryHelper.updateAccessInfo(bestMatch.id);

        return bestMatch;
      }

      return null;
    } catch (e) {
      AppLogger.debug('âŒ Error finding similar query: $e');
      return null;
    }
  }

  /// Get query history with pagination
  Future<List<QueryHistory>> getQueryHistory({
    int? limit = 50,
    int? offset = 0,
    String? sessionId,
    bool favoritesOnly = false,
  }) async {
    return await QueryHistoryHelper.getAll(
      limit: limit,
      offset: offset,
      sessionId: sessionId,
      favoritesOnly: favoritesOnly,
    );
  }

  // ========== Du'a Response Caching ==========

  /// Cache a complete Du'a response with sources
  Future<void> cacheDuaResponse(DuaResponse duaResponse) async {
    try {
      final db = await _dbHelper.database;

      // Insert main response
      await db.insert('dua_responses', {
        'id': duaResponse.id,
        'query': duaResponse.query,
        'response': duaResponse.response,
        'timestamp': duaResponse.timestamp.millisecondsSinceEpoch,
        'response_time': duaResponse.responseTime,
        'confidence': duaResponse.confidence,
        'session_id': duaResponse.sessionId,
        'tokens_used': duaResponse.tokensUsed,
        'model': duaResponse.model,
        'metadata': duaResponse.metadata != null
            ? jsonEncode(duaResponse.metadata)
            : null,
        'is_favorite': duaResponse.isFavorite ? 1 : 0,
        'is_from_cache': duaResponse.isFromCache ? 1 : 0,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });

      // Insert sources
      for (final source in duaResponse.sources) {
        await db.insert('dua_sources', {
          'id': source.id,
          'dua_response_id': duaResponse.id,
          'title': source.title,
          'content': source.content,
          'relevance_score': source.relevanceScore,
          'url': source.url,
          'reference': source.reference,
          'category': source.category,
          'metadata':
              source.metadata != null ? jsonEncode(source.metadata) : null,
        });
      }
    } catch (e) {
      AppLogger.debug('âŒ Error caching Du\'a response: $e');
    }
  }

  /// Retrieve cached Du'a response by ID
  Future<DuaResponse?> getCachedDuaResponse(String id) async {
    try {
      final db = await _dbHelper.database;

      // Get main response
      final responseRows = await db.query(
        'dua_responses',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (responseRows.isEmpty) return null;

      final responseRow = responseRows.first;

      // Get sources
      final sourceRows = await db.query(
        'dua_sources',
        where: 'dua_response_id = ?',
        whereArgs: [id],
        orderBy: 'relevance_score DESC',
      );

      final sources = sourceRows
          .map(
            (row) => DuaSource(
              id: row['id'] as String,
              title: row['title'] as String,
              content: row['content'] as String,
              relevanceScore: row['relevance_score'] as double,
              url: row['url'] as String?,
              reference: row['reference'] as String?,
              category: row['category'] as String?,
              metadata: row['metadata'] != null
                  ? jsonDecode(row['metadata'] as String)
                  : null,
            ),
          )
          .toList();

      return DuaResponse(
        id: responseRow['id'] as String,
        query: responseRow['query'] as String,
        response: responseRow['response'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          responseRow['timestamp'] as int,
        ),
        responseTime: responseRow['response_time'] as int,
        confidence: responseRow['confidence'] as double,
        sources: sources,
        sessionId: responseRow['session_id'] as String?,
        tokensUsed: responseRow['tokens_used'] as int?,
        model: responseRow['model'] as String?,
        metadata: responseRow['metadata'] != null
            ? jsonDecode(responseRow['metadata'] as String)
            : null,
        isFavorite: (responseRow['is_favorite'] as int) == 1,
        isFromCache: (responseRow['is_from_cache'] as int) == 1,
      );
    } catch (e) {
      AppLogger.debug('âŒ Error retrieving cached Du\'a response: $e');
      return null;
    }
  }

  // ========== Du'a Recommendation Caching ==========

  /// Cache Du'a recommendations
  Future<void> cacheDuaRecommendation(DuaRecommendation recommendation) async {
    try {
      await DuaRecommendationHelper.insert(recommendation);
    } catch (e) {
      AppLogger.debug('âŒ Error caching Du\'a recommendation: $e');
    }
  }

  /// Get cached recommendations by category
  Future<List<DuaRecommendation>> getCachedRecommendations({
    String? category,
    int? limit = 20,
    bool favoritesOnly = false,
  }) async {
    return await DuaRecommendationHelper.getByCategory(
      category: category,
      limit: limit,
      favoritesOnly: favoritesOnly,
    );
  }

  // ========== User Preference Caching ==========

  /// Get user preference value with caching
  Future<T?> getUserPreference<T>(
    String userId,
    String key,
    String type,
  ) async {
    try {
      final preference = await UserPreferenceHelper.getByUserAndKey(
        userId,
        key,
      );
      if (preference == null) return null;

      switch (type) {
        case 'string':
          return preference.stringValue as T?;
        case 'int':
          return preference.intValue as T?;
        case 'bool':
          return preference.boolValue as T?;
        case 'list':
          return preference.listValue as T?;
        default:
          return preference.value as T?;
      }
    } catch (e) {
      AppLogger.debug('âŒ Error getting user preference: $e');
      return null;
    }
  }

  /// Set user preference with caching
  Future<void> setUserPreference({
    required String userId,
    required String key,
    required dynamic value,
    required String type,
    String? category,
    String? description,
    bool isSystem = false,
  }) async {
    try {
      final preference = UserPreference(
        id: _generateId(),
        userId: userId,
        key: key,
        value: value.toString(),
        type: type,
        category: category,
        description: description,
        metadata: null,
        isSystem: isSystem,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await UserPreferenceHelper.insertOrUpdate(preference);
    } catch (e) {
      AppLogger.debug('âŒ Error setting user preference: $e');
    }
  }

  /// Get user's RAG context for personalized responses
  Future<Map<String, dynamic>> getUserRagContext(String userId) async {
    try {
      final preferences = await UserPreferenceHelper.getByUser(userId);
      final ragContext = <String, dynamic>{};

      for (final pref in preferences) {
        if (pref.isActive) {
          ragContext[pref.key] = _parsePreferenceValue(pref.value, pref.type);
        }
      }

      return ragContext;
    } catch (e) {
      AppLogger.debug('âŒ Error getting user RAG context: $e');
      return {};
    }
  }

  // ========== Audio Cache Management ==========

  /// Cache downloaded audio file
  Future<void> cacheAudioFile(AudioCache audioCache) async {
    try {
      await AudioCacheHelper.insert(audioCache);
    } catch (e) {
      AppLogger.debug('âŒ Error caching audio file: $e');
    }
  }

  /// Get cached audio file info
  Future<AudioCache?> getCachedAudio(
    String duaId, {
    AudioQuality? quality,
  }) async {
    try {
      return await AudioCacheHelper.getByDuaId(duaId, quality: quality);
    } catch (e) {
      AppLogger.debug('âŒ Error getting cached audio: $e');
      return null;
    }
  }

  /// Clean up expired audio cache
  Future<void> cleanupExpiredAudio() async {
    try {
      await AudioCacheHelper.cleanupExpired();
    } catch (e) {
      AppLogger.debug('âŒ Error cleaning up expired audio: $e');
    }
  }

  // ========== Cache Maintenance ==========

  /// Maintain cache size by removing old entries
  Future<void> _maintainCacheSize() async {
    try {
      final db = await _dbHelper.database;

      // Count current cache entries
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM query_history',
      );
      final currentCount = countResult.first['count'] as int;

      if (currentCount > _maxCacheSize) {
        // Remove oldest entries
        final excessCount = currentCount - _maxCacheSize;
        await db.execute(
          '''
          DELETE FROM query_history 
          WHERE id IN (
            SELECT id FROM query_history 
            WHERE is_favorite = 0
            ORDER BY last_accessed ASC 
            LIMIT ?
          )
        ''',
          [excessCount],
        );
      }
    } catch (e) {
      AppLogger.debug('âŒ Error maintaining cache size: $e');
    }
  }

  /// Remove expired cache entries
  Future<void> cleanupExpiredCache() async {
    try {
      final cutoffTime = DateTime.now().millisecondsSinceEpoch - _maxCacheAge;

      final db = await _dbHelper.database;
      await db.delete(
        'query_history',
        where: 'timestamp < ? AND is_favorite = 0',
        whereArgs: [cutoffTime],
      );

      await db.delete(
        'dua_responses',
        where: 'timestamp < ? AND is_favorite = 0',
        whereArgs: [cutoffTime],
      );
    } catch (e) {
      AppLogger.debug('âŒ Error cleaning up expired cache: $e');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final stats = await _dbHelper.getDatabaseStats();
      final db = await _dbHelper.database;

      // Get cache hit rate for last 24 hours
      final dayAgo =
          DateTime.now().millisecondsSinceEpoch - (24 * 60 * 60 * 1000);
      final cacheHits = await db.rawQuery(
        '''
        SELECT COUNT(*) as count FROM query_history 
        WHERE timestamp > ? AND is_from_cache = 1
      ''',
        [dayAgo],
      );

      final totalQueries = await db.rawQuery(
        '''
        SELECT COUNT(*) as count FROM query_history 
        WHERE timestamp > ?
      ''',
        [dayAgo],
      );

      final hitRate = totalQueries.first['count'] as int > 0
          ? (cacheHits.first['count'] as int) /
              (totalQueries.first['count'] as int)
          : 0.0;

      return {
        ...stats,
        'cache_hit_rate_24h': hitRate,
        'cache_threshold': _semanticSimilarityThreshold,
        'max_cache_age_days': _maxCacheAge ~/ (24 * 60 * 60 * 1000),
        'max_cache_size': _maxCacheSize,
      };
    } catch (e) {
      AppLogger.debug('âŒ Error getting cache stats: $e');
      return {};
    }
  }

  // ========== Utility Methods ==========

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (1000 + (999 * (DateTime.now().microsecond / 1000))).round().toString();
  }

  dynamic _parsePreferenceValue(String value, String type) {
    switch (type) {
      case 'int':
        return int.tryParse(value);
      case 'bool':
        return value.toLowerCase() == 'true';
      case 'list':
        try {
          return jsonDecode(value) as List;
        } catch (e) {
          return value.split(',');
        }
      default:
        return value;
    }
  }

  /// Clear all cache (for testing/debugging)
  Future<void> clearAllCache() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('query_history');
      await db.delete('dua_responses');
      await db.delete('dua_sources');
      await db.delete('dua_recommendations');
      await db.delete('audio_cache');
      AppLogger.debug('âœ… All cache cleared');
    } catch (e) {
      AppLogger.debug('âŒ Error clearing cache: $e');
    }
  }
}
