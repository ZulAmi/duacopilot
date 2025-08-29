import 'package:duacopilot/core/logging/app_logger.dart';

import '../../config/rag_config.dart';
import '../models/dua_recommendation.dart';
import '../models/dua_response.dart';
import '../models/query_history.dart';
import 'hadith_vector_index.dart';
import 'quran_api_service.dart';
import 'quran_vector_index.dart';
import 'rag_cache_service.dart';

/// Comprehensive RAG service that integrates multiple Islamic knowledge sources
///
/// This service provides intelligent Islamic content recommendations by:
/// - Using local vector database for fast semantic search (50-200ms)
/// - Searching comprehensive Quran and Hadith APIs as fallback
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

  IslamicRagService({
    QuranApiService? quranApi,
    RagCacheService? cacheService,
  })  : _quranApi = quranApi ?? QuranApiService(),
        _cacheService = cacheService ?? RagCacheService();

  bool _hadithInitialized = false;
  Future<void> _ensureHadithIndex() async {
    if (_hadithInitialized) return;
    await HadithVectorIndex.instance.initialize();
    _hadithInitialized = true;
  }

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

      // Hadith semantic search (local) for enrichment
      await _ensureHadithIndex();
      var hadithMatches = await HadithVectorIndex.instance.search(query: query, limit: 8);

      // Filter hadith by minimum confidence threshold (30%)
      hadithMatches = hadithMatches.where((h) => h.score >= 0.30).toList();

      // Limit to top 3 most relevant
      hadithMatches = hadithMatches.take(3).toList(); // Generate comprehensive response content
      final responseContent = _buildResponseContent(searchResults, query, hadithMatches: hadithMatches);

      // Generate sources
      final sources = _buildSources(searchResults, hadithMatches: hadithMatches);

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

      for (int i = 0; i < searchResults.length && recommendations.length < limit; i++) {
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
    final stopwatch = Stopwatch()..start();
    AppLogger.debug('🔍 Starting search for: "$query"');

    // FAST PATH: Local vector database (50-200ms retrieval)
    if (RagConfig.useLocalVectorDB) {
      AppLogger.debug('🚀 Attempting local vector search...');
      final vectorIndex = QuranVectorIndex.instance;

      if (vectorIndex.isReady) {
        AppLogger.debug('✅ Vector index is ready, searching...');
        try {
          final vectorResults = await vectorIndex.search(
            query: query,
            limit: maxSearchResults,
            minSimilarity: RagConfig.similarityThreshold,
          );

          if (vectorResults.isNotEmpty) {
            stopwatch.stop();
            AppLogger.debug(
                '🎯 Fast vector retrieval: ${vectorResults.length} results in ${stopwatch.elapsedMilliseconds}ms');
            return vectorResults;
          } else {
            AppLogger.debug('⚠️ Vector search returned no results above threshold ${RagConfig.similarityThreshold}');
          }
        } catch (e, stackTrace) {
          AppLogger.debug('❌ Vector search failed: $e');
          AppLogger.debug('Stack trace: $stackTrace');
        }
      } else {
        AppLogger.debug('❌ Vector index is not ready (not initialized or failed to load data)');
      }
    } else {
      AppLogger.debug('⚠️ Local vector DB is disabled in config');
    }

    // FALLBACK PATH: API-based search (slower but comprehensive)
    AppLogger.debug('🌐 Falling back to API search...');
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
    String query, {
    List<HadithSearchMatch>? hadithMatches,
  }) {
    if (searchResults.isEmpty) {
      return _buildEmptyStateResponse(query);
    }

    final buffer = StringBuffer();
    final queryType = _classifyQuery(query);

    // Opening
    buffer.writeln(_buildCompassionateOpening(query, queryType));
    buffer.writeln();

    // Main guidance section
    buffer.writeln(_buildMainGuidanceSection(searchResults, query, queryType));
    buffer.writeln();

    // Practical guidance
    buffer.writeln(_buildPracticalGuidanceSection(query, queryType));
    buffer.writeln();

    // Related aspects
    buffer.writeln(_buildRelatedAspectsSection(searchResults, query));
    buffer.writeln();

    // Spiritual conclusion
    buffer.writeln(_buildSpiritualConclusionSection(query, queryType));
    buffer.writeln();

    // Hadith Section (if available)
    if ((hadithMatches ?? []).isNotEmpty) {
      buffer.writeln('## 📚 Authentic Hadith References');
      buffer.writeln('*Supporting traditions from the Prophet Muhammad ﷺ*\n');

      int hadithIdx = 1;
      for (final h in hadithMatches!.take(3)) {
        final confidencePercent = (h.score * 100).round();
        final hadithRef = h.hadithNumber.isEmpty ? h.id : h.hadithNumber;

        buffer.writeln('**[H$hadithIdx] ${h.collection.toUpperCase()} $hadithRef** *($confidencePercent% relevance)*');

        // Arabic text (if available)
        if (h.arabicText.trim().isNotEmpty) {
          buffer.writeln('> **Arabic:** ${h.arabicText}');
        }

        // English translation
        buffer.writeln('> **Translation:** ${h.englishText}');

        // Narrator chain (if available)
        if (h.narrator.trim().isNotEmpty) {
          buffer.writeln('> **Narrator:** ${h.narrator}');
        }

        buffer.writeln(); // Space between hadiths
        hadithIdx++;
      }
    }

    // Citations
    buffer.writeln(_buildComprehensiveCitationsSection(searchResults));

    return buffer.toString();
  }

  // ===== Premium Response Builder Helpers =====

  String _buildEmptyStateResponse(String query) =>
      'Assalamu alaikum wa rahmatullahi wa barakatuh. While I did not find direct verses for "$query", Islamic guidance still applies:\n\n'
      '1. Turn to Allah in sincere dua.\n'
      '2. Consult authentic Quran and Sahih Hadith.\n'
      '3. Seek qualified scholarly advice for rulings.\n'
      '4. Maintain patience & tawakkul (trust in Allah).\n\n'
      '"And whoever relies upon Allah – then He is sufficient for him." (Quran 65:3)';

  String _buildCompassionateOpening(String query, String type) {
    final lower = query.toLowerCase();
    if (lower.contains('sick') || lower.contains('ill')) {
      return 'May Allah grant you a swift and complete recovery. Your concern about "$query" is understood and Islam offers profound guidance on illness and healing.';
    }
    switch (type) {
      case 'prayer':
        return 'May Allah accept your worship. Let\'s explore essential guidance related to your query about "$query".';
      case 'dua':
        return 'Your desire regarding "$query" is a sign of iman. Here is comprehensive guidance with authentic sources.';
      case 'guidance':
        return 'Seeking guidance about "$query" is itself an act of faith. Let\'s ground the answer firmly in Quran and authentic tradition.';
      default:
        return 'Assalamu alaikum wa rahmatullahi wa barakatuh. Let\'s examine "$query" through authentic Quranic principles.';
    }
  }

  String _buildMainGuidanceSection(
    List<QuranSearchMatch> results,
    String query,
    String type,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('## Core Quranic Foundations');
    if (results.isEmpty) return buffer.toString();
    for (int i = 0; i < results.length && i < 3; i++) {
      final r = results[i];
      final arabic = _extractArabicText(r);
      buffer.writeln('\n[${i + 1}] ${r.surah.englishName} ${r.numberInSurah}:');
      if (arabic.isNotEmpty) buffer.writeln('Arabic: $arabic');
      buffer.writeln('English: "${r.text}"');
    }
    if (results.length > 3) {
      buffer.writeln('\n…and ${results.length - 3} additional relevant verses identified.');
    }
    return buffer.toString();
  }

  String _buildPracticalGuidanceSection(String query, String type) {
    final steps = _generatePracticalSteps(query, type);
    final buffer = StringBuffer('## 🌟 Practical Islamic Guidance\n*Actionable steps rooted in Quran and Sunnah*\n\n');

    for (int i = 0; i < steps.length; i++) {
      buffer.writeln('${i + 1}. **${steps[i]}**');
    }

    final dua = _getRelevantDua(type);
    if (dua.isNotEmpty) {
      buffer.writeln('\n### 🤲 Recommended Dua');

      if (dua['arabic']?.toString().trim().isNotEmpty == true) {
        buffer.writeln('> **Arabic:** ${dua['arabic']}');
      }

      if (dua['transliteration']?.toString().trim().isNotEmpty == true) {
        buffer.writeln('> **Transliteration:** *${dua['transliteration']}*');
      }

      if (dua['translation']?.toString().trim().isNotEmpty == true) {
        buffer.writeln('> **Translation:** "${dua['translation']}"');
      }

      if (dua['reference']?.toString().trim().isNotEmpty == true) {
        buffer.writeln('> **Source:** ${dua['reference']}');
      }

      buffer.writeln();
    }

    return buffer.toString();
  }

  String _buildRelatedAspectsSection(
    List<QuranSearchMatch> results,
    String query,
  ) {
    final aspects = _generateRelatedAspects(query, results);
    if (aspects.isEmpty) return '';
    final buffer = StringBuffer('## Related Islamic Themes\n');
    for (final a in aspects) {
      buffer
        ..writeln('\n### ${a['title']}')
        ..writeln(a['content']);
    }
    return buffer.toString();
  }

  String _buildSpiritualConclusionSection(String query, String type) {
    final conclusions = <String, String>{
      'illness':
          'May Allah grant you complete shifaa (healing). Illness expiates sins and elevates ranks when met with patience.',
      'prayer': 'Consistency, khushu\' (presence of heart), and sincerity transform prayer into light and protection.',
      'dua': 'Never underestimate the power of sincere supplication—its acceptance is certain in one of three ways.',
      'guidance': 'Remain steadfast; every sincere search for guidance is rewarded and leads closer to Allah.',
      'general':
          'Anchor every concern in remembrance of Allah, reliance upon Him, and adherence to authentic guidance.',
    };
    return '## Final Reflection\n${conclusions[type] ?? conclusions['general']!}\n';
  }

  String _buildComprehensiveCitationsSection(List<QuranSearchMatch> results) {
    if (results.isEmpty) return '';
    final buffer = StringBuffer('## 📖 Quranic Sources & References\n*Direct citations from the Holy Quran*\n\n');

    for (int i = 0; i < results.length && i < 5; i++) {
      final r = results[i];
      final arabic = _extractArabicText(r);
      final confidencePercent = (_calculateRelevance(r, '') * 100).round();

      buffer
          .writeln('**[Q${i + 1}] Quran ${r.surah.englishName} ${r.numberInSurah}** *($confidencePercent% relevance)*');
      buffer.writeln('> "${r.text}"');
      if (arabic.isNotEmpty) {
        buffer.writeln('> *Arabic:* $arabic');
      } else {
        buffer.writeln('> *Arabic:* ${r.surah.name} - آية ${r.numberInSurah}');
      }
      buffer.writeln();
    }

    buffer.writeln('---');
    buffer.writeln('*May Allah ﷻ grant us understanding and guide us on the straight path. Ameen.*');

    return buffer.toString();
  }

  // ===== Support logic for premium formatting =====

  String _extractArabicText(QuranSearchMatch match) {
    // If edition already Arabic, return; else skip (could extend to fetch Arabic lazily)
    if (match.edition.language.toLowerCase().startsWith('ar')) {
      return match.text;
    }
    return '';
  }

  List<String> _generatePracticalSteps(String query, String type) {
    switch (type) {
      case 'prayer':
        return [
          'Guard the five daily prayers at their earliest times',
          'Strive for khushu\' by reflecting on meanings',
          'Add voluntary sunnah and night prayers',
          'Maintain wudu and a clean environment',
          'Make dua in sujood and before tasleem',
        ];
      case 'dua':
        return [
          'Begin with praise of Allah and salawat upon the Prophet ﷺ',
          'Face the qiblah and raise your hands with humility',
          'Use Quranic and Prophetic duas first',
          'Persist daily with patience and certainty of response',
          'Avoid prohibited income & actions that block acceptance',
        ];
      case 'guidance':
        return [
          'Perform Salat al-Istikhara when deciding',
          'Consult knowledgeable, trustworthy Muslims',
          'Study relevant Quranic themes regularly',
          'Track habits & replace doubtful with beneficial acts',
          'Maintain daily dhikr and Quran recitation',
        ];
      default:
        final lower = query.toLowerCase();
        if (lower.contains('sick') || lower.contains('ill')) {
          return [
            'Seek qualified medical treatment promptly',
            'Recite Ruqyah verses (Al-Fatiha, Ayat al-Kursi, last 2 surahs)',
            'Maintain optimism & patience (sabr)',
            'Use permissible prophetic remedies (honey, black seed, zamzam)',
            'Increase dua especially before fajr and between adhan & iqamah',
          ];
        }
        return [
          'Clarify your intention (niyyah) and purify it for Allah',
          'Consult the Quran daily for thematic guidance',
          'Identify and remove harmful habits gradually',
          'Keep a gratitude & reflection journal',
          'Stay consistent with dhikr and salawat',
        ];
    }
  }

  Map<String, String> _getRelevantDua(String type) {
    switch (type) {
      case 'illness':
        return {
          'arabic': 'اللهم رب الناس أذهب البأس واشفِ أنت الشافي لا شفاء إلا شفاؤك شفاء لا يغادر سقما',
          'transliteration':
              'Allahumma rabban-naas adhhib al-ba\'sa, washfi anta ash-shaafi, la shifaa\' illa shifaa\'uk, shifaa\'an la yughaadiru saqaman.',
          'translation':
              'O Allah, Lord of mankind, remove the harm and heal, for You are the Healer; there is no healing except Your healing, a healing that leaves behind no ailment.',
          'reference': 'Sahih al-Bukhari 5743, Sahih Muslim 2191',
        };
      case 'prayer':
        return {
          'arabic': 'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِن ذُرِّيَّتِي',
          'transliteration': 'Rabbi ij\'alni muqeema as-salaati wa min dhurriyyatee',
          'translation': 'My Lord, make me one who establishes prayer, and [many] from my descendants.',
          'reference': 'Quran 14:40',
        };
      case 'dua':
        return {
          'arabic': 'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
          'transliteration': 'Rabbana taqabbal minna innaka anta as-samee\'u al-\'aleem',
          'translation': 'Our Lord, accept [this] from us. Indeed, You are the Hearing, the Knowing.',
          'reference': 'Quran 2:127',
        };
      case 'forgiveness':
        return {
          'arabic': 'رَبِّ اغْفِرْ لِي ذَنبِي وَخَطَئِي وَجَهْلِي',
          'transliteration': 'Rabbi ighfir li dhanbee wa khata\'ee wa jahlee',
          'translation': 'My Lord, forgive my sin and my error and my ignorance.',
          'reference': 'Sahih al-Bukhari 834',
        };
      case 'guidance':
        return {
          'arabic': 'اللهم اهدني فيمن هديت',
          'transliteration': 'Allahumma ihdinee feeman hadayt',
          'translation': 'O Allah, guide me among those You have guided.',
          'reference': 'Sunan at-Tirmidhi 464',
        };
      case 'protection':
        return {
          'arabic': 'أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِن شَرِّ مَا خَلَقَ',
          'transliteration': 'A\'oodhu bi kalimaati Allaahi at-taammaati min sharri maa khalaq',
          'translation': 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
          'reference': 'Sahih Muslim 2708',
        };
      default:
        // Smart dua selection based on query context
        if (type.contains('sick') || type.contains('ill') || type.contains('health')) {
          return _getRelevantDua('illness');
        } else if (type.contains('forgiv') || type.contains('sin') || type.contains('repent')) {
          return _getRelevantDua('forgiveness');
        } else if (type.contains('guid') || type.contains('path') || type.contains('direct')) {
          return _getRelevantDua('guidance');
        } else if (type.contains('protect') || type.contains('safe') || type.contains('harm')) {
          return _getRelevantDua('protection');
        }
        return {
          'arabic': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          'transliteration':
              'Rabbana aatina fi\'d-dunya hasanatan wa fi\'l-aakhirati hasanatan wa qina \'adhab an-naar',
          'translation':
              'Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire.',
          'reference': 'Quran 2:201',
        };
    }
  }

  List<Map<String, String>> _generateRelatedAspects(
    String query,
    List<QuranSearchMatch> results,
  ) {
    final list = <Map<String, String>>[];
    final lower = query.toLowerCase();
    if (lower.contains('sick') || lower.contains('ill')) {
      list.add({
        'title': 'Illness as Purification',
        'content':
            'Authentic narrations indicate that no fatigue, illness, anxiety, or grief afflicts a believer except that Allah expiates sins through it when borne with patience.',
      });
      list.add({
        'title': 'Balance Between Means & Reliance',
        'content':
            'Islam commands seeking treatment while placing absolute trust (tawakkul) in Allah as the true Healer.',
      });
    }
    if (results.length > 3) {
      list.add({
        'title': 'Additional Quranic Context',
        'content':
            'Further verses matched your query indicating a consistent Quranic theme; explore tafsir for deeper insight.',
      });
    }
    return list;
  }

  List<DuaSource> _buildSources(List<QuranSearchMatch> searchResults, {List<HadithSearchMatch>? hadithMatches}) {
    final sources = <DuaSource>[];

    // Add Quran sources with enhanced metadata
    for (int i = 0; i < searchResults.length; i++) {
      final match = searchResults[i];
      final confidenceScore = _calculateRelevance(match, '');

      sources.add(DuaSource(
        id: 'quran_${match.number}',
        title: '📖 Quran ${match.surah.englishName} ${match.numberInSurah}',
        content: match.text,
        relevanceScore: confidenceScore,
        reference: 'Q${i + 1}: ${match.surah.englishName} ${match.numberInSurah}',
        category: 'Quran',
        metadata: {
          'source_type': 'quran',
          'surah_number': match.surah.number,
          'verse_number': match.numberInSurah,
          'surah_name_arabic': match.surah.name,
          'edition': match.edition.identifier,
          'language': match.edition.language,
          'confidence_percent': (confidenceScore * 100).round(),
        },
      ));
    }

    // Add Hadith sources with enhanced metadata
    if (hadithMatches != null) {
      for (int i = 0; i < hadithMatches.length; i++) {
        final h = hadithMatches[i];
        final hadithRef = h.hadithNumber.isEmpty ? h.id : h.hadithNumber;
        final confidencePercent = (h.score * 100).round();

        sources.add(DuaSource(
          id: 'hadith_${h.id}',
          title: '📚 ${h.collection.toUpperCase()} $hadithRef',
          content: h.englishText,
          relevanceScore: h.score,
          reference: 'H${i + 1}: ${h.collection}:$hadithRef',
          category: 'Hadith',
          metadata: {
            'source_type': 'hadith',
            'collection': h.collection,
            'hadith_number': hadithRef,
            'language': h.language,
            'narrator': h.narrator,
            'arabic_text': h.arabicText,
            'confidence_percent': confidencePercent,
            'has_arabic': h.arabicText.trim().isNotEmpty,
          },
        ));
      }
    }

    // Sort by relevance score descending
    sources.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return sources;
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

    return (baseConfidence + (resultCount / maxSearchResults) * (maxConfidence - baseConfidence)).clamp(0.0, 1.0);
  }

  Map<String, dynamic> _buildMetadata(
    List<QuranSearchMatch> searchResults,
    String query,
  ) {
    return {
      'search_results_count': searchResults.length,
      'primary_surah': searchResults.isNotEmpty ? searchResults.first.surah.englishName : null,
      'query_type': _classifyQuery(query),
      'timestamp': DateTime.now().toIso8601String(),
      'api_version': 'alquran.cloud/v1',
      'sources': searchResults
          .map(
            (match) => {
              'id': match.number.toString(),
              'title': 'Quran ${match.surah.englishName} ${match.numberInSurah}',
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
