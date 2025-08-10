import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../../domain/entities/rag_response.dart';
import '../../domain/entities/enhanced_query.dart';
import '../../domain/entities/query_context.dart';
import '../../services/rag_service.dart';
import '../../core/services/query_enhancement/query_enhancement_service.dart';
import 'rag_state_models.dart';
import 'provider_config.dart';

/// AsyncNotifierProvider for RAG API calls with loading, success, error states
class RagApiNotifier extends AsyncNotifier<RagStateData> {
  late final RagService _ragService;
  late final QueryEnhancementService _queryEnhancer;

  @override
  Future<RagStateData> build() async {
    _ragService = ref.read(ragServiceProvider);
    _queryEnhancer = QueryEnhancementService();

    // Load persisted state
    final persistedState = await RagStatePersistence.loadState();
    if (persistedState != null) {
      return persistedState;
    }

    // Return initial state
    return const RagStateData();
  }

  /// Perform RAG query with smart enhancement and error recovery
  Future<void> performQuery(
    String query, {
    bool useCache = true,
    String language = 'en',
    QueryContext? context,
    Map<String, dynamic>? userPreferences,
  }) async {
    if (query.isEmpty) return;

    try {
      // Update state to loading
      state = AsyncValue.data(
        state.value!.copyWith(
          apiState: RagApiState.loading,
          currentQuery: query,
          error: null,
        ),
      );

      // Step 1: Enhance the query with smart processing
      final enhancedQuery = await _queryEnhancer.enhanceQuery(
        originalQuery: query,
        language: language,
        context: context,
        userPreferences: userPreferences,
      );

      // Check cache first if enabled (using enhanced query)
      if (useCache) {
        final cacheNotifier = ref.read(ragCacheProvider.notifier);
        final cachedResponse = await cacheNotifier.get(
          enhancedQuery.processedQuery,
        );
        if (cachedResponse != null) {
          state = AsyncValue.data(
            state.value!.copyWith(
              apiState: RagApiState.success,
              response: cachedResponse.response,
              isFromCache: true,
              lastUpdated: DateTime.now(),
              retryCount: 0,
              confidence: enhancedQuery.confidence,
              metadata: {
                'enhanced_query': enhancedQuery.processedQuery,
                'original_query': enhancedQuery.originalQuery,
                'intent': enhancedQuery.intent.name,
                'semantic_tags': enhancedQuery.semanticTags,
                'processing_steps': enhancedQuery.processingSteps,
                ...enhancedQuery.metadata,
              },
            ),
          );
          await _persistState();
          return;
        }
      }

      // Step 2: Perform RAG query with enhanced query
      final searchResponse = await _ragService.searchDuas(
        query: enhancedQuery.processedQuery,
        language: language,
        location: enhancedQuery.context.location,
        additionalContext: {
          'intent': enhancedQuery.intent.name,
          'semantic_tags': enhancedQuery.semanticTags,
          'time_context': enhancedQuery.context.timeOfDay?.name,
          'prayer_context': enhancedQuery.context.prayerTime?.name,
          'confidence': enhancedQuery.confidence,
          ...enhancedQuery.metadata,
        },
      );

      // Convert RagSearchResponse to RagResponse for compatibility
      final response = RagResponse(
        id: searchResponse.queryId,
        query: enhancedQuery.originalQuery, // Keep original for user display
        response:
            searchResponse.recommendations.isNotEmpty
                ? searchResponse.recommendations.first.dua.translation
                : 'No results found',
        timestamp: DateTime.now(),
        responseTime: 0,
        confidence: (searchResponse.confidence + enhancedQuery.confidence) / 2,
        metadata: {
          'reasoning': searchResponse.reasoning,
          'recommendations_count': searchResponse.recommendations.length,
          'enhanced_query': enhancedQuery.processedQuery,
          'original_query': enhancedQuery.originalQuery,
          'intent': enhancedQuery.intent.name,
          'semantic_tags': enhancedQuery.semanticTags,
          'processing_steps': enhancedQuery.processingSteps,
          'query_enhancement_confidence': enhancedQuery.confidence,
          'context_summary': enhancedQuery.context.summary,
          ...enhancedQuery.metadata,
        },
      );

      // Update state with success
      final newState = state.value!.copyWith(
        apiState: RagApiState.success,
        response: response,
        isFromCache: false,
        lastUpdated: DateTime.now(),
        retryCount: 0,
        confidence: response.confidence,
        metadata: response.metadata,
      );

      state = AsyncValue.data(newState);

      // Cache the response (using enhanced query as key)
      if (useCache) {
        await ref
            .read(ragCacheProvider.notifier)
            .put(enhancedQuery.processedQuery, response);
      }

      // Persist state
      await _persistState();
    } catch (error, stackTrace) {
      // Handle error with retry logic
      await _handleError(
        error,
        stackTrace,
        query,
        useCache,
        language,
        context,
        userPreferences,
      );
    }
  }

