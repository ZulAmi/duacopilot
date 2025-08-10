import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:duacopilot/data/repositories/enhanced_rag_repository_impl.dart';
import 'package:duacopilot/data/datasources/rag_api_service.dart';
import 'package:duacopilot/data/datasources/local_datasource.dart';
import 'package:duacopilot/data/datasources/islamic_rag_service.dart';
import 'package:duacopilot/data/models/rag_request_model.dart';
import 'package:duacopilot/data/models/rag_response_model.dart';
import 'package:duacopilot/data/models/query_history_model.dart';
import 'package:duacopilot/data/models/dua_response.dart';
import 'package:duacopilot/data/models/dua_recommendation.dart';
import 'package:duacopilot/data/models/query_history.dart' as data_model;
import 'package:duacopilot/core/error/failures.dart';
import 'package:duacopilot/core/network/network_info.dart';
import 'package:duacopilot/domain/entities/rag_response.dart';
import 'package:duacopilot/domain/entities/query_history.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Mock implementations for testing
class MockRagApiService implements RagApiService {
  bool shouldFail = false;

  @override
  Future<RagResponseModel> queryRag(RagRequestModel request) async {
    if (shouldFail) throw Exception('API Error');

    return RagResponseModel(
      id: '1',
      query: request.query,
      response: 'Mock RAG response for: ${request.query}',
      timestamp: DateTime.now(),
      responseTime: 100,
    );
  }

  @override
  Future<List<RagResponseModel>> getQueryHistory({
    int? limit,
    String? sessionId,
  }) async {
    return [];
  }

  @override
  Future<void> connectWebSocket({String? sessionId}) async {
    // Mock implementation
  }

  @override
  Future<void> dispose() async {
    // Mock implementation
  }

  @override
  Future<void> clearCache() async {
    // Mock implementation
  }

  @override
  Future<void> setAuthToken(String token) async {
    // Mock implementation
  }

  @override
  Stream<RagResponseModel>? get realTimeUpdates => null;
}

class MockLocalDataSource implements LocalDataSource {
  final Map<String, RagResponseModel> _cache = {};
  final List<QueryHistoryModel> _history = [];

  @override
  Future<void> cacheRagResponse(RagResponseModel response) async {
    _cache[response.query] = response;
  }

  @override
  Future<RagResponseModel?> getCachedRagResponse(String query) async {
    return _cache[query];
  }

  @override
  Future<void> saveQueryHistory(QueryHistoryModel queryHistory) async {
    _history.add(queryHistory);
  }

  @override
  Future<List<QueryHistoryModel>> getQueryHistory({
    int? limit,
    int? offset,
  }) async {
    var result = _history;
    if (offset != null) {
      result = result.skip(offset).toList();
    }
    if (limit != null) {
      result = result.take(limit).toList();
    }
    return result;
  }

  @override
  Future<void> clearExpiredCache() async {
    _cache.clear();
  }
}

class MockIslamicRagService implements IslamicRagService {
  bool shouldFail = false;

  @override
  Future<DuaResponse> processQuery({
    required String query,
    String? userId,
    String language = 'en',
    bool includeAudio = true,
    List<String>? preferredEditions,
  }) async {
    if (shouldFail) throw Exception('Islamic RAG Error');

    return DuaResponse(
      id: '1',
      query: query,
      response: 'Islamic response for: $query',
      timestamp: DateTime.now(),
      responseTime: 100,
      confidence: 0.8,
      sources: [],
    );
  }

  @override
  Future<List<DuaRecommendation>> generateRecommendations({
    required String query,
    String? userId,
    String language = 'en',
    int limit = 5,
  }) async => [];

  @override
  Future<List<DuaRecommendation>> getPopularRecommendations({
    String language = 'en',
    String? category,
    int limit = 10,
  }) async => [];

  @override
  Future<List<data_model.QueryHistory>> getUserHistory(
    String userId, {
    int limit = 50,
  }) async => [];

