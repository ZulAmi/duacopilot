import 'package:dartz/dartz.dart';
import '../../domain/entities/rag_response.dart';
import '../../domain/entities/query_history.dart';
import '../../domain/repositories/rag_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/rag_remote_datasource.dart';
import '../datasources/local_datasource.dart';
import '../models/query_history_model.dart';

class RagRepositoryImpl implements RagRepository {
  final RagRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RagRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RagResponse>> searchRag(String query) async {
    try {
      // First check cache
      final cachedResponse = await localDataSource.getCachedRagResponse(query);
      if (cachedResponse != null) {
        return Right(cachedResponse);
      }

      // Check network connectivity
      if (await networkInfo.isConnected) {
        final remoteResponse = await remoteDataSource.searchRag(query);

        // Cache the response
        await localDataSource.cacheRagResponse(remoteResponse);

        return Right(remoteResponse);
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<QueryHistory>>> getQueryHistory({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryHistoryModels = await localDataSource.getQueryHistory(
        limit: limit,
        offset: offset,
      );
      return Right(queryHistoryModels);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveQueryHistory(
    QueryHistory queryHistory,
  ) async {
    try {
      final queryHistoryModel = QueryHistoryModel.fromEntity(queryHistory);
      await localDataSource.saveQueryHistory(queryHistoryModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearQueryHistory() async {
    try {
      // Implementation would clear all query history
      // For now, this is a placeholder
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, RagResponse?>> getCachedResponse(String query) async {
    try {
      final cachedResponse = await localDataSource.getCachedRagResponse(query);
      return Right(cachedResponse);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