  /// Handle errors with automatic retry logic
  Future<void> _handleError(
    Object error,
    StackTrace stackTrace,
    String query,
    bool useCache, [
    String language = 'en',
    QueryContext? context,
    Map<String, dynamic>? userPreferences,
  ]) async {
    final currentState = state.value!;
    final retryCount = currentState.retryCount;

    // Check if we should retry
    if (retryCount < 3 && _shouldRetry(error)) {
      // Wait before retry with exponential backoff
      final delayMs = 1000 * (retryCount + 1) * (retryCount + 1);
      await Future.delayed(Duration(milliseconds: delayMs));

      // Update state with retry count
      state = AsyncValue.data(
        currentState.copyWith(
          retryCount: retryCount + 1,
          error: 'Retrying... (${retryCount + 1}/3)',
        ),
      );

      // Retry the query with enhanced parameters
      await performQuery(
        query,
        useCache: useCache,
        language: language,
        context: context,
        userPreferences: userPreferences,
      );
    } else {
      // Max retries reached or non-retryable error
      state = AsyncValue.data(
        currentState.copyWith(
          apiState: RagApiState.error,
          error: _formatError(error),
          retryCount: retryCount,
        ),
      );

      await _persistState();
    }
  }

  /// Check if error is retryable
  bool _shouldRetry(Object error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          (error.response?.statusCode ?? 0) >= 500;
    }
    return false;
  }

  /// Format error message for display
  String _formatError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.receiveTimeout:
          return 'Server took too long to respond.';
        case DioExceptionType.sendTimeout:
          return 'Request took too long to send.';
        case DioExceptionType.badResponse:
          return 'Server error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return 'Network error occurred.';
      }
    }
    return error.toString();
  }

  /// Clear current query and reset state
  void clearQuery() {
    state = AsyncValue.data(
      state.value!.copyWith(
        apiState: RagApiState.idle,
        response: null,
        currentQuery: null,
        error: null,
        retryCount: 0,
      ),
    );
    _persistState();
  }

  /// Persist current state
  Future<void> _persistState() async {
    final currentState = state.value;
    if (currentState != null) {
      await RagStatePersistence.saveState(currentState);
    }
  }
}

/// Provider for RAG API state management
final ragApiProvider = AsyncNotifierProvider<RagApiNotifier, RagStateData>(() {
  return RagApiNotifier();
});

/// FutureProvider for caching RAG responses with automatic invalidation
class RagCacheNotifier extends StateNotifier<Map<String, CachedRagEntry>> {
  final RagCacheConfig config;

  RagCacheNotifier(this.config) : super({}) {
    _loadCache();
  }

  /// Load cache from persistence
  Future<void> _loadCache() async {
    final cache = await RagStatePersistence.loadCache();
    state = cache;
  }

  /// Get cached response
  Future<CachedRagEntry?> get(String query) async {
    final normalizedQuery = _normalizeQuery(query);
    final entry = state[normalizedQuery];

    if (entry == null) return null;

    // Check if entry is expired
    if (entry.isExpired(config.maxAge)) {
      await remove(normalizedQuery);
      return null;
    }

    return entry;
  }

  /// Put response in cache
  Future<void> put(String query, RagResponse response) async {
    final normalizedQuery = _normalizeQuery(query);

    // Check cache size limit
    if (state.length >= config.maxEntries) {
      await _evictOldest();
    }

    final entry = CachedRagEntry(
      query: normalizedQuery,
      response: response,
      timestamp: DateTime.now(),
      metadata: {'source': 'api'},
    );

    state = {...state, normalizedQuery: entry};
    await _persistCache();
  }

  /// Remove entry from cache
  Future<void> remove(String query) async {
    final normalizedQuery = _normalizeQuery(query);
    state = {...state}..remove(normalizedQuery);
    await _persistCache();
  }

  /// Clear all cache
  Future<void> clear() async {
    state = {};
    await _persistCache();
  }

