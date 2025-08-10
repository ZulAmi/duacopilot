import 'package:equatable/equatable.dart';

class QueryHistory extends Equatable {
  final int? id;
  final String query;
  final String? response;
  final DateTime timestamp;
  final int? responseTime;
  final bool success;

  const QueryHistory({
    this.id,
    required this.query,
    this.response,
    required this.timestamp,
    this.responseTime,
    required this.success,
  });

  @override
  List<Object?> get props => [
    id,
    query,
    response,
    timestamp,
    responseTime,
    success,
  ];
}
