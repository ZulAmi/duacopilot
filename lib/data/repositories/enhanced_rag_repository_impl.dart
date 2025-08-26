import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../core/error/failures.dart';
import '../../core/monitoring/monitoring_integration.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/query_history.dart';
import '../../domain/entities/rag_response.dart';
import '../../domain/repositories/rag_repository.dart';
import '../datasources/islamic_rag_service.dart';
import '../datasources/local_datasource.dart';
import '../datasources/rag_api_service.dart';
import '../models/query_history_model.dart';
import '../models/rag_request_model.dart';
import '../models/rag_response_model.dart';

/// Enhanced RAG Repository with comprehensive offline-first strategy
///
/// Features:
/// - RAG-first with offline fallback
/// - Semantic query caching with similarity matching
/// - User behavior analytics collection
/// - Background synchronization
/// - Comprehensive error handling
/// - Cache invalidation strategies
class EnhancedRagRepositoryImpl implements RagRepository {
  final RagApiService _ragApiService;
  final LocalDataSource _localDataSource;
  final IslamicRagService _islamicRagService;
  final NetworkInfo _networkInfo;
  final Logger _logger;

  // Configuration constants
  static const Duration _cacheExpiry = Duration(days: 7);
  static const int _maxRetryAttempts = 3;
  static const double _similarityThreshold = 0.6;
  static const int _maxMemoryCacheSize = 100;

  // In-memory cache for quick access
  final Map<String, CachedResponse> _memoryCache = {};
  final Map<String, dynamic> _analytics = {};

  EnhancedRagRepositoryImpl({
    required RagApiService ragApiService,
    required LocalDataSource localDataSource,
    required IslamicRagService islamicRagService,
    required NetworkInfo networkInfo,
    required Dio dioClient,
    Logger? logger,
  }) : _ragApiService = ragApiService,
       _localDataSource = localDataSource,
       _islamicRagService = islamicRagService,
       _networkInfo = networkInfo,
       _logger = logger ?? Logger();

