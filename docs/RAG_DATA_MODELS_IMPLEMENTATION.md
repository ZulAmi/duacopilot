# RAG Data Models and Local Storage Implementation

## Overview

This document outlines the comprehensive Flutter data models and local storage implementation for RAG (Retrieval-Augmented Generation) integration in the Du'a Copilot application.

## 🏗️ Architecture Overview

### Data Layer Structure

```
lib/data/
├── models/
│   ├── dua_response.dart           # RAG API response model
│   ├── dua_recommendation.dart     # Du'a recommendations with Arabic text
│   ├── query_history.dart          # Semantic caching for queries
│   ├── user_preference.dart        # User personalization context
│   └── audio_cache.dart            # Audio file management
├── datasources/
│   ├── rag_database_helper.dart    # Database helper with migrations
│   └── rag_cache_service.dart      # Comprehensive caching service
└── test/
    └── data_models_test.dart       # Model validation tests
```

## 📊 Data Models

### 1. DuaResponse Model

**Purpose**: Immutable RAG API response model with source attribution

**Key Features**:

- Freezed-based immutable data class with JSON serialization
- Source attribution with relevance scoring
- Metadata tracking for RAG context
- Database conversion methods

**Schema**:

```dart
class DuaResponse {
  String id;
  String query;
  String response;
  DateTime timestamp;
  int responseTime;
  double confidence;
  List<DuaSource> sources;
  String? sessionId;
  int? tokensUsed;
  String? model;
  Map<String, dynamic>? metadata;
  bool isFavorite;
  bool isFromCache;
}
```

### 2. DuaRecommendation Model

**Purpose**: Arabic Du'a recommendations with multilingual support

**Key Features**:

- Arabic text with transliteration and translation
- Confidence scoring for recommendation quality
- Audio file tracking and download status
- Category-based organization

**Schema**:

```dart
class DuaRecommendation {
  String id;
  String arabicText;
  String transliteration;
  String translation;
  double confidence;
  String? category;
  String? source;
  String? reference;
  String? audioUrl;
  String? audioFileName;
  // ... additional fields
}
```

### 3. QueryHistory Model

**Purpose**: Semantic caching for RAG queries with similarity detection

**Key Features**:

- Semantic hash generation for query similarity
- Access count and recency tracking
- Session-based query grouping
- Cache management with favorites

**Schema**:

```dart
class QueryHistory {
  String id;
  String query;
  String response;
  DateTime timestamp;
  int responseTime;
  String semanticHash;
  double? confidence;
  String? sessionId;
  Map<String, dynamic>? context;
  // ... additional fields
}
```

### 4. UserPreference Model

**Purpose**: Personalization context sent to RAG service

**Key Features**:

- Type-safe preference system (string, int, bool, list)
- RAG context generation for personalized responses
- Category-based organization
- System vs user preference differentiation

**Schema**:

```dart
class UserPreference {
  String id;
  String userId;
  String key;
  String value;
  String type; // 'string', 'int', 'bool', 'list'
  String? category;
  String? description;
  bool isSystem;
  bool isActive;
  // ... additional fields
}
```

### 5. AudioCache Model

**Purpose**: Downloaded Du'a audio file management

**Key Features**:

- Audio quality levels (64-320 kbps)
- Download status tracking
- Expiration and cleanup logic
- Play count and favorites

**Enums**:

```dart
enum AudioQuality { low(64), medium(128), high(192), ultra(320) }
enum DownloadStatus { pending, downloading, completed, failed, cancelled, paused }
```

## 🗄️ Database Implementation

### Database Helper (rag_database_helper.dart)

**Features**:

- SQLite database with versioned migrations
- Foreign key support and data integrity
- Optimized indexes for semantic search
- Database maintenance and cleanup utilities

**Migration Strategy**:

- Progressive upgrades from version 1 to 3
- V2: Enhanced RAG features and semantic search
- V3: Comprehensive model support with audio caching

**Tables**:

- `query_history`: Semantic query caching
- `dua_responses`: RAG API responses with sources
- `dua_sources`: Source attribution for responses
- `dua_recommendations`: Du'a recommendations
- `user_preferences`: User personalization context
- `audio_cache`: Audio file management

### Cache Service (rag_cache_service.dart)

**Comprehensive caching solution with**:

- Semantic query similarity matching
- Intelligent cache size management
- User preference caching
- Audio file lifecycle management
- Cache statistics and analytics

**Key Methods**:

