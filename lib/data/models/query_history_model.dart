import '../../domain/entities/query_history.dart';

/// QueryHistoryModel class implementation
class QueryHistoryModel extends QueryHistory {
  const QueryHistoryModel({
    super.id,
    required super.query,
    super.response,
    required super.timestamp,
    super.responseTime,
    required super.success,
  });

  factory QueryHistoryModel.fromEntity(QueryHistory entity) {
    return QueryHistoryModel(
      id: entity.id,
      query: entity.query,
      response: entity.response,
      timestamp: entity.timestamp,
      responseTime: entity.responseTime,
      success: entity.success,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'response_time': responseTime,
      'success': success ? 1 : 0,
    };
  }

  factory QueryHistoryModel.fromDatabase(Map<String, dynamic> map) {
    return QueryHistoryModel(
      id: map['id'] as int?,
      query: map['query'] as String,
      response: map['response'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      responseTime: map['response_time'] as int?,
      success: (map['success'] as int) == 1,
    );
  }
}
