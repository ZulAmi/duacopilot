// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personalization_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EnhancedRecommendation _$EnhancedRecommendationFromJson(
  Map<String, dynamic> json,
) {
  return _EnhancedRecommendation.fromJson(json);
}

/// @nodoc
mixin _$EnhancedRecommendation {
  DuaEntity get dua => throw _privateConstructorUsedError;
  PersonalizationScore get personalizationScore =>
      throw _privateConstructorUsedError;
  List<String> get reasoning => throw _privateConstructorUsedError;
  List<String> get contextTags => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  bool get isPersonalized => throw _privateConstructorUsedError;
  List<String> get enhancementReasons => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this EnhancedRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnhancedRecommendationCopyWith<EnhancedRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnhancedRecommendationCopyWith<$Res> {
  factory $EnhancedRecommendationCopyWith(
    EnhancedRecommendation value,
    $Res Function(EnhancedRecommendation) then,
  ) = _$EnhancedRecommendationCopyWithImpl<$Res, EnhancedRecommendation>;
  @useResult
  $Res call({
    DuaEntity dua,
    PersonalizationScore personalizationScore,
    List<String> reasoning,
    List<String> contextTags,
    double confidence,
    bool isPersonalized,
    List<String> enhancementReasons,
    Map<String, dynamic>? metadata,
  });

  $DuaEntityCopyWith<$Res> get dua;
  $PersonalizationScoreCopyWith<$Res> get personalizationScore;
}

/// @nodoc
class _$EnhancedRecommendationCopyWithImpl<
  $Res,
  $Val extends EnhancedRecommendation
>
    implements $EnhancedRecommendationCopyWith<$Res> {
  _$EnhancedRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dua = null,
    Object? personalizationScore = null,
    Object? reasoning = null,
    Object? contextTags = null,
    Object? confidence = null,
    Object? isPersonalized = null,
    Object? enhancementReasons = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            dua:
                null == dua
                    ? _value.dua
                    : dua // ignore: cast_nullable_to_non_nullable
                        as DuaEntity,
            personalizationScore:
                null == personalizationScore
                    ? _value.personalizationScore
                    : personalizationScore // ignore: cast_nullable_to_non_nullable
                        as PersonalizationScore,
            reasoning:
                null == reasoning
                    ? _value.reasoning
                    : reasoning // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            contextTags:
                null == contextTags
                    ? _value.contextTags
                    : contextTags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as double,
            isPersonalized:
                null == isPersonalized
                    ? _value.isPersonalized
                    : isPersonalized // ignore: cast_nullable_to_non_nullable
                        as bool,
            enhancementReasons:
                null == enhancementReasons
                    ? _value.enhancementReasons
                    : enhancementReasons // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DuaEntityCopyWith<$Res> get dua {
    return $DuaEntityCopyWith<$Res>(_value.dua, (value) {
      return _then(_value.copyWith(dua: value) as $Val);
    });
  }

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalizationScoreCopyWith<$Res> get personalizationScore {
    return $PersonalizationScoreCopyWith<$Res>(_value.personalizationScore, (
      value,
    ) {
      return _then(_value.copyWith(personalizationScore: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EnhancedRecommendationImplCopyWith<$Res>
    implements $EnhancedRecommendationCopyWith<$Res> {
  factory _$$EnhancedRecommendationImplCopyWith(
    _$EnhancedRecommendationImpl value,
    $Res Function(_$EnhancedRecommendationImpl) then,
  ) = __$$EnhancedRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DuaEntity dua,
    PersonalizationScore personalizationScore,
    List<String> reasoning,
    List<String> contextTags,
    double confidence,
    bool isPersonalized,
    List<String> enhancementReasons,
    Map<String, dynamic>? metadata,
  });

  @override
  $DuaEntityCopyWith<$Res> get dua;
  @override
  $PersonalizationScoreCopyWith<$Res> get personalizationScore;
}

/// @nodoc
class __$$EnhancedRecommendationImplCopyWithImpl<$Res>
    extends
        _$EnhancedRecommendationCopyWithImpl<$Res, _$EnhancedRecommendationImpl>
    implements _$$EnhancedRecommendationImplCopyWith<$Res> {
  __$$EnhancedRecommendationImplCopyWithImpl(
    _$EnhancedRecommendationImpl _value,
    $Res Function(_$EnhancedRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dua = null,
    Object? personalizationScore = null,
    Object? reasoning = null,
    Object? contextTags = null,
    Object? confidence = null,
    Object? isPersonalized = null,
    Object? enhancementReasons = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$EnhancedRecommendationImpl(
        dua:
            null == dua
                ? _value.dua
                : dua // ignore: cast_nullable_to_non_nullable
                    as DuaEntity,
        personalizationScore:
            null == personalizationScore
                ? _value.personalizationScore
                : personalizationScore // ignore: cast_nullable_to_non_nullable
                    as PersonalizationScore,
        reasoning:
            null == reasoning
                ? _value._reasoning
                : reasoning // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        contextTags:
            null == contextTags
                ? _value._contextTags
                : contextTags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as double,
        isPersonalized:
            null == isPersonalized
                ? _value.isPersonalized
                : isPersonalized // ignore: cast_nullable_to_non_nullable
                    as bool,
        enhancementReasons:
            null == enhancementReasons
                ? _value._enhancementReasons
                : enhancementReasons // ignore: cast_nullable_to_non_nullable
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
class _$EnhancedRecommendationImpl implements _EnhancedRecommendation {
  const _$EnhancedRecommendationImpl({
    required this.dua,
    required this.personalizationScore,
    required final List<String> reasoning,
    required final List<String> contextTags,
    required this.confidence,
    this.isPersonalized = false,
    final List<String> enhancementReasons = const [],
    final Map<String, dynamic>? metadata,
  }) : _reasoning = reasoning,
       _contextTags = contextTags,
       _enhancementReasons = enhancementReasons,
       _metadata = metadata;

  factory _$EnhancedRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnhancedRecommendationImplFromJson(json);

  @override
  final DuaEntity dua;
  @override
  final PersonalizationScore personalizationScore;
  final List<String> _reasoning;
  @override
  List<String> get reasoning {
    if (_reasoning is EqualUnmodifiableListView) return _reasoning;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reasoning);
  }

  final List<String> _contextTags;
  @override
  List<String> get contextTags {
    if (_contextTags is EqualUnmodifiableListView) return _contextTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contextTags);
  }

  @override
  final double confidence;
  @override
  @JsonKey()
  final bool isPersonalized;
  final List<String> _enhancementReasons;
  @override
  @JsonKey()
  List<String> get enhancementReasons {
    if (_enhancementReasons is EqualUnmodifiableListView)
      return _enhancementReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enhancementReasons);
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
    return 'EnhancedRecommendation(dua: $dua, personalizationScore: $personalizationScore, reasoning: $reasoning, contextTags: $contextTags, confidence: $confidence, isPersonalized: $isPersonalized, enhancementReasons: $enhancementReasons, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnhancedRecommendationImpl &&
            (identical(other.dua, dua) || other.dua == dua) &&
            (identical(other.personalizationScore, personalizationScore) ||
                other.personalizationScore == personalizationScore) &&
            const DeepCollectionEquality().equals(
              other._reasoning,
              _reasoning,
            ) &&
            const DeepCollectionEquality().equals(
              other._contextTags,
              _contextTags,
            ) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.isPersonalized, isPersonalized) ||
                other.isPersonalized == isPersonalized) &&
            const DeepCollectionEquality().equals(
              other._enhancementReasons,
              _enhancementReasons,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dua,
    personalizationScore,
    const DeepCollectionEquality().hash(_reasoning),
    const DeepCollectionEquality().hash(_contextTags),
    confidence,
    isPersonalized,
    const DeepCollectionEquality().hash(_enhancementReasons),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnhancedRecommendationImplCopyWith<_$EnhancedRecommendationImpl>
  get copyWith =>
      __$$EnhancedRecommendationImplCopyWithImpl<_$EnhancedRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EnhancedRecommendationImplToJson(this);
  }
}

abstract class _EnhancedRecommendation implements EnhancedRecommendation {
  const factory _EnhancedRecommendation({
    required final DuaEntity dua,
    required final PersonalizationScore personalizationScore,
    required final List<String> reasoning,
    required final List<String> contextTags,
    required final double confidence,
    final bool isPersonalized,
    final List<String> enhancementReasons,
    final Map<String, dynamic>? metadata,
  }) = _$EnhancedRecommendationImpl;

  factory _EnhancedRecommendation.fromJson(Map<String, dynamic> json) =
      _$EnhancedRecommendationImpl.fromJson;

  @override
  DuaEntity get dua;
  @override
  PersonalizationScore get personalizationScore;
  @override
  List<String> get reasoning;
  @override
  List<String> get contextTags;
  @override
  double get confidence;
  @override
  bool get isPersonalized;
  @override
  List<String> get enhancementReasons;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of EnhancedRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnhancedRecommendationImplCopyWith<_$EnhancedRecommendationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PersonalizationScore _$PersonalizationScoreFromJson(Map<String, dynamic> json) {
  return _PersonalizationScore.fromJson(json);
}

/// @nodoc
mixin _$PersonalizationScore {
  double get usage => throw _privateConstructorUsedError;
  double get cultural => throw _privateConstructorUsedError;
  double get temporal => throw _privateConstructorUsedError;
  double get contextual => throw _privateConstructorUsedError;
  double get overall => throw _privateConstructorUsedError;
  Map<String, double> get customScores => throw _privateConstructorUsedError;

  /// Serializes this PersonalizationScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalizationScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalizationScoreCopyWith<PersonalizationScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizationScoreCopyWith<$Res> {
  factory $PersonalizationScoreCopyWith(
    PersonalizationScore value,
    $Res Function(PersonalizationScore) then,
  ) = _$PersonalizationScoreCopyWithImpl<$Res, PersonalizationScore>;
  @useResult
  $Res call({
    double usage,
    double cultural,
    double temporal,
    double contextual,
    double overall,
    Map<String, double> customScores,
  });
}

/// @nodoc
class _$PersonalizationScoreCopyWithImpl<
  $Res,
  $Val extends PersonalizationScore
>
    implements $PersonalizationScoreCopyWith<$Res> {
  _$PersonalizationScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizationScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usage = null,
    Object? cultural = null,
    Object? temporal = null,
    Object? contextual = null,
    Object? overall = null,
    Object? customScores = null,
  }) {
    return _then(
      _value.copyWith(
            usage:
                null == usage
                    ? _value.usage
                    : usage // ignore: cast_nullable_to_non_nullable
                        as double,
            cultural:
                null == cultural
                    ? _value.cultural
                    : cultural // ignore: cast_nullable_to_non_nullable
                        as double,
            temporal:
                null == temporal
                    ? _value.temporal
                    : temporal // ignore: cast_nullable_to_non_nullable
                        as double,
            contextual:
                null == contextual
                    ? _value.contextual
                    : contextual // ignore: cast_nullable_to_non_nullable
                        as double,
            overall:
                null == overall
                    ? _value.overall
                    : overall // ignore: cast_nullable_to_non_nullable
                        as double,
            customScores:
                null == customScores
                    ? _value.customScores
                    : customScores // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PersonalizationScoreImplCopyWith<$Res>
    implements $PersonalizationScoreCopyWith<$Res> {
  factory _$$PersonalizationScoreImplCopyWith(
    _$PersonalizationScoreImpl value,
    $Res Function(_$PersonalizationScoreImpl) then,
  ) = __$$PersonalizationScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double usage,
    double cultural,
    double temporal,
    double contextual,
    double overall,
    Map<String, double> customScores,
  });
}

/// @nodoc
class __$$PersonalizationScoreImplCopyWithImpl<$Res>
    extends _$PersonalizationScoreCopyWithImpl<$Res, _$PersonalizationScoreImpl>
    implements _$$PersonalizationScoreImplCopyWith<$Res> {
  __$$PersonalizationScoreImplCopyWithImpl(
    _$PersonalizationScoreImpl _value,
    $Res Function(_$PersonalizationScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usage = null,
    Object? cultural = null,
    Object? temporal = null,
    Object? contextual = null,
    Object? overall = null,
    Object? customScores = null,
  }) {
    return _then(
      _$PersonalizationScoreImpl(
        usage:
            null == usage
                ? _value.usage
                : usage // ignore: cast_nullable_to_non_nullable
                    as double,
        cultural:
            null == cultural
                ? _value.cultural
                : cultural // ignore: cast_nullable_to_non_nullable
                    as double,
        temporal:
            null == temporal
                ? _value.temporal
                : temporal // ignore: cast_nullable_to_non_nullable
                    as double,
        contextual:
            null == contextual
                ? _value.contextual
                : contextual // ignore: cast_nullable_to_non_nullable
                    as double,
        overall:
            null == overall
                ? _value.overall
                : overall // ignore: cast_nullable_to_non_nullable
                    as double,
        customScores:
            null == customScores
                ? _value._customScores
                : customScores // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalizationScoreImpl implements _PersonalizationScore {
  const _$PersonalizationScoreImpl({
    required this.usage,
    required this.cultural,
    required this.temporal,
    required this.contextual,
    required this.overall,
    final Map<String, double> customScores = const {},
  }) : _customScores = customScores;

  factory _$PersonalizationScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalizationScoreImplFromJson(json);

  @override
  final double usage;
  @override
  final double cultural;
  @override
  final double temporal;
  @override
  final double contextual;
  @override
  final double overall;
  final Map<String, double> _customScores;
  @override
  @JsonKey()
  Map<String, double> get customScores {
    if (_customScores is EqualUnmodifiableMapView) return _customScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customScores);
  }

  @override
  String toString() {
    return 'PersonalizationScore(usage: $usage, cultural: $cultural, temporal: $temporal, contextual: $contextual, overall: $overall, customScores: $customScores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationScoreImpl &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.cultural, cultural) ||
                other.cultural == cultural) &&
            (identical(other.temporal, temporal) ||
                other.temporal == temporal) &&
            (identical(other.contextual, contextual) ||
                other.contextual == contextual) &&
            (identical(other.overall, overall) || other.overall == overall) &&
            const DeepCollectionEquality().equals(
              other._customScores,
              _customScores,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    usage,
    cultural,
    temporal,
    contextual,
    overall,
    const DeepCollectionEquality().hash(_customScores),
  );

  /// Create a copy of PersonalizationScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationScoreImplCopyWith<_$PersonalizationScoreImpl>
  get copyWith =>
      __$$PersonalizationScoreImplCopyWithImpl<_$PersonalizationScoreImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalizationScoreImplToJson(this);
  }
}

abstract class _PersonalizationScore implements PersonalizationScore {
  const factory _PersonalizationScore({
    required final double usage,
    required final double cultural,
    required final double temporal,
    required final double contextual,
    required final double overall,
    final Map<String, double> customScores,
  }) = _$PersonalizationScoreImpl;

  factory _PersonalizationScore.fromJson(Map<String, dynamic> json) =
      _$PersonalizationScoreImpl.fromJson;

  @override
  double get usage;
  @override
  double get cultural;
  @override
  double get temporal;
  @override
  double get contextual;
  @override
  double get overall;
  @override
  Map<String, double> get customScores;

  /// Create a copy of PersonalizationScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationScoreImplCopyWith<_$PersonalizationScoreImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UserSession _$UserSessionFromJson(Map<String, dynamic> json) {
  return _UserSession.fromJson(json);
}

/// @nodoc
mixin _$UserSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  Map<String, dynamic> get context => throw _privateConstructorUsedError;
  Map<String, dynamic> get deviceInfo => throw _privateConstructorUsedError;
  List<String> get interactions => throw _privateConstructorUsedError;
  Map<String, int> get duaViews => throw _privateConstructorUsedError;
  int get searchCount => throw _privateConstructorUsedError;
  int get bookmarkCount => throw _privateConstructorUsedError;

  /// Serializes this UserSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSessionCopyWith<UserSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionCopyWith<$Res> {
  factory $UserSessionCopyWith(
    UserSession value,
    $Res Function(UserSession) then,
  ) = _$UserSessionCopyWithImpl<$Res, UserSession>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime startTime,
    DateTime? endTime,
    Map<String, dynamic> context,
    Map<String, dynamic> deviceInfo,
    List<String> interactions,
    Map<String, int> duaViews,
    int searchCount,
    int bookmarkCount,
  });
}

/// @nodoc
class _$UserSessionCopyWithImpl<$Res, $Val extends UserSession>
    implements $UserSessionCopyWith<$Res> {
  _$UserSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? context = null,
    Object? deviceInfo = null,
    Object? interactions = null,
    Object? duaViews = null,
    Object? searchCount = null,
    Object? bookmarkCount = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            startTime:
                null == startTime
                    ? _value.startTime
                    : startTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            endTime:
                freezed == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            context:
                null == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            deviceInfo:
                null == deviceInfo
                    ? _value.deviceInfo
                    : deviceInfo // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            interactions:
                null == interactions
                    ? _value.interactions
                    : interactions // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            duaViews:
                null == duaViews
                    ? _value.duaViews
                    : duaViews // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            searchCount:
                null == searchCount
                    ? _value.searchCount
                    : searchCount // ignore: cast_nullable_to_non_nullable
                        as int,
            bookmarkCount:
                null == bookmarkCount
                    ? _value.bookmarkCount
                    : bookmarkCount // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserSessionImplCopyWith<$Res>
    implements $UserSessionCopyWith<$Res> {
  factory _$$UserSessionImplCopyWith(
    _$UserSessionImpl value,
    $Res Function(_$UserSessionImpl) then,
  ) = __$$UserSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime startTime,
    DateTime? endTime,
    Map<String, dynamic> context,
    Map<String, dynamic> deviceInfo,
    List<String> interactions,
    Map<String, int> duaViews,
    int searchCount,
    int bookmarkCount,
  });
}

/// @nodoc
class __$$UserSessionImplCopyWithImpl<$Res>
    extends _$UserSessionCopyWithImpl<$Res, _$UserSessionImpl>
    implements _$$UserSessionImplCopyWith<$Res> {
  __$$UserSessionImplCopyWithImpl(
    _$UserSessionImpl _value,
    $Res Function(_$UserSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? context = null,
    Object? deviceInfo = null,
    Object? interactions = null,
    Object? duaViews = null,
    Object? searchCount = null,
    Object? bookmarkCount = null,
  }) {
    return _then(
      _$UserSessionImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        startTime:
            null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        endTime:
            freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        context:
            null == context
                ? _value._context
                : context // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        deviceInfo:
            null == deviceInfo
                ? _value._deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        interactions:
            null == interactions
                ? _value._interactions
                : interactions // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        duaViews:
            null == duaViews
                ? _value._duaViews
                : duaViews // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        searchCount:
            null == searchCount
                ? _value.searchCount
                : searchCount // ignore: cast_nullable_to_non_nullable
                    as int,
        bookmarkCount:
            null == bookmarkCount
                ? _value.bookmarkCount
                : bookmarkCount // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSessionImpl implements _UserSession {
  const _$UserSessionImpl({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required final Map<String, dynamic> context,
    required final Map<String, dynamic> deviceInfo,
    final List<String> interactions = const [],
    final Map<String, int> duaViews = const {},
    this.searchCount = 0,
    this.bookmarkCount = 0,
  }) : _context = context,
       _deviceInfo = deviceInfo,
       _interactions = interactions,
       _duaViews = duaViews;

  factory _$UserSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  final Map<String, dynamic> _context;
  @override
  Map<String, dynamic> get context {
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_context);
  }

  final Map<String, dynamic> _deviceInfo;
  @override
  Map<String, dynamic> get deviceInfo {
    if (_deviceInfo is EqualUnmodifiableMapView) return _deviceInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deviceInfo);
  }

  final List<String> _interactions;
  @override
  @JsonKey()
  List<String> get interactions {
    if (_interactions is EqualUnmodifiableListView) return _interactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interactions);
  }

  final Map<String, int> _duaViews;
  @override
  @JsonKey()
  Map<String, int> get duaViews {
    if (_duaViews is EqualUnmodifiableMapView) return _duaViews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_duaViews);
  }

  @override
  @JsonKey()
  final int searchCount;
  @override
  @JsonKey()
  final int bookmarkCount;

  @override
  String toString() {
    return 'UserSession(id: $id, userId: $userId, startTime: $startTime, endTime: $endTime, context: $context, deviceInfo: $deviceInfo, interactions: $interactions, duaViews: $duaViews, searchCount: $searchCount, bookmarkCount: $bookmarkCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            const DeepCollectionEquality().equals(
              other._deviceInfo,
              _deviceInfo,
            ) &&
            const DeepCollectionEquality().equals(
              other._interactions,
              _interactions,
            ) &&
            const DeepCollectionEquality().equals(other._duaViews, _duaViews) &&
            (identical(other.searchCount, searchCount) ||
                other.searchCount == searchCount) &&
            (identical(other.bookmarkCount, bookmarkCount) ||
                other.bookmarkCount == bookmarkCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    startTime,
    endTime,
    const DeepCollectionEquality().hash(_context),
    const DeepCollectionEquality().hash(_deviceInfo),
    const DeepCollectionEquality().hash(_interactions),
    const DeepCollectionEquality().hash(_duaViews),
    searchCount,
    bookmarkCount,
  );

  /// Create a copy of UserSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionImplCopyWith<_$UserSessionImpl> get copyWith =>
      __$$UserSessionImplCopyWithImpl<_$UserSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSessionImplToJson(this);
  }
}

