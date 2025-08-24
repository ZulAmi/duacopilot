// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_dua_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SmartDuaCollection _$SmartDuaCollectionFromJson(Map<String, dynamic> json) {
  return _SmartDuaCollection.fromJson(json);
}

/// @nodoc
mixin _$SmartDuaCollection {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get duaIds => throw _privateConstructorUsedError;
  EmotionalState get primaryEmotion => throw _privateConstructorUsedError;
  List<EmotionalState> get secondaryEmotions =>
      throw _privateConstructorUsedError;
  DuaContext get context => throw _privateConstructorUsedError;
  List<String> get triggers => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  AIConfidenceLevel get confidenceLevel => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;
  Map<String, dynamic> get aiMetadata => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;
  double get effectivenessScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastUsedAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isPersonalized => throw _privateConstructorUsedError;

  /// Serializes this SmartDuaCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartDuaCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartDuaCollectionCopyWith<SmartDuaCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartDuaCollectionCopyWith<$Res> {
  factory $SmartDuaCollectionCopyWith(
    SmartDuaCollection value,
    $Res Function(SmartDuaCollection) then,
  ) = _$SmartDuaCollectionCopyWithImpl<$Res, SmartDuaCollection>;
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String description,
    List<String> duaIds,
    EmotionalState primaryEmotion,
    List<EmotionalState> secondaryEmotions,
    DuaContext context,
    List<String> triggers,
    List<String> keywords,
    AIConfidenceLevel confidenceLevel,
    double relevanceScore,
    Map<String, dynamic> aiMetadata,
    int usageCount,
    double effectivenessScore,
    DateTime createdAt,
    DateTime lastUsedAt,
    DateTime? updatedAt,
    bool isActive,
    bool isPersonalized,
  });
}

/// @nodoc
class _$SmartDuaCollectionCopyWithImpl<$Res, $Val extends SmartDuaCollection>
    implements $SmartDuaCollectionCopyWith<$Res> {
  _$SmartDuaCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartDuaCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = null,
    Object? duaIds = null,
    Object? primaryEmotion = null,
    Object? secondaryEmotions = null,
    Object? context = null,
    Object? triggers = null,
    Object? keywords = null,
    Object? confidenceLevel = null,
    Object? relevanceScore = null,
    Object? aiMetadata = null,
    Object? usageCount = null,
    Object? effectivenessScore = null,
    Object? createdAt = null,
    Object? lastUsedAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? isPersonalized = null,
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
            duaIds:
                null == duaIds
                    ? _value.duaIds
                    : duaIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            primaryEmotion:
                null == primaryEmotion
                    ? _value.primaryEmotion
                    : primaryEmotion // ignore: cast_nullable_to_non_nullable
                        as EmotionalState,
            secondaryEmotions:
                null == secondaryEmotions
                    ? _value.secondaryEmotions
                    : secondaryEmotions // ignore: cast_nullable_to_non_nullable
                        as List<EmotionalState>,
            context:
                null == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as DuaContext,
            triggers:
                null == triggers
                    ? _value.triggers
                    : triggers // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            keywords:
                null == keywords
                    ? _value.keywords
                    : keywords // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            confidenceLevel:
                null == confidenceLevel
                    ? _value.confidenceLevel
                    : confidenceLevel // ignore: cast_nullable_to_non_nullable
                        as AIConfidenceLevel,
            relevanceScore:
                null == relevanceScore
                    ? _value.relevanceScore
                    : relevanceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            aiMetadata:
                null == aiMetadata
                    ? _value.aiMetadata
                    : aiMetadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            usageCount:
                null == usageCount
                    ? _value.usageCount
                    : usageCount // ignore: cast_nullable_to_non_nullable
                        as int,
            effectivenessScore:
                null == effectivenessScore
                    ? _value.effectivenessScore
                    : effectivenessScore // ignore: cast_nullable_to_non_nullable
                        as double,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastUsedAt:
                null == lastUsedAt
                    ? _value.lastUsedAt
                    : lastUsedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isPersonalized:
                null == isPersonalized
                    ? _value.isPersonalized
                    : isPersonalized // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SmartDuaCollectionImplCopyWith<$Res>
    implements $SmartDuaCollectionCopyWith<$Res> {
  factory _$$SmartDuaCollectionImplCopyWith(
    _$SmartDuaCollectionImpl value,
    $Res Function(_$SmartDuaCollectionImpl) then,
  ) = __$$SmartDuaCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String description,
    List<String> duaIds,
    EmotionalState primaryEmotion,
    List<EmotionalState> secondaryEmotions,
    DuaContext context,
    List<String> triggers,
    List<String> keywords,
    AIConfidenceLevel confidenceLevel,
    double relevanceScore,
    Map<String, dynamic> aiMetadata,
    int usageCount,
    double effectivenessScore,
    DateTime createdAt,
    DateTime lastUsedAt,
    DateTime? updatedAt,
    bool isActive,
    bool isPersonalized,
  });
}

/// @nodoc
class __$$SmartDuaCollectionImplCopyWithImpl<$Res>
    extends _$SmartDuaCollectionCopyWithImpl<$Res, _$SmartDuaCollectionImpl>
    implements _$$SmartDuaCollectionImplCopyWith<$Res> {
  __$$SmartDuaCollectionImplCopyWithImpl(
    _$SmartDuaCollectionImpl _value,
    $Res Function(_$SmartDuaCollectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmartDuaCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = null,
    Object? duaIds = null,
    Object? primaryEmotion = null,
    Object? secondaryEmotions = null,
    Object? context = null,
    Object? triggers = null,
    Object? keywords = null,
    Object? confidenceLevel = null,
    Object? relevanceScore = null,
    Object? aiMetadata = null,
    Object? usageCount = null,
    Object? effectivenessScore = null,
    Object? createdAt = null,
    Object? lastUsedAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? isPersonalized = null,
  }) {
    return _then(
      _$SmartDuaCollectionImpl(
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
        duaIds:
            null == duaIds
                ? _value._duaIds
                : duaIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        primaryEmotion:
            null == primaryEmotion
                ? _value.primaryEmotion
                : primaryEmotion // ignore: cast_nullable_to_non_nullable
                    as EmotionalState,
        secondaryEmotions:
            null == secondaryEmotions
                ? _value._secondaryEmotions
                : secondaryEmotions // ignore: cast_nullable_to_non_nullable
                    as List<EmotionalState>,
        context:
            null == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                    as DuaContext,
        triggers:
            null == triggers
                ? _value._triggers
                : triggers // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        keywords:
            null == keywords
                ? _value._keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        confidenceLevel:
            null == confidenceLevel
                ? _value.confidenceLevel
                : confidenceLevel // ignore: cast_nullable_to_non_nullable
                    as AIConfidenceLevel,
        relevanceScore:
            null == relevanceScore
                ? _value.relevanceScore
                : relevanceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        aiMetadata:
            null == aiMetadata
                ? _value._aiMetadata
                : aiMetadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        usageCount:
            null == usageCount
                ? _value.usageCount
                : usageCount // ignore: cast_nullable_to_non_nullable
                    as int,
        effectivenessScore:
            null == effectivenessScore
                ? _value.effectivenessScore
                : effectivenessScore // ignore: cast_nullable_to_non_nullable
                    as double,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastUsedAt:
            null == lastUsedAt
                ? _value.lastUsedAt
                : lastUsedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isPersonalized:
            null == isPersonalized
                ? _value.isPersonalized
                : isPersonalized // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartDuaCollectionImpl implements _SmartDuaCollection {
  const _$SmartDuaCollectionImpl({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required final List<String> duaIds,
    required this.primaryEmotion,
    required final List<EmotionalState> secondaryEmotions,
    required this.context,
    required final List<String> triggers,
    required final List<String> keywords,
    required this.confidenceLevel,
    required this.relevanceScore,
    required final Map<String, dynamic> aiMetadata,
    required this.usageCount,
    required this.effectivenessScore,
    required this.createdAt,
    required this.lastUsedAt,
    this.updatedAt,
    this.isActive = true,
    this.isPersonalized = true,
  }) : _duaIds = duaIds,
       _secondaryEmotions = secondaryEmotions,
       _triggers = triggers,
       _keywords = keywords,
       _aiMetadata = aiMetadata;

  factory _$SmartDuaCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartDuaCollectionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String description;
  final List<String> _duaIds;
  @override
  List<String> get duaIds {
    if (_duaIds is EqualUnmodifiableListView) return _duaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_duaIds);
  }

  @override
  final EmotionalState primaryEmotion;
  final List<EmotionalState> _secondaryEmotions;
  @override
  List<EmotionalState> get secondaryEmotions {
    if (_secondaryEmotions is EqualUnmodifiableListView)
      return _secondaryEmotions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryEmotions);
  }

  @override
  final DuaContext context;
  final List<String> _triggers;
  @override
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  final AIConfidenceLevel confidenceLevel;
  @override
  final double relevanceScore;
  final Map<String, dynamic> _aiMetadata;
  @override
  Map<String, dynamic> get aiMetadata {
    if (_aiMetadata is EqualUnmodifiableMapView) return _aiMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_aiMetadata);
  }

  @override
  final int usageCount;
  @override
  final double effectivenessScore;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastUsedAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isPersonalized;

  @override
  String toString() {
    return 'SmartDuaCollection(id: $id, userId: $userId, name: $name, description: $description, duaIds: $duaIds, primaryEmotion: $primaryEmotion, secondaryEmotions: $secondaryEmotions, context: $context, triggers: $triggers, keywords: $keywords, confidenceLevel: $confidenceLevel, relevanceScore: $relevanceScore, aiMetadata: $aiMetadata, usageCount: $usageCount, effectivenessScore: $effectivenessScore, createdAt: $createdAt, lastUsedAt: $lastUsedAt, updatedAt: $updatedAt, isActive: $isActive, isPersonalized: $isPersonalized)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartDuaCollectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._duaIds, _duaIds) &&
            (identical(other.primaryEmotion, primaryEmotion) ||
                other.primaryEmotion == primaryEmotion) &&
            const DeepCollectionEquality().equals(
              other._secondaryEmotions,
              _secondaryEmotions,
            ) &&
            (identical(other.context, context) || other.context == context) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.confidenceLevel, confidenceLevel) ||
                other.confidenceLevel == confidenceLevel) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            const DeepCollectionEquality().equals(
              other._aiMetadata,
              _aiMetadata,
            ) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.effectivenessScore, effectivenessScore) ||
                other.effectivenessScore == effectivenessScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPersonalized, isPersonalized) ||
                other.isPersonalized == isPersonalized));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    name,
    description,
    const DeepCollectionEquality().hash(_duaIds),
    primaryEmotion,
    const DeepCollectionEquality().hash(_secondaryEmotions),
    context,
    const DeepCollectionEquality().hash(_triggers),
    const DeepCollectionEquality().hash(_keywords),
    confidenceLevel,
    relevanceScore,
    const DeepCollectionEquality().hash(_aiMetadata),
    usageCount,
    effectivenessScore,
    createdAt,
    lastUsedAt,
    updatedAt,
    isActive,
    isPersonalized,
  ]);

  /// Create a copy of SmartDuaCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartDuaCollectionImplCopyWith<_$SmartDuaCollectionImpl> get copyWith =>
      __$$SmartDuaCollectionImplCopyWithImpl<_$SmartDuaCollectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartDuaCollectionImplToJson(this);
  }
}

