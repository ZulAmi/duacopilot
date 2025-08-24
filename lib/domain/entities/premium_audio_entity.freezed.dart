// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'premium_audio_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QariInfo _$QariInfoFromJson(Map<String, dynamic> json) {
  return _QariInfo.fromJson(json);
}

/// @nodoc
mixin _$QariInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get arabicName => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  List<String> get specializations => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'bio_en')
  String get bioEnglish => throw _privateConstructorUsedError;
  @JsonKey(name: 'bio_ar')
  String get bioArabic => throw _privateConstructorUsedError;
  List<String> get awards => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalRecitations => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QariInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QariInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QariInfoCopyWith<QariInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QariInfoCopyWith<$Res> {
  factory $QariInfoCopyWith(QariInfo value, $Res Function(QariInfo) then) =
      _$QariInfoCopyWithImpl<$Res, QariInfo>;
  @useResult
  $Res call({
    String id,
    String name,
    String arabicName,
    String country,
    String description,
    String profileImageUrl,
    List<String> specializations,
    bool isVerified,
    @JsonKey(name: 'bio_en') String bioEnglish,
    @JsonKey(name: 'bio_ar') String bioArabic,
    List<String> awards,
    double rating,
    int totalRecitations,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$QariInfoCopyWithImpl<$Res, $Val extends QariInfo>
    implements $QariInfoCopyWith<$Res> {
  _$QariInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QariInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? arabicName = null,
    Object? country = null,
    Object? description = null,
    Object? profileImageUrl = null,
    Object? specializations = null,
    Object? isVerified = null,
    Object? bioEnglish = null,
    Object? bioArabic = null,
    Object? awards = null,
    Object? rating = null,
    Object? totalRecitations = null,
    Object? birthDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            arabicName:
                null == arabicName
                    ? _value.arabicName
                    : arabicName // ignore: cast_nullable_to_non_nullable
                        as String,
            country:
                null == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            profileImageUrl:
                null == profileImageUrl
                    ? _value.profileImageUrl
                    : profileImageUrl // ignore: cast_nullable_to_non_nullable
                        as String,
            specializations:
                null == specializations
                    ? _value.specializations
                    : specializations // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            isVerified:
                null == isVerified
                    ? _value.isVerified
                    : isVerified // ignore: cast_nullable_to_non_nullable
                        as bool,
            bioEnglish:
                null == bioEnglish
                    ? _value.bioEnglish
                    : bioEnglish // ignore: cast_nullable_to_non_nullable
                        as String,
            bioArabic:
                null == bioArabic
                    ? _value.bioArabic
                    : bioArabic // ignore: cast_nullable_to_non_nullable
                        as String,
            awards:
                null == awards
                    ? _value.awards
                    : awards // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            rating:
                null == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as double,
            totalRecitations:
                null == totalRecitations
                    ? _value.totalRecitations
                    : totalRecitations // ignore: cast_nullable_to_non_nullable
                        as int,
            birthDate:
                freezed == birthDate
                    ? _value.birthDate
                    : birthDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QariInfoImplCopyWith<$Res>
    implements $QariInfoCopyWith<$Res> {
  factory _$$QariInfoImplCopyWith(
    _$QariInfoImpl value,
    $Res Function(_$QariInfoImpl) then,
  ) = __$$QariInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String arabicName,
    String country,
    String description,
    String profileImageUrl,
    List<String> specializations,
    bool isVerified,
    @JsonKey(name: 'bio_en') String bioEnglish,
    @JsonKey(name: 'bio_ar') String bioArabic,
    List<String> awards,
    double rating,
    int totalRecitations,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$QariInfoImplCopyWithImpl<$Res>
    extends _$QariInfoCopyWithImpl<$Res, _$QariInfoImpl>
    implements _$$QariInfoImplCopyWith<$Res> {
  __$$QariInfoImplCopyWithImpl(
    _$QariInfoImpl _value,
    $Res Function(_$QariInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QariInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? arabicName = null,
    Object? country = null,
    Object? description = null,
    Object? profileImageUrl = null,
    Object? specializations = null,
    Object? isVerified = null,
    Object? bioEnglish = null,
    Object? bioArabic = null,
    Object? awards = null,
    Object? rating = null,
    Object? totalRecitations = null,
    Object? birthDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$QariInfoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        arabicName:
            null == arabicName
                ? _value.arabicName
                : arabicName // ignore: cast_nullable_to_non_nullable
                    as String,
        country:
            null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        profileImageUrl:
            null == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                    as String,
        specializations:
            null == specializations
                ? _value._specializations
                : specializations // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        isVerified:
            null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                    as bool,
        bioEnglish:
            null == bioEnglish
                ? _value.bioEnglish
                : bioEnglish // ignore: cast_nullable_to_non_nullable
                    as String,
        bioArabic:
            null == bioArabic
                ? _value.bioArabic
                : bioArabic // ignore: cast_nullable_to_non_nullable
                    as String,
        awards:
            null == awards
                ? _value._awards
                : awards // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        rating:
            null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as double,
        totalRecitations:
            null == totalRecitations
                ? _value.totalRecitations
                : totalRecitations // ignore: cast_nullable_to_non_nullable
                    as int,
        birthDate:
            freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QariInfoImpl implements _QariInfo {
  const _$QariInfoImpl({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.country,
    required this.description,
    required this.profileImageUrl,
    required final List<String> specializations,
    required this.isVerified,
    @JsonKey(name: 'bio_en') required this.bioEnglish,
    @JsonKey(name: 'bio_ar') required this.bioArabic,
    final List<String> awards = const [],
    this.rating = 0.0,
    this.totalRecitations = 0,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  }) : _specializations = specializations,
       _awards = awards;

  factory _$QariInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QariInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String arabicName;
  @override
  final String country;
  @override
  final String description;
  @override
  final String profileImageUrl;
  final List<String> _specializations;
  @override
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final bool isVerified;
  @override
  @JsonKey(name: 'bio_en')
  final String bioEnglish;
  @override
  @JsonKey(name: 'bio_ar')
  final String bioArabic;
  final List<String> _awards;
  @override
  @JsonKey()
  List<String> get awards {
    if (_awards is EqualUnmodifiableListView) return _awards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awards);
  }

  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int totalRecitations;
  @override
  final DateTime? birthDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'QariInfo(id: $id, name: $name, arabicName: $arabicName, country: $country, description: $description, profileImageUrl: $profileImageUrl, specializations: $specializations, isVerified: $isVerified, bioEnglish: $bioEnglish, bioArabic: $bioArabic, awards: $awards, rating: $rating, totalRecitations: $totalRecitations, birthDate: $birthDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QariInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.arabicName, arabicName) ||
                other.arabicName == arabicName) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            const DeepCollectionEquality().equals(
              other._specializations,
              _specializations,
            ) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.bioEnglish, bioEnglish) ||
                other.bioEnglish == bioEnglish) &&
            (identical(other.bioArabic, bioArabic) ||
                other.bioArabic == bioArabic) &&
            const DeepCollectionEquality().equals(other._awards, _awards) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalRecitations, totalRecitations) ||
                other.totalRecitations == totalRecitations) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
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
    name,
    arabicName,
    country,
    description,
    profileImageUrl,
    const DeepCollectionEquality().hash(_specializations),
    isVerified,
    bioEnglish,
    bioArabic,
    const DeepCollectionEquality().hash(_awards),
    rating,
    totalRecitations,
    birthDate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of QariInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QariInfoImplCopyWith<_$QariInfoImpl> get copyWith =>
      __$$QariInfoImplCopyWithImpl<_$QariInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QariInfoImplToJson(this);
  }
}

abstract class _QariInfo implements QariInfo {
  const factory _QariInfo({
    required final String id,
    required final String name,
    required final String arabicName,
    required final String country,
    required final String description,
    required final String profileImageUrl,
    required final List<String> specializations,
    required final bool isVerified,
    @JsonKey(name: 'bio_en') required final String bioEnglish,
    @JsonKey(name: 'bio_ar') required final String bioArabic,
    final List<String> awards,
    final double rating,
    final int totalRecitations,
    final DateTime? birthDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$QariInfoImpl;

  factory _QariInfo.fromJson(Map<String, dynamic> json) =
      _$QariInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get arabicName;
  @override
  String get country;
  @override
  String get description;
  @override
  String get profileImageUrl;
  @override
  List<String> get specializations;
  @override
  bool get isVerified;
  @override
  @JsonKey(name: 'bio_en')
  String get bioEnglish;
  @override
  @JsonKey(name: 'bio_ar')
  String get bioArabic;
  @override
  List<String> get awards;
  @override
  double get rating;
  @override
  int get totalRecitations;
  @override
  DateTime? get birthDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of QariInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QariInfoImplCopyWith<_$QariInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PremiumRecitation _$PremiumRecitationFromJson(Map<String, dynamic> json) {
  return _PremiumRecitation.fromJson(json);
}

/// @nodoc
mixin _$PremiumRecitation {
  String get id => throw _privateConstructorUsedError;
  String get duaId => throw _privateConstructorUsedError;
  String get qariId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get arabicTitle => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  AudioQuality get quality => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError; // in seconds
  int get sizeInBytes => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  bool get isDownloaded => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError; // Security & DRM
  @JsonKey(includeToJson: false)
  String? get encryptedUrl => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  String? get accessToken => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  DateTime? get tokenExpiry => throw _privateConstructorUsedError; // Offline capabilities
  String? get localPath => throw _privateConstructorUsedError;
  String? get downloadId => throw _privateConstructorUsedError;
  DownloadStatus get downloadStatus => throw _privateConstructorUsedError;
  double get downloadProgress => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastPlayed => throw _privateConstructorUsedError;

  /// Serializes this PremiumRecitation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PremiumRecitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumRecitationCopyWith<PremiumRecitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumRecitationCopyWith<$Res> {
  factory $PremiumRecitationCopyWith(
    PremiumRecitation value,
    $Res Function(PremiumRecitation) then,
  ) = _$PremiumRecitationCopyWithImpl<$Res, PremiumRecitation>;
  @useResult
  $Res call({
    String id,
    String duaId,
    String qariId,
    String title,
    String arabicTitle,
    String url,
    AudioQuality quality,
    int duration,
    int sizeInBytes,
    String format,
    bool isDownloaded,
    bool isFavorite,
    int playCount,
    List<String> tags,
    @JsonKey(includeToJson: false) String? encryptedUrl,
    @JsonKey(includeToJson: false) String? accessToken,
    @JsonKey(includeToJson: false) DateTime? tokenExpiry,
    String? localPath,
    String? downloadId,
    DownloadStatus downloadStatus,
    double downloadProgress,
    DateTime? createdAt,
    DateTime? lastPlayed,
  });
}

/// @nodoc
class _$PremiumRecitationCopyWithImpl<$Res, $Val extends PremiumRecitation>
    implements $PremiumRecitationCopyWith<$Res> {
  _$PremiumRecitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumRecitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? qariId = null,
    Object? title = null,
    Object? arabicTitle = null,
    Object? url = null,
    Object? quality = null,
    Object? duration = null,
    Object? sizeInBytes = null,
    Object? format = null,
    Object? isDownloaded = null,
    Object? isFavorite = null,
    Object? playCount = null,
    Object? tags = null,
    Object? encryptedUrl = freezed,
    Object? accessToken = freezed,
    Object? tokenExpiry = freezed,
    Object? localPath = freezed,
    Object? downloadId = freezed,
    Object? downloadStatus = null,
    Object? downloadProgress = null,
    Object? createdAt = freezed,
    Object? lastPlayed = freezed,
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
            qariId:
                null == qariId
                    ? _value.qariId
                    : qariId // ignore: cast_nullable_to_non_nullable
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
            url:
                null == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String,
            quality:
                null == quality
                    ? _value.quality
                    : quality // ignore: cast_nullable_to_non_nullable
                        as AudioQuality,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as int,
            sizeInBytes:
                null == sizeInBytes
                    ? _value.sizeInBytes
                    : sizeInBytes // ignore: cast_nullable_to_non_nullable
                        as int,
            format:
                null == format
                    ? _value.format
                    : format // ignore: cast_nullable_to_non_nullable
                        as String,
            isDownloaded:
                null == isDownloaded
                    ? _value.isDownloaded
                    : isDownloaded // ignore: cast_nullable_to_non_nullable
                        as bool,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
            playCount:
                null == playCount
                    ? _value.playCount
                    : playCount // ignore: cast_nullable_to_non_nullable
                        as int,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            encryptedUrl:
                freezed == encryptedUrl
                    ? _value.encryptedUrl
                    : encryptedUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            accessToken:
                freezed == accessToken
                    ? _value.accessToken
                    : accessToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            tokenExpiry:
                freezed == tokenExpiry
                    ? _value.tokenExpiry
                    : tokenExpiry // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            localPath:
                freezed == localPath
                    ? _value.localPath
                    : localPath // ignore: cast_nullable_to_non_nullable
                        as String?,
            downloadId:
                freezed == downloadId
                    ? _value.downloadId
                    : downloadId // ignore: cast_nullable_to_non_nullable
                        as String?,
            downloadStatus:
                null == downloadStatus
                    ? _value.downloadStatus
                    : downloadStatus // ignore: cast_nullable_to_non_nullable
                        as DownloadStatus,
            downloadProgress:
                null == downloadProgress
                    ? _value.downloadProgress
                    : downloadProgress // ignore: cast_nullable_to_non_nullable
                        as double,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastPlayed:
                freezed == lastPlayed
                    ? _value.lastPlayed
                    : lastPlayed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PremiumRecitationImplCopyWith<$Res>
    implements $PremiumRecitationCopyWith<$Res> {
  factory _$$PremiumRecitationImplCopyWith(
    _$PremiumRecitationImpl value,
    $Res Function(_$PremiumRecitationImpl) then,
  ) = __$$PremiumRecitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String duaId,
    String qariId,
    String title,
    String arabicTitle,
    String url,
    AudioQuality quality,
    int duration,
    int sizeInBytes,
    String format,
    bool isDownloaded,
    bool isFavorite,
    int playCount,
    List<String> tags,
    @JsonKey(includeToJson: false) String? encryptedUrl,
    @JsonKey(includeToJson: false) String? accessToken,
    @JsonKey(includeToJson: false) DateTime? tokenExpiry,
    String? localPath,
    String? downloadId,
    DownloadStatus downloadStatus,
    double downloadProgress,
    DateTime? createdAt,
    DateTime? lastPlayed,
  });
}

/// @nodoc
class __$$PremiumRecitationImplCopyWithImpl<$Res>
    extends _$PremiumRecitationCopyWithImpl<$Res, _$PremiumRecitationImpl>
    implements _$$PremiumRecitationImplCopyWith<$Res> {
  __$$PremiumRecitationImplCopyWithImpl(
    _$PremiumRecitationImpl _value,
    $Res Function(_$PremiumRecitationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PremiumRecitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? duaId = null,
    Object? qariId = null,
    Object? title = null,
    Object? arabicTitle = null,
    Object? url = null,
    Object? quality = null,
    Object? duration = null,
    Object? sizeInBytes = null,
    Object? format = null,
    Object? isDownloaded = null,
    Object? isFavorite = null,
    Object? playCount = null,
    Object? tags = null,
    Object? encryptedUrl = freezed,
    Object? accessToken = freezed,
    Object? tokenExpiry = freezed,
    Object? localPath = freezed,
    Object? downloadId = freezed,
    Object? downloadStatus = null,
    Object? downloadProgress = null,
    Object? createdAt = freezed,
    Object? lastPlayed = freezed,
  }) {
    return _then(
      _$PremiumRecitationImpl(
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
        qariId:
            null == qariId
                ? _value.qariId
                : qariId // ignore: cast_nullable_to_non_nullable
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
        url:
            null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String,
        quality:
            null == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                    as AudioQuality,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as int,
        sizeInBytes:
            null == sizeInBytes
                ? _value.sizeInBytes
                : sizeInBytes // ignore: cast_nullable_to_non_nullable
                    as int,
        format:
            null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                    as String,
        isDownloaded:
            null == isDownloaded
                ? _value.isDownloaded
                : isDownloaded // ignore: cast_nullable_to_non_nullable
                    as bool,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
        playCount:
            null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                    as int,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        encryptedUrl:
            freezed == encryptedUrl
                ? _value.encryptedUrl
                : encryptedUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        accessToken:
            freezed == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        tokenExpiry:
            freezed == tokenExpiry
                ? _value.tokenExpiry
                : tokenExpiry // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        localPath:
            freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                    as String?,
        downloadId:
            freezed == downloadId
                ? _value.downloadId
                : downloadId // ignore: cast_nullable_to_non_nullable
                    as String?,
        downloadStatus:
            null == downloadStatus
                ? _value.downloadStatus
                : downloadStatus // ignore: cast_nullable_to_non_nullable
                    as DownloadStatus,
        downloadProgress:
            null == downloadProgress
                ? _value.downloadProgress
                : downloadProgress // ignore: cast_nullable_to_non_nullable
                    as double,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastPlayed:
            freezed == lastPlayed
                ? _value.lastPlayed
                : lastPlayed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PremiumRecitationImpl implements _PremiumRecitation {
  const _$PremiumRecitationImpl({
    required this.id,
    required this.duaId,
    required this.qariId,
    required this.title,
    required this.arabicTitle,
    required this.url,
    required this.quality,
    required this.duration,
    required this.sizeInBytes,
    this.format = 'mp3',
    this.isDownloaded = false,
    this.isFavorite = false,
    this.playCount = 0,
    final List<String> tags = const [],
    @JsonKey(includeToJson: false) this.encryptedUrl,
    @JsonKey(includeToJson: false) this.accessToken,
    @JsonKey(includeToJson: false) this.tokenExpiry,
    this.localPath,
    this.downloadId,
    this.downloadStatus = DownloadStatus.notDownloaded,
    this.downloadProgress = 0.0,
    this.createdAt,
    this.lastPlayed,
  }) : _tags = tags;

  factory _$PremiumRecitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumRecitationImplFromJson(json);

  @override
  final String id;
  @override
  final String duaId;
  @override
  final String qariId;
  @override
  final String title;
  @override
  final String arabicTitle;
  @override
  final String url;
  @override
  final AudioQuality quality;
  @override
  final int duration;
  // in seconds
  @override
  final int sizeInBytes;
  @override
  @JsonKey()
  final String format;
  @override
  @JsonKey()
  final bool isDownloaded;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final int playCount;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  // Security & DRM
  @override
  @JsonKey(includeToJson: false)
  final String? encryptedUrl;
  @override
  @JsonKey(includeToJson: false)
  final String? accessToken;
  @override
  @JsonKey(includeToJson: false)
  final DateTime? tokenExpiry;
  // Offline capabilities
  @override
  final String? localPath;
  @override
  final String? downloadId;
  @override
  @JsonKey()
  final DownloadStatus downloadStatus;
  @override
  @JsonKey()
  final double downloadProgress;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastPlayed;

  @override
  String toString() {
    return 'PremiumRecitation(id: $id, duaId: $duaId, qariId: $qariId, title: $title, arabicTitle: $arabicTitle, url: $url, quality: $quality, duration: $duration, sizeInBytes: $sizeInBytes, format: $format, isDownloaded: $isDownloaded, isFavorite: $isFavorite, playCount: $playCount, tags: $tags, encryptedUrl: $encryptedUrl, accessToken: $accessToken, tokenExpiry: $tokenExpiry, localPath: $localPath, downloadId: $downloadId, downloadStatus: $downloadStatus, downloadProgress: $downloadProgress, createdAt: $createdAt, lastPlayed: $lastPlayed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumRecitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.duaId, duaId) || other.duaId == duaId) &&
            (identical(other.qariId, qariId) || other.qariId == qariId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.arabicTitle, arabicTitle) ||
                other.arabicTitle == arabicTitle) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.isDownloaded, isDownloaded) ||
                other.isDownloaded == isDownloaded) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.encryptedUrl, encryptedUrl) ||
                other.encryptedUrl == encryptedUrl) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.tokenExpiry, tokenExpiry) ||
                other.tokenExpiry == tokenExpiry) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.downloadId, downloadId) ||
                other.downloadId == downloadId) &&
            (identical(other.downloadStatus, downloadStatus) ||
                other.downloadStatus == downloadStatus) &&
            (identical(other.downloadProgress, downloadProgress) ||
                other.downloadProgress == downloadProgress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastPlayed, lastPlayed) ||
                other.lastPlayed == lastPlayed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    duaId,
    qariId,
    title,
    arabicTitle,
    url,
    quality,
    duration,
    sizeInBytes,
    format,
    isDownloaded,
    isFavorite,
    playCount,
    const DeepCollectionEquality().hash(_tags),
    encryptedUrl,
    accessToken,
    tokenExpiry,
    localPath,
    downloadId,
    downloadStatus,
    downloadProgress,
    createdAt,
    lastPlayed,
  ]);

  /// Create a copy of PremiumRecitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumRecitationImplCopyWith<_$PremiumRecitationImpl> get copyWith =>
      __$$PremiumRecitationImplCopyWithImpl<_$PremiumRecitationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumRecitationImplToJson(this);
  }
}

