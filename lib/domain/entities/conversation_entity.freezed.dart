// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get userId => throw _privateConstructorUsedError;
  Map<String, dynamic> get preferences => throw _privateConstructorUsedError;
  String get conversationStyle => throw _privateConstructorUsedError;
  List<String> get topicInterests => throw _privateConstructorUsedError;
  Map<String, dynamic> get emotionalPatterns =>
      throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String userId,
      Map<String, dynamic> preferences,
      String conversationStyle,
      List<String> topicInterests,
      Map<String, dynamic> emotionalPatterns});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferences = null,
    Object? conversationStyle = null,
    Object? topicInterests = null,
    Object? emotionalPatterns = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      conversationStyle: null == conversationStyle
          ? _value.conversationStyle
          : conversationStyle // ignore: cast_nullable_to_non_nullable
              as String,
      topicInterests: null == topicInterests
          ? _value.topicInterests
          : topicInterests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emotionalPatterns: null == emotionalPatterns
          ? _value.emotionalPatterns
          : emotionalPatterns // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      Map<String, dynamic> preferences,
      String conversationStyle,
      List<String> topicInterests,
      Map<String, dynamic> emotionalPatterns});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferences = null,
    Object? conversationStyle = null,
    Object? topicInterests = null,
    Object? emotionalPatterns = null,
  }) {
    return _then(_$UserProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      conversationStyle: null == conversationStyle
          ? _value.conversationStyle
          : conversationStyle // ignore: cast_nullable_to_non_nullable
              as String,
      topicInterests: null == topicInterests
          ? _value._topicInterests
          : topicInterests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emotionalPatterns: null == emotionalPatterns
          ? _value._emotionalPatterns
          : emotionalPatterns // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.userId,
      required final Map<String, dynamic> preferences,
      required this.conversationStyle,
      required final List<String> topicInterests,
      required final Map<String, dynamic> emotionalPatterns})
      : _preferences = preferences,
        _topicInterests = topicInterests,
        _emotionalPatterns = emotionalPatterns;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String userId;
  final Map<String, dynamic> _preferences;
  @override
  Map<String, dynamic> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  @override
  final String conversationStyle;
  final List<String> _topicInterests;
  @override
  List<String> get topicInterests {
    if (_topicInterests is EqualUnmodifiableListView) return _topicInterests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topicInterests);
  }

  final Map<String, dynamic> _emotionalPatterns;
  @override
  Map<String, dynamic> get emotionalPatterns {
    if (_emotionalPatterns is EqualUnmodifiableMapView)
      return _emotionalPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_emotionalPatterns);
  }

  @override
  String toString() {
    return 'UserProfile(userId: $userId, preferences: $preferences, conversationStyle: $conversationStyle, topicInterests: $topicInterests, emotionalPatterns: $emotionalPatterns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            (identical(other.conversationStyle, conversationStyle) ||
                other.conversationStyle == conversationStyle) &&
            const DeepCollectionEquality()
                .equals(other._topicInterests, _topicInterests) &&
            const DeepCollectionEquality()
                .equals(other._emotionalPatterns, _emotionalPatterns));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      const DeepCollectionEquality().hash(_preferences),
      conversationStyle,
      const DeepCollectionEquality().hash(_topicInterests),
      const DeepCollectionEquality().hash(_emotionalPatterns));

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
          {required final String userId,
          required final Map<String, dynamic> preferences,
          required final String conversationStyle,
          required final List<String> topicInterests,
          required final Map<String, dynamic> emotionalPatterns}) =
      _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get userId;
  @override
  Map<String, dynamic> get preferences;
  @override
  String get conversationStyle;
  @override
  List<String> get topicInterests;
  @override
  Map<String, dynamic> get emotionalPatterns;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationContext _$ConversationContextFromJson(Map<String, dynamic> json) {
  return _ConversationContext.fromJson(json);
}

/// @nodoc
mixin _$ConversationContext {
  String get conversationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get lastActivity => throw _privateConstructorUsedError;
  int get turnCount => throw _privateConstructorUsedError;
  String? get currentTopic => throw _privateConstructorUsedError;
  EmotionalState get emotionalState => throw _privateConstructorUsedError;
  List<String> get contextTags => throw _privateConstructorUsedError;
  UserProfile get userProfile => throw _privateConstructorUsedError;
  Map<String, dynamic> get semanticContext =>
      throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ConversationContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationContextCopyWith<ConversationContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationContextCopyWith<$Res> {
  factory $ConversationContextCopyWith(
          ConversationContext value, $Res Function(ConversationContext) then) =
      _$ConversationContextCopyWithImpl<$Res, ConversationContext>;
  @useResult
  $Res call(
      {String conversationId,
      String userId,
      DateTime startTime,
      DateTime lastActivity,
      int turnCount,
      String? currentTopic,
      EmotionalState emotionalState,
      List<String> contextTags,
      UserProfile userProfile,
      Map<String, dynamic> semanticContext,
      DateTime? endTime,
      bool isActive});

  $UserProfileCopyWith<$Res> get userProfile;
}

/// @nodoc
class _$ConversationContextCopyWithImpl<$Res, $Val extends ConversationContext>
    implements $ConversationContextCopyWith<$Res> {
  _$ConversationContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? lastActivity = null,
    Object? turnCount = null,
    Object? currentTopic = freezed,
    Object? emotionalState = null,
    Object? contextTags = null,
    Object? userProfile = null,
    Object? semanticContext = null,
    Object? endTime = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivity: null == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime,
      turnCount: null == turnCount
          ? _value.turnCount
          : turnCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentTopic: freezed == currentTopic
          ? _value.currentTopic
          : currentTopic // ignore: cast_nullable_to_non_nullable
              as String?,
      emotionalState: null == emotionalState
          ? _value.emotionalState
          : emotionalState // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      contextTags: null == contextTags
          ? _value.contextTags
          : contextTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userProfile: null == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      semanticContext: null == semanticContext
          ? _value.semanticContext
          : semanticContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ConversationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get userProfile {
    return $UserProfileCopyWith<$Res>(_value.userProfile, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationContextImplCopyWith<$Res>
    implements $ConversationContextCopyWith<$Res> {
  factory _$$ConversationContextImplCopyWith(_$ConversationContextImpl value,
          $Res Function(_$ConversationContextImpl) then) =
      __$$ConversationContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String conversationId,
      String userId,
      DateTime startTime,
      DateTime lastActivity,
      int turnCount,
      String? currentTopic,
      EmotionalState emotionalState,
      List<String> contextTags,
      UserProfile userProfile,
      Map<String, dynamic> semanticContext,
      DateTime? endTime,
      bool isActive});

  @override
  $UserProfileCopyWith<$Res> get userProfile;
}

/// @nodoc
class __$$ConversationContextImplCopyWithImpl<$Res>
    extends _$ConversationContextCopyWithImpl<$Res, _$ConversationContextImpl>
    implements _$$ConversationContextImplCopyWith<$Res> {
  __$$ConversationContextImplCopyWithImpl(_$ConversationContextImpl _value,
      $Res Function(_$ConversationContextImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? lastActivity = null,
    Object? turnCount = null,
    Object? currentTopic = freezed,
    Object? emotionalState = null,
    Object? contextTags = null,
    Object? userProfile = null,
    Object? semanticContext = null,
    Object? endTime = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ConversationContextImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivity: null == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime,
      turnCount: null == turnCount
          ? _value.turnCount
          : turnCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentTopic: freezed == currentTopic
          ? _value.currentTopic
          : currentTopic // ignore: cast_nullable_to_non_nullable
              as String?,
      emotionalState: null == emotionalState
          ? _value.emotionalState
          : emotionalState // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      contextTags: null == contextTags
          ? _value._contextTags
          : contextTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userProfile: null == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      semanticContext: null == semanticContext
          ? _value._semanticContext
          : semanticContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationContextImpl implements _ConversationContext {
  const _$ConversationContextImpl(
      {required this.conversationId,
      required this.userId,
      required this.startTime,
      required this.lastActivity,
      required this.turnCount,
      required this.currentTopic,
      required this.emotionalState,
      required final List<String> contextTags,
      required this.userProfile,
      required final Map<String, dynamic> semanticContext,
      this.endTime,
      this.isActive = true})
      : _contextTags = contextTags,
        _semanticContext = semanticContext;

  factory _$ConversationContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationContextImplFromJson(json);

  @override
  final String conversationId;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime lastActivity;
  @override
  final int turnCount;
  @override
  final String? currentTopic;
  @override
  final EmotionalState emotionalState;
  final List<String> _contextTags;
  @override
  List<String> get contextTags {
    if (_contextTags is EqualUnmodifiableListView) return _contextTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contextTags);
  }

  @override
  final UserProfile userProfile;
  final Map<String, dynamic> _semanticContext;
  @override
  Map<String, dynamic> get semanticContext {
    if (_semanticContext is EqualUnmodifiableMapView) return _semanticContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_semanticContext);
  }

  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'ConversationContext(conversationId: $conversationId, userId: $userId, startTime: $startTime, lastActivity: $lastActivity, turnCount: $turnCount, currentTopic: $currentTopic, emotionalState: $emotionalState, contextTags: $contextTags, userProfile: $userProfile, semanticContext: $semanticContext, endTime: $endTime, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationContextImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.lastActivity, lastActivity) ||
                other.lastActivity == lastActivity) &&
            (identical(other.turnCount, turnCount) ||
                other.turnCount == turnCount) &&
            (identical(other.currentTopic, currentTopic) ||
                other.currentTopic == currentTopic) &&
            (identical(other.emotionalState, emotionalState) ||
                other.emotionalState == emotionalState) &&
            const DeepCollectionEquality()
                .equals(other._contextTags, _contextTags) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            const DeepCollectionEquality()
                .equals(other._semanticContext, _semanticContext) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      conversationId,
      userId,
      startTime,
      lastActivity,
      turnCount,
      currentTopic,
      emotionalState,
      const DeepCollectionEquality().hash(_contextTags),
      userProfile,
      const DeepCollectionEquality().hash(_semanticContext),
      endTime,
      isActive);

  /// Create a copy of ConversationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationContextImplCopyWith<_$ConversationContextImpl> get copyWith =>
      __$$ConversationContextImplCopyWithImpl<_$ConversationContextImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationContextImplToJson(
      this,
    );
  }
}

