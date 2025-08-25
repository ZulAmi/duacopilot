import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';
import '../secure_storage/secure_storage_service.dart';

/// Enhanced emotion detection service for sophisticated Du'a matching
/// Uses advanced NLP techniques and Islamic context awareness
class EnhancedEmotionDetectionService {
  static EnhancedEmotionDetectionService? _instance;
  static EnhancedEmotionDetectionService get instance => _instance ??= EnhancedEmotionDetectionService._();

  EnhancedEmotionDetectionService._();

  // Core services
  late SecureStorageService _secureStorage;
  SharedPreferences? _prefs;

  // Configuration
  static const String _emotionHistoryKey = 'emotion_history';
  static const String _emotionPatternsKey = 'emotion_patterns';
  static const double _confidenceThreshold = 0.6;
  static const int _maxHistoryEntries = 500;

  // State management
  bool _isInitialized = false;
  final Map<String, EmotionalProfile> _userProfiles = {};
  final Map<String, List<EmotionalDetection>> _emotionHistory = {};

  // Advanced emotion detection models
  late Map<String, EmotionModel> _emotionModels;
  late Map<String, List<String>> _culturalExpressions;
  late Map<String, double> _contextWeights;

  // Stream controllers
  final _emotionDetectionController = StreamController<EmotionalDetection>.broadcast();
  final _emotionPatternController = StreamController<EmotionalPattern>.broadcast();

  // Public streams
  Stream<EmotionalDetection> get emotionDetectionStream => _emotionDetectionController.stream;
  Stream<EmotionalPattern> get emotionPatternStream => _emotionPatternController.stream;

