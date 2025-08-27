import 'package:duacopilot/core/logging/app_logger.dart';

import '../models/dua_response.dart';
import '../models/dua_recommendation.dart';
import '../models/query_history.dart';
import 'quran_api_service.dart';
import 'rag_cache_service.dart';

/// Comprehensive RAG service that integrates Quran API with local caching
///
/// This service provides intelligent Islamic content recommendations by:
/// - Searching Quranic verses based on user queries
/// - Caching frequently accessed content locally
/// - Learning from user preferences and history
/// - Providing contextually relevant Islamic guidance
class IslamicRagService {
  final QuranApiService _quranApi;
  final RagCacheService _cacheService;

  /// Configuration for search and recommendations
  static const int maxSearchResults = 10;
  static const int maxRecommendations = 5;
  static const double similarityThreshold = 0.7;
  static const Duration cacheExpiry = Duration(days: 7);

  IslamicRagService({QuranApiService? quranApi, RagCacheService? cacheService})
      : _quranApi = quranApi ?? QuranApiService(),
        _cacheService = cacheService ?? RagCacheService();

  // ========== Core RAG Operations ==========

  /// Process user query and generate comprehensive Islamic guidance
  Future<DuaResponse> processQuery({
    required String query,
    String? userId,
    String language = 'en',
    bool includeAudio = true,
    List<String>? preferredEditions,
  }) async {
    try {
      final startTime = DateTime.now();

      // Check cache first for semantic matches
      final cachedResponse = await _cacheService.findSimilarQuery(query);
      if (cachedResponse != null) {
        return _convertQueryHistoryToResponse(cachedResponse, query);
      }

      // Search Quranic content
      final searchResults = await _searchQuranContent(
        query: query,
        language: language,
        preferredEditions: preferredEditions,
      );

      // Generate comprehensive response content
      final responseContent = _buildResponseContent(searchResults, query);

      // Generate sources
      final sources = _buildSources(searchResults);

      // Calculate confidence
      final confidence = _calculateConfidence(searchResults);

      // Calculate response time
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;

      // Build comprehensive response
      final response = DuaResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        query: query,
        response: responseContent,
        timestamp: DateTime.now(),
        responseTime: responseTime,
        confidence: confidence,
        sources: sources,
        sessionId: userId,
        metadata: _buildMetadata(searchResults, query),
      );

      // Cache the response for future semantic matching
      await _cacheService.cacheQueryResponse(
        query: query,
        response: responseContent,
        confidence: confidence,
        sessionId: userId,
        metadata: response.metadata,
      );

      return response;
    } catch (e) {
      throw IslamicRagException('Failed to process query: $e');
    }
  }

  /// Generate Quranic recommendations based on user query
  Future<List<DuaRecommendation>> generateRecommendations({
    required String query,
    String? userId,
    String language = 'en',
    int limit = 5,
  }) async {
    try {
      // Search for relevant verses
      final searchResults = await _searchQuranContent(
        query: query,
        language: language,
      );

      final recommendations = <DuaRecommendation>[];

      for (int i = 0;
          i < searchResults.length && recommendations.length < limit;
          i++) {
        final match = searchResults[i];

        // Get Arabic text
        final arabicText = await _getArabicText(match.number) ?? match.text;

        // Get transliteration
        final transliteration = await _getTransliteration(match.number) ?? '';

        final recommendation = DuaRecommendation(
          id: '${match.number}_rec_${DateTime.now().millisecondsSinceEpoch}',
          arabicText: arabicText,
          transliteration: transliteration,
          translation: match.text,
          confidence: _calculateRelevance(match, query),
          category: _getCategoryFromMatch(match),
          source: 'Quran',
          reference: '${match.surah.englishName} ${match.numberInSurah}',
          audioUrl: _quranApi.getAudioUrl(ayahNumber: match.number),
          tags: _extractTags(match, query),
          metadata: {
            'surah_number': match.surah.number,
            'verse_number': match.numberInSurah,
            'surah_name': match.surah.englishName,
            'revelation_type': match.surah.revelationType,
          },
        );

        recommendations.add(recommendation);
      }

      return recommendations;
    } catch (e) {
      throw IslamicRagException('Failed to generate recommendations: $e');
    }
  }

  // ========== Helper Methods ==========

  /// Convert cached QueryHistory to DuaResponse
  DuaResponse _convertQueryHistoryToResponse(
    QueryHistory queryHistory,
    String currentQuery,
  ) {
    // Extract sources from metadata if available
    final sources = <DuaSource>[];
    if (queryHistory.metadata?['sources'] != null) {
      final sourcesData = queryHistory.metadata!['sources'] as List;
      for (final sourceData in sourcesData) {
        sources.add(DuaSource.fromJson(sourceData));
      }
    }

    return DuaResponse(
      id: queryHistory.id,
      query: currentQuery,
      response: queryHistory.response,
      timestamp: queryHistory.timestamp,
      responseTime: queryHistory.responseTime,
      confidence: queryHistory.confidence ?? 0.8,
      sources: sources,
      sessionId: queryHistory.sessionId,
      metadata: queryHistory.metadata,
      isFromCache: true,
    );
  }

  /// Search for Quranic content based on user query
  Future<List<QuranSearchMatch>> _searchQuranContent({
    required String query,
    required String language,
    List<String>? preferredEditions,
  }) async {
    final editions = preferredEditions ?? _getDefaultEditions(language);
    final searchResults = <QuranSearchMatch>[];

    for (final edition in editions) {
      try {
        final result = await _quranApi.searchVerses(
          query: query,
          edition: edition,
        );

        // Add top results, avoiding duplicates
        final uniqueResults = result.matches
            .where(
              (match) => !searchResults.any(
                (existing) => existing.number == match.number,
              ),
            )
            .take(maxSearchResults ~/ editions.length);

        searchResults.addAll(uniqueResults);
      } catch (e) {
        // Continue with other editions if one fails
        AppLogger.debug('Search failed for edition $edition: $e');
      }
    }

    // Sort by relevance and limit results
    searchResults.sort(
      (a, b) => _calculateRelevance(
        b,
        query,
      ).compareTo(_calculateRelevance(a, query)),
    );

    return searchResults.take(maxSearchResults).toList();
  }

  String _buildResponseContent(
    List<QuranSearchMatch> searchResults,
    String query,
  ) {
    if (searchResults.isEmpty) {
      return 'I couldn\'t find specific Quranic verses directly related to "$query". However, I can still provide general Islamic guidance on this topic.';
    }

    final buffer = StringBuffer();
    buffer.writeln(
      'Based on your query about "$query", here are relevant verses from the Quran:\n',
    );

    for (int i = 0; i < searchResults.length && i < 3; i++) {
      final match = searchResults[i];
      buffer.writeln('${i + 1}. "${match.text}"');
      buffer.writeln(
        '   â€” Quran ${match.surah.englishName} ${match.numberInSurah}\n',
      );
    }

    if (searchResults.length > 3) {
      buffer.writeln('And ${searchResults.length - 3} more related verses...');
    }

    return buffer.toString();
  }

  List<DuaSource> _buildSources(List<QuranSearchMatch> searchResults) {
    return searchResults.map((match) {
      return DuaSource(
        id: match.number.toString(),
        title: 'Quran ${match.surah.englishName} ${match.numberInSurah}',
        content: match.text,
        relevanceScore: _calculateRelevance(match, ''),
        reference: '${match.surah.englishName} ${match.numberInSurah}',
        category: 'Quran',
        metadata: {
          'surah_number': match.surah.number,
          'verse_number': match.numberInSurah,
          'edition': match.edition.identifier,
          'language': match.edition.language,
        },
      );
    }).toList();
  }

  List<String> _getDefaultEditions(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return [
          QuranApiService.popularEditions['english_sahih']!,
          QuranApiService.popularEditions['english_pickthall']!,
        ];
      case 'ar':
        return [QuranApiService.popularEditions['arabic_uthmani']!];
      default:
        return [QuranApiService.popularEditions['english_sahih']!];
    }
  }

  double _calculateRelevance(QuranSearchMatch match, String query) {
    if (query.isEmpty) return 0.5;

    final queryWords = query.toLowerCase().split(' ');
    final matchText = match.text.toLowerCase();

    double score = 0.0;
    for (final word in queryWords) {
      if (matchText.contains(word)) {
        score += 1.0;
      }
    }

    return score / queryWords.length;
  }

  double _calculateConfidence(List<QuranSearchMatch> searchResults) {
    if (searchResults.isEmpty) return 0.0;

    // Base confidence on number and quality of results
    final resultCount = searchResults.length;
    final maxConfidence = 0.95;
    final baseConfidence = 0.3;

    return (baseConfidence +
            (resultCount / maxSearchResults) * (maxConfidence - baseConfidence))
        .clamp(0.0, 1.0);
  }

  Map<String, dynamic> _buildMetadata(
    List<QuranSearchMatch> searchResults,
    String query,
  ) {
    return {
      'search_results_count': searchResults.length,
      'primary_surah': searchResults.isNotEmpty
          ? searchResults.first.surah.englishName
          : null,
      'query_type': _classifyQuery(query),
      'timestamp': DateTime.now().toIso8601String(),
      'api_version': 'alquran.cloud/v1',
      'sources': searchResults
          .map(
            (match) => {
              'id': match.number.toString(),
              'title':
                  'Quran ${match.surah.englishName} ${match.numberInSurah}',
              'content': match.text,
              'relevanceScore': _calculateRelevance(match, query),
              'reference': '${match.surah.englishName} ${match.numberInSurah}',
              'category': 'Quran',
            },
          )
          .toList(),
    };
  }

  String _classifyQuery(String query) {
    final queryLower = query.toLowerCase();

    if (queryLower.contains(RegExp(r'\b(prayer|salah|namaz)\b'))) {
      return 'prayer';
    } else if (queryLower.contains(RegExp(r'\b(dua|supplication)\b'))) {
      return 'dua';
    } else if (queryLower.contains(RegExp(r'\b(guidance|help|advice)\b'))) {
      return 'guidance';
    } else if (queryLower.contains(RegExp(r'\b(story|prophet|history)\b'))) {
      return 'narrative';
    } else {
      return 'general';
    }
  }

  String? _getCategoryFromMatch(QuranSearchMatch match) {
    final text = match.text.toLowerCase();

    if (text.contains(RegExp(r'\b(prayer|pray|worship|salah)\b'))) {
      return 'prayer';
    } else if (text.contains(RegExp(r'\b(forgive|mercy|compassion)\b'))) {
      return 'forgiveness';
    } else if (text.contains(RegExp(r'\b(knowledge|learn|wisdom)\b'))) {
      return 'knowledge';
    } else if (text.contains(RegExp(r'\b(family|children|parent)\b'))) {
      return 'family';
    } else {
      return 'general';
    }
  }

  List<String> _extractTags(QuranSearchMatch match, String query) {
    final tags = <String>{};

    // Add surah name
    tags.add(match.surah.englishName.toLowerCase());

    // Add revelation type
    tags.add(match.surah.revelationType.toLowerCase());

    // Extract keywords from query
    final queryWords = query.toLowerCase().split(' ');
    tags.addAll(queryWords.where((word) => word.length > 3));

    // Add theme tags based on content
    final text = match.text.toLowerCase();
    final themes = [
      'prayer',
      'guidance',
      'patience',
      'forgiveness',
      'charity',
      'knowledge',
    ];
    for (final theme in themes) {
      if (text.contains(theme)) {
        tags.add(theme);
      }
    }

    return tags.toList();
  }

  Future<String?> _getArabicText(int verseNumber) async {
    try {
      final verses = await _quranApi.getVerseWithTranslations(
        verseNumber,
        editions: [QuranApiService.popularEditions['arabic_uthmani']!],
      );
      return verses.isNotEmpty ? verses.first.text : null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getTransliteration(int verseNumber) async {
    try {
      final verses = await _quranApi.getVerseWithTranslations(
        verseNumber,
        editions: [QuranApiService.popularEditions['transliteration']!],
      );
      return verses.isNotEmpty ? verses.first.text : null;
    } catch (e) {
      return null;
    }
  }

  // ========== Public Utility Methods ==========

  /// Get user's query history
  Future<List<QueryHistory>> getUserHistory(
    String userId, {
    int limit = 50,
  }) async {
    return await _cacheService.getQueryHistory(limit: limit);
  }

  /// Get popular recommendations based on cached queries
  Future<List<DuaRecommendation>> getPopularRecommendations({
    String language = 'en',
    String? category,
    int limit = 10,
  }) async {
    final popularQueries = [
      'guidance',
      'patience',
      'forgiveness',
      'gratitude',
      'protection',
      'prayer',
      'peace',
      'wisdom',
      'mercy',
      'righteousness',
    ];

    final recommendations = <DuaRecommendation>[];

    for (final query in popularQueries.take(limit)) {
      try {
        final recs = await generateRecommendations(
          query: query,
          language: language,
          limit: 1,
        );

        if (recs.isNotEmpty) {
          recommendations.add(recs.first);
        }
      } catch (e) {
        AppLogger.debug('Failed to get popular recommendation for $query: $e');
      }
    }

    return recommendations.take(limit).toList();
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _cacheService.clearAllCache();
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    return await _cacheService.getCacheStats();
  }

  void dispose() {
    _quranApi.dispose();
  }
}

/// IslamicRagException class implementation
class IslamicRagException implements Exception {
  final String message;

  IslamicRagException(this.message);

  @override
  String toString() => 'IslamicRagException: $message';
}
