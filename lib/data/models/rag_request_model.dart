import 'package:equatable/equatable.dart';

/// RagRequestModel class implementation
class RagRequestModel extends Equatable {
  final String query;
  final Map<String, dynamic>? context;
  final List<String>? sources;
  final int? maxTokens;
  final double? temperature;
  final bool? includeMetadata;
  final String? sessionId;
  final Map<String, String>? parameters;

  const RagRequestModel({
    required this.query,
    this.context,
    this.sources,
    this.maxTokens,
    this.temperature,
    this.includeMetadata,
    this.sessionId,
    this.parameters,
  });

  factory RagRequestModel.fromJson(Map<String, dynamic> json) {
    return RagRequestModel(
      query: json['query'] as String,
      context: json['context'] as Map<String, dynamic>?,
      sources:
          json['sources'] != null
              ? List<String>.from(json['sources'] as List)
              : null,
      maxTokens: json['max_tokens'] as int?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      includeMetadata: json['include_metadata'] as bool?,
      sessionId: json['session_id'] as String?,
      parameters:
          json['parameters'] != null
              ? Map<String, String>.from(json['parameters'] as Map)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'query': query};

    if (context != null) data['context'] = context;
    if (sources != null) data['sources'] = sources;
    if (maxTokens != null) data['max_tokens'] = maxTokens;
    if (temperature != null) data['temperature'] = temperature;
    if (includeMetadata != null) data['include_metadata'] = includeMetadata;
    if (sessionId != null) data['session_id'] = sessionId;
    if (parameters != null) data['parameters'] = parameters;

    return data;
  }

  @override
  List<Object?> get props => [
    query,
    context,
    sources,
    maxTokens,
    temperature,
    includeMetadata,
    sessionId,
    parameters,
  ];

  RagRequestModel copyWith({
    String? query,
    Map<String, dynamic>? context,
    List<String>? sources,
    int? maxTokens,
    double? temperature,
    bool? includeMetadata,
    String? sessionId,
    Map<String, String>? parameters,
  }) {
    return RagRequestModel(
      query: query ?? this.query,
      context: context ?? this.context,
      sources: sources ?? this.sources,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      includeMetadata: includeMetadata ?? this.includeMetadata,
      sessionId: sessionId ?? this.sessionId,
      parameters: parameters ?? this.parameters,
    );
  }
}
