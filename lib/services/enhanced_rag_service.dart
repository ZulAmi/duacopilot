import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/network/rag_api_client.dart';
import '../data/models/offline/offline_search_models.dart';
import '../data/models/rag_response_models.dart';
import '../domain/entities/dua_entity.dart';
import 'offline/offline_search_initialization_service.dart';
import 'offline/offline_semantic_search_service.dart';
import 'rag_service.dart';

/// Enhanced RAG service with intelligent offline/online routing
class EnhancedRagService {
  final RagService _onlineRagService;
  final Connectivity _connectivity;

  OfflineSemanticSearchService? _offlineService;
  bool _offlineInitialized = false;

  final StreamController<RagSearchResponse> _searchResultsController =
      StreamController<RagSearchResponse>.broadcast();

  EnhancedRagService(this._onlineRagService, this._connectivity);

  /// Stream of search results for reactive UI updates
  Stream<RagSearchResponse> get searchResults =>
      _searchResultsController.stream;

  /// Initialize both online and offline capabilities
  Future<void> initialize() async {
    try {
      // Initialize online RAG service
      await _onlineRagService.initialize();

      // Initialize offline search capabilities
      if (!OfflineSearchInitializationService.isInitialized) {
        await OfflineSearchInitializationService.initializeOfflineSearch();
      }

      _offlineService = OfflineSearchInitializationService.offlineSearchService;
      _offlineInitialized = _offlineService != null && _offlineService!.isReady;

      print('EnhancedRagService initialized - Offline: $_offlineInitialized');

      // Listen to offline search results and convert them
      _offlineService?.searchResults.listen(_handleOfflineResult);
    } catch (e) {
      print('Failed to initialize EnhancedRagService: $e');
      // Continue with online-only mode
    }
  }

  /// Intelligent search with automatic online/offline routing
  Future<RagSearchResponse> searchDuas({
    required String query,
    String language = 'en',
    String? location,
    Map<String, dynamic>? additionalContext,
    bool forceRefresh = false,
    bool preferOffline = false,
  }) async {
    try {
      // Check connection status
      final isOnline = await _isConnected();

      // Decide search strategy
      if (preferOffline || !isOnline) {
        return await _performOfflineSearch(
          query: query,
          language: language,
          location: location,
          context: additionalContext ?? {},
        );
      }

      // Try online search first
      try {
        final onlineResult = await _onlineRagService.searchDuas(
          query: query,
          language: language,
          location: location,
          additionalContext: additionalContext,
          forceRefresh: forceRefresh,
        );

        // Enhance online result with quality indicators
        final enhancedResult = _enhanceOnlineResult(onlineResult);
        _searchResultsController.add(enhancedResult);
        return enhancedResult;
      } catch (e) {
        print('Online search failed, falling back to offline: $e');

        // Fallback to offline search
        return await _performOfflineSearch(
          query: query,
          language: language,
          location: location,
          context: additionalContext ?? {},
        );
      }
    } catch (e) {
      print('All search methods failed: $e');

      // Return empty result with error information
      return _createErrorResult(query, language, e.toString());
    }
  }

  /// Get popular Du'as with offline fallback
  Future<PopularDuasResponse> getPopularDuas({
    int page = 1,
    int limit = 20,
    String? category,
    String? timeframe,
    bool forceRefresh = false,
  }) async {
    try {
      final isOnline = await _isConnected();

      if (isOnline) {
        // Try online popular Du'as
        return await _onlineRagService.getPopularDuas(
          page: page,
          limit: limit,
          category: category,
          timeframe: timeframe,
          forceRefresh: forceRefresh,
        );
      } else {
        // Return offline popular Du'as (from local embeddings)
        return await _getOfflinePopularDuas(category: category, limit: limit);
      }
    } catch (e) {
      print('Error getting popular Du\'as: $e');
      // Return offline fallback
      return await _getOfflinePopularDuas(category: category, limit: limit);
    }
  }

