// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AudioTrack _$AudioTrackFromJson(Map<String, dynamic> json) {
  return _AudioTrack.fromJson(json);
}

/// @nodoc
mixin _$AudioTrack {
  String get id => throw _privateConstructorUsedError;
  String get duaId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get reciter => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  AudioQuality get quality => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  double get ragConfidenceScore => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;
  String? get checksumMd5 => throw _privateConstructorUsedError;
  bool get isDownloaded => throw _privateConstructorUsedError;
  bool get isDownloading => throw _privateConstructorUsedError;
  double get downloadProgress => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  DateTime? get downloadedAt => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this AudioTrack to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioTrackCopyWith<AudioTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioTrackCopyWith<$Res> {
  factory $AudioTrackCopyWith(
    AudioTrack value,
    $Res Function(AudioTrack) then,
  ) = _$AudioTrackCopyWithImpl<$Res, AudioTrack>;
  @useResult
  $Res call({
    String id,
    String duaId,
    String title,
    String reciter,
    String language,
    AudioQuality quality,
    String url,
    Duration duration,
    int fileSizeBytes,
    double ragConfidenceScore,
    String? localPath,
    String? checksumMd5,
    bool isDownloaded,
    bool isDownloading,
    double downloadProgress,
    DateTime? lastAccessed,
    DateTime? downloadedAt,
    List<String> tags,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$AudioTrackCopyWithImpl<$Res, $Val extends AudioTrack>
    implements $AudioTrackCopyWith<$Res> {
  _$AudioTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? title = null,
    Object? reciter = null,
    Object? language = null,
    Object? quality = null,
    Object? url = null,
    Object? duration = null,
    Object? fileSizeBytes = null,
    Object? ragConfidenceScore = null,
    Object? localPath = freezed,
    Object? checksumMd5 = freezed,
    Object? isDownloaded = null,
    Object? isDownloading = null,
    Object? downloadProgress = null,
    Object? lastAccessed = freezed,
    Object? downloadedAt = freezed,
    Object? tags = null,
    Object? metadata = freezed,
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
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            reciter:
                null == reciter
                    ? _value.reciter
                    : reciter // ignore: cast_nullable_to_non_nullable
                        as String,
            language:
                null == language
                    ? _value.language
                    : language // ignore: cast_nullable_to_non_nullable
                        as String,
            quality:
                null == quality
                    ? _value.quality
                    : quality // ignore: cast_nullable_to_non_nullable
                        as AudioQuality,
            url:
                null == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as Duration,
            fileSizeBytes:
                null == fileSizeBytes
                    ? _value.fileSizeBytes
                    : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                        as int,
            ragConfidenceScore:
                null == ragConfidenceScore
                    ? _value.ragConfidenceScore
                    : ragConfidenceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            localPath:
                freezed == localPath
                    ? _value.localPath
                    : localPath // ignore: cast_nullable_to_non_nullable
                        as String?,
            checksumMd5:
                freezed == checksumMd5
                    ? _value.checksumMd5
                    : checksumMd5 // ignore: cast_nullable_to_non_nullable
                        as String?,
            isDownloaded:
                null == isDownloaded
                    ? _value.isDownloaded
                    : isDownloaded // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDownloading:
                null == isDownloading
                    ? _value.isDownloading
                    : isDownloading // ignore: cast_nullable_to_non_nullable
                        as bool,
            downloadProgress:
                null == downloadProgress
                    ? _value.downloadProgress
                    : downloadProgress // ignore: cast_nullable_to_non_nullable
                        as double,
            lastAccessed:
                freezed == lastAccessed
                    ? _value.lastAccessed
                    : lastAccessed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            downloadedAt:
                freezed == downloadedAt
                    ? _value.downloadedAt
                    : downloadedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioTrackImplCopyWith<$Res>
    implements $AudioTrackCopyWith<$Res> {
  factory _$$AudioTrackImplCopyWith(
    _$AudioTrackImpl value,
    $Res Function(_$AudioTrackImpl) then,
  ) = __$$AudioTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String duaId,
    String title,
    String reciter,
    String language,
    AudioQuality quality,
    String url,
    Duration duration,
    int fileSizeBytes,
    double ragConfidenceScore,
    String? localPath,
    String? checksumMd5,
    bool isDownloaded,
    bool isDownloading,
    double downloadProgress,
    DateTime? lastAccessed,
    DateTime? downloadedAt,
    List<String> tags,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$AudioTrackImplCopyWithImpl<$Res>
    extends _$AudioTrackCopyWithImpl<$Res, _$AudioTrackImpl>
    implements _$$AudioTrackImplCopyWith<$Res> {
  __$$AudioTrackImplCopyWithImpl(
    _$AudioTrackImpl _value,
    $Res Function(_$AudioTrackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? title = null,
    Object? reciter = null,
    Object? language = null,
    Object? quality = null,
    Object? url = null,
    Object? duration = null,
    Object? fileSizeBytes = null,
    Object? ragConfidenceScore = null,
    Object? localPath = freezed,
    Object? checksumMd5 = freezed,
    Object? isDownloaded = null,
    Object? isDownloading = null,
    Object? downloadProgress = null,
    Object? lastAccessed = freezed,
    Object? downloadedAt = freezed,
    Object? tags = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$AudioTrackImpl(
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
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        reciter:
            null == reciter
                ? _value.reciter
                : reciter // ignore: cast_nullable_to_non_nullable
                    as String,
        language:
            null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                    as String,
        quality:
            null == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                    as AudioQuality,
        url:
            null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as Duration,
        fileSizeBytes:
            null == fileSizeBytes
                ? _value.fileSizeBytes
                : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                    as int,
        ragConfidenceScore:
            null == ragConfidenceScore
                ? _value.ragConfidenceScore
                : ragConfidenceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        localPath:
            freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                    as String?,
        checksumMd5:
            freezed == checksumMd5
                ? _value.checksumMd5
                : checksumMd5 // ignore: cast_nullable_to_non_nullable
                    as String?,
        isDownloaded:
            null == isDownloaded
                ? _value.isDownloaded
                : isDownloaded // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDownloading:
            null == isDownloading
                ? _value.isDownloading
                : isDownloading // ignore: cast_nullable_to_non_nullable
                    as bool,
        downloadProgress:
            null == downloadProgress
                ? _value.downloadProgress
                : downloadProgress // ignore: cast_nullable_to_non_nullable
                    as double,
        lastAccessed:
            freezed == lastAccessed
                ? _value.lastAccessed
                : lastAccessed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        downloadedAt:
            freezed == downloadedAt
                ? _value.downloadedAt
                : downloadedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioTrackImpl implements _AudioTrack {
  const _$AudioTrackImpl({
    required this.id,
    required this.duaId,
    required this.title,
    required this.reciter,
    required this.language,
    required this.quality,
    required this.url,
    required this.duration,
    required this.fileSizeBytes,
    required this.ragConfidenceScore,
    this.localPath,
    this.checksumMd5,
    this.isDownloaded = false,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.lastAccessed,
    this.downloadedAt,
    final List<String> tags = const [],
    final Map<String, dynamic>? metadata,
  }) : _tags = tags,
       _metadata = metadata;

  factory _$AudioTrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioTrackImplFromJson(json);

  @override
  final String id;
  @override
  final String duaId;
  @override
  final String title;
  @override
  final String reciter;
  @override
  final String language;
  @override
  final AudioQuality quality;
  @override
  final String url;
  @override
  final Duration duration;
  @override
  final int fileSizeBytes;
  @override
  final double ragConfidenceScore;
  @override
  final String? localPath;
  @override
  final String? checksumMd5;
  @override
  @JsonKey()
  final bool isDownloaded;
  @override
  @JsonKey()
  final bool isDownloading;
  @override
  @JsonKey()
  final double downloadProgress;
  @override
  final DateTime? lastAccessed;
  @override
  final DateTime? downloadedAt;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

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
  String toString() {
    return 'AudioTrack(id: $id, duaId: $duaId, title: $title, reciter: $reciter, language: $language, quality: $quality, url: $url, duration: $duration, fileSizeBytes: $fileSizeBytes, ragConfidenceScore: $ragConfidenceScore, localPath: $localPath, checksumMd5: $checksumMd5, isDownloaded: $isDownloaded, isDownloading: $isDownloading, downloadProgress: $downloadProgress, lastAccessed: $lastAccessed, downloadedAt: $downloadedAt, tags: $tags, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioTrackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reciter, reciter) || other.reciter == reciter) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.ragConfidenceScore, ragConfidenceScore) ||
                other.ragConfidenceScore == ragConfidenceScore) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.checksumMd5, checksumMd5) ||
                other.checksumMd5 == checksumMd5) &&
            (identical(other.isDownloaded, isDownloaded) ||
                other.isDownloaded == isDownloaded) &&
            (identical(other.isDownloading, isDownloading) ||
                other.isDownloading == isDownloading) &&
            (identical(other.downloadProgress, downloadProgress) ||
                other.downloadProgress == downloadProgress) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    duaId,
    title,
    reciter,
    language,
    quality,
    url,
    duration,
    fileSizeBytes,
    ragConfidenceScore,
    localPath,
    checksumMd5,
    isDownloaded,
    isDownloading,
    downloadProgress,
    lastAccessed,
    downloadedAt,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_metadata),
  ]);

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioTrackImplCopyWith<_$AudioTrackImpl> get copyWith =>
      __$$AudioTrackImplCopyWithImpl<_$AudioTrackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioTrackImplToJson(this);
  }
}

abstract class _AudioTrack implements AudioTrack {
  const factory _AudioTrack({
    required final String id,
    required final String duaId,
    required final String title,
    required final String reciter,
    required final String language,
    required final AudioQuality quality,
    required final String url,
    required final Duration duration,
    required final int fileSizeBytes,
    required final double ragConfidenceScore,
    final String? localPath,
    final String? checksumMd5,
    final bool isDownloaded,
    final bool isDownloading,
    final double downloadProgress,
    final DateTime? lastAccessed,
    final DateTime? downloadedAt,
    final List<String> tags,
    final Map<String, dynamic>? metadata,
  }) = _$AudioTrackImpl;

  factory _AudioTrack.fromJson(Map<String, dynamic> json) =
      _$AudioTrackImpl.fromJson;

  @override
  String get id;
  @override
  String get duaId;
  @override
  String get title;
  @override
  String get reciter;
  @override
  String get language;
  @override
  AudioQuality get quality;
  @override
  String get url;
  @override
  Duration get duration;
  @override
  int get fileSizeBytes;
  @override
  double get ragConfidenceScore;
  @override
  String? get localPath;
  @override
  String? get checksumMd5;
  @override
  bool get isDownloaded;
  @override
  bool get isDownloading;
  @override
  double get downloadProgress;
  @override
  DateTime? get lastAccessed;
  @override
  DateTime? get downloadedAt;
  @override
  List<String> get tags;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioTrackImplCopyWith<_$AudioTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Playlist _$PlaylistFromJson(Map<String, dynamic> json) {
  return _Playlist.fromJson(json);
}

/// @nodoc
mixin _$Playlist {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get trackIds => throw _privateConstructorUsedError;
  PlaylistType get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastModified => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  bool get isAutoGenerated => throw _privateConstructorUsedError;
  double? get averageRagScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get ragMetadata => throw _privateConstructorUsedError;

  /// Serializes this Playlist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Playlist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaylistCopyWith<Playlist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistCopyWith<$Res> {
  factory $PlaylistCopyWith(Playlist value, $Res Function(Playlist) then) =
      _$PlaylistCopyWithImpl<$Res, Playlist>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    List<String> trackIds,
    PlaylistType type,
    DateTime createdAt,
    DateTime? lastModified,
    String? coverImageUrl,
    bool isAutoGenerated,
    double? averageRagScore,
    Map<String, dynamic>? ragMetadata,
  });
}

/// @nodoc
class _$PlaylistCopyWithImpl<$Res, $Val extends Playlist>
    implements $PlaylistCopyWith<$Res> {
  _$PlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Playlist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? trackIds = null,
    Object? type = null,
    Object? createdAt = null,
    Object? lastModified = freezed,
    Object? coverImageUrl = freezed,
    Object? isAutoGenerated = null,
    Object? averageRagScore = freezed,
    Object? ragMetadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            trackIds:
                null == trackIds
                    ? _value.trackIds
                    : trackIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as PlaylistType,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastModified:
                freezed == lastModified
                    ? _value.lastModified
                    : lastModified // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            coverImageUrl:
                freezed == coverImageUrl
                    ? _value.coverImageUrl
                    : coverImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            isAutoGenerated:
                null == isAutoGenerated
                    ? _value.isAutoGenerated
                    : isAutoGenerated // ignore: cast_nullable_to_non_nullable
                        as bool,
            averageRagScore:
                freezed == averageRagScore
                    ? _value.averageRagScore
                    : averageRagScore // ignore: cast_nullable_to_non_nullable
                        as double?,
            ragMetadata:
                freezed == ragMetadata
                    ? _value.ragMetadata
                    : ragMetadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaylistImplCopyWith<$Res>
    implements $PlaylistCopyWith<$Res> {
  factory _$$PlaylistImplCopyWith(
    _$PlaylistImpl value,
    $Res Function(_$PlaylistImpl) then,
  ) = __$$PlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    List<String> trackIds,
    PlaylistType type,
    DateTime createdAt,
    DateTime? lastModified,
    String? coverImageUrl,
    bool isAutoGenerated,
    double? averageRagScore,
    Map<String, dynamic>? ragMetadata,
  });
}

/// @nodoc
class __$$PlaylistImplCopyWithImpl<$Res>
    extends _$PlaylistCopyWithImpl<$Res, _$PlaylistImpl>
    implements _$$PlaylistImplCopyWith<$Res> {
  __$$PlaylistImplCopyWithImpl(
    _$PlaylistImpl _value,
    $Res Function(_$PlaylistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Playlist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? trackIds = null,
    Object? type = null,
    Object? createdAt = null,
    Object? lastModified = freezed,
    Object? coverImageUrl = freezed,
    Object? isAutoGenerated = null,
    Object? averageRagScore = freezed,
    Object? ragMetadata = freezed,
  }) {
    return _then(
      _$PlaylistImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        trackIds:
            null == trackIds
                ? _value._trackIds
                : trackIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as PlaylistType,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastModified:
            freezed == lastModified
                ? _value.lastModified
                : lastModified // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        coverImageUrl:
            freezed == coverImageUrl
                ? _value.coverImageUrl
                : coverImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        isAutoGenerated:
            null == isAutoGenerated
                ? _value.isAutoGenerated
                : isAutoGenerated // ignore: cast_nullable_to_non_nullable
                    as bool,
        averageRagScore:
            freezed == averageRagScore
                ? _value.averageRagScore
                : averageRagScore // ignore: cast_nullable_to_non_nullable
                    as double?,
        ragMetadata:
            freezed == ragMetadata
                ? _value._ragMetadata
                : ragMetadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaylistImpl implements _Playlist {
  const _$PlaylistImpl({
    required this.id,
    required this.name,
    required this.description,
    required final List<String> trackIds,
    required this.type,
    required this.createdAt,
    this.lastModified,
    this.coverImageUrl,
    this.isAutoGenerated = false,
    this.averageRagScore,
    final Map<String, dynamic>? ragMetadata,
  }) : _trackIds = trackIds,
       _ragMetadata = ragMetadata;

  factory _$PlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaylistImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<String> _trackIds;
  @override
  List<String> get trackIds {
    if (_trackIds is EqualUnmodifiableListView) return _trackIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trackIds);
  }

  @override
  final PlaylistType type;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastModified;
  @override
  final String? coverImageUrl;
  @override
  @JsonKey()
  final bool isAutoGenerated;
  @override
  final double? averageRagScore;
  final Map<String, dynamic>? _ragMetadata;
  @override
  Map<String, dynamic>? get ragMetadata {
    final value = _ragMetadata;
    if (value == null) return null;
    if (_ragMetadata is EqualUnmodifiableMapView) return _ragMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, description: $description, trackIds: $trackIds, type: $type, createdAt: $createdAt, lastModified: $lastModified, coverImageUrl: $coverImageUrl, isAutoGenerated: $isAutoGenerated, averageRagScore: $averageRagScore, ragMetadata: $ragMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaylistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._trackIds, _trackIds) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.isAutoGenerated, isAutoGenerated) ||
                other.isAutoGenerated == isAutoGenerated) &&
            (identical(other.averageRagScore, averageRagScore) ||
                other.averageRagScore == averageRagScore) &&
            const DeepCollectionEquality().equals(
              other._ragMetadata,
              _ragMetadata,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(_trackIds),
    type,
    createdAt,
    lastModified,
    coverImageUrl,
    isAutoGenerated,
    averageRagScore,
    const DeepCollectionEquality().hash(_ragMetadata),
  );

  /// Create a copy of Playlist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistImplCopyWith<_$PlaylistImpl> get copyWith =>
      __$$PlaylistImplCopyWithImpl<_$PlaylistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaylistImplToJson(this);
  }
}

abstract class _Playlist implements Playlist {
  const factory _Playlist({
    required final String id,
    required final String name,
    required final String description,
    required final List<String> trackIds,
    required final PlaylistType type,
    required final DateTime createdAt,
    final DateTime? lastModified,
    final String? coverImageUrl,
    final bool isAutoGenerated,
    final double? averageRagScore,
    final Map<String, dynamic>? ragMetadata,
  }) = _$PlaylistImpl;

  factory _Playlist.fromJson(Map<String, dynamic> json) =
      _$PlaylistImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get trackIds;
  @override
  PlaylistType get type;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastModified;
  @override
  String? get coverImageUrl;
  @override
  bool get isAutoGenerated;
  @override
  double? get averageRagScore;
  @override
  Map<String, dynamic>? get ragMetadata;

  /// Create a copy of Playlist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaylistImplCopyWith<_$PlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AudioCacheItem _$AudioCacheItemFromJson(Map<String, dynamic> json) {
  return _AudioCacheItem.fromJson(json);
}

/// @nodoc
mixin _$AudioCacheItem {
  String get trackId => throw _privateConstructorUsedError;
  String get localPath => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  DateTime get cachedAt => throw _privateConstructorUsedError;
  String get checksumMd5 => throw _privateConstructorUsedError;
  int get accessCount => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  CacheStatus get status => throw _privateConstructorUsedError;
  CachePriority get priority => throw _privateConstructorUsedError;

  /// Serializes this AudioCacheItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioCacheItemCopyWith<AudioCacheItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioCacheItemCopyWith<$Res> {
  factory $AudioCacheItemCopyWith(
    AudioCacheItem value,
    $Res Function(AudioCacheItem) then,
  ) = _$AudioCacheItemCopyWithImpl<$Res, AudioCacheItem>;
  @useResult
  $Res call({
    String trackId,
    String localPath,
    int fileSizeBytes,
    DateTime cachedAt,
    String checksumMd5,
    int accessCount,
    DateTime? lastAccessed,
    CacheStatus status,
    CachePriority priority,
  });
}

/// @nodoc
class _$AudioCacheItemCopyWithImpl<$Res, $Val extends AudioCacheItem>
    implements $AudioCacheItemCopyWith<$Res> {
  _$AudioCacheItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? localPath = null,
    Object? fileSizeBytes = null,
    Object? cachedAt = null,
    Object? checksumMd5 = null,
    Object? accessCount = null,
    Object? lastAccessed = freezed,
    Object? status = null,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            trackId:
                null == trackId
                    ? _value.trackId
                    : trackId // ignore: cast_nullable_to_non_nullable
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
            cachedAt:
                null == cachedAt
                    ? _value.cachedAt
                    : cachedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            checksumMd5:
                null == checksumMd5
                    ? _value.checksumMd5
                    : checksumMd5 // ignore: cast_nullable_to_non_nullable
                        as String,
            accessCount:
                null == accessCount
                    ? _value.accessCount
                    : accessCount // ignore: cast_nullable_to_non_nullable
                        as int,
            lastAccessed:
                freezed == lastAccessed
                    ? _value.lastAccessed
                    : lastAccessed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as CacheStatus,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as CachePriority,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioCacheItemImplCopyWith<$Res>
    implements $AudioCacheItemCopyWith<$Res> {
  factory _$$AudioCacheItemImplCopyWith(
    _$AudioCacheItemImpl value,
    $Res Function(_$AudioCacheItemImpl) then,
  ) = __$$AudioCacheItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String trackId,
    String localPath,
    int fileSizeBytes,
    DateTime cachedAt,
    String checksumMd5,
    int accessCount,
    DateTime? lastAccessed,
    CacheStatus status,
    CachePriority priority,
  });
}

