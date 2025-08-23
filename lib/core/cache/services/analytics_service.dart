import 'package:duacopilot/core/logging/app_logger.dart';

import 'dart:async';
import 'dart:collection';
// Note: Firebase Analytics will be added when firebase_analytics package is available
// import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/cache_models.dart';

// Mock Firebase Analytics for development
/// MockFirebaseAnalytics class implementation
class MockFirebaseAnalytics {
  static final MockFirebaseAnalytics instance = MockFirebaseAnalytics();

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    // In development, just print to console
    AppLogger.debug('Analytics Event: $name - $parameters');
  }
}

/// Analytics service for cache performance and popular query tracking
class CacheAnalyticsService {
  static final MockFirebaseAnalytics _analytics =
      MockFirebaseAnalytics.instance;

  // In-memory analytics data
  static final Map<String, QueryAnalytics> _queryAnalytics = {};
  static final Queue<CacheEvent> _eventQueue = Queue();
  static final Map<String, int> _popularQueries = {};

  // Configuration
  static const int maxEventQueueSize = 1000;
  static const int popularQueryThreshold = 5;
  static const Duration analyticsFlushInterval = Duration(minutes: 5);

  static Timer? _flushTimer;

  /// Initialize analytics service
  static void initialize() {
    _startPeriodicFlush();
  }

  /// Record cache hit event
  static void recordCacheHit(
    String query,
    String language,
    QueryType queryType,
    Duration retrievalTime,
    String strategy,
  ) {
    _recordEvent(
      CacheEvent(
        type: CacheEventType.hit,
        query: query,
        language: language,
        queryType: queryType,
        timestamp: DateTime.now(),
        retrievalTime: retrievalTime,
        strategy: strategy,
      ),
    );

    _updateQueryAnalytics(query, language, true, retrievalTime);
    _incrementPopularQuery(query);

    // Firebase Analytics event
    _analytics.logEvent(
      name: 'cache_hit',
      parameters: {
        'query_type': queryType.name,
        'language': language,
        'retrieval_time_ms': retrievalTime.inMilliseconds,
        'strategy': strategy,
      },
    );
  }

  /// Record cache miss event
  static void recordCacheMiss(
    String query,
    String language,
    QueryType queryType,
    Duration apiCallTime,
    String strategy,
  ) {
    _recordEvent(
      CacheEvent(
        type: CacheEventType.miss,
        query: query,
        language: language,
        queryType: queryType,
        timestamp: DateTime.now(),
        apiCallTime: apiCallTime,
        strategy: strategy,
      ),
    );

    _updateQueryAnalytics(query, language, false, apiCallTime);

    // Firebase Analytics event
    _analytics.logEvent(
      name: 'cache_miss',
      parameters: {
        'query_type': queryType.name,
        'language': language,
        'api_call_time_ms': apiCallTime.inMilliseconds,
        'strategy': strategy,
      },
    );
  }

  /// Record cache eviction event
  static void recordCacheEviction(
    String key,
    String strategy,
    EvictionPolicy policy,
    String reason,
  ) {
    _recordEvent(
      CacheEvent(
        type: CacheEventType.eviction,
        key: key,
        strategy: strategy,
        evictionPolicy: policy,
        reason: reason,
        timestamp: DateTime.now(),
      ),
    );

    // Firebase Analytics event
    _analytics.logEvent(
      name: 'cache_eviction',
      parameters: {
        'strategy': strategy,
        'policy': policy.name,
        'reason': reason,
      },
    );
  }

  /// Record cache prewarming event
  static void recordPrewarming(
    List<String> queries,
    String strategy,
    Duration totalTime,
    int successCount,
    int failureCount,
  ) {
    _recordEvent(
      CacheEvent(
        type: CacheEventType.prewarming,
        prewarmingQueries: queries,
        strategy: strategy,
        prewarmingTime: totalTime,
        prewarmingSuccess: successCount,
        prewarmingFailures: failureCount,
        timestamp: DateTime.now(),
      ),
    );

    // Firebase Analytics event
    _analytics.logEvent(
      name: 'cache_prewarming',
      parameters: {
        'strategy': strategy,
        'query_count': queries.length,
        'total_time_ms': totalTime.inMilliseconds,
        'success_count': successCount,
        'failure_count': failureCount,
        'success_rate': successCount / queries.length,
      },
    );
  }