abstract class _PremiumRecitation implements PremiumRecitation {
  const factory _PremiumRecitation({
    required final String id,
    required final String duaId,
    required final String qariId,
    required final String title,
    required final String arabicTitle,
    required final String url,
    required final AudioQuality quality,
    required final int duration,
    required final int sizeInBytes,
    final String format,
    final bool isDownloaded,
    final bool isFavorite,
    final int playCount,
    final List<String> tags,
    @JsonKey(includeToJson: false) final String? encryptedUrl,
    @JsonKey(includeToJson: false) final String? accessToken,
    @JsonKey(includeToJson: false) final DateTime? tokenExpiry,
    final String? localPath,
    final String? downloadId,
    final DownloadStatus downloadStatus,
    final double downloadProgress,
    final DateTime? createdAt,
    final DateTime? lastPlayed,
  }) = _$PremiumRecitationImpl;

  factory _PremiumRecitation.fromJson(Map<String, dynamic> json) =
      _$PremiumRecitationImpl.fromJson;

  @override
  String get id;
  @override
  String get duaId;
  @override
  String get qariId;
  @override
  String get title;
  @override
  String get arabicTitle;
  @override
  String get url;
  @override
  AudioQuality get quality;
  @override
  int get duration; // in seconds
  @override
  int get sizeInBytes;
  @override
  String get format;
  @override
  bool get isDownloaded;
  @override
  bool get isFavorite;
  @override
  int get playCount;
  @override
  List<String> get tags; // Security & DRM
  @override
  @JsonKey(includeToJson: false)
  String? get encryptedUrl;
  @override
  @JsonKey(includeToJson: false)
  String? get accessToken;
  @override
  @JsonKey(includeToJson: false)
  DateTime? get tokenExpiry; // Offline capabilities
  @override
  String? get localPath;
  @override
  String? get downloadId;
  @override
  DownloadStatus get downloadStatus;
  @override
  double get downloadProgress;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastPlayed;

