// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dua_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DuaResponse _$DuaResponseFromJson(Map<String, dynamic> json) {
  return _DuaResponse.fromJson(json);
}

/// @nodoc
mixin _$DuaResponse {
  String get id => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  String get response => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get responseTime => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  List<DuaSource> get sources => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  int? get tokensUsed => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isFromCache => throw _privateConstructorUsedError;

  /// Serializes this DuaResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuaResponseCopyWith<DuaResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuaResponseCopyWith<$Res> {
  factory $DuaResponseCopyWith(
          DuaResponse value, $Res Function(DuaResponse) then) =
      _$DuaResponseCopyWithImpl<$Res, DuaResponse>;
  @useResult
  $Res call(
      {String id,
      String query,
      String response,
      DateTime timestamp,
      int responseTime,
      double confidence,
      List<DuaSource> sources,
      String? sessionId,
      int? tokensUsed,
      String? model,
      Map<String, dynamic>? metadata,
      bool isFavorite,
      bool isFromCache});
}

/// @nodoc
class _$DuaResponseCopyWithImpl<$Res, $Val extends DuaResponse>
    implements $DuaResponseCopyWith<$Res> {
  _$DuaResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? response = null,
    Object? timestamp = null,
    Object? responseTime = null,
    Object? confidence = null,
    Object? sources = null,
    Object? sessionId = freezed,
    Object? tokensUsed = freezed,
    Object? model = freezed,
    Object? metadata = freezed,
    Object? isFavorite = null,
    Object? isFromCache = null,
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
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      sources: null == sources
          ? _value.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<DuaSource>,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tokensUsed: freezed == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DuaResponseImplCopyWith<$Res>
    implements $DuaResponseCopyWith<$Res> {
  factory _$$DuaResponseImplCopyWith(
          _$DuaResponseImpl value, $Res Function(_$DuaResponseImpl) then) =
      __$$DuaResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String query,
      String response,
      DateTime timestamp,
      int responseTime,
      double confidence,
      List<DuaSource> sources,
      String? sessionId,
      int? tokensUsed,
      String? model,
      Map<String, dynamic>? metadata,
      bool isFavorite,
      bool isFromCache});
}

/// @nodoc
class __$$DuaResponseImplCopyWithImpl<$Res>
    extends _$DuaResponseCopyWithImpl<$Res, _$DuaResponseImpl>
    implements _$$DuaResponseImplCopyWith<$Res> {
  __$$DuaResponseImplCopyWithImpl(
      _$DuaResponseImpl _value, $Res Function(_$DuaResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DuaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? response = null,
    Object? timestamp = null,
    Object? responseTime = null,
    Object? confidence = null,
    Object? sources = null,
    Object? sessionId = freezed,
    Object? tokensUsed = freezed,
    Object? model = freezed,
    Object? metadata = freezed,
    Object? isFavorite = null,
    Object? isFromCache = null,
  }) {
    return _then(_$DuaResponseImpl(
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
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      sources: null == sources
          ? _value._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<DuaSource>,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tokensUsed: freezed == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DuaResponseImpl extends _DuaResponse with DiagnosticableTreeMixin {
  const _$DuaResponseImpl(
      {required this.id,
      required this.query,
      required this.response,
      required this.timestamp,
      required this.responseTime,
      required this.confidence,
      required final List<DuaSource> sources,
      this.sessionId,
      this.tokensUsed,
      this.model,
      final Map<String, dynamic>? metadata,
      this.isFavorite = false,
      this.isFromCache = false})
      : _sources = sources,
        _metadata = metadata,
        super._();

  factory _$DuaResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuaResponseImplFromJson(json);

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
  final double confidence;
  final List<DuaSource> _sources;
  @override
  List<DuaSource> get sources {
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sources);
  }

  @override
  final String? sessionId;
  @override
  final int? tokensUsed;
  @override
  final String? model;
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DuaResponse(id: $id, query: $query, response: $response, timestamp: $timestamp, responseTime: $responseTime, confidence: $confidence, sources: $sources, sessionId: $sessionId, tokensUsed: $tokensUsed, model: $model, metadata: $metadata, isFavorite: $isFavorite, isFromCache: $isFromCache)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DuaResponse'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('query', query))
      ..add(DiagnosticsProperty('response', response))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('responseTime', responseTime))
      ..add(DiagnosticsProperty('confidence', confidence))
      ..add(DiagnosticsProperty('sources', sources))
      ..add(DiagnosticsProperty('sessionId', sessionId))
      ..add(DiagnosticsProperty('tokensUsed', tokensUsed))
      ..add(DiagnosticsProperty('model', model))
      ..add(DiagnosticsProperty('metadata', metadata))
      ..add(DiagnosticsProperty('isFavorite', isFavorite))
      ..add(DiagnosticsProperty('isFromCache', isFromCache));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuaResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.responseTime, responseTime) ||
                other.responseTime == responseTime) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed) &&
            (identical(other.model, model) || other.model == model) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isFromCache, isFromCache) ||
                other.isFromCache == isFromCache));
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
      confidence,
      const DeepCollectionEquality().hash(_sources),
      sessionId,
      tokensUsed,
      model,
      const DeepCollectionEquality().hash(_metadata),
      isFavorite,
      isFromCache);

  /// Create a copy of DuaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuaResponseImplCopyWith<_$DuaResponseImpl> get copyWith =>
      __$$DuaResponseImplCopyWithImpl<_$DuaResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DuaResponseImplToJson(
      this,
    );
  }
}

