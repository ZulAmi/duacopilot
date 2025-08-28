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
        r'\b(صلاة|صلى|نماز|عبادة)\b',
        r'\b(فجر|ظهر|عصر|مغرب|عشاء)\b',
        r'\b(قيام|تهجد|وتر)\b',
        r'كيف أصلي',
        r'وقت الصلاة',
      ],
      QueryIntent.dua: [
        r'\b(دعاء|ادع|استغفار)\b',
        r'\b(من فضلك|ساعد|بارك|احم)\b',
        r'\b(اغفر|رحمة|هداية)\b',
        r'دعاء ل',
        r'ادع لي',
      ],
      QueryIntent.quran: [
        r'\b(قرآن|قرءان|كتاب الله)\b',
        r'\b(سورة|آية|تلاوة)\b',
        r'\b(حفظ|تجويد|تفسير)\b',
        r'يقول القرآن',
        r'في القرآن',
      ],
      QueryIntent.fasting: [
        r'\b(صوم|صيام|رمضان)\b',
        r'\b(إفطار|سحور|إمساك)\b',
        r'أحكام الصيام',
        r'كيفية الصوم',
      ],
    },
    'ur': {
      QueryIntent.prayer: [
        r'\b(نماز|صلاة|عبادت)\b',
        r'\b(فجر|ظہر|عصر|مغرب|عشاء)\b',
        r'\b(قیام|تہجد|وتر)\b',
        r'نماز کیسے پڑھیں',
        r'نماز کا وقت',
      ],
      QueryIntent.dua: [
        r'\b(دعا|التجا|منت)\b',
        r'\b(مہربانی|مدد|برکت|حفاظت)\b',
        r'\b(معافی|رحم|ہدایت)\b',
        r'دعا برائے',
        r'میرے لیے دعا',
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
      r'\b(الآن|فوراً|عاجل|اليوم)\b',
      r'\b(ابھی|فوری|آج|جلدی)\b',
      r'\b(sekarang|segera|hari ini|cepat)\b',
    ],
    'emotional_distress': [
      r'\b(worried|anxious|scared|desperate|helpless)\b',
      r'\b(قلق|خائف|يائس|عاجز)\b',
      r'\b(پریشان|خوف|مایوس|بےبس)\b',
      r'\b(khawatir|takut|putus asa|tidak berdaya)\b',
    ],
    'seeking_knowledge': [
      r'\b(what|how|why|when|where|explain|tell me)\b',
      r'\b(ما|كيف|لماذا|متى|أين|اشرح)\b',
      r'\b(کیا|کیسے|کیوں|کب|کہاں|بتائیں)\b',
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
    final topIntent = intentScores.entries.where((entry) => entry.value == maxScore).first.key;

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
            intentScores[QueryIntent.emergency] = (intentScores[QueryIntent.emergency] ?? 0) + 0.3;
            intentScores[QueryIntent.guidance] = (intentScores[QueryIntent.guidance] ?? 0) + 0.2;
            break;

          case 'emotional_distress':
            // Boost healing, protection, and guidance intents
            intentScores[QueryIntent.healing] = (intentScores[QueryIntent.healing] ?? 0) + 0.3;
            intentScores[QueryIntent.protection] = (intentScores[QueryIntent.protection] ?? 0) + 0.3;
            intentScores[QueryIntent.guidance] = (intentScores[QueryIntent.guidance] ?? 0) + 0.2;
            break;

          case 'seeking_knowledge':
            // Boost knowledge intent
            intentScores[QueryIntent.knowledge] = (intentScores[QueryIntent.knowledge] ?? 0) + 0.3;
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
    final significantScores = scores.values.where((score) => score > 0.3).length;
    return significantScores > 1;
  }

  /// Get the secondary intent if mixed intents are detected
  QueryIntent? getSecondaryIntent(Map<QueryIntent, double> scores) {
    final sortedScores = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

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
      'ar': [r'\b(ما|كيف|لماذا|متى|أين|من|هل|أين)\b', r'؟'],
      'ur': [r'\b(کیا|کیسے|کیوں|کب|کہاں|کون|کیا)\b', r'؟'],
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
      'ar': [r'\b(أنا|لدي|أريد|أحتاج|أشعر)\b'],
      'ur': [r'\b(میں|میرے پاس|مجھے چاہیے|میں محسوس)\b'],
      'id': [r'\b(saya|saya punya|saya ingin|saya butuh|saya merasa)\b'],
    };

    final patterns = statementPatterns[language] ?? statementPatterns['en']!;
    return patterns.any(
      (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(query),
    );
  }
}
