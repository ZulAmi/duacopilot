import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../datasources/rag_database_helper.dart';

part 'user_preference.freezed.dart';
part 'user_preference.g.dart';

@freezed
/// UserPreference class implementation
class UserPreference with _$UserPreference {
  const factory UserPreference({
    required String id,
    required String userId,
    required String key,
    required String value,
    required String type, // Changed from PreferenceType to String
    String? category,
    String? description,
    Map<String, dynamic>? metadata,
    @Default(false) bool isSystem,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserPreference;

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);
}

// Helper extension for database operations and value conversion
extension UserPreferenceExtension on UserPreference {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'key': key,
      'value': value,
      'type': type, // Now using string directly
      'category': category,
      'description': description,
      'metadata': metadata != null ? _encodeJson(metadata!) : null,
      'is_system': isSystem ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Type-safe value getters
  String get stringValue => value;

  int get intValue => int.tryParse(value) ?? 0;

  double get doubleValue => double.tryParse(value) ?? 0.0;

  bool get boolValue => value.toLowerCase() == 'true';

  List<String> get listValue =>
      value.split(',').where((s) => s.isNotEmpty).toList();

  // Context generation for RAG service
  Map<String, dynamic> toRagContext() {
    final context = <String, dynamic>{
      'preference_key': key,
      'preference_category': category ?? 'general',
    };

    switch (type) {
      case 'string':
        context['value'] = stringValue;
        break;
      case 'int':
        context['value'] = intValue;
        break;
      case 'double':
        context['value'] = doubleValue;
        break;
      case 'bool':
        context['value'] = boolValue;
        break;
      case 'list':
        context['value'] = listValue;
        break;
      case 'json':
        context['value'] = metadata ?? {};
        break;
    }

    return context;
  }

  static String _encodeJson(Map<String, dynamic> data) {
    return jsonEncode(data);
  }
}

// Static helper methods
/// UserPreferenceHelper class implementation
class UserPreferenceHelper {
  static Future<Database> get _database async =>
      RagDatabaseHelper.instance.database;

  static UserPreference fromDatabase(Map<String, dynamic> map) {
    return UserPreference(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      key: map['key'] as String,
      value: map['value'] as String,
      type: map['type'] as String,
      category: map['category'] as String?,
      description: map['description'] as String?,
      metadata:
          map['metadata'] != null
              ? _decodeJson(map['metadata'] as String)
              : null,
      isSystem: (map['is_system'] as int) == 1,
      isActive: (map['is_active'] as int) == 1,
      createdAt:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
              : null,
      updatedAt:
          map['updated_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
              : null,
    );
  }

  // Database operations
  static Future<UserPreference?> getByUserAndKey(
    String userId,
    String key,
  ) async {
    final db = await _database;
    final maps = await db.query(
      'user_preferences',
      where: 'user_id = ? AND key = ?',
      whereArgs: [userId, key],
    );

    if (maps.isEmpty) return null;
    return fromDatabase(maps.first);
  }

  static Future<List<UserPreference>> getByUser(String userId) async {
    final db = await _database;
    final maps = await db.query(
      'user_preferences',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      orderBy: 'category, key',
    );

    return maps.map((map) => fromDatabase(map)).toList();
  }

  static Future<void> insertOrUpdate(UserPreference preference) async {
    final db = await _database;
    await db.insert(
      'user_preferences',
      preference.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Map<String, dynamic> _decodeJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return <String, dynamic>{};
    }
  }
}

enum PreferenceType { string, integer, decimal, boolean, list, json }

// Predefined preference keys for RAG context
/// PreferenceKeys class implementation
class PreferenceKeys {
  static const String language = 'language';
  static const String region = 'region';
  static const String schoolOfThought = 'school_of_thought';
  static const String prayerReminders = 'prayer_reminders';
  static const String audioQuality = 'audio_quality';
  static const String duaCategories = 'dua_categories';
  static const String transliterationStyle = 'transliteration_style';
  static const String favoriteReciter = 'favorite_reciter';
  static const String searchHistory = 'search_history_enabled';
  static const String cachePreference = 'cache_preference';
}