abstract class _SmartDuaCollection implements SmartDuaCollection {
  const factory _SmartDuaCollection({
    required final String id,
    required final String userId,
    required final String name,
    required final String description,
    required final List<String> duaIds,
    required final EmotionalState primaryEmotion,
    required final List<EmotionalState> secondaryEmotions,
    required final DuaContext context,
    required final List<String> triggers,
    required final List<String> keywords,
    required final AIConfidenceLevel confidenceLevel,
    required final double relevanceScore,
    required final Map<String, dynamic> aiMetadata,
    required final int usageCount,
    required final double effectivenessScore,
    required final DateTime createdAt,
    required final DateTime lastUsedAt,
    final DateTime? updatedAt,
    final bool isActive,
    final bool isPersonalized,
  }) = _$SmartDuaCollectionImpl;

  factory _SmartDuaCollection.fromJson(Map<String, dynamic> json) =
      _$SmartDuaCollectionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get duaIds;
  @override
  EmotionalState get primaryEmotion;
  @override
  List<EmotionalState> get secondaryEmotions;
  @override
  DuaContext get context;
  @override
  List<String> get triggers;
  @override
  List<String> get keywords;
  @override
  AIConfidenceLevel get confidenceLevel;
  @override
  double get relevanceScore;
  @override
  Map<String, dynamic> get aiMetadata;
  @override
  int get usageCount;
  @override
  double get effectivenessScore;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastUsedAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isActive;
  @override
  bool get isPersonalized;

  /// Create a copy of SmartDuaCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartDuaCollectionImplCopyWith<_$SmartDuaCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmotionalPattern _$EmotionalPatternFromJson(Map<String, dynamic> json) {
  return _EmotionalPattern.fromJson(json);
}

/// @nodoc
mixin _$EmotionalPattern {
  String get userId => throw _privateConstructorUsedError;
  EmotionalState get dominantEmotion => throw _privateConstructorUsedError;
  Map<EmotionalState, double> get emotionFrequency =>
      throw _privateConstructorUsedError;
  Map<DuaContext, int> get contextPreferences =>
      throw _privateConstructorUsedError;
  List<String> get frequentTriggers => throw _privateConstructorUsedError;
  Map<String, double> get timePatterns => throw _privateConstructorUsedError;
  double get stressLevel => throw _privateConstructorUsedError;
  double get spiritualEngagement => throw _privateConstructorUsedError;
  DateTime get analyzedAt => throw _privateConstructorUsedError;
  DateTime get dataStartDate => throw _privateConstructorUsedError;
  DateTime get dataEndDate => throw _privateConstructorUsedError;
  int get totalInteractions => throw _privateConstructorUsedError;
  double get predictionAccuracy => throw _privateConstructorUsedError;

  /// Serializes this EmotionalPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmotionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmotionalPatternCopyWith<EmotionalPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmotionalPatternCopyWith<$Res> {
  factory $EmotionalPatternCopyWith(
    EmotionalPattern value,
    $Res Function(EmotionalPattern) then,
  ) = _$EmotionalPatternCopyWithImpl<$Res, EmotionalPattern>;
  @useResult
  $Res call({
    String userId,
    EmotionalState dominantEmotion,
    Map<EmotionalState, double> emotionFrequency,
    Map<DuaContext, int> contextPreferences,
    List<String> frequentTriggers,
    Map<String, double> timePatterns,
    double stressLevel,
    double spiritualEngagement,
    DateTime analyzedAt,
    DateTime dataStartDate,
    DateTime dataEndDate,
    int totalInteractions,
    double predictionAccuracy,
  });
}

/// @nodoc
class _$EmotionalPatternCopyWithImpl<$Res, $Val extends EmotionalPattern>
    implements $EmotionalPatternCopyWith<$Res> {
  _$EmotionalPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmotionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? dominantEmotion = null,
    Object? emotionFrequency = null,
    Object? contextPreferences = null,
    Object? frequentTriggers = null,
    Object? timePatterns = null,
    Object? stressLevel = null,
    Object? spiritualEngagement = null,
    Object? analyzedAt = null,
    Object? dataStartDate = null,
    Object? dataEndDate = null,
    Object? totalInteractions = null,
    Object? predictionAccuracy = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            dominantEmotion:
                null == dominantEmotion
                    ? _value.dominantEmotion
                    : dominantEmotion // ignore: cast_nullable_to_non_nullable
                        as EmotionalState,
            emotionFrequency:
                null == emotionFrequency
                    ? _value.emotionFrequency
                    : emotionFrequency // ignore: cast_nullable_to_non_nullable
                        as Map<EmotionalState, double>,
            contextPreferences:
                null == contextPreferences
                    ? _value.contextPreferences
                    : contextPreferences // ignore: cast_nullable_to_non_nullable
                        as Map<DuaContext, int>,
            frequentTriggers:
                null == frequentTriggers
                    ? _value.frequentTriggers
                    : frequentTriggers // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            timePatterns:
                null == timePatterns
                    ? _value.timePatterns
                    : timePatterns // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
            stressLevel:
                null == stressLevel
                    ? _value.stressLevel
                    : stressLevel // ignore: cast_nullable_to_non_nullable
                        as double,
            spiritualEngagement:
                null == spiritualEngagement
                    ? _value.spiritualEngagement
                    : spiritualEngagement // ignore: cast_nullable_to_non_nullable
                        as double,
            analyzedAt:
                null == analyzedAt
                    ? _value.analyzedAt
                    : analyzedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            dataStartDate:
                null == dataStartDate
                    ? _value.dataStartDate
                    : dataStartDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            dataEndDate:
                null == dataEndDate
                    ? _value.dataEndDate
                    : dataEndDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            totalInteractions:
                null == totalInteractions
                    ? _value.totalInteractions
                    : totalInteractions // ignore: cast_nullable_to_non_nullable
                        as int,
            predictionAccuracy:
                null == predictionAccuracy
                    ? _value.predictionAccuracy
                    : predictionAccuracy // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmotionalPatternImplCopyWith<$Res>
    implements $EmotionalPatternCopyWith<$Res> {
  factory _$$EmotionalPatternImplCopyWith(
    _$EmotionalPatternImpl value,
    $Res Function(_$EmotionalPatternImpl) then,
  ) = __$$EmotionalPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    EmotionalState dominantEmotion,
    Map<EmotionalState, double> emotionFrequency,
    Map<DuaContext, int> contextPreferences,
    List<String> frequentTriggers,
    Map<String, double> timePatterns,
    double stressLevel,
    double spiritualEngagement,
    DateTime analyzedAt,
    DateTime dataStartDate,
    DateTime dataEndDate,
    int totalInteractions,
    double predictionAccuracy,
  });
}

