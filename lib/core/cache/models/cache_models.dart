import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Cache entry with TTL and metadata
@immutable

/// CacheEntry class implementation
class CacheEntry extends Equatable {
  final String key;
  final String compressedData;
  final DateTime createdAt;
  final DateTime expiresAt;
  final CacheStrategy strategy;
  final Map<String, dynamic> metadata;
  final int accessCount;
  final DateTime lastAccessedAt;
  final String semanticHash;
  final double compressionRatio;

  const CacheEntry({
    required this.key,
    required this.compressedData,
    required this.createdAt,
    required this.expiresAt,
    required this.strategy,
    required this.metadata,
    required this.accessCount,
    required this.lastAccessedAt,
    required this.semanticHash,
    required this.compressionRatio,
  });

  @override
  List<Object?> get props => [
        key,
        compressedData,
        createdAt,
        expiresAt,
        strategy,
        metadata,
        accessCount,
        lastAccessedAt,
        semanticHash,
        compressionRatio,
      ];

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isNearExpiry =>
      DateTime.now().isAfter(expiresAt.subtract(strategy.nearExpiryThreshold));

  Duration get age => DateTime.now().difference(createdAt);

  CacheEntry copyWith({
    String? key,
    String? compressedData,
    DateTime? createdAt,
    DateTime? expiresAt,
    CacheStrategy? strategy,
    Map<String, dynamic>? metadata,
    int? accessCount,
    DateTime? lastAccessedAt,
    String? semanticHash,
    double? compressionRatio,
  }) {
    return CacheEntry(
      key: key ?? this.key,
      compressedData: compressedData ?? this.compressedData,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      strategy: strategy ?? this.strategy,
      metadata: metadata ?? this.metadata,
      accessCount: accessCount ?? this.accessCount,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      semanticHash: semanticHash ?? this.semanticHash,
      compressionRatio: compressionRatio ?? this.compressionRatio,
    );
  }

  /// Increment access count and update last accessed time
  CacheEntry recordAccess() {
    return copyWith(
      accessCount: accessCount + 1,
      lastAccessedAt: DateTime.now(),
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'compressedData': compressedData,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'strategy': strategy.toJson(),
      'metadata': metadata,
      'accessCount': accessCount,
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
      'semanticHash': semanticHash,
      'compressionRatio': compressionRatio,
    };
  }

  /// Create from map
  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      key: json['key'],
      compressedData: json['compressedData'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      strategy: CacheStrategy.fromJson(json['strategy']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      accessCount: json['accessCount'] ?? 0,
      lastAccessedAt: DateTime.parse(json['lastAccessedAt']),
      semanticHash: json['semanticHash'],
      compressionRatio: json['compressionRatio']?.toDouble() ?? 1.0,
    );
  }
}

/// Cache strategy configuration
@immutable

/// CacheStrategy class implementation
class CacheStrategy extends Equatable {
  final String name;
  final Duration ttl;
  final Duration nearExpiryThreshold;
  final int maxSize;
  final EvictionPolicy evictionPolicy;
  final bool enablePrewarming;
  final bool enableCompression;
  final double minCompressionRatio;
  final Map<String, dynamic> parameters;

  const CacheStrategy({
    required this.name,
    required this.ttl,
    required this.nearExpiryThreshold,
    required this.maxSize,
    this.evictionPolicy = EvictionPolicy.lru,
    this.enablePrewarming = false,
    this.enableCompression = true,
    this.minCompressionRatio = 0.7,
    this.parameters = const {},
  });

  @override
  List<Object?> get props => [
        name,
        ttl,
        nearExpiryThreshold,
        maxSize,
        evictionPolicy,
        enablePrewarming,
        enableCompression,
        minCompressionRatio,
        parameters,
      ];

