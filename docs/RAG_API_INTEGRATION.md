# Flutter-Optimized RAG API Integration

This document provides comprehensive documentation for the RAG (Retrieval-Augmented Generation) API integration in the DuaCopilot Flutter application.

## Overview

The RAG API integration provides intelligent Du'a search and recommendation capabilities using advanced AI technology. The system includes comprehensive caching, offline support, error handling, and performance optimizations specifically designed for Flutter applications.

## Architecture Components

### 1. RagApiClient (`lib/core/network/rag_api_client.dart`)

The low-level HTTP client that handles direct communication with the RAG API endpoints.

**Features:**

- RESTful API communication
- Automatic error handling and retry logic
- Request/response serialization
- Authentication token management
- Timeout handling
- Platform-specific optimizations

### 2. RagService (`lib/services/rag_service.dart`)

High-level service that provides business logic, caching, and offline capabilities.

**Features:**

- Intelligent caching (memory + disk)
- Offline fallback functionality
- Background synchronization
- Error recovery mechanisms
- Stream-based reactive updates
- Performance monitoring

### 3. Response Models (`lib/data/models/rag_response_models.dart`)

Comprehensive data models for all API responses with full JSON serialization support.

## API Endpoints

### 1. Search Du'as

**Endpoint:** `POST /api/v1/search`

**Purpose:** Natural language search for Du'as with contextual understanding.

**Request:**

```json
{
  "query": "feeling anxious before exam",
  "context": {
    "language": "en",
    "location": "optional"
  }
}
```

**Response:**

```json
{
  "recommendations": [
    {
      "dua": {
        /* DuaEntity */
      },
      "relevance_score": 0.95,
      "match_reason": "situational_match",
      "highlighted_keywords": ["anxious", "exam"],
      "context": {
        /* additional context */
      }
    }
  ],
  "confidence": 0.95,
  "reasoning": "situational_match",
  "query_id": "unique_query_identifier"
}
```

**Usage:**

```dart
final response = await ragService.searchDuas(
  query: "feeling anxious before exam",
  language: "en",
  location: "New York",
  additionalContext: {
    "time_of_day": "morning",
    "user_preference": "short_duas"
  },
);
```

### 2. Get Du'a Details

**Endpoint:** `GET /api/v1/dua/{id}`

**Purpose:** Retrieve detailed information about a specific Du'a including audio, translations, and metadata.

**Response:**

```json
{
  "dua": {
    /* DuaEntity */
  },
  "audio": {
    "url": "https://audio.duacopilot.com/dua123.mp3",
    "format": "mp3",
    "duration_ms": 45000,
    "quality": "high",
    "reciter": "Sheikh Ahmad",
    "size_bytes": 1024000,
    "download_url": "https://download.duacopilot.com/dua123.mp3"
  },
  "translations": [
    {
      "language": "en",
      "text": "English translation",
      "transliteration": "Arabic transliteration",
      "translator": "Translation source",
      "confidence": 0.98
    }
  ],
  "tags": ["anxiety", "exam", "student"],
  "usage_stats": {
    "total_views": 15420,
    "total_favorites": 892,
    "weekly_views": 1250,
    "average_rating": 4.8,
    "rating_count": 156
  },
  "related_duas": [
    {
      "dua_id": "related123",
      "title": "Related Du'a",
      "relevance_score": 0.85,
      "relation": "similar_context"
    }
  ]
}
```

**Usage:**

```dart
final details = await ragService.getDuaDetails("dua123");
```

### 3. Submit Feedback

**Endpoint:** `POST /api/v1/feedback`

**Purpose:** Submit user feedback to improve RAG model accuracy.

**Request:**

```json
{
  "dua_id": "dua123",
  "query_id": "query456",
  "feedback_type": "helpful",
  "rating": 5.0,
  "comment": "Very relevant to my situation",
  "metadata": {
    "interaction_time": 30,
    "user_context": "exam_preparation"
  }
}
```

**Usage:**

```dart
await ragService.submitFeedback(
  duaId: "dua123",
  queryId: "query456",
  feedbackType: FeedbackType.helpful,
  rating: 5.0,
  comment: "Very helpful",
  metadata: {"context": "exam_stress"},
);
```