/// @nodoc
class __$$AudioCacheItemImplCopyWithImpl<$Res>
    extends _$AudioCacheItemCopyWithImpl<$Res, _$AudioCacheItemImpl>
    implements _$$AudioCacheItemImplCopyWith<$Res> {
  __$$AudioCacheItemImplCopyWithImpl(
    _$AudioCacheItemImpl _value,
    $Res Function(_$AudioCacheItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? localPath = null,
    Object? fileSizeBytes = null,
    Object? cachedAt = null,
    Object? checksumMd5 = null,
    Object? accessCount = null,
    Object? lastAccessed = freezed,
    Object? status = null,
    Object? priority = null,
  }) {
    return _then(
      _$AudioCacheItemImpl(
        trackId:
            null == trackId
                ? _value.trackId
                : trackId // ignore: cast_nullable_to_non_nullable
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
        cachedAt:
            null == cachedAt
                ? _value.cachedAt
                : cachedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        checksumMd5:
            null == checksumMd5
                ? _value.checksumMd5
                : checksumMd5 // ignore: cast_nullable_to_non_nullable
                    as String,
        accessCount:
            null == accessCount
                ? _value.accessCount
                : accessCount // ignore: cast_nullable_to_non_nullable
                    as int,
        lastAccessed:
            freezed == lastAccessed
                ? _value.lastAccessed
                : lastAccessed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as CacheStatus,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as CachePriority,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioCacheItemImpl implements _AudioCacheItem {
  const _$AudioCacheItemImpl({
    required this.trackId,
    required this.localPath,
    required this.fileSizeBytes,
    required this.cachedAt,
    required this.checksumMd5,
    required this.accessCount,
    this.lastAccessed,
    this.status = CacheStatus.cached,
    this.priority = CachePriority.normal,
  });

  factory _$AudioCacheItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioCacheItemImplFromJson(json);

  @override
  final String trackId;
  @override
  final String localPath;
  @override
  final int fileSizeBytes;
  @override
  final DateTime cachedAt;
  @override
  final String checksumMd5;
  @override
  final int accessCount;
  @override
  final DateTime? lastAccessed;
  @override
  @JsonKey()
  final CacheStatus status;
  @override
  @JsonKey()
  final CachePriority priority;

  @override
  String toString() {
    return 'AudioCacheItem(trackId: $trackId, localPath: $localPath, fileSizeBytes: $fileSizeBytes, cachedAt: $cachedAt, checksumMd5: $checksumMd5, accessCount: $accessCount, lastAccessed: $lastAccessed, status: $status, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioCacheItemImpl &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.cachedAt, cachedAt) ||
                other.cachedAt == cachedAt) &&
            (identical(other.checksumMd5, checksumMd5) ||
                other.checksumMd5 == checksumMd5) &&
            (identical(other.accessCount, accessCount) ||
                other.accessCount == accessCount) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    trackId,
    localPath,
    fileSizeBytes,
    cachedAt,
    checksumMd5,
    accessCount,
    lastAccessed,
    status,
    priority,
  );

  /// Create a copy of AudioCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioCacheItemImplCopyWith<_$AudioCacheItemImpl> get copyWith =>
      __$$AudioCacheItemImplCopyWithImpl<_$AudioCacheItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioCacheItemImplToJson(this);
  }
}

abstract class _AudioCacheItem implements AudioCacheItem {
  const factory _AudioCacheItem({
    required final String trackId,
    required final String localPath,
    required final int fileSizeBytes,
    required final DateTime cachedAt,
    required final String checksumMd5,
    required final int accessCount,
    final DateTime? lastAccessed,
    final CacheStatus status,
    final CachePriority priority,
  }) = _$AudioCacheItemImpl;

  factory _AudioCacheItem.fromJson(Map<String, dynamic> json) =
      _$AudioCacheItemImpl.fromJson;

  @override
  String get trackId;
  @override
  String get localPath;
  @override
  int get fileSizeBytes;
  @override
  DateTime get cachedAt;
  @override
  String get checksumMd5;
  @override
  int get accessCount;
  @override
  DateTime? get lastAccessed;
  @override
  CacheStatus get status;
  @override
  CachePriority get priority;

  /// Create a copy of AudioCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioCacheItemImplCopyWith<_$AudioCacheItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AudioDownloadJob _$AudioDownloadJobFromJson(Map<String, dynamic> json) {
  return _AudioDownloadJob.fromJson(json);
}

/// @nodoc
mixin _$AudioDownloadJob {
  String get id => throw _privateConstructorUsedError;
  String get trackId => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get targetPath => throw _privateConstructorUsedError;
  DownloadPriority get priority => throw _privateConstructorUsedError;
  DateTime get queuedAt => throw _privateConstructorUsedError;
  DownloadStatus get status => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  int get bytesDownloaded => throw _privateConstructorUsedError;
  int get totalBytes => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;

  /// Serializes this AudioDownloadJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioDownloadJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioDownloadJobCopyWith<AudioDownloadJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioDownloadJobCopyWith<$Res> {
  factory $AudioDownloadJobCopyWith(
    AudioDownloadJob value,
    $Res Function(AudioDownloadJob) then,
  ) = _$AudioDownloadJobCopyWithImpl<$Res, AudioDownloadJob>;
  @useResult
  $Res call({
    String id,
    String trackId,
    String url,
    String targetPath,
    DownloadPriority priority,
    DateTime queuedAt,
    DownloadStatus status,
    double progress,
    int bytesDownloaded,
    int totalBytes,
    DateTime? startedAt,
    DateTime? completedAt,
    String? errorMessage,
    int retryCount,
  });
}

/// @nodoc
class _$AudioDownloadJobCopyWithImpl<$Res, $Val extends AudioDownloadJob>
    implements $AudioDownloadJobCopyWith<$Res> {
  _$AudioDownloadJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioDownloadJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackId = null,
    Object? url = null,
    Object? targetPath = null,
    Object? priority = null,
    Object? queuedAt = null,
    Object? status = null,
    Object? progress = null,
    Object? bytesDownloaded = null,
    Object? totalBytes = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? errorMessage = freezed,
    Object? retryCount = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            trackId:
                null == trackId
                    ? _value.trackId
                    : trackId // ignore: cast_nullable_to_non_nullable
                        as String,
            url:
                null == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String,
            targetPath:
                null == targetPath
                    ? _value.targetPath
                    : targetPath // ignore: cast_nullable_to_non_nullable
                        as String,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as DownloadPriority,
            queuedAt:
                null == queuedAt
                    ? _value.queuedAt
                    : queuedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as DownloadStatus,
            progress:
                null == progress
                    ? _value.progress
                    : progress // ignore: cast_nullable_to_non_nullable
                        as double,
            bytesDownloaded:
                null == bytesDownloaded
                    ? _value.bytesDownloaded
                    : bytesDownloaded // ignore: cast_nullable_to_non_nullable
                        as int,
            totalBytes:
                null == totalBytes
                    ? _value.totalBytes
                    : totalBytes // ignore: cast_nullable_to_non_nullable
                        as int,
            startedAt:
                freezed == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            retryCount:
                null == retryCount
                    ? _value.retryCount
                    : retryCount // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioDownloadJobImplCopyWith<$Res>
    implements $AudioDownloadJobCopyWith<$Res> {
  factory _$$AudioDownloadJobImplCopyWith(
    _$AudioDownloadJobImpl value,
    $Res Function(_$AudioDownloadJobImpl) then,
  ) = __$$AudioDownloadJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String trackId,
    String url,
    String targetPath,
    DownloadPriority priority,
    DateTime queuedAt,
    DownloadStatus status,
    double progress,
    int bytesDownloaded,
    int totalBytes,
    DateTime? startedAt,
    DateTime? completedAt,
    String? errorMessage,
    int retryCount,
  });
}

/// @nodoc
class __$$AudioDownloadJobImplCopyWithImpl<$Res>
    extends _$AudioDownloadJobCopyWithImpl<$Res, _$AudioDownloadJobImpl>
    implements _$$AudioDownloadJobImplCopyWith<$Res> {
  __$$AudioDownloadJobImplCopyWithImpl(
    _$AudioDownloadJobImpl _value,
    $Res Function(_$AudioDownloadJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioDownloadJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackId = null,
    Object? url = null,
    Object? targetPath = null,
    Object? priority = null,
    Object? queuedAt = null,
    Object? status = null,
    Object? progress = null,
    Object? bytesDownloaded = null,
    Object? totalBytes = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? errorMessage = freezed,
    Object? retryCount = null,
  }) {
    return _then(
      _$AudioDownloadJobImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        trackId:
            null == trackId
                ? _value.trackId
                : trackId // ignore: cast_nullable_to_non_nullable
                    as String,
        url:
            null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String,
        targetPath:
            null == targetPath
                ? _value.targetPath
                : targetPath // ignore: cast_nullable_to_non_nullable
                    as String,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as DownloadPriority,
        queuedAt:
            null == queuedAt
                ? _value.queuedAt
                : queuedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as DownloadStatus,
        progress:
            null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as double,
        bytesDownloaded:
            null == bytesDownloaded
                ? _value.bytesDownloaded
                : bytesDownloaded // ignore: cast_nullable_to_non_nullable
                    as int,
        totalBytes:
            null == totalBytes
                ? _value.totalBytes
                : totalBytes // ignore: cast_nullable_to_non_nullable
                    as int,
        startedAt:
            freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        retryCount:
            null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioDownloadJobImpl implements _AudioDownloadJob {
  const _$AudioDownloadJobImpl({
    required this.id,
    required this.trackId,
    required this.url,
    required this.targetPath,
    required this.priority,
    required this.queuedAt,
    this.status = DownloadStatus.queued,
    this.progress = 0.0,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
    this.startedAt,
    this.completedAt,
    this.errorMessage,
    this.retryCount = 0,
  });

  factory _$AudioDownloadJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioDownloadJobImplFromJson(json);

  @override
  final String id;
  @override
  final String trackId;
  @override
  final String url;
  @override
  final String targetPath;
  @override
  final DownloadPriority priority;
  @override
  final DateTime queuedAt;
  @override
  @JsonKey()
  final DownloadStatus status;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final int bytesDownloaded;
  @override
  @JsonKey()
  final int totalBytes;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final int retryCount;

  @override
  String toString() {
    return 'AudioDownloadJob(id: $id, trackId: $trackId, url: $url, targetPath: $targetPath, priority: $priority, queuedAt: $queuedAt, status: $status, progress: $progress, bytesDownloaded: $bytesDownloaded, totalBytes: $totalBytes, startedAt: $startedAt, completedAt: $completedAt, errorMessage: $errorMessage, retryCount: $retryCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioDownloadJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.targetPath, targetPath) ||
                other.targetPath == targetPath) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.queuedAt, queuedAt) ||
                other.queuedAt == queuedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.bytesDownloaded, bytesDownloaded) ||
                other.bytesDownloaded == bytesDownloaded) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    trackId,
    url,
    targetPath,
    priority,
    queuedAt,
    status,
    progress,
    bytesDownloaded,
    totalBytes,
    startedAt,
    completedAt,
    errorMessage,
    retryCount,
  );

  /// Create a copy of AudioDownloadJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioDownloadJobImplCopyWith<_$AudioDownloadJobImpl> get copyWith =>
      __$$AudioDownloadJobImplCopyWithImpl<_$AudioDownloadJobImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioDownloadJobImplToJson(this);
  }
}