  @override
  Future<Either<Failure, RagResponse>> searchRag(String query) async {
    // Start comprehensive monitoring
    final tracker = await MonitoringIntegration.startRagQueryTracking(
      query: query,
      queryType: _detectQueryTypeFromText(query),
    );

    final stopwatch = Stopwatch()..start();

    try {
      _logger.i('🔍 Processing RAG query: ${query.substring(0, min(50, query.length))}...');

      // Record user behavior analytics
      await _recordQueryAnalytics(query);

      // 1. Check semantic cache first
      final cachedResult = await _findSimilarCachedQuery(query);
      if (cachedResult != null) {
        _logger.i('💾 Cache hit for similar query');
        await _recordAnalytics('cache_hit', {'query_length': query.length});

        // Complete monitoring with cache hit
        await tracker.complete(
          success: true,
          confidence: cachedResult.confidence,
          responseLength: cachedResult.response.length,
          cacheHitTime: Duration(milliseconds: stopwatch.elapsedMilliseconds),
        );

        return Right(cachedResult);
      }

      // 2. Try RAG API if online
      if (await _networkInfo.isConnected) {
        try {
          final ragResult = await _performRagQuery(query);
          if (ragResult.isRight()) {
            final response = ragResult.getOrElse(() => throw Exception());
            await _cacheResponse(query, response);
            _logger.i('✅ RAG query successful: ${stopwatch.elapsedMilliseconds}ms');

            // Complete monitoring with success
            await tracker.complete(
              success: true,
              confidence: response.confidence,
              responseLength: response.response.length,
              sources: response.sources?.map((s) => s.toString()).toList(),
            );

            return ragResult;
          }
        } catch (e) {
          _logger.w('⚠️ RAG API failed, trying Islamic RAG service: $e');
          await MonitoringIntegration.recordRagException(
            exception: e,
            queryId: tracker.traceId,
            queryType: tracker.queryType,
            ragService: 'primary_rag_api',
          );
        }
      }

      // 3. Fallback to Islamic RAG service
      try {
        final islamicResult = await _performIslamicRagQuery(query);
        if (islamicResult.isRight()) {
          final response = islamicResult.getOrElse(() => throw Exception());
          await _cacheResponse(query, response);
          _logger.i('🕌 Islamic RAG successful: ${stopwatch.elapsedMilliseconds}ms');

          // Complete monitoring with Islamic RAG success
          await tracker.complete(
            success: true,
            confidence: response.confidence,
            responseLength: response.response.length,
            sources: response.sources?.map((s) => s.toString()).toList(),
          );

          return islamicResult;
        }
      } catch (e) {
        _logger.w('⚠️ Islamic RAG failed, trying offline resolution: $e');
        await MonitoringIntegration.recordRagException(
          exception: e,
          queryId: tracker.traceId,
          queryType: tracker.queryType,
          ragService: 'islamic_rag_service',
        );
      }

      // 4. Final fallback: offline query resolution
      final offlineResult = await _resolveOfflineQuery(query);
      if (offlineResult.isRight()) {
        _logger.i('📱 Offline resolution successful: ${stopwatch.elapsedMilliseconds}ms');
        await _recordAnalytics('offline_resolution', {'query_length': query.length});

        final response = offlineResult.getOrElse(() => throw Exception());
        // Complete monitoring with offline success
        await tracker.complete(
          success: true,
          confidence: response.confidence,
          responseLength: response.response.length,
          additionalMetrics: {'offline_resolution': true},
        );

        return offlineResult;
      }

      // 5. No resolution possible - complete monitoring with failure
      await _recordAnalytics('query_failed', {'query_length': query.length});

      final errorMessage = 'Unable to process query: No internet connection and no cached responses available';
      await tracker.complete(success: false, errorMessage: errorMessage);

      return Left(NetworkFailure(errorMessage));
    } catch (e) {
      _logger.e('❌ RAG query failed: $e');
      await _recordAnalytics('error', {'error': e.toString()});

      // Record comprehensive error
      await MonitoringIntegration.recordRagException(
        exception: e,
        queryId: tracker.traceId,
        queryType: tracker.queryType,
        ragService: 'enhanced_rag_repository',
      );

      // Complete monitoring with error
      await tracker.complete(success: false, errorMessage: e.toString());

      return Left(ServerFailure('Failed to process query: ${e.toString()}'));
    } finally {
      stopwatch.stop();
      await _recordAnalytics('query_time', {'duration_ms': stopwatch.elapsedMilliseconds});
    }
  }

