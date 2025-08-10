# DuaCopilot Performance Optimization Guide

This guide provides a comprehensive overview of the performance optimizations implemented for the DuaCopilot RAG integration.

## Overview

The performance optimization system includes:

1. **Arabic Scroll Physics** - Custom scroll behaviors optimized for Arabic text and RTL layouts
2. **Memory-Efficient ListView** - Optimized list rendering for large RAG response datasets
3. **Media Optimization** - Image and audio caching with smart compression
4. **Background Processing** - Compute isolates for heavy text processing operations
5. **Platform-Specific Optimizations** - iOS/Android/Web/Desktop specific configurations
6. **Performance Monitoring** - Firebase Performance integration for RAG query metrics

## Quick Start

### 1. Basic Setup

Wrap your app with the performance optimization wrapper:

```dart
import 'package:duacopilot/core/performance/performance_integration.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerformanceOptimizedApp(
      enableArabicScrollOptimization: true,
      enablePerformanceMonitoring: true,
      child: MaterialApp(
        home: YourHomeScreen(),
      ),
    );
  }
}
```

### 2. Using Optimized Components

#### Arabic-Optimized ListView

```dart
import 'package:duacopilot/presentation/widgets/optimized_rag_list_view.dart';

OptimizedRagListView(
  ragResponses: responses,
  itemBuilder: (context, response, index) {
    return Card(
      child: ListTile(
        title: Text(response.text),
        subtitle: Text('Confidence: ${response.confidence}'),
      ),
    );
  },
  isArabic: true,
  enableVirtualization: true,
)
```

#### Optimized Image Loading

```dart
import 'package:duacopilot/core/performance/performance_integration.dart';

PerformanceHelpers.createOptimizedImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
  placeholder: CircularProgressIndicator(),
  errorWidget: Icon(Icons.error),
)
```

#### Background Text Processing

```dart
import 'package:duacopilot/core/performance/performance_integration.dart';

// Extract keywords in background
final keywords = await PerformanceHelpers.extractKeywordsInBackground(arabicText);

// Analyze sentiment in background
final sentiment = await PerformanceHelpers.analyzeSentimentInBackground(arabicText);

// Measure performance of operations
final result = await PerformanceHelpers.measurePerformance(
  operationName: 'rag_query',
  operation: () async {
    return await ragService.processQuery(query);
  },
  attributes: {
    'query_type': 'semantic_search',
    'language': 'arabic',
  },
);
```

## Advanced Usage

### 1. Custom Performance Monitoring

```dart
import 'package:duacopilot/core/performance/performance_monitoring.dart';

class MyRagService {
  final RagPerformanceMonitor _monitor = RagPerformanceMonitor();

  Future<RagResponse> processQuery(String query) async {
    // Start monitoring
    final traceId = await _monitor.startRagQueryTrace(
      queryText: query,
      queryType: 'semantic_search',
      customAttributes: {
        'user_id': currentUserId,
        'language': 'arabic',
      },
    );

    try {
      // Process query
      final response = await _performRagQuery(query);

      // Stop monitoring with success metrics
      await _monitor.stopRagQueryTrace(
        traceId: traceId,
        success: true,
        responseLength: response.text.length,
        confidence: response.confidence,
      );

      return response;
    } catch (error) {
      // Stop monitoring with error
      await _monitor.stopRagQueryTrace(
        traceId: traceId,
        success: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }
}
```

### 2. Platform-Specific Optimizations

```dart
import 'package:duacopilot/core/performance/platform_optimizer.dart';

class PlatformAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = PlatformOptimizer.getPlatformConfig();

    return AnimatedContainer(
      duration: config.animationDuration,
      curve: config.animationCurve,
      child: ListView.builder(
        cacheExtent: config.listViewCacheExtent,
        itemBuilder: (context, index) {
          return _buildItem(index);
        },
      ),
    );
  }
}
```

### 3. Widget Extensions

```dart
import 'package:duacopilot/core/performance/performance_integration.dart';

Widget myWidget = Container(
  child: Text('Arabic text content'),
)
.withArabicScrollOptimization(isRTL: true)
.withPerformanceMonitoring(
  name: 'arabic_content_widget',
  attributes: {'content_type': 'dua'},
);
```

### 4. Background Processing

