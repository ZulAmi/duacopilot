import 'dart:async';
import '../../../domain/entities/enhanced_query.dart';

/// Islamic terminology mapper for query expansion
class IslamicTerminologyMapper {
  static const Map<String, Map<String, List<String>>> _terminologyMaps = {
    'en': {
      'prayer': ['salah', 'namaz', 'worship', 'prostration', 'rukuh', 'sujood'],
      'dua': ['supplication', 'invocation', 'prayer', 'request', 'plea'],
      'quran': ['holy book', 'revelation', 'verses', 'surah', 'ayah'],
      'hadith': ['tradition', 'saying', 'narration', 'report', 'sunnah'],
      'fasting': ['sawm', 'abstinence', 'ramadan', 'iftar', 'suhur'],
      'charity': ['zakat', 'sadaqah', 'alms', 'donation', 'giving'],
      'pilgrimage': ['hajj', 'umrah', 'mecca', 'kaaba', 'tawaf'],
      'prophet': ['messenger', 'rasul', 'nabi', 'muhammad', 'pbuh'],
      'allah': ['god', 'creator', 'almighty', 'divine', 'lord'],
      'faith': ['iman', 'belief', 'trust', 'conviction', 'certainty'],
    },
    'ar': {
      'ØµÙ„Ø§Ø©': [
        'Ø¹Ø¨Ø§Ø¯Ø©',
        'Ø±ÙƒÙˆØ¹',
        'Ø³Ø¬ÙˆØ¯',
        'Ù‚ÙŠØ§Ù…',
        'ØªØ³Ø¨ÙŠØ­'
      ],
      'Ø¯Ø¹Ø§Ø¡': [
        'Ø§Ø³ØªØºØ§Ø«Ø©',
        'ØªÙˆØ³Ù„',
        'Ø§Ø¨ØªÙ‡Ø§Ù„',
        'Ù…Ù†Ø§Ø¬Ø§Ø©',
        'ØªØ¶Ø±Ø¹'
      ],
      'Ù‚Ø±Ø¢Ù†': [
        'ÙƒØªØ§Ø¨ Ø§Ù„Ù„Ù‡',
        'Ø§Ù„Ø°ÙƒØ± Ø§Ù„Ø­ÙƒÙŠÙ…',
        'Ø§Ù„ÙØ±Ù‚Ø§Ù†',
        'Ø¢ÙŠØ©',
        'Ø³ÙˆØ±Ø©'
      ],
      'Ø­Ø¯ÙŠØ«': ['Ø³Ù†Ø©', 'Ø£Ø«Ø±', 'Ø®Ø¨Ø±', 'Ø±ÙˆØ§ÙŠØ©', 'Ù†Ù‚Ù„'],
      'ØµÙˆÙ…': [
        'Ø¥Ù…Ø³Ø§Ùƒ',
        'ØµÙŠØ§Ù…',
        'Ø±Ù…Ø¶Ø§Ù†',
        'Ø¥ÙØ·Ø§Ø±',
        'Ø³Ø­ÙˆØ±'
      ],
      'Ø²ÙƒØ§Ø©': ['ØµØ¯Ù‚Ø©', 'Ø¹Ø·Ø§Ø¡', 'Ø¥Ù†ÙØ§Ù‚', 'Ø®ÙŠØ±', 'Ø¨Ø±'],
      'Ø­Ø¬': [
        'Ø¹Ù…Ø±Ø©',
        'Ø¨ÙŠØª Ø§Ù„Ù„Ù‡',
        'Ø§Ù„ÙƒØ¹Ø¨Ø©',
        'Ø·ÙˆØ§Ù',
        'Ø³Ø¹ÙŠ'
      ],
      'Ù†Ø¨ÙŠ': [
        'Ø±Ø³ÙˆÙ„',
        'Ù…Ø­Ù…Ø¯',
        'Ø®Ø§ØªÙ… Ø§Ù„Ù†Ø¨ÙŠÙŠÙ†',
        'Ø§Ù„Ù…ØµØ·ÙÙ‰'
      ],
      'Ø§Ù„Ù„Ù‡': [
        'Ø±Ø¨',
        'Ø®Ø§Ù„Ù‚',
        'Ø¥Ù„Ù‡',
        'Ø¬Ù„ Ø¬Ù„Ø§Ù„Ù‡',
        'Ø³Ø¨Ø­Ø§Ù†Ù‡'
      ],
      'Ø¥ÙŠÙ…Ø§Ù†': [
        'Ø¹Ù‚ÙŠØ¯Ø©',
        'ÙŠÙ‚ÙŠÙ†',
        'Ø«Ù‚Ø©',
        'Ø§Ø¹ØªÙ‚Ø§Ø¯',
        'ØªØµØ¯ÙŠÙ‚'
      ],
    },
    'ur': {
      'Ù†Ù…Ø§Ø²': [
        'Ø¹Ø¨Ø§Ø¯Øª',
        'Ø±Ú©ÙˆØ¹',
        'Ø³Ø¬Ø¯Û',
        'Ù‚ÛŒØ§Ù…',
        'ØªØ³Ø¨ÛŒØ­'
      ],
      'Ø¯Ø¹Ø§': [
        'Ø§Ù„ØªØ¬Ø§',
        'Ù…Ù†Øª',
        'Ú¯Ø°Ø§Ø±Ø´',
        'Ø§Ø³ØªØ¯Ø¹Ø§',
        'Ø¯Ø±Ø®ÙˆØ§Ø³Øª'
      ],
      'Ù‚Ø±Ø¢Ù†': [
        'Ú©ØªØ§Ø¨ Ø§Ù„Ù„Û',
        'Ù‚Ø±Ø¢Ù† Ù…Ø¬ÛŒØ¯',
        'Ø¢ÛŒØª',
        'Ø³ÙˆØ±Û'
      ],
      'Ø­Ø¯ÛŒØ«': ['Ø³Ù†Øª', 'Ø±ÙˆØ§ÛŒØª', 'Ø®Ø¨Ø±', 'Ù†Ù‚Ù„', 'Ø§Ø«Ø±'],
      'Ø±ÙˆØ²Û': [
        'ØµÙˆÙ…',
        'Ø±Ù…Ø¶Ø§Ù†',
        'Ø§ÙØ·Ø§Ø±',
        'Ø³Ø­Ø±ÛŒ',
        'Ø§Ù…Ø³Ø§Ú©'
      ],
      'Ø²Ú©ÙˆÙ°Ûƒ': [
        'ØµØ¯Ù‚Û',
        'Ø®ÛŒØ±Ø§Øª',
        'Ø¯Ø§Ù†',
        'Ø¹Ø·ÛŒÛ',
        'Ø§Ù†ÙØ§Ù‚'
      ],
      'Ø­Ø¬': ['Ø¹Ù…Ø±Û', 'Ø®Ø§Ù†Û Ú©Ø¹Ø¨Û', 'Ø·ÙˆØ§Ù', 'Ø³Ø¹ÛŒ', 'Ù…Ú©Û'],
      'Ù†Ø¨ÛŒ': ['Ø±Ø³ÙˆÙ„', 'Ù…Ø­Ù…Ø¯', 'Ø®Ø§ØªÙ… Ø§Ù„Ù†Ø¨ÛŒÛŒÙ†', 'Ø­Ø¶ÙˆØ±'],
      'Ø§Ù„Ù„Û': [
        'Ø±Ø¨',
        'Ø®Ø§Ù„Ù‚',
        'Ù…Ø§Ù„Ú©',
        'Ù¾Ø±ÙˆØ±Ø¯Ú¯Ø§Ø±',
        'Ø®Ø¯Ø§'
      ],
      'Ø§ÛŒÙ…Ø§Ù†': [
        'Ø¹Ù‚ÛŒØ¯Û',
        'ÛŒÙ‚ÛŒÙ†',
        'Ø§Ø¹ØªÙ‚Ø§Ø¯',
        'Ø¨Ú¾Ø±ÙˆØ³Û',
        'ØªÙˆÚ©Ù„'
      ],
    },
    'id': {
      'shalat': ['ibadah', 'rukuk', 'sujud', 'berdiri', 'tasbih'],
      'doa': ['permohonan', 'permintaan', 'munajat', 'memohon'],
      'quran': ['kitab suci', 'alquran', 'ayat', 'surat', 'wahyu'],
      'hadits': ['sunnah', 'riwayat', 'atsar', 'berita', 'tradisi'],
      'puasa': ['shaum', 'ramadhan', 'berbuka', 'sahur', 'menahan'],
      'zakat': ['sedekah', 'infak', 'pemberian', 'derma', 'amal'],
      'haji': ['umrah', 'kabah', 'thawaf', 'said', 'makkah'],
      'nabi': ['rasul', 'muhammad', 'utusan', 'khatamul anbiya'],
      'allah': ['tuhan', 'pencipta', 'yang maha esa', 'rabb'],
      'iman': ['kepercayaan', 'keyakinan', 'akidah', 'tauhid'],
    },
  };

