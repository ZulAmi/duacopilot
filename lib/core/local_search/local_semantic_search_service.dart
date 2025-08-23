import 'package:duacopilot/core/logging/app_logger.dart';

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/rag_response.dart';
import 'models/local_search_models.dart';
import 'services/local_embedding_service.dart';
import 'services/fallback_template_service.dart';
import 'services/query_queue_service.dart';
import 'storage/local_vector_storage.dart';

/// Main local semantic search service that coordinates offline functionality
class LocalSemanticSearchService {
  static LocalSemanticSearchService? _instance;
  static LocalSemanticSearchService get instance =>
      _instance ??= LocalSemanticSearchService._();

  LocalSemanticSearchService._();

  // Services
  LocalEmbeddingService get _embeddingService => LocalEmbeddingService.instance;
  FallbackTemplateService get _templateService =>
      FallbackTemplateService.instance;
  QueryQueueService get _queueService => QueryQueueService.instance;
  LocalVectorStorage get _vectorStorage => LocalVectorStorage.instance;

  // Configuration
  static const double _similarityThreshold = 0.6;
  static const int _maxSearchResults = 5;

  // State
  bool _isInitialized = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isOnline = true;

  // Callbacks
  Function(bool)? _onConnectivityChanged;
  Function(LocalSearchResult)? _onOfflineResponseGenerated;

  /// Initialize the local semantic search service
  Future<void> initialize({
    Function(bool)? onConnectivityChanged,
    Function(LocalSearchResult)? onOfflineResponseGenerated,
  }) async {
    if (_isInitialized) return;

    try {
      AppLogger.debug('Initializing Local Semantic Search Service...');

      // Store callbacks
      _onConnectivityChanged = onConnectivityChanged;
      _onOfflineResponseGenerated = onOfflineResponseGenerated;

      // Initialize all services
      await _embeddingService.initialize();
      await _templateService.initialize();
      await _vectorStorage.initialize();

      // Initialize queue service with callbacks
      await _queueService.initialize(
        onQueryProcessed: _handleQueuedQueryProcessed,
        onQueryFailed: _handleQueuedQueryFailed,
        onQueueSizeChanged: _handleQueueSizeChanged,
      );

      // Set up connectivity monitoring
      await _setupConnectivityMonitoring();

      // Preload popular embeddings
      await _preloadPopularEmbeddings();

      _isInitialized = true;
      AppLogger.debug('Local Semantic Search Service initialized successfully');
    } catch (e) {
      AppLogger.debug('Error initializing Local Semantic Search Service: $e');
      throw Exception('Failed to initialize local search service: $e');
    }
  }

  /// Perform semantic search with automatic online/offline handling
  Future<SearchResponse> search({
    required String query,
    required String language,
    bool forceOffline = false,
    int maxResults = _maxSearchResults,
    double minSimilarity = _similarityThreshold,
  }) async {
    await _ensureInitialized();

    try {
      print(
        'Searching for: "$query" in $language (online: ${_isOnline && !forceOffline})',
      );

      // Check if we should try online search first
      if (_isOnline && !forceOffline) {
        try {
          // Try online search (this would integrate with your existing RAG service)
          final onlineResult = await _tryOnlineSearch(query, language);
          if (onlineResult != null) {
            // Store successful result for future offline use
            await _storeOnlineResult(query, language, onlineResult);

            return SearchResponse(
              results: [
                _convertRagResponseToLocalResult(onlineResult, query, language),
              ],
              isOnline: true,
              source: 'online_rag',
              totalResults: 1,
              searchTime: DateTime.now(),
              confidence: 0.95,
            );
          }
        } catch (e) {
          AppLogger.debug('Online search failed, falling back to offline: $e');
        }
      }

      // Perform offline search
      return await _performOfflineSearch(
        query: query,
        language: language,
        maxResults: maxResults,
        minSimilarity: minSimilarity,
      );
    } catch (e) {
      AppLogger.debug('Error during search: $e');
      return SearchResponse.empty(query, language);
    }
  }

