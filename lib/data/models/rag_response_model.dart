import '../../domain/entities/rag_response.dart';

class RagResponseModel extends RagResponse {
  const RagResponseModel({
    required super.id,
    required super.query,
    required super.response,
    required super.timestamp,
    required super.responseTime,
    super.metadata,
    super.sources,
  });

  factory RagResponseModel.fromJson(Map<String, dynamic> json) {
    return RagResponseModel(
      id: json['id'] as String,
      query: json['query'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseTime: json['response_time'] as int,
      metadata: json['metadata'] as Map<String, dynamic>?,
      sources:
          json['sources'] != null
              ? List<String>.from(json['sources'] as List)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'response_time': responseTime,
      'metadata': metadata,
      'sources': sources,
    };
  }

  factory RagResponseModel.fromEntity(RagResponse entity) {
    return RagResponseModel(
      id: entity.id,
      query: entity.query,
      response: entity.response,
      timestamp: entity.timestamp,
      responseTime: entity.responseTime,
      metadata: entity.metadata,
      sources: entity.sources,
    );
  }

  RagResponse toEntity() {
    return RagResponse(
      id: id,
      query: query,
      response: response,
      timestamp: timestamp,
      responseTime: responseTime,
      metadata: metadata,
      sources: sources,
    );
  }

  // For database operations
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'response_time': responseTime,
      'metadata': metadata != null ? _encodeMetadata(metadata!) : null,
      'sources': sources?.join(','),
    };
  }

  factory RagResponseModel.fromDatabase(Map<String, dynamic> map) {
    return RagResponseModel(
      id: map['id'] as String,
      query: map['query'] as String,
      response: map['response'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      responseTime: map['response_time'] as int,
      metadata:
          map['metadata'] != null
              ? _decodeMetadata(map['metadata'] as String)
              : null,
      sources:
          map['sources'] != null
              ? (map['sources'] as String)
                  .split(',')
                  .where((s) => s.isNotEmpty)
                  .toList()
              : null,
    );
  }

  static String _encodeMetadata(Map<String, dynamic> metadata) {
    // Simple JSON encoding - in a real app, you might want to use proper JSON serialization
    return metadata.toString();
  }

  static Map<String, dynamic> _decodeMetadata(String metadataString) {
    // Simple JSON decoding - in a real app, you might want to use proper JSON deserialization
    return {};
  }
}