/// @nodoc
class __$$EmotionalPatternImplCopyWithImpl<$Res>
    extends _$EmotionalPatternCopyWithImpl<$Res, _$EmotionalPatternImpl>
    implements _$$EmotionalPatternImplCopyWith<$Res> {
  __$$EmotionalPatternImplCopyWithImpl(
    _$EmotionalPatternImpl _value,
    $Res Function(_$EmotionalPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmotionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? dominantEmotion = null,
    Object? emotionFrequency = null,
    Object? contextPreferences = null,
    Object? frequentTriggers = null,
    Object? timePatterns = null,
    Object? stressLevel = null,
    Object? spiritualEngagement = null,
    Object? analyzedAt = null,
    Object? dataStartDate = null,
    Object? dataEndDate = null,
    Object? totalInteractions = null,
    Object? predictionAccuracy = null,
  }) {
    return _then(
      _$EmotionalPatternImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        dominantEmotion:
            null == dominantEmotion
                ? _value.dominantEmotion
                : dominantEmotion // ignore: cast_nullable_to_non_nullable
                    as EmotionalState,
        emotionFrequency:
            null == emotionFrequency
                ? _value._emotionFrequency
                : emotionFrequency // ignore: cast_nullable_to_non_nullable
                    as Map<EmotionalState, double>,
        contextPreferences:
            null == contextPreferences
                ? _value._contextPreferences
                : contextPreferences // ignore: cast_nullable_to_non_nullable
                    as Map<DuaContext, int>,
        frequentTriggers:
            null == frequentTriggers
                ? _value._frequentTriggers
                : frequentTriggers // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        timePatterns:
            null == timePatterns
                ? _value._timePatterns
                : timePatterns // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
        stressLevel:
            null == stressLevel
                ? _value.stressLevel
                : stressLevel // ignore: cast_nullable_to_non_nullable
                    as double,
        spiritualEngagement:
            null == spiritualEngagement
                ? _value.spiritualEngagement
                : spiritualEngagement // ignore: cast_nullable_to_non_nullable
                    as double,
        analyzedAt:
            null == analyzedAt
                ? _value.analyzedAt
                : analyzedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        dataStartDate:
            null == dataStartDate
                ? _value.dataStartDate
                : dataStartDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        dataEndDate:
            null == dataEndDate
                ? _value.dataEndDate
                : dataEndDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        totalInteractions:
            null == totalInteractions
                ? _value.totalInteractions
                : totalInteractions // ignore: cast_nullable_to_non_nullable
                    as int,
        predictionAccuracy:
            null == predictionAccuracy
                ? _value.predictionAccuracy
                : predictionAccuracy // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmotionalPatternImpl implements _EmotionalPattern {
  const _$EmotionalPatternImpl({
    required this.userId,
    required this.dominantEmotion,
    required final Map<EmotionalState, double> emotionFrequency,
    required final Map<DuaContext, int> contextPreferences,
    required final List<String> frequentTriggers,
    required final Map<String, double> timePatterns,
    required this.stressLevel,
    required this.spiritualEngagement,
    required this.analyzedAt,
    required this.dataStartDate,
    required this.dataEndDate,
    this.totalInteractions = 0,
    this.predictionAccuracy = 0.0,
  }) : _emotionFrequency = emotionFrequency,
       _contextPreferences = contextPreferences,
       _frequentTriggers = frequentTriggers,
       _timePatterns = timePatterns;

  factory _$EmotionalPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmotionalPatternImplFromJson(json);

  @override
  final String userId;
  @override
  final EmotionalState dominantEmotion;
  final Map<EmotionalState, double> _emotionFrequency;
  @override
  Map<EmotionalState, double> get emotionFrequency {
    if (_emotionFrequency is EqualUnmodifiableMapView) return _emotionFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_emotionFrequency);
  }

  final Map<DuaContext, int> _contextPreferences;
  @override
  Map<DuaContext, int> get contextPreferences {
    if (_contextPreferences is EqualUnmodifiableMapView)
      return _contextPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contextPreferences);
  }

  final List<String> _frequentTriggers;
  @override
  List<String> get frequentTriggers {
    if (_frequentTriggers is EqualUnmodifiableListView)
      return _frequentTriggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frequentTriggers);
  }

  final Map<String, double> _timePatterns;
  @override
  Map<String, double> get timePatterns {
    if (_timePatterns is EqualUnmodifiableMapView) return _timePatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timePatterns);
  }

  @override
  final double stressLevel;
  @override
  final double spiritualEngagement;
  @override
  final DateTime analyzedAt;
  @override
  final DateTime dataStartDate;
  @override
  final DateTime dataEndDate;
  @override
  @JsonKey()
  final int totalInteractions;
  @override
  @JsonKey()
  final double predictionAccuracy;

  @override
  String toString() {
    return 'EmotionalPattern(userId: $userId, dominantEmotion: $dominantEmotion, emotionFrequency: $emotionFrequency, contextPreferences: $contextPreferences, frequentTriggers: $frequentTriggers, timePatterns: $timePatterns, stressLevel: $stressLevel, spiritualEngagement: $spiritualEngagement, analyzedAt: $analyzedAt, dataStartDate: $dataStartDate, dataEndDate: $dataEndDate, totalInteractions: $totalInteractions, predictionAccuracy: $predictionAccuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmotionalPatternImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.dominantEmotion, dominantEmotion) ||
                other.dominantEmotion == dominantEmotion) &&
            const DeepCollectionEquality().equals(
              other._emotionFrequency,
              _emotionFrequency,
            ) &&
            const DeepCollectionEquality().equals(
              other._contextPreferences,
              _contextPreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._frequentTriggers,
              _frequentTriggers,
            ) &&
            const DeepCollectionEquality().equals(
              other._timePatterns,
              _timePatterns,
            ) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            (identical(other.spiritualEngagement, spiritualEngagement) ||
                other.spiritualEngagement == spiritualEngagement) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt) &&
            (identical(other.dataStartDate, dataStartDate) ||
                other.dataStartDate == dataStartDate) &&
            (identical(other.dataEndDate, dataEndDate) ||
                other.dataEndDate == dataEndDate) &&
            (identical(other.totalInteractions, totalInteractions) ||
                other.totalInteractions == totalInteractions) &&
            (identical(other.predictionAccuracy, predictionAccuracy) ||
                other.predictionAccuracy == predictionAccuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    dominantEmotion,
    const DeepCollectionEquality().hash(_emotionFrequency),
    const DeepCollectionEquality().hash(_contextPreferences),
    const DeepCollectionEquality().hash(_frequentTriggers),
    const DeepCollectionEquality().hash(_timePatterns),
    stressLevel,
    spiritualEngagement,
    analyzedAt,
    dataStartDate,
    dataEndDate,
    totalInteractions,
    predictionAccuracy,
  );

  /// Create a copy of EmotionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmotionalPatternImplCopyWith<_$EmotionalPatternImpl> get copyWith =>
      __$$EmotionalPatternImplCopyWithImpl<_$EmotionalPatternImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmotionalPatternImplToJson(this);
  }
}

