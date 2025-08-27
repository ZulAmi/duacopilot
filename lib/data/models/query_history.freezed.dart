// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QueryHistory _$QueryHistoryFromJson(Map<String, dynamic> json) {
  return _QueryHistory.fromJson(json);
}

/// @nodoc
mixin _$QueryHistory {
  String get id => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  String get response => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get responseTime => throw _privateConstructorUsedError;
  String get semanticHash => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get context => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isFromCache => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  int? get accessCount => throw _privateConstructorUsedError;

  /// Serializes this QueryHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueryHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueryHistoryCopyWith<QueryHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryHistoryCopyWith<$Res> {
  factory $QueryHistoryCopyWith(
          QueryHistory value, $Res Function(QueryHistory) then) =
      _$QueryHistoryCopyWithImpl<$Res, QueryHistory>;
  @useResult
  $Res call(
      {String id,
      String query,
      String response,
      DateTime timestamp,
      int responseTime,
      String semanticHash,
      double? confidence,
      String? sessionId,
      List<String>? tags,
      Map<String, dynamic>? context,
      Map<String, dynamic>? metadata,
      bool isFavorite,
      bool isFromCache,
      DateTime? lastAccessed,
      int? accessCount});
}

/// @nodoc
class _$QueryHistoryCopyWithImpl<$Res, $Val extends QueryHistory>
    implements $QueryHistoryCopyWith<$Res> {
  _$QueryHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueryHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? response = null,
    Object? timestamp = null,
    Object? responseTime = null,
    Object? semanticHash = null,
    Object? confidence = freezed,
    Object? sessionId = freezed,
    Object? tags = freezed,
    Object? context = freezed,
    Object? metadata = freezed,
    Object? isFavorite = null,
    Object? isFromCache = null,
    Object? lastAccessed = freezed,
    Object? accessCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      responseTime: null == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as int,
      semanticHash: null == semanticHash
          ? _value.semanticHash
          : semanticHash // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isFromCache: null == isFromCache
          ? _value.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      accessCount: freezed == accessCount
          ? _value.accessCount
          : accessCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryHistoryImplCopyWith<$Res>
    implements $QueryHistoryCopyWith<$Res> {
  factory _$$QueryHistoryImplCopyWith(
          _$QueryHistoryImpl value, $Res Function(_$QueryHistoryImpl) then) =
      __$$QueryHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String query,
      String response,
      DateTime timestamp,
      int responseTime,
      String semanticHash,
      double? confidence,
      String? sessionId,
      List<String>? tags,
      Map<String, dynamic>? context,
      Map<String, dynamic>? metadata,
      bool isFavorite,
      bool isFromCache,
      DateTime? lastAccessed,
      int? accessCount});
}

/// @nodoc
class __$$QueryHistoryImplCopyWithImpl<$Res>
    extends _$QueryHistoryCopyWithImpl<$Res, _$QueryHistoryImpl>
    implements _$$QueryHistoryImplCopyWith<$Res> {
  __$$QueryHistoryImplCopyWithImpl(
      _$QueryHistoryImpl _value, $Res Function(_$QueryHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of QueryHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? response = null,
    Object? timestamp = null,
    Object? responseTime = null,
    Object? semanticHash = null,
    Object? confidence = freezed,
    Object? sessionId = freezed,
    Object? tags = freezed,
    Object? context = freezed,
    Object? metadata = freezed,
    Object? isFavorite = null,
    Object? isFromCache = null,
    Object? lastAccessed = freezed,
    Object? accessCount = freezed,
  }) {
    return _then(_$QueryHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      responseTime: null == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as int,
      semanticHash: null == semanticHash
          ? _value.semanticHash
          : semanticHash // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      context: freezed == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isFromCache: null == isFromCache
          ? _value.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      accessCount: freezed == accessCount
          ? _value.accessCount
          : accessCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QueryHistoryImpl implements _QueryHistory {
  const _$QueryHistoryImpl(
      {required this.id,
      required this.query,
      required this.response,
      required this.timestamp,
      required this.responseTime,
      required this.semanticHash,
      this.confidence,
      this.sessionId,
      final List<String>? tags,
      final Map<String, dynamic>? context,
      final Map<String, dynamic>? metadata,
      this.isFavorite = false,
      this.isFromCache = false,
      this.lastAccessed,
      this.accessCount})
      : _tags = tags,
        _context = context,
        _metadata = metadata;

  factory _$QueryHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueryHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String query;
  @override
  final String response;
  @override
  final DateTime timestamp;
  @override
  final int responseTime;
  @override
  final String semanticHash;
  @override
  final double? confidence;
  @override
  final String? sessionId;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _context;
  @override
  Map<String, dynamic>? get context {
    final value = _context;
    if (value == null) return null;
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
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
  final bool isFromCache;
  @override
  final DateTime? lastAccessed;
  @override
  final int? accessCount;

  @override
  String toString() {
    return 'QueryHistory(id: $id, query: $query, response: $response, timestamp: $timestamp, responseTime: $responseTime, semanticHash: $semanticHash, confidence: $confidence, sessionId: $sessionId, tags: $tags, context: $context, metadata: $metadata, isFavorite: $isFavorite, isFromCache: $isFromCache, lastAccessed: $lastAccessed, accessCount: $accessCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.responseTime, responseTime) ||
                other.responseTime == responseTime) &&
            (identical(other.semanticHash, semanticHash) ||
                other.semanticHash == semanticHash) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isFromCache, isFromCache) ||
                other.isFromCache == isFromCache) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.accessCount, accessCount) ||
                other.accessCount == accessCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      query,
      response,
      timestamp,
      responseTime,
      semanticHash,
      confidence,
      sessionId,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_context),
      const DeepCollectionEquality().hash(_metadata),
      isFavorite,
      isFromCache,
      lastAccessed,
      accessCount);

  /// Create a copy of QueryHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryHistoryImplCopyWith<_$QueryHistoryImpl> get copyWith =>
      __$$QueryHistoryImplCopyWithImpl<_$QueryHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueryHistoryImplToJson(
      this,
    );
  }
}

abstract class _QueryHistory implements QueryHistory {
  const factory _QueryHistory(
      {required final String id,
      required final String query,
      required final String response,
      required final DateTime timestamp,
      required final int responseTime,
      required final String semanticHash,
      final double? confidence,
      final String? sessionId,
      final List<String>? tags,
      final Map<String, dynamic>? context,
      final Map<String, dynamic>? metadata,
      final bool isFavorite,
      final bool isFromCache,
      final DateTime? lastAccessed,
      final int? accessCount}) = _$QueryHistoryImpl;

  factory _QueryHistory.fromJson(Map<String, dynamic> json) =
      _$QueryHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get query;
  @override
  String get response;
  @override
  DateTime get timestamp;
  @override
  int get responseTime;
  @override
  String get semanticHash;
  @override
  double? get confidence;
  @override
  String? get sessionId;
  @override
  List<String>? get tags;
  @override
  Map<String, dynamic>? get context;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isFavorite;
  @override
  bool get isFromCache;
  @override
  DateTime? get lastAccessed;
  @override
  int? get accessCount;

  /// Create a copy of QueryHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueryHistoryImplCopyWith<_$QueryHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