  static const Map<String, Map<String, String>> _contextualMappings = {
    'emotions': {
      'en': 'anxiety|worry|fear|sadness|grief|happiness|gratitude|love|hope',
      'ar': 'Ù‚Ù„Ù‚|Ø®ÙˆÙ|Ø­Ø²Ù†|ÙØ±Ø­|Ø´ÙƒØ±|Ø­Ø¨|Ø£Ù…Ù„|ÙŠØ£Ø³',
      'ur': 'Ù¾Ø±ÛŒØ´Ø§Ù†ÛŒ|Ø®ÙˆÙ|ØºÙ…|Ø®ÙˆØ´ÛŒ|Ø´Ú©Ø±|Ù…Ø­Ø¨Øª|Ø§Ù…ÛŒØ¯',
      'id': 'cemas|takut|sedih|bahagia|syukur|cinta|harapan',
    },
    'situations': {
      'en': 'exam|travel|work|marriage|illness|difficulty|success|guidance',
      'ar':
          'Ø§Ù…ØªØ­Ø§Ù†|Ø³ÙØ±|Ø¹Ù…Ù„|Ø²ÙˆØ§Ø¬|Ù…Ø±Ø¶|ØµØ¹ÙˆØ¨Ø©|Ù†Ø¬Ø§Ø­|Ù‡Ø¯Ø§ÙŠØ©',
      'ur':
          'Ø§Ù…ØªØ­Ø§Ù†|Ø³ÙØ±|Ú©Ø§Ù…|Ø´Ø§Ø¯ÛŒ|Ø¨ÛŒÙ…Ø§Ø±ÛŒ|Ù…Ø´Ú©Ù„|Ú©Ø§Ù…ÛŒØ§Ø¨ÛŒ|ÛØ¯Ø§ÛŒØª',
      'id': 'ujian|perjalanan|kerja|nikah|sakit|kesulitan|sukses|petunjuk',
    },
    'time_references': {
      'en': 'morning|afternoon|evening|night|before|after|during',
      'ar': 'ØµØ¨Ø§Ø­|Ø¸Ù‡Ø±|Ù…Ø³Ø§Ø¡|Ù„ÙŠÙ„|Ù‚Ø¨Ù„|Ø¨Ø¹Ø¯|Ø£Ø«Ù†Ø§Ø¡',
      'ur': 'ØµØ¨Ø­|Ø¯ÙˆÙ¾ÛØ±|Ø´Ø§Ù…|Ø±Ø§Øª|Ù¾ÛÙ„Û’|Ø¨Ø¹Ø¯|Ø¯ÙˆØ±Ø§Ù†',
      'id': 'pagi|siang|sore|malam|sebelum|sesudah|selama',
    },
  };

