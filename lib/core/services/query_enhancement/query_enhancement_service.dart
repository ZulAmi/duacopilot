import 'package:intl/intl.dart';
import '../../../domain/entities/enhanced_query.dart';
import '../../../domain/entities/query_context.dart';
import 'islamic_terminology_mapper.dart';
import 'query_validator.dart';
import 'intent_classifier.dart';

/// Comprehensive query enhancement service for RAG API calls
class QueryEnhancementService {
  final IslamicTerminologyMapper _terminologyMapper;
  final QueryValidator _validator;
  final IntentClassifier _intentClassifier;

  // Supported languages
  static const List<String> supportedLanguages = ['en', 'ar', 'ur', 'id'];

  // Islamic calendar instance
  late final DateFormat _islamicDateFormat;
  late final DateFormat _timeFormat;

  QueryEnhancementService({
    IslamicTerminologyMapper? terminologyMapper,
    QueryValidator? validator,
    IntentClassifier? intentClassifier,
  }) : _terminologyMapper = terminologyMapper ?? IslamicTerminologyMapper(),
       _validator = validator ?? QueryValidator(),
       _intentClassifier = intentClassifier ?? IntentClassifier() {
    _islamicDateFormat = DateFormat('dd MMMM yyyy', 'ar');
    _timeFormat = DateFormat('HH:mm', 'en');
  }

  /// Main method to enhance a query before RAG API call
  Future<EnhancedQuery> enhanceQuery({
    required String originalQuery,
    required String language,
    QueryContext? context,
    Map<String, dynamic>? userPreferences,
  }) async {
    try {
      // Step 1: Validate and sanitize input
      final validationResult = await _validator.validateQuery(originalQuery);
      if (!validationResult.isValid) {
        throw QueryValidationException(validationResult.errors.join(', '));
      }

      final sanitizedQuery = _validator.sanitizeQuery(originalQuery);

      // Step 2: Text preprocessing and normalization
      final normalizedQuery = await _preprocessText(sanitizedQuery, language);

      // Step 3: Generate or enhance context
      final enhancedContext = await _enhanceContext(context ?? QueryContext());

      // Step 4: Classify intent
      final intent = await _intentClassifier.classifyIntent(normalizedQuery, language);

      // Step 5: Expand query with Islamic terminology
      final expandedQuery = await _terminologyMapper.expandQuery(normalizedQuery, language, intent: intent);

      // Step 6: Inject contextual information
      final contextualizedQuery = await _injectContextualInfo(
        expandedQuery,
        enhancedContext,
        language,
        userPreferences,
      );

      // Step 7: Generate semantic tags and keywords
      final semanticTags = await _generateSemanticTags(contextualizedQuery, intent, language);

      // Step 8: Create enhanced query object
      final enhancedQuery = EnhancedQuery(
        originalQuery: originalQuery,
        processedQuery: contextualizedQuery,
        language: language,
        intent: intent,
        context: enhancedContext,
        semanticTags: semanticTags,
        confidence: _calculateConfidence(normalizedQuery, intent, enhancedContext),
        processingSteps: [
          'validation',
          'sanitization',
          'normalization',
          'context_enhancement',
          'intent_classification',
          'terminology_expansion',
          'contextualization',
          'semantic_tagging',
        ],
        metadata: {
          'processing_time': DateTime.now().millisecondsSinceEpoch,
          'language_detected': language,
          'query_length': contextualizedQuery.length,
          'original_length': originalQuery.length,
          'expansion_ratio': contextualizedQuery.length / originalQuery.length,
        },
      );

      return enhancedQuery;
    } catch (e) {
      // Fallback: return basic enhanced query on error
      return EnhancedQuery(
        originalQuery: originalQuery,
        processedQuery: originalQuery,
        language: language,
        intent: QueryIntent.general,
        context: context ?? QueryContext(),
        semanticTags: [],
        confidence: 0.5,
        processingSteps: ['fallback'],
        metadata: {'error': e.toString()},
      );
    }
  }