  /// Record cache invalidation event
  static void recordInvalidation(CacheInvalidationEvent event) {
    _recordEvent(
      CacheEvent(
        type: CacheEventType.invalidation,
        invalidationEvent: event,
        timestamp: DateTime.now(),
      ),
    );

    // Firebase Analytics event
    _analytics.logEvent(
      name: 'cache_invalidation',
      parameters: {
        'event_type': event.eventType,
        'affected_count': event.affectedKeys.length,
        'reason': event.reason,
      },
    );
  }

  /// Get popular queries for prewarming
  static List<PopularQuery> getPopularQueries({
    int limit = 50,
    String? language,
    QueryType? queryType,
  }) {
    var queries =
        _queryAnalytics.values
            .where(
              (analytics) => analytics.accessCount >= popularQueryThreshold,
            )
            .toList();

    // Filter by language if specified
    if (language != null) {
      queries = queries.where((q) => q.language == language).toList();
    }

    // Filter by query type if specified
    if (queryType != null) {
      queries = queries.where((q) => q.queryType == queryType).toList();
    }

    // Sort by popularity score (combination of access count and recency)
    queries.sort((a, b) {
      final scoreA = _calculatePopularityScore(a);
      final scoreB = _calculatePopularityScore(b);
      return scoreB.compareTo(scoreA);
    });

    return queries
        .take(limit)
        .map(
          (analytics) => PopularQuery(
            query: analytics.query,
            language: analytics.language,
            queryType: analytics.queryType,
            accessCount: analytics.accessCount,
            lastAccessed: analytics.lastAccessed,
            averageRetrievalTime: analytics.averageRetrievalTime,
            cacheHitRatio: analytics.cacheHitRatio,
            popularityScore: _calculatePopularityScore(analytics),
          ),
        )
        .toList();
  }

  /// Get cache performance metrics
  static CachePerformanceMetrics getPerformanceMetrics({Duration? timeWindow}) {
    final cutoffTime =
        timeWindow != null
            ? DateTime.now().subtract(timeWindow)
            : DateTime.fromMillisecondsSinceEpoch(0);

    final relevantEvents =
        _eventQueue
            .where((event) => event.timestamp.isAfter(cutoffTime))
            .toList();

    final hitEvents =
        relevantEvents.where((e) => e.type == CacheEventType.hit).toList();

    final missEvents =
        relevantEvents.where((e) => e.type == CacheEventType.miss).toList();

    final totalRequests = hitEvents.length + missEvents.length;
    final hitRatio = totalRequests > 0 ? hitEvents.length / totalRequests : 0.0;

    final averageHitTime =
        hitEvents.isNotEmpty
            ? Duration(
              microseconds:
                  hitEvents
                      .map((e) => e.retrievalTime?.inMicroseconds ?? 0)
                      .reduce((a, b) => a + b) ~/
                  hitEvents.length,
            )
            : Duration.zero;

    final averageMissTime =
        missEvents.isNotEmpty
            ? Duration(
              microseconds:
                  missEvents
                      .map((e) => e.apiCallTime?.inMicroseconds ?? 0)
                      .reduce((a, b) => a + b) ~/
                  missEvents.length,
            )
            : Duration.zero;

    // Calculate strategy performance
    final strategyPerformance = <String, StrategyPerformance>{};
    final strategyCounts = <String, Map<String, int>>{};

    for (final event in relevantEvents) {
      if (event.strategy == null) continue;

      strategyCounts.putIfAbsent(
        event.strategy!,
        () => {'hits': 0, 'misses': 0},
      );

      if (event.type == CacheEventType.hit) {
        strategyCounts[event.strategy!]!['hits'] =
            strategyCounts[event.strategy!]!['hits']! + 1;
      } else if (event.type == CacheEventType.miss) {
        strategyCounts[event.strategy!]!['misses'] =
            strategyCounts[event.strategy!]!['misses']! + 1;
      }
    }

    for (final entry in strategyCounts.entries) {
      final strategy = entry.key;
      final counts = entry.value;
      final hits = counts['hits']!;
      final misses = counts['misses']!;
      final total = hits + misses;

      strategyPerformance[strategy] = StrategyPerformance(
        strategyName: strategy,
        hitCount: hits,
        missCount: misses,
        hitRatio: total > 0 ? hits / total : 0.0,
      );
    }

    return CachePerformanceMetrics(
      totalRequests: totalRequests,
      hitCount: hitEvents.length,
      missCount: missEvents.length,
      hitRatio: hitRatio,
      averageHitTime: averageHitTime,
      averageMissTime: averageMissTime,
      timeWindow: timeWindow,
      strategyPerformance: strategyPerformance,
    );
  }