abstract class _UserSession implements UserSession {
  const factory _UserSession({
    required final String id,
    required final String userId,
    required final DateTime startTime,
    final DateTime? endTime,
    required final Map<String, dynamic> context,
    required final Map<String, dynamic> deviceInfo,
    final List<String> interactions,
    final Map<String, int> duaViews,
    final int searchCount,
    final int bookmarkCount,
  }) = _$UserSessionImpl;

  factory _UserSession.fromJson(Map<String, dynamic> json) =
      _$UserSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  Map<String, dynamic> get context;
  @override
  Map<String, dynamic> get deviceInfo;
  @override
  List<String> get interactions;
  @override
  Map<String, int> get duaViews;
  @override
  int get searchCount;
  @override
  int get bookmarkCount;

  /// Create a copy of UserSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionImplCopyWith<_$UserSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DuaInteraction _$DuaInteractionFromJson(Map<String, dynamic> json) {
  return _DuaInteraction.fromJson(json);
}

/// @nodoc
mixin _$DuaInteraction {
  String get duaId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  InteractionType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  Map<String, dynamic> get context => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this DuaInteraction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuaInteraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuaInteractionCopyWith<DuaInteraction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuaInteractionCopyWith<$Res> {
  factory $DuaInteractionCopyWith(
    DuaInteraction value,
    $Res Function(DuaInteraction) then,
  ) = _$DuaInteractionCopyWithImpl<$Res, DuaInteraction>;
  @useResult
  $Res call({
    String duaId,
    String userId,
    String sessionId,
    InteractionType type,
    DateTime timestamp,
    Duration duration,
    Map<String, dynamic> context,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$DuaInteractionCopyWithImpl<$Res, $Val extends DuaInteraction>
    implements $DuaInteractionCopyWith<$Res> {
  _$DuaInteractionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuaInteraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? userId = null,
    Object? sessionId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? duration = null,
    Object? context = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            duaId:
                null == duaId
                    ? _value.duaId
                    : duaId // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as InteractionType,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as Duration,
            context:
                null == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DuaInteractionImplCopyWith<$Res>
    implements $DuaInteractionCopyWith<$Res> {
  factory _$$DuaInteractionImplCopyWith(
    _$DuaInteractionImpl value,
    $Res Function(_$DuaInteractionImpl) then,
  ) = __$$DuaInteractionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String duaId,
    String userId,
    String sessionId,
    InteractionType type,
    DateTime timestamp,
    Duration duration,
    Map<String, dynamic> context,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$DuaInteractionImplCopyWithImpl<$Res>
    extends _$DuaInteractionCopyWithImpl<$Res, _$DuaInteractionImpl>
    implements _$$DuaInteractionImplCopyWith<$Res> {
  __$$DuaInteractionImplCopyWithImpl(
    _$DuaInteractionImpl _value,
    $Res Function(_$DuaInteractionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DuaInteraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? userId = null,
    Object? sessionId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? duration = null,
    Object? context = null,
    Object? metadata = null,
  }) {
    return _then(
      _$DuaInteractionImpl(
        duaId:
            null == duaId
                ? _value.duaId
                : duaId // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as InteractionType,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as Duration,
        context:
            null == context
                ? _value._context
                : context // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DuaInteractionImpl implements _DuaInteraction {
  const _$DuaInteractionImpl({
    required this.duaId,
    required this.userId,
    required this.sessionId,
    required this.type,
    required this.timestamp,
    required this.duration,
    required final Map<String, dynamic> context,
    final Map<String, dynamic> metadata = const {},
  }) : _context = context,
       _metadata = metadata;

  factory _$DuaInteractionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuaInteractionImplFromJson(json);

  @override
  final String duaId;
  @override
  final String userId;
  @override
  final String sessionId;
  @override
  final InteractionType type;
  @override
  final DateTime timestamp;
  @override
  final Duration duration;
  final Map<String, dynamic> _context;
  @override
  Map<String, dynamic> get context {
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_context);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'DuaInteraction(duaId: $duaId, userId: $userId, sessionId: $sessionId, type: $type, timestamp: $timestamp, duration: $duration, context: $context, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuaInteractionImpl &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    duaId,
    userId,
    sessionId,
    type,
    timestamp,
    duration,
    const DeepCollectionEquality().hash(_context),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of DuaInteraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuaInteractionImplCopyWith<_$DuaInteractionImpl> get copyWith =>
      __$$DuaInteractionImplCopyWithImpl<_$DuaInteractionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DuaInteractionImplToJson(this);
  }
}

abstract class _DuaInteraction implements DuaInteraction {
  const factory _DuaInteraction({
    required final String duaId,
    required final String userId,
    required final String sessionId,
    required final InteractionType type,
    required final DateTime timestamp,
    required final Duration duration,
    required final Map<String, dynamic> context,
    final Map<String, dynamic> metadata,
  }) = _$DuaInteractionImpl;

  factory _DuaInteraction.fromJson(Map<String, dynamic> json) =
      _$DuaInteractionImpl.fromJson;

  @override
  String get duaId;
  @override
  String get userId;
  @override
  String get sessionId;
  @override
  InteractionType get type;
  @override
  DateTime get timestamp;
  @override
  Duration get duration;
  @override
  Map<String, dynamic> get context;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of DuaInteraction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuaInteractionImplCopyWith<_$DuaInteractionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonalizationUpdate _$PersonalizationUpdateFromJson(
  Map<String, dynamic> json,
) {
  return _PersonalizationUpdate.fromJson(json);
}

/// @nodoc
mixin _$PersonalizationUpdate {
  UpdateType get type => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PersonalizationUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalizationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalizationUpdateCopyWith<PersonalizationUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizationUpdateCopyWith<$Res> {
  factory $PersonalizationUpdateCopyWith(
    PersonalizationUpdate value,
    $Res Function(PersonalizationUpdate) then,
  ) = _$PersonalizationUpdateCopyWithImpl<$Res, PersonalizationUpdate>;
  @useResult
  $Res call({
    UpdateType type,
    dynamic data,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$PersonalizationUpdateCopyWithImpl<
  $Res,
  $Val extends PersonalizationUpdate
>
    implements $PersonalizationUpdateCopyWith<$Res> {
  _$PersonalizationUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = freezed,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as UpdateType,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as dynamic,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
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
abstract class _$$PersonalizationUpdateImplCopyWith<$Res>
    implements $PersonalizationUpdateCopyWith<$Res> {
  factory _$$PersonalizationUpdateImplCopyWith(
    _$PersonalizationUpdateImpl value,
    $Res Function(_$PersonalizationUpdateImpl) then,
  ) = __$$PersonalizationUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UpdateType type,
    dynamic data,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$PersonalizationUpdateImplCopyWithImpl<$Res>
    extends
        _$PersonalizationUpdateCopyWithImpl<$Res, _$PersonalizationUpdateImpl>
    implements _$$PersonalizationUpdateImplCopyWith<$Res> {
  __$$PersonalizationUpdateImplCopyWithImpl(
    _$PersonalizationUpdateImpl _value,
    $Res Function(_$PersonalizationUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = freezed,
    Object? timestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PersonalizationUpdateImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as UpdateType,
        data:
            freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                    as dynamic,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
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
class _$PersonalizationUpdateImpl implements _PersonalizationUpdate {
  const _$PersonalizationUpdateImpl({
    required this.type,
    required this.data,
    required this.timestamp,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$PersonalizationUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalizationUpdateImplFromJson(json);

  @override
  final UpdateType type;
  @override
  final dynamic data;
  @override
  final DateTime timestamp;
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
    return 'PersonalizationUpdate(type: $type, data: $data, timestamp: $timestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationUpdateImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(data),
    timestamp,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PersonalizationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationUpdateImplCopyWith<_$PersonalizationUpdateImpl>
  get copyWith =>
      __$$PersonalizationUpdateImplCopyWithImpl<_$PersonalizationUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalizationUpdateImplToJson(this);
  }
}

abstract class _PersonalizationUpdate implements PersonalizationUpdate {
  const factory _PersonalizationUpdate({
    required final UpdateType type,
    required final dynamic data,
    required final DateTime timestamp,
    final Map<String, dynamic>? metadata,
  }) = _$PersonalizationUpdateImpl;

  factory _PersonalizationUpdate.fromJson(Map<String, dynamic> json) =
      _$PersonalizationUpdateImpl.fromJson;

  @override
  UpdateType get type;
  @override
  dynamic get data;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PersonalizationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationUpdateImplCopyWith<_$PersonalizationUpdateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UsagePatterns _$UsagePatternsFromJson(Map<String, dynamic> json) {
  return _UsagePatterns.fromJson(json);
}

/// @nodoc
mixin _$UsagePatterns {
  String get userId => throw _privateConstructorUsedError;
  List<String> get frequentDuas => throw _privateConstructorUsedError;
  List<String> get recentDuas => throw _privateConstructorUsedError;
  Map<String, int> get categoryPreferences =>
      throw _privateConstructorUsedError;
  Map<String, double> get timeOfDayPatterns =>
      throw _privateConstructorUsedError;
  Map<String, int> get dailyUsageStats => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  int get totalInteractions => throw _privateConstructorUsedError;
  Map<String, double> get averageReadingTimes =>
      throw _privateConstructorUsedError;

  /// Serializes this UsagePatterns to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsagePatterns
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsagePatternsCopyWith<UsagePatterns> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsagePatternsCopyWith<$Res> {
  factory $UsagePatternsCopyWith(
    UsagePatterns value,
    $Res Function(UsagePatterns) then,
  ) = _$UsagePatternsCopyWithImpl<$Res, UsagePatterns>;
  @useResult
  $Res call({
    String userId,
    List<String> frequentDuas,
    List<String> recentDuas,
    Map<String, int> categoryPreferences,
    Map<String, double> timeOfDayPatterns,
    Map<String, int> dailyUsageStats,
    DateTime lastUpdated,
    int totalInteractions,
    Map<String, double> averageReadingTimes,
  });
}

/// @nodoc
class _$UsagePatternsCopyWithImpl<$Res, $Val extends UsagePatterns>
    implements $UsagePatternsCopyWith<$Res> {
  _$UsagePatternsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsagePatterns
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? frequentDuas = null,
    Object? recentDuas = null,
    Object? categoryPreferences = null,
    Object? timeOfDayPatterns = null,
    Object? dailyUsageStats = null,
    Object? lastUpdated = null,
    Object? totalInteractions = null,
    Object? averageReadingTimes = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            frequentDuas:
                null == frequentDuas
                    ? _value.frequentDuas
                    : frequentDuas // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            recentDuas:
                null == recentDuas
                    ? _value.recentDuas
                    : recentDuas // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            categoryPreferences:
                null == categoryPreferences
                    ? _value.categoryPreferences
                    : categoryPreferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            timeOfDayPatterns:
                null == timeOfDayPatterns
                    ? _value.timeOfDayPatterns
                    : timeOfDayPatterns // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
            dailyUsageStats:
                null == dailyUsageStats
                    ? _value.dailyUsageStats
                    : dailyUsageStats // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            lastUpdated:
                null == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            totalInteractions:
                null == totalInteractions
                    ? _value.totalInteractions
                    : totalInteractions // ignore: cast_nullable_to_non_nullable
                        as int,
            averageReadingTimes:
                null == averageReadingTimes
                    ? _value.averageReadingTimes
                    : averageReadingTimes // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsagePatternsImplCopyWith<$Res>
    implements $UsagePatternsCopyWith<$Res> {
  factory _$$UsagePatternsImplCopyWith(
    _$UsagePatternsImpl value,
    $Res Function(_$UsagePatternsImpl) then,
  ) = __$$UsagePatternsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    List<String> frequentDuas,
    List<String> recentDuas,
    Map<String, int> categoryPreferences,
    Map<String, double> timeOfDayPatterns,
    Map<String, int> dailyUsageStats,
    DateTime lastUpdated,
    int totalInteractions,
    Map<String, double> averageReadingTimes,
  });
}

/// @nodoc
class __$$UsagePatternsImplCopyWithImpl<$Res>
    extends _$UsagePatternsCopyWithImpl<$Res, _$UsagePatternsImpl>
    implements _$$UsagePatternsImplCopyWith<$Res> {
  __$$UsagePatternsImplCopyWithImpl(
    _$UsagePatternsImpl _value,
    $Res Function(_$UsagePatternsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsagePatterns
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? frequentDuas = null,
    Object? recentDuas = null,
    Object? categoryPreferences = null,
    Object? timeOfDayPatterns = null,
    Object? dailyUsageStats = null,
    Object? lastUpdated = null,
    Object? totalInteractions = null,
    Object? averageReadingTimes = null,
  }) {
    return _then(
      _$UsagePatternsImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        frequentDuas:
            null == frequentDuas
                ? _value._frequentDuas
                : frequentDuas // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        recentDuas:
            null == recentDuas
                ? _value._recentDuas
                : recentDuas // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        categoryPreferences:
            null == categoryPreferences
                ? _value._categoryPreferences
                : categoryPreferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        timeOfDayPatterns:
            null == timeOfDayPatterns
                ? _value._timeOfDayPatterns
                : timeOfDayPatterns // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
        dailyUsageStats:
            null == dailyUsageStats
                ? _value._dailyUsageStats
                : dailyUsageStats // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        lastUpdated:
            null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        totalInteractions:
            null == totalInteractions
                ? _value.totalInteractions
                : totalInteractions // ignore: cast_nullable_to_non_nullable
                    as int,
        averageReadingTimes:
            null == averageReadingTimes
                ? _value._averageReadingTimes
                : averageReadingTimes // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsagePatternsImpl implements _UsagePatterns {
  const _$UsagePatternsImpl({
    required this.userId,
    required final List<String> frequentDuas,
    required final List<String> recentDuas,
    required final Map<String, int> categoryPreferences,
    required final Map<String, double> timeOfDayPatterns,
    required final Map<String, int> dailyUsageStats,
    required this.lastUpdated,
    this.totalInteractions = 0,
    final Map<String, double> averageReadingTimes = const {},
  }) : _frequentDuas = frequentDuas,
       _recentDuas = recentDuas,
       _categoryPreferences = categoryPreferences,
       _timeOfDayPatterns = timeOfDayPatterns,
       _dailyUsageStats = dailyUsageStats,
       _averageReadingTimes = averageReadingTimes;

  factory _$UsagePatternsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsagePatternsImplFromJson(json);

  @override
  final String userId;
  final List<String> _frequentDuas;
  @override
  List<String> get frequentDuas {
    if (_frequentDuas is EqualUnmodifiableListView) return _frequentDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frequentDuas);
  }

  final List<String> _recentDuas;
  @override
  List<String> get recentDuas {
    if (_recentDuas is EqualUnmodifiableListView) return _recentDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentDuas);
  }

  final Map<String, int> _categoryPreferences;
  @override
  Map<String, int> get categoryPreferences {
    if (_categoryPreferences is EqualUnmodifiableMapView)
      return _categoryPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryPreferences);
  }

  final Map<String, double> _timeOfDayPatterns;
  @override
  Map<String, double> get timeOfDayPatterns {
    if (_timeOfDayPatterns is EqualUnmodifiableMapView)
      return _timeOfDayPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeOfDayPatterns);
  }

  final Map<String, int> _dailyUsageStats;
  @override
  Map<String, int> get dailyUsageStats {
    if (_dailyUsageStats is EqualUnmodifiableMapView) return _dailyUsageStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyUsageStats);
  }

  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final int totalInteractions;
  final Map<String, double> _averageReadingTimes;
  @override
  @JsonKey()
  Map<String, double> get averageReadingTimes {
    if (_averageReadingTimes is EqualUnmodifiableMapView)
      return _averageReadingTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_averageReadingTimes);
  }

  @override
  String toString() {
    return 'UsagePatterns(userId: $userId, frequentDuas: $frequentDuas, recentDuas: $recentDuas, categoryPreferences: $categoryPreferences, timeOfDayPatterns: $timeOfDayPatterns, dailyUsageStats: $dailyUsageStats, lastUpdated: $lastUpdated, totalInteractions: $totalInteractions, averageReadingTimes: $averageReadingTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsagePatternsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._frequentDuas,
              _frequentDuas,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentDuas,
              _recentDuas,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryPreferences,
              _categoryPreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._timeOfDayPatterns,
              _timeOfDayPatterns,
            ) &&
            const DeepCollectionEquality().equals(
              other._dailyUsageStats,
              _dailyUsageStats,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.totalInteractions, totalInteractions) ||
                other.totalInteractions == totalInteractions) &&
            const DeepCollectionEquality().equals(
              other._averageReadingTimes,
              _averageReadingTimes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_frequentDuas),
    const DeepCollectionEquality().hash(_recentDuas),
    const DeepCollectionEquality().hash(_categoryPreferences),
    const DeepCollectionEquality().hash(_timeOfDayPatterns),
    const DeepCollectionEquality().hash(_dailyUsageStats),
    lastUpdated,
    totalInteractions,
    const DeepCollectionEquality().hash(_averageReadingTimes),
  );

  /// Create a copy of UsagePatterns
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsagePatternsImplCopyWith<_$UsagePatternsImpl> get copyWith =>
      __$$UsagePatternsImplCopyWithImpl<_$UsagePatternsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsagePatternsImplToJson(this);
  }
}

abstract class _UsagePatterns implements UsagePatterns {
  const factory _UsagePatterns({
    required final String userId,
    required final List<String> frequentDuas,
    required final List<String> recentDuas,
    required final Map<String, int> categoryPreferences,
    required final Map<String, double> timeOfDayPatterns,
    required final Map<String, int> dailyUsageStats,
    required final DateTime lastUpdated,
    final int totalInteractions,
    final Map<String, double> averageReadingTimes,
  }) = _$UsagePatternsImpl;

  factory _UsagePatterns.fromJson(Map<String, dynamic> json) =
      _$UsagePatternsImpl.fromJson;

  @override
  String get userId;
  @override
  List<String> get frequentDuas;
  @override
  List<String> get recentDuas;
  @override
  Map<String, int> get categoryPreferences;
  @override
  Map<String, double> get timeOfDayPatterns;
  @override
  Map<String, int> get dailyUsageStats;
  @override
  DateTime get lastUpdated;
  @override
  int get totalInteractions;
  @override
  Map<String, double> get averageReadingTimes;

  /// Create a copy of UsagePatterns
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsagePatternsImplCopyWith<_$UsagePatternsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CulturalPreferences _$CulturalPreferencesFromJson(Map<String, dynamic> json) {
  return _CulturalPreferences.fromJson(json);
}

/// @nodoc
mixin _$CulturalPreferences {
  String get userId => throw _privateConstructorUsedError;
  List<String> get preferredLanguages => throw _privateConstructorUsedError;
  String get primaryLanguage => throw _privateConstructorUsedError;
  List<String> get culturalTags => throw _privateConstructorUsedError;
  Map<String, double> get languagePreferences =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  Map<String, dynamic> get customPreferences =>
      throw _privateConstructorUsedError;
  bool get autoDetectLanguage => throw _privateConstructorUsedError;
  String get transliterationStyle => throw _privateConstructorUsedError;

  /// Serializes this CulturalPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CulturalPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CulturalPreferencesCopyWith<CulturalPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CulturalPreferencesCopyWith<$Res> {
  factory $CulturalPreferencesCopyWith(
    CulturalPreferences value,
    $Res Function(CulturalPreferences) then,
  ) = _$CulturalPreferencesCopyWithImpl<$Res, CulturalPreferences>;
  @useResult
  $Res call({
    String userId,
    List<String> preferredLanguages,
    String primaryLanguage,
    List<String> culturalTags,
    Map<String, double> languagePreferences,
    DateTime lastUpdated,
    Map<String, dynamic> customPreferences,
    bool autoDetectLanguage,
    String transliterationStyle,
  });
}

/// @nodoc
class _$CulturalPreferencesCopyWithImpl<$Res, $Val extends CulturalPreferences>
    implements $CulturalPreferencesCopyWith<$Res> {
  _$CulturalPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CulturalPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferredLanguages = null,
    Object? primaryLanguage = null,
    Object? culturalTags = null,
    Object? languagePreferences = null,
    Object? lastUpdated = null,
    Object? customPreferences = null,
    Object? autoDetectLanguage = null,
    Object? transliterationStyle = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            preferredLanguages:
                null == preferredLanguages
                    ? _value.preferredLanguages
                    : preferredLanguages // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            primaryLanguage:
                null == primaryLanguage
                    ? _value.primaryLanguage
                    : primaryLanguage // ignore: cast_nullable_to_non_nullable
                        as String,
            culturalTags:
                null == culturalTags
                    ? _value.culturalTags
                    : culturalTags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            languagePreferences:
                null == languagePreferences
                    ? _value.languagePreferences
                    : languagePreferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
            lastUpdated:
                null == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            customPreferences:
                null == customPreferences
                    ? _value.customPreferences
                    : customPreferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            autoDetectLanguage:
                null == autoDetectLanguage
                    ? _value.autoDetectLanguage
                    : autoDetectLanguage // ignore: cast_nullable_to_non_nullable
                        as bool,
            transliterationStyle:
                null == transliterationStyle
                    ? _value.transliterationStyle
                    : transliterationStyle // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CulturalPreferencesImplCopyWith<$Res>
    implements $CulturalPreferencesCopyWith<$Res> {
  factory _$$CulturalPreferencesImplCopyWith(
    _$CulturalPreferencesImpl value,
    $Res Function(_$CulturalPreferencesImpl) then,
  ) = __$$CulturalPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    List<String> preferredLanguages,
    String primaryLanguage,
    List<String> culturalTags,
    Map<String, double> languagePreferences,
    DateTime lastUpdated,
    Map<String, dynamic> customPreferences,
    bool autoDetectLanguage,
    String transliterationStyle,
  });
}

/// @nodoc
class __$$CulturalPreferencesImplCopyWithImpl<$Res>
    extends _$CulturalPreferencesCopyWithImpl<$Res, _$CulturalPreferencesImpl>
    implements _$$CulturalPreferencesImplCopyWith<$Res> {
  __$$CulturalPreferencesImplCopyWithImpl(
    _$CulturalPreferencesImpl _value,
    $Res Function(_$CulturalPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CulturalPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferredLanguages = null,
    Object? primaryLanguage = null,
    Object? culturalTags = null,
    Object? languagePreferences = null,
    Object? lastUpdated = null,
    Object? customPreferences = null,
    Object? autoDetectLanguage = null,
    Object? transliterationStyle = null,
  }) {
    return _then(
      _$CulturalPreferencesImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        preferredLanguages:
            null == preferredLanguages
                ? _value._preferredLanguages
                : preferredLanguages // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        primaryLanguage:
            null == primaryLanguage
                ? _value.primaryLanguage
                : primaryLanguage // ignore: cast_nullable_to_non_nullable
                    as String,
        culturalTags:
            null == culturalTags
                ? _value._culturalTags
                : culturalTags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        languagePreferences:
            null == languagePreferences
                ? _value._languagePreferences
                : languagePreferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
        lastUpdated:
            null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        customPreferences:
            null == customPreferences
                ? _value._customPreferences
                : customPreferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        autoDetectLanguage:
            null == autoDetectLanguage
                ? _value.autoDetectLanguage
                : autoDetectLanguage // ignore: cast_nullable_to_non_nullable
                    as bool,
        transliterationStyle:
            null == transliterationStyle
                ? _value.transliterationStyle
                : transliterationStyle // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CulturalPreferencesImpl implements _CulturalPreferences {
  const _$CulturalPreferencesImpl({
    required this.userId,
    required final List<String> preferredLanguages,
    required this.primaryLanguage,
    required final List<String> culturalTags,
    required final Map<String, double> languagePreferences,
    required this.lastUpdated,
    final Map<String, dynamic> customPreferences = const {},
    this.autoDetectLanguage = false,
    this.transliterationStyle = 'balanced',
  }) : _preferredLanguages = preferredLanguages,
       _culturalTags = culturalTags,
       _languagePreferences = languagePreferences,
       _customPreferences = customPreferences;

  factory _$CulturalPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CulturalPreferencesImplFromJson(json);

  @override
  final String userId;
  final List<String> _preferredLanguages;
  @override
  List<String> get preferredLanguages {
    if (_preferredLanguages is EqualUnmodifiableListView)
      return _preferredLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredLanguages);
  }

  @override
  final String primaryLanguage;
  final List<String> _culturalTags;
  @override
  List<String> get culturalTags {
    if (_culturalTags is EqualUnmodifiableListView) return _culturalTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_culturalTags);
  }

  final Map<String, double> _languagePreferences;
  @override
  Map<String, double> get languagePreferences {
    if (_languagePreferences is EqualUnmodifiableMapView)
      return _languagePreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_languagePreferences);
  }

  @override
  final DateTime lastUpdated;
  final Map<String, dynamic> _customPreferences;
  @override
  @JsonKey()
  Map<String, dynamic> get customPreferences {
    if (_customPreferences is EqualUnmodifiableMapView)
      return _customPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customPreferences);
  }

  @override
  @JsonKey()
  final bool autoDetectLanguage;
  @override
  @JsonKey()
  final String transliterationStyle;

  @override
  String toString() {
    return 'CulturalPreferences(userId: $userId, preferredLanguages: $preferredLanguages, primaryLanguage: $primaryLanguage, culturalTags: $culturalTags, languagePreferences: $languagePreferences, lastUpdated: $lastUpdated, customPreferences: $customPreferences, autoDetectLanguage: $autoDetectLanguage, transliterationStyle: $transliterationStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CulturalPreferencesImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._preferredLanguages,
              _preferredLanguages,
            ) &&
            (identical(other.primaryLanguage, primaryLanguage) ||
                other.primaryLanguage == primaryLanguage) &&
            const DeepCollectionEquality().equals(
              other._culturalTags,
              _culturalTags,
            ) &&
            const DeepCollectionEquality().equals(
              other._languagePreferences,
              _languagePreferences,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(
              other._customPreferences,
              _customPreferences,
            ) &&
            (identical(other.autoDetectLanguage, autoDetectLanguage) ||
                other.autoDetectLanguage == autoDetectLanguage) &&
            (identical(other.transliterationStyle, transliterationStyle) ||
                other.transliterationStyle == transliterationStyle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_preferredLanguages),
    primaryLanguage,
    const DeepCollectionEquality().hash(_culturalTags),
    const DeepCollectionEquality().hash(_languagePreferences),
    lastUpdated,
    const DeepCollectionEquality().hash(_customPreferences),
    autoDetectLanguage,
    transliterationStyle,
  );

  /// Create a copy of CulturalPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CulturalPreferencesImplCopyWith<_$CulturalPreferencesImpl> get copyWith =>
      __$$CulturalPreferencesImplCopyWithImpl<_$CulturalPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CulturalPreferencesImplToJson(this);
  }
}

abstract class _CulturalPreferences implements CulturalPreferences {
  const factory _CulturalPreferences({
    required final String userId,
    required final List<String> preferredLanguages,
    required final String primaryLanguage,
    required final List<String> culturalTags,
    required final Map<String, double> languagePreferences,
    required final DateTime lastUpdated,
    final Map<String, dynamic> customPreferences,
    final bool autoDetectLanguage,
    final String transliterationStyle,
  }) = _$CulturalPreferencesImpl;

  factory _CulturalPreferences.fromJson(Map<String, dynamic> json) =
      _$CulturalPreferencesImpl.fromJson;

  @override
  String get userId;
  @override
  List<String> get preferredLanguages;
  @override
  String get primaryLanguage;
  @override
  List<String> get culturalTags;
  @override
  Map<String, double> get languagePreferences;
  @override
  DateTime get lastUpdated;
  @override
  Map<String, dynamic> get customPreferences;
  @override
  bool get autoDetectLanguage;
  @override
  String get transliterationStyle;

  /// Create a copy of CulturalPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CulturalPreferencesImplCopyWith<_$CulturalPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CulturalPreferenceUpdate _$CulturalPreferenceUpdateFromJson(
  Map<String, dynamic> json,
) {
  return _CulturalPreferenceUpdate.fromJson(json);
}

/// @nodoc
mixin _$CulturalPreferenceUpdate {
  String get userId => throw _privateConstructorUsedError;
  List<String>? get preferredLanguages => throw _privateConstructorUsedError;
  String? get primaryLanguage => throw _privateConstructorUsedError;
  List<String>? get culturalTags => throw _privateConstructorUsedError;
  Map<String, double>? get languagePreferences =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get customPreferences =>
      throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this CulturalPreferenceUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CulturalPreferenceUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CulturalPreferenceUpdateCopyWith<CulturalPreferenceUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CulturalPreferenceUpdateCopyWith<$Res> {
  factory $CulturalPreferenceUpdateCopyWith(
    CulturalPreferenceUpdate value,
    $Res Function(CulturalPreferenceUpdate) then,
  ) = _$CulturalPreferenceUpdateCopyWithImpl<$Res, CulturalPreferenceUpdate>;
  @useResult
  $Res call({
    String userId,
    List<String>? preferredLanguages,
    String? primaryLanguage,
    List<String>? culturalTags,
    Map<String, double>? languagePreferences,
    Map<String, dynamic>? customPreferences,
    DateTime timestamp,
  });
}

/// @nodoc
class _$CulturalPreferenceUpdateCopyWithImpl<
  $Res,
  $Val extends CulturalPreferenceUpdate
>
    implements $CulturalPreferenceUpdateCopyWith<$Res> {
  _$CulturalPreferenceUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CulturalPreferenceUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferredLanguages = freezed,
    Object? primaryLanguage = freezed,
    Object? culturalTags = freezed,
    Object? languagePreferences = freezed,
    Object? customPreferences = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            preferredLanguages:
                freezed == preferredLanguages
                    ? _value.preferredLanguages
                    : preferredLanguages // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            primaryLanguage:
                freezed == primaryLanguage
                    ? _value.primaryLanguage
                    : primaryLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            culturalTags:
                freezed == culturalTags
                    ? _value.culturalTags
                    : culturalTags // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            languagePreferences:
                freezed == languagePreferences
                    ? _value.languagePreferences
                    : languagePreferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>?,
            customPreferences:
                freezed == customPreferences
                    ? _value.customPreferences
                    : customPreferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CulturalPreferenceUpdateImplCopyWith<$Res>
    implements $CulturalPreferenceUpdateCopyWith<$Res> {
  factory _$$CulturalPreferenceUpdateImplCopyWith(
    _$CulturalPreferenceUpdateImpl value,
    $Res Function(_$CulturalPreferenceUpdateImpl) then,
  ) = __$$CulturalPreferenceUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    List<String>? preferredLanguages,
    String? primaryLanguage,
    List<String>? culturalTags,
    Map<String, double>? languagePreferences,
    Map<String, dynamic>? customPreferences,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$CulturalPreferenceUpdateImplCopyWithImpl<$Res>
    extends
        _$CulturalPreferenceUpdateCopyWithImpl<
          $Res,
          _$CulturalPreferenceUpdateImpl
        >
    implements _$$CulturalPreferenceUpdateImplCopyWith<$Res> {
  __$$CulturalPreferenceUpdateImplCopyWithImpl(
    _$CulturalPreferenceUpdateImpl _value,
    $Res Function(_$CulturalPreferenceUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CulturalPreferenceUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferredLanguages = freezed,
    Object? primaryLanguage = freezed,
    Object? culturalTags = freezed,
    Object? languagePreferences = freezed,
    Object? customPreferences = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _$CulturalPreferenceUpdateImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        preferredLanguages:
            freezed == preferredLanguages
                ? _value._preferredLanguages
                : preferredLanguages // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        primaryLanguage:
            freezed == primaryLanguage
                ? _value.primaryLanguage
                : primaryLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        culturalTags:
            freezed == culturalTags
                ? _value._culturalTags
                : culturalTags // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        languagePreferences:
            freezed == languagePreferences
                ? _value._languagePreferences
                : languagePreferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>?,
        customPreferences:
            freezed == customPreferences
                ? _value._customPreferences
                : customPreferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CulturalPreferenceUpdateImpl implements _CulturalPreferenceUpdate {
  const _$CulturalPreferenceUpdateImpl({
    required this.userId,
    final List<String>? preferredLanguages,
    this.primaryLanguage,
    final List<String>? culturalTags,
    final Map<String, double>? languagePreferences,
    final Map<String, dynamic>? customPreferences,
    required this.timestamp,
  }) : _preferredLanguages = preferredLanguages,
       _culturalTags = culturalTags,
       _languagePreferences = languagePreferences,
       _customPreferences = customPreferences;

  factory _$CulturalPreferenceUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CulturalPreferenceUpdateImplFromJson(json);

  @override
  final String userId;
  final List<String>? _preferredLanguages;
  @override
  List<String>? get preferredLanguages {
    final value = _preferredLanguages;
    if (value == null) return null;
    if (_preferredLanguages is EqualUnmodifiableListView)
      return _preferredLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? primaryLanguage;
  final List<String>? _culturalTags;
  @override
  List<String>? get culturalTags {
    final value = _culturalTags;
    if (value == null) return null;
    if (_culturalTags is EqualUnmodifiableListView) return _culturalTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, double>? _languagePreferences;
  @override
  Map<String, double>? get languagePreferences {
    final value = _languagePreferences;
    if (value == null) return null;
    if (_languagePreferences is EqualUnmodifiableMapView)
      return _languagePreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _customPreferences;
  @override
  Map<String, dynamic>? get customPreferences {
    final value = _customPreferences;
    if (value == null) return null;
    if (_customPreferences is EqualUnmodifiableMapView)
      return _customPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'CulturalPreferenceUpdate(userId: $userId, preferredLanguages: $preferredLanguages, primaryLanguage: $primaryLanguage, culturalTags: $culturalTags, languagePreferences: $languagePreferences, customPreferences: $customPreferences, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CulturalPreferenceUpdateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._preferredLanguages,
              _preferredLanguages,
            ) &&
            (identical(other.primaryLanguage, primaryLanguage) ||
                other.primaryLanguage == primaryLanguage) &&
            const DeepCollectionEquality().equals(
              other._culturalTags,
              _culturalTags,
            ) &&
            const DeepCollectionEquality().equals(
              other._languagePreferences,
              _languagePreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._customPreferences,
              _customPreferences,
            ) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_preferredLanguages),
    primaryLanguage,
    const DeepCollectionEquality().hash(_culturalTags),
    const DeepCollectionEquality().hash(_languagePreferences),
    const DeepCollectionEquality().hash(_customPreferences),
    timestamp,
  );

  /// Create a copy of CulturalPreferenceUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CulturalPreferenceUpdateImplCopyWith<_$CulturalPreferenceUpdateImpl>
  get copyWith => __$$CulturalPreferenceUpdateImplCopyWithImpl<
    _$CulturalPreferenceUpdateImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CulturalPreferenceUpdateImplToJson(this);
  }
}

abstract class _CulturalPreferenceUpdate implements CulturalPreferenceUpdate {
  const factory _CulturalPreferenceUpdate({
    required final String userId,
    final List<String>? preferredLanguages,
    final String? primaryLanguage,
    final List<String>? culturalTags,
    final Map<String, double>? languagePreferences,
    final Map<String, dynamic>? customPreferences,
    required final DateTime timestamp,
  }) = _$CulturalPreferenceUpdateImpl;

  factory _CulturalPreferenceUpdate.fromJson(Map<String, dynamic> json) =
      _$CulturalPreferenceUpdateImpl.fromJson;

  @override
  String get userId;
  @override
  List<String>? get preferredLanguages;
  @override
  String? get primaryLanguage;
  @override
  List<String>? get culturalTags;
  @override
  Map<String, double>? get languagePreferences;
  @override
  Map<String, dynamic>? get customPreferences;
  @override
  DateTime get timestamp;

  /// Create a copy of CulturalPreferenceUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CulturalPreferenceUpdateImplCopyWith<_$CulturalPreferenceUpdateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TemporalPatterns _$TemporalPatternsFromJson(Map<String, dynamic> json) {
  return _TemporalPatterns.fromJson(json);
}

/// @nodoc
mixin _$TemporalPatterns {
  String get userId => throw _privateConstructorUsedError;
  Map<int, HourlyPattern> get hourlyPatterns =>
      throw _privateConstructorUsedError;
  Map<String, DayOfWeekPattern> get dayOfWeekPatterns =>
      throw _privateConstructorUsedError;
  Map<String, SeasonalPattern> get seasonalPatterns =>
      throw _privateConstructorUsedError;
  DateTime get lastAnalyzed => throw _privateConstructorUsedError;
  Map<String, int> get prayerTimePatterns => throw _privateConstructorUsedError;
  Map<String, double> get habitStrengths => throw _privateConstructorUsedError;

  /// Serializes this TemporalPatterns to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemporalPatterns
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemporalPatternsCopyWith<TemporalPatterns> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemporalPatternsCopyWith<$Res> {
  factory $TemporalPatternsCopyWith(
    TemporalPatterns value,
    $Res Function(TemporalPatterns) then,
  ) = _$TemporalPatternsCopyWithImpl<$Res, TemporalPatterns>;
  @useResult
  $Res call({
    String userId,
    Map<int, HourlyPattern> hourlyPatterns,
    Map<String, DayOfWeekPattern> dayOfWeekPatterns,
    Map<String, SeasonalPattern> seasonalPatterns,
    DateTime lastAnalyzed,
    Map<String, int> prayerTimePatterns,
    Map<String, double> habitStrengths,
  });
}

/// @nodoc
class _$TemporalPatternsCopyWithImpl<$Res, $Val extends TemporalPatterns>
    implements $TemporalPatternsCopyWith<$Res> {
  _$TemporalPatternsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemporalPatterns
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? hourlyPatterns = null,
    Object? dayOfWeekPatterns = null,
    Object? seasonalPatterns = null,
    Object? lastAnalyzed = null,
    Object? prayerTimePatterns = null,
    Object? habitStrengths = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            hourlyPatterns:
                null == hourlyPatterns
                    ? _value.hourlyPatterns
                    : hourlyPatterns // ignore: cast_nullable_to_non_nullable
                        as Map<int, HourlyPattern>,
            dayOfWeekPatterns:
                null == dayOfWeekPatterns
                    ? _value.dayOfWeekPatterns
                    : dayOfWeekPatterns // ignore: cast_nullable_to_non_nullable
                        as Map<String, DayOfWeekPattern>,
            seasonalPatterns:
                null == seasonalPatterns
                    ? _value.seasonalPatterns
                    : seasonalPatterns // ignore: cast_nullable_to_non_nullable
                        as Map<String, SeasonalPattern>,
            lastAnalyzed:
                null == lastAnalyzed
                    ? _value.lastAnalyzed
                    : lastAnalyzed // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            prayerTimePatterns:
                null == prayerTimePatterns
                    ? _value.prayerTimePatterns
                    : prayerTimePatterns // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            habitStrengths:
                null == habitStrengths
                    ? _value.habitStrengths
                    : habitStrengths // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TemporalPatternsImplCopyWith<$Res>
    implements $TemporalPatternsCopyWith<$Res> {
  factory _$$TemporalPatternsImplCopyWith(
    _$TemporalPatternsImpl value,
    $Res Function(_$TemporalPatternsImpl) then,
  ) = __$$TemporalPatternsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    Map<int, HourlyPattern> hourlyPatterns,
    Map<String, DayOfWeekPattern> dayOfWeekPatterns,
    Map<String, SeasonalPattern> seasonalPatterns,
    DateTime lastAnalyzed,
    Map<String, int> prayerTimePatterns,
    Map<String, double> habitStrengths,
  });
}

/// @nodoc
class __$$TemporalPatternsImplCopyWithImpl<$Res>
    extends _$TemporalPatternsCopyWithImpl<$Res, _$TemporalPatternsImpl>
    implements _$$TemporalPatternsImplCopyWith<$Res> {
  __$$TemporalPatternsImplCopyWithImpl(
    _$TemporalPatternsImpl _value,
    $Res Function(_$TemporalPatternsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TemporalPatterns
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? hourlyPatterns = null,
    Object? dayOfWeekPatterns = null,
    Object? seasonalPatterns = null,
    Object? lastAnalyzed = null,
    Object? prayerTimePatterns = null,
    Object? habitStrengths = null,
  }) {
    return _then(
      _$TemporalPatternsImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        hourlyPatterns:
            null == hourlyPatterns
                ? _value._hourlyPatterns
                : hourlyPatterns // ignore: cast_nullable_to_non_nullable
                    as Map<int, HourlyPattern>,
        dayOfWeekPatterns:
            null == dayOfWeekPatterns
                ? _value._dayOfWeekPatterns
                : dayOfWeekPatterns // ignore: cast_nullable_to_non_nullable
                    as Map<String, DayOfWeekPattern>,
        seasonalPatterns:
            null == seasonalPatterns
                ? _value._seasonalPatterns
                : seasonalPatterns // ignore: cast_nullable_to_non_nullable
                    as Map<String, SeasonalPattern>,
        lastAnalyzed:
            null == lastAnalyzed
                ? _value.lastAnalyzed
                : lastAnalyzed // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        prayerTimePatterns:
            null == prayerTimePatterns
                ? _value._prayerTimePatterns
                : prayerTimePatterns // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        habitStrengths:
            null == habitStrengths
                ? _value._habitStrengths
                : habitStrengths // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TemporalPatternsImpl implements _TemporalPatterns {
  const _$TemporalPatternsImpl({
    required this.userId,
    required final Map<int, HourlyPattern> hourlyPatterns,
    required final Map<String, DayOfWeekPattern> dayOfWeekPatterns,
    required final Map<String, SeasonalPattern> seasonalPatterns,
    required this.lastAnalyzed,
    final Map<String, int> prayerTimePatterns = const {},
    final Map<String, double> habitStrengths = const {},
  }) : _hourlyPatterns = hourlyPatterns,
       _dayOfWeekPatterns = dayOfWeekPatterns,
       _seasonalPatterns = seasonalPatterns,
       _prayerTimePatterns = prayerTimePatterns,
       _habitStrengths = habitStrengths;

  factory _$TemporalPatternsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemporalPatternsImplFromJson(json);

  @override
  final String userId;
  final Map<int, HourlyPattern> _hourlyPatterns;
  @override
  Map<int, HourlyPattern> get hourlyPatterns {
    if (_hourlyPatterns is EqualUnmodifiableMapView) return _hourlyPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hourlyPatterns);
  }

  final Map<String, DayOfWeekPattern> _dayOfWeekPatterns;
  @override
  Map<String, DayOfWeekPattern> get dayOfWeekPatterns {
    if (_dayOfWeekPatterns is EqualUnmodifiableMapView)
      return _dayOfWeekPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dayOfWeekPatterns);
  }

  final Map<String, SeasonalPattern> _seasonalPatterns;
  @override
  Map<String, SeasonalPattern> get seasonalPatterns {
    if (_seasonalPatterns is EqualUnmodifiableMapView) return _seasonalPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_seasonalPatterns);
  }

  @override
  final DateTime lastAnalyzed;
  final Map<String, int> _prayerTimePatterns;
  @override
  @JsonKey()
  Map<String, int> get prayerTimePatterns {
    if (_prayerTimePatterns is EqualUnmodifiableMapView)
      return _prayerTimePatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_prayerTimePatterns);
  }

  final Map<String, double> _habitStrengths;
  @override
  @JsonKey()
  Map<String, double> get habitStrengths {
    if (_habitStrengths is EqualUnmodifiableMapView) return _habitStrengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_habitStrengths);
  }

  @override
  String toString() {
    return 'TemporalPatterns(userId: $userId, hourlyPatterns: $hourlyPatterns, dayOfWeekPatterns: $dayOfWeekPatterns, seasonalPatterns: $seasonalPatterns, lastAnalyzed: $lastAnalyzed, prayerTimePatterns: $prayerTimePatterns, habitStrengths: $habitStrengths)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemporalPatternsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._hourlyPatterns,
              _hourlyPatterns,
            ) &&
            const DeepCollectionEquality().equals(
              other._dayOfWeekPatterns,
              _dayOfWeekPatterns,
            ) &&
            const DeepCollectionEquality().equals(
              other._seasonalPatterns,
              _seasonalPatterns,
            ) &&
            (identical(other.lastAnalyzed, lastAnalyzed) ||
                other.lastAnalyzed == lastAnalyzed) &&
            const DeepCollectionEquality().equals(
              other._prayerTimePatterns,
              _prayerTimePatterns,
            ) &&
            const DeepCollectionEquality().equals(
              other._habitStrengths,
              _habitStrengths,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_hourlyPatterns),
    const DeepCollectionEquality().hash(_dayOfWeekPatterns),
    const DeepCollectionEquality().hash(_seasonalPatterns),
    lastAnalyzed,
    const DeepCollectionEquality().hash(_prayerTimePatterns),
    const DeepCollectionEquality().hash(_habitStrengths),
  );

  /// Create a copy of TemporalPatterns
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemporalPatternsImplCopyWith<_$TemporalPatternsImpl> get copyWith =>
      __$$TemporalPatternsImplCopyWithImpl<_$TemporalPatternsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TemporalPatternsImplToJson(this);
  }
}

abstract class _TemporalPatterns implements TemporalPatterns {
  const factory _TemporalPatterns({
    required final String userId,
    required final Map<int, HourlyPattern> hourlyPatterns,
    required final Map<String, DayOfWeekPattern> dayOfWeekPatterns,
    required final Map<String, SeasonalPattern> seasonalPatterns,
    required final DateTime lastAnalyzed,
    final Map<String, int> prayerTimePatterns,
    final Map<String, double> habitStrengths,
  }) = _$TemporalPatternsImpl;

  factory _TemporalPatterns.fromJson(Map<String, dynamic> json) =
      _$TemporalPatternsImpl.fromJson;

  @override
  String get userId;
  @override
  Map<int, HourlyPattern> get hourlyPatterns;
  @override
  Map<String, DayOfWeekPattern> get dayOfWeekPatterns;
  @override
  Map<String, SeasonalPattern> get seasonalPatterns;
  @override
  DateTime get lastAnalyzed;
  @override
  Map<String, int> get prayerTimePatterns;
  @override
  Map<String, double> get habitStrengths;

  /// Create a copy of TemporalPatterns
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemporalPatternsImplCopyWith<_$TemporalPatternsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HourlyPattern _$HourlyPatternFromJson(Map<String, dynamic> json) {
  return _HourlyPattern.fromJson(json);
}

/// @nodoc
mixin _$HourlyPattern {
  int get hour => throw _privateConstructorUsedError;
  List<String> get popularDuas => throw _privateConstructorUsedError;
  double get activityScore => throw _privateConstructorUsedError;
  Map<String, int> get categoryFrequency => throw _privateConstructorUsedError;
  int get totalInteractions => throw _privateConstructorUsedError;

  /// Serializes this HourlyPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HourlyPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HourlyPatternCopyWith<HourlyPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyPatternCopyWith<$Res> {
  factory $HourlyPatternCopyWith(
    HourlyPattern value,
    $Res Function(HourlyPattern) then,
  ) = _$HourlyPatternCopyWithImpl<$Res, HourlyPattern>;
  @useResult
  $Res call({
    int hour,
    List<String> popularDuas,
    double activityScore,
    Map<String, int> categoryFrequency,
    int totalInteractions,
  });
}

/// @nodoc
class _$HourlyPatternCopyWithImpl<$Res, $Val extends HourlyPattern>
    implements $HourlyPatternCopyWith<$Res> {
  _$HourlyPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HourlyPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? popularDuas = null,
    Object? activityScore = null,
    Object? categoryFrequency = null,
    Object? totalInteractions = null,
  }) {
    return _then(
      _value.copyWith(
            hour:
                null == hour
                    ? _value.hour
                    : hour // ignore: cast_nullable_to_non_nullable
                        as int,
            popularDuas:
                null == popularDuas
                    ? _value.popularDuas
                    : popularDuas // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            activityScore:
                null == activityScore
                    ? _value.activityScore
                    : activityScore // ignore: cast_nullable_to_non_nullable
                        as double,
            categoryFrequency:
                null == categoryFrequency
                    ? _value.categoryFrequency
                    : categoryFrequency // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            totalInteractions:
                null == totalInteractions
                    ? _value.totalInteractions
                    : totalInteractions // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HourlyPatternImplCopyWith<$Res>
    implements $HourlyPatternCopyWith<$Res> {
  factory _$$HourlyPatternImplCopyWith(
    _$HourlyPatternImpl value,
    $Res Function(_$HourlyPatternImpl) then,
  ) = __$$HourlyPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int hour,
    List<String> popularDuas,
    double activityScore,
    Map<String, int> categoryFrequency,
    int totalInteractions,
  });
}

/// @nodoc
class __$$HourlyPatternImplCopyWithImpl<$Res>
    extends _$HourlyPatternCopyWithImpl<$Res, _$HourlyPatternImpl>
    implements _$$HourlyPatternImplCopyWith<$Res> {
  __$$HourlyPatternImplCopyWithImpl(
    _$HourlyPatternImpl _value,
    $Res Function(_$HourlyPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HourlyPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? popularDuas = null,
    Object? activityScore = null,
    Object? categoryFrequency = null,
    Object? totalInteractions = null,
  }) {
    return _then(
      _$HourlyPatternImpl(
        hour:
            null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
                    as int,
        popularDuas:
            null == popularDuas
                ? _value._popularDuas
                : popularDuas // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        activityScore:
            null == activityScore
                ? _value.activityScore
                : activityScore // ignore: cast_nullable_to_non_nullable
                    as double,
        categoryFrequency:
            null == categoryFrequency
                ? _value._categoryFrequency
                : categoryFrequency // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        totalInteractions:
            null == totalInteractions
                ? _value.totalInteractions
                : totalInteractions // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HourlyPatternImpl implements _HourlyPattern {
  const _$HourlyPatternImpl({
    required this.hour,
    required final List<String> popularDuas,
    required this.activityScore,
    required final Map<String, int> categoryFrequency,
    this.totalInteractions = 0,
  }) : _popularDuas = popularDuas,
       _categoryFrequency = categoryFrequency;

  factory _$HourlyPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlyPatternImplFromJson(json);

  @override
  final int hour;
  final List<String> _popularDuas;
  @override
  List<String> get popularDuas {
    if (_popularDuas is EqualUnmodifiableListView) return _popularDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularDuas);
  }

  @override
  final double activityScore;
  final Map<String, int> _categoryFrequency;
  @override
  Map<String, int> get categoryFrequency {
    if (_categoryFrequency is EqualUnmodifiableMapView)
      return _categoryFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryFrequency);
  }

  @override
  @JsonKey()
  final int totalInteractions;

  @override
  String toString() {
    return 'HourlyPattern(hour: $hour, popularDuas: $popularDuas, activityScore: $activityScore, categoryFrequency: $categoryFrequency, totalInteractions: $totalInteractions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyPatternImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            const DeepCollectionEquality().equals(
              other._popularDuas,
              _popularDuas,
            ) &&
            (identical(other.activityScore, activityScore) ||
                other.activityScore == activityScore) &&
            const DeepCollectionEquality().equals(
              other._categoryFrequency,
              _categoryFrequency,
            ) &&
            (identical(other.totalInteractions, totalInteractions) ||
                other.totalInteractions == totalInteractions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hour,
    const DeepCollectionEquality().hash(_popularDuas),
    activityScore,
    const DeepCollectionEquality().hash(_categoryFrequency),
    totalInteractions,
  );

  /// Create a copy of HourlyPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyPatternImplCopyWith<_$HourlyPatternImpl> get copyWith =>
      __$$HourlyPatternImplCopyWithImpl<_$HourlyPatternImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlyPatternImplToJson(this);
  }
}

abstract class _HourlyPattern implements HourlyPattern {
  const factory _HourlyPattern({
    required final int hour,
    required final List<String> popularDuas,
    required final double activityScore,
    required final Map<String, int> categoryFrequency,
    final int totalInteractions,
  }) = _$HourlyPatternImpl;

  factory _HourlyPattern.fromJson(Map<String, dynamic> json) =
      _$HourlyPatternImpl.fromJson;

  @override
  int get hour;
  @override
  List<String> get popularDuas;
  @override
  double get activityScore;
  @override
  Map<String, int> get categoryFrequency;
  @override
  int get totalInteractions;

  /// Create a copy of HourlyPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HourlyPatternImplCopyWith<_$HourlyPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DayOfWeekPattern _$DayOfWeekPatternFromJson(Map<String, dynamic> json) {
  return _DayOfWeekPattern.fromJson(json);
}

/// @nodoc
mixin _$DayOfWeekPattern {
  String get dayName => throw _privateConstructorUsedError;
  List<String> get preferredDuas => throw _privateConstructorUsedError;
  double get engagementScore => throw _privateConstructorUsedError;
  Map<String, double> get timeDistribution =>
      throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;

  /// Serializes this DayOfWeekPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayOfWeekPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayOfWeekPatternCopyWith<DayOfWeekPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayOfWeekPatternCopyWith<$Res> {
  factory $DayOfWeekPatternCopyWith(
    DayOfWeekPattern value,
    $Res Function(DayOfWeekPattern) then,
  ) = _$DayOfWeekPatternCopyWithImpl<$Res, DayOfWeekPattern>;
  @useResult
  $Res call({
    String dayName,
    List<String> preferredDuas,
    double engagementScore,
    Map<String, double> timeDistribution,
    int totalSessions,
  });
}

/// @nodoc
class _$DayOfWeekPatternCopyWithImpl<$Res, $Val extends DayOfWeekPattern>
    implements $DayOfWeekPatternCopyWith<$Res> {
  _$DayOfWeekPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayOfWeekPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayName = null,
    Object? preferredDuas = null,
    Object? engagementScore = null,
    Object? timeDistribution = null,
    Object? totalSessions = null,
  }) {
    return _then(
      _value.copyWith(
            dayName:
                null == dayName
                    ? _value.dayName
                    : dayName // ignore: cast_nullable_to_non_nullable
                        as String,
            preferredDuas:
                null == preferredDuas
                    ? _value.preferredDuas
                    : preferredDuas // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            engagementScore:
                null == engagementScore
                    ? _value.engagementScore
                    : engagementScore // ignore: cast_nullable_to_non_nullable
                        as double,
            timeDistribution:
                null == timeDistribution
                    ? _value.timeDistribution
                    : timeDistribution // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
            totalSessions:
                null == totalSessions
                    ? _value.totalSessions
                    : totalSessions // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayOfWeekPatternImplCopyWith<$Res>
    implements $DayOfWeekPatternCopyWith<$Res> {
  factory _$$DayOfWeekPatternImplCopyWith(
    _$DayOfWeekPatternImpl value,
    $Res Function(_$DayOfWeekPatternImpl) then,
  ) = __$$DayOfWeekPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String dayName,
    List<String> preferredDuas,
    double engagementScore,
    Map<String, double> timeDistribution,
    int totalSessions,
  });
}

/// @nodoc
class __$$DayOfWeekPatternImplCopyWithImpl<$Res>
    extends _$DayOfWeekPatternCopyWithImpl<$Res, _$DayOfWeekPatternImpl>
    implements _$$DayOfWeekPatternImplCopyWith<$Res> {
  __$$DayOfWeekPatternImplCopyWithImpl(
    _$DayOfWeekPatternImpl _value,
    $Res Function(_$DayOfWeekPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayOfWeekPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayName = null,
    Object? preferredDuas = null,
    Object? engagementScore = null,
    Object? timeDistribution = null,
    Object? totalSessions = null,
  }) {
    return _then(
      _$DayOfWeekPatternImpl(
        dayName:
            null == dayName
                ? _value.dayName
                : dayName // ignore: cast_nullable_to_non_nullable
                    as String,
        preferredDuas:
            null == preferredDuas
                ? _value._preferredDuas
                : preferredDuas // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        engagementScore:
            null == engagementScore
                ? _value.engagementScore
                : engagementScore // ignore: cast_nullable_to_non_nullable
                    as double,
        timeDistribution:
            null == timeDistribution
                ? _value._timeDistribution
                : timeDistribution // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
        totalSessions:
            null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DayOfWeekPatternImpl implements _DayOfWeekPattern {
  const _$DayOfWeekPatternImpl({
    required this.dayName,
    required final List<String> preferredDuas,
    required this.engagementScore,
    required final Map<String, double> timeDistribution,
    this.totalSessions = 0,
  }) : _preferredDuas = preferredDuas,
       _timeDistribution = timeDistribution;

  factory _$DayOfWeekPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayOfWeekPatternImplFromJson(json);

  @override
  final String dayName;
  final List<String> _preferredDuas;
  @override
  List<String> get preferredDuas {
    if (_preferredDuas is EqualUnmodifiableListView) return _preferredDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredDuas);
  }

  @override
  final double engagementScore;
  final Map<String, double> _timeDistribution;
  @override
  Map<String, double> get timeDistribution {
    if (_timeDistribution is EqualUnmodifiableMapView) return _timeDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeDistribution);
  }

  @override
  @JsonKey()
  final int totalSessions;

  @override
  String toString() {
    return 'DayOfWeekPattern(dayName: $dayName, preferredDuas: $preferredDuas, engagementScore: $engagementScore, timeDistribution: $timeDistribution, totalSessions: $totalSessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayOfWeekPatternImpl &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            const DeepCollectionEquality().equals(
              other._preferredDuas,
              _preferredDuas,
            ) &&
            (identical(other.engagementScore, engagementScore) ||
                other.engagementScore == engagementScore) &&
            const DeepCollectionEquality().equals(
              other._timeDistribution,
              _timeDistribution,
            ) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dayName,
    const DeepCollectionEquality().hash(_preferredDuas),
    engagementScore,
    const DeepCollectionEquality().hash(_timeDistribution),
    totalSessions,
  );

  /// Create a copy of DayOfWeekPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayOfWeekPatternImplCopyWith<_$DayOfWeekPatternImpl> get copyWith =>
      __$$DayOfWeekPatternImplCopyWithImpl<_$DayOfWeekPatternImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DayOfWeekPatternImplToJson(this);
  }
}

abstract class _DayOfWeekPattern implements DayOfWeekPattern {
  const factory _DayOfWeekPattern({
    required final String dayName,
    required final List<String> preferredDuas,
    required final double engagementScore,
    required final Map<String, double> timeDistribution,
    final int totalSessions,
  }) = _$DayOfWeekPatternImpl;

  factory _DayOfWeekPattern.fromJson(Map<String, dynamic> json) =
      _$DayOfWeekPatternImpl.fromJson;

  @override
  String get dayName;
  @override
  List<String> get preferredDuas;
  @override
  double get engagementScore;
  @override
  Map<String, double> get timeDistribution;
  @override
  int get totalSessions;

  /// Create a copy of DayOfWeekPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayOfWeekPatternImplCopyWith<_$DayOfWeekPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SeasonalPattern _$SeasonalPatternFromJson(Map<String, dynamic> json) {
  return _SeasonalPattern.fromJson(json);
}

/// @nodoc
mixin _$SeasonalPattern {
  String get season => throw _privateConstructorUsedError;
  List<String> get seasonalDuas => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;
  Map<String, int> get occasionFrequency => throw _privateConstructorUsedError;
  List<String> get specialOccasions => throw _privateConstructorUsedError;

  /// Serializes this SeasonalPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeasonalPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeasonalPatternCopyWith<SeasonalPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonalPatternCopyWith<$Res> {
  factory $SeasonalPatternCopyWith(
    SeasonalPattern value,
    $Res Function(SeasonalPattern) then,
  ) = _$SeasonalPatternCopyWithImpl<$Res, SeasonalPattern>;
  @useResult
  $Res call({
    String season,
    List<String> seasonalDuas,
    double relevanceScore,
    Map<String, int> occasionFrequency,
    List<String> specialOccasions,
  });
}

/// @nodoc
class _$SeasonalPatternCopyWithImpl<$Res, $Val extends SeasonalPattern>
    implements $SeasonalPatternCopyWith<$Res> {
  _$SeasonalPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeasonalPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? season = null,
    Object? seasonalDuas = null,
    Object? relevanceScore = null,
    Object? occasionFrequency = null,
    Object? specialOccasions = null,
  }) {
    return _then(
      _value.copyWith(
            season:
                null == season
                    ? _value.season
                    : season // ignore: cast_nullable_to_non_nullable
                        as String,
            seasonalDuas:
                null == seasonalDuas
                    ? _value.seasonalDuas
                    : seasonalDuas // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            relevanceScore:
                null == relevanceScore
                    ? _value.relevanceScore
                    : relevanceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            occasionFrequency:
                null == occasionFrequency
                    ? _value.occasionFrequency
                    : occasionFrequency // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            specialOccasions:
                null == specialOccasions
                    ? _value.specialOccasions
                    : specialOccasions // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeasonalPatternImplCopyWith<$Res>
    implements $SeasonalPatternCopyWith<$Res> {
  factory _$$SeasonalPatternImplCopyWith(
    _$SeasonalPatternImpl value,
    $Res Function(_$SeasonalPatternImpl) then,
  ) = __$$SeasonalPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String season,
    List<String> seasonalDuas,
    double relevanceScore,
    Map<String, int> occasionFrequency,
    List<String> specialOccasions,
  });
}

/// @nodoc
class __$$SeasonalPatternImplCopyWithImpl<$Res>
    extends _$SeasonalPatternCopyWithImpl<$Res, _$SeasonalPatternImpl>
    implements _$$SeasonalPatternImplCopyWith<$Res> {
  __$$SeasonalPatternImplCopyWithImpl(
    _$SeasonalPatternImpl _value,
    $Res Function(_$SeasonalPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeasonalPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? season = null,
    Object? seasonalDuas = null,
    Object? relevanceScore = null,
    Object? occasionFrequency = null,
    Object? specialOccasions = null,
  }) {
    return _then(
      _$SeasonalPatternImpl(
        season:
            null == season
                ? _value.season
                : season // ignore: cast_nullable_to_non_nullable
                    as String,
        seasonalDuas:
            null == seasonalDuas
                ? _value._seasonalDuas
                : seasonalDuas // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        relevanceScore:
            null == relevanceScore
                ? _value.relevanceScore
                : relevanceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        occasionFrequency:
            null == occasionFrequency
                ? _value._occasionFrequency
                : occasionFrequency // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        specialOccasions:
            null == specialOccasions
                ? _value._specialOccasions
                : specialOccasions // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeasonalPatternImpl implements _SeasonalPattern {
  const _$SeasonalPatternImpl({
    required this.season,
    required final List<String> seasonalDuas,
    required this.relevanceScore,
    required final Map<String, int> occasionFrequency,
    final List<String> specialOccasions = const [],
  }) : _seasonalDuas = seasonalDuas,
       _occasionFrequency = occasionFrequency,
       _specialOccasions = specialOccasions;

  factory _$SeasonalPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeasonalPatternImplFromJson(json);

  @override
  final String season;
  final List<String> _seasonalDuas;
  @override
  List<String> get seasonalDuas {
    if (_seasonalDuas is EqualUnmodifiableListView) return _seasonalDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seasonalDuas);
  }

  @override
  final double relevanceScore;
  final Map<String, int> _occasionFrequency;
  @override
  Map<String, int> get occasionFrequency {
    if (_occasionFrequency is EqualUnmodifiableMapView)
      return _occasionFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_occasionFrequency);
  }

  final List<String> _specialOccasions;
  @override
  @JsonKey()
  List<String> get specialOccasions {
    if (_specialOccasions is EqualUnmodifiableListView)
      return _specialOccasions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialOccasions);
  }

  @override
  String toString() {
    return 'SeasonalPattern(season: $season, seasonalDuas: $seasonalDuas, relevanceScore: $relevanceScore, occasionFrequency: $occasionFrequency, specialOccasions: $specialOccasions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonalPatternImpl &&
            (identical(other.season, season) || other.season == season) &&
            const DeepCollectionEquality().equals(
              other._seasonalDuas,
              _seasonalDuas,
            ) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            const DeepCollectionEquality().equals(
              other._occasionFrequency,
              _occasionFrequency,
            ) &&
            const DeepCollectionEquality().equals(
              other._specialOccasions,
              _specialOccasions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    season,
    const DeepCollectionEquality().hash(_seasonalDuas),
    relevanceScore,
    const DeepCollectionEquality().hash(_occasionFrequency),
    const DeepCollectionEquality().hash(_specialOccasions),
  );

  /// Create a copy of SeasonalPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonalPatternImplCopyWith<_$SeasonalPatternImpl> get copyWith =>
      __$$SeasonalPatternImplCopyWithImpl<_$SeasonalPatternImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SeasonalPatternImplToJson(this);
  }
}

abstract class _SeasonalPattern implements SeasonalPattern {
  const factory _SeasonalPattern({
    required final String season,
    required final List<String> seasonalDuas,
    required final double relevanceScore,
    required final Map<String, int> occasionFrequency,
    final List<String> specialOccasions,
  }) = _$SeasonalPatternImpl;

  factory _SeasonalPattern.fromJson(Map<String, dynamic> json) =
      _$SeasonalPatternImpl.fromJson;

  @override
  String get season;
  @override
  List<String> get seasonalDuas;
  @override
  double get relevanceScore;
  @override
  Map<String, int> get occasionFrequency;
  @override
  List<String> get specialOccasions;

  /// Create a copy of SeasonalPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeasonalPatternImplCopyWith<_$SeasonalPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonalizationContext _$PersonalizationContextFromJson(
  Map<String, dynamic> json,
) {
  return _PersonalizationContext.fromJson(json);
}

/// @nodoc
mixin _$PersonalizationContext {
  String get userId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  UsagePatterns get usagePatterns => throw _privateConstructorUsedError;
  CulturalPreferences get culturalPreferences =>
      throw _privateConstructorUsedError;
  TemporalPatterns get temporalPatterns => throw _privateConstructorUsedError;
  TimeContext get islamicTimeContext => throw _privateConstructorUsedError;
  LocationContext? get locationContext => throw _privateConstructorUsedError;
  Map<String, dynamic> get sessionContext => throw _privateConstructorUsedError;
  PrivacyLevel get privacyLevel => throw _privateConstructorUsedError;
  Map<String, dynamic> get customContext => throw _privateConstructorUsedError;

  /// Serializes this PersonalizationContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalizationContextCopyWith<PersonalizationContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizationContextCopyWith<$Res> {
  factory $PersonalizationContextCopyWith(
    PersonalizationContext value,
    $Res Function(PersonalizationContext) then,
  ) = _$PersonalizationContextCopyWithImpl<$Res, PersonalizationContext>;
  @useResult
  $Res call({
    String userId,
    String sessionId,
    String query,
    DateTime timestamp,
    UsagePatterns usagePatterns,
    CulturalPreferences culturalPreferences,
    TemporalPatterns temporalPatterns,
    TimeContext islamicTimeContext,
    LocationContext? locationContext,
    Map<String, dynamic> sessionContext,
    PrivacyLevel privacyLevel,
    Map<String, dynamic> customContext,
  });

  $UsagePatternsCopyWith<$Res> get usagePatterns;
  $CulturalPreferencesCopyWith<$Res> get culturalPreferences;
  $TemporalPatternsCopyWith<$Res> get temporalPatterns;
  $TimeContextCopyWith<$Res> get islamicTimeContext;
  $LocationContextCopyWith<$Res>? get locationContext;
}

/// @nodoc
class _$PersonalizationContextCopyWithImpl<
  $Res,
  $Val extends PersonalizationContext
>
    implements $PersonalizationContextCopyWith<$Res> {
  _$PersonalizationContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sessionId = null,
    Object? query = null,
    Object? timestamp = null,
    Object? usagePatterns = null,
    Object? culturalPreferences = null,
    Object? temporalPatterns = null,
    Object? islamicTimeContext = null,
    Object? locationContext = freezed,
    Object? sessionContext = null,
    Object? privacyLevel = null,
    Object? customContext = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            query:
                null == query
                    ? _value.query
                    : query // ignore: cast_nullable_to_non_nullable
                        as String,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            usagePatterns:
                null == usagePatterns
                    ? _value.usagePatterns
                    : usagePatterns // ignore: cast_nullable_to_non_nullable
                        as UsagePatterns,
            culturalPreferences:
                null == culturalPreferences
                    ? _value.culturalPreferences
                    : culturalPreferences // ignore: cast_nullable_to_non_nullable
                        as CulturalPreferences,
            temporalPatterns:
                null == temporalPatterns
                    ? _value.temporalPatterns
                    : temporalPatterns // ignore: cast_nullable_to_non_nullable
                        as TemporalPatterns,
            islamicTimeContext:
                null == islamicTimeContext
                    ? _value.islamicTimeContext
                    : islamicTimeContext // ignore: cast_nullable_to_non_nullable
                        as TimeContext,
            locationContext:
                freezed == locationContext
                    ? _value.locationContext
                    : locationContext // ignore: cast_nullable_to_non_nullable
                        as LocationContext?,
            sessionContext:
                null == sessionContext
                    ? _value.sessionContext
                    : sessionContext // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            privacyLevel:
                null == privacyLevel
                    ? _value.privacyLevel
                    : privacyLevel // ignore: cast_nullable_to_non_nullable
                        as PrivacyLevel,
            customContext:
                null == customContext
                    ? _value.customContext
                    : customContext // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
          )
          as $Val,
    );
  }

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsagePatternsCopyWith<$Res> get usagePatterns {
    return $UsagePatternsCopyWith<$Res>(_value.usagePatterns, (value) {
      return _then(_value.copyWith(usagePatterns: value) as $Val);
    });
  }

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CulturalPreferencesCopyWith<$Res> get culturalPreferences {
    return $CulturalPreferencesCopyWith<$Res>(_value.culturalPreferences, (
      value,
    ) {
      return _then(_value.copyWith(culturalPreferences: value) as $Val);
    });
  }

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemporalPatternsCopyWith<$Res> get temporalPatterns {
    return $TemporalPatternsCopyWith<$Res>(_value.temporalPatterns, (value) {
      return _then(_value.copyWith(temporalPatterns: value) as $Val);
    });
  }

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeContextCopyWith<$Res> get islamicTimeContext {
    return $TimeContextCopyWith<$Res>(_value.islamicTimeContext, (value) {
      return _then(_value.copyWith(islamicTimeContext: value) as $Val);
    });
  }

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationContextCopyWith<$Res>? get locationContext {
    if (_value.locationContext == null) {
      return null;
    }

    return $LocationContextCopyWith<$Res>(_value.locationContext!, (value) {
      return _then(_value.copyWith(locationContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PersonalizationContextImplCopyWith<$Res>
    implements $PersonalizationContextCopyWith<$Res> {
  factory _$$PersonalizationContextImplCopyWith(
    _$PersonalizationContextImpl value,
    $Res Function(_$PersonalizationContextImpl) then,
  ) = __$$PersonalizationContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String sessionId,
    String query,
    DateTime timestamp,
    UsagePatterns usagePatterns,
    CulturalPreferences culturalPreferences,
    TemporalPatterns temporalPatterns,
    TimeContext islamicTimeContext,
    LocationContext? locationContext,
    Map<String, dynamic> sessionContext,
    PrivacyLevel privacyLevel,
    Map<String, dynamic> customContext,
  });

  @override
  $UsagePatternsCopyWith<$Res> get usagePatterns;
  @override
  $CulturalPreferencesCopyWith<$Res> get culturalPreferences;
  @override
  $TemporalPatternsCopyWith<$Res> get temporalPatterns;
  @override
  $TimeContextCopyWith<$Res> get islamicTimeContext;
  @override
  $LocationContextCopyWith<$Res>? get locationContext;
}

/// @nodoc
class __$$PersonalizationContextImplCopyWithImpl<$Res>
    extends
        _$PersonalizationContextCopyWithImpl<$Res, _$PersonalizationContextImpl>
    implements _$$PersonalizationContextImplCopyWith<$Res> {
  __$$PersonalizationContextImplCopyWithImpl(
    _$PersonalizationContextImpl _value,
    $Res Function(_$PersonalizationContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sessionId = null,
    Object? query = null,
    Object? timestamp = null,
    Object? usagePatterns = null,
    Object? culturalPreferences = null,
    Object? temporalPatterns = null,
    Object? islamicTimeContext = null,
    Object? locationContext = freezed,
    Object? sessionContext = null,
    Object? privacyLevel = null,
    Object? customContext = null,
  }) {
    return _then(
      _$PersonalizationContextImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        query:
            null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                    as String,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        usagePatterns:
            null == usagePatterns
                ? _value.usagePatterns
                : usagePatterns // ignore: cast_nullable_to_non_nullable
                    as UsagePatterns,
        culturalPreferences:
            null == culturalPreferences
                ? _value.culturalPreferences
                : culturalPreferences // ignore: cast_nullable_to_non_nullable
                    as CulturalPreferences,
        temporalPatterns:
            null == temporalPatterns
                ? _value.temporalPatterns
                : temporalPatterns // ignore: cast_nullable_to_non_nullable
                    as TemporalPatterns,
        islamicTimeContext:
            null == islamicTimeContext
                ? _value.islamicTimeContext
                : islamicTimeContext // ignore: cast_nullable_to_non_nullable
                    as TimeContext,
        locationContext:
            freezed == locationContext
                ? _value.locationContext
                : locationContext // ignore: cast_nullable_to_non_nullable
                    as LocationContext?,
        sessionContext:
            null == sessionContext
                ? _value._sessionContext
                : sessionContext // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        privacyLevel:
            null == privacyLevel
                ? _value.privacyLevel
                : privacyLevel // ignore: cast_nullable_to_non_nullable
                    as PrivacyLevel,
        customContext:
            null == customContext
                ? _value._customContext
                : customContext // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalizationContextImpl implements _PersonalizationContext {
  const _$PersonalizationContextImpl({
    required this.userId,
    required this.sessionId,
    required this.query,
    required this.timestamp,
    required this.usagePatterns,
    required this.culturalPreferences,
    required this.temporalPatterns,
    required this.islamicTimeContext,
    this.locationContext,
    required final Map<String, dynamic> sessionContext,
    required this.privacyLevel,
    final Map<String, dynamic> customContext = const {},
  }) : _sessionContext = sessionContext,
       _customContext = customContext;

  factory _$PersonalizationContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalizationContextImplFromJson(json);

  @override
  final String userId;
  @override
  final String sessionId;
  @override
  final String query;
  @override
  final DateTime timestamp;
  @override
  final UsagePatterns usagePatterns;
  @override
  final CulturalPreferences culturalPreferences;
  @override
  final TemporalPatterns temporalPatterns;
  @override
  final TimeContext islamicTimeContext;
  @override
  final LocationContext? locationContext;
  final Map<String, dynamic> _sessionContext;
  @override
  Map<String, dynamic> get sessionContext {
    if (_sessionContext is EqualUnmodifiableMapView) return _sessionContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sessionContext);
  }

  @override
  final PrivacyLevel privacyLevel;
  final Map<String, dynamic> _customContext;
  @override
  @JsonKey()
  Map<String, dynamic> get customContext {
    if (_customContext is EqualUnmodifiableMapView) return _customContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customContext);
  }

  @override
  String toString() {
    return 'PersonalizationContext(userId: $userId, sessionId: $sessionId, query: $query, timestamp: $timestamp, usagePatterns: $usagePatterns, culturalPreferences: $culturalPreferences, temporalPatterns: $temporalPatterns, islamicTimeContext: $islamicTimeContext, locationContext: $locationContext, sessionContext: $sessionContext, privacyLevel: $privacyLevel, customContext: $customContext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationContextImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.usagePatterns, usagePatterns) ||
                other.usagePatterns == usagePatterns) &&
            (identical(other.culturalPreferences, culturalPreferences) ||
                other.culturalPreferences == culturalPreferences) &&
            (identical(other.temporalPatterns, temporalPatterns) ||
                other.temporalPatterns == temporalPatterns) &&
            (identical(other.islamicTimeContext, islamicTimeContext) ||
                other.islamicTimeContext == islamicTimeContext) &&
            (identical(other.locationContext, locationContext) ||
                other.locationContext == locationContext) &&
            const DeepCollectionEquality().equals(
              other._sessionContext,
              _sessionContext,
            ) &&
            (identical(other.privacyLevel, privacyLevel) ||
                other.privacyLevel == privacyLevel) &&
            const DeepCollectionEquality().equals(
              other._customContext,
              _customContext,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    sessionId,
    query,
    timestamp,
    usagePatterns,
    culturalPreferences,
    temporalPatterns,
    islamicTimeContext,
    locationContext,
    const DeepCollectionEquality().hash(_sessionContext),
    privacyLevel,
    const DeepCollectionEquality().hash(_customContext),
  );

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationContextImplCopyWith<_$PersonalizationContextImpl>
  get copyWith =>
      __$$PersonalizationContextImplCopyWithImpl<_$PersonalizationContextImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalizationContextImplToJson(this);
  }
}

abstract class _PersonalizationContext implements PersonalizationContext {
  const factory _PersonalizationContext({
    required final String userId,
    required final String sessionId,
    required final String query,
    required final DateTime timestamp,
    required final UsagePatterns usagePatterns,
    required final CulturalPreferences culturalPreferences,
    required final TemporalPatterns temporalPatterns,
    required final TimeContext islamicTimeContext,
    final LocationContext? locationContext,
    required final Map<String, dynamic> sessionContext,
    required final PrivacyLevel privacyLevel,
    final Map<String, dynamic> customContext,
  }) = _$PersonalizationContextImpl;

  factory _PersonalizationContext.fromJson(Map<String, dynamic> json) =
      _$PersonalizationContextImpl.fromJson;

  @override
  String get userId;
  @override
  String get sessionId;
  @override
  String get query;
  @override
  DateTime get timestamp;
  @override
  UsagePatterns get usagePatterns;
  @override
  CulturalPreferences get culturalPreferences;
  @override
  TemporalPatterns get temporalPatterns;
  @override
  TimeContext get islamicTimeContext;
  @override
  LocationContext? get locationContext;
  @override
  Map<String, dynamic> get sessionContext;
  @override
  PrivacyLevel get privacyLevel;
  @override
  Map<String, dynamic> get customContext;

  /// Create a copy of PersonalizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationContextImplCopyWith<_$PersonalizationContextImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LocationContext _$LocationContextFromJson(Map<String, dynamic> json) {
  return _LocationContext.fromJson(json);
}

/// @nodoc
mixin _$LocationContext {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  bool get isHome => throw _privateConstructorUsedError;
  bool get isTraveling => throw _privateConstructorUsedError;

  /// Serializes this LocationContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationContextCopyWith<LocationContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationContextCopyWith<$Res> {
  factory $LocationContextCopyWith(
    LocationContext value,
    $Res Function(LocationContext) then,
  ) = _$LocationContextCopyWithImpl<$Res, LocationContext>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    double accuracy,
    DateTime timestamp,
    String? city,
    String? country,
    bool isHome,
    bool isTraveling,
  });
}

/// @nodoc
class _$LocationContextCopyWithImpl<$Res, $Val extends LocationContext>
    implements $LocationContextCopyWith<$Res> {
  _$LocationContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = null,
    Object? timestamp = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? isHome = null,
    Object? isTraveling = null,
  }) {
    return _then(
      _value.copyWith(
            latitude:
                null == latitude
                    ? _value.latitude
                    : latitude // ignore: cast_nullable_to_non_nullable
                        as double,
            longitude:
                null == longitude
                    ? _value.longitude
                    : longitude // ignore: cast_nullable_to_non_nullable
                        as double,
            accuracy:
                null == accuracy
                    ? _value.accuracy
                    : accuracy // ignore: cast_nullable_to_non_nullable
                        as double,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            country:
                freezed == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String?,
            isHome:
                null == isHome
                    ? _value.isHome
                    : isHome // ignore: cast_nullable_to_non_nullable
                        as bool,
            isTraveling:
                null == isTraveling
                    ? _value.isTraveling
                    : isTraveling // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationContextImplCopyWith<$Res>
    implements $LocationContextCopyWith<$Res> {
  factory _$$LocationContextImplCopyWith(
    _$LocationContextImpl value,
    $Res Function(_$LocationContextImpl) then,
  ) = __$$LocationContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    double accuracy,
    DateTime timestamp,
    String? city,
    String? country,
    bool isHome,
    bool isTraveling,
  });
}

/// @nodoc
class __$$LocationContextImplCopyWithImpl<$Res>
    extends _$LocationContextCopyWithImpl<$Res, _$LocationContextImpl>
    implements _$$LocationContextImplCopyWith<$Res> {
  __$$LocationContextImplCopyWithImpl(
    _$LocationContextImpl _value,
    $Res Function(_$LocationContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = null,
    Object? timestamp = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? isHome = null,
    Object? isTraveling = null,
  }) {
    return _then(
      _$LocationContextImpl(
        latitude:
            null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                    as double,
        longitude:
            null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                    as double,
        accuracy:
            null == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                    as double,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        country:
            freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String?,
        isHome:
            null == isHome
                ? _value.isHome
                : isHome // ignore: cast_nullable_to_non_nullable
                    as bool,
        isTraveling:
            null == isTraveling
                ? _value.isTraveling
                : isTraveling // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationContextImpl implements _LocationContext {
  const _$LocationContextImpl({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    this.city,
    this.country,
    this.isHome = false,
    this.isTraveling = false,
  });

  factory _$LocationContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationContextImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double accuracy;
  @override
  final DateTime timestamp;
  @override
  final String? city;
  @override
  final String? country;
  @override
  @JsonKey()
  final bool isHome;
  @override
  @JsonKey()
  final bool isTraveling;

  @override
  String toString() {
    return 'LocationContext(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, timestamp: $timestamp, city: $city, country: $country, isHome: $isHome, isTraveling: $isTraveling)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationContextImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isHome, isHome) || other.isHome == isHome) &&
            (identical(other.isTraveling, isTraveling) ||
                other.isTraveling == isTraveling));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    accuracy,
    timestamp,
    city,
    country,
    isHome,
    isTraveling,
  );

  /// Create a copy of LocationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationContextImplCopyWith<_$LocationContextImpl> get copyWith =>
      __$$LocationContextImplCopyWithImpl<_$LocationContextImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationContextImplToJson(this);
  }
}

abstract class _LocationContext implements LocationContext {
  const factory _LocationContext({
    required final double latitude,
    required final double longitude,
    required final double accuracy,
    required final DateTime timestamp,
    final String? city,
    final String? country,
    final bool isHome,
    final bool isTraveling,
  }) = _$LocationContextImpl;

  factory _LocationContext.fromJson(Map<String, dynamic> json) =
      _$LocationContextImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get accuracy;
  @override
  DateTime get timestamp;
  @override
  String? get city;
  @override
  String? get country;
  @override
  bool get isHome;
  @override
  bool get isTraveling;

  /// Create a copy of LocationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationContextImplCopyWith<_$LocationContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonalizationInput _$PersonalizationInputFromJson(Map<String, dynamic> json) {
  return _PersonalizationInput.fromJson(json);
}

/// @nodoc
mixin _$PersonalizationInput {
  String get query => throw _privateConstructorUsedError;
  List<DuaEntity> get candidateDuas => throw _privateConstructorUsedError;
  PersonalizationContext get context => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this PersonalizationInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalizationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalizationInputCopyWith<PersonalizationInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizationInputCopyWith<$Res> {
  factory $PersonalizationInputCopyWith(
    PersonalizationInput value,
    $Res Function(PersonalizationInput) then,
  ) = _$PersonalizationInputCopyWithImpl<$Res, PersonalizationInput>;
  @useResult
  $Res call({
    String query,
    List<DuaEntity> candidateDuas,
    PersonalizationContext context,
    String userId,
  });

  $PersonalizationContextCopyWith<$Res> get context;
}

/// @nodoc
class _$PersonalizationInputCopyWithImpl<
  $Res,
  $Val extends PersonalizationInput
>
    implements $PersonalizationInputCopyWith<$Res> {
  _$PersonalizationInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? candidateDuas = null,
    Object? context = null,
    Object? userId = null,
  }) {
    return _then(
      _value.copyWith(
            query:
                null == query
                    ? _value.query
                    : query // ignore: cast_nullable_to_non_nullable
                        as String,
            candidateDuas:
                null == candidateDuas
                    ? _value.candidateDuas
                    : candidateDuas // ignore: cast_nullable_to_non_nullable
                        as List<DuaEntity>,
            context:
                null == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as PersonalizationContext,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }

  /// Create a copy of PersonalizationInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalizationContextCopyWith<$Res> get context {
    return $PersonalizationContextCopyWith<$Res>(_value.context, (value) {
      return _then(_value.copyWith(context: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PersonalizationInputImplCopyWith<$Res>
    implements $PersonalizationInputCopyWith<$Res> {
  factory _$$PersonalizationInputImplCopyWith(
    _$PersonalizationInputImpl value,
    $Res Function(_$PersonalizationInputImpl) then,
  ) = __$$PersonalizationInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String query,
    List<DuaEntity> candidateDuas,
    PersonalizationContext context,
    String userId,
  });

  @override
  $PersonalizationContextCopyWith<$Res> get context;
}

/// @nodoc
class __$$PersonalizationInputImplCopyWithImpl<$Res>
    extends _$PersonalizationInputCopyWithImpl<$Res, _$PersonalizationInputImpl>
    implements _$$PersonalizationInputImplCopyWith<$Res> {
  __$$PersonalizationInputImplCopyWithImpl(
    _$PersonalizationInputImpl _value,
    $Res Function(_$PersonalizationInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? candidateDuas = null,
    Object? context = null,
    Object? userId = null,
  }) {
    return _then(
      _$PersonalizationInputImpl(
        query:
            null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                    as String,
        candidateDuas:
            null == candidateDuas
                ? _value._candidateDuas
                : candidateDuas // ignore: cast_nullable_to_non_nullable
                    as List<DuaEntity>,
        context:
            null == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                    as PersonalizationContext,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalizationInputImpl implements _PersonalizationInput {
  const _$PersonalizationInputImpl({
    required this.query,
    required final List<DuaEntity> candidateDuas,
    required this.context,
    required this.userId,
  }) : _candidateDuas = candidateDuas;

  factory _$PersonalizationInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalizationInputImplFromJson(json);

  @override
  final String query;
  final List<DuaEntity> _candidateDuas;
  @override
  List<DuaEntity> get candidateDuas {
    if (_candidateDuas is EqualUnmodifiableListView) return _candidateDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidateDuas);
  }

  @override
  final PersonalizationContext context;
  @override
  final String userId;

  @override
  String toString() {
    return 'PersonalizationInput(query: $query, candidateDuas: $candidateDuas, context: $context, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationInputImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(
              other._candidateDuas,
              _candidateDuas,
            ) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    const DeepCollectionEquality().hash(_candidateDuas),
    context,
    userId,
  );

  /// Create a copy of PersonalizationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationInputImplCopyWith<_$PersonalizationInputImpl>
  get copyWith =>
      __$$PersonalizationInputImplCopyWithImpl<_$PersonalizationInputImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalizationInputImplToJson(this);
  }
}

abstract class _PersonalizationInput implements PersonalizationInput {
  const factory _PersonalizationInput({
    required final String query,
    required final List<DuaEntity> candidateDuas,
    required final PersonalizationContext context,
    required final String userId,
  }) = _$PersonalizationInputImpl;

  factory _PersonalizationInput.fromJson(Map<String, dynamic> json) =
      _$PersonalizationInputImpl.fromJson;

  @override
  String get query;
  @override
  List<DuaEntity> get candidateDuas;
  @override
  PersonalizationContext get context;
  @override
  String get userId;

  /// Create a copy of PersonalizationInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationInputImplCopyWith<_$PersonalizationInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ContextualSuggestionInput _$ContextualSuggestionInputFromJson(
  Map<String, dynamic> json,
) {
  return _ContextualSuggestionInput.fromJson(json);
}

/// @nodoc
mixin _$ContextualSuggestionInput {
  String get userId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  TimeContext get islamicContext => throw _privateConstructorUsedError;
  TemporalPatterns get timePatterns => throw _privateConstructorUsedError;
  UsagePatterns get usagePatterns => throw _privateConstructorUsedError;
  List<String> get locationSuggestions => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Serializes this ContextualSuggestionInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContextualSuggestionInputCopyWith<ContextualSuggestionInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextualSuggestionInputCopyWith<$Res> {
  factory $ContextualSuggestionInputCopyWith(
    ContextualSuggestionInput value,
    $Res Function(ContextualSuggestionInput) then,
  ) = _$ContextualSuggestionInputCopyWithImpl<$Res, ContextualSuggestionInput>;
  @useResult
  $Res call({
    String userId,
    DateTime timestamp,
    TimeContext islamicContext,
    TemporalPatterns timePatterns,
    UsagePatterns usagePatterns,
    List<String> locationSuggestions,
    int limit,
  });

  $TimeContextCopyWith<$Res> get islamicContext;
  $TemporalPatternsCopyWith<$Res> get timePatterns;
  $UsagePatternsCopyWith<$Res> get usagePatterns;
}

/// @nodoc
class _$ContextualSuggestionInputCopyWithImpl<
  $Res,
  $Val extends ContextualSuggestionInput
>
    implements $ContextualSuggestionInputCopyWith<$Res> {
  _$ContextualSuggestionInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? timestamp = null,
    Object? islamicContext = null,
    Object? timePatterns = null,
    Object? usagePatterns = null,
    Object? locationSuggestions = null,
    Object? limit = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            islamicContext:
                null == islamicContext
                    ? _value.islamicContext
                    : islamicContext // ignore: cast_nullable_to_non_nullable
                        as TimeContext,
            timePatterns:
                null == timePatterns
                    ? _value.timePatterns
                    : timePatterns // ignore: cast_nullable_to_non_nullable
                        as TemporalPatterns,
            usagePatterns:
                null == usagePatterns
                    ? _value.usagePatterns
                    : usagePatterns // ignore: cast_nullable_to_non_nullable
                        as UsagePatterns,
            locationSuggestions:
                null == locationSuggestions
                    ? _value.locationSuggestions
                    : locationSuggestions // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            limit:
                null == limit
                    ? _value.limit
                    : limit // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeContextCopyWith<$Res> get islamicContext {
    return $TimeContextCopyWith<$Res>(_value.islamicContext, (value) {
      return _then(_value.copyWith(islamicContext: value) as $Val);
    });
  }

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemporalPatternsCopyWith<$Res> get timePatterns {
    return $TemporalPatternsCopyWith<$Res>(_value.timePatterns, (value) {
      return _then(_value.copyWith(timePatterns: value) as $Val);
    });
  }

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsagePatternsCopyWith<$Res> get usagePatterns {
    return $UsagePatternsCopyWith<$Res>(_value.usagePatterns, (value) {
      return _then(_value.copyWith(usagePatterns: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContextualSuggestionInputImplCopyWith<$Res>
    implements $ContextualSuggestionInputCopyWith<$Res> {
  factory _$$ContextualSuggestionInputImplCopyWith(
    _$ContextualSuggestionInputImpl value,
    $Res Function(_$ContextualSuggestionInputImpl) then,
  ) = __$$ContextualSuggestionInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    DateTime timestamp,
    TimeContext islamicContext,
    TemporalPatterns timePatterns,
    UsagePatterns usagePatterns,
    List<String> locationSuggestions,
    int limit,
  });

  @override
  $TimeContextCopyWith<$Res> get islamicContext;
  @override
  $TemporalPatternsCopyWith<$Res> get timePatterns;
  @override
  $UsagePatternsCopyWith<$Res> get usagePatterns;
}

/// @nodoc
class __$$ContextualSuggestionInputImplCopyWithImpl<$Res>
    extends
        _$ContextualSuggestionInputCopyWithImpl<
          $Res,
          _$ContextualSuggestionInputImpl
        >
    implements _$$ContextualSuggestionInputImplCopyWith<$Res> {
  __$$ContextualSuggestionInputImplCopyWithImpl(
    _$ContextualSuggestionInputImpl _value,
    $Res Function(_$ContextualSuggestionInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? timestamp = null,
    Object? islamicContext = null,
    Object? timePatterns = null,
    Object? usagePatterns = null,
    Object? locationSuggestions = null,
    Object? limit = null,
  }) {
    return _then(
      _$ContextualSuggestionInputImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        islamicContext:
            null == islamicContext
                ? _value.islamicContext
                : islamicContext // ignore: cast_nullable_to_non_nullable
                    as TimeContext,
        timePatterns:
            null == timePatterns
                ? _value.timePatterns
                : timePatterns // ignore: cast_nullable_to_non_nullable
                    as TemporalPatterns,
        usagePatterns:
            null == usagePatterns
                ? _value.usagePatterns
                : usagePatterns // ignore: cast_nullable_to_non_nullable
                    as UsagePatterns,
        locationSuggestions:
            null == locationSuggestions
                ? _value._locationSuggestions
                : locationSuggestions // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        limit:
            null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContextualSuggestionInputImpl implements _ContextualSuggestionInput {
  const _$ContextualSuggestionInputImpl({
    required this.userId,
    required this.timestamp,
    required this.islamicContext,
    required this.timePatterns,
    required this.usagePatterns,
    required final List<String> locationSuggestions,
    required this.limit,
  }) : _locationSuggestions = locationSuggestions;

  factory _$ContextualSuggestionInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContextualSuggestionInputImplFromJson(json);

  @override
  final String userId;
  @override
  final DateTime timestamp;
  @override
  final TimeContext islamicContext;
  @override
  final TemporalPatterns timePatterns;
  @override
  final UsagePatterns usagePatterns;
  final List<String> _locationSuggestions;
  @override
  List<String> get locationSuggestions {
    if (_locationSuggestions is EqualUnmodifiableListView)
      return _locationSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationSuggestions);
  }

  @override
  final int limit;

  @override
  String toString() {
    return 'ContextualSuggestionInput(userId: $userId, timestamp: $timestamp, islamicContext: $islamicContext, timePatterns: $timePatterns, usagePatterns: $usagePatterns, locationSuggestions: $locationSuggestions, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContextualSuggestionInputImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.islamicContext, islamicContext) ||
                other.islamicContext == islamicContext) &&
            (identical(other.timePatterns, timePatterns) ||
                other.timePatterns == timePatterns) &&
            (identical(other.usagePatterns, usagePatterns) ||
                other.usagePatterns == usagePatterns) &&
            const DeepCollectionEquality().equals(
              other._locationSuggestions,
              _locationSuggestions,
            ) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    timestamp,
    islamicContext,
    timePatterns,
    usagePatterns,
    const DeepCollectionEquality().hash(_locationSuggestions),
    limit,
  );

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextualSuggestionInputImplCopyWith<_$ContextualSuggestionInputImpl>
  get copyWith => __$$ContextualSuggestionInputImplCopyWithImpl<
    _$ContextualSuggestionInputImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContextualSuggestionInputImplToJson(this);
  }
}

abstract class _ContextualSuggestionInput implements ContextualSuggestionInput {
  const factory _ContextualSuggestionInput({
    required final String userId,
    required final DateTime timestamp,
    required final TimeContext islamicContext,
    required final TemporalPatterns timePatterns,
    required final UsagePatterns usagePatterns,
    required final List<String> locationSuggestions,
    required final int limit,
  }) = _$ContextualSuggestionInputImpl;

  factory _ContextualSuggestionInput.fromJson(Map<String, dynamic> json) =
      _$ContextualSuggestionInputImpl.fromJson;

  @override
  String get userId;
  @override
  DateTime get timestamp;
  @override
  TimeContext get islamicContext;
  @override
  TemporalPatterns get timePatterns;
  @override
  UsagePatterns get usagePatterns;
  @override
  List<String> get locationSuggestions;
  @override
  int get limit;

  /// Create a copy of ContextualSuggestionInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContextualSuggestionInputImplCopyWith<_$ContextualSuggestionInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AnalyticsDataPoint _$AnalyticsDataPointFromJson(Map<String, dynamic> json) {
  return _AnalyticsDataPoint.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsDataPoint {
  String get userId => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  Map<String, String> get dimensions => throw _privateConstructorUsedError;
  Map<String, double> get metrics => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDataPointCopyWith<AnalyticsDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataPointCopyWith<$Res> {
  factory $AnalyticsDataPointCopyWith(
    AnalyticsDataPoint value,
    $Res Function(AnalyticsDataPoint) then,
  ) = _$AnalyticsDataPointCopyWithImpl<$Res, AnalyticsDataPoint>;
  @useResult
  $Res call({
    String userId,
    String eventType,
    DateTime timestamp,
    Map<String, dynamic> data,
    Map<String, String> dimensions,
    Map<String, double> metrics,
  });
}

/// @nodoc
class _$AnalyticsDataPointCopyWithImpl<$Res, $Val extends AnalyticsDataPoint>
    implements $AnalyticsDataPointCopyWith<$Res> {
  _$AnalyticsDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? eventType = null,
    Object? timestamp = null,
    Object? data = null,
    Object? dimensions = null,
    Object? metrics = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            eventType:
                null == eventType
                    ? _value.eventType
                    : eventType // ignore: cast_nullable_to_non_nullable
                        as String,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            data:
                null == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            dimensions:
                null == dimensions
                    ? _value.dimensions
                    : dimensions // ignore: cast_nullable_to_non_nullable
                        as Map<String, String>,
            metrics:
                null == metrics
                    ? _value.metrics
                    : metrics // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsDataPointImplCopyWith<$Res>
    implements $AnalyticsDataPointCopyWith<$Res> {
  factory _$$AnalyticsDataPointImplCopyWith(
    _$AnalyticsDataPointImpl value,
    $Res Function(_$AnalyticsDataPointImpl) then,
  ) = __$$AnalyticsDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String eventType,
    DateTime timestamp,
    Map<String, dynamic> data,
    Map<String, String> dimensions,
    Map<String, double> metrics,
  });
}

/// @nodoc
class __$$AnalyticsDataPointImplCopyWithImpl<$Res>
    extends _$AnalyticsDataPointCopyWithImpl<$Res, _$AnalyticsDataPointImpl>
    implements _$$AnalyticsDataPointImplCopyWith<$Res> {
  __$$AnalyticsDataPointImplCopyWithImpl(
    _$AnalyticsDataPointImpl _value,
    $Res Function(_$AnalyticsDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? eventType = null,
    Object? timestamp = null,
    Object? data = null,
    Object? dimensions = null,
    Object? metrics = null,
  }) {
    return _then(
      _$AnalyticsDataPointImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        eventType:
            null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                    as String,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        data:
            null == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        dimensions:
            null == dimensions
                ? _value._dimensions
                : dimensions // ignore: cast_nullable_to_non_nullable
                    as Map<String, String>,
        metrics:
            null == metrics
                ? _value._metrics
                : metrics // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataPointImpl implements _AnalyticsDataPoint {
  const _$AnalyticsDataPointImpl({
    required this.userId,
    required this.eventType,
    required this.timestamp,
    required final Map<String, dynamic> data,
    final Map<String, String> dimensions = const {},
    final Map<String, double> metrics = const {},
  }) : _data = data,
       _dimensions = dimensions,
       _metrics = metrics;

  factory _$AnalyticsDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataPointImplFromJson(json);

  @override
  final String userId;
  @override
  final String eventType;
  @override
  final DateTime timestamp;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  final Map<String, String> _dimensions;
  @override
  @JsonKey()
  Map<String, String> get dimensions {
    if (_dimensions is EqualUnmodifiableMapView) return _dimensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dimensions);
  }

  final Map<String, double> _metrics;
  @override
  @JsonKey()
  Map<String, double> get metrics {
    if (_metrics is EqualUnmodifiableMapView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metrics);
  }

  @override
  String toString() {
    return 'AnalyticsDataPoint(userId: $userId, eventType: $eventType, timestamp: $timestamp, data: $data, dimensions: $dimensions, metrics: $metrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataPointImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(
              other._dimensions,
              _dimensions,
            ) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    eventType,
    timestamp,
    const DeepCollectionEquality().hash(_data),
    const DeepCollectionEquality().hash(_dimensions),
    const DeepCollectionEquality().hash(_metrics),
  );

  /// Create a copy of AnalyticsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataPointImplCopyWith<_$AnalyticsDataPointImpl> get copyWith =>
      __$$AnalyticsDataPointImplCopyWithImpl<_$AnalyticsDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataPointImplToJson(this);
  }
}

abstract class _AnalyticsDataPoint implements AnalyticsDataPoint {
  const factory _AnalyticsDataPoint({
    required final String userId,
    required final String eventType,
    required final DateTime timestamp,
    required final Map<String, dynamic> data,
    final Map<String, String> dimensions,
    final Map<String, double> metrics,
  }) = _$AnalyticsDataPointImpl;

  factory _AnalyticsDataPoint.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataPointImpl.fromJson;

  @override
  String get userId;
  @override
  String get eventType;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic> get data;
  @override
  Map<String, String> get dimensions;
  @override
  Map<String, double> get metrics;

  /// Create a copy of AnalyticsDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDataPointImplCopyWith<_$AnalyticsDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HabitStrength _$HabitStrengthFromJson(Map<String, dynamic> json) {
  return _HabitStrength.fromJson(json);
}

/// @nodoc
mixin _$HabitStrength {
  String get duaId => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;
  Duration get avgDuration => throw _privateConstructorUsedError;
  DateTime get lastPracticed => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  List<DateTime> get recentSessions => throw _privateConstructorUsedError;

  /// Serializes this HabitStrength to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitStrength
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitStrengthCopyWith<HabitStrength> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitStrengthCopyWith<$Res> {
  factory $HabitStrengthCopyWith(
    HabitStrength value,
    $Res Function(HabitStrength) then,
  ) = _$HabitStrengthCopyWithImpl<$Res, HabitStrength>;
  @useResult
  $Res call({
    String duaId,
    double strength,
    int frequency,
    Duration avgDuration,
    DateTime lastPracticed,
    int streakDays,
    List<DateTime> recentSessions,
  });
}

/// @nodoc
class _$HabitStrengthCopyWithImpl<$Res, $Val extends HabitStrength>
    implements $HabitStrengthCopyWith<$Res> {
  _$HabitStrengthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitStrength
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? strength = null,
    Object? frequency = null,
    Object? avgDuration = null,
    Object? lastPracticed = null,
    Object? streakDays = null,
    Object? recentSessions = null,
  }) {
    return _then(
      _value.copyWith(
            duaId:
                null == duaId
                    ? _value.duaId
                    : duaId // ignore: cast_nullable_to_non_nullable
                        as String,
            strength:
                null == strength
                    ? _value.strength
                    : strength // ignore: cast_nullable_to_non_nullable
                        as double,
            frequency:
                null == frequency
                    ? _value.frequency
                    : frequency // ignore: cast_nullable_to_non_nullable
                        as int,
            avgDuration:
                null == avgDuration
                    ? _value.avgDuration
                    : avgDuration // ignore: cast_nullable_to_non_nullable
                        as Duration,
            lastPracticed:
                null == lastPracticed
                    ? _value.lastPracticed
                    : lastPracticed // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            streakDays:
                null == streakDays
                    ? _value.streakDays
                    : streakDays // ignore: cast_nullable_to_non_nullable
                        as int,
            recentSessions:
                null == recentSessions
                    ? _value.recentSessions
                    : recentSessions // ignore: cast_nullable_to_non_nullable
                        as List<DateTime>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitStrengthImplCopyWith<$Res>
    implements $HabitStrengthCopyWith<$Res> {
  factory _$$HabitStrengthImplCopyWith(
    _$HabitStrengthImpl value,
    $Res Function(_$HabitStrengthImpl) then,
  ) = __$$HabitStrengthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String duaId,
    double strength,
    int frequency,
    Duration avgDuration,
    DateTime lastPracticed,
    int streakDays,
    List<DateTime> recentSessions,
  });
}

/// @nodoc
class __$$HabitStrengthImplCopyWithImpl<$Res>
    extends _$HabitStrengthCopyWithImpl<$Res, _$HabitStrengthImpl>
    implements _$$HabitStrengthImplCopyWith<$Res> {
  __$$HabitStrengthImplCopyWithImpl(
    _$HabitStrengthImpl _value,
    $Res Function(_$HabitStrengthImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitStrength
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? strength = null,
    Object? frequency = null,
    Object? avgDuration = null,
    Object? lastPracticed = null,
    Object? streakDays = null,
    Object? recentSessions = null,
  }) {
    return _then(
      _$HabitStrengthImpl(
        duaId:
            null == duaId
                ? _value.duaId
                : duaId // ignore: cast_nullable_to_non_nullable
                    as String,
        strength:
            null == strength
                ? _value.strength
                : strength // ignore: cast_nullable_to_non_nullable
                    as double,
        frequency:
            null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                    as int,
        avgDuration:
            null == avgDuration
                ? _value.avgDuration
                : avgDuration // ignore: cast_nullable_to_non_nullable
                    as Duration,
        lastPracticed:
            null == lastPracticed
                ? _value.lastPracticed
                : lastPracticed // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        streakDays:
            null == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                    as int,
        recentSessions:
            null == recentSessions
                ? _value._recentSessions
                : recentSessions // ignore: cast_nullable_to_non_nullable
                    as List<DateTime>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitStrengthImpl implements _HabitStrength {
  const _$HabitStrengthImpl({
    required this.duaId,
    required this.strength,
    required this.frequency,
    required this.avgDuration,
    required this.lastPracticed,
    this.streakDays = 0,
    final List<DateTime> recentSessions = const [],
  }) : _recentSessions = recentSessions;

  factory _$HabitStrengthImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitStrengthImplFromJson(json);

  @override
  final String duaId;
  @override
  final double strength;
  @override
  final int frequency;
  @override
  final Duration avgDuration;
  @override
  final DateTime lastPracticed;
  @override
  @JsonKey()
  final int streakDays;
  final List<DateTime> _recentSessions;
  @override
  @JsonKey()
  List<DateTime> get recentSessions {
    if (_recentSessions is EqualUnmodifiableListView) return _recentSessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentSessions);
  }

  @override
  String toString() {
    return 'HabitStrength(duaId: $duaId, strength: $strength, frequency: $frequency, avgDuration: $avgDuration, lastPracticed: $lastPracticed, streakDays: $streakDays, recentSessions: $recentSessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitStrengthImpl &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.avgDuration, avgDuration) ||
                other.avgDuration == avgDuration) &&
            (identical(other.lastPracticed, lastPracticed) ||
                other.lastPracticed == lastPracticed) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            const DeepCollectionEquality().equals(
              other._recentSessions,
              _recentSessions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    duaId,
    strength,
    frequency,
    avgDuration,
    lastPracticed,
    streakDays,
    const DeepCollectionEquality().hash(_recentSessions),
  );

  /// Create a copy of HabitStrength
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitStrengthImplCopyWith<_$HabitStrengthImpl> get copyWith =>
      __$$HabitStrengthImplCopyWithImpl<_$HabitStrengthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitStrengthImplToJson(this);
  }
}

abstract class _HabitStrength implements HabitStrength {
  const factory _HabitStrength({
    required final String duaId,
    required final double strength,
    required final int frequency,
    required final Duration avgDuration,
    required final DateTime lastPracticed,
    final int streakDays,
    final List<DateTime> recentSessions,
  }) = _$HabitStrengthImpl;

  factory _HabitStrength.fromJson(Map<String, dynamic> json) =
      _$HabitStrengthImpl.fromJson;

  @override
  String get duaId;
  @override
  double get strength;
  @override
  int get frequency;
  @override
  Duration get avgDuration;
  @override
  DateTime get lastPracticed;
  @override
  int get streakDays;
  @override
  List<DateTime> get recentSessions;

  /// Create a copy of HabitStrength
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitStrengthImplCopyWith<_$HabitStrengthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendationEnhancement _$RecommendationEnhancementFromJson(
  Map<String, dynamic> json,
) {
  return _RecommendationEnhancement.fromJson(json);
}

/// @nodoc
mixin _$RecommendationEnhancement {
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get confidenceBoost => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this RecommendationEnhancement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationEnhancement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationEnhancementCopyWith<RecommendationEnhancement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationEnhancementCopyWith<$Res> {
  factory $RecommendationEnhancementCopyWith(
    RecommendationEnhancement value,
    $Res Function(RecommendationEnhancement) then,
  ) = _$RecommendationEnhancementCopyWithImpl<$Res, RecommendationEnhancement>;
  @useResult
  $Res call({
    String type,
    String description,
    double confidenceBoost,
    Map<String, dynamic> parameters,
    bool isActive,
  });
}

/// @nodoc
class _$RecommendationEnhancementCopyWithImpl<
  $Res,
  $Val extends RecommendationEnhancement
>
    implements $RecommendationEnhancementCopyWith<$Res> {
  _$RecommendationEnhancementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationEnhancement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? description = null,
    Object? confidenceBoost = null,
    Object? parameters = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            confidenceBoost:
                null == confidenceBoost
                    ? _value.confidenceBoost
                    : confidenceBoost // ignore: cast_nullable_to_non_nullable
                        as double,
            parameters:
                null == parameters
                    ? _value.parameters
                    : parameters // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationEnhancementImplCopyWith<$Res>
    implements $RecommendationEnhancementCopyWith<$Res> {
  factory _$$RecommendationEnhancementImplCopyWith(
    _$RecommendationEnhancementImpl value,
    $Res Function(_$RecommendationEnhancementImpl) then,
  ) = __$$RecommendationEnhancementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    String description,
    double confidenceBoost,
    Map<String, dynamic> parameters,
    bool isActive,
  });
}

/// @nodoc
class __$$RecommendationEnhancementImplCopyWithImpl<$Res>
    extends
        _$RecommendationEnhancementCopyWithImpl<
          $Res,
          _$RecommendationEnhancementImpl
        >
    implements _$$RecommendationEnhancementImplCopyWith<$Res> {
  __$$RecommendationEnhancementImplCopyWithImpl(
    _$RecommendationEnhancementImpl _value,
    $Res Function(_$RecommendationEnhancementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationEnhancement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? description = null,
    Object? confidenceBoost = null,
    Object? parameters = null,
    Object? isActive = null,
  }) {
    return _then(
      _$RecommendationEnhancementImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        confidenceBoost:
            null == confidenceBoost
                ? _value.confidenceBoost
                : confidenceBoost // ignore: cast_nullable_to_non_nullable
                    as double,
        parameters:
            null == parameters
                ? _value._parameters
                : parameters // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationEnhancementImpl implements _RecommendationEnhancement {
  const _$RecommendationEnhancementImpl({
    required this.type,
    required this.description,
    required this.confidenceBoost,
    required final Map<String, dynamic> parameters,
    this.isActive = false,
  }) : _parameters = parameters;

  factory _$RecommendationEnhancementImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationEnhancementImplFromJson(json);

  @override
  final String type;
  @override
  final String description;
  @override
  final double confidenceBoost;
  final Map<String, dynamic> _parameters;
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'RecommendationEnhancement(type: $type, description: $description, confidenceBoost: $confidenceBoost, parameters: $parameters, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationEnhancementImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.confidenceBoost, confidenceBoost) ||
                other.confidenceBoost == confidenceBoost) &&
            const DeepCollectionEquality().equals(
              other._parameters,
              _parameters,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    description,
    confidenceBoost,
    const DeepCollectionEquality().hash(_parameters),
    isActive,
  );

  /// Create a copy of RecommendationEnhancement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationEnhancementImplCopyWith<_$RecommendationEnhancementImpl>
  get copyWith => __$$RecommendationEnhancementImplCopyWithImpl<
    _$RecommendationEnhancementImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationEnhancementImplToJson(this);
  }
}

abstract class _RecommendationEnhancement implements RecommendationEnhancement {
  const factory _RecommendationEnhancement({
    required final String type,
    required final String description,
    required final double confidenceBoost,
    required final Map<String, dynamic> parameters,
    final bool isActive,
  }) = _$RecommendationEnhancementImpl;

  factory _RecommendationEnhancement.fromJson(Map<String, dynamic> json) =
      _$RecommendationEnhancementImpl.fromJson;

  @override
  String get type;
  @override
  String get description;
  @override
  double get confidenceBoost;
  @override
  Map<String, dynamic> get parameters;
  @override
  bool get isActive;

  /// Create a copy of RecommendationEnhancement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationEnhancementImplCopyWith<_$RecommendationEnhancementImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PersonalizationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )
    loaded,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult? Function(Object error, StackTrace stackTrace)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonalizationInitial value) initial,
    required TResult Function(PersonalizationLoading value) loading,
    required TResult Function(PersonalizationLoaded value) loaded,
    required TResult Function(PersonalizationError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonalizationInitial value)? initial,
    TResult? Function(PersonalizationLoading value)? loading,
    TResult? Function(PersonalizationLoaded value)? loaded,
    TResult? Function(PersonalizationError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonalizationInitial value)? initial,
    TResult Function(PersonalizationLoading value)? loading,
    TResult Function(PersonalizationLoaded value)? loaded,
    TResult Function(PersonalizationError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizationStateCopyWith<$Res> {
  factory $PersonalizationStateCopyWith(
    PersonalizationState value,
    $Res Function(PersonalizationState) then,
  ) = _$PersonalizationStateCopyWithImpl<$Res, PersonalizationState>;
}

/// @nodoc
class _$PersonalizationStateCopyWithImpl<
  $Res,
  $Val extends PersonalizationState
>
    implements $PersonalizationStateCopyWith<$Res> {
  _$PersonalizationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PersonalizationInitialImplCopyWith<$Res> {
  factory _$$PersonalizationInitialImplCopyWith(
    _$PersonalizationInitialImpl value,
    $Res Function(_$PersonalizationInitialImpl) then,
  ) = __$$PersonalizationInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PersonalizationInitialImplCopyWithImpl<$Res>
    extends
        _$PersonalizationStateCopyWithImpl<$Res, _$PersonalizationInitialImpl>
    implements _$$PersonalizationInitialImplCopyWith<$Res> {
  __$$PersonalizationInitialImplCopyWithImpl(
    _$PersonalizationInitialImpl _value,
    $Res Function(_$PersonalizationInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PersonalizationInitialImpl implements PersonalizationInitial {
  const _$PersonalizationInitialImpl();

  @override
  String toString() {
    return 'PersonalizationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )
    loaded,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult? Function(Object error, StackTrace stackTrace)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonalizationInitial value) initial,
    required TResult Function(PersonalizationLoading value) loading,
    required TResult Function(PersonalizationLoaded value) loaded,
    required TResult Function(PersonalizationError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonalizationInitial value)? initial,
    TResult? Function(PersonalizationLoading value)? loading,
    TResult? Function(PersonalizationLoaded value)? loaded,
    TResult? Function(PersonalizationError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonalizationInitial value)? initial,
    TResult Function(PersonalizationLoading value)? loading,
    TResult Function(PersonalizationLoaded value)? loaded,
    TResult Function(PersonalizationError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PersonalizationInitial implements PersonalizationState {
  const factory PersonalizationInitial() = _$PersonalizationInitialImpl;
}

/// @nodoc
abstract class _$$PersonalizationLoadingImplCopyWith<$Res> {
  factory _$$PersonalizationLoadingImplCopyWith(
    _$PersonalizationLoadingImpl value,
    $Res Function(_$PersonalizationLoadingImpl) then,
  ) = __$$PersonalizationLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PersonalizationLoadingImplCopyWithImpl<$Res>
    extends
        _$PersonalizationStateCopyWithImpl<$Res, _$PersonalizationLoadingImpl>
    implements _$$PersonalizationLoadingImplCopyWith<$Res> {
  __$$PersonalizationLoadingImplCopyWithImpl(
    _$PersonalizationLoadingImpl _value,
    $Res Function(_$PersonalizationLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PersonalizationLoadingImpl implements PersonalizationLoading {
  const _$PersonalizationLoadingImpl();

  @override
  String toString() {
    return 'PersonalizationState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )
    loaded,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult? Function(Object error, StackTrace stackTrace)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonalizationInitial value) initial,
    required TResult Function(PersonalizationLoading value) loading,
    required TResult Function(PersonalizationLoaded value) loaded,
    required TResult Function(PersonalizationError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonalizationInitial value)? initial,
    TResult? Function(PersonalizationLoading value)? loading,
    TResult? Function(PersonalizationLoaded value)? loaded,
    TResult? Function(PersonalizationError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonalizationInitial value)? initial,
    TResult Function(PersonalizationLoading value)? loading,
    TResult Function(PersonalizationLoaded value)? loaded,
    TResult Function(PersonalizationError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PersonalizationLoading implements PersonalizationState {
  const factory PersonalizationLoading() = _$PersonalizationLoadingImpl;
}

/// @nodoc
abstract class _$$PersonalizationLoadedImplCopyWith<$Res> {
  factory _$$PersonalizationLoadedImplCopyWith(
    _$PersonalizationLoadedImpl value,
    $Res Function(_$PersonalizationLoadedImpl) then,
  ) = __$$PersonalizationLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    UsagePatterns usagePatterns,
    CulturalPreferences culturalPreferences,
    bool isPersonalizationActive,
    List<EnhancedRecommendation> recommendations,
    List<EnhancedRecommendation> contextualSuggestions,
    TemporalPatterns? temporalPatterns,
    Map<String, dynamic>? metadata,
  });

  $UsagePatternsCopyWith<$Res> get usagePatterns;
  $CulturalPreferencesCopyWith<$Res> get culturalPreferences;
  $TemporalPatternsCopyWith<$Res>? get temporalPatterns;
}

/// @nodoc
class __$$PersonalizationLoadedImplCopyWithImpl<$Res>
    extends
        _$PersonalizationStateCopyWithImpl<$Res, _$PersonalizationLoadedImpl>
    implements _$$PersonalizationLoadedImplCopyWith<$Res> {
  __$$PersonalizationLoadedImplCopyWithImpl(
    _$PersonalizationLoadedImpl _value,
    $Res Function(_$PersonalizationLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usagePatterns = null,
    Object? culturalPreferences = null,
    Object? isPersonalizationActive = null,
    Object? recommendations = null,
    Object? contextualSuggestions = null,
    Object? temporalPatterns = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PersonalizationLoadedImpl(
        usagePatterns:
            null == usagePatterns
                ? _value.usagePatterns
                : usagePatterns // ignore: cast_nullable_to_non_nullable
                    as UsagePatterns,
        culturalPreferences:
            null == culturalPreferences
                ? _value.culturalPreferences
                : culturalPreferences // ignore: cast_nullable_to_non_nullable
                    as CulturalPreferences,
        isPersonalizationActive:
            null == isPersonalizationActive
                ? _value.isPersonalizationActive
                : isPersonalizationActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        recommendations:
            null == recommendations
                ? _value._recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                    as List<EnhancedRecommendation>,
        contextualSuggestions:
            null == contextualSuggestions
                ? _value._contextualSuggestions
                : contextualSuggestions // ignore: cast_nullable_to_non_nullable
                    as List<EnhancedRecommendation>,
        temporalPatterns:
            freezed == temporalPatterns
                ? _value.temporalPatterns
                : temporalPatterns // ignore: cast_nullable_to_non_nullable
                    as TemporalPatterns?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsagePatternsCopyWith<$Res> get usagePatterns {
    return $UsagePatternsCopyWith<$Res>(_value.usagePatterns, (value) {
      return _then(_value.copyWith(usagePatterns: value));
    });
  }

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CulturalPreferencesCopyWith<$Res> get culturalPreferences {
    return $CulturalPreferencesCopyWith<$Res>(_value.culturalPreferences, (
      value,
    ) {
      return _then(_value.copyWith(culturalPreferences: value));
    });
  }

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemporalPatternsCopyWith<$Res>? get temporalPatterns {
    if (_value.temporalPatterns == null) {
      return null;
    }

    return $TemporalPatternsCopyWith<$Res>(_value.temporalPatterns!, (value) {
      return _then(_value.copyWith(temporalPatterns: value));
    });
  }
}

/// @nodoc

class _$PersonalizationLoadedImpl implements PersonalizationLoaded {
  const _$PersonalizationLoadedImpl({
    required this.usagePatterns,
    required this.culturalPreferences,
    this.isPersonalizationActive = true,
    final List<EnhancedRecommendation> recommendations = const [],
    final List<EnhancedRecommendation> contextualSuggestions = const [],
    this.temporalPatterns,
    final Map<String, dynamic>? metadata,
  }) : _recommendations = recommendations,
       _contextualSuggestions = contextualSuggestions,
       _metadata = metadata;

  @override
  final UsagePatterns usagePatterns;
  @override
  final CulturalPreferences culturalPreferences;
  @override
  @JsonKey()
  final bool isPersonalizationActive;
  final List<EnhancedRecommendation> _recommendations;
  @override
  @JsonKey()
  List<EnhancedRecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  final List<EnhancedRecommendation> _contextualSuggestions;
  @override
  @JsonKey()
  List<EnhancedRecommendation> get contextualSuggestions {
    if (_contextualSuggestions is EqualUnmodifiableListView)
      return _contextualSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contextualSuggestions);
  }

  @override
  final TemporalPatterns? temporalPatterns;
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
    return 'PersonalizationState.loaded(usagePatterns: $usagePatterns, culturalPreferences: $culturalPreferences, isPersonalizationActive: $isPersonalizationActive, recommendations: $recommendations, contextualSuggestions: $contextualSuggestions, temporalPatterns: $temporalPatterns, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationLoadedImpl &&
            (identical(other.usagePatterns, usagePatterns) ||
                other.usagePatterns == usagePatterns) &&
            (identical(other.culturalPreferences, culturalPreferences) ||
                other.culturalPreferences == culturalPreferences) &&
            (identical(
                  other.isPersonalizationActive,
                  isPersonalizationActive,
                ) ||
                other.isPersonalizationActive == isPersonalizationActive) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            const DeepCollectionEquality().equals(
              other._contextualSuggestions,
              _contextualSuggestions,
            ) &&
            (identical(other.temporalPatterns, temporalPatterns) ||
                other.temporalPatterns == temporalPatterns) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    usagePatterns,
    culturalPreferences,
    isPersonalizationActive,
    const DeepCollectionEquality().hash(_recommendations),
    const DeepCollectionEquality().hash(_contextualSuggestions),
    temporalPatterns,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationLoadedImplCopyWith<_$PersonalizationLoadedImpl>
  get copyWith =>
      __$$PersonalizationLoadedImplCopyWithImpl<_$PersonalizationLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )
    loaded,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) {
    return loaded(
      usagePatterns,
      culturalPreferences,
      isPersonalizationActive,
      recommendations,
      contextualSuggestions,
      temporalPatterns,
      metadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult? Function(Object error, StackTrace stackTrace)? error,
  }) {
    return loaded?.call(
      usagePatterns,
      culturalPreferences,
      isPersonalizationActive,
      recommendations,
      contextualSuggestions,
      temporalPatterns,
      metadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        usagePatterns,
        culturalPreferences,
        isPersonalizationActive,
        recommendations,
        contextualSuggestions,
        temporalPatterns,
        metadata,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonalizationInitial value) initial,
    required TResult Function(PersonalizationLoading value) loading,
    required TResult Function(PersonalizationLoaded value) loaded,
    required TResult Function(PersonalizationError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonalizationInitial value)? initial,
    TResult? Function(PersonalizationLoading value)? loading,
    TResult? Function(PersonalizationLoaded value)? loaded,
    TResult? Function(PersonalizationError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonalizationInitial value)? initial,
    TResult Function(PersonalizationLoading value)? loading,
    TResult Function(PersonalizationLoaded value)? loaded,
    TResult Function(PersonalizationError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class PersonalizationLoaded implements PersonalizationState {
  const factory PersonalizationLoaded({
    required final UsagePatterns usagePatterns,
    required final CulturalPreferences culturalPreferences,
    final bool isPersonalizationActive,
    final List<EnhancedRecommendation> recommendations,
    final List<EnhancedRecommendation> contextualSuggestions,
    final TemporalPatterns? temporalPatterns,
    final Map<String, dynamic>? metadata,
  }) = _$PersonalizationLoadedImpl;

  UsagePatterns get usagePatterns;
  CulturalPreferences get culturalPreferences;
  bool get isPersonalizationActive;
  List<EnhancedRecommendation> get recommendations;
  List<EnhancedRecommendation> get contextualSuggestions;
  TemporalPatterns? get temporalPatterns;
  Map<String, dynamic>? get metadata;

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationLoadedImplCopyWith<_$PersonalizationLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PersonalizationErrorImplCopyWith<$Res> {
  factory _$$PersonalizationErrorImplCopyWith(
    _$PersonalizationErrorImpl value,
    $Res Function(_$PersonalizationErrorImpl) then,
  ) = __$$PersonalizationErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Object error, StackTrace stackTrace});
}

/// @nodoc
class __$$PersonalizationErrorImplCopyWithImpl<$Res>
    extends _$PersonalizationStateCopyWithImpl<$Res, _$PersonalizationErrorImpl>
    implements _$$PersonalizationErrorImplCopyWith<$Res> {
  __$$PersonalizationErrorImplCopyWithImpl(
    _$PersonalizationErrorImpl _value,
    $Res Function(_$PersonalizationErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null, Object? stackTrace = null}) {
    return _then(
      _$PersonalizationErrorImpl(
        null == error ? _value.error : error,
        null == stackTrace
            ? _value.stackTrace
            : stackTrace // ignore: cast_nullable_to_non_nullable
                as StackTrace,
      ),
    );
  }
}

/// @nodoc

class _$PersonalizationErrorImpl implements PersonalizationError {
  const _$PersonalizationErrorImpl(this.error, this.stackTrace);

  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  @override
  String toString() {
    return 'PersonalizationState.error(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationErrorImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(error),
    stackTrace,
  );

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationErrorImplCopyWith<_$PersonalizationErrorImpl>
  get copyWith =>
      __$$PersonalizationErrorImplCopyWithImpl<_$PersonalizationErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )
    loaded,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) {
    return error(this.error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult? Function(Object error, StackTrace stackTrace)? error,
  }) {
    return error?.call(this.error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      UsagePatterns usagePatterns,
      CulturalPreferences culturalPreferences,
      bool isPersonalizationActive,
      List<EnhancedRecommendation> recommendations,
      List<EnhancedRecommendation> contextualSuggestions,
      TemporalPatterns? temporalPatterns,
      Map<String, dynamic>? metadata,
    )?
    loaded,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonalizationInitial value) initial,
    required TResult Function(PersonalizationLoading value) loading,
    required TResult Function(PersonalizationLoaded value) loaded,
    required TResult Function(PersonalizationError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonalizationInitial value)? initial,
    TResult? Function(PersonalizationLoading value)? loading,
    TResult? Function(PersonalizationLoaded value)? loaded,
    TResult? Function(PersonalizationError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonalizationInitial value)? initial,
    TResult Function(PersonalizationLoading value)? loading,
    TResult Function(PersonalizationLoaded value)? loaded,
    TResult Function(PersonalizationError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PersonalizationError implements PersonalizationState {
  const factory PersonalizationError(
    final Object error,
    final StackTrace stackTrace,
  ) = _$PersonalizationErrorImpl;

  Object get error;
  StackTrace get stackTrace;

  /// Create a copy of PersonalizationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationErrorImplCopyWith<_$PersonalizationErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PersonalizationSettings _$PersonalizationSettingsFromJson(
  Map<String, dynamic> json,
) {
  return _PersonalizationSettings.fromJson(json);
}

/// @nodoc
mixin _$PersonalizationSettings {
  bool get isEnabled => throw _privateConstructorUsedError;
  PrivacyLevel get privacyLevel => throw _privateConstructorUsedError;
  bool get analyticsEnabled => throw _privateConstructorUsedError;
  bool get locationEnabled => throw _privateConstructorUsedError;
  bool get islamicCalendarEnabled => throw _privateConstructorUsedError;
  Map<String, bool> get featureFlags => throw _privateConstructorUsedError;

  /// Serializes this PersonalizationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalizationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalizationSettingsCopyWith<PersonalizationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalizationSettingsCopyWith<$Res> {
  factory $PersonalizationSettingsCopyWith(
    PersonalizationSettings value,
    $Res Function(PersonalizationSettings) then,
  ) = _$PersonalizationSettingsCopyWithImpl<$Res, PersonalizationSettings>;
  @useResult
  $Res call({
    bool isEnabled,
    PrivacyLevel privacyLevel,
    bool analyticsEnabled,
    bool locationEnabled,
    bool islamicCalendarEnabled,
    Map<String, bool> featureFlags,
  });
}

/// @nodoc
class _$PersonalizationSettingsCopyWithImpl<
  $Res,
  $Val extends PersonalizationSettings
>
    implements $PersonalizationSettingsCopyWith<$Res> {
  _$PersonalizationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalizationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? privacyLevel = null,
    Object? analyticsEnabled = null,
    Object? locationEnabled = null,
    Object? islamicCalendarEnabled = null,
    Object? featureFlags = null,
  }) {
    return _then(
      _value.copyWith(
            isEnabled:
                null == isEnabled
                    ? _value.isEnabled
                    : isEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            privacyLevel:
                null == privacyLevel
                    ? _value.privacyLevel
                    : privacyLevel // ignore: cast_nullable_to_non_nullable
                        as PrivacyLevel,
            analyticsEnabled:
                null == analyticsEnabled
                    ? _value.analyticsEnabled
                    : analyticsEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            locationEnabled:
                null == locationEnabled
                    ? _value.locationEnabled
                    : locationEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            islamicCalendarEnabled:
                null == islamicCalendarEnabled
                    ? _value.islamicCalendarEnabled
                    : islamicCalendarEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            featureFlags:
                null == featureFlags
                    ? _value.featureFlags
                    : featureFlags // ignore: cast_nullable_to_non_nullable
                        as Map<String, bool>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PersonalizationSettingsImplCopyWith<$Res>
    implements $PersonalizationSettingsCopyWith<$Res> {
  factory _$$PersonalizationSettingsImplCopyWith(
    _$PersonalizationSettingsImpl value,
    $Res Function(_$PersonalizationSettingsImpl) then,
  ) = __$$PersonalizationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isEnabled,
    PrivacyLevel privacyLevel,
    bool analyticsEnabled,
    bool locationEnabled,
    bool islamicCalendarEnabled,
    Map<String, bool> featureFlags,
  });
}

/// @nodoc
class __$$PersonalizationSettingsImplCopyWithImpl<$Res>
    extends
        _$PersonalizationSettingsCopyWithImpl<
          $Res,
          _$PersonalizationSettingsImpl
        >
    implements _$$PersonalizationSettingsImplCopyWith<$Res> {
  __$$PersonalizationSettingsImplCopyWithImpl(
    _$PersonalizationSettingsImpl _value,
    $Res Function(_$PersonalizationSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersonalizationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? privacyLevel = null,
    Object? analyticsEnabled = null,
    Object? locationEnabled = null,
    Object? islamicCalendarEnabled = null,
    Object? featureFlags = null,
  }) {
    return _then(
      _$PersonalizationSettingsImpl(
        isEnabled:
            null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        privacyLevel:
            null == privacyLevel
                ? _value.privacyLevel
                : privacyLevel // ignore: cast_nullable_to_non_nullable
                    as PrivacyLevel,
        analyticsEnabled:
            null == analyticsEnabled
                ? _value.analyticsEnabled
                : analyticsEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        locationEnabled:
            null == locationEnabled
                ? _value.locationEnabled
                : locationEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        islamicCalendarEnabled:
            null == islamicCalendarEnabled
                ? _value.islamicCalendarEnabled
                : islamicCalendarEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        featureFlags:
            null == featureFlags
                ? _value._featureFlags
                : featureFlags // ignore: cast_nullable_to_non_nullable
                    as Map<String, bool>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalizationSettingsImpl implements _PersonalizationSettings {
  const _$PersonalizationSettingsImpl({
    required this.isEnabled,
    required this.privacyLevel,
    required this.analyticsEnabled,
    required this.locationEnabled,
    required this.islamicCalendarEnabled,
    final Map<String, bool> featureFlags = const {},
  }) : _featureFlags = featureFlags;

  factory _$PersonalizationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalizationSettingsImplFromJson(json);

  @override
  final bool isEnabled;
  @override
  final PrivacyLevel privacyLevel;
  @override
  final bool analyticsEnabled;
  @override
  final bool locationEnabled;
  @override
  final bool islamicCalendarEnabled;
  final Map<String, bool> _featureFlags;
  @override
  @JsonKey()
  Map<String, bool> get featureFlags {
    if (_featureFlags is EqualUnmodifiableMapView) return _featureFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_featureFlags);
  }

  @override
  String toString() {
    return 'PersonalizationSettings(isEnabled: $isEnabled, privacyLevel: $privacyLevel, analyticsEnabled: $analyticsEnabled, locationEnabled: $locationEnabled, islamicCalendarEnabled: $islamicCalendarEnabled, featureFlags: $featureFlags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalizationSettingsImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.privacyLevel, privacyLevel) ||
                other.privacyLevel == privacyLevel) &&
            (identical(other.analyticsEnabled, analyticsEnabled) ||
                other.analyticsEnabled == analyticsEnabled) &&
            (identical(other.locationEnabled, locationEnabled) ||
                other.locationEnabled == locationEnabled) &&
            (identical(other.islamicCalendarEnabled, islamicCalendarEnabled) ||
                other.islamicCalendarEnabled == islamicCalendarEnabled) &&
            const DeepCollectionEquality().equals(
              other._featureFlags,
              _featureFlags,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isEnabled,
    privacyLevel,
    analyticsEnabled,
    locationEnabled,
    islamicCalendarEnabled,
    const DeepCollectionEquality().hash(_featureFlags),
  );

  /// Create a copy of PersonalizationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalizationSettingsImplCopyWith<_$PersonalizationSettingsImpl>
  get copyWith => __$$PersonalizationSettingsImplCopyWithImpl<
    _$PersonalizationSettingsImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalizationSettingsImplToJson(this);
  }
}

abstract class _PersonalizationSettings implements PersonalizationSettings {
  const factory _PersonalizationSettings({
    required final bool isEnabled,
    required final PrivacyLevel privacyLevel,
    required final bool analyticsEnabled,
    required final bool locationEnabled,
    required final bool islamicCalendarEnabled,
    final Map<String, bool> featureFlags,
  }) = _$PersonalizationSettingsImpl;

  factory _PersonalizationSettings.fromJson(Map<String, dynamic> json) =
      _$PersonalizationSettingsImpl.fromJson;

  @override
  bool get isEnabled;
  @override
  PrivacyLevel get privacyLevel;
  @override
  bool get analyticsEnabled;
  @override
  bool get locationEnabled;
  @override
  bool get islamicCalendarEnabled;
  @override
  Map<String, bool> get featureFlags;

  /// Create a copy of PersonalizationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalizationSettingsImplCopyWith<_$PersonalizationSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
