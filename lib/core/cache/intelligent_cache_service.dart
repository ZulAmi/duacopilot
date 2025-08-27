import 'package:duacopilot/core/logging/app_logger.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/cache_models.dart';
import 'services/semantic_hash_service.dart';
import 'services/compression_service.dart';
import 'services/analytics_service.dart';
import '../../domain/entities/rag_response.dart';

/// Intelligent caching system for RAG data with semantic deduplication,
/// TTL-based expiration, compression, and analytics
class IntelligentCacheService {
  static IntelligentCacheService? _instance;
  static IntelligentCacheService get instance =>
      _instance ??= IntelligentCacheService._();

  IntelligentCacheService._();

  // Cache storage
  final Map<String, CacheEntry> _cache = {};
  final Map<String, List<String>> _semanticIndex =
      {}; // semantic_hash -> [keys]
  final Map<String, Timer> _expirationTimers = {};

  // Configuration
  final Map<QueryType, CacheStrategy> _strategies = {
    QueryType.dua: CacheStrategy.duaQueries,
    QueryType.quran: CacheStrategy.quranQueries,
    QueryType.hadith: CacheStrategy.hadithQueries,
    QueryType.general: CacheStrategy.generalQueries,
  };

  // Metrics
  int _hitCount = 0;
  int _missCount = 0;
  int _evictionCount = 0;
  final List<Duration> _retrievalTimes = [];

  // Prewarming
  Timer? _prewarmingTimer;
  bool _isPrewarming = false;

  /// Initialize the cache service
  Future<void> initialize() async {
    await _loadFromPersistentStorage();
    _startMaintenanceTasks();
    CacheAnalyticsService.initialize();

    // Start prewarming for strategies that enable it
    _schedulePrewarming();
  }

  /// Store data in cache with intelligent strategy selection
  Future<void> store({
    required String query,
    required String language,
    required RagResponse data,
    QueryType? queryType,
    Map<String, dynamic>? metadata,
  }) async {
    final detectedType = queryType ?? _detectQueryType(query);
    final strategy = _strategies[detectedType] ?? CacheStrategy.generalQueries;

    // Generate semantic hash
    final semanticHash = SemanticHashService.generateSemanticHash(
      query,
      language,
      similarityThreshold:
          strategy.parameters['semantic_similarity_threshold'] ?? 0.8,
    );

    // Check for similar queries
    final existingSimilar = await _findSimilarCachedQuery(
      semanticHash,
      strategy,
    );
    if (existingSimilar != null) {
      // Update existing entry instead of creating new one
      await _updateExistingEntry(existingSimilar, data, semanticHash);
      return;
    }

    // Compress data if strategy enables it
    CompressionResult compressionResult;
    if (strategy.enableCompression) {
      // Use Arabic-specific compression for Arabic content
      if (language == 'ar' || _containsArabicText(data.response)) {
        compressionResult = CompressionService.compressArabicText(
          data.response,
        );
      } else {
        compressionResult = CompressionService.compressConditionally(
          data.response,
          maxRatio: strategy.minCompressionRatio,
        );
      }
    } else {
      compressionResult = CompressionResult(
        data: data.response,
        isCompressed: false,
        compressionRatio: 1.0,
        originalSize: data.response.length,
        compressedSize: data.response.length,
      );
    }

    // Create cache entry
    final key = _generateCacheKey(query, language);
    final now = DateTime.now();
    final cacheEntry = CacheEntry(
      key: key,
      compressedData: compressionResult.data,
      createdAt: now,
      expiresAt: now.add(strategy.ttl),
      strategy: strategy,
      metadata: {
        'original_query': query,
        'language': language,
        'query_type': detectedType.name,
        'rag_response': data.toJson(),
        ...metadata ?? {},
      },
      accessCount: 1,
      lastAccessedAt: now,
      semanticHash: semanticHash.hash,
      compressionRatio: compressionResult.compressionRatio,
    );

    // Store in cache
    await _storeCacheEntry(key, cacheEntry, strategy);

    // Update semantic index
    _updateSemanticIndex(semanticHash.hash, key);

    // Schedule expiration
    _scheduleExpiration(key, strategy.ttl);

    // Record analytics
    CacheAnalyticsService.recordCacheMiss(
      query,
      language,
      detectedType,
      Duration.zero, // This is a store operation, not a miss
      strategy.name,
    );
  }

