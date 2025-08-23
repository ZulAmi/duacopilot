import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'dua_response.freezed.dart';
part 'dua_response.g.dart';

@freezed
/// DuaResponse class implementation
class DuaResponse with _$DuaResponse {
  const DuaResponse._();

  const factory DuaResponse({
    required String id,
    required String query,
    required String response,
    required DateTime timestamp,
    required int responseTime,
    required double confidence,
    required List<DuaSource> sources,
    String? sessionId,
    int? tokensUsed,
    String? model,
    Map<String, dynamic>? metadata,
    @Default(false) bool isFavorite,
    @Default(false) bool isFromCache,
  }) = _DuaResponse;

  factory DuaResponse.fromJson(Map<String, dynamic> json) =>
      _$DuaResponseFromJson(json);
}

@freezed
/// DuaSource class implementation
class DuaSource with _$DuaSource {
  const DuaSource._();

  const factory DuaSource({
    required String id,
    required String title,
    required String content,
    required double relevanceScore,
    String? url,
    String? reference,
    String? category,
    Map<String, dynamic>? metadata,
  }) = _DuaSource;

  factory DuaSource.fromJson(Map<String, dynamic> json) =>
      _$DuaSourceFromJson(json);
}
