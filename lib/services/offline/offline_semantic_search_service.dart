import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/offline/offline_search_models.dart';
import '../rag_service.dart';
import 'fallback_template_service.dart';
import 'local_embedding_service.dart';
import 'local_vector_storage_service.dart';
import 'query_queue_service.dart';

/// Comprehensive offline semantic search service
class OfflineSemanticSearchService {
  static const double _minSimilarityThreshold = 0.4;

  final LocalEmbeddingService _embeddingService;
  final LocalVectorStorageService _storageService;
  final QueryQueueService _queueService;
  final FallbackTemplateService _templateService;
  final RagService _ragService;
  final Connectivity _connectivity;
  final SharedPreferences _prefs;

  bool _isInitialized = false;
  final StreamController<OfflineSearchResult> _searchResultsController =
      StreamController<OfflineSearchResult>.broadcast();

  OfflineSemanticSearchService({
    required LocalEmbeddingService embeddingService,
    required LocalVectorStorageService storageService,
    required QueryQueueService queueService,
    required FallbackTemplateService templateService,
    required RagService ragService,
    required Connectivity connectivity,
    required SharedPreferences prefs,
  })  : _embeddingService = embeddingService,
        _storageService = storageService,
        _queueService = queueService,
        _templateService = templateService,
        _ragService = ragService,
        _connectivity = connectivity,
        _prefs = prefs;

  /// Stream of search results for reactive UI updates
  Stream<OfflineSearchResult> get searchResults => _searchResultsController.stream;

  /// Initialize all offline search components
  Future<void> initialize() async {
    try {
      print('Initializing OfflineSemanticSearchService...');

      // Initialize all services in parallel
      await Future.wait([
        _embeddingService.initialize(),
        _storageService.initialize(),
        _templateService.initialize(),
        _queueService.initialize(),
      ]);

      _isInitialized = true;
      print('OfflineSemanticSearchService initialized successfully');

      // Start periodic sync if online
      _startPeriodicSync();
    } catch (e) {
      print('Failed to initialize OfflineSemanticSearchService: $e');
      _isInitialized = false;
      // Continue in degraded mode
    }
  }

  bool get isReady => _isInitialized;

  /// Get access to storage service for external operations
  LocalVectorStorageService get storageService => _storageService;

  /// Main search method with intelligent offline/online routing
  Future<OfflineSearchResult> search({
    required String query,
    required String language,
    String? category,
    String? location,
    Map<String, dynamic>? context,
    bool forceOffline = false,
  }) async {
    final queryId = _generateQueryId();
    final searchContext = context ?? {};

    try {
      // Check if we should try online first
      if (!forceOffline && await _shouldTryOnlineFirst()) {
        try {
          final onlineResult = await _tryOnlineSearch(
            query: query,
            language: language,
            location: location,
            context: searchContext,
          );

          if (onlineResult != null) {
            // Cache the online result for offline use
            await _cacheOnlineResult(queryId, query, onlineResult);
            return _convertToOfflineResult(onlineResult, queryId, SearchQuality.high);
          }
        } catch (e) {
          print('Online search failed, falling back to offline: $e');
        }
      }

      // Try offline semantic search
      final offlineResult = await _performOfflineSearch(
        queryId: queryId,
        query: query,
        language: language,
        category: category,
        context: searchContext,
      );

      // Queue for online processing if offline result is low quality
      if (offlineResult.quality == SearchQuality.low && !forceOffline) {
        await _queueService.queueQuery(
          query: query,
          language: language,
          context: searchContext,
          location: location,
          fallbackResultId: queryId,
        );
      }

      _searchResultsController.add(offlineResult);
      return offlineResult;
    } catch (e) {
      print('Search failed completely: $e');

      // Last resort: generic fallback
      final fallbackResult = await _templateService.getFallbackResponse(
        query: query,
        language: language,
        category: category,
        context: searchContext,
      );

      if (fallbackResult != null) {
        _searchResultsController.add(fallbackResult);
        return fallbackResult;
      }

      // Ultimate fallback
      return _createEmergencyFallback(queryId, query, language);
    }
  }