  // Comprehensive emotion lexicon with cultural variations
  static const Map<EmotionalState, Map<String, List<String>>> _emotionLexicon = {
    EmotionalState.anxious: {
      'english': [
        'anxious',
        'worried',
        'nervous',
        'tense',
        'restless',
        'uneasy',
        'distressed',
        'troubled',
        'apprehensive',
        'fearful',
        'panicked',
        'stressed',
        'overwhelmed',
      ],
      'arabic': ['قلق', 'خائف', 'مضطرب', 'متوتر', 'مرتبك', 'مشدود', 'خوف', 'رهبة'],
      'urdu': ['پریشان', 'بے چین', 'گھبرایا', 'خوفزدہ', 'فکرمند', 'تشویش'],
      'contextual': ['can\'t sleep', 'heart racing', 'can\'t focus', 'feel sick', 'shaking', 'sweating'],
    },
    EmotionalState.grateful: {
      'english': [
        'grateful',
        'thankful',
        'blessed',
        'appreciate',
        'honored',
        'privileged',
        'fortunate',
        'indebted',
        'appreciative',
      ],
      'arabic': ['شاكر', 'ممتن', 'مبارك', 'محظوظ', 'نعمة', 'بركة', 'حمد'],
      'urdu': ['شکر گزار', 'ممنون', 'احسان مند', 'برکت', 'نعمت', 'خوش قسمت'],
      'contextual': ['alhamdulillah', 'thank allah', 'so blessed', 'allah\'s mercy', 'count blessings'],
    },
    EmotionalState.sad: {
      'english': [
        'sad',
        'depressed',
        'down',
        'melancholy',
        'heartbroken',
        'grief',
        'sorrow',
        'despair',
        'dejected',
        'gloomy',
        'miserable',
      ],
      'arabic': ['حزين', 'مكتئب', 'غم', 'أسى', 'كآبة', 'يأس', 'حسرة'],
      'urdu': ['اداس', 'غمگین', 'افسردہ', 'دکھی', 'رنجیدہ', 'پریشان'],
      'contextual': ['feel empty', 'lost someone', 'everything dark', 'no hope', 'crying'],
    },
    EmotionalState.uncertain: {
      'english': [
        'uncertain',
        'confused',
        'doubtful',
        'hesitant',
        'lost',
        'unclear',
        'puzzled',
        'bewildered',
        'perplexed',
        'conflicted',
      ],
      'arabic': ['محتار', 'متردد', 'مشكوك', 'غير متأكد', 'حائر', 'متضارب'],
      'urdu': ['شک', 'تذبذب', 'کنفیوزڈ', 'الجھن', 'بے یقینی'],
      'contextual': ['don\'t know what to do', 'which path', 'need guidance', 'torn between', 'can\'t decide'],
    },
    EmotionalState.seeking_guidance: {
      'english': ['guidance', 'help', 'direction', 'advice', 'support', 'assistance', 'counsel', 'wisdom', 'insight'],
      'arabic': ['هداية', 'إرشاد', 'نصح', 'مساعدة', 'دعم', 'توجيه', 'حكمة'],
      'urdu': ['ہدایت', 'رہنمائی', 'مدد', 'نصیحت', 'راہ', 'سپورٹ'],
      'contextual': ['need allah\'s help', 'show me the way', 'what should i do', 'pray for guidance', 'lost my way'],
    },
    EmotionalState.hopeful: {
      'english': ['hopeful', 'optimistic', 'positive', 'confident', 'expectant', 'encouraged', 'inspired', 'uplifted'],
      'arabic': ['متفائل', 'راجي', 'مأمول', 'واثق', 'مشجع', 'ملهم'],
      'urdu': ['امیدوار', 'مثبت', 'خوش امید', 'حوصلہ مند', 'متوقع'],
      'contextual': ['things will improve', 'allah will provide', 'trust in allah', 'better days', 'have faith'],
    },
    EmotionalState.worried: {
      'english': ['worried', 'concerned', 'troubled', 'apprehensive', 'anxious about', 'bothered', 'disturbed'],
      'arabic': ['مهموم', 'قلق', 'مضطرب', 'خائف من', 'مشغول البال'],
      'urdu': ['فکرمند', 'پریشان', 'بے چینی', 'تشویش', 'خدشہ'],
      'contextual': ['what if', 'scared that', 'worried about', 'concerned for', 'fear for'],
    },
    EmotionalState.excited: {
      'english': ['excited', 'thrilled', 'enthusiastic', 'elated', 'joyful', 'happy', 'delighted', 'ecstatic'],
      'arabic': ['متحمس', 'مبتهج', 'فرح', 'سعيد', 'مسرور', 'مرح'],
      'urdu': ['پرجوش', 'خوش', 'مسرور', 'خوشی', 'جوش', 'ولولہ'],
      'contextual': ['can\'t wait', 'so happy', 'amazing news', 'allah blessed', 'fantastic'],
    },
    EmotionalState.peaceful: {
      'english': ['peaceful', 'calm', 'serene', 'tranquil', 'relaxed', 'content', 'at ease', 'harmonious'],
      'arabic': ['هادئ', 'مطمئن', 'ساكن', 'راض', 'مرتاح', 'سلام'],
      'urdu': ['پُر سکون', 'اطمینان', 'سکون', 'آرام', 'راحت'],
      'contextual': ['feel at peace', 'allah\'s peace', 'heart calm', 'no worries', 'content'],
    },
    EmotionalState.fearful: {
      'english': ['fearful', 'scared', 'afraid', 'terrified', 'frightened', 'petrified', 'horrified'],
      'arabic': ['خائف', 'مذعور', 'مرعوب', 'فزع', 'هلع', 'رعب'],
      'urdu': ['خوفزدہ', 'ڈرا ہوا', 'خائف', 'دہشت زدہ', 'گھبرایا'],
      'contextual': ['so scared', 'afraid of', 'terrified', 'fear allah\'s punishment', 'nightmares'],
    },
  };

