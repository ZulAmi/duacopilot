# Quick Start Guide - Smart Query Enhancement

This guide will help you quickly test and integrate the Smart Query Enhancement system.

## 1. Testing the Demo

### Run the Demo Screen

```dart
// Add to your app's routes or navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SmartQueryDemoScreen(),
  ),
);
```

### Test Cases to Try

#### English Queries:

- "I'm feeling anxious before my exam"
- "Need protection prayer for travel"
- "Dua for healing from illness"
- "Guidance for making important decision"
- "Thank you prayer after success"

#### Arabic Queries:

- "أشعر بالقلق قبل الامتحان"
- "دعاء للشفاء من المرض"
- "استغفار بعد الذنب"

#### Urdu Queries:

- "امتحان سے پہلے گھبراہٹ"
- "سفر کے لیے حفاظت کی دعا"
- "بیماری سے شفا کی دعا"

#### Indonesian Queries:

- "cemas sebelum ujian"
- "doa perlindungan perjalanan"
- "doa kesembuhan dari sakit"

## 2. Integration Steps

### Step 1: Configure Providers

Ensure your `provider_config.dart` includes:

```dart
final queryEnhancementServiceProvider = Provider<QueryEnhancementService>(
  (ref) => QueryEnhancementService(),
);
```

### Step 2: Update Your Search Widget

```dart
class SmartSearchField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Ask about prayers, duas, guidance...',
        prefixIcon: Icon(Icons.search),
      ),
      onSubmitted: (query) async {
        if (query.trim().isEmpty) return;

        // Create context
        final context = QueryContext(
          timestamp: DateTime.now(),
          deviceLanguage: Localizations.localeOf(context).languageCode,
          userPreferences: {
            'preferred_school': 'Hanafi',
            'difficulty_level': 'intermediate',
          },
        );

        // Perform enhanced search
        await ref.read(ragApiProvider.notifier).performQuery(
          query,
          language: context.deviceLanguage,
          context: context,
        );
      },
    );
  }
}
```

### Step 3: Display Enhanced Results

```dart
Consumer(
  builder: (context, ref, child) {
    final ragState = ref.watch(ragApiProvider);

    return ragState.when(
      data: (results) => ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Card(
            child: ListTile(
              title: Text(result.title),
              subtitle: Text(result.content),
              trailing: result.metadata?['confidence'] != null
                ? Chip(
                    label: Text(
                      '${(result.metadata!['confidence'] * 100).round()}%',
                    ),
                  )
                : null,
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  },
)
```

## 3. Configuration Options

### Basic Configuration

```dart
final queryEnhancer = QueryEnhancementService();

// Simple enhancement
final enhanced = await queryEnhancer.enhanceQuery(
  originalQuery: userInput,
  language: "en",
);
```

### Advanced Configuration

```dart
final context = QueryContext(
  timestamp: DateTime.now(),
  location: "Your Location",
  deviceLanguage: "en",
  userPreferences: {
    'preferred_school': 'Hanafi',      // Shafi, Maliki, Hanbali
    'difficulty_level': 'intermediate', // beginner, advanced
    'preferred_categories': [
      'daily_prayers',
      'guidance',
      'healing',
    ],
    'emotional_sensitivity': 'high',    // low, medium, high
  },
);

final enhanced = await queryEnhancer.enhanceQuery(
  originalQuery: userInput,
  language: detectedLanguage,
  context: context,
);
```

## 4. Language Detection

### Automatic Detection

```dart
String detectLanguage(String text) {
  // Arabic detection
  if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) return 'ar';

  // Urdu detection (has Arabic script + specific characters)
  if (RegExp(r'[\u0600-\u06FF].*[\u06A9\u06AF\u06BE\u06CC]').hasMatch(text)) return 'ur';

  // Indonesian detection
  if (RegExp(r'\b(doa|shalat|puasa|zakat|haji)\b', caseSensitive: false).hasMatch(text)) return 'id';

  // Default to English
  return 'en';
}
```

### Manual Language Selection

```dart
class LanguageSelector extends StatefulWidget {
  final Function(String) onLanguageChanged;

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      items: [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
        DropdownMenuItem(value: 'ur', child: Text('اردو')),
        DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
      ],
      onChanged: (language) {
        setState(() {
          selectedLanguage = language!;
        });
        widget.onLanguageChanged(language!);
      },
    );
  }
}
```

