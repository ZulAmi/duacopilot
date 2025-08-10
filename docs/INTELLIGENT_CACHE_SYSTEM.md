# Intelligent Caching System for DuaCopilot

This intelligent caching system provides advanced query optimization, semantic deduplication, compression, and analytics for the DuaCopilot RAG API.

## Features

### ✅ Semantic Similarity Hashing

- Uses cryptographic hashing for query deduplication
- Multi-language semantic analysis (Arabic, English, Urdu, Indonesian)
- Islamic terminology expansion and synonym matching
- Configurable similarity thresholds per query type

### ✅ TTL-Based Cache Expiration

- Different strategies for different query types:
  - **Dua queries**: 24 hours TTL, LFU eviction
  - **Quran queries**: 7 days TTL, LRU eviction
  - **Hadith queries**: 3 days TTL, LFU eviction
  - **General queries**: 6 hours TTL, LRU eviction

### ✅ Intelligent Compression

- Gzip compression with automatic benefit detection
- Arabic-specific compression with pattern optimization
- Configurable compression ratios per strategy
- Smart decompression with preprocessing reversal

### ✅ Analytics & Popular Query Prewarming

- Firebase Analytics integration (with mock for development)
- Popular query tracking and trending analysis
- Automated prewarming based on analytics
- Performance metrics and cache hit ratio monitoring

### ✅ Cache Invalidation Patterns

- Pattern-based invalidation
- Query type and language-specific invalidation
- Model update handling with domain-specific invalidation
- Automatic cleanup of expired entries

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 IntelligentCacheService                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │ SemanticHash    │  │ Compression     │  │ Analytics   │ │
│  │ Service         │  │ Service         │  │ Service     │ │
│  │                 │  │                 │  │             │ │
│  │ • Multi-lang    │  │ • Gzip          │  │ • Firebase  │ │
│  │ • Islamic terms │  │ • Arabic opts   │  │ • Trending  │ │
│  │ • Synonyms      │  │ • Conditional   │  │ • Popular   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                     Cache Storage                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │ Memory Cache    │  │ Semantic Index  │  │ Persistent  │ │
│  │ • Fast access   │  │ • Hash lookup   │  │ • SharedPrefs│ │
│  │ • TTL timers    │  │ • Similarity    │  │ • Recovery   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Integration with RAG Provider

```dart
// In your RAG provider
class RagApiNotifier extends AsyncNotifier<RagStateData> {
  late final IntelligentCacheService _cache;

  @override
  Future<RagStateData> build() async {
    _cache = IntelligentCacheService.instance;
    await _cache.initialize();
    return const RagStateData();
  }

  Future<void> performQuery(String query, {String language = 'en'}) async {
    // Check cache first
    final cached = await _cache.retrieve(
      query: query,
      language: language,
    );

    if (cached != null) {
      // Use cached response
      state = AsyncValue.data(state.value!.copyWith(
        response: cached,
        isFromCache: true,
      ));
      return;
    }

    // Perform API call
    final response = await ragService.query(query, language);

    // Store in cache
    await _cache.store(
      query: query,
      language: language,
      data: response,
    );

    state = AsyncValue.data(state.value!.copyWith(
      response: response,
      isFromCache: false,
    ));
  }
}
```

### Cache Management UI

```dart
// Navigate to cache management
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CacheManagementScreen(),
  ),
);
```

### Manual Cache Operations

```dart
final cacheService = IntelligentCacheService.instance;

// Clear all cache
await cacheService.invalidateAll();

// Invalidate by pattern
await cacheService.invalidate(pattern: "anxiety");

// Invalidate by query type
await cacheService.invalidate(queryType: QueryType.dua);

// Prewarm with popular queries
await cacheService.prewarmCache(queryLimit: 50);

// Handle model update
await cacheService.handleModelUpdate(
  modelVersion: "v2.1.0",
  affectedDomains: ["dua", "quran"],
);
```

## Configuration

### Cache Strategies

Customize cache strategies in `cache_models.dart`:

```dart
static const CacheStrategy customStrategy = CacheStrategy(
  name: 'custom',
  ttl: Duration(hours: 12),
  nearExpiryThreshold: Duration(hours: 1),
  maxSize: 200,
  evictionPolicy: EvictionPolicy.lru,
  enablePrewarming: true,
  enableCompression: true,
  minCompressionRatio: 0.7,
  parameters: {
    'semantic_similarity_threshold': 0.85,
    'prewarming_count': 30,
  },
);
```

### Semantic Similarity

Adjust similarity thresholds for different content types:

```dart
// In SemanticHashService
final semanticHash = SemanticHashService.generateSemanticHash(
  query,
  language,
  similarityThreshold: 0.85, // Higher = more strict
);
```

### Compression Settings

Configure compression for different languages:

```dart
// Arabic text gets special compression treatment
if (language == 'ar' || _containsArabicText(text)) {
  compressionResult = CompressionService.compressArabicText(text);
} else {
  compressionResult = CompressionService.compressConditionally(
    text,
    minimumSize: 100,
    maxRatio: 0.9,
  );
}
```

## Analytics

### Firebase Analytics Events

The system automatically logs these events:

- `cache_hit` - Successful cache retrieval
- `cache_miss` - Cache miss requiring API call
- `cache_eviction` - Entry removed from cache
- `cache_prewarming` - Prewarming operation
- `cache_invalidation` - Manual or automatic invalidation

### Performance Metrics

