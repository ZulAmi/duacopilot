# Smart Query Enhancement System

This document provides comprehensive documentation for the Smart Query Enhancement System in the DuaCopilot Flutter application.

## Overview

The Smart Query Enhancement System is a sophisticated preprocessing layer that transforms user queries into optimized, context-aware requests before sending them to the RAG API. This system significantly improves the relevance and accuracy of responses through intelligent text processing, contextual enrichment, and multi-language support.

## Architecture Components

### 1. QueryEnhancementService (`query_enhancement_service.dart`)

The main orchestrator that coordinates all enhancement processes.

**Key Features:**

- Text preprocessing and normalization
- Contextual information injection
- Query expansion with Islamic terminology
- Multi-language support (English, Arabic, Urdu, Indonesian)
- Intent classification
- Security validation and sanitization

### 2. IslamicTerminologyMapper (`islamic_terminology_mapper.dart`)

Handles Islamic terminology expansion and mapping across languages.

**Features:**

- Comprehensive Islamic term dictionaries for 4 languages
- Query expansion with related terminology
- Topic tag extraction
- Complexity scoring based on Islamic content
- Language-specific phrase generation

### 3. QueryValidator (`query_validator.dart`)

Provides security validation and content sanitization.

**Security Features:**

- XSS and injection attack prevention
- Malicious pattern detection
- Content appropriateness checking
- PII detection and removal
- Input sanitization and normalization

### 4. IntentClassifier (`intent_classifier.dart`)

Classifies user queries into specific intents for better contextual understanding.

**Supported Intents:**

- Prayer-related queries
- Du'a requests
- Quranic questions
- Hadith inquiries
- Fasting guidance
- Charity information
- Pilgrimage help
- Healing requests
- Protection prayers
- Gratitude expressions
- Forgiveness seeking
- Guidance requests
- Knowledge seeking
- Travel prayers
- Family matters
- Business inquiries
- Emergency situations

## Enhancement Process Flow

### Step 1: Input Validation and Sanitization

```
User Query → Security Validation → Content Sanitization → Normalized Input
```

**Security Checks:**

- Malicious script detection
- SQL injection prevention
- Character encoding validation
- Rate limiting verification
- PII detection and removal

**Sanitization Process:**

- HTML entity escaping
- Control character removal
- Whitespace normalization
- Length validation and truncation

### Step 2: Text Preprocessing and Normalization

```
Sanitized Input → Language Detection → Unicode Normalization → Text Preprocessing
```

**Language-Specific Processing:**

**Arabic:**

- Diacritic normalization
- Alif variant standardization
- Taa Marbouta normalization
- Religious symbol expansion (ﷺ → صلى الله عليه وسلم)

**Urdu:**

- Kaaf variant normalization
- Religious abbreviation expansion
- Urdu-specific character handling

**Indonesian:**

- Religious abbreviation expansion (SAW → Shallallahu Alaihi Wasallam)
- Indonesian Islamic terminology normalization

**English:**

- Religious abbreviation expansion (PBUH → Peace Be Upon Him)
- Islamic term standardization

### Step 3: Context Enhancement

```
Preprocessed Text → Context Generation → Time/Location Injection → Seasonal Context
```

**Contextual Information Added:**

- Current time of day (morning, afternoon, evening, night)
- Islamic date and calendar information
- Current prayer time context
- Seasonal information
- Geographic location context
- User preference integration

### Step 4: Intent Classification

```
Contextualized Query → Pattern Matching → Intent Scoring → Primary/Secondary Intent
```

**Classification Process:**

- Multi-language pattern matching
- Context modifier application
- Positional weight assignment
- Confidence score calculation
- Mixed intent detection

### Step 5: Islamic Terminology Expansion

```
Classified Query → Term Mapping → Synonym Addition → Related Concept Injection
```

**Expansion Examples:**

**English:**

- "prayer" → "prayer salah namaz worship prostration"
- "dua" → "dua supplication invocation prayer request"

**Arabic:**

- "صلاة" → "صلاة عبادة ركوع سجود قيام"
- "دعاء" → "دعاء استغاثة توسل ابتهال"

### Step 6: Semantic Tag Generation

```
Expanded Query → Content Analysis → Topic Extraction → Tag Assignment
```

**Tag Categories:**

- Intent tags (intent:prayer, intent:dua)
- Language tags (lang:ar, lang:en)
- Topic tags (islamic_topic:charity)
- Context tags (context:emotions, context:situations)
- Emotion tags (emotion:distressed, emotion:grateful)

### Step 7: Final Enhancement

```
Tagged Query → Confidence Calculation → Metadata Generation → Enhanced Query Object
```

## Usage Examples

### Basic Implementation

