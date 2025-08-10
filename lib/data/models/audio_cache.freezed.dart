// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_cache.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AudioCache _$AudioCacheFromJson(Map<String, dynamic> json) {
  return _AudioCache.fromJson(json);
}

/// @nodoc
mixin _$AudioCache {
  String get id => throw _privateConstructorUsedError;
  String get duaId => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get localPath => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  AudioQuality get quality => throw _privateConstructorUsedError;
  DownloadStatus get status => throw _privateConstructorUsedError;
  String? get originalUrl => throw _privateConstructorUsedError;
  String? get reciter => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get downloadedAt => throw _privateConstructorUsedError;
  DateTime? get lastPlayed => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this AudioCache to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioCache
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioCacheCopyWith<AudioCache> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioCacheCopyWith<$Res> {
  factory $AudioCacheCopyWith(
    AudioCache value,
    $Res Function(AudioCache) then,
  ) = _$AudioCacheCopyWithImpl<$Res, AudioCache>;
  @useResult
  $Res call({
    String id,
    String duaId,
    String fileName,
    String localPath,
    int fileSizeBytes,
    AudioQuality quality,
    DownloadStatus status,
    String? originalUrl,
    String? reciter,
    String? language,
    Map<String, dynamic>? metadata,
    int playCount,
    bool isFavorite,
    DateTime? downloadedAt,
    DateTime? lastPlayed,
    DateTime? expiresAt,
  });
}

/// @nodoc
class _$AudioCacheCopyWithImpl<$Res, $Val extends AudioCache>
    implements $AudioCacheCopyWith<$Res> {
  _$AudioCacheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioCache
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? fileName = null,
    Object? localPath = null,
    Object? fileSizeBytes = null,
    Object? quality = null,
    Object? status = null,
    Object? originalUrl = freezed,
    Object? reciter = freezed,
    Object? language = freezed,
    Object? metadata = freezed,
    Object? playCount = null,
    Object? isFavorite = null,
    Object? downloadedAt = freezed,
    Object? lastPlayed = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            duaId:
                null == duaId
                    ? _value.duaId
                    : duaId // ignore: cast_nullable_to_non_nullable
                        as String,
            fileName:
                null == fileName
                    ? _value.fileName
                    : fileName // ignore: cast_nullable_to_non_nullable
                        as String,
            localPath:
                null == localPath
                    ? _value.localPath
                    : localPath // ignore: cast_nullable_to_non_nullable
                        as String,
            fileSizeBytes:
                null == fileSizeBytes
                    ? _value.fileSizeBytes
                    : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                        as int,
            quality:
                null == quality
                    ? _value.quality
                    : quality // ignore: cast_nullable_to_non_nullable
                        as AudioQuality,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as DownloadStatus,
            originalUrl:
                freezed == originalUrl
                    ? _value.originalUrl
                    : originalUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            reciter:
                freezed == reciter
                    ? _value.reciter
                    : reciter // ignore: cast_nullable_to_non_nullable
                        as String?,
            language:
                freezed == language
                    ? _value.language
                    : language // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            playCount:
                null == playCount
                    ? _value.playCount
                    : playCount // ignore: cast_nullable_to_non_nullable
                        as int,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
            downloadedAt:
                freezed == downloadedAt
                    ? _value.downloadedAt
                    : downloadedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastPlayed:
                freezed == lastPlayed
                    ? _value.lastPlayed
                    : lastPlayed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            expiresAt:
                freezed == expiresAt
                    ? _value.expiresAt
                    : expiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioCacheImplCopyWith<$Res>
    implements $AudioCacheCopyWith<$Res> {
  factory _$$AudioCacheImplCopyWith(
    _$AudioCacheImpl value,
    $Res Function(_$AudioCacheImpl) then,
  ) = __$$AudioCacheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String duaId,
    String fileName,
    String localPath,
    int fileSizeBytes,
    AudioQuality quality,
    DownloadStatus status,
    String? originalUrl,
    String? reciter,
    String? language,
    Map<String, dynamic>? metadata,
    int playCount,
    bool isFavorite,
    DateTime? downloadedAt,
    DateTime? lastPlayed,
    DateTime? expiresAt,
  });
}

