import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../datasources/rag_database_helper.dart';

part 'dua_recommendation.freezed.dart';
part 'dua_recommendation.g.dart';

@freezed
/// DuaRecommendation class implementation
class DuaRecommendation with _$DuaRecommendation {
  const factory DuaRecommendation({
    required String id,
    required String arabicText,
    required String transliteration,
    required String translation,
    required double confidence,
    String? category,
    String? source,
    String? reference,
    String? audioUrl,
    String? audioFileName,
    int? repetitions,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    @Default(false) bool isFavorite,
    @Default(false) bool hasAudio,
    @Default(false) bool isDownloaded,
    DateTime? createdAt,
    DateTime? lastAccessed,
  }) = _DuaRecommendation;

  factory DuaRecommendation.fromJson(Map<String, dynamic> json) =>
      _$DuaRecommendationFromJson(json);
}

// Helper extension for database operations
extension DuaRecommendationExtension on DuaRecommendation {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'confidence': confidence,
      'category': category,
      'source': source,
      'reference': reference,
      'audio_url': audioUrl,
      'audio_file_name': audioFileName,
      'repetitions': repetitions,
      'tags': tags?.join(','),
      'metadata': metadata != null ? _encodeMetadata(metadata!) : null,
      'is_favorite': isFavorite ? 1 : 0,
      'has_audio': hasAudio ? 1 : 0,
      'is_downloaded': isDownloaded ? 1 : 0,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'last_accessed': lastAccessed?.millisecondsSinceEpoch,
    };
  }

  static String _encodeMetadata(Map<String, dynamic> metadata) {
    return jsonEncode(metadata);
  }
}

// Static helper methods
/// DuaRecommendationHelper class implementation
class DuaRecommendationHelper {
  static Future<Database> get _database async =>
      RagDatabaseHelper.instance.database;

  static DuaRecommendation fromDatabase(Map<String, dynamic> map) {
    return DuaRecommendation(
      id: map['id'] as String,
      arabicText: map['arabic_text'] as String,
      transliteration: map['transliteration'] as String,
      translation: map['translation'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      category: map['category'] as String?,
      source: map['source'] as String?,
      reference: map['reference'] as String?,
      audioUrl: map['audio_url'] as String?,
      audioFileName: map['audio_file_name'] as String?,
      repetitions: map['repetitions'] as int?,
      tags:
          map['tags'] != null
              ? (map['tags'] as String)
                  .split(',')
                  .where((t) => t.isNotEmpty)
                  .toList()
              : null,
      metadata:
          map['metadata'] != null
              ? _decodeMetadata(map['metadata'] as String)
              : null,
      isFavorite: (map['is_favorite'] as int) == 1,
      hasAudio: (map['has_audio'] as int) == 1,
      isDownloaded: (map['is_downloaded'] as int) == 1,
      createdAt:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
              : null,
      lastAccessed:
          map['last_accessed'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['last_accessed'] as int)
              : null,
    );
  }

  // Database operations
  static Future<void> insert(DuaRecommendation recommendation) async {
    final db = await _database;
    await db.insert('dua_recommendations', recommendation.toDatabase());
  }

  static Future<List<DuaRecommendation>> getByCategory({
    String? category,
    int? limit,
    bool favoritesOnly = false,
  }) async {
    final db = await _database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (category != null) {
      whereClause = 'category = ?';
      whereArgs.add(category);
    }

    if (favoritesOnly) {
      whereClause += '${whereClause.isNotEmpty ? ' AND ' : ''}is_favorite = 1';
    }

    final maps = await db.query(
      'dua_recommendations',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'confidence DESC',
      limit: limit,
    );

    return maps.map((map) => fromDatabase(map)).toList();
  }

  static Map<String, dynamic> _decodeMetadata(String metadataString) {
    try {
      return jsonDecode(metadataString) as Map<String, dynamic>;
    } catch (e) {
      return <String, dynamic>{};
    }
  }
}