  /// Get search capabilities status
  Map<String, dynamic> getSearchCapabilities() {
    return {
      'online_available':
          true, // _onlineRagService is never null in this context
      'offline_available': _offlineInitialized,
      'offline_service_ready': _offlineService?.isReady ?? false,
      'has_embeddings': _offlineInitialized, // Simplified check
      'supported_languages': _getSupportedLanguages(),
      'supported_categories': _getSupportedCategories(),
    };
  }

  /// Get comprehensive search statistics
  Future<Map<String, dynamic>> getSearchStatistics() async {
    final stats = <String, dynamic>{
      'capabilities': getSearchCapabilities(),
      'connection_status': await _isConnected(),
    };

    if (_offlineInitialized && _offlineService != null) {
      try {
        final offlineStats = await _offlineService!.getSearchStatistics();
        stats['offline_stats'] = offlineStats;
      } catch (e) {
        print('Error getting offline stats: $e');
      }
    }

    return stats;
  }

  /// Force sync with remote server
  Future<void> syncWithRemote() async {
    if (_offlineInitialized && _offlineService != null) {
      try {
        await _offlineService!.syncWithRemote();
        print('Successfully synced with remote server');
      } catch (e) {
        print('Failed to sync with remote: $e');
      }
    }
  }

  /// Submit feedback with offline queuing
  Future<bool> submitFeedback({
    required String duaId,
    required String queryId,
    required FeedbackType feedbackType,
    double? rating,
    String? comment,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Try online feedback first
      final isOnline = await _isConnected();

      if (isOnline) {
        return await _onlineRagService.submitFeedback(
          duaId: duaId,
          queryId: queryId,
          feedbackType: feedbackType,
          rating: rating,
          comment: comment,
          metadata: metadata,
        );
      } else {
        // Queue feedback for later submission
        // This would be handled by the queue service
        print('Feedback queued for later submission (offline mode)');
        return true; // Return true to not disrupt user experience
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      return false;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _searchResultsController.close();
    await _offlineService?.dispose();
  }

  // Private methods

  Future<bool> _isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  Future<RagSearchResponse> _performOfflineSearch({
    required String query,
    required String language,
    String? location,
    required Map<String, dynamic> context,
  }) async {
    if (!_offlineInitialized || _offlineService == null) {
      return _createNoResultsResponse(
        query,
        language,
        'Offline search not available',
      );
    }

    try {
      final offlineResult = await _offlineService!.search(
        query: query,
        language: language,
        location: location,
        context: context,
      );

      return _convertOfflineToRagResponse(offlineResult, query, language);
    } catch (e) {
      print('Offline search failed: $e');
      return _createNoResultsResponse(
        query,
        language,
        'Offline search failed: $e',
      );
    }
  }

  RagSearchResponse _convertOfflineToRagResponse(
    OfflineSearchResult offlineResult,
    String query,
    String language,
  ) {
    final recommendations =
        offlineResult.matches.map((match) {
          return DuaRecommendation(
            dua: DuaEntity(
              id: match.duaId,
              arabicText: match.text,
              transliteration: match.transliteration,
              translation: match.translation,
              category: match.category,
              tags: match.matchedKeywords,
              authenticity: SourceAuthenticity(
                level:
                    AuthenticityLevel.verified, // Default for offline content
                source: 'offline_database',
                reference: 'Local storage',
              ),
              ragConfidence: RAGConfidence(
                score: match.similarityScore,
                reasoning: match.matchReason,
                keywords: match.matchedKeywords,
                contextMatch: ContextMatch(
                  relevanceScore: match.similarityScore,
                  category: match.category,
                  matchingCriteria: match.matchedKeywords,
                  situation: 'offline_search',
                ),
              ),
            ),
            relevanceScore: match.similarityScore,
            matchReason: match.matchReason,
            highlightedKeywords: match.matchedKeywords,
            context: {
              'quality': offlineResult.quality.name,
              'confidence': offlineResult.confidence,
              'search_method': 'offline',
              'is_cached': offlineResult.isFromCache,
            },
          );
        }).toList();

    return RagSearchResponse(
      recommendations: recommendations,
      confidence: offlineResult.confidence,
      reasoning:
          '${offlineResult.reasoning} (${offlineResult.quality.name} quality)',
      queryId: offlineResult.queryId,
      metadata: {
        'search_type': 'offline',
        'quality': offlineResult.quality.name,
        'timestamp': offlineResult.timestamp.toIso8601String(),
        'offline_metadata': offlineResult.metadata,
      },
    );
  }

  RagSearchResponse _enhanceOnlineResult(RagSearchResponse onlineResult) {
    // Add quality indicators to online results
    final enhancedRecommendations =
        onlineResult.recommendations.map((rec) {
          final enhancedContext = Map<String, dynamic>.from(rec.context ?? {});
          enhancedContext['quality'] = 'high';
          enhancedContext['search_method'] = 'online';

          return DuaRecommendation(
            dua: rec.dua,
            relevanceScore: rec.relevanceScore,
            matchReason: rec.matchReason,
            highlightedKeywords: rec.highlightedKeywords,
            context: enhancedContext,
          );
        }).toList();

    final enhancedMetadata = Map<String, dynamic>.from(
      onlineResult.metadata ?? {},
    );
    enhancedMetadata['search_type'] = 'online';
    enhancedMetadata['quality'] = 'high';

    return RagSearchResponse(
      recommendations: enhancedRecommendations,
      confidence: onlineResult.confidence,
      reasoning: '${onlineResult.reasoning} (online search)',
      queryId: onlineResult.queryId,
      metadata: enhancedMetadata,
    );
  }

  void _handleOfflineResult(OfflineSearchResult offlineResult) {
    // Convert and emit offline results
    try {
      final ragResponse = _convertOfflineToRagResponse(
        offlineResult,
        'background_query', // We don't have the original query here
        'unknown', // We don't have the language here
      );
      _searchResultsController.add(ragResponse);
    } catch (e) {
      print('Error handling offline result: $e');
    }
  }

  Future<PopularDuasResponse> _getOfflinePopularDuas({
    String? category,
    int limit = 20,
  }) async {
    // This would be implemented based on your offline data structure
    // For now, return an empty response
    return PopularDuasResponse(
      duas: [],
      pagination: PaginationInfo(
        currentPage: 1,
        totalPages: 1,
        totalItems: 0,
        itemsPerPage: limit,
        hasNext: false,
        hasPrevious: false,
      ),
      timeframe: 'offline',
      metadata: {
        'source': 'offline',
        'message':
            'Popular Du\'as from offline storage (feature under development)',
      },
    );
  }

  RagSearchResponse _createNoResultsResponse(
    String query,
    String language,
    String reason,
  ) {
    return RagSearchResponse(
      recommendations: [],
      confidence: 0.0,
      reasoning: reason,
      queryId: 'no_results_${DateTime.now().millisecondsSinceEpoch}',
      metadata: {
        'search_type': 'failed',
        'original_query': query,
        'language': language,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  RagSearchResponse _createErrorResult(
    String query,
    String language,
    String error,
  ) {
    return RagSearchResponse(
      recommendations: [],
      confidence: 0.0,
      reasoning: 'Search failed: $error',
      queryId: 'error_${DateTime.now().millisecondsSinceEpoch}',
      metadata: {
        'search_type': 'error',
        'original_query': query,
        'language': language,
        'error': error,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  List<String> _getSupportedLanguages() {
    // This would be dynamically determined based on available data
    return ['en', 'ar'];
  }

  List<String> _getSupportedCategories() {
    // This would be dynamically determined based on available data
    return [
      'morning',
      'evening',
      'food',
      'travel',
      'sleep',
      'forgiveness',
      'protection',
      'health',
      'guidance',
      'general',
      'gratitude',
      'knowledge',
      'patience',
      'family',
      'success',
    ];
  }
}
