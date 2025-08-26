import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'premium_audio_entity.freezed.dart';
part 'premium_audio_entity.g.dart';

/// Premium Audio Quality enumeration
enum AudioQuality {
  standard(bitrate: 128, label: 'Standard (128 kbps)'),
  high(bitrate: 192, label: 'High (192 kbps)'),
  premium(bitrate: 320, label: 'Premium (320 kbps)'),
  lossless(bitrate: 1411, label: 'Lossless (FLAC)');

  const AudioQuality({required this.bitrate, required this.label});
  final int bitrate;
  final String label;
}

/// Famous Qari information with security validation
@freezed
class QariInfo with _$QariInfo {
  const factory QariInfo({
    required String id,
    required String name,
    required String arabicName,
    required String country,
    required String description,
    required String profileImageUrl,
    required List<String> specializations,
    required bool isVerified,
    required String bioEnglish,
    required String bioArabic,
    @Default([]) List<String> awards,
    @Default(0.0) double rating,
    @Default(0) int totalRecitations,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _QariInfo;

  factory QariInfo.fromJson(Map<String, dynamic> json) {
    // Handle the bio_en and bio_ar field mapping manually
    return QariInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      country: json['country'] as String,
      description: json['description'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      specializations: (json['specializations'] as List<dynamic>).cast<String>(),
      isVerified: json['isVerified'] as bool,
      bioEnglish: json['bio_en'] as String? ?? json['bioEnglish'] as String,
      bioArabic: json['bio_ar'] as String? ?? json['bioArabic'] as String,
      awards: (json['awards'] as List<dynamic>?)?.cast<String>() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRecitations: json['totalRecitations'] as int? ?? 0,
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate'] as String) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }
}

/// Premium recitation with encrypted metadata
@freezed
class PremiumRecitation with _$PremiumRecitation {
  const factory PremiumRecitation({
    required String id,
    required String duaId,
    required String qariId,
    required String title,
    required String arabicTitle,
    required String url,
    required AudioQuality quality,
    required int duration, // in seconds
    required int sizeInBytes,
    @Default('mp3') String format,
    @Default(false) bool isDownloaded,
    @Default(false) bool isFavorite,
    @Default(0) int playCount,
    @Default([]) List<String> tags,

    // Security & DRM (excluded from JSON serialization)
    String? encryptedUrl,
    String? accessToken,
    DateTime? tokenExpiry,

    // Offline capabilities
    String? localPath,
    String? downloadId,
    @Default(DownloadStatus.notDownloaded) DownloadStatus downloadStatus,
    @Default(0.0) double downloadProgress,

    DateTime? createdAt,
    DateTime? lastPlayed,
  }) = _PremiumRecitation;

  factory PremiumRecitation.fromJson(Map<String, dynamic> json) {
    return PremiumRecitation(
      id: json['id'] as String,
      duaId: json['duaId'] as String,
      qariId: json['qariId'] as String,
      title: json['title'] as String,
      arabicTitle: json['arabicTitle'] as String,
      url: json['url'] as String,
      quality: AudioQuality.values.byName(json['quality'] as String),
      duration: json['duration'] as int,
      sizeInBytes: json['sizeInBytes'] as int,
      format: json['format'] as String? ?? 'mp3',
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      playCount: json['playCount'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      // Security fields are excluded from JSON parsing for security
      encryptedUrl: null,
      accessToken: null,
      tokenExpiry: null,
      // Offline capabilities
      localPath: json['localPath'] as String?,
      downloadId: json['downloadId'] as String?,
      downloadStatus:
          json['downloadStatus'] != null
              ? DownloadStatus.values.byName(json['downloadStatus'] as String)
              : DownloadStatus.notDownloaded,
      downloadProgress: (json['downloadProgress'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      lastPlayed: json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duaId': duaId,
      'qariId': qariId,
      'title': title,
      'arabicTitle': arabicTitle,
      'url': url,
      'quality': quality.name,
      'duration': duration,
      'sizeInBytes': sizeInBytes,
      'format': format,
      'isDownloaded': isDownloaded,
      'isFavorite': isFavorite,
      'playCount': playCount,
      'tags': tags,
      // Security fields are explicitly excluded from JSON serialization
      'localPath': localPath,
      'downloadId': downloadId,
      'downloadStatus': downloadStatus.name,
      'downloadProgress': downloadProgress,
      'createdAt': createdAt?.toIso8601String(),
      'lastPlayed': lastPlayed?.toIso8601String(),
    };
  }
}

/// Download status for offline recitations
enum DownloadStatus { notDownloaded, downloading, downloaded, failed, pending, paused }

/// Premium playlist for different moods/occasions
@freezed
class PremiumPlaylist with _$PremiumPlaylist {
  const factory PremiumPlaylist({
    required String id,
    required String userId,
    required String name,
    required String description,
    @Default([]) List<String> recitationIds,
    @Default(PlaylistMood.general) PlaylistMood mood,
    @Default(false) bool isPublic,
    @Default(false) bool isSystemGenerated,
    String? coverImageUrl,
    @Default(0) int totalDuration,
    @Default(0) int playCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastPlayed,
  }) = _PremiumPlaylist;

  factory PremiumPlaylist.fromJson(Map<String, dynamic> json) => _$PremiumPlaylistFromJson(json);
}

/// Playlist moods for personalized experience
enum PlaylistMood {
  general('General', '🕌'),
  morning('Morning Prayers', '🌅'),
  evening('Evening Duas', '🌆'),
  night('Night Recitations', '🌙'),
  ramadan('Ramadan Special', '🌙'),
  stress('Stress Relief', '💆'),
  gratitude('Gratitude & Praise', '🤲'),
  forgiveness('Seeking Forgiveness', '🙏'),
  healing('Healing & Recovery', '💚'),
  travel('Travel Duas', '✈️');

  const PlaylistMood(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// Sleep timer configuration
@freezed
class SleepTimerConfig with _$SleepTimerConfig {
  const factory SleepTimerConfig({
    @Default(Duration(minutes: 30)) Duration duration,
    @Default(SleepAction.pause) SleepAction action,
    @Default(FadeOutDuration.gradual) FadeOutDuration fadeOut,
    @Default(false) bool isActive,
    DateTime? startTime,
    DateTime? endTime,
  }) = _SleepTimerConfig;

  factory SleepTimerConfig.fromJson(Map<String, dynamic> json) => _$SleepTimerConfigFromJson(json);
}

/// Sleep timer actions
enum SleepAction { pause, stop, nextTrack }

/// Fade out duration options
enum FadeOutDuration {
  instant(seconds: 0),
  quick(seconds: 5),
  gradual(seconds: 15),
  slow(seconds: 30);

  const FadeOutDuration({required this.seconds});
  final int seconds;
}

/// Premium audio settings with security
@freezed
class PremiumAudioSettings with _$PremiumAudioSettings {
  const factory PremiumAudioSettings({
    @Default(AudioQuality.high) AudioQuality preferredQuality,
    @Default(true) bool allowOfflineDownloads,
    @Default(true) bool autoDownloadFavorites,
    @Default(false) bool backgroundPlayEnabled,
    @Default(1.0) double playbackSpeed,
    @Default(true) bool crossfadeEnabled,
    @Default(Duration(seconds: 3)) Duration crossfadeDuration,
    @Default(false) bool gaplessPlayback,
    @Default(0.8) double volumeLevel,
    @Default(true) bool hapticFeedbackEnabled,

    // Security settings
    @Default(true) bool requireAuthForDownloads,
    @Default(false) bool allowScreenshots,
    @Default(true) bool drmProtectionEnabled,

    // Storage management
    @Default(5000) int maxStorageMB, // 5GB default
    @Default(AutoDeletePolicy.never) AutoDeletePolicy autoDelete,
    @Default(Duration(days: 30)) Duration unusedContentRetention,

    DateTime? lastUpdated,
  }) = _PremiumAudioSettings;

  factory PremiumAudioSettings.fromJson(Map<String, dynamic> json) => _$PremiumAudioSettingsFromJson(json);
}

/// Auto delete policy for storage management
enum AutoDeletePolicy { never, after30Days, after60Days, after90Days, whenStorageFull }

/// Premium audio statistics for analytics
@freezed
class PremiumAudioStats with _$PremiumAudioStats {
  const factory PremiumAudioStats({
    required String userId,
    @Default(0) int totalListeningTime, // in seconds
    @Default(0) int sessionsCount,
    @Default(0) int favoritesCount,
    @Default(0) int downloadsCount,
    @Default(0) int playlistsCount,
    @Default({}) Map<String, int> qariPreferences, // qariId -> playCount
    @Default({}) Map<PlaylistMood, int> moodPreferences,
    @Default([]) List<String> topRecitations,
    DateTime? lastSessionDate,
    DateTime? firstSessionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PremiumAudioStats;

  factory PremiumAudioStats.fromJson(Map<String, dynamic> json) => _$PremiumAudioStatsFromJson(json);
}

/// Content verification for authenticity
@freezed
class ContentVerification with _$ContentVerification {
  const factory ContentVerification({
    required String contentId,
    required String sha256Hash,
    required bool isVerified,
    required String verificationSource,
    @Default([]) List<String> certificates,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  }) = _ContentVerification;

  factory ContentVerification.fromJson(Map<String, dynamic> json) => _$ContentVerificationFromJson(json);
}
