# RAG State Management Implementation

This implementation provides robust state management for RAG (Retrieval-Augmented Generation) integration using Flutter Riverpod with comprehensive features including caching, real-time updates, error recovery, and debugging capabilities.

## Overview

The RAG state management system consists of several key components:

1. **AsyncNotifierProvider** - RAG API calls with loading, success, error states
2. **FutureProvider** - Caching RAG responses with automatic invalidation
3. **StateNotifier** - Complex RAG response processing and filtering
4. **StreamProvider** - Real-time updates from WebSocket connections
5. **Local state persistence** - Using shared_preferences with state restoration
6. **Error recovery mechanisms** - Automatic retry logic
7. **State debugging and logging** - For development and production monitoring

## Architecture

### Data Models (`rag_state_models.dart`)

#### RagStateData

Core state container for RAG operations:

```dart
class RagStateData {
  final RagApiState apiState;           // Current API state (idle, loading, success, error, retrying)
  final RagResponse? response;          // RAG response data
  final String? error;                  // Error message if any
  final String? currentQuery;           // Current query being processed
  final DateTime? lastUpdated;          // Last update timestamp
  final int retryCount;                // Number of retry attempts
  final bool isFromCache;              // Whether response came from cache
  final Map<String, dynamic>? metadata; // Additional metadata
  final double? confidence;            // Response confidence score
}
```

#### RagCacheConfig

Configuration for response caching:

```dart
class RagCacheConfig {
  final int maxEntries;               // Maximum cache entries
  final Duration maxAge;              // Cache entry expiration time
  final bool enablePersistence;       // Enable persistent storage
  final String cacheKey;             // Storage key for cache
}
```

#### WebSocketState

Real-time connection state:

```dart
enum WebSocketConnectionState {
  disconnected, connecting, connected, reconnecting, error
}

class WebSocketState {
  final WebSocketConnectionState connectionState;
  final String? error;
  final DateTime? lastConnected;
  final DateTime? lastDisconnected;
  final int reconnectAttempts;
  final List<Map<String, dynamic>> recentMessages;
}
```

#### RagFilterConfig

Response filtering configuration:

```dart
class RagFilterConfig {
  final double minConfidence;          // Minimum confidence threshold
  final List<String> includeCategories; // Categories to include
  final List<String> excludeCategories; // Categories to exclude
  final bool sortByRelevance;         // Sort by relevance score
  final int maxResults;               // Maximum number of results
  final int? maxResponseLength;       // Maximum response length
  final List<String> languageFilter;  // Language filters (en, ar, etc.)
  final List<String> requiredKeywords; // Required keywords
  final List<String> blacklistedKeywords; // Blacklisted keywords
  final bool enableSourceFiltering;   // Enable source filtering
}
```

### Providers (`rag_provider.dart`)

#### RagApiNotifier

Main provider for RAG API operations:

```dart
final ragApiProvider = AsyncNotifierProvider<RagApiNotifier, RagStateData>(() {
  return RagApiNotifier();
});
```

**Key Methods:**

- `performQuery(String query, {bool useCache = true})` - Execute RAG query
- `clearQuery()` - Clear current query and reset state
- `_handleError()` - Handle errors with automatic retry logic
- `_persistState()` - Persist state to local storage

**Features:**

- Automatic retry with exponential backoff
- Cache-first strategy for performance
- Comprehensive error handling
- State persistence across app restarts

#### RagCacheNotifier

Manages response caching:

```dart
final ragCacheProvider = StateNotifierProvider<RagCacheNotifier, Map<String, CachedRagEntry>>((ref) {
  return RagCacheNotifier(config);
});
```

**Key Methods:**

- `get(String query)` - Retrieve cached response
- `put(String query, RagResponse response)` - Store response in cache
- `remove(String query)` - Remove specific cache entry
- `clear()` - Clear all cache entries
- `invalidateExpired()` - Remove expired entries
- `getStats()` - Get cache statistics

**Features:**

- LRU eviction when cache is full
- Automatic expiration handling
- Query normalization for consistent caching
- Persistent storage integration

#### RagFilterNotifier

Handles response filtering:

```dart
final ragFilterProvider = StateNotifierProvider<RagFilterNotifier, RagFilterConfig>((ref) {
  return RagFilterNotifier();
});
```

**Key Methods:**

- `updateMinConfidence(double confidence)` - Set confidence threshold
- `updateMaxResults(int maxResults)` - Set maximum results
- `updateLanguageFilter(List<String> languages)` - Configure language filtering
- `filterResponses(List<RagResponse> responses)` - Apply filters to responses

#### RagWebSocketNotifier

Manages real-time WebSocket connections:

```dart
final ragWebSocketProvider = StateNotifierProvider<RagWebSocketNotifier, WebSocketState>((ref) {
  return RagWebSocketNotifier();
});
```

**Key Methods:**