## 5. Performance Optimization

### Debounced Search

```dart
class DebouncedSearch extends StatefulWidget {
  @override
  _DebouncedSearchState createState() => _DebouncedSearchState();
}

class _DebouncedSearchState extends State<DebouncedSearch> {
  Timer? _debounceTimer;
  final TextEditingController _controller = TextEditingController();

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    // Perform enhanced search
    final context = QueryContext(timestamp: DateTime.now());

    final enhanced = await ref.read(queryEnhancementServiceProvider)
        .enhanceQuery(
      originalQuery: query,
      language: "en",
      context: context,
    );

    // Use enhanced query for search
    await ref.read(ragApiProvider.notifier).searchWithEnhancedQuery(enhanced);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Type to search...',
      ),
    );
  }
}
```

### Caching Enhancement Results

```dart
class CachedQueryEnhancer {
  static final Map<String, EnhancedQuery> _cache = {};
  static const int maxCacheSize = 100;

  static Future<EnhancedQuery> enhance(
    String query,
    String language,
    QueryContext context,
  ) async {
    final cacheKey = '$query-$language-${context.hashCode}';

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final enhancer = QueryEnhancementService();
    final enhanced = await enhancer.enhanceQuery(
      originalQuery: query,
      language: language,
      context: context,
    );

    // Manage cache size
    if (_cache.length >= maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    _cache[cacheKey] = enhanced;
    return enhanced;
  }
}
```

## 6. Error Handling

### Graceful Fallbacks

```dart
Future<List<SearchResult>> searchWithFallback(String query) async {
  try {
    // Try enhanced search first
    final enhanced = await queryEnhancer.enhanceQuery(
      originalQuery: query,
      language: "en",
    );

    return await ragService.search(enhanced.processedQuery);
  } catch (enhancementError) {
    debugPrint('Enhancement failed: $enhancementError');

    try {
      // Fallback to basic search
      return await ragService.search(query);
    } catch (searchError) {
      debugPrint('Basic search failed: $searchError');

      // Final fallback - return predefined helpful results
      return _getHelpfulFallbackResults(query);
    }
  }
}

List<SearchResult> _getHelpfulFallbackResults(String query) {
  return [
    SearchResult(
      title: "Search Tips",
      content: "Try asking about prayers, duas, or Islamic guidance. For example: 'dua for anxiety' or 'prayer for success'",
      source: "System Help",
    ),
  ];
}
```

## 7. Testing Checklist

- [ ] Test with all supported languages (en, ar, ur, id)
- [ ] Verify intent classification works correctly
- [ ] Check Islamic terminology expansion
- [ ] Test security validation with various inputs
- [ ] Verify context injection works properly
- [ ] Test error handling and fallbacks
- [ ] Check performance with large queries
- [ ] Verify caching works correctly
- [ ] Test with mixed-language inputs
- [ ] Check metadata preservation

## 8. Common Issues and Solutions

### Issue: Enhancement is slow

**Solution**: Implement caching and debouncing

```dart
// Use debouncing for search inputs
Timer? _debounceTimer;
_debounceTimer?.cancel();
_debounceTimer = Timer(Duration(milliseconds: 300), () {
  performSearch(query);
});
```

### Issue: Intent classification is inaccurate

**Solution**: Add more context or train with user feedback

```dart
// Provide more context for better classification
final context = QueryContext(
  timestamp: DateTime.now(),
  emotionalContext: "distressed", // Add emotional context
  situationalContext: "academic", // Add situational context
);
```

### Issue: Language detection fails

**Solution**: Use explicit language selection or improve detection

```dart
// Explicit language selection
String? userSelectedLanguage = await showLanguageDialog();
String language = userSelectedLanguage ?? detectLanguage(query);
```

### Issue: Security validation is too strict

**Solution**: Adjust validation parameters

```dart
// Configure validator for your use case
final validator = QueryValidator(
  maxLength: 1000,        // Increase if needed
  allowEmojis: true,      // Allow emojis if appropriate
  strictMode: false,      // Reduce strictness
);
```

That's it! Your Smart Query Enhancement system is now ready to use. Start with the demo screen to see all features in action, then integrate the components into your existing search functionality.