```dart
// Initialize the enhancement service
final queryEnhancer = QueryEnhancementService();

// Create context
final context = QueryContext(
  timestamp: DateTime.now(),
  location: "New York",
  deviceLanguage: "en",
  userPreferences: {
    'preferred_school': 'Hanafi',
    'difficulty_level': 'intermediate',
  },
);

// Enhance query
final enhancedQuery = await queryEnhancer.enhanceQuery(
  originalQuery: "I'm feeling anxious before my exam",
  language: "en",
  context: context,
);

// Use enhanced query with RAG service
final response = await ragService.searchDuas(
  query: enhancedQuery.processedQuery,
  language: enhancedQuery.language,
  additionalContext: enhancedQuery.metadata,
);
```

### Advanced Usage with Riverpod

```dart
class SmartSearchWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onSubmitted: (query) {
        // Create context with current information
        final queryContext = QueryContext(
          timestamp: DateTime.now(),
          location: "Current Location",
          userPreferences: ref.read(userPreferencesProvider),
        );

        // Perform enhanced search
        ref.read(ragApiProvider.notifier).performQuery(
          query,
          language: "en",
          context: queryContext,
        );
      },
    );
  }
}
```

## Multi-Language Support

### Language-Specific Features

#### Arabic (ar)

```dart
// Input: "أشعر بالقلق قبل الامتحان"
// Enhanced: "أشعر بالقلق قبل الامتحان استغاثة دعاء توسل [Context: في فترة الظهيرة]"

// Features:
- Diacritic normalization
- Religious symbol expansion
- Prayer time context in Arabic
- Islamic terminology in Arabic
```

#### Urdu (ur)

```dart
// Input: "امتحان سے پہلے گھبراہٹ"
// Enhanced: "امتحان سے پہلے گھبراہٹ التجا دعا منت [Context: دوپہر کے وقت]"

// Features:
- Urdu script normalization
- Religious abbreviation expansion
- Context phrases in Urdu
- Urdu Islamic terminology
```

#### Indonesian (id)

```dart
// Input: "cemas sebelum ujian"
// Enhanced: "cemas sebelum ujian permohonan doa munajat [Context: di siang hari]"

// Features:
- Indonesian Islamic term mapping
- Context phrases in Indonesian
- Religious abbreviation expansion
```

#### English (en)

```dart
// Input: "anxious before exam"
// Enhanced: "anxious before exam supplication prayer request [Context: in the afternoon]"

// Features:
- Islamic terminology expansion
- Religious abbreviation expansion
- English context phrases
```

## Configuration and Customization

### User Preferences Integration

```dart
final userPreferences = {
  'preferred_school': 'Hanafi',        // Islamic school of thought
  'difficulty_level': 'beginner',     // Content complexity
  'preferred_categories': [            // Preferred topic categories
    'daily_prayers',
    'guidance',
    'healing'
  ],
  'emotional_sensitivity': 'high',    // Emotional context sensitivity
  'location_sharing': true,           // Allow location context
  'time_context': true,               // Include time-based context
};
```

### Context Configuration

```dart
final context = QueryContext(
  timestamp: DateTime.now(),
  timeOfDay: TimeOfDay.afternoon,
  islamicDate: "15 Ramadan 1445",
  prayerTime: PrayerTime.dhuhr,
  seasonalContext: "summer",
  location: "Mecca, Saudi Arabia",
  userPreferences: userPreferences,
);
```

## Performance Optimization

### Caching Strategies

```dart
// Enhanced query caching
final cacheKey = "${originalQuery}_${language}_${context.hashCode}";
final cachedEnhancement = await enhancementCache.get(cacheKey);

if (cachedEnhancement != null) {
  return cachedEnhancement;
}

// Perform enhancement and cache result
final enhancement = await enhanceQuery(query, language, context);
await enhancementCache.put(cacheKey, enhancement, duration: Duration(hours: 1));
```

### Background Processing

```dart
// Use isolates for heavy text processing
final enhancement = await compute(
  _enhanceQueryInIsolate,
  QueryEnhancementParams(query, language, context),
);
```

### Debounced Enhancement

```dart
class DebouncedQueryEnhancer {
  Timer? _debounceTimer;

  void enhanceQuery(String query, Function(EnhancedQuery) callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () async {
      final enhanced = await queryEnhancer.enhanceQuery(
        originalQuery: query,
        language: currentLanguage,
      );
      callback(enhanced);
    });
  }
}
```

## Security Considerations

### Input Validation

```dart
// Security validation example
final validation = await validator.validateQuery(userInput);

if (!validation.isValid) {
  throw QueryValidationException(validation.errors.join(', '));
}

if (validation.hasSecurityIssues) {
  // Log security incident
  await securityLogger.logIncident(userInput, validation.errors);
  throw SecurityException('Potentially malicious input detected');
}
```

### Content Sanitization

```dart
// Sanitization process
String sanitized = validator.sanitizeQuery(userInput);

// Additional security measures
if (validator.containsPII(sanitized)) {
  sanitized = validator.removePII(sanitized);
}

if (validator.isSpamLike(sanitized)) {
  throw SpamException('Spam-like content detected');
}
```

## Error Handling and Fallbacks

### Graceful Degradation