abstract class _EmotionalPattern implements EmotionalPattern {
  const factory _EmotionalPattern({
    required final String userId,
    required final EmotionalState dominantEmotion,
    required final Map<EmotionalState, double> emotionFrequency,
    required final Map<DuaContext, int> contextPreferences,
    required final List<String> frequentTriggers,
    required final Map<String, double> timePatterns,
    required final double stressLevel,
    required final double spiritualEngagement,
    required final DateTime analyzedAt,
    required final DateTime dataStartDate,
    required final DateTime dataEndDate,
    final int totalInteractions,
    final double predictionAccuracy,
  }) = _$EmotionalPatternImpl;

  factory _EmotionalPattern.fromJson(Map<String, dynamic> json) =
      _$EmotionalPatternImpl.fromJson;

  @override
  String get userId;
  @override
  EmotionalState get dominantEmotion;
  @override
  Map<EmotionalState, double> get emotionFrequency;
  @override
  Map<DuaContext, int> get contextPreferences;
  @override
  List<String> get frequentTriggers;
  @override
  Map<String, double> get timePatterns;
  @override
  double get stressLevel;
  @override
  double get spiritualEngagement;
  @override
  DateTime get analyzedAt;
  @override
  DateTime get dataStartDate;
  @override
  DateTime get dataEndDate;
  @override
  int get totalInteractions;
  @override
  double get predictionAccuracy;

  /// Create a copy of EmotionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmotionalPatternImplCopyWith<_$EmotionalPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmartDuaRecommendation _$SmartDuaRecommendationFromJson(
  Map<String, dynamic> json,
) {
  return _SmartDuaRecommendation.fromJson(json);
}

/// @nodoc
mixin _$SmartDuaRecommendation {
  String get id => throw _privateConstructorUsedError;
  String get duaId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get arabicTitle => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  EmotionalState get targetEmotion => throw _privateConstructorUsedError;
  DuaContext get context => throw _privateConstructorUsedError;
  List<String> get matchedKeywords => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;
  AIConfidenceLevel get confidence => throw _privateConstructorUsedError;
  Map<String, dynamic> get aiReasoningData =>
      throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  DateTime? get dismissedAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  bool get isPersonalized => throw _privateConstructorUsedError;
  bool get wasAccurate => throw _privateConstructorUsedError;
  String? get userFeedback => throw _privateConstructorUsedError;

  /// Serializes this SmartDuaRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartDuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartDuaRecommendationCopyWith<SmartDuaRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartDuaRecommendationCopyWith<$Res> {
  factory $SmartDuaRecommendationCopyWith(
    SmartDuaRecommendation value,
    $Res Function(SmartDuaRecommendation) then,
  ) = _$SmartDuaRecommendationCopyWithImpl<$Res, SmartDuaRecommendation>;
  @useResult
  $Res call({
    String id,
    String duaId,
    String userId,
    String title,
    String arabicTitle,
    String reason,
    EmotionalState targetEmotion,
    DuaContext context,
    List<String> matchedKeywords,
    double relevanceScore,
    AIConfidenceLevel confidence,
    Map<String, dynamic> aiReasoningData,
    DateTime generatedAt,
    DateTime? dismissedAt,
    DateTime? acceptedAt,
    bool isPersonalized,
    bool wasAccurate,
    String? userFeedback,
  });
}

/// @nodoc
class _$SmartDuaRecommendationCopyWithImpl<
  $Res,
  $Val extends SmartDuaRecommendation
>
    implements $SmartDuaRecommendationCopyWith<$Res> {
  _$SmartDuaRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartDuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? userId = null,
    Object? title = null,
    Object? arabicTitle = null,
    Object? reason = null,
    Object? targetEmotion = null,
    Object? context = null,
    Object? matchedKeywords = null,
    Object? relevanceScore = null,
    Object? confidence = null,
    Object? aiReasoningData = null,
    Object? generatedAt = null,
    Object? dismissedAt = freezed,
    Object? acceptedAt = freezed,
    Object? isPersonalized = null,
    Object? wasAccurate = null,
    Object? userFeedback = freezed,
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
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            arabicTitle:
                null == arabicTitle
                    ? _value.arabicTitle
                    : arabicTitle // ignore: cast_nullable_to_non_nullable
                        as String,
            reason:
                null == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String,
            targetEmotion:
                null == targetEmotion
                    ? _value.targetEmotion
                    : targetEmotion // ignore: cast_nullable_to_non_nullable
                        as EmotionalState,
            context:
                null == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as DuaContext,
            matchedKeywords:
                null == matchedKeywords
                    ? _value.matchedKeywords
                    : matchedKeywords // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            relevanceScore:
                null == relevanceScore
                    ? _value.relevanceScore
                    : relevanceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as AIConfidenceLevel,
            aiReasoningData:
                null == aiReasoningData
                    ? _value.aiReasoningData
                    : aiReasoningData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            generatedAt:
                null == generatedAt
                    ? _value.generatedAt
                    : generatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            dismissedAt:
                freezed == dismissedAt
                    ? _value.dismissedAt
                    : dismissedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            acceptedAt:
                freezed == acceptedAt
                    ? _value.acceptedAt
                    : acceptedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isPersonalized:
                null == isPersonalized
                    ? _value.isPersonalized
                    : isPersonalized // ignore: cast_nullable_to_non_nullable
                        as bool,
            wasAccurate:
                null == wasAccurate
                    ? _value.wasAccurate
                    : wasAccurate // ignore: cast_nullable_to_non_nullable
                        as bool,
            userFeedback:
                freezed == userFeedback
                    ? _value.userFeedback
                    : userFeedback // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SmartDuaRecommendationImplCopyWith<$Res>
    implements $SmartDuaRecommendationCopyWith<$Res> {
  factory _$$SmartDuaRecommendationImplCopyWith(
    _$SmartDuaRecommendationImpl value,
    $Res Function(_$SmartDuaRecommendationImpl) then,
  ) = __$$SmartDuaRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String duaId,
    String userId,
    String title,
    String arabicTitle,
    String reason,
    EmotionalState targetEmotion,
    DuaContext context,
    List<String> matchedKeywords,
    double relevanceScore,
    AIConfidenceLevel confidence,
    Map<String, dynamic> aiReasoningData,
    DateTime generatedAt,
    DateTime? dismissedAt,
    DateTime? acceptedAt,
    bool isPersonalized,
    bool wasAccurate,
    String? userFeedback,
  });
}

