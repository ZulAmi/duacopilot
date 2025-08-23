import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intelligent_cache_service.dart';
import '../models/cache_models.dart';
import '../services/analytics_service.dart';
import '../../../domain/entities/rag_response.dart';

/// Provider for the intelligent cache service
final intelligentCacheServiceProvider = Provider<IntelligentCacheService>((
  ref,
) {
  return IntelligentCacheService.instance;
});

/// State notifier for cache metrics and monitoring
class CacheMetricsNotifier extends StateNotifier<CacheMetrics> {
  final IntelligentCacheService _cacheService;

  CacheMetricsNotifier(this._cacheService) : super(_getInitialMetrics());

  static CacheMetrics _getInitialMetrics() {
    return const CacheMetrics(
      hitCount: 0,
      missCount: 0,
      evictionCount: 0,
      hitRatio: 0.0,
      averageCompressionRatio: 1.0,
      averageRetrievalTime: Duration.zero,
      totalSize: 0,
      entryCount: 0,
      strategyUsage: {},
      strategyPerformance: {},
    );
  }

  /// Update metrics from cache service
  void updateMetrics() {
    state = _cacheService.getMetrics();
  }

  /// Refresh metrics periodically
  void startMetricsRefresh() {
    // Update metrics every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (_) {
      updateMetrics();
    });
  }
}

/// Provider for cache metrics
final cacheMetricsProvider =
    StateNotifierProvider<CacheMetricsNotifier, CacheMetrics>((ref) {
      final cacheService = ref.read(intelligentCacheServiceProvider);
      final notifier = CacheMetricsNotifier(cacheService);
      notifier.startMetricsRefresh();
      return notifier;
    });

/// Cache analytics provider
class CacheAnalyticsNotifier extends StateNotifier<CacheAnalyticsSummary?> {
  CacheAnalyticsNotifier() : super(null);

  /// Get analytics summary
  void loadAnalytics() {
    try {
      final summary = CacheAnalyticsService.getAnalyticsSummary();
      state = summary;
    } catch (e) {
      // Handle error
      state = null;
    }
  }

  /// Refresh analytics data
  void refreshAnalytics() {
    loadAnalytics();
  }
}

/// Provider for cache analytics
final cacheAnalyticsProvider =
    StateNotifierProvider<CacheAnalyticsNotifier, CacheAnalyticsSummary?>((
      ref,
    ) {
      final notifier = CacheAnalyticsNotifier();
      notifier.loadAnalytics();
      return notifier;
    });

/// Cache operation provider for UI actions
class CacheOperationsNotifier extends StateNotifier<CacheOperationState> {
  final IntelligentCacheService _cacheService;

  CacheOperationsNotifier(this._cacheService)
    : super(const CacheOperationState());