  /// Create a copy of PremiumRecitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumRecitationImplCopyWith<_$PremiumRecitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PremiumPlaylist _$PremiumPlaylistFromJson(Map<String, dynamic> json) {
  return _PremiumPlaylist.fromJson(json);
}

/// @nodoc
mixin _$PremiumPlaylist {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get recitationIds => throw _privateConstructorUsedError;
  PlaylistMood get mood => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  bool get isSystemGenerated => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  int get totalDuration => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastPlayed => throw _privateConstructorUsedError;

  /// Serializes this PremiumPlaylist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PremiumPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumPlaylistCopyWith<PremiumPlaylist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumPlaylistCopyWith<$Res> {
  factory $PremiumPlaylistCopyWith(
    PremiumPlaylist value,
    $Res Function(PremiumPlaylist) then,
  ) = _$PremiumPlaylistCopyWithImpl<$Res, PremiumPlaylist>;
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String description,
    List<String> recitationIds,
    PlaylistMood mood,
    bool isPublic,
    bool isSystemGenerated,
    String? coverImageUrl,
    int totalDuration,
    int playCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastPlayed,
  });
}

/// @nodoc
class _$PremiumPlaylistCopyWithImpl<$Res, $Val extends PremiumPlaylist>
    implements $PremiumPlaylistCopyWith<$Res> {
  _$PremiumPlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = null,
    Object? recitationIds = null,
    Object? mood = null,
    Object? isPublic = null,
    Object? isSystemGenerated = null,
    Object? coverImageUrl = freezed,
    Object? totalDuration = null,
    Object? playCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastPlayed = freezed,
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
            recitationIds:
                null == recitationIds
                    ? _value.recitationIds
                    : recitationIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            mood:
                null == mood
                    ? _value.mood
                    : mood // ignore: cast_nullable_to_non_nullable
                        as PlaylistMood,
            isPublic:
                null == isPublic
                    ? _value.isPublic
                    : isPublic // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSystemGenerated:
                null == isSystemGenerated
                    ? _value.isSystemGenerated
                    : isSystemGenerated // ignore: cast_nullable_to_non_nullable
                        as bool,
            coverImageUrl:
                freezed == coverImageUrl
                    ? _value.coverImageUrl
                    : coverImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalDuration:
                null == totalDuration
                    ? _value.totalDuration
                    : totalDuration // ignore: cast_nullable_to_non_nullable
                        as int,
            playCount:
                null == playCount
                    ? _value.playCount
                    : playCount // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastPlayed:
                freezed == lastPlayed
                    ? _value.lastPlayed
                    : lastPlayed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PremiumPlaylistImplCopyWith<$Res>
    implements $PremiumPlaylistCopyWith<$Res> {
  factory _$$PremiumPlaylistImplCopyWith(
    _$PremiumPlaylistImpl value,
    $Res Function(_$PremiumPlaylistImpl) then,
  ) = __$$PremiumPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String name,
    String description,
    List<String> recitationIds,
    PlaylistMood mood,
    bool isPublic,
    bool isSystemGenerated,
    String? coverImageUrl,
    int totalDuration,
    int playCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastPlayed,
  });
}

