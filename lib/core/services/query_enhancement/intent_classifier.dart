import 'dart:math';
import '../../../domain/entities/enhanced_query.dart';

/// Intent classification service for query understanding
class IntentClassifier {
  // Intent classification patterns for different languages
  static const Map<String, Map<QueryIntent, List<String>>> _intentPatterns = {
    'en': {
      QueryIntent.prayer: [
        r'\b(prayer|salah|namaz|worship|prostration)\b',
        r'\b(fajr|dhuhr|asr|maghrib|isha)\b',
        r'\b(qiyam|tahajjud|witr)\b',
        r'\bhow to pray\b',
        r'\bprayer time\b',
      ],
      QueryIntent.dua: [
        r'\b(dua|supplication|invocation)\b',
        r'\b(please|help|bless|protect)\b',
        r'\b(forgive|mercy|guidance)\b',
        r'\bdua for\b',
        r'\bpray for\b',
      ],
      QueryIntent.quran: [
        r'\b(quran|quraan|koran)\b',
        r'\b(surah|ayah|verse)\b',
        r'\b(recitation|memorization)\b',
        r'\bquran says\b',
        r'\bin the quran\b',
      ],
      QueryIntent.hadith: [
        r'\b(hadith|sunnah|tradition)\b',
        r'\b(prophet said|messenger said)\b',
        r'\b(bukhari|muslim|tirmidhi)\b',
        r'\bhadith about\b',
        r'\bprophet taught\b',
      ],
      QueryIntent.fasting: [
        r'\b(fast|fasting|sawm|roza)\b',
        r'\b(ramadan|ramadhan)\b',
        r'\b(iftar|suhur|sehri)\b',
        r'\bbreak fast\b',
        r'\bfasting rules\b',
      ],
      QueryIntent.charity: [
        r'\b(charity|zakat|sadaqah)\b',
        r'\b(donation|giving|alms)\b',
        r'\b(help poor|help needy)\b',
        r'\bzakat on\b',
        r'\bgive charity\b',
      ],
      QueryIntent.pilgrimage: [
        r'\b(hajj|umrah|pilgrimage)\b',
        r'\b(mecca|makkah|kaaba)\b',
        r'\b(tawaf|said|jamarat)\b',
        r'\bhajj steps\b',
        r'\bumrah guide\b',
      ],
      QueryIntent.healing: [
        r'\b(heal|healing|cure|health)\b',
        r'\b(sick|illness|disease|pain)\b',
        r'\b(medicine|treatment|recovery)\b',
        r'\bdua for healing\b',
        r'\bwhen sick\b',
      ],
      QueryIntent.protection: [
        r'\b(protect|protection|safety|guard)\b',
        r'\b(evil|harm|danger|threat)\b',
        r'\b(safe|security|shield)\b',
        r'\bprotect from\b',
        r'\bkeep safe\b',
      ],
      QueryIntent.gratitude: [
        r'\b(thank|grateful|gratitude|blessing)\b',
        r'\b(alhamdulillah|praise|appreciation)\b',
        r'\b(blessed|fortune|gift)\b',
        r'\bthank allah\b',
        r'\bpraise for\b',
      ],
      QueryIntent.forgiveness: [
        r'\b(forgive|forgiveness|pardon|mercy)\b',
        r'\b(sin|mistake|wrong|error)\b',
        r'\b(repent|repentance|tawbah)\b',
        r'\bforgive me\b',
        r'\bseek forgiveness\b',
      ],
      QueryIntent.guidance: [
        r'\b(guide|guidance|direction|path)\b',
        r'\b(confused|lost|uncertain|doubt)\b',
        r'\b(decision|choice|advice)\b',
        r'\bshow me\b',
        r'\bright path\b',
      ],
      QueryIntent.knowledge: [
        r'\b(learn|knowledge|study|understand)\b',
        r'\b(teach|education|wisdom)\b',
        r'\b(explain|clarify|meaning)\b',
        r'\bwhat is\b',
        r'\bhow to\b',
      ],
      QueryIntent.travel: [
        r'\b(travel|journey|trip|voyage)\b',
        r'\b(safar|musafir|traveling)\b',
        r'\b(airport|flight|road|train)\b',
        r'\btravel dua\b',
        r'\bsafe journey\b',
      ],
      QueryIntent.family: [
        r'\b(family|parents|children|spouse)\b',
        r'\b(mother|father|wife|husband)\b',
        r'\b(marriage|wedding|divorce)\b',
        r'\bfor family\b',
        r'\bparents rights\b',
      ],
      QueryIntent.business: [
        r'\b(business|work|job|career)\b',
        r'\b(money|wealth|success|prosperity)\b',
        r'\b(halal|haram|permissible)\b',
        r'\bbusiness dua\b',
        r'\bhalal income\b',
      ],
      QueryIntent.emergency: [
        r'\b(emergency|urgent|crisis|disaster)\b',
        r'\b(accident|tragedy|calamity)\b',
        r'\b(immediately|quickly|help)\b',
        r'\bin trouble\b',
        r'\bemergency dua\b',
      ],
    },
    'ar': {
      QueryIntent.prayer: [
        r'\b(ØµÙ„Ø§Ø©|ØµÙ„Ù‰|Ù†Ù…Ø§Ø²|Ø¹Ø¨Ø§Ø¯Ø©)\b',
        r'\b(ÙØ¬Ø±|Ø¸Ù‡Ø±|Ø¹ØµØ±|Ù…ØºØ±Ø¨|Ø¹Ø´Ø§Ø¡)\b',
        r'\b(Ù‚ÙŠØ§Ù…|ØªÙ‡Ø¬Ø¯|ÙˆØªØ±)\b',
        r'ÙƒÙŠÙ Ø£ØµÙ„ÙŠ',
        r'ÙˆÙ‚Øª Ø§Ù„ØµÙ„Ø§Ø©',
      ],
      QueryIntent.dua: [
        r'\b(Ø¯Ø¹Ø§Ø¡|Ø§Ø¯Ø¹|Ø§Ø³ØªØºÙØ§Ø±)\b',
        r'\b(Ù…Ù† ÙØ¶Ù„Ùƒ|Ø³Ø§Ø¹Ø¯|Ø¨Ø§Ø±Ùƒ|Ø§Ø­Ù…)\b',
        r'\b(Ø§ØºÙØ±|Ø±Ø­Ù…Ø©|Ù‡Ø¯Ø§ÙŠØ©)\b',
        r'Ø¯Ø¹Ø§Ø¡ Ù„Ù€',
        r'Ø§Ø¯Ø¹ Ù„ÙŠ',
      ],
      QueryIntent.quran: [
        r'\b(Ù‚Ø±Ø¢Ù†|Ù‚Ø±Ø£Ù†|ÙƒØªØ§Ø¨ Ø§Ù„Ù„Ù‡)\b',
        r'\b(Ø³ÙˆØ±Ø©|Ø¢ÙŠØ©|ØªÙ„Ø§ÙˆØ©)\b',
        r'\b(Ø­ÙØ¸|ØªØ¬ÙˆÙŠØ¯|ØªÙØ³ÙŠØ±)\b',
        r'ÙŠÙ‚ÙˆÙ„ Ø§Ù„Ù‚Ø±Ø¢Ù†',
        r'ÙÙŠ Ø§Ù„Ù‚Ø±Ø¢Ù†',
      ],
      QueryIntent.fasting: [
        r'\b(ØµÙˆÙ…|ØµÙŠØ§Ù…|Ø±Ù…Ø¶Ø§Ù†)\b',
        r'\b(Ø¥ÙØ·Ø§Ø±|Ø³Ø­ÙˆØ±|Ø¥Ù…Ø³Ø§Ùƒ)\b',
        r'Ø£Ø­ÙƒØ§Ù… Ø§Ù„ØµÙŠØ§Ù…',
        r'ÙƒÙŠÙÙŠØ© Ø§Ù„ØµÙˆÙ…',
      ],
    },
    'ur': {
      QueryIntent.prayer: [
        r'\b(Ù†Ù…Ø§Ø²|ØµÙ„Ø§Ø©|Ø¹Ø¨Ø§Ø¯Øª)\b',
        r'\b(ÙØ¬Ø±|Ø¸ÛØ±|Ø¹ØµØ±|Ù…ØºØ±Ø¨|Ø¹Ø´Ø§Ø¡)\b',
        r'\b(Ù‚ÛŒØ§Ù…|ØªÛØ¬Ø¯|ÙˆØªØ±)\b',
        r'Ù†Ù…Ø§Ø² Ú©ÛŒØ³Û’ Ù¾Ú‘Ú¾ÛŒÚº',
        r'Ù†Ù…Ø§Ø² Ú©Ø§ ÙˆÙ‚Øª',
      ],
      QueryIntent.dua: [
        r'\b(Ø¯Ø¹Ø§|Ø§Ù„ØªØ¬Ø§|Ù…Ù†Øª)\b',
        r'\b(Ù…ÛØ±Ø¨Ø§Ù†ÛŒ|Ù…Ø¯Ø¯|Ø¨Ø±Ú©Øª|Ø­ÙØ§Ø¸Øª)\b',
        r'\b(Ù…Ø¹Ø§ÙÛŒ|Ø±Ø­Ù…|ÛØ¯Ø§ÛŒØª)\b',
        r'Ø¯Ø¹Ø§ Ø¨Ø±Ø§Ø¦Û’',
        r'Ù…ÛŒØ±Û’ Ù„ÛŒÛ’ Ø¯Ø¹Ø§',
      ],
    },
    'id': {
      QueryIntent.prayer: [
        r'\b(shalat|salat|ibadah)\b',
        r'\b(subuh|dzuhur|ashar|maghrib|isya)\b',
        r'\b(qiyam|tahajud|witir)\b',
        r'cara shalat',
        r'waktu shalat',
      ],
      QueryIntent.dua: [
        r'\b(doa|permohonan|mohon)\b',
        r'\b(tolong|bantu|berkah|lindungi)\b',
        r'\b(ampuni|rahmat|petunjuk)\b',
        r'doa untuk',
        r'doakan saya',
      ],
    },
  };