```dart
try {
  final enhanced = await queryEnhancer.enhanceQuery(
    originalQuery: query,
    language: language,
    context: context,
  );
  return enhanced;
} catch (e) {
  // Fallback to basic query processing
  debugPrint('Enhancement failed: $e');
  return EnhancedQuery(
    originalQuery: query,
    processedQuery: query, // Use original as fallback
    language: language,
    intent: QueryIntent.general,
    context: context ?? QueryContext(),
    semanticTags: [],
    confidence: 0.5,
    processingSteps: ['fallback'],
    metadata: {'error': e.toString()},
  );
}
```

### Retry Logic

```dart
Future<EnhancedQuery> enhanceWithRetry(
  String query,
  String language, {
  int maxRetries = 3,
}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await enhanceQuery(query, language);
    } catch (e) {
      if (attempt == maxRetries) {
        return _createFallbackQuery(query, language);
      }
      await Future.delayed(Duration(milliseconds: 100 * attempt));
    }
  }
  throw Exception('All enhancement attempts failed');
}
```

## Monitoring and Analytics

### Performance Metrics

```dart
class QueryEnhancementMetrics {
  static final Map<String, int> _processingTimes = {};
  static final Map<String, int> _languageUsage = {};
  static final Map<QueryIntent, int> _intentCounts = {};

  static void recordProcessingTime(String step, int milliseconds) {
    _processingTimes[step] = (_processingTimes[step] ?? 0) + milliseconds;
  }

  static void recordLanguageUsage(String language) {
    _languageUsage[language] = (_languageUsage[language] ?? 0) + 1;
  }

  static void recordIntentClassification(QueryIntent intent) {
    _intentCounts[intent] = (_intentCounts[intent] ?? 0) + 1;
  }

  static Map<String, dynamic> getMetrics() {
    return {
      'processing_times': _processingTimes,
      'language_usage': _languageUsage,
      'intent_distribution': _intentCounts,
    };
  }
}
```

### Quality Assurance

```dart
class QueryEnhancementQA {
  static Future<QualityReport> assessEnhancement(
    String original,
    EnhancedQuery enhanced,
  ) async {
    final metrics = {
      'length_ratio': enhanced.processedQuery.length / original.length,
      'confidence_score': enhanced.confidence,
      'processing_steps': enhanced.processingSteps.length,
      'semantic_tags': enhanced.semanticTags.length,
      'intent_confidence': enhanced.intent != QueryIntent.unknown ? 1.0 : 0.0,
    };

    return QualityReport(
      original: original,
      enhanced: enhanced,
      metrics: metrics,
      quality_score: _calculateQualityScore(metrics),
    );
  }
}
```

## Testing

### Unit Tests

```dart
void main() {
  group('QueryEnhancementService Tests', () {
    late QueryEnhancementService service;

    setUp(() {
      service = QueryEnhancementService();
    });

    test('should enhance English query correctly', () async {
      final result = await service.enhanceQuery(
        originalQuery: "I'm worried about my exam",
        language: "en",
      );

      expect(result.intent, QueryIntent.guidance);
      expect(result.semanticTags, contains('emotion:distressed'));
      expect(result.confidence, greaterThan(0.5));
    });

    test('should handle Arabic text properly', () async {
      final result = await service.enhanceQuery(
        originalQuery: "أشعر بالقلق",
        language: "ar",
      );

      expect(result.language, "ar");
      expect(result.processedQuery, isNot(equals(result.originalQuery)));
    });
  });
}
```

### Integration Tests

```dart
void main() {
  group('Smart Query Integration Tests', () {
    testWidgets('should enhance and search successfully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SmartQueryDemoScreen(),
          ),
        ),
      );

      // Enter query
      await tester.enterText(
        find.byType(TextField),
        "I need guidance for my decision",
      );

      // Trigger search
      await tester.tap(find.text('Search with Smart Enhancement'));
      await tester.pumpAndSettle();

      // Verify enhancement occurred
      expect(find.text('Detected Intent'), findsOneWidget);
      expect(find.text('guidance'), findsOneWidget);
    });
  });
}
```

## Best Practices

1. **Always Validate Input**: Never process user input without proper validation
2. **Use Appropriate Language**: Ensure language detection is accurate before processing
3. **Cache Enhancements**: Cache enhancement results to improve performance
4. **Monitor Performance**: Track processing times and optimize bottlenecks
5. **Handle Errors Gracefully**: Provide fallbacks when enhancement fails
6. **Respect Privacy**: Be careful with location and personal data
7. **Test Across Languages**: Ensure all supported languages work correctly
8. **Update Terminology**: Keep Islamic terminology mappings current and accurate

## Future Enhancements

- **Machine Learning Integration**: Use TensorFlow Lite for advanced intent classification
- **Voice Input Processing**: Enhance voice-to-text queries
- **Contextual Learning**: Learn from user feedback to improve enhancements
- **Advanced Personalization**: More sophisticated user preference handling
- **Real-time Language Detection**: Automatic language detection for mixed-language queries
- **Sentiment Analysis**: Deeper emotional context understanding
- **Temporal Context**: More sophisticated time-based context injection
