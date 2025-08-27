import 'package:freezed_annotation/freezed_annotation.dart';

part 'dua_entity.freezed.dart';
part 'dua_entity.g.dart';

@freezed

/// DuaEntity class implementation
class DuaEntity with _$DuaEntity {
  const factory DuaEntity({
    required String id,
    required String arabicText,
    required String transliteration,
    required String translation,
    required String category,
    required List<String> tags,
    required SourceAuthenticity authenticity,
    required RAGConfidence ragConfidence,
    String? audioUrl,
    String? context,
    String? benefits,
    List<String>? relatedDuas,
    @Default(false) bool isFavorite,
    DateTime? lastAccessed,
  }) = _DuaEntity;

  factory DuaEntity.fromJson(Map<String, dynamic> json) =>
      _$DuaEntityFromJson(json);
}

@freezed

/// SourceAuthenticity class implementation
class SourceAuthenticity with _$SourceAuthenticity {
  const factory SourceAuthenticity({
    required AuthenticityLevel level,
    required String source,
    required String reference,
    String? hadithGrade,
    String? chain,
    String? scholar,
    @Default(1.0) double confidenceScore,
  }) = _SourceAuthenticity;

  factory SourceAuthenticity.fromJson(Map<String, dynamic> json) =>
      _$SourceAuthenticityFromJson(json);
}

@freezed

/// RAGConfidence class implementation
class RAGConfidence with _$RAGConfidence {
  const factory RAGConfidence({
    required double score,
    required String reasoning,
    required List<String> keywords,
    required ContextMatch contextMatch,
    List<String>? similarQueries,
    Map<String, double>? semanticSimilarity,
    @Default([]) List<String> supportingEvidence,
  }) = _RAGConfidence;

  factory RAGConfidence.fromJson(Map<String, dynamic> json) =>
      _$RAGConfidenceFromJson(json);
}

@freezed

/// ContextMatch class implementation
class ContextMatch with _$ContextMatch {
  const factory ContextMatch({
    required double relevanceScore,
    required String category,
    required List<String> matchingCriteria,
    String? timeOfDay,
    String? situation,
    String? emotionalState,
  }) = _ContextMatch;

  factory ContextMatch.fromJson(Map<String, dynamic> json) =>
      _$ContextMatchFromJson(json);
}

enum AuthenticityLevel {
  @JsonValue('sahih')
  sahih,
  @JsonValue('hasan')
  hasan,
  @JsonValue('daif')
  daif,
  @JsonValue('fabricated')
  fabricated,
  @JsonValue('quran')
  quran,
  @JsonValue('verified')
  verified,
}

extension AuthenticityLevelExtension on AuthenticityLevel {
  String get displayName {
    switch (this) {
      case AuthenticityLevel.sahih:
        return 'Sahih (Authentic)';
      case AuthenticityLevel.hasan:
        return 'Hasan (Good)';
      case AuthenticityLevel.daif:
        return 'Daif (Weak)';
      case AuthenticityLevel.fabricated:
        return 'Fabricated';
      case AuthenticityLevel.quran:
        return 'Quran';
      case AuthenticityLevel.verified:
        return 'Verified';
    }
  }

  String get description {
    switch (this) {
      case AuthenticityLevel.sahih:
        return 'Authentic hadith with strong chain of narrators';
      case AuthenticityLevel.hasan:
        return 'Good hadith with acceptable chain of narrators';
      case AuthenticityLevel.daif:
        return 'Weak hadith with questionable chain';
      case AuthenticityLevel.fabricated:
        return 'Fabricated or false attribution';
      case AuthenticityLevel.quran:
        return 'Direct verse from the Holy Quran';
      case AuthenticityLevel.verified:
        return 'Verified by Islamic scholars';
    }
  }
}
