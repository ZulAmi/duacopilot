import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../datasources/rag_database_helper.dart';

part 'query_history.freezed.dart';
part 'query_history.g.dart';

@freezed
class QueryHistory with _$QueryHistory {
  const factory QueryHistory({
    required String id,
    required String query,
    required String response,
    required DateTime timestamp,
    required int responseTime,
    required String semanticHash,
    double? confidence,
    String? sessionId,
    List<String>? tags,
    Map<String, dynamic>? context,
    Map<String, dynamic>? metadata,
    @Default(false) bool isFavorite,
    @Default(false) bool isFromCache,
    DateTime? lastAccessed,
    int? accessCount,
  }) = _QueryHistory;

  factory QueryHistory.fromJson(Map<String, dynamic> json) =>
      _$QueryHistoryFromJson(json);
}

// Helper extension for database operations
extension QueryHistoryExtension on QueryHistory {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'response_time': responseTime,
      'semantic_hash': semanticHash,
      'confidence': confidence,
      'session_id': sessionId,
      'tags': tags?.join(','),
      'context': context != null ? _encodeJson(context!) : null,
      'metadata': metadata != null ? _encodeJson(metadata!) : null,
      'is_favorite': isFavorite ? 1 : 0,
      'is_from_cache': isFromCache ? 1 : 0,
      'last_accessed': lastAccessed?.millisecondsSinceEpoch,
      'access_count': accessCount ?? 0,
    };
  }

  static String _encodeJson(Map<String, dynamic> data) {
    return jsonEncode(data);
  }
}

// Static helper methods
class QueryHistoryHelper {
  static Future<Database> get _database async =>
      RagDatabaseHelper.instance.database;

  static QueryHistory fromDatabase(Map<String, dynamic> map) {
    return QueryHistory(
      id: map['id'] as String,
      query: map['query'] as String,
      response: map['response'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      responseTime: map['response_time'] as int,
      semanticHash: map['semantic_hash'] as String,
      confidence:
          map['confidence'] != null
              ? (map['confidence'] as num).toDouble()
              : null,
      sessionId: map['session_id'] as String?,
      tags:
          map['tags'] != null
              ? (map['tags'] as String)
                  .split(',')
                  .where((t) => t.isNotEmpty)
                  .toList()
              : null,
      context:
          map['context'] != null ? _decodeJson(map['context'] as String) : null,
      metadata:
          map['metadata'] != null
              ? _decodeJson(map['metadata'] as String)
              : null,
      isFavorite: (map['is_favorite'] as int) == 1,
      isFromCache: (map['is_from_cache'] as int) == 1,
      lastAccessed:
          map['last_accessed'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['last_accessed'] as int)
              : null,
      accessCount: map['access_count'] as int?,
    );
  }

  // Database operations
  static Future<void> insert(QueryHistory queryHistory) async {
    final db = await _database;
    await db.insert('query_history', queryHistory.toDatabase());
  }

  static Future<List<QueryHistory>> findBySemanticHash(
    String semanticHash,
  ) async {
    final db = await _database;
    final maps = await db.query(
      'query_history',
      where: 'semantic_hash = ?',
      whereArgs: [semanticHash],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => fromDatabase(map)).toList();
  }

  static Future<void> updateAccessInfo(String id) async {
    final db = await _database;
    await db.update(
      'query_history',
      {
        'last_accessed': DateTime.now().millisecondsSinceEpoch,
        'access_count': 'access_count + 1',
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<QueryHistory>> getAll({
    int? limit,
    int? offset,
    String? sessionId,
    bool favoritesOnly = false,
  }) async {
    final db = await _database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (sessionId != null) {
      whereClause = 'session_id = ?';
      whereArgs.add(sessionId);
    }

    if (favoritesOnly) {
      whereClause +=
          (whereClause.isNotEmpty ? ' AND ' : '') + 'is_favorite = 1';
    }

    final maps = await db.query(
      'query_history',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'timestamp DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => fromDatabase(map)).toList();
  }

  // Semantic similarity helper
  static String generateSemanticHash(String query) {
    // Simple hash generation - in production, use semantic embeddings
    final normalized = query.toLowerCase().trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    return normalized.hashCode.toString();
  }

  static Map<String, dynamic> _decodeJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return <String, dynamic>{};
    }
  }
}
