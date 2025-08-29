import 'dart:convert';

import 'package:http/http.dart' as http;

/// Comprehensive Islamic Knowledge API Service
/// Uses quranapi.pages.dev and hadithapi.com for complete Islamic content
class ComprehensiveIslamicApiService {
  static const String _quranApiBase = 'https://quranapi.pages.dev/api';
  static const String _hadithApiBase = 'https://hadithapi.com/api';
  static const String _hadithApiKey = r'$2y$10$y8jjH1MflEEb3MBh98bsCeeroBw8b29ylK8iYj0ju95l3mhPdBFkG';

  final http.Client _client;

  ComprehensiveIslamicApiService({http.Client? client}) : _client = client ?? http.Client();

  // ========== Quran API Methods ==========

  /// Get all Quran chapters (Surahs) information
  Future<List<Map<String, dynamic>>> getSurahs() async {
    try {
      final response = await _client.get(Uri.parse('$_quranApiBase/surah.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch surahs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching surahs: $e');
    }
  }

  /// Get a specific Surah with all its verses
  Future<Map<String, dynamic>> getSurah(int surahNumber) async {
    try {
      final response = await _client.get(Uri.parse('$_quranApiBase/$surahNumber.json'));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch surah $surahNumber: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching surah $surahNumber: $e');
    }
  }

  /// Search Quran verses by text content
  Future<List<Map<String, dynamic>>> searchQuranVerses(String query) async {
    try {
      // Since the API doesn't have direct search, we'll implement basic text matching
      // by fetching commonly relevant surahs and searching their content
      final List<int> relevantSurahs = _getRelevantSurahsForQuery(query);
      List<Map<String, dynamic>> results = [];

      for (final surahNum in relevantSurahs.take(10)) {
        // Limit to first 10 for performance
        try {
          final surah = await getSurah(surahNum);
          final List<String> englishVerses = (surah['english'] as List? ?? []).cast<String>();
          final List<String> arabicVerses = (surah['arabic1'] as List? ?? []).cast<String>();

          for (int i = 0; i < englishVerses.length; i++) {
            final englishText = englishVerses[i].toLowerCase();
            if (englishText.contains(query.toLowerCase())) {
              results.add({
                'surah': surahNum,
                'verse': i + 1,
                'surahName': surah['surahName'],
                'surahNameArabic': surah['surahNameArabic'],
                'englishText': englishVerses[i],
                'arabicText': i < arabicVerses.length ? arabicVerses[i] : '',
                'revelationPlace': surah['revelationPlace'],
                'type': 'quran',
                'reference': '${surah['surahName']} ${i + 1}',
              });
            }
          }
        } catch (e) {
          // Skip this surah on error and continue
          continue;
        }
      }

      // Sort by relevance (could be improved with proper scoring)
      results.sort((a, b) =>
          _calculateRelevance(query, a['englishText']).compareTo(_calculateRelevance(query, b['englishText'])));

      return results.take(20).toList(); // Return top 20 results
    } catch (e) {
      throw Exception('Error searching Quran verses: $e');
    }
  }

  /// Get relevant surahs for a query (heuristic approach)
  List<int> _getRelevantSurahsForQuery(String query) {
    final queryLower = query.toLowerCase();
    Map<String, List<int>> topicToSurahs = {
      // Prayer and worship
      'prayer|pray|salah|worship|dua': [1, 2, 17, 23, 62], // Al-Fatiha, Al-Baqara, Al-Isra, Al-Mu'minun, Al-Jumu'a

      // Family and relationships
      'parent|mother|father|family|marry|spouse|child': [2, 4, 19, 31], // Al-Baqara, An-Nisa, Maryam, Luqman

      // Patience and trials
      'patience|trial|test|difficult|sick|illness': [2, 3, 18, 29], // Al-Baqara, Aal-i-Imran, Al-Kahf, Al-Ankabut

      // Guidance and knowledge
      'guidance|guide|knowledge|learn|wisdom': [1, 2, 18, 31, 96], // Al-Fatiha, Al-Baqara, Al-Kahf, Luqman, Al-Alaq

      // Forgiveness and mercy
      'forgive|mercy|compassion|raheem|rahman': [1, 2, 7, 39], // Al-Fatiha, Al-Baqara, Al-A'raf, Az-Zumar

      // Death and afterlife
      'death|die|afterlife|paradise|hell|grave': [
        2,
        23,
        50,
        67,
        102
      ], // Al-Baqara, Al-Mu'minun, Qaf, Al-Mulk, At-Takathur

      // Gratitude and praise
      'thank|grateful|praise|hamd': [1, 14, 31, 35], // Al-Fatiha, Ibrahim, Luqman, Fatir

      // Trust in Allah
      'trust|tawakkul|rely|depend': [3, 8, 9, 65], // Aal-i-Imran, Al-Anfal, At-Tawba, At-Talaq
    };

    List<int> relevantSurahs = [];

    for (final entry in topicToSurahs.entries) {
      final RegExp regex = RegExp(entry.key);
      if (regex.hasMatch(queryLower)) {
        relevantSurahs.addAll(entry.value);
      }
    }

    // If no specific topic found, search in most commonly referenced surahs
    if (relevantSurahs.isEmpty) {
      relevantSurahs = [1, 2, 3, 4, 18, 19, 36, 55, 67, 112]; // Popular surahs
    }

    return relevantSurahs.toSet().toList(); // Remove duplicates
  }

  /// Simple relevance scoring for search results
  int _calculateRelevance(String query, String text) {
    final queryWords = query.toLowerCase().split(' ');
    final textLower = text.toLowerCase();
    int score = 0;

    for (final word in queryWords) {
      if (word.length > 2) {
        // Skip very short words
        final regex = RegExp(r'\b' + RegExp.escape(word) + r'\b');
        score += regex.allMatches(textLower).length * 10; // Exact word matches

        if (textLower.contains(word)) {
          score += 5; // Partial matches
        }
      }
    }

    return score;
  }

  // ========== Hadith API Methods ==========

  /// Get all available Hadith books
  Future<List<Map<String, dynamic>>> getHadithBooks() async {
    try {
      final response = await _client.get(Uri.parse('$_hadithApiBase/books?apiKey=$_hadithApiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 200) {
          return (data['books'] as List).cast<Map<String, dynamic>>();
        } else {
          throw Exception('API error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to fetch hadith books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hadith books: $e');
    }
  }

  /// Get chapters from a specific Hadith book
  Future<List<Map<String, dynamic>>> getHadithChapters(String bookSlug) async {
    try {
      final response = await _client.get(Uri.parse('$_hadithApiBase/$bookSlug/chapters?apiKey=$_hadithApiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 200) {
          return (data['chapters'] as List).cast<Map<String, dynamic>>();
        } else {
          throw Exception('API error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to fetch chapters for $bookSlug: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chapters for $bookSlug: $e');
    }
  }

  /// Get hadiths from a specific chapter (Note: This endpoint seems to have issues in the API)
  Future<List<Map<String, dynamic>>> getHadithsFromChapter(String bookSlug, int chapterId) async {
    try {
      final response =
          await _client.get(Uri.parse('$_hadithApiBase/$bookSlug/chapters/$chapterId?apiKey=$_hadithApiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 200) {
          return (data['hadiths'] as List).cast<Map<String, dynamic>>();
        } else {
          throw Exception('API error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to fetch hadiths from chapter $chapterId: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hadiths from chapter $chapterId: $e');
    }
  }

  /// Search hadith by getting recent/popular hadiths (fallback method)
  Future<List<Map<String, dynamic>>> searchHadiths(String query) async {
    try {
      // Since individual hadith endpoints seem to have issues,
      // we'll return empty for now and rely on Quran search
      // This can be improved when the Hadith API endpoints are working properly
      return [];
    } catch (e) {
      throw Exception('Error searching hadiths: $e');
    }
  }

  // ========== Unified Search Method ==========

  /// Search both Quran and Hadith for relevant content
  Future<List<Map<String, dynamic>>> searchIslamicContent(String query) async {
    try {
      List<Map<String, dynamic>> results = [];

      // Search Quran (this works well)
      final quranResults = await searchQuranVerses(query);
      results.addAll(quranResults);

      // Search Hadith (currently limited due to API issues)
      try {
        final hadithResults = await searchHadiths(query);
        results.addAll(hadithResults);
      } catch (e) {
        // Hadith search failed, continue with Quran results only
        print('Hadith search failed: $e');
      }

      // Sort all results by relevance
      results.sort((a, b) {
        final aText = a['englishText'] as String? ?? '';
        final bText = b['englishText'] as String? ?? '';
        return _calculateRelevance(query, bText).compareTo(_calculateRelevance(query, aText));
      });

      return results.take(15).toList(); // Return top 15 results
    } catch (e) {
      throw Exception('Error searching Islamic content: $e');
    }
  }

  /// Get random verses for inspiration/testing
  Future<List<Map<String, dynamic>>> getRandomVerses({int count = 5}) async {
    try {
      final List<int> randomSurahs = [1, 2, 18, 36, 55, 67, 112, 113, 114]; // Popular surahs
      List<Map<String, dynamic>> results = [];

      for (int i = 0; i < count && i < randomSurahs.length; i++) {
        try {
          final surah = await getSurah(randomSurahs[i]);
          final englishVerses = (surah['english'] as List? ?? []).cast<String>();
          final arabicVerses = (surah['arabic1'] as List? ?? []).cast<String>();

          if (englishVerses.isNotEmpty) {
            // Get first verse of each surah
            results.add({
              'surah': randomSurahs[i],
              'verse': 1,
              'surahName': surah['surahName'],
              'surahNameArabic': surah['surahNameArabic'],
              'englishText': englishVerses[0],
              'arabicText': arabicVerses.isNotEmpty ? arabicVerses[0] : '',
              'revelationPlace': surah['revelationPlace'],
              'type': 'quran',
              'reference': '${surah['surahName']} 1',
            });
          }
        } catch (e) {
          continue;
        }
      }

      return results;
    } catch (e) {
      throw Exception('Error getting random verses: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
