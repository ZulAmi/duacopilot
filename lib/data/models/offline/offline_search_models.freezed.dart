// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DuaEmbedding _$DuaEmbeddingFromJson(Map<String, dynamic> json) {
  return _DuaEmbedding.fromJson(json);
}

/// @nodoc
mixin _$DuaEmbedding {
  String get id => throw _privateConstructorUsedError;
  String get duaId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  List<double> get vector => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DuaEmbedding to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuaEmbedding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuaEmbeddingCopyWith<DuaEmbedding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuaEmbeddingCopyWith<$Res> {
  factory $DuaEmbeddingCopyWith(
          DuaEmbedding value, $Res Function(DuaEmbedding) then) =
      _$DuaEmbeddingCopyWithImpl<$Res, DuaEmbedding>;
  @useResult
  $Res call(
      {String id,
      String duaId,
      String text,
      String language,
      List<double> vector,
      String category,
      List<String> keywords,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$DuaEmbeddingCopyWithImpl<$Res, $Val extends DuaEmbedding>
    implements $DuaEmbeddingCopyWith<$Res> {
  _$DuaEmbeddingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuaEmbedding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? text = null,
    Object? language = null,
    Object? vector = null,
    Object? category = null,
    Object? keywords = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      duaId: null == duaId
          ? _value.duaId
          : duaId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      vector: null == vector
          ? _value.vector
          : vector // ignore: cast_nullable_to_non_nullable
              as List<double>,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DuaEmbeddingImplCopyWith<$Res>
    implements $DuaEmbeddingCopyWith<$Res> {
  factory _$$DuaEmbeddingImplCopyWith(
          _$DuaEmbeddingImpl value, $Res Function(_$DuaEmbeddingImpl) then) =
      __$$DuaEmbeddingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String duaId,
      String text,
      String language,
      List<double> vector,
      String category,
      List<String> keywords,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$DuaEmbeddingImplCopyWithImpl<$Res>
    extends _$DuaEmbeddingCopyWithImpl<$Res, _$DuaEmbeddingImpl>
    implements _$$DuaEmbeddingImplCopyWith<$Res> {
  __$$DuaEmbeddingImplCopyWithImpl(
      _$DuaEmbeddingImpl _value, $Res Function(_$DuaEmbeddingImpl) _then)
      : super(_value, _then);

  /// Create a copy of DuaEmbedding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? text = null,
    Object? language = null,
    Object? vector = null,
    Object? category = null,
    Object? keywords = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DuaEmbeddingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      duaId: null == duaId
          ? _value.duaId
          : duaId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      vector: null == vector
          ? _value._vector
          : vector // ignore: cast_nullable_to_non_nullable
              as List<double>,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DuaEmbeddingImpl implements _DuaEmbedding {
  const _$DuaEmbeddingImpl(
      {required this.id,
      required this.duaId,
      required this.text,
      required this.language,
      required final List<double> vector,
      required this.category,
      final List<String> keywords = const [],
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      required this.updatedAt})
      : _vector = vector,
        _keywords = keywords,
        _metadata = metadata;

  factory _$DuaEmbeddingImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuaEmbeddingImplFromJson(json);

  @override
  final String id;
  @override
  final String duaId;
  @override
  final String text;
  @override
  final String language;
  final List<double> _vector;
  @override
  List<double> get vector {
    if (_vector is EqualUnmodifiableListView) return _vector;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vector);
  }

  @override
  final String category;
  final List<String> _keywords;
  @override
  @JsonKey()
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
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
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DuaEmbedding(id: $id, duaId: $duaId, text: $text, language: $language, vector: $vector, category: $category, keywords: $keywords, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuaEmbeddingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other._vector, _vector) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
      duaId,
      text,
      language,
      const DeepCollectionEquality().hash(_vector),
      category,
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  /// Create a copy of DuaEmbedding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuaEmbeddingImplCopyWith<_$DuaEmbeddingImpl> get copyWith =>
      __$$DuaEmbeddingImplCopyWithImpl<_$DuaEmbeddingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DuaEmbeddingImplToJson(
      this,
    );
  }
}

abstract class _DuaEmbedding implements DuaEmbedding {
  const factory _DuaEmbedding(
      {required final String id,
      required final String duaId,
      required final String text,
      required final String language,
      required final List<double> vector,
      required final String category,
      final List<String> keywords,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$DuaEmbeddingImpl;

  factory _DuaEmbedding.fromJson(Map<String, dynamic> json) =
      _$DuaEmbeddingImpl.fromJson;

  @override
  String get id;
  @override
  String get duaId;
  @override
  String get text;
  @override
  String get language;
  @override
  List<double> get vector;
  @override
  String get category;
  @override
  List<String> get keywords;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of DuaEmbedding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuaEmbeddingImplCopyWith<_$DuaEmbeddingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocalSearchQuery _$LocalSearchQueryFromJson(Map<String, dynamic> json) {
  return _LocalSearchQuery.fromJson(json);
}

/// @nodoc
mixin _$LocalSearchQuery {
  String get id => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  List<double> get embedding => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic> get context => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this LocalSearchQuery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalSearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalSearchQueryCopyWith<LocalSearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalSearchQueryCopyWith<$Res> {
  factory $LocalSearchQueryCopyWith(
          LocalSearchQuery value, $Res Function(LocalSearchQuery) then) =
      _$LocalSearchQueryCopyWithImpl<$Res, LocalSearchQuery>;
  @useResult
  $Res call(
      {String id,
      String query,
      String language,
      List<double> embedding,
      DateTime timestamp,
      Map<String, dynamic> context,
      String? location});
}

/// @nodoc
class _$LocalSearchQueryCopyWithImpl<$Res, $Val extends LocalSearchQuery>
    implements $LocalSearchQueryCopyWith<$Res> {
  _$LocalSearchQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalSearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? language = null,
    Object? embedding = null,
    Object? timestamp = null,
    Object? context = null,
    Object? location = freezed,
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
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      embedding: null == embedding
          ? _value.embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalSearchQueryImplCopyWith<$Res>
    implements $LocalSearchQueryCopyWith<$Res> {
  factory _$$LocalSearchQueryImplCopyWith(_$LocalSearchQueryImpl value,
          $Res Function(_$LocalSearchQueryImpl) then) =
      __$$LocalSearchQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String query,
      String language,
      List<double> embedding,
      DateTime timestamp,
      Map<String, dynamic> context,
      String? location});
}

/// @nodoc
class __$$LocalSearchQueryImplCopyWithImpl<$Res>
    extends _$LocalSearchQueryCopyWithImpl<$Res, _$LocalSearchQueryImpl>
    implements _$$LocalSearchQueryImplCopyWith<$Res> {
  __$$LocalSearchQueryImplCopyWithImpl(_$LocalSearchQueryImpl _value,
      $Res Function(_$LocalSearchQueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalSearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? language = null,
    Object? embedding = null,
    Object? timestamp = null,
    Object? context = null,
    Object? location = freezed,
  }) {
    return _then(_$LocalSearchQueryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      embedding: null == embedding
          ? _value._embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      context: null == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalSearchQueryImpl implements _LocalSearchQuery {
  const _$LocalSearchQueryImpl(
      {required this.id,
      required this.query,
      required this.language,
      required final List<double> embedding,
      required this.timestamp,
      final Map<String, dynamic> context = const {},
      this.location})
      : _embedding = embedding,
        _context = context;

  factory _$LocalSearchQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalSearchQueryImplFromJson(json);

  @override
  final String id;
  @override
  final String query;
  @override
  final String language;
  final List<double> _embedding;
  @override
  List<double> get embedding {
    if (_embedding is EqualUnmodifiableListView) return _embedding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_embedding);
  }

  @override
  final DateTime timestamp;
  final Map<String, dynamic> _context;
  @override
  @JsonKey()
  Map<String, dynamic> get context {
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_context);
  }

  @override
  final String? location;

  @override
  String toString() {
    return 'LocalSearchQuery(id: $id, query: $query, language: $language, embedding: $embedding, timestamp: $timestamp, context: $context, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalSearchQueryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality()
                .equals(other._embedding, _embedding) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      query,
      language,
      const DeepCollectionEquality().hash(_embedding),
      timestamp,
      const DeepCollectionEquality().hash(_context),
      location);

  /// Create a copy of LocalSearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalSearchQueryImplCopyWith<_$LocalSearchQueryImpl> get copyWith =>
      __$$LocalSearchQueryImplCopyWithImpl<_$LocalSearchQueryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalSearchQueryImplToJson(
      this,
    );
  }
}

abstract class _LocalSearchQuery implements LocalSearchQuery {
  const factory _LocalSearchQuery(
      {required final String id,
      required final String query,
      required final String language,
      required final List<double> embedding,
      required final DateTime timestamp,
      final Map<String, dynamic> context,
      final String? location}) = _$LocalSearchQueryImpl;

  factory _LocalSearchQuery.fromJson(Map<String, dynamic> json) =
      _$LocalSearchQueryImpl.fromJson;

  @override
  String get id;
  @override
  String get query;
  @override
  String get language;
  @override
  List<double> get embedding;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic> get context;
  @override
  String? get location;

  /// Create a copy of LocalSearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalSearchQueryImplCopyWith<_$LocalSearchQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OfflineSearchResult _$OfflineSearchResultFromJson(Map<String, dynamic> json) {
  return _OfflineSearchResult.fromJson(json);
}

/// @nodoc
mixin _$OfflineSearchResult {
  String get queryId => throw _privateConstructorUsedError;
  List<OfflineDuaMatch> get matches => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  SearchQuality get quality => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isFromCache => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this OfflineSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfflineSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfflineSearchResultCopyWith<OfflineSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfflineSearchResultCopyWith<$Res> {
  factory $OfflineSearchResultCopyWith(
          OfflineSearchResult value, $Res Function(OfflineSearchResult) then) =
      _$OfflineSearchResultCopyWithImpl<$Res, OfflineSearchResult>;
  @useResult
  $Res call(
      {String queryId,
      List<OfflineDuaMatch> matches,
      double confidence,
      SearchQuality quality,
      String reasoning,
      DateTime timestamp,
      bool isFromCache,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$OfflineSearchResultCopyWithImpl<$Res, $Val extends OfflineSearchResult>
    implements $OfflineSearchResultCopyWith<$Res> {
  _$OfflineSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfflineSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queryId = null,
    Object? matches = null,
    Object? confidence = null,
    Object? quality = null,
    Object? reasoning = null,
    Object? timestamp = null,
    Object? isFromCache = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      queryId: null == queryId
          ? _value.queryId
          : queryId // ignore: cast_nullable_to_non_nullable
              as String,
      matches: null == matches
          ? _value.matches
          : matches // ignore: cast_nullable_to_non_nullable
              as List<OfflineDuaMatch>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as SearchQuality,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromCache: null == isFromCache
          ? _value.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfflineSearchResultImplCopyWith<$Res>
    implements $OfflineSearchResultCopyWith<$Res> {
  factory _$$OfflineSearchResultImplCopyWith(_$OfflineSearchResultImpl value,
          $Res Function(_$OfflineSearchResultImpl) then) =
      __$$OfflineSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String queryId,
      List<OfflineDuaMatch> matches,
      double confidence,
      SearchQuality quality,
      String reasoning,
      DateTime timestamp,
      bool isFromCache,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$OfflineSearchResultImplCopyWithImpl<$Res>
    extends _$OfflineSearchResultCopyWithImpl<$Res, _$OfflineSearchResultImpl>
    implements _$$OfflineSearchResultImplCopyWith<$Res> {
  __$$OfflineSearchResultImplCopyWithImpl(_$OfflineSearchResultImpl _value,
      $Res Function(_$OfflineSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfflineSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queryId = null,
    Object? matches = null,
    Object? confidence = null,
    Object? quality = null,
    Object? reasoning = null,
    Object? timestamp = null,
    Object? isFromCache = null,
    Object? metadata = null,
  }) {
    return _then(_$OfflineSearchResultImpl(
      queryId: null == queryId
          ? _value.queryId
          : queryId // ignore: cast_nullable_to_non_nullable
              as String,
      matches: null == matches
          ? _value._matches
          : matches // ignore: cast_nullable_to_non_nullable
              as List<OfflineDuaMatch>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as SearchQuality,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromCache: null == isFromCache
          ? _value.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfflineSearchResultImpl implements _OfflineSearchResult {
  const _$OfflineSearchResultImpl(
      {required this.queryId,
      required final List<OfflineDuaMatch> matches,
      required this.confidence,
      required this.quality,
      required this.reasoning,
      required this.timestamp,
      this.isFromCache = false,
      final Map<String, dynamic> metadata = const {}})
      : _matches = matches,
        _metadata = metadata;

  factory _$OfflineSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfflineSearchResultImplFromJson(json);

  @override
  final String queryId;
  final List<OfflineDuaMatch> _matches;
  @override
  List<OfflineDuaMatch> get matches {
    if (_matches is EqualUnmodifiableListView) return _matches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matches);
  }

  @override
  final double confidence;
  @override
  final SearchQuality quality;
  @override
  final String reasoning;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isFromCache;
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
    return 'OfflineSearchResult(queryId: $queryId, matches: $matches, confidence: $confidence, quality: $quality, reasoning: $reasoning, timestamp: $timestamp, isFromCache: $isFromCache, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflineSearchResultImpl &&
            (identical(other.queryId, queryId) || other.queryId == queryId) &&
            const DeepCollectionEquality().equals(other._matches, _matches) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isFromCache, isFromCache) ||
                other.isFromCache == isFromCache) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      queryId,
      const DeepCollectionEquality().hash(_matches),
      confidence,
      quality,
      reasoning,
      timestamp,
      isFromCache,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of OfflineSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflineSearchResultImplCopyWith<_$OfflineSearchResultImpl> get copyWith =>
      __$$OfflineSearchResultImplCopyWithImpl<_$OfflineSearchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfflineSearchResultImplToJson(
      this,
    );
  }
}

abstract class _OfflineSearchResult implements OfflineSearchResult {
  const factory _OfflineSearchResult(
      {required final String queryId,
      required final List<OfflineDuaMatch> matches,
      required final double confidence,
      required final SearchQuality quality,
      required final String reasoning,
      required final DateTime timestamp,
      final bool isFromCache,
      final Map<String, dynamic> metadata}) = _$OfflineSearchResultImpl;

  factory _OfflineSearchResult.fromJson(Map<String, dynamic> json) =
      _$OfflineSearchResultImpl.fromJson;

  @override
  String get queryId;
  @override
  List<OfflineDuaMatch> get matches;
  @override
  double get confidence;
  @override
  SearchQuality get quality;
  @override
  String get reasoning;
  @override
  DateTime get timestamp;
  @override
  bool get isFromCache;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of OfflineSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflineSearchResultImplCopyWith<_$OfflineSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OfflineDuaMatch _$OfflineDuaMatchFromJson(Map<String, dynamic> json) {
  return _OfflineDuaMatch.fromJson(json);
}

/// @nodoc
mixin _$OfflineDuaMatch {
  String get duaId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  String get transliteration => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get similarityScore => throw _privateConstructorUsedError;
  List<String> get matchedKeywords => throw _privateConstructorUsedError;
  String get matchReason => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this OfflineDuaMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfflineDuaMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfflineDuaMatchCopyWith<OfflineDuaMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfflineDuaMatchCopyWith<$Res> {
  factory $OfflineDuaMatchCopyWith(
          OfflineDuaMatch value, $Res Function(OfflineDuaMatch) then) =
      _$OfflineDuaMatchCopyWithImpl<$Res, OfflineDuaMatch>;
  @useResult
  $Res call(
      {String duaId,
      String text,
      String translation,
      String transliteration,
      String category,
      double similarityScore,
      List<String> matchedKeywords,
      String matchReason,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$OfflineDuaMatchCopyWithImpl<$Res, $Val extends OfflineDuaMatch>
    implements $OfflineDuaMatchCopyWith<$Res> {
  _$OfflineDuaMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfflineDuaMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? text = null,
    Object? translation = null,
    Object? transliteration = null,
    Object? category = null,
    Object? similarityScore = null,
    Object? matchedKeywords = null,
    Object? matchReason = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      duaId: null == duaId
          ? _value.duaId
          : duaId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      translation: null == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String,
      transliteration: null == transliteration
          ? _value.transliteration
          : transliteration // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      similarityScore: null == similarityScore
          ? _value.similarityScore
          : similarityScore // ignore: cast_nullable_to_non_nullable
              as double,
      matchedKeywords: null == matchedKeywords
          ? _value.matchedKeywords
          : matchedKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchReason: null == matchReason
          ? _value.matchReason
          : matchReason // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfflineDuaMatchImplCopyWith<$Res>
    implements $OfflineDuaMatchCopyWith<$Res> {
  factory _$$OfflineDuaMatchImplCopyWith(_$OfflineDuaMatchImpl value,
          $Res Function(_$OfflineDuaMatchImpl) then) =
      __$$OfflineDuaMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String duaId,
      String text,
      String translation,
      String transliteration,
      String category,
      double similarityScore,
      List<String> matchedKeywords,
      String matchReason,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$OfflineDuaMatchImplCopyWithImpl<$Res>
    extends _$OfflineDuaMatchCopyWithImpl<$Res, _$OfflineDuaMatchImpl>
    implements _$$OfflineDuaMatchImplCopyWith<$Res> {
  __$$OfflineDuaMatchImplCopyWithImpl(
      _$OfflineDuaMatchImpl _value, $Res Function(_$OfflineDuaMatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfflineDuaMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duaId = null,
    Object? text = null,
    Object? translation = null,
    Object? transliteration = null,
    Object? category = null,
    Object? similarityScore = null,
    Object? matchedKeywords = null,
    Object? matchReason = null,
    Object? metadata = null,
  }) {
    return _then(_$OfflineDuaMatchImpl(
      duaId: null == duaId
          ? _value.duaId
          : duaId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      translation: null == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String,
      transliteration: null == transliteration
          ? _value.transliteration
          : transliteration // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      similarityScore: null == similarityScore
          ? _value.similarityScore
          : similarityScore // ignore: cast_nullable_to_non_nullable
              as double,
      matchedKeywords: null == matchedKeywords
          ? _value._matchedKeywords
          : matchedKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchReason: null == matchReason
          ? _value.matchReason
          : matchReason // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfflineDuaMatchImpl implements _OfflineDuaMatch {
  const _$OfflineDuaMatchImpl(
      {required this.duaId,
      required this.text,
      required this.translation,
      required this.transliteration,
      required this.category,
      required this.similarityScore,
      required final List<String> matchedKeywords,
      required this.matchReason,
      final Map<String, dynamic> metadata = const {}})
      : _matchedKeywords = matchedKeywords,
        _metadata = metadata;

  factory _$OfflineDuaMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfflineDuaMatchImplFromJson(json);

  @override
  final String duaId;
  @override
  final String text;
  @override
  final String translation;
  @override
  final String transliteration;
  @override
  final String category;
  @override
  final double similarityScore;
  final List<String> _matchedKeywords;
  @override
  List<String> get matchedKeywords {
    if (_matchedKeywords is EqualUnmodifiableListView) return _matchedKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchedKeywords);
  }

  @override
  final String matchReason;
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
    return 'OfflineDuaMatch(duaId: $duaId, text: $text, translation: $translation, transliteration: $transliteration, category: $category, similarityScore: $similarityScore, matchedKeywords: $matchedKeywords, matchReason: $matchReason, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflineDuaMatchImpl &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.transliteration, transliteration) ||
                other.transliteration == transliteration) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.similarityScore, similarityScore) ||
                other.similarityScore == similarityScore) &&
            const DeepCollectionEquality()
                .equals(other._matchedKeywords, _matchedKeywords) &&
            (identical(other.matchReason, matchReason) ||
                other.matchReason == matchReason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      duaId,
      text,
      translation,
      transliteration,
      category,
      similarityScore,
      const DeepCollectionEquality().hash(_matchedKeywords),
      matchReason,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of OfflineDuaMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflineDuaMatchImplCopyWith<_$OfflineDuaMatchImpl> get copyWith =>
      __$$OfflineDuaMatchImplCopyWithImpl<_$OfflineDuaMatchImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfflineDuaMatchImplToJson(
      this,
    );
  }
}

abstract class _OfflineDuaMatch implements OfflineDuaMatch {
  const factory _OfflineDuaMatch(
      {required final String duaId,
      required final String text,
      required final String translation,
      required final String transliteration,
      required final String category,
      required final double similarityScore,
      required final List<String> matchedKeywords,
      required final String matchReason,
      final Map<String, dynamic> metadata}) = _$OfflineDuaMatchImpl;

  factory _OfflineDuaMatch.fromJson(Map<String, dynamic> json) =
      _$OfflineDuaMatchImpl.fromJson;

  @override
  String get duaId;
  @override
  String get text;
  @override
  String get translation;
  @override
  String get transliteration;
  @override
  String get category;
  @override
  double get similarityScore;
  @override
  List<String> get matchedKeywords;
  @override
  String get matchReason;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of OfflineDuaMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflineDuaMatchImplCopyWith<_$OfflineDuaMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PendingQuery _$PendingQueryFromJson(Map<String, dynamic> json) {
  return _PendingQuery.fromJson(json);
}

/// @nodoc
mixin _$PendingQuery {
  String get id => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic> get context => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  PendingQueryStatus get status => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get fallbackResultId => throw _privateConstructorUsedError;

  /// Serializes this PendingQuery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PendingQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingQueryCopyWith<PendingQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingQueryCopyWith<$Res> {
  factory $PendingQueryCopyWith(
          PendingQuery value, $Res Function(PendingQuery) then) =
      _$PendingQueryCopyWithImpl<$Res, PendingQuery>;
  @useResult
  $Res call(
      {String id,
      String query,
      String language,
      DateTime timestamp,
      Map<String, dynamic> context,
      int retryCount,
      PendingQueryStatus status,
      String? location,
      String? fallbackResultId});
}

/// @nodoc
class _$PendingQueryCopyWithImpl<$Res, $Val extends PendingQuery>
    implements $PendingQueryCopyWith<$Res> {
  _$PendingQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? language = null,
    Object? timestamp = null,
    Object? context = null,
    Object? retryCount = null,
    Object? status = null,
    Object? location = freezed,
    Object? fallbackResultId = freezed,
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
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PendingQueryStatus,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      fallbackResultId: freezed == fallbackResultId
          ? _value.fallbackResultId
          : fallbackResultId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PendingQueryImplCopyWith<$Res>
    implements $PendingQueryCopyWith<$Res> {
  factory _$$PendingQueryImplCopyWith(
          _$PendingQueryImpl value, $Res Function(_$PendingQueryImpl) then) =
      __$$PendingQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String query,
      String language,
      DateTime timestamp,
      Map<String, dynamic> context,
      int retryCount,
      PendingQueryStatus status,
      String? location,
      String? fallbackResultId});
}

/// @nodoc
class __$$PendingQueryImplCopyWithImpl<$Res>
    extends _$PendingQueryCopyWithImpl<$Res, _$PendingQueryImpl>
    implements _$$PendingQueryImplCopyWith<$Res> {
  __$$PendingQueryImplCopyWithImpl(
      _$PendingQueryImpl _value, $Res Function(_$PendingQueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PendingQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? language = null,
    Object? timestamp = null,
    Object? context = null,
    Object? retryCount = null,
    Object? status = null,
    Object? location = freezed,
    Object? fallbackResultId = freezed,
  }) {
    return _then(_$PendingQueryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      context: null == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PendingQueryStatus,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      fallbackResultId: freezed == fallbackResultId
          ? _value.fallbackResultId
          : fallbackResultId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingQueryImpl implements _PendingQuery {
  const _$PendingQueryImpl(
      {required this.id,
      required this.query,
      required this.language,
      required this.timestamp,
      required final Map<String, dynamic> context,
      this.retryCount = 0,
      this.status = PendingQueryStatus.pending,
      this.location,
      this.fallbackResultId})
      : _context = context;

  factory _$PendingQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingQueryImplFromJson(json);

  @override
  final String id;
  @override
  final String query;
  @override
  final String language;
  @override
  final DateTime timestamp;
  final Map<String, dynamic> _context;
  @override
  Map<String, dynamic> get context {
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_context);
  }

  @override
  @JsonKey()
  final int retryCount;
  @override
  @JsonKey()
  final PendingQueryStatus status;
  @override
  final String? location;
  @override
  final String? fallbackResultId;

  @override
  String toString() {
    return 'PendingQuery(id: $id, query: $query, language: $language, timestamp: $timestamp, context: $context, retryCount: $retryCount, status: $status, location: $location, fallbackResultId: $fallbackResultId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingQueryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._context, _context) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.fallbackResultId, fallbackResultId) ||
                other.fallbackResultId == fallbackResultId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      query,
      language,
      timestamp,
      const DeepCollectionEquality().hash(_context),
      retryCount,
      status,
      location,
      fallbackResultId);

  /// Create a copy of PendingQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingQueryImplCopyWith<_$PendingQueryImpl> get copyWith =>
      __$$PendingQueryImplCopyWithImpl<_$PendingQueryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingQueryImplToJson(
      this,
    );
  }
}

abstract class _PendingQuery implements PendingQuery {
  const factory _PendingQuery(
      {required final String id,
      required final String query,
      required final String language,
      required final DateTime timestamp,
      required final Map<String, dynamic> context,
      final int retryCount,
      final PendingQueryStatus status,
      final String? location,
      final String? fallbackResultId}) = _$PendingQueryImpl;

  factory _PendingQuery.fromJson(Map<String, dynamic> json) =
      _$PendingQueryImpl.fromJson;

  @override
  String get id;
  @override
  String get query;
  @override
  String get language;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic> get context;
  @override
  int get retryCount;
  @override
  PendingQueryStatus get status;
  @override
  String? get location;
  @override
  String? get fallbackResultId;

  /// Create a copy of PendingQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingQueryImplCopyWith<_$PendingQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FallbackTemplate _$FallbackTemplateFromJson(Map<String, dynamic> json) {
  return _FallbackTemplate.fromJson(json);
}

/// @nodoc
mixin _$FallbackTemplate {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get template => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  double get priority => throw _privateConstructorUsedError;
  Map<String, dynamic> get variations => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FallbackTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FallbackTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FallbackTemplateCopyWith<FallbackTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FallbackTemplateCopyWith<$Res> {
  factory $FallbackTemplateCopyWith(
          FallbackTemplate value, $Res Function(FallbackTemplate) then) =
      _$FallbackTemplateCopyWithImpl<$Res, FallbackTemplate>;
  @useResult
  $Res call(
      {String id,
      String category,
      String language,
      String template,
      List<String> keywords,
      double priority,
      Map<String, dynamic> variations,
      DateTime createdAt});
}

/// @nodoc
class _$FallbackTemplateCopyWithImpl<$Res, $Val extends FallbackTemplate>
    implements $FallbackTemplateCopyWith<$Res> {
  _$FallbackTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FallbackTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? language = null,
    Object? template = null,
    Object? keywords = null,
    Object? priority = null,
    Object? variations = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as double,
      variations: null == variations
          ? _value.variations
          : variations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FallbackTemplateImplCopyWith<$Res>
    implements $FallbackTemplateCopyWith<$Res> {
  factory _$$FallbackTemplateImplCopyWith(_$FallbackTemplateImpl value,
          $Res Function(_$FallbackTemplateImpl) then) =
      __$$FallbackTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String category,
      String language,
      String template,
      List<String> keywords,
      double priority,
      Map<String, dynamic> variations,
      DateTime createdAt});
}

/// @nodoc
class __$$FallbackTemplateImplCopyWithImpl<$Res>
    extends _$FallbackTemplateCopyWithImpl<$Res, _$FallbackTemplateImpl>
    implements _$$FallbackTemplateImplCopyWith<$Res> {
  __$$FallbackTemplateImplCopyWithImpl(_$FallbackTemplateImpl _value,
      $Res Function(_$FallbackTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FallbackTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? language = null,
    Object? template = null,
    Object? keywords = null,
    Object? priority = null,
    Object? variations = null,
    Object? createdAt = null,
  }) {
    return _then(_$FallbackTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as double,
      variations: null == variations
          ? _value._variations
          : variations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FallbackTemplateImpl implements _FallbackTemplate {
  const _$FallbackTemplateImpl(
      {required this.id,
      required this.category,
      required this.language,
      required this.template,
      required final List<String> keywords,
      required this.priority,
      final Map<String, dynamic> variations = const {},
      required this.createdAt})
      : _keywords = keywords,
        _variations = variations;

  factory _$FallbackTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FallbackTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String category;
  @override
  final String language;
  @override
  final String template;
  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  final double priority;
  final Map<String, dynamic> _variations;
  @override
  @JsonKey()
  Map<String, dynamic> get variations {
    if (_variations is EqualUnmodifiableMapView) return _variations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_variations);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FallbackTemplate(id: $id, category: $category, language: $language, template: $template, keywords: $keywords, priority: $priority, variations: $variations, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FallbackTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.template, template) ||
                other.template == template) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other._variations, _variations) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      category,
      language,
      template,
      const DeepCollectionEquality().hash(_keywords),
      priority,
      const DeepCollectionEquality().hash(_variations),
      createdAt);

  /// Create a copy of FallbackTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FallbackTemplateImplCopyWith<_$FallbackTemplateImpl> get copyWith =>
      __$$FallbackTemplateImplCopyWithImpl<_$FallbackTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FallbackTemplateImplToJson(
      this,
    );
  }
}

abstract class _FallbackTemplate implements FallbackTemplate {
  const factory _FallbackTemplate(
      {required final String id,
      required final String category,
      required final String language,
      required final String template,
      required final List<String> keywords,
      required final double priority,
      final Map<String, dynamic> variations,
      required final DateTime createdAt}) = _$FallbackTemplateImpl;

  factory _FallbackTemplate.fromJson(Map<String, dynamic> json) =
      _$FallbackTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get category;
  @override
  String get language;
  @override
  String get template;
  @override
  List<String> get keywords;
  @override
  double get priority;
  @override
  Map<String, dynamic> get variations;
  @override
  DateTime get createdAt;

  /// Create a copy of FallbackTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FallbackTemplateImplCopyWith<_$FallbackTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OfflineSyncStatus _$OfflineSyncStatusFromJson(Map<String, dynamic> json) {
  return _OfflineSyncStatus.fromJson(json);
}

/// @nodoc
mixin _$OfflineSyncStatus {
  DateTime get lastSync => throw _privateConstructorUsedError;
  int get totalEmbeddings => throw _privateConstructorUsedError;
  int get pendingQueries => throw _privateConstructorUsedError;
  List<String> get availableLanguages => throw _privateConstructorUsedError;
  List<String> get availableCategories => throw _privateConstructorUsedError;
  bool get isSyncing => throw _privateConstructorUsedError;
  DateTime? get nextScheduledSync => throw _privateConstructorUsedError;
  String? get lastError => throw _privateConstructorUsedError;

  /// Serializes this OfflineSyncStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfflineSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfflineSyncStatusCopyWith<OfflineSyncStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfflineSyncStatusCopyWith<$Res> {
  factory $OfflineSyncStatusCopyWith(
          OfflineSyncStatus value, $Res Function(OfflineSyncStatus) then) =
      _$OfflineSyncStatusCopyWithImpl<$Res, OfflineSyncStatus>;
  @useResult
  $Res call(
      {DateTime lastSync,
      int totalEmbeddings,
      int pendingQueries,
      List<String> availableLanguages,
      List<String> availableCategories,
      bool isSyncing,
      DateTime? nextScheduledSync,
      String? lastError});
}

/// @nodoc
class _$OfflineSyncStatusCopyWithImpl<$Res, $Val extends OfflineSyncStatus>
    implements $OfflineSyncStatusCopyWith<$Res> {
  _$OfflineSyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfflineSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastSync = null,
    Object? totalEmbeddings = null,
    Object? pendingQueries = null,
    Object? availableLanguages = null,
    Object? availableCategories = null,
    Object? isSyncing = null,
    Object? nextScheduledSync = freezed,
    Object? lastError = freezed,
  }) {
    return _then(_value.copyWith(
      lastSync: null == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalEmbeddings: null == totalEmbeddings
          ? _value.totalEmbeddings
          : totalEmbeddings // ignore: cast_nullable_to_non_nullable
              as int,
      pendingQueries: null == pendingQueries
          ? _value.pendingQueries
          : pendingQueries // ignore: cast_nullable_to_non_nullable
              as int,
      availableLanguages: null == availableLanguages
          ? _value.availableLanguages
          : availableLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableCategories: null == availableCategories
          ? _value.availableCategories
          : availableCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      nextScheduledSync: freezed == nextScheduledSync
          ? _value.nextScheduledSync
          : nextScheduledSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfflineSyncStatusImplCopyWith<$Res>
    implements $OfflineSyncStatusCopyWith<$Res> {
  factory _$$OfflineSyncStatusImplCopyWith(_$OfflineSyncStatusImpl value,
          $Res Function(_$OfflineSyncStatusImpl) then) =
      __$$OfflineSyncStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime lastSync,
      int totalEmbeddings,
      int pendingQueries,
      List<String> availableLanguages,
      List<String> availableCategories,
      bool isSyncing,
      DateTime? nextScheduledSync,
      String? lastError});
}

/// @nodoc
class __$$OfflineSyncStatusImplCopyWithImpl<$Res>
    extends _$OfflineSyncStatusCopyWithImpl<$Res, _$OfflineSyncStatusImpl>
    implements _$$OfflineSyncStatusImplCopyWith<$Res> {
  __$$OfflineSyncStatusImplCopyWithImpl(_$OfflineSyncStatusImpl _value,
      $Res Function(_$OfflineSyncStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfflineSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastSync = null,
    Object? totalEmbeddings = null,
    Object? pendingQueries = null,
    Object? availableLanguages = null,
    Object? availableCategories = null,
    Object? isSyncing = null,
    Object? nextScheduledSync = freezed,
    Object? lastError = freezed,
  }) {
    return _then(_$OfflineSyncStatusImpl(
      lastSync: null == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalEmbeddings: null == totalEmbeddings
          ? _value.totalEmbeddings
          : totalEmbeddings // ignore: cast_nullable_to_non_nullable
              as int,
      pendingQueries: null == pendingQueries
          ? _value.pendingQueries
          : pendingQueries // ignore: cast_nullable_to_non_nullable
              as int,
      availableLanguages: null == availableLanguages
          ? _value._availableLanguages
          : availableLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableCategories: null == availableCategories
          ? _value._availableCategories
          : availableCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      nextScheduledSync: freezed == nextScheduledSync
          ? _value.nextScheduledSync
          : nextScheduledSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfflineSyncStatusImpl implements _OfflineSyncStatus {
  const _$OfflineSyncStatusImpl(
      {required this.lastSync,
      required this.totalEmbeddings,
      required this.pendingQueries,
      required final List<String> availableLanguages,
      required final List<String> availableCategories,
      this.isSyncing = false,
      this.nextScheduledSync,
      this.lastError})
      : _availableLanguages = availableLanguages,
        _availableCategories = availableCategories;

  factory _$OfflineSyncStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfflineSyncStatusImplFromJson(json);

  @override
  final DateTime lastSync;
  @override
  final int totalEmbeddings;
  @override
  final int pendingQueries;
  final List<String> _availableLanguages;
  @override
  List<String> get availableLanguages {
    if (_availableLanguages is EqualUnmodifiableListView)
      return _availableLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableLanguages);
  }

  final List<String> _availableCategories;
  @override
  List<String> get availableCategories {
    if (_availableCategories is EqualUnmodifiableListView)
      return _availableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCategories);
  }

  @override
  @JsonKey()
  final bool isSyncing;
  @override
  final DateTime? nextScheduledSync;
  @override
  final String? lastError;

  @override
  String toString() {
    return 'OfflineSyncStatus(lastSync: $lastSync, totalEmbeddings: $totalEmbeddings, pendingQueries: $pendingQueries, availableLanguages: $availableLanguages, availableCategories: $availableCategories, isSyncing: $isSyncing, nextScheduledSync: $nextScheduledSync, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflineSyncStatusImpl &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync) &&
            (identical(other.totalEmbeddings, totalEmbeddings) ||
                other.totalEmbeddings == totalEmbeddings) &&
            (identical(other.pendingQueries, pendingQueries) ||
                other.pendingQueries == pendingQueries) &&
            const DeepCollectionEquality()
                .equals(other._availableLanguages, _availableLanguages) &&
            const DeepCollectionEquality()
                .equals(other._availableCategories, _availableCategories) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.nextScheduledSync, nextScheduledSync) ||
                other.nextScheduledSync == nextScheduledSync) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastSync,
      totalEmbeddings,
      pendingQueries,
      const DeepCollectionEquality().hash(_availableLanguages),
      const DeepCollectionEquality().hash(_availableCategories),
      isSyncing,
      nextScheduledSync,
      lastError);

  /// Create a copy of OfflineSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflineSyncStatusImplCopyWith<_$OfflineSyncStatusImpl> get copyWith =>
      __$$OfflineSyncStatusImplCopyWithImpl<_$OfflineSyncStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfflineSyncStatusImplToJson(
      this,
    );
  }
}

abstract class _OfflineSyncStatus implements OfflineSyncStatus {
  const factory _OfflineSyncStatus(
      {required final DateTime lastSync,
      required final int totalEmbeddings,
      required final int pendingQueries,
      required final List<String> availableLanguages,
      required final List<String> availableCategories,
      final bool isSyncing,
      final DateTime? nextScheduledSync,
      final String? lastError}) = _$OfflineSyncStatusImpl;

  factory _OfflineSyncStatus.fromJson(Map<String, dynamic> json) =
      _$OfflineSyncStatusImpl.fromJson;

  @override
  DateTime get lastSync;
  @override
  int get totalEmbeddings;
  @override
  int get pendingQueries;
  @override
  List<String> get availableLanguages;
  @override
  List<String> get availableCategories;
  @override
  bool get isSyncing;
  @override
  DateTime? get nextScheduledSync;
  @override
  String? get lastError;

  /// Create a copy of OfflineSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflineSyncStatusImplCopyWith<_$OfflineSyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
