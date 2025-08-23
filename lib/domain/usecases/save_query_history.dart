import 'package:dartz/dartz.dart';
import '../entities/query_history.dart';
import '../repositories/rag_repository.dart';
import '../../core/error/failures.dart';

/// SaveQueryHistory class implementation
class SaveQueryHistory {
  final RagRepository repository;

  SaveQueryHistory(this.repository);

  Future<Either<Failure, void>> call(QueryHistory queryHistory) async {
    return await repository.saveQueryHistory(queryHistory);
  }
}
