import 'package:dartz/dartz.dart';
import '../entities/query_history.dart';
import '../repositories/rag_repository.dart';
import '../../core/error/failures.dart';

class GetQueryHistory {
  final RagRepository repository;

  GetQueryHistory(this.repository);

  Future<Either<Failure, List<QueryHistory>>> call({
    int? limit,
    int? offset,
  }) async {
    return await repository.getQueryHistory(limit: limit, offset: offset);
  }
}