  // Context-based intent modifiers
  static const Map<String, List<String>> _contextModifiers = {
    'time_sensitive': [
      r'\b(now|immediately|urgent|quickly|today)\b',
      r'\b(Ø§Ù„Ø¢Ù†|ÙÙˆØ±Ø§Ù‹|Ø¹Ø§Ø¬Ù„|Ø§Ù„ÙŠÙˆÙ…)\b',
      r'\b(Ø§Ø¨Ú¾ÛŒ|ÙÙˆØ±ÛŒ|Ø¢Ø¬|Ø¬Ù„Ø¯ÛŒ)\b',
      r'\b(sekarang|segera|hari ini|cepat)\b',
    ],
    'emotional_distress': [
      r'\b(worried|anxious|scared|desperate|helpless)\b',
      r'\b(Ù‚Ù„Ù‚|Ø®Ø§Ø¦Ù|ÙŠØ§Ø¦Ø³|Ø¹Ø§Ø¬Ø²)\b',
      r'\b(Ù¾Ø±ÛŒØ´Ø§Ù†|Ø®ÙˆÙ|Ù…Ø§ÛŒÙˆØ³|Ø¨Û’Ø¨Ø³)\b',
      r'\b(khawatir|takut|putus asa|tidak berdaya)\b',
    ],
    'seeking_knowledge': [
      r'\b(what|how|why|when|where|explain|tell me)\b',
      r'\b(Ù…Ø§|ÙƒÙŠÙ|Ù„Ù…Ø§Ø°Ø§|Ù…ØªÙ‰|Ø£ÙŠÙ†|Ø§Ø´Ø±Ø­)\b',
      r'\b(Ú©ÛŒØ§|Ú©ÛŒØ³Û’|Ú©ÛŒÙˆÚº|Ú©Ø¨|Ú©ÛØ§Úº|Ø¨ØªØ§Ø¦ÛŒÚº)\b',
      r'\b(apa|bagaimana|mengapa|kapan|dimana|jelaskan)\b',
    ],
  };