  /// Retrieve data from cache with similarity matching
  Future<RagResponse?> retrieve({
    required String query,
    required String language,
    QueryType? queryType,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final detectedType = queryType ?? _detectQueryType(query);
      final strategy =
          _strategies[detectedType] ?? CacheStrategy.generalQueries;

      // Generate semantic hash for lookup
      final semanticHash = SemanticHashService.generateSemanticHash(
        query,
        language,
        similarityThreshold:
            strategy.parameters['semantic_similarity_threshold'] ?? 0.8,
      );

      // Try exact key match first
      final exactKey = _generateCacheKey(query, language);
      var cacheEntry = _cache[exactKey];

      // If no exact match, try semantic similarity
      if (cacheEntry == null) {
        final similarKey = await _findSimilarCachedQuery(
          semanticHash,
          strategy,
        );
        if (similarKey != null) {
          cacheEntry = _cache[similarKey];
        }
      }

      if (cacheEntry == null || cacheEntry.isExpired) {
        if (cacheEntry?.isExpired == true) {
          await _removeCacheEntry(cacheEntry!.key);
        }

        stopwatch.stop();
        _missCount++;

        CacheAnalyticsService.recordCacheMiss(
          query,
          language,
          detectedType,
          stopwatch.elapsed,
          strategy.name,
        );

        return null;
      }

      // Update access information
      final updatedEntry = cacheEntry.recordAccess();
      _cache[cacheEntry.key] = updatedEntry;

      // Decompress data
      String responseData;
      if (updatedEntry.compressionRatio < 1.0) {
        final compressionResult = CompressionResult(
          data: updatedEntry.compressedData,
          isCompressed: true,
          compressionRatio: updatedEntry.compressionRatio,
          originalSize: 0, // Not needed for decompression
          compressedSize: updatedEntry.compressedData.length,
          metadata: updatedEntry.metadata,
        );
        responseData = CompressionService.smartDecompress(compressionResult);
      } else {
        responseData = updatedEntry.compressedData;
      }

      // Reconstruct RagResponse
      final ragData =
          updatedEntry.metadata['rag_response'] as Map<String, dynamic>;
      final ragResponse = RagResponse.fromJson({
        ...ragData,
        'response': responseData, // Use decompressed data
      });

      stopwatch.stop();
      _hitCount++;
      _retrievalTimes.add(stopwatch.elapsed);

      // Record analytics
      CacheAnalyticsService.recordCacheHit(
        query,
        language,
        detectedType,
        stopwatch.elapsed,
        strategy.name,
      );

      // Check if entry is near expiry and schedule refresh
      if (updatedEntry.isNearExpiry) {
        _scheduleRefresh(updatedEntry);
      }

      return ragResponse;
    } finally {
      stopwatch.stop();
    }
  }

  /// Invalidate cache entries based on patterns
  Future<void> invalidate({
    String? pattern,
    QueryType? queryType,
    String? language,
    Duration? olderThan,
    String? reason = 'Manual invalidation',
  }) async {
    final affectedKeys = <String>[];
    final now = DateTime.now();

    for (final entry in _cache.values.toList()) {
      bool shouldInvalidate = false;

      // Pattern matching
      if (pattern != null) {
        final originalQuery = entry.metadata['original_query'] as String?;
        if (originalQuery?.contains(pattern) == true) {
          shouldInvalidate = true;
        }
      }

      // Query type matching
      if (queryType != null) {
        final entryType = entry.metadata['query_type'] as String?;
        if (entryType == queryType.name) {
          shouldInvalidate = true;
        }
      }

      // Language matching
      if (language != null) {
        final entryLanguage = entry.metadata['language'] as String?;
        if (entryLanguage == language) {
          shouldInvalidate = true;
        }
      }

      // Age-based invalidation
      if (olderThan != null) {
        if (now.difference(entry.createdAt) > olderThan) {
          shouldInvalidate = true;
        }
      }

      if (shouldInvalidate) {
        affectedKeys.add(entry.key);
        await _removeCacheEntry(entry.key);
      }
    }

    // Record invalidation event
    final invalidationEvent = CacheInvalidationEvent(
      eventType: 'manual',
      timestamp: now,
      affectedKeys: affectedKeys,
      metadata: {
        'pattern': pattern,
        'query_type': queryType?.name,
        'language': language,
        'older_than_hours': olderThan?.inHours,
      },
      reason: reason!,
    );

    CacheAnalyticsService.recordInvalidation(invalidationEvent);
  }