  /// Clear all cache
  Future<void> clearAllCache() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cacheService.invalidateAll(reason: 'User requested clear all');
      state = state.copyWith(
        isLoading: false,
        lastOperation: 'Clear all cache completed',
        operationTimestamp: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Invalidate cache by pattern
  Future<void> invalidateByPattern(String pattern) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cacheService.invalidate(
        pattern: pattern,
        reason: 'User pattern invalidation: $pattern',
      );
      state = state.copyWith(
        isLoading: false,
        lastOperation: 'Invalidated entries matching: $pattern',
        operationTimestamp: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Invalidate cache by query type
  Future<void> invalidateByQueryType(QueryType queryType) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cacheService.invalidate(
        queryType: queryType,
        reason: 'User query type invalidation: ${queryType.name}',
      );
      state = state.copyWith(
        isLoading: false,
        lastOperation: 'Invalidated ${queryType.name} cache entries',
        operationTimestamp: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Invalidate cache by language
  Future<void> invalidateByLanguage(String language) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cacheService.invalidate(
        language: language,
        reason: 'User language invalidation: $language',
      );
      state = state.copyWith(
        isLoading: false,
        lastOperation: 'Invalidated $language cache entries',
        operationTimestamp: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Prewarm cache with popular queries
  Future<void> prewarmCache({int? limit}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cacheService.prewarmCache(queryLimit: limit);
      state = state.copyWith(
        isLoading: false,
        lastOperation: 'Cache prewarming completed',
        operationTimestamp: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Handle model update
  Future<void> handleModelUpdate({
    required String modelVersion,
    List<String>? affectedDomains,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cacheService.handleModelUpdate(
        modelVersion: modelVersion,
        affectedDomains: affectedDomains,
      );
      state = state.copyWith(
        isLoading: false,
        lastOperation: 'Model update processed: $modelVersion',
        operationTimestamp: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear operation state
  void clearState() {
    state = const CacheOperationState();
  }
}

/// Cache operation state
class CacheOperationState {
  final bool isLoading;
  final String? error;
  final String? lastOperation;
  final DateTime? operationTimestamp;

  const CacheOperationState({
    this.isLoading = false,
    this.error,
    this.lastOperation,
    this.operationTimestamp,
  });

  CacheOperationState copyWith({
    bool? isLoading,
    String? error,
    String? lastOperation,
    DateTime? operationTimestamp,
  }) {
    return CacheOperationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastOperation: lastOperation ?? this.lastOperation,
      operationTimestamp: operationTimestamp ?? this.operationTimestamp,
    );
  }
}

/// Provider for cache operations
final cacheOperationsProvider =
    StateNotifierProvider<CacheOperationsNotifier, CacheOperationState>((ref) {
      final cacheService = ref.read(intelligentCacheServiceProvider);
      return CacheOperationsNotifier(cacheService);
    });

/// Popular queries provider
final popularQueriesProvider =
    FutureProvider.family<List<PopularQuery>, PopularQueriesRequest>((
      ref,
      request,
    ) async {
      return CacheAnalyticsService.getPopularQueries(
        limit: request.limit,
        language: request.language,
        queryType: request.queryType,
      );
    });

/// Trending queries provider
final trendingQueriesProvider =
    FutureProvider.family<List<TrendingQuery>, TrendingQueriesRequest>((
      ref,
      request,
    ) async {
      return CacheAnalyticsService.getTrendingQueries(
        limit: request.limit,
        trendWindow: request.trendWindow,
      );
    });

/// Cache performance provider
final cachePerformanceProvider = FutureProvider.family<
  CachePerformanceMetrics,
  Duration?
>((ref, timeWindow) async {
  return CacheAnalyticsService.getPerformanceMetrics(timeWindow: timeWindow);
});

// Request classes for parameterized providers

/// PopularQueriesRequest class implementation
class PopularQueriesRequest {
  final int limit;
  final String? language;
  final QueryType? queryType;

  const PopularQueriesRequest({this.limit = 50, this.language, this.queryType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularQueriesRequest &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          language == other.language &&
          queryType == other.queryType;

  @override
  int get hashCode => limit.hashCode ^ language.hashCode ^ queryType.hashCode;
}

/// TrendingQueriesRequest class implementation
class TrendingQueriesRequest {
  final int limit;
  final Duration trendWindow;

  const TrendingQueriesRequest({
    this.limit = 20,
    this.trendWindow = const Duration(days: 7),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendingQueriesRequest &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          trendWindow == other.trendWindow;

  @override
  int get hashCode => limit.hashCode ^ trendWindow.hashCode;
}

/// Extension methods for easier cache integration
extension RagProviderCacheExtension on Ref {
  /// Get cached RAG response
  Future<RagResponse?> getCachedResponse({
    required String query,
    required String language,
    QueryType? queryType,
  }) async {
    final cacheService = read(intelligentCacheServiceProvider);
    return await cacheService.retrieve(
      query: query,
      language: language,
      queryType: queryType,
    );
  }

  /// Store RAG response in cache
  Future<void> cacheResponse({
    required String query,
    required String language,
    required RagResponse response,
    QueryType? queryType,
    Map<String, dynamic>? metadata,
  }) async {
    final cacheService = read(intelligentCacheServiceProvider);
    await cacheService.store(
      query: query,
      language: language,
      data: response,
      queryType: queryType,
      metadata: metadata,
    );
  }
}

/// Cache initialization provider
final cacheInitializationProvider = FutureProvider<bool>((ref) async {
  final cacheService = ref.read(intelligentCacheServiceProvider);
  await cacheService.initialize();
  return true;
});