```dart
final metrics = cacheService.getMetrics();
print('Hit ratio: ${metrics.hitRatio}');
print('Average compression: ${metrics.averageCompressionRatio}');
print('Total entries: ${metrics.entryCount}');
```

### Popular Queries

```dart
final popularQueries = CacheAnalyticsService.getPopularQueries(
  limit: 50,
  language: 'en',
  queryType: QueryType.dua,
);

for (final query in popularQueries) {
  print('${query.query} - ${query.accessCount} accesses');
}
```

## Monitoring

### Cache Health Dashboard

The `CacheManagementScreen` provides:

- **Overview Tab**: Hit ratios, compression stats, strategy performance
- **Analytics Tab**: Performance metrics, timing analysis
- **Popular Tab**: Most accessed and trending queries with filters
- **Operations Tab**: Manual cache operations and maintenance

### Key Metrics to Monitor

1. **Hit Ratio**: Should be >70% for optimal performance
2. **Compression Ratio**: Arabic content should compress to ~40-60%
3. **Retrieval Time**: Cache hits should be <10ms
4. **Eviction Rate**: High eviction indicates need for larger cache

## Performance Optimization

### Memory Management

```dart
// Configure maximum cache sizes per strategy
static const CacheStrategy duaQueries = CacheStrategy(
  maxSize: 500,        // Max 500 dua entries
  evictionPolicy: EvictionPolicy.lfu,  // Keep frequently used
);
```

### Background Tasks

The system automatically handles:

- Expired entry cleanup (every 30 minutes)
- Analytics data flushing (every 5 minutes)
- Popular query prewarming (every 6 hours)
- Persistent storage saves (every 15 minutes)

### Semantic Index Optimization

```dart
// Semantic index maps hashes to keys for fast lookup
final semanticHash = SemanticHashService.generateSemanticHash(query, language);
final candidateKeys = _semanticIndex[semanticHash.hash] ?? [];

// Only check similarity for candidates with same hash prefix
for (final key in candidateKeys) {
  if (areSimilar(targetHash, entryHash, threshold: 0.8)) {
    return key; // Found similar cached entry
  }
}
```

## Error Handling

### Graceful Degradation

```dart
try {
  final cached = await cache.retrieve(query: query, language: language);
  return cached ?? await performApiCall();
} catch (cacheError) {
  // If cache fails, fall back to direct API call
  print('Cache error: $cacheError');
  return await performApiCall();
}
```

### Recovery Mechanisms

- Automatic cache corruption detection and clearing
- Persistent storage validation on startup
- Fallback to uncompressed storage if compression fails
- Analytics event queue size limiting to prevent memory issues

## Testing

### Unit Tests

```dart
void main() {
  group('IntelligentCacheService', () {
    test('should cache and retrieve responses', () async {
      final cache = IntelligentCacheService.instance;
      await cache.initialize();

      await cache.store(
        query: 'test query',
        language: 'en',
        data: testResponse,
      );

      final retrieved = await cache.retrieve(
        query: 'test query',
        language: 'en',
      );

      expect(retrieved, isNotNull);
      expect(retrieved!.response, equals(testResponse.response));
    });
  });
}
```

### Performance Tests

```dart
test('should handle high cache load', () async {
  final cache = IntelligentCacheService.instance;
  final stopwatch = Stopwatch()..start();

  // Store 1000 entries
  for (int i = 0; i < 1000; i++) {
    await cache.store(
      query: 'query $i',
      language: 'en',
      data: createTestResponse(i),
    );
  }

  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // <5 seconds
});
```

## Migration

### From Basic Caching

If upgrading from a basic caching system:

1. Initialize the intelligent cache service
2. Migrate existing cache keys to new format
3. Set up analytics tracking
4. Configure cache strategies per query type
5. Enable compression for Arabic content

### Data Migration

```dart
Future<void> migrateLegacyCache() async {
  final prefs = await SharedPreferences.getInstance();
  final legacyData = prefs.getString('old_cache_key');

  if (legacyData != null) {
    // Parse and migrate to new format
    final oldEntries = jsonDecode(legacyData);

    for (final entry in oldEntries) {
      await cache.store(
        query: entry['query'],
        language: entry['language'] ?? 'en',
        data: RagResponse.fromJson(entry['response']),
      );
    }

    // Clean up old cache
    await prefs.remove('old_cache_key');
  }
}
```

## Troubleshooting

### Common Issues

**High Memory Usage**

- Reduce `maxSize` in cache strategies
- Enable compression for large responses
- Increase eviction frequency

**Low Hit Ratio**

- Lower semantic similarity thresholds
- Increase cache TTL values
- Check query normalization

**Slow Performance**

- Enable compression for large Arabic texts
- Optimize semantic hash generation
- Use background prewarming

**Cache Misses**

- Check query normalization consistency
- Verify language detection accuracy
- Review similarity threshold settings

### Debug Mode

Enable debug logging:

```dart
// Set debug flag in cache service
const bool debugCaching = true;

if (debugCaching) {
  print('Cache hit for query: $query');
  print('Semantic hash: ${semanticHash.hash}');
  print('Similarity score: $similarityScore');
}
```

## Future Enhancements

- Machine learning-based query intent classification
- Distributed caching across multiple devices
- Real-time cache synchronization
- Advanced compression algorithms for Arabic text
- Predictive prewarming based on user patterns
- Cache warming based on prayer times and Islamic calendar
