import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../data/models/offline/offline_search_models.dart';
import 'local_vector_storage_service.dart';

/// Service for managing fallback response templates
class FallbackTemplateService {
  static const String _templatesEnPath = 'assets/offline_data/templates_en.json';
  static const String _templatesArPath = 'assets/offline_data/templates_ar.json';

  final LocalVectorStorageService _storageService;
  final Map<String, List<FallbackTemplate>> _memoryCache = {};
  bool _isInitialized = false;

  FallbackTemplateService(this._storageService);

  /// Initialize the fallback template service
  Future<void> initialize() async {
    try {
      await _loadTemplatesFromAssets();
      _isInitialized = true;
      print('FallbackTemplateService initialized successfully');
    } catch (e) {
      print('Failed to initialize FallbackTemplateService: $e');
      _isInitialized = false;
    }
  }

  bool get isReady => _isInitialized;

  /// Get fallback response for a query
  Future<OfflineSearchResult?> getFallbackResponse({
    required String query,
    required String language,
    String? category,
    Map<String, dynamic>? context,
  }) async {
    if (!isReady) return null;

    try {
      // Extract keywords from query
      final keywords = _extractKeywords(query);

      // Find best matching template
      final template = await _findBestTemplate(keywords: keywords, language: language, category: category);

      if (template == null) {
        return _createGenericFallback(query, language);
      }

      // Generate response from template
      final response = _generateResponseFromTemplate(template, keywords, context);

      return OfflineSearchResult(
        queryId: _generateQueryId(),
        matches: response,
        confidence: 0.3, // Low confidence for fallback
        quality: SearchQuality.low,
        reasoning: 'Generated from fallback template: ${template.category}',
        timestamp: DateTime.now(),
        metadata: {
          'template_id': template.id,
          'template_category': template.category,
          'matched_keywords': keywords,
          'source': 'fallback_template',
        },
      );
    } catch (e) {
      print('Error generating fallback response: $e');
      return _createGenericFallback(query, language);
    }
  }

  /// Get available template categories for a language
  Future<List<String>> getAvailableCategories(String language) async {
    if (!isReady) return [];

    final templates = await _storageService.getFallbackTemplates(language: language);
    return templates.map((t) => t.category).toSet().toList();
  }

  /// Get template statistics
  Future<Map<String, dynamic>> getTemplateStats() async {
    if (!isReady) return {};

    final allTemplates = await _storageService.getFallbackTemplates();

    final languageCount = <String, int>{};
    final categoryCount = <String, int>{};

    for (final template in allTemplates) {
      languageCount[template.language] = (languageCount[template.language] ?? 0) + 1;
      categoryCount[template.category] = (categoryCount[template.category] ?? 0) + 1;
    }

    return {
      'total_templates': allTemplates.length,
      'languages': languageCount,
      'categories': categoryCount,
      'average_priority':
          allTemplates.isEmpty
              ? 0.0
              : allTemplates.map((t) => t.priority).reduce((a, b) => a + b) / allTemplates.length,
    };
  }

  /// Update templates from remote source (for progressive enhancement)
  Future<void> updateTemplatesFromRemote(Map<String, dynamic> remoteTemplates) async {
    try {
      final templates = <FallbackTemplate>[];

      for (final entry in remoteTemplates.entries) {
        final templateData = entry.value as Map<String, dynamic>;

        final template = FallbackTemplate(
          id: entry.key,
          category: templateData['category'] as String,
          language: templateData['language'] as String,
          template: templateData['template'] as String,
          keywords: List<String>.from(templateData['keywords'] as List),
          priority: (templateData['priority'] as num).toDouble(),
          variations: Map<String, dynamic>.from(templateData['variations'] as Map? ?? {}),
          createdAt: DateTime.now(),
        );

        templates.add(template);
      }

      // Store updated templates
      await _storageService.storeBatchFallbackTemplates(templates);

      // Clear memory cache to force reload
      _memoryCache.clear();

      print('Updated ${templates.length} templates from remote source');
    } catch (e) {
      print('Error updating templates from remote: $e');
    }
  }

  // Private methods

