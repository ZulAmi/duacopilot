// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'context_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserContext _$UserContextFromJson(Map<String, dynamic> json) {
  return _UserContext.fromJson(json);
}

/// @nodoc
mixin _$UserContext {
  String get userId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  LocationContext get location => throw _privateConstructorUsedError;
  TimeContext get time => throw _privateConstructorUsedError;
  UserPreferences get preferences => throw _privateConstructorUsedError;
  HabitStats get habits => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this UserContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserContextCopyWith<UserContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserContextCopyWith<$Res> {
  factory $UserContextCopyWith(
    UserContext value,
    $Res Function(UserContext) then,
  ) = _$UserContextCopyWithImpl<$Res, UserContext>;
  @useResult
  $Res call({
    String userId,
    DateTime timestamp,
    LocationContext location,
    TimeContext time,
    UserPreferences preferences,
    HabitStats habits,
    Map<String, dynamic>? metadata,
  });

  $LocationContextCopyWith<$Res> get location;
  $TimeContextCopyWith<$Res> get time;
  $UserPreferencesCopyWith<$Res> get preferences;
  $HabitStatsCopyWith<$Res> get habits;
}

/// @nodoc
class _$UserContextCopyWithImpl<$Res, $Val extends UserContext>
    implements $UserContextCopyWith<$Res> {
  _$UserContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? timestamp = null,
    Object? location = null,
    Object? time = null,
    Object? preferences = null,
    Object? habits = null,
    Object? metadata = freezed,
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
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as LocationContext,
            time:
                null == time
                    ? _value.time
                    : time // ignore: cast_nullable_to_non_nullable
                        as TimeContext,
            preferences:
                null == preferences
                    ? _value.preferences
                    : preferences // ignore: cast_nullable_to_non_nullable
                        as UserPreferences,
            habits:
                null == habits
                    ? _value.habits
                    : habits // ignore: cast_nullable_to_non_nullable
                        as HabitStats,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationContextCopyWith<$Res> get location {
    return $LocationContextCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeContextCopyWith<$Res> get time {
    return $TimeContextCopyWith<$Res>(_value.time, (value) {
      return _then(_value.copyWith(time: value) as $Val);
    });
  }

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res> get preferences {
    return $UserPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HabitStatsCopyWith<$Res> get habits {
    return $HabitStatsCopyWith<$Res>(_value.habits, (value) {
      return _then(_value.copyWith(habits: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserContextImplCopyWith<$Res>
    implements $UserContextCopyWith<$Res> {
  factory _$$UserContextImplCopyWith(
    _$UserContextImpl value,
    $Res Function(_$UserContextImpl) then,
  ) = __$$UserContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    DateTime timestamp,
    LocationContext location,
    TimeContext time,
    UserPreferences preferences,
    HabitStats habits,
    Map<String, dynamic>? metadata,
  });

  @override
  $LocationContextCopyWith<$Res> get location;
  @override
  $TimeContextCopyWith<$Res> get time;
  @override
  $UserPreferencesCopyWith<$Res> get preferences;
  @override
  $HabitStatsCopyWith<$Res> get habits;
}

/// @nodoc
class __$$UserContextImplCopyWithImpl<$Res>
    extends _$UserContextCopyWithImpl<$Res, _$UserContextImpl>
    implements _$$UserContextImplCopyWith<$Res> {
  __$$UserContextImplCopyWithImpl(
    _$UserContextImpl _value,
    $Res Function(_$UserContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? timestamp = null,
    Object? location = null,
    Object? time = null,
    Object? preferences = null,
    Object? habits = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$UserContextImpl(
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
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as LocationContext,
        time:
            null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                    as TimeContext,
        preferences:
            null == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                    as UserPreferences,
        habits:
            null == habits
                ? _value.habits
                : habits // ignore: cast_nullable_to_non_nullable
                    as HabitStats,
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
class _$UserContextImpl implements _UserContext {
  const _$UserContextImpl({
    required this.userId,
    required this.timestamp,
    required this.location,
    required this.time,
    required this.preferences,
    required this.habits,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$UserContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserContextImplFromJson(json);

  @override
  final String userId;
  @override
  final DateTime timestamp;
  @override
  final LocationContext location;
  @override
  final TimeContext time;
  @override
  final UserPreferences preferences;
  @override
  final HabitStats habits;
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
    return 'UserContext(userId: $userId, timestamp: $timestamp, location: $location, time: $time, preferences: $preferences, habits: $habits, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserContextImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
            (identical(other.habits, habits) || other.habits == habits) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    timestamp,
    location,
    time,
    preferences,
    habits,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserContextImplCopyWith<_$UserContextImpl> get copyWith =>
      __$$UserContextImplCopyWithImpl<_$UserContextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserContextImplToJson(this);
  }
}

abstract class _UserContext implements UserContext {
  const factory _UserContext({
    required final String userId,
    required final DateTime timestamp,
    required final LocationContext location,
    required final TimeContext time,
    required final UserPreferences preferences,
    required final HabitStats habits,
    final Map<String, dynamic>? metadata,
  }) = _$UserContextImpl;

  factory _UserContext.fromJson(Map<String, dynamic> json) =
      _$UserContextImpl.fromJson;

  @override
  String get userId;
  @override
  DateTime get timestamp;
  @override
  LocationContext get location;
  @override
  TimeContext get time;
  @override
  UserPreferences get preferences;
  @override
  HabitStats get habits;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserContextImplCopyWith<_$UserContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  LocationType? get type => throw _privateConstructorUsedError;
  List<String>? get nearbyPlaces => throw _privateConstructorUsedError;

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
    String? address,
    String? city,
    String? country,
    LocationType? type,
    List<String>? nearbyPlaces,
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
    Object? address = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? type = freezed,
    Object? nearbyPlaces = freezed,
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
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as LocationType?,
            nearbyPlaces:
                freezed == nearbyPlaces
                    ? _value.nearbyPlaces
                    : nearbyPlaces // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
    String? address,
    String? city,
    String? country,
    LocationType? type,
    List<String>? nearbyPlaces,
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
    Object? address = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? type = freezed,
    Object? nearbyPlaces = freezed,
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
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as LocationType?,
        nearbyPlaces:
            freezed == nearbyPlaces
                ? _value._nearbyPlaces
                : nearbyPlaces // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
    this.address,
    this.city,
    this.country,
    this.type,
    final List<String>? nearbyPlaces,
  }) : _nearbyPlaces = nearbyPlaces;

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
  final String? address;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final LocationType? type;
  final List<String>? _nearbyPlaces;
  @override
  List<String>? get nearbyPlaces {
    final value = _nearbyPlaces;
    if (value == null) return null;
    if (_nearbyPlaces is EqualUnmodifiableListView) return _nearbyPlaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LocationContext(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, timestamp: $timestamp, address: $address, city: $city, country: $country, type: $type, nearbyPlaces: $nearbyPlaces)';
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
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._nearbyPlaces,
              _nearbyPlaces,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    accuracy,
    timestamp,
    address,
    city,
    country,
    type,
    const DeepCollectionEquality().hash(_nearbyPlaces),
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
    final String? address,
    final String? city,
    final String? country,
    final LocationType? type,
    final List<String>? nearbyPlaces,
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
  String? get address;
  @override
  String? get city;
  @override
  String? get country;
  @override
  LocationType? get type;
  @override
  List<String>? get nearbyPlaces;

  /// Create a copy of LocationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationContextImplCopyWith<_$LocationContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeContext _$TimeContextFromJson(Map<String, dynamic> json) {
  return _TimeContext.fromJson(json);
}

/// @nodoc
mixin _$TimeContext {
  DateTime get currentTime => throw _privateConstructorUsedError;
  TimeOfDay get timeOfDay => throw _privateConstructorUsedError;
  IslamicDate get islamicDate => throw _privateConstructorUsedError;
  PrayerTimes get prayerTimes => throw _privateConstructorUsedError;
  List<String> get specialOccasions => throw _privateConstructorUsedError;
  bool get isRamadan => throw _privateConstructorUsedError;
  bool get isHajjSeason => throw _privateConstructorUsedError;

  /// Serializes this TimeContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeContextCopyWith<TimeContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeContextCopyWith<$Res> {
  factory $TimeContextCopyWith(
    TimeContext value,
    $Res Function(TimeContext) then,
  ) = _$TimeContextCopyWithImpl<$Res, TimeContext>;
  @useResult
  $Res call({
    DateTime currentTime,
    TimeOfDay timeOfDay,
    IslamicDate islamicDate,
    PrayerTimes prayerTimes,
    List<String> specialOccasions,
    bool isRamadan,
    bool isHajjSeason,
  });

  $IslamicDateCopyWith<$Res> get islamicDate;
  $PrayerTimesCopyWith<$Res> get prayerTimes;
}

/// @nodoc
class _$TimeContextCopyWithImpl<$Res, $Val extends TimeContext>
    implements $TimeContextCopyWith<$Res> {
  _$TimeContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTime = null,
    Object? timeOfDay = null,
    Object? islamicDate = null,
    Object? prayerTimes = null,
    Object? specialOccasions = null,
    Object? isRamadan = null,
    Object? isHajjSeason = null,
  }) {
    return _then(
      _value.copyWith(
            currentTime:
                null == currentTime
                    ? _value.currentTime
                    : currentTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            timeOfDay:
                null == timeOfDay
                    ? _value.timeOfDay
                    : timeOfDay // ignore: cast_nullable_to_non_nullable
                        as TimeOfDay,
            islamicDate:
                null == islamicDate
                    ? _value.islamicDate
                    : islamicDate // ignore: cast_nullable_to_non_nullable
                        as IslamicDate,
            prayerTimes:
                null == prayerTimes
                    ? _value.prayerTimes
                    : prayerTimes // ignore: cast_nullable_to_non_nullable
                        as PrayerTimes,
            specialOccasions:
                null == specialOccasions
                    ? _value.specialOccasions
                    : specialOccasions // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            isRamadan:
                null == isRamadan
                    ? _value.isRamadan
                    : isRamadan // ignore: cast_nullable_to_non_nullable
                        as bool,
            isHajjSeason:
                null == isHajjSeason
                    ? _value.isHajjSeason
                    : isHajjSeason // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IslamicDateCopyWith<$Res> get islamicDate {
    return $IslamicDateCopyWith<$Res>(_value.islamicDate, (value) {
      return _then(_value.copyWith(islamicDate: value) as $Val);
    });
  }

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrayerTimesCopyWith<$Res> get prayerTimes {
    return $PrayerTimesCopyWith<$Res>(_value.prayerTimes, (value) {
      return _then(_value.copyWith(prayerTimes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimeContextImplCopyWith<$Res>
    implements $TimeContextCopyWith<$Res> {
  factory _$$TimeContextImplCopyWith(
    _$TimeContextImpl value,
    $Res Function(_$TimeContextImpl) then,
  ) = __$$TimeContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime currentTime,
    TimeOfDay timeOfDay,
    IslamicDate islamicDate,
    PrayerTimes prayerTimes,
    List<String> specialOccasions,
    bool isRamadan,
    bool isHajjSeason,
  });

  @override
  $IslamicDateCopyWith<$Res> get islamicDate;
  @override
  $PrayerTimesCopyWith<$Res> get prayerTimes;
}

/// @nodoc
class __$$TimeContextImplCopyWithImpl<$Res>
    extends _$TimeContextCopyWithImpl<$Res, _$TimeContextImpl>
    implements _$$TimeContextImplCopyWith<$Res> {
  __$$TimeContextImplCopyWithImpl(
    _$TimeContextImpl _value,
    $Res Function(_$TimeContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTime = null,
    Object? timeOfDay = null,
    Object? islamicDate = null,
    Object? prayerTimes = null,
    Object? specialOccasions = null,
    Object? isRamadan = null,
    Object? isHajjSeason = null,
  }) {
    return _then(
      _$TimeContextImpl(
        currentTime:
            null == currentTime
                ? _value.currentTime
                : currentTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        timeOfDay:
            null == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                    as TimeOfDay,
        islamicDate:
            null == islamicDate
                ? _value.islamicDate
                : islamicDate // ignore: cast_nullable_to_non_nullable
                    as IslamicDate,
        prayerTimes:
            null == prayerTimes
                ? _value.prayerTimes
                : prayerTimes // ignore: cast_nullable_to_non_nullable
                    as PrayerTimes,
        specialOccasions:
            null == specialOccasions
                ? _value._specialOccasions
                : specialOccasions // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        isRamadan:
            null == isRamadan
                ? _value.isRamadan
                : isRamadan // ignore: cast_nullable_to_non_nullable
                    as bool,
        isHajjSeason:
            null == isHajjSeason
                ? _value.isHajjSeason
                : isHajjSeason // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeContextImpl implements _TimeContext {
  const _$TimeContextImpl({
    required this.currentTime,
    required this.timeOfDay,
    required this.islamicDate,
    required this.prayerTimes,
    final List<String> specialOccasions = const [],
    this.isRamadan = false,
    this.isHajjSeason = false,
  }) : _specialOccasions = specialOccasions;

  factory _$TimeContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeContextImplFromJson(json);

  @override
  final DateTime currentTime;
  @override
  final TimeOfDay timeOfDay;
  @override
  final IslamicDate islamicDate;
  @override
  final PrayerTimes prayerTimes;
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
  @JsonKey()
  final bool isRamadan;
  @override
  @JsonKey()
  final bool isHajjSeason;

  @override
  String toString() {
    return 'TimeContext(currentTime: $currentTime, timeOfDay: $timeOfDay, islamicDate: $islamicDate, prayerTimes: $prayerTimes, specialOccasions: $specialOccasions, isRamadan: $isRamadan, isHajjSeason: $isHajjSeason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeContextImpl &&
            (identical(other.currentTime, currentTime) ||
                other.currentTime == currentTime) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.islamicDate, islamicDate) ||
                other.islamicDate == islamicDate) &&
            (identical(other.prayerTimes, prayerTimes) ||
                other.prayerTimes == prayerTimes) &&
            const DeepCollectionEquality().equals(
              other._specialOccasions,
              _specialOccasions,
            ) &&
            (identical(other.isRamadan, isRamadan) ||
                other.isRamadan == isRamadan) &&
            (identical(other.isHajjSeason, isHajjSeason) ||
                other.isHajjSeason == isHajjSeason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentTime,
    timeOfDay,
    islamicDate,
    prayerTimes,
    const DeepCollectionEquality().hash(_specialOccasions),
    isRamadan,
    isHajjSeason,
  );

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeContextImplCopyWith<_$TimeContextImpl> get copyWith =>
      __$$TimeContextImplCopyWithImpl<_$TimeContextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeContextImplToJson(this);
  }
}

abstract class _TimeContext implements TimeContext {
  const factory _TimeContext({
    required final DateTime currentTime,
    required final TimeOfDay timeOfDay,
    required final IslamicDate islamicDate,
    required final PrayerTimes prayerTimes,
    final List<String> specialOccasions,
    final bool isRamadan,
    final bool isHajjSeason,
  }) = _$TimeContextImpl;

  factory _TimeContext.fromJson(Map<String, dynamic> json) =
      _$TimeContextImpl.fromJson;

  @override
  DateTime get currentTime;
  @override
  TimeOfDay get timeOfDay;
  @override
  IslamicDate get islamicDate;
  @override
  PrayerTimes get prayerTimes;
  @override
  List<String> get specialOccasions;
  @override
  bool get isRamadan;
  @override
  bool get isHajjSeason;

  /// Create a copy of TimeContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeContextImplCopyWith<_$TimeContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IslamicDate _$IslamicDateFromJson(Map<String, dynamic> json) {
  return _IslamicDate.fromJson(json);
}

/// @nodoc
mixin _$IslamicDate {
  int get day => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  String get monthName => throw _privateConstructorUsedError;
  bool get isHolyMonth => throw _privateConstructorUsedError;
  List<String>? get significantEvents => throw _privateConstructorUsedError;

  /// Serializes this IslamicDate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IslamicDate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IslamicDateCopyWith<IslamicDate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IslamicDateCopyWith<$Res> {
  factory $IslamicDateCopyWith(
    IslamicDate value,
    $Res Function(IslamicDate) then,
  ) = _$IslamicDateCopyWithImpl<$Res, IslamicDate>;
  @useResult
  $Res call({
    int day,
    int month,
    int year,
    String monthName,
    bool isHolyMonth,
    List<String>? significantEvents,
  });
}

/// @nodoc
class _$IslamicDateCopyWithImpl<$Res, $Val extends IslamicDate>
    implements $IslamicDateCopyWith<$Res> {
  _$IslamicDateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IslamicDate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? month = null,
    Object? year = null,
    Object? monthName = null,
    Object? isHolyMonth = null,
    Object? significantEvents = freezed,
  }) {
    return _then(
      _value.copyWith(
            day:
                null == day
                    ? _value.day
                    : day // ignore: cast_nullable_to_non_nullable
                        as int,
            month:
                null == month
                    ? _value.month
                    : month // ignore: cast_nullable_to_non_nullable
                        as int,
            year:
                null == year
                    ? _value.year
                    : year // ignore: cast_nullable_to_non_nullable
                        as int,
            monthName:
                null == monthName
                    ? _value.monthName
                    : monthName // ignore: cast_nullable_to_non_nullable
                        as String,
            isHolyMonth:
                null == isHolyMonth
                    ? _value.isHolyMonth
                    : isHolyMonth // ignore: cast_nullable_to_non_nullable
                        as bool,
            significantEvents:
                freezed == significantEvents
                    ? _value.significantEvents
                    : significantEvents // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IslamicDateImplCopyWith<$Res>
    implements $IslamicDateCopyWith<$Res> {
  factory _$$IslamicDateImplCopyWith(
    _$IslamicDateImpl value,
    $Res Function(_$IslamicDateImpl) then,
  ) = __$$IslamicDateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int day,
    int month,
    int year,
    String monthName,
    bool isHolyMonth,
    List<String>? significantEvents,
  });
}

/// @nodoc
class __$$IslamicDateImplCopyWithImpl<$Res>
    extends _$IslamicDateCopyWithImpl<$Res, _$IslamicDateImpl>
    implements _$$IslamicDateImplCopyWith<$Res> {
  __$$IslamicDateImplCopyWithImpl(
    _$IslamicDateImpl _value,
    $Res Function(_$IslamicDateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IslamicDate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? month = null,
    Object? year = null,
    Object? monthName = null,
    Object? isHolyMonth = null,
    Object? significantEvents = freezed,
  }) {
    return _then(
      _$IslamicDateImpl(
        day:
            null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                    as int,
        month:
            null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                    as int,
        year:
            null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                    as int,
        monthName:
            null == monthName
                ? _value.monthName
                : monthName // ignore: cast_nullable_to_non_nullable
                    as String,
        isHolyMonth:
            null == isHolyMonth
                ? _value.isHolyMonth
                : isHolyMonth // ignore: cast_nullable_to_non_nullable
                    as bool,
        significantEvents:
            freezed == significantEvents
                ? _value._significantEvents
                : significantEvents // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IslamicDateImpl implements _IslamicDate {
  const _$IslamicDateImpl({
    required this.day,
    required this.month,
    required this.year,
    required this.monthName,
    required this.isHolyMonth,
    final List<String>? significantEvents,
  }) : _significantEvents = significantEvents;

  factory _$IslamicDateImpl.fromJson(Map<String, dynamic> json) =>
      _$$IslamicDateImplFromJson(json);

  @override
  final int day;
  @override
  final int month;
  @override
  final int year;
  @override
  final String monthName;
  @override
  final bool isHolyMonth;
  final List<String>? _significantEvents;
  @override
  List<String>? get significantEvents {
    final value = _significantEvents;
    if (value == null) return null;
    if (_significantEvents is EqualUnmodifiableListView)
      return _significantEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'IslamicDate(day: $day, month: $month, year: $year, monthName: $monthName, isHolyMonth: $isHolyMonth, significantEvents: $significantEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IslamicDateImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.monthName, monthName) ||
                other.monthName == monthName) &&
            (identical(other.isHolyMonth, isHolyMonth) ||
                other.isHolyMonth == isHolyMonth) &&
            const DeepCollectionEquality().equals(
              other._significantEvents,
              _significantEvents,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    month,
    year,
    monthName,
    isHolyMonth,
    const DeepCollectionEquality().hash(_significantEvents),
  );

  /// Create a copy of IslamicDate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IslamicDateImplCopyWith<_$IslamicDateImpl> get copyWith =>
      __$$IslamicDateImplCopyWithImpl<_$IslamicDateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IslamicDateImplToJson(this);
  }
}

abstract class _IslamicDate implements IslamicDate {
  const factory _IslamicDate({
    required final int day,
    required final int month,
    required final int year,
    required final String monthName,
    required final bool isHolyMonth,
    final List<String>? significantEvents,
  }) = _$IslamicDateImpl;

  factory _IslamicDate.fromJson(Map<String, dynamic> json) =
      _$IslamicDateImpl.fromJson;

  @override
  int get day;
  @override
  int get month;
  @override
  int get year;
  @override
  String get monthName;
  @override
  bool get isHolyMonth;
  @override
  List<String>? get significantEvents;

  /// Create a copy of IslamicDate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IslamicDateImplCopyWith<_$IslamicDateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrayerTimes _$PrayerTimesFromJson(Map<String, dynamic> json) {
  return _PrayerTimes.fromJson(json);
}

/// @nodoc
mixin _$PrayerTimes {
  DateTime get fajr => throw _privateConstructorUsedError;
  DateTime get sunrise => throw _privateConstructorUsedError;
  DateTime get dhuhr => throw _privateConstructorUsedError;
  DateTime get asr => throw _privateConstructorUsedError;
  DateTime get maghrib => throw _privateConstructorUsedError;
  DateTime get isha => throw _privateConstructorUsedError;
  NextPrayer? get nextPrayer => throw _privateConstructorUsedError;
  Duration? get timeToNext => throw _privateConstructorUsedError;

  /// Serializes this PrayerTimes to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrayerTimes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerTimesCopyWith<PrayerTimes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerTimesCopyWith<$Res> {
  factory $PrayerTimesCopyWith(
    PrayerTimes value,
    $Res Function(PrayerTimes) then,
  ) = _$PrayerTimesCopyWithImpl<$Res, PrayerTimes>;
  @useResult
  $Res call({
    DateTime fajr,
    DateTime sunrise,
    DateTime dhuhr,
    DateTime asr,
    DateTime maghrib,
    DateTime isha,
    NextPrayer? nextPrayer,
    Duration? timeToNext,
  });

  $NextPrayerCopyWith<$Res>? get nextPrayer;
}

/// @nodoc
class _$PrayerTimesCopyWithImpl<$Res, $Val extends PrayerTimes>
    implements $PrayerTimesCopyWith<$Res> {
  _$PrayerTimesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerTimes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fajr = null,
    Object? sunrise = null,
    Object? dhuhr = null,
    Object? asr = null,
    Object? maghrib = null,
    Object? isha = null,
    Object? nextPrayer = freezed,
    Object? timeToNext = freezed,
  }) {
    return _then(
      _value.copyWith(
            fajr:
                null == fajr
                    ? _value.fajr
                    : fajr // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            sunrise:
                null == sunrise
                    ? _value.sunrise
                    : sunrise // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            dhuhr:
                null == dhuhr
                    ? _value.dhuhr
                    : dhuhr // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            asr:
                null == asr
                    ? _value.asr
                    : asr // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            maghrib:
                null == maghrib
                    ? _value.maghrib
                    : maghrib // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isha:
                null == isha
                    ? _value.isha
                    : isha // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            nextPrayer:
                freezed == nextPrayer
                    ? _value.nextPrayer
                    : nextPrayer // ignore: cast_nullable_to_non_nullable
                        as NextPrayer?,
            timeToNext:
                freezed == timeToNext
                    ? _value.timeToNext
                    : timeToNext // ignore: cast_nullable_to_non_nullable
                        as Duration?,
          )
          as $Val,
    );
  }

  /// Create a copy of PrayerTimes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NextPrayerCopyWith<$Res>? get nextPrayer {
    if (_value.nextPrayer == null) {
      return null;
    }

    return $NextPrayerCopyWith<$Res>(_value.nextPrayer!, (value) {
      return _then(_value.copyWith(nextPrayer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrayerTimesImplCopyWith<$Res>
    implements $PrayerTimesCopyWith<$Res> {
  factory _$$PrayerTimesImplCopyWith(
    _$PrayerTimesImpl value,
    $Res Function(_$PrayerTimesImpl) then,
  ) = __$$PrayerTimesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime fajr,
    DateTime sunrise,
    DateTime dhuhr,
    DateTime asr,
    DateTime maghrib,
    DateTime isha,
    NextPrayer? nextPrayer,
    Duration? timeToNext,
  });

  @override
  $NextPrayerCopyWith<$Res>? get nextPrayer;
}

/// @nodoc
class __$$PrayerTimesImplCopyWithImpl<$Res>
    extends _$PrayerTimesCopyWithImpl<$Res, _$PrayerTimesImpl>
    implements _$$PrayerTimesImplCopyWith<$Res> {
  __$$PrayerTimesImplCopyWithImpl(
    _$PrayerTimesImpl _value,
    $Res Function(_$PrayerTimesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerTimes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fajr = null,
    Object? sunrise = null,
    Object? dhuhr = null,
    Object? asr = null,
    Object? maghrib = null,
    Object? isha = null,
    Object? nextPrayer = freezed,
    Object? timeToNext = freezed,
  }) {
    return _then(
      _$PrayerTimesImpl(
        fajr:
            null == fajr
                ? _value.fajr
                : fajr // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        sunrise:
            null == sunrise
                ? _value.sunrise
                : sunrise // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        dhuhr:
            null == dhuhr
                ? _value.dhuhr
                : dhuhr // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        asr:
            null == asr
                ? _value.asr
                : asr // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        maghrib:
            null == maghrib
                ? _value.maghrib
                : maghrib // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isha:
            null == isha
                ? _value.isha
                : isha // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        nextPrayer:
            freezed == nextPrayer
                ? _value.nextPrayer
                : nextPrayer // ignore: cast_nullable_to_non_nullable
                    as NextPrayer?,
        timeToNext:
            freezed == timeToNext
                ? _value.timeToNext
                : timeToNext // ignore: cast_nullable_to_non_nullable
                    as Duration?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrayerTimesImpl implements _PrayerTimes {
  const _$PrayerTimesImpl({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.nextPrayer,
    this.timeToNext,
  });

  factory _$PrayerTimesImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerTimesImplFromJson(json);

  @override
  final DateTime fajr;
  @override
  final DateTime sunrise;
  @override
  final DateTime dhuhr;
  @override
  final DateTime asr;
  @override
  final DateTime maghrib;
  @override
  final DateTime isha;
  @override
  final NextPrayer? nextPrayer;
  @override
  final Duration? timeToNext;

  @override
  String toString() {
    return 'PrayerTimes(fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, asr: $asr, maghrib: $maghrib, isha: $isha, nextPrayer: $nextPrayer, timeToNext: $timeToNext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimesImpl &&
            (identical(other.fajr, fajr) || other.fajr == fajr) &&
            (identical(other.sunrise, sunrise) || other.sunrise == sunrise) &&
            (identical(other.dhuhr, dhuhr) || other.dhuhr == dhuhr) &&
            (identical(other.asr, asr) || other.asr == asr) &&
            (identical(other.maghrib, maghrib) || other.maghrib == maghrib) &&
            (identical(other.isha, isha) || other.isha == isha) &&
            (identical(other.nextPrayer, nextPrayer) ||
                other.nextPrayer == nextPrayer) &&
            (identical(other.timeToNext, timeToNext) ||
                other.timeToNext == timeToNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fajr,
    sunrise,
    dhuhr,
    asr,
    maghrib,
    isha,
    nextPrayer,
    timeToNext,
  );

  /// Create a copy of PrayerTimes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimesImplCopyWith<_$PrayerTimesImpl> get copyWith =>
      __$$PrayerTimesImplCopyWithImpl<_$PrayerTimesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerTimesImplToJson(this);
  }
}

abstract class _PrayerTimes implements PrayerTimes {
  const factory _PrayerTimes({
    required final DateTime fajr,
    required final DateTime sunrise,
    required final DateTime dhuhr,
    required final DateTime asr,
    required final DateTime maghrib,
    required final DateTime isha,
    final NextPrayer? nextPrayer,
    final Duration? timeToNext,
  }) = _$PrayerTimesImpl;

  factory _PrayerTimes.fromJson(Map<String, dynamic> json) =
      _$PrayerTimesImpl.fromJson;

  @override
  DateTime get fajr;
  @override
  DateTime get sunrise;
  @override
  DateTime get dhuhr;
  @override
  DateTime get asr;
  @override
  DateTime get maghrib;
  @override
  DateTime get isha;
  @override
  NextPrayer? get nextPrayer;
  @override
  Duration? get timeToNext;

  /// Create a copy of PrayerTimes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimesImplCopyWith<_$PrayerTimesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NextPrayer _$NextPrayerFromJson(Map<String, dynamic> json) {
  return _NextPrayer.fromJson(json);
}

/// @nodoc
mixin _$NextPrayer {
  PrayerType get type => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  Duration get remaining => throw _privateConstructorUsedError;

  /// Serializes this NextPrayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NextPrayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NextPrayerCopyWith<NextPrayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NextPrayerCopyWith<$Res> {
  factory $NextPrayerCopyWith(
    NextPrayer value,
    $Res Function(NextPrayer) then,
  ) = _$NextPrayerCopyWithImpl<$Res, NextPrayer>;
  @useResult
  $Res call({PrayerType type, DateTime time, Duration remaining});
}

/// @nodoc
class _$NextPrayerCopyWithImpl<$Res, $Val extends NextPrayer>
    implements $NextPrayerCopyWith<$Res> {
  _$NextPrayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NextPrayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? time = null,
    Object? remaining = null,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as PrayerType,
            time:
                null == time
                    ? _value.time
                    : time // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            remaining:
                null == remaining
                    ? _value.remaining
                    : remaining // ignore: cast_nullable_to_non_nullable
                        as Duration,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NextPrayerImplCopyWith<$Res>
    implements $NextPrayerCopyWith<$Res> {
  factory _$$NextPrayerImplCopyWith(
    _$NextPrayerImpl value,
    $Res Function(_$NextPrayerImpl) then,
  ) = __$$NextPrayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PrayerType type, DateTime time, Duration remaining});
}

/// @nodoc
class __$$NextPrayerImplCopyWithImpl<$Res>
    extends _$NextPrayerCopyWithImpl<$Res, _$NextPrayerImpl>
    implements _$$NextPrayerImplCopyWith<$Res> {
  __$$NextPrayerImplCopyWithImpl(
    _$NextPrayerImpl _value,
    $Res Function(_$NextPrayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NextPrayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? time = null,
    Object? remaining = null,
  }) {
    return _then(
      _$NextPrayerImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as PrayerType,
        time:
            null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        remaining:
            null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                    as Duration,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NextPrayerImpl implements _NextPrayer {
  const _$NextPrayerImpl({
    required this.type,
    required this.time,
    required this.remaining,
  });

  factory _$NextPrayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$NextPrayerImplFromJson(json);

  @override
  final PrayerType type;
  @override
  final DateTime time;
  @override
  final Duration remaining;

  @override
  String toString() {
    return 'NextPrayer(type: $type, time: $time, remaining: $remaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextPrayerImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, time, remaining);

  /// Create a copy of NextPrayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextPrayerImplCopyWith<_$NextPrayerImpl> get copyWith =>
      __$$NextPrayerImplCopyWithImpl<_$NextPrayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NextPrayerImplToJson(this);
  }
}

abstract class _NextPrayer implements NextPrayer {
  const factory _NextPrayer({
    required final PrayerType type,
    required final DateTime time,
    required final Duration remaining,
  }) = _$NextPrayerImpl;

  factory _NextPrayer.fromJson(Map<String, dynamic> json) =
      _$NextPrayerImpl.fromJson;

  @override
  PrayerType get type;
  @override
  DateTime get time;
  @override
  Duration get remaining;

  /// Create a copy of NextPrayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextPrayerImplCopyWith<_$NextPrayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  String get language => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  NotificationSettings get notifications => throw _privateConstructorUsedError;
  AudioSettings get audio => throw _privateConstructorUsedError;
  bool get locationEnabled => throw _privateConstructorUsedError;
  bool get smartSuggestions => throw _privateConstructorUsedError;
  List<String> get favoriteCategories => throw _privateConstructorUsedError;
  Map<String, dynamic> get customSettings => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
    UserPreferences value,
    $Res Function(UserPreferences) then,
  ) = _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call({
    String language,
    String region,
    NotificationSettings notifications,
    AudioSettings audio,
    bool locationEnabled,
    bool smartSuggestions,
    List<String> favoriteCategories,
    Map<String, dynamic> customSettings,
  });

  $NotificationSettingsCopyWith<$Res> get notifications;
  $AudioSettingsCopyWith<$Res> get audio;
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? region = null,
    Object? notifications = null,
    Object? audio = null,
    Object? locationEnabled = null,
    Object? smartSuggestions = null,
    Object? favoriteCategories = null,
    Object? customSettings = null,
  }) {
    return _then(
      _value.copyWith(
            language:
                null == language
                    ? _value.language
                    : language // ignore: cast_nullable_to_non_nullable
                        as String,
            region:
                null == region
                    ? _value.region
                    : region // ignore: cast_nullable_to_non_nullable
                        as String,
            notifications:
                null == notifications
                    ? _value.notifications
                    : notifications // ignore: cast_nullable_to_non_nullable
                        as NotificationSettings,
            audio:
                null == audio
                    ? _value.audio
                    : audio // ignore: cast_nullable_to_non_nullable
                        as AudioSettings,
            locationEnabled:
                null == locationEnabled
                    ? _value.locationEnabled
                    : locationEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            smartSuggestions:
                null == smartSuggestions
                    ? _value.smartSuggestions
                    : smartSuggestions // ignore: cast_nullable_to_non_nullable
                        as bool,
            favoriteCategories:
                null == favoriteCategories
                    ? _value.favoriteCategories
                    : favoriteCategories // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            customSettings:
                null == customSettings
                    ? _value.customSettings
                    : customSettings // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
          )
          as $Val,
    );
  }

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationSettingsCopyWith<$Res> get notifications {
    return $NotificationSettingsCopyWith<$Res>(_value.notifications, (value) {
      return _then(_value.copyWith(notifications: value) as $Val);
    });
  }

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AudioSettingsCopyWith<$Res> get audio {
    return $AudioSettingsCopyWith<$Res>(_value.audio, (value) {
      return _then(_value.copyWith(audio: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(
    _$UserPreferencesImpl value,
    $Res Function(_$UserPreferencesImpl) then,
  ) = __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String language,
    String region,
    NotificationSettings notifications,
    AudioSettings audio,
    bool locationEnabled,
    bool smartSuggestions,
    List<String> favoriteCategories,
    Map<String, dynamic> customSettings,
  });

  @override
  $NotificationSettingsCopyWith<$Res> get notifications;
  @override
  $AudioSettingsCopyWith<$Res> get audio;
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
    _$UserPreferencesImpl _value,
    $Res Function(_$UserPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? region = null,
    Object? notifications = null,
    Object? audio = null,
    Object? locationEnabled = null,
    Object? smartSuggestions = null,
    Object? favoriteCategories = null,
    Object? customSettings = null,
  }) {
    return _then(
      _$UserPreferencesImpl(
        language:
            null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                    as String,
        region:
            null == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                    as String,
        notifications:
            null == notifications
                ? _value.notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                    as NotificationSettings,
        audio:
            null == audio
                ? _value.audio
                : audio // ignore: cast_nullable_to_non_nullable
                    as AudioSettings,
        locationEnabled:
            null == locationEnabled
                ? _value.locationEnabled
                : locationEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        smartSuggestions:
            null == smartSuggestions
                ? _value.smartSuggestions
                : smartSuggestions // ignore: cast_nullable_to_non_nullable
                    as bool,
        favoriteCategories:
            null == favoriteCategories
                ? _value._favoriteCategories
                : favoriteCategories // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        customSettings:
            null == customSettings
                ? _value._customSettings
                : customSettings // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl({
    required this.language,
    required this.region,
    required this.notifications,
    required this.audio,
    this.locationEnabled = true,
    this.smartSuggestions = true,
    final List<String> favoriteCategories = const ['general'],
    final Map<String, dynamic> customSettings = const {},
  }) : _favoriteCategories = favoriteCategories,
       _customSettings = customSettings;

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  final String language;
  @override
  final String region;
  @override
  final NotificationSettings notifications;
  @override
  final AudioSettings audio;
  @override
  @JsonKey()
  final bool locationEnabled;
  @override
  @JsonKey()
  final bool smartSuggestions;
  final List<String> _favoriteCategories;
  @override
  @JsonKey()
  List<String> get favoriteCategories {
    if (_favoriteCategories is EqualUnmodifiableListView)
      return _favoriteCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteCategories);
  }

  final Map<String, dynamic> _customSettings;
  @override
  @JsonKey()
  Map<String, dynamic> get customSettings {
    if (_customSettings is EqualUnmodifiableMapView) return _customSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customSettings);
  }

  @override
  String toString() {
    return 'UserPreferences(language: $language, region: $region, notifications: $notifications, audio: $audio, locationEnabled: $locationEnabled, smartSuggestions: $smartSuggestions, favoriteCategories: $favoriteCategories, customSettings: $customSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.notifications, notifications) ||
                other.notifications == notifications) &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.locationEnabled, locationEnabled) ||
                other.locationEnabled == locationEnabled) &&
            (identical(other.smartSuggestions, smartSuggestions) ||
                other.smartSuggestions == smartSuggestions) &&
            const DeepCollectionEquality().equals(
              other._favoriteCategories,
              _favoriteCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._customSettings,
              _customSettings,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    language,
    region,
    notifications,
    audio,
    locationEnabled,
    smartSuggestions,
    const DeepCollectionEquality().hash(_favoriteCategories),
    const DeepCollectionEquality().hash(_customSettings),
  );

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(this);
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences({
    required final String language,
    required final String region,
    required final NotificationSettings notifications,
    required final AudioSettings audio,
    final bool locationEnabled,
    final bool smartSuggestions,
    final List<String> favoriteCategories,
    final Map<String, dynamic> customSettings,
  }) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  String get language;
  @override
  String get region;
  @override
  NotificationSettings get notifications;
  @override
  AudioSettings get audio;
  @override
  bool get locationEnabled;
  @override
  bool get smartSuggestions;
  @override
  List<String> get favoriteCategories;
  @override
  Map<String, dynamic> get customSettings;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  bool get enabled => throw _privateConstructorUsedError;
  bool get prayerReminders => throw _privateConstructorUsedError;
  bool get dailyDua => throw _privateConstructorUsedError;
  bool get contextualSuggestions => throw _privateConstructorUsedError;
  bool get habitReminders => throw _privateConstructorUsedError;
  List<String> get quietHours => throw _privateConstructorUsedError;
  NotificationPriority get priority => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(
    NotificationSettings value,
    $Res Function(NotificationSettings) then,
  ) = _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call({
    bool enabled,
    bool prayerReminders,
    bool dailyDua,
    bool contextualSuggestions,
    bool habitReminders,
    List<String> quietHours,
    NotificationPriority priority,
  });
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<
  $Res,
  $Val extends NotificationSettings
>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? prayerReminders = null,
    Object? dailyDua = null,
    Object? contextualSuggestions = null,
    Object? habitReminders = null,
    Object? quietHours = null,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            enabled:
                null == enabled
                    ? _value.enabled
                    : enabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            prayerReminders:
                null == prayerReminders
                    ? _value.prayerReminders
                    : prayerReminders // ignore: cast_nullable_to_non_nullable
                        as bool,
            dailyDua:
                null == dailyDua
                    ? _value.dailyDua
                    : dailyDua // ignore: cast_nullable_to_non_nullable
                        as bool,
            contextualSuggestions:
                null == contextualSuggestions
                    ? _value.contextualSuggestions
                    : contextualSuggestions // ignore: cast_nullable_to_non_nullable
                        as bool,
            habitReminders:
                null == habitReminders
                    ? _value.habitReminders
                    : habitReminders // ignore: cast_nullable_to_non_nullable
                        as bool,
            quietHours:
                null == quietHours
                    ? _value.quietHours
                    : quietHours // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as NotificationPriority,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(
    _$NotificationSettingsImpl value,
    $Res Function(_$NotificationSettingsImpl) then,
  ) = __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool enabled,
    bool prayerReminders,
    bool dailyDua,
    bool contextualSuggestions,
    bool habitReminders,
    List<String> quietHours,
    NotificationPriority priority,
  });
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(
    _$NotificationSettingsImpl _value,
    $Res Function(_$NotificationSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? prayerReminders = null,
    Object? dailyDua = null,
    Object? contextualSuggestions = null,
    Object? habitReminders = null,
    Object? quietHours = null,
    Object? priority = null,
  }) {
    return _then(
      _$NotificationSettingsImpl(
        enabled:
            null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        prayerReminders:
            null == prayerReminders
                ? _value.prayerReminders
                : prayerReminders // ignore: cast_nullable_to_non_nullable
                    as bool,
        dailyDua:
            null == dailyDua
                ? _value.dailyDua
                : dailyDua // ignore: cast_nullable_to_non_nullable
                    as bool,
        contextualSuggestions:
            null == contextualSuggestions
                ? _value.contextualSuggestions
                : contextualSuggestions // ignore: cast_nullable_to_non_nullable
                    as bool,
        habitReminders:
            null == habitReminders
                ? _value.habitReminders
                : habitReminders // ignore: cast_nullable_to_non_nullable
                    as bool,
        quietHours:
            null == quietHours
                ? _value._quietHours
                : quietHours // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as NotificationPriority,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl({
    this.enabled = true,
    this.prayerReminders = true,
    this.dailyDua = true,
    this.contextualSuggestions = true,
    this.habitReminders = true,
    final List<String> quietHours = const [],
    this.priority = NotificationPriority.normal,
  }) : _quietHours = quietHours;

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool prayerReminders;
  @override
  @JsonKey()
  final bool dailyDua;
  @override
  @JsonKey()
  final bool contextualSuggestions;
  @override
  @JsonKey()
  final bool habitReminders;
  final List<String> _quietHours;
  @override
  @JsonKey()
  List<String> get quietHours {
    if (_quietHours is EqualUnmodifiableListView) return _quietHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quietHours);
  }

  @override
  @JsonKey()
  final NotificationPriority priority;

  @override
  String toString() {
    return 'NotificationSettings(enabled: $enabled, prayerReminders: $prayerReminders, dailyDua: $dailyDua, contextualSuggestions: $contextualSuggestions, habitReminders: $habitReminders, quietHours: $quietHours, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.prayerReminders, prayerReminders) ||
                other.prayerReminders == prayerReminders) &&
            (identical(other.dailyDua, dailyDua) ||
                other.dailyDua == dailyDua) &&
            (identical(other.contextualSuggestions, contextualSuggestions) ||
                other.contextualSuggestions == contextualSuggestions) &&
            (identical(other.habitReminders, habitReminders) ||
                other.habitReminders == habitReminders) &&
            const DeepCollectionEquality().equals(
              other._quietHours,
              _quietHours,
            ) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    enabled,
    prayerReminders,
    dailyDua,
    contextualSuggestions,
    habitReminders,
    const DeepCollectionEquality().hash(_quietHours),
    priority,
  );

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
  get copyWith =>
      __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(this);
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings({
    final bool enabled,
    final bool prayerReminders,
    final bool dailyDua,
    final bool contextualSuggestions,
    final bool habitReminders,
    final List<String> quietHours,
    final NotificationPriority priority,
  }) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

  @override
  bool get enabled;
  @override
  bool get prayerReminders;
  @override
  bool get dailyDua;
  @override
  bool get contextualSuggestions;
  @override
  bool get habitReminders;
  @override
  List<String> get quietHours;
  @override
  NotificationPriority get priority;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AudioSettings _$AudioSettingsFromJson(Map<String, dynamic> json) {
  return _AudioSettings.fromJson(json);
}

/// @nodoc
mixin _$AudioSettings {
  double get playbackSpeed => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;
  bool get autoPlay => throw _privateConstructorUsedError;
  AudioQuality get preferredQuality => throw _privateConstructorUsedError;
  bool get downloadOnWifi => throw _privateConstructorUsedError;

  /// Serializes this AudioSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioSettingsCopyWith<AudioSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioSettingsCopyWith<$Res> {
  factory $AudioSettingsCopyWith(
    AudioSettings value,
    $Res Function(AudioSettings) then,
  ) = _$AudioSettingsCopyWithImpl<$Res, AudioSettings>;
  @useResult
  $Res call({
    double playbackSpeed,
    double volume,
    bool autoPlay,
    AudioQuality preferredQuality,
    bool downloadOnWifi,
  });
}

/// @nodoc
class _$AudioSettingsCopyWithImpl<$Res, $Val extends AudioSettings>
    implements $AudioSettingsCopyWith<$Res> {
  _$AudioSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playbackSpeed = null,
    Object? volume = null,
    Object? autoPlay = null,
    Object? preferredQuality = null,
    Object? downloadOnWifi = null,
  }) {
    return _then(
      _value.copyWith(
            playbackSpeed:
                null == playbackSpeed
                    ? _value.playbackSpeed
                    : playbackSpeed // ignore: cast_nullable_to_non_nullable
                        as double,
            volume:
                null == volume
                    ? _value.volume
                    : volume // ignore: cast_nullable_to_non_nullable
                        as double,
            autoPlay:
                null == autoPlay
                    ? _value.autoPlay
                    : autoPlay // ignore: cast_nullable_to_non_nullable
                        as bool,
            preferredQuality:
                null == preferredQuality
                    ? _value.preferredQuality
                    : preferredQuality // ignore: cast_nullable_to_non_nullable
                        as AudioQuality,
            downloadOnWifi:
                null == downloadOnWifi
                    ? _value.downloadOnWifi
                    : downloadOnWifi // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioSettingsImplCopyWith<$Res>
    implements $AudioSettingsCopyWith<$Res> {
  factory _$$AudioSettingsImplCopyWith(
    _$AudioSettingsImpl value,
    $Res Function(_$AudioSettingsImpl) then,
  ) = __$$AudioSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double playbackSpeed,
    double volume,
    bool autoPlay,
    AudioQuality preferredQuality,
    bool downloadOnWifi,
  });
}

/// @nodoc
class __$$AudioSettingsImplCopyWithImpl<$Res>
    extends _$AudioSettingsCopyWithImpl<$Res, _$AudioSettingsImpl>
    implements _$$AudioSettingsImplCopyWith<$Res> {
  __$$AudioSettingsImplCopyWithImpl(
    _$AudioSettingsImpl _value,
    $Res Function(_$AudioSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playbackSpeed = null,
    Object? volume = null,
    Object? autoPlay = null,
    Object? preferredQuality = null,
    Object? downloadOnWifi = null,
  }) {
    return _then(
      _$AudioSettingsImpl(
        playbackSpeed:
            null == playbackSpeed
                ? _value.playbackSpeed
                : playbackSpeed // ignore: cast_nullable_to_non_nullable
                    as double,
        volume:
            null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                    as double,
        autoPlay:
            null == autoPlay
                ? _value.autoPlay
                : autoPlay // ignore: cast_nullable_to_non_nullable
                    as bool,
        preferredQuality:
            null == preferredQuality
                ? _value.preferredQuality
                : preferredQuality // ignore: cast_nullable_to_non_nullable
                    as AudioQuality,
        downloadOnWifi:
            null == downloadOnWifi
                ? _value.downloadOnWifi
                : downloadOnWifi // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioSettingsImpl implements _AudioSettings {
  const _$AudioSettingsImpl({
    this.playbackSpeed = 1.0,
    this.volume = 0.8,
    this.autoPlay = true,
    this.preferredQuality = AudioQuality.high,
    this.downloadOnWifi = true,
  });

  factory _$AudioSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioSettingsImplFromJson(json);

  @override
  @JsonKey()
  final double playbackSpeed;
  @override
  @JsonKey()
  final double volume;
  @override
  @JsonKey()
  final bool autoPlay;
  @override
  @JsonKey()
  final AudioQuality preferredQuality;
  @override
  @JsonKey()
  final bool downloadOnWifi;

  @override
  String toString() {
    return 'AudioSettings(playbackSpeed: $playbackSpeed, volume: $volume, autoPlay: $autoPlay, preferredQuality: $preferredQuality, downloadOnWifi: $downloadOnWifi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioSettingsImpl &&
            (identical(other.playbackSpeed, playbackSpeed) ||
                other.playbackSpeed == playbackSpeed) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.autoPlay, autoPlay) ||
                other.autoPlay == autoPlay) &&
            (identical(other.preferredQuality, preferredQuality) ||
                other.preferredQuality == preferredQuality) &&
            (identical(other.downloadOnWifi, downloadOnWifi) ||
                other.downloadOnWifi == downloadOnWifi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playbackSpeed,
    volume,
    autoPlay,
    preferredQuality,
    downloadOnWifi,
  );

  /// Create a copy of AudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioSettingsImplCopyWith<_$AudioSettingsImpl> get copyWith =>
      __$$AudioSettingsImplCopyWithImpl<_$AudioSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioSettingsImplToJson(this);
  }
}

abstract class _AudioSettings implements AudioSettings {
  const factory _AudioSettings({
    final double playbackSpeed,
    final double volume,
    final bool autoPlay,
    final AudioQuality preferredQuality,
    final bool downloadOnWifi,
  }) = _$AudioSettingsImpl;

  factory _AudioSettings.fromJson(Map<String, dynamic> json) =
      _$AudioSettingsImpl.fromJson;

  @override
  double get playbackSpeed;
  @override
  double get volume;
  @override
  bool get autoPlay;
  @override
  AudioQuality get preferredQuality;
  @override
  bool get downloadOnWifi;

  /// Create a copy of AudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioSettingsImplCopyWith<_$AudioSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HabitStats _$HabitStatsFromJson(Map<String, dynamic> json) {
  return _HabitStats.fromJson(json);
}

/// @nodoc
mixin _$HabitStats {
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  int get totalDuas => throw _privateConstructorUsedError;
  DateTime get lastActivity => throw _privateConstructorUsedError;
  Map<String, int> get categoryStats => throw _privateConstructorUsedError;
  List<DailyActivity> get recentActivity => throw _privateConstructorUsedError;
  int get weeklyGoal => throw _privateConstructorUsedError;
  int get monthlyGoal => throw _privateConstructorUsedError;

  /// Serializes this HabitStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitStatsCopyWith<HabitStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitStatsCopyWith<$Res> {
  factory $HabitStatsCopyWith(
    HabitStats value,
    $Res Function(HabitStats) then,
  ) = _$HabitStatsCopyWithImpl<$Res, HabitStats>;
  @useResult
  $Res call({
    int currentStreak,
    int longestStreak,
    int totalDuas,
    DateTime lastActivity,
    Map<String, int> categoryStats,
    List<DailyActivity> recentActivity,
    int weeklyGoal,
    int monthlyGoal,
  });
}

/// @nodoc
class _$HabitStatsCopyWithImpl<$Res, $Val extends HabitStats>
    implements $HabitStatsCopyWith<$Res> {
  _$HabitStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalDuas = null,
    Object? lastActivity = null,
    Object? categoryStats = null,
    Object? recentActivity = null,
    Object? weeklyGoal = null,
    Object? monthlyGoal = null,
  }) {
    return _then(
      _value.copyWith(
            currentStreak:
                null == currentStreak
                    ? _value.currentStreak
                    : currentStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            longestStreak:
                null == longestStreak
                    ? _value.longestStreak
                    : longestStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            totalDuas:
                null == totalDuas
                    ? _value.totalDuas
                    : totalDuas // ignore: cast_nullable_to_non_nullable
                        as int,
            lastActivity:
                null == lastActivity
                    ? _value.lastActivity
                    : lastActivity // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            categoryStats:
                null == categoryStats
                    ? _value.categoryStats
                    : categoryStats // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            recentActivity:
                null == recentActivity
                    ? _value.recentActivity
                    : recentActivity // ignore: cast_nullable_to_non_nullable
                        as List<DailyActivity>,
            weeklyGoal:
                null == weeklyGoal
                    ? _value.weeklyGoal
                    : weeklyGoal // ignore: cast_nullable_to_non_nullable
                        as int,
            monthlyGoal:
                null == monthlyGoal
                    ? _value.monthlyGoal
                    : monthlyGoal // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitStatsImplCopyWith<$Res>
    implements $HabitStatsCopyWith<$Res> {
  factory _$$HabitStatsImplCopyWith(
    _$HabitStatsImpl value,
    $Res Function(_$HabitStatsImpl) then,
  ) = __$$HabitStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStreak,
    int longestStreak,
    int totalDuas,
    DateTime lastActivity,
    Map<String, int> categoryStats,
    List<DailyActivity> recentActivity,
    int weeklyGoal,
    int monthlyGoal,
  });
}

/// @nodoc
class __$$HabitStatsImplCopyWithImpl<$Res>
    extends _$HabitStatsCopyWithImpl<$Res, _$HabitStatsImpl>
    implements _$$HabitStatsImplCopyWith<$Res> {
  __$$HabitStatsImplCopyWithImpl(
    _$HabitStatsImpl _value,
    $Res Function(_$HabitStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalDuas = null,
    Object? lastActivity = null,
    Object? categoryStats = null,
    Object? recentActivity = null,
    Object? weeklyGoal = null,
    Object? monthlyGoal = null,
  }) {
    return _then(
      _$HabitStatsImpl(
        currentStreak:
            null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        longestStreak:
            null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        totalDuas:
            null == totalDuas
                ? _value.totalDuas
                : totalDuas // ignore: cast_nullable_to_non_nullable
                    as int,
        lastActivity:
            null == lastActivity
                ? _value.lastActivity
                : lastActivity // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        categoryStats:
            null == categoryStats
                ? _value._categoryStats
                : categoryStats // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        recentActivity:
            null == recentActivity
                ? _value._recentActivity
                : recentActivity // ignore: cast_nullable_to_non_nullable
                    as List<DailyActivity>,
        weeklyGoal:
            null == weeklyGoal
                ? _value.weeklyGoal
                : weeklyGoal // ignore: cast_nullable_to_non_nullable
                    as int,
        monthlyGoal:
            null == monthlyGoal
                ? _value.monthlyGoal
                : monthlyGoal // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitStatsImpl implements _HabitStats {
  const _$HabitStatsImpl({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDuas,
    required this.lastActivity,
    required final Map<String, int> categoryStats,
    required final List<DailyActivity> recentActivity,
    this.weeklyGoal = 0,
    this.monthlyGoal = 0,
  }) : _categoryStats = categoryStats,
       _recentActivity = recentActivity;

  factory _$HabitStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitStatsImplFromJson(json);

  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final int totalDuas;
  @override
  final DateTime lastActivity;
  final Map<String, int> _categoryStats;
  @override
  Map<String, int> get categoryStats {
    if (_categoryStats is EqualUnmodifiableMapView) return _categoryStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStats);
  }

  final List<DailyActivity> _recentActivity;
  @override
  List<DailyActivity> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  @override
  @JsonKey()
  final int weeklyGoal;
  @override
  @JsonKey()
  final int monthlyGoal;

  @override
  String toString() {
    return 'HabitStats(currentStreak: $currentStreak, longestStreak: $longestStreak, totalDuas: $totalDuas, lastActivity: $lastActivity, categoryStats: $categoryStats, recentActivity: $recentActivity, weeklyGoal: $weeklyGoal, monthlyGoal: $monthlyGoal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitStatsImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.totalDuas, totalDuas) ||
                other.totalDuas == totalDuas) &&
            (identical(other.lastActivity, lastActivity) ||
                other.lastActivity == lastActivity) &&
            const DeepCollectionEquality().equals(
              other._categoryStats,
              _categoryStats,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentActivity,
              _recentActivity,
            ) &&
            (identical(other.weeklyGoal, weeklyGoal) ||
                other.weeklyGoal == weeklyGoal) &&
            (identical(other.monthlyGoal, monthlyGoal) ||
                other.monthlyGoal == monthlyGoal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStreak,
    longestStreak,
    totalDuas,
    lastActivity,
    const DeepCollectionEquality().hash(_categoryStats),
    const DeepCollectionEquality().hash(_recentActivity),
    weeklyGoal,
    monthlyGoal,
  );

  /// Create a copy of HabitStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitStatsImplCopyWith<_$HabitStatsImpl> get copyWith =>
      __$$HabitStatsImplCopyWithImpl<_$HabitStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitStatsImplToJson(this);
  }
}

abstract class _HabitStats implements HabitStats {
  const factory _HabitStats({
    required final int currentStreak,
    required final int longestStreak,
    required final int totalDuas,
    required final DateTime lastActivity,
    required final Map<String, int> categoryStats,
    required final List<DailyActivity> recentActivity,
    final int weeklyGoal,
    final int monthlyGoal,
  }) = _$HabitStatsImpl;

  factory _HabitStats.fromJson(Map<String, dynamic> json) =
      _$HabitStatsImpl.fromJson;

  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  int get totalDuas;
  @override
  DateTime get lastActivity;
  @override
  Map<String, int> get categoryStats;
  @override
  List<DailyActivity> get recentActivity;
  @override
  int get weeklyGoal;
  @override
  int get monthlyGoal;

  /// Create a copy of HabitStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitStatsImplCopyWith<_$HabitStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyActivity _$DailyActivityFromJson(Map<String, dynamic> json) {
  return _DailyActivity.fromJson(json);
}

/// @nodoc
mixin _$DailyActivity {
  DateTime get date => throw _privateConstructorUsedError;
  int get duaCount => throw _privateConstructorUsedError;
  Duration get totalTime => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  bool get goalMet => throw _privateConstructorUsedError;

  /// Serializes this DailyActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyActivityCopyWith<DailyActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyActivityCopyWith<$Res> {
  factory $DailyActivityCopyWith(
    DailyActivity value,
    $Res Function(DailyActivity) then,
  ) = _$DailyActivityCopyWithImpl<$Res, DailyActivity>;
  @useResult
  $Res call({
    DateTime date,
    int duaCount,
    Duration totalTime,
    List<String> categories,
    bool goalMet,
  });
}

/// @nodoc
class _$DailyActivityCopyWithImpl<$Res, $Val extends DailyActivity>
    implements $DailyActivityCopyWith<$Res> {
  _$DailyActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? duaCount = null,
    Object? totalTime = null,
    Object? categories = null,
    Object? goalMet = null,
  }) {
    return _then(
      _value.copyWith(
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            duaCount:
                null == duaCount
                    ? _value.duaCount
                    : duaCount // ignore: cast_nullable_to_non_nullable
                        as int,
            totalTime:
                null == totalTime
                    ? _value.totalTime
                    : totalTime // ignore: cast_nullable_to_non_nullable
                        as Duration,
            categories:
                null == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            goalMet:
                null == goalMet
                    ? _value.goalMet
                    : goalMet // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyActivityImplCopyWith<$Res>
    implements $DailyActivityCopyWith<$Res> {
  factory _$$DailyActivityImplCopyWith(
    _$DailyActivityImpl value,
    $Res Function(_$DailyActivityImpl) then,
  ) = __$$DailyActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    int duaCount,
    Duration totalTime,
    List<String> categories,
    bool goalMet,
  });
}

/// @nodoc
class __$$DailyActivityImplCopyWithImpl<$Res>
    extends _$DailyActivityCopyWithImpl<$Res, _$DailyActivityImpl>
    implements _$$DailyActivityImplCopyWith<$Res> {
  __$$DailyActivityImplCopyWithImpl(
    _$DailyActivityImpl _value,
    $Res Function(_$DailyActivityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? duaCount = null,
    Object? totalTime = null,
    Object? categories = null,
    Object? goalMet = null,
  }) {
    return _then(
      _$DailyActivityImpl(
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        duaCount:
            null == duaCount
                ? _value.duaCount
                : duaCount // ignore: cast_nullable_to_non_nullable
                    as int,
        totalTime:
            null == totalTime
                ? _value.totalTime
                : totalTime // ignore: cast_nullable_to_non_nullable
                    as Duration,
        categories:
            null == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        goalMet:
            null == goalMet
                ? _value.goalMet
                : goalMet // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyActivityImpl implements _DailyActivity {
  const _$DailyActivityImpl({
    required this.date,
    required this.duaCount,
    required this.totalTime,
    required final List<String> categories,
    this.goalMet = false,
  }) : _categories = categories;

  factory _$DailyActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyActivityImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int duaCount;
  @override
  final Duration totalTime;
  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final bool goalMet;

  @override
  String toString() {
    return 'DailyActivity(date: $date, duaCount: $duaCount, totalTime: $totalTime, categories: $categories, goalMet: $goalMet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyActivityImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.duaCount, duaCount) ||
                other.duaCount == duaCount) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.goalMet, goalMet) || other.goalMet == goalMet));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    duaCount,
    totalTime,
    const DeepCollectionEquality().hash(_categories),
    goalMet,
  );

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyActivityImplCopyWith<_$DailyActivityImpl> get copyWith =>
      __$$DailyActivityImplCopyWithImpl<_$DailyActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyActivityImplToJson(this);
  }
}

abstract class _DailyActivity implements DailyActivity {
  const factory _DailyActivity({
    required final DateTime date,
    required final int duaCount,
    required final Duration totalTime,
    required final List<String> categories,
    final bool goalMet,
  }) = _$DailyActivityImpl;

  factory _DailyActivity.fromJson(Map<String, dynamic> json) =
      _$DailyActivityImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get duaCount;
  @override
  Duration get totalTime;
  @override
  List<String> get categories;
  @override
  bool get goalMet;

  /// Create a copy of DailyActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyActivityImplCopyWith<_$DailyActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmartSuggestion _$SmartSuggestionFromJson(Map<String, dynamic> json) {
  return _SmartSuggestion.fromJson(json);
}

/// @nodoc
mixin _$SmartSuggestion {
  String get duaId => throw _privateConstructorUsedError;
  SuggestionType get type => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  SuggestionTrigger get trigger => throw _privateConstructorUsedError;
  Map<String, dynamic>? get context => throw _privateConstructorUsedError;

  /// Serializes this SmartSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartSuggestionCopyWith<SmartSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartSuggestionCopyWith<$Res> {
  factory $SmartSuggestionCopyWith(
    SmartSuggestion value,
    $Res Function(SmartSuggestion) then,
  ) = _$SmartSuggestionCopyWithImpl<$Res, SmartSuggestion>;
  @useResult
  $Res call({
    String duaId,
    SuggestionType type,
    double confidence,
    String reason,
    DateTime timestamp,
    SuggestionTrigger trigger,
    Map<String, dynamic>? context,
  });
}

/// @nodoc
class _$SmartSuggestionCopyWithImpl<$Res, $Val extends SmartSuggestion>
    implements $SmartSuggestionCopyWith<$Res> {
  _$SmartSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? type = null,
    Object? confidence = null,
    Object? reason = null,
    Object? timestamp = null,
    Object? trigger = null,
    Object? context = freezed,
  }) {
    return _then(
      _value.copyWith(
            duaId:
                null == duaId
                    ? _value.duaId
                    : duaId // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as SuggestionType,
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as double,
            reason:
                null == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            trigger:
                null == trigger
                    ? _value.trigger
                    : trigger // ignore: cast_nullable_to_non_nullable
                        as SuggestionTrigger,
            context:
                freezed == context
                    ? _value.context
                    : context // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SmartSuggestionImplCopyWith<$Res>
    implements $SmartSuggestionCopyWith<$Res> {
  factory _$$SmartSuggestionImplCopyWith(
    _$SmartSuggestionImpl value,
    $Res Function(_$SmartSuggestionImpl) then,
  ) = __$$SmartSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String duaId,
    SuggestionType type,
    double confidence,
    String reason,
    DateTime timestamp,
    SuggestionTrigger trigger,
    Map<String, dynamic>? context,
  });
}

/// @nodoc
class __$$SmartSuggestionImplCopyWithImpl<$Res>
    extends _$SmartSuggestionCopyWithImpl<$Res, _$SmartSuggestionImpl>
    implements _$$SmartSuggestionImplCopyWith<$Res> {
  __$$SmartSuggestionImplCopyWithImpl(
    _$SmartSuggestionImpl _value,
    $Res Function(_$SmartSuggestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmartSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? type = null,
    Object? confidence = null,
    Object? reason = null,
    Object? timestamp = null,
    Object? trigger = null,
    Object? context = freezed,
  }) {
    return _then(
      _$SmartSuggestionImpl(
        duaId:
            null == duaId
                ? _value.duaId
                : duaId // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as SuggestionType,
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as double,
        reason:
            null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        trigger:
            null == trigger
                ? _value.trigger
                : trigger // ignore: cast_nullable_to_non_nullable
                    as SuggestionTrigger,
        context:
            freezed == context
                ? _value._context
                : context // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartSuggestionImpl implements _SmartSuggestion {
  const _$SmartSuggestionImpl({
    required this.duaId,
    required this.type,
    required this.confidence,
    required this.reason,
    required this.timestamp,
    required this.trigger,
    final Map<String, dynamic>? context,
  }) : _context = context;

  factory _$SmartSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartSuggestionImplFromJson(json);

  @override
  final String duaId;
  @override
  final SuggestionType type;
  @override
  final double confidence;
  @override
  final String reason;
  @override
  final DateTime timestamp;
  @override
  final SuggestionTrigger trigger;
  final Map<String, dynamic>? _context;
  @override
  Map<String, dynamic>? get context {
    final value = _context;
    if (value == null) return null;
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SmartSuggestion(duaId: $duaId, type: $type, confidence: $confidence, reason: $reason, timestamp: $timestamp, trigger: $trigger, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartSuggestionImpl &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            const DeepCollectionEquality().equals(other._context, _context));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    duaId,
    type,
    confidence,
    reason,
    timestamp,
    trigger,
    const DeepCollectionEquality().hash(_context),
  );

  /// Create a copy of SmartSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartSuggestionImplCopyWith<_$SmartSuggestionImpl> get copyWith =>
      __$$SmartSuggestionImplCopyWithImpl<_$SmartSuggestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartSuggestionImplToJson(this);
  }
}

abstract class _SmartSuggestion implements SmartSuggestion {
  const factory _SmartSuggestion({
    required final String duaId,
    required final SuggestionType type,
    required final double confidence,
    required final String reason,
    required final DateTime timestamp,
    required final SuggestionTrigger trigger,
    final Map<String, dynamic>? context,
  }) = _$SmartSuggestionImpl;

  factory _SmartSuggestion.fromJson(Map<String, dynamic> json) =
      _$SmartSuggestionImpl.fromJson;

  @override
  String get duaId;
  @override
  SuggestionType get type;
  @override
  double get confidence;
  @override
  String get reason;
  @override
  DateTime get timestamp;
  @override
  SuggestionTrigger get trigger;
  @override
  Map<String, dynamic>? get context;

  /// Create a copy of SmartSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartSuggestionImplCopyWith<_$SmartSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationSchedule _$NotificationScheduleFromJson(Map<String, dynamic> json) {
  return _NotificationSchedule.fromJson(json);
}

/// @nodoc
mixin _$NotificationSchedule {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String? get duaId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get payload => throw _privateConstructorUsedError;
  bool get isRepeating => throw _privateConstructorUsedError;
  RepeatInterval? get repeatInterval => throw _privateConstructorUsedError;

  /// Serializes this NotificationSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationScheduleCopyWith<NotificationSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationScheduleCopyWith<$Res> {
  factory $NotificationScheduleCopyWith(
    NotificationSchedule value,
    $Res Function(NotificationSchedule) then,
  ) = _$NotificationScheduleCopyWithImpl<$Res, NotificationSchedule>;
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    DateTime scheduledTime,
    NotificationType type,
    String? duaId,
    Map<String, dynamic>? payload,
    bool isRepeating,
    RepeatInterval? repeatInterval,
  });
}

/// @nodoc
class _$NotificationScheduleCopyWithImpl<
  $Res,
  $Val extends NotificationSchedule
>
    implements $NotificationScheduleCopyWith<$Res> {
  _$NotificationScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduledTime = null,
    Object? type = null,
    Object? duaId = freezed,
    Object? payload = freezed,
    Object? isRepeating = null,
    Object? repeatInterval = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            body:
                null == body
                    ? _value.body
                    : body // ignore: cast_nullable_to_non_nullable
                        as String,
            scheduledTime:
                null == scheduledTime
                    ? _value.scheduledTime
                    : scheduledTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as NotificationType,
            duaId:
                freezed == duaId
                    ? _value.duaId
                    : duaId // ignore: cast_nullable_to_non_nullable
                        as String?,
            payload:
                freezed == payload
                    ? _value.payload
                    : payload // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            isRepeating:
                null == isRepeating
                    ? _value.isRepeating
                    : isRepeating // ignore: cast_nullable_to_non_nullable
                        as bool,
            repeatInterval:
                freezed == repeatInterval
                    ? _value.repeatInterval
                    : repeatInterval // ignore: cast_nullable_to_non_nullable
                        as RepeatInterval?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationScheduleImplCopyWith<$Res>
    implements $NotificationScheduleCopyWith<$Res> {
  factory _$$NotificationScheduleImplCopyWith(
    _$NotificationScheduleImpl value,
    $Res Function(_$NotificationScheduleImpl) then,
  ) = __$$NotificationScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    DateTime scheduledTime,
    NotificationType type,
    String? duaId,
    Map<String, dynamic>? payload,
    bool isRepeating,
    RepeatInterval? repeatInterval,
  });
}

/// @nodoc
class __$$NotificationScheduleImplCopyWithImpl<$Res>
    extends _$NotificationScheduleCopyWithImpl<$Res, _$NotificationScheduleImpl>
    implements _$$NotificationScheduleImplCopyWith<$Res> {
  __$$NotificationScheduleImplCopyWithImpl(
    _$NotificationScheduleImpl _value,
    $Res Function(_$NotificationScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? scheduledTime = null,
    Object? type = null,
    Object? duaId = freezed,
    Object? payload = freezed,
    Object? isRepeating = null,
    Object? repeatInterval = freezed,
  }) {
    return _then(
      _$NotificationScheduleImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        body:
            null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                    as String,
        scheduledTime:
            null == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as NotificationType,
        duaId:
            freezed == duaId
                ? _value.duaId
                : duaId // ignore: cast_nullable_to_non_nullable
                    as String?,
        payload:
            freezed == payload
                ? _value._payload
                : payload // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        isRepeating:
            null == isRepeating
                ? _value.isRepeating
                : isRepeating // ignore: cast_nullable_to_non_nullable
                    as bool,
        repeatInterval:
            freezed == repeatInterval
                ? _value.repeatInterval
                : repeatInterval // ignore: cast_nullable_to_non_nullable
                    as RepeatInterval?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationScheduleImpl implements _NotificationSchedule {
  const _$NotificationScheduleImpl({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.type,
    this.duaId,
    final Map<String, dynamic>? payload,
    this.isRepeating = false,
    this.repeatInterval,
  }) : _payload = payload;

  factory _$NotificationScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime scheduledTime;
  @override
  final NotificationType type;
  @override
  final String? duaId;
  final Map<String, dynamic>? _payload;
  @override
  Map<String, dynamic>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isRepeating;
  @override
  final RepeatInterval? repeatInterval;

  @override
  String toString() {
    return 'NotificationSchedule(id: $id, title: $title, body: $body, scheduledTime: $scheduledTime, type: $type, duaId: $duaId, payload: $payload, isRepeating: $isRepeating, repeatInterval: $repeatInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.isRepeating, isRepeating) ||
                other.isRepeating == isRepeating) &&
            (identical(other.repeatInterval, repeatInterval) ||
                other.repeatInterval == repeatInterval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    body,
    scheduledTime,
    type,
    duaId,
    const DeepCollectionEquality().hash(_payload),
    isRepeating,
    repeatInterval,
  );

  /// Create a copy of NotificationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationScheduleImplCopyWith<_$NotificationScheduleImpl>
  get copyWith =>
      __$$NotificationScheduleImplCopyWithImpl<_$NotificationScheduleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationScheduleImplToJson(this);
  }
}

abstract class _NotificationSchedule implements NotificationSchedule {
  const factory _NotificationSchedule({
    required final String id,
    required final String title,
    required final String body,
    required final DateTime scheduledTime,
    required final NotificationType type,
    final String? duaId,
    final Map<String, dynamic>? payload,
    final bool isRepeating,
    final RepeatInterval? repeatInterval,
  }) = _$NotificationScheduleImpl;

  factory _NotificationSchedule.fromJson(Map<String, dynamic> json) =
      _$NotificationScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  DateTime get scheduledTime;
  @override
  NotificationType get type;
  @override
  String? get duaId;
  @override
  Map<String, dynamic>? get payload;
  @override
  bool get isRepeating;
  @override
  RepeatInterval? get repeatInterval;

  /// Create a copy of NotificationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationScheduleImplCopyWith<_$NotificationScheduleImpl>
  get copyWith => throw _privateConstructorUsedError;
}