  /// Preprocess and normalize text
  Future<String> _preprocessText(String text, String language) async {
    String processed = text;

    // Basic normalization
    processed = processed.trim();
    processed = _normalizeWhitespace(processed);
    processed = _normalizeUnicode(processed);

    // Language-specific preprocessing
    switch (language) {
      case 'ar':
        processed = _preprocessArabic(processed);
        break;
      case 'ur':
        processed = _preprocessUrdu(processed);
        break;
      case 'id':
        processed = _preprocessIndonesian(processed);
        break;
      default:
        processed = _preprocessEnglish(processed);
    }

    // Remove excessive punctuation but preserve structure
    processed = _normalizePunctuation(processed);

    return processed;
  }

  /// Enhance query context with current information
  Future<QueryContext> _enhanceContext(QueryContext baseContext) async {
    final now = DateTime.now();

    return baseContext.copyWith(
      timestamp: now,
      timeOfDay: _getTimeOfDay(now),
      islamicDate: _getIslamicDate(now),
      prayerTime: await _getCurrentPrayerTime(now, baseContext.location),
      seasonalContext: _getSeasonalContext(now),
      weekday: _getIslamicWeekday(now.weekday),
    );
  }

  /// Inject contextual information into query
  Future<String> _injectContextualInfo(
    String query,
    QueryContext context,
    String language,
    Map<String, dynamic>? userPreferences,
  ) async {
    final contextualPhrases = <String>[];

    // Time-based context
    if (context.timeOfDay != null) {
      contextualPhrases.add(_getTimeContextPhrase(context.timeOfDay!, language));
    }

    // Prayer time context
    if (context.prayerTime != null) {
      contextualPhrases.add(_getPrayerContextPhrase(context.prayerTime!, language));
    }

    // Seasonal context
    if (context.seasonalContext != null) {
      contextualPhrases.add(_getSeasonalContextPhrase(context.seasonalContext!, language));
    }

    // Location context
    if (context.location != null) {
      contextualPhrases.add(_getLocationContextPhrase(context.location!, language));
    }

    // User preferences context
    if (userPreferences != null) {
      contextualPhrases.addAll(_getUserPreferenceContextPhrases(userPreferences, language));
    }

    // Combine original query with context
    if (contextualPhrases.isNotEmpty) {
      final contextString = contextualPhrases.join(' ');
      return '$query [Context: $contextString]';
    }

    return query;
  }

  /// Generate semantic tags for the query
  Future<List<String>> _generateSemanticTags(String query, QueryIntent intent, String language) async {
    final tags = <String>[];

    // Intent-based tags
    tags.add('intent:${intent.name}');

    // Language tag
    tags.add('lang:$language');

    // Content-based tags
    final contentTags = await _extractContentTags(query, language);
    tags.addAll(contentTags);

    // Emotional context tags
    final emotionalTags = _extractEmotionalTags(query, language);
    tags.addAll(emotionalTags);

    // Topic tags using Islamic terminology
    final topicTags = await _terminologyMapper.extractTopicTags(query, language);
    tags.addAll(topicTags);

    return tags.toSet().toList(); // Remove duplicates
  }

  /// Calculate confidence score for the enhanced query
  double _calculateConfidence(String query, QueryIntent intent, QueryContext context) {
    double confidence = 0.5; // Base confidence

    // Query length factor
    if (query.length > 10 && query.length < 200) {
      confidence += 0.2;
    }

    // Intent confidence
    if (intent != QueryIntent.unknown) {
      confidence += 0.2;
    }

    // Context richness
    int contextFactors = 0;
    if (context.timeOfDay != null) contextFactors++;
    if (context.prayerTime != null) contextFactors++;
    if (context.location != null) contextFactors++;
    if (context.seasonalContext != null) contextFactors++;

    confidence += (contextFactors / 4) * 0.2;

    // Language specificity
    if (query.contains(RegExp(r'[\u0600-\u06FF]'))) {
      // Arabic
      confidence += 0.1;
    }

    return confidence.clamp(0.0, 1.0);
  }

