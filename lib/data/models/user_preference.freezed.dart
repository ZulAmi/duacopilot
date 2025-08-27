// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPreference _$UserPreferenceFromJson(Map<String, dynamic> json) {
  return _UserPreference.fromJson(json);
}

/// @nodoc
mixin _$UserPreference {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // Changed from PreferenceType to String
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isSystem => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserPreference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferenceCopyWith<UserPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferenceCopyWith<$Res> {
  factory $UserPreferenceCopyWith(
          UserPreference value, $Res Function(UserPreference) then) =
      _$UserPreferenceCopyWithImpl<$Res, UserPreference>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String key,
      String value,
      String type,
      String? category,
      String? description,
      Map<String, dynamic>? metadata,
      bool isSystem,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserPreferenceCopyWithImpl<$Res, $Val extends UserPreference>
    implements $UserPreferenceCopyWith<$Res> {
  _$UserPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? key = null,
    Object? value = null,
    Object? type = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? isSystem = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferenceImplCopyWith<$Res>
    implements $UserPreferenceCopyWith<$Res> {
  factory _$$UserPreferenceImplCopyWith(_$UserPreferenceImpl value,
          $Res Function(_$UserPreferenceImpl) then) =
      __$$UserPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String key,
      String value,
      String type,
      String? category,
      String? description,
      Map<String, dynamic>? metadata,
      bool isSystem,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserPreferenceImplCopyWithImpl<$Res>
    extends _$UserPreferenceCopyWithImpl<$Res, _$UserPreferenceImpl>
    implements _$$UserPreferenceImplCopyWith<$Res> {
  __$$UserPreferenceImplCopyWithImpl(
      _$UserPreferenceImpl _value, $Res Function(_$UserPreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? key = null,
    Object? value = null,
    Object? type = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? isSystem = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserPreferenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferenceImpl implements _UserPreference {
  const _$UserPreferenceImpl(
      {required this.id,
      required this.userId,
      required this.key,
      required this.value,
      required this.type,
      this.category,
      this.description,
      final Map<String, dynamic>? metadata,
      this.isSystem = false,
      this.isActive = true,
      this.createdAt,
      this.updatedAt})
      : _metadata = metadata;

  factory _$UserPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferenceImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String key;
  @override
  final String value;
  @override
  final String type;
// Changed from PreferenceType to String
  @override
  final String? category;
  @override
  final String? description;
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
  final bool isSystem;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserPreference(id: $id, userId: $userId, key: $key, value: $value, type: $type, category: $category, description: $description, metadata: $metadata, isSystem: $isSystem, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      key,
      value,
      type,
      category,
      description,
      const DeepCollectionEquality().hash(_metadata),
      isSystem,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of UserPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferenceImplCopyWith<_$UserPreferenceImpl> get copyWith =>
      __$$UserPreferenceImplCopyWithImpl<_$UserPreferenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferenceImplToJson(
      this,
    );
  }
}

abstract class _UserPreference implements UserPreference {
  const factory _UserPreference(
      {required final String id,
      required final String userId,
      required final String key,
      required final String value,
      required final String type,
      final String? category,
      final String? description,
      final Map<String, dynamic>? metadata,
      final bool isSystem,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserPreferenceImpl;

  factory _UserPreference.fromJson(Map<String, dynamic> json) =
      _$UserPreferenceImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get key;
  @override
  String get value;
  @override
  String get type; // Changed from PreferenceType to String
  @override
  String? get category;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isSystem;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserPreference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferenceImplCopyWith<_$UserPreferenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