```dart
// Query caching
Future<void> cacheQueryResponse({...});
Future<QueryHistory?> findSimilarQuery(String query);

// Preference management
Future<T?> getUserPreference<T>(String userId, String key, String type);
Future<Map<String, dynamic>> getUserRagContext(String userId);

// Audio management
Future<void> cacheAudioFile(AudioCache audioCache);
Future<AudioCache?> getCachedAudio(String duaId);

// Maintenance
Future<void> cleanupExpiredCache();
Future<Map<String, dynamic>> getCacheStats();
```

## 🔧 Technical Implementation

### Dependencies Added

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  sqflite: ^2.3.0

dev_dependencies:
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
```

### Code Generation

Models use Freezed for immutable data classes with:

- JSON serialization/deserialization
- Copy methods with optional parameter updates
- Equality and hash code generation
- toString() implementations

### Database Operations

Each model includes:

- `toDatabase()`: Convert model to database-ready Map
- `fromDatabase()`: Create model from database Map
- Helper classes with CRUD operations
- Optimized query methods with pagination

## 🚀 Usage Examples

### 1. Caching a RAG Response

```dart
final cacheService = RagCacheService();

await cacheService.cacheQueryResponse(
  query: "What is the dua for traveling?",
  response: "The dua for traveling is...",
  confidence: 0.95,
  sessionId: "session_123",
);
```

### 2. Finding Similar Queries

```dart
final similarQuery = await cacheService.findSimilarQuery(
  "What dua should I recite when traveling?"
);

if (similarQuery != null) {
  // Use cached response
  print("Cache hit: ${similarQuery.response}");
}
```

### 3. Managing User Preferences

```dart
// Set user preference
await cacheService.setUserPreference(
  userId: "user_123",
  key: "language",
  value: "en",
  type: "string",
  category: "localization",
);

// Get RAG context
final ragContext = await cacheService.getUserRagContext("user_123");
// Send ragContext to RAG service for personalized responses
```

### 4. Audio File Management

```dart
final audioCache = AudioCache(
  id: "audio_1",
  duaId: "dua_travel",
  fileName: "travel_dua.mp3",
  localPath: "/storage/audio/travel_dua.mp3",
  fileSizeBytes: 2048000,
  quality: AudioQuality.high,
  status: DownloadStatus.completed,
);

await cacheService.cacheAudioFile(audioCache);
```

## 📈 Performance Optimizations

### 1. Semantic Caching

- Hash-based query similarity detection
- Configurable similarity threshold (default: 0.85)
- LRU-based cache eviction for size management

### 2. Database Indexing

- Optimized indexes on frequently queried columns
- Compound indexes for complex queries
- Foreign key relationships for data integrity

### 3. Cache Maintenance

- Automatic cleanup of expired entries
- Configurable cache size limits (default: 1000 entries)
- Background maintenance operations

### 4. Memory Management

- Lazy loading of database connections
- Efficient JSON serialization
- Minimal object allocation in hot paths

## 🧪 Testing

### Test Coverage

- Model creation and validation
- Database conversion accuracy
- Semantic hash consistency
- Type-safe preference handling
- Audio quality enum functionality

### Example Test Results

```
✅ All 7 tests passed!
- QueryHistory model creation and database conversion
- DuaRecommendation model creation
- UserPreference model with different types
- AudioCache model with quality enum
- DuaResponse model with sources
- Cache service initialization
- Semantic hash generation
```

## 🔮 Future Enhancements

### 1. Advanced Semantic Search

- Vector embeddings for true semantic similarity
- Machine learning-based similarity scoring
- Multi-language semantic matching

### 2. Enhanced Caching

- Distributed caching for multi-device sync
- Predictive caching based on user patterns
- Compression for large cache entries

### 3. Analytics Integration

- Detailed usage analytics
- Cache hit/miss ratio optimization
- User behavior pattern analysis

### 4. Offline Synchronization

- Conflict resolution strategies
- Incremental sync for bandwidth optimization
- Background sync with network availability detection

## 📝 Migration and Deployment

### Database Migration Strategy

1. **Version 1→2**: Add semantic search capabilities
2. **Version 2→3**: Comprehensive RAG model support
3. **Future versions**: Progressive feature additions with backward compatibility

### Deployment Considerations

- Database schema validation on app startup
- Graceful handling of migration failures
- Data integrity checks and recovery procedures

## 🎯 Conclusion

This implementation provides a robust, scalable foundation for RAG integration in the Du'a Copilot application with:

- **Comprehensive data modeling** with freezed and JSON serialization
- **Intelligent caching** with semantic similarity detection
- **Efficient database operations** with SQLite and optimized queries
- **Type-safe user preferences** for personalized RAG responses
- **Complete audio management** with download tracking and cleanup
- **Proper testing coverage** ensuring reliability and correctness

The architecture supports both current RAG requirements and future enhancements while maintaining clean separation of concerns and optimal performance characteristics.