/// @nodoc
class __$$AudioCacheImplCopyWithImpl<$Res>
    extends _$AudioCacheCopyWithImpl<$Res, _$AudioCacheImpl>
    implements _$$AudioCacheImplCopyWith<$Res> {
  __$$AudioCacheImplCopyWithImpl(
    _$AudioCacheImpl _value,
    $Res Function(_$AudioCacheImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioCache
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? fileName = null,
    Object? localPath = null,
    Object? fileSizeBytes = null,
    Object? quality = null,
    Object? status = null,
    Object? originalUrl = freezed,
    Object? reciter = freezed,
    Object? language = freezed,
    Object? metadata = freezed,
    Object? playCount = null,
    Object? isFavorite = null,
    Object? downloadedAt = freezed,
    Object? lastPlayed = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$AudioCacheImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        duaId:
            null == duaId
                ? _value.duaId
                : duaId // ignore: cast_nullable_to_non_nullable
                    as String,
        fileName:
            null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                    as String,
        localPath:
            null == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                    as String,
        fileSizeBytes:
            null == fileSizeBytes
                ? _value.fileSizeBytes
                : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                    as int,
        quality:
            null == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                    as AudioQuality,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as DownloadStatus,
        originalUrl:
            freezed == originalUrl
                ? _value.originalUrl
                : originalUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        reciter:
            freezed == reciter
                ? _value.reciter
                : reciter // ignore: cast_nullable_to_non_nullable
                    as String?,
        language:
            freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        playCount:
            null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                    as int,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
        downloadedAt:
            freezed == downloadedAt
                ? _value.downloadedAt
                : downloadedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastPlayed:
            freezed == lastPlayed
                ? _value.lastPlayed
                : lastPlayed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        expiresAt:
            freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioCacheImpl implements _AudioCache {
  const _$AudioCacheImpl({
    required this.id,
    required this.duaId,
    required this.fileName,
    required this.localPath,
    required this.fileSizeBytes,
    required this.quality,
    required this.status,
    this.originalUrl,
    this.reciter,
    this.language,
    final Map<String, dynamic>? metadata,
    this.playCount = 0,
    this.isFavorite = false,
    this.downloadedAt,
    this.lastPlayed,
    this.expiresAt,
  }) : _metadata = metadata;

  factory _$AudioCacheImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioCacheImplFromJson(json);

  @override
  final String id;
  @override
  final String duaId;
  @override
  final String fileName;
  @override
  final String localPath;
  @override
  final int fileSizeBytes;
  @override
  final AudioQuality quality;
  @override
  final DownloadStatus status;
  @override
  final String? originalUrl;
  @override
  final String? reciter;
  @override
  final String? language;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? downloadedAt;
  @override
  final DateTime? lastPlayed;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'AudioCache(id: $id, duaId: $duaId, fileName: $fileName, localPath: $localPath, fileSizeBytes: $fileSizeBytes, quality: $quality, status: $status, originalUrl: $originalUrl, reciter: $reciter, language: $language, metadata: $metadata, playCount: $playCount, isFavorite: $isFavorite, downloadedAt: $downloadedAt, lastPlayed: $lastPlayed, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioCacheImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.originalUrl, originalUrl) ||
                other.originalUrl == originalUrl) &&
            (identical(other.reciter, reciter) || other.reciter == reciter) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt) &&
            (identical(other.lastPlayed, lastPlayed) ||
                other.lastPlayed == lastPlayed) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    duaId,
    fileName,
    localPath,
    fileSizeBytes,
    quality,
    status,
    originalUrl,
    reciter,
    language,
    const DeepCollectionEquality().hash(_metadata),
    playCount,
    isFavorite,
    downloadedAt,
    lastPlayed,
    expiresAt,
  );

  /// Create a copy of AudioCache
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioCacheImplCopyWith<_$AudioCacheImpl> get copyWith =>
      __$$AudioCacheImplCopyWithImpl<_$AudioCacheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioCacheImplToJson(this);
  }
}

abstract class _AudioCache implements AudioCache {
  const factory _AudioCache({
    required final String id,
    required final String duaId,
    required final String fileName,
    required final String localPath,
    required final int fileSizeBytes,
    required final AudioQuality quality,
    required final DownloadStatus status,
    final String? originalUrl,
    final String? reciter,
    final String? language,
    final Map<String, dynamic>? metadata,
    final int playCount,
    final bool isFavorite,
    final DateTime? downloadedAt,
    final DateTime? lastPlayed,
    final DateTime? expiresAt,
  }) = _$AudioCacheImpl;

  factory _AudioCache.fromJson(Map<String, dynamic> json) =
      _$AudioCacheImpl.fromJson;

  @override
  String get id;
  @override
  String get duaId;
  @override
  String get fileName;
  @override
  String get localPath;
  @override
  int get fileSizeBytes;
  @override
  AudioQuality get quality;
  @override
  DownloadStatus get status;
  @override
  String? get originalUrl;
  @override
  String? get reciter;
  @override
  String? get language;
  @override
  Map<String, dynamic>? get metadata;
  @override
  int get playCount;
  @override
  bool get isFavorite;
  @override
  DateTime? get downloadedAt;
  @override
  DateTime? get lastPlayed;
  @override
  DateTime? get expiresAt;

  /// Create a copy of AudioCache
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioCacheImplCopyWith<_$AudioCacheImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