  /// Get trending queries (queries with increasing popularity)
  static List<TrendingQuery> getTrendingQueries({
    int limit = 20,
    Duration trendWindow = const Duration(days: 7),
  }) {
    final cutoffTime = DateTime.now().subtract(trendWindow);

    final trendingQueries = <String, TrendData>{};

    for (final event in _eventQueue) {
      if (event.timestamp.isBefore(cutoffTime) || event.query == null) continue;

      final query = event.query!;
      trendingQueries.putIfAbsent(query, () => TrendData());

      // Count accesses by day
      final dayKey =
          '${event.timestamp.year}-${event.timestamp.month}-${event.timestamp.day}';
      trendingQueries[query]!.dailyCounts.putIfAbsent(dayKey, () => 0);
      trendingQueries[query]!.dailyCounts[dayKey] =
          trendingQueries[query]!.dailyCounts[dayKey]! + 1;
    }

    // Calculate trends
    final trends = <TrendingQuery>[];

    for (final entry in trendingQueries.entries) {
      final query = entry.key;
      final trendData = entry.value;

      final trend = _calculateTrend(trendData.dailyCounts);

      if (trend.isIncreasing) {
        trends.add(
          TrendingQuery(
            query: query,
            trendScore: trend.score,
            dailyGrowthRate: trend.growthRate,
            totalAccesses: trendData.dailyCounts.values.reduce((a, b) => a + b),
          ),
        );
      }
    }

    trends.sort((a, b) => b.trendScore.compareTo(a.trendScore));

    return trends.take(limit).toList();
  }

  /// Log custom cache event
  static void logCustomEvent(String eventName, Map<String, Object> parameters) {
    _analytics.logEvent(
      name: 'cache_custom_$eventName',
      parameters: parameters,
    );
  }

  /// Get analytics summary for dashboard
  static CacheAnalyticsSummary getAnalyticsSummary() {
    final performance = getPerformanceMetrics(timeWindow: Duration(hours: 24));

    final popularQueries = getPopularQueries(limit: 10);
    final trendingQueries = getTrendingQueries(limit: 5);

    return CacheAnalyticsSummary(
      performance: performance,
      popularQueries: popularQueries,
      trendingQueries: trendingQueries,
      totalUniqueQueries: _queryAnalytics.length,
      totalEvents: _eventQueue.length,
    );
  }

  /// Private helper methods

  static void _recordEvent(CacheEvent event) {
    _eventQueue.add(event);

    // Limit queue size
    while (_eventQueue.length > maxEventQueueSize) {
      _eventQueue.removeFirst();
    }
  }

  static void _updateQueryAnalytics(
    String query,
    String language,
    bool isHit,
    Duration responseTime,
  ) {
    final key = '$language:$query';

    _queryAnalytics.putIfAbsent(
      key,
      () => QueryAnalytics(
        query: query,
        language: language,
        queryType: _detectQueryType(query),
        firstSeen: DateTime.now(),
      ),
    );

    final analytics = _queryAnalytics[key]!;
    analytics.recordAccess(isHit, responseTime);
  }

