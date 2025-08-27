// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasbih_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TasbihSession _$TasbihSessionFromJson(Map<String, dynamic> json) {
  return _TasbihSession.fromJson(json);
}

/// @nodoc
mixin _$TasbihSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  TasbihType get type => throw _privateConstructorUsedError;
  int get targetCount => throw _privateConstructorUsedError;
  int get currentCount => throw _privateConstructorUsedError;
  List<TasbihEntry> get entries => throw _privateConstructorUsedError;
  TasbihSettings get settings => throw _privateConstructorUsedError;
  TasbihGoal? get goal => throw _privateConstructorUsedError;
  Duration? get totalDuration => throw _privateConstructorUsedError;
  bool? get isCompleted => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this TasbihSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TasbihSessionCopyWith<TasbihSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasbihSessionCopyWith<$Res> {
  factory $TasbihSessionCopyWith(
          TasbihSession value, $Res Function(TasbihSession) then) =
      _$TasbihSessionCopyWithImpl<$Res, TasbihSession>;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime startTime,
      DateTime? endTime,
      TasbihType type,
      int targetCount,
      int currentCount,
      List<TasbihEntry> entries,
      TasbihSettings settings,
      TasbihGoal? goal,
      Duration? totalDuration,
      bool? isCompleted,
      Map<String, dynamic>? metadata});

  $TasbihSettingsCopyWith<$Res> get settings;
  $TasbihGoalCopyWith<$Res>? get goal;
}

