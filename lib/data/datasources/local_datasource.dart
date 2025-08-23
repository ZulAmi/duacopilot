import 'package:sqflite/sqflite.dart';
import '../models/query_history_model.dart';
import '../models/rag_response_model.dart';
import '../../core/error/exceptions.dart';

abstract class LocalDataSource {
  Future<void> saveQueryHistory(QueryHistoryModel queryHistory);
  Future<List<QueryHistoryModel>> getQueryHistory({int? limit, int? offset});
  Future<void> cacheRagResponse(RagResponseModel response);
  Future<RagResponseModel?> getCachedRagResponse(String query);
  Future<void> clearExpiredCache();
}

/// LocalDataSourceImpl class implementation
class LocalDataSourceImpl implements LocalDataSource {
  final Database database;

  LocalDataSourceImpl(this.database);

  @override
  Future<void> saveQueryHistory(QueryHistoryModel queryHistory) async {
    try {
      await database.insert(
        'query_history',
        queryHistory.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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
      final List<Map<String, dynamic>> maps = await database.query(
        'query_history',
        orderBy: 'timestamp DESC',
        limit: limit,
        offset: offset,
      );

      return maps.map((map) => QueryHistoryModel.fromDatabase(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get query history: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheRagResponse(RagResponseModel response) async {
    try {
      final queryHash = response.query.hashCode.toString();
      final expiresAt =
          DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch;

      await database.insert('rag_cache', {
        'query_hash': queryHash,
        'query': response.query,
        'response': response.response,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'expires_at': expiresAt,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw CacheException('Failed to cache RAG response: ${e.toString()}');
    }
  }

  @override
  Future<RagResponseModel?> getCachedRagResponse(String query) async {
    try {
      final queryHash = query.hashCode.toString();
      final now = DateTime.now().millisecondsSinceEpoch;

      final List<Map<String, dynamic>> maps = await database.query(
        'rag_cache',
        where: 'query_hash = ? AND expires_at > ?',
        whereArgs: [queryHash, now],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      return RagResponseModel.fromDatabase({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'query': map['query'] as String,
        'response': map['response'] as String,
        'timestamp': map['created_at'] as int,
        'response_time': 0,
        'metadata': null,
        'sources': null,
      });
    } catch (e) {
      throw CacheException(
        'Failed to get cached RAG response: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearExpiredCache() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await database.delete(
        'rag_cache',
        where: 'expires_at < ?',
        whereArgs: [now],
      );
    } catch (e) {
      throw CacheException('Failed to clear expired cache: ${e.toString()}');
    }
  }
}