  static void _incrementPopularQuery(String query) {
    _popularQueries[query] = (_popularQueries[query] ?? 0) + 1;
  }

  static QueryType _detectQueryType(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dua') || lowerQuery.contains('دعاء')) {
      return QueryType.dua;
    } else if (lowerQuery.contains('quran') || lowerQuery.contains('قرآن')) {
      return QueryType.quran;
    } else if (lowerQuery.contains('hadith') || lowerQuery.contains('حديث')) {
      return QueryType.hadith;
    } else if (lowerQuery.contains('prayer') || lowerQuery.contains('صلاة')) {
      return QueryType.prayer;
    } else if (lowerQuery.contains('fasting') || lowerQuery.contains('صوم')) {
      return QueryType.fasting;
    } else if (lowerQuery.contains('charity') || lowerQuery.contains('زكاة')) {
      return QueryType.charity;
    } else if (lowerQuery.contains('hajj') || lowerQuery.contains('حج')) {
      return QueryType.pilgrimage;
    }

    return QueryType.general;
  }

  static double _calculatePopularityScore(QueryAnalytics analytics) {
    final recencyBonus = _calculateRecencyBonus(analytics.lastAccessed);
    final frequencyScore = analytics.accessCount.toDouble();
    final performanceBonus = analytics.cacheHitRatio * 10;

    return (frequencyScore * 0.6) +
        (recencyBonus * 0.3) +
        (performanceBonus * 0.1);
  }

  static double _calculateRecencyBonus(DateTime lastAccessed) {
    final hoursSinceAccess = DateTime.now().difference(lastAccessed).inHours;
    return (24 - hoursSinceAccess.clamp(0, 24)) / 24 * 100;
  }

  static TrendCalculation _calculateTrend(Map<String, int> dailyCounts) {
    if (dailyCounts.length < 2) {
      return TrendCalculation(score: 0, growthRate: 0, isIncreasing: false);
    }

    final sortedEntries =
        dailyCounts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    final values = sortedEntries.map((e) => e.value.toDouble()).toList();

    // Simple linear regression for trend
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    final n = values.length;

    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += values[i];
      sumXY += i * values[i];
      sumX2 += i * i;
    }

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final isIncreasing = slope > 0;

    return TrendCalculation(
      score: slope.abs() * 100,
      growthRate: slope,
      isIncreasing: isIncreasing,
    );
  }

  static void _startPeriodicFlush() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(analyticsFlushInterval, (_) {
      _flushAnalytics();
    });
  }

  static void _flushAnalytics() {
    // Send aggregated analytics to Firebase
    final summary = getAnalyticsSummary();

    _analytics.logEvent(
      name: 'cache_analytics_flush',
      parameters: {
        'total_requests': summary.performance.totalRequests,
        'hit_ratio': summary.performance.hitRatio,
        'unique_queries': summary.totalUniqueQueries,
        'popular_query_count': summary.popularQueries.length,
        'trending_query_count': summary.trendingQueries.length,
      },
    );
  }

  /// Cleanup resources
  static void dispose() {
    _flushTimer?.cancel();
    _flushTimer = null;
  }
}

// Supporting classes and enums

enum CacheEventType { hit, miss, eviction, prewarming, invalidation }

/// CacheEvent class implementation
class CacheEvent {
  final CacheEventType type;
  final DateTime timestamp;
  final String? query;
  final String? language;
  final QueryType? queryType;
  final String? key;
  final String? strategy;
  final Duration? retrievalTime;
  final Duration? apiCallTime;
  final EvictionPolicy? evictionPolicy;
  final String? reason;
  final List<String>? prewarmingQueries;
  final Duration? prewarmingTime;
  final int? prewarmingSuccess;
  final int? prewarmingFailures;
  final CacheInvalidationEvent? invalidationEvent;

