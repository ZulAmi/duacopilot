import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/monitoring/simple_monitoring_service.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/query_history.dart';
import '../../domain/entities/rag_response.dart';
import '../../domain/repositories/rag_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/rag_remote_datasource.dart';
import '../models/query_history_model.dart';

/// RagRepositoryImpl class implementation
class RagRepositoryImpl implements RagRepository {
  final RagRemoteDataSource remoteDataSource;
  final LocalDataSource? localDataSource;
  final NetworkInfo networkInfo;

  RagRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource, // Made optional
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RagResponse>> searchRag(String query) async {
    final startTime = DateTime.now();

    try {
      // First check cache (if available)
      if (localDataSource != null) {
        final cachedResponse = await localDataSource!.getCachedRagResponse(query);
        if (cachedResponse != null) {
          // Track cache hit
          final processingTime = DateTime.now().difference(startTime);
          SimpleMonitoringService.trackRagQuery(
            query: query,
            queryType: 'cache_hit',
            success: true,
            processingTime: processingTime,
            resultCount: cachedResponse.sources?.length ?? 1,
          );

          return Right(cachedResponse);
        }
      }

      // Check network connectivity
      if (await networkInfo.isConnected) {
        final remoteResponse = await remoteDataSource.searchRag(query);
        final processingTime = DateTime.now().difference(startTime);

        // Cache the response (if local storage available)
        if (localDataSource != null) {
          await localDataSource!.cacheRagResponse(remoteResponse);
        }

        // Track successful remote query
        SimpleMonitoringService.trackRagQuery(
          query: query,
          queryType: 'remote_api',
          success: true,
          processingTime: processingTime,
          resultCount: remoteResponse.sources?.length ?? 1,
        );

        return Right(remoteResponse);
      } else {
        // Track network failure
        SimpleMonitoringService.trackRagQuery(query: query, queryType: 'network_failure', success: false);

        return const Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      // Track server error
      SimpleMonitoringService.trackRagQuery(query: query, queryType: 'server_error', success: false);

      SimpleMonitoringService.recordError(
        e,
        StackTrace.current,
        context: 'RAG Server Exception',
        additionalData: {'query': query, 'error': e.message},
      );

      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      // Track cache error
      SimpleMonitoringService.trackRagQuery(query: query, queryType: 'cache_error', success: false);

      SimpleMonitoringService.recordError(
        e,
        StackTrace.current,
        context: 'RAG Cache Exception',
        additionalData: {'query': query, 'error': e.message},
      );

      return Left(CacheFailure(e.message));
    } catch (e) {
      // Track unexpected error
      SimpleMonitoringService.trackRagQuery(query: query, queryType: 'unexpected_error', success: false);

      SimpleMonitoringService.recordError(
        e,
        StackTrace.current,
        context: 'RAG Unexpected Error',
        additionalData: {'query': query},
      );

      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<QueryHistory>>> getQueryHistory({int? limit, int? offset}) async {
    try {
      if (localDataSource == null) {
        return const Left(CacheFailure('Local storage not available'));
      }

      final queryHistoryModels = await localDataSource!.getQueryHistory(limit: limit, offset: offset);
      return Right(queryHistoryModels);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveQueryHistory(QueryHistory queryHistory) async {
    try {
      if (localDataSource == null) {
        return const Left(CacheFailure('Local storage not available'));
      }

      final queryHistoryModel = QueryHistoryModel.fromEntity(queryHistory);
      await localDataSource!.saveQueryHistory(queryHistoryModel);
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
      if (localDataSource == null) {
        return const Left(CacheFailure('Local storage not available'));
      }

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
      if (localDataSource == null) {
        return const Right(null);
      }

      final cachedResponse = await localDataSource!.getCachedRagResponse(query);
      return Right(cachedResponse);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
