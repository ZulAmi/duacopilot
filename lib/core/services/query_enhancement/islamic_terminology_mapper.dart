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
      'صلاة': ['عبادة', 'ركوع', 'سجود', 'قيام', 'تسبيح'],
      'دعاء': ['استغاثة', 'توسل', 'ابتهال', 'مناجاة', 'تضرع'],
      'قرآن': ['كتاب الله', 'الذكر الحكيم', 'الفرقان', 'آية', 'سورة'],
      'حديث': ['سنة', 'أثر', 'خبر', 'رواية', 'نقل'],
      'صوم': ['إمساك', 'صيام', 'رمضان', 'إفطار', 'سحور'],
      'زكاة': ['صدقة', 'عطاء', 'إنفاق', 'خير', 'بر'],
      'حج': ['عمرة', 'بيت الله', 'الكعبة', 'طواف', 'سعي'],
      'نبي': ['رسول', 'محمد', 'خاتم النبيين', 'المصطفى'],
      'الله': ['رب', 'خالق', 'إله', 'جل جلاله', 'سبحانه'],
      'إيمان': ['عقيدة', 'يقين', 'ثقة', 'اعتقاد', 'تصديق'],
    },
    'ur': {
      'نماز': ['عبادت', 'رکوع', 'سجدہ', 'قیام', 'تسبیح'],
      'دعا': ['التجا', 'منت', 'گزارش', 'استدعاء', 'درخواست'],
      'قرآن': ['کتاب اللہ', 'قرآن مجید', 'آیت', 'سورہ'],
      'حدیث': ['سنت', 'روایت', 'خبر', 'نقل', 'اثر'],
      'روزہ': ['صوم', 'رمضان', 'افطار', 'سحری', 'امساک'],
      'زکوٰۃ': ['صدقہ', 'خیرات', 'دان', 'عطیہ', 'انفاق'],
      'حج': ['عمرہ', 'خانہ کعبہ', 'طواف', 'سعی', 'مکہ'],
      'نبی': ['رسول', 'محمد', 'خاتم النبیین', 'حضور'],
      'اللہ': ['رب', 'خالق', 'مالک', 'پروردگار', 'خدا'],
      'ایمان': ['عقیدہ', 'یقین', 'اعتقاد', 'بھروسہ', 'توکل'],
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
      'ar': 'قلق|خوف|حزن|فرح|شكر|حب|أمل|يأس',
      'ur': 'پریشانی|خوف|غم|خوشی|شکر|محبت|امید',
      'id': 'cemas|takut|sedih|bahagia|syukur|cinta|harapan',
    },
    'situations': {
      'en': 'exam|travel|work|marriage|illness|difficulty|success|guidance',
      'ar': 'امتحان|سفر|عمل|زواج|مرض|صعوبة|نجاح|هداية',
      'ur': 'امتحان|سفر|کام|شادی|بیماری|مشکل|کامیابی|ہدایت',
      'id': 'ujian|perjalanan|kerja|nikah|sakit|kesulitan|sukses|petunjuk',
    },
    'time_references': {
      'en': 'morning|afternoon|evening|night|before|after|during',
      'ar': 'صباح|ظهر|مساء|ليل|قبل|بعد|أثناء',
      'ur': 'صبح|دوپہر|شام|رات|پہلے|بعد|دوران',
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
    final terminologyMap = _terminologyMaps[language] ?? _terminologyMaps['en']!;

    // Expand each word if it has Islamic terminology mappings
    for (final word in originalWords) {
      expandedTerms.add(word);

      // Find expansions for this word
      for (final entry in terminologyMap.entries) {
        if (entry.key.toLowerCase() == word || entry.value.any((synonym) => synonym.toLowerCase() == word)) {
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
    final terminologyMap = _terminologyMaps[language] ?? _terminologyMaps['en']!;

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
          'greeting': 'السلام عليكم ورحمة الله وبركاته',
          'basmala': 'بسم الله الرحمن الرحيم',
          'praise': 'الحمد لله رب العالمين',
          'seeking_help': 'اللهم أعني',
          'conclusion': 'وآخر دعوانا أن الحمد لله رب العالمين',
        };
      case 'ur':
        return {
          'greeting': 'السلام علیکم ورحمة اللہ وبرکاتہ',
          'basmala': 'بسم اللہ الرحمن الرحیم',
          'praise': 'الحمد للہ رب العالمین',
          'seeking_help': 'اللہم مدد فرما',
          'conclusion': 'اور ہماری آخری دعا یہ ہے کہ تمام تعریفیں اللہ کے لیے ہیں',
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
          'basmala': 'In the name of Allah, the Most Gracious, the Most Merciful',
          'praise': 'All praise is due to Allah, Lord of the worlds',
          'seeking_help': 'O Allah, help me',
          'conclusion': 'And our final prayer is that all praise belongs to Allah',
        };
    }
  }

  /// Get intent-specific terminology
  List<String> _getIntentSpecificTerms(QueryIntent intent, String language) {
    final Map<QueryIntent, Map<String, List<String>>> intentTerms = {
      QueryIntent.prayer: {
        'en': ['worship', 'devotion', 'prostration', 'recitation'],
        'ar': ['عبادة', 'خشوع', 'سجود', 'تلاوة'],
        'ur': ['عبادت', 'خشوع', 'سجدہ', 'تلاوت'],
        'id': ['ibadah', 'khusyu', 'sujud', 'tilawah'],
      },
      QueryIntent.dua: {
        'en': ['supplication', 'invocation', 'plea', 'request'],
        'ar': ['ابتهال', 'استغاثة', 'تضرع', 'طلب'],
        'ur': ['التجا', 'منت', 'درخواست', 'طلب'],
        'id': ['permohonan', 'munajat', 'memohon', 'berdo\'a'],
      },
      QueryIntent.guidance: {
        'en': ['direction', 'wisdom', 'advice', 'counsel'],
        'ar': ['إرشاد', 'حكمة', 'نصيحة', 'توجيه'],
        'ur': ['ہدایت', 'حکمت', 'نصیحت', 'رہنمائی'],
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
    final terminologyMap = _terminologyMaps[language] ?? _terminologyMaps['en']!;

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
    final terminologyMap = _terminologyMaps[language] ?? _terminologyMaps['en']!;
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