  // Islamic emotional expressions and phrases
  static const Map<String, EmotionalState> _islamicExpressions = {
    'alhamdulillah': EmotionalState.grateful,
    'subhanallah': EmotionalState.grateful,
    'mashallah': EmotionalState.grateful,
    'astaghfirullah': EmotionalState.worried,
    'inshallah': EmotionalState.hopeful,
    'la hawla wa la quwwata illa billah': EmotionalState.seeking_guidance,
    'allah yehdik': EmotionalState.seeking_guidance,
    'rabbi ishurni': EmotionalState.seeking_guidance,
    'hasbi allah': EmotionalState.peaceful,
    'allahu a\'lam': EmotionalState.uncertain,
  };

  // Contextual modifiers that affect emotion intensity
  static const Map<String, double> _intensityModifiers = {
    'very': 1.3,
    'extremely': 1.5,
    'really': 1.2,
    'so': 1.2,
    'totally': 1.4,
    'completely': 1.4,
    'little': 0.7,
    'somewhat': 0.8,
    'kind of': 0.7,
    'a bit': 0.6,
    'slightly': 0.6,
  };

  /// Initialize emotion detection service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Enhanced Emotion Detection Service...');

      _secureStorage = SecureStorageService.instance;
      _prefs = await SharedPreferences.getInstance();

      // Initialize emotion models
      await _initializeEmotionModels();

      // Load cultural expressions
      await _loadCulturalExpressions();

      // Initialize context weights
      _initializeContextWeights();

      // Load user emotion history
      await _loadEmotionHistory();