  Future<void> _loadTemplatesFromAssets() async {
    try {
      // Load English templates
      await _loadLanguageTemplates('en', _templatesEnPath);

      // Load Arabic templates
      await _loadLanguageTemplates('ar', _templatesArPath);
    } catch (e) {
      print('Error loading templates from assets: $e');
      // Create default templates if loading fails
      await _createDefaultTemplates();
    }
  }

  Future<void> _loadLanguageTemplates(String language, String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      final templates = <FallbackTemplate>[];

      for (final entry in jsonData.entries) {
        final templateData = entry.value as Map<String, dynamic>;

        final template = FallbackTemplate(
          id: '${language}_${entry.key}',
          category: templateData['category'] as String,
          language: language,
          template: templateData['template'] as String,
          keywords: List<String>.from(templateData['keywords'] as List),
          priority: (templateData['priority'] as num?)?.toDouble() ?? 1.0,
          variations: Map<String, dynamic>.from(templateData['variations'] as Map? ?? {}),
          createdAt: DateTime.now(),
        );

        templates.add(template);
      }

      // Store templates in local storage
      await _storageService.storeBatchFallbackTemplates(templates);

      // Cache in memory
      _memoryCache[language] = templates;

      print('Loaded ${templates.length} ${language.toUpperCase()} templates');
    } catch (e) {
      print('Error loading $language templates: $e');
    }
  }

  Future<void> _createDefaultTemplates() async {
    final defaultTemplates = [
      // English templates
      FallbackTemplate(
        id: 'en_general_prayer',
        category: 'general',
        language: 'en',
        template: 'Here are some general prayers that might help with your request.',
        keywords: ['prayer', 'dua', 'help', 'guidance'],
        priority: 1.0,
        createdAt: DateTime.now(),
      ),
      FallbackTemplate(
        id: 'en_morning_prayers',
        category: 'morning',
        language: 'en',
        template: 'Here are morning prayers and supplications.',
        keywords: ['morning', 'dawn', 'fajr', 'sunrise'],
        priority: 2.0,
        createdAt: DateTime.now(),
      ),
      FallbackTemplate(
        id: 'en_evening_prayers',
        category: 'evening',
        language: 'en',
        template: 'Here are evening prayers and supplications.',
        keywords: ['evening', 'sunset', 'maghrib', 'night'],
        priority: 2.0,
        createdAt: DateTime.now(),
      ),

      // Arabic templates
      FallbackTemplate(
        id: 'ar_general_prayer',
        category: 'general',
        language: 'ar',
        template: 'إليك بعض الأدعية العامة التي قد تساعد في طلبك',
        keywords: ['دعاء', 'صلاة', 'مساعدة', 'هداية'],
        priority: 1.0,
        createdAt: DateTime.now(),
      ),
      FallbackTemplate(
        id: 'ar_morning_prayers',
        category: 'morning',
        language: 'ar',
        template: 'إليك أدعية الصباح والأذكار',
        keywords: ['صباح', 'فجر', 'شروق', 'أذكار'],
        priority: 2.0,
        createdAt: DateTime.now(),
      ),
    ];

    await _storageService.storeBatchFallbackTemplates(defaultTemplates);
    print('Created ${defaultTemplates.length} default templates');
  }

  Future<FallbackTemplate?> _findBestTemplate({
    required List<String> keywords,
    required String language,
    String? category,
  }) async {
    // Try memory cache first
    if (_memoryCache.containsKey(language)) {
      final template = _findBestFromList(_memoryCache[language]!, keywords, category);
      if (template != null) return template;
    }

    // Get from storage
    final templates = await _storageService.getFallbackTemplates(language: language, category: category);

    return _findBestFromList(templates, keywords, category);
  }

  FallbackTemplate? _findBestFromList(List<FallbackTemplate> templates, List<String> keywords, String? category) {
    if (templates.isEmpty) return null;

    FallbackTemplate? bestTemplate;
    double bestScore = 0.0;

    for (final template in templates) {
      double score = template.priority;

      // Keyword matching score
      for (final keyword in keywords) {
        if (template.keywords.any((k) => k.toLowerCase().contains(keyword.toLowerCase()))) {
          score += 2.0;
        }
      }

      // Category matching bonus
      if (category != null && template.category.toLowerCase() == category.toLowerCase()) {
        score += 5.0;
      }

      if (score > bestScore) {
        bestScore = score;
        bestTemplate = template;
      }
    }

    return bestTemplate;
  }

  List<String> _extractKeywords(String query) {
    // Simple keyword extraction
    final words =
        query
            .toLowerCase()
            .replaceAll(RegExp(r'[^\w\s]'), ' ')
            .split(' ')
            .where((word) => word.isNotEmpty && word.length > 2)
            .toList();

    // Remove common stop words
    final stopWords = {
      'the',
      'and',
      'for',
      'are',
      'but',
      'not',
      'you',
      'all',
      'can',
      'had',
      'her',
      'was',
      'one',
      'our',
      'out',
      'day',
      'get',
      'has',
      'him',
      'his',
      'how',
      'its',
      'may',
      'new',
      'now',
      'old',
      'see',
      'two',
      'way',
      'who',
      'boy',
      'did',
      'does',
      'let',
      'put',
      'say',
      'she',
      'too',
      'use',
    };

    return words.where((word) => !stopWords.contains(word)).toList();
  }

  List<OfflineDuaMatch> _generateResponseFromTemplate(
    FallbackTemplate template,
    List<String> keywords,
    Map<String, dynamic>? context,
  ) {
    // Generate basic response based on template
    final matches = <OfflineDuaMatch>[];

    // Create main response
    matches.add(
      OfflineDuaMatch(
        duaId: 'fallback_${template.id}',
        text: template.template,
        translation: template.template, // Same as text for fallback
        transliteration: '', // No transliteration for fallback
        category: template.category,
        similarityScore: 0.3, // Low similarity for fallback
        matchedKeywords: keywords.take(3).toList(),
        matchReason: 'Matched fallback template for ${template.category}',
        metadata: {'template_id': template.id, 'is_fallback': true, 'template_priority': template.priority},
      ),
    );

    // Add variations if available
    if (template.variations.isNotEmpty) {
      int variationCount = 0;
      for (final entry in template.variations.entries) {
        if (variationCount >= 2) break; // Limit variations

        matches.add(
          OfflineDuaMatch(
            duaId: 'fallback_${template.id}_var_$variationCount',
            text: entry.value as String,
            translation: entry.value as String,
            transliteration: '',
            category: template.category,
            similarityScore: 0.25,
            matchedKeywords: keywords.take(2).toList(),
            matchReason: 'Template variation: ${entry.key}',
            metadata: {
              'template_id': template.id,
              'is_fallback': true,
              'is_variation': true,
              'variation_key': entry.key,
            },
          ),
        );
        variationCount++;
      }
    }

    return matches;
  }

  OfflineSearchResult _createGenericFallback(String query, String language) {
    final isArabic = language == 'ar';

    final genericText =
        isArabic
            ? 'عذراً، لم أتمكن من العثور على دعاء محدد لطلبك. يمكنك محاولة البحث بكلمات مختلفة.'
            : 'Sorry, I couldn\'t find a specific prayer for your request. You might try searching with different words.';

    final genericAdvice =
        isArabic
            ? 'في هذه الحالة، يمكنك الدعاء بما يفتح الله به عليك من القلب.'
            : 'In this case, you can make a heartfelt prayer in your own words.';

    return OfflineSearchResult(
      queryId: _generateQueryId(),
      matches: [
        OfflineDuaMatch(
          duaId: 'generic_fallback',
          text: genericText,
          translation: genericText,
          transliteration: '',
          category: 'general',
          similarityScore: 0.1,
          matchedKeywords: [],
          matchReason: 'Generic fallback response',
          metadata: {'is_generic_fallback': true, 'original_query': query},
        ),
        OfflineDuaMatch(
          duaId: 'generic_advice',
          text: genericAdvice,
          translation: genericAdvice,
          transliteration: '',
          category: 'advice',
          similarityScore: 0.1,
          matchedKeywords: [],
          matchReason: 'General advice',
          metadata: {'is_advice': true},
        ),
      ],
      confidence: 0.1,
      quality: SearchQuality.low,
      reasoning: 'No matching template found, using generic fallback',
      timestamp: DateTime.now(),
      metadata: {'is_generic_fallback': true, 'query_language': language},
    );
  }

  String _generateQueryId() {
    return 'fallback_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().hashCode.abs()}';
  }
}