abstract class _AudioDownloadJob implements AudioDownloadJob {
  const factory _AudioDownloadJob({
    required final String id,
    required final String trackId,
    required final String url,
    required final String targetPath,
    required final DownloadPriority priority,
    required final DateTime queuedAt,
    final DownloadStatus status,
    final double progress,
    final int bytesDownloaded,
    final int totalBytes,
    final DateTime? startedAt,
    final DateTime? completedAt,
    final String? errorMessage,
    final int retryCount,
  }) = _$AudioDownloadJobImpl;

  factory _AudioDownloadJob.fromJson(Map<String, dynamic> json) =
      _$AudioDownloadJobImpl.fromJson;

  @override
  String get id;
  @override
  String get trackId;
  @override
  String get url;
  @override
  String get targetPath;
  @override
  DownloadPriority get priority;
  @override
  DateTime get queuedAt;
  @override
  DownloadStatus get status;
  @override
  double get progress;
  @override
  int get bytesDownloaded;
  @override
  int get totalBytes;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get errorMessage;
  @override
  int get retryCount;

  /// Create a copy of AudioDownloadJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioDownloadJobImplCopyWith<_$AudioDownloadJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AudioPlaybackState _$AudioPlaybackStateFromJson(Map<String, dynamic> json) {
  return _AudioPlaybackState.fromJson(json);
}