  /// Get search suggestions based on local data
  Future<List<String>> getSuggestions({
    required String partialQuery,
    required String language,
    int limit = 10,
  }) async {
    await _ensureInitialized();

    try {
      final suggestions = <String>[];

      // Get suggestions from common queries
      final commonQueries = _templateService.getCommonQueries(
        language,
        limit: limit * 2,
      );
      for (final query in commonQueries) {
        if (query.toLowerCase().contains(partialQuery.toLowerCase())) {
          suggestions.add(query);
        }
      }

      // Get suggestions from stored embeddings
      final embeddings = await _vectorStorage.getEmbeddingsByLanguage(language);
      for (final embedding in embeddings) {
        if (embedding.query.toLowerCase().contains(
              partialQuery.toLowerCase(),
            ) &&
            !suggestions.contains(embedding.query)) {
          suggestions.add(embedding.query);
        }
      }

      // Sort by relevance and limit results
      suggestions.sort(
        (a, b) => _calculateSuggestionScore(
          partialQuery,
          b,
        ).compareTo(_calculateSuggestionScore(partialQuery, a)),
      );

      return suggestions.take(limit).toList();
    } catch (e) {
      AppLogger.debug('Error getting suggestions: $e');
      return [];
    }
  }

  /// Get offline search statistics
  Future<Map<String, dynamic>> getSearchStats() async {
    await _ensureInitialized();

    try {
      final embeddingStats = await _vectorStorage.getStorageStats();
      final queueStats = _queueService.getQueueStats();
      final templateStats = _templateService.getTemplateStats();

      return {
        'is_initialized': _isInitialized,
        'is_online': _isOnline,
        'embeddings': embeddingStats,
        'queue': queueStats,
        'templates': templateStats,
        'services_status': {
          'embedding_service': _embeddingService.isInitialized,
          'template_service': _templateService.isInitialized,
          'vector_storage': _vectorStorage.isInitialized,
          'queue_service': _queueService.isInitialized,
        },
      };
    } catch (e) {
      AppLogger.debug('Error getting search stats: $e');
      return {'error': e.toString()};
    }
  }

  /// Manually trigger sync when connectivity returns
  Future<void> syncPendingQueries() async {
    await _ensureInitialized();

    if (_isOnline) {
      await _queueService.processQueue();
    } else {
      AppLogger.debug('Cannot sync: device is offline');
    }
  }

  /// Preload embeddings for popular queries
  Future<void> preloadPopularQueries({String? language, int limit = 50}) async {
    await _ensureInitialized();

    try {
      AppLogger.debug('Preloading popular queries...');
      final languages =
          language != null ? [language] : ['en', 'ar', 'ur', 'id'];

      for (final lang in languages) {
        final commonQueries = _templateService.getCommonQueries(
          lang,
          limit: limit,
        );
        final embeddings = <DuaEmbedding>[];

        for (final query in commonQueries) {
          try {
            final embedding = await _embeddingService.generateEmbedding(
              query,
              lang,
            );
            final duaEmbedding = DuaEmbedding(
              id: _generateEmbeddingId(query, lang),
              query: query,
              duaText: 'Preloaded template response',
              embedding: embedding,
              language: lang,
              metadata: {'source': 'preload', 'category': 'common'},
              createdAt: DateTime.now(),
              popularity: 1.0, // High popularity for preloaded
              keywords: _extractKeywords(query),
              category: 'general',
            );
            embeddings.add(duaEmbedding);
          } catch (e) {
            AppLogger.debug('Failed to preload embedding for "$query": $e');
          }
        }

        if (embeddings.isNotEmpty) {
          await _vectorStorage.storeBatchEmbeddings(embeddings);
          AppLogger.debug('Preloaded ${embeddings.length} embeddings for $lang');
        }
      }
    } catch (e) {
      AppLogger.debug('Error preloading popular queries: $e');
    }
  }

  /// Clear offline data
  Future<void> clearOfflineData() async {
    await _ensureInitialized();

    try {
      await _vectorStorage.clearEmbeddings();
      await _queueService.clearQueue();
      AppLogger.debug('Offline data cleared');
    } catch (e) {
      AppLogger.debug('Error clearing offline data: $e');
    }
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _queueService.dispose();
    await _vectorStorage.dispose();
    await _embeddingService.dispose();

    _isInitialized = false;
    AppLogger.debug('Local Semantic Search Service disposed');
  }

  // Private methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _setupConnectivityMonitoring() async {
    try {
      // Check initial connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      _isOnline = connectivityResult != ConnectivityResult.none;

      // Monitor connectivity changes
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
        ConnectivityResult result,
      ) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;