### 4. Get Popular Du'as

**Endpoint:** `GET /api/v1/popular`

**Purpose:** Retrieve trending Du'as with pagination support.

**Query Parameters:**

- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)
- `category`: Filter by category
- `timeframe`: Time period (day/week/month/year)

**Usage:**

```dart
final popular = await ragService.getPopularDuas(
  page: 1,
  limit: 10,
  category: "daily_prayers",
  timeframe: "week",
);
```

### 5. Update Personalization

**Endpoint:** `POST /api/v1/personalize`

**Purpose:** Update user preferences for better recommendations.

**Request:**

```json
{
  "preferred_categories": ["daily_prayers", "anxiety_relief"],
  "preferred_languages": ["en", "ar"],
  "topic_preferences": {
    "spiritual_growth": 0.9,
    "daily_routines": 0.7,
    "emergency_situations": 0.8
  },
  "demographics": {
    "age_group": "young_adult",
    "region": "north_america",
    "religious_level": "practicing"
  }
}
```

**Usage:**

```dart
await ragService.updatePersonalization(
  preferredCategories: ["daily_prayers", "anxiety_relief"],
  preferredLanguages: ["en", "ar"],
  topicPreferences: {
    "spiritual_growth": 0.9,
    "daily_routines": 0.7,
  },
  demographics: UserDemographics(
    ageGroup: "young_adult",
    region: "north_america",
  ),
);
```

### 6. Get Offline Cache

**Endpoint:** `GET /api/v1/offline-cache`

**Purpose:** Download essential Du'as for offline functionality.

**Query Parameters:**

- `last_sync`: Timestamp of last synchronization
- `categories`: Comma-separated list of categories
- `language`: Preferred language
- `max_size`: Maximum cache size in bytes

**Usage:**

```dart
await ragService.syncOfflineCache(force: true);
```

## Caching Strategy

### Memory Cache

- Fast access for recent searches
- Automatic cleanup based on memory pressure
- Configurable size limits

### Disk Cache

- Persistent storage for offline access
- Automatic expiration based on timestamp
- Compression for efficient storage

### Offline Cache

- Essential Du'as for offline functionality
- Background synchronization
- Intelligent fallback search

## Error Handling

### Exception Types

```dart
// Network-related errors
try {
  final response = await ragService.searchDuas(query: "test");
} catch (e) {
  if (e is NetworkException) {
    // Handle network connectivity issues
  } else if (e is TimeoutException) {
    // Handle request timeouts
  } else if (e is RateLimitException) {
    // Handle API rate limiting
  } else if (e is UnauthorizedException) {
    // Handle authentication issues
  }
}
```

### Graceful Degradation

- Automatic fallback to cached data
- Offline search capabilities
- Queued operations for when connectivity returns

## Performance Optimizations

### Background Processing

- Heavy text processing in isolates
- Non-blocking UI operations
- Efficient memory management

### Network Optimization

- Request deduplication
- Intelligent retry logic
- Connection pooling
- Compression support

### Flutter-Specific Optimizations

- Widget rebuild minimization
- Efficient ListView implementation
- Memory-conscious image loading
- Platform-specific adaptations

## Usage Examples

### Basic Search Implementation

```dart
class DuaSearchWidget extends StatefulWidget {
  @override
  _DuaSearchWidgetState createState() => _DuaSearchWidgetState();
}

class _DuaSearchWidgetState extends State<DuaSearchWidget> {
  late RagService _ragService;
  StreamSubscription? _searchSubscription;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    final apiClient = RagApiClient();
    _ragService = RagService(apiClient, prefs);

    _searchSubscription = _ragService.searchResults.listen((response) {
      setState(() {
        // Update UI with search results
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onChanged: (query) {
        _ragService.searchDuas(query: query);
      },
    );
  }

  @override
  void dispose() {
    _searchSubscription?.cancel();
    _ragService.dispose();
    super.dispose();
  }
}
```

### Advanced Configuration

