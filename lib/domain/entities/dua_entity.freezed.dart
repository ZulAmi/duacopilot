// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dua_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DuaEntity _$DuaEntityFromJson(Map<String, dynamic> json) {
  return _DuaEntity.fromJson(json);
}

/// @nodoc
mixin _$DuaEntity {
  String get id => throw _privateConstructorUsedError;
  String get arabicText => throw _privateConstructorUsedError;
  String get transliteration => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  SourceAuthenticity get authenticity => throw _privateConstructorUsedError;
  RAGConfidence get ragConfidence => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  String? get context => throw _privateConstructorUsedError;
  String? get benefits => throw _privateConstructorUsedError;
  List<String>? get relatedDuas => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;

  /// Serializes this DuaEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuaEntityCopyWith<DuaEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuaEntityCopyWith<$Res> {
  factory $DuaEntityCopyWith(DuaEntity value, $Res Function(DuaEntity) then) =
      _$DuaEntityCopyWithImpl<$Res, DuaEntity>;
  @useResult
  $Res call({
    String id,
    String arabicText,
    String transliteration,
    String translation,
    String category,
    List<String> tags,
    SourceAuthenticity authenticity,
    RAGConfidence ragConfidence,
    String? audioUrl,
    String? context,
    String? benefits,
    List<String>? relatedDuas,
    bool isFavorite,
    DateTime? lastAccessed,
  });

  $SourceAuthenticityCopyWith<$Res> get authenticity;
  $RAGConfidenceCopyWith<$Res> get ragConfidence;
}

