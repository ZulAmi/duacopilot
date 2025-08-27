import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:duacopilot/core/logging/app_logger.dart';
import '../models/local_search_models.dart';

/// Service for managing fallback response templates stored in asset JSON files
class FallbackTemplateService {
  static FallbackTemplateService? _instance;
  static FallbackTemplateService get instance =>
      _instance ??= FallbackTemplateService._();

  FallbackTemplateService._();

  // Template storage
  final Map<String, List<ResponseTemplate>> _templates = {};
  final Map<String, List<String>> _commonQueries = {};
  bool _isInitialized = false;

  // Asset paths
  static const Map<String, String> _templateAssets = {
    'en': 'assets/offline_data/templates_en.json',
    'ar': 'assets/offline_data/templates_ar.json',
    'ur': 'assets/offline_data/templates_ur.json',
    'id': 'assets/offline_data/templates_id.json',
  };

  /// Initialize the template service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load templates for each language
      for (final entry in _templateAssets.entries) {
        await _loadTemplatesForLanguage(entry.key, entry.value);
      }

      _isInitialized = true;
      AppLogger.debug('Fallback template service initialized successfully');
    } catch (e) {
      AppLogger.debug('Error initializing fallback template service: $e');
      // Create default templates as fallback
      _createDefaultTemplates();
      _isInitialized = true;
    }
  }

  /// Generate a fallback response for a query
  Future<LocalSearchResult?> generateFallbackResponse(
    String query,
    String language, {
    double confidenceBoost = 0.0,
  }) async {
    await _ensureInitialized();

    try {
      // Find the best matching template
      final template = _findBestTemplate(query, language);
      if (template == null) return null;

      // Generate response from template
      final response = _generateResponseFromTemplate(template, query, language);

      // Calculate confidence based on match quality
      final confidence = _calculateConfidence(query, template, confidenceBoost);

      // Create quality indicators for offline response
      final quality = ResponseQuality.offline(
        accuracy: confidence,
        completeness: template.completeness,
        relevance: template.relevance,
      );

      return LocalSearchResult(
        id: _generateResponseId(),
        query: query,
        response: response,
        confidence: confidence,
        source: 'fallback_template',
        isOffline: true,
        metadata: {
          'template_id': template.id,
          'template_category': template.category,
          'language': language,
          'generation_method': 'template_based',
          'template_confidence': template.confidence,
        },
        relatedQueries: template.relatedQueries,
        timestamp: DateTime.now(),
        language: language,
        quality: quality,
      );
    } catch (e) {
      AppLogger.debug('Error generating fallback response: $e');
      return null;
    }
  }

  /// Get templates by category
  List<ResponseTemplate> getTemplatesByCategory(
    String category,
    String language,
  ) {
    final languageTemplates = _templates[language] ?? [];
    return languageTemplates.where((t) => t.category == category).toList();
  }

  /// Get most relevant templates for a query
  List<ResponseTemplate> getMostRelevantTemplates(
    String query,
    String language, {
    int limit = 5,
  }) {
    final templates = _templates[language] ?? [];
    final scored = <_ScoredTemplate>[];

    for (final template in templates) {
      final score = _calculateTemplateScore(query, template);
      if (score > 0.1) {
        scored.add(_ScoredTemplate(template, score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(limit).map((st) => st.template).toList();
  }

  /// Get common queries for a language
  List<String> getCommonQueries(String language, {int limit = 20}) {
    final queries = _commonQueries[language] ?? [];
    return queries.take(limit).toList();
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get template statistics
  Map<String, dynamic> getTemplateStats() {
    final stats = <String, dynamic>{};

    for (final entry in _templates.entries) {
      final language = entry.key;
      final templates = entry.value;

      final categoryCount = <String, int>{};
      for (final template in templates) {
        categoryCount[template.category] =
            (categoryCount[template.category] ?? 0) + 1;
      }

      stats[language] = {
        'total_templates': templates.length,
        'categories': categoryCount,
        'common_queries': _commonQueries[language]?.length ?? 0,
      };
    }

    return stats;
  }

  // Private methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _loadTemplatesForLanguage(
    String language,
    String assetPath,
  ) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Parse templates
      final templatesJson = data['templates'] as List;
      final templates = templatesJson
          .map(
            (json) => ResponseTemplate.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      _templates[language] = templates;

      // Parse common queries
      final queriesJson = data['common_queries'] as List?;
      if (queriesJson != null) {
        _commonQueries[language] = queriesJson.cast<String>();
      }

      AppLogger.debug('Loaded ${templates.length} templates for $language');
    } catch (e) {
      AppLogger.debug('Could not load templates for $language: $e');
      _createDefaultTemplatesForLanguage(language);
    }
  }

  ResponseTemplate? _findBestTemplate(String query, String language) {
    final templates = _templates[language] ?? [];
    if (templates.isEmpty) return null;

    ResponseTemplate? bestTemplate;
    double bestScore = 0.0;

    for (final template in templates) {
      final score = _calculateTemplateScore(query, template);
      if (score > bestScore) {
        bestScore = score;
        bestTemplate = template;
      }
    }

    return bestScore > 0.2 ? bestTemplate : null;
  }

  double _calculateTemplateScore(String query, ResponseTemplate template) {
    final queryLower = query.toLowerCase();
    double score = 0.0;

    // Check keywords match
    for (final keyword in template.keywords) {
      if (queryLower.contains(keyword.toLowerCase())) {
        score += 0.3;
      }
    }

    // Check pattern match
    for (final pattern in template.patterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(query)) {
        score += 0.4;
      }
    }

    // Check semantic similarity with examples
    for (final example in template.examples) {
      final similarity = _calculateStringSimilarity(
        queryLower,
        example.toLowerCase(),
      );
      score += similarity * 0.2;
    }

    // Boost popular templates
    score *= (1.0 + template.popularity * 0.1);

    return score.clamp(0.0, 1.0);
  }

  double _calculateStringSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;

    final words1 = s1.split(' ').toSet();
    final words2 = s2.split(' ').toSet();

    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;

    return union > 0 ? intersection / union : 0.0;
  }

  String _generateResponseFromTemplate(
    ResponseTemplate template,
    String query,
    String language,
  ) {
    var response = template.responseTemplate;

    // Replace placeholders
    final placeholders = _extractPlaceholders(query);
    for (final entry in placeholders.entries) {
      response = response.replaceAll('{{${entry.key}}}', entry.value);
    }

    // Replace dynamic content
    response = _replaceDynamicContent(response, language);

    return response;
  }

  Map<String, String> _extractPlaceholders(String query) {
    final placeholders = <String, String>{};

    // Extract time-based placeholders
    final timeRegex = RegExp(
      r'\b(morning|afternoon|evening|night|dawn|sunset)\b',
      caseSensitive: false,
    );
    final timeMatch = timeRegex.firstMatch(query);
    if (timeMatch != null) {
      placeholders['time'] = timeMatch.group(1)!;
    }

    // Extract action-based placeholders
    final actionRegex = RegExp(
      r'\b(prayer|sleep|work|travel|study|eat)\b',
      caseSensitive: false,
    );
    final actionMatch = actionRegex.firstMatch(query);
    if (actionMatch != null) {
      placeholders['action'] = actionMatch.group(1)!;
    }

    // Default placeholders
    placeholders['time'] ??= 'any time';
    placeholders['action'] ??= 'daily activities';

    return placeholders;
  }

  String _replaceDynamicContent(String response, String language) {
    final now = DateTime.now();

    // Replace date/time placeholders
    response = response.replaceAll('{{date}}', _formatDate(now, language));
    response = response.replaceAll('{{time}}', _formatTime(now, language));

    // Replace Islamic calendar info (simplified)
    response = response.replaceAll(
      '{{islamic_date}}',
      _formatIslamicDate(now, language),
    );

    return response;
  }

  String _formatDate(DateTime date, String language) {
    switch (language) {
      case 'ar':
        return '${date.day}/${date.month}/${date.year}';
      case 'ur':
        return '${date.day}/${date.month}/${date.year}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatTime(DateTime time, String language) {
    final hour = time.hour;
    final minute = time.minute;

    switch (language) {
      case 'ar':
        return '$hour:${minute.toString().padLeft(2, '0')}';
      case 'ur':
        return '$hour:${minute.toString().padLeft(2, '0')}';
      default:
        final period = hour >= 12 ? 'PM' : 'AM';
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    }
  }

  String _formatIslamicDate(DateTime date, String language) {
    // Simplified Islamic date calculation (approximate)
    // In a real implementation, you'd use a proper Islamic calendar library
    final islamicYear = ((date.year - 622) * 1.030684).round() + 1;

    switch (language) {
      case 'ar':
        return '$islamicYear Ù‡Ø¬Ø±ÙŠ';
      case 'ur':
        return '$islamicYear ÛØ¬Ø±ÛŒ';
      default:
        return '$islamicYear AH';
    }
  }

  double _calculateConfidence(
    String query,
    ResponseTemplate template,
    double boost,
  ) {
    final baseConfidence = template.confidence;
    final matchScore = _calculateTemplateScore(query, template);

    return (baseConfidence * 0.6 + matchScore * 0.4 + boost).clamp(0.0, 1.0);
  }

  String _generateResponseId() {
    return 'fallback_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  void _createDefaultTemplates() {
    for (final language in ['en', 'ar', 'ur', 'id']) {
      _createDefaultTemplatesForLanguage(language);
    }
  }

  void _createDefaultTemplatesForLanguage(String language) {
    final templates = <ResponseTemplate>[];
    final commonQueries = <String>[];

    switch (language) {
      case 'ar':
        templates.addAll(_createArabicTemplates());
        commonQueries.addAll(_createArabicCommonQueries());
        break;
      case 'ur':
        templates.addAll(_createUrduTemplates());
        commonQueries.addAll(_createUrduCommonQueries());
        break;
      case 'id':
        templates.addAll(_createIndonesianTemplates());
        commonQueries.addAll(_createIndonesianCommonQueries());
        break;
      default:
        templates.addAll(_createEnglishTemplates());
        commonQueries.addAll(_createEnglishCommonQueries());
    }

    _templates[language] = templates;
    _commonQueries[language] = commonQueries;
  }

  List<ResponseTemplate> _createEnglishTemplates() {
    return [
      ResponseTemplate(
        id: 'general_dua_en',
        category: 'general',
        confidence: 0.7,
        completeness: 0.8,
        relevance: 0.9,
        responseTemplate:
            'Here is a general dua for {{action}}: "Bismillah, Rabbi zidni ilman" (In the name of Allah, my Lord, increase me in knowledge). This dua can be recited at {{time}}.',
        keywords: ['dua', 'prayer', 'general', 'help'],
        patterns: [r'dua for.*', r'prayer for.*', r'help with.*'],
        examples: [
          'dua for success',
          'prayer for guidance',
          'help with studies',
        ],
        relatedQueries: ['morning dua', 'evening dua', 'travel dua'],
        popularity: 0.8,
      ),
      ResponseTemplate(
        id: 'morning_dua_en',
        category: 'time_based',
        confidence: 0.9,
        completeness: 0.9,
        relevance: 0.95,
        responseTemplate:
            'Morning dua: "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilayk an-nushur" (O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection).',
        keywords: ['morning', 'dawn', 'sunrise', 'start', 'day'],
        patterns: [r'morning.*dua', r'dawn.*prayer', r'start.*day'],
        examples: ['morning dua', 'dawn prayer', 'start of day dua'],
        relatedQueries: ['evening dua', 'daily prayers', 'dhikr'],
        popularity: 0.9,
      ),
    ];
  }

  List<ResponseTemplate> _createArabicTemplates() {
    return [
      ResponseTemplate(
        id: 'general_dua_ar',
        category: 'general',
        confidence: 0.7,
        completeness: 0.8,
        relevance: 0.9,
        responseTemplate:
            'Ø¯Ø¹Ø§Ø¡ Ø¹Ø§Ù… Ù„Ù€ {{action}}: "Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ØŒ Ø±Ø¨ Ø²Ø¯Ù†ÙŠ Ø¹Ù„Ù…Ø§Ù‹". ÙŠÙ…ÙƒÙ† Ù‚Ø±Ø§Ø¡Ø© Ù‡Ø°Ø§ Ø§Ù„Ø¯Ø¹Ø§Ø¡ ÙÙŠ {{time}}.',
        keywords: ['Ø¯Ø¹Ø§Ø¡', 'ØµÙ„Ø§Ø©', 'Ø¹Ø§Ù…', 'Ù…Ø³Ø§Ø¹Ø¯Ø©'],
        patterns: [r'Ø¯Ø¹Ø§Ø¡.*', r'ØµÙ„Ø§Ø©.*', r'Ù…Ø³Ø§Ø¹Ø¯Ø©.*'],
        examples: [
          'Ø¯Ø¹Ø§Ø¡ Ù„Ù„Ù†Ø¬Ø§Ø­',
          'ØµÙ„Ø§Ø© Ù„Ù„Ù‡Ø¯Ø§ÙŠØ©',
          'Ù…Ø³Ø§Ø¹Ø¯Ø© ÙÙŠ Ø§Ù„Ø¯Ø±Ø§Ø³Ø©'
        ],
        relatedQueries: [
          'Ø¯Ø¹Ø§Ø¡ Ø§Ù„ØµØ¨Ø§Ø­',
          'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ù…Ø³Ø§Ø¡',
          'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ø³ÙØ±'
        ],
        popularity: 0.8,
      ),
    ];
  }

  List<ResponseTemplate> _createUrduTemplates() {
    return [
      ResponseTemplate(
        id: 'general_dua_ur',
        category: 'general',
        confidence: 0.7,
        completeness: 0.8,
        relevance: 0.9,
        responseTemplate:
            '{{action}} Ú©Û’ Ù„ÛŒÛ’ Ø¹Ø§Ù… Ø¯Ø¹Ø§: "Ø¨Ø³Ù… Ø§Ù„Ù„ÛØŒ Ø±Ø¨ Ø²Ø¯Ù†ÛŒ Ø¹Ù„Ù…Ø§Ù‹"Û” ÛŒÛ Ø¯Ø¹Ø§ {{time}} Ù…ÛŒÚº Ù¾Ú‘Ú¾ÛŒ Ø¬Ø§ Ø³Ú©ØªÛŒ ÛÛ’Û”',
        keywords: ['Ø¯Ø¹Ø§', 'Ù†Ù…Ø§Ø²', 'Ø¹Ø§Ù…', 'Ù…Ø¯Ø¯'],
        patterns: [r'Ø¯Ø¹Ø§.*', r'Ù†Ù…Ø§Ø².*', r'Ù…Ø¯Ø¯.*'],
        examples: [
          'Ú©Ø§Ù…ÛŒØ§Ø¨ÛŒ Ú©ÛŒ Ø¯Ø¹Ø§',
          'ÛØ¯Ø§ÛŒØª Ú©ÛŒ Ù†Ù…Ø§Ø²',
          'Ù¾Ú‘Ú¾Ø§Ø¦ÛŒ Ù…ÛŒÚº Ù…Ø¯Ø¯'
        ],
        relatedQueries: [
          'ØµØ¨Ø­ Ú©ÛŒ Ø¯Ø¹Ø§',
          'Ø´Ø§Ù… Ú©ÛŒ Ø¯Ø¹Ø§',
          'Ø³ÙØ± Ú©ÛŒ Ø¯Ø¹Ø§'
        ],
        popularity: 0.8,
      ),
    ];
  }

  List<ResponseTemplate> _createIndonesianTemplates() {
    return [
      ResponseTemplate(
        id: 'general_dua_id',
        category: 'general',
        confidence: 0.7,
        completeness: 0.8,
        relevance: 0.9,
        responseTemplate:
            'Doa umum untuk {{action}}: "Bismillah, Rabbi zidni ilman" (Dengan nama Allah, Tuhanku, tambahkanlah ilmu kepadaku). Doa ini dapat dibaca pada {{time}}.',
        keywords: ['doa', 'shalat', 'umum', 'bantuan'],
        patterns: [r'doa.*', r'shalat.*', r'bantuan.*'],
        examples: ['doa sukses', 'shalat petunjuk', 'bantuan belajar'],
        relatedQueries: ['doa pagi', 'doa sore', 'doa perjalanan'],
        popularity: 0.8,
      ),
    ];
  }

  List<String> _createEnglishCommonQueries() {
    return [
      'morning dua',
      'evening dua',
      'travel dua',
      'dua for success',
      'dua before eating',
      'dua after eating',
      'dua for health',
      'dua for protection',
      'dua for forgiveness',
      'dua for guidance',
    ];
  }

  List<String> _createArabicCommonQueries() {
    return [
      'Ø¯Ø¹Ø§Ø¡ Ø§Ù„ØµØ¨Ø§Ø­',
      'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ù…Ø³Ø§Ø¡',
      'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ø³ÙØ±',
      'Ø¯Ø¹Ø§Ø¡ Ù„Ù„Ù†Ø¬Ø§Ø­',
      'Ø¯Ø¹Ø§Ø¡ Ù‚Ø¨Ù„ Ø§Ù„Ø·Ø¹Ø§Ù…',
      'Ø¯Ø¹Ø§Ø¡ Ø¨Ø¹Ø¯ Ø§Ù„Ø·Ø¹Ø§Ù…',
      'Ø¯Ø¹Ø§Ø¡ Ù„Ù„ØµØ­Ø©',
      'Ø¯Ø¹Ø§Ø¡ Ù„Ù„Ø­Ù…Ø§ÙŠØ©',
      'Ø¯Ø¹Ø§Ø¡ Ù„Ù„Ù…ØºÙØ±Ø©',
      'Ø¯Ø¹Ø§Ø¡ Ù„Ù„Ù‡Ø¯Ø§ÙŠØ©',
    ];
  }

  List<String> _createUrduCommonQueries() {
    return [
      'ØµØ¨Ø­ Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ø´Ø§Ù… Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ø³ÙØ± Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ú©Ø§Ù…ÛŒØ§Ø¨ÛŒ Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ú©Ú¾Ø§Ù†Û’ Ø³Û’ Ù¾ÛÙ„Û’ Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ú©Ú¾Ø§Ù†Û’ Ú©Û’ Ø¨Ø¹Ø¯ Ú©ÛŒ Ø¯Ø¹Ø§',
      'ØµØ­Øª Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ø­ÙØ§Ø¸Øª Ú©ÛŒ Ø¯Ø¹Ø§',
      'Ù…Ø¹Ø§ÙÛŒ Ú©ÛŒ Ø¯Ø¹Ø§',
      'ÛØ¯Ø§ÛŒØª Ú©ÛŒ Ø¯Ø¹Ø§',
    ];
  }

  List<String> _createIndonesianCommonQueries() {
    return [
      'doa pagi',
      'doa sore',
      'doa perjalanan',
      'doa sukses',
      'doa sebelum makan',
      'doa sesudah makan',
      'doa kesehatan',
      'doa perlindungan',
      'doa ampunan',
      'doa petunjuk',
    ];
  }
}

/// Response template model
class ResponseTemplate {
  final String id;
  final String category;
  final double confidence;
  final double completeness;
  final double relevance;
  final String responseTemplate;
  final List<String> keywords;
  final List<String> patterns;
  final List<String> examples;
  final List<String> relatedQueries;
  final double popularity;

  const ResponseTemplate({
    required this.id,
    required this.category,
    required this.confidence,
    required this.completeness,
    required this.relevance,
    required this.responseTemplate,
    required this.keywords,
    required this.patterns,
    required this.examples,
    required this.relatedQueries,
    this.popularity = 0.0,
  });

  factory ResponseTemplate.fromJson(Map<String, dynamic> json) {
    return ResponseTemplate(
      id: json['id'] as String,
      category: json['category'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      completeness: (json['completeness'] as num).toDouble(),
      relevance: (json['relevance'] as num).toDouble(),
      responseTemplate: json['response_template'] as String,
      keywords: (json['keywords'] as List).cast<String>(),
      patterns: (json['patterns'] as List).cast<String>(),
      examples: (json['examples'] as List).cast<String>(),
      relatedQueries: (json['related_queries'] as List).cast<String>(),
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'confidence': confidence,
      'completeness': completeness,
      'relevance': relevance,
      'response_template': responseTemplate,
      'keywords': keywords,
      'patterns': patterns,
      'examples': examples,
      'related_queries': relatedQueries,
      'popularity': popularity,
    };
  }
}

/// Internal class for scored templates
class _ScoredTemplate {
  final ResponseTemplate template;
  final double score;

  _ScoredTemplate(this.template, this.score);
}