  /// Search similar Du'as using local embeddings
  Future<List<OfflineDuaMatch>> searchSimilarDuas({
    required String query,
    required String language,
    String? category,
    int maxResults = 5,
  }) async {
    if (!isReady || !_embeddingService.isReady) {
      return [];
    }

    try {
      // Generate embedding for query
      final queryEmbedding = await _embeddingService.generateEmbedding(query);

      // Get candidate embeddings
      List<DuaEmbedding> candidates;
      if (category != null) {
        candidates = await _storageService.getEmbeddingsByCategory(category);
      } else {
        candidates = await _storageService.getEmbeddingsByLanguage(language);
      }

      if (candidates.isEmpty) {
        return [];
      }

      // Calculate similarities
      final similarities = <MapEntry<DuaEmbedding, double>>[];
      for (final candidate in candidates) {
        final similarity = _embeddingService.calculateSimilarity(queryEmbedding, candidate.vector);

        if (similarity >= _minSimilarityThreshold) {
          similarities.add(MapEntry(candidate, similarity));
        }
      }

      // Sort by similarity and take top results
      similarities.sort((a, b) => b.value.compareTo(a.value));

      // Convert to OfflineDuaMatch
      final matches = <OfflineDuaMatch>[];
      for (final entry in similarities.take(maxResults)) {
        final embedding = entry.key;
        final similarity = entry.value;

        matches.add(
          OfflineDuaMatch(
            duaId: embedding.duaId,
            text: embedding.text,
            translation: embedding.metadata['translation'] as String? ?? embedding.text,
            transliteration: embedding.metadata['transliteration'] as String? ?? '',
            category: embedding.category,
            similarityScore: similarity,
            matchedKeywords: _extractMatchedKeywords(query, embedding.keywords),
            matchReason: 'Semantic similarity match (${(similarity * 100).toInt()}%)',
            metadata: {
              'embedding_id': embedding.id,
              'similarity_score': similarity,
              'search_method': 'semantic_embedding',
              ...embedding.metadata,
            },
          ),
        );
      }

      return matches;
    } catch (e) {
      print('Error in semantic similarity search: $e');
      return [];
    }
  }

  /// Get offline search statistics
  Future<Map<String, dynamic>> getSearchStatistics() async {
    if (!isReady) return {};

    try {
      final storageStats = await _storageService.getStorageStats();
      final queueStats = _queueService.getQueueStatistics();
      final templateStats = await _templateService.getTemplateStats();

      return {
        'storage': storageStats,
        'queue': queueStats,
        'templates': templateStats,
        'embedding_service_ready': _embeddingService.isReady,
        'available_languages': await _storageService.getAvailableLanguages(),
        'available_categories': await _storageService.getAvailableCategories(),
      };
    } catch (e) {
      print('Error getting search statistics: $e');
      return {};
    }
  }

