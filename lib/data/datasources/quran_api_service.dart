import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/audio_cache.dart';

/// Al Quran Cloud API service for RAG content integration
///
/// Provides access to Quranic verses, translations, search capabilities,
/// and audio content for enhancing RAG responses with authentic Islamic sources.
class QuranApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _cdnBaseUrl = 'https://cdn.alquran.cloud';

  final http.Client _client;

  // Popular editions for different use cases
  static const Map<String, String> popularEditions = {
    'arabic_uthmani': 'quran-uthmani-quran-academy',
    'english_sahih': 'en.sahih',
    'english_pickthall': 'en.pickthall',
    'english_yusufali': 'en.yusufali',
    'transliteration': 'en.transliteration',
  };

  // Popular audio reciters
  static const Map<String, String> popularReciters = {
    'alafasy': 'ar.alafasy',
    'abdulbasit': 'ar.abdulbasitmurattal',
    'sudais': 'ar.abdurrahmaansudais',
    'husary': 'ar.husary',
    'hanirifai': 'ar.hanirifai',
  };

  QuranApiService({http.Client? client}) : _client = client ?? http.Client();

  // ========== Search Operations ==========

  /// Search for verses containing specific keywords
  Future<QuranSearchResult> searchVerses({
    required String query,
    int? surahNumber,
    String edition = 'en.sahih',
  }) async {
    try {
      String endpoint;
      if (surahNumber != null) {
        endpoint =
            '$_baseUrl/search/${Uri.encodeComponent(query)}/$surahNumber/$edition';
      } else {
        endpoint = '$_baseUrl/search/${Uri.encodeComponent(query)}';
      }

      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuranSearchResult.fromJson(data);
      } else if (response.statusCode == 404) {
        return QuranSearchResult.empty(query);
      } else {
        throw QuranApiException(
          'Search failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to search verses: $e');
    }
  }

  /// Get detailed verse information with multiple translations
  Future<List<QuranVerse>> getVerseWithTranslations(
    int ayahNumber, {
    List<String>? editions,
  }) async {
    try {
      final selectedEditions =
          editions ??
          [
            popularEditions['arabic_uthmani']!,
            popularEditions['english_sahih']!,
            popularEditions['transliteration']!,
          ];

      final editionsParam = selectedEditions.join(',');
      final endpoint = '$_baseUrl/ayah/$ayahNumber/editions/$editionsParam';

      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> ayahData = data['data'];

        return ayahData.map((ayah) => QuranVerse.fromJson(ayah)).toList();
      } else {
        throw QuranApiException('Failed to get verse: ${response.statusCode}');
      }
    } catch (e) {
      throw QuranApiException('Failed to get verse with translations: $e');
    }
  }

  /// Get a complete Surah with specified edition
  Future<QuranSurah> getSurah(
    int surahNumber, {
    String edition = 'en.sahih',
    int? offset,
    int? limit,
  }) async {
    try {
      String endpoint = '$_baseUrl/surah/$surahNumber/$edition';

      if (offset != null || limit != null) {
        final params = <String>[];
        if (offset != null) params.add('offset=$offset');
        if (limit != null) params.add('limit=$limit');
        endpoint += '?${params.join('&')}';
      }

      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuranSurah.fromJson(data['data']);
      } else {
        throw QuranApiException('Failed to get surah: ${response.statusCode}');
      }
    } catch (e) {
      throw QuranApiException('Failed to get surah: $e');
    }
  }

  // ========== Edition Management ==========

  /// Get available editions by language
  Future<List<QuranEdition>> getEditionsByLanguage(String language) async {
    try {
      final endpoint = '$_baseUrl/edition/language/$language';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> editions = data['data'];

        return editions
            .map((edition) => QuranEdition.fromJson(edition))
            .toList();
      } else {
        throw QuranApiException(
          'Failed to get editions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get editions by language: $e');
    }
  }

  /// Get all available editions
  Future<List<QuranEdition>> getAllEditions() async {
    try {
      final endpoint = '$_baseUrl/edition';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> editions = data['data'];

        return editions
            .map((edition) => QuranEdition.fromJson(edition))
            .toList();
      } else {
        throw QuranApiException(
          'Failed to get editions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get all editions: $e');
    }
  }

  // ========== Audio Operations ==========

  /// Get audio URL for a specific verse and reciter
  String getAudioUrl({
    required int ayahNumber,
    String reciter = 'ar.alafasy',
    AudioQuality quality = AudioQuality.medium,
  }) {
    final qualityStr = _getQualityString(quality);
    return '$_cdnBaseUrl/quran/audio/$qualityStr/$reciter/$ayahNumber.mp3';
  }

  /// Get multiple audio URLs for different quality levels
  List<String> getAudioUrls({
    required int ayahNumber,
    String reciter = 'ar.alafasy',
  }) {
    return AudioQuality.values.map((quality) {
      final qualityStr = _getQualityString(quality);
      return '$_cdnBaseUrl/quran/audio/$qualityStr/$reciter/$ayahNumber.mp3';
    }).toList();
  }

  String _getQualityString(AudioQuality quality) {
    switch (quality) {
      case AudioQuality.low:
        return '64';
      case AudioQuality.medium:
        return '128';
      case AudioQuality.high:
        return '192';
      case AudioQuality.ultra:
        return '320';
    }
  }

  // ========== Utility Methods ==========

  /// Get meta information about Quran structure
  Future<QuranMeta> getMetaData() async {
    try {
      final endpoint = '$_baseUrl/meta';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuranMeta.fromJson(data['data']);
      } else {
        throw QuranApiException(
          'Failed to get meta data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get meta data: $e');
    }
  }

  /// Get verses requiring Sajda (prostration)
  Future<List<QuranVerse>> getSajdaVerses({String edition = 'en.sahih'}) async {
    try {
      final endpoint = '$_baseUrl/sajda/$edition';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> ayahs = data['data']['ayahs'];

        return ayahs.map((ayah) => QuranVerse.fromJson(ayah)).toList();
      } else {
        throw QuranApiException(
          'Failed to get sajda verses: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get sajda verses: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

// ========== Data Models ==========

/// QuranSearchResult class implementation
class QuranSearchResult {
  final String query;
  final int count;
  final List<QuranSearchMatch> matches;

  QuranSearchResult({
    required this.query,
    required this.count,
    required this.matches,
  });

  factory QuranSearchResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return QuranSearchResult(
      query: data['query'] ?? '',
      count: data['count'] ?? 0,
      matches:
          (data['matches'] as List<dynamic>?)
              ?.map((match) => QuranSearchMatch.fromJson(match))
              .toList() ??
          [],
    );
  }

  factory QuranSearchResult.empty(String query) {
    return QuranSearchResult(query: query, count: 0, matches: []);
  }
}

/// QuranSearchMatch class implementation
class QuranSearchMatch {
  final int number;
  final String text;
  final QuranEdition edition;
  final QuranSurahInfo surah;
  final int numberInSurah;

  QuranSearchMatch({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
  });

  factory QuranSearchMatch.fromJson(Map<String, dynamic> json) {
    return QuranSearchMatch(
      number: json['number'],
      text: json['text'],
      edition: QuranEdition.fromJson(json['edition']),
      surah: QuranSurahInfo.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
    );
  }
}

/// QuranVerse class implementation
class QuranVerse {
  final int number;
  final String text;
  final QuranEdition edition;
  final QuranSurahInfo surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final dynamic sajda; // Can be bool or object

  QuranVerse({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      number: json['number'],
      text: json['text'],
      edition: QuranEdition.fromJson(json['edition']),
      surah: QuranSurahInfo.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
    );
  }
}

/// QuranSurah class implementation
class QuranSurah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<QuranVerse> ayahs;

  QuranSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs:
          (json['ayahs'] as List<dynamic>)
              .map((ayah) => QuranVerse.fromJson(ayah))
              .toList(),
    );
  }
}