abstract class _DuaResponse extends DuaResponse {
  const factory _DuaResponse(
      {required final String id,
      required final String query,
      required final String response,
      required final DateTime timestamp,
      required final int responseTime,
      required final double confidence,
      required final List<DuaSource> sources,
      final String? sessionId,
      final int? tokensUsed,
      final String? model,
      final Map<String, dynamic>? metadata,
      final bool isFavorite,
      final bool isFromCache}) = _$DuaResponseImpl;
  const _DuaResponse._() : super._();

  factory _DuaResponse.fromJson(Map<String, dynamic> json) =
      _$DuaResponseImpl.fromJson;

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
  double get confidence;
  @override
  List<DuaSource> get sources;
  @override
  String? get sessionId;
  @override
  int? get tokensUsed;
  @override
  String? get model;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isFavorite;
  @override
  bool get isFromCache;

  /// Create a copy of DuaResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuaResponseImplCopyWith<_$DuaResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DuaSource _$DuaSourceFromJson(Map<String, dynamic> json) {
  return _DuaSource.fromJson(json);
}

/// @nodoc
mixin _$DuaSource {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this DuaSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuaSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuaSourceCopyWith<DuaSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuaSourceCopyWith<$Res> {
  factory $DuaSourceCopyWith(DuaSource value, $Res Function(DuaSource) then) =
      _$DuaSourceCopyWithImpl<$Res, DuaSource>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      double relevanceScore,
      String? url,
      String? reference,
      String? category,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$DuaSourceCopyWithImpl<$Res, $Val extends DuaSource>
    implements $DuaSourceCopyWith<$Res> {
  _$DuaSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuaSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? relevanceScore = null,
    Object? url = freezed,
    Object? reference = freezed,
    Object? category = freezed,
    Object? metadata = freezed,
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      relevanceScore: null == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DuaSourceImplCopyWith<$Res>
    implements $DuaSourceCopyWith<$Res> {
  factory _$$DuaSourceImplCopyWith(
          _$DuaSourceImpl value, $Res Function(_$DuaSourceImpl) then) =
      __$$DuaSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      double relevanceScore,
      String? url,
      String? reference,
      String? category,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$DuaSourceImplCopyWithImpl<$Res>
    extends _$DuaSourceCopyWithImpl<$Res, _$DuaSourceImpl>
    implements _$$DuaSourceImplCopyWith<$Res> {
  __$$DuaSourceImplCopyWithImpl(
      _$DuaSourceImpl _value, $Res Function(_$DuaSourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of DuaSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? relevanceScore = null,
    Object? url = freezed,
    Object? reference = freezed,
    Object? category = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$DuaSourceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      relevanceScore: null == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DuaSourceImpl extends _DuaSource with DiagnosticableTreeMixin {
  const _$DuaSourceImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.relevanceScore,
      this.url,
      this.reference,
      this.category,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata,
        super._();

  factory _$DuaSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuaSourceImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final double relevanceScore;
  @override
  final String? url;
  @override
  final String? reference;
  @override
  final String? category;
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DuaSource(id: $id, title: $title, content: $content, relevanceScore: $relevanceScore, url: $url, reference: $reference, category: $category, metadata: $metadata)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DuaSource'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('content', content))
      ..add(DiagnosticsProperty('relevanceScore', relevanceScore))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('reference', reference))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('metadata', metadata));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuaSourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      relevanceScore,
      url,
      reference,
      category,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of DuaSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuaSourceImplCopyWith<_$DuaSourceImpl> get copyWith =>
      __$$DuaSourceImplCopyWithImpl<_$DuaSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DuaSourceImplToJson(
      this,
    );
  }
}

abstract class _DuaSource extends DuaSource {
  const factory _DuaSource(
      {required final String id,
      required final String title,
      required final String content,
      required final double relevanceScore,
      final String? url,
      final String? reference,
      final String? category,
      final Map<String, dynamic>? metadata}) = _$DuaSourceImpl;
  const _DuaSource._() : super._();

  factory _DuaSource.fromJson(Map<String, dynamic> json) =
      _$DuaSourceImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  double get relevanceScore;
  @override
  String? get url;
  @override
  String? get reference;
  @override
  String? get category;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of DuaSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuaSourceImplCopyWith<_$DuaSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
