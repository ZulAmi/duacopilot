// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_audio_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QariInfoImpl _$$QariInfoImplFromJson(Map<String, dynamic> json) =>
    _$QariInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      country: json['country'] as String,
      description: json['description'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      specializations:
          (json['specializations'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      isVerified: json['isVerified'] as bool,
      bioEnglish: json['bio_en'] as String,
      bioArabic: json['bio_ar'] as String,
      awards:
          (json['awards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRecitations: (json['totalRecitations'] as num?)?.toInt() ?? 0,
      birthDate:
          json['birthDate'] == null
              ? null
              : DateTime.parse(json['birthDate'] as String),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$QariInfoImplToJson(_$QariInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'arabicName': instance.arabicName,
      'country': instance.country,
      'description': instance.description,
      'profileImageUrl': instance.profileImageUrl,
      'specializations': instance.specializations,
      'isVerified': instance.isVerified,
      'bio_en': instance.bioEnglish,
      'bio_ar': instance.bioArabic,
      'awards': instance.awards,
      'rating': instance.rating,
      'totalRecitations': instance.totalRecitations,
      'birthDate': instance.birthDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$PremiumRecitationImpl _$$PremiumRecitationImplFromJson(
  Map<String, dynamic> json,
) => _$PremiumRecitationImpl(
  id: json['id'] as String,
  duaId: json['duaId'] as String,
  qariId: json['qariId'] as String,
  title: json['title'] as String,
  arabicTitle: json['arabicTitle'] as String,
  url: json['url'] as String,
  quality: $enumDecode(_$AudioQualityEnumMap, json['quality']),
  duration: (json['duration'] as num).toInt(),
  sizeInBytes: (json['sizeInBytes'] as num).toInt(),
  format: json['format'] as String? ?? 'mp3',
  isDownloaded: json['isDownloaded'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  playCount: (json['playCount'] as num?)?.toInt() ?? 0,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  encryptedUrl: json['encryptedUrl'] as String?,
  accessToken: json['accessToken'] as String?,
  tokenExpiry:
      json['tokenExpiry'] == null
          ? null
          : DateTime.parse(json['tokenExpiry'] as String),
  localPath: json['localPath'] as String?,
  downloadId: json['downloadId'] as String?,
  downloadStatus:
      $enumDecodeNullable(_$DownloadStatusEnumMap, json['downloadStatus']) ??
      DownloadStatus.notDownloaded,
  downloadProgress: (json['downloadProgress'] as num?)?.toDouble() ?? 0.0,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  lastPlayed:
      json['lastPlayed'] == null
          ? null
          : DateTime.parse(json['lastPlayed'] as String),
);

Map<String, dynamic> _$$PremiumRecitationImplToJson(
  _$PremiumRecitationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'duaId': instance.duaId,
  'qariId': instance.qariId,
  'title': instance.title,
  'arabicTitle': instance.arabicTitle,
  'url': instance.url,
  'quality': _$AudioQualityEnumMap[instance.quality]!,
  'duration': instance.duration,
  'sizeInBytes': instance.sizeInBytes,
  'format': instance.format,
  'isDownloaded': instance.isDownloaded,
  'isFavorite': instance.isFavorite,
  'playCount': instance.playCount,
  'tags': instance.tags,
  'localPath': instance.localPath,
  'downloadId': instance.downloadId,
  'downloadStatus': _$DownloadStatusEnumMap[instance.downloadStatus]!,
  'downloadProgress': instance.downloadProgress,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastPlayed': instance.lastPlayed?.toIso8601String(),
};

const _$AudioQualityEnumMap = {
  AudioQuality.standard: 'standard',
  AudioQuality.high: 'high',
  AudioQuality.premium: 'premium',
  AudioQuality.lossless: 'lossless',
};

const _$DownloadStatusEnumMap = {
  DownloadStatus.notDownloaded: 'notDownloaded',
  DownloadStatus.downloading: 'downloading',
  DownloadStatus.downloaded: 'downloaded',
  DownloadStatus.failed: 'failed',
  DownloadStatus.pending: 'pending',
  DownloadStatus.paused: 'paused',
};

_$PremiumPlaylistImpl _$$PremiumPlaylistImplFromJson(
  Map<String, dynamic> json,
) => _$PremiumPlaylistImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  recitationIds:
      (json['recitationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  mood:
      $enumDecodeNullable(_$PlaylistMoodEnumMap, json['mood']) ??
      PlaylistMood.general,
  isPublic: json['isPublic'] as bool? ?? false,
  isSystemGenerated: json['isSystemGenerated'] as bool? ?? false,
  coverImageUrl: json['coverImageUrl'] as String?,
  totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
  playCount: (json['playCount'] as num?)?.toInt() ?? 0,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  lastPlayed:
      json['lastPlayed'] == null
          ? null
          : DateTime.parse(json['lastPlayed'] as String),
);

Map<String, dynamic> _$$PremiumPlaylistImplToJson(
  _$PremiumPlaylistImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'description': instance.description,
  'recitationIds': instance.recitationIds,
  'mood': _$PlaylistMoodEnumMap[instance.mood]!,
  'isPublic': instance.isPublic,
  'isSystemGenerated': instance.isSystemGenerated,
  'coverImageUrl': instance.coverImageUrl,
  'totalDuration': instance.totalDuration,
  'playCount': instance.playCount,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'lastPlayed': instance.lastPlayed?.toIso8601String(),
};

const _$PlaylistMoodEnumMap = {
  PlaylistMood.general: 'general',
  PlaylistMood.morning: 'morning',
  PlaylistMood.evening: 'evening',
  PlaylistMood.night: 'night',
  PlaylistMood.ramadan: 'ramadan',
  PlaylistMood.stress: 'stress',
  PlaylistMood.gratitude: 'gratitude',
  PlaylistMood.forgiveness: 'forgiveness',
  PlaylistMood.healing: 'healing',
  PlaylistMood.travel: 'travel',
};

_$SleepTimerConfigImpl _$$SleepTimerConfigImplFromJson(
  Map<String, dynamic> json,
) => _$SleepTimerConfigImpl(
  duration:
      json['duration'] == null
          ? const Duration(minutes: 30)
          : Duration(microseconds: (json['duration'] as num).toInt()),
  action:
      $enumDecodeNullable(_$SleepActionEnumMap, json['action']) ??
      SleepAction.pause,
  fadeOut:
      $enumDecodeNullable(_$FadeOutDurationEnumMap, json['fadeOut']) ??
      FadeOutDuration.gradual,
  isActive: json['isActive'] as bool? ?? false,
  startTime:
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
  endTime:
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
);

Map<String, dynamic> _$$SleepTimerConfigImplToJson(
  _$SleepTimerConfigImpl instance,
) => <String, dynamic>{
  'duration': instance.duration.inMicroseconds,
  'action': _$SleepActionEnumMap[instance.action]!,
  'fadeOut': _$FadeOutDurationEnumMap[instance.fadeOut]!,
  'isActive': instance.isActive,
  'startTime': instance.startTime?.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
};

const _$SleepActionEnumMap = {
  SleepAction.pause: 'pause',
  SleepAction.stop: 'stop',
  SleepAction.nextTrack: 'nextTrack',
};

const _$FadeOutDurationEnumMap = {
  FadeOutDuration.instant: 'instant',
  FadeOutDuration.quick: 'quick',
  FadeOutDuration.gradual: 'gradual',
  FadeOutDuration.slow: 'slow',
};

_$PremiumAudioSettingsImpl _$$PremiumAudioSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$PremiumAudioSettingsImpl(
  preferredQuality:
      $enumDecodeNullable(_$AudioQualityEnumMap, json['preferredQuality']) ??
      AudioQuality.high,
  allowOfflineDownloads: json['allowOfflineDownloads'] as bool? ?? true,
  autoDownloadFavorites: json['autoDownloadFavorites'] as bool? ?? true,
  backgroundPlayEnabled: json['backgroundPlayEnabled'] as bool? ?? false,
  playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
  crossfadeEnabled: json['crossfadeEnabled'] as bool? ?? true,
  crossfadeDuration:
      json['crossfadeDuration'] == null
          ? const Duration(seconds: 3)
          : Duration(microseconds: (json['crossfadeDuration'] as num).toInt()),
  gaplessPlayback: json['gaplessPlayback'] as bool? ?? false,
  volumeLevel: (json['volumeLevel'] as num?)?.toDouble() ?? 0.8,
  hapticFeedbackEnabled: json['hapticFeedbackEnabled'] as bool? ?? true,
  requireAuthForDownloads: json['requireAuthForDownloads'] as bool? ?? true,
  allowScreenshots: json['allowScreenshots'] as bool? ?? false,
  drmProtectionEnabled: json['drmProtectionEnabled'] as bool? ?? true,
  maxStorageMB: (json['maxStorageMB'] as num?)?.toInt() ?? 5000,
  autoDelete:
      $enumDecodeNullable(_$AutoDeletePolicyEnumMap, json['autoDelete']) ??
      AutoDeletePolicy.never,
  unusedContentRetention:
      json['unusedContentRetention'] == null
          ? const Duration(days: 30)
          : Duration(
            microseconds: (json['unusedContentRetention'] as num).toInt(),
          ),
  lastUpdated:
      json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$PremiumAudioSettingsImplToJson(
  _$PremiumAudioSettingsImpl instance,
) => <String, dynamic>{
  'preferredQuality': _$AudioQualityEnumMap[instance.preferredQuality]!,
  'allowOfflineDownloads': instance.allowOfflineDownloads,
  'autoDownloadFavorites': instance.autoDownloadFavorites,
  'backgroundPlayEnabled': instance.backgroundPlayEnabled,
  'playbackSpeed': instance.playbackSpeed,
  'crossfadeEnabled': instance.crossfadeEnabled,
  'crossfadeDuration': instance.crossfadeDuration.inMicroseconds,
  'gaplessPlayback': instance.gaplessPlayback,
  'volumeLevel': instance.volumeLevel,
  'hapticFeedbackEnabled': instance.hapticFeedbackEnabled,
  'requireAuthForDownloads': instance.requireAuthForDownloads,
  'allowScreenshots': instance.allowScreenshots,
  'drmProtectionEnabled': instance.drmProtectionEnabled,
  'maxStorageMB': instance.maxStorageMB,
  'autoDelete': _$AutoDeletePolicyEnumMap[instance.autoDelete]!,
  'unusedContentRetention': instance.unusedContentRetention.inMicroseconds,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
};

const _$AutoDeletePolicyEnumMap = {
  AutoDeletePolicy.never: 'never',
  AutoDeletePolicy.after30Days: 'after30Days',
  AutoDeletePolicy.after60Days: 'after60Days',
  AutoDeletePolicy.after90Days: 'after90Days',
  AutoDeletePolicy.whenStorageFull: 'whenStorageFull',
};

_$PremiumAudioStatsImpl _$$PremiumAudioStatsImplFromJson(
  Map<String, dynamic> json,
) => _$PremiumAudioStatsImpl(
  userId: json['userId'] as String,
  totalListeningTime: (json['totalListeningTime'] as num?)?.toInt() ?? 0,
  sessionsCount: (json['sessionsCount'] as num?)?.toInt() ?? 0,
  favoritesCount: (json['favoritesCount'] as num?)?.toInt() ?? 0,
  downloadsCount: (json['downloadsCount'] as num?)?.toInt() ?? 0,
  playlistsCount: (json['playlistsCount'] as num?)?.toInt() ?? 0,
  qariPreferences:
      (json['qariPreferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  moodPreferences:
      (json['moodPreferences'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$PlaylistMoodEnumMap, k), (e as num).toInt()),
      ) ??
      const {},
  topRecitations:
      (json['topRecitations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastSessionDate:
      json['lastSessionDate'] == null
          ? null
          : DateTime.parse(json['lastSessionDate'] as String),
  firstSessionDate:
      json['firstSessionDate'] == null
          ? null
          : DateTime.parse(json['firstSessionDate'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$PremiumAudioStatsImplToJson(
  _$PremiumAudioStatsImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'totalListeningTime': instance.totalListeningTime,
  'sessionsCount': instance.sessionsCount,
  'favoritesCount': instance.favoritesCount,
  'downloadsCount': instance.downloadsCount,
  'playlistsCount': instance.playlistsCount,
  'qariPreferences': instance.qariPreferences,
  'moodPreferences': instance.moodPreferences.map(
    (k, e) => MapEntry(_$PlaylistMoodEnumMap[k]!, e),
  ),
  'topRecitations': instance.topRecitations,
  'lastSessionDate': instance.lastSessionDate?.toIso8601String(),
  'firstSessionDate': instance.firstSessionDate?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_$ContentVerificationImpl _$$ContentVerificationImplFromJson(
  Map<String, dynamic> json,
) => _$ContentVerificationImpl(
  contentId: json['contentId'] as String,
  sha256Hash: json['sha256Hash'] as String,
  isVerified: json['isVerified'] as bool,
  verificationSource: json['verificationSource'] as String,
  certificates:
      (json['certificates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  verifiedAt:
      json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$$ContentVerificationImplToJson(
  _$ContentVerificationImpl instance,
) => <String, dynamic>{
  'contentId': instance.contentId,
  'sha256Hash': instance.sha256Hash,
  'isVerified': instance.isVerified,
  'verificationSource': instance.verificationSource,
  'certificates': instance.certificates,
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
};
