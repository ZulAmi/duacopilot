import 'package:equatable/equatable.dart';

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
}