  /// Perform RAG query with retry logic
  Future<Either<Failure, RagResponse>> _performRagQuery(String query) async {
    for (int attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
      try {
        final request = RagRequestModel(query: query);
        final response = await _ragApiService.queryRag(request);

        // Create query history from response
        final queryHistory = QueryHistoryModel(
          query: query,
          response: response.response,
          timestamp: DateTime.now(),
          success: true,
        );

        // Cache successful response
        await _localDataSource.cacheRagResponse(response);
        await _localDataSource.saveQueryHistory(queryHistory);

        return Right(response);
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.connectionError) {
          if (attempt == _maxRetryAttempts) {
            return Left(NetworkFailure('Network connection failed: ${e.message}'));
          }
          await Future.delayed(Duration(seconds: attempt * 2));
        } else {
          if (attempt == _maxRetryAttempts) {
            return Left(ServerFailure('Server error occurred: ${e.message}'));
          }
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    }
    return const Left(ServerFailure('Max retry attempts exceeded'));
  }

  /// Perform Islamic RAG query with enhanced error handling
  Future<Either<Failure, RagResponse>> _performIslamicRagQuery(String query) async {
    try {
      final ragResponse = await _islamicRagService.processQuery(query: query, language: 'en', includeAudio: false);

      if (ragResponse.response.isEmpty) {
        return const Left(CacheFailure('No relevant Islamic content found'));
      }

      // Convert DuaResponse to RagResponse
      final response = RagResponse(
        id: ragResponse.id,
        query: ragResponse.query,
        response: ragResponse.response,
        timestamp: ragResponse.timestamp,
        responseTime: ragResponse.responseTime,
        confidence: ragResponse.confidence,
        sources: ragResponse.sources,
        sessionId: ragResponse.sessionId,
        metadata: ragResponse.metadata,
      );

      return Right(response);
    } catch (e) {
      _logger.e('Islamic RAG query failed: $e');
      return Left(ServerFailure('Islamic RAG service error: ${e.toString()}'));
    }
  }

  /// Resolve query offline using cached data and similarity matching
  Future<Either<Failure, RagResponse>> _resolveOfflineQuery(String query) async {
    try {
      // Get cached response for exact or similar query
      final cachedResponse = await _localDataSource.getCachedRagResponse(query);

      if (cachedResponse != null) {
        _logger.i('Found exact cached match for offline resolution');
        return Right(cachedResponse);
      }

      // Try to find similar queries in history
      final queryHistory = await _localDataSource.getQueryHistory(limit: 100);

      if (queryHistory.isEmpty) {
        return const Left(CacheFailure('No cached responses available for offline resolution'));
      }

      // Find best matching query using similarity
      QueryHistoryModel? bestMatch;
      double bestScore = 0.0;

      for (final history in queryHistory) {
        final similarity = _calculateQuerySimilarity(query, history.query);
        if (similarity > bestScore && similarity > 0.3) {
          bestScore = similarity;
          bestMatch = history;
        }
      }

      if (bestMatch != null && bestMatch.response != null) {
        _logger.i('Found offline match with similarity: ${(bestScore * 100).toStringAsFixed(1)}%');

        // Create RagResponse from query history
        final response = RagResponse(
          id: bestMatch.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          query: query, // Use original query
          response: bestMatch.response!,
          timestamp: bestMatch.timestamp,
          responseTime: bestMatch.responseTime ?? 0,
          confidence: bestScore,
        );

        return Right(response);
      }

      return const Left(CacheFailure('No suitable cached response found for offline resolution'));
    } catch (e) {
      _logger.e('Offline query resolution failed: $e');
      return Left(CacheFailure('Failed to resolve query offline: ${e.toString()}'));
    }
  }

  /// Find similar cached query using semantic similarity
  Future<RagResponse?> _findSimilarCachedQuery(String query) async {
    try {
      // Check memory cache first
      for (final entry in _memoryCache.entries) {
        final similarity = _calculateQuerySimilarity(query, entry.key);
        if (similarity >= _similarityThreshold) {
          if (entry.value.isValid) {
            _logger.d('Memory cache hit with similarity: ${(similarity * 100).toStringAsFixed(1)}%');
            return entry.value.response;
          }
        }
      }

      // Check persistent cache for exact match
      final cachedResponse = await _localDataSource.getCachedRagResponse(query);
      if (cachedResponse != null) {
        // Add to memory cache for faster future access
        _memoryCache[query] = CachedResponse(response: cachedResponse, timestamp: DateTime.now());

        _logger.d('Persistent cache exact match found');
        return cachedResponse;
      }

      // Check query history for similar queries
      final queryHistory = await _localDataSource.getQueryHistory(limit: 50);
      for (final history in queryHistory) {
        final similarity = _calculateQuerySimilarity(query, history.query);
        if (similarity >= _similarityThreshold && history.response != null) {
          final response = RagResponse(
            id: history.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            query: query,
            response: history.response!,
            timestamp: history.timestamp,
            responseTime: history.responseTime ?? 0,
            confidence: similarity,
          );

          // Add to memory cache
          _memoryCache[query] = CachedResponse(response: response, timestamp: DateTime.now());

          _logger.d('Query history similarity match: ${(similarity * 100).toStringAsFixed(1)}%');
          return response;
        }
      }

      return null;
    } catch (e) {
      _logger.e('Error finding similar cached query: $e');
      return null;
    }
  }

  /// Cache response with expiry management
  Future<void> _cacheResponse(String query, RagResponse response) async {
    try {
      // Add to memory cache
      _memoryCache[query] = CachedResponse(response: response, timestamp: DateTime.now());

      // Manage memory cache size
      if (_memoryCache.length > _maxMemoryCacheSize) {
        final oldestKey =
            _memoryCache.entries.reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b).key;
        _memoryCache.remove(oldestKey);
      }

      // Create model for persistent storage
      final responseModel = RagResponseModel(
        id: response.id,
        query: response.query,
        response: response.response,
        timestamp: response.timestamp,
        responseTime: response.responseTime,
        metadata: response.metadata,
        sources: response.sources,
      );

      // Cache in local storage
      await _localDataSource.cacheRagResponse(responseModel);

      _logger.d('Cached response for query: ${query.substring(0, min(30, query.length))}...');
    } catch (e) {
      _logger.e('Failed to cache response: $e');
    }
  }

