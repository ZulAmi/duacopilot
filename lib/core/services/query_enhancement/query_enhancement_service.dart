// ignore_for_file: avoid_print

import 'package:intl/intl.dart';

import '../../../domain/entities/enhanced_query.dart';
import '../../../domain/entities/query_context.dart';
import 'intent_classifier.dart';
import 'islamic_terminology_mapper.dart';
import 'query_validator.dart';

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
  })  : _terminologyMapper = terminologyMapper ?? IslamicTerminologyMapper(),
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
      final intent =
          await _intentClassifier.classifyIntent(normalizedQuery, language);

      // Step 5: Expand query with Islamic terminology
      final expandedQuery = await _terminologyMapper
          .expandQuery(normalizedQuery, language, intent: intent);

      // Step 6: Inject contextual information
      final contextualizedQuery = await _injectContextualInfo(
        expandedQuery,
        enhancedContext,
        language,
        userPreferences,
      );

      // Step 7: Generate semantic tags and keywords
      final semanticTags =
          await _generateSemanticTags(contextualizedQuery, intent, language);

      // Step 8: Create enhanced query object
      final enhancedQuery = EnhancedQuery(
        originalQuery: originalQuery,
        processedQuery: contextualizedQuery,
        language: language,
        intent: intent,
        context: enhancedContext,
        semanticTags: semanticTags,
        confidence:
            _calculateConfidence(normalizedQuery, intent, enhancedContext),
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

    // Generate formatted time and date information
    final formattedTime = _timeFormat.format(now);
    final islamicDateString = _getIslamicDate(now);

    // Log the enhanced context for debugging
    print(
        'Enhanced context: time=$formattedTime, islamic_date=$islamicDateString');

    return baseContext.copyWith(
      timestamp: now,
      timeOfDay: _getTimeOfDay(now),
      islamicDate: islamicDateString,
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

    // Time-based context with formatted time
    if (context.timeOfDay != null) {
      contextualPhrases
          .add(_getTimeContextPhrase(context.timeOfDay!, language));

      // Add specific formatted time using the time formatter
      if (context.timestamp != null) {
        final formattedTime = _timeFormat.format(context.timestamp!);
        contextualPhrases
            .add(_getFormattedTimeContext(formattedTime, language));
      }
    }

    // Islamic date context
    if (context.islamicDate != null) {
      contextualPhrases
          .add(_getIslamicDateContext(context.islamicDate!, language));
    }

    // Prayer time context
    if (context.prayerTime != null) {
      contextualPhrases
          .add(_getPrayerContextPhrase(context.prayerTime!, language));
    }

    // Seasonal context
    if (context.seasonalContext != null) {
      contextualPhrases
          .add(_getSeasonalContextPhrase(context.seasonalContext!, language));
    }

    // Location context
    if (context.location != null) {
      contextualPhrases
          .add(_getLocationContextPhrase(context.location!, language));
    }

    // User preferences context
    if (userPreferences != null) {
      contextualPhrases
          .addAll(_getUserPreferenceContextPhrases(userPreferences, language));
    }

    // Combine original query with context
    if (contextualPhrases.isNotEmpty) {
      final contextString = contextualPhrases.join(' ');
      return '$query [Context: $contextString]';
    }

    return query;
  }

  /// Generate semantic tags for the query
  Future<List<String>> _generateSemanticTags(
      String query, QueryIntent intent, String language) async {
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
    final topicTags =
        await _terminologyMapper.extractTopicTags(query, language);
    tags.addAll(topicTags);

    return tags.toSet().toList(); // Remove duplicates
  }

  /// Calculate confidence score for the enhanced query
  double _calculateConfidence(
      String query, QueryIntent intent, QueryContext context) {
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
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
            '') // Remove diacritics
        .replaceAll('Ø£', 'Ø§') // Normalize Alif variants
        .replaceAll('Ø¥', 'Ø§')
        .replaceAll('Ø¢', 'Ø§')
        .replaceAll('Ø©', 'Ù‡') // Normalize Taa Marbouta
        .replaceAll('ÙŠ', 'Ù‰') // Normalize Yaa variants
        .replaceAll('Ùƒ', 'Ú©'); // Normalize Kaaf variants for Urdu
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
        .replaceAll(
            'ï·º', 'ØµÙ„Ù‰ Ø§Ù„Ù„Ù‡ Ø¹Ù„ÙŠÙ‡ ÙˆØ³Ù„Ù…') // Expand PBUH symbol
        .replaceAll('ï·»', 'Ø¬Ù„ Ø¬Ù„Ø§Ù„Ù‡') // Expand Jalla Jalalahu
        .replaceAll('ï·½',
            'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…'); // Expand Basmala
  }

  String _preprocessUrdu(String text) {
    return text
        .replaceAll('ï·º', 'ØµÙ„ÛŒ Ø§Ù„Ù„Û Ø¹Ù„ÛŒÛ ÙˆØ³Ù„Ù…')
        .replaceAll('Ø‘', 'Ø¹Ù„ÛŒÛ Ø§Ù„Ø³Ù„Ø§Ù…')
        .replaceAll('Ø“', 'Ø±Ø¶ÛŒ Ø§Ù„Ù„Û Ø¹Ù†Û');
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
    // Use the Islamic date formatter for proper Hijri representation
    try {
      // For more accurate Islamic date, this would integrate with a Hijri calendar library
      final daysSinceEpoch = date.difference(DateTime(622, 7, 16)).inDays;
      final islamicYear = 1 + (daysSinceEpoch / 354.37).floor();
      final islamicMonth = ((daysSinceEpoch % 354.37) / 29.5).floor() + 1;
      final islamicDay = ((daysSinceEpoch % 354.37) % 29.5).floor() + 1;

      // Use the Islamic date formatter
      final formattedDate = _islamicDateFormat.format(date);
      return 'Ø§Ù„ØªØ§Ø±ÙŠØ® Ø§Ù„Ù‡Ø¬Ø±ÙŠ: $islamicDay/$islamicMonth/$islamicYear ($formattedDate)';
    } catch (e) {
      // Fallback to simple Islamic year calculation
      final daysSinceEpoch = date.difference(DateTime(622, 7, 16)).inDays;
      final islamicYear = 1 + (daysSinceEpoch / 354.37).floor();
      return 'Ø§Ù„Ø³Ù†Ø© Ø§Ù„Ù‡Ø¬Ø±ÙŠØ© $islamicYear';
    }
  }

  Future<PrayerTime?> _getCurrentPrayerTime(
      DateTime time, String? location) async {
    // Use the time formatter for consistent time representation
    final formattedTime = _timeFormat.format(time);

    // Simplified prayer time calculation with formatted time logging
    // In production, integrate with a proper prayer time API
    final hour = time.hour;
    PrayerTime? prayerTime;

    if (hour >= 4 && hour < 6) {
      prayerTime = PrayerTime.fajr;
    } else if (hour >= 6 && hour < 12) {
      prayerTime = PrayerTime.duha;
    } else if (hour >= 12 && hour < 15) {
      prayerTime = PrayerTime.dhuhr;
    } else if (hour >= 15 && hour < 18) {
      prayerTime = PrayerTime.asr;
    } else if (hour >= 18 && hour < 20) {
      prayerTime = PrayerTime.maghrib;
    } else if (hour >= 20 || hour < 4) {
      prayerTime = PrayerTime.isha;
    }

    // Log formatted time for debugging/context
    if (prayerTime != null) {
      // This formatted time can be used for context injection
      print(
          'Prayer time ${prayerTime.name} detected at $formattedTime${location != null ? ' in $location' : ''}');
    }

    return prayerTime;
  }

  String _getSeasonalContext(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  String _getIslamicWeekday(int weekday) {
    const islamicWeekdays = [
      'Ø§Ù„Ø¥Ø«Ù†ÙŠÙ†',
      'Ø§Ù„Ø«Ù„Ø§Ø«Ø§Ø¡',
      'Ø§Ù„Ø£Ø±Ø¨Ø¹Ø§Ø¡',
      'Ø§Ù„Ø®Ù…ÙŠØ³',
      'Ø§Ù„Ø¬Ù…Ø¹Ø©',
      'Ø§Ù„Ø³Ø¨Øª',
      'Ø§Ù„Ø£Ø­Ø¯'
    ];
    return islamicWeekdays[weekday - 1];
  }

  // Context phrase generation methods
  String _getTimeContextPhrase(TimeOfDay timeOfDay, String language) {
    switch (language) {
      case 'ar':
        switch (timeOfDay) {
          case TimeOfDay.morning:
            return 'ÙÙŠ Ø§Ù„ØµØ¨Ø§Ø­';
          case TimeOfDay.afternoon:
            return 'ÙÙŠ ÙØªØ±Ø© Ø§Ù„Ø¸Ù‡ÙŠØ±Ø©';
          case TimeOfDay.evening:
            return 'ÙÙŠ Ø§Ù„Ù…Ø³Ø§Ø¡';
          case TimeOfDay.night:
            return 'ÙÙŠ Ø§Ù„Ù„ÙŠÙ„';
        }
      case 'ur':
        switch (timeOfDay) {
          case TimeOfDay.morning:
            return 'ØµØ¨Ø­ Ú©Û’ ÙˆÙ‚Øª';
          case TimeOfDay.afternoon:
            return 'Ø¯ÙˆÙ¾ÛØ± Ú©Û’ ÙˆÙ‚Øª';
          case TimeOfDay.evening:
            return 'Ø´Ø§Ù… Ú©Û’ ÙˆÙ‚Øª';
          case TimeOfDay.night:
            return 'Ø±Ø§Øª Ú©Û’ ÙˆÙ‚Øª';
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

  /// Get formatted time string for context injection
  String _getFormattedTimeContext(String formattedTime, String language) {
    switch (language) {
      case 'ar':
        return 'Ø§Ù„ÙˆÙ‚Øª: $formattedTime';
      case 'ur':
        return 'ÙˆÙ‚Øª: $formattedTime';
      case 'id':
        return 'waktu: $formattedTime';
      default:
        return 'time: $formattedTime';
    }
  }

  /// Get Islamic date context phrase
  String _getIslamicDateContext(String islamicDate, String language) {
    switch (language) {
      case 'ar':
        return islamicDate; // Already in Arabic
      case 'ur':
        return 'Ø§Ø³Ù„Ø§Ù…ÛŒ ØªØ§Ø±ÛŒØ®: $islamicDate';
      case 'id':
        return 'tanggal Islam: $islamicDate';
      default:
        return 'Islamic date: $islamicDate';
    }
  }

  String _getPrayerContextPhrase(PrayerTime prayerTime, String language) {
    switch (language) {
      case 'ar':
        switch (prayerTime) {
          case PrayerTime.fajr:
            return 'ÙˆÙ‚Øª ØµÙ„Ø§Ø© Ø§Ù„ÙØ¬Ø±';
          case PrayerTime.duha:
            return 'ÙˆÙ‚Øª ØµÙ„Ø§Ø© Ø§Ù„Ø¶Ø­Ù‰';
          case PrayerTime.dhuhr:
            return 'ÙˆÙ‚Øª ØµÙ„Ø§Ø© Ø§Ù„Ø¸Ù‡Ø±';
          case PrayerTime.asr:
            return 'ÙˆÙ‚Øª ØµÙ„Ø§Ø© Ø§Ù„Ø¹ØµØ±';
          case PrayerTime.maghrib:
            return 'ÙˆÙ‚Øª ØµÙ„Ø§Ø© Ø§Ù„Ù…ØºØ±Ø¨';
          case PrayerTime.isha:
            return 'ÙˆÙ‚Øª ØµÙ„Ø§Ø© Ø§Ù„Ø¹Ø´Ø§Ø¡';
        }
      case 'ur':
        switch (prayerTime) {
          case PrayerTime.fajr:
            return 'ÙØ¬Ø± Ú©Ø§ ÙˆÙ‚Øª';
          case PrayerTime.duha:
            return 'Ú†Ø§Ø´Øª Ú©Ø§ ÙˆÙ‚Øª';
          case PrayerTime.dhuhr:
            return 'Ø¸ÛØ± Ú©Ø§ ÙˆÙ‚Øª';
          case PrayerTime.asr:
            return 'Ø¹ØµØ± Ú©Ø§ ÙˆÙ‚Øª';
          case PrayerTime.maghrib:
            return 'Ù…ØºØ±Ø¨ Ú©Ø§ ÙˆÙ‚Øª';
          case PrayerTime.isha:
            return 'Ø¹Ø´Ø§Ø¡ Ú©Ø§ ÙˆÙ‚Øª';
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
            return 'ÙÙŠ ÙØµÙ„ Ø§Ù„Ø±Ø¨ÙŠØ¹';
          case 'summer':
            return 'ÙÙŠ ÙØµÙ„ Ø§Ù„ØµÙŠÙ';
          case 'autumn':
            return 'ÙÙŠ ÙØµÙ„ Ø§Ù„Ø®Ø±ÙŠÙ';
          case 'winter':
            return 'ÙÙŠ ÙØµÙ„ Ø§Ù„Ø´ØªØ§Ø¡';
          default:
            return '';
        }
      case 'ur':
        switch (season) {
          case 'spring':
            return 'Ø¨ÛØ§Ø± Ú©Û’ Ù…ÙˆØ³Ù… Ù…ÛŒÚº';
          case 'summer':
            return 'Ú¯Ø±Ù…ÛŒÙˆÚº Ú©Û’ Ù…ÙˆØ³Ù… Ù…ÛŒÚº';
          case 'autumn':
            return 'Ø®Ø²Ø§Úº Ú©Û’ Ù…ÙˆØ³Ù… Ù…ÛŒÚº';
          case 'winter':
            return 'Ø³Ø±Ø¯ÛŒÙˆÚº Ú©Û’ Ù…ÙˆØ³Ù… Ù…ÛŒÚº';
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
        return 'ÙÙŠ $location';
      case 'ur':
        return '$location Ù…ÛŒÚº';
      case 'id':
        return 'di $location';
      default:
        return 'in $location';
    }
  }

  List<String> _getUserPreferenceContextPhrases(
      Map<String, dynamic> preferences, String language) {
    final phrases = <String>[];

    if (preferences['preferred_school'] != null) {
      final school = preferences['preferred_school'];
      switch (language) {
        case 'ar':
          phrases.add('ÙˆÙÙ‚Ø§Ù‹ Ù„Ù…Ø°Ù‡Ø¨ $school');
          break;
        case 'ur':
          phrases.add('$school Ù…Ø³Ù„Ú© Ú©Û’ Ù…Ø·Ø§Ø¨Ù‚');
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
          phrases.add('Ù…Ø³ØªÙˆÙ‰ $level');
          break;
        case 'ur':
          phrases.add('$level Ø³Ø·Ø­');
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
  Future<List<String>> _extractContentTags(
      String query, String language) async {
    final tags = <String>[];
    final lowerQuery = query.toLowerCase();

    // Common Islamic concepts
    final islamicConcepts = {
      'prayer': ['prayer', 'salah', 'namaz', 'shalat', 'ØµÙ„Ø§Ø©', 'Ù†Ù…Ø§Ø²'],
      'dua': ['dua', 'supplication', 'prayer', 'Ø¯Ø¹Ø§Ø¡'],
      'quran': ['quran', 'quraan', 'koran', 'Ù‚Ø±Ø¢Ù†'],
      'hadith': ['hadith', 'sunnah', 'Ø­Ø¯ÙŠØ«', 'Ø³Ù†Ø©'],
      'fasting': [
        'fast',
        'fasting',
        'sawm',
        'roza',
        'puasa',
        'ØµÙˆÙ…',
        'Ø±ÙˆØ²Û'
      ],
      'charity': ['charity', 'zakat', 'sadaqah', 'Ø²ÙƒØ§Ø©', 'ØµØ¯Ù‚Ø©'],
      'pilgrimage': ['hajj', 'umrah', 'pilgrimage', 'Ø­Ø¬', 'Ø¹Ù…Ø±Ø©'],
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
      'distressed': [
        'help',
        'problem',
        'difficulty',
        'trouble',
        'Ù…Ø´ÙƒÙ„Ø©',
        'Ù…Ø³Ø§Ø¹Ø¯Ø©'
      ],
      'grateful': ['thank', 'grateful', 'blessing', 'Ø´ÙƒØ±', 'Ø­Ù…Ø¯'],
      'seeking': [
        'want',
        'need',
        'seeking',
        'looking for',
        'Ø£Ø±ÙŠØ¯',
        'Ø£Ø­ØªØ§Ø¬'
      ],
      'confused': [
        'confused',
        'don\'t understand',
        'unclear',
        'Ù…Ø­ØªØ§Ø±',
        'Ù„Ø§ Ø£ÙÙ‡Ù…'
      ],
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