/// @nodoc
class _$DuaEntityCopyWithImpl<$Res, $Val extends DuaEntity>
    implements $DuaEntityCopyWith<$Res> {
  _$DuaEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? arabicText = null,
    Object? transliteration = null,
    Object? translation = null,
    Object? category = null,
    Object? tags = null,
    Object? authenticity = null,
    Object? ragConfidence = null,
    Object? audioUrl = freezed,
    Object? context = freezed,
    Object? benefits = freezed,
    Object? relatedDuas = freezed,
    Object? isFavorite = null,
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
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            authenticity:
                null == authenticity
                    ? _value.authenticity
                    : authenticity // ignore: cast_nullable_to_non_nullable
                        as SourceAuthenticity,
            ragConfidence:
                null == ragConfidence
                    ? _value.ragConfidence
                    : ragConfidence // ignore: cast_nullable_to_non_nullable
                        as RAGConfidence,
            audioUrl:
                freezed == audioUrl
                    ? _value.audioUrl
                    : audioUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            context:
                freezed == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as String?,
            benefits:
                freezed == benefits
                    ? _value.benefits
                    : benefits // ignore: cast_nullable_to_non_nullable
                        as String?,
            relatedDuas:
                freezed == relatedDuas
                    ? _value.relatedDuas
                    : relatedDuas // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
            lastAccessed:
                freezed == lastAccessed
                    ? _value.lastAccessed
                    : lastAccessed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SourceAuthenticityCopyWith<$Res> get authenticity {
    return $SourceAuthenticityCopyWith<$Res>(_value.authenticity, (value) {
      return _then(_value.copyWith(authenticity: value) as $Val);
    });
  }

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RAGConfidenceCopyWith<$Res> get ragConfidence {
    return $RAGConfidenceCopyWith<$Res>(_value.ragConfidence, (value) {
      return _then(_value.copyWith(ragConfidence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DuaEntityImplCopyWith<$Res>
    implements $DuaEntityCopyWith<$Res> {
  factory _$$DuaEntityImplCopyWith(
    _$DuaEntityImpl value,
    $Res Function(_$DuaEntityImpl) then,
  ) = __$$DuaEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String arabicText,
    String transliteration,
    String translation,
    String category,
    List<String> tags,
    SourceAuthenticity authenticity,
    RAGConfidence ragConfidence,
    String? audioUrl,
    String? context,
    String? benefits,
    List<String>? relatedDuas,
    bool isFavorite,
    DateTime? lastAccessed,
  });

  @override
  $SourceAuthenticityCopyWith<$Res> get authenticity;
  @override
  $RAGConfidenceCopyWith<$Res> get ragConfidence;
}

/// @nodoc
class __$$DuaEntityImplCopyWithImpl<$Res>
    extends _$DuaEntityCopyWithImpl<$Res, _$DuaEntityImpl>
    implements _$$DuaEntityImplCopyWith<$Res> {
  __$$DuaEntityImplCopyWithImpl(
    _$DuaEntityImpl _value,
    $Res Function(_$DuaEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? arabicText = null,
    Object? transliteration = null,
    Object? translation = null,
    Object? category = null,
    Object? tags = null,
    Object? authenticity = null,
    Object? ragConfidence = null,
    Object? audioUrl = freezed,
    Object? context = freezed,
    Object? benefits = freezed,
    Object? relatedDuas = freezed,
    Object? isFavorite = null,
    Object? lastAccessed = freezed,
  }) {
    return _then(
      _$DuaEntityImpl(
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
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        authenticity:
            null == authenticity
                ? _value.authenticity
                : authenticity // ignore: cast_nullable_to_non_nullable
                    as SourceAuthenticity,
        ragConfidence:
            null == ragConfidence
                ? _value.ragConfidence
                : ragConfidence // ignore: cast_nullable_to_non_nullable
                    as RAGConfidence,
        audioUrl:
            freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        context:
            freezed == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                    as String?,
        benefits:
            freezed == benefits
                ? _value.benefits
                : benefits // ignore: cast_nullable_to_non_nullable
                    as String?,
        relatedDuas:
            freezed == relatedDuas
                ? _value._relatedDuas
                : relatedDuas // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
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
class _$DuaEntityImpl implements _DuaEntity {
  const _$DuaEntityImpl({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.category,
    required final List<String> tags,
    required this.authenticity,
    required this.ragConfidence,
    this.audioUrl,
    this.context,
    this.benefits,
    final List<String>? relatedDuas,
    this.isFavorite = false,
    this.lastAccessed,
  }) : _tags = tags,
       _relatedDuas = relatedDuas;

  factory _$DuaEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuaEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String arabicText;
  @override
  final String transliteration;
  @override
  final String translation;
  @override
  final String category;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final SourceAuthenticity authenticity;
  @override
  final RAGConfidence ragConfidence;
  @override
  final String? audioUrl;
  @override
  final String? context;
  @override
  final String? benefits;
  final List<String>? _relatedDuas;
  @override
  List<String>? get relatedDuas {
    final value = _relatedDuas;
    if (value == null) return null;
    if (_relatedDuas is EqualUnmodifiableListView) return _relatedDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? lastAccessed;

  @override
  String toString() {
    return 'DuaEntity(id: $id, arabicText: $arabicText, transliteration: $transliteration, translation: $translation, category: $category, tags: $tags, authenticity: $authenticity, ragConfidence: $ragConfidence, audioUrl: $audioUrl, context: $context, benefits: $benefits, relatedDuas: $relatedDuas, isFavorite: $isFavorite, lastAccessed: $lastAccessed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuaEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.arabicText, arabicText) ||
                other.arabicText == arabicText) &&
            (identical(other.transliteration, transliteration) ||
                other.transliteration == transliteration) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.authenticity, authenticity) ||
                other.authenticity == authenticity) &&
            (identical(other.ragConfidence, ragConfidence) ||
                other.ragConfidence == ragConfidence) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.benefits, benefits) ||
                other.benefits == benefits) &&
            const DeepCollectionEquality().equals(
              other._relatedDuas,
              _relatedDuas,
            ) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
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
    category,
    const DeepCollectionEquality().hash(_tags),
    authenticity,
    ragConfidence,
    audioUrl,
    context,
    benefits,
    const DeepCollectionEquality().hash(_relatedDuas),
    isFavorite,
    lastAccessed,
  );

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuaEntityImplCopyWith<_$DuaEntityImpl> get copyWith =>
      __$$DuaEntityImplCopyWithImpl<_$DuaEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DuaEntityImplToJson(this);
  }
}

abstract class _DuaEntity implements DuaEntity {
  const factory _DuaEntity({
    required final String id,
    required final String arabicText,
    required final String transliteration,
    required final String translation,
    required final String category,
    required final List<String> tags,
    required final SourceAuthenticity authenticity,
    required final RAGConfidence ragConfidence,
    final String? audioUrl,
    final String? context,
    final String? benefits,
    final List<String>? relatedDuas,
    final bool isFavorite,
    final DateTime? lastAccessed,
  }) = _$DuaEntityImpl;

  factory _DuaEntity.fromJson(Map<String, dynamic> json) =
      _$DuaEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get arabicText;
  @override
  String get transliteration;
  @override
  String get translation;
  @override
  String get category;
  @override
  List<String> get tags;
  @override
  SourceAuthenticity get authenticity;
  @override
  RAGConfidence get ragConfidence;
  @override
  String? get audioUrl;
  @override
  String? get context;
  @override
  String? get benefits;
  @override
  List<String>? get relatedDuas;
  @override
  bool get isFavorite;
  @override
  DateTime? get lastAccessed;

  /// Create a copy of DuaEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuaEntityImplCopyWith<_$DuaEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SourceAuthenticity _$SourceAuthenticityFromJson(Map<String, dynamic> json) {
  return _SourceAuthenticity.fromJson(json);
}

/// @nodoc
mixin _$SourceAuthenticity {
  AuthenticityLevel get level => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get hadithGrade => throw _privateConstructorUsedError;
  String? get chain => throw _privateConstructorUsedError;
  String? get scholar => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;

  /// Serializes this SourceAuthenticity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourceAuthenticity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourceAuthenticityCopyWith<SourceAuthenticity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceAuthenticityCopyWith<$Res> {
  factory $SourceAuthenticityCopyWith(
    SourceAuthenticity value,
    $Res Function(SourceAuthenticity) then,
  ) = _$SourceAuthenticityCopyWithImpl<$Res, SourceAuthenticity>;
  @useResult
  $Res call({
    AuthenticityLevel level,
    String source,
    String reference,
    String? hadithGrade,
    String? chain,
    String? scholar,
    double confidenceScore,
  });
}

/// @nodoc
class _$SourceAuthenticityCopyWithImpl<$Res, $Val extends SourceAuthenticity>
    implements $SourceAuthenticityCopyWith<$Res> {
  _$SourceAuthenticityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourceAuthenticity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? source = null,
    Object? reference = null,
    Object? hadithGrade = freezed,
    Object? chain = freezed,
    Object? scholar = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(
      _value.copyWith(
            level:
                null == level
                    ? _value.level
                    : level // ignore: cast_nullable_to_non_nullable
                        as AuthenticityLevel,
            source:
                null == source
                    ? _value.source
                    : source // ignore: cast_nullable_to_non_nullable
                        as String,
            reference:
                null == reference
                    ? _value.reference
                    : reference // ignore: cast_nullable_to_non_nullable
                        as String,
            hadithGrade:
                freezed == hadithGrade
                    ? _value.hadithGrade
                    : hadithGrade // ignore: cast_nullable_to_non_nullable
                        as String?,
            chain:
                freezed == chain
                    ? _value.chain
                    : chain // ignore: cast_nullable_to_non_nullable
                        as String?,
            scholar:
                freezed == scholar
                    ? _value.scholar
                    : scholar // ignore: cast_nullable_to_non_nullable
                        as String?,
            confidenceScore:
                null == confidenceScore
                    ? _value.confidenceScore
                    : confidenceScore // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SourceAuthenticityImplCopyWith<$Res>
    implements $SourceAuthenticityCopyWith<$Res> {
  factory _$$SourceAuthenticityImplCopyWith(
    _$SourceAuthenticityImpl value,
    $Res Function(_$SourceAuthenticityImpl) then,
  ) = __$$SourceAuthenticityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AuthenticityLevel level,
    String source,
    String reference,
    String? hadithGrade,
    String? chain,
    String? scholar,
    double confidenceScore,
  });
}

/// @nodoc
class __$$SourceAuthenticityImplCopyWithImpl<$Res>
    extends _$SourceAuthenticityCopyWithImpl<$Res, _$SourceAuthenticityImpl>
    implements _$$SourceAuthenticityImplCopyWith<$Res> {
  __$$SourceAuthenticityImplCopyWithImpl(
    _$SourceAuthenticityImpl _value,
    $Res Function(_$SourceAuthenticityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SourceAuthenticity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? source = null,
    Object? reference = null,
    Object? hadithGrade = freezed,
    Object? chain = freezed,
    Object? scholar = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(
      _$SourceAuthenticityImpl(
        level:
            null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                    as AuthenticityLevel,
        source:
            null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                    as String,
        reference:
            null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                    as String,
        hadithGrade:
            freezed == hadithGrade
                ? _value.hadithGrade
                : hadithGrade // ignore: cast_nullable_to_non_nullable
                    as String?,
        chain:
            freezed == chain
                ? _value.chain
                : chain // ignore: cast_nullable_to_non_nullable
                    as String?,
        scholar:
            freezed == scholar
                ? _value.scholar
                : scholar // ignore: cast_nullable_to_non_nullable
                    as String?,
        confidenceScore:
            null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SourceAuthenticityImpl implements _SourceAuthenticity {
  const _$SourceAuthenticityImpl({
    required this.level,
    required this.source,
    required this.reference,
    this.hadithGrade,
    this.chain,
    this.scholar,
    this.confidenceScore = 1.0,
  });

  factory _$SourceAuthenticityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceAuthenticityImplFromJson(json);

  @override
  final AuthenticityLevel level;
  @override
  final String source;
  @override
  final String reference;
  @override
  final String? hadithGrade;
  @override
  final String? chain;
  @override
  final String? scholar;
  @override
  @JsonKey()
  final double confidenceScore;

  @override
  String toString() {
    return 'SourceAuthenticity(level: $level, source: $source, reference: $reference, hadithGrade: $hadithGrade, chain: $chain, scholar: $scholar, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceAuthenticityImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.hadithGrade, hadithGrade) ||
                other.hadithGrade == hadithGrade) &&
            (identical(other.chain, chain) || other.chain == chain) &&
            (identical(other.scholar, scholar) || other.scholar == scholar) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    level,
    source,
    reference,
    hadithGrade,
    chain,
    scholar,
    confidenceScore,
  );

  /// Create a copy of SourceAuthenticity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceAuthenticityImplCopyWith<_$SourceAuthenticityImpl> get copyWith =>
      __$$SourceAuthenticityImplCopyWithImpl<_$SourceAuthenticityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceAuthenticityImplToJson(this);
  }
}

abstract class _SourceAuthenticity implements SourceAuthenticity {
  const factory _SourceAuthenticity({
    required final AuthenticityLevel level,
    required final String source,
    required final String reference,
    final String? hadithGrade,
    final String? chain,
    final String? scholar,
    final double confidenceScore,
  }) = _$SourceAuthenticityImpl;

  factory _SourceAuthenticity.fromJson(Map<String, dynamic> json) =
      _$SourceAuthenticityImpl.fromJson;

  @override
  AuthenticityLevel get level;
  @override
  String get source;
  @override
  String get reference;
  @override
  String? get hadithGrade;
  @override
  String? get chain;
  @override
  String? get scholar;
  @override
  double get confidenceScore;

  /// Create a copy of SourceAuthenticity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourceAuthenticityImplCopyWith<_$SourceAuthenticityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RAGConfidence _$RAGConfidenceFromJson(Map<String, dynamic> json) {
  return _RAGConfidence.fromJson(json);
}

/// @nodoc
mixin _$RAGConfidence {
  double get score => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  ContextMatch get contextMatch => throw _privateConstructorUsedError;
  List<String>? get similarQueries => throw _privateConstructorUsedError;
  Map<String, double>? get semanticSimilarity =>
      throw _privateConstructorUsedError;
  List<String> get supportingEvidence => throw _privateConstructorUsedError;

  /// Serializes this RAGConfidence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RAGConfidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RAGConfidenceCopyWith<RAGConfidence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RAGConfidenceCopyWith<$Res> {
  factory $RAGConfidenceCopyWith(
    RAGConfidence value,
    $Res Function(RAGConfidence) then,
  ) = _$RAGConfidenceCopyWithImpl<$Res, RAGConfidence>;
  @useResult
  $Res call({
    double score,
    String reasoning,
    List<String> keywords,
    ContextMatch contextMatch,
    List<String>? similarQueries,
    Map<String, double>? semanticSimilarity,
    List<String> supportingEvidence,
  });

  $ContextMatchCopyWith<$Res> get contextMatch;
}

/// @nodoc
class _$RAGConfidenceCopyWithImpl<$Res, $Val extends RAGConfidence>
    implements $RAGConfidenceCopyWith<$Res> {
  _$RAGConfidenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RAGConfidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? reasoning = null,
    Object? keywords = null,
    Object? contextMatch = null,
    Object? similarQueries = freezed,
    Object? semanticSimilarity = freezed,
    Object? supportingEvidence = null,
  }) {
    return _then(
      _value.copyWith(
            score:
                null == score
                    ? _value.score
                    : score // ignore: cast_nullable_to_non_nullable
                        as double,
            reasoning:
                null == reasoning
                    ? _value.reasoning
                    : reasoning // ignore: cast_nullable_to_non_nullable
                        as String,
            keywords:
                null == keywords
                    ? _value.keywords
                    : keywords // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            contextMatch:
                null == contextMatch
                    ? _value.contextMatch
                    : contextMatch // ignore: cast_nullable_to_non_nullable
                        as ContextMatch,
            similarQueries:
                freezed == similarQueries
                    ? _value.similarQueries
                    : similarQueries // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            semanticSimilarity:
                freezed == semanticSimilarity
                    ? _value.semanticSimilarity
                    : semanticSimilarity // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>?,
            supportingEvidence:
                null == supportingEvidence
                    ? _value.supportingEvidence
                    : supportingEvidence // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of RAGConfidence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContextMatchCopyWith<$Res> get contextMatch {
    return $ContextMatchCopyWith<$Res>(_value.contextMatch, (value) {
      return _then(_value.copyWith(contextMatch: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RAGConfidenceImplCopyWith<$Res>
    implements $RAGConfidenceCopyWith<$Res> {
  factory _$$RAGConfidenceImplCopyWith(
    _$RAGConfidenceImpl value,
    $Res Function(_$RAGConfidenceImpl) then,
  ) = __$$RAGConfidenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double score,
    String reasoning,
    List<String> keywords,
    ContextMatch contextMatch,
    List<String>? similarQueries,
    Map<String, double>? semanticSimilarity,
    List<String> supportingEvidence,
  });

  @override
  $ContextMatchCopyWith<$Res> get contextMatch;
}

/// @nodoc
class __$$RAGConfidenceImplCopyWithImpl<$Res>
    extends _$RAGConfidenceCopyWithImpl<$Res, _$RAGConfidenceImpl>
    implements _$$RAGConfidenceImplCopyWith<$Res> {
  __$$RAGConfidenceImplCopyWithImpl(
    _$RAGConfidenceImpl _value,
    $Res Function(_$RAGConfidenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RAGConfidence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? reasoning = null,
    Object? keywords = null,
    Object? contextMatch = null,
    Object? similarQueries = freezed,
    Object? semanticSimilarity = freezed,
    Object? supportingEvidence = null,
  }) {
    return _then(
      _$RAGConfidenceImpl(
        score:
            null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                    as double,
        reasoning:
            null == reasoning
                ? _value.reasoning
                : reasoning // ignore: cast_nullable_to_non_nullable
                    as String,
        keywords:
            null == keywords
                ? _value._keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        contextMatch:
            null == contextMatch
                ? _value.contextMatch
                : contextMatch // ignore: cast_nullable_to_non_nullable
                    as ContextMatch,
        similarQueries:
            freezed == similarQueries
                ? _value._similarQueries
                : similarQueries // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        semanticSimilarity:
            freezed == semanticSimilarity
                ? _value._semanticSimilarity
                : semanticSimilarity // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>?,
        supportingEvidence:
            null == supportingEvidence
                ? _value._supportingEvidence
                : supportingEvidence // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RAGConfidenceImpl implements _RAGConfidence {
  const _$RAGConfidenceImpl({
    required this.score,
    required this.reasoning,
    required final List<String> keywords,
    required this.contextMatch,
    final List<String>? similarQueries,
    final Map<String, double>? semanticSimilarity,
    final List<String> supportingEvidence = const [],
  }) : _keywords = keywords,
       _similarQueries = similarQueries,
       _semanticSimilarity = semanticSimilarity,
       _supportingEvidence = supportingEvidence;

  factory _$RAGConfidenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RAGConfidenceImplFromJson(json);

  @override
  final double score;
  @override
  final String reasoning;
  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  final ContextMatch contextMatch;
  final List<String>? _similarQueries;
  @override
  List<String>? get similarQueries {
    final value = _similarQueries;
    if (value == null) return null;
    if (_similarQueries is EqualUnmodifiableListView) return _similarQueries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, double>? _semanticSimilarity;
  @override
  Map<String, double>? get semanticSimilarity {
    final value = _semanticSimilarity;
    if (value == null) return null;
    if (_semanticSimilarity is EqualUnmodifiableMapView)
      return _semanticSimilarity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _supportingEvidence;
  @override
  @JsonKey()
  List<String> get supportingEvidence {
    if (_supportingEvidence is EqualUnmodifiableListView)
      return _supportingEvidence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportingEvidence);
  }

  @override
  String toString() {
    return 'RAGConfidence(score: $score, reasoning: $reasoning, keywords: $keywords, contextMatch: $contextMatch, similarQueries: $similarQueries, semanticSimilarity: $semanticSimilarity, supportingEvidence: $supportingEvidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RAGConfidenceImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.contextMatch, contextMatch) ||
                other.contextMatch == contextMatch) &&
            const DeepCollectionEquality().equals(
              other._similarQueries,
              _similarQueries,
            ) &&
            const DeepCollectionEquality().equals(
              other._semanticSimilarity,
              _semanticSimilarity,
            ) &&
            const DeepCollectionEquality().equals(
              other._supportingEvidence,
              _supportingEvidence,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    reasoning,
    const DeepCollectionEquality().hash(_keywords),
    contextMatch,
    const DeepCollectionEquality().hash(_similarQueries),
    const DeepCollectionEquality().hash(_semanticSimilarity),
    const DeepCollectionEquality().hash(_supportingEvidence),
  );

  /// Create a copy of RAGConfidence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RAGConfidenceImplCopyWith<_$RAGConfidenceImpl> get copyWith =>
      __$$RAGConfidenceImplCopyWithImpl<_$RAGConfidenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RAGConfidenceImplToJson(this);
  }
}

abstract class _RAGConfidence implements RAGConfidence {
  const factory _RAGConfidence({
    required final double score,
    required final String reasoning,
    required final List<String> keywords,
    required final ContextMatch contextMatch,
    final List<String>? similarQueries,
    final Map<String, double>? semanticSimilarity,
    final List<String> supportingEvidence,
  }) = _$RAGConfidenceImpl;

  factory _RAGConfidence.fromJson(Map<String, dynamic> json) =
      _$RAGConfidenceImpl.fromJson;

  @override
  double get score;
  @override
  String get reasoning;
  @override
  List<String> get keywords;
  @override
  ContextMatch get contextMatch;
  @override
  List<String>? get similarQueries;
  @override
  Map<String, double>? get semanticSimilarity;
  @override
  List<String> get supportingEvidence;

  /// Create a copy of RAGConfidence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RAGConfidenceImplCopyWith<_$RAGConfidenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContextMatch _$ContextMatchFromJson(Map<String, dynamic> json) {
  return _ContextMatch.fromJson(json);
}

/// @nodoc
mixin _$ContextMatch {
  double get relevanceScore => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get matchingCriteria => throw _privateConstructorUsedError;
  String? get timeOfDay => throw _privateConstructorUsedError;
  String? get situation => throw _privateConstructorUsedError;
  String? get emotionalState => throw _privateConstructorUsedError;

  /// Serializes this ContextMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContextMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContextMatchCopyWith<ContextMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextMatchCopyWith<$Res> {
  factory $ContextMatchCopyWith(
    ContextMatch value,
    $Res Function(ContextMatch) then,
  ) = _$ContextMatchCopyWithImpl<$Res, ContextMatch>;
  @useResult
  $Res call({
    double relevanceScore,
    String category,
    List<String> matchingCriteria,
    String? timeOfDay,
    String? situation,
    String? emotionalState,
  });
}

/// @nodoc
class _$ContextMatchCopyWithImpl<$Res, $Val extends ContextMatch>
    implements $ContextMatchCopyWith<$Res> {
  _$ContextMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContextMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relevanceScore = null,
    Object? category = null,
    Object? matchingCriteria = null,
    Object? timeOfDay = freezed,
    Object? situation = freezed,
    Object? emotionalState = freezed,
  }) {
    return _then(
      _value.copyWith(
            relevanceScore:
                null == relevanceScore
                    ? _value.relevanceScore
                    : relevanceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String,
            matchingCriteria:
                null == matchingCriteria
                    ? _value.matchingCriteria
                    : matchingCriteria // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            timeOfDay:
                freezed == timeOfDay
                    ? _value.timeOfDay
                    : timeOfDay // ignore: cast_nullable_to_non_nullable
                        as String?,
            situation:
                freezed == situation
                    ? _value.situation
                    : situation // ignore: cast_nullable_to_non_nullable
                        as String?,
            emotionalState:
                freezed == emotionalState
                    ? _value.emotionalState
                    : emotionalState // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContextMatchImplCopyWith<$Res>
    implements $ContextMatchCopyWith<$Res> {
  factory _$$ContextMatchImplCopyWith(
    _$ContextMatchImpl value,
    $Res Function(_$ContextMatchImpl) then,
  ) = __$$ContextMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double relevanceScore,
    String category,
    List<String> matchingCriteria,
    String? timeOfDay,
    String? situation,
    String? emotionalState,
  });
}

/// @nodoc
class __$$ContextMatchImplCopyWithImpl<$Res>
    extends _$ContextMatchCopyWithImpl<$Res, _$ContextMatchImpl>
    implements _$$ContextMatchImplCopyWith<$Res> {
  __$$ContextMatchImplCopyWithImpl(
    _$ContextMatchImpl _value,
    $Res Function(_$ContextMatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContextMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relevanceScore = null,
    Object? category = null,
    Object? matchingCriteria = null,
    Object? timeOfDay = freezed,
    Object? situation = freezed,
    Object? emotionalState = freezed,
  }) {
    return _then(
      _$ContextMatchImpl(
        relevanceScore:
            null == relevanceScore
                ? _value.relevanceScore
                : relevanceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String,
        matchingCriteria:
            null == matchingCriteria
                ? _value._matchingCriteria
                : matchingCriteria // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        timeOfDay:
            freezed == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                    as String?,
        situation:
            freezed == situation
                ? _value.situation
                : situation // ignore: cast_nullable_to_non_nullable
                    as String?,
        emotionalState:
            freezed == emotionalState
                ? _value.emotionalState
                : emotionalState // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContextMatchImpl implements _ContextMatch {
  const _$ContextMatchImpl({
    required this.relevanceScore,
    required this.category,
    required final List<String> matchingCriteria,
    this.timeOfDay,
    this.situation,
    this.emotionalState,
  }) : _matchingCriteria = matchingCriteria;

  factory _$ContextMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContextMatchImplFromJson(json);

  @override
  final double relevanceScore;
  @override
  final String category;
  final List<String> _matchingCriteria;
  @override
  List<String> get matchingCriteria {
    if (_matchingCriteria is EqualUnmodifiableListView)
      return _matchingCriteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchingCriteria);
  }

  @override
  final String? timeOfDay;
  @override
  final String? situation;
  @override
  final String? emotionalState;

  @override
  String toString() {
    return 'ContextMatch(relevanceScore: $relevanceScore, category: $category, matchingCriteria: $matchingCriteria, timeOfDay: $timeOfDay, situation: $situation, emotionalState: $emotionalState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContextMatchImpl &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._matchingCriteria,
              _matchingCriteria,
            ) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.situation, situation) ||
                other.situation == situation) &&
            (identical(other.emotionalState, emotionalState) ||
                other.emotionalState == emotionalState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    relevanceScore,
    category,
    const DeepCollectionEquality().hash(_matchingCriteria),
    timeOfDay,
    situation,
    emotionalState,
  );

  /// Create a copy of ContextMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextMatchImplCopyWith<_$ContextMatchImpl> get copyWith =>
      __$$ContextMatchImplCopyWithImpl<_$ContextMatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContextMatchImplToJson(this);
  }
}

abstract class _ContextMatch implements ContextMatch {
  const factory _ContextMatch({
    required final double relevanceScore,
    required final String category,
    required final List<String> matchingCriteria,
    final String? timeOfDay,
    final String? situation,
    final String? emotionalState,
  }) = _$ContextMatchImpl;

  factory _ContextMatch.fromJson(Map<String, dynamic> json) =
      _$ContextMatchImpl.fromJson;

  @override
  double get relevanceScore;
  @override
  String get category;
  @override
  List<String> get matchingCriteria;
  @override
  String? get timeOfDay;
  @override
  String? get situation;
  @override
  String? get emotionalState;

  /// Create a copy of ContextMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContextMatchImplCopyWith<_$ContextMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