  @override
  Future<void> clearCache() async {
    // Mock implementation
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    return {};
  }

  @override
  void dispose() {
    // Mock implementation
  }
}

class MockNetworkInfo implements NetworkInfo {
  bool _isConnected = true;

  void setConnected(bool connected) {
    _isConnected = connected;
  }

  @override
  Future<bool> get isConnected async => _isConnected;

  @override
  Future<ConnectivityResult> get connectivityResult async {
    return _isConnected ? ConnectivityResult.wifi : ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return Stream.value(
      _isConnected ? ConnectivityResult.wifi : ConnectivityResult.none,
    );
  }
}

void main() {
  group('EnhancedRagRepositoryImpl', () {
    late EnhancedRagRepositoryImpl repository;
    late MockRagApiService mockRagApiService;
    late MockLocalDataSource mockLocalDataSource;
    late MockIslamicRagService mockIslamicRagService;
    late MockNetworkInfo mockNetworkInfo;
    late Dio mockDio;
    late Logger logger;

    setUp(() {
      mockRagApiService = MockRagApiService();
      mockLocalDataSource = MockLocalDataSource();
      mockIslamicRagService = MockIslamicRagService();
      mockNetworkInfo = MockNetworkInfo();
      mockDio = Dio();
      logger = Logger(level: Level.off); // Disable logging for tests

      repository = EnhancedRagRepositoryImpl(
        ragApiService: mockRagApiService,
        localDataSource: mockLocalDataSource,
        islamicRagService: mockIslamicRagService,
        networkInfo: mockNetworkInfo,
        dioClient: mockDio,
        logger: logger,
      );
    });

    group('searchRag', () {
      const testQuery = 'test query';

      test('should return success when RAG API works online', () async {
        // Arrange
        mockNetworkInfo.setConnected(true);

        // Act
        final result = await repository.searchRag(testQuery);

        // Assert
        expect(result, isA<Right<Failure, RagResponse>>());
        final response = result.getOrElse(() => throw Exception());
        expect(response.query, equals(testQuery));
        expect(response.response.contains('Mock RAG response'), isTrue);
      });

      test('should fallback to Islamic RAG when RAG API fails', () async {
        // Arrange
        mockNetworkInfo.setConnected(true);
        mockRagApiService.shouldFail = true;

        // Act
        final result = await repository.searchRag(testQuery);

        // Assert
        expect(result, isA<Right<Failure, RagResponse>>());
        final response = result.getOrElse(() => throw Exception());
        expect(response.response.contains('Islamic response'), isTrue);
      });

      test('should return cached response when available', () async {
        // Arrange
        const cachedQuery = 'cached query';
        final cachedResponse = RagResponseModel(
          id: '1',
          query: cachedQuery,
          response: 'Cached response',
          timestamp: DateTime.now(),
          responseTime: 50,
        );

        await mockLocalDataSource.cacheRagResponse(cachedResponse);

        // Act
        final result = await repository.searchRag(cachedQuery);

        // Assert
        expect(result, isA<Right<Failure, RagResponse>>());
        final response = result.getOrElse(() => throw Exception());
        expect(response.response, equals('Cached response'));
      });

      test(
        'should use offline resolution when offline and no exact cache',
        () async {
          // Arrange
          mockNetworkInfo.setConnected(false);

          // Add similar query to history
          final historyItem = QueryHistoryModel(
            query: 'test similar query',
            response: 'Historical response',
            timestamp: DateTime.now(),
            success: true,
          );
          await mockLocalDataSource.saveQueryHistory(historyItem);

          // Act
          final result = await repository.searchRag('test query similar');

          // Assert
          expect(result, isA<Right<Failure, RagResponse>>());
          final response = result.getOrElse(() => throw Exception());
          expect(response.response, equals('Historical response'));
        },
      );

      test(
        'should return network failure when offline and no cached data',
        () async {
          // Arrange
          mockNetworkInfo.setConnected(false);

          // Act
          final result = await repository.searchRag('completely new query');

          // Assert
          expect(result, isA<Left<Failure, RagResponse>>());
          final failure = result.fold((l) => l, (r) => null);
          expect(failure, isA<NetworkFailure>());
        },
      );
    });

    group('getQueryHistory', () {
      test('should return query history successfully', () async {
        // Arrange
        final historyItem = QueryHistoryModel(
          query: 'test query',
          response: 'test response',
          timestamp: DateTime.now(),
          success: true,
        );
        await mockLocalDataSource.saveQueryHistory(historyItem);

        // Act
        final result = await repository.getQueryHistory(limit: 10);

        // Assert
        expect(result, isA<Right<Failure, List<QueryHistory>>>());
        final histories = result.getOrElse(() => []);
        expect(histories.length, equals(1));
        expect(histories.first.query, equals('test query'));
      });
    });

    group('saveQueryHistory', () {
      test('should save query history successfully', () async {
        // Arrange
        final queryHistory = QueryHistory(
          query: 'test query',
          response: 'test response',
          timestamp: DateTime.parse('2023-01-01'),
          success: true,
        );

        // Act
        final result = await repository.saveQueryHistory(queryHistory);

        // Assert
        expect(result, isA<Right<Failure, void>>());

        // Verify it was saved
        final historyResult = await repository.getQueryHistory();
        final histories = historyResult.getOrElse(() => []);
        expect(histories.length, equals(1));
      });
    });

    group('getCachedResponse', () {
      test('should return cached response when available', () async {
        // Arrange
        const testQuery = 'test query';
        final testResponse = RagResponseModel(
          id: '1',
          query: testQuery,
          response: 'cached response',
          timestamp: DateTime.now(),
          responseTime: 100,
        );
        await mockLocalDataSource.cacheRagResponse(testResponse);

        // Act
        final result = await repository.getCachedResponse(testQuery);

        // Assert
        expect(result, isA<Right<Failure, RagResponse?>>());
        final response = result.getOrElse(() => null);
        expect(response?.response, equals('cached response'));
      });

      test('should return null when no cached response', () async {
        // Act
        final result = await repository.getCachedResponse('non-existent query');

        // Assert
        expect(result, isA<Right<Failure, RagResponse?>>());
        final response = result.getOrElse(() => null);
        expect(response, isNull);
      });
    });

    group('clearExpiredCache', () {
      test('should clear expired cache without errors', () async {
        // Act & Assert - Should complete without throwing
        await expectLater(repository.clearExpiredCache(), completes);
      });
    });

    group('backgroundSync', () {
      test('should perform background sync when connected', () async {
        // Arrange
        mockNetworkInfo.setConnected(true);

        // Act & Assert - Should complete without throwing
        await expectLater(repository.backgroundSync(), completes);
      });

      test('should skip sync when not connected', () async {
        // Arrange
        mockNetworkInfo.setConnected(false);

        // Act & Assert - Should complete without throwing
        await expectLater(repository.backgroundSync(), completes);
      });
    });

    group('analytics', () {
      test('should record and retrieve analytics', () async {
        // Arrange
        const testQuery = 'test query for analytics';
        mockNetworkInfo.setConnected(false);

        // Act
        await repository.searchRag(testQuery);
        final analytics = repository.getAnalytics();

        // Assert
        expect(analytics, isNotEmpty);
      });

      test('should clear analytics', () {
        // Act
        repository.clearAnalytics();
        final analytics = repository.getAnalytics();

        // Assert
        expect(analytics, isEmpty);
      });
    });

    group('needsBackgroundSync', () {
      test('should return true for sync check', () async {
        // Act
        final needsSync = await repository.needsBackgroundSync();

        // Assert
        expect(needsSync, isTrue);
      });
    });
  });
}