/// @nodoc
class __$$SmartDuaRecommendationImplCopyWithImpl<$Res>
    extends
        _$SmartDuaRecommendationCopyWithImpl<$Res, _$SmartDuaRecommendationImpl>
    implements _$$SmartDuaRecommendationImplCopyWith<$Res> {
  __$$SmartDuaRecommendationImplCopyWithImpl(
    _$SmartDuaRecommendationImpl _value,
    $Res Function(_$SmartDuaRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmartDuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? userId = null,
    Object? title = null,
    Object? arabicTitle = null,
    Object? reason = null,
    Object? targetEmotion = null,
    Object? context = null,
    Object? matchedKeywords = null,
    Object? relevanceScore = null,
    Object? confidence = null,
    Object? aiReasoningData = null,
    Object? generatedAt = null,
    Object? dismissedAt = freezed,
    Object? acceptedAt = freezed,
    Object? isPersonalized = null,
    Object? wasAccurate = null,
    Object? userFeedback = freezed,
  }) {
    return _then(
      _$SmartDuaRecommendationImpl(
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
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        arabicTitle:
            null == arabicTitle
                ? _value.arabicTitle
                : arabicTitle // ignore: cast_nullable_to_non_nullable
                    as String,
        reason:
            null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String,
        targetEmotion:
            null == targetEmotion
                ? _value.targetEmotion
                : targetEmotion // ignore: cast_nullable_to_non_nullable
                    as EmotionalState,
        context:
            null == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                    as DuaContext,
        matchedKeywords:
            null == matchedKeywords
                ? _value._matchedKeywords
                : matchedKeywords // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        relevanceScore:
            null == relevanceScore
                ? _value.relevanceScore
                : relevanceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as AIConfidenceLevel,
        aiReasoningData:
            null == aiReasoningData
                ? _value._aiReasoningData
                : aiReasoningData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        generatedAt:
            null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        dismissedAt:
            freezed == dismissedAt
                ? _value.dismissedAt
                : dismissedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        acceptedAt:
            freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isPersonalized:
            null == isPersonalized
                ? _value.isPersonalized
                : isPersonalized // ignore: cast_nullable_to_non_nullable
                    as bool,
        wasAccurate:
            null == wasAccurate
                ? _value.wasAccurate
                : wasAccurate // ignore: cast_nullable_to_non_nullable
                    as bool,
        userFeedback:
            freezed == userFeedback
                ? _value.userFeedback
                : userFeedback // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartDuaRecommendationImpl implements _SmartDuaRecommendation {
  const _$SmartDuaRecommendationImpl({
    required this.id,
    required this.duaId,
    required this.userId,
    required this.title,
    required this.arabicTitle,
    required this.reason,
    required this.targetEmotion,
    required this.context,
    required final List<String> matchedKeywords,
    required this.relevanceScore,
    required this.confidence,
    required final Map<String, dynamic> aiReasoningData,
    required this.generatedAt,
    this.dismissedAt,
    this.acceptedAt,
    this.isPersonalized = true,
    this.wasAccurate = false,
    this.userFeedback,
  }) : _matchedKeywords = matchedKeywords,
       _aiReasoningData = aiReasoningData;

  factory _$SmartDuaRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartDuaRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  final String duaId;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String arabicTitle;
  @override
  final String reason;
  @override
  final EmotionalState targetEmotion;
  @override
  final DuaContext context;
  final List<String> _matchedKeywords;
  @override
  List<String> get matchedKeywords {
    if (_matchedKeywords is EqualUnmodifiableListView) return _matchedKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchedKeywords);
  }

  @override
  final double relevanceScore;
  @override
  final AIConfidenceLevel confidence;
  final Map<String, dynamic> _aiReasoningData;
  @override
  Map<String, dynamic> get aiReasoningData {
    if (_aiReasoningData is EqualUnmodifiableMapView) return _aiReasoningData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_aiReasoningData);
  }

  @override
  final DateTime generatedAt;
  @override
  final DateTime? dismissedAt;
  @override
  final DateTime? acceptedAt;
  @override
  @JsonKey()
  final bool isPersonalized;
  @override
  @JsonKey()
  final bool wasAccurate;
  @override
  final String? userFeedback;

  @override
  String toString() {
    return 'SmartDuaRecommendation(id: $id, duaId: $duaId, userId: $userId, title: $title, arabicTitle: $arabicTitle, reason: $reason, targetEmotion: $targetEmotion, context: $context, matchedKeywords: $matchedKeywords, relevanceScore: $relevanceScore, confidence: $confidence, aiReasoningData: $aiReasoningData, generatedAt: $generatedAt, dismissedAt: $dismissedAt, acceptedAt: $acceptedAt, isPersonalized: $isPersonalized, wasAccurate: $wasAccurate, userFeedback: $userFeedback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartDuaRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.arabicTitle, arabicTitle) ||
                other.arabicTitle == arabicTitle) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.targetEmotion, targetEmotion) ||
                other.targetEmotion == targetEmotion) &&
            (identical(other.context, context) || other.context == context) &&
            const DeepCollectionEquality().equals(
              other._matchedKeywords,
              _matchedKeywords,
            ) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(
              other._aiReasoningData,
              _aiReasoningData,
            ) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.dismissedAt, dismissedAt) ||
                other.dismissedAt == dismissedAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.isPersonalized, isPersonalized) ||
                other.isPersonalized == isPersonalized) &&
            (identical(other.wasAccurate, wasAccurate) ||
                other.wasAccurate == wasAccurate) &&
            (identical(other.userFeedback, userFeedback) ||
                other.userFeedback == userFeedback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    duaId,
    userId,
    title,
    arabicTitle,
    reason,
    targetEmotion,
    context,
    const DeepCollectionEquality().hash(_matchedKeywords),
    relevanceScore,
    confidence,
    const DeepCollectionEquality().hash(_aiReasoningData),
    generatedAt,
    dismissedAt,
    acceptedAt,
    isPersonalized,
    wasAccurate,
    userFeedback,
  );

  /// Create a copy of SmartDuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartDuaRecommendationImplCopyWith<_$SmartDuaRecommendationImpl>
  get copyWith =>
      __$$SmartDuaRecommendationImplCopyWithImpl<_$SmartDuaRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartDuaRecommendationImplToJson(this);
  }
}

abstract class _SmartDuaRecommendation implements SmartDuaRecommendation {
  const factory _SmartDuaRecommendation({
    required final String id,
    required final String duaId,
    required final String userId,
    required final String title,
    required final String arabicTitle,
    required final String reason,
    required final EmotionalState targetEmotion,
    required final DuaContext context,
    required final List<String> matchedKeywords,
    required final double relevanceScore,
    required final AIConfidenceLevel confidence,
    required final Map<String, dynamic> aiReasoningData,
    required final DateTime generatedAt,
    final DateTime? dismissedAt,
    final DateTime? acceptedAt,
    final bool isPersonalized,
    final bool wasAccurate,
    final String? userFeedback,
  }) = _$SmartDuaRecommendationImpl;

  factory _SmartDuaRecommendation.fromJson(Map<String, dynamic> json) =
      _$SmartDuaRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  String get duaId;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get arabicTitle;
  @override
  String get reason;
  @override
  EmotionalState get targetEmotion;
  @override
  DuaContext get context;
  @override
  List<String> get matchedKeywords;
  @override
  double get relevanceScore;
  @override
  AIConfidenceLevel get confidence;
  @override
  Map<String, dynamic> get aiReasoningData;
  @override
  DateTime get generatedAt;
  @override
  DateTime? get dismissedAt;
  @override
  DateTime? get acceptedAt;
  @override
  bool get isPersonalized;
  @override
  bool get wasAccurate;
  @override
  String? get userFeedback;

  /// Create a copy of SmartDuaRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartDuaRecommendationImplCopyWith<_$SmartDuaRecommendationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ContextualInput _$ContextualInputFromJson(Map<String, dynamic> json) {
  return _ContextualInput.fromJson(json);
}

/// @nodoc
mixin _$ContextualInput {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get rawInput => throw _privateConstructorUsedError;
  List<String> get processedKeywords => throw _privateConstructorUsedError;
  EmotionalState get detectedEmotion => throw _privateConstructorUsedError;
  DuaContext get detectedContext => throw _privateConstructorUsedError;
  double get emotionConfidence => throw _privateConstructorUsedError;
  double get contextConfidence => throw _privateConstructorUsedError;
  Map<String, dynamic> get nlpAnalysis => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isEncrypted => throw _privateConstructorUsedError;
  String? get encryptionKey => throw _privateConstructorUsedError;

  /// Serializes this ContextualInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContextualInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContextualInputCopyWith<ContextualInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextualInputCopyWith<$Res> {
  factory $ContextualInputCopyWith(
    ContextualInput value,
    $Res Function(ContextualInput) then,
  ) = _$ContextualInputCopyWithImpl<$Res, ContextualInput>;
  @useResult
  $Res call({
    String id,
    String userId,
    String rawInput,
    List<String> processedKeywords,
    EmotionalState detectedEmotion,
    DuaContext detectedContext,
    double emotionConfidence,
    double contextConfidence,
    Map<String, dynamic> nlpAnalysis,
    DateTime timestamp,
    bool isEncrypted,
    String? encryptionKey,
  });
}

/// @nodoc
class _$ContextualInputCopyWithImpl<$Res, $Val extends ContextualInput>
    implements $ContextualInputCopyWith<$Res> {
  _$ContextualInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContextualInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? rawInput = null,
    Object? processedKeywords = null,
    Object? detectedEmotion = null,
    Object? detectedContext = null,
    Object? emotionConfidence = null,
    Object? contextConfidence = null,
    Object? nlpAnalysis = null,
    Object? timestamp = null,
    Object? isEncrypted = null,
    Object? encryptionKey = freezed,
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
            rawInput:
                null == rawInput
                    ? _value.rawInput
                    : rawInput // ignore: cast_nullable_to_non_nullable
                        as String,
            processedKeywords:
                null == processedKeywords
                    ? _value.processedKeywords
                    : processedKeywords // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            detectedEmotion:
                null == detectedEmotion
                    ? _value.detectedEmotion
                    : detectedEmotion // ignore: cast_nullable_to_non_nullable
                        as EmotionalState,
            detectedContext:
                null == detectedContext
                    ? _value.detectedContext
                    : detectedContext // ignore: cast_nullable_to_non_nullable
                        as DuaContext,
            emotionConfidence:
                null == emotionConfidence
                    ? _value.emotionConfidence
                    : emotionConfidence // ignore: cast_nullable_to_non_nullable
                        as double,
            contextConfidence:
                null == contextConfidence
                    ? _value.contextConfidence
                    : contextConfidence // ignore: cast_nullable_to_non_nullable
                        as double,
            nlpAnalysis:
                null == nlpAnalysis
                    ? _value.nlpAnalysis
                    : nlpAnalysis // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isEncrypted:
                null == isEncrypted
                    ? _value.isEncrypted
                    : isEncrypted // ignore: cast_nullable_to_non_nullable
                        as bool,
            encryptionKey:
                freezed == encryptionKey
                    ? _value.encryptionKey
                    : encryptionKey // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContextualInputImplCopyWith<$Res>
    implements $ContextualInputCopyWith<$Res> {
  factory _$$ContextualInputImplCopyWith(
    _$ContextualInputImpl value,
    $Res Function(_$ContextualInputImpl) then,
  ) = __$$ContextualInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String rawInput,
    List<String> processedKeywords,
    EmotionalState detectedEmotion,
    DuaContext detectedContext,
    double emotionConfidence,
    double contextConfidence,
    Map<String, dynamic> nlpAnalysis,
    DateTime timestamp,
    bool isEncrypted,
    String? encryptionKey,
  });
}

