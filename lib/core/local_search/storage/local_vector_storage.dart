import 'package:duacopilot/core/logging/app_logger.dart';

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/local_search_models.dart';
import '../services/local_embedding_service.dart';

/// Simplified Hive-based local vector storage for Du'a embeddings
/// Uses JSON serialization until Hive adapters are properly generated
class LocalVectorStorage {
  static LocalVectorStorage? _instance;
  static LocalVectorStorage get instance =>
      _instance ??= LocalVectorStorage._();

  LocalVectorStorage._();

  // Hive boxes (using String for JSON serialization)
  Box<String>? _embeddingsBox;
  Box<String>? _pendingQueriesBox;
  Box<String>? _metadataBox;

  // Box names
  static const String _embeddingsBoxName = 'dua_embeddings_json';
  static const String _pendingQueriesBoxName = 'pending_queries_json';
  static const String _metadataBoxName = 'storage_metadata';

  // Configuration
  static const int _maxEmbeddings = 1000;
  static const int _maxPendingQueries = 100;

  bool _isInitialized = false;

  /// Initialize the local storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Open boxes
      _embeddingsBox = await Hive.openBox<String>(_embeddingsBoxName);
      _pendingQueriesBox = await Hive.openBox<String>(_pendingQueriesBoxName);
      _metadataBox = await Hive.openBox<String>(_metadataBoxName);

      // Clean up old data if necessary
      await _performMaintenance();

