// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qibla_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QiblaCompass _$QiblaCompassFromJson(Map<String, dynamic> json) {
  return _QiblaCompass.fromJson(json);
}

/// @nodoc
mixin _$QiblaCompass {
  double get qiblaDirection => throw _privateConstructorUsedError;
  double get currentDirection => throw _privateConstructorUsedError;
  double get deviceHeading => throw _privateConstructorUsedError;
  LocationAccuracy get accuracy => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  bool get isCalibrationNeeded => throw _privateConstructorUsedError;
  String? get nearestMosque => throw _privateConstructorUsedError;
  double? get distanceToKaaba => throw _privateConstructorUsedError;
  QiblaCalibrationData? get calibrationData =>
      throw _privateConstructorUsedError;

  /// Serializes this QiblaCompass to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QiblaCompass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QiblaCompassCopyWith<QiblaCompass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QiblaCompassCopyWith<$Res> {
  factory $QiblaCompassCopyWith(
          QiblaCompass value, $Res Function(QiblaCompass) then) =
      _$QiblaCompassCopyWithImpl<$Res, QiblaCompass>;
  @useResult
  $Res call(
      {double qiblaDirection,
      double currentDirection,
      double deviceHeading,
      LocationAccuracy accuracy,
      DateTime lastUpdated,
      bool isCalibrationNeeded,
      String? nearestMosque,
      double? distanceToKaaba,
      QiblaCalibrationData? calibrationData});

  $QiblaCalibrationDataCopyWith<$Res>? get calibrationData;
}