/// @nodoc
class _$TasbihSessionCopyWithImpl<$Res, $Val extends TasbihSession>
    implements $TasbihSessionCopyWith<$Res> {
  _$TasbihSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? type = null,
    Object? targetCount = null,
    Object? currentCount = null,
    Object? entries = null,
    Object? settings = null,
    Object? goal = freezed,
    Object? totalDuration = freezed,
    Object? isCompleted = freezed,
    Object? metadata = freezed,
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
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TasbihType,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<TasbihEntry>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TasbihSettings,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as TasbihGoal?,
      totalDuration: freezed == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TasbihSettingsCopyWith<$Res> get settings {
    return $TasbihSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TasbihGoalCopyWith<$Res>? get goal {
    if (_value.goal == null) {
      return null;
    }

    return $TasbihGoalCopyWith<$Res>(_value.goal!, (value) {
      return _then(_value.copyWith(goal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TasbihSessionImplCopyWith<$Res>
    implements $TasbihSessionCopyWith<$Res> {
  factory _$$TasbihSessionImplCopyWith(
          _$TasbihSessionImpl value, $Res Function(_$TasbihSessionImpl) then) =
      __$$TasbihSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime startTime,
      DateTime? endTime,
      TasbihType type,
      int targetCount,
      int currentCount,
      List<TasbihEntry> entries,
      TasbihSettings settings,
      TasbihGoal? goal,
      Duration? totalDuration,
      bool? isCompleted,
      Map<String, dynamic>? metadata});

  @override
  $TasbihSettingsCopyWith<$Res> get settings;
  @override
  $TasbihGoalCopyWith<$Res>? get goal;
}

/// @nodoc
class __$$TasbihSessionImplCopyWithImpl<$Res>
    extends _$TasbihSessionCopyWithImpl<$Res, _$TasbihSessionImpl>
    implements _$$TasbihSessionImplCopyWith<$Res> {
  __$$TasbihSessionImplCopyWithImpl(
      _$TasbihSessionImpl _value, $Res Function(_$TasbihSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? type = null,
    Object? targetCount = null,
    Object? currentCount = null,
    Object? entries = null,
    Object? settings = null,
    Object? goal = freezed,
    Object? totalDuration = freezed,
    Object? isCompleted = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$TasbihSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TasbihType,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<TasbihEntry>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TasbihSettings,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as TasbihGoal?,
      totalDuration: freezed == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasbihSessionImpl implements _TasbihSession {
  const _$TasbihSessionImpl(
      {required this.id,
      required this.userId,
      required this.startTime,
      this.endTime,
      required this.type,
      required this.targetCount,
      required this.currentCount,
      required final List<TasbihEntry> entries,
      required this.settings,
      this.goal,
      this.totalDuration,
      this.isCompleted,
      final Map<String, dynamic>? metadata})
      : _entries = entries,
        _metadata = metadata;

  factory _$TasbihSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasbihSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final TasbihType type;
  @override
  final int targetCount;
  @override
  final int currentCount;
  final List<TasbihEntry> _entries;
  @override
  List<TasbihEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final TasbihSettings settings;
  @override
  final TasbihGoal? goal;
  @override
  final Duration? totalDuration;
  @override
  final bool? isCompleted;
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
    return 'TasbihSession(id: $id, userId: $userId, startTime: $startTime, endTime: $endTime, type: $type, targetCount: $targetCount, currentCount: $currentCount, entries: $entries, settings: $settings, goal: $goal, totalDuration: $totalDuration, isCompleted: $isCompleted, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasbihSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            (identical(other.currentCount, currentCount) ||
                other.currentCount == currentCount) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      startTime,
      endTime,
      type,
      targetCount,
      currentCount,
      const DeepCollectionEquality().hash(_entries),
      settings,
      goal,
      totalDuration,
      isCompleted,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TasbihSessionImplCopyWith<_$TasbihSessionImpl> get copyWith =>
      __$$TasbihSessionImplCopyWithImpl<_$TasbihSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasbihSessionImplToJson(
      this,
    );
  }
}

abstract class _TasbihSession implements TasbihSession {
  const factory _TasbihSession(
      {required final String id,
      required final String userId,
      required final DateTime startTime,
      final DateTime? endTime,
      required final TasbihType type,
      required final int targetCount,
      required final int currentCount,
      required final List<TasbihEntry> entries,
      required final TasbihSettings settings,
      final TasbihGoal? goal,
      final Duration? totalDuration,
      final bool? isCompleted,
      final Map<String, dynamic>? metadata}) = _$TasbihSessionImpl;

  factory _TasbihSession.fromJson(Map<String, dynamic> json) =
      _$TasbihSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  TasbihType get type;
  @override
  int get targetCount;
  @override
  int get currentCount;
  @override
  List<TasbihEntry> get entries;
  @override
  TasbihSettings get settings;
  @override
  TasbihGoal? get goal;
  @override
  Duration? get totalDuration;
  @override
  bool? get isCompleted;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of TasbihSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TasbihSessionImplCopyWith<_$TasbihSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TasbihEntry _$TasbihEntryFromJson(Map<String, dynamic> json) {
  return _TasbihEntry.fromJson(json);
}

/// @nodoc
mixin _$TasbihEntry {
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  InputMethod get inputMethod => throw _privateConstructorUsedError;
  String? get dhikrText => throw _privateConstructorUsedError;
  Duration? get timeSinceLastEntry => throw _privateConstructorUsedError;
  bool? get isAutoDetected => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;

  /// Serializes this TasbihEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TasbihEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TasbihEntryCopyWith<TasbihEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasbihEntryCopyWith<$Res> {
  factory $TasbihEntryCopyWith(
          TasbihEntry value, $Res Function(TasbihEntry) then) =
      _$TasbihEntryCopyWithImpl<$Res, TasbihEntry>;
  @useResult
  $Res call(
      {DateTime timestamp,
      int count,
      InputMethod inputMethod,
      String? dhikrText,
      Duration? timeSinceLastEntry,
      bool? isAutoDetected,
      double? confidence});
}

/// @nodoc
class _$TasbihEntryCopyWithImpl<$Res, $Val extends TasbihEntry>
    implements $TasbihEntryCopyWith<$Res> {
  _$TasbihEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TasbihEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? count = null,
    Object? inputMethod = null,
    Object? dhikrText = freezed,
    Object? timeSinceLastEntry = freezed,
    Object? isAutoDetected = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      inputMethod: null == inputMethod
          ? _value.inputMethod
          : inputMethod // ignore: cast_nullable_to_non_nullable
              as InputMethod,
      dhikrText: freezed == dhikrText
          ? _value.dhikrText
          : dhikrText // ignore: cast_nullable_to_non_nullable
              as String?,
      timeSinceLastEntry: freezed == timeSinceLastEntry
          ? _value.timeSinceLastEntry
          : timeSinceLastEntry // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isAutoDetected: freezed == isAutoDetected
          ? _value.isAutoDetected
          : isAutoDetected // ignore: cast_nullable_to_non_nullable
              as bool?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasbihEntryImplCopyWith<$Res>
    implements $TasbihEntryCopyWith<$Res> {
  factory _$$TasbihEntryImplCopyWith(
          _$TasbihEntryImpl value, $Res Function(_$TasbihEntryImpl) then) =
      __$$TasbihEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      int count,
      InputMethod inputMethod,
      String? dhikrText,
      Duration? timeSinceLastEntry,
      bool? isAutoDetected,
      double? confidence});
}

/// @nodoc
class __$$TasbihEntryImplCopyWithImpl<$Res>
    extends _$TasbihEntryCopyWithImpl<$Res, _$TasbihEntryImpl>
    implements _$$TasbihEntryImplCopyWith<$Res> {
  __$$TasbihEntryImplCopyWithImpl(
      _$TasbihEntryImpl _value, $Res Function(_$TasbihEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TasbihEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? count = null,
    Object? inputMethod = null,
    Object? dhikrText = freezed,
    Object? timeSinceLastEntry = freezed,
    Object? isAutoDetected = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_$TasbihEntryImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      inputMethod: null == inputMethod
          ? _value.inputMethod
          : inputMethod // ignore: cast_nullable_to_non_nullable
              as InputMethod,
      dhikrText: freezed == dhikrText
          ? _value.dhikrText
          : dhikrText // ignore: cast_nullable_to_non_nullable
              as String?,
      timeSinceLastEntry: freezed == timeSinceLastEntry
          ? _value.timeSinceLastEntry
          : timeSinceLastEntry // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isAutoDetected: freezed == isAutoDetected
          ? _value.isAutoDetected
          : isAutoDetected // ignore: cast_nullable_to_non_nullable
              as bool?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasbihEntryImpl implements _TasbihEntry {
  const _$TasbihEntryImpl(
      {required this.timestamp,
      required this.count,
      required this.inputMethod,
      this.dhikrText,
      this.timeSinceLastEntry,
      this.isAutoDetected,
      this.confidence});

  factory _$TasbihEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasbihEntryImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final int count;
  @override
  final InputMethod inputMethod;
  @override
  final String? dhikrText;
  @override
  final Duration? timeSinceLastEntry;
  @override
  final bool? isAutoDetected;
  @override
  final double? confidence;

  @override
  String toString() {
    return 'TasbihEntry(timestamp: $timestamp, count: $count, inputMethod: $inputMethod, dhikrText: $dhikrText, timeSinceLastEntry: $timeSinceLastEntry, isAutoDetected: $isAutoDetected, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasbihEntryImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.inputMethod, inputMethod) ||
                other.inputMethod == inputMethod) &&
            (identical(other.dhikrText, dhikrText) ||
                other.dhikrText == dhikrText) &&
            (identical(other.timeSinceLastEntry, timeSinceLastEntry) ||
                other.timeSinceLastEntry == timeSinceLastEntry) &&
            (identical(other.isAutoDetected, isAutoDetected) ||
                other.isAutoDetected == isAutoDetected) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp, count, inputMethod,
      dhikrText, timeSinceLastEntry, isAutoDetected, confidence);

  /// Create a copy of TasbihEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TasbihEntryImplCopyWith<_$TasbihEntryImpl> get copyWith =>
      __$$TasbihEntryImplCopyWithImpl<_$TasbihEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasbihEntryImplToJson(
      this,
    );
  }
}

abstract class _TasbihEntry implements TasbihEntry {
  const factory _TasbihEntry(
      {required final DateTime timestamp,
      required final int count,
      required final InputMethod inputMethod,
      final String? dhikrText,
      final Duration? timeSinceLastEntry,
      final bool? isAutoDetected,
      final double? confidence}) = _$TasbihEntryImpl;

  factory _TasbihEntry.fromJson(Map<String, dynamic> json) =
      _$TasbihEntryImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  int get count;
  @override
  InputMethod get inputMethod;
  @override
  String? get dhikrText;
  @override
  Duration? get timeSinceLastEntry;
  @override
  bool? get isAutoDetected;
  @override
  double? get confidence;

  /// Create a copy of TasbihEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TasbihEntryImplCopyWith<_$TasbihEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TasbihSettings _$TasbihSettingsFromJson(Map<String, dynamic> json) {
  return _TasbihSettings.fromJson(json);
}

/// @nodoc
mixin _$TasbihSettings {
  bool get hapticFeedback => throw _privateConstructorUsedError;
  bool get soundFeedback => throw _privateConstructorUsedError;
  bool get voiceRecognition => throw _privateConstructorUsedError;
  double get sensitivity => throw _privateConstructorUsedError;
  AnimationType get animation => throw _privateConstructorUsedError;
  ThemeStyle get theme => throw _privateConstructorUsedError;
  bool get autoSave => throw _privateConstructorUsedError;
  bool get familySharing => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customSounds => throw _privateConstructorUsedError;
  VibrationPattern? get vibrationPattern => throw _privateConstructorUsedError;

  /// Serializes this TasbihSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TasbihSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TasbihSettingsCopyWith<TasbihSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasbihSettingsCopyWith<$Res> {
  factory $TasbihSettingsCopyWith(
          TasbihSettings value, $Res Function(TasbihSettings) then) =
      _$TasbihSettingsCopyWithImpl<$Res, TasbihSettings>;
  @useResult
  $Res call(
      {bool hapticFeedback,
      bool soundFeedback,
      bool voiceRecognition,
      double sensitivity,
      AnimationType animation,
      ThemeStyle theme,
      bool autoSave,
      bool familySharing,
      Map<String, dynamic>? customSounds,
      VibrationPattern? vibrationPattern});
}

/// @nodoc
class _$TasbihSettingsCopyWithImpl<$Res, $Val extends TasbihSettings>
    implements $TasbihSettingsCopyWith<$Res> {
  _$TasbihSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TasbihSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hapticFeedback = null,
    Object? soundFeedback = null,
    Object? voiceRecognition = null,
    Object? sensitivity = null,
    Object? animation = null,
    Object? theme = null,
    Object? autoSave = null,
    Object? familySharing = null,
    Object? customSounds = freezed,
    Object? vibrationPattern = freezed,
  }) {
    return _then(_value.copyWith(
      hapticFeedback: null == hapticFeedback
          ? _value.hapticFeedback
          : hapticFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      soundFeedback: null == soundFeedback
          ? _value.soundFeedback
          : soundFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      voiceRecognition: null == voiceRecognition
          ? _value.voiceRecognition
          : voiceRecognition // ignore: cast_nullable_to_non_nullable
              as bool,
      sensitivity: null == sensitivity
          ? _value.sensitivity
          : sensitivity // ignore: cast_nullable_to_non_nullable
              as double,
      animation: null == animation
          ? _value.animation
          : animation // ignore: cast_nullable_to_non_nullable
              as AnimationType,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeStyle,
      autoSave: null == autoSave
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      familySharing: null == familySharing
          ? _value.familySharing
          : familySharing // ignore: cast_nullable_to_non_nullable
              as bool,
      customSounds: freezed == customSounds
          ? _value.customSounds
          : customSounds // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      vibrationPattern: freezed == vibrationPattern
          ? _value.vibrationPattern
          : vibrationPattern // ignore: cast_nullable_to_non_nullable
              as VibrationPattern?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasbihSettingsImplCopyWith<$Res>
    implements $TasbihSettingsCopyWith<$Res> {
  factory _$$TasbihSettingsImplCopyWith(_$TasbihSettingsImpl value,
          $Res Function(_$TasbihSettingsImpl) then) =
      __$$TasbihSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hapticFeedback,
      bool soundFeedback,
      bool voiceRecognition,
      double sensitivity,
      AnimationType animation,
      ThemeStyle theme,
      bool autoSave,
      bool familySharing,
      Map<String, dynamic>? customSounds,
      VibrationPattern? vibrationPattern});
}

/// @nodoc
class __$$TasbihSettingsImplCopyWithImpl<$Res>
    extends _$TasbihSettingsCopyWithImpl<$Res, _$TasbihSettingsImpl>
    implements _$$TasbihSettingsImplCopyWith<$Res> {
  __$$TasbihSettingsImplCopyWithImpl(
      _$TasbihSettingsImpl _value, $Res Function(_$TasbihSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TasbihSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hapticFeedback = null,
    Object? soundFeedback = null,
    Object? voiceRecognition = null,
    Object? sensitivity = null,
    Object? animation = null,
    Object? theme = null,
    Object? autoSave = null,
    Object? familySharing = null,
    Object? customSounds = freezed,
    Object? vibrationPattern = freezed,
  }) {
    return _then(_$TasbihSettingsImpl(
      hapticFeedback: null == hapticFeedback
          ? _value.hapticFeedback
          : hapticFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      soundFeedback: null == soundFeedback
          ? _value.soundFeedback
          : soundFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      voiceRecognition: null == voiceRecognition
          ? _value.voiceRecognition
          : voiceRecognition // ignore: cast_nullable_to_non_nullable
              as bool,
      sensitivity: null == sensitivity
          ? _value.sensitivity
          : sensitivity // ignore: cast_nullable_to_non_nullable
              as double,
      animation: null == animation
          ? _value.animation
          : animation // ignore: cast_nullable_to_non_nullable
              as AnimationType,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeStyle,
      autoSave: null == autoSave
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      familySharing: null == familySharing
          ? _value.familySharing
          : familySharing // ignore: cast_nullable_to_non_nullable
              as bool,
      customSounds: freezed == customSounds
          ? _value._customSounds
          : customSounds // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      vibrationPattern: freezed == vibrationPattern
          ? _value.vibrationPattern
          : vibrationPattern // ignore: cast_nullable_to_non_nullable
              as VibrationPattern?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasbihSettingsImpl implements _TasbihSettings {
  const _$TasbihSettingsImpl(
      {required this.hapticFeedback,
      required this.soundFeedback,
      required this.voiceRecognition,
      required this.sensitivity,
      required this.animation,
      required this.theme,
      required this.autoSave,
      required this.familySharing,
      final Map<String, dynamic>? customSounds,
      this.vibrationPattern})
      : _customSounds = customSounds;

  factory _$TasbihSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasbihSettingsImplFromJson(json);

  @override
  final bool hapticFeedback;
  @override
  final bool soundFeedback;
  @override
  final bool voiceRecognition;
  @override
  final double sensitivity;
  @override
  final AnimationType animation;
  @override
  final ThemeStyle theme;
  @override
  final bool autoSave;
  @override
  final bool familySharing;
  final Map<String, dynamic>? _customSounds;
  @override
  Map<String, dynamic>? get customSounds {
    final value = _customSounds;
    if (value == null) return null;
    if (_customSounds is EqualUnmodifiableMapView) return _customSounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final VibrationPattern? vibrationPattern;

  @override
  String toString() {
    return 'TasbihSettings(hapticFeedback: $hapticFeedback, soundFeedback: $soundFeedback, voiceRecognition: $voiceRecognition, sensitivity: $sensitivity, animation: $animation, theme: $theme, autoSave: $autoSave, familySharing: $familySharing, customSounds: $customSounds, vibrationPattern: $vibrationPattern)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasbihSettingsImpl &&
            (identical(other.hapticFeedback, hapticFeedback) ||
                other.hapticFeedback == hapticFeedback) &&
            (identical(other.soundFeedback, soundFeedback) ||
                other.soundFeedback == soundFeedback) &&
            (identical(other.voiceRecognition, voiceRecognition) ||
                other.voiceRecognition == voiceRecognition) &&
            (identical(other.sensitivity, sensitivity) ||
                other.sensitivity == sensitivity) &&
            (identical(other.animation, animation) ||
                other.animation == animation) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.autoSave, autoSave) ||
                other.autoSave == autoSave) &&
            (identical(other.familySharing, familySharing) ||
                other.familySharing == familySharing) &&
            const DeepCollectionEquality()
                .equals(other._customSounds, _customSounds) &&
            (identical(other.vibrationPattern, vibrationPattern) ||
                other.vibrationPattern == vibrationPattern));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hapticFeedback,
      soundFeedback,
      voiceRecognition,
      sensitivity,
      animation,
      theme,
      autoSave,
      familySharing,
      const DeepCollectionEquality().hash(_customSounds),
      vibrationPattern);

  /// Create a copy of TasbihSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TasbihSettingsImplCopyWith<_$TasbihSettingsImpl> get copyWith =>
      __$$TasbihSettingsImplCopyWithImpl<_$TasbihSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasbihSettingsImplToJson(
      this,
    );
  }
}

abstract class _TasbihSettings implements TasbihSettings {
  const factory _TasbihSettings(
      {required final bool hapticFeedback,
      required final bool soundFeedback,
      required final bool voiceRecognition,
      required final double sensitivity,
      required final AnimationType animation,
      required final ThemeStyle theme,
      required final bool autoSave,
      required final bool familySharing,
      final Map<String, dynamic>? customSounds,
      final VibrationPattern? vibrationPattern}) = _$TasbihSettingsImpl;

  factory _TasbihSettings.fromJson(Map<String, dynamic> json) =
      _$TasbihSettingsImpl.fromJson;

  @override
  bool get hapticFeedback;
  @override
  bool get soundFeedback;
  @override
  bool get voiceRecognition;
  @override
  double get sensitivity;
  @override
  AnimationType get animation;
  @override
  ThemeStyle get theme;
  @override
  bool get autoSave;
  @override
  bool get familySharing;
  @override
  Map<String, dynamic>? get customSounds;
  @override
  VibrationPattern? get vibrationPattern;

  /// Create a copy of TasbihSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TasbihSettingsImplCopyWith<_$TasbihSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TasbihGoal _$TasbihGoalFromJson(Map<String, dynamic> json) {
  return _TasbihGoal.fromJson(json);
}

/// @nodoc
mixin _$TasbihGoal {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get targetCount => throw _privateConstructorUsedError;
  Duration get timeFrame => throw _privateConstructorUsedError;
  GoalPeriod get period => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  int get currentProgress => throw _privateConstructorUsedError;
  List<String> get dhikrTypes => throw _privateConstructorUsedError;
  Map<DateTime, int> get dailyProgress => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get reward => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  GoalStatus? get status => throw _privateConstructorUsedError;

  /// Serializes this TasbihGoal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TasbihGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TasbihGoalCopyWith<TasbihGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasbihGoalCopyWith<$Res> {
  factory $TasbihGoalCopyWith(
          TasbihGoal value, $Res Function(TasbihGoal) then) =
      _$TasbihGoalCopyWithImpl<$Res, TasbihGoal>;
  @useResult
  $Res call(
      {String id,
      String title,
      int targetCount,
      Duration timeFrame,
      GoalPeriod period,
      DateTime startDate,
      DateTime? endDate,
      int currentProgress,
      List<String> dhikrTypes,
      Map<DateTime, int> dailyProgress,
      String? description,
      String? reward,
      bool? isActive,
      GoalStatus? status});
}

/// @nodoc
class _$TasbihGoalCopyWithImpl<$Res, $Val extends TasbihGoal>
    implements $TasbihGoalCopyWith<$Res> {
  _$TasbihGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TasbihGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetCount = null,
    Object? timeFrame = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? currentProgress = null,
    Object? dhikrTypes = null,
    Object? dailyProgress = null,
    Object? description = freezed,
    Object? reward = freezed,
    Object? isActive = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      timeFrame: null == timeFrame
          ? _value.timeFrame
          : timeFrame // ignore: cast_nullable_to_non_nullable
              as Duration,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as GoalPeriod,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      dhikrTypes: null == dhikrTypes
          ? _value.dhikrTypes
          : dhikrTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dailyProgress: null == dailyProgress
          ? _value.dailyProgress
          : dailyProgress // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, int>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GoalStatus?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasbihGoalImplCopyWith<$Res>
    implements $TasbihGoalCopyWith<$Res> {
  factory _$$TasbihGoalImplCopyWith(
          _$TasbihGoalImpl value, $Res Function(_$TasbihGoalImpl) then) =
      __$$TasbihGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int targetCount,
      Duration timeFrame,
      GoalPeriod period,
      DateTime startDate,
      DateTime? endDate,
      int currentProgress,
      List<String> dhikrTypes,
      Map<DateTime, int> dailyProgress,
      String? description,
      String? reward,
      bool? isActive,
      GoalStatus? status});
}

/// @nodoc
class __$$TasbihGoalImplCopyWithImpl<$Res>
    extends _$TasbihGoalCopyWithImpl<$Res, _$TasbihGoalImpl>
    implements _$$TasbihGoalImplCopyWith<$Res> {
  __$$TasbihGoalImplCopyWithImpl(
      _$TasbihGoalImpl _value, $Res Function(_$TasbihGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of TasbihGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetCount = null,
    Object? timeFrame = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? currentProgress = null,
    Object? dhikrTypes = null,
    Object? dailyProgress = null,
    Object? description = freezed,
    Object? reward = freezed,
    Object? isActive = freezed,
    Object? status = freezed,
  }) {
    return _then(_$TasbihGoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      timeFrame: null == timeFrame
          ? _value.timeFrame
          : timeFrame // ignore: cast_nullable_to_non_nullable
              as Duration,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as GoalPeriod,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      dhikrTypes: null == dhikrTypes
          ? _value._dhikrTypes
          : dhikrTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dailyProgress: null == dailyProgress
          ? _value._dailyProgress
          : dailyProgress // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, int>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GoalStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasbihGoalImpl implements _TasbihGoal {
  const _$TasbihGoalImpl(
      {required this.id,
      required this.title,
      required this.targetCount,
      required this.timeFrame,
      required this.period,
      required this.startDate,
      this.endDate,
      required this.currentProgress,
      required final List<String> dhikrTypes,
      required final Map<DateTime, int> dailyProgress,
      this.description,
      this.reward,
      this.isActive,
      this.status})
      : _dhikrTypes = dhikrTypes,
        _dailyProgress = dailyProgress;

  factory _$TasbihGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasbihGoalImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int targetCount;
  @override
  final Duration timeFrame;
  @override
  final GoalPeriod period;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final int currentProgress;
  final List<String> _dhikrTypes;
  @override
  List<String> get dhikrTypes {
    if (_dhikrTypes is EqualUnmodifiableListView) return _dhikrTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dhikrTypes);
  }

  final Map<DateTime, int> _dailyProgress;
  @override
  Map<DateTime, int> get dailyProgress {
    if (_dailyProgress is EqualUnmodifiableMapView) return _dailyProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyProgress);
  }

  @override
  final String? description;
  @override
  final String? reward;
  @override
  final bool? isActive;
  @override
  final GoalStatus? status;

  @override
  String toString() {
    return 'TasbihGoal(id: $id, title: $title, targetCount: $targetCount, timeFrame: $timeFrame, period: $period, startDate: $startDate, endDate: $endDate, currentProgress: $currentProgress, dhikrTypes: $dhikrTypes, dailyProgress: $dailyProgress, description: $description, reward: $reward, isActive: $isActive, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasbihGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            (identical(other.timeFrame, timeFrame) ||
                other.timeFrame == timeFrame) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.currentProgress, currentProgress) ||
                other.currentProgress == currentProgress) &&
            const DeepCollectionEquality()
                .equals(other._dhikrTypes, _dhikrTypes) &&
            const DeepCollectionEquality()
                .equals(other._dailyProgress, _dailyProgress) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      targetCount,
      timeFrame,
      period,
      startDate,
      endDate,
      currentProgress,
      const DeepCollectionEquality().hash(_dhikrTypes),
      const DeepCollectionEquality().hash(_dailyProgress),
      description,
      reward,
      isActive,
      status);

  /// Create a copy of TasbihGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TasbihGoalImplCopyWith<_$TasbihGoalImpl> get copyWith =>
      __$$TasbihGoalImplCopyWithImpl<_$TasbihGoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasbihGoalImplToJson(
      this,
    );
  }
}

abstract class _TasbihGoal implements TasbihGoal {
  const factory _TasbihGoal(
      {required final String id,
      required final String title,
      required final int targetCount,
      required final Duration timeFrame,
      required final GoalPeriod period,
      required final DateTime startDate,
      final DateTime? endDate,
      required final int currentProgress,
      required final List<String> dhikrTypes,
      required final Map<DateTime, int> dailyProgress,
      final String? description,
      final String? reward,
      final bool? isActive,
      final GoalStatus? status}) = _$TasbihGoalImpl;

  factory _TasbihGoal.fromJson(Map<String, dynamic> json) =
      _$TasbihGoalImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  int get targetCount;
  @override
  Duration get timeFrame;
  @override
  GoalPeriod get period;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  int get currentProgress;
  @override
  List<String> get dhikrTypes;
  @override
  Map<DateTime, int> get dailyProgress;
  @override
  String? get description;
  @override
  String? get reward;
  @override
  bool? get isActive;
  @override
  GoalStatus? get status;

  /// Create a copy of TasbihGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TasbihGoalImplCopyWith<_$TasbihGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TasbihStats _$TasbihStatsFromJson(Map<String, dynamic> json) {
  return _TasbihStats.fromJson(json);
}

/// @nodoc
mixin _$TasbihStats {
  int get totalSessions => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  Duration get totalTime => throw _privateConstructorUsedError;
  Map<TasbihType, int> get countsByType => throw _privateConstructorUsedError;
  Map<DateTime, int> get dailyProgress => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime get lastSession => throw _privateConstructorUsedError;
  double get averageSessionDuration => throw _privateConstructorUsedError;
  List<Achievement> get achievements => throw _privateConstructorUsedError;
  Map<String, dynamic>? get personalBests => throw _privateConstructorUsedError;
  FamilyStats? get familyStats => throw _privateConstructorUsedError;

  /// Serializes this TasbihStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TasbihStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TasbihStatsCopyWith<TasbihStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasbihStatsCopyWith<$Res> {
  factory $TasbihStatsCopyWith(
          TasbihStats value, $Res Function(TasbihStats) then) =
      _$TasbihStatsCopyWithImpl<$Res, TasbihStats>;
  @useResult
  $Res call(
      {int totalSessions,
      int totalCount,
      Duration totalTime,
      Map<TasbihType, int> countsByType,
      Map<DateTime, int> dailyProgress,
      int currentStreak,
      int longestStreak,
      DateTime lastSession,
      double averageSessionDuration,
      List<Achievement> achievements,
      Map<String, dynamic>? personalBests,
      FamilyStats? familyStats});

  $FamilyStatsCopyWith<$Res>? get familyStats;
}

/// @nodoc
class _$TasbihStatsCopyWithImpl<$Res, $Val extends TasbihStats>
    implements $TasbihStatsCopyWith<$Res> {
  _$TasbihStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TasbihStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? totalCount = null,
    Object? totalTime = null,
    Object? countsByType = null,
    Object? dailyProgress = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastSession = null,
    Object? averageSessionDuration = null,
    Object? achievements = null,
    Object? personalBests = freezed,
    Object? familyStats = freezed,
  }) {
    return _then(_value.copyWith(
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalTime: null == totalTime
          ? _value.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      countsByType: null == countsByType
          ? _value.countsByType
          : countsByType // ignore: cast_nullable_to_non_nullable
              as Map<TasbihType, int>,
      dailyProgress: null == dailyProgress
          ? _value.dailyProgress
          : dailyProgress // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, int>,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastSession: null == lastSession
          ? _value.lastSession
          : lastSession // ignore: cast_nullable_to_non_nullable
              as DateTime,
      averageSessionDuration: null == averageSessionDuration
          ? _value.averageSessionDuration
          : averageSessionDuration // ignore: cast_nullable_to_non_nullable
              as double,
      achievements: null == achievements
          ? _value.achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<Achievement>,
      personalBests: freezed == personalBests
          ? _value.personalBests
          : personalBests // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      familyStats: freezed == familyStats
          ? _value.familyStats
          : familyStats // ignore: cast_nullable_to_non_nullable
              as FamilyStats?,
    ) as $Val);
  }

  /// Create a copy of TasbihStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FamilyStatsCopyWith<$Res>? get familyStats {
    if (_value.familyStats == null) {
      return null;
    }

    return $FamilyStatsCopyWith<$Res>(_value.familyStats!, (value) {
      return _then(_value.copyWith(familyStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TasbihStatsImplCopyWith<$Res>
    implements $TasbihStatsCopyWith<$Res> {
  factory _$$TasbihStatsImplCopyWith(
          _$TasbihStatsImpl value, $Res Function(_$TasbihStatsImpl) then) =
      __$$TasbihStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalSessions,
      int totalCount,
      Duration totalTime,
      Map<TasbihType, int> countsByType,
      Map<DateTime, int> dailyProgress,
      int currentStreak,
      int longestStreak,
      DateTime lastSession,
      double averageSessionDuration,
      List<Achievement> achievements,
      Map<String, dynamic>? personalBests,
      FamilyStats? familyStats});

  @override
  $FamilyStatsCopyWith<$Res>? get familyStats;
}

/// @nodoc
class __$$TasbihStatsImplCopyWithImpl<$Res>
    extends _$TasbihStatsCopyWithImpl<$Res, _$TasbihStatsImpl>
    implements _$$TasbihStatsImplCopyWith<$Res> {
  __$$TasbihStatsImplCopyWithImpl(
      _$TasbihStatsImpl _value, $Res Function(_$TasbihStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TasbihStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? totalCount = null,
    Object? totalTime = null,
    Object? countsByType = null,
    Object? dailyProgress = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastSession = null,
    Object? averageSessionDuration = null,
    Object? achievements = null,
    Object? personalBests = freezed,
    Object? familyStats = freezed,
  }) {
    return _then(_$TasbihStatsImpl(
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalTime: null == totalTime
          ? _value.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      countsByType: null == countsByType
          ? _value._countsByType
          : countsByType // ignore: cast_nullable_to_non_nullable
              as Map<TasbihType, int>,
      dailyProgress: null == dailyProgress
          ? _value._dailyProgress
          : dailyProgress // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, int>,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastSession: null == lastSession
          ? _value.lastSession
          : lastSession // ignore: cast_nullable_to_non_nullable
              as DateTime,
      averageSessionDuration: null == averageSessionDuration
          ? _value.averageSessionDuration
          : averageSessionDuration // ignore: cast_nullable_to_non_nullable
              as double,
      achievements: null == achievements
          ? _value._achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<Achievement>,
      personalBests: freezed == personalBests
          ? _value._personalBests
          : personalBests // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      familyStats: freezed == familyStats
          ? _value.familyStats
          : familyStats // ignore: cast_nullable_to_non_nullable
              as FamilyStats?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasbihStatsImpl implements _TasbihStats {
  const _$TasbihStatsImpl(
      {required this.totalSessions,
      required this.totalCount,
      required this.totalTime,
      required final Map<TasbihType, int> countsByType,
      required final Map<DateTime, int> dailyProgress,
      required this.currentStreak,
      required this.longestStreak,
      required this.lastSession,
      required this.averageSessionDuration,
      required final List<Achievement> achievements,
      final Map<String, dynamic>? personalBests,
      this.familyStats})
      : _countsByType = countsByType,
        _dailyProgress = dailyProgress,
        _achievements = achievements,
        _personalBests = personalBests;

  factory _$TasbihStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasbihStatsImplFromJson(json);

  @override
  final int totalSessions;
  @override
  final int totalCount;
  @override
  final Duration totalTime;
  final Map<TasbihType, int> _countsByType;
  @override
  Map<TasbihType, int> get countsByType {
    if (_countsByType is EqualUnmodifiableMapView) return _countsByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_countsByType);
  }

  final Map<DateTime, int> _dailyProgress;
  @override
  Map<DateTime, int> get dailyProgress {
    if (_dailyProgress is EqualUnmodifiableMapView) return _dailyProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyProgress);
  }

  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime lastSession;
  @override
  final double averageSessionDuration;
  final List<Achievement> _achievements;
  @override
  List<Achievement> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  final Map<String, dynamic>? _personalBests;
  @override
  Map<String, dynamic>? get personalBests {
    final value = _personalBests;
    if (value == null) return null;
    if (_personalBests is EqualUnmodifiableMapView) return _personalBests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final FamilyStats? familyStats;

  @override
  String toString() {
    return 'TasbihStats(totalSessions: $totalSessions, totalCount: $totalCount, totalTime: $totalTime, countsByType: $countsByType, dailyProgress: $dailyProgress, currentStreak: $currentStreak, longestStreak: $longestStreak, lastSession: $lastSession, averageSessionDuration: $averageSessionDuration, achievements: $achievements, personalBests: $personalBests, familyStats: $familyStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasbihStatsImpl &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            const DeepCollectionEquality()
                .equals(other._countsByType, _countsByType) &&
            const DeepCollectionEquality()
                .equals(other._dailyProgress, _dailyProgress) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastSession, lastSession) ||
                other.lastSession == lastSession) &&
            (identical(other.averageSessionDuration, averageSessionDuration) ||
                other.averageSessionDuration == averageSessionDuration) &&
            const DeepCollectionEquality()
                .equals(other._achievements, _achievements) &&
            const DeepCollectionEquality()
                .equals(other._personalBests, _personalBests) &&
            (identical(other.familyStats, familyStats) ||
                other.familyStats == familyStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalSessions,
      totalCount,
      totalTime,
      const DeepCollectionEquality().hash(_countsByType),
      const DeepCollectionEquality().hash(_dailyProgress),
      currentStreak,
      longestStreak,
      lastSession,
      averageSessionDuration,
      const DeepCollectionEquality().hash(_achievements),
      const DeepCollectionEquality().hash(_personalBests),
      familyStats);

  /// Create a copy of TasbihStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TasbihStatsImplCopyWith<_$TasbihStatsImpl> get copyWith =>
      __$$TasbihStatsImplCopyWithImpl<_$TasbihStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasbihStatsImplToJson(
      this,
    );
  }
}

abstract class _TasbihStats implements TasbihStats {
  const factory _TasbihStats(
      {required final int totalSessions,
      required final int totalCount,
      required final Duration totalTime,
      required final Map<TasbihType, int> countsByType,
      required final Map<DateTime, int> dailyProgress,
      required final int currentStreak,
      required final int longestStreak,
      required final DateTime lastSession,
      required final double averageSessionDuration,
      required final List<Achievement> achievements,
      final Map<String, dynamic>? personalBests,
      final FamilyStats? familyStats}) = _$TasbihStatsImpl;

  factory _TasbihStats.fromJson(Map<String, dynamic> json) =
      _$TasbihStatsImpl.fromJson;

  @override
  int get totalSessions;
  @override
  int get totalCount;
  @override
  Duration get totalTime;
  @override
  Map<TasbihType, int> get countsByType;
  @override
  Map<DateTime, int> get dailyProgress;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime get lastSession;
  @override
  double get averageSessionDuration;
  @override
  List<Achievement> get achievements;
  @override
  Map<String, dynamic>? get personalBests;
  @override
  FamilyStats? get familyStats;

  /// Create a copy of TasbihStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TasbihStatsImplCopyWith<_$TasbihStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get iconPath => throw _privateConstructorUsedError;
  DateTime get unlockedAt => throw _privateConstructorUsedError;
  AchievementCategory get category => throw _privateConstructorUsedError;
  int get pointsEarned => throw _privateConstructorUsedError;
  bool? get isRare => throw _privateConstructorUsedError;
  Map<String, dynamic>? get criteria => throw _privateConstructorUsedError;

  /// Serializes this Achievement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
          Achievement value, $Res Function(Achievement) then) =
      _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String iconPath,
      DateTime unlockedAt,
      AchievementCategory category,
      int pointsEarned,
      bool? isRare,
      Map<String, dynamic>? criteria});
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconPath = null,
    Object? unlockedAt = null,
    Object? category = null,
    Object? pointsEarned = null,
    Object? isRare = freezed,
    Object? criteria = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAt: null == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AchievementCategory,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      isRare: freezed == isRare
          ? _value.isRare
          : isRare // ignore: cast_nullable_to_non_nullable
              as bool?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
          _$AchievementImpl value, $Res Function(_$AchievementImpl) then) =
      __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String iconPath,
      DateTime unlockedAt,
      AchievementCategory category,
      int pointsEarned,
      bool? isRare,
      Map<String, dynamic>? criteria});
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
      _$AchievementImpl _value, $Res Function(_$AchievementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconPath = null,
    Object? unlockedAt = null,
    Object? category = null,
    Object? pointsEarned = null,
    Object? isRare = freezed,
    Object? criteria = freezed,
  }) {
    return _then(_$AchievementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAt: null == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AchievementCategory,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      isRare: freezed == isRare
          ? _value.isRare
          : isRare // ignore: cast_nullable_to_non_nullable
              as bool?,
      criteria: freezed == criteria
          ? _value._criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.iconPath,
      required this.unlockedAt,
      required this.category,
      required this.pointsEarned,
      this.isRare,
      final Map<String, dynamic>? criteria})
      : _criteria = criteria;

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String iconPath;
  @override
  final DateTime unlockedAt;
  @override
  final AchievementCategory category;
  @override
  final int pointsEarned;
  @override
  final bool? isRare;
  final Map<String, dynamic>? _criteria;
  @override
  Map<String, dynamic>? get criteria {
    final value = _criteria;
    if (value == null) return null;
    if (_criteria is EqualUnmodifiableMapView) return _criteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, iconPath: $iconPath, unlockedAt: $unlockedAt, category: $category, pointsEarned: $pointsEarned, isRare: $isRare, criteria: $criteria)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.isRare, isRare) || other.isRare == isRare) &&
            const DeepCollectionEquality().equals(other._criteria, _criteria));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      iconPath,
      unlockedAt,
      category,
      pointsEarned,
      isRare,
      const DeepCollectionEquality().hash(_criteria));

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(
      this,
    );
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement(
      {required final String id,
      required final String title,
      required final String description,
      required final String iconPath,
      required final DateTime unlockedAt,
      required final AchievementCategory category,
      required final int pointsEarned,
      final bool? isRare,
      final Map<String, dynamic>? criteria}) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get iconPath;
  @override
  DateTime get unlockedAt;
  @override
  AchievementCategory get category;
  @override
  int get pointsEarned;
  @override
  bool? get isRare;
  @override
  Map<String, dynamic>? get criteria;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyStats _$FamilyStatsFromJson(Map<String, dynamic> json) {
  return _FamilyStats.fromJson(json);
}