/// @nodoc
class __$$PremiumPlaylistImplCopyWithImpl<$Res>
    extends _$PremiumPlaylistCopyWithImpl<$Res, _$PremiumPlaylistImpl>
    implements _$$PremiumPlaylistImplCopyWith<$Res> {
  __$$PremiumPlaylistImplCopyWithImpl(
    _$PremiumPlaylistImpl _value,
    $Res Function(_$PremiumPlaylistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PremiumPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = null,
    Object? recitationIds = null,
    Object? mood = null,
    Object? isPublic = null,
    Object? isSystemGenerated = null,
    Object? coverImageUrl = freezed,
    Object? totalDuration = null,
    Object? playCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastPlayed = freezed,
  }) {
    return _then(
      _$PremiumPlaylistImpl(
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
        recitationIds:
            null == recitationIds
                ? _value._recitationIds
                : recitationIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        mood:
            null == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                    as PlaylistMood,
        isPublic:
            null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSystemGenerated:
            null == isSystemGenerated
                ? _value.isSystemGenerated
                : isSystemGenerated // ignore: cast_nullable_to_non_nullable
                    as bool,
        coverImageUrl:
            freezed == coverImageUrl
                ? _value.coverImageUrl
                : coverImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalDuration:
            null == totalDuration
                ? _value.totalDuration
                : totalDuration // ignore: cast_nullable_to_non_nullable
                    as int,
        playCount:
            null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastPlayed:
            freezed == lastPlayed
                ? _value.lastPlayed
                : lastPlayed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PremiumPlaylistImpl implements _PremiumPlaylist {
  const _$PremiumPlaylistImpl({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    final List<String> recitationIds = const [],
    this.mood = PlaylistMood.general,
    this.isPublic = false,
    this.isSystemGenerated = false,
    this.coverImageUrl,
    this.totalDuration = 0,
    this.playCount = 0,
    this.createdAt,
    this.updatedAt,
    this.lastPlayed,
  }) : _recitationIds = recitationIds;

  factory _$PremiumPlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumPlaylistImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String description;
  final List<String> _recitationIds;
  @override
  @JsonKey()
  List<String> get recitationIds {
    if (_recitationIds is EqualUnmodifiableListView) return _recitationIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recitationIds);
  }

  @override
  @JsonKey()
  final PlaylistMood mood;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final bool isSystemGenerated;
  @override
  final String? coverImageUrl;
  @override
  @JsonKey()
  final int totalDuration;
  @override
  @JsonKey()
  final int playCount;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? lastPlayed;

  @override
  String toString() {
    return 'PremiumPlaylist(id: $id, userId: $userId, name: $name, description: $description, recitationIds: $recitationIds, mood: $mood, isPublic: $isPublic, isSystemGenerated: $isSystemGenerated, coverImageUrl: $coverImageUrl, totalDuration: $totalDuration, playCount: $playCount, createdAt: $createdAt, updatedAt: $updatedAt, lastPlayed: $lastPlayed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumPlaylistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._recitationIds,
              _recitationIds,
            ) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isSystemGenerated, isSystemGenerated) ||
                other.isSystemGenerated == isSystemGenerated) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastPlayed, lastPlayed) ||
                other.lastPlayed == lastPlayed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    description,
    const DeepCollectionEquality().hash(_recitationIds),
    mood,
    isPublic,
    isSystemGenerated,
    coverImageUrl,
    totalDuration,
    playCount,
    createdAt,
    updatedAt,
    lastPlayed,
  );

  /// Create a copy of PremiumPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumPlaylistImplCopyWith<_$PremiumPlaylistImpl> get copyWith =>
      __$$PremiumPlaylistImplCopyWithImpl<_$PremiumPlaylistImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumPlaylistImplToJson(this);
  }
}

abstract class _PremiumPlaylist implements PremiumPlaylist {
  const factory _PremiumPlaylist({
    required final String id,
    required final String userId,
    required final String name,
    required final String description,
    final List<String> recitationIds,
    final PlaylistMood mood,
    final bool isPublic,
    final bool isSystemGenerated,
    final String? coverImageUrl,
    final int totalDuration,
    final int playCount,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? lastPlayed,
  }) = _$PremiumPlaylistImpl;

  factory _PremiumPlaylist.fromJson(Map<String, dynamic> json) =
      _$PremiumPlaylistImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get recitationIds;
  @override
  PlaylistMood get mood;
  @override
  bool get isPublic;
  @override
  bool get isSystemGenerated;
  @override
  String? get coverImageUrl;
  @override
  int get totalDuration;
  @override
  int get playCount;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get lastPlayed;

  /// Create a copy of PremiumPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumPlaylistImplCopyWith<_$PremiumPlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SleepTimerConfig _$SleepTimerConfigFromJson(Map<String, dynamic> json) {
  return _SleepTimerConfig.fromJson(json);
}