abstract class _ConversationContext implements ConversationContext {
  const factory _ConversationContext(
      {required final String conversationId,
      required final String userId,
      required final DateTime startTime,
      required final DateTime lastActivity,
      required final int turnCount,
      required final String? currentTopic,
      required final EmotionalState emotionalState,
      required final List<String> contextTags,
      required final UserProfile userProfile,
      required final Map<String, dynamic> semanticContext,
      final DateTime? endTime,
      final bool isActive}) = _$ConversationContextImpl;

  factory _ConversationContext.fromJson(Map<String, dynamic> json) =
      _$ConversationContextImpl.fromJson;

  @override
  String get conversationId;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime get lastActivity;
  @override
  int get turnCount;
  @override
  String? get currentTopic;
  @override
  EmotionalState get emotionalState;
  @override
  List<String> get contextTags;
  @override
  UserProfile get userProfile;
  @override
  Map<String, dynamic> get semanticContext;
  @override
  DateTime? get endTime;
  @override
  bool get isActive;

  /// Create a copy of ConversationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationContextImplCopyWith<_$ConversationContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationTurn _$ConversationTurnFromJson(Map<String, dynamic> json) {
  return _ConversationTurn.fromJson(json);
}

/// @nodoc
mixin _$ConversationTurn {
  String get turnId => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get userInput => throw _privateConstructorUsedError;
  String get systemResponse => throw _privateConstructorUsedError;
  String get intent => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  EmotionalState get emotionalState => throw _privateConstructorUsedError;
  List<String> get topicTags => throw _privateConstructorUsedError;
  List<double> get semanticEmbedding => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this ConversationTurn to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationTurn
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationTurnCopyWith<ConversationTurn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationTurnCopyWith<$Res> {
  factory $ConversationTurnCopyWith(
          ConversationTurn value, $Res Function(ConversationTurn) then) =
      _$ConversationTurnCopyWithImpl<$Res, ConversationTurn>;
  @useResult
  $Res call(
      {String turnId,
      String conversationId,
      String userInput,
      String systemResponse,
      String intent,
      DateTime timestamp,
      EmotionalState emotionalState,
      List<String> topicTags,
      List<double> semanticEmbedding,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ConversationTurnCopyWithImpl<$Res, $Val extends ConversationTurn>
    implements $ConversationTurnCopyWith<$Res> {
  _$ConversationTurnCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationTurn
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? turnId = null,
    Object? conversationId = null,
    Object? userInput = null,
    Object? systemResponse = null,
    Object? intent = null,
    Object? timestamp = null,
    Object? emotionalState = null,
    Object? topicTags = null,
    Object? semanticEmbedding = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      turnId: null == turnId
          ? _value.turnId
          : turnId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
      systemResponse: null == systemResponse
          ? _value.systemResponse
          : systemResponse // ignore: cast_nullable_to_non_nullable
              as String,
      intent: null == intent
          ? _value.intent
          : intent // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      emotionalState: null == emotionalState
          ? _value.emotionalState
          : emotionalState // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      topicTags: null == topicTags
          ? _value.topicTags
          : topicTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      semanticEmbedding: null == semanticEmbedding
          ? _value.semanticEmbedding
          : semanticEmbedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationTurnImplCopyWith<$Res>
    implements $ConversationTurnCopyWith<$Res> {
  factory _$$ConversationTurnImplCopyWith(_$ConversationTurnImpl value,
          $Res Function(_$ConversationTurnImpl) then) =
      __$$ConversationTurnImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String turnId,
      String conversationId,
      String userInput,
      String systemResponse,
      String intent,
      DateTime timestamp,
      EmotionalState emotionalState,
      List<String> topicTags,
      List<double> semanticEmbedding,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ConversationTurnImplCopyWithImpl<$Res>
    extends _$ConversationTurnCopyWithImpl<$Res, _$ConversationTurnImpl>
    implements _$$ConversationTurnImplCopyWith<$Res> {
  __$$ConversationTurnImplCopyWithImpl(_$ConversationTurnImpl _value,
      $Res Function(_$ConversationTurnImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationTurn
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? turnId = null,
    Object? conversationId = null,
    Object? userInput = null,
    Object? systemResponse = null,
    Object? intent = null,
    Object? timestamp = null,
    Object? emotionalState = null,
    Object? topicTags = null,
    Object? semanticEmbedding = null,
    Object? metadata = null,
  }) {
    return _then(_$ConversationTurnImpl(
      turnId: null == turnId
          ? _value.turnId
          : turnId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
      systemResponse: null == systemResponse
          ? _value.systemResponse
          : systemResponse // ignore: cast_nullable_to_non_nullable
              as String,
      intent: null == intent
          ? _value.intent
          : intent // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      emotionalState: null == emotionalState
          ? _value.emotionalState
          : emotionalState // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      topicTags: null == topicTags
          ? _value._topicTags
          : topicTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      semanticEmbedding: null == semanticEmbedding
          ? _value._semanticEmbedding
          : semanticEmbedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationTurnImpl implements _ConversationTurn {
  const _$ConversationTurnImpl(
      {required this.turnId,
      required this.conversationId,
      required this.userInput,
      required this.systemResponse,
      required this.intent,
      required this.timestamp,
      required this.emotionalState,
      required final List<String> topicTags,
      required final List<double> semanticEmbedding,
      required final Map<String, dynamic> metadata})
      : _topicTags = topicTags,
        _semanticEmbedding = semanticEmbedding,
        _metadata = metadata;

  factory _$ConversationTurnImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationTurnImplFromJson(json);

  @override
  final String turnId;
  @override
  final String conversationId;
  @override
  final String userInput;
  @override
  final String systemResponse;
  @override
  final String intent;
  @override
  final DateTime timestamp;
  @override
  final EmotionalState emotionalState;
  final List<String> _topicTags;
  @override
  List<String> get topicTags {
    if (_topicTags is EqualUnmodifiableListView) return _topicTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topicTags);
  }

  final List<double> _semanticEmbedding;
  @override
  List<double> get semanticEmbedding {
    if (_semanticEmbedding is EqualUnmodifiableListView)
      return _semanticEmbedding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_semanticEmbedding);
  }

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ConversationTurn(turnId: $turnId, conversationId: $conversationId, userInput: $userInput, systemResponse: $systemResponse, intent: $intent, timestamp: $timestamp, emotionalState: $emotionalState, topicTags: $topicTags, semanticEmbedding: $semanticEmbedding, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationTurnImpl &&
            (identical(other.turnId, turnId) || other.turnId == turnId) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userInput, userInput) ||
                other.userInput == userInput) &&
            (identical(other.systemResponse, systemResponse) ||
                other.systemResponse == systemResponse) &&
            (identical(other.intent, intent) || other.intent == intent) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.emotionalState, emotionalState) ||
                other.emotionalState == emotionalState) &&
            const DeepCollectionEquality()
                .equals(other._topicTags, _topicTags) &&
            const DeepCollectionEquality()
                .equals(other._semanticEmbedding, _semanticEmbedding) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      turnId,
      conversationId,
      userInput,
      systemResponse,
      intent,
      timestamp,
      emotionalState,
      const DeepCollectionEquality().hash(_topicTags),
      const DeepCollectionEquality().hash(_semanticEmbedding),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ConversationTurn
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationTurnImplCopyWith<_$ConversationTurnImpl> get copyWith =>
      __$$ConversationTurnImplCopyWithImpl<_$ConversationTurnImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationTurnImplToJson(
      this,
    );
  }
}

abstract class _ConversationTurn implements ConversationTurn {
  const factory _ConversationTurn(
      {required final String turnId,
      required final String conversationId,
      required final String userInput,
      required final String systemResponse,
      required final String intent,
      required final DateTime timestamp,
      required final EmotionalState emotionalState,
      required final List<String> topicTags,
      required final List<double> semanticEmbedding,
      required final Map<String, dynamic> metadata}) = _$ConversationTurnImpl;

  factory _ConversationTurn.fromJson(Map<String, dynamic> json) =
      _$ConversationTurnImpl.fromJson;

  @override
  String get turnId;
  @override
  String get conversationId;
  @override
  String get userInput;
  @override
  String get systemResponse;
  @override
  String get intent;
  @override
  DateTime get timestamp;
  @override
  EmotionalState get emotionalState;
  @override
  List<String> get topicTags;
  @override
  List<double> get semanticEmbedding;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of ConversationTurn
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationTurnImplCopyWith<_$ConversationTurnImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SemanticMemory _$SemanticMemoryFromJson(Map<String, dynamic> json) {
  return _SemanticMemory.fromJson(json);
}

/// @nodoc
mixin _$SemanticMemory {
  String get userId => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get turnId => throw _privateConstructorUsedError;
  String get userInput => throw _privateConstructorUsedError;
  String get systemResponse => throw _privateConstructorUsedError;
  List<double> get embedding => throw _privateConstructorUsedError;
  List<String> get topics => throw _privateConstructorUsedError;
  EmotionalState get emotionalState => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this SemanticMemory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SemanticMemory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SemanticMemoryCopyWith<SemanticMemory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SemanticMemoryCopyWith<$Res> {
  factory $SemanticMemoryCopyWith(
          SemanticMemory value, $Res Function(SemanticMemory) then) =
      _$SemanticMemoryCopyWithImpl<$Res, SemanticMemory>;
  @useResult
  $Res call(
      {String userId,
      String conversationId,
      String turnId,
      String userInput,
      String systemResponse,
      List<double> embedding,
      List<String> topics,
      EmotionalState emotionalState,
      DateTime timestamp});
}

/// @nodoc
class _$SemanticMemoryCopyWithImpl<$Res, $Val extends SemanticMemory>
    implements $SemanticMemoryCopyWith<$Res> {
  _$SemanticMemoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SemanticMemory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? conversationId = null,
    Object? turnId = null,
    Object? userInput = null,
    Object? systemResponse = null,
    Object? embedding = null,
    Object? topics = null,
    Object? emotionalState = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      turnId: null == turnId
          ? _value.turnId
          : turnId // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
      systemResponse: null == systemResponse
          ? _value.systemResponse
          : systemResponse // ignore: cast_nullable_to_non_nullable
              as String,
      embedding: null == embedding
          ? _value.embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emotionalState: null == emotionalState
          ? _value.emotionalState
          : emotionalState // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SemanticMemoryImplCopyWith<$Res>
    implements $SemanticMemoryCopyWith<$Res> {
  factory _$$SemanticMemoryImplCopyWith(_$SemanticMemoryImpl value,
          $Res Function(_$SemanticMemoryImpl) then) =
      __$$SemanticMemoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String conversationId,
      String turnId,
      String userInput,
      String systemResponse,
      List<double> embedding,
      List<String> topics,
      EmotionalState emotionalState,
      DateTime timestamp});
}

/// @nodoc
class __$$SemanticMemoryImplCopyWithImpl<$Res>
    extends _$SemanticMemoryCopyWithImpl<$Res, _$SemanticMemoryImpl>
    implements _$$SemanticMemoryImplCopyWith<$Res> {
  __$$SemanticMemoryImplCopyWithImpl(
      _$SemanticMemoryImpl _value, $Res Function(_$SemanticMemoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SemanticMemory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? conversationId = null,
    Object? turnId = null,
    Object? userInput = null,
    Object? systemResponse = null,
    Object? embedding = null,
    Object? topics = null,
    Object? emotionalState = null,
    Object? timestamp = null,
  }) {
    return _then(_$SemanticMemoryImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      turnId: null == turnId
          ? _value.turnId
          : turnId // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
      systemResponse: null == systemResponse
          ? _value.systemResponse
          : systemResponse // ignore: cast_nullable_to_non_nullable
              as String,
      embedding: null == embedding
          ? _value._embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emotionalState: null == emotionalState
          ? _value.emotionalState
          : emotionalState // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SemanticMemoryImpl implements _SemanticMemory {
  const _$SemanticMemoryImpl(
      {required this.userId,
      required this.conversationId,
      required this.turnId,
      required this.userInput,
      required this.systemResponse,
      required final List<double> embedding,
      required final List<String> topics,
      required this.emotionalState,
      required this.timestamp})
      : _embedding = embedding,
        _topics = topics;

  factory _$SemanticMemoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SemanticMemoryImplFromJson(json);

  @override
  final String userId;
  @override
  final String conversationId;
  @override
  final String turnId;
  @override
  final String userInput;
  @override
  final String systemResponse;
  final List<double> _embedding;
  @override
  List<double> get embedding {
    if (_embedding is EqualUnmodifiableListView) return _embedding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_embedding);
  }

  final List<String> _topics;
  @override
  List<String> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  final EmotionalState emotionalState;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'SemanticMemory(userId: $userId, conversationId: $conversationId, turnId: $turnId, userInput: $userInput, systemResponse: $systemResponse, embedding: $embedding, topics: $topics, emotionalState: $emotionalState, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SemanticMemoryImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.turnId, turnId) || other.turnId == turnId) &&
            (identical(other.userInput, userInput) ||
                other.userInput == userInput) &&
            (identical(other.systemResponse, systemResponse) ||
                other.systemResponse == systemResponse) &&
            const DeepCollectionEquality()
                .equals(other._embedding, _embedding) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.emotionalState, emotionalState) ||
                other.emotionalState == emotionalState) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      conversationId,
      turnId,
      userInput,
      systemResponse,
      const DeepCollectionEquality().hash(_embedding),
      const DeepCollectionEquality().hash(_topics),
      emotionalState,
      timestamp);

  /// Create a copy of SemanticMemory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SemanticMemoryImplCopyWith<_$SemanticMemoryImpl> get copyWith =>
      __$$SemanticMemoryImplCopyWithImpl<_$SemanticMemoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SemanticMemoryImplToJson(
      this,
    );
  }
}

abstract class _SemanticMemory implements SemanticMemory {
  const factory _SemanticMemory(
      {required final String userId,
      required final String conversationId,
      required final String turnId,
      required final String userInput,
      required final String systemResponse,
      required final List<double> embedding,
      required final List<String> topics,
      required final EmotionalState emotionalState,
      required final DateTime timestamp}) = _$SemanticMemoryImpl;

  factory _SemanticMemory.fromJson(Map<String, dynamic> json) =
      _$SemanticMemoryImpl.fromJson;

  @override
  String get userId;
  @override
  String get conversationId;
  @override
  String get turnId;
  @override
  String get userInput;
  @override
  String get systemResponse;
  @override
  List<double> get embedding;
  @override
  List<String> get topics;
  @override
  EmotionalState get emotionalState;
  @override
  DateTime get timestamp;

  /// Create a copy of SemanticMemory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SemanticMemoryImplCopyWith<_$SemanticMemoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SimilarConversation _$SimilarConversationFromJson(Map<String, dynamic> json) {
  return _SimilarConversation.fromJson(json);
}

/// @nodoc
mixin _$SimilarConversation {
  String get conversationId => throw _privateConstructorUsedError;
  String get turnId => throw _privateConstructorUsedError;
  double get similarity => throw _privateConstructorUsedError;
  String get originalInput => throw _privateConstructorUsedError;
  String get response => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<String> get topics => throw _privateConstructorUsedError;

  /// Serializes this SimilarConversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SimilarConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimilarConversationCopyWith<SimilarConversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimilarConversationCopyWith<$Res> {
  factory $SimilarConversationCopyWith(
          SimilarConversation value, $Res Function(SimilarConversation) then) =
      _$SimilarConversationCopyWithImpl<$Res, SimilarConversation>;
  @useResult
  $Res call(
      {String conversationId,
      String turnId,
      double similarity,
      String originalInput,
      String response,
      DateTime timestamp,
      List<String> topics});
}

/// @nodoc
class _$SimilarConversationCopyWithImpl<$Res, $Val extends SimilarConversation>
    implements $SimilarConversationCopyWith<$Res> {
  _$SimilarConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SimilarConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? turnId = null,
    Object? similarity = null,
    Object? originalInput = null,
    Object? response = null,
    Object? timestamp = null,
    Object? topics = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      turnId: null == turnId
          ? _value.turnId
          : turnId // ignore: cast_nullable_to_non_nullable
              as String,
      similarity: null == similarity
          ? _value.similarity
          : similarity // ignore: cast_nullable_to_non_nullable
              as double,
      originalInput: null == originalInput
          ? _value.originalInput
          : originalInput // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimilarConversationImplCopyWith<$Res>
    implements $SimilarConversationCopyWith<$Res> {
  factory _$$SimilarConversationImplCopyWith(_$SimilarConversationImpl value,
          $Res Function(_$SimilarConversationImpl) then) =
      __$$SimilarConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String conversationId,
      String turnId,
      double similarity,
      String originalInput,
      String response,
      DateTime timestamp,
      List<String> topics});
}

/// @nodoc
class __$$SimilarConversationImplCopyWithImpl<$Res>
    extends _$SimilarConversationCopyWithImpl<$Res, _$SimilarConversationImpl>
    implements _$$SimilarConversationImplCopyWith<$Res> {
  __$$SimilarConversationImplCopyWithImpl(_$SimilarConversationImpl _value,
      $Res Function(_$SimilarConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SimilarConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? turnId = null,
    Object? similarity = null,
    Object? originalInput = null,
    Object? response = null,
    Object? timestamp = null,
    Object? topics = null,
  }) {
    return _then(_$SimilarConversationImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      turnId: null == turnId
          ? _value.turnId
          : turnId // ignore: cast_nullable_to_non_nullable
              as String,
      similarity: null == similarity
          ? _value.similarity
          : similarity // ignore: cast_nullable_to_non_nullable
              as double,
      originalInput: null == originalInput
          ? _value.originalInput
          : originalInput // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SimilarConversationImpl implements _SimilarConversation {
  const _$SimilarConversationImpl(
      {required this.conversationId,
      required this.turnId,
      required this.similarity,
      required this.originalInput,
      required this.response,
      required this.timestamp,
      required final List<String> topics})
      : _topics = topics;

  factory _$SimilarConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimilarConversationImplFromJson(json);

  @override
  final String conversationId;
  @override
  final String turnId;
  @override
  final double similarity;
  @override
  final String originalInput;
  @override
  final String response;
  @override
  final DateTime timestamp;
  final List<String> _topics;
  @override
  List<String> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  String toString() {
    return 'SimilarConversation(conversationId: $conversationId, turnId: $turnId, similarity: $similarity, originalInput: $originalInput, response: $response, timestamp: $timestamp, topics: $topics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimilarConversationImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.turnId, turnId) || other.turnId == turnId) &&
            (identical(other.similarity, similarity) ||
                other.similarity == similarity) &&
            (identical(other.originalInput, originalInput) ||
                other.originalInput == originalInput) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._topics, _topics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      conversationId,
      turnId,
      similarity,
      originalInput,
      response,
      timestamp,
      const DeepCollectionEquality().hash(_topics));

  /// Create a copy of SimilarConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimilarConversationImplCopyWith<_$SimilarConversationImpl> get copyWith =>
      __$$SimilarConversationImplCopyWithImpl<_$SimilarConversationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimilarConversationImplToJson(
      this,
    );
  }
}

abstract class _SimilarConversation implements SimilarConversation {
  const factory _SimilarConversation(
      {required final String conversationId,
      required final String turnId,
      required final double similarity,
      required final String originalInput,
      required final String response,
      required final DateTime timestamp,
      required final List<String> topics}) = _$SimilarConversationImpl;

  factory _SimilarConversation.fromJson(Map<String, dynamic> json) =
      _$SimilarConversationImpl.fromJson;

  @override
  String get conversationId;
  @override
  String get turnId;
  @override
  double get similarity;
  @override
  String get originalInput;
  @override
  String get response;
  @override
  DateTime get timestamp;
  @override
  List<String> get topics;

  /// Create a copy of SimilarConversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimilarConversationImplCopyWith<_$SimilarConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationUpdate _$ConversationUpdateFromJson(Map<String, dynamic> json) {
  return _ConversationUpdate.fromJson(json);
}

/// @nodoc
mixin _$ConversationUpdate {
  String get conversationId => throw _privateConstructorUsedError;
  ConversationTurn get turn => throw _privateConstructorUsedError;
  ConversationContext get updatedContext => throw _privateConstructorUsedError;
  ConversationUpdateType get updateType => throw _privateConstructorUsedError;

  /// Serializes this ConversationUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationUpdateCopyWith<ConversationUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationUpdateCopyWith<$Res> {
  factory $ConversationUpdateCopyWith(
          ConversationUpdate value, $Res Function(ConversationUpdate) then) =
      _$ConversationUpdateCopyWithImpl<$Res, ConversationUpdate>;
  @useResult
  $Res call(
      {String conversationId,
      ConversationTurn turn,
      ConversationContext updatedContext,
      ConversationUpdateType updateType});

  $ConversationTurnCopyWith<$Res> get turn;
  $ConversationContextCopyWith<$Res> get updatedContext;
}

/// @nodoc
class _$ConversationUpdateCopyWithImpl<$Res, $Val extends ConversationUpdate>
    implements $ConversationUpdateCopyWith<$Res> {
  _$ConversationUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? turn = null,
    Object? updatedContext = null,
    Object? updateType = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      turn: null == turn
          ? _value.turn
          : turn // ignore: cast_nullable_to_non_nullable
              as ConversationTurn,
      updatedContext: null == updatedContext
          ? _value.updatedContext
          : updatedContext // ignore: cast_nullable_to_non_nullable
              as ConversationContext,
      updateType: null == updateType
          ? _value.updateType
          : updateType // ignore: cast_nullable_to_non_nullable
              as ConversationUpdateType,
    ) as $Val);
  }

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationTurnCopyWith<$Res> get turn {
    return $ConversationTurnCopyWith<$Res>(_value.turn, (value) {
      return _then(_value.copyWith(turn: value) as $Val);
    });
  }

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationContextCopyWith<$Res> get updatedContext {
    return $ConversationContextCopyWith<$Res>(_value.updatedContext, (value) {
      return _then(_value.copyWith(updatedContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationUpdateImplCopyWith<$Res>
    implements $ConversationUpdateCopyWith<$Res> {
  factory _$$ConversationUpdateImplCopyWith(_$ConversationUpdateImpl value,
          $Res Function(_$ConversationUpdateImpl) then) =
      __$$ConversationUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String conversationId,
      ConversationTurn turn,
      ConversationContext updatedContext,
      ConversationUpdateType updateType});

  @override
  $ConversationTurnCopyWith<$Res> get turn;
  @override
  $ConversationContextCopyWith<$Res> get updatedContext;
}

/// @nodoc
class __$$ConversationUpdateImplCopyWithImpl<$Res>
    extends _$ConversationUpdateCopyWithImpl<$Res, _$ConversationUpdateImpl>
    implements _$$ConversationUpdateImplCopyWith<$Res> {
  __$$ConversationUpdateImplCopyWithImpl(_$ConversationUpdateImpl _value,
      $Res Function(_$ConversationUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? turn = null,
    Object? updatedContext = null,
    Object? updateType = null,
  }) {
    return _then(_$ConversationUpdateImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      turn: null == turn
          ? _value.turn
          : turn // ignore: cast_nullable_to_non_nullable
              as ConversationTurn,
      updatedContext: null == updatedContext
          ? _value.updatedContext
          : updatedContext // ignore: cast_nullable_to_non_nullable
              as ConversationContext,
      updateType: null == updateType
          ? _value.updateType
          : updateType // ignore: cast_nullable_to_non_nullable
              as ConversationUpdateType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationUpdateImpl implements _ConversationUpdate {
  const _$ConversationUpdateImpl(
      {required this.conversationId,
      required this.turn,
      required this.updatedContext,
      required this.updateType});

  factory _$ConversationUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationUpdateImplFromJson(json);

  @override
  final String conversationId;
  @override
  final ConversationTurn turn;
  @override
  final ConversationContext updatedContext;
  @override
  final ConversationUpdateType updateType;

  @override
  String toString() {
    return 'ConversationUpdate(conversationId: $conversationId, turn: $turn, updatedContext: $updatedContext, updateType: $updateType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationUpdateImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.turn, turn) || other.turn == turn) &&
            (identical(other.updatedContext, updatedContext) ||
                other.updatedContext == updatedContext) &&
            (identical(other.updateType, updateType) ||
                other.updateType == updateType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, conversationId, turn, updatedContext, updateType);

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationUpdateImplCopyWith<_$ConversationUpdateImpl> get copyWith =>
      __$$ConversationUpdateImplCopyWithImpl<_$ConversationUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationUpdateImplToJson(
      this,
    );
  }
}

abstract class _ConversationUpdate implements ConversationUpdate {
  const factory _ConversationUpdate(
          {required final String conversationId,
          required final ConversationTurn turn,
          required final ConversationContext updatedContext,
          required final ConversationUpdateType updateType}) =
      _$ConversationUpdateImpl;

  factory _ConversationUpdate.fromJson(Map<String, dynamic> json) =
      _$ConversationUpdateImpl.fromJson;

  @override
  String get conversationId;
  @override
  ConversationTurn get turn;
  @override
  ConversationContext get updatedContext;
  @override
  ConversationUpdateType get updateType;

  /// Create a copy of ConversationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationUpdateImplCopyWith<_$ConversationUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicFrequency _$TopicFrequencyFromJson(Map<String, dynamic> json) {
  return _TopicFrequency.fromJson(json);
}

/// @nodoc
mixin _$TopicFrequency {
  String get topic => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;

  /// Serializes this TopicFrequency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicFrequencyCopyWith<TopicFrequency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicFrequencyCopyWith<$Res> {
  factory $TopicFrequencyCopyWith(
          TopicFrequency value, $Res Function(TopicFrequency) then) =
      _$TopicFrequencyCopyWithImpl<$Res, TopicFrequency>;
  @useResult
  $Res call({String topic, int frequency});
}

/// @nodoc
class _$TopicFrequencyCopyWithImpl<$Res, $Val extends TopicFrequency>
    implements $TopicFrequencyCopyWith<$Res> {
  _$TopicFrequencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? frequency = null,
  }) {
    return _then(_value.copyWith(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicFrequencyImplCopyWith<$Res>
    implements $TopicFrequencyCopyWith<$Res> {
  factory _$$TopicFrequencyImplCopyWith(_$TopicFrequencyImpl value,
          $Res Function(_$TopicFrequencyImpl) then) =
      __$$TopicFrequencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String topic, int frequency});
}

/// @nodoc
class __$$TopicFrequencyImplCopyWithImpl<$Res>
    extends _$TopicFrequencyCopyWithImpl<$Res, _$TopicFrequencyImpl>
    implements _$$TopicFrequencyImplCopyWith<$Res> {
  __$$TopicFrequencyImplCopyWithImpl(
      _$TopicFrequencyImpl _value, $Res Function(_$TopicFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopicFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? frequency = null,
  }) {
    return _then(_$TopicFrequencyImpl(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicFrequencyImpl implements _TopicFrequency {
  const _$TopicFrequencyImpl({required this.topic, required this.frequency});

  factory _$TopicFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicFrequencyImplFromJson(json);

  @override
  final String topic;
  @override
  final int frequency;

  @override
  String toString() {
    return 'TopicFrequency(topic: $topic, frequency: $frequency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicFrequencyImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, topic, frequency);

  /// Create a copy of TopicFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicFrequencyImplCopyWith<_$TopicFrequencyImpl> get copyWith =>
      __$$TopicFrequencyImplCopyWithImpl<_$TopicFrequencyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicFrequencyImplToJson(
      this,
    );
  }
}

abstract class _TopicFrequency implements TopicFrequency {
  const factory _TopicFrequency(
      {required final String topic,
      required final int frequency}) = _$TopicFrequencyImpl;

  factory _TopicFrequency.fromJson(Map<String, dynamic> json) =
      _$TopicFrequencyImpl.fromJson;

  @override
  String get topic;
  @override
  int get frequency;

  /// Create a copy of TopicFrequency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicFrequencyImplCopyWith<_$TopicFrequencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationStats _$ConversationStatsFromJson(Map<String, dynamic> json) {
  return _ConversationStats.fromJson(json);
}

/// @nodoc
mixin _$ConversationStats {
  String get userId => throw _privateConstructorUsedError;
  int get totalConversations => throw _privateConstructorUsedError;
  int get totalTurns => throw _privateConstructorUsedError;
  double get averageTurnsPerConversation => throw _privateConstructorUsedError;
  List<TopicFrequency> get mostDiscussedTopics =>
      throw _privateConstructorUsedError;
  DateTime? get lastConversationDate => throw _privateConstructorUsedError;

  /// Serializes this ConversationStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationStatsCopyWith<ConversationStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationStatsCopyWith<$Res> {
  factory $ConversationStatsCopyWith(
          ConversationStats value, $Res Function(ConversationStats) then) =
      _$ConversationStatsCopyWithImpl<$Res, ConversationStats>;
  @useResult
  $Res call(
      {String userId,
      int totalConversations,
      int totalTurns,
      double averageTurnsPerConversation,
      List<TopicFrequency> mostDiscussedTopics,
      DateTime? lastConversationDate});
}

/// @nodoc
class _$ConversationStatsCopyWithImpl<$Res, $Val extends ConversationStats>
    implements $ConversationStatsCopyWith<$Res> {
  _$ConversationStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalConversations = null,
    Object? totalTurns = null,
    Object? averageTurnsPerConversation = null,
    Object? mostDiscussedTopics = null,
    Object? lastConversationDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalConversations: null == totalConversations
          ? _value.totalConversations
          : totalConversations // ignore: cast_nullable_to_non_nullable
              as int,
      totalTurns: null == totalTurns
          ? _value.totalTurns
          : totalTurns // ignore: cast_nullable_to_non_nullable
              as int,
      averageTurnsPerConversation: null == averageTurnsPerConversation
          ? _value.averageTurnsPerConversation
          : averageTurnsPerConversation // ignore: cast_nullable_to_non_nullable
              as double,
      mostDiscussedTopics: null == mostDiscussedTopics
          ? _value.mostDiscussedTopics
          : mostDiscussedTopics // ignore: cast_nullable_to_non_nullable
              as List<TopicFrequency>,
      lastConversationDate: freezed == lastConversationDate
          ? _value.lastConversationDate
          : lastConversationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationStatsImplCopyWith<$Res>
    implements $ConversationStatsCopyWith<$Res> {
  factory _$$ConversationStatsImplCopyWith(_$ConversationStatsImpl value,
          $Res Function(_$ConversationStatsImpl) then) =
      __$$ConversationStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int totalConversations,
      int totalTurns,
      double averageTurnsPerConversation,
      List<TopicFrequency> mostDiscussedTopics,
      DateTime? lastConversationDate});
}

/// @nodoc
class __$$ConversationStatsImplCopyWithImpl<$Res>
    extends _$ConversationStatsCopyWithImpl<$Res, _$ConversationStatsImpl>
    implements _$$ConversationStatsImplCopyWith<$Res> {
  __$$ConversationStatsImplCopyWithImpl(_$ConversationStatsImpl _value,
      $Res Function(_$ConversationStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalConversations = null,
    Object? totalTurns = null,
    Object? averageTurnsPerConversation = null,
    Object? mostDiscussedTopics = null,
    Object? lastConversationDate = freezed,
  }) {
    return _then(_$ConversationStatsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalConversations: null == totalConversations
          ? _value.totalConversations
          : totalConversations // ignore: cast_nullable_to_non_nullable
              as int,
      totalTurns: null == totalTurns
          ? _value.totalTurns
          : totalTurns // ignore: cast_nullable_to_non_nullable
              as int,
      averageTurnsPerConversation: null == averageTurnsPerConversation
          ? _value.averageTurnsPerConversation
          : averageTurnsPerConversation // ignore: cast_nullable_to_non_nullable
              as double,
      mostDiscussedTopics: null == mostDiscussedTopics
          ? _value._mostDiscussedTopics
          : mostDiscussedTopics // ignore: cast_nullable_to_non_nullable
              as List<TopicFrequency>,
      lastConversationDate: freezed == lastConversationDate
          ? _value.lastConversationDate
          : lastConversationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationStatsImpl implements _ConversationStats {
  const _$ConversationStatsImpl(
      {required this.userId,
      required this.totalConversations,
      required this.totalTurns,
      required this.averageTurnsPerConversation,
      required final List<TopicFrequency> mostDiscussedTopics,
      this.lastConversationDate})
      : _mostDiscussedTopics = mostDiscussedTopics;

  factory _$ConversationStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationStatsImplFromJson(json);

  @override
  final String userId;
  @override
  final int totalConversations;
  @override
  final int totalTurns;
  @override
  final double averageTurnsPerConversation;
  final List<TopicFrequency> _mostDiscussedTopics;
  @override
  List<TopicFrequency> get mostDiscussedTopics {
    if (_mostDiscussedTopics is EqualUnmodifiableListView)
      return _mostDiscussedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mostDiscussedTopics);
  }

  @override
  final DateTime? lastConversationDate;

  @override
  String toString() {
    return 'ConversationStats(userId: $userId, totalConversations: $totalConversations, totalTurns: $totalTurns, averageTurnsPerConversation: $averageTurnsPerConversation, mostDiscussedTopics: $mostDiscussedTopics, lastConversationDate: $lastConversationDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalConversations, totalConversations) ||
                other.totalConversations == totalConversations) &&
            (identical(other.totalTurns, totalTurns) ||
                other.totalTurns == totalTurns) &&
            (identical(other.averageTurnsPerConversation,
                    averageTurnsPerConversation) ||
                other.averageTurnsPerConversation ==
                    averageTurnsPerConversation) &&
            const DeepCollectionEquality()
                .equals(other._mostDiscussedTopics, _mostDiscussedTopics) &&
            (identical(other.lastConversationDate, lastConversationDate) ||
                other.lastConversationDate == lastConversationDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalConversations,
      totalTurns,
      averageTurnsPerConversation,
      const DeepCollectionEquality().hash(_mostDiscussedTopics),
      lastConversationDate);

  /// Create a copy of ConversationStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationStatsImplCopyWith<_$ConversationStatsImpl> get copyWith =>
      __$$ConversationStatsImplCopyWithImpl<_$ConversationStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationStatsImplToJson(
      this,
    );
  }
}

abstract class _ConversationStats implements ConversationStats {
  const factory _ConversationStats(
      {required final String userId,
      required final int totalConversations,
      required final int totalTurns,
      required final double averageTurnsPerConversation,
      required final List<TopicFrequency> mostDiscussedTopics,
      final DateTime? lastConversationDate}) = _$ConversationStatsImpl;

  factory _ConversationStats.fromJson(Map<String, dynamic> json) =
      _$ConversationStatsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalConversations;
  @override
  int get totalTurns;
  @override
  double get averageTurnsPerConversation;
  @override
  List<TopicFrequency> get mostDiscussedTopics;
  @override
  DateTime? get lastConversationDate;

  /// Create a copy of ConversationStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationStatsImplCopyWith<_$ConversationStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VoiceQueryResult _$VoiceQueryResultFromJson(Map<String, dynamic> json) {
  return _VoiceQueryResult.fromJson(json);
}

/// @nodoc
mixin _$VoiceQueryResult {
  String get transcription => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String get detectedLanguage => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  bool get containsArabic => throw _privateConstructorUsedError;
  List<String> get alternatives => throw _privateConstructorUsedError;
  Map<String, dynamic> get audioMetadata => throw _privateConstructorUsedError;

  /// Serializes this VoiceQueryResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoiceQueryResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoiceQueryResultCopyWith<VoiceQueryResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceQueryResultCopyWith<$Res> {
  factory $VoiceQueryResultCopyWith(
          VoiceQueryResult value, $Res Function(VoiceQueryResult) then) =
      _$VoiceQueryResultCopyWithImpl<$Res, VoiceQueryResult>;
  @useResult
  $Res call(
      {String transcription,
      double confidence,
      String detectedLanguage,
      Duration duration,
      bool containsArabic,
      List<String> alternatives,
      Map<String, dynamic> audioMetadata});
}

/// @nodoc
class _$VoiceQueryResultCopyWithImpl<$Res, $Val extends VoiceQueryResult>
    implements $VoiceQueryResultCopyWith<$Res> {
  _$VoiceQueryResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoiceQueryResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcription = null,
    Object? confidence = null,
    Object? detectedLanguage = null,
    Object? duration = null,
    Object? containsArabic = null,
    Object? alternatives = null,
    Object? audioMetadata = null,
  }) {
    return _then(_value.copyWith(
      transcription: null == transcription
          ? _value.transcription
          : transcription // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      detectedLanguage: null == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      containsArabic: null == containsArabic
          ? _value.containsArabic
          : containsArabic // ignore: cast_nullable_to_non_nullable
              as bool,
      alternatives: null == alternatives
          ? _value.alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioMetadata: null == audioMetadata
          ? _value.audioMetadata
          : audioMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoiceQueryResultImplCopyWith<$Res>
    implements $VoiceQueryResultCopyWith<$Res> {
  factory _$$VoiceQueryResultImplCopyWith(_$VoiceQueryResultImpl value,
          $Res Function(_$VoiceQueryResultImpl) then) =
      __$$VoiceQueryResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String transcription,
      double confidence,
      String detectedLanguage,
      Duration duration,
      bool containsArabic,
      List<String> alternatives,
      Map<String, dynamic> audioMetadata});
}

/// @nodoc
class __$$VoiceQueryResultImplCopyWithImpl<$Res>
    extends _$VoiceQueryResultCopyWithImpl<$Res, _$VoiceQueryResultImpl>
    implements _$$VoiceQueryResultImplCopyWith<$Res> {
  __$$VoiceQueryResultImplCopyWithImpl(_$VoiceQueryResultImpl _value,
      $Res Function(_$VoiceQueryResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of VoiceQueryResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcription = null,
    Object? confidence = null,
    Object? detectedLanguage = null,
    Object? duration = null,
    Object? containsArabic = null,
    Object? alternatives = null,
    Object? audioMetadata = null,
  }) {
    return _then(_$VoiceQueryResultImpl(
      transcription: null == transcription
          ? _value.transcription
          : transcription // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      detectedLanguage: null == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      containsArabic: null == containsArabic
          ? _value.containsArabic
          : containsArabic // ignore: cast_nullable_to_non_nullable
              as bool,
      alternatives: null == alternatives
          ? _value._alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioMetadata: null == audioMetadata
          ? _value._audioMetadata
          : audioMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VoiceQueryResultImpl implements _VoiceQueryResult {
  const _$VoiceQueryResultImpl(
      {required this.transcription,
      required this.confidence,
      required this.detectedLanguage,
      required this.duration,
      required this.containsArabic,
      required final List<String> alternatives,
      required final Map<String, dynamic> audioMetadata})
      : _alternatives = alternatives,
        _audioMetadata = audioMetadata;

  factory _$VoiceQueryResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoiceQueryResultImplFromJson(json);

  @override
  final String transcription;
  @override
  final double confidence;
  @override
  final String detectedLanguage;
  @override
  final Duration duration;
  @override
  final bool containsArabic;
  final List<String> _alternatives;
  @override
  List<String> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  final Map<String, dynamic> _audioMetadata;
  @override
  Map<String, dynamic> get audioMetadata {
    if (_audioMetadata is EqualUnmodifiableMapView) return _audioMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_audioMetadata);
  }

  @override
  String toString() {
    return 'VoiceQueryResult(transcription: $transcription, confidence: $confidence, detectedLanguage: $detectedLanguage, duration: $duration, containsArabic: $containsArabic, alternatives: $alternatives, audioMetadata: $audioMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceQueryResultImpl &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.detectedLanguage, detectedLanguage) ||
                other.detectedLanguage == detectedLanguage) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.containsArabic, containsArabic) ||
                other.containsArabic == containsArabic) &&
            const DeepCollectionEquality()
                .equals(other._alternatives, _alternatives) &&
            const DeepCollectionEquality()
                .equals(other._audioMetadata, _audioMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      transcription,
      confidence,
      detectedLanguage,
      duration,
      containsArabic,
      const DeepCollectionEquality().hash(_alternatives),
      const DeepCollectionEquality().hash(_audioMetadata));

  /// Create a copy of VoiceQueryResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceQueryResultImplCopyWith<_$VoiceQueryResultImpl> get copyWith =>
      __$$VoiceQueryResultImplCopyWithImpl<_$VoiceQueryResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoiceQueryResultImplToJson(
      this,
    );
  }
}

abstract class _VoiceQueryResult implements VoiceQueryResult {
  const factory _VoiceQueryResult(
          {required final String transcription,
          required final double confidence,
          required final String detectedLanguage,
          required final Duration duration,
          required final bool containsArabic,
          required final List<String> alternatives,
          required final Map<String, dynamic> audioMetadata}) =
      _$VoiceQueryResultImpl;

  factory _VoiceQueryResult.fromJson(Map<String, dynamic> json) =
      _$VoiceQueryResultImpl.fromJson;

  @override
  String get transcription;
  @override
  double get confidence;
  @override
  String get detectedLanguage;
  @override
  Duration get duration;
  @override
  bool get containsArabic;
  @override
  List<String> get alternatives;
  @override
  Map<String, dynamic> get audioMetadata;

  /// Create a copy of VoiceQueryResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceQueryResultImplCopyWith<_$VoiceQueryResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
  String get detectedContext => throw _privateConstructorUsedError;
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
          ContextualInput value, $Res Function(ContextualInput) then) =
      _$ContextualInputCopyWithImpl<$Res, ContextualInput>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String rawInput,
      List<String> processedKeywords,
      EmotionalState detectedEmotion,
      String detectedContext,
      double emotionConfidence,
      double contextConfidence,
      Map<String, dynamic> nlpAnalysis,
      DateTime timestamp,
      bool isEncrypted,
      String? encryptionKey});
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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      rawInput: null == rawInput
          ? _value.rawInput
          : rawInput // ignore: cast_nullable_to_non_nullable
              as String,
      processedKeywords: null == processedKeywords
          ? _value.processedKeywords
          : processedKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      detectedEmotion: null == detectedEmotion
          ? _value.detectedEmotion
          : detectedEmotion // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      detectedContext: null == detectedContext
          ? _value.detectedContext
          : detectedContext // ignore: cast_nullable_to_non_nullable
              as String,
      emotionConfidence: null == emotionConfidence
          ? _value.emotionConfidence
          : emotionConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      contextConfidence: null == contextConfidence
          ? _value.contextConfidence
          : contextConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      nlpAnalysis: null == nlpAnalysis
          ? _value.nlpAnalysis
          : nlpAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptionKey: freezed == encryptionKey
          ? _value.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContextualInputImplCopyWith<$Res>
    implements $ContextualInputCopyWith<$Res> {
  factory _$$ContextualInputImplCopyWith(_$ContextualInputImpl value,
          $Res Function(_$ContextualInputImpl) then) =
      __$$ContextualInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String rawInput,
      List<String> processedKeywords,
      EmotionalState detectedEmotion,
      String detectedContext,
      double emotionConfidence,
      double contextConfidence,
      Map<String, dynamic> nlpAnalysis,
      DateTime timestamp,
      bool isEncrypted,
      String? encryptionKey});
}

/// @nodoc
class __$$ContextualInputImplCopyWithImpl<$Res>
    extends _$ContextualInputCopyWithImpl<$Res, _$ContextualInputImpl>
    implements _$$ContextualInputImplCopyWith<$Res> {
  __$$ContextualInputImplCopyWithImpl(
      _$ContextualInputImpl _value, $Res Function(_$ContextualInputImpl) _then)
      : super(_value, _then);

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
    return _then(_$ContextualInputImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      rawInput: null == rawInput
          ? _value.rawInput
          : rawInput // ignore: cast_nullable_to_non_nullable
              as String,
      processedKeywords: null == processedKeywords
          ? _value._processedKeywords
          : processedKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      detectedEmotion: null == detectedEmotion
          ? _value.detectedEmotion
          : detectedEmotion // ignore: cast_nullable_to_non_nullable
              as EmotionalState,
      detectedContext: null == detectedContext
          ? _value.detectedContext
          : detectedContext // ignore: cast_nullable_to_non_nullable
              as String,
      emotionConfidence: null == emotionConfidence
          ? _value.emotionConfidence
          : emotionConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      contextConfidence: null == contextConfidence
          ? _value.contextConfidence
          : contextConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      nlpAnalysis: null == nlpAnalysis
          ? _value._nlpAnalysis
          : nlpAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptionKey: freezed == encryptionKey
          ? _value.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContextualInputImpl implements _ContextualInput {
  const _$ContextualInputImpl(
      {required this.id,
      required this.userId,
      required this.rawInput,
      required final List<String> processedKeywords,
      required this.detectedEmotion,
      required this.detectedContext,
      required this.emotionConfidence,
      required this.contextConfidence,
      required final Map<String, dynamic> nlpAnalysis,
      required this.timestamp,
      required this.isEncrypted,
      this.encryptionKey})
      : _processedKeywords = processedKeywords,
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
  final String detectedContext;
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
            const DeepCollectionEquality()
                .equals(other._processedKeywords, _processedKeywords) &&
            (identical(other.detectedEmotion, detectedEmotion) ||
                other.detectedEmotion == detectedEmotion) &&
            (identical(other.detectedContext, detectedContext) ||
                other.detectedContext == detectedContext) &&
            (identical(other.emotionConfidence, emotionConfidence) ||
                other.emotionConfidence == emotionConfidence) &&
            (identical(other.contextConfidence, contextConfidence) ||
                other.contextConfidence == contextConfidence) &&
            const DeepCollectionEquality()
                .equals(other._nlpAnalysis, _nlpAnalysis) &&
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
      encryptionKey);

  /// Create a copy of ContextualInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextualInputImplCopyWith<_$ContextualInputImpl> get copyWith =>
      __$$ContextualInputImplCopyWithImpl<_$ContextualInputImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContextualInputImplToJson(
      this,
    );
  }
}

abstract class _ContextualInput implements ContextualInput {
  const factory _ContextualInput(
      {required final String id,
      required final String userId,
      required final String rawInput,
      required final List<String> processedKeywords,
      required final EmotionalState detectedEmotion,
      required final String detectedContext,
      required final double emotionConfidence,
      required final double contextConfidence,
      required final Map<String, dynamic> nlpAnalysis,
      required final DateTime timestamp,
      required final bool isEncrypted,
      final String? encryptionKey}) = _$ContextualInputImpl;

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
  String get detectedContext;
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

ProactiveSuggestion _$ProactiveSuggestionFromJson(Map<String, dynamic> json) {
  return _ProactiveSuggestion.fromJson(json);
}

/// @nodoc
mixin _$ProactiveSuggestion {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get suggestionText => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;
  DateTime get suggestedAt => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  Map<String, dynamic> get context => throw _privateConstructorUsedError;
  bool get isShown => throw _privateConstructorUsedError;
  bool get isAccepted => throw _privateConstructorUsedError;
  DateTime? get shownAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this ProactiveSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProactiveSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProactiveSuggestionCopyWith<ProactiveSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProactiveSuggestionCopyWith<$Res> {
  factory $ProactiveSuggestionCopyWith(
          ProactiveSuggestion value, $Res Function(ProactiveSuggestion) then) =
      _$ProactiveSuggestionCopyWithImpl<$Res, ProactiveSuggestion>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String suggestionText,
      String reason,
      double relevanceScore,
      DateTime suggestedAt,
      String category,
      Map<String, dynamic> context,
      bool isShown,
      bool isAccepted,
      DateTime? shownAt,
      DateTime? respondedAt});
}

/// @nodoc
class _$ProactiveSuggestionCopyWithImpl<$Res, $Val extends ProactiveSuggestion>
    implements $ProactiveSuggestionCopyWith<$Res> {
  _$ProactiveSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProactiveSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? suggestionText = null,
    Object? reason = null,
    Object? relevanceScore = null,
    Object? suggestedAt = null,
    Object? category = null,
    Object? context = null,
    Object? isShown = null,
    Object? isAccepted = null,
    Object? shownAt = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      suggestionText: null == suggestionText
          ? _value.suggestionText
          : suggestionText // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      relevanceScore: null == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      suggestedAt: null == suggestedAt
          ? _value.suggestedAt
          : suggestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      shownAt: freezed == shownAt
          ? _value.shownAt
          : shownAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProactiveSuggestionImplCopyWith<$Res>
    implements $ProactiveSuggestionCopyWith<$Res> {
  factory _$$ProactiveSuggestionImplCopyWith(_$ProactiveSuggestionImpl value,
          $Res Function(_$ProactiveSuggestionImpl) then) =
      __$$ProactiveSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String suggestionText,
      String reason,
      double relevanceScore,
      DateTime suggestedAt,
      String category,
      Map<String, dynamic> context,
      bool isShown,
      bool isAccepted,
      DateTime? shownAt,
      DateTime? respondedAt});
}

/// @nodoc
class __$$ProactiveSuggestionImplCopyWithImpl<$Res>
    extends _$ProactiveSuggestionCopyWithImpl<$Res, _$ProactiveSuggestionImpl>
    implements _$$ProactiveSuggestionImplCopyWith<$Res> {
  __$$ProactiveSuggestionImplCopyWithImpl(_$ProactiveSuggestionImpl _value,
      $Res Function(_$ProactiveSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProactiveSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? suggestionText = null,
    Object? reason = null,
    Object? relevanceScore = null,
    Object? suggestedAt = null,
    Object? category = null,
    Object? context = null,
    Object? isShown = null,
    Object? isAccepted = null,
    Object? shownAt = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_$ProactiveSuggestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      suggestionText: null == suggestionText
          ? _value.suggestionText
          : suggestionText // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      relevanceScore: null == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      suggestedAt: null == suggestedAt
          ? _value.suggestedAt
          : suggestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      context: null == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      shownAt: freezed == shownAt
          ? _value.shownAt
          : shownAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProactiveSuggestionImpl implements _ProactiveSuggestion {
  const _$ProactiveSuggestionImpl(
      {required this.id,
      required this.userId,
      required this.suggestionText,
      required this.reason,
      required this.relevanceScore,
      required this.suggestedAt,
      required this.category,
      required final Map<String, dynamic> context,
      this.isShown = false,
      this.isAccepted = false,
      this.shownAt,
      this.respondedAt})
      : _context = context;

  factory _$ProactiveSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProactiveSuggestionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String suggestionText;
  @override
  final String reason;
  @override
  final double relevanceScore;
  @override
  final DateTime suggestedAt;
  @override
  final String category;
  final Map<String, dynamic> _context;
  @override
  Map<String, dynamic> get context {
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_context);
  }

  @override
  @JsonKey()
  final bool isShown;
  @override
  @JsonKey()
  final bool isAccepted;
  @override
  final DateTime? shownAt;
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'ProactiveSuggestion(id: $id, userId: $userId, suggestionText: $suggestionText, reason: $reason, relevanceScore: $relevanceScore, suggestedAt: $suggestedAt, category: $category, context: $context, isShown: $isShown, isAccepted: $isAccepted, shownAt: $shownAt, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProactiveSuggestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.suggestionText, suggestionText) ||
                other.suggestionText == suggestionText) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            (identical(other.suggestedAt, suggestedAt) ||
                other.suggestedAt == suggestedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            (identical(other.isShown, isShown) || other.isShown == isShown) &&
            (identical(other.isAccepted, isAccepted) ||
                other.isAccepted == isAccepted) &&
            (identical(other.shownAt, shownAt) || other.shownAt == shownAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      suggestionText,
      reason,
      relevanceScore,
      suggestedAt,
      category,
      const DeepCollectionEquality().hash(_context),
      isShown,
      isAccepted,
      shownAt,
      respondedAt);

  /// Create a copy of ProactiveSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProactiveSuggestionImplCopyWith<_$ProactiveSuggestionImpl> get copyWith =>
      __$$ProactiveSuggestionImplCopyWithImpl<_$ProactiveSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProactiveSuggestionImplToJson(
      this,
    );
  }
}

abstract class _ProactiveSuggestion implements ProactiveSuggestion {
  const factory _ProactiveSuggestion(
      {required final String id,
      required final String userId,
      required final String suggestionText,
      required final String reason,
      required final double relevanceScore,
      required final DateTime suggestedAt,
      required final String category,
      required final Map<String, dynamic> context,
      final bool isShown,
      final bool isAccepted,
      final DateTime? shownAt,
      final DateTime? respondedAt}) = _$ProactiveSuggestionImpl;

  factory _ProactiveSuggestion.fromJson(Map<String, dynamic> json) =
      _$ProactiveSuggestionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get suggestionText;
  @override
  String get reason;
  @override
  double get relevanceScore;
  @override
  DateTime get suggestedAt;
  @override
  String get category;
  @override
  Map<String, dynamic> get context;
  @override
  bool get isShown;
  @override
  bool get isAccepted;
  @override
  DateTime? get shownAt;
  @override
  DateTime? get respondedAt;

  /// Create a copy of ProactiveSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProactiveSuggestionImplCopyWith<_$ProactiveSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return _CalendarEvent.fromJson(json);
}

/// @nodoc
mixin _$CalendarEvent {
  String get eventId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  bool get isIslamicEvent => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  List<String>? get suggestedDuas => throw _privateConstructorUsedError;

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
          CalendarEvent value, $Res Function(CalendarEvent) then) =
      _$CalendarEventCopyWithImpl<$Res, CalendarEvent>;
  @useResult
  $Res call(
      {String eventId,
      String title,
      DateTime startTime,
      DateTime endTime,
      String description,
      String location,
      bool isIslamicEvent,
      Map<String, dynamic> metadata,
      List<String>? suggestedDuas});
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res, $Val extends CalendarEvent>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = null,
    Object? location = null,
    Object? isIslamicEvent = null,
    Object? metadata = null,
    Object? suggestedDuas = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      isIslamicEvent: null == isIslamicEvent
          ? _value.isIslamicEvent
          : isIslamicEvent // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      suggestedDuas: freezed == suggestedDuas
          ? _value.suggestedDuas
          : suggestedDuas // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarEventImplCopyWith<$Res>
    implements $CalendarEventCopyWith<$Res> {
  factory _$$CalendarEventImplCopyWith(
          _$CalendarEventImpl value, $Res Function(_$CalendarEventImpl) then) =
      __$$CalendarEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      String title,
      DateTime startTime,
      DateTime endTime,
      String description,
      String location,
      bool isIslamicEvent,
      Map<String, dynamic> metadata,
      List<String>? suggestedDuas});
}

/// @nodoc
class __$$CalendarEventImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventImpl>
    implements _$$CalendarEventImplCopyWith<$Res> {
  __$$CalendarEventImplCopyWithImpl(
      _$CalendarEventImpl _value, $Res Function(_$CalendarEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = null,
    Object? location = null,
    Object? isIslamicEvent = null,
    Object? metadata = null,
    Object? suggestedDuas = freezed,
  }) {
    return _then(_$CalendarEventImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      isIslamicEvent: null == isIslamicEvent
          ? _value.isIslamicEvent
          : isIslamicEvent // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      suggestedDuas: freezed == suggestedDuas
          ? _value._suggestedDuas
          : suggestedDuas // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarEventImpl implements _CalendarEvent {
  const _$CalendarEventImpl(
      {required this.eventId,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.description,
      required this.location,
      required this.isIslamicEvent,
      required final Map<String, dynamic> metadata,
      final List<String>? suggestedDuas})
      : _metadata = metadata,
        _suggestedDuas = suggestedDuas;

  factory _$CalendarEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventImplFromJson(json);

  @override
  final String eventId;
  @override
  final String title;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String description;
  @override
  final String location;
  @override
  final bool isIslamicEvent;
  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  final List<String>? _suggestedDuas;
  @override
  List<String>? get suggestedDuas {
    final value = _suggestedDuas;
    if (value == null) return null;
    if (_suggestedDuas is EqualUnmodifiableListView) return _suggestedDuas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CalendarEvent(eventId: $eventId, title: $title, startTime: $startTime, endTime: $endTime, description: $description, location: $location, isIslamicEvent: $isIslamicEvent, metadata: $metadata, suggestedDuas: $suggestedDuas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isIslamicEvent, isIslamicEvent) ||
                other.isIslamicEvent == isIslamicEvent) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            const DeepCollectionEquality()
                .equals(other._suggestedDuas, _suggestedDuas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      title,
      startTime,
      endTime,
      description,
      location,
      isIslamicEvent,
      const DeepCollectionEquality().hash(_metadata),
      const DeepCollectionEquality().hash(_suggestedDuas));

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      __$$CalendarEventImplCopyWithImpl<_$CalendarEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventImplToJson(
      this,
    );
  }
}

abstract class _CalendarEvent implements CalendarEvent {
  const factory _CalendarEvent(
      {required final String eventId,
      required final String title,
      required final DateTime startTime,
      required final DateTime endTime,
      required final String description,
      required final String location,
      required final bool isIslamicEvent,
      required final Map<String, dynamic> metadata,
      final List<String>? suggestedDuas}) = _$CalendarEventImpl;

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) =
      _$CalendarEventImpl.fromJson;

  @override
  String get eventId;
  @override
  String get title;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get description;
  @override
  String get location;
  @override
  bool get isIslamicEvent;
  @override
  Map<String, dynamic> get metadata;
  @override
  List<String>? get suggestedDuas;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CulturalContext _$CulturalContextFromJson(Map<String, dynamic> json) {
  return _CulturalContext.fromJson(json);
}

/// @nodoc
mixin _$CulturalContext {
  String get userId => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  String get primaryLanguage => throw _privateConstructorUsedError;
  List<String> get preferredLanguages => throw _privateConstructorUsedError;
  String get islamicSchool => throw _privateConstructorUsedError;
  Map<String, dynamic> get culturalPreferences =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this CulturalContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CulturalContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CulturalContextCopyWith<CulturalContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CulturalContextCopyWith<$Res> {
  factory $CulturalContextCopyWith(
          CulturalContext value, $Res Function(CulturalContext) then) =
      _$CulturalContextCopyWithImpl<$Res, CulturalContext>;
  @useResult
  $Res call(
      {String userId,
      String country,
      String region,
      String primaryLanguage,
      List<String> preferredLanguages,
      String islamicSchool,
      Map<String, dynamic> culturalPreferences,
      DateTime lastUpdated});
}

/// @nodoc
class _$CulturalContextCopyWithImpl<$Res, $Val extends CulturalContext>
    implements $CulturalContextCopyWith<$Res> {
  _$CulturalContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CulturalContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? country = null,
    Object? region = null,
    Object? primaryLanguage = null,
    Object? preferredLanguages = null,
    Object? islamicSchool = null,
    Object? culturalPreferences = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLanguage: null == primaryLanguage
          ? _value.primaryLanguage
          : primaryLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      preferredLanguages: null == preferredLanguages
          ? _value.preferredLanguages
          : preferredLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      islamicSchool: null == islamicSchool
          ? _value.islamicSchool
          : islamicSchool // ignore: cast_nullable_to_non_nullable
              as String,
      culturalPreferences: null == culturalPreferences
          ? _value.culturalPreferences
          : culturalPreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CulturalContextImplCopyWith<$Res>
    implements $CulturalContextCopyWith<$Res> {
  factory _$$CulturalContextImplCopyWith(_$CulturalContextImpl value,
          $Res Function(_$CulturalContextImpl) then) =
      __$$CulturalContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String country,
      String region,
      String primaryLanguage,
      List<String> preferredLanguages,
      String islamicSchool,
      Map<String, dynamic> culturalPreferences,
      DateTime lastUpdated});
}

/// @nodoc
class __$$CulturalContextImplCopyWithImpl<$Res>
    extends _$CulturalContextCopyWithImpl<$Res, _$CulturalContextImpl>
    implements _$$CulturalContextImplCopyWith<$Res> {
  __$$CulturalContextImplCopyWithImpl(
      _$CulturalContextImpl _value, $Res Function(_$CulturalContextImpl) _then)
      : super(_value, _then);

  /// Create a copy of CulturalContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? country = null,
    Object? region = null,
    Object? primaryLanguage = null,
    Object? preferredLanguages = null,
    Object? islamicSchool = null,
    Object? culturalPreferences = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$CulturalContextImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLanguage: null == primaryLanguage
          ? _value.primaryLanguage
          : primaryLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      preferredLanguages: null == preferredLanguages
          ? _value._preferredLanguages
          : preferredLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      islamicSchool: null == islamicSchool
          ? _value.islamicSchool
          : islamicSchool // ignore: cast_nullable_to_non_nullable
              as String,
      culturalPreferences: null == culturalPreferences
          ? _value._culturalPreferences
          : culturalPreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CulturalContextImpl implements _CulturalContext {
  const _$CulturalContextImpl(
      {required this.userId,
      required this.country,
      required this.region,
      required this.primaryLanguage,
      required final List<String> preferredLanguages,
      required this.islamicSchool,
      required final Map<String, dynamic> culturalPreferences,
      required this.lastUpdated})
      : _preferredLanguages = preferredLanguages,
        _culturalPreferences = culturalPreferences;

  factory _$CulturalContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$CulturalContextImplFromJson(json);

  @override
  final String userId;
  @override
  final String country;
  @override
  final String region;
  @override
  final String primaryLanguage;
  final List<String> _preferredLanguages;
  @override
  List<String> get preferredLanguages {
    if (_preferredLanguages is EqualUnmodifiableListView)
      return _preferredLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredLanguages);
  }

  @override
  final String islamicSchool;
  final Map<String, dynamic> _culturalPreferences;
  @override
  Map<String, dynamic> get culturalPreferences {
    if (_culturalPreferences is EqualUnmodifiableMapView)
      return _culturalPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_culturalPreferences);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'CulturalContext(userId: $userId, country: $country, region: $region, primaryLanguage: $primaryLanguage, preferredLanguages: $preferredLanguages, islamicSchool: $islamicSchool, culturalPreferences: $culturalPreferences, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CulturalContextImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.primaryLanguage, primaryLanguage) ||
                other.primaryLanguage == primaryLanguage) &&
            const DeepCollectionEquality()
                .equals(other._preferredLanguages, _preferredLanguages) &&
            (identical(other.islamicSchool, islamicSchool) ||
                other.islamicSchool == islamicSchool) &&
            const DeepCollectionEquality()
                .equals(other._culturalPreferences, _culturalPreferences) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      country,
      region,
      primaryLanguage,
      const DeepCollectionEquality().hash(_preferredLanguages),
      islamicSchool,
      const DeepCollectionEquality().hash(_culturalPreferences),
      lastUpdated);

  /// Create a copy of CulturalContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CulturalContextImplCopyWith<_$CulturalContextImpl> get copyWith =>
      __$$CulturalContextImplCopyWithImpl<_$CulturalContextImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CulturalContextImplToJson(
      this,
    );
  }
}

abstract class _CulturalContext implements CulturalContext {
  const factory _CulturalContext(
      {required final String userId,
      required final String country,
      required final String region,
      required final String primaryLanguage,
      required final List<String> preferredLanguages,
      required final String islamicSchool,
      required final Map<String, dynamic> culturalPreferences,
      required final DateTime lastUpdated}) = _$CulturalContextImpl;

  factory _CulturalContext.fromJson(Map<String, dynamic> json) =
      _$CulturalContextImpl.fromJson;

  @override
  String get userId;
  @override
  String get country;
  @override
  String get region;
  @override
  String get primaryLanguage;
  @override
  List<String> get preferredLanguages;
  @override
  String get islamicSchool;
  @override
  Map<String, dynamic> get culturalPreferences;
  @override
  DateTime get lastUpdated;

  /// Create a copy of CulturalContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CulturalContextImplCopyWith<_$CulturalContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
