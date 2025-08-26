import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/models/offline/offline_search_models.dart';

/// Local vector storage using Hive for Du'a embeddings
class LocalVectorStorageService {
  static const String _embeddingsBoxName = 'dua_embeddings';
  static const String _queriesBoxName = 'search_queries';
  static const String _cacheBoxName = 'search_cache';
  static const String _templatesBoxName = 'fallback_templates';

  Box<Map>? _embeddingsBox;
  Box<Map>? _queriesBox;
  Box<Map>? _cacheBox;
  Box<Map>? _templatesBox;

  bool _isInitialized = false;

  /// Initialize Hive boxes for local storage
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Open all required boxes
      _embeddingsBox = await Hive.openBox<Map>(_embeddingsBoxName);
      _queriesBox = await Hive.openBox<Map>(_queriesBoxName);
      _cacheBox = await Hive.openBox<Map>(_cacheBoxName);
      _templatesBox = await Hive.openBox<Map>(_templatesBoxName);

      _isInitialized = true;
      print('LocalVectorStorageService initialized successfully');
    } catch (e) {
      print('Failed to initialize LocalVectorStorageService: $e');
      _isInitialized = false;
    }
  }

  bool get isReady => _isInitialized;

  // Du'a Embeddings Management

  /// Store a Du'a embedding
  Future<void> storeEmbedding(DuaEmbedding embedding) async {
    if (!isReady) return;

    try {
      await _embeddingsBox!.put(embedding.id, embedding.toJson());
    } catch (e) {
      print('Error storing embedding: $e');
    }
  }

  /// Store multiple embeddings in batch
  Future<void> storeBatchEmbeddings(List<DuaEmbedding> embeddings) async {
    if (!isReady) return;

    try {
      final batch = <String, Map<String, dynamic>>{};
      for (final embedding in embeddings) {
        batch[embedding.id] = embedding.toJson();
      }
      await _embeddingsBox!.putAll(batch);
    } catch (e) {
      print('Error storing batch embeddings: $e');
    }
  }

  /// Get a Du'a embedding by ID
  Future<DuaEmbedding?> getEmbedding(String id) async {
    if (!isReady) return null;

    try {
      final data = _embeddingsBox!.get(id);
      if (data != null) {
        return DuaEmbedding.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      print('Error getting embedding: $e');
    }
    return null;
  }

  /// Get all embeddings for a specific language
  Future<List<DuaEmbedding>> getEmbeddingsByLanguage(String language) async {
    if (!isReady) return [];

    try {
      final embeddings = <DuaEmbedding>[];
      for (final data in _embeddingsBox!.values) {
        final embedding = DuaEmbedding.fromJson(
          Map<String, dynamic>.from(data),
        );
        if (embedding.language == language) {
          embeddings.add(embedding);
        }
      }
      return embeddings;
    } catch (e) {
      print('Error getting embeddings by language: $e');
      return [];
    }
  }

  /// Get all embeddings for a specific category
  Future<List<DuaEmbedding>> getEmbeddingsByCategory(String category) async {
    if (!isReady) return [];

    try {
      final embeddings = <DuaEmbedding>[];
      for (final data in _embeddingsBox!.values) {
        final embedding = DuaEmbedding.fromJson(
          Map<String, dynamic>.from(data),
        );
        if (embedding.category == category) {
          embeddings.add(embedding);
        }
      }
      return embeddings;
    } catch (e) {
      print('Error getting embeddings by category: $e');
      return [];
    }
  }

  /// Get all available embeddings
  Future<List<DuaEmbedding>> getAllEmbeddings() async {
    if (!isReady) return [];

    try {
      final embeddings = <DuaEmbedding>[];
      for (final data in _embeddingsBox!.values) {
        embeddings.add(DuaEmbedding.fromJson(Map<String, dynamic>.from(data)));
      }
      return embeddings;
    } catch (e) {
      print('Error getting all embeddings: $e');
      return [];
    }
  }

  /// Search embeddings by keywords
  Future<List<DuaEmbedding>> searchEmbeddingsByKeywords(
    List<String> keywords,
  ) async {
    if (!isReady) return [];

    try {
      final embeddings = <DuaEmbedding>[];
      final lowercaseKeywords = keywords.map((k) => k.toLowerCase()).toList();

      for (final data in _embeddingsBox!.values) {
        final embedding = DuaEmbedding.fromJson(
          Map<String, dynamic>.from(data),
        );

        // Check if any keyword matches
        final hasMatch = lowercaseKeywords.any(
          (keyword) =>
              embedding.keywords.any(
                (k) => k.toLowerCase().contains(keyword),
              ) ||
              embedding.text.toLowerCase().contains(keyword),
        );

        if (hasMatch) {
          embeddings.add(embedding);
        }
      }

      return embeddings;
    } catch (e) {
      print('Error searching embeddings by keywords: $e');
      return [];
    }
  }

  // Query History Management

  /// Store a search query
  Future<void> storeQuery(LocalSearchQuery query) async {
    if (!isReady) return;

    try {
      await _queriesBox!.put(query.id, query.toJson());
    } catch (e) {
      print('Error storing query: $e');
    }
  }

  /// Get recent queries
  Future<List<LocalSearchQuery>> getRecentQueries({int limit = 20}) async {
    if (!isReady) return [];

    try {
      final queries = <LocalSearchQuery>[];
      final values = _queriesBox!.values.toList();

      // Sort by timestamp (most recent first)
      values.sort((a, b) {
        final timeA = DateTime.parse(a['timestamp'] as String);
        final timeB = DateTime.parse(b['timestamp'] as String);
        return timeB.compareTo(timeA);
      });

      for (final data in values.take(limit)) {
        queries.add(LocalSearchQuery.fromJson(Map<String, dynamic>.from(data)));
      }

      return queries;
    } catch (e) {
      print('Error getting recent queries: $e');
      return [];
    }
  }

  /// Clear old queries (keep only recent ones)
  Future<void> cleanOldQueries({int keepCount = 100}) async {
    if (!isReady) return;

    try {
      final queries = await getRecentQueries(limit: 1000);
      if (queries.length > keepCount) {
        // Clear box and keep only recent ones
        await _queriesBox!.clear();
        final recentQueries = queries.take(keepCount);
        for (final query in recentQueries) {
          await _queriesBox!.put(query.id, query.toJson());
        }
      }
    } catch (e) {
      print('Error cleaning old queries: $e');
    }
  }

  // Search Results Cache Management

  /// Store a search result
  Future<void> storeSearchResult(
    String queryId,
    OfflineSearchResult result,
  ) async {
    if (!isReady) return;

    try {
      await _cacheBox!.put(queryId, result.toJson());
    } catch (e) {
      print('Error storing search result: $e');
    }
  }

  /// Get cached search result
  Future<OfflineSearchResult?> getCachedResult(String queryId) async {
    if (!isReady) return null;

    try {
      final data = _cacheBox!.get(queryId);
      if (data != null) {
        final result = OfflineSearchResult.fromJson(
          Map<String, dynamic>.from(data),
        );

        // Check if cache is still valid (24 hours)
        final now = DateTime.now();
        final cacheAge = now.difference(result.timestamp);
        if (cacheAge.inHours < 24) {
          return result.copyWith(isFromCache: true);
        } else {
          // Remove expired cache
          await _cacheBox!.delete(queryId);
        }
      }
    } catch (e) {
      print('Error getting cached result: $e');
    }
    return null;
  }

  /// Clear old cached results
  Future<void> cleanOldCache({
    Duration maxAge = const Duration(days: 7),
  }) async {
    if (!isReady) return;

    try {
      final keysToDelete = <String>[];
      final now = DateTime.now();

      for (final entry in _cacheBox!.toMap().entries) {
        try {
          final result = OfflineSearchResult.fromJson(
            Map<String, dynamic>.from(entry.value),
          );
          if (now.difference(result.timestamp) > maxAge) {
            keysToDelete.add(entry.key);
          }
        } catch (e) {
          // Invalid data, mark for deletion
          keysToDelete.add(entry.key);
        }
      }

      for (final key in keysToDelete) {
        await _cacheBox!.delete(key);
      }

      print('Cleaned ${keysToDelete.length} old cache entries');
    } catch (e) {
      print('Error cleaning old cache: $e');
    }
  }

  // Fallback Templates Management

  /// Store a fallback template
  Future<void> storeFallbackTemplate(FallbackTemplate template) async {
    if (!isReady) return;

    try {
      await _templatesBox!.put(template.id, template.toJson());
    } catch (e) {
      print('Error storing fallback template: $e');
    }
  }

  /// Store multiple fallback templates
  Future<void> storeBatchFallbackTemplates(
    List<FallbackTemplate> templates,
  ) async {
    if (!isReady) return;

    try {
      final batch = <String, Map<String, dynamic>>{};
      for (final template in templates) {
        batch[template.id] = template.toJson();
      }
      await _templatesBox!.putAll(batch);
    } catch (e) {
      print('Error storing batch fallback templates: $e');
    }
  }

  /// Get fallback templates by category and language
  Future<List<FallbackTemplate>> getFallbackTemplates({
    String? category,
    String? language,
  }) async {
    if (!isReady) return [];

    try {
      final templates = <FallbackTemplate>[];

      for (final data in _templatesBox!.values) {
        final template = FallbackTemplate.fromJson(
          Map<String, dynamic>.from(data),
        );

        bool matches = true;
        if (category != null && template.category != category) {
          matches = false;
        }
        if (language != null && template.language != language) {
          matches = false;
        }

        if (matches) {
          templates.add(template);
        }
      }

      // Sort by priority
      templates.sort((a, b) => b.priority.compareTo(a.priority));
      return templates;
    } catch (e) {
      print('Error getting fallback templates: $e');
      return [];
    }
  }

  /// Find best fallback template for keywords
  Future<FallbackTemplate?> findBestFallbackTemplate({
    required List<String> keywords,
    String? category,
    String? language,
  }) async {
    if (!isReady) return null;

    try {
      final templates = await getFallbackTemplates(
        category: category,
        language: language,
      );

      FallbackTemplate? bestMatch;
      double bestScore = 0.0;

      for (final template in templates) {
        double score = 0.0;

        // Calculate keyword match score
        for (final keyword in keywords) {
          if (template.keywords.any(
            (k) => k.toLowerCase().contains(keyword.toLowerCase()),
          )) {
            score += 1.0;
          }
        }

        // Add priority bonus
        score += template.priority * 0.1;

        if (score > bestScore) {
          bestScore = score;
          bestMatch = template;
        }
      }

      return bestMatch;
    } catch (e) {
      print('Error finding best fallback template: $e');
      return null;
    }
  }

  // Statistics and Info

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    if (!isReady) return {};

    try {
      return {
        'embeddings_count': _embeddingsBox!.length,
        'queries_count': _queriesBox!.length,
        'cached_results_count': _cacheBox!.length,
        'templates_count': _templatesBox!.length,
        'total_size_estimate': _estimateTotalSize(),
      };
    } catch (e) {
      print('Error getting storage stats: $e');
      return {};
    }
  }

  /// Get available languages
  Future<Set<String>> getAvailableLanguages() async {
    if (!isReady) return {};

    try {
      final languages = <String>{};
      for (final data in _embeddingsBox!.values) {
        final embedding = DuaEmbedding.fromJson(
          Map<String, dynamic>.from(data),
        );
        languages.add(embedding.language);
      }
      return languages;
    } catch (e) {
      print('Error getting available languages: $e');
      return {};
    }
  }

  /// Get available categories
  Future<Set<String>> getAvailableCategories() async {
    if (!isReady) return {};

    try {
      final categories = <String>{};
      for (final data in _embeddingsBox!.values) {
        final embedding = DuaEmbedding.fromJson(
          Map<String, dynamic>.from(data),
        );
        categories.add(embedding.category);
      }
      return categories;
    } catch (e) {
      print('Error getting available categories: $e');
      return {};
    }
  }

  /// Clear all data (for reset)
  Future<void> clearAllData() async {
    if (!isReady) return;

    try {
      await _embeddingsBox!.clear();
      await _queriesBox!.clear();
      await _cacheBox!.clear();
      await _templatesBox!.clear();
      print('All local storage data cleared');
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  /// Close all boxes and cleanup
  Future<void> dispose() async {
    try {
      await _embeddingsBox?.close();
      await _queriesBox?.close();
      await _cacheBox?.close();
      await _templatesBox?.close();
      _isInitialized = false;
    } catch (e) {
      print('Error disposing LocalVectorStorageService: $e');
    }
  }

  // Private helper methods

  int _estimateTotalSize() {
    try {
      int size = 0;

      // Estimate embeddings size
      for (final data in _embeddingsBox!.values) {
        size += jsonEncode(data).length;
      }

      // Estimate queries size
      for (final data in _queriesBox!.values) {
        size += jsonEncode(data).length;
      }

      // Estimate cache size
      for (final data in _cacheBox!.values) {
        size += jsonEncode(data).length;
      }

      // Estimate templates size
      for (final data in _templatesBox!.values) {
        size += jsonEncode(data).length;
      }

      return size;
    } catch (e) {
      return 0;
    }
  }
}