  /// Sync embeddings with remote server (progressive enhancement)
  Future<void> syncWithRemote() async {
    if (!await _isOnline()) return;

    try {
      print('Starting sync with remote server...');

      // This would typically fetch embeddings from your backend
      // For now, we'll simulate with a placeholder
      await _simulateRemoteSync();

      // Update last sync timestamp
      await _prefs.setString('last_offline_sync', DateTime.now().toIso8601String());

      print('Sync completed successfully');
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  /// Clear all offline data and reset
  Future<void> clearOfflineData() async {
    try {
      await _storageService.clearAllData();
      await _queueService.cleanQueue();
      print('All offline data cleared');
    } catch (e) {
      print('Error clearing offline data: $e');
    }
  }

  /// Dispose and cleanup resources
  Future<void> dispose() async {
    await _searchResultsController.close();
    await _storageService.dispose();
    _embeddingService.dispose();
  }

  // Private methods

  Future<bool> _shouldTryOnlineFirst() async {
    // Check if online
    if (!await _isOnline()) return false;

    // Check if we haven't tried online recently
    final lastOnlineAttempt = _prefs.getString('last_online_attempt');
    if (lastOnlineAttempt != null) {
      final lastAttempt = DateTime.parse(lastOnlineAttempt);
      if (DateTime.now().difference(lastAttempt).inMinutes < 5) {
        return false; // Don't spam online requests
      }
    }

    return true;
  }

  Future<dynamic> _tryOnlineSearch({
    required String query,
    required String language,
    String? location,
    required Map<String, dynamic> context,
  }) async {
    await _prefs.setString('last_online_attempt', DateTime.now().toIso8601String());

    // Try online search with timeout
    return await _ragService
        .searchDuas(query: query, language: language, location: location, additionalContext: context)
        .timeout(const Duration(seconds: 10));
  }

  Future<OfflineSearchResult> _performOfflineSearch({
    required String queryId,
    required String query,
    required String language,
    String? category,
    required Map<String, dynamic> context,
  }) async {
    // Check cache first
    final cachedResult = await _storageService.getCachedResult(queryId);
    if (cachedResult != null) {
      return cachedResult;
    }

    // Try semantic search if embeddings available
    final semanticMatches = await searchSimilarDuas(query: query, language: language, category: category);

    if (semanticMatches.isNotEmpty) {
      final result = OfflineSearchResult(
        queryId: queryId,
        matches: semanticMatches,
        confidence: _calculateConfidence(semanticMatches),
        quality: SearchQuality.medium,
        reasoning: 'Local semantic search with ${semanticMatches.length} matches',
        timestamp: DateTime.now(),
        metadata: {
          'search_method': 'local_semantic',
          'embedding_service_used': _embeddingService.isReady,
          'total_candidates': await _storageService.getStorageStats().then((s) => s['embeddings_count']),
        },
      );

      await _storageService.storeSearchResult(queryId, result);
      return result;
    }

    // Fall back to keyword search
    final keywordMatches = await _performKeywordSearch(query, language, category);
    if (keywordMatches.isNotEmpty) {
      final result = OfflineSearchResult(
        queryId: queryId,
        matches: keywordMatches,
        confidence: 0.4,
        quality: SearchQuality.medium,
        reasoning: 'Keyword search with ${keywordMatches.length} matches',
        timestamp: DateTime.now(),
        metadata: {'search_method': 'keyword_search'},
      );

      await _storageService.storeSearchResult(queryId, result);
      return result;
    }

    // Use fallback templates
    final fallbackResult = await _templateService.getFallbackResponse(
      query: query,
      language: language,
      category: category,
      context: context,
    );

    if (fallbackResult != null) {
      await _storageService.storeSearchResult(queryId, fallbackResult);
      return fallbackResult;
    }

    // Last resort
    return _createEmergencyFallback(queryId, query, language);
  }

  Future<List<OfflineDuaMatch>> _performKeywordSearch(String query, String language, String? category) async {
    final keywords = query.toLowerCase().split(' ').where((word) => word.isNotEmpty && word.length > 2).toList();

    final embeddings = await _storageService.searchEmbeddingsByKeywords(keywords);

    // Filter by language and category
    final filteredEmbeddings = embeddings.where((e) {
      if (e.language != language) return false;
      if (category != null && e.category != category) return false;
      return true;
    }).toList();

    // Convert to matches
    final matches = <OfflineDuaMatch>[];
    for (final embedding in filteredEmbeddings.take(5)) {
      final matchedKeywords = _extractMatchedKeywords(query, embedding.keywords);

      matches.add(
        OfflineDuaMatch(
          duaId: embedding.duaId,
          text: embedding.text,
          translation: embedding.metadata['translation'] as String? ?? embedding.text,
          transliteration: embedding.metadata['transliteration'] as String? ?? '',
          category: embedding.category,
          similarityScore: matchedKeywords.length / keywords.length,
          matchedKeywords: matchedKeywords,
          matchReason: 'Keyword match: ${matchedKeywords.join(", ")}',
          metadata: {'embedding_id': embedding.id, 'search_method': 'keyword_search', ...embedding.metadata},
        ),
      );
    }

    return matches;
  }

  List<String> _extractMatchedKeywords(String query, List<String> candidateKeywords) {
    final queryWords = query.toLowerCase().split(' ');
    final matched = <String>[];

    for (final keyword in candidateKeywords) {
      for (final word in queryWords) {
        if (keyword.toLowerCase().contains(word) || word.contains(keyword.toLowerCase())) {
          matched.add(keyword);
          break;
        }
      }
    }

    return matched;
  }

  double _calculateConfidence(List<OfflineDuaMatch> matches) {
    if (matches.isEmpty) return 0.0;

    final avgSimilarity = matches.map((m) => m.similarityScore).reduce((a, b) => a + b) / matches.length;

    // Boost confidence if we have multiple good matches
    if (matches.length >= 3 && avgSimilarity > 0.6) {
      return (avgSimilarity * 0.8).clamp(0.0, 1.0);
    }

    return (avgSimilarity * 0.6).clamp(0.0, 1.0);
  }

  Future<void> _cacheOnlineResult(String queryId, String query, dynamic onlineResult) async {
    // Convert online result to offline format for caching
    // Implementation depends on your online result format
  }

  OfflineSearchResult _convertToOfflineResult(dynamic onlineResult, String queryId, SearchQuality quality) {
    // Convert online result to OfflineSearchResult
    // Implementation depends on your online result format

    return OfflineSearchResult(
      queryId: queryId,
      matches: [], // Convert from online format
      confidence: 0.9,
      quality: quality,
      reasoning: 'Online search result',
      timestamp: DateTime.now(),
      metadata: {'source': 'online'},
    );
  }

  OfflineSearchResult _createEmergencyFallback(String queryId, String query, String language) {
    final isArabic = language == 'ar';

    return OfflineSearchResult(
      queryId: queryId,
      matches: [
        OfflineDuaMatch(
          duaId: 'emergency_fallback',
          text: isArabic
              ? 'عذرًا، لا توجد نتائج متاحة في الوضع الحالي'
              : 'Sorry, no results are available in the current mode',
          translation: isArabic
              ? 'عذرًا، لا توجد نتائج متاحة في الوضع الحالي'
              : 'Sorry, no results are available in the current mode',
          transliteration: '',
          category: 'system',
          similarityScore: 0.0,
          matchedKeywords: [],
          matchReason: 'Emergency fallback - no other options available',
          metadata: {'is_emergency_fallback': true, 'original_query': query},
        ),
      ],
      confidence: 0.0,
      quality: SearchQuality.low,
      reasoning: 'Emergency fallback - all search methods failed',
      timestamp: DateTime.now(),
      metadata: {'is_emergency_fallback': true},
    );
  }

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void _startPeriodicSync() {
    Timer.periodic(const Duration(hours: 6), (timer) {
      if (_isInitialized) {
        syncWithRemote();
        _queueService.processQueue();
      }
    });
  }

  Future<void> _simulateRemoteSync() async {
    // This would be replaced with actual API calls to fetch embeddings
    // For now, just simulate with a delay
    await Future.delayed(const Duration(seconds: 2));
    print('Remote sync simulation completed');
  }

  String _generateQueryId() {
    return 'offline_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().hashCode.abs()}';
  }
}