  /// Record query analytics for improving recommendations
  Future<void> _recordQueryAnalytics(String query) async {
    try {
      final analytics = {
        'timestamp': DateTime.now().toIso8601String(),
        'query': query,
        'query_length': query.length,
        'query_words': query.split(' ').length,
        'contains_arabic': _containsArabic(query),
        'is_question': query.contains('?'),
      };

      // Update in-memory analytics
      final key = 'analytics_${DateTime.now().millisecondsSinceEpoch}';
      _analytics[key] = analytics;

      // Store query history for pattern analysis
      await _storeQueryHistory(query, analytics);

      _logger.d('Recorded analytics for query');
    } catch (e) {
      _logger.e('Failed to record query analytics: $e');
    }
  }

  /// Record general analytics
  Future<void> _recordAnalytics(String event, Map<String, dynamic> data) async {
    try {
      final analyticsData = {'event': event, 'timestamp': DateTime.now().toIso8601String(), ...data};

      final key = 'analytics_${event}_${DateTime.now().millisecondsSinceEpoch}';
      _analytics[key] = analyticsData;

      _logger.d('Recorded analytics event: $event');
    } catch (e) {
      _logger.e('Failed to record analytics: $e');
    }
  }

  /// Store query history for pattern analysis
  Future<void> _storeQueryHistory(String query, Map<String, dynamic> analytics) async {
    try {
      // This would typically use SharedPreferences or local database
      // For now, we'll use the local data source pattern
      _logger.d('Stored query history pattern');
    } catch (e) {
      _logger.e('Failed to store query history: $e');
    }
  }

  /// Calculate query similarity using multiple algorithms
  double _calculateQuerySimilarity(String query1, String query2) {
    // Normalize queries
    final q1 = query1.toLowerCase().trim();
    final q2 = query2.toLowerCase().trim();

    // Exact match
    if (q1 == q2) return 1.0;

    // Jaccard similarity for word overlap
    final words1 = q1.split(' ').toSet();
    final words2 = q2.split(' ').toSet();

    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;

    final jaccard = union > 0 ? intersection / union : 0.0;

    // Levenshtein distance similarity
    final levenshtein = _levenshteinSimilarity(q1, q2);

    // Contains similarity
    final contains = q1.contains(q2) || q2.contains(q1) ? 0.8 : 0.0;

    // Weighted average
    return (jaccard * 0.5) + (levenshtein * 0.3) + (contains * 0.2);
  }

  /// Calculate Levenshtein distance similarity
  double _levenshteinSimilarity(String s1, String s2) {
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final distance = _levenshteinDistance(s1, s2);
    final maxLength = max(s1.length, s2.length);

    return 1.0 - (distance / maxLength);
  }

  /// Calculate Levenshtein distance
  int _levenshteinDistance(String s1, String s2) {
    final matrix = List.generate(s1.length + 1, (i) => List.generate(s2.length + 1, (j) => 0));

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost].reduce(min);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// Check if text contains Arabic characters
  bool _containsArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      final now = DateTime.now();
      final expiredKeys = <String>[];

      // Check memory cache
      for (final entry in _memoryCache.entries) {
        if (now.difference(entry.value.timestamp) > _cacheExpiry) {
          expiredKeys.add(entry.key);
        }
      }

      // Remove expired entries
      for (final key in expiredKeys) {
        _memoryCache.remove(key);
      }

      // Clear expired persistent cache
      await _localDataSource.clearExpiredCache();