  /// Handle model updates that require cache invalidation
  Future<void> handleModelUpdate({
    required String modelVersion,
    List<String>? affectedDomains,
  }) async {
    final reason = 'Model update: $modelVersion';

    if (affectedDomains == null) {
      // Invalidate all cache
      await invalidateAll(reason: reason);
    } else {
      // Invalidate specific domains
      for (final domain in affectedDomains) {
        final queryType = _mapDomainToQueryType(domain);
        if (queryType != null) {
          await invalidate(queryType: queryType, reason: reason);
        }
      }
    }

    // Record model update event
    CacheAnalyticsService.logCustomEvent('model_update', {
      'model_version': modelVersion,
      'affected_domains': affectedDomains?.join(',') ?? 'all',
      'invalidated_entries': _evictionCount,
    });
  }

  /// Prewarming based on popular queries
  Future<void> prewarmCache({
    int? queryLimit,
    List<QueryType>? queryTypes,
  }) async {
    if (_isPrewarming) return;

    _isPrewarming = true;
    final stopwatch = Stopwatch()..start();

    try {
      final popularQueries = CacheAnalyticsService.getPopularQueries(
        limit: queryLimit ?? 50,
      );

      final filteredQueries = queryTypes != null
          ? popularQueries
              .where((q) => queryTypes.contains(q.queryType))
              .toList()
          : popularQueries;

      int successCount = 0;
      int failureCount = 0;
      final prewarmingQueries = <String>[];

      for (final popularQuery in filteredQueries) {
        prewarmingQueries.add(popularQuery.query);

        try {
          // Check if already cached
          final cached = await retrieve(
            query: popularQuery.query,
            language: popularQuery.language,
            queryType: popularQuery.queryType,
          );

          if (cached == null) {
            // This would typically trigger a RAG API call
            // For now, we just count it as needing refresh
            failureCount++;
          } else {
            successCount++;
          }
        } catch (e) {
          failureCount++;
        }
      }

      stopwatch.stop();

      CacheAnalyticsService.recordPrewarming(
        prewarmingQueries,
        'popular_queries',
        stopwatch.elapsed,
        successCount,
        failureCount,
      );
    } finally {
      _isPrewarming = false;
      stopwatch.stop();
    }
  }

  /// Get cache statistics
  CacheMetrics getMetrics() {
    final totalRequests = _hitCount + _missCount;
    final hitRatio = totalRequests > 0 ? _hitCount / totalRequests : 0.0;

    final averageRetrievalTime = _retrievalTimes.isNotEmpty
        ? Duration(
            microseconds: _retrievalTimes
                    .map((d) => d.inMicroseconds)
                    .reduce((a, b) => a + b) ~/
                _retrievalTimes.length,
          )
        : Duration.zero;

    // Calculate total cache size
    int totalSize = 0;
    double totalCompressionRatio = 0.0;
    final strategyUsage = <String, int>{};
    final strategyPerformance = <String, Duration>{};

    for (final entry in _cache.values) {
      totalSize += entry.compressedData.length;
      totalCompressionRatio += entry.compressionRatio;

      final strategyName = entry.strategy.name;
      strategyUsage[strategyName] = (strategyUsage[strategyName] ?? 0) + 1;
    }

    final averageCompressionRatio =
        _cache.isNotEmpty ? totalCompressionRatio / _cache.length : 1.0;

    return CacheMetrics(
      hitCount: _hitCount,
      missCount: _missCount,
      evictionCount: _evictionCount,
      hitRatio: hitRatio,
      averageCompressionRatio: averageCompressionRatio,
      averageRetrievalTime: averageRetrievalTime,
      totalSize: totalSize,
      entryCount: _cache.length,
      strategyUsage: strategyUsage,
      strategyPerformance: strategyPerformance,
    );
  }

  /// Clear all cache
  Future<void> invalidateAll({String reason = 'Clear all'}) async {
    final affectedKeys = _cache.keys.toList();

    _cache.clear();
    _semanticIndex.clear();
    _clearAllTimers();

    final invalidationEvent = CacheInvalidationEvent(
      eventType: 'clear_all',
      timestamp: DateTime.now(),
      affectedKeys: affectedKeys,
      metadata: {},
      reason: reason,
    );

    CacheAnalyticsService.recordInvalidation(invalidationEvent);
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    _clearAllTimers();
    _prewarmingTimer?.cancel();
    await _saveToPersistentStorage();
    CacheAnalyticsService.dispose();
  }

  // Private helper methods

