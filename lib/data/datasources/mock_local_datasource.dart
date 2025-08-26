import '../../core/error/exceptions.dart';
import '../datasources/local_datasource.dart';
import '../models/query_history_model.dart';
import '../models/rag_response_model.dart';

/// Mock implementation of LocalDataSource for web and fallback scenarios
/// Provides in-memory storage that behaves like a database but doesn't require SQLite
class MockLocalDataSource implements LocalDataSource {
  // In-memory storage
  final List<QueryHistoryModel> _queryHistory = [];
  final List<RagResponseModel> _ragCache = [];

  @override
  Future<void> saveQueryHistory(QueryHistoryModel queryHistory) async {
    try {
      // Remove existing entry with same query to avoid duplicates
      _queryHistory.removeWhere((item) => item.query == queryHistory.query);

      // Add new entry
      _queryHistory.add(queryHistory);

      // Keep only last 100 entries to prevent memory bloat
      if (_queryHistory.length > 100) {
        _queryHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _queryHistory.removeRange(100, _queryHistory.length);
      }
    } catch (e) {
      throw CacheException('Failed to save query history: ${e.toString()}');
    }
  }

  @override
  Future<List<QueryHistoryModel>> getQueryHistory({
    int? limit,
    int? offset,
  }) async {
    try {
      final sortedHistory = List<QueryHistoryModel>.from(_queryHistory)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      int start = offset ?? 0;
      int end = limit != null ? start + limit : sortedHistory.length;

      if (start >= sortedHistory.length) return [];
      if (end > sortedHistory.length) end = sortedHistory.length;

      return sortedHistory.sublist(start, end);
    } catch (e) {
      throw CacheException('Failed to get query history: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheRagResponse(RagResponseModel response) async {
    try {
      // Remove existing cache for this query
      _ragCache.removeWhere((item) => item.query == response.query);

      // Add new cache entry
      _ragCache.add(response);

      // Keep only last 50 cached responses to prevent memory bloat
      if (_ragCache.length > 50) {
        _ragCache.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _ragCache.removeRange(50, _ragCache.length);
      }
    } catch (e) {
      throw CacheException('Failed to cache RAG response: ${e.toString()}');
    }
  }

  @override
  Future<RagResponseModel?> getCachedRagResponse(String query) async {
    try {
      // Find exact match
      for (final cached in _ragCache) {
        if (cached.query.toLowerCase().trim() == query.toLowerCase().trim()) {
          // Check if cache is still valid (24 hours for mock)
          final now = DateTime.now();
          final ageHours = now.difference(cached.timestamp).inHours;

          if (ageHours < 24) {
            return cached;
          } else {
            // Remove expired cache
            _ragCache.removeWhere((item) => item.query == cached.query);
          }
        }
      }

      return null;
    } catch (e) {
      throw CacheException(
        'Failed to get cached RAG response: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearExpiredCache() async {
    try {
      final now = DateTime.now();
      _ragCache.removeWhere((cached) {
        final ageHours = now.difference(cached.timestamp).inHours;
        return ageHours >= 24; // Remove entries older than 24 hours
      });
    } catch (e) {
      throw CacheException('Failed to clear expired cache: ${e.toString()}');
    }
  }

  // Additional methods for managing the mock data
  Future<void> clearAllData() async {
    _queryHistory.clear();
    _ragCache.clear();
  }

  // Get statistics for debugging
  Map<String, int> getStats() {
    return {
      'query_history_count': _queryHistory.length,
      'rag_cache_count': _ragCache.length,
    };
  }
}