  /// Expand query with Islamic terminology and synonyms
  Future<String> expandQuery(
    String query,
    String language, {
    QueryIntent? intent,
  }) async {
    final expandedTerms = <String>[];
    final originalWords = query.toLowerCase().split(' ');

    // Get terminology map for the language
    final terminologyMap =
        _terminologyMaps[language] ?? _terminologyMaps['en']!;

    // Expand each word if it has Islamic terminology mappings
    for (final word in originalWords) {
      expandedTerms.add(word);

      // Find expansions for this word
      for (final entry in terminologyMap.entries) {
        if (entry.key.toLowerCase() == word ||
            entry.value.any((synonym) => synonym.toLowerCase() == word)) {
          // Add related terms (limit to avoid over-expansion)
          expandedTerms.addAll(entry.value.take(2));
          break;
        }
      }
    }

    // Add intent-specific terms
    if (intent != null && intent != QueryIntent.unknown) {
      expandedTerms.addAll(_getIntentSpecificTerms(intent, language));
    }

    // Combine original query with expansions
    final expansion = expandedTerms.toSet().toList().join(' ');
    return '$query $expansion'.trim();
  }

  /// Extract topic tags from query
  Future<List<String>> extractTopicTags(String query, String language) async {
    final tags = <String>[];
    final lowerQuery = query.toLowerCase();
    final terminologyMap =
        _terminologyMaps[language] ?? _terminologyMaps['en']!;

    // Check for Islamic topics
    for (final entry in terminologyMap.entries) {
      if (lowerQuery.contains(entry.key.toLowerCase()) ||
          entry.value.any(
            (synonym) => lowerQuery.contains(synonym.toLowerCase()),
          )) {
        tags.add('islamic_topic:${entry.key}');
      }
    }

    // Check for contextual patterns
    for (final contextEntry in _contextualMappings.entries) {
      final patterns = contextEntry.value[language];
      if (patterns != null) {
        final regex = RegExp(patterns, caseSensitive: false);
        if (regex.hasMatch(lowerQuery)) {
          tags.add('context:${contextEntry.key}');
        }
      }
    }

    return tags;
  }