/// @nodoc
mixin _$FamilyStats {
  String get familyId => throw _privateConstructorUsedError;
  Map<String, int> get memberContributions =>
      throw _privateConstructorUsedError;
  int get totalFamilyCount => throw _privateConstructorUsedError;
  List<FamilyMember> get members => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  FamilyGoal? get currentGoal => throw _privateConstructorUsedError;
  List<FamilyChallenge>? get activeChallenges =>
      throw _privateConstructorUsedError;

  /// Serializes this FamilyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyStatsCopyWith<FamilyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyStatsCopyWith<$Res> {
  factory $FamilyStatsCopyWith(
          FamilyStats value, $Res Function(FamilyStats) then) =
      _$FamilyStatsCopyWithImpl<$Res, FamilyStats>;
  @useResult
  $Res call(
      {String familyId,
      Map<String, int> memberContributions,
      int totalFamilyCount,
      List<FamilyMember> members,
      DateTime lastUpdated,
      FamilyGoal? currentGoal,
      List<FamilyChallenge>? activeChallenges});

  $FamilyGoalCopyWith<$Res>? get currentGoal;
}

/// @nodoc
class _$FamilyStatsCopyWithImpl<$Res, $Val extends FamilyStats>
    implements $FamilyStatsCopyWith<$Res> {
  _$FamilyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? familyId = null,
    Object? memberContributions = null,
    Object? totalFamilyCount = null,
    Object? members = null,
    Object? lastUpdated = null,
    Object? currentGoal = freezed,
    Object? activeChallenges = freezed,
  }) {
    return _then(_value.copyWith(
      familyId: null == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String,
      memberContributions: null == memberContributions
          ? _value.memberContributions
          : memberContributions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalFamilyCount: null == totalFamilyCount
          ? _value.totalFamilyCount
          : totalFamilyCount // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<FamilyMember>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentGoal: freezed == currentGoal
          ? _value.currentGoal
          : currentGoal // ignore: cast_nullable_to_non_nullable
              as FamilyGoal?,
      activeChallenges: freezed == activeChallenges
          ? _value.activeChallenges
          : activeChallenges // ignore: cast_nullable_to_non_nullable
              as List<FamilyChallenge>?,
    ) as $Val);
  }

  /// Create a copy of FamilyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FamilyGoalCopyWith<$Res>? get currentGoal {
    if (_value.currentGoal == null) {
      return null;
    }

    return $FamilyGoalCopyWith<$Res>(_value.currentGoal!, (value) {
      return _then(_value.copyWith(currentGoal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FamilyStatsImplCopyWith<$Res>
    implements $FamilyStatsCopyWith<$Res> {
  factory _$$FamilyStatsImplCopyWith(
          _$FamilyStatsImpl value, $Res Function(_$FamilyStatsImpl) then) =
      __$$FamilyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String familyId,
      Map<String, int> memberContributions,
      int totalFamilyCount,
      List<FamilyMember> members,
      DateTime lastUpdated,
      FamilyGoal? currentGoal,
      List<FamilyChallenge>? activeChallenges});

  @override
  $FamilyGoalCopyWith<$Res>? get currentGoal;
}

/// @nodoc
class __$$FamilyStatsImplCopyWithImpl<$Res>
    extends _$FamilyStatsCopyWithImpl<$Res, _$FamilyStatsImpl>
    implements _$$FamilyStatsImplCopyWith<$Res> {
  __$$FamilyStatsImplCopyWithImpl(
      _$FamilyStatsImpl _value, $Res Function(_$FamilyStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? familyId = null,
    Object? memberContributions = null,
    Object? totalFamilyCount = null,
    Object? members = null,
    Object? lastUpdated = null,
    Object? currentGoal = freezed,
    Object? activeChallenges = freezed,
  }) {
    return _then(_$FamilyStatsImpl(
      familyId: null == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String,
      memberContributions: null == memberContributions
          ? _value._memberContributions
          : memberContributions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalFamilyCount: null == totalFamilyCount
          ? _value.totalFamilyCount
          : totalFamilyCount // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<FamilyMember>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentGoal: freezed == currentGoal
          ? _value.currentGoal
          : currentGoal // ignore: cast_nullable_to_non_nullable
              as FamilyGoal?,
      activeChallenges: freezed == activeChallenges
          ? _value._activeChallenges
          : activeChallenges // ignore: cast_nullable_to_non_nullable
              as List<FamilyChallenge>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyStatsImpl implements _FamilyStats {
  const _$FamilyStatsImpl(
      {required this.familyId,
      required final Map<String, int> memberContributions,
      required this.totalFamilyCount,
      required final List<FamilyMember> members,
      required this.lastUpdated,
      this.currentGoal,
      final List<FamilyChallenge>? activeChallenges})
      : _memberContributions = memberContributions,
        _members = members,
        _activeChallenges = activeChallenges;

  factory _$FamilyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyStatsImplFromJson(json);

  @override
  final String familyId;
  final Map<String, int> _memberContributions;
  @override
  Map<String, int> get memberContributions {
    if (_memberContributions is EqualUnmodifiableMapView)
      return _memberContributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberContributions);
  }

  @override
  final int totalFamilyCount;
  final List<FamilyMember> _members;
  @override
  List<FamilyMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final DateTime lastUpdated;
  @override
  final FamilyGoal? currentGoal;
  final List<FamilyChallenge>? _activeChallenges;
  @override
  List<FamilyChallenge>? get activeChallenges {
    final value = _activeChallenges;
    if (value == null) return null;
    if (_activeChallenges is EqualUnmodifiableListView)
      return _activeChallenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FamilyStats(familyId: $familyId, memberContributions: $memberContributions, totalFamilyCount: $totalFamilyCount, members: $members, lastUpdated: $lastUpdated, currentGoal: $currentGoal, activeChallenges: $activeChallenges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyStatsImpl &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            const DeepCollectionEquality()
                .equals(other._memberContributions, _memberContributions) &&
            (identical(other.totalFamilyCount, totalFamilyCount) ||
                other.totalFamilyCount == totalFamilyCount) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.currentGoal, currentGoal) ||
                other.currentGoal == currentGoal) &&
            const DeepCollectionEquality()
                .equals(other._activeChallenges, _activeChallenges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      familyId,
      const DeepCollectionEquality().hash(_memberContributions),
      totalFamilyCount,
      const DeepCollectionEquality().hash(_members),
      lastUpdated,
      currentGoal,
      const DeepCollectionEquality().hash(_activeChallenges));

  /// Create a copy of FamilyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyStatsImplCopyWith<_$FamilyStatsImpl> get copyWith =>
      __$$FamilyStatsImplCopyWithImpl<_$FamilyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyStatsImplToJson(
      this,
    );
  }
}

abstract class _FamilyStats implements FamilyStats {
  const factory _FamilyStats(
      {required final String familyId,
      required final Map<String, int> memberContributions,
      required final int totalFamilyCount,
      required final List<FamilyMember> members,
      required final DateTime lastUpdated,
      final FamilyGoal? currentGoal,
      final List<FamilyChallenge>? activeChallenges}) = _$FamilyStatsImpl;

  factory _FamilyStats.fromJson(Map<String, dynamic> json) =
      _$FamilyStatsImpl.fromJson;

  @override
  String get familyId;
  @override
  Map<String, int> get memberContributions;
  @override
  int get totalFamilyCount;
  @override
  List<FamilyMember> get members;
  @override
  DateTime get lastUpdated;
  @override
  FamilyGoal? get currentGoal;
  @override
  List<FamilyChallenge>? get activeChallenges;

  /// Create a copy of FamilyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyStatsImplCopyWith<_$FamilyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) {
  return _FamilyMember.fromJson(json);
}

/// @nodoc
mixin _$FamilyMember {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  DateTime get lastActive => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool? get isOnline => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberCopyWith<FamilyMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberCopyWith<$Res> {
  factory $FamilyMemberCopyWith(
          FamilyMember value, $Res Function(FamilyMember) then) =
      _$FamilyMemberCopyWithImpl<$Res, FamilyMember>;
  @useResult
  $Res call(
      {String userId,
      String displayName,
      String role,
      int totalCount,
      DateTime lastActive,
      String? avatarUrl,
      bool? isOnline,
      Map<String, dynamic>? preferences});
}

/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res, $Val extends FamilyMember>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
    Object? totalCount = null,
    Object? lastActive = null,
    Object? avatarUrl = freezed,
    Object? isOnline = freezed,
    Object? preferences = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: freezed == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyMemberImplCopyWith<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  factory _$$FamilyMemberImplCopyWith(
          _$FamilyMemberImpl value, $Res Function(_$FamilyMemberImpl) then) =
      __$$FamilyMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String displayName,
      String role,
      int totalCount,
      DateTime lastActive,
      String? avatarUrl,
      bool? isOnline,
      Map<String, dynamic>? preferences});
}

/// @nodoc
class __$$FamilyMemberImplCopyWithImpl<$Res>
    extends _$FamilyMemberCopyWithImpl<$Res, _$FamilyMemberImpl>
    implements _$$FamilyMemberImplCopyWith<$Res> {
  __$$FamilyMemberImplCopyWithImpl(
      _$FamilyMemberImpl _value, $Res Function(_$FamilyMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
    Object? totalCount = null,
    Object? lastActive = null,
    Object? avatarUrl = freezed,
    Object? isOnline = freezed,
    Object? preferences = freezed,
  }) {
    return _then(_$FamilyMemberImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: freezed == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyMemberImpl implements _FamilyMember {
  const _$FamilyMemberImpl(
      {required this.userId,
      required this.displayName,
      required this.role,
      required this.totalCount,
      required this.lastActive,
      this.avatarUrl,
      this.isOnline,
      final Map<String, dynamic>? preferences})
      : _preferences = preferences;

  factory _$FamilyMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyMemberImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String role;
  @override
  final int totalCount;
  @override
  final DateTime lastActive;
  @override
  final String? avatarUrl;
  @override
  final bool? isOnline;
  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FamilyMember(userId: $userId, displayName: $displayName, role: $role, totalCount: $totalCount, lastActive: $lastActive, avatarUrl: $avatarUrl, isOnline: $isOnline, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      displayName,
      role,
      totalCount,
      lastActive,
      avatarUrl,
      isOnline,
      const DeepCollectionEquality().hash(_preferences));

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      __$$FamilyMemberImplCopyWithImpl<_$FamilyMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyMemberImplToJson(
      this,
    );
  }
}

abstract class _FamilyMember implements FamilyMember {
  const factory _FamilyMember(
      {required final String userId,
      required final String displayName,
      required final String role,
      required final int totalCount,
      required final DateTime lastActive,
      final String? avatarUrl,
      final bool? isOnline,
      final Map<String, dynamic>? preferences}) = _$FamilyMemberImpl;

  factory _FamilyMember.fromJson(Map<String, dynamic> json) =
      _$FamilyMemberImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String get role;
  @override
  int get totalCount;
  @override
  DateTime get lastActive;
  @override
  String? get avatarUrl;
  @override
  bool? get isOnline;
  @override
  Map<String, dynamic>? get preferences;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyGoal _$FamilyGoalFromJson(Map<String, dynamic> json) {
  return _FamilyGoal.fromJson(json);
}

/// @nodoc
mixin _$FamilyGoal {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get targetCount => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  int get currentProgress => throw _privateConstructorUsedError;
  Map<String, int> get memberContributions =>
      throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get reward => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this FamilyGoal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyGoalCopyWith<FamilyGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyGoalCopyWith<$Res> {
  factory $FamilyGoalCopyWith(
          FamilyGoal value, $Res Function(FamilyGoal) then) =
      _$FamilyGoalCopyWithImpl<$Res, FamilyGoal>;
  @useResult
  $Res call(
      {String id,
      String title,
      int targetCount,
      DateTime deadline,
      int currentProgress,
      Map<String, int> memberContributions,
      String? description,
      String? reward,
      bool? isActive});
}

/// @nodoc
class _$FamilyGoalCopyWithImpl<$Res, $Val extends FamilyGoal>
    implements $FamilyGoalCopyWith<$Res> {
  _$FamilyGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetCount = null,
    Object? deadline = null,
    Object? currentProgress = null,
    Object? memberContributions = null,
    Object? description = freezed,
    Object? reward = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      memberContributions: null == memberContributions
          ? _value.memberContributions
          : memberContributions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyGoalImplCopyWith<$Res>
    implements $FamilyGoalCopyWith<$Res> {
  factory _$$FamilyGoalImplCopyWith(
          _$FamilyGoalImpl value, $Res Function(_$FamilyGoalImpl) then) =
      __$$FamilyGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int targetCount,
      DateTime deadline,
      int currentProgress,
      Map<String, int> memberContributions,
      String? description,
      String? reward,
      bool? isActive});
}

/// @nodoc
class __$$FamilyGoalImplCopyWithImpl<$Res>
    extends _$FamilyGoalCopyWithImpl<$Res, _$FamilyGoalImpl>
    implements _$$FamilyGoalImplCopyWith<$Res> {
  __$$FamilyGoalImplCopyWithImpl(
      _$FamilyGoalImpl _value, $Res Function(_$FamilyGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetCount = null,
    Object? deadline = null,
    Object? currentProgress = null,
    Object? memberContributions = null,
    Object? description = freezed,
    Object? reward = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$FamilyGoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      memberContributions: null == memberContributions
          ? _value._memberContributions
          : memberContributions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyGoalImpl implements _FamilyGoal {
  const _$FamilyGoalImpl(
      {required this.id,
      required this.title,
      required this.targetCount,
      required this.deadline,
      required this.currentProgress,
      required final Map<String, int> memberContributions,
      this.description,
      this.reward,
      this.isActive})
      : _memberContributions = memberContributions;

  factory _$FamilyGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyGoalImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int targetCount;
  @override
  final DateTime deadline;
  @override
  final int currentProgress;
  final Map<String, int> _memberContributions;
  @override
  Map<String, int> get memberContributions {
    if (_memberContributions is EqualUnmodifiableMapView)
      return _memberContributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberContributions);
  }

  @override
  final String? description;
  @override
  final String? reward;
  @override
  final bool? isActive;

  @override
  String toString() {
    return 'FamilyGoal(id: $id, title: $title, targetCount: $targetCount, deadline: $deadline, currentProgress: $currentProgress, memberContributions: $memberContributions, description: $description, reward: $reward, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.currentProgress, currentProgress) ||
                other.currentProgress == currentProgress) &&
            const DeepCollectionEquality()
                .equals(other._memberContributions, _memberContributions) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      targetCount,
      deadline,
      currentProgress,
      const DeepCollectionEquality().hash(_memberContributions),
      description,
      reward,
      isActive);

  /// Create a copy of FamilyGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyGoalImplCopyWith<_$FamilyGoalImpl> get copyWith =>
      __$$FamilyGoalImplCopyWithImpl<_$FamilyGoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyGoalImplToJson(
      this,
    );
  }
}

abstract class _FamilyGoal implements FamilyGoal {
  const factory _FamilyGoal(
      {required final String id,
      required final String title,
      required final int targetCount,
      required final DateTime deadline,
      required final int currentProgress,
      required final Map<String, int> memberContributions,
      final String? description,
      final String? reward,
      final bool? isActive}) = _$FamilyGoalImpl;

  factory _FamilyGoal.fromJson(Map<String, dynamic> json) =
      _$FamilyGoalImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  int get targetCount;
  @override
  DateTime get deadline;
  @override
  int get currentProgress;
  @override
  Map<String, int> get memberContributions;
  @override
  String? get description;
  @override
  String? get reward;
  @override
  bool? get isActive;

  /// Create a copy of FamilyGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyGoalImplCopyWith<_$FamilyGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyChallenge _$FamilyChallengeFromJson(Map<String, dynamic> json) {
  return _FamilyChallenge.fromJson(json);
}

/// @nodoc
mixin _$FamilyChallenge {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ChallengeType get type => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  Map<String, int> get scores => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get rules => throw _privateConstructorUsedError;
  List<String>? get prizes => throw _privateConstructorUsedError;

  /// Serializes this FamilyChallenge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyChallengeCopyWith<FamilyChallenge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyChallengeCopyWith<$Res> {
  factory $FamilyChallengeCopyWith(
          FamilyChallenge value, $Res Function(FamilyChallenge) then) =
      _$FamilyChallengeCopyWithImpl<$Res, FamilyChallenge>;
  @useResult
  $Res call(
      {String id,
      String title,
      ChallengeType type,
      DateTime startDate,
      DateTime endDate,
      Map<String, int> scores,
      List<String> participants,
      String? description,
      Map<String, dynamic>? rules,
      List<String>? prizes});
}

/// @nodoc
class _$FamilyChallengeCopyWithImpl<$Res, $Val extends FamilyChallenge>
    implements $FamilyChallengeCopyWith<$Res> {
  _$FamilyChallengeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? scores = null,
    Object? participants = null,
    Object? description = freezed,
    Object? rules = freezed,
    Object? prizes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChallengeType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scores: null == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      rules: freezed == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      prizes: freezed == prizes
          ? _value.prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyChallengeImplCopyWith<$Res>
    implements $FamilyChallengeCopyWith<$Res> {
  factory _$$FamilyChallengeImplCopyWith(_$FamilyChallengeImpl value,
          $Res Function(_$FamilyChallengeImpl) then) =
      __$$FamilyChallengeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      ChallengeType type,
      DateTime startDate,
      DateTime endDate,
      Map<String, int> scores,
      List<String> participants,
      String? description,
      Map<String, dynamic>? rules,
      List<String>? prizes});
}

/// @nodoc
class __$$FamilyChallengeImplCopyWithImpl<$Res>
    extends _$FamilyChallengeCopyWithImpl<$Res, _$FamilyChallengeImpl>
    implements _$$FamilyChallengeImplCopyWith<$Res> {
  __$$FamilyChallengeImplCopyWithImpl(
      _$FamilyChallengeImpl _value, $Res Function(_$FamilyChallengeImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? scores = null,
    Object? participants = null,
    Object? description = freezed,
    Object? rules = freezed,
    Object? prizes = freezed,
  }) {
    return _then(_$FamilyChallengeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChallengeType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scores: null == scores
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      rules: freezed == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      prizes: freezed == prizes
          ? _value._prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyChallengeImpl implements _FamilyChallenge {
  const _$FamilyChallengeImpl(
      {required this.id,
      required this.title,
      required this.type,
      required this.startDate,
      required this.endDate,
      required final Map<String, int> scores,
      required final List<String> participants,
      this.description,
      final Map<String, dynamic>? rules,
      final List<String>? prizes})
      : _scores = scores,
        _participants = participants,
        _rules = rules,
        _prizes = prizes;

  factory _$FamilyChallengeImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyChallengeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final ChallengeType type;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final Map<String, int> _scores;
  @override
  Map<String, int> get scores {
    if (_scores is EqualUnmodifiableMapView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_scores);
  }

  final List<String> _participants;
  @override
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final String? description;
  final Map<String, dynamic>? _rules;
  @override
  Map<String, dynamic>? get rules {
    final value = _rules;
    if (value == null) return null;
    if (_rules is EqualUnmodifiableMapView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _prizes;
  @override
  List<String>? get prizes {
    final value = _prizes;
    if (value == null) return null;
    if (_prizes is EqualUnmodifiableListView) return _prizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FamilyChallenge(id: $id, title: $title, type: $type, startDate: $startDate, endDate: $endDate, scores: $scores, participants: $participants, description: $description, rules: $rules, prizes: $prizes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyChallengeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            const DeepCollectionEquality().equals(other._prizes, _prizes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_participants),
      description,
      const DeepCollectionEquality().hash(_rules),
      const DeepCollectionEquality().hash(_prizes));

  /// Create a copy of FamilyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyChallengeImplCopyWith<_$FamilyChallengeImpl> get copyWith =>
      __$$FamilyChallengeImplCopyWithImpl<_$FamilyChallengeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyChallengeImplToJson(
      this,
    );
  }
}

abstract class _FamilyChallenge implements FamilyChallenge {
  const factory _FamilyChallenge(
      {required final String id,
      required final String title,
      required final ChallengeType type,
      required final DateTime startDate,
      required final DateTime endDate,
      required final Map<String, int> scores,
      required final List<String> participants,
      final String? description,
      final Map<String, dynamic>? rules,
      final List<String>? prizes}) = _$FamilyChallengeImpl;

  factory _FamilyChallenge.fromJson(Map<String, dynamic> json) =
      _$FamilyChallengeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  ChallengeType get type;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  Map<String, int> get scores;
  @override
  List<String> get participants;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get rules;
  @override
  List<String>? get prizes;

  /// Create a copy of FamilyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyChallengeImplCopyWith<_$FamilyChallengeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VoiceRecognition _$VoiceRecognitionFromJson(Map<String, dynamic> json) {
  return _VoiceRecognition.fromJson(json);
}

/// @nodoc
mixin _$VoiceRecognition {
  bool get isEnabled => throw _privateConstructorUsedError;
  List<String> get recognizedPhrases => throw _privateConstructorUsedError;
  double get confidenceThreshold => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  Map<String, double> get phraseConfidence =>
      throw _privateConstructorUsedError;
  bool? get backgroundListening => throw _privateConstructorUsedError;
  Duration? get sessionTimeout => throw _privateConstructorUsedError;
  List<String>? get customPhrases => throw _privateConstructorUsedError;

  /// Serializes this VoiceRecognition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoiceRecognition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoiceRecognitionCopyWith<VoiceRecognition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceRecognitionCopyWith<$Res> {
  factory $VoiceRecognitionCopyWith(
          VoiceRecognition value, $Res Function(VoiceRecognition) then) =
      _$VoiceRecognitionCopyWithImpl<$Res, VoiceRecognition>;
  @useResult
  $Res call(
      {bool isEnabled,
      List<String> recognizedPhrases,
      double confidenceThreshold,
      String language,
      Map<String, double> phraseConfidence,
      bool? backgroundListening,
      Duration? sessionTimeout,
      List<String>? customPhrases});
}

/// @nodoc
class _$VoiceRecognitionCopyWithImpl<$Res, $Val extends VoiceRecognition>
    implements $VoiceRecognitionCopyWith<$Res> {
  _$VoiceRecognitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoiceRecognition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? recognizedPhrases = null,
    Object? confidenceThreshold = null,
    Object? language = null,
    Object? phraseConfidence = null,
    Object? backgroundListening = freezed,
    Object? sessionTimeout = freezed,
    Object? customPhrases = freezed,
  }) {
    return _then(_value.copyWith(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      recognizedPhrases: null == recognizedPhrases
          ? _value.recognizedPhrases
          : recognizedPhrases // ignore: cast_nullable_to_non_nullable
              as List<String>,
      confidenceThreshold: null == confidenceThreshold
          ? _value.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      phraseConfidence: null == phraseConfidence
          ? _value.phraseConfidence
          : phraseConfidence // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      backgroundListening: freezed == backgroundListening
          ? _value.backgroundListening
          : backgroundListening // ignore: cast_nullable_to_non_nullable
              as bool?,
      sessionTimeout: freezed == sessionTimeout
          ? _value.sessionTimeout
          : sessionTimeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      customPhrases: freezed == customPhrases
          ? _value.customPhrases
          : customPhrases // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoiceRecognitionImplCopyWith<$Res>
    implements $VoiceRecognitionCopyWith<$Res> {
  factory _$$VoiceRecognitionImplCopyWith(_$VoiceRecognitionImpl value,
          $Res Function(_$VoiceRecognitionImpl) then) =
      __$$VoiceRecognitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isEnabled,
      List<String> recognizedPhrases,
      double confidenceThreshold,
      String language,
      Map<String, double> phraseConfidence,
      bool? backgroundListening,
      Duration? sessionTimeout,
      List<String>? customPhrases});
}

/// @nodoc
class __$$VoiceRecognitionImplCopyWithImpl<$Res>
    extends _$VoiceRecognitionCopyWithImpl<$Res, _$VoiceRecognitionImpl>
    implements _$$VoiceRecognitionImplCopyWith<$Res> {
  __$$VoiceRecognitionImplCopyWithImpl(_$VoiceRecognitionImpl _value,
      $Res Function(_$VoiceRecognitionImpl) _then)
      : super(_value, _then);

  /// Create a copy of VoiceRecognition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? recognizedPhrases = null,
    Object? confidenceThreshold = null,
    Object? language = null,
    Object? phraseConfidence = null,
    Object? backgroundListening = freezed,
    Object? sessionTimeout = freezed,
    Object? customPhrases = freezed,
  }) {
    return _then(_$VoiceRecognitionImpl(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      recognizedPhrases: null == recognizedPhrases
          ? _value._recognizedPhrases
          : recognizedPhrases // ignore: cast_nullable_to_non_nullable
              as List<String>,
      confidenceThreshold: null == confidenceThreshold
          ? _value.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      phraseConfidence: null == phraseConfidence
          ? _value._phraseConfidence
          : phraseConfidence // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      backgroundListening: freezed == backgroundListening
          ? _value.backgroundListening
          : backgroundListening // ignore: cast_nullable_to_non_nullable
              as bool?,
      sessionTimeout: freezed == sessionTimeout
          ? _value.sessionTimeout
          : sessionTimeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      customPhrases: freezed == customPhrases
          ? _value._customPhrases
          : customPhrases // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VoiceRecognitionImpl implements _VoiceRecognition {
  const _$VoiceRecognitionImpl(
      {required this.isEnabled,
      required final List<String> recognizedPhrases,
      required this.confidenceThreshold,
      required this.language,
      required final Map<String, double> phraseConfidence,
      this.backgroundListening,
      this.sessionTimeout,
      final List<String>? customPhrases})
      : _recognizedPhrases = recognizedPhrases,
        _phraseConfidence = phraseConfidence,
        _customPhrases = customPhrases;

  factory _$VoiceRecognitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoiceRecognitionImplFromJson(json);

  @override
  final bool isEnabled;
  final List<String> _recognizedPhrases;
  @override
  List<String> get recognizedPhrases {
    if (_recognizedPhrases is EqualUnmodifiableListView)
      return _recognizedPhrases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recognizedPhrases);
  }

  @override
  final double confidenceThreshold;
  @override
  final String language;
  final Map<String, double> _phraseConfidence;
  @override
  Map<String, double> get phraseConfidence {
    if (_phraseConfidence is EqualUnmodifiableMapView) return _phraseConfidence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_phraseConfidence);
  }

  @override
  final bool? backgroundListening;
  @override
  final Duration? sessionTimeout;
  final List<String>? _customPhrases;
  @override
  List<String>? get customPhrases {
    final value = _customPhrases;
    if (value == null) return null;
    if (_customPhrases is EqualUnmodifiableListView) return _customPhrases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'VoiceRecognition(isEnabled: $isEnabled, recognizedPhrases: $recognizedPhrases, confidenceThreshold: $confidenceThreshold, language: $language, phraseConfidence: $phraseConfidence, backgroundListening: $backgroundListening, sessionTimeout: $sessionTimeout, customPhrases: $customPhrases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceRecognitionImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality()
                .equals(other._recognizedPhrases, _recognizedPhrases) &&
            (identical(other.confidenceThreshold, confidenceThreshold) ||
                other.confidenceThreshold == confidenceThreshold) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality()
                .equals(other._phraseConfidence, _phraseConfidence) &&
            (identical(other.backgroundListening, backgroundListening) ||
                other.backgroundListening == backgroundListening) &&
            (identical(other.sessionTimeout, sessionTimeout) ||
                other.sessionTimeout == sessionTimeout) &&
            const DeepCollectionEquality()
                .equals(other._customPhrases, _customPhrases));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isEnabled,
      const DeepCollectionEquality().hash(_recognizedPhrases),
      confidenceThreshold,
      language,
      const DeepCollectionEquality().hash(_phraseConfidence),
      backgroundListening,
      sessionTimeout,
      const DeepCollectionEquality().hash(_customPhrases));

  /// Create a copy of VoiceRecognition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceRecognitionImplCopyWith<_$VoiceRecognitionImpl> get copyWith =>
      __$$VoiceRecognitionImplCopyWithImpl<_$VoiceRecognitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoiceRecognitionImplToJson(
      this,
    );
  }
}

abstract class _VoiceRecognition implements VoiceRecognition {
  const factory _VoiceRecognition(
      {required final bool isEnabled,
      required final List<String> recognizedPhrases,
      required final double confidenceThreshold,
      required final String language,
      required final Map<String, double> phraseConfidence,
      final bool? backgroundListening,
      final Duration? sessionTimeout,
      final List<String>? customPhrases}) = _$VoiceRecognitionImpl;

  factory _VoiceRecognition.fromJson(Map<String, dynamic> json) =
      _$VoiceRecognitionImpl.fromJson;

  @override
  bool get isEnabled;
  @override
  List<String> get recognizedPhrases;
  @override
  double get confidenceThreshold;
  @override
  String get language;
  @override
  Map<String, double> get phraseConfidence;
  @override
  bool? get backgroundListening;
  @override
  Duration? get sessionTimeout;
  @override
  List<String>? get customPhrases;

  /// Create a copy of VoiceRecognition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceRecognitionImplCopyWith<_$VoiceRecognitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmartReminder _$SmartReminderFromJson(Map<String, dynamic> json) {
  return _SmartReminder.fromJson(json);
}

/// @nodoc
mixin _$SmartReminder {
  String get id => throw _privateConstructorUsedError;
  ReminderType get type => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Duration? get frequency => throw _privateConstructorUsedError;
  List<String>? get conditions => throw _privateConstructorUsedError;
  Map<String, dynamic>? get personalizedData =>
      throw _privateConstructorUsedError;

  /// Serializes this SmartReminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartReminderCopyWith<SmartReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartReminderCopyWith<$Res> {
  factory $SmartReminderCopyWith(
          SmartReminder value, $Res Function(SmartReminder) then) =
      _$SmartReminderCopyWithImpl<$Res, SmartReminder>;
  @useResult
  $Res call(
      {String id,
      ReminderType type,
      DateTime scheduledTime,
      bool isEnabled,
      String message,
      Duration? frequency,
      List<String>? conditions,
      Map<String, dynamic>? personalizedData});
}

/// @nodoc
class _$SmartReminderCopyWithImpl<$Res, $Val extends SmartReminder>
    implements $SmartReminderCopyWith<$Res> {
  _$SmartReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? scheduledTime = null,
    Object? isEnabled = null,
    Object? message = null,
    Object? frequency = freezed,
    Object? conditions = freezed,
    Object? personalizedData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as Duration?,
      conditions: freezed == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      personalizedData: freezed == personalizedData
          ? _value.personalizedData
          : personalizedData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartReminderImplCopyWith<$Res>
    implements $SmartReminderCopyWith<$Res> {
  factory _$$SmartReminderImplCopyWith(
          _$SmartReminderImpl value, $Res Function(_$SmartReminderImpl) then) =
      __$$SmartReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ReminderType type,
      DateTime scheduledTime,
      bool isEnabled,
      String message,
      Duration? frequency,
      List<String>? conditions,
      Map<String, dynamic>? personalizedData});
}

/// @nodoc
class __$$SmartReminderImplCopyWithImpl<$Res>
    extends _$SmartReminderCopyWithImpl<$Res, _$SmartReminderImpl>
    implements _$$SmartReminderImplCopyWith<$Res> {
  __$$SmartReminderImplCopyWithImpl(
      _$SmartReminderImpl _value, $Res Function(_$SmartReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? scheduledTime = null,
    Object? isEnabled = null,
    Object? message = null,
    Object? frequency = freezed,
    Object? conditions = freezed,
    Object? personalizedData = freezed,
  }) {
    return _then(_$SmartReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as Duration?,
      conditions: freezed == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      personalizedData: freezed == personalizedData
          ? _value._personalizedData
          : personalizedData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartReminderImpl implements _SmartReminder {
  const _$SmartReminderImpl(
      {required this.id,
      required this.type,
      required this.scheduledTime,
      required this.isEnabled,
      required this.message,
      this.frequency,
      final List<String>? conditions,
      final Map<String, dynamic>? personalizedData})
      : _conditions = conditions,
        _personalizedData = personalizedData;

  factory _$SmartReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartReminderImplFromJson(json);

  @override
  final String id;
  @override
  final ReminderType type;
  @override
  final DateTime scheduledTime;
  @override
  final bool isEnabled;
  @override
  final String message;
  @override
  final Duration? frequency;
  final List<String>? _conditions;
  @override
  List<String>? get conditions {
    final value = _conditions;
    if (value == null) return null;
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _personalizedData;
  @override
  Map<String, dynamic>? get personalizedData {
    final value = _personalizedData;
    if (value == null) return null;
    if (_personalizedData is EqualUnmodifiableMapView) return _personalizedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SmartReminder(id: $id, type: $type, scheduledTime: $scheduledTime, isEnabled: $isEnabled, message: $message, frequency: $frequency, conditions: $conditions, personalizedData: $personalizedData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            const DeepCollectionEquality()
                .equals(other._personalizedData, _personalizedData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      scheduledTime,
      isEnabled,
      message,
      frequency,
      const DeepCollectionEquality().hash(_conditions),
      const DeepCollectionEquality().hash(_personalizedData));

  /// Create a copy of SmartReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartReminderImplCopyWith<_$SmartReminderImpl> get copyWith =>
      __$$SmartReminderImplCopyWithImpl<_$SmartReminderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartReminderImplToJson(
      this,
    );
  }
}

abstract class _SmartReminder implements SmartReminder {
  const factory _SmartReminder(
      {required final String id,
      required final ReminderType type,
      required final DateTime scheduledTime,
      required final bool isEnabled,
      required final String message,
      final Duration? frequency,
      final List<String>? conditions,
      final Map<String, dynamic>? personalizedData}) = _$SmartReminderImpl;

  factory _SmartReminder.fromJson(Map<String, dynamic> json) =
      _$SmartReminderImpl.fromJson;

  @override
  String get id;
  @override
  ReminderType get type;
  @override
  DateTime get scheduledTime;
  @override
  bool get isEnabled;
  @override
  String get message;
  @override
  Duration? get frequency;
  @override
  List<String>? get conditions;
  @override
  Map<String, dynamic>? get personalizedData;

  /// Create a copy of SmartReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartReminderImplCopyWith<_$SmartReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
