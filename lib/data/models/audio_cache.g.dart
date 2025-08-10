// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_cache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioCacheImpl _$$AudioCacheImplFromJson(Map<String, dynamic> json) =>
    _$AudioCacheImpl(
      id: json['id'] as String,
      duaId: json['duaId'] as String,
      fileName: json['fileName'] as String,
      localPath: json['localPath'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      quality: $enumDecode(_$AudioQualityEnumMap, json['quality']),
      status: $enumDecode(_$DownloadStatusEnumMap, json['status']),
      originalUrl: json['originalUrl'] as String?,
      reciter: json['reciter'] as String?,
      language: json['language'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      downloadedAt:
          json['downloadedAt'] == null
              ? null
              : DateTime.parse(json['downloadedAt'] as String),
      lastPlayed:
          json['lastPlayed'] == null
              ? null
              : DateTime.parse(json['lastPlayed'] as String),
      expiresAt:
          json['expiresAt'] == null
              ? null
              : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$AudioCacheImplToJson(_$AudioCacheImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'duaId': instance.duaId,
      'fileName': instance.fileName,
      'localPath': instance.localPath,
      'fileSizeBytes': instance.fileSizeBytes,
      'quality': _$AudioQualityEnumMap[instance.quality]!,
      'status': _$DownloadStatusEnumMap[instance.status]!,
      'originalUrl': instance.originalUrl,
      'reciter': instance.reciter,
      'language': instance.language,
      'metadata': instance.metadata,
      'playCount': instance.playCount,
      'isFavorite': instance.isFavorite,
      'downloadedAt': instance.downloadedAt?.toIso8601String(),
      'lastPlayed': instance.lastPlayed?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$AudioQualityEnumMap = {
  AudioQuality.low: 'low',
  AudioQuality.medium: 'medium',
  AudioQuality.high: 'high',
  AudioQuality.ultra: 'ultra',
};

const _$DownloadStatusEnumMap = {
  DownloadStatus.pending: 'pending',
  DownloadStatus.downloading: 'downloading',
  DownloadStatus.completed: 'completed',
  DownloadStatus.failed: 'failed',
  DownloadStatus.cancelled: 'cancelled',
  DownloadStatus.paused: 'paused',
};