  // Text preprocessing methods
  String _normalizeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalizeUnicode(String text) {
    // Normalize Arabic diacritics and variants
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '') // Remove diacritics
        .replaceAll('أ', 'ا') // Normalize Alif variants
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه') // Normalize Taa Marbouta
        .replaceAll('ي', 'ى') // Normalize Yaa variants
        .replaceAll('ك', 'ک'); // Normalize Kaaf variants for Urdu
  }

  String _normalizePunctuation(String text) {
    return text
        .replaceAll(RegExp(r'[!]{2,}'), '!')
        .replaceAll(RegExp(r'[?]{2,}'), '?')
        .replaceAll(RegExp(r'[.]{2,}'), '...')
        .replaceAll(RegExp(r'[-]{2,}'), ' - ');
  }

  String _preprocessArabic(String text) {
    return text
        .replaceAll('ﷺ', 'صلى الله عليه وسلم') // Expand PBUH symbol
        .replaceAll('ﷻ', 'جل جلاله') // Expand Jalla Jalalahu
        .replaceAll('﷽', 'بسم الله الرحمن الرحيم'); // Expand Basmala
  }

  String _preprocessUrdu(String text) {
    return text.replaceAll('ﷺ', 'صلی اللہ علیہ وسلم').replaceAll('ؑ', 'علیہ السلام').replaceAll('ؓ', 'رضی اللہ عنہ');
  }

  String _preprocessIndonesian(String text) {
    return text
        .replaceAll('SAW', 'Shallallahu Alaihi Wasallam')
        .replaceAll('AS', 'Alaihissalam')
        .replaceAll('RA', 'Radhiyallahu Anhu');
  }

  String _preprocessEnglish(String text) {
    return text
        .replaceAll('PBUH', 'Peace Be Upon Him')
        .replaceAll('pbuh', 'peace be upon him')
        .replaceAll('SAW', 'Sallallahu Alaihi Wasallam')
        .replaceAll('AS', 'Alaihis Salam')
        .replaceAll('RA', 'Radhiyallahu Anhu');
  }

  // Context generation methods
  TimeOfDay _getTimeOfDay(DateTime time) {
    final hour = time.hour;
    if (hour >= 4 && hour < 12) return TimeOfDay.morning;
    if (hour >= 12 && hour < 17) return TimeOfDay.afternoon;
    if (hour >= 17 && hour < 20) return TimeOfDay.evening;
    return TimeOfDay.night;
  }

  String _getIslamicDate(DateTime date) {
    // Simplified Islamic date calculation
    // In production, use a proper Hijri calendar library
    final daysSinceEpoch = date.difference(DateTime(622, 7, 16)).inDays;
    final islamicYear = 1 + (daysSinceEpoch / 354.37).floor();
    return 'السنة الهجرية $islamicYear';
  }

  Future<PrayerTime?> _getCurrentPrayerTime(DateTime time, String? location) async {
    // Simplified prayer time calculation
    // In production, integrate with a proper prayer time API
    final hour = time.hour;
    if (hour >= 4 && hour < 6) return PrayerTime.fajr;
    if (hour >= 6 && hour < 12) return PrayerTime.duha;
    if (hour >= 12 && hour < 15) return PrayerTime.dhuhr;
    if (hour >= 15 && hour < 18) return PrayerTime.asr;
    if (hour >= 18 && hour < 20) return PrayerTime.maghrib;
    if (hour >= 20 || hour < 4) return PrayerTime.isha;
    return null;
  }

  String _getSeasonalContext(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  String _getIslamicWeekday(int weekday) {
    const islamicWeekdays = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return islamicWeekdays[weekday - 1];
  }

  // Context phrase generation methods
  String _getTimeContextPhrase(TimeOfDay timeOfDay, String language) {
    switch (language) {
      case 'ar':
        switch (timeOfDay) {
          case TimeOfDay.morning:
            return 'في الصباح';
          case TimeOfDay.afternoon:
            return 'في فترة الظهيرة';
          case TimeOfDay.evening:
            return 'في المساء';
          case TimeOfDay.night:
            return 'في الليل';
        }
      case 'ur':
        switch (timeOfDay) {
          case TimeOfDay.morning:
            return 'صبح کے وقت';
          case TimeOfDay.afternoon:
            return 'دوپہر کے وقت';
          case TimeOfDay.evening:
            return 'شام کے وقت';
          case TimeOfDay.night:
            return 'رات کے وقت';
        }
      case 'id':
        switch (timeOfDay) {
          case TimeOfDay.morning:
            return 'di pagi hari';
          case TimeOfDay.afternoon:
            return 'di siang hari';
          case TimeOfDay.evening:
            return 'di sore hari';
          case TimeOfDay.night:
            return 'di malam hari';
        }
      default:
        switch (timeOfDay) {
          case TimeOfDay.morning:
            return 'in the morning';
          case TimeOfDay.afternoon:
            return 'in the afternoon';
          case TimeOfDay.evening:
            return 'in the evening';
          case TimeOfDay.night:
            return 'at night';
        }
    }
  }

  String _getPrayerContextPhrase(PrayerTime prayerTime, String language) {
    switch (language) {
      case 'ar':
        switch (prayerTime) {
          case PrayerTime.fajr:
            return 'وقت صلاة الفجر';
          case PrayerTime.duha:
            return 'وقت صلاة الضحى';
          case PrayerTime.dhuhr:
            return 'وقت صلاة الظهر';
          case PrayerTime.asr:
            return 'وقت صلاة العصر';
          case PrayerTime.maghrib:
            return 'وقت صلاة المغرب';
          case PrayerTime.isha:
            return 'وقت صلاة العشاء';
        }
      case 'ur':
        switch (prayerTime) {
          case PrayerTime.fajr:
            return 'فجر کا وقت';
          case PrayerTime.duha:
            return 'چاشت کا وقت';
          case PrayerTime.dhuhr:
            return 'ظہر کا وقت';
          case PrayerTime.asr:
            return 'عصر کا وقت';
          case PrayerTime.maghrib:
            return 'مغرب کا وقت';
          case PrayerTime.isha:
            return 'عشاء کا وقت';
        }
      case 'id':
        switch (prayerTime) {
          case PrayerTime.fajr:
            return 'waktu shalat Subuh';
          case PrayerTime.duha:
            return 'waktu shalat Dhuha';
          case PrayerTime.dhuhr:
            return 'waktu shalat Dzuhur';
          case PrayerTime.asr:
            return 'waktu shalat Ashar';
          case PrayerTime.maghrib:
            return 'waktu shalat Maghrib';
          case PrayerTime.isha:
            return 'waktu shalat Isya';
        }
      default:
        switch (prayerTime) {
          case PrayerTime.fajr:
            return 'during Fajr prayer time';
          case PrayerTime.duha:
            return 'during Duha prayer time';
          case PrayerTime.dhuhr:
            return 'during Dhuhr prayer time';
          case PrayerTime.asr:
            return 'during Asr prayer time';
          case PrayerTime.maghrib:
            return 'during Maghrib prayer time';
          case PrayerTime.isha:
            return 'during Isha prayer time';
        }
    }
  }

  String _getSeasonalContextPhrase(String season, String language) {
    switch (language) {
      case 'ar':
        switch (season) {
          case 'spring':
            return 'في فصل الربيع';
          case 'summer':
            return 'في فصل الصيف';
          case 'autumn':
            return 'في فصل الخريف';
          case 'winter':
            return 'في فصل الشتاء';
          default:
            return '';
        }
      case 'ur':
        switch (season) {
          case 'spring':
            return 'بہار کے موسم میں';
          case 'summer':
            return 'گرمیوں کے موسم میں';
          case 'autumn':
            return 'خزاں کے موسم میں';
          case 'winter':
            return 'سردیوں کے موسم میں';
          default:
            return '';
        }
      case 'id':
        switch (season) {
          case 'spring':
            return 'di musim semi';
          case 'summer':
            return 'di musim panas';
          case 'autumn':
            return 'di musim gugur';
          case 'winter':
            return 'di musim dingin';
          default:
            return '';
        }
      default:
        return 'during $season';
    }
  }

  String _getLocationContextPhrase(String location, String language) {
    switch (language) {
      case 'ar':
        return 'في $location';
      case 'ur':
        return '$location میں';
      case 'id':
        return 'di $location';
      default:
        return 'in $location';
    }
  }

  List<String> _getUserPreferenceContextPhrases(Map<String, dynamic> preferences, String language) {
    final phrases = <String>[];

    if (preferences['preferred_school'] != null) {
      final school = preferences['preferred_school'];
      switch (language) {
        case 'ar':
          phrases.add('وفقاً لمذهب $school');
          break;
        case 'ur':
          phrases.add('$school مسلک کے مطابق');
          break;
        case 'id':
          phrases.add('menurut mazhab $school');
          break;
        default:
          phrases.add('according to $school school');
          break;
      }
    }

    if (preferences['difficulty_level'] != null) {
      final level = preferences['difficulty_level'];
      switch (language) {
        case 'ar':
          phrases.add('مستوى $level');
          break;
        case 'ur':
          phrases.add('$level سطح');
          break;
        case 'id':
          phrases.add('tingkat $level');
          break;
        default:
          phrases.add('$level level');
          break;
      }
    }

    return phrases;
  }

  // Content analysis methods
  Future<List<String>> _extractContentTags(String query, String language) async {
    final tags = <String>[];
    final lowerQuery = query.toLowerCase();

    // Common Islamic concepts
    final islamicConcepts = {
      'prayer': ['prayer', 'salah', 'namaz', 'shalat', 'صلاة', 'نماز'],
      'dua': ['dua', 'supplication', 'prayer', 'دعاء'],
      'quran': ['quran', 'quraan', 'koran', 'قرآن'],
      'hadith': ['hadith', 'sunnah', 'حديث', 'سنة'],
      'fasting': ['fast', 'fasting', 'sawm', 'roza', 'puasa', 'صوم', 'روزہ'],
      'charity': ['charity', 'zakat', 'sadaqah', 'زكاة', 'صدقة'],
      'pilgrimage': ['hajj', 'umrah', 'pilgrimage', 'حج', 'عمرة'],
    };

    for (final entry in islamicConcepts.entries) {
      for (final term in entry.value) {
        if (lowerQuery.contains(term)) {
          tags.add('topic:${entry.key}');
          break;
        }
      }
    }

    return tags;
  }

  List<String> _extractEmotionalTags(String query, String language) {
    final tags = <String>[];
    final lowerQuery = query.toLowerCase();

    // Emotional indicators
    final emotions = {
      'distressed': ['help', 'problem', 'difficulty', 'trouble', 'مشكلة', 'مساعدة'],
      'grateful': ['thank', 'grateful', 'blessing', 'شكر', 'حمد'],
      'seeking': ['want', 'need', 'seeking', 'looking for', 'أريد', 'أحتاج'],
      'confused': ['confused', 'don\'t understand', 'unclear', 'محتار', 'لا أفهم'],
    };

    for (final entry in emotions.entries) {
      for (final indicator in entry.value) {
        if (lowerQuery.contains(indicator)) {
          tags.add('emotion:${entry.key}');
          break;
        }
      }
    }

    return tags;
  }
}

/// Exception thrown when query validation fails
class QueryValidationException implements Exception {
  final String message;
  QueryValidationException(this.message);

  @override
  String toString() => 'QueryValidationException: $message';
}