  /// Get language-specific Islamic greetings and phrases
  Map<String, String> getIslamicPhrases(String language) {
    switch (language) {
      case 'ar':
        return {
          'greeting':
              'Ø§Ù„Ø³Ù„Ø§Ù… Ø¹Ù„ÙŠÙƒÙ… ÙˆØ±Ø­Ù…Ø© Ø§Ù„Ù„Ù‡ ÙˆØ¨Ø±ÙƒØ§ØªÙ‡',
          'basmala': 'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…',
          'praise': 'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡ Ø±Ø¨ Ø§Ù„Ø¹Ø§Ù„Ù…ÙŠÙ†',
          'seeking_help': 'Ø§Ù„Ù„Ù‡Ù… Ø£Ø¹Ù†ÙŠ',
          'conclusion':
              'ÙˆØ¢Ø®Ø± Ø¯Ø¹ÙˆØ§Ù†Ø§ Ø£Ù† Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡ Ø±Ø¨ Ø§Ù„Ø¹Ø§Ù„Ù…ÙŠÙ†',
        };
      case 'ur':
        return {
          'greeting':
              'Ø§Ù„Ø³Ù„Ø§Ù… Ø¹Ù„ÛŒÚ©Ù… ÙˆØ±Ø­Ù…Ûƒ Ø§Ù„Ù„Û ÙˆØ¨Ø±Ú©Ø§ØªÛ',
          'basmala': 'Ø¨Ø³Ù… Ø§Ù„Ù„Û Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÛŒÙ…',
          'praise': 'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Û Ø±Ø¨ Ø§Ù„Ø¹Ø§Ù„Ù…ÛŒÙ†',
          'seeking_help': 'Ø§Ù„Ù„ÛÙ… Ù…Ø¯Ø¯ ÙØ±Ù…Ø§',
          'conclusion':
              'Ø§ÙˆØ± ÛÙ…Ø§Ø±ÛŒ Ø¢Ø®Ø±ÛŒ Ø¯Ø¹Ø§ ÛŒÛ ÛÛ’ Ú©Û ØªÙ…Ø§Ù… ØªØ¹Ø±ÛŒÙÛŒÚº Ø§Ù„Ù„Û Ú©Û’ Ù„ÛŒÛ’ ÛÛŒÚº',
        };
      case 'id':
        return {
          'greeting': 'Assalamu\'alaikum warahmatullahi wabarakatuh',
          'basmala': 'Bismillahir rahmanir rahim',
          'praise': 'Alhamdulillahi rabbil alamiin',
          'seeking_help': 'Allahumma a\'inni',
          'conclusion': 'Dan doa terakhir kami adalah segala puji bagi Allah',
        };
      default:
        return {
          'greeting': 'Peace be upon you',
          'basmala':
              'In the name of Allah, the Most Gracious, the Most Merciful',
          'praise': 'All praise is due to Allah, Lord of the worlds',
          'seeking_help': 'O Allah, help me',
          'conclusion':
              'And our final prayer is that all praise belongs to Allah',
        };
    }
  }