/// @nodoc
class __$$ContextualInputImplCopyWithImpl<$Res>
    extends _$ContextualInputCopyWithImpl<$Res, _$ContextualInputImpl>
    implements _$$ContextualInputImplCopyWith<$Res> {
  __$$ContextualInputImplCopyWithImpl(
    _$ContextualInputImpl _value,
    $Res Function(_$ContextualInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContextualInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? rawInput = null,
    Object? processedKeywords = null,
    Object? detectedEmotion = null,
    Object? detectedContext = null,
    Object? emotionConfidence = null,
    Object? contextConfidence = null,
    Object? nlpAnalysis = null,
    Object? timestamp = null,
    Object? isEncrypted = null,
    Object? encryptionKey = freezed,
  }) {
    return _then(
      _$ContextualInputImpl(
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
        rawInput:
            null == rawInput
                ? _value.rawInput
                : rawInput // ignore: cast_nullable_to_non_nullable
                    as String,
        processedKeywords:
            null == processedKeywords
                ? _value._processedKeywords
                : processedKeywords // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        detectedEmotion:
            null == detectedEmotion
                ? _value.detectedEmotion
                : detectedEmotion // ignore: cast_nullable_to_non_nullable
                    as EmotionalState,
        detectedContext:
            null == detectedContext
                ? _value.detectedContext
                : detectedContext // ignore: cast_nullable_to_non_nullable
                    as DuaContext,
        emotionConfidence:
            null == emotionConfidence
                ? _value.emotionConfidence
                : emotionConfidence // ignore: cast_nullable_to_non_nullable
                    as double,
        contextConfidence:
            null == contextConfidence
                ? _value.contextConfidence
                : contextConfidence // ignore: cast_nullable_to_non_nullable
                    as double,
        nlpAnalysis:
            null == nlpAnalysis
                ? _value._nlpAnalysis
                : nlpAnalysis // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isEncrypted:
            null == isEncrypted
                ? _value.isEncrypted
                : isEncrypted // ignore: cast_nullable_to_non_nullable
                    as bool,
        encryptionKey:
            freezed == encryptionKey
                ? _value.encryptionKey
                : encryptionKey // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContextualInputImpl implements _ContextualInput {
  const _$ContextualInputImpl({
    required this.id,
    required this.userId,
    required this.rawInput,
    required final List<String> processedKeywords,
    required this.detectedEmotion,
    required this.detectedContext,
    required this.emotionConfidence,
    required this.contextConfidence,
    required final Map<String, dynamic> nlpAnalysis,
    required this.timestamp,
    this.isEncrypted = true,
    this.encryptionKey,
  }) : _processedKeywords = processedKeywords,
       _nlpAnalysis = nlpAnalysis;

  factory _$ContextualInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContextualInputImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String rawInput;
  final List<String> _processedKeywords;
  @override
  List<String> get processedKeywords {
    if (_processedKeywords is EqualUnmodifiableListView)
      return _processedKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_processedKeywords);
  }

  @override
  final EmotionalState detectedEmotion;
  @override
  final DuaContext detectedContext;
  @override
  final double emotionConfidence;
  @override
  final double contextConfidence;
  final Map<String, dynamic> _nlpAnalysis;
  @override
  Map<String, dynamic> get nlpAnalysis {
    if (_nlpAnalysis is EqualUnmodifiableMapView) return _nlpAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nlpAnalysis);
  }

  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isEncrypted;
  @override
  final String? encryptionKey;

  @override
  String toString() {
    return 'ContextualInput(id: $id, userId: $userId, rawInput: $rawInput, processedKeywords: $processedKeywords, detectedEmotion: $detectedEmotion, detectedContext: $detectedContext, emotionConfidence: $emotionConfidence, contextConfidence: $contextConfidence, nlpAnalysis: $nlpAnalysis, timestamp: $timestamp, isEncrypted: $isEncrypted, encryptionKey: $encryptionKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContextualInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.rawInput, rawInput) ||
                other.rawInput == rawInput) &&
            const DeepCollectionEquality().equals(
              other._processedKeywords,
              _processedKeywords,
            ) &&
            (identical(other.detectedEmotion, detectedEmotion) ||
                other.detectedEmotion == detectedEmotion) &&
            (identical(other.detectedContext, detectedContext) ||
                other.detectedContext == detectedContext) &&
            (identical(other.emotionConfidence, emotionConfidence) ||
                other.emotionConfidence == emotionConfidence) &&
            (identical(other.contextConfidence, contextConfidence) ||
                other.contextConfidence == contextConfidence) &&
            const DeepCollectionEquality().equals(
              other._nlpAnalysis,
              _nlpAnalysis,
            ) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isEncrypted, isEncrypted) ||
                other.isEncrypted == isEncrypted) &&
            (identical(other.encryptionKey, encryptionKey) ||
                other.encryptionKey == encryptionKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    rawInput,
    const DeepCollectionEquality().hash(_processedKeywords),
    detectedEmotion,
    detectedContext,
    emotionConfidence,
    contextConfidence,
    const DeepCollectionEquality().hash(_nlpAnalysis),
    timestamp,
    isEncrypted,
    encryptionKey,
  );

  /// Create a copy of ContextualInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextualInputImplCopyWith<_$ContextualInputImpl> get copyWith =>
      __$$ContextualInputImplCopyWithImpl<_$ContextualInputImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContextualInputImplToJson(this);
  }
}

abstract class _ContextualInput implements ContextualInput {
  const factory _ContextualInput({
    required final String id,
    required final String userId,
    required final String rawInput,
    required final List<String> processedKeywords,
    required final EmotionalState detectedEmotion,
    required final DuaContext detectedContext,
    required final double emotionConfidence,
    required final double contextConfidence,
    required final Map<String, dynamic> nlpAnalysis,
    required final DateTime timestamp,
    final bool isEncrypted,
    final String? encryptionKey,
  }) = _$ContextualInputImpl;

  factory _ContextualInput.fromJson(Map<String, dynamic> json) =
      _$ContextualInputImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get rawInput;
  @override
  List<String> get processedKeywords;
  @override
  EmotionalState get detectedEmotion;
  @override
  DuaContext get detectedContext;
  @override
  double get emotionConfidence;
  @override
  double get contextConfidence;
  @override
  Map<String, dynamic> get nlpAnalysis;
  @override
  DateTime get timestamp;
  @override
  bool get isEncrypted;
  @override
  String? get encryptionKey;

  /// Create a copy of ContextualInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContextualInputImplCopyWith<_$ContextualInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIFeedback _$AIFeedbackFromJson(Map<String, dynamic> json) {
  return _AIFeedback.fromJson(json);
}