  String _generateCacheKey(String query, String language) {
    return '$language:${query.toLowerCase().trim()}';
  }

  QueryType _detectQueryType(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dua') || lowerQuery.contains('Ø¯Ø¹Ø§Ø¡')) {
      return QueryType.dua;
    } else if (lowerQuery.contains('quran') ||
        lowerQuery.contains('Ù‚Ø±Ø¢Ù†')) {
      return QueryType.quran;
    } else if (lowerQuery.contains('hadith') ||
        lowerQuery.contains('Ø­Ø¯ÙŠØ«')) {
      return QueryType.hadith;
    } else if (lowerQuery.contains('prayer') ||
        lowerQuery.contains('ØµÙ„Ø§Ø©')) {
      return QueryType.prayer;
    } else if (lowerQuery.contains('fasting') ||
        lowerQuery.contains('ØµÙˆÙ…')) {
      return QueryType.fasting;
    } else if (lowerQuery.contains('charity') ||
        lowerQuery.contains('Ø²ÙƒØ§Ø©')) {
      return QueryType.charity;
    } else if (lowerQuery.contains('hajj') || lowerQuery.contains('Ø­Ø¬')) {
      return QueryType.pilgrimage;
    }

    return QueryType.general;
  }

  bool _containsArabicText(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  Future<String?> _findSimilarCachedQuery(
    SemanticHash targetHash,
    CacheStrategy strategy,
  ) async {
    final threshold =
        strategy.parameters['semantic_similarity_threshold'] ?? 0.8;
    final candidateKeys = _semanticIndex[targetHash.hash] ?? [];

    for (final key in candidateKeys) {
      final entry = _cache[key];
      if (entry == null || entry.isExpired) continue;

      final entryQuery = entry.metadata['original_query'] as String;
      final entryLanguage = entry.metadata['language'] as String;

      if (entryLanguage != targetHash.language) continue;

      final entryHash = SemanticHashService.generateSemanticHash(
        entryQuery,
        entryLanguage,
      );

      if (SemanticHashService.areSimilar(
        targetHash,
        entryHash,
        threshold: threshold,
      )) {
        return key;
      }
    }

    return null;
  }

  void _updateSemanticIndex(String semanticHash, String key) {
    _semanticIndex.putIfAbsent(semanticHash, () => []);
    if (!_semanticIndex[semanticHash]!.contains(key)) {
      _semanticIndex[semanticHash]!.add(key);
    }
  }

  Future<void> _storeCacheEntry(
    String key,
    CacheEntry entry,
    CacheStrategy strategy,
  ) async {
    // Check if we need to evict entries
    final currentStrategyEntries =
        _cache.values.where((e) => e.strategy.name == strategy.name).length;

    if (currentStrategyEntries >= strategy.maxSize) {
      await _evictEntries(strategy);
    }

    _cache[key] = entry;
    await _saveToPersistentStorage();
  }

  Future<void> _evictEntries(CacheStrategy strategy) async {
    final strategyEntries = _cache.entries
        .where((e) => e.value.strategy.name == strategy.name)
        .toList();

    if (strategyEntries.isEmpty) return;

    // Sort by eviction policy
    switch (strategy.evictionPolicy) {
      case EvictionPolicy.lru:
        strategyEntries.sort(
          (a, b) => a.value.lastAccessedAt.compareTo(b.value.lastAccessedAt),
        );
        break;
      case EvictionPolicy.lfu:
        strategyEntries.sort(
          (a, b) => a.value.accessCount.compareTo(b.value.accessCount),
        );
        break;
      case EvictionPolicy.fifo:
        strategyEntries.sort(
          (a, b) => a.value.createdAt.compareTo(b.value.createdAt),
        );
        break;
      case EvictionPolicy.ttl:
        strategyEntries.sort(
          (a, b) => a.value.expiresAt.compareTo(b.value.expiresAt),
        );
        break;
      case EvictionPolicy.size:
        strategyEntries.sort(
          (a, b) => b.value.compressedData.length.compareTo(
            a.value.compressedData.length,
          ),
        );
        break;
    }

    // Evict the first (oldest/least used) entry
    final toEvict = strategyEntries.first;
    await _removeCacheEntry(toEvict.key);

    CacheAnalyticsService.recordCacheEviction(
      toEvict.key,
      strategy.name,
      strategy.evictionPolicy,
      'Size limit exceeded',
    );
  }

  Future<void> _removeCacheEntry(String key) async {
    final entry = _cache.remove(key);
    if (entry != null) {
      _evictionCount++;

      // Remove from semantic index
      _semanticIndex[entry.semanticHash]?.remove(key);
      if (_semanticIndex[entry.semanticHash]?.isEmpty == true) {
        _semanticIndex.remove(entry.semanticHash);
      }

      // Cancel expiration timer
      _expirationTimers[key]?.cancel();
      _expirationTimers.remove(key);
    }
  }

  void _scheduleExpiration(String key, Duration ttl) {
    _expirationTimers[key]?.cancel();
    _expirationTimers[key] = Timer(ttl, () async {
      await _removeCacheEntry(key);
    });
  }

  void _scheduleRefresh(CacheEntry entry) {
    // This would typically trigger a background refresh
    // For now, we just log it
    AppLogger.debug(
      'Scheduling refresh for: ${entry.metadata['original_query']}',
    );
  }

  Future<void> _updateExistingEntry(
    String existingKey,
    RagResponse newData,
    SemanticHash semanticHash,
  ) async {
    final existing = _cache[existingKey];
    if (existing == null) return;

    // Update the entry with new data
    final compressionResult = CompressionService.compressConditionally(
      newData.response,
      maxRatio: existing.strategy.minCompressionRatio,
    );

    final updatedEntry = existing.copyWith(
      compressedData: compressionResult.data,
      lastAccessedAt: DateTime.now(),
      accessCount: existing.accessCount + 1,
      compressionRatio: compressionResult.compressionRatio,
      metadata: {
        ...existing.metadata,
        'rag_response': newData.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    );

    _cache[existingKey] = updatedEntry;
  }

  QueryType? _mapDomainToQueryType(String domain) {
    switch (domain.toLowerCase()) {
      case 'dua':
      case 'duas':
        return QueryType.dua;
      case 'quran':
      case 'quranic':
        return QueryType.quran;
      case 'hadith':
      case 'hadiths':
        return QueryType.hadith;
      case 'prayer':
      case 'prayers':
        return QueryType.prayer;
      case 'fasting':
        return QueryType.fasting;
      case 'charity':
      case 'zakat':
        return QueryType.charity;
      case 'pilgrimage':
      case 'hajj':
        return QueryType.pilgrimage;
      default:
        return null;
    }
  }

  void _schedulePrewarming() {
    // Schedule prewarming for strategies that enable it
    _prewarmingTimer = Timer.periodic(Duration(hours: 6), (_) async {
      for (final strategy in _strategies.values) {
        if (strategy.enablePrewarming) {
          await prewarmCache(
            queryLimit: strategy.parameters['prewarming_count'] ?? 50,
          );
        }
      }
    });
  }

  void _startMaintenanceTasks() {
    // Periodic cleanup of expired entries
    Timer.periodic(Duration(minutes: 30), (_) async {
      await _cleanupExpiredEntries();
    });

    // Periodic metrics flush
    Timer.periodic(Duration(minutes: 15), (_) async {
      await _saveToPersistentStorage();
    });
  }

  Future<void> _cleanupExpiredEntries() async {
    final expiredKeys = <String>[];

    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      await _removeCacheEntry(key);
    }
  }

  void _clearAllTimers() {
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    _expirationTimers.clear();
  }

  Future<void> _loadFromPersistentStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString('intelligent_cache_data');

      if (cacheData != null) {
        final data = jsonDecode(cacheData) as Map<String, dynamic>;

        for (final entry in data.entries) {
          final cacheEntry = CacheEntry.fromJson(entry.value);

          if (!cacheEntry.isExpired) {
            _cache[entry.key] = cacheEntry;
            _updateSemanticIndex(cacheEntry.semanticHash, entry.key);

            // Reschedule expiration
            final remaining = cacheEntry.expiresAt.difference(DateTime.now());
            if (remaining.isNegative) {
              await _removeCacheEntry(entry.key);
            } else {
              _scheduleExpiration(entry.key, remaining);
            }
          }
        }
      }
    } catch (e) {
      AppLogger.debug('Error loading cache from persistent storage: $e');
    }
  }

  Future<void> _saveToPersistentStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = <String, dynamic>{};

      for (final entry in _cache.entries) {
        if (!entry.value.isExpired) {
          cacheData[entry.key] = entry.value.toJson();
        }
      }

      await prefs.setString('intelligent_cache_data', jsonEncode(cacheData));
    } catch (e) {
      AppLogger.debug('Error saving cache to persistent storage: $e');
    }
  }
}