/// @nodoc
mixin _$SleepTimerConfig {
  Duration get duration => throw _privateConstructorUsedError;
  SleepAction get action => throw _privateConstructorUsedError;
  FadeOutDuration get fadeOut => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// Serializes this SleepTimerConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SleepTimerConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SleepTimerConfigCopyWith<SleepTimerConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepTimerConfigCopyWith<$Res> {
  factory $SleepTimerConfigCopyWith(
    SleepTimerConfig value,
    $Res Function(SleepTimerConfig) then,
  ) = _$SleepTimerConfigCopyWithImpl<$Res, SleepTimerConfig>;
  @useResult
  $Res call({
    Duration duration,
    SleepAction action,
    FadeOutDuration fadeOut,
    bool isActive,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// @nodoc
class _$SleepTimerConfigCopyWithImpl<$Res, $Val extends SleepTimerConfig>
    implements $SleepTimerConfigCopyWith<$Res> {
  _$SleepTimerConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SleepTimerConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? action = null,
    Object? fadeOut = null,
    Object? isActive = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as Duration,
            action:
                null == action
                    ? _value.action
                    : action // ignore: cast_nullable_to_non_nullable
                        as SleepAction,
            fadeOut:
                null == fadeOut
                    ? _value.fadeOut
                    : fadeOut // ignore: cast_nullable_to_non_nullable
                        as FadeOutDuration,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            startTime:
                freezed == startTime
                    ? _value.startTime
                    : startTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endTime:
                freezed == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SleepTimerConfigImplCopyWith<$Res>
    implements $SleepTimerConfigCopyWith<$Res> {
  factory _$$SleepTimerConfigImplCopyWith(
    _$SleepTimerConfigImpl value,
    $Res Function(_$SleepTimerConfigImpl) then,
  ) = __$$SleepTimerConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Duration duration,
    SleepAction action,
    FadeOutDuration fadeOut,
    bool isActive,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// @nodoc
class __$$SleepTimerConfigImplCopyWithImpl<$Res>
    extends _$SleepTimerConfigCopyWithImpl<$Res, _$SleepTimerConfigImpl>
    implements _$$SleepTimerConfigImplCopyWith<$Res> {
  __$$SleepTimerConfigImplCopyWithImpl(
    _$SleepTimerConfigImpl _value,
    $Res Function(_$SleepTimerConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SleepTimerConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? action = null,
    Object? fadeOut = null,
    Object? isActive = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _$SleepTimerConfigImpl(
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as Duration,
        action:
            null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                    as SleepAction,
        fadeOut:
            null == fadeOut
                ? _value.fadeOut
                : fadeOut // ignore: cast_nullable_to_non_nullable
                    as FadeOutDuration,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        startTime:
            freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endTime:
            freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SleepTimerConfigImpl implements _SleepTimerConfig {
  const _$SleepTimerConfigImpl({
    this.duration = const Duration(minutes: 30),
    this.action = SleepAction.pause,
    this.fadeOut = FadeOutDuration.gradual,
    this.isActive = false,
    this.startTime,
    this.endTime,
  });

  factory _$SleepTimerConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepTimerConfigImplFromJson(json);

  @override
  @JsonKey()
  final Duration duration;
  @override
  @JsonKey()
  final SleepAction action;
  @override
  @JsonKey()
  final FadeOutDuration fadeOut;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'SleepTimerConfig(duration: $duration, action: $action, fadeOut: $fadeOut, isActive: $isActive, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepTimerConfigImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.fadeOut, fadeOut) || other.fadeOut == fadeOut) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    action,
    fadeOut,
    isActive,
    startTime,
    endTime,
  );

  /// Create a copy of SleepTimerConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepTimerConfigImplCopyWith<_$SleepTimerConfigImpl> get copyWith =>
      __$$SleepTimerConfigImplCopyWithImpl<_$SleepTimerConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepTimerConfigImplToJson(this);
  }
}

abstract class _SleepTimerConfig implements SleepTimerConfig {
  const factory _SleepTimerConfig({
    final Duration duration,
    final SleepAction action,
    final FadeOutDuration fadeOut,
    final bool isActive,
    final DateTime? startTime,
    final DateTime? endTime,
  }) = _$SleepTimerConfigImpl;

  factory _SleepTimerConfig.fromJson(Map<String, dynamic> json) =
      _$SleepTimerConfigImpl.fromJson;

  @override
  Duration get duration;
  @override
  SleepAction get action;
  @override
  FadeOutDuration get fadeOut;
  @override
  bool get isActive;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;

  /// Create a copy of SleepTimerConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepTimerConfigImplCopyWith<_$SleepTimerConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PremiumAudioSettings _$PremiumAudioSettingsFromJson(Map<String, dynamic> json) {
  return _PremiumAudioSettings.fromJson(json);
}

/// @nodoc
mixin _$PremiumAudioSettings {
  AudioQuality get preferredQuality => throw _privateConstructorUsedError;
  bool get allowOfflineDownloads => throw _privateConstructorUsedError;
  bool get autoDownloadFavorites => throw _privateConstructorUsedError;
  bool get backgroundPlayEnabled => throw _privateConstructorUsedError;
  double get playbackSpeed => throw _privateConstructorUsedError;
  bool get crossfadeEnabled => throw _privateConstructorUsedError;
  Duration get crossfadeDuration => throw _privateConstructorUsedError;
  bool get gaplessPlayback => throw _privateConstructorUsedError;
  double get volumeLevel => throw _privateConstructorUsedError;
  bool get hapticFeedbackEnabled =>
      throw _privateConstructorUsedError; // Security settings
  bool get requireAuthForDownloads => throw _privateConstructorUsedError;
  bool get allowScreenshots => throw _privateConstructorUsedError;
  bool get drmProtectionEnabled =>
      throw _privateConstructorUsedError; // Storage management
  int get maxStorageMB => throw _privateConstructorUsedError; // 5GB default
  AutoDeletePolicy get autoDelete => throw _privateConstructorUsedError;
  Duration get unusedContentRetention => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this PremiumAudioSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PremiumAudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumAudioSettingsCopyWith<PremiumAudioSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumAudioSettingsCopyWith<$Res> {
  factory $PremiumAudioSettingsCopyWith(
    PremiumAudioSettings value,
    $Res Function(PremiumAudioSettings) then,
  ) = _$PremiumAudioSettingsCopyWithImpl<$Res, PremiumAudioSettings>;
  @useResult
  $Res call({
    AudioQuality preferredQuality,
    bool allowOfflineDownloads,
    bool autoDownloadFavorites,
    bool backgroundPlayEnabled,
    double playbackSpeed,
    bool crossfadeEnabled,
    Duration crossfadeDuration,
    bool gaplessPlayback,
    double volumeLevel,
    bool hapticFeedbackEnabled,
    bool requireAuthForDownloads,
    bool allowScreenshots,
    bool drmProtectionEnabled,
    int maxStorageMB,
    AutoDeletePolicy autoDelete,
    Duration unusedContentRetention,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class _$PremiumAudioSettingsCopyWithImpl<
  $Res,
  $Val extends PremiumAudioSettings
>
    implements $PremiumAudioSettingsCopyWith<$Res> {
  _$PremiumAudioSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumAudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredQuality = null,
    Object? allowOfflineDownloads = null,
    Object? autoDownloadFavorites = null,
    Object? backgroundPlayEnabled = null,
    Object? playbackSpeed = null,
    Object? crossfadeEnabled = null,
    Object? crossfadeDuration = null,
    Object? gaplessPlayback = null,
    Object? volumeLevel = null,
    Object? hapticFeedbackEnabled = null,
    Object? requireAuthForDownloads = null,
    Object? allowScreenshots = null,
    Object? drmProtectionEnabled = null,
    Object? maxStorageMB = null,
    Object? autoDelete = null,
    Object? unusedContentRetention = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            preferredQuality:
                null == preferredQuality
                    ? _value.preferredQuality
                    : preferredQuality // ignore: cast_nullable_to_non_nullable
                        as AudioQuality,
            allowOfflineDownloads:
                null == allowOfflineDownloads
                    ? _value.allowOfflineDownloads
                    : allowOfflineDownloads // ignore: cast_nullable_to_non_nullable
                        as bool,
            autoDownloadFavorites:
                null == autoDownloadFavorites
                    ? _value.autoDownloadFavorites
                    : autoDownloadFavorites // ignore: cast_nullable_to_non_nullable
                        as bool,
            backgroundPlayEnabled:
                null == backgroundPlayEnabled
                    ? _value.backgroundPlayEnabled
                    : backgroundPlayEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            playbackSpeed:
                null == playbackSpeed
                    ? _value.playbackSpeed
                    : playbackSpeed // ignore: cast_nullable_to_non_nullable
                        as double,
            crossfadeEnabled:
                null == crossfadeEnabled
                    ? _value.crossfadeEnabled
                    : crossfadeEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            crossfadeDuration:
                null == crossfadeDuration
                    ? _value.crossfadeDuration
                    : crossfadeDuration // ignore: cast_nullable_to_non_nullable
                        as Duration,
            gaplessPlayback:
                null == gaplessPlayback
                    ? _value.gaplessPlayback
                    : gaplessPlayback // ignore: cast_nullable_to_non_nullable
                        as bool,
            volumeLevel:
                null == volumeLevel
                    ? _value.volumeLevel
                    : volumeLevel // ignore: cast_nullable_to_non_nullable
                        as double,
            hapticFeedbackEnabled:
                null == hapticFeedbackEnabled
                    ? _value.hapticFeedbackEnabled
                    : hapticFeedbackEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            requireAuthForDownloads:
                null == requireAuthForDownloads
                    ? _value.requireAuthForDownloads
                    : requireAuthForDownloads // ignore: cast_nullable_to_non_nullable
                        as bool,
            allowScreenshots:
                null == allowScreenshots
                    ? _value.allowScreenshots
                    : allowScreenshots // ignore: cast_nullable_to_non_nullable
                        as bool,
            drmProtectionEnabled:
                null == drmProtectionEnabled
                    ? _value.drmProtectionEnabled
                    : drmProtectionEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            maxStorageMB:
                null == maxStorageMB
                    ? _value.maxStorageMB
                    : maxStorageMB // ignore: cast_nullable_to_non_nullable
                        as int,
            autoDelete:
                null == autoDelete
                    ? _value.autoDelete
                    : autoDelete // ignore: cast_nullable_to_non_nullable
                        as AutoDeletePolicy,
            unusedContentRetention:
                null == unusedContentRetention
                    ? _value.unusedContentRetention
                    : unusedContentRetention // ignore: cast_nullable_to_non_nullable
                        as Duration,
            lastUpdated:
                freezed == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PremiumAudioSettingsImplCopyWith<$Res>
    implements $PremiumAudioSettingsCopyWith<$Res> {
  factory _$$PremiumAudioSettingsImplCopyWith(
    _$PremiumAudioSettingsImpl value,
    $Res Function(_$PremiumAudioSettingsImpl) then,
  ) = __$$PremiumAudioSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AudioQuality preferredQuality,
    bool allowOfflineDownloads,
    bool autoDownloadFavorites,
    bool backgroundPlayEnabled,
    double playbackSpeed,
    bool crossfadeEnabled,
    Duration crossfadeDuration,
    bool gaplessPlayback,
    double volumeLevel,
    bool hapticFeedbackEnabled,
    bool requireAuthForDownloads,
    bool allowScreenshots,
    bool drmProtectionEnabled,
    int maxStorageMB,
    AutoDeletePolicy autoDelete,
    Duration unusedContentRetention,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class __$$PremiumAudioSettingsImplCopyWithImpl<$Res>
    extends _$PremiumAudioSettingsCopyWithImpl<$Res, _$PremiumAudioSettingsImpl>
    implements _$$PremiumAudioSettingsImplCopyWith<$Res> {
  __$$PremiumAudioSettingsImplCopyWithImpl(
    _$PremiumAudioSettingsImpl _value,
    $Res Function(_$PremiumAudioSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PremiumAudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredQuality = null,
    Object? allowOfflineDownloads = null,
    Object? autoDownloadFavorites = null,
    Object? backgroundPlayEnabled = null,
    Object? playbackSpeed = null,
    Object? crossfadeEnabled = null,
    Object? crossfadeDuration = null,
    Object? gaplessPlayback = null,
    Object? volumeLevel = null,
    Object? hapticFeedbackEnabled = null,
    Object? requireAuthForDownloads = null,
    Object? allowScreenshots = null,
    Object? drmProtectionEnabled = null,
    Object? maxStorageMB = null,
    Object? autoDelete = null,
    Object? unusedContentRetention = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$PremiumAudioSettingsImpl(
        preferredQuality:
            null == preferredQuality
                ? _value.preferredQuality
                : preferredQuality // ignore: cast_nullable_to_non_nullable
                    as AudioQuality,
        allowOfflineDownloads:
            null == allowOfflineDownloads
                ? _value.allowOfflineDownloads
                : allowOfflineDownloads // ignore: cast_nullable_to_non_nullable
                    as bool,
        autoDownloadFavorites:
            null == autoDownloadFavorites
                ? _value.autoDownloadFavorites
                : autoDownloadFavorites // ignore: cast_nullable_to_non_nullable
                    as bool,
        backgroundPlayEnabled:
            null == backgroundPlayEnabled
                ? _value.backgroundPlayEnabled
                : backgroundPlayEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        playbackSpeed:
            null == playbackSpeed
                ? _value.playbackSpeed
                : playbackSpeed // ignore: cast_nullable_to_non_nullable
                    as double,
        crossfadeEnabled:
            null == crossfadeEnabled
                ? _value.crossfadeEnabled
                : crossfadeEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        crossfadeDuration:
            null == crossfadeDuration
                ? _value.crossfadeDuration
                : crossfadeDuration // ignore: cast_nullable_to_non_nullable
                    as Duration,
        gaplessPlayback:
            null == gaplessPlayback
                ? _value.gaplessPlayback
                : gaplessPlayback // ignore: cast_nullable_to_non_nullable
                    as bool,
        volumeLevel:
            null == volumeLevel
                ? _value.volumeLevel
                : volumeLevel // ignore: cast_nullable_to_non_nullable
                    as double,
        hapticFeedbackEnabled:
            null == hapticFeedbackEnabled
                ? _value.hapticFeedbackEnabled
                : hapticFeedbackEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        requireAuthForDownloads:
            null == requireAuthForDownloads
                ? _value.requireAuthForDownloads
                : requireAuthForDownloads // ignore: cast_nullable_to_non_nullable
                    as bool,
        allowScreenshots:
            null == allowScreenshots
                ? _value.allowScreenshots
                : allowScreenshots // ignore: cast_nullable_to_non_nullable
                    as bool,
        drmProtectionEnabled:
            null == drmProtectionEnabled
                ? _value.drmProtectionEnabled
                : drmProtectionEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        maxStorageMB:
            null == maxStorageMB
                ? _value.maxStorageMB
                : maxStorageMB // ignore: cast_nullable_to_non_nullable
                    as int,
        autoDelete:
            null == autoDelete
                ? _value.autoDelete
                : autoDelete // ignore: cast_nullable_to_non_nullable
                    as AutoDeletePolicy,
        unusedContentRetention:
            null == unusedContentRetention
                ? _value.unusedContentRetention
                : unusedContentRetention // ignore: cast_nullable_to_non_nullable
                    as Duration,
        lastUpdated:
            freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PremiumAudioSettingsImpl implements _PremiumAudioSettings {
  const _$PremiumAudioSettingsImpl({
    this.preferredQuality = AudioQuality.high,
    this.allowOfflineDownloads = true,
    this.autoDownloadFavorites = true,
    this.backgroundPlayEnabled = false,
    this.playbackSpeed = 1.0,
    this.crossfadeEnabled = true,
    this.crossfadeDuration = const Duration(seconds: 3),
    this.gaplessPlayback = false,
    this.volumeLevel = 0.8,
    this.hapticFeedbackEnabled = true,
    this.requireAuthForDownloads = true,
    this.allowScreenshots = false,
    this.drmProtectionEnabled = true,
    this.maxStorageMB = 5000,
    this.autoDelete = AutoDeletePolicy.never,
    this.unusedContentRetention = const Duration(days: 30),
    this.lastUpdated,
  });

  factory _$PremiumAudioSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumAudioSettingsImplFromJson(json);

  @override
  @JsonKey()
  final AudioQuality preferredQuality;
  @override
  @JsonKey()
  final bool allowOfflineDownloads;
  @override
  @JsonKey()
  final bool autoDownloadFavorites;
  @override
  @JsonKey()
  final bool backgroundPlayEnabled;
  @override
  @JsonKey()
  final double playbackSpeed;
  @override
  @JsonKey()
  final bool crossfadeEnabled;
  @override
  @JsonKey()
  final Duration crossfadeDuration;
  @override
  @JsonKey()
  final bool gaplessPlayback;
  @override
  @JsonKey()
  final double volumeLevel;
  @override
  @JsonKey()
  final bool hapticFeedbackEnabled;
  // Security settings
  @override
  @JsonKey()
  final bool requireAuthForDownloads;
  @override
  @JsonKey()
  final bool allowScreenshots;
  @override
  @JsonKey()
  final bool drmProtectionEnabled;
  // Storage management
  @override
  @JsonKey()
  final int maxStorageMB;
  // 5GB default
  @override
  @JsonKey()
  final AutoDeletePolicy autoDelete;
  @override
  @JsonKey()
  final Duration unusedContentRetention;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'PremiumAudioSettings(preferredQuality: $preferredQuality, allowOfflineDownloads: $allowOfflineDownloads, autoDownloadFavorites: $autoDownloadFavorites, backgroundPlayEnabled: $backgroundPlayEnabled, playbackSpeed: $playbackSpeed, crossfadeEnabled: $crossfadeEnabled, crossfadeDuration: $crossfadeDuration, gaplessPlayback: $gaplessPlayback, volumeLevel: $volumeLevel, hapticFeedbackEnabled: $hapticFeedbackEnabled, requireAuthForDownloads: $requireAuthForDownloads, allowScreenshots: $allowScreenshots, drmProtectionEnabled: $drmProtectionEnabled, maxStorageMB: $maxStorageMB, autoDelete: $autoDelete, unusedContentRetention: $unusedContentRetention, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumAudioSettingsImpl &&
            (identical(other.preferredQuality, preferredQuality) ||
                other.preferredQuality == preferredQuality) &&
            (identical(other.allowOfflineDownloads, allowOfflineDownloads) ||
                other.allowOfflineDownloads == allowOfflineDownloads) &&
            (identical(other.autoDownloadFavorites, autoDownloadFavorites) ||
                other.autoDownloadFavorites == autoDownloadFavorites) &&
            (identical(other.backgroundPlayEnabled, backgroundPlayEnabled) ||
                other.backgroundPlayEnabled == backgroundPlayEnabled) &&
            (identical(other.playbackSpeed, playbackSpeed) ||
                other.playbackSpeed == playbackSpeed) &&
            (identical(other.crossfadeEnabled, crossfadeEnabled) ||
                other.crossfadeEnabled == crossfadeEnabled) &&
            (identical(other.crossfadeDuration, crossfadeDuration) ||
                other.crossfadeDuration == crossfadeDuration) &&
            (identical(other.gaplessPlayback, gaplessPlayback) ||
                other.gaplessPlayback == gaplessPlayback) &&
            (identical(other.volumeLevel, volumeLevel) ||
                other.volumeLevel == volumeLevel) &&
            (identical(other.hapticFeedbackEnabled, hapticFeedbackEnabled) ||
                other.hapticFeedbackEnabled == hapticFeedbackEnabled) &&
            (identical(
                  other.requireAuthForDownloads,
                  requireAuthForDownloads,
                ) ||
                other.requireAuthForDownloads == requireAuthForDownloads) &&
            (identical(other.allowScreenshots, allowScreenshots) ||
                other.allowScreenshots == allowScreenshots) &&
            (identical(other.drmProtectionEnabled, drmProtectionEnabled) ||
                other.drmProtectionEnabled == drmProtectionEnabled) &&
            (identical(other.maxStorageMB, maxStorageMB) ||
                other.maxStorageMB == maxStorageMB) &&
            (identical(other.autoDelete, autoDelete) ||
                other.autoDelete == autoDelete) &&
            (identical(other.unusedContentRetention, unusedContentRetention) ||
                other.unusedContentRetention == unusedContentRetention) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    preferredQuality,
    allowOfflineDownloads,
    autoDownloadFavorites,
    backgroundPlayEnabled,
    playbackSpeed,
    crossfadeEnabled,
    crossfadeDuration,
    gaplessPlayback,
    volumeLevel,
    hapticFeedbackEnabled,
    requireAuthForDownloads,
    allowScreenshots,
    drmProtectionEnabled,
    maxStorageMB,
    autoDelete,
    unusedContentRetention,
    lastUpdated,
  );

  /// Create a copy of PremiumAudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumAudioSettingsImplCopyWith<_$PremiumAudioSettingsImpl>
  get copyWith =>
      __$$PremiumAudioSettingsImplCopyWithImpl<_$PremiumAudioSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumAudioSettingsImplToJson(this);
  }
}

abstract class _PremiumAudioSettings implements PremiumAudioSettings {
  const factory _PremiumAudioSettings({
    final AudioQuality preferredQuality,
    final bool allowOfflineDownloads,
    final bool autoDownloadFavorites,
    final bool backgroundPlayEnabled,
    final double playbackSpeed,
    final bool crossfadeEnabled,
    final Duration crossfadeDuration,
    final bool gaplessPlayback,
    final double volumeLevel,
    final bool hapticFeedbackEnabled,
    final bool requireAuthForDownloads,
    final bool allowScreenshots,
    final bool drmProtectionEnabled,
    final int maxStorageMB,
    final AutoDeletePolicy autoDelete,
    final Duration unusedContentRetention,
    final DateTime? lastUpdated,
  }) = _$PremiumAudioSettingsImpl;

  factory _PremiumAudioSettings.fromJson(Map<String, dynamic> json) =
      _$PremiumAudioSettingsImpl.fromJson;

  @override
  AudioQuality get preferredQuality;
  @override
  bool get allowOfflineDownloads;
  @override
  bool get autoDownloadFavorites;
  @override
  bool get backgroundPlayEnabled;
  @override
  double get playbackSpeed;
  @override
  bool get crossfadeEnabled;
  @override
  Duration get crossfadeDuration;
  @override
  bool get gaplessPlayback;
  @override
  double get volumeLevel;
  @override
  bool get hapticFeedbackEnabled; // Security settings
  @override
  bool get requireAuthForDownloads;
  @override
  bool get allowScreenshots;
  @override
  bool get drmProtectionEnabled; // Storage management
  @override
  int get maxStorageMB; // 5GB default
  @override
  AutoDeletePolicy get autoDelete;
  @override
  Duration get unusedContentRetention;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of PremiumAudioSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumAudioSettingsImplCopyWith<_$PremiumAudioSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PremiumAudioStats _$PremiumAudioStatsFromJson(Map<String, dynamic> json) {
  return _PremiumAudioStats.fromJson(json);
}

/// @nodoc
mixin _$PremiumAudioStats {
  String get userId => throw _privateConstructorUsedError;
  int get totalListeningTime =>
      throw _privateConstructorUsedError; // in seconds
  int get sessionsCount => throw _privateConstructorUsedError;
  int get favoritesCount => throw _privateConstructorUsedError;
  int get downloadsCount => throw _privateConstructorUsedError;
  int get playlistsCount => throw _privateConstructorUsedError;
  Map<String, int> get qariPreferences =>
      throw _privateConstructorUsedError; // qariId -> playCount
  Map<PlaylistMood, int> get moodPreferences =>
      throw _privateConstructorUsedError;
  List<String> get topRecitations => throw _privateConstructorUsedError;
  DateTime? get lastSessionDate => throw _privateConstructorUsedError;
  DateTime? get firstSessionDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PremiumAudioStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PremiumAudioStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumAudioStatsCopyWith<PremiumAudioStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumAudioStatsCopyWith<$Res> {
  factory $PremiumAudioStatsCopyWith(
    PremiumAudioStats value,
    $Res Function(PremiumAudioStats) then,
  ) = _$PremiumAudioStatsCopyWithImpl<$Res, PremiumAudioStats>;
  @useResult
  $Res call({
    String userId,
    int totalListeningTime,
    int sessionsCount,
    int favoritesCount,
    int downloadsCount,
    int playlistsCount,
    Map<String, int> qariPreferences,
    Map<PlaylistMood, int> moodPreferences,
    List<String> topRecitations,
    DateTime? lastSessionDate,
    DateTime? firstSessionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$PremiumAudioStatsCopyWithImpl<$Res, $Val extends PremiumAudioStats>
    implements $PremiumAudioStatsCopyWith<$Res> {
  _$PremiumAudioStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumAudioStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalListeningTime = null,
    Object? sessionsCount = null,
    Object? favoritesCount = null,
    Object? downloadsCount = null,
    Object? playlistsCount = null,
    Object? qariPreferences = null,
    Object? moodPreferences = null,
    Object? topRecitations = null,
    Object? lastSessionDate = freezed,
    Object? firstSessionDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            totalListeningTime:
                null == totalListeningTime
                    ? _value.totalListeningTime
                    : totalListeningTime // ignore: cast_nullable_to_non_nullable
                        as int,
            sessionsCount:
                null == sessionsCount
                    ? _value.sessionsCount
                    : sessionsCount // ignore: cast_nullable_to_non_nullable
                        as int,
            favoritesCount:
                null == favoritesCount
                    ? _value.favoritesCount
                    : favoritesCount // ignore: cast_nullable_to_non_nullable
                        as int,
            downloadsCount:
                null == downloadsCount
                    ? _value.downloadsCount
                    : downloadsCount // ignore: cast_nullable_to_non_nullable
                        as int,
            playlistsCount:
                null == playlistsCount
                    ? _value.playlistsCount
                    : playlistsCount // ignore: cast_nullable_to_non_nullable
                        as int,
            qariPreferences:
                null == qariPreferences
                    ? _value.qariPreferences
                    : qariPreferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            moodPreferences:
                null == moodPreferences
                    ? _value.moodPreferences
                    : moodPreferences // ignore: cast_nullable_to_non_nullable
                        as Map<PlaylistMood, int>,
            topRecitations:
                null == topRecitations
                    ? _value.topRecitations
                    : topRecitations // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            lastSessionDate:
                freezed == lastSessionDate
                    ? _value.lastSessionDate
                    : lastSessionDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            firstSessionDate:
                freezed == firstSessionDate
                    ? _value.firstSessionDate
                    : firstSessionDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PremiumAudioStatsImplCopyWith<$Res>
    implements $PremiumAudioStatsCopyWith<$Res> {
  factory _$$PremiumAudioStatsImplCopyWith(
    _$PremiumAudioStatsImpl value,
    $Res Function(_$PremiumAudioStatsImpl) then,
  ) = __$$PremiumAudioStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int totalListeningTime,
    int sessionsCount,
    int favoritesCount,
    int downloadsCount,
    int playlistsCount,
    Map<String, int> qariPreferences,
    Map<PlaylistMood, int> moodPreferences,
    List<String> topRecitations,
    DateTime? lastSessionDate,
    DateTime? firstSessionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PremiumAudioStatsImplCopyWithImpl<$Res>
    extends _$PremiumAudioStatsCopyWithImpl<$Res, _$PremiumAudioStatsImpl>
    implements _$$PremiumAudioStatsImplCopyWith<$Res> {
  __$$PremiumAudioStatsImplCopyWithImpl(
    _$PremiumAudioStatsImpl _value,
    $Res Function(_$PremiumAudioStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PremiumAudioStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalListeningTime = null,
    Object? sessionsCount = null,
    Object? favoritesCount = null,
    Object? downloadsCount = null,
    Object? playlistsCount = null,
    Object? qariPreferences = null,
    Object? moodPreferences = null,
    Object? topRecitations = null,
    Object? lastSessionDate = freezed,
    Object? firstSessionDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PremiumAudioStatsImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        totalListeningTime:
            null == totalListeningTime
                ? _value.totalListeningTime
                : totalListeningTime // ignore: cast_nullable_to_non_nullable
                    as int,
        sessionsCount:
            null == sessionsCount
                ? _value.sessionsCount
                : sessionsCount // ignore: cast_nullable_to_non_nullable
                    as int,
        favoritesCount:
            null == favoritesCount
                ? _value.favoritesCount
                : favoritesCount // ignore: cast_nullable_to_non_nullable
                    as int,
        downloadsCount:
            null == downloadsCount
                ? _value.downloadsCount
                : downloadsCount // ignore: cast_nullable_to_non_nullable
                    as int,
        playlistsCount:
            null == playlistsCount
                ? _value.playlistsCount
                : playlistsCount // ignore: cast_nullable_to_non_nullable
                    as int,
        qariPreferences:
            null == qariPreferences
                ? _value._qariPreferences
                : qariPreferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        moodPreferences:
            null == moodPreferences
                ? _value._moodPreferences
                : moodPreferences // ignore: cast_nullable_to_non_nullable
                    as Map<PlaylistMood, int>,
        topRecitations:
            null == topRecitations
                ? _value._topRecitations
                : topRecitations // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        lastSessionDate:
            freezed == lastSessionDate
                ? _value.lastSessionDate
                : lastSessionDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        firstSessionDate:
            freezed == firstSessionDate
                ? _value.firstSessionDate
                : firstSessionDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PremiumAudioStatsImpl implements _PremiumAudioStats {
  const _$PremiumAudioStatsImpl({
    required this.userId,
    this.totalListeningTime = 0,
    this.sessionsCount = 0,
    this.favoritesCount = 0,
    this.downloadsCount = 0,
    this.playlistsCount = 0,
    final Map<String, int> qariPreferences = const {},
    final Map<PlaylistMood, int> moodPreferences = const {},
    final List<String> topRecitations = const [],
    this.lastSessionDate,
    this.firstSessionDate,
    this.createdAt,
    this.updatedAt,
  }) : _qariPreferences = qariPreferences,
       _moodPreferences = moodPreferences,
       _topRecitations = topRecitations;

  factory _$PremiumAudioStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumAudioStatsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final int totalListeningTime;
  // in seconds
  @override
  @JsonKey()
  final int sessionsCount;
  @override
  @JsonKey()
  final int favoritesCount;
  @override
  @JsonKey()
  final int downloadsCount;
  @override
  @JsonKey()
  final int playlistsCount;
  final Map<String, int> _qariPreferences;
  @override
  @JsonKey()
  Map<String, int> get qariPreferences {
    if (_qariPreferences is EqualUnmodifiableMapView) return _qariPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_qariPreferences);
  }

  // qariId -> playCount
  final Map<PlaylistMood, int> _moodPreferences;
  // qariId -> playCount
  @override
  @JsonKey()
  Map<PlaylistMood, int> get moodPreferences {
    if (_moodPreferences is EqualUnmodifiableMapView) return _moodPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moodPreferences);
  }

  final List<String> _topRecitations;
  @override
  @JsonKey()
  List<String> get topRecitations {
    if (_topRecitations is EqualUnmodifiableListView) return _topRecitations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRecitations);
  }

  @override
  final DateTime? lastSessionDate;
  @override
  final DateTime? firstSessionDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PremiumAudioStats(userId: $userId, totalListeningTime: $totalListeningTime, sessionsCount: $sessionsCount, favoritesCount: $favoritesCount, downloadsCount: $downloadsCount, playlistsCount: $playlistsCount, qariPreferences: $qariPreferences, moodPreferences: $moodPreferences, topRecitations: $topRecitations, lastSessionDate: $lastSessionDate, firstSessionDate: $firstSessionDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumAudioStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalListeningTime, totalListeningTime) ||
                other.totalListeningTime == totalListeningTime) &&
            (identical(other.sessionsCount, sessionsCount) ||
                other.sessionsCount == sessionsCount) &&
            (identical(other.favoritesCount, favoritesCount) ||
                other.favoritesCount == favoritesCount) &&
            (identical(other.downloadsCount, downloadsCount) ||
                other.downloadsCount == downloadsCount) &&
            (identical(other.playlistsCount, playlistsCount) ||
                other.playlistsCount == playlistsCount) &&
            const DeepCollectionEquality().equals(
              other._qariPreferences,
              _qariPreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._moodPreferences,
              _moodPreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._topRecitations,
              _topRecitations,
            ) &&
            (identical(other.lastSessionDate, lastSessionDate) ||
                other.lastSessionDate == lastSessionDate) &&
            (identical(other.firstSessionDate, firstSessionDate) ||
                other.firstSessionDate == firstSessionDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    totalListeningTime,
    sessionsCount,
    favoritesCount,
    downloadsCount,
    playlistsCount,
    const DeepCollectionEquality().hash(_qariPreferences),
    const DeepCollectionEquality().hash(_moodPreferences),
    const DeepCollectionEquality().hash(_topRecitations),
    lastSessionDate,
    firstSessionDate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PremiumAudioStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumAudioStatsImplCopyWith<_$PremiumAudioStatsImpl> get copyWith =>
      __$$PremiumAudioStatsImplCopyWithImpl<_$PremiumAudioStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumAudioStatsImplToJson(this);
  }
}

abstract class _PremiumAudioStats implements PremiumAudioStats {
  const factory _PremiumAudioStats({
    required final String userId,
    final int totalListeningTime,
    final int sessionsCount,
    final int favoritesCount,
    final int downloadsCount,
    final int playlistsCount,
    final Map<String, int> qariPreferences,
    final Map<PlaylistMood, int> moodPreferences,
    final List<String> topRecitations,
    final DateTime? lastSessionDate,
    final DateTime? firstSessionDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$PremiumAudioStatsImpl;

  factory _PremiumAudioStats.fromJson(Map<String, dynamic> json) =
      _$PremiumAudioStatsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalListeningTime; // in seconds
  @override
  int get sessionsCount;
  @override
  int get favoritesCount;
  @override
  int get downloadsCount;
  @override
  int get playlistsCount;
  @override
  Map<String, int> get qariPreferences; // qariId -> playCount
  @override
  Map<PlaylistMood, int> get moodPreferences;
  @override
  List<String> get topRecitations;
  @override
  DateTime? get lastSessionDate;
  @override
  DateTime? get firstSessionDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PremiumAudioStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumAudioStatsImplCopyWith<_$PremiumAudioStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContentVerification _$ContentVerificationFromJson(Map<String, dynamic> json) {
  return _ContentVerification.fromJson(json);
}

/// @nodoc
mixin _$ContentVerification {
  String get contentId => throw _privateConstructorUsedError;
  String get sha256Hash => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get verificationSource => throw _privateConstructorUsedError;
  List<String> get certificates => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this ContentVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentVerificationCopyWith<ContentVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentVerificationCopyWith<$Res> {
  factory $ContentVerificationCopyWith(
    ContentVerification value,
    $Res Function(ContentVerification) then,
  ) = _$ContentVerificationCopyWithImpl<$Res, ContentVerification>;
  @useResult
  $Res call({
    String contentId,
    String sha256Hash,
    bool isVerified,
    String verificationSource,
    List<String> certificates,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class _$ContentVerificationCopyWithImpl<$Res, $Val extends ContentVerification>
    implements $ContentVerificationCopyWith<$Res> {
  _$ContentVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? sha256Hash = null,
    Object? isVerified = null,
    Object? verificationSource = null,
    Object? certificates = null,
    Object? verifiedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            contentId:
                null == contentId
                    ? _value.contentId
                    : contentId // ignore: cast_nullable_to_non_nullable
                        as String,
            sha256Hash:
                null == sha256Hash
                    ? _value.sha256Hash
                    : sha256Hash // ignore: cast_nullable_to_non_nullable
                        as String,
            isVerified:
                null == isVerified
                    ? _value.isVerified
                    : isVerified // ignore: cast_nullable_to_non_nullable
                        as bool,
            verificationSource:
                null == verificationSource
                    ? _value.verificationSource
                    : verificationSource // ignore: cast_nullable_to_non_nullable
                        as String,
            certificates:
                null == certificates
                    ? _value.certificates
                    : certificates // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            verifiedAt:
                freezed == verifiedAt
                    ? _value.verifiedAt
                    : verifiedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            expiresAt:
                freezed == expiresAt
                    ? _value.expiresAt
                    : expiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContentVerificationImplCopyWith<$Res>
    implements $ContentVerificationCopyWith<$Res> {
  factory _$$ContentVerificationImplCopyWith(
    _$ContentVerificationImpl value,
    $Res Function(_$ContentVerificationImpl) then,
  ) = __$$ContentVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String contentId,
    String sha256Hash,
    bool isVerified,
    String verificationSource,
    List<String> certificates,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class __$$ContentVerificationImplCopyWithImpl<$Res>
    extends _$ContentVerificationCopyWithImpl<$Res, _$ContentVerificationImpl>
    implements _$$ContentVerificationImplCopyWith<$Res> {
  __$$ContentVerificationImplCopyWithImpl(
    _$ContentVerificationImpl _value,
    $Res Function(_$ContentVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? sha256Hash = null,
    Object? isVerified = null,
    Object? verificationSource = null,
    Object? certificates = null,
    Object? verifiedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$ContentVerificationImpl(
        contentId:
            null == contentId
                ? _value.contentId
                : contentId // ignore: cast_nullable_to_non_nullable
                    as String,
        sha256Hash:
            null == sha256Hash
                ? _value.sha256Hash
                : sha256Hash // ignore: cast_nullable_to_non_nullable
                    as String,
        isVerified:
            null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                    as bool,
        verificationSource:
            null == verificationSource
                ? _value.verificationSource
                : verificationSource // ignore: cast_nullable_to_non_nullable
                    as String,
        certificates:
            null == certificates
                ? _value._certificates
                : certificates // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        verifiedAt:
            freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        expiresAt:
            freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentVerificationImpl implements _ContentVerification {
  const _$ContentVerificationImpl({
    required this.contentId,
    required this.sha256Hash,
    required this.isVerified,
    required this.verificationSource,
    final List<String> certificates = const [],
    this.verifiedAt,
    this.expiresAt,
  }) : _certificates = certificates;

  factory _$ContentVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentVerificationImplFromJson(json);

  @override
  final String contentId;
  @override
  final String sha256Hash;
  @override
  final bool isVerified;
  @override
  final String verificationSource;
  final List<String> _certificates;
  @override
  @JsonKey()
  List<String> get certificates {
    if (_certificates is EqualUnmodifiableListView) return _certificates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certificates);
  }

  @override
  final DateTime? verifiedAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'ContentVerification(contentId: $contentId, sha256Hash: $sha256Hash, isVerified: $isVerified, verificationSource: $verificationSource, certificates: $certificates, verifiedAt: $verifiedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentVerificationImpl &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.sha256Hash, sha256Hash) ||
                other.sha256Hash == sha256Hash) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verificationSource, verificationSource) ||
                other.verificationSource == verificationSource) &&
            const DeepCollectionEquality().equals(
              other._certificates,
              _certificates,
            ) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    contentId,
    sha256Hash,
    isVerified,
    verificationSource,
    const DeepCollectionEquality().hash(_certificates),
    verifiedAt,
    expiresAt,
  );

  /// Create a copy of ContentVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentVerificationImplCopyWith<_$ContentVerificationImpl> get copyWith =>
      __$$ContentVerificationImplCopyWithImpl<_$ContentVerificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentVerificationImplToJson(this);
  }
}

abstract class _ContentVerification implements ContentVerification {
  const factory _ContentVerification({
    required final String contentId,
    required final String sha256Hash,
    required final bool isVerified,
    required final String verificationSource,
    final List<String> certificates,
    final DateTime? verifiedAt,
    final DateTime? expiresAt,
  }) = _$ContentVerificationImpl;

  factory _ContentVerification.fromJson(Map<String, dynamic> json) =
      _$ContentVerificationImpl.fromJson;

  @override
  String get contentId;
  @override
  String get sha256Hash;
  @override
  bool get isVerified;
  @override
  String get verificationSource;
  @override
  List<String> get certificates;
  @override
  DateTime? get verifiedAt;
  @override
  DateTime? get expiresAt;

  /// Create a copy of ContentVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentVerificationImplCopyWith<_$ContentVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