/// @nodoc
mixin _$AIFeedback {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get recommendationId => throw _privateConstructorUsedError;
  bool get wasHelpful => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get feedbackType => throw _privateConstructorUsedError;
  String? get textFeedback => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;
  DateTime? get providedAt => throw _privateConstructorUsedError;

  /// Serializes this AIFeedback to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIFeedback
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIFeedbackCopyWith<AIFeedback> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIFeedbackCopyWith<$Res> {
  factory $AIFeedbackCopyWith(
    AIFeedback value,
    $Res Function(AIFeedback) then,
  ) = _$AIFeedbackCopyWithImpl<$Res, AIFeedback>;
  @useResult
  $Res call({
    String id,
    String userId,
    String recommendationId,
    bool wasHelpful,
    int rating,
    String feedbackType,
    String? textFeedback,
    Map<String, dynamic>? additionalData,
    DateTime? providedAt,
  });
}

/// @nodoc
class _$AIFeedbackCopyWithImpl<$Res, $Val extends AIFeedback>
    implements $AIFeedbackCopyWith<$Res> {
  _$AIFeedbackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIFeedback
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? recommendationId = null,
    Object? wasHelpful = null,
    Object? rating = null,
    Object? feedbackType = null,
    Object? textFeedback = freezed,
    Object? additionalData = freezed,
    Object? providedAt = freezed,
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
            recommendationId:
                null == recommendationId
                    ? _value.recommendationId
                    : recommendationId // ignore: cast_nullable_to_non_nullable
                        as String,
            wasHelpful:
                null == wasHelpful
                    ? _value.wasHelpful
                    : wasHelpful // ignore: cast_nullable_to_non_nullable
                        as bool,
            rating:
                null == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as int,
            feedbackType:
                null == feedbackType
                    ? _value.feedbackType
                    : feedbackType // ignore: cast_nullable_to_non_nullable
                        as String,
            textFeedback:
                freezed == textFeedback
                    ? _value.textFeedback
                    : textFeedback // ignore: cast_nullable_to_non_nullable
                        as String?,
            additionalData:
                freezed == additionalData
                    ? _value.additionalData
                    : additionalData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            providedAt:
                freezed == providedAt
                    ? _value.providedAt
                    : providedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIFeedbackImplCopyWith<$Res>
    implements $AIFeedbackCopyWith<$Res> {
  factory _$$AIFeedbackImplCopyWith(
    _$AIFeedbackImpl value,
    $Res Function(_$AIFeedbackImpl) then,
  ) = __$$AIFeedbackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String recommendationId,
    bool wasHelpful,
    int rating,
    String feedbackType,
    String? textFeedback,
    Map<String, dynamic>? additionalData,
    DateTime? providedAt,
  });
}