  /// Get intent-specific terminology
  List<String> _getIntentSpecificTerms(QueryIntent intent, String language) {
    final Map<QueryIntent, Map<String, List<String>>> intentTerms = {
      QueryIntent.prayer: {
        'en': ['worship', 'devotion', 'prostration', 'recitation'],
        'ar': ['Ø¹Ø¨Ø§Ø¯Ø©', 'Ø®Ø´ÙˆØ¹', 'Ø³Ø¬ÙˆØ¯', 'ØªÙ„Ø§ÙˆØ©'],
        'ur': ['Ø¹Ø¨Ø§Ø¯Øª', 'Ø®Ø´ÙˆØ¹', 'Ø³Ø¬Ø¯Û', 'ØªÙ„Ø§ÙˆØª'],
        'id': ['ibadah', 'khusyu', 'sujud', 'tilawah'],
      },
      QueryIntent.dua: {
        'en': ['supplication', 'invocation', 'plea', 'request'],
        'ar': ['Ø§Ø¨ØªÙ‡Ø§Ù„', 'Ø§Ø³ØªØºØ§Ø«Ø©', 'ØªØ¶Ø±Ø¹', 'Ø·Ù„Ø¨'],
        'ur': ['Ø§Ù„ØªØ¬Ø§', 'Ù…Ù†Øª', 'Ø¯Ø±Ø®ÙˆØ§Ø³Øª', 'Ø·Ù„Ø¨'],
        'id': ['permohonan', 'munajat', 'memohon', 'berdo\'a'],
      },
      QueryIntent.guidance: {
        'en': ['direction', 'wisdom', 'advice', 'counsel'],
        'ar': ['Ø¥Ø±Ø´Ø§Ø¯', 'Ø­ÙƒÙ…Ø©', 'Ù†ØµÙŠØ­Ø©', 'ØªÙˆØ¬ÙŠÙ‡'],
        'ur': ['ÛØ¯Ø§ÛŒØª', 'Ø­Ú©Ù…Øª', 'Ù†ØµÛŒØ­Øª', 'Ø±Ø§ÛÙ†Ù…Ø§Ø¦ÛŒ'],
        'id': ['petunjuk', 'hikmah', 'nasihat', 'bimbingan'],
      },
      // Add more intent-specific terms as needed
    };

    final terms = intentTerms[intent];
    if (terms != null && terms.containsKey(language)) {
      return terms[language] ?? [];
    }
    return [];
  }

  /// Check if query contains Islamic content
  bool containsIslamicContent(String query, String language) {
    final lowerQuery = query.toLowerCase();
    final terminologyMap =
        _terminologyMaps[language] ?? _terminologyMaps['en']!;

    for (final entry in terminologyMap.entries) {
      if (lowerQuery.contains(entry.key.toLowerCase()) ||
          entry.value.any(
            (synonym) => lowerQuery.contains(synonym.toLowerCase()),
          )) {
        return true;
      }
    }

    return false;
  }

  /// Get query complexity score based on Islamic terminology usage
  double getComplexityScore(String query, String language) {
    final lowerQuery = query.toLowerCase();
    final terminologyMap =
        _terminologyMaps[language] ?? _terminologyMaps['en']!;
    int islamicTermCount = 0;
    int totalWords = query.split(' ').length;

    for (final entry in terminologyMap.entries) {
      if (lowerQuery.contains(entry.key.toLowerCase())) {
        islamicTermCount++;
      }
      for (final synonym in entry.value) {
        if (lowerQuery.contains(synonym.toLowerCase())) {
          islamicTermCount++;
          break;
        }
      }
    }

    // Return complexity score (0.0 to 1.0)
    return (islamicTermCount / totalWords).clamp(0.0, 1.0);
  }
}
