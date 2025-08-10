import 'package:dartz/dartz.dart';
import '../entities/rag_response.dart';
import '../repositories/rag_repository.dart';
import '../../core/error/failures.dart';

class SearchRag {
  final RagRepository repository;

  SearchRag(this.repository);

  Future<Either<Failure, RagResponse>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Left(ValidationFailure('Query cannot be empty'));
    }

    return await repository.searchRag(query.trim());
  }
}