```dart
// Configure API client
final apiClient = RagApiClient();
apiClient.setAuthToken(await SecureStorage.getApiToken());

// Initialize service with custom settings
final ragService = RagService(apiClient, prefs);
await ragService.initialize();

// Set up personalization
await ragService.updatePersonalization(
  preferredCategories: ["daily_prayers", "special_occasions"],
  preferredLanguages: ["en", "ar"],
  topicPreferences: {
    "morning_prayers": 1.0,
    "evening_prayers": 0.8,
    "travel_prayers": 0.6,
  },
);

// Configure offline cache
await ragService.syncOfflineCache(force: true);
```

## Security Considerations

### API Authentication

- Secure token storage using Flutter Secure Storage
- Token refresh mechanisms
- Request signing for sensitive operations

### Data Privacy

- Local data encryption
- Secure cache storage
- Privacy-compliant data handling

### Network Security

- Certificate pinning support
- HTTPS enforcement
- Request/response validation

## Testing

### Unit Tests

```dart
void main() {
  group('RagService Tests', () {
    late MockRagApiClient mockApiClient;
    late MockSharedPreferences mockPrefs;
    late RagService ragService;

    setUp(() {
      mockApiClient = MockRagApiClient();
      mockPrefs = MockSharedPreferences();
      ragService = RagService(mockApiClient, mockPrefs);
    });

    test('should return cached response when available', () async {
      // Test implementation
    });

    test('should fallback to offline cache when network fails', () async {
      // Test implementation
    });
  });
}
```

### Integration Tests

```dart
void main() {
  group('RAG API Integration Tests', () {
    testWidgets('should display search results', (tester) async {
      // Widget test implementation
    });
  });
}
```

## Monitoring and Analytics

### Performance Metrics

- API response times
- Cache hit rates
- Error frequencies
- User engagement metrics

### Firebase Integration

```dart
// Performance monitoring
final trace = FirebasePerformance.instance.newTrace('rag_search');
await trace.start();
// Perform search
await trace.stop();

// Custom metrics
trace.putMetric('search_results_count', results.length);
trace.putAttribute('query_category', category);
```

## Configuration

### Environment Setup

```dart
// Development
const ragApiConfig = RagApiConfig(
  baseUrl: 'https://dev-api.duacopilot.com',
  timeout: Duration(seconds: 30),
  enableDebugLogs: true,
);

// Production
const ragApiConfig = RagApiConfig(
  baseUrl: 'https://api.duacopilot.com',
  timeout: Duration(seconds: 15),
  enableDebugLogs: false,
);
```

### Feature Flags

```dart
class RagFeatureFlags {
  static const bool enableOfflineSearch = true;
  static const bool enablePersonalization = true;
  static const bool enableAdvancedCaching = true;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
}
```

## Troubleshooting

### Common Issues

1. **Network Connectivity**

   - Check device internet connection
   - Verify API endpoint accessibility
   - Validate authentication tokens

2. **Performance Issues**

   - Monitor memory usage
   - Check cache size and cleanup
   - Optimize search query frequency

3. **Cache Problems**
   - Clear corrupt cache data
   - Reset offline synchronization
   - Validate data integrity

### Debug Tools

```dart
// Enable debug logging
debugPrint('RAG Service Cache Stats: ${await ragService.getCacheStats()}');

// Health check
final isHealthy = await ragService.checkHealth();
debugPrint('RAG Service Health: $isHealthy');

// Manual cache management
await ragService.clearCache();
await ragService.syncOfflineCache(force: true);
```

## Best Practices

1. **Efficient Search Patterns**

   - Debounce user input to avoid excessive API calls
   - Implement search suggestions from cache
   - Use pagination for large result sets

2. **Cache Management**

   - Regular cache cleanup
   - Monitor storage usage
   - Implement cache warming strategies

3. **Error Handling**

   - Graceful degradation for network issues
   - User-friendly error messages
   - Automatic retry mechanisms

4. **Performance Optimization**
   - Lazy loading for large datasets
   - Background processing for heavy operations
   - Memory-efficient data structures

## Future Enhancements

- Real-time search suggestions
- Advanced personalization algorithms
- Multi-language support expansion
- Voice search integration
- Offline machine learning capabilities
- Enhanced analytics and insights