  CacheEvent({
    required this.type,
    required this.timestamp,
    this.query,
    this.language,
    this.queryType,
    this.key,
    this.strategy,
    this.retrievalTime,
    this.apiCallTime,
    this.evictionPolicy,
    this.reason,
    this.prewarmingQueries,
    this.prewarmingTime,
    this.prewarmingSuccess,
    this.prewarmingFailures,
    this.invalidationEvent,
  });
}

/// QueryAnalytics class implementation
class QueryAnalytics {
  final String query;
  final String language;
  final QueryType queryType;
  final DateTime firstSeen;

  int accessCount = 0;
  int hitCount = 0;
  int missCount = 0;
  DateTime lastAccessed;
  Duration totalRetrievalTime = Duration.zero;

  QueryAnalytics({
    required this.query,
    required this.language,
    required this.queryType,
    required this.firstSeen,
  }) : lastAccessed = firstSeen;

  double get cacheHitRatio => accessCount > 0 ? hitCount / accessCount : 0.0;

  Duration get averageRetrievalTime =>
      accessCount > 0
          ? Duration(
            microseconds: totalRetrievalTime.inMicroseconds ~/ accessCount,
          )
          : Duration.zero;

  void recordAccess(bool isHit, Duration responseTime) {
    accessCount++;
    lastAccessed = DateTime.now();
    totalRetrievalTime += responseTime;

    if (isHit) {
      hitCount++;
    } else {
      missCount++;
    }
  }
}

/// PopularQuery class implementation
class PopularQuery {
  final String query;
  final String language;
  final QueryType queryType;
  final int accessCount;
  final DateTime lastAccessed;
  final Duration averageRetrievalTime;
  final double cacheHitRatio;
  final double popularityScore;

  PopularQuery({
    required this.query,
    required this.language,
    required this.queryType,
    required this.accessCount,
    required this.lastAccessed,
    required this.averageRetrievalTime,
    required this.cacheHitRatio,
    required this.popularityScore,
  });
}

/// TrendingQuery class implementation
class TrendingQuery {
  final String query;
  final double trendScore;
  final double dailyGrowthRate;
  final int totalAccesses;

  TrendingQuery({
    required this.query,
    required this.trendScore,
    required this.dailyGrowthRate,
    required this.totalAccesses,
  });
}

/// CachePerformanceMetrics class implementation
class CachePerformanceMetrics {
  final int totalRequests;
  final int hitCount;
  final int missCount;
  final double hitRatio;
  final Duration averageHitTime;
  final Duration averageMissTime;
  final Duration? timeWindow;
  final Map<String, StrategyPerformance> strategyPerformance;

  CachePerformanceMetrics({
    required this.totalRequests,
    required this.hitCount,
    required this.missCount,
    required this.hitRatio,
    required this.averageHitTime,
    required this.averageMissTime,
    this.timeWindow,
    required this.strategyPerformance,
  });
}

/// StrategyPerformance class implementation
class StrategyPerformance {
  final String strategyName;
  final int hitCount;
  final int missCount;
  final double hitRatio;

  StrategyPerformance({
    required this.strategyName,
    required this.hitCount,
    required this.missCount,
    required this.hitRatio,
  });
}

/// CacheAnalyticsSummary class implementation
class CacheAnalyticsSummary {
  final CachePerformanceMetrics performance;
  final List<PopularQuery> popularQueries;
  final List<TrendingQuery> trendingQueries;
  final int totalUniqueQueries;
  final int totalEvents;

  CacheAnalyticsSummary({
    required this.performance,
    required this.popularQueries,
    required this.trendingQueries,
    required this.totalUniqueQueries,
    required this.totalEvents,
  });
}

/// TrendData class implementation
class TrendData {
  final Map<String, int> dailyCounts = {};
}

/// TrendCalculation class implementation
class TrendCalculation {
  final double score;
  final double growthRate;
  final bool isIncreasing;

  TrendCalculation({
    required this.score,
    required this.growthRate,
    required this.isIncreasing,
  });
}