      _isInitialized = true;
      AppLogger.info('Enhanced Emotion Detection Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Enhanced Emotion Detection Service: $e');
      throw Exception('Emotion detection service initialization failed');
    }
  }

  /// Detect emotions from text with advanced analysis
  Future<EmotionalDetection> detectEmotion({
    required String text,
    required String userId,
    String? language,
    Map<String, dynamic>? context,
  }) async {
    await _ensureInitialized();

    try {
      final processedText = _preprocessText(text, language);
      final detectedLanguage = language ?? await _detectLanguage(text);

      // Multi-model emotion analysis
      final lexicalEmotion = _detectLexicalEmotion(processedText, detectedLanguage);
      final contextualEmotion = _detectContextualEmotion(processedText, context);
      final islamicEmotion = _detectIslamicEmotion(processedText);
      final historicalEmotion = _getHistoricalEmotionBias(userId);

      // Combine detection results with weighted scoring
      final combinedResult = _combineEmotionResults([
        lexicalEmotion,
        contextualEmotion,
        islamicEmotion,
        historicalEmotion,
      ]);

      // Apply intensity modifiers
      final intensityScore = _calculateIntensityScore(processedText);
      final adjustedConfidence = (combinedResult.confidence * intensityScore).clamp(0.0, 1.0);

      final detection = EmotionalDetection(
        id: 'emotion_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        inputText: text,
        detectedEmotion: combinedResult.emotion,
        confidence: adjustedConfidence,
        detectedLanguage: detectedLanguage,
        timestamp: DateTime.now(),
        analysisMetadata: {
          'lexical_confidence': lexicalEmotion.confidence,
          'contextual_confidence': contextualEmotion.confidence,
          'islamic_confidence': islamicEmotion.confidence,
          'intensity_multiplier': intensityScore,
          'text_length': text.length,
          'detected_language': detectedLanguage,
          'islamic_expressions': _findIslamicExpressions(processedText),
        },
      );

      // Update user emotion history
      await _updateEmotionHistory(userId, detection);

      // Analyze patterns
      await _analyzeEmotionPatterns(userId);

      // Notify listeners
      _emotionDetectionController.add(detection);

      return detection;
    } catch (e) {
      AppLogger.error('Failed to detect emotion: $e');

      // Return neutral emotion as fallback
      return EmotionalDetection(
        id: 'emotion_fallback_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        inputText: text,
        detectedEmotion: EmotionalState.neutral,
        confidence: 0.5,
        detectedLanguage: language ?? 'en',
        timestamp: DateTime.now(),
        analysisMetadata: {'error': e.toString()},
      );
    }
  }

  /// Get appropriate Du'as for detected emotion
  Future<List<String>> getEmotionalDuaRecommendations({
    required EmotionalState emotion,
    required double confidence,
    String? culturalContext,
  }) async {
    await _ensureInitialized();

    final recommendations = <String>[];

    // Base Du'as for each emotional state
    switch (emotion) {
      case EmotionalState.anxious:
        recommendations.addAll([
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
          'اللَّهُمَّ أَصْلِحْ لِي دِينِي الَّذِي هُوَ عِصْمَةُ أَمْرِي',
        ]);
        break;
      case EmotionalState.grateful:
        recommendations.addAll([
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ',
          'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
        ]);
        break;
      case EmotionalState.sad:
        recommendations.addAll([
          'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
          'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
          'وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
        ]);
        break;
      case EmotionalState.seeking_guidance:
        recommendations.addAll([
          'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
          'اللَّهُمَّ أَرِنِي الْحَقَّ حَقًّا وَارْزُقْنِي اتِّبَاعَهُ',
          'رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
        ]);
        break;
      case EmotionalState.hopeful:
        recommendations.addAll([
          'وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
          'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
          'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا',
        ]);
        break;
      default:
        recommendations.addAll([
          'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
        ]);
    }

    // Add cultural context if available
    if (culturalContext != null) {
      final culturalDuas = await _getCulturalDuaRecommendations(emotion, culturalContext);
      recommendations.addAll(culturalDuas);
    }

    return recommendations.take(3).toList();
  }

  /// Get user's emotional profile
  Future<EmotionalProfile?> getUserEmotionalProfile(String userId) async {
    await _ensureInitialized();
    return _userProfiles[userId];
  }

  /// Get emotion history for user
  Future<List<EmotionalDetection>> getEmotionHistory(String userId, {int limit = 50}) async {
    await _ensureInitialized();
    final history = _emotionHistory[userId] ?? [];
    return history.reversed.take(limit).toList();
  }

  // Private helper methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _initializeEmotionModels() async {
    _emotionModels = {};

    // Initialize basic models for each emotion
    for (final emotion in EmotionalState.values) {
      _emotionModels[emotion.name] = EmotionModel(
        emotion: emotion,
        keywords: _emotionLexicon[emotion] ?? {},
        confidence: 0.0,
      );
    }
  }

  Future<void> _loadCulturalExpressions() async {
    _culturalExpressions = {
      'islamic': _islamicExpressions.keys.toList(),
      'arabic': _emotionLexicon.values.expand((lang) => lang['arabic'] ?? <String>[]).cast<String>().toList(),
      'urdu': _emotionLexicon.values.expand((lang) => lang['urdu'] ?? <String>[]).cast<String>().toList(),
    };
  }

  void _initializeContextWeights() {
    _contextWeights = {'lexical': 0.4, 'contextual': 0.3, 'islamic': 0.2, 'historical': 0.1};
  }

  Future<void> _loadEmotionHistory() async {
    try {
      final historyJson = _prefs?.getString(_emotionHistoryKey);
      if (historyJson != null) {
        final data = jsonDecode(historyJson) as Map<String, dynamic>;
        data.forEach((userId, history) {
          _emotionHistory[userId] =
              (history as List<dynamic>).map((item) => EmotionalDetection.fromJson(item)).toList();
        });
      }
    } catch (e) {
      AppLogger.warning('Failed to load emotion history: $e');
    }
  }

  String _preprocessText(String text, String? language) {
    var processed = text.toLowerCase().trim();

    // Remove extra whitespace
    processed = processed.replaceAll(RegExp(r'\s+'), ' ');

    // Handle Arabic/Urdu text preprocessing
    if (language == 'ar' || language == 'ur') {
      // Remove diacritics
      processed = processed.replaceAll(RegExp(r'[\u064B-\u0652]'), '');
    }

    return processed;
  }

  Future<String> _detectLanguage(String text) async {
    // Simple language detection
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return 'ar'; // Arabic/Urdu script
    }
    return 'en'; // Default to English
  }

  EmotionResult _detectLexicalEmotion(String text, String language) {
    final emotionScores = <EmotionalState, double>{};

    for (final emotion in EmotionalState.values) {
      final keywords = _emotionLexicon[emotion] ?? {};
      double score = 0.0;

      // Check English keywords
      final englishKeywords = keywords['english'] ?? [];
      for (final keyword in englishKeywords) {
        if (text.contains(keyword)) {
          score += 1.0;
        }
      }

      // Check language-specific keywords
      if (language == 'ar') {
        final arabicKeywords = keywords['arabic'] ?? [];
        for (final keyword in arabicKeywords) {
          if (text.contains(keyword)) {
            score += 1.2; // Higher weight for native language
          }
        }
      } else if (language == 'ur') {
        final urduKeywords = keywords['urdu'] ?? [];
        for (final keyword in urduKeywords) {
          if (text.contains(keyword)) {
            score += 1.2;
          }
        }
      }

      // Check contextual expressions
      final contextualKeywords = keywords['contextual'] ?? [];
      for (final keyword in contextualKeywords) {
        if (text.contains(keyword)) {
          score += 0.8;
        }
      }

      if (score > 0) {
        emotionScores[emotion] = score;
      }
    }

    if (emotionScores.isEmpty) {
      return EmotionResult(EmotionalState.neutral, 0.5);
    }

    final topEmotion = emotionScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    final confidence = (topEmotion.value / (text.split(' ').length + 1)).clamp(0.0, 1.0);
    return EmotionResult(topEmotion.key, confidence);
  }

  EmotionResult _detectContextualEmotion(String text, Map<String, dynamic>? context) {
    if (context == null) {
      return EmotionResult(EmotionalState.neutral, 0.0);
    }

    // Analyze context for emotional indicators
    double anxietyScore = 0.0;
    double gratitudeScore = 0.0;
    double sadnessScore = 0.0;

    // Time-based context
    final timeOfDay = context['time_of_day'] as String?;
    if (timeOfDay == 'night' || timeOfDay == 'late') {
      anxietyScore += 0.2; // Late night often indicates worry
    }

    // Situation context
    final situation = context['situation'] as String?;
    if (situation != null) {
      if (situation.contains('work') || situation.contains('exam')) {
        anxietyScore += 0.3;
      } else if (situation.contains('family') || situation.contains('celebration')) {
        gratitudeScore += 0.3;
      }
    }

    // Determine dominant contextual emotion
    final scores = {
      EmotionalState.anxious: anxietyScore,
      EmotionalState.grateful: gratitudeScore,
      EmotionalState.sad: sadnessScore,
    };

    final maxEntry = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    return EmotionResult(maxEntry.key, maxEntry.value);
  }

  EmotionResult _detectIslamicEmotion(String text) {
    double totalScore = 0.0;
    final emotionScores = <EmotionalState, double>{};

    // Check for Islamic expressions
    for (final expression in _islamicExpressions.keys) {
      if (text.contains(expression)) {
        final emotion = _islamicExpressions[expression]!;
        emotionScores[emotion] = (emotionScores[emotion] ?? 0.0) + 1.0;
        totalScore += 1.0;
      }
    }

    if (totalScore == 0) {
      return EmotionResult(EmotionalState.neutral, 0.0);
    }

    final topEmotion = emotionScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    return EmotionResult(topEmotion.key, (topEmotion.value / totalScore).clamp(0.0, 1.0));
  }

  EmotionResult _getHistoricalEmotionBias(String userId) {
    final history = _emotionHistory[userId];
    if (history == null || history.isEmpty) {
      return EmotionResult(EmotionalState.neutral, 0.0);
    }

    // Get recent emotions (last 10)
    final recentEmotions = history.take(10).toList();
    final emotionCounts = <EmotionalState, int>{};

    for (final detection in recentEmotions) {
      emotionCounts[detection.detectedEmotion] = (emotionCounts[detection.detectedEmotion] ?? 0) + 1;
    }

    if (emotionCounts.isEmpty) {
      return EmotionResult(EmotionalState.neutral, 0.0);
    }

    final mostFrequent = emotionCounts.entries.reduce((a, b) => a.value > b.value ? a : b);

    final confidence = (mostFrequent.value / recentEmotions.length) * 0.3;
    return EmotionResult(mostFrequent.key, confidence);
  }

  EmotionResult _combineEmotionResults(List<EmotionResult> results) {
    final weightedScores = <EmotionalState, double>{};
    final weights = [
      _contextWeights['lexical']!,
      _contextWeights['contextual']!,
      _contextWeights['islamic']!,
      _contextWeights['historical']!,
    ];

    for (int i = 0; i < results.length && i < weights.length; i++) {
      final result = results[i];
      final weight = weights[i];

      weightedScores[result.emotion] = (weightedScores[result.emotion] ?? 0.0) + (result.confidence * weight);
    }

    if (weightedScores.isEmpty) {
      return EmotionResult(EmotionalState.neutral, 0.5);
    }

    final topEmotion = weightedScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    return EmotionResult(topEmotion.key, topEmotion.value.clamp(0.0, 1.0));
  }

  double _calculateIntensityScore(String text) {
    double intensity = 1.0;

    // Check for intensity modifiers
    for (final modifier in _intensityModifiers.keys) {
      if (text.contains(modifier)) {
        intensity *= _intensityModifiers[modifier]!;
      }
    }

    // Check for repeated punctuation (!!!, ???)
    final exclamationCount = RegExp(r'!').allMatches(text).length;
    if (exclamationCount > 1) {
      intensity *= 1.2;
    }

    // Check for capital letters (intensity indicator)
    final capitalRatio = text.split('').where((c) => c == c.toUpperCase()).length / text.length;
    if (capitalRatio > 0.3) {
      intensity *= 1.1;
    }

    return intensity.clamp(0.5, 2.0);
  }

  List<String> _findIslamicExpressions(String text) {
    return _islamicExpressions.keys.where((expr) => text.contains(expr)).toList();
  }

  Future<void> _updateEmotionHistory(String userId, EmotionalDetection detection) async {
    _emotionHistory.putIfAbsent(userId, () => []).insert(0, detection);

    // Limit history size
    if (_emotionHistory[userId]!.length > _maxHistoryEntries) {
      _emotionHistory[userId]!.removeRange(_maxHistoryEntries, _emotionHistory[userId]!.length);
    }

    await _saveEmotionHistory();
  }

  Future<void> _saveEmotionHistory() async {
    try {
      final historyData = <String, dynamic>{};
      _emotionHistory.forEach((userId, history) {
        historyData[userId] = history.map((detection) => detection.toJson()).toList();
      });

      await _prefs?.setString(_emotionHistoryKey, jsonEncode(historyData));
    } catch (e) {
      AppLogger.error('Failed to save emotion history: $e');
    }
  }

  Future<void> _analyzeEmotionPatterns(String userId) async {
    final history = _emotionHistory[userId];
    if (history == null || history.length < 10) return;

    // Analyze patterns and update user profile
    final patterns = _identifyEmotionalPatterns(history);
    _userProfiles[userId] = EmotionalProfile(
      userId: userId,
      dominantEmotions: patterns.dominantEmotions,
      emotionalStability: patterns.stability,
      culturalContext: patterns.culturalContext,
      lastUpdated: DateTime.now(),
    );

    _emotionPatternController.add(patterns);
  }

  EmotionalPattern _identifyEmotionalPatterns(List<EmotionalDetection> history) {
    final emotionCounts = <EmotionalState, int>{};
    final emotionConfidences = <EmotionalState, List<double>>{};

    for (final detection in history) {
      emotionCounts[detection.detectedEmotion] = (emotionCounts[detection.detectedEmotion] ?? 0) + 1;
      emotionConfidences.putIfAbsent(detection.detectedEmotion, () => []).add(detection.confidence);
    }

    // Calculate dominant emotions
    final sortedEmotions = emotionCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final dominantEmotions = sortedEmotions.take(3).map((entry) => entry.key).toList();

    // Calculate stability (variance in emotions)
    final stability = _calculateEmotionalStability(emotionCounts, history.length);

    return EmotionalPattern(
      userId: history.first.userId,
      dominantEmotions: dominantEmotions,
      stability: stability,
      culturalContext: 'general', // Would be enhanced with actual cultural analysis
      patternStrength: sortedEmotions.first.value / history.length,
      analysisDate: DateTime.now(),
    );
  }

  double _calculateEmotionalStability(Map<EmotionalState, int> emotionCounts, int totalCount) {
    if (emotionCounts.length <= 1) return 1.0;

    final mean = totalCount / emotionCounts.length;
    final variance =
        emotionCounts.values.map((count) => pow(count - mean, 2)).reduce((a, b) => a + b) / emotionCounts.length;

    // Convert variance to stability score (0-1, higher = more stable)
    return (1.0 / (1.0 + variance / mean)).clamp(0.0, 1.0);
  }

  Future<List<String>> _getCulturalDuaRecommendations(EmotionalState emotion, String culturalContext) async {
    // This would be enhanced with actual cultural Du'a database
    return ['Cultural Du\'a recommendation for $culturalContext context'];
  }

  /// Cleanup resources
  void dispose() {
    _emotionDetectionController.close();
    _emotionPatternController.close();
  }
}

