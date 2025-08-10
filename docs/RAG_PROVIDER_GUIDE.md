# RAG Provider Integration Guide

This document explains how to integrate and use the RAG (Retrieval-Augmented Generation) providers in your Flutter app using Riverpod.

## Provider Architecture

The RAG system uses a layered provider architecture with the following components:

### Core Providers (`provider_config.dart`)

1. **sharedPreferencesProvider** - Provides SharedPreferences instance
2. **ragApiClientProvider** - Provides RAG API client
3. **ragServiceProvider** - Provides high-level RAG service

### State Management Providers (`rag_provider.dart`)

1. **ragApiProvider** - Main API state management with AsyncNotifier
2. **ragCacheProvider** - Response caching with automatic expiration
3. **ragFilterProvider** - Response filtering and processing
4. **ragWebSocketProvider** - Real-time WebSocket connections
5. **ragUpdatesStreamProvider** - Stream of real-time updates

## Setup Instructions

### 1. Configure Providers in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lib/presentation/providers/provider_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override the SharedPreferences provider with actual instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot',
      home: HomeScreen(),
    );
  }
}
```

### 2. Using RAG Providers in Widgets

#### Basic Search Implementation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rag_provider.dart';

class RagSearchWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<RagSearchWidget> createState() => _RagSearchWidgetState();
}

class _RagSearchWidgetState extends ConsumerState<RagSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ragState = ref.watch(ragApiProvider);

    return Column(
      children: [
        // Search Input
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for Du\'as...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _performSearch(_searchController.text),
            ),
          ),
          onSubmitted: _performSearch,
        ),

        // Search Results
        Expanded(
          child: ragState.when(
            data: (data) => _buildSearchResults(data),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorWidget(error),
          ),
        ),
      ],
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      ref.read(ragApiProvider.notifier).performQuery(query);
    }
  }

  Widget _buildSearchResults(RagStateData data) {
    if (data.apiState == RagApiState.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (data.response == null) {
      return Center(child: Text('Enter a search query'));
    }

    return ListView(
      children: [
        ListTile(
          title: Text('Query: ${data.currentQuery ?? 'Unknown'}'),
          subtitle: Text('Response: ${data.response!.response}'),
          trailing: data.isFromCache
            ? Icon(Icons.cached, color: Colors.green)
            : Icon(Icons.cloud_download, color: Colors.blue),
        ),
        if (data.confidence != null)
          ListTile(
            title: Text('Confidence'),
            trailing: Text('${(data.confidence! * 100).toStringAsFixed(1)}%'),
          ),
      ],
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Error: $error'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _performSearch(_searchController.text),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

#### Advanced Cache Management

```dart
class CacheManagementWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheState = ref.watch(ragCacheProvider);
    final cacheNotifier = ref.read(ragCacheProvider.notifier);

    return Column(
      children: [
        // Cache Statistics
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cache Statistics', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                ...cacheNotifier.getStats().entries.map((entry) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(entry.value.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Cache Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => cacheNotifier.invalidateExpired(),
              child: Text('Clean Expired'),
            ),
            ElevatedButton(
              onPressed: () => cacheNotifier.clear(),
              child: Text('Clear All'),
            ),
          ],
        ),

        // Cached Entries
        Expanded(
          child: ListView.builder(
            itemCount: cacheState.length,
            itemBuilder: (context, index) {
              final entry = cacheState.values.elementAt(index);
              return ListTile(
                title: Text(entry.query),
                subtitle: Text('Cached: ${entry.timestamp}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => cacheNotifier.remove(entry.query),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

#### Filter Configuration

```dart
class FilterConfigWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterConfig = ref.watch(ragFilterProvider);
    final filterNotifier = ref.read(ragFilterProvider.notifier);

    return Column(
      children: [
        // Confidence Threshold
        ListTile(
          title: Text('Minimum Confidence'),
          subtitle: Slider(
            value: filterConfig.minConfidence,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(filterConfig.minConfidence * 100).round()}%',
            onChanged: (value) => filterNotifier.updateMinConfidence(value),
          ),
        ),

        // Maximum Results
        ListTile(
          title: Text('Maximum Results'),
          subtitle: Slider(
            value: filterConfig.maxResults.toDouble(),
            min: 1,
            max: 50,
            divisions: 49,
            label: filterConfig.maxResults.toString(),
            onChanged: (value) => filterNotifier.updateMaxResults(value.round()),
          ),
        ),

        // Language Filter
        ExpansionTile(
          title: Text('Language Filter'),
          children: [
            CheckboxListTile(
              title: Text('English'),
              value: filterConfig.languageFilter.contains('en'),
              onChanged: (enabled) => _toggleLanguage(ref, 'en', enabled ?? false),
            ),
            CheckboxListTile(
              title: Text('Arabic'),
              value: filterConfig.languageFilter.contains('ar'),
              onChanged: (enabled) => _toggleLanguage(ref, 'ar', enabled ?? false),
            ),
          ],
        ),

        // Reset Button
        ElevatedButton(
          onPressed: () => filterNotifier.resetToDefaults(),
          child: Text('Reset to Defaults'),
        ),
      ],
    );
  }

  void _toggleLanguage(WidgetRef ref, String language, bool enabled) {
    final currentLanguages = ref.read(ragFilterProvider).languageFilter;
    final newLanguages = List<String>.from(currentLanguages);

    if (enabled) {
      newLanguages.add(language);
    } else {
      newLanguages.remove(language);
    }

    ref.read(ragFilterProvider.notifier).updateLanguageFilter(newLanguages);
  }
}
```

#### Real-time Updates

```dart
class RealTimeUpdatesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webSocketState = ref.watch(ragWebSocketProvider);
    final updatesStream = ref.watch(ragUpdatesStreamProvider);

    return Column(
      children: [
        // Connection Status
        Card(
          color: _getConnectionColor(webSocketState.connectionState),
          child: ListTile(
            leading: Icon(_getConnectionIcon(webSocketState.connectionState)),
            title: Text('WebSocket Status'),
            subtitle: Text(webSocketState.connectionState.name),
            trailing: webSocketState.error != null
              ? Tooltip(
                  message: webSocketState.error!,
                  child: Icon(Icons.error),
                )
              : null,
          ),
        ),

        // Real-time Updates
        Expanded(
          child: updatesStream.when(
            data: (update) => _buildUpdateWidget(update),
            loading: () => Center(child: Text('Waiting for updates...')),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }

  Color _getConnectionColor(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return Colors.green.shade100;
      case WebSocketConnectionState.connecting:
        return Colors.orange.shade100;
      case WebSocketConnectionState.disconnected:
        return Colors.grey.shade100;
      case WebSocketConnectionState.error:
        return Colors.red.shade100;
    }
  }

  IconData _getConnectionIcon(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return Icons.wifi;
      case WebSocketConnectionState.connecting:
        return Icons.wifi_calling;
      case WebSocketConnectionState.disconnected:
        return Icons.wifi_off;
      case WebSocketConnectionState.error:
        return Icons.wifi_off;
    }
  }

  Widget _buildUpdateWidget(RagResponse update) {
    return ListTile(
      title: Text('Real-time Update'),
      subtitle: Text(update.response),
      trailing: Text(update.timestamp.toString()),
    );
  }
}
```

## Error Handling

### Automatic Retry Logic

The `RagApiNotifier` includes automatic retry logic with exponential backoff:

```dart
// Automatic retry is handled internally
await ref.read(ragApiProvider.notifier).performQuery('search query');

// Manual retry
if (ragState.hasError) {
  ref.read(ragApiProvider.notifier).performQuery(ragState.value?.currentQuery ?? '');
}
```

### Custom Error Handling

```dart
final ragState = ref.watch(ragApiProvider);

ragState.when(
  data: (data) {
    if (data.apiState == RagApiState.error) {
      return ErrorWidget(data.error ?? 'Unknown error');
    }
    return SuccessWidget(data);
  },
  loading: () => LoadingWidget(),
  error: (error, stack) => CriticalErrorWidget(error),
);
```

## Performance Optimization

### Debounced Search

```dart
class DebouncedSearchWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<DebouncedSearchWidget> createState() => _DebouncedSearchWidgetState();
}

class _DebouncedSearchWidgetState extends ConsumerState<DebouncedSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      if (_controller.text.isNotEmpty) {
        ref.read(ragApiProvider.notifier).performQuery(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(hintText: 'Search...'),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
```

### Memory Management

```dart
class MemoryEfficientRagWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only keep providers alive when widget is visible
    ref.keepAlive();

    return Container(/* widget content */);
  }
}
```

## Testing

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('RagApiNotifier Tests', () {
    late ProviderContainer container;
    late MockRagService mockRagService;

    setUp(() {
      mockRagService = MockRagService();
      container = ProviderContainer(
        overrides: [
          ragServiceProvider.overrideWithValue(mockRagService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should perform search successfully', () async {
      // Setup mock response
      when(mockRagService.searchDuas(query: 'test'))
          .thenAnswer((_) async => MockRagSearchResponse());

      // Perform search
      await container.read(ragApiProvider.notifier).performQuery('test');

      // Verify state
      final state = container.read(ragApiProvider).value;
      expect(state?.apiState, RagApiState.success);
    });
  });
}
```

### Widget Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('RagSearchWidget displays search results', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ragServiceProvider.overrideWithValue(MockRagService()),
        ],
        child: MaterialApp(home: RagSearchWidget()),
      ),
    );

    // Perform search
    await tester.enterText(find.byType(TextField), 'test query');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify results
    expect(find.text('test query'), findsOneWidget);
  });
}
```

## Best Practices

1. **Provider Lifecycle**: Use `ref.keepAlive()` for providers that should persist
2. **Memory Management**: Dispose of providers when no longer needed
3. **Error Boundaries**: Always handle provider errors gracefully
4. **Performance**: Use `select` to watch specific parts of provider state
5. **Testing**: Mock providers for unit and widget tests
6. **Caching**: Configure appropriate cache sizes and expiration times

## Troubleshooting

### Common Issues

1. **Provider Not Found**: Ensure providers are properly configured in main.dart
2. **Memory Leaks**: Dispose of controllers and cancel timers
3. **State Inconsistency**: Use immutable state models and proper copyWith methods
4. **Network Errors**: Implement proper retry logic and fallback mechanisms

### Debug Tools

```dart
// Log provider state changes
ref.listen(ragApiProvider, (previous, next) {
  print('RAG state changed: ${previous?.value?.apiState} -> ${next.value?.apiState}');
});

// Monitor cache performance
final cacheStats = ref.read(ragCacheProvider.notifier).getStats();
print('Cache stats: $cacheStats');
```