/// QuranSurahInfo class implementation
class QuranSurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;

  QuranSurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
  });

  factory QuranSurahInfo.fromJson(Map<String, dynamic> json) {
    return QuranSurahInfo(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
    );
  }
}

/// QuranEdition class implementation
class QuranEdition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  QuranEdition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory QuranEdition.fromJson(Map<String, dynamic> json) {
    return QuranEdition(
      identifier: json['identifier'],
      language: json['language'],
      name: json['name'],
      englishName: json['englishName'],
      format: json['format'],
      type: json['type'],
      direction: json['direction'],
    );
  }
}

/// QuranMeta class implementation
class QuranMeta {
  final Map<String, int> ayahs;
  final Map<String, dynamic> surahs;
  final Map<String, dynamic> juzs;
  final Map<String, dynamic> pages;
  final Map<String, dynamic> manzils;
  final Map<String, dynamic> rukus;
  final Map<String, dynamic> hizbQuarters;

  QuranMeta({
    required this.ayahs,
    required this.surahs,
    required this.juzs,
    required this.pages,
    required this.manzils,
    required this.rukus,
    required this.hizbQuarters,
  });

  factory QuranMeta.fromJson(Map<String, dynamic> json) {
    return QuranMeta(
      ayahs: Map<String, int>.from(json['ayahs']),
      surahs: json['surahs'],
      juzs: json['juzs'],
      pages: json['pages'],
      manzils: json['manzils'],
      rukus: json['rukus'],
      hizbQuarters: json['hizbQuarters'],
    );
  }
}

/// QuranApiException class implementation
class QuranApiException implements Exception {
  final String message;

  QuranApiException(this.message);

  @override
  String toString() => 'QuranApiException: $message';
}
