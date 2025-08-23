import 'package:equatable/equatable.dart';

/// RagResponse class implementation
class RagResponse extends Equatable {
  final String id;
  final String query;
  final String response;
  final DateTime timestamp;
  final int responseTime;
  final Map<String, dynamic>? metadata;
  final List<dynamic>? sources; // Can be List<String> or List<RagSourceModel>
  final double? confidence;
  final String? sessionId;
  final int? tokensUsed;
  final String? model;

  const RagResponse({
    required this.id,
    required this.query,
    required this.response,
    required this.timestamp,
    required this.responseTime,
    this.metadata,
    this.sources,
    this.confidence,
    this.sessionId,
    this.tokensUsed,
    this.model,
  });

  @override
  List<Object?> get props => [
    id,
    query,
    response,
    timestamp,
    responseTime,
    metadata,
    sources,
    confidence,
    sessionId,
    tokensUsed,
    model,
  ];

  /// Convert RagResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'responseTime': responseTime,
      'metadata': metadata,
      'sources': sources,
      'confidence': confidence,
      'sessionId': sessionId,
      'tokensUsed': tokensUsed,
      'model': model,
    };
  }

  /// Create RagResponse from JSON
  factory RagResponse.fromJson(Map<String, dynamic> json) {
    return RagResponse(
      id: json['id'] as String,
      query: json['query'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseTime: json['responseTime'] as int,
      metadata: json['metadata'] as Map<String, dynamic>?,
      sources: json['sources'] as List<dynamic>?,
      confidence: json['confidence'] as double?,
      sessionId: json['sessionId'] as String?,
      tokensUsed: json['tokensUsed'] as int?,
      model: json['model'] as String?,
    );
  }

  /// Create a copy of RagResponse with updated fields
  RagResponse copyWith({
    String? id,
    String? query,
    String? response,
    DateTime? timestamp,
    int? responseTime,
    Map<String, dynamic>? metadata,
    List<dynamic>? sources,
    double? confidence,
    String? sessionId,
    int? tokensUsed,
    String? model,
  }) {
    return RagResponse(
      id: id ?? this.id,
      query: query ?? this.query,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      responseTime: responseTime ?? this.responseTime,
      metadata: metadata ?? this.metadata,
      sources: sources ?? this.sources,
      confidence: confidence ?? this.confidence,
      sessionId: sessionId ?? this.sessionId,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      model: model ?? this.model,
    );
  }
}