```dart
import 'package:duacopilot/core/performance/background_processing.dart';

class TextAnalysisService {
  Future<Map<String, dynamic>> analyzeText(String text) async {
    // Process text analysis in background isolate
    return await RagBackgroundProcessor.processTextAnalysis(
      text: text,
      includeKeywords: true,
      includeSentiment: true,
      includeLanguageDetection: true,
    );
  }

  Future<List<String>> extractKeywords(String text) async {
    return await RagBackgroundProcessor.extractKeywords(text: text);
  }

  Future<SentimentAnalysisResult> analyzeSentiment(String text) async {
    return await RagBackgroundProcessor.analyzeSentiment(
      text: text,
      language: 'ar',
    );
  }
}
```

## Performance Best Practices

### 1. Memory Management

- Use `OptimizedRagListView` for large datasets
- Enable virtualization for lists with 100+ items
- Dispose of resources properly in widget lifecycle

```dart
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late final RagImageCacheManager _cacheManager;

  @override
  void initState() {
    super.initState();
    _cacheManager = RagImageCacheManager();
  }

  @override
  void dispose() {
    _cacheManager.dispose();
    super.dispose();
  }
}
```

### 2. Arabic Text Optimization

- Use `ArabicScrollPhysics` for Arabic content
- Enable RTL support in scroll configurations
- Use Arabic-aware text measurement

```dart
ScrollConfiguration(
  behavior: ArabicScrollBehavior(isRTL: true),
  child: ListView(
    physics: ArabicScrollPhysics(),
    children: arabicContent.map((text) =>
      Text(text, textDirection: TextDirection.rtl)
    ).toList(),
  ),
)
```

### 3. Performance Monitoring

- Monitor critical RAG operations
- Set up custom metrics for key user flows
- Use execution time measurement for optimization

```dart
// Monitor critical operations
final result = await PerformanceUtils.measureExecutionTime(
  operationName: 'critical_rag_operation',
  operation: () async {
    return await criticalOperation();
  },
  attributes: {
    'operation_type': 'semantic_search',
    'data_size': dataSize.toString(),
  },
);
```

## Configuration

### 1. Platform-Specific Settings

Each platform has optimized configurations:

- **iOS**: Native scroll physics, Core Animation optimizations
- **Android**: Material Design scroll physics, GPU acceleration
- **Web**: Canvas optimizations, service worker caching
- **Desktop**: High DPI support, efficient rendering

### 2. Performance Thresholds

Configure performance thresholds based on your needs:

```dart
const performanceConfig = {
  'max_list_items_without_virtualization': 50,
  'image_cache_size_mb': 100,
  'background_isolate_timeout_seconds': 30,
  'scroll_physics_spring_tension': 0.8,
};
```

## Troubleshooting

### Common Issues

1. **High Memory Usage**

   - Enable virtualization for large lists
   - Reduce image cache size
   - Dispose of unused resources

2. **Slow Scroll Performance**

   - Use `ArabicScrollPhysics` for Arabic content
   - Enable `RepaintBoundary` for complex widgets
   - Reduce widget rebuilds

3. **Background Processing Timeout**
   - Increase isolate timeout
   - Break large operations into smaller chunks
   - Use progress callbacks for long operations

### Debug Mode Features

In debug mode, additional logging and metrics are available:

```dart
// Enable debug logging
debugPrint('Performance monitoring enabled: ${kDebugMode}');

// Monitor memory usage
PerformanceUtils.measureMemoryUsage('after_rag_query');
```

## Migration Guide

### From Basic ListView to Optimized

```dart
// Before
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => buildItem(items[index]),
)

// After
OptimizedRagListView(
  ragResponses: items,
  itemBuilder: (context, item, index) => buildItem(item),
  enableVirtualization: true,
  isArabic: true,
)
```

### Adding Performance Monitoring

```dart
// Before
final result = await ragService.query(text);

// After
final result = await PerformanceHelpers.measurePerformance(
  operationName: 'rag_query',
  operation: () => ragService.query(text),
);
```

## Performance Metrics

The system tracks several key metrics:

- **Query Processing Time**: Time to process RAG queries
- **Memory Usage**: Memory consumption patterns
- **Scroll Performance**: Frame rates and scroll smoothness
- **Image Loading**: Cache hit rates and loading times
- **Background Processing**: Isolate execution times

These metrics are automatically sent to Firebase Performance for analysis and optimization.
