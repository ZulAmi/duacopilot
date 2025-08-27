// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local_semantic_search_service.dart';
import '../models/local_search_models.dart';

/// Provider for the local semantic search service
final localSearchServiceProvider = Provider<LocalSemanticSearchService>((ref) {
  return LocalSemanticSearchService.instance;
});

/// Provider for search state management
final searchStateProvider = StateNotifierProvider<SearchStateNotifier, SearchState>((ref) {
  final searchService = ref.watch(localSearchServiceProvider);
  return SearchStateNotifier(searchService);
});

/// Provider for offline status
final offlineStatusProvider = StateProvider<bool>((ref) => false);

/// Provider for queue size
final queueSizeProvider = StateProvider<int>((ref) => 0);

/// Provider for search suggestions
final searchSuggestionsProvider = FutureProvider.family<List<String>, SearchSuggestionsParams>((
  ref,
  params,
) async {
  final searchService = ref.watch(localSearchServiceProvider);
  return await searchService.getSuggestions(
    partialQuery: params.partialQuery,
    language: params.language,
    limit: params.limit,
  );
});

/// Provider for search statistics
final searchStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final searchService = ref.watch(localSearchServiceProvider);
  return await searchService.getSearchStats();
});

/// Search state notifier
class SearchStateNotifier extends StateNotifier<SearchState> {
  final LocalSemanticSearchService _searchService;

  SearchStateNotifier(this._searchService) : super(SearchState.initial());

  /// Perform a search
  Future<void> search({
    required String query,
    required String language,
    bool forceOffline = false,
    int maxResults = 5,
  }) async {
    if (query.trim().isEmpty) {
      state = SearchState.initial();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _searchService.search(
        query: query,
        language: language,
        forceOffline: forceOffline,
        maxResults: maxResults,
      );

      state = state.copyWith(
        isLoading: false,
        results: response.results,
        isOnline: response.isOnline,
        source: response.source,
        confidence: response.confidence,
        searchTime: response.searchTime,
        processingTime: response.processingTime,
        lastQuery: query,
        lastLanguage: language,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        results: [],
      );
    }
  }

  /// Clear search results
  void clearResults() {
    state = SearchState.initial();
  }

  /// Update offline status
  void updateOfflineStatus(bool isOffline) {
    state = state.copyWith(isOffline: isOffline);
  }

  /// Update queue size
  void updateQueueSize(int queueSize) {
    state = state.copyWith(queueSize: queueSize);
  }
}

/// Search state model
class SearchState {
  final bool isLoading;
  final List<LocalSearchResult> results;
  final String? error;
  final bool isOnline;
  final bool isOffline;
  final String source;
  final double confidence;
  final DateTime? searchTime;
  final Duration? processingTime;
  final String? lastQuery;
  final String? lastLanguage;
  final int queueSize;

  const SearchState({
    required this.isLoading,
    required this.results,
    this.error,
    required this.isOnline,
    required this.isOffline,
    required this.source,
    required this.confidence,
    this.searchTime,
    this.processingTime,
    this.lastQuery,
    this.lastLanguage,
    required this.queueSize,
  });

  factory SearchState.initial() {
    return const SearchState(
      isLoading: false,
      results: [],
      error: null,
      isOnline: true,
      isOffline: false,
      source: 'none',
      confidence: 0.0,
      queueSize: 0,
    );
  }

  SearchState copyWith({
    bool? isLoading,
    List<LocalSearchResult>? results,
    String? error,
    bool? isOnline,
    bool? isOffline,
    String? source,
    double? confidence,
    DateTime? searchTime,
    Duration? processingTime,
    String? lastQuery,
    String? lastLanguage,
    int? queueSize,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
      isOnline: isOnline ?? this.isOnline,
      isOffline: isOffline ?? this.isOffline,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      searchTime: searchTime ?? this.searchTime,
      processingTime: processingTime ?? this.processingTime,
      lastQuery: lastQuery ?? this.lastQuery,
      lastLanguage: lastLanguage ?? this.lastLanguage,
      queueSize: queueSize ?? this.queueSize,
    );
  }

  bool get hasResults => results.isNotEmpty;
  bool get hasError => error != null;
  LocalSearchResult? get bestResult => results.isNotEmpty ? results.first : null;
}

/// Parameters for search suggestions
class SearchSuggestionsParams {
  final String partialQuery;
  final String language;
  final int limit;

  const SearchSuggestionsParams({
    required this.partialQuery,
    required this.language,
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchSuggestionsParams &&
        other.partialQuery == partialQuery &&
        other.language == language &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(partialQuery, language, limit);
}

/// Extension to initialize the local search service
extension LocalSearchServiceExtension on WidgetRef {
  /// Initialize the local search service with callbacks
  Future<void> initializeLocalSearch() async {
    final searchService = read(localSearchServiceProvider);

    await searchService.initialize(
      onConnectivityChanged: (isOnline) {
        read(offlineStatusProvider.notifier).state = !isOnline;
        read(searchStateProvider.notifier).updateOfflineStatus(!isOnline);
      },
      onOfflineResponseGenerated: (result) {
        // Handle offline response generation
        print(
          'Generated offline response: ${result.response.substring(0, 50)}...',
        );
      },
    );

    // Update initial queue size
    final stats = await searchService.getSearchStats();
    final queueSize = stats['queue']?['total_pending'] ?? 0;
    read(queueSizeProvider.notifier).state = queueSize;
    read(searchStateProvider.notifier).updateQueueSize(queueSize);
  }
}

/// Provider for manual search operations
final manualSearchProvider = Provider<ManualSearchOperations>((ref) {
  final searchService = ref.watch(localSearchServiceProvider);
  return ManualSearchOperations(searchService);
});

/// Manual search operations
class ManualSearchOperations {
  final LocalSemanticSearchService _searchService;

  ManualSearchOperations(this._searchService);

  /// Sync pending queries
  Future<void> syncPendingQueries() async {
    await _searchService.syncPendingQueries();
  }

  /// Preload popular queries
  Future<void> preloadPopularQueries({String? language}) async {
    await _searchService.preloadPopularQueries(language: language);
  }

  /// Clear offline data
  Future<void> clearOfflineData() async {
    await _searchService.clearOfflineData();
  }

  /// Check if service is initialized
  bool get isInitialized => _searchService.isInitialized;

  /// Check if device is online
  bool get isOnline => _searchService.isOnline;

  /// Get current queue size
  int get queueSize => _searchService.queueSize;
}

/// Provider for search quality metrics
final searchQualityProvider = Provider.family<String, LocalSearchResult>((
  ref,
  result,
) {
  final quality = result.quality;
  return '${quality.qualityLevel} (${(quality.overallScore * 100).toInt()}%)';
});

/// Provider for search confidence indicator
final searchConfidenceProvider = Provider.family<String, double>((
  ref,
  confidence,
) {
  if (confidence >= 0.9) return 'Very High';
  if (confidence >= 0.8) return 'High';
  if (confidence >= 0.6) return 'Medium';
  if (confidence >= 0.4) return 'Low';
  return 'Very Low';
});
