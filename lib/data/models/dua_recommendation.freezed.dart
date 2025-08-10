// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dua_recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DuaRecommendation _$DuaRecommendationFromJson(Map<String, dynamic> json) {
  return _DuaRecommendation.fromJson(json);
}

/// @nodoc
mixin _$DuaRecommendation {
  String get id => throw _privateConstructorUsedError;
  String get arabicText => throw _privateConstructorUsedError;
  String get transliteration => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  String? get audioFileName => throw _privateConstructorUsedError;
  int? get repetitions => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get hasAudio => throw _privateConstructorUsedError;
  bool get isDownloaded => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;

  /// Serializes this DuaRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuaRecommendationCopyWith<DuaRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuaRecommendationCopyWith<$Res> {
  factory $DuaRecommendationCopyWith(
    DuaRecommendation value,
    $Res Function(DuaRecommendation) then,
  ) = _$DuaRecommendationCopyWithImpl<$Res, DuaRecommendation>;
  @useResult
  $Res call({
    String id,
    String arabicText,
    String transliteration,
    String translation,
    double confidence,
    String? category,
    String? source,
    String? reference,
    String? audioUrl,
    String? audioFileName,
    int? repetitions,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    bool isFavorite,
    bool hasAudio,
    bool isDownloaded,
    DateTime? createdAt,
    DateTime? lastAccessed,
  });
}

/// @nodoc
class _$DuaRecommendationCopyWithImpl<$Res, $Val extends DuaRecommendation>
    implements $DuaRecommendationCopyWith<$Res> {
  _$DuaRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? arabicText = null,
    Object? transliteration = null,
    Object? translation = null,
    Object? confidence = null,
    Object? category = freezed,
    Object? source = freezed,
    Object? reference = freezed,
    Object? audioUrl = freezed,
    Object? audioFileName = freezed,
    Object? repetitions = freezed,
    Object? tags = freezed,
    Object? metadata = freezed,
    Object? isFavorite = null,
    Object? hasAudio = null,
    Object? isDownloaded = null,
    Object? createdAt = freezed,
    Object? lastAccessed = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            arabicText:
                null == arabicText
                    ? _value.arabicText
                    : arabicText // ignore: cast_nullable_to_non_nullable
                        as String,
            transliteration:
                null == transliteration
                    ? _value.transliteration
                    : transliteration // ignore: cast_nullable_to_non_nullable
                        as String,
            translation:
                null == translation
                    ? _value.translation
                    : translation // ignore: cast_nullable_to_non_nullable
                        as String,
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as double,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
            source:
                freezed == source
                    ? _value.source
                    : source // ignore: cast_nullable_to_non_nullable
                        as String?,
            reference:
                freezed == reference
                    ? _value.reference
                    : reference // ignore: cast_nullable_to_non_nullable
                        as String?,
            audioUrl:
                freezed == audioUrl
                    ? _value.audioUrl
                    : audioUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            audioFileName:
                freezed == audioFileName
                    ? _value.audioFileName
                    : audioFileName // ignore: cast_nullable_to_non_nullable
                        as String?,
            repetitions:
                freezed == repetitions
                    ? _value.repetitions
                    : repetitions // ignore: cast_nullable_to_non_nullable
                        as int?,
            tags:
                freezed == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
            hasAudio:
                null == hasAudio
                    ? _value.hasAudio
                    : hasAudio // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDownloaded:
                null == isDownloaded
                    ? _value.isDownloaded
                    : isDownloaded // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastAccessed:
                freezed == lastAccessed
                    ? _value.lastAccessed
                    : lastAccessed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DuaRecommendationImplCopyWith<$Res>
    implements $DuaRecommendationCopyWith<$Res> {
  factory _$$DuaRecommendationImplCopyWith(
    _$DuaRecommendationImpl value,
    $Res Function(_$DuaRecommendationImpl) then,
  ) = __$$DuaRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String arabicText,
    String transliteration,
    String translation,
    double confidence,
    String? category,
    String? source,
    String? reference,
    String? audioUrl,
    String? audioFileName,
    int? repetitions,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    bool isFavorite,
    bool hasAudio,
    bool isDownloaded,
    DateTime? createdAt,
    DateTime? lastAccessed,
  });
}