/// @nodoc
class __$$AIFeedbackImplCopyWithImpl<$Res>
    extends _$AIFeedbackCopyWithImpl<$Res, _$AIFeedbackImpl>
    implements _$$AIFeedbackImplCopyWith<$Res> {
  __$$AIFeedbackImplCopyWithImpl(
    _$AIFeedbackImpl _value,
    $Res Function(_$AIFeedbackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIFeedback
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? recommendationId = null,
    Object? wasHelpful = null,
    Object? rating = null,
    Object? feedbackType = null,
    Object? textFeedback = freezed,
    Object? additionalData = freezed,
    Object? providedAt = freezed,
  }) {
    return _then(
      _$AIFeedbackImpl(
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
        recommendationId:
            null == recommendationId
                ? _value.recommendationId
                : recommendationId // ignore: cast_nullable_to_non_nullable
                    as String,
        wasHelpful:
            null == wasHelpful
                ? _value.wasHelpful
                : wasHelpful // ignore: cast_nullable_to_non_nullable
                    as bool,
        rating:
            null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as int,
        feedbackType:
            null == feedbackType
                ? _value.feedbackType
                : feedbackType // ignore: cast_nullable_to_non_nullable
                    as String,
        textFeedback:
            freezed == textFeedback
                ? _value.textFeedback
                : textFeedback // ignore: cast_nullable_to_non_nullable
                    as String?,
        additionalData:
            freezed == additionalData
                ? _value._additionalData
                : additionalData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        providedAt:
            freezed == providedAt
                ? _value.providedAt
                : providedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIFeedbackImpl implements _AIFeedback {
  const _$AIFeedbackImpl({
    required this.id,
    required this.userId,
    required this.recommendationId,
    required this.wasHelpful,
    required this.rating,
    required this.feedbackType,
    this.textFeedback,
    final Map<String, dynamic>? additionalData,
    this.providedAt,
  }) : _additionalData = additionalData;

  factory _$AIFeedbackImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIFeedbackImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String recommendationId;
  @override
  final bool wasHelpful;
  @override
  final int rating;
  @override
  final String feedbackType;
  @override
  final String? textFeedback;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? providedAt;

  @override
  String toString() {
    return 'AIFeedback(id: $id, userId: $userId, recommendationId: $recommendationId, wasHelpful: $wasHelpful, rating: $rating, feedbackType: $feedbackType, textFeedback: $textFeedback, additionalData: $additionalData, providedAt: $providedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIFeedbackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recommendationId, recommendationId) ||
                other.recommendationId == recommendationId) &&
            (identical(other.wasHelpful, wasHelpful) ||
                other.wasHelpful == wasHelpful) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.feedbackType, feedbackType) ||
                other.feedbackType == feedbackType) &&
            (identical(other.textFeedback, textFeedback) ||
                other.textFeedback == textFeedback) &&
            const DeepCollectionEquality().equals(
              other._additionalData,
              _additionalData,
            ) &&
            (identical(other.providedAt, providedAt) ||
                other.providedAt == providedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    recommendationId,
    wasHelpful,
    rating,
    feedbackType,
    textFeedback,
    const DeepCollectionEquality().hash(_additionalData),
    providedAt,
  );

  /// Create a copy of AIFeedback
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIFeedbackImplCopyWith<_$AIFeedbackImpl> get copyWith =>
      __$$AIFeedbackImplCopyWithImpl<_$AIFeedbackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIFeedbackImplToJson(this);
  }
}

abstract class _AIFeedback implements AIFeedback {
  const factory _AIFeedback({
    required final String id,
    required final String userId,
    required final String recommendationId,
    required final bool wasHelpful,
    required final int rating,
    required final String feedbackType,
    final String? textFeedback,
    final Map<String, dynamic>? additionalData,
    final DateTime? providedAt,
  }) = _$AIFeedbackImpl;

  factory _AIFeedback.fromJson(Map<String, dynamic> json) =
      _$AIFeedbackImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get recommendationId;
  @override
  bool get wasHelpful;
  @override
  int get rating;
  @override
  String get feedbackType;
  @override
  String? get textFeedback;
  @override
  Map<String, dynamic>? get additionalData;
  @override
  DateTime? get providedAt;

  /// Create a copy of AIFeedback
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIFeedbackImplCopyWith<_$AIFeedbackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContextualAnalytics _$ContextualAnalyticsFromJson(Map<String, dynamic> json) {
  return _ContextualAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ContextualAnalytics {
  String get userId => throw _privateConstructorUsedError;
  Map<EmotionalState, int> get emotionSuccessRate =>
      throw _privateConstructorUsedError;
  Map<DuaContext, double> get contextEffectiveness =>
      throw _privateConstructorUsedError;
  int get totalRecommendations => throw _privateConstructorUsedError;
  int get acceptedRecommendations => throw _privateConstructorUsedError;
  int get dismissedRecommendations => throw _privateConstructorUsedError;
  double get overallSatisfaction => throw _privateConstructorUsedError;
  Map<String, dynamic> get improvementAreas =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this ContextualAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContextualAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContextualAnalyticsCopyWith<ContextualAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextualAnalyticsCopyWith<$Res> {
  factory $ContextualAnalyticsCopyWith(
    ContextualAnalytics value,
    $Res Function(ContextualAnalytics) then,
  ) = _$ContextualAnalyticsCopyWithImpl<$Res, ContextualAnalytics>;
  @useResult
  $Res call({
    String userId,
    Map<EmotionalState, int> emotionSuccessRate,
    Map<DuaContext, double> contextEffectiveness,
    int totalRecommendations,
    int acceptedRecommendations,
    int dismissedRecommendations,
    double overallSatisfaction,
    Map<String, dynamic> improvementAreas,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$ContextualAnalyticsCopyWithImpl<$Res, $Val extends ContextualAnalytics>
    implements $ContextualAnalyticsCopyWith<$Res> {
  _$ContextualAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContextualAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? emotionSuccessRate = null,
    Object? contextEffectiveness = null,
    Object? totalRecommendations = null,
    Object? acceptedRecommendations = null,
    Object? dismissedRecommendations = null,
    Object? overallSatisfaction = null,
    Object? improvementAreas = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            emotionSuccessRate:
                null == emotionSuccessRate
                    ? _value.emotionSuccessRate
                    : emotionSuccessRate // ignore: cast_nullable_to_non_nullable
                        as Map<EmotionalState, int>,
            contextEffectiveness:
                null == contextEffectiveness
                    ? _value.contextEffectiveness
                    : contextEffectiveness // ignore: cast_nullable_to_non_nullable
                        as Map<DuaContext, double>,
            totalRecommendations:
                null == totalRecommendations
                    ? _value.totalRecommendations
                    : totalRecommendations // ignore: cast_nullable_to_non_nullable
                        as int,
            acceptedRecommendations:
                null == acceptedRecommendations
                    ? _value.acceptedRecommendations
                    : acceptedRecommendations // ignore: cast_nullable_to_non_nullable
                        as int,
            dismissedRecommendations:
                null == dismissedRecommendations
                    ? _value.dismissedRecommendations
                    : dismissedRecommendations // ignore: cast_nullable_to_non_nullable
                        as int,
            overallSatisfaction:
                null == overallSatisfaction
                    ? _value.overallSatisfaction
                    : overallSatisfaction // ignore: cast_nullable_to_non_nullable
                        as double,
            improvementAreas:
                null == improvementAreas
                    ? _value.improvementAreas
                    : improvementAreas // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            lastUpdated:
                null == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContextualAnalyticsImplCopyWith<$Res>
    implements $ContextualAnalyticsCopyWith<$Res> {
  factory _$$ContextualAnalyticsImplCopyWith(
    _$ContextualAnalyticsImpl value,
    $Res Function(_$ContextualAnalyticsImpl) then,
  ) = __$$ContextualAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    Map<EmotionalState, int> emotionSuccessRate,
    Map<DuaContext, double> contextEffectiveness,
    int totalRecommendations,
    int acceptedRecommendations,
    int dismissedRecommendations,
    double overallSatisfaction,
    Map<String, dynamic> improvementAreas,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$ContextualAnalyticsImplCopyWithImpl<$Res>
    extends _$ContextualAnalyticsCopyWithImpl<$Res, _$ContextualAnalyticsImpl>
    implements _$$ContextualAnalyticsImplCopyWith<$Res> {
  __$$ContextualAnalyticsImplCopyWithImpl(
    _$ContextualAnalyticsImpl _value,
    $Res Function(_$ContextualAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContextualAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? emotionSuccessRate = null,
    Object? contextEffectiveness = null,
    Object? totalRecommendations = null,
    Object? acceptedRecommendations = null,
    Object? dismissedRecommendations = null,
    Object? overallSatisfaction = null,
    Object? improvementAreas = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$ContextualAnalyticsImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        emotionSuccessRate:
            null == emotionSuccessRate
                ? _value._emotionSuccessRate
                : emotionSuccessRate // ignore: cast_nullable_to_non_nullable
                    as Map<EmotionalState, int>,
        contextEffectiveness:
            null == contextEffectiveness
                ? _value._contextEffectiveness
                : contextEffectiveness // ignore: cast_nullable_to_non_nullable
                    as Map<DuaContext, double>,
        totalRecommendations:
            null == totalRecommendations
                ? _value.totalRecommendations
                : totalRecommendations // ignore: cast_nullable_to_non_nullable
                    as int,
        acceptedRecommendations:
            null == acceptedRecommendations
                ? _value.acceptedRecommendations
                : acceptedRecommendations // ignore: cast_nullable_to_non_nullable
                    as int,
        dismissedRecommendations:
            null == dismissedRecommendations
                ? _value.dismissedRecommendations
                : dismissedRecommendations // ignore: cast_nullable_to_non_nullable
                    as int,
        overallSatisfaction:
            null == overallSatisfaction
                ? _value.overallSatisfaction
                : overallSatisfaction // ignore: cast_nullable_to_non_nullable
                    as double,
        improvementAreas:
            null == improvementAreas
                ? _value._improvementAreas
                : improvementAreas // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        lastUpdated:
            null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContextualAnalyticsImpl implements _ContextualAnalytics {
  const _$ContextualAnalyticsImpl({
    required this.userId,
    required final Map<EmotionalState, int> emotionSuccessRate,
    required final Map<DuaContext, double> contextEffectiveness,
    required this.totalRecommendations,
    required this.acceptedRecommendations,
    required this.dismissedRecommendations,
    required this.overallSatisfaction,
    required final Map<String, dynamic> improvementAreas,
    required this.lastUpdated,
  }) : _emotionSuccessRate = emotionSuccessRate,
       _contextEffectiveness = contextEffectiveness,
       _improvementAreas = improvementAreas;

  factory _$ContextualAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContextualAnalyticsImplFromJson(json);

  @override
  final String userId;
  final Map<EmotionalState, int> _emotionSuccessRate;
  @override
  Map<EmotionalState, int> get emotionSuccessRate {
    if (_emotionSuccessRate is EqualUnmodifiableMapView)
      return _emotionSuccessRate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_emotionSuccessRate);
  }

  final Map<DuaContext, double> _contextEffectiveness;
  @override
  Map<DuaContext, double> get contextEffectiveness {
    if (_contextEffectiveness is EqualUnmodifiableMapView)
      return _contextEffectiveness;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contextEffectiveness);
  }

  @override
  final int totalRecommendations;
  @override
  final int acceptedRecommendations;
  @override
  final int dismissedRecommendations;
  @override
  final double overallSatisfaction;
  final Map<String, dynamic> _improvementAreas;
  @override
  Map<String, dynamic> get improvementAreas {
    if (_improvementAreas is EqualUnmodifiableMapView) return _improvementAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_improvementAreas);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'ContextualAnalytics(userId: $userId, emotionSuccessRate: $emotionSuccessRate, contextEffectiveness: $contextEffectiveness, totalRecommendations: $totalRecommendations, acceptedRecommendations: $acceptedRecommendations, dismissedRecommendations: $dismissedRecommendations, overallSatisfaction: $overallSatisfaction, improvementAreas: $improvementAreas, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContextualAnalyticsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._emotionSuccessRate,
              _emotionSuccessRate,
            ) &&
            const DeepCollectionEquality().equals(
              other._contextEffectiveness,
              _contextEffectiveness,
            ) &&
            (identical(other.totalRecommendations, totalRecommendations) ||
                other.totalRecommendations == totalRecommendations) &&
            (identical(
                  other.acceptedRecommendations,
                  acceptedRecommendations,
                ) ||
                other.acceptedRecommendations == acceptedRecommendations) &&
            (identical(
                  other.dismissedRecommendations,
                  dismissedRecommendations,
                ) ||
                other.dismissedRecommendations == dismissedRecommendations) &&
            (identical(other.overallSatisfaction, overallSatisfaction) ||
                other.overallSatisfaction == overallSatisfaction) &&
            const DeepCollectionEquality().equals(
              other._improvementAreas,
              _improvementAreas,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_emotionSuccessRate),
    const DeepCollectionEquality().hash(_contextEffectiveness),
    totalRecommendations,
    acceptedRecommendations,
    dismissedRecommendations,
    overallSatisfaction,
    const DeepCollectionEquality().hash(_improvementAreas),
    lastUpdated,
  );

  /// Create a copy of ContextualAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextualAnalyticsImplCopyWith<_$ContextualAnalyticsImpl> get copyWith =>
      __$$ContextualAnalyticsImplCopyWithImpl<_$ContextualAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContextualAnalyticsImplToJson(this);
  }
}

abstract class _ContextualAnalytics implements ContextualAnalytics {
  const factory _ContextualAnalytics({
    required final String userId,
    required final Map<EmotionalState, int> emotionSuccessRate,
    required final Map<DuaContext, double> contextEffectiveness,
    required final int totalRecommendations,
    required final int acceptedRecommendations,
    required final int dismissedRecommendations,
    required final double overallSatisfaction,
    required final Map<String, dynamic> improvementAreas,
    required final DateTime lastUpdated,
  }) = _$ContextualAnalyticsImpl;

  factory _ContextualAnalytics.fromJson(Map<String, dynamic> json) =
      _$ContextualAnalyticsImpl.fromJson;

  @override
  String get userId;
  @override
  Map<EmotionalState, int> get emotionSuccessRate;
  @override
  Map<DuaContext, double> get contextEffectiveness;
  @override
  int get totalRecommendations;
  @override
  int get acceptedRecommendations;
  @override
  int get dismissedRecommendations;
  @override
  double get overallSatisfaction;
  @override
  Map<String, dynamic> get improvementAreas;
  @override
  DateTime get lastUpdated;

  /// Create a copy of ContextualAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContextualAnalyticsImplCopyWith<_$ContextualAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