/// @nodoc
class _$QiblaCompassCopyWithImpl<$Res, $Val extends QiblaCompass>
    implements $QiblaCompassCopyWith<$Res> {
  _$QiblaCompassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QiblaCompass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qiblaDirection = null,
    Object? currentDirection = null,
    Object? deviceHeading = null,
    Object? accuracy = null,
    Object? lastUpdated = null,
    Object? isCalibrationNeeded = null,
    Object? nearestMosque = freezed,
    Object? distanceToKaaba = freezed,
    Object? calibrationData = freezed,
  }) {
    return _then(_value.copyWith(
      qiblaDirection: null == qiblaDirection
          ? _value.qiblaDirection
          : qiblaDirection // ignore: cast_nullable_to_non_nullable
              as double,
      currentDirection: null == currentDirection
          ? _value.currentDirection
          : currentDirection // ignore: cast_nullable_to_non_nullable
              as double,
      deviceHeading: null == deviceHeading
          ? _value.deviceHeading
          : deviceHeading // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as LocationAccuracy,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCalibrationNeeded: null == isCalibrationNeeded
          ? _value.isCalibrationNeeded
          : isCalibrationNeeded // ignore: cast_nullable_to_non_nullable
              as bool,
      nearestMosque: freezed == nearestMosque
          ? _value.nearestMosque
          : nearestMosque // ignore: cast_nullable_to_non_nullable
              as String?,
      distanceToKaaba: freezed == distanceToKaaba
          ? _value.distanceToKaaba
          : distanceToKaaba // ignore: cast_nullable_to_non_nullable
              as double?,
      calibrationData: freezed == calibrationData
          ? _value.calibrationData
          : calibrationData // ignore: cast_nullable_to_non_nullable
              as QiblaCalibrationData?,
    ) as $Val);
  }

  /// Create a copy of QiblaCompass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QiblaCalibrationDataCopyWith<$Res>? get calibrationData {
    if (_value.calibrationData == null) {
      return null;
    }

    return $QiblaCalibrationDataCopyWith<$Res>(_value.calibrationData!,
        (value) {
      return _then(_value.copyWith(calibrationData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QiblaCompassImplCopyWith<$Res>
    implements $QiblaCompassCopyWith<$Res> {
  factory _$$QiblaCompassImplCopyWith(
          _$QiblaCompassImpl value, $Res Function(_$QiblaCompassImpl) then) =
      __$$QiblaCompassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double qiblaDirection,
      double currentDirection,
      double deviceHeading,
      LocationAccuracy accuracy,
      DateTime lastUpdated,
      bool isCalibrationNeeded,
      String? nearestMosque,
      double? distanceToKaaba,
      QiblaCalibrationData? calibrationData});

  @override
  $QiblaCalibrationDataCopyWith<$Res>? get calibrationData;
}

/// @nodoc
class __$$QiblaCompassImplCopyWithImpl<$Res>
    extends _$QiblaCompassCopyWithImpl<$Res, _$QiblaCompassImpl>
    implements _$$QiblaCompassImplCopyWith<$Res> {
  __$$QiblaCompassImplCopyWithImpl(
      _$QiblaCompassImpl _value, $Res Function(_$QiblaCompassImpl) _then)
      : super(_value, _then);

  /// Create a copy of QiblaCompass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qiblaDirection = null,
    Object? currentDirection = null,
    Object? deviceHeading = null,
    Object? accuracy = null,
    Object? lastUpdated = null,
    Object? isCalibrationNeeded = null,
    Object? nearestMosque = freezed,
    Object? distanceToKaaba = freezed,
    Object? calibrationData = freezed,
  }) {
    return _then(_$QiblaCompassImpl(
      qiblaDirection: null == qiblaDirection
          ? _value.qiblaDirection
          : qiblaDirection // ignore: cast_nullable_to_non_nullable
              as double,
      currentDirection: null == currentDirection
          ? _value.currentDirection
          : currentDirection // ignore: cast_nullable_to_non_nullable
              as double,
      deviceHeading: null == deviceHeading
          ? _value.deviceHeading
          : deviceHeading // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as LocationAccuracy,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCalibrationNeeded: null == isCalibrationNeeded
          ? _value.isCalibrationNeeded
          : isCalibrationNeeded // ignore: cast_nullable_to_non_nullable
              as bool,
      nearestMosque: freezed == nearestMosque
          ? _value.nearestMosque
          : nearestMosque // ignore: cast_nullable_to_non_nullable
              as String?,
      distanceToKaaba: freezed == distanceToKaaba
          ? _value.distanceToKaaba
          : distanceToKaaba // ignore: cast_nullable_to_non_nullable
              as double?,
      calibrationData: freezed == calibrationData
          ? _value.calibrationData
          : calibrationData // ignore: cast_nullable_to_non_nullable
              as QiblaCalibrationData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QiblaCompassImpl implements _QiblaCompass {
  const _$QiblaCompassImpl(
      {required this.qiblaDirection,
      required this.currentDirection,
      required this.deviceHeading,
      required this.accuracy,
      required this.lastUpdated,
      required this.isCalibrationNeeded,
      this.nearestMosque,
      this.distanceToKaaba,
      this.calibrationData});

  factory _$QiblaCompassImpl.fromJson(Map<String, dynamic> json) =>
      _$$QiblaCompassImplFromJson(json);

  @override
  final double qiblaDirection;
  @override
  final double currentDirection;
  @override
  final double deviceHeading;
  @override
  final LocationAccuracy accuracy;
  @override
  final DateTime lastUpdated;
  @override
  final bool isCalibrationNeeded;
  @override
  final String? nearestMosque;
  @override
  final double? distanceToKaaba;
  @override
  final QiblaCalibrationData? calibrationData;

  @override
  String toString() {
    return 'QiblaCompass(qiblaDirection: $qiblaDirection, currentDirection: $currentDirection, deviceHeading: $deviceHeading, accuracy: $accuracy, lastUpdated: $lastUpdated, isCalibrationNeeded: $isCalibrationNeeded, nearestMosque: $nearestMosque, distanceToKaaba: $distanceToKaaba, calibrationData: $calibrationData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QiblaCompassImpl &&
            (identical(other.qiblaDirection, qiblaDirection) ||
                other.qiblaDirection == qiblaDirection) &&
            (identical(other.currentDirection, currentDirection) ||
                other.currentDirection == currentDirection) &&
            (identical(other.deviceHeading, deviceHeading) ||
                other.deviceHeading == deviceHeading) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isCalibrationNeeded, isCalibrationNeeded) ||
                other.isCalibrationNeeded == isCalibrationNeeded) &&
            (identical(other.nearestMosque, nearestMosque) ||
                other.nearestMosque == nearestMosque) &&
            (identical(other.distanceToKaaba, distanceToKaaba) ||
                other.distanceToKaaba == distanceToKaaba) &&
            (identical(other.calibrationData, calibrationData) ||
                other.calibrationData == calibrationData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      qiblaDirection,
      currentDirection,
      deviceHeading,
      accuracy,
      lastUpdated,
      isCalibrationNeeded,
      nearestMosque,
      distanceToKaaba,
      calibrationData);

  /// Create a copy of QiblaCompass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QiblaCompassImplCopyWith<_$QiblaCompassImpl> get copyWith =>
      __$$QiblaCompassImplCopyWithImpl<_$QiblaCompassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QiblaCompassImplToJson(
      this,
    );
  }
}

abstract class _QiblaCompass implements QiblaCompass {
  const factory _QiblaCompass(
      {required final double qiblaDirection,
      required final double currentDirection,
      required final double deviceHeading,
      required final LocationAccuracy accuracy,
      required final DateTime lastUpdated,
      required final bool isCalibrationNeeded,
      final String? nearestMosque,
      final double? distanceToKaaba,
      final QiblaCalibrationData? calibrationData}) = _$QiblaCompassImpl;

  factory _QiblaCompass.fromJson(Map<String, dynamic> json) =
      _$QiblaCompassImpl.fromJson;

  @override
  double get qiblaDirection;
  @override
  double get currentDirection;
  @override
  double get deviceHeading;
  @override
  LocationAccuracy get accuracy;
  @override
  DateTime get lastUpdated;
  @override
  bool get isCalibrationNeeded;
  @override
  String? get nearestMosque;
  @override
  double? get distanceToKaaba;
  @override
  QiblaCalibrationData? get calibrationData;

  /// Create a copy of QiblaCompass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QiblaCompassImplCopyWith<_$QiblaCompassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QiblaCalibrationData _$QiblaCalibrationDataFromJson(Map<String, dynamic> json) {
  return _QiblaCalibrationData.fromJson(json);
}

/// @nodoc
mixin _$QiblaCalibrationData {
  double get magneticDeclination => throw _privateConstructorUsedError;
  DateTime get lastCalibration => throw _privateConstructorUsedError;
  CalibrationQuality get quality => throw _privateConstructorUsedError;
  List<double> get calibrationReadings => throw _privateConstructorUsedError;
  String? get deviceModel => throw _privateConstructorUsedError;
  Map<String, dynamic>? get sensorInfo => throw _privateConstructorUsedError;

  /// Serializes this QiblaCalibrationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QiblaCalibrationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QiblaCalibrationDataCopyWith<QiblaCalibrationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QiblaCalibrationDataCopyWith<$Res> {
  factory $QiblaCalibrationDataCopyWith(QiblaCalibrationData value,
          $Res Function(QiblaCalibrationData) then) =
      _$QiblaCalibrationDataCopyWithImpl<$Res, QiblaCalibrationData>;
  @useResult
  $Res call(
      {double magneticDeclination,
      DateTime lastCalibration,
      CalibrationQuality quality,
      List<double> calibrationReadings,
      String? deviceModel,
      Map<String, dynamic>? sensorInfo});
}

/// @nodoc
class _$QiblaCalibrationDataCopyWithImpl<$Res,
        $Val extends QiblaCalibrationData>
    implements $QiblaCalibrationDataCopyWith<$Res> {
  _$QiblaCalibrationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QiblaCalibrationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? magneticDeclination = null,
    Object? lastCalibration = null,
    Object? quality = null,
    Object? calibrationReadings = null,
    Object? deviceModel = freezed,
    Object? sensorInfo = freezed,
  }) {
    return _then(_value.copyWith(
      magneticDeclination: null == magneticDeclination
          ? _value.magneticDeclination
          : magneticDeclination // ignore: cast_nullable_to_non_nullable
              as double,
      lastCalibration: null == lastCalibration
          ? _value.lastCalibration
          : lastCalibration // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as CalibrationQuality,
      calibrationReadings: null == calibrationReadings
          ? _value.calibrationReadings
          : calibrationReadings // ignore: cast_nullable_to_non_nullable
              as List<double>,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorInfo: freezed == sensorInfo
          ? _value.sensorInfo
          : sensorInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QiblaCalibrationDataImplCopyWith<$Res>
    implements $QiblaCalibrationDataCopyWith<$Res> {
  factory _$$QiblaCalibrationDataImplCopyWith(_$QiblaCalibrationDataImpl value,
          $Res Function(_$QiblaCalibrationDataImpl) then) =
      __$$QiblaCalibrationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double magneticDeclination,
      DateTime lastCalibration,
      CalibrationQuality quality,
      List<double> calibrationReadings,
      String? deviceModel,
      Map<String, dynamic>? sensorInfo});
}

/// @nodoc
class __$$QiblaCalibrationDataImplCopyWithImpl<$Res>
    extends _$QiblaCalibrationDataCopyWithImpl<$Res, _$QiblaCalibrationDataImpl>
    implements _$$QiblaCalibrationDataImplCopyWith<$Res> {
  __$$QiblaCalibrationDataImplCopyWithImpl(_$QiblaCalibrationDataImpl _value,
      $Res Function(_$QiblaCalibrationDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of QiblaCalibrationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? magneticDeclination = null,
    Object? lastCalibration = null,
    Object? quality = null,
    Object? calibrationReadings = null,
    Object? deviceModel = freezed,
    Object? sensorInfo = freezed,
  }) {
    return _then(_$QiblaCalibrationDataImpl(
      magneticDeclination: null == magneticDeclination
          ? _value.magneticDeclination
          : magneticDeclination // ignore: cast_nullable_to_non_nullable
              as double,
      lastCalibration: null == lastCalibration
          ? _value.lastCalibration
          : lastCalibration // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as CalibrationQuality,
      calibrationReadings: null == calibrationReadings
          ? _value._calibrationReadings
          : calibrationReadings // ignore: cast_nullable_to_non_nullable
              as List<double>,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      sensorInfo: freezed == sensorInfo
          ? _value._sensorInfo
          : sensorInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QiblaCalibrationDataImpl implements _QiblaCalibrationData {
  const _$QiblaCalibrationDataImpl(
      {required this.magneticDeclination,
      required this.lastCalibration,
      required this.quality,
      required final List<double> calibrationReadings,
      this.deviceModel,
      final Map<String, dynamic>? sensorInfo})
      : _calibrationReadings = calibrationReadings,
        _sensorInfo = sensorInfo;

  factory _$QiblaCalibrationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$QiblaCalibrationDataImplFromJson(json);

  @override
  final double magneticDeclination;
  @override
  final DateTime lastCalibration;
  @override
  final CalibrationQuality quality;
  final List<double> _calibrationReadings;
  @override
  List<double> get calibrationReadings {
    if (_calibrationReadings is EqualUnmodifiableListView)
      return _calibrationReadings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_calibrationReadings);
  }

  @override
  final String? deviceModel;
  final Map<String, dynamic>? _sensorInfo;
  @override
  Map<String, dynamic>? get sensorInfo {
    final value = _sensorInfo;
    if (value == null) return null;
    if (_sensorInfo is EqualUnmodifiableMapView) return _sensorInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'QiblaCalibrationData(magneticDeclination: $magneticDeclination, lastCalibration: $lastCalibration, quality: $quality, calibrationReadings: $calibrationReadings, deviceModel: $deviceModel, sensorInfo: $sensorInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QiblaCalibrationDataImpl &&
            (identical(other.magneticDeclination, magneticDeclination) ||
                other.magneticDeclination == magneticDeclination) &&
            (identical(other.lastCalibration, lastCalibration) ||
                other.lastCalibration == lastCalibration) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            const DeepCollectionEquality()
                .equals(other._calibrationReadings, _calibrationReadings) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            const DeepCollectionEquality()
                .equals(other._sensorInfo, _sensorInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      magneticDeclination,
      lastCalibration,
      quality,
      const DeepCollectionEquality().hash(_calibrationReadings),
      deviceModel,
      const DeepCollectionEquality().hash(_sensorInfo));

  /// Create a copy of QiblaCalibrationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QiblaCalibrationDataImplCopyWith<_$QiblaCalibrationDataImpl>
      get copyWith =>
          __$$QiblaCalibrationDataImplCopyWithImpl<_$QiblaCalibrationDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QiblaCalibrationDataImplToJson(
      this,
    );
  }
}

abstract class _QiblaCalibrationData implements QiblaCalibrationData {
  const factory _QiblaCalibrationData(
      {required final double magneticDeclination,
      required final DateTime lastCalibration,
      required final CalibrationQuality quality,
      required final List<double> calibrationReadings,
      final String? deviceModel,
      final Map<String, dynamic>? sensorInfo}) = _$QiblaCalibrationDataImpl;

  factory _QiblaCalibrationData.fromJson(Map<String, dynamic> json) =
      _$QiblaCalibrationDataImpl.fromJson;

  @override
  double get magneticDeclination;
  @override
  DateTime get lastCalibration;
  @override
  CalibrationQuality get quality;
  @override
  List<double> get calibrationReadings;
  @override
  String? get deviceModel;
  @override
  Map<String, dynamic>? get sensorInfo;

  /// Create a copy of QiblaCalibrationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QiblaCalibrationDataImplCopyWith<_$QiblaCalibrationDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrayerTracker _$PrayerTrackerFromJson(Map<String, dynamic> json) {
  return _PrayerTracker.fromJson(json);
}

/// @nodoc
mixin _$PrayerTracker {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  Map<PrayerType, PrayerCompletion> get prayers =>
      throw _privateConstructorUsedError;
  PrayerStats get dailyStats => throw _privateConstructorUsedError;
  List<PrayerReminder>? get reminders => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PrayerTracker to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrayerTracker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerTrackerCopyWith<PrayerTracker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerTrackerCopyWith<$Res> {
  factory $PrayerTrackerCopyWith(
          PrayerTracker value, $Res Function(PrayerTracker) then) =
      _$PrayerTrackerCopyWithImpl<$Res, PrayerTracker>;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime date,
      Map<PrayerType, PrayerCompletion> prayers,
      PrayerStats dailyStats,
      List<PrayerReminder>? reminders,
      Map<String, dynamic>? metadata});

  $PrayerStatsCopyWith<$Res> get dailyStats;
}

/// @nodoc
class _$PrayerTrackerCopyWithImpl<$Res, $Val extends PrayerTracker>
    implements $PrayerTrackerCopyWith<$Res> {
  _$PrayerTrackerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerTracker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? prayers = null,
    Object? dailyStats = null,
    Object? reminders = freezed,
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      prayers: null == prayers
          ? _value.prayers
          : prayers // ignore: cast_nullable_to_non_nullable
              as Map<PrayerType, PrayerCompletion>,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as PrayerStats,
      reminders: freezed == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<PrayerReminder>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of PrayerTracker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrayerStatsCopyWith<$Res> get dailyStats {
    return $PrayerStatsCopyWith<$Res>(_value.dailyStats, (value) {
      return _then(_value.copyWith(dailyStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrayerTrackerImplCopyWith<$Res>
    implements $PrayerTrackerCopyWith<$Res> {
  factory _$$PrayerTrackerImplCopyWith(
          _$PrayerTrackerImpl value, $Res Function(_$PrayerTrackerImpl) then) =
      __$$PrayerTrackerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime date,
      Map<PrayerType, PrayerCompletion> prayers,
      PrayerStats dailyStats,
      List<PrayerReminder>? reminders,
      Map<String, dynamic>? metadata});

  @override
  $PrayerStatsCopyWith<$Res> get dailyStats;
}

/// @nodoc
class __$$PrayerTrackerImplCopyWithImpl<$Res>
    extends _$PrayerTrackerCopyWithImpl<$Res, _$PrayerTrackerImpl>
    implements _$$PrayerTrackerImplCopyWith<$Res> {
  __$$PrayerTrackerImplCopyWithImpl(
      _$PrayerTrackerImpl _value, $Res Function(_$PrayerTrackerImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrayerTracker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? prayers = null,
    Object? dailyStats = null,
    Object? reminders = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PrayerTrackerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      prayers: null == prayers
          ? _value._prayers
          : prayers // ignore: cast_nullable_to_non_nullable
              as Map<PrayerType, PrayerCompletion>,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as PrayerStats,
      reminders: freezed == reminders
          ? _value._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<PrayerReminder>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrayerTrackerImpl implements _PrayerTracker {
  const _$PrayerTrackerImpl(
      {required this.id,
      required this.userId,
      required this.date,
      required final Map<PrayerType, PrayerCompletion> prayers,
      required this.dailyStats,
      final List<PrayerReminder>? reminders,
      final Map<String, dynamic>? metadata})
      : _prayers = prayers,
        _reminders = reminders,
        _metadata = metadata;

  factory _$PrayerTrackerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerTrackerImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime date;
  final Map<PrayerType, PrayerCompletion> _prayers;
  @override
  Map<PrayerType, PrayerCompletion> get prayers {
    if (_prayers is EqualUnmodifiableMapView) return _prayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_prayers);
  }

  @override
  final PrayerStats dailyStats;
  final List<PrayerReminder>? _reminders;
  @override
  List<PrayerReminder>? get reminders {
    final value = _reminders;
    if (value == null) return null;
    if (_reminders is EqualUnmodifiableListView) return _reminders;
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
  String toString() {
    return 'PrayerTracker(id: $id, userId: $userId, date: $date, prayers: $prayers, dailyStats: $dailyStats, reminders: $reminders, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTrackerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._prayers, _prayers) &&
            (identical(other.dailyStats, dailyStats) ||
                other.dailyStats == dailyStats) &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      date,
      const DeepCollectionEquality().hash(_prayers),
      dailyStats,
      const DeepCollectionEquality().hash(_reminders),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PrayerTracker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTrackerImplCopyWith<_$PrayerTrackerImpl> get copyWith =>
      __$$PrayerTrackerImplCopyWithImpl<_$PrayerTrackerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerTrackerImplToJson(
      this,
    );
  }
}

abstract class _PrayerTracker implements PrayerTracker {
  const factory _PrayerTracker(
      {required final String id,
      required final String userId,
      required final DateTime date,
      required final Map<PrayerType, PrayerCompletion> prayers,
      required final PrayerStats dailyStats,
      final List<PrayerReminder>? reminders,
      final Map<String, dynamic>? metadata}) = _$PrayerTrackerImpl;

  factory _PrayerTracker.fromJson(Map<String, dynamic> json) =
      _$PrayerTrackerImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get date;
  @override
  Map<PrayerType, PrayerCompletion> get prayers;
  @override
  PrayerStats get dailyStats;
  @override
  List<PrayerReminder>? get reminders;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PrayerTracker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTrackerImplCopyWith<_$PrayerTrackerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrayerCompletion _$PrayerCompletionFromJson(Map<String, dynamic> json) {
  return _PrayerCompletion.fromJson(json);
}

/// @nodoc
mixin _$PrayerCompletion {
  PrayerType get type => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  PrayerCompletionStatus? get status => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  bool? get isInCongregation => throw _privateConstructorUsedError;
  Duration? get duration => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  double? get qiblaAccuracy => throw _privateConstructorUsedError;

  /// Serializes this PrayerCompletion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrayerCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerCompletionCopyWith<PrayerCompletion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerCompletionCopyWith<$Res> {
  factory $PrayerCompletionCopyWith(
          PrayerCompletion value, $Res Function(PrayerCompletion) then) =
      _$PrayerCompletionCopyWithImpl<$Res, PrayerCompletion>;
  @useResult
  $Res call(
      {PrayerType type,
      DateTime scheduledTime,
      DateTime? completedAt,
      PrayerCompletionStatus? status,
      String? location,
      bool? isInCongregation,
      Duration? duration,
      String? notes,
      double? qiblaAccuracy});
}

/// @nodoc
class _$PrayerCompletionCopyWithImpl<$Res, $Val extends PrayerCompletion>
    implements $PrayerCompletionCopyWith<$Res> {
  _$PrayerCompletionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerCompletion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? scheduledTime = null,
    Object? completedAt = freezed,
    Object? status = freezed,
    Object? location = freezed,
    Object? isInCongregation = freezed,
    Object? duration = freezed,
    Object? notes = freezed,
    Object? qiblaAccuracy = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PrayerType,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PrayerCompletionStatus?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      isInCongregation: freezed == isInCongregation
          ? _value.isInCongregation
          : isInCongregation // ignore: cast_nullable_to_non_nullable
              as bool?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      qiblaAccuracy: freezed == qiblaAccuracy
          ? _value.qiblaAccuracy
          : qiblaAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrayerCompletionImplCopyWith<$Res>
    implements $PrayerCompletionCopyWith<$Res> {
  factory _$$PrayerCompletionImplCopyWith(_$PrayerCompletionImpl value,
          $Res Function(_$PrayerCompletionImpl) then) =
      __$$PrayerCompletionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PrayerType type,
      DateTime scheduledTime,
      DateTime? completedAt,
      PrayerCompletionStatus? status,
      String? location,
      bool? isInCongregation,
      Duration? duration,
      String? notes,
      double? qiblaAccuracy});
}

/// @nodoc
class __$$PrayerCompletionImplCopyWithImpl<$Res>
    extends _$PrayerCompletionCopyWithImpl<$Res, _$PrayerCompletionImpl>
    implements _$$PrayerCompletionImplCopyWith<$Res> {
  __$$PrayerCompletionImplCopyWithImpl(_$PrayerCompletionImpl _value,
      $Res Function(_$PrayerCompletionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrayerCompletion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? scheduledTime = null,
    Object? completedAt = freezed,
    Object? status = freezed,
    Object? location = freezed,
    Object? isInCongregation = freezed,
    Object? duration = freezed,
    Object? notes = freezed,
    Object? qiblaAccuracy = freezed,
  }) {
    return _then(_$PrayerCompletionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PrayerType,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PrayerCompletionStatus?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      isInCongregation: freezed == isInCongregation
          ? _value.isInCongregation
          : isInCongregation // ignore: cast_nullable_to_non_nullable
              as bool?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      qiblaAccuracy: freezed == qiblaAccuracy
          ? _value.qiblaAccuracy
          : qiblaAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrayerCompletionImpl implements _PrayerCompletion {
  const _$PrayerCompletionImpl(
      {required this.type,
      required this.scheduledTime,
      this.completedAt,
      this.status,
      this.location,
      this.isInCongregation,
      this.duration,
      this.notes,
      this.qiblaAccuracy});

  factory _$PrayerCompletionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerCompletionImplFromJson(json);

  @override
  final PrayerType type;
  @override
  final DateTime scheduledTime;
  @override
  final DateTime? completedAt;
  @override
  final PrayerCompletionStatus? status;
  @override
  final String? location;
  @override
  final bool? isInCongregation;
  @override
  final Duration? duration;
  @override
  final String? notes;
  @override
  final double? qiblaAccuracy;

  @override
  String toString() {
    return 'PrayerCompletion(type: $type, scheduledTime: $scheduledTime, completedAt: $completedAt, status: $status, location: $location, isInCongregation: $isInCongregation, duration: $duration, notes: $notes, qiblaAccuracy: $qiblaAccuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerCompletionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isInCongregation, isInCongregation) ||
                other.isInCongregation == isInCongregation) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.qiblaAccuracy, qiblaAccuracy) ||
                other.qiblaAccuracy == qiblaAccuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, scheduledTime, completedAt,
      status, location, isInCongregation, duration, notes, qiblaAccuracy);

  /// Create a copy of PrayerCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerCompletionImplCopyWith<_$PrayerCompletionImpl> get copyWith =>
      __$$PrayerCompletionImplCopyWithImpl<_$PrayerCompletionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerCompletionImplToJson(
      this,
    );
  }
}

abstract class _PrayerCompletion implements PrayerCompletion {
  const factory _PrayerCompletion(
      {required final PrayerType type,
      required final DateTime scheduledTime,
      final DateTime? completedAt,
      final PrayerCompletionStatus? status,
      final String? location,
      final bool? isInCongregation,
      final Duration? duration,
      final String? notes,
      final double? qiblaAccuracy}) = _$PrayerCompletionImpl;

  factory _PrayerCompletion.fromJson(Map<String, dynamic> json) =
      _$PrayerCompletionImpl.fromJson;

  @override
  PrayerType get type;
  @override
  DateTime get scheduledTime;
  @override
  DateTime? get completedAt;
  @override
  PrayerCompletionStatus? get status;
  @override
  String? get location;
  @override
  bool? get isInCongregation;
  @override
  Duration? get duration;
  @override
  String? get notes;
  @override
  double? get qiblaAccuracy;

  /// Create a copy of PrayerCompletion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerCompletionImplCopyWith<_$PrayerCompletionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrayerStats _$PrayerStatsFromJson(Map<String, dynamic> json) {
  return _PrayerStats.fromJson(json);
}

/// @nodoc
mixin _$PrayerStats {
  int get totalPrayers => throw _privateConstructorUsedError;
  int get completedPrayers => throw _privateConstructorUsedError;
  int get missedPrayers => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  Duration get totalPrayerTime => throw _privateConstructorUsedError;
  Map<PrayerType, int> get prayerCounts => throw _privateConstructorUsedError;
  String? get bestStreak => throw _privateConstructorUsedError;
  DateTime? get lastPrayerTime => throw _privateConstructorUsedError;

  /// Serializes this PrayerStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerStatsCopyWith<PrayerStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerStatsCopyWith<$Res> {
  factory $PrayerStatsCopyWith(
          PrayerStats value, $Res Function(PrayerStats) then) =
      _$PrayerStatsCopyWithImpl<$Res, PrayerStats>;
  @useResult
  $Res call(
      {int totalPrayers,
      int completedPrayers,
      int missedPrayers,
      double completionRate,
      Duration totalPrayerTime,
      Map<PrayerType, int> prayerCounts,
      String? bestStreak,
      DateTime? lastPrayerTime});
}

/// @nodoc
class _$PrayerStatsCopyWithImpl<$Res, $Val extends PrayerStats>
    implements $PrayerStatsCopyWith<$Res> {
  _$PrayerStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPrayers = null,
    Object? completedPrayers = null,
    Object? missedPrayers = null,
    Object? completionRate = null,
    Object? totalPrayerTime = null,
    Object? prayerCounts = null,
    Object? bestStreak = freezed,
    Object? lastPrayerTime = freezed,
  }) {
    return _then(_value.copyWith(
      totalPrayers: null == totalPrayers
          ? _value.totalPrayers
          : totalPrayers // ignore: cast_nullable_to_non_nullable
              as int,
      completedPrayers: null == completedPrayers
          ? _value.completedPrayers
          : completedPrayers // ignore: cast_nullable_to_non_nullable
              as int,
      missedPrayers: null == missedPrayers
          ? _value.missedPrayers
          : missedPrayers // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrayerTime: null == totalPrayerTime
          ? _value.totalPrayerTime
          : totalPrayerTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      prayerCounts: null == prayerCounts
          ? _value.prayerCounts
          : prayerCounts // ignore: cast_nullable_to_non_nullable
              as Map<PrayerType, int>,
      bestStreak: freezed == bestStreak
          ? _value.bestStreak
          : bestStreak // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPrayerTime: freezed == lastPrayerTime
          ? _value.lastPrayerTime
          : lastPrayerTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrayerStatsImplCopyWith<$Res>
    implements $PrayerStatsCopyWith<$Res> {
  factory _$$PrayerStatsImplCopyWith(
          _$PrayerStatsImpl value, $Res Function(_$PrayerStatsImpl) then) =
      __$$PrayerStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalPrayers,
      int completedPrayers,
      int missedPrayers,
      double completionRate,
      Duration totalPrayerTime,
      Map<PrayerType, int> prayerCounts,
      String? bestStreak,
      DateTime? lastPrayerTime});
}

/// @nodoc
class __$$PrayerStatsImplCopyWithImpl<$Res>
    extends _$PrayerStatsCopyWithImpl<$Res, _$PrayerStatsImpl>
    implements _$$PrayerStatsImplCopyWith<$Res> {
  __$$PrayerStatsImplCopyWithImpl(
      _$PrayerStatsImpl _value, $Res Function(_$PrayerStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPrayers = null,
    Object? completedPrayers = null,
    Object? missedPrayers = null,
    Object? completionRate = null,
    Object? totalPrayerTime = null,
    Object? prayerCounts = null,
    Object? bestStreak = freezed,
    Object? lastPrayerTime = freezed,
  }) {
    return _then(_$PrayerStatsImpl(
      totalPrayers: null == totalPrayers
          ? _value.totalPrayers
          : totalPrayers // ignore: cast_nullable_to_non_nullable
              as int,
      completedPrayers: null == completedPrayers
          ? _value.completedPrayers
          : completedPrayers // ignore: cast_nullable_to_non_nullable
              as int,
      missedPrayers: null == missedPrayers
          ? _value.missedPrayers
          : missedPrayers // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrayerTime: null == totalPrayerTime
          ? _value.totalPrayerTime
          : totalPrayerTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      prayerCounts: null == prayerCounts
          ? _value._prayerCounts
          : prayerCounts // ignore: cast_nullable_to_non_nullable
              as Map<PrayerType, int>,
      bestStreak: freezed == bestStreak
          ? _value.bestStreak
          : bestStreak // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPrayerTime: freezed == lastPrayerTime
          ? _value.lastPrayerTime
          : lastPrayerTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrayerStatsImpl implements _PrayerStats {
  const _$PrayerStatsImpl(
      {required this.totalPrayers,
      required this.completedPrayers,
      required this.missedPrayers,
      required this.completionRate,
      required this.totalPrayerTime,
      required final Map<PrayerType, int> prayerCounts,
      this.bestStreak,
      this.lastPrayerTime})
      : _prayerCounts = prayerCounts;

  factory _$PrayerStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerStatsImplFromJson(json);

  @override
  final int totalPrayers;
  @override
  final int completedPrayers;
  @override
  final int missedPrayers;
  @override
  final double completionRate;
  @override
  final Duration totalPrayerTime;
  final Map<PrayerType, int> _prayerCounts;
  @override
  Map<PrayerType, int> get prayerCounts {
    if (_prayerCounts is EqualUnmodifiableMapView) return _prayerCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_prayerCounts);
  }

  @override
  final String? bestStreak;
  @override
  final DateTime? lastPrayerTime;

  @override
  String toString() {
    return 'PrayerStats(totalPrayers: $totalPrayers, completedPrayers: $completedPrayers, missedPrayers: $missedPrayers, completionRate: $completionRate, totalPrayerTime: $totalPrayerTime, prayerCounts: $prayerCounts, bestStreak: $bestStreak, lastPrayerTime: $lastPrayerTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerStatsImpl &&
            (identical(other.totalPrayers, totalPrayers) ||
                other.totalPrayers == totalPrayers) &&
            (identical(other.completedPrayers, completedPrayers) ||
                other.completedPrayers == completedPrayers) &&
            (identical(other.missedPrayers, missedPrayers) ||
                other.missedPrayers == missedPrayers) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.totalPrayerTime, totalPrayerTime) ||
                other.totalPrayerTime == totalPrayerTime) &&
            const DeepCollectionEquality()
                .equals(other._prayerCounts, _prayerCounts) &&
            (identical(other.bestStreak, bestStreak) ||
                other.bestStreak == bestStreak) &&
            (identical(other.lastPrayerTime, lastPrayerTime) ||
                other.lastPrayerTime == lastPrayerTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPrayers,
      completedPrayers,
      missedPrayers,
      completionRate,
      totalPrayerTime,
      const DeepCollectionEquality().hash(_prayerCounts),
      bestStreak,
      lastPrayerTime);

  /// Create a copy of PrayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerStatsImplCopyWith<_$PrayerStatsImpl> get copyWith =>
      __$$PrayerStatsImplCopyWithImpl<_$PrayerStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerStatsImplToJson(
      this,
    );
  }
}

abstract class _PrayerStats implements PrayerStats {
  const factory _PrayerStats(
      {required final int totalPrayers,
      required final int completedPrayers,
      required final int missedPrayers,
      required final double completionRate,
      required final Duration totalPrayerTime,
      required final Map<PrayerType, int> prayerCounts,
      final String? bestStreak,
      final DateTime? lastPrayerTime}) = _$PrayerStatsImpl;

  factory _PrayerStats.fromJson(Map<String, dynamic> json) =
      _$PrayerStatsImpl.fromJson;

  @override
  int get totalPrayers;
  @override
  int get completedPrayers;
  @override
  int get missedPrayers;
  @override
  double get completionRate;
  @override
  Duration get totalPrayerTime;
  @override
  Map<PrayerType, int> get prayerCounts;
  @override
  String? get bestStreak;
  @override
  DateTime? get lastPrayerTime;

  /// Create a copy of PrayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerStatsImplCopyWith<_$PrayerStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrayerReminder _$PrayerReminderFromJson(Map<String, dynamic> json) {
  return _PrayerReminder.fromJson(json);
}

/// @nodoc
mixin _$PrayerReminder {
  String get id => throw _privateConstructorUsedError;
  PrayerType get prayerType => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  Duration? get advanceNotification => throw _privateConstructorUsedError;
  String? get customMessage => throw _privateConstructorUsedError;
  ReminderRepeat? get repeatType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get soundSettings => throw _privateConstructorUsedError;

  /// Serializes this PrayerReminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrayerReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerReminderCopyWith<PrayerReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerReminderCopyWith<$Res> {
  factory $PrayerReminderCopyWith(
          PrayerReminder value, $Res Function(PrayerReminder) then) =
      _$PrayerReminderCopyWithImpl<$Res, PrayerReminder>;
  @useResult
  $Res call(
      {String id,
      PrayerType prayerType,
      DateTime scheduledTime,
      bool isEnabled,
      Duration? advanceNotification,
      String? customMessage,
      ReminderRepeat? repeatType,
      Map<String, dynamic>? soundSettings});
}

/// @nodoc
class _$PrayerReminderCopyWithImpl<$Res, $Val extends PrayerReminder>
    implements $PrayerReminderCopyWith<$Res> {
  _$PrayerReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? prayerType = null,
    Object? scheduledTime = null,
    Object? isEnabled = null,
    Object? advanceNotification = freezed,
    Object? customMessage = freezed,
    Object? repeatType = freezed,
    Object? soundSettings = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      prayerType: null == prayerType
          ? _value.prayerType
          : prayerType // ignore: cast_nullable_to_non_nullable
              as PrayerType,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      advanceNotification: freezed == advanceNotification
          ? _value.advanceNotification
          : advanceNotification // ignore: cast_nullable_to_non_nullable
              as Duration?,
      customMessage: freezed == customMessage
          ? _value.customMessage
          : customMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      repeatType: freezed == repeatType
          ? _value.repeatType
          : repeatType // ignore: cast_nullable_to_non_nullable
              as ReminderRepeat?,
      soundSettings: freezed == soundSettings
          ? _value.soundSettings
          : soundSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrayerReminderImplCopyWith<$Res>
    implements $PrayerReminderCopyWith<$Res> {
  factory _$$PrayerReminderImplCopyWith(_$PrayerReminderImpl value,
          $Res Function(_$PrayerReminderImpl) then) =
      __$$PrayerReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PrayerType prayerType,
      DateTime scheduledTime,
      bool isEnabled,
      Duration? advanceNotification,
      String? customMessage,
      ReminderRepeat? repeatType,
      Map<String, dynamic>? soundSettings});
}

/// @nodoc
class __$$PrayerReminderImplCopyWithImpl<$Res>
    extends _$PrayerReminderCopyWithImpl<$Res, _$PrayerReminderImpl>
    implements _$$PrayerReminderImplCopyWith<$Res> {
  __$$PrayerReminderImplCopyWithImpl(
      _$PrayerReminderImpl _value, $Res Function(_$PrayerReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrayerReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? prayerType = null,
    Object? scheduledTime = null,
    Object? isEnabled = null,
    Object? advanceNotification = freezed,
    Object? customMessage = freezed,
    Object? repeatType = freezed,
    Object? soundSettings = freezed,
  }) {
    return _then(_$PrayerReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      prayerType: null == prayerType
          ? _value.prayerType
          : prayerType // ignore: cast_nullable_to_non_nullable
              as PrayerType,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      advanceNotification: freezed == advanceNotification
          ? _value.advanceNotification
          : advanceNotification // ignore: cast_nullable_to_non_nullable
              as Duration?,
      customMessage: freezed == customMessage
          ? _value.customMessage
          : customMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      repeatType: freezed == repeatType
          ? _value.repeatType
          : repeatType // ignore: cast_nullable_to_non_nullable
              as ReminderRepeat?,
      soundSettings: freezed == soundSettings
          ? _value._soundSettings
          : soundSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrayerReminderImpl implements _PrayerReminder {
  const _$PrayerReminderImpl(
      {required this.id,
      required this.prayerType,
      required this.scheduledTime,
      required this.isEnabled,
      this.advanceNotification,
      this.customMessage,
      this.repeatType,
      final Map<String, dynamic>? soundSettings})
      : _soundSettings = soundSettings;

  factory _$PrayerReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerReminderImplFromJson(json);

  @override
  final String id;
  @override
  final PrayerType prayerType;
  @override
  final DateTime scheduledTime;
  @override
  final bool isEnabled;
  @override
  final Duration? advanceNotification;
  @override
  final String? customMessage;
  @override
  final ReminderRepeat? repeatType;
  final Map<String, dynamic>? _soundSettings;
  @override
  Map<String, dynamic>? get soundSettings {
    final value = _soundSettings;
    if (value == null) return null;
    if (_soundSettings is EqualUnmodifiableMapView) return _soundSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PrayerReminder(id: $id, prayerType: $prayerType, scheduledTime: $scheduledTime, isEnabled: $isEnabled, advanceNotification: $advanceNotification, customMessage: $customMessage, repeatType: $repeatType, soundSettings: $soundSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.prayerType, prayerType) ||
                other.prayerType == prayerType) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.advanceNotification, advanceNotification) ||
                other.advanceNotification == advanceNotification) &&
            (identical(other.customMessage, customMessage) ||
                other.customMessage == customMessage) &&
            (identical(other.repeatType, repeatType) ||
                other.repeatType == repeatType) &&
            const DeepCollectionEquality()
                .equals(other._soundSettings, _soundSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      prayerType,
      scheduledTime,
      isEnabled,
      advanceNotification,
      customMessage,
      repeatType,
      const DeepCollectionEquality().hash(_soundSettings));

  /// Create a copy of PrayerReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerReminderImplCopyWith<_$PrayerReminderImpl> get copyWith =>
      __$$PrayerReminderImplCopyWithImpl<_$PrayerReminderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerReminderImplToJson(
      this,
    );
  }
}

abstract class _PrayerReminder implements PrayerReminder {
  const factory _PrayerReminder(
      {required final String id,
      required final PrayerType prayerType,
      required final DateTime scheduledTime,
      required final bool isEnabled,
      final Duration? advanceNotification,
      final String? customMessage,
      final ReminderRepeat? repeatType,
      final Map<String, dynamic>? soundSettings}) = _$PrayerReminderImpl;

  factory _PrayerReminder.fromJson(Map<String, dynamic> json) =
      _$PrayerReminderImpl.fromJson;

  @override
  String get id;
  @override
  PrayerType get prayerType;
  @override
  DateTime get scheduledTime;
  @override
  bool get isEnabled;
  @override
  Duration? get advanceNotification;
  @override
  String? get customMessage;
  @override
  ReminderRepeat? get repeatType;
  @override
  Map<String, dynamic>? get soundSettings;

  /// Create a copy of PrayerReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerReminderImplCopyWith<_$PrayerReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MosqueLocation _$MosqueLocationFromJson(Map<String, dynamic> json) {
  return _MosqueLocation.fromJson(json);
}

/// @nodoc
mixin _$MosqueLocation {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get distanceInMeters => throw _privateConstructorUsedError;
  double get qiblaDirection => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  List<String>? get amenities => throw _privateConstructorUsedError;
  Map<PrayerType, DateTime>? get prayerTimes =>
      throw _privateConstructorUsedError;
  MosqueRating? get rating => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;

  /// Serializes this MosqueLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MosqueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MosqueLocationCopyWith<MosqueLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MosqueLocationCopyWith<$Res> {
  factory $MosqueLocationCopyWith(
          MosqueLocation value, $Res Function(MosqueLocation) then) =
      _$MosqueLocationCopyWithImpl<$Res, MosqueLocation>;
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      double distanceInMeters,
      double qiblaDirection,
      String? address,
      String? phoneNumber,
      String? website,
      List<String>? amenities,
      Map<PrayerType, DateTime>? prayerTimes,
      MosqueRating? rating,
      List<String>? images});

  $MosqueRatingCopyWith<$Res>? get rating;
}

/// @nodoc
class _$MosqueLocationCopyWithImpl<$Res, $Val extends MosqueLocation>
    implements $MosqueLocationCopyWith<$Res> {
  _$MosqueLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MosqueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distanceInMeters = null,
    Object? qiblaDirection = null,
    Object? address = freezed,
    Object? phoneNumber = freezed,
    Object? website = freezed,
    Object? amenities = freezed,
    Object? prayerTimes = freezed,
    Object? rating = freezed,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      distanceInMeters: null == distanceInMeters
          ? _value.distanceInMeters
          : distanceInMeters // ignore: cast_nullable_to_non_nullable
              as double,
      qiblaDirection: null == qiblaDirection
          ? _value.qiblaDirection
          : qiblaDirection // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      amenities: freezed == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      prayerTimes: freezed == prayerTimes
          ? _value.prayerTimes
          : prayerTimes // ignore: cast_nullable_to_non_nullable
              as Map<PrayerType, DateTime>?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as MosqueRating?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of MosqueLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MosqueRatingCopyWith<$Res>? get rating {
    if (_value.rating == null) {
      return null;
    }

    return $MosqueRatingCopyWith<$Res>(_value.rating!, (value) {
      return _then(_value.copyWith(rating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MosqueLocationImplCopyWith<$Res>
    implements $MosqueLocationCopyWith<$Res> {
  factory _$$MosqueLocationImplCopyWith(_$MosqueLocationImpl value,
          $Res Function(_$MosqueLocationImpl) then) =
      __$$MosqueLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      double distanceInMeters,
      double qiblaDirection,
      String? address,
      String? phoneNumber,
      String? website,
      List<String>? amenities,
      Map<PrayerType, DateTime>? prayerTimes,
      MosqueRating? rating,
      List<String>? images});

  @override
  $MosqueRatingCopyWith<$Res>? get rating;
}

/// @nodoc
class __$$MosqueLocationImplCopyWithImpl<$Res>
    extends _$MosqueLocationCopyWithImpl<$Res, _$MosqueLocationImpl>
    implements _$$MosqueLocationImplCopyWith<$Res> {
  __$$MosqueLocationImplCopyWithImpl(
      _$MosqueLocationImpl _value, $Res Function(_$MosqueLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of MosqueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distanceInMeters = null,
    Object? qiblaDirection = null,
    Object? address = freezed,
    Object? phoneNumber = freezed,
    Object? website = freezed,
    Object? amenities = freezed,
    Object? prayerTimes = freezed,
    Object? rating = freezed,
    Object? images = freezed,
  }) {
    return _then(_$MosqueLocationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      distanceInMeters: null == distanceInMeters
          ? _value.distanceInMeters
          : distanceInMeters // ignore: cast_nullable_to_non_nullable
              as double,
      qiblaDirection: null == qiblaDirection
          ? _value.qiblaDirection
          : qiblaDirection // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      amenities: freezed == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      prayerTimes: freezed == prayerTimes
          ? _value._prayerTimes
          : prayerTimes // ignore: cast_nullable_to_non_nullable
              as Map<PrayerType, DateTime>?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as MosqueRating?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MosqueLocationImpl implements _MosqueLocation {
  const _$MosqueLocationImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.distanceInMeters,
      required this.qiblaDirection,
      this.address,
      this.phoneNumber,
      this.website,
      final List<String>? amenities,
      final Map<PrayerType, DateTime>? prayerTimes,
      this.rating,
      final List<String>? images})
      : _amenities = amenities,
        _prayerTimes = prayerTimes,
        _images = images;

  factory _$MosqueLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MosqueLocationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double distanceInMeters;
  @override
  final double qiblaDirection;
  @override
  final String? address;
  @override
  final String? phoneNumber;
  @override
  final String? website;
  final List<String>? _amenities;
  @override
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<PrayerType, DateTime>? _prayerTimes;
  @override
  Map<PrayerType, DateTime>? get prayerTimes {
    final value = _prayerTimes;
    if (value == null) return null;
    if (_prayerTimes is EqualUnmodifiableMapView) return _prayerTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final MosqueRating? rating;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MosqueLocation(id: $id, name: $name, latitude: $latitude, longitude: $longitude, distanceInMeters: $distanceInMeters, qiblaDirection: $qiblaDirection, address: $address, phoneNumber: $phoneNumber, website: $website, amenities: $amenities, prayerTimes: $prayerTimes, rating: $rating, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MosqueLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.distanceInMeters, distanceInMeters) ||
                other.distanceInMeters == distanceInMeters) &&
            (identical(other.qiblaDirection, qiblaDirection) ||
                other.qiblaDirection == qiblaDirection) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.website, website) || other.website == website) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            const DeepCollectionEquality()
                .equals(other._prayerTimes, _prayerTimes) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      latitude,
      longitude,
      distanceInMeters,
      qiblaDirection,
      address,
      phoneNumber,
      website,
      const DeepCollectionEquality().hash(_amenities),
      const DeepCollectionEquality().hash(_prayerTimes),
      rating,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of MosqueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MosqueLocationImplCopyWith<_$MosqueLocationImpl> get copyWith =>
      __$$MosqueLocationImplCopyWithImpl<_$MosqueLocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MosqueLocationImplToJson(
      this,
    );
  }
}

abstract class _MosqueLocation implements MosqueLocation {
  const factory _MosqueLocation(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      required final double distanceInMeters,
      required final double qiblaDirection,
      final String? address,
      final String? phoneNumber,
      final String? website,
      final List<String>? amenities,
      final Map<PrayerType, DateTime>? prayerTimes,
      final MosqueRating? rating,
      final List<String>? images}) = _$MosqueLocationImpl;

  factory _MosqueLocation.fromJson(Map<String, dynamic> json) =
      _$MosqueLocationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get distanceInMeters;
  @override
  double get qiblaDirection;
  @override
  String? get address;
  @override
  String? get phoneNumber;
  @override
  String? get website;
  @override
  List<String>? get amenities;
  @override
  Map<PrayerType, DateTime>? get prayerTimes;
  @override
  MosqueRating? get rating;
  @override
  List<String>? get images;

  /// Create a copy of MosqueLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MosqueLocationImplCopyWith<_$MosqueLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MosqueRating _$MosqueRatingFromJson(Map<String, dynamic> json) {
  return _MosqueRating.fromJson(json);
}

/// @nodoc
mixin _$MosqueRating {
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  Map<String, int> get categoryRatings => throw _privateConstructorUsedError;
  List<MosqueReview>? get recentReviews => throw _privateConstructorUsedError;

  /// Serializes this MosqueRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MosqueRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MosqueRatingCopyWith<MosqueRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MosqueRatingCopyWith<$Res> {
  factory $MosqueRatingCopyWith(
          MosqueRating value, $Res Function(MosqueRating) then) =
      _$MosqueRatingCopyWithImpl<$Res, MosqueRating>;
  @useResult
  $Res call(
      {double averageRating,
      int totalReviews,
      Map<String, int> categoryRatings,
      List<MosqueReview>? recentReviews});
}

/// @nodoc
class _$MosqueRatingCopyWithImpl<$Res, $Val extends MosqueRating>
    implements $MosqueRatingCopyWith<$Res> {
  _$MosqueRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MosqueRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? categoryRatings = null,
    Object? recentReviews = freezed,
  }) {
    return _then(_value.copyWith(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      categoryRatings: null == categoryRatings
          ? _value.categoryRatings
          : categoryRatings // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      recentReviews: freezed == recentReviews
          ? _value.recentReviews
          : recentReviews // ignore: cast_nullable_to_non_nullable
              as List<MosqueReview>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MosqueRatingImplCopyWith<$Res>
    implements $MosqueRatingCopyWith<$Res> {
  factory _$$MosqueRatingImplCopyWith(
          _$MosqueRatingImpl value, $Res Function(_$MosqueRatingImpl) then) =
      __$$MosqueRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double averageRating,
      int totalReviews,
      Map<String, int> categoryRatings,
      List<MosqueReview>? recentReviews});
}

/// @nodoc
class __$$MosqueRatingImplCopyWithImpl<$Res>
    extends _$MosqueRatingCopyWithImpl<$Res, _$MosqueRatingImpl>
    implements _$$MosqueRatingImplCopyWith<$Res> {
  __$$MosqueRatingImplCopyWithImpl(
      _$MosqueRatingImpl _value, $Res Function(_$MosqueRatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MosqueRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? categoryRatings = null,
    Object? recentReviews = freezed,
  }) {
    return _then(_$MosqueRatingImpl(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      categoryRatings: null == categoryRatings
          ? _value._categoryRatings
          : categoryRatings // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      recentReviews: freezed == recentReviews
          ? _value._recentReviews
          : recentReviews // ignore: cast_nullable_to_non_nullable
              as List<MosqueReview>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MosqueRatingImpl implements _MosqueRating {
  const _$MosqueRatingImpl(
      {required this.averageRating,
      required this.totalReviews,
      required final Map<String, int> categoryRatings,
      final List<MosqueReview>? recentReviews})
      : _categoryRatings = categoryRatings,
        _recentReviews = recentReviews;

  factory _$MosqueRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MosqueRatingImplFromJson(json);

  @override
  final double averageRating;
  @override
  final int totalReviews;
  final Map<String, int> _categoryRatings;
  @override
  Map<String, int> get categoryRatings {
    if (_categoryRatings is EqualUnmodifiableMapView) return _categoryRatings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryRatings);
  }

  final List<MosqueReview>? _recentReviews;
  @override
  List<MosqueReview>? get recentReviews {
    final value = _recentReviews;
    if (value == null) return null;
    if (_recentReviews is EqualUnmodifiableListView) return _recentReviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MosqueRating(averageRating: $averageRating, totalReviews: $totalReviews, categoryRatings: $categoryRatings, recentReviews: $recentReviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MosqueRatingImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality()
                .equals(other._categoryRatings, _categoryRatings) &&
            const DeepCollectionEquality()
                .equals(other._recentReviews, _recentReviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averageRating,
      totalReviews,
      const DeepCollectionEquality().hash(_categoryRatings),
      const DeepCollectionEquality().hash(_recentReviews));

  /// Create a copy of MosqueRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MosqueRatingImplCopyWith<_$MosqueRatingImpl> get copyWith =>
      __$$MosqueRatingImplCopyWithImpl<_$MosqueRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MosqueRatingImplToJson(
      this,
    );
  }
}

abstract class _MosqueRating implements MosqueRating {
  const factory _MosqueRating(
      {required final double averageRating,
      required final int totalReviews,
      required final Map<String, int> categoryRatings,
      final List<MosqueReview>? recentReviews}) = _$MosqueRatingImpl;

  factory _MosqueRating.fromJson(Map<String, dynamic> json) =
      _$MosqueRatingImpl.fromJson;

  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  Map<String, int> get categoryRatings;
  @override
  List<MosqueReview>? get recentReviews;

  /// Create a copy of MosqueRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MosqueRatingImplCopyWith<_$MosqueRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MosqueReview _$MosqueReviewFromJson(Map<String, dynamic> json) {
  return _MosqueReview.fromJson(json);
}

/// @nodoc
mixin _$MosqueReview {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  DateTime get reviewDate => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  List<String>? get categories => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;

  /// Serializes this MosqueReview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MosqueReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MosqueReviewCopyWith<MosqueReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MosqueReviewCopyWith<$Res> {
  factory $MosqueReviewCopyWith(
          MosqueReview value, $Res Function(MosqueReview) then) =
      _$MosqueReviewCopyWithImpl<$Res, MosqueReview>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int rating,
      DateTime reviewDate,
      String? comment,
      List<String>? categories,
      bool? isVerified});
}

/// @nodoc
class _$MosqueReviewCopyWithImpl<$Res, $Val extends MosqueReview>
    implements $MosqueReviewCopyWith<$Res> {
  _$MosqueReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MosqueReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? rating = null,
    Object? reviewDate = null,
    Object? comment = freezed,
    Object? categories = freezed,
    Object? isVerified = freezed,
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
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      reviewDate: null == reviewDate
          ? _value.reviewDate
          : reviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MosqueReviewImplCopyWith<$Res>
    implements $MosqueReviewCopyWith<$Res> {
  factory _$$MosqueReviewImplCopyWith(
          _$MosqueReviewImpl value, $Res Function(_$MosqueReviewImpl) then) =
      __$$MosqueReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int rating,
      DateTime reviewDate,
      String? comment,
      List<String>? categories,
      bool? isVerified});
}

/// @nodoc
class __$$MosqueReviewImplCopyWithImpl<$Res>
    extends _$MosqueReviewCopyWithImpl<$Res, _$MosqueReviewImpl>
    implements _$$MosqueReviewImplCopyWith<$Res> {
  __$$MosqueReviewImplCopyWithImpl(
      _$MosqueReviewImpl _value, $Res Function(_$MosqueReviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of MosqueReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? rating = null,
    Object? reviewDate = null,
    Object? comment = freezed,
    Object? categories = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_$MosqueReviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      reviewDate: null == reviewDate
          ? _value.reviewDate
          : reviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MosqueReviewImpl implements _MosqueReview {
  const _$MosqueReviewImpl(
      {required this.id,
      required this.userId,
      required this.rating,
      required this.reviewDate,
      this.comment,
      final List<String>? categories,
      this.isVerified})
      : _categories = categories;

  factory _$MosqueReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$MosqueReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int rating;
  @override
  final DateTime reviewDate;
  @override
  final String? comment;
  final List<String>? _categories;
  @override
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isVerified;

  @override
  String toString() {
    return 'MosqueReview(id: $id, userId: $userId, rating: $rating, reviewDate: $reviewDate, comment: $comment, categories: $categories, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MosqueReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewDate, reviewDate) ||
                other.reviewDate == reviewDate) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, rating, reviewDate,
      comment, const DeepCollectionEquality().hash(_categories), isVerified);

  /// Create a copy of MosqueReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MosqueReviewImplCopyWith<_$MosqueReviewImpl> get copyWith =>
      __$$MosqueReviewImplCopyWithImpl<_$MosqueReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MosqueReviewImplToJson(
      this,
    );
  }
}

abstract class _MosqueReview implements MosqueReview {
  const factory _MosqueReview(
      {required final String id,
      required final String userId,
      required final int rating,
      required final DateTime reviewDate,
      final String? comment,
      final List<String>? categories,
      final bool? isVerified}) = _$MosqueReviewImpl;

  factory _MosqueReview.fromJson(Map<String, dynamic> json) =
      _$MosqueReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get rating;
  @override
  DateTime get reviewDate;
  @override
  String? get comment;
  @override
  List<String>? get categories;
  @override
  bool? get isVerified;

  /// Create a copy of MosqueReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MosqueReviewImplCopyWith<_$MosqueReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