  /// Predefined strategies for different query types
  static const CacheStrategy duaQueries = CacheStrategy(
    name: 'dua_queries',
    ttl: Duration(hours: 24),
    nearExpiryThreshold: Duration(hours: 2),
    maxSize: 500,
    evictionPolicy: EvictionPolicy.lfu,
    enablePrewarming: true,
    enableCompression: true,
    minCompressionRatio: 0.6,
    parameters: {'semantic_similarity_threshold': 0.85, 'prewarming_count': 50},
  );

  static const CacheStrategy quranQueries = CacheStrategy(
    name: 'quran_queries',
    ttl: Duration(days: 7),
    nearExpiryThreshold: Duration(hours: 12),
    maxSize: 300,
    evictionPolicy: EvictionPolicy.lru,
    enablePrewarming: true,
    enableCompression: true,
    minCompressionRatio: 0.5,
    parameters: {'semantic_similarity_threshold': 0.9, 'prewarming_count': 30},
  );

  static const CacheStrategy hadithQueries = CacheStrategy(
    name: 'hadith_queries',
    ttl: Duration(days: 3),
    nearExpiryThreshold: Duration(hours: 6),
    maxSize: 200,
    evictionPolicy: EvictionPolicy.lfu,
    enablePrewarming: false,
    enableCompression: true,
    minCompressionRatio: 0.7,
    parameters: {'semantic_similarity_threshold': 0.8},
  );

  static const CacheStrategy generalQueries = CacheStrategy(
    name: 'general_queries',
    ttl: Duration(hours: 6),
    nearExpiryThreshold: Duration(hours: 1),
    maxSize: 100,
    evictionPolicy: EvictionPolicy.lru,
    enablePrewarming: false,
    enableCompression: false,
    parameters: {'semantic_similarity_threshold': 0.75},
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ttl': ttl.inMilliseconds,
      'nearExpiryThreshold': nearExpiryThreshold.inMilliseconds,
      'maxSize': maxSize,
      'evictionPolicy': evictionPolicy.name,
      'enablePrewarming': enablePrewarming,
      'enableCompression': enableCompression,
      'minCompressionRatio': minCompressionRatio,
      'parameters': parameters,
    };
  }

  factory CacheStrategy.fromJson(Map<String, dynamic> json) {
    return CacheStrategy(
      name: json['name'],
      ttl: Duration(milliseconds: json['ttl']),
      nearExpiryThreshold: Duration(milliseconds: json['nearExpiryThreshold']),
      maxSize: json['maxSize'],
      evictionPolicy: EvictionPolicy.values.firstWhere(
        (e) => e.name == json['evictionPolicy'],
        orElse: () => EvictionPolicy.lru,
      ),
      enablePrewarming: json['enablePrewarming'] ?? false,
      enableCompression: json['enableCompression'] ?? true,
      minCompressionRatio: json['minCompressionRatio']?.toDouble() ?? 0.7,
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
    );
  }
}

/// Cache eviction policies
enum EvictionPolicy {
  lru, // Least Recently Used
  lfu, // Least Frequently Used
  fifo, // First In First Out
  ttl, // Time To Live based
  size, // Size based
}

/// Query type classification for cache strategy selection
enum QueryType {
  dua,
  quran,
  hadith,
  prayer,
  fasting,
  charity,
  pilgrimage,
  general,
}

/// Semantic hash result for query deduplication
@immutable

/// SemanticHash class implementation
class SemanticHash extends Equatable {
  final String hash;
  final String normalizedQuery;
  final List<String> semanticTokens;
  final String language;
  final double confidence;

  const SemanticHash({
    required this.hash,
    required this.normalizedQuery,
    required this.semanticTokens,
    required this.language,
    required this.confidence,
  });

  @override
  List<Object?> get props => [
        hash,
        normalizedQuery,
        semanticTokens,
        language,
        confidence,
      ];

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'normalizedQuery': normalizedQuery,
      'semanticTokens': semanticTokens,
      'language': language,
      'confidence': confidence,
    };
  }

  factory SemanticHash.fromJson(Map<String, dynamic> json) {
    return SemanticHash(
      hash: json['hash'],
      normalizedQuery: json['normalizedQuery'],
      semanticTokens: List<String>.from(json['semanticTokens'] ?? []),
      language: json['language'],
      confidence: json['confidence']?.toDouble() ?? 1.0,
    );
  }
}