      _isInitialized = true;
      AppLogger.debug('Local vector storage initialized successfully');
    } catch (e) {
      AppLogger.debug('Error initializing local vector storage: $e');
      throw Exception('Failed to initialize local storage: $e');
    }
  }

  /// Store a Du'a embedding
  Future<void> storeEmbedding(DuaEmbedding embedding) async {
    await _ensureInitialized();

    try {
      // Check if we need to make space
      if (_embeddingsBox!.length >= _maxEmbeddings) {
        await _evictOldEmbeddings();
      }

      // Store the embedding as JSON
      final jsonString = jsonEncode(embedding.toJson());
      await _embeddingsBox!.put(embedding.id, jsonString);

      // Update metadata
      await _updateStorageMetadata();

      AppLogger.debug('Stored embedding for: ${embedding.query}');
    } catch (e) {
      AppLogger.debug('Error storing embedding: $e');
      throw Exception('Failed to store embedding: $e');
    }
  }

  /// Store multiple embeddings in batch
  Future<void> storeBatchEmbeddings(List<DuaEmbedding> embeddings) async {
    await _ensureInitialized();

    try {
      final embeddingsMap = <String, String>{};
      for (final embedding in embeddings) {
        embeddingsMap[embedding.id] = jsonEncode(embedding.toJson());
      }

      // Check space and evict if necessary
      final spaceNeeded = embeddingsMap.length;
      final currentCount = _embeddingsBox!.length;
      if (currentCount + spaceNeeded > _maxEmbeddings) {
        final toEvict = (currentCount + spaceNeeded) - _maxEmbeddings;
        await _evictOldEmbeddings(count: toEvict);
      }

      // Store all embeddings
      await _embeddingsBox!.putAll(embeddingsMap);

      // Update metadata
      await _updateStorageMetadata();

      AppLogger.debug('Stored ${embeddings.length} embeddings in batch');
    } catch (e) {
      AppLogger.debug('Error storing batch embeddings: $e');
      throw Exception('Failed to store batch embeddings: $e');
    }
  }

  /// Retrieve embedding by ID
  Future<DuaEmbedding?> getEmbedding(String id) async {
    await _ensureInitialized();

    try {
      final jsonString = _embeddingsBox!.get(id);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return DuaEmbedding.fromJson(json);
      }
      return null;
    } catch (e) {
      AppLogger.debug('Error retrieving embedding: $e');
      return null;
    }
  }

  /// Get all embeddings for a specific language
  Future<List<DuaEmbedding>> getEmbeddingsByLanguage(String language) async {
    await _ensureInitialized();

    try {
      final embeddings = <DuaEmbedding>[];
      for (final jsonString in _embeddingsBox!.values) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final embedding = DuaEmbedding.fromJson(json);
          if (embedding.language == language) {
            embeddings.add(embedding);
          }
        } catch (e) {
          AppLogger.debug('Error parsing embedding: $e');
        }
      }
      return embeddings;
    } catch (e) {
      AppLogger.debug('Error retrieving embeddings by language: $e');
      return [];
    }
  }

  /// Get all embeddings for a specific category
  Future<List<DuaEmbedding>> getEmbeddingsByCategory(String category) async {
    await _ensureInitialized();

    try {
      final embeddings = <DuaEmbedding>[];
      for (final jsonString in _embeddingsBox!.values) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final embedding = DuaEmbedding.fromJson(json);
          if (embedding.category == category) {
            embeddings.add(embedding);
          }
        } catch (e) {
          AppLogger.debug('Error parsing embedding: $e');
        }
      }
      return embeddings;
    } catch (e) {
      AppLogger.debug('Error retrieving embeddings by category: $e');
      return [];
    }
  }

  /// Search for similar embeddings
  Future<List<SimilarityMatch>> searchSimilar(
    List<double> queryEmbedding,
    String language, {
    int limit = 5,
    double minSimilarity = 0.5,
    String? category,
  }) async {
    await _ensureInitialized();

    try {
      final candidates = <DuaEmbedding>[];

      for (final jsonString in _embeddingsBox!.values) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final embedding = DuaEmbedding.fromJson(json);

          if (embedding.language == language) {
            if (category == null || embedding.category == category) {
              candidates.add(embedding);
            }
          }
        } catch (e) {
          AppLogger.debug('Error parsing embedding for search: $e');
        }
      }

      return LocalEmbeddingService.instance.findMostSimilar(
        queryEmbedding,
        candidates,
        limit: limit,
        minSimilarity: minSimilarity,
      );
    } catch (e) {
      AppLogger.debug('Error searching similar embeddings: $e');
      return [];
    }
  }

  /// Get popular embeddings based on usage
  Future<List<DuaEmbedding>> getPopularEmbeddings({
    int limit = 10,
    String? language,
  }) async {
    await _ensureInitialized();

    try {
      final embeddings = <DuaEmbedding>[];

      for (final jsonString in _embeddingsBox!.values) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final embedding = DuaEmbedding.fromJson(json);

          if (language == null || embedding.language == language) {
            embeddings.add(embedding);
          }
        } catch (e) {
          AppLogger.debug('Error parsing embedding: $e');
        }
      }

      // Sort by popularity
      embeddings.sort((a, b) => b.popularity.compareTo(a.popularity));

      return embeddings.take(limit).toList();
    } catch (e) {
      AppLogger.debug('Error retrieving popular embeddings: $e');
      return [];
    }
  }

  /// Update embedding popularity
  Future<void> updateEmbeddingPopularity(
    String id,
    double popularityBoost,
  ) async {
    await _ensureInitialized();

    try {
      final jsonString = _embeddingsBox!.get(id);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final embedding = DuaEmbedding.fromJson(json);
        final updated = embedding.copyWith(
          popularity: embedding.popularity + popularityBoost,
        );
        final updatedJsonString = jsonEncode(updated.toJson());
        await _embeddingsBox!.put(id, updatedJsonString);
      }
    } catch (e) {
      AppLogger.debug('Error updating embedding popularity: $e');
    }
  }

  /// Store a pending query
  Future<void> storePendingQuery(PendingQuery query) async {
    await _ensureInitialized();

    try {
      // Check if we need to make space
      if (_pendingQueriesBox!.length >= _maxPendingQueries) {
        await _evictOldPendingQueries();
      }

      final jsonString = jsonEncode(query.toJson());
      await _pendingQueriesBox!.put(query.id, jsonString);
      AppLogger.debug('Stored pending query: ${query.query}');
    } catch (e) {
      AppLogger.debug('Error storing pending query: $e');
      throw Exception('Failed to store pending query: $e');
    }
  }

  /// Get all pending queries
  Future<List<PendingQuery>> getPendingQueries({
    bool unprocessedOnly = false,
  }) async {
    await _ensureInitialized();

    try {
      final queries = <PendingQuery>[];

      for (final jsonString in _pendingQueriesBox!.values) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final query = PendingQuery.fromJson(json);

          if (!unprocessedOnly || !query.isProcessed) {
            queries.add(query);
          }
        } catch (e) {
          AppLogger.debug('Error parsing pending query: $e');
        }
      }

      // Sort by priority (higher first) then by creation date
      queries.sort((a, b) {
        final priorityComparison = b.priority.compareTo(a.priority);
        if (priorityComparison != 0) return priorityComparison;
        return a.createdAt.compareTo(b.createdAt);
      });

      return queries;
    } catch (e) {
      AppLogger.debug('Error retrieving pending queries: $e');
      return [];
    }
  }

  /// Mark pending query as processed
  Future<void> markQueryProcessed(String queryId, String? responseId) async {
    await _ensureInitialized();

    try {
      final jsonString = _pendingQueriesBox!.get(queryId);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final query = PendingQuery.fromJson(json);
        final updated = query.copyWith(
          isProcessed: true,
          localResponseId: responseId,
        );
        final updatedJsonString = jsonEncode(updated.toJson());
        await _pendingQueriesBox!.put(queryId, updatedJsonString);
      }
    } catch (e) {
      AppLogger.debug('Error marking query as processed: $e');
    }
  }

  /// Remove pending query
  Future<void> removePendingQuery(String queryId) async {
    await _ensureInitialized();

    try {
      await _pendingQueriesBox!.delete(queryId);
    } catch (e) {
      AppLogger.debug('Error removing pending query: $e');
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    await _ensureInitialized();

    try {
      final embeddingsCount = _embeddingsBox!.length;
      final pendingQueriesCount = _pendingQueriesBox!.length;

      // Calculate unprocessed queries
      final allQueries = await getPendingQueries();
      final unprocessedQueriesCount =
          allQueries.where((q) => !q.isProcessed).length;

      // Calculate approximate storage size
      int embeddingsSize = 0;
      for (final jsonString in _embeddingsBox!.values) {
        embeddingsSize += jsonString.length;
      }

      // Language and category distribution
      final languageDistribution = <String, int>{};
      final categoryDistribution = <String, int>{};

      for (final jsonString in _embeddingsBox!.values) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final language = json['language'] as String? ?? 'unknown';
          final category = json['category'] as String? ?? 'unknown';

          languageDistribution[language] =
              (languageDistribution[language] ?? 0) + 1;
          categoryDistribution[category] =
              (categoryDistribution[category] ?? 0) + 1;
        } catch (e) {
          // Skip invalid entries
        }
      }

      return {
        'embeddings_count': embeddingsCount,
        'pending_queries_count': pendingQueriesCount,
        'unprocessed_queries_count': unprocessedQueriesCount,
        'embeddings_size_bytes': embeddingsSize,
        'max_embeddings': _maxEmbeddings,
        'max_pending_queries': _maxPendingQueries,
        'language_distribution': languageDistribution,
        'category_distribution': categoryDistribution,
        'storage_usage_percent':
            (embeddingsCount / _maxEmbeddings * 100).round(),
        'last_updated': await _getLastUpdated(),
      };
    } catch (e) {
      AppLogger.debug('Error getting storage stats: $e');
      return {};
    }
  }

  /// Clear all embeddings
  Future<void> clearEmbeddings() async {
    await _ensureInitialized();

    try {
      await _embeddingsBox!.clear();
      await _updateStorageMetadata();
      AppLogger.debug('Cleared all embeddings');
    } catch (e) {
      AppLogger.debug('Error clearing embeddings: $e');
    }
  }

  /// Clear all pending queries
  Future<void> clearPendingQueries() async {
    await _ensureInitialized();

    try {
      await _pendingQueriesBox!.clear();
      AppLogger.debug('Cleared all pending queries');
    } catch (e) {
      AppLogger.debug('Error clearing pending queries: $e');
    }
  }

  /// Dispose and close storage
  Future<void> dispose() async {
    try {
      await _embeddingsBox?.close();
      await _pendingQueriesBox?.close();
      await _metadataBox?.close();
      _isInitialized = false;
      AppLogger.debug('Local vector storage disposed');
    } catch (e) {
      AppLogger.debug('Error disposing local storage: $e');
    }
  }

  // Private methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _performMaintenance() async {
    try {
      // Remove expired embeddings based on age
      final cutoffDate = DateTime.now().subtract(Duration(days: 30));
      final toRemove = <String>[];

      for (final entry in _embeddingsBox!.toMap().entries) {
        try {
          final json = jsonDecode(entry.value) as Map<String, dynamic>;
          final createdAt = DateTime.parse(json['createdAt'] as String);
          final popularity = json['popularity'] as double? ?? 0.0;

          if (createdAt.isBefore(cutoffDate) && popularity < 1.0) {
            toRemove.add(entry.key);
          }
        } catch (e) {
          // Remove corrupted entries
          toRemove.add(entry.key);
        }
      }

      for (final key in toRemove) {
        await _embeddingsBox!.delete(key);
      }

      AppLogger.debug(
        'Maintenance completed: removed ${toRemove.length} old embeddings',
      );
    } catch (e) {
      AppLogger.debug('Error during maintenance: $e');
    }
  }

  Future<void> _evictOldEmbeddings({int? count}) async {
    try {
      final embeddingEntries = <MapEntry<String, double>>[];

      // Get all embeddings with their creation dates and popularity
      for (final entry in _embeddingsBox!.toMap().entries) {
        try {
          final json = jsonDecode(entry.value) as Map<String, dynamic>;
          final createdAt = DateTime.parse(json['createdAt'] as String);
          final popularity = json['popularity'] as double? ?? 0.0;

          // Create a score based on age and popularity (lower is worse)
          final ageInDays = DateTime.now().difference(createdAt).inDays;
          final score =
              popularity - (ageInDays * 0.01); // Reduce score with age

          embeddingEntries.add(MapEntry(entry.key, score));
        } catch (e) {
          // Remove corrupted entries
          embeddingEntries.add(MapEntry(entry.key, -999.0));
        }
      }

      // Sort by score (ascending - worst first)
      embeddingEntries.sort((a, b) => a.value.compareTo(b.value));

      final toEvict =
          count ?? (embeddingEntries.length ~/ 10); // Default: evict 10%
      final actualEvictCount = toEvict.clamp(1, embeddingEntries.length);

      for (int i = 0; i < actualEvictCount; i++) {
        await _embeddingsBox!.delete(embeddingEntries[i].key);
      }

      AppLogger.debug('Evicted $actualEvictCount old embeddings');
    } catch (e) {
      AppLogger.debug('Error evicting old embeddings: $e');
    }
  }

  Future<void> _evictOldPendingQueries() async {
    try {
      final queryEntries = <MapEntry<String, DateTime>>[];

      for (final entry in _pendingQueriesBox!.toMap().entries) {
        try {
          final json = jsonDecode(entry.value) as Map<String, dynamic>;
          final createdAt = DateTime.parse(json['createdAt'] as String);
          queryEntries.add(MapEntry(entry.key, createdAt));
        } catch (e) {
          // Remove corrupted entries
          queryEntries.add(MapEntry(entry.key, DateTime(1970)));
        }
      }

      // Sort by creation date (oldest first)
      queryEntries.sort((a, b) => a.value.compareTo(b.value));

      // Remove oldest 20%
      final toEvict = queryEntries.length ~/ 5;
      for (int i = 0; i < toEvict; i++) {
        await _pendingQueriesBox!.delete(queryEntries[i].key);
      }

      AppLogger.debug('Evicted $toEvict old pending queries');
    } catch (e) {
      AppLogger.debug('Error evicting old pending queries: $e');
    }
  }

  Future<void> _updateStorageMetadata() async {
    try {
      await _metadataBox!.put('last_updated', DateTime.now().toIso8601String());
      await _metadataBox!.put(
        'embeddings_count',
        _embeddingsBox!.length.toString(),
      );
    } catch (e) {
      AppLogger.debug('Error updating storage metadata: $e');
    }
  }

  Future<String> _getLastUpdated() async {
    try {
      return _metadataBox!.get('last_updated') ?? 'Never';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Get all embeddings (for debugging)
  Future<List<DuaEmbedding>> getAllEmbeddings() async {
    await _ensureInitialized();

    final embeddings = <DuaEmbedding>[];
    for (final jsonString in _embeddingsBox!.values) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        embeddings.add(DuaEmbedding.fromJson(json));
      } catch (e) {
        AppLogger.debug('Error parsing embedding: $e');
      }
    }
    return embeddings;
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;
}