  /// Classify the intent of a query
  Future<QueryIntent> classifyIntent(String query, String language) async {
    final lowerQuery = query.toLowerCase();
    final patterns = _intentPatterns[language] ?? _intentPatterns['en']!;

    // Score each intent based on pattern matches
    final intentScores = <QueryIntent, double>{};

    for (final entry in patterns.entries) {
      double score = 0.0;

      for (final pattern in entry.value) {
        final regex = RegExp(pattern, caseSensitive: false);
        final matches = regex.allMatches(lowerQuery);

        if (matches.isNotEmpty) {
          // Base score for match
          score += 1.0;

          // Bonus for multiple matches
          score += (matches.length - 1) * 0.5;

          // Bonus for longer matches
          for (final match in matches) {
            final matchLength = match.group(0)?.length ?? 0;
            score += matchLength * 0.01;
          }
        }
      }

      if (score > 0) {
        intentScores[entry.key] = score;
      }
    }

    // Apply context modifiers
    _applyContextModifiers(lowerQuery, intentScores);

    // Apply positional weights (keywords at beginning/end are more important)
    _applyPositionalWeights(lowerQuery, patterns, intentScores);

    // Return intent with highest score
    if (intentScores.isEmpty) {
      return QueryIntent.general;
    }

    final maxScore = intentScores.values.reduce(max);
    final topIntent = intentScores.entries
        .where((entry) => entry.value == maxScore)
        .first
        .key;

    // Require minimum confidence threshold
    if (maxScore < 0.5) {
      return QueryIntent.general;
    }

    return topIntent;
  }