/// Cache performance metrics
@immutable

/// CacheMetrics class implementation
class CacheMetrics extends Equatable {
  final int hitCount;
  final int missCount;
  final int evictionCount;
  final double hitRatio;
  final double averageCompressionRatio;
  final Duration averageRetrievalTime;
  final int totalSize;
  final int entryCount;
  final Map<String, int> strategyUsage;
  final Map<String, Duration> strategyPerformance;

  const CacheMetrics({
    required this.hitCount,
    required this.missCount,
    required this.evictionCount,
    required this.hitRatio,
    required this.averageCompressionRatio,
    required this.averageRetrievalTime,
    required this.totalSize,
    required this.entryCount,
    required this.strategyUsage,
    required this.strategyPerformance,
  });

  @override
  List<Object?> get props => [
        hitCount,
        missCount,
        evictionCount,
        hitRatio,
        averageCompressionRatio,
        averageRetrievalTime,
        totalSize,
        entryCount,
        strategyUsage,
        strategyPerformance,
      ];

  int get totalRequests => hitCount + missCount;

  Map<String, dynamic> toJson() {
    return {
      'hitCount': hitCount,
      'missCount': missCount,
      'evictionCount': evictionCount,
      'hitRatio': hitRatio,
      'averageCompressionRatio': averageCompressionRatio,
      'averageRetrievalTime': averageRetrievalTime.inMicroseconds,
      'totalSize': totalSize,
      'entryCount': entryCount,
      'strategyUsage': strategyUsage,
      'strategyPerformance': strategyPerformance.map(
        (k, v) => MapEntry(k, v.inMicroseconds),
      ),
    };
  }

  factory CacheMetrics.fromJson(Map<String, dynamic> json) {
    return CacheMetrics(
      hitCount: json['hitCount'] ?? 0,
      missCount: json['missCount'] ?? 0,
      evictionCount: json['evictionCount'] ?? 0,
      hitRatio: json['hitRatio']?.toDouble() ?? 0.0,
      averageCompressionRatio:
          json['averageCompressionRatio']?.toDouble() ?? 1.0,
      averageRetrievalTime: Duration(
        microseconds: json['averageRetrievalTime'] ?? 0,
      ),
      totalSize: json['totalSize'] ?? 0,
      entryCount: json['entryCount'] ?? 0,
      strategyUsage: Map<String, int>.from(json['strategyUsage'] ?? {}),
      strategyPerformance:
          (json['strategyPerformance'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, Duration(microseconds: v)),
              ) ??
              {},
    );
  }
}

/// Cache invalidation event
@immutable

/// CacheInvalidationEvent class implementation
class CacheInvalidationEvent extends Equatable {
  final String eventType;
  final DateTime timestamp;
  final List<String> affectedKeys;
  final Map<String, dynamic> metadata;
  final String reason;

  const CacheInvalidationEvent({
    required this.eventType,
    required this.timestamp,
    required this.affectedKeys,
    required this.metadata,
    required this.reason,
  });

  @override
  List<Object?> get props => [
        eventType,
        timestamp,
        affectedKeys,
        metadata,
        reason,
      ];

  Map<String, dynamic> toJson() {
    return {
      'eventType': eventType,
      'timestamp': timestamp.toIso8601String(),
      'affectedKeys': affectedKeys,
      'metadata': metadata,
      'reason': reason,
    };
  }

  factory CacheInvalidationEvent.fromJson(Map<String, dynamic> json) {
    return CacheInvalidationEvent(
      eventType: json['eventType'],
      timestamp: DateTime.parse(json['timestamp']),
      affectedKeys: List<String>.from(json['affectedKeys'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      reason: json['reason'],
    );
  }
}
