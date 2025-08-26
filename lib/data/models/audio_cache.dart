import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../datasources/rag_database_helper.dart';

part 'audio_cache.freezed.dart';
part 'audio_cache.g.dart';

@freezed
/// AudioCache class implementation
class AudioCache with _$AudioCache {
  const factory AudioCache({
    required String id,
    required String duaId,
    required String fileName,
    required String localPath,
    required int fileSizeBytes,
    required AudioQuality quality,
    required DownloadStatus status,
    String? originalUrl,
    String? reciter,
    String? language,
    Map<String, dynamic>? metadata,
    @Default(0) int playCount,
    @Default(false) bool isFavorite,
    DateTime? downloadedAt,
    DateTime? lastPlayed,
    DateTime? expiresAt,
  }) = _AudioCache;

  factory AudioCache.fromJson(Map<String, dynamic> json) =>
      _$AudioCacheFromJson(json);
}

// Helper extension for database operations and audio management
extension AudioCacheExtension on AudioCache {
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'dua_id': duaId,
      'file_name': fileName,
      'local_path': localPath,
      'file_size_bytes': fileSizeBytes,
      'quality': quality.name,
      'status': status.name,
      'original_url': originalUrl,
      'reciter': reciter,
      'language': language,
      'metadata': metadata != null ? _encodeJson(metadata!) : null,
      'play_count': playCount,
      'is_favorite': isFavorite ? 1 : 0,
      'downloaded_at': downloadedAt?.millisecondsSinceEpoch,
      'last_played': lastPlayed?.millisecondsSinceEpoch,
      'expires_at': expiresAt?.millisecondsSinceEpoch,
    };
  }

  // Helper methods for audio management
  bool get isDownloaded => status == DownloadStatus.completed;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get isDownloading => status == DownloadStatus.downloading;

  double get fileSizeMB => fileSizeBytes / (1024 * 1024);

  String get displaySize {
    if (fileSizeBytes < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${fileSizeMB.toStringAsFixed(1)}MB';
  }

  // Cache management helpers
  Duration? get ageInCache {
    if (downloadedAt == null) return null;
    return DateTime.now().difference(downloadedAt!);
  }

  bool shouldCleanup({Duration maxAge = const Duration(days: 30)}) {
    if (isFavorite) return false;
    if (isExpired) return true;
    if (playCount == 0 && ageInCache != null && ageInCache! > maxAge) {
      return true;
    }
    return false;
  }

  static String _encodeJson(Map<String, dynamic> data) {
    return jsonEncode(data);
  }
}

// Static helper methods
/// AudioCacheHelper class implementation
class AudioCacheHelper {
  static Future<Database> get _database async =>
      RagDatabaseHelper.instance.database;

  static AudioCache fromDatabase(Map<String, dynamic> map) {
    return AudioCache(
      id: map['id'] as String,
      duaId: map['dua_id'] as String,
      fileName: map['file_name'] as String,
      localPath: map['local_path'] as String,
      fileSizeBytes: map['file_size_bytes'] as int,
      quality: AudioQuality.values.firstWhere(
        (q) => q.name == map['quality'],
        orElse: () => AudioQuality.medium,
      ),
      status: DownloadStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => DownloadStatus.pending,
      ),
      originalUrl: map['original_url'] as String?,
      reciter: map['reciter'] as String?,
      language: map['language'] as String?,
      metadata:
          map['metadata'] != null
              ? _decodeJson(map['metadata'] as String)
              : null,
      playCount: map['play_count'] as int? ?? 0,
      isFavorite: (map['is_favorite'] as int) == 1,
      downloadedAt:
          map['downloaded_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['downloaded_at'] as int)
              : null,
      lastPlayed:
          map['last_played'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['last_played'] as int)
              : null,
      expiresAt:
          map['expires_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['expires_at'] as int)
              : null,
    );
  }

  // Database operations
  static Future<void> insert(AudioCache audioCache) async {
    final db = await _database;
    await db.insert('audio_cache', audioCache.toDatabase());
  }

  static Future<AudioCache?> getByDuaId(
    String duaId, {
    AudioQuality? quality,
  }) async {
    final db = await _database;
    String whereClause = 'dua_id = ?';
    List<dynamic> whereArgs = [duaId];

    if (quality != null) {
      whereClause += ' AND quality = ?';
      whereArgs.add(quality.name);
    }

    final maps = await db.query(
      'audio_cache',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'downloaded_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return fromDatabase(maps.first);
  }

  static Future<void> cleanupExpired() async {
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.delete(
      'audio_cache',
      where: 'expires_at IS NOT NULL AND expires_at < ? AND is_favorite = 0',
      whereArgs: [now],
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

enum AudioQuality {
  low(bitrate: 64),
  medium(bitrate: 128),
  high(bitrate: 192),
  ultra(bitrate: 320);

  const AudioQuality({required this.bitrate});
  final int bitrate;

  String get displayName {
    switch (this) {
      case AudioQuality.low:
        return 'Low (64kbps)';
      case AudioQuality.medium:
        return 'Medium (128kbps)';
      case AudioQuality.high:
        return 'High (192kbps)';
      case AudioQuality.ultra:
        return 'Ultra (320kbps)';
    }
  }
}

enum DownloadStatus {
  pending,
  downloading,
  completed,
  failed,
  cancelled,
  paused;

  String get displayName {
    switch (this) {
      case DownloadStatus.pending:
        return 'Pending';
      case DownloadStatus.downloading:
        return 'Downloading';
      case DownloadStatus.completed:
        return 'Downloaded';
      case DownloadStatus.failed:
        return 'Failed';
      case DownloadStatus.cancelled:
        return 'Cancelled';
      case DownloadStatus.paused:
        return 'Paused';
    }
  }
}