        if (_isOnline != wasOnline) {
          AppLogger.debug('Connectivity changed: ${_isOnline ? 'Online' : 'Offline'}');
          _onConnectivityChanged?.call(_isOnline);

          if (_isOnline) {
            // Trigger queue processing when coming online
            _queueService.processQueue();
          }
        }
      });
    } catch (e) {
      AppLogger.debug('Error setting up connectivity monitoring: $e');
    }
  }

  Future<SearchResponse> _performOfflineSearch({
    required String query,
    required String language,
    required int maxResults,
    required double minSimilarity,
  }) async {
    final stopwatch = Stopwatch()..start();
    final results = <LocalSearchResult>[];

    try {
      // 1. Try semantic similarity search in stored embeddings
      final queryEmbedding = await _embeddingService.generateEmbedding(
        query,
        language,
      );
      final similarMatches = await _vectorStorage.searchSimilar(
        queryEmbedding,
        language,
        limit: maxResults,
        minSimilarity: minSimilarity,
      );

      // Convert similarity matches to search results
      for (final match in similarMatches) {
        final result = LocalSearchResult(
          id: match.embedding.id,
          query: query,
          response: match.embedding.duaText,
          confidence: match.similarity,
          source: 'vector_similarity',
          isOffline: true,
          metadata: {
            ...match.embedding.metadata,
            'similarity_score': match.similarity,
            'match_reason': match.matchReason,
          },
          relatedQueries: [],
          timestamp: DateTime.now(),
          language: language,
          quality: ResponseQuality.offline(
            accuracy: match.similarity,
            relevance: match.similarity,
          ),
        );
        results.add(result);
      }

      // 2. If no good semantic matches, try fallback templates
      if (results.isEmpty || results.first.confidence < 0.8) {
        final templateResult = await _templateService.generateFallbackResponse(
          query,
          language,
          confidenceBoost:
              results.isEmpty
                  ? 0.0
                  : -0.2, // Lower confidence if we have other results
        );

        if (templateResult != null) {
          results.add(templateResult);
        }
      }

      // 3. Queue the query for online processing when connected
      if (_isOnline) {
        await _queueService.enqueueQuery(
          query: query,
          language: language,
          priority:
              results.isEmpty ? 2 : 1, // Higher priority if no offline results
          localResponseId: results.isNotEmpty ? results.first.id : null,
        );
      }

      stopwatch.stop();

      // Sort results by confidence
      results.sort((a, b) => b.confidence.compareTo(a.confidence));

      // Notify about offline response generation
      if (results.isNotEmpty) {
        _onOfflineResponseGenerated?.call(results.first);
      }

      return SearchResponse(
        results: results.take(maxResults).toList(),
        isOnline: false,
        source: 'offline_search',
        totalResults: results.length,
        searchTime: DateTime.now(),
        confidence: results.isNotEmpty ? results.first.confidence : 0.0,
        processingTime: stopwatch.elapsed,
      );
    } catch (e) {
      AppLogger.debug('Error in offline search: $e');
      stopwatch.stop();
      return SearchResponse.empty(query, language);
    }
  }

  Future<RagResponse?> _tryOnlineSearch(String query, String language) async {
    // This would integrate with your existing RAG service
    // For now, we'll simulate it
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    // Simulate success/failure (80% success rate for demo)
    if (DateTime.now().millisecond % 10 < 8) {
      return RagResponse(
        id: 'online_${DateTime.now().millisecondsSinceEpoch}',
        query: query,
        response: 'This is a simulated online RAG response for: $query',
        timestamp: DateTime.now(),
        responseTime: 500,
        confidence: 0.95,
        model: 'gpt-4',
        metadata: {'source': 'online_rag', 'language': language},
      );
    }

    return null; // Simulate failure
  }

  Future<void> _storeOnlineResult(
    String query,
    String language,
    RagResponse response,
  ) async {
    try {
      final embedding = await _embeddingService.generateEmbedding(
        query,
        language,
      );
      final duaEmbedding = DuaEmbedding(
        id: _generateEmbeddingId(query, language),
        query: query,
        duaText: response.response,
        embedding: embedding,
        language: language,
        metadata: {
          'source': 'online_rag',
          'rag_response_id': response.id,
          'confidence': response.confidence,
          'model': response.model,
        },
        createdAt: DateTime.now(),
        popularity: 0.5, // Medium popularity for online results
        keywords: _extractKeywords(query),
        category: _categorizeQuery(query),
      );

      await _vectorStorage.storeEmbedding(duaEmbedding);
    } catch (e) {
      AppLogger.debug('Error storing online result: $e');
    }
  }

  LocalSearchResult _convertRagResponseToLocalResult(
    RagResponse ragResponse,
    String query,
    String language,
  ) {
    return LocalSearchResult(
      id: ragResponse.id,
      query: query,
      response: ragResponse.response,
      confidence: ragResponse.confidence ?? 0.95,
      source: 'online_rag',
      isOffline: false,
      metadata: ragResponse.metadata ?? {},
      relatedQueries: [],
      timestamp: ragResponse.timestamp,
      language: language,
      quality: ResponseQuality.online(),
    );
  }

  Future<void> _preloadPopularEmbeddings() async {
    try {
      // This would typically load from a curated dataset
      // For now, we'll just ensure we have some basic embeddings
      final hasEmbeddings =
          (await _vectorStorage.getStorageStats())['embeddings_count'] > 0;

      if (!hasEmbeddings) {
        await preloadPopularQueries(limit: 20);
      }
    } catch (e) {
      AppLogger.debug('Error preloading embeddings: $e');
    }
  }

  String _generateEmbeddingId(String query, String language) {
    return '${language}_${query.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
  }

  List<String> _extractKeywords(String query) {
    return query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2)
        .toList();
  }

  String _categorizeQuery(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dua') || lowerQuery.contains('دعاء')) {
      return 'dua';
    } else if (lowerQuery.contains('prayer') || lowerQuery.contains('صلاة')) {
      return 'prayer';
    } else if (lowerQuery.contains('quran') || lowerQuery.contains('قرآن')) {
      return 'quran';
    } else if (lowerQuery.contains('hadith') || lowerQuery.contains('حديث')) {
      return 'hadith';
    }

    return 'general';
  }

  double _calculateSuggestionScore(String partial, String suggestion) {
    final partialLower = partial.toLowerCase();
    final suggestionLower = suggestion.toLowerCase();

    if (suggestionLower.startsWith(partialLower)) return 1.0;
    if (suggestionLower.contains(partialLower)) return 0.8;

    // Word overlap score
    final partialWords = partialLower.split(' ');
    final suggestionWords = suggestionLower.split(' ');
    final overlap =
        partialWords.where((word) => suggestionWords.contains(word)).length;

    return overlap / partialWords.length * 0.6;
  }

  // Queue service callbacks
  void _handleQueuedQueryProcessed(PendingQuery query) {
    AppLogger.debug('Queued query processed: ${query.query}');
  }

  void _handleQueuedQueryFailed(PendingQuery query, String error) {
    AppLogger.debug('Queued query failed: ${query.query} - $error');
  }

  void _handleQueueSizeChanged(int newSize) {
    AppLogger.debug('Queue size changed: $newSize pending queries');
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if device is online
  bool get isOnline => _isOnline;

  /// Get current queue size
  int get queueSize => _queueService.queueSize;
}

/// Search response containing results and metadata
class SearchResponse {
  final List<LocalSearchResult> results;
  final bool isOnline;
  final String source;
  final int totalResults;
  final DateTime searchTime;
  final double confidence;
  final Duration? processingTime;

  const SearchResponse({
    required this.results,
    required this.isOnline,
    required this.source,
    required this.totalResults,
    required this.searchTime,
    required this.confidence,
    this.processingTime,
  });

  bool get isEmpty => results.isEmpty;
  bool get hasResults => results.isNotEmpty;
  LocalSearchResult? get bestResult =>
      results.isNotEmpty ? results.first : null;

  factory SearchResponse.empty(String query, String language) {
    return SearchResponse(
      results: [],
      isOnline: false,
      source: 'no_results',
      totalResults: 0,
      searchTime: DateTime.now(),
      confidence: 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((r) => r.toJson()).toList(),
      'is_online': isOnline,
      'source': source,
      'total_results': totalResults,
      'search_time': searchTime.toIso8601String(),
      'confidence': confidence,
      'processing_time_ms': processingTime?.inMilliseconds,
    };
  }
}