- `connect()` - Establish WebSocket connection
- `disconnect()` - Close WebSocket connection
- `sendMessage(Map<String, dynamic> message)` - Send message through WebSocket
- Automatic reconnection on connection loss

### Services (`rag_service.dart`)

#### RagService

HTTP service for RAG API communication:

```dart
class RagService {
  Future<RagResponse> query(String query);
  Future<List<RagResponse>> getSimilar(String query, {int limit = 5});
  Future<bool> checkHealth();
}
```

### Debugging (`rag_debug_provider.dart`)

#### RagDebugNotifier

Comprehensive debugging and monitoring:

```dart
final ragDebugProvider = StateNotifierProvider<RagDebugNotifier, RagDebugState>((ref) {
  return RagDebugNotifier();
});
```

**Features:**

- API call logging with timing and status codes
- Cache operation monitoring
- WebSocket event tracking
- State transition logging
- Error tracking with context
- Performance metrics calculation
- Debug data export functionality

**Key Methods:**

- `logApiCall()` - Log API call metrics
- `logCacheOperation()` - Track cache hits/misses
- `logWebSocketEvent()` - Monitor WebSocket events
- `logStateTransition()` - Track state changes
- `getPerformanceMetrics()` - Calculate performance statistics

## Usage Examples

### Basic RAG Query

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(ragApiProvider.notifier).performQuery("What is Islam?");
      },
      child: Text('Ask Question'),
    );
  }
}
```

### Watching RAG State

```dart
class ResponseWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ragState = ref.watch(ragApiProvider);

    return ragState.when(
      data: (state) {
        switch (state.apiState) {
          case RagApiState.loading:
            return CircularProgressIndicator();
          case RagApiState.success:
            return Text(state.response?.response ?? '');
          case RagApiState.error:
            return Text('Error: ${state.error}');
          default:
            return Text('Ready to ask...');
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Cache Management

```dart
// Clear cache
await ref.read(ragCacheProvider.notifier).clear();

// Get cache statistics
final cacheNotifier = ref.read(ragCacheProvider.notifier);
final stats = cacheNotifier.getStats();
print('Cache entries: ${stats['totalEntries']}');
print('Hit rate: ${stats['cacheHitRate']}%');
```

### Filtering Configuration

```dart
// Update confidence threshold
ref.read(ragFilterProvider.notifier).updateMinConfidence(0.8);

// Configure language filtering
ref.read(ragFilterProvider.notifier).updateLanguageFilter(['en', 'ar']);

// Update required keywords
ref.read(ragFilterProvider.notifier).updateKeywordFilters(['Islam', 'prayer']);
```

### WebSocket Integration

```dart
// Monitor WebSocket state
final wsState = ref.watch(ragWebSocketProvider);
if (wsState.connectionState == WebSocketConnectionState.connected) {
  // Connected - can receive real-time updates
}

// Manual connection control
ref.read(ragWebSocketProvider.notifier).connect();
ref.read(ragWebSocketProvider.notifier).disconnect();
```

### Debug Mode

```dart
// Enable debug mode
ref.read(ragDebugProvider.notifier).setDebugMode(true);

// Get performance metrics
final debugNotifier = ref.read(ragDebugProvider.notifier);
final metrics = debugNotifier.getPerformanceMetrics();

// Export debug data
final debugData = debugNotifier.exportDebugData();
```

## Error Recovery

The system includes comprehensive error recovery mechanisms:

1. **Automatic Retry**: Failed requests are automatically retried up to 3 times with exponential backoff
2. **Network Error Handling**: Different handling for various network error types
3. **Graceful Degradation**: Fallback to cached responses when API is unavailable
4. **Connection Recovery**: WebSocket automatically attempts reconnection on disconnect

## State Persistence

All state is automatically persisted to local storage:

- **RAG State**: Current query state and responses
- **Cache**: Cached responses for offline access
- **Filter Config**: User's filtering preferences
- **Debug State**: Debug configuration and logs

State is restored when the app restarts, providing seamless user experience.

## Performance Optimization

- **Cache-First Strategy**: Check cache before making API calls
- **Query Normalization**: Consistent caching through query normalization
- **Efficient State Updates**: Minimal rebuilds using Riverpod's fine-grained reactivity
- **Background Processing**: Non-blocking cache operations
- **Memory Management**: Automatic cache cleanup and size limits

## Production Considerations

1. **Environment Configuration**: Update API URLs and WebSocket endpoints for production
2. **Error Monitoring**: Integrate with crash reporting services
3. **Analytics**: Add user interaction tracking
4. **Security**: Implement proper authentication and API key management
5. **Rate Limiting**: Respect API rate limits and implement client-side throttling

## Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  shared_preferences: ^2.2.2
  dio: ^5.4.0
  web_socket_channel: ^2.4.0
  logger: ^2.0.2+1
```

This implementation provides a production-ready RAG state management solution with comprehensive features for caching, real-time updates, error recovery, and debugging capabilities.