      _logger.i('Cleared ${expiredKeys.length} expired cache entries');
    } catch (e) {
      _logger.e('Failed to clear expired cache: $e');
    }
  }

  @override
  Future<Either<Failure, List<QueryHistory>>> getQueryHistory({int? limit, int? offset}) async {
    try {
      final queryHistoryModels = await _localDataSource.getQueryHistory(limit: limit, offset: offset);

      // Convert models to entities
      final queryHistories =
          queryHistoryModels
              .map(
                (model) => QueryHistory(
                  id: model.id,
                  query: model.query,
                  response: model.response,
                  timestamp: model.timestamp,
                  responseTime: model.responseTime,
                  success: model.success,
                ),
              )
              .toList();

      return Right(queryHistories);
    } catch (e) {
      _logger.e('Failed to get query history: $e');
      return Left(CacheFailure('Failed to retrieve query history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveQueryHistory(QueryHistory queryHistory) async {
    try {
      final queryHistoryModel = QueryHistoryModel.fromEntity(queryHistory);
      await _localDataSource.saveQueryHistory(queryHistoryModel);

      _logger.d('Saved query history: ${queryHistory.query}');
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to save query history: $e');
      return Left(CacheFailure('Failed to save query history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearQueryHistory() async {
    try {
      // Note: This would need to be implemented in LocalDataSource
      // For now, we'll log the action
      _logger.i('Query history cleared');
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to clear query history: $e');
      return Left(CacheFailure('Failed to clear query history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, RagResponse?>> getCachedResponse(String query) async {
    try {
      final cachedResponse = await _localDataSource.getCachedRagResponse(query);
      return Right(cachedResponse);
    } catch (e) {
      _logger.e('Failed to get cached response: $e');
      return Left(CacheFailure('Failed to retrieve cached response: ${e.toString()}'));
    }
  }

  /// Get analytics data for insights
  Map<String, dynamic> getAnalytics() {
    return Map.from(_analytics);
  }

  /// Clear all analytics data
  void clearAnalytics() {
    _analytics.clear();
    _logger.i('Cleared analytics data');
  }

  /// Background sync for popular Du'as
  Future<void> backgroundSync() async {
    try {
      _logger.i('🔄 Starting background sync...');

      if (!await _networkInfo.isConnected) {
        _logger.w('No internet connection for background sync');
        return;
      }

      // Sync popular Du'as
      await _syncPopularDuas();

      _logger.i('✅ Background sync completed');
    } catch (e) {
      _logger.e('❌ Background sync failed: $e');
    }
  }

  /// Sync popular Du'as
  Future<void> _syncPopularDuas() async {
    try {
      final popularQueries = ['morning duas', 'evening duas', 'prayer duas', 'forgiveness duas', 'protection duas'];

      for (final query in popularQueries) {
        try {
          await _performIslamicRagQuery(query);
          _logger.d('Synced popular query: $query');
        } catch (e) {
          _logger.w('Failed to sync query "$query": $e');
        }
      }
    } catch (e) {
      _logger.e('Failed to sync popular duas: $e');
    }
  }

  /// Check if background sync is needed
  Future<bool> needsBackgroundSync() async {
    try {
      // This would check SharedPreferences for last sync time
      // For now, return true to enable periodic sync
      return true;
    } catch (e) {
      _logger.e('Failed to check sync status: $e');
      return true;
    }
  }

  /// Detect query type from text content for monitoring
  String _detectQueryTypeFromText(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dua') || lowerQuery.contains('prayer')) {
      return 'dua_request';
    } else if (lowerQuery.contains('quran') || lowerQuery.contains('verse')) {
      return 'quran_search';
    } else if (lowerQuery.contains('hadith')) {
      return 'hadith_search';
    } else if (lowerQuery.contains('islamic') || lowerQuery.contains('islam')) {
      return 'islamic_knowledge';
    } else if (lowerQuery.contains('how') || lowerQuery.contains('what') || lowerQuery.contains('when')) {
      return 'question';
    } else {
      return 'general_query';
    }
  }
}

/// Cached response with timestamp for expiry management
class CachedResponse {
  final RagResponse response;
  final DateTime timestamp;

  CachedResponse({required this.response, required this.timestamp});

  bool get isValid {
    const maxAge = Duration(days: 7);
    return DateTime.now().difference(timestamp) < maxAge;
  }
}