// Supporting classes and models

class EmotionResult {
  final EmotionalState emotion;
  final double confidence;

  EmotionResult(this.emotion, this.confidence);
}

class EmotionModel {
  final EmotionalState emotion;
  final Map<String, List<String>> keywords;
  final double confidence;

  EmotionModel({required this.emotion, required this.keywords, required this.confidence});
}

class EmotionalDetection {
  final String id;
  final String userId;
  final String inputText;
  final EmotionalState detectedEmotion;
  final double confidence;
  final String detectedLanguage;
  final DateTime timestamp;
  final Map<String, dynamic> analysisMetadata;

  EmotionalDetection({
    required this.id,
    required this.userId,
    required this.inputText,
    required this.detectedEmotion,
    required this.confidence,
    required this.detectedLanguage,
    required this.timestamp,
    required this.analysisMetadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'inputText': inputText,
      'detectedEmotion': detectedEmotion.name,
      'confidence': confidence,
      'detectedLanguage': detectedLanguage,
      'timestamp': timestamp.toIso8601String(),
      'analysisMetadata': analysisMetadata,
    };
  }

  factory EmotionalDetection.fromJson(Map<String, dynamic> json) {
    return EmotionalDetection(
      id: json['id'],
      userId: json['userId'],
      inputText: json['inputText'],
      detectedEmotion: EmotionalState.values.byName(json['detectedEmotion']),
      confidence: json['confidence'].toDouble(),
      detectedLanguage: json['detectedLanguage'],
      timestamp: DateTime.parse(json['timestamp']),
      analysisMetadata: json['analysisMetadata'] ?? {},
    );
  }
}

class EmotionalPattern {
  final String userId;
  final List<EmotionalState> dominantEmotions;
  final double stability;
  final String culturalContext;
  final double patternStrength;
  final DateTime analysisDate;

  EmotionalPattern({
    required this.userId,
    required this.dominantEmotions,
    required this.stability,
    required this.culturalContext,
    required this.patternStrength,
    required this.analysisDate,
  });
}

class EmotionalProfile {
  final String userId;
  final List<EmotionalState> dominantEmotions;
  final double emotionalStability;
  final String culturalContext;
  final DateTime lastUpdated;

  EmotionalProfile({
    required this.userId,
    required this.dominantEmotions,
    required this.emotionalStability,
    required this.culturalContext,
    required this.lastUpdated,
  });
}