  /// Invalidate expired entries
  Future<void> invalidateExpired() async {
    final validEntries = <String, CachedRagEntry>{};

    for (final entry in state.entries) {
      if (!entry.value.isExpired(config.maxAge)) {
        validEntries[entry.key] = entry.value;
      }
    }

    if (validEntries.length != state.length) {
      state = validEntries;
      await _persistCache();
    }
  }

  /// Evict oldest entries when cache is full
  Future<void> _evictOldest() async {
    if (state.isEmpty) return;

    final sortedEntries =
        state.entries.toList()
          ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

    final entriesToRemove = (state.length * 0.2).ceil(); // Remove 20%
    final newState = <String, CachedRagEntry>{};

    for (int i = entriesToRemove; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      newState[entry.key] = entry.value;
    }

    state = newState;
  }

  /// Normalize query for consistent caching
  String _normalizeQuery(String query) {
    return query.trim().toLowerCase();
  }

  /// Persist cache to storage
  Future<void> _persistCache() async {
    await RagStatePersistence.saveCache(state);
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    int expiredCount = 0;
    int totalSize = 0;

    for (final entry in state.values) {
      if (entry.isExpired(config.maxAge)) {
        expiredCount++;
      }
      totalSize += entry.response.response.length;
    }

    return {
      'totalEntries': state.length,
      'expiredEntries': expiredCount,
      'totalSizeBytes': totalSize,
      'maxSize': config.maxEntries,
      'maxAge': config.maxAge.inMinutes,
    };
  }
}

/// Provider for RAG response caching
final ragCacheProvider =
    StateNotifierProvider<RagCacheNotifier, Map<String, CachedRagEntry>>((ref) {
      const config = RagCacheConfig(
        maxEntries: 100,
        maxAge: Duration(hours: 1),
        enablePersistence: true,
      );
      return RagCacheNotifier(config);
    });

/// StateNotifier for complex RAG response processing and filtering
class RagFilterNotifier extends StateNotifier<RagFilterConfig> {
  RagFilterNotifier() : super(const RagFilterConfig()) {
    _loadFilterConfig();
  }

  /// Load filter configuration from persistence
  Future<void> _loadFilterConfig() async {
    final config = await RagStatePersistence.loadFilterConfig();
    if (config != null) {
      state = config;
    }
  }

  /// Update minimum confidence threshold
  Future<void> updateMinConfidence(double confidence) async {
    state = state.copyWith(minConfidence: confidence);
    await _persistConfig();
  }

  /// Update maximum results
  Future<void> updateMaxResults(int maxResults) async {
    state = state.copyWith(maxResults: maxResults);
    await _persistConfig();
  }

  /// Update maximum response length
  Future<void> updateMaxLength(int length) async {
    state = state.copyWith(maxResponseLength: length);
    await _persistConfig();
  }

  /// Update language filter
  Future<void> updateLanguageFilter(List<String> languages) async {
    state = state.copyWith(languageFilter: languages);
    await _persistConfig();
  }

  /// Update content type filter
  Future<void> updateContentTypeFilter(List<String> contentTypes) async {
    state = state.copyWith(contentTypeFilter: contentTypes);
    await _persistConfig();
  }

  /// Update keyword filters
  Future<void> updateKeywordFilters(List<String> keywords) async {
    state = state.copyWith(requiredKeywords: keywords);
    await _persistConfig();
  }

  /// Update blacklisted keywords
  Future<void> updateBlacklistedKeywords(List<String> keywords) async {
    state = state.copyWith(blacklistedKeywords: keywords);
    await _persistConfig();
  }

  /// Enable/disable source filtering
  Future<void> updateSourceFiltering(bool enabled) async {
    state = state.copyWith(enableSourceFiltering: enabled);
    await _persistConfig();
  }

  /// Reset to default configuration
  Future<void> resetToDefaults() async {
    state = const RagFilterConfig();
    await _persistConfig();
  }

