import 'package:dartz/dartz.dart';
import '../entities/rag_response.dart';
import '../entities/query_history.dart';
import '../../core/error/failures.dart';

abstract class RagRepository {
  Future<Either<Failure, RagResponse>> searchRag(String query);
  Future<Either<Failure, List<QueryHistory>>> getQueryHistory({
    int? limit,
    int? offset,
  });
  Future<Either<Failure, void>> saveQueryHistory(QueryHistory queryHistory);
  Future<Either<Failure, void>> clearQueryHistory();
  Future<Either<Failure, RagResponse?>> getCachedResponse(String query);
}