  /// Get confidence score for intent classification
  Future<double> getIntentConfidence(
    String query,
    String language,
    QueryIntent intent,
  ) async {
    if (intent == QueryIntent.general || intent == QueryIntent.unknown) {
      return 0.5;
    }

    final patterns = _intentPatterns[language]?[intent] ?? [];
    if (patterns.isEmpty) return 0.3;

    final lowerQuery = query.toLowerCase();
    double confidence = 0.0;
    int matchCount = 0;

    for (final pattern in patterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      if (regex.hasMatch(lowerQuery)) {
        matchCount++;
        confidence += 0.2;
      }
    }

    // Adjust confidence based on query length and specificity
    final words = query.split(' ').length;
    if (words > 5 && matchCount > 0) {
      confidence += 0.1; // Longer, specific queries get bonus
    }
    if (words < 3 && matchCount > 0) {
      confidence -= 0.1; // Short queries get penalty
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Get all possible intents with their confidence scores
  Future<Map<QueryIntent, double>> getAllIntentScores(
    String query,
    String language,
  ) async {
    final lowerQuery = query.toLowerCase();
    final patterns = _intentPatterns[language] ?? _intentPatterns['en']!;
    final scores = <QueryIntent, double>{};

    for (final entry in patterns.entries) {
      double score = 0.0;

      for (final pattern in entry.value) {
        final regex = RegExp(pattern, caseSensitive: false);
        if (regex.hasMatch(lowerQuery)) {
          score += 0.2;
        }
      }

      if (score > 0) {
        scores[entry.key] = score.clamp(0.0, 1.0);
      }
    }

    return scores;
  }

  /// Apply context modifiers to adjust intent scores
  void _applyContextModifiers(
    String query,
    Map<QueryIntent, double> intentScores,
  ) {
    for (final entry in _contextModifiers.entries) {
      final modifierType = entry.key;
      final patterns = entry.value;

      bool hasModifier = false;
      for (final pattern in patterns) {
        if (RegExp(pattern, caseSensitive: false).hasMatch(query)) {
          hasModifier = true;
          break;
        }
      }

      if (hasModifier) {
        switch (modifierType) {
          case 'time_sensitive':
            // Boost emergency and guidance intents
            intentScores[QueryIntent.emergency] =
                (intentScores[QueryIntent.emergency] ?? 0) + 0.3;
            intentScores[QueryIntent.guidance] =
                (intentScores[QueryIntent.guidance] ?? 0) + 0.2;
            break;

          case 'emotional_distress':
            // Boost healing, protection, and guidance intents
            intentScores[QueryIntent.healing] =
                (intentScores[QueryIntent.healing] ?? 0) + 0.3;
            intentScores[QueryIntent.protection] =
                (intentScores[QueryIntent.protection] ?? 0) + 0.3;
            intentScores[QueryIntent.guidance] =
                (intentScores[QueryIntent.guidance] ?? 0) + 0.2;
            break;

          case 'seeking_knowledge':
            // Boost knowledge intent
            intentScores[QueryIntent.knowledge] =
                (intentScores[QueryIntent.knowledge] ?? 0) + 0.3;
            break;
        }
      }
    }
  }

  /// Apply positional weights to intent scores
  void _applyPositionalWeights(
    String query,
    Map<QueryIntent, List<String>> patterns,
    Map<QueryIntent, double> intentScores,
  ) {
    final words = query.split(' ');
    if (words.length < 2) return;

    final firstWord = words.first.toLowerCase();
    final lastWord = words.last.toLowerCase();

    for (final entry in patterns.entries) {
      final intent = entry.key;
      final patternList = entry.value;

      for (final pattern in patternList) {
        final regex = RegExp(pattern, caseSensitive: false);

        // Check if pattern matches at beginning of query
        if (regex.hasMatch(firstWord)) {
          intentScores[intent] = (intentScores[intent] ?? 0) + 0.1;
        }

        // Check if pattern matches at end of query
        if (regex.hasMatch(lastWord)) {
          intentScores[intent] = (intentScores[intent] ?? 0) + 0.05;
        }
      }
    }
  }

  /// Check if query has mixed intents
  bool hasMixedIntents(Map<QueryIntent, double> scores) {
    final significantScores =
        scores.values.where((score) => score > 0.3).length;
    return significantScores > 1;
  }

  /// Get the secondary intent if mixed intents are detected
  QueryIntent? getSecondaryIntent(Map<QueryIntent, double> scores) {
    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedScores.length >= 2 && sortedScores[1].value > 0.3) {
      return sortedScores[1].key;
    }

    return null;
  }

  /// Detect if query is asking a question
  bool isQuestion(String query, String language) {
    final questionPatterns = {
      'en': [
        r'\b(what|how|why|when|where|which|who|can|is|are|do|does|will)\b',
        r'\?',
      ],
      'ar': [
        r'\b(Ù…Ø§|ÙƒÙŠÙ|Ù„Ù…Ø§Ø°Ø§|Ù…ØªÙ‰|Ø£ÙŠÙ†|Ù…Ù†|Ù‡Ù„|Ø£ÙŠÙ†)\b',
        r'\ØŸ'
      ],
      'ur': [
        r'\b(Ú©ÛŒØ§|Ú©ÛŒØ³Û’|Ú©ÛŒÙˆÚº|Ú©Ø¨|Ú©ÛØ§Úº|Ú©ÙˆÙ†|Ú©ÛŒØ§)\b',
        r'\ØŸ'
      ],
      'id': [r'\b(apa|bagaimana|mengapa|kapan|dimana|siapa|apakah)\b', r'\?'],
    };

    final patterns = questionPatterns[language] ?? questionPatterns['en']!;
    return patterns.any(
      (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(query),
    );
  }

  /// Detect if query is a statement or declaration
  bool isStatement(String query, String language) {
    final statementPatterns = {
      'en': [r'\b(i am|i have|i want|i need|i feel|my)\b'],
      'ar': [r'\b(Ø£Ù†Ø§|Ù„Ø¯ÙŠ|Ø£Ø±ÙŠØ¯|Ø£Ø­ØªØ§Ø¬|Ø£Ø´Ø¹Ø±)\b'],
      'ur': [
        r'\b(Ù…ÛŒÚº|Ù…ÛŒØ±Û’ Ù¾Ø§Ø³|Ù…Ø¬Ú¾Û’ Ú†Ø§ÛÛŒÛ’|Ù…ÛŒÚº Ù…Ø­Ø³ÙˆØ³)\b'
      ],
      'id': [r'\b(saya|saya punya|saya ingin|saya butuh|saya merasa)\b'],
    };

    final patterns = statementPatterns[language] ?? statementPatterns['en']!;
    return patterns.any(
      (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(query),
    );
  }
}