  /// Filter RAG responses based on current configuration
  List<RagResponse> filterResponses(List<RagResponse> responses) {
    return responses.where((response) {
      // Confidence filter
      if (response.confidence != null &&
          response.confidence! < state.minConfidence) {
        return false;
      }

      // Length filter
      if (state.maxResponseLength != null &&
          response.response.length > state.maxResponseLength!) {
        return false;
      }

      // Language filter
      if (state.languageFilter.isNotEmpty) {
        final responseLanguage = _detectLanguage(response.response);
        if (!state.languageFilter.contains(responseLanguage)) {
          return false;
        }
      }

      // Required keywords filter
      if (state.requiredKeywords.isNotEmpty) {
        final responseText = response.response.toLowerCase();
        final hasAllKeywords = state.requiredKeywords.every(
          (keyword) => responseText.contains(keyword.toLowerCase()),
        );
        if (!hasAllKeywords) return false;
      }

      // Blacklisted keywords filter
      if (state.blacklistedKeywords.isNotEmpty) {
        final responseText = response.response.toLowerCase();
        final hasBlacklistedKeyword = state.blacklistedKeywords.any(
          (keyword) => responseText.contains(keyword.toLowerCase()),
        );
        if (hasBlacklistedKeyword) return false;
      }

      return true;
    }).toList();
  }

  /// Detect language of response (simplified implementation)
  String _detectLanguage(String text) {
    // Simple language detection based on common words
    final arabicPattern = RegExp(r'[\u0600-\u06FF]');
    if (arabicPattern.hasMatch(text)) {
      return 'ar';
    }
    return 'en'; // Default to English
  }

  /// Persist filter configuration
  Future<void> _persistConfig() async {
    await RagStatePersistence.saveFilterConfig(state);
  }
}

/// Provider for RAG response filtering
final ragFilterProvider =
    StateNotifierProvider<RagFilterNotifier, RagFilterConfig>((ref) {
      return RagFilterNotifier();
    });

/// StreamProvider for real-time updates from WebSocket connections
class RagWebSocketNotifier extends StateNotifier<WebSocketState> {
  WebSocketChannel? _channel;

  RagWebSocketNotifier() : super(const WebSocketState()) {
    _initialize();
  }

  /// Initialize WebSocket connection
  Future<void> _initialize() async {
    await connect();
  }

  /// Connect to WebSocket
  Future<void> connect() async {
    if (state.connectionState == WebSocketConnectionState.connected) return;

    try {
      state = state.copyWith(
        connectionState: WebSocketConnectionState.connecting,
      );

      // Replace with your actual WebSocket URL
      const wsUrl = 'wss://api.duacopilot.com/ws';
      _channel = IOWebSocketChannel.connect(wsUrl);

      state = state.copyWith(
        connectionState: WebSocketConnectionState.connected,
        lastConnected: DateTime.now(),
        error: null,
      );

      // Listen for messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );
    } catch (error) {
      state = state.copyWith(
        connectionState: WebSocketConnectionState.error,
        error: error.toString(),
      );
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    state = state.copyWith(
      connectionState: WebSocketConnectionState.disconnected,
      lastDisconnected: DateTime.now(),
    );
  }

  /// Send message through WebSocket
  void sendMessage(Map<String, dynamic> message) {
    if (state.connectionState == WebSocketConnectionState.connected) {
      _channel?.sink.add(message);
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      // Process real-time updates
      // This could trigger updates to other providers
      debugPrint('WebSocket message received: $message');
    } catch (error) {
      debugPrint('Error processing WebSocket message: $error');
    }
  }

  /// Handle WebSocket errors
  void _handleError(Object error) {
    state = state.copyWith(
      connectionState: WebSocketConnectionState.error,
      error: error.toString(),
    );

    // Attempt reconnection after delay
    Future.delayed(const Duration(seconds: 5), () {
      if (state.connectionState == WebSocketConnectionState.error) {
        connect();
      }
    });
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
    state = state.copyWith(
      connectionState: WebSocketConnectionState.disconnected,
      lastDisconnected: DateTime.now(),
    );

    // Attempt reconnection after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (state.connectionState == WebSocketConnectionState.disconnected) {
        connect();
      }
    });
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

/// Provider for WebSocket state management
final ragWebSocketProvider =
    StateNotifierProvider<RagWebSocketNotifier, WebSocketState>((ref) {
      return RagWebSocketNotifier();
    });

/// Stream provider for real-time RAG updates
final ragUpdatesStreamProvider = StreamProvider<RagResponse>((ref) {
  // Watch the WebSocket provider to ensure connection is maintained
  ref.watch(ragWebSocketProvider.notifier);

  return Stream.periodic(const Duration(seconds: 30), (count) {
    // This would be replaced with actual WebSocket stream
    // For now, return empty stream
    return null;
  }).where((event) => event != null).cast<RagResponse>();
});