/// @nodoc
class __$$DuaRecommendationImplCopyWithImpl<$Res>
    extends _$DuaRecommendationCopyWithImpl<$Res, _$DuaRecommendationImpl>
    implements _$$DuaRecommendationImplCopyWith<$Res> {
  __$$DuaRecommendationImplCopyWithImpl(
    _$DuaRecommendationImpl _value,
    $Res Function(_$DuaRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? arabicText = null,
    Object? transliteration = null,
    Object? translation = null,
    Object? confidence = null,
    Object? category = freezed,
    Object? source = freezed,
    Object? reference = freezed,
    Object? audioUrl = freezed,
    Object? audioFileName = freezed,
    Object? repetitions = freezed,
    Object? tags = freezed,
    Object? metadata = freezed,
    Object? isFavorite = null,
    Object? hasAudio = null,
    Object? isDownloaded = null,
    Object? createdAt = freezed,
    Object? lastAccessed = freezed,
  }) {
    return _then(
      _$DuaRecommendationImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        arabicText:
            null == arabicText
                ? _value.arabicText
                : arabicText // ignore: cast_nullable_to_non_nullable
                    as String,
        transliteration:
            null == transliteration
                ? _value.transliteration
                : transliteration // ignore: cast_nullable_to_non_nullable
                    as String,
        translation:
            null == translation
                ? _value.translation
                : translation // ignore: cast_nullable_to_non_nullable
                    as String,
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as double,
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
        source:
            freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                    as String?,
        reference:
            freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                    as String?,
        audioUrl:
            freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        audioFileName:
            freezed == audioFileName
                ? _value.audioFileName
                : audioFileName // ignore: cast_nullable_to_non_nullable
                    as String?,
        repetitions:
            freezed == repetitions
                ? _value.repetitions
                : repetitions // ignore: cast_nullable_to_non_nullable
                    as int?,
        tags:
            freezed == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
        hasAudio:
            null == hasAudio
                ? _value.hasAudio
                : hasAudio // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDownloaded:
            null == isDownloaded
                ? _value.isDownloaded
                : isDownloaded // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastAccessed:
            freezed == lastAccessed
                ? _value.lastAccessed
                : lastAccessed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DuaRecommendationImpl implements _DuaRecommendation {
  const _$DuaRecommendationImpl({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.confidence,
    this.category,
    this.source,
    this.reference,
    this.audioUrl,
    this.audioFileName,
    this.repetitions,
    final List<String>? tags,
    final Map<String, dynamic>? metadata,
    this.isFavorite = false,
    this.hasAudio = false,
    this.isDownloaded = false,
    this.createdAt,
    this.lastAccessed,
  }) : _tags = tags,
       _metadata = metadata;

  factory _$DuaRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuaRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  final String arabicText;
  @override
  final String transliteration;
  @override
  final String translation;
  @override
  final double confidence;
  @override
  final String? category;
  @override
  final String? source;
  @override
  final String? reference;
  @override
  final String? audioUrl;
  @override
  final String? audioFileName;
  @override
  final int? repetitions;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
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
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool hasAudio;
  @override
  @JsonKey()
  final bool isDownloaded;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastAccessed;

  @override
  String toString() {
    return 'DuaRecommendation(id: $id, arabicText: $arabicText, transliteration: $transliteration, translation: $translation, confidence: $confidence, category: $category, source: $source, reference: $reference, audioUrl: $audioUrl, audioFileName: $audioFileName, repetitions: $repetitions, tags: $tags, metadata: $metadata, isFavorite: $isFavorite, hasAudio: $hasAudio, isDownloaded: $isDownloaded, createdAt: $createdAt, lastAccessed: $lastAccessed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuaRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.arabicText, arabicText) ||
                other.arabicText == arabicText) &&
            (identical(other.transliteration, transliteration) ||
                other.transliteration == transliteration) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.audioFileName, audioFileName) ||
                other.audioFileName == audioFileName) &&
            (identical(other.repetitions, repetitions) ||
                other.repetitions == repetitions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.hasAudio, hasAudio) ||
                other.hasAudio == hasAudio) &&
            (identical(other.isDownloaded, isDownloaded) ||
                other.isDownloaded == isDownloaded) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    arabicText,
    transliteration,
    translation,
    confidence,
    category,
    source,
    reference,
    audioUrl,
    audioFileName,
    repetitions,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_metadata),
    isFavorite,
    hasAudio,
    isDownloaded,
    createdAt,
    lastAccessed,
  );

  /// Create a copy of DuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuaRecommendationImplCopyWith<_$DuaRecommendationImpl> get copyWith =>
      __$$DuaRecommendationImplCopyWithImpl<_$DuaRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DuaRecommendationImplToJson(this);
  }
}

abstract class _DuaRecommendation implements DuaRecommendation {
  const factory _DuaRecommendation({
    required final String id,
    required final String arabicText,
    required final String transliteration,
    required final String translation,
    required final double confidence,
    final String? category,
    final String? source,
    final String? reference,
    final String? audioUrl,
    final String? audioFileName,
    final int? repetitions,
    final List<String>? tags,
    final Map<String, dynamic>? metadata,
    final bool isFavorite,
    final bool hasAudio,
    final bool isDownloaded,
    final DateTime? createdAt,
    final DateTime? lastAccessed,
  }) = _$DuaRecommendationImpl;

  factory _DuaRecommendation.fromJson(Map<String, dynamic> json) =
      _$DuaRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  String get arabicText;
  @override
  String get transliteration;
  @override
  String get translation;
  @override
  double get confidence;
  @override
  String? get category;
  @override
  String? get source;
  @override
  String? get reference;
  @override
  String? get audioUrl;
  @override
  String? get audioFileName;
  @override
  int? get repetitions;
  @override
  List<String>? get tags;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isFavorite;
  @override
  bool get hasAudio;
  @override
  bool get isDownloaded;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastAccessed;

  /// Create a copy of DuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuaRecommendationImplCopyWith<_$DuaRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