/// @nodoc
mixin _$AudioPlaybackState {
  String? get currentTrackId => throw _privateConstructorUsedError;
  PlayerState get playerState => throw _privateConstructorUsedError;
  Duration get position => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  RepeatMode get repeatMode => throw _privateConstructorUsedError;
  bool get isShuffling => throw _privateConstructorUsedError;
  List<String> get queue => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;

  /// Serializes this AudioPlaybackState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioPlaybackStateCopyWith<AudioPlaybackState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioPlaybackStateCopyWith<$Res> {
  factory $AudioPlaybackStateCopyWith(
    AudioPlaybackState value,
    $Res Function(AudioPlaybackState) then,
  ) = _$AudioPlaybackStateCopyWithImpl<$Res, AudioPlaybackState>;
  @useResult
  $Res call({
    String? currentTrackId,
    PlayerState playerState,
    Duration position,
    Duration duration,
    double speed,
    RepeatMode repeatMode,
    bool isShuffling,
    List<String> queue,
    int currentIndex,
    double volume,
    bool isMuted,
  });
}

/// @nodoc
class _$AudioPlaybackStateCopyWithImpl<$Res, $Val extends AudioPlaybackState>
    implements $AudioPlaybackStateCopyWith<$Res> {
  _$AudioPlaybackStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTrackId = freezed,
    Object? playerState = null,
    Object? position = null,
    Object? duration = null,
    Object? speed = null,
    Object? repeatMode = null,
    Object? isShuffling = null,
    Object? queue = null,
    Object? currentIndex = null,
    Object? volume = null,
    Object? isMuted = null,
  }) {
    return _then(
      _value.copyWith(
            currentTrackId:
                freezed == currentTrackId
                    ? _value.currentTrackId
                    : currentTrackId // ignore: cast_nullable_to_non_nullable
                        as String?,
            playerState:
                null == playerState
                    ? _value.playerState
                    : playerState // ignore: cast_nullable_to_non_nullable
                        as PlayerState,
            position:
                null == position
                    ? _value.position
                    : position // ignore: cast_nullable_to_non_nullable
                        as Duration,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as Duration,
            speed:
                null == speed
                    ? _value.speed
                    : speed // ignore: cast_nullable_to_non_nullable
                        as double,
            repeatMode:
                null == repeatMode
                    ? _value.repeatMode
                    : repeatMode // ignore: cast_nullable_to_non_nullable
                        as RepeatMode,
            isShuffling:
                null == isShuffling
                    ? _value.isShuffling
                    : isShuffling // ignore: cast_nullable_to_non_nullable
                        as bool,
            queue:
                null == queue
                    ? _value.queue
                    : queue // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            currentIndex:
                null == currentIndex
                    ? _value.currentIndex
                    : currentIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            volume:
                null == volume
                    ? _value.volume
                    : volume // ignore: cast_nullable_to_non_nullable
                        as double,
            isMuted:
                null == isMuted
                    ? _value.isMuted
                    : isMuted // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioPlaybackStateImplCopyWith<$Res>
    implements $AudioPlaybackStateCopyWith<$Res> {
  factory _$$AudioPlaybackStateImplCopyWith(
    _$AudioPlaybackStateImpl value,
    $Res Function(_$AudioPlaybackStateImpl) then,
  ) = __$$AudioPlaybackStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? currentTrackId,
    PlayerState playerState,
    Duration position,
    Duration duration,
    double speed,
    RepeatMode repeatMode,
    bool isShuffling,
    List<String> queue,
    int currentIndex,
    double volume,
    bool isMuted,
  });
}

/// @nodoc
class __$$AudioPlaybackStateImplCopyWithImpl<$Res>
    extends _$AudioPlaybackStateCopyWithImpl<$Res, _$AudioPlaybackStateImpl>
    implements _$$AudioPlaybackStateImplCopyWith<$Res> {
  __$$AudioPlaybackStateImplCopyWithImpl(
    _$AudioPlaybackStateImpl _value,
    $Res Function(_$AudioPlaybackStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTrackId = freezed,
    Object? playerState = null,
    Object? position = null,
    Object? duration = null,
    Object? speed = null,
    Object? repeatMode = null,
    Object? isShuffling = null,
    Object? queue = null,
    Object? currentIndex = null,
    Object? volume = null,
    Object? isMuted = null,
  }) {
    return _then(
      _$AudioPlaybackStateImpl(
        currentTrackId:
            freezed == currentTrackId
                ? _value.currentTrackId
                : currentTrackId // ignore: cast_nullable_to_non_nullable
                    as String?,
        playerState:
            null == playerState
                ? _value.playerState
                : playerState // ignore: cast_nullable_to_non_nullable
                    as PlayerState,
        position:
            null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                    as Duration,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as Duration,
        speed:
            null == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                    as double,
        repeatMode:
            null == repeatMode
                ? _value.repeatMode
                : repeatMode // ignore: cast_nullable_to_non_nullable
                    as RepeatMode,
        isShuffling:
            null == isShuffling
                ? _value.isShuffling
                : isShuffling // ignore: cast_nullable_to_non_nullable
                    as bool,
        queue:
            null == queue
                ? _value._queue
                : queue // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        currentIndex:
            null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        volume:
            null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                    as double,
        isMuted:
            null == isMuted
                ? _value.isMuted
                : isMuted // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioPlaybackStateImpl implements _AudioPlaybackState {
  const _$AudioPlaybackStateImpl({
    this.currentTrackId,
    this.playerState = PlayerState.stopped,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.repeatMode = RepeatMode.none,
    this.isShuffling = false,
    final List<String> queue = const [],
    this.currentIndex = 0,
    this.volume = 1.0,
    this.isMuted = false,
  }) : _queue = queue;

  factory _$AudioPlaybackStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioPlaybackStateImplFromJson(json);

  @override
  final String? currentTrackId;
  @override
  @JsonKey()
  final PlayerState playerState;
  @override
  @JsonKey()
  final Duration position;
  @override
  @JsonKey()
  final Duration duration;
  @override
  @JsonKey()
  final double speed;
  @override
  @JsonKey()
  final RepeatMode repeatMode;
  @override
  @JsonKey()
  final bool isShuffling;
  final List<String> _queue;
  @override
  @JsonKey()
  List<String> get queue {
    if (_queue is EqualUnmodifiableListView) return _queue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queue);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final double volume;
  @override
  @JsonKey()
  final bool isMuted;

  @override
  String toString() {
    return 'AudioPlaybackState(currentTrackId: $currentTrackId, playerState: $playerState, position: $position, duration: $duration, speed: $speed, repeatMode: $repeatMode, isShuffling: $isShuffling, queue: $queue, currentIndex: $currentIndex, volume: $volume, isMuted: $isMuted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioPlaybackStateImpl &&
            (identical(other.currentTrackId, currentTrackId) ||
                other.currentTrackId == currentTrackId) &&
            (identical(other.playerState, playerState) ||
                other.playerState == playerState) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.repeatMode, repeatMode) ||
                other.repeatMode == repeatMode) &&
            (identical(other.isShuffling, isShuffling) ||
                other.isShuffling == isShuffling) &&
            const DeepCollectionEquality().equals(other._queue, _queue) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentTrackId,
    playerState,
    position,
    duration,
    speed,
    repeatMode,
    isShuffling,
    const DeepCollectionEquality().hash(_queue),
    currentIndex,
    volume,
    isMuted,
  );

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioPlaybackStateImplCopyWith<_$AudioPlaybackStateImpl> get copyWith =>
      __$$AudioPlaybackStateImplCopyWithImpl<_$AudioPlaybackStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioPlaybackStateImplToJson(this);
  }
}

abstract class _AudioPlaybackState implements AudioPlaybackState {
  const factory _AudioPlaybackState({
    final String? currentTrackId,
    final PlayerState playerState,
    final Duration position,
    final Duration duration,
    final double speed,
    final RepeatMode repeatMode,
    final bool isShuffling,
    final List<String> queue,
    final int currentIndex,
    final double volume,
    final bool isMuted,
  }) = _$AudioPlaybackStateImpl;

  factory _AudioPlaybackState.fromJson(Map<String, dynamic> json) =
      _$AudioPlaybackStateImpl.fromJson;

  @override
  String? get currentTrackId;
  @override
  PlayerState get playerState;
  @override
  Duration get position;
  @override
  Duration get duration;
  @override
  double get speed;
  @override
  RepeatMode get repeatMode;
  @override
  bool get isShuffling;
  @override
  List<String> get queue;
  @override
  int get currentIndex;
  @override
  double get volume;
  @override
  bool get isMuted;

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioPlaybackStateImplCopyWith<_$AudioPlaybackStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
