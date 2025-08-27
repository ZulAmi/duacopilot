import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';

/// Enhanced emotion detection service for sophisticated Du'a matching
/// Uses advanced NLP techniques and Islamic context awareness
class EnhancedEmotionDetectionService {
  static EnhancedEmotionDetectionService? _instance;
  static EnhancedEmotionDetectionService get instance =>
      _instance ??= EnhancedEmotionDetectionService._();

  EnhancedEmotionDetectionService._();

  // Core services
  SharedPreferences? _prefs;

  // Configuration
  static const String _emotionHistoryKey = 'emotion_history';
  static const int _maxHistoryEntries = 500;

  // State management
  bool _isInitialized = false;
  final Map<String, EmotionalProfile> _userProfiles = {};
  final Map<String, List<EmotionalDetection>> _emotionHistory = {};

  // Advanced emotion detection models
  late Map<String, EmotionModel> _emotionModels;
  late Map<String, double> _contextWeights;

  // Stream controllers
  final _emotionDetectionController =
      StreamController<EmotionalDetection>.broadcast();
  final _emotionPatternController =
      StreamController<EmotionalPattern>.broadcast();

  // Public streams
  Stream<EmotionalDetection> get emotionDetectionStream =>
      _emotionDetectionController.stream;
  Stream<EmotionalPattern> get emotionPatternStream =>
      _emotionPatternController.stream;

  // Comprehensive emotion lexicon with cultural variations
  static const Map<EmotionalState, Map<String, List<String>>> _emotionLexicon =
      {
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
      'arabic': [
        'Ù‚Ù„Ù‚',
        'Ø®Ø§Ø¦Ù',
        'Ù…Ø¶Ø·Ø±Ø¨',
        'Ù…ØªÙˆØªØ±',
        'Ù…Ø±ØªØ¨Ùƒ',
        'Ù…Ø´Ø¯ÙˆØ¯',
        'Ø®ÙˆÙ',
        'Ø±Ù‡Ø¨Ø©'
      ],
      'urdu': [
        'Ù¾Ø±ÛŒØ´Ø§Ù†',
        'Ø¨Û’ Ú†ÛŒÙ†',
        'Ú¯Ú¾Ø¨Ø±Ø§ÛŒØ§',
        'Ø®ÙˆÙØ²Ø¯Û',
        'ÙÚ©Ø±Ù…Ù†Ø¯',
        'ØªØ´ÙˆÛŒØ´'
      ],
      'contextual': [
        'can\'t sleep',
        'heart racing',
        'can\'t focus',
        'feel sick',
        'shaking',
        'sweating'
      ],
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
      'arabic': [
        'Ø´Ø§ÙƒØ±',
        'Ù…Ù…ØªÙ†',
        'Ù…Ø¨Ø§Ø±Ùƒ',
        'Ù…Ø­Ø¸ÙˆØ¸',
        'Ù†Ø¹Ù…Ø©',
        'Ø¨Ø±ÙƒØ©',
        'Ø­Ù…Ø¯'
      ],
      'urdu': [
        'Ø´Ú©Ø± Ú¯Ø²Ø§Ø±',
        'Ù…Ù…Ù†ÙˆÙ†',
        'Ø§Ø­Ø³Ø§Ù† Ù…Ù†Ø¯',
        'Ø¨Ø±Ú©Øª',
        'Ù†Ø¹Ù…Øª',
        'Ø®ÙˆØ´ Ù‚Ø³Ù…Øª'
      ],
      'contextual': [
        'alhamdulillah',
        'thank allah',
        'so blessed',
        'allah\'s mercy',
        'count blessings'
      ],
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
      'arabic': [
        'Ø­Ø²ÙŠÙ†',
        'Ù…ÙƒØªØ¦Ø¨',
        'ØºÙ…',
        'Ø£Ø³Ù‰',
        'ÙƒØ¢Ø¨Ø©',
        'ÙŠØ£Ø³',
        'Ø­Ø³Ø±Ø©'
      ],
      'urdu': [
        'Ø§Ø¯Ø§Ø³',
        'ØºÙ…Ú¯ÛŒÙ†',
        'Ø§ÙØ³Ø±Ø¯Û',
        'Ø¯Ú©Ú¾ÛŒ',
        'Ø±Ù†Ø¬ÛŒØ¯Û',
        'Ù¾Ø±ÛŒØ´Ø§Ù†'
      ],
      'contextual': [
        'feel empty',
        'lost someone',
        'everything dark',
        'no hope',
        'crying'
      ],
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
      'arabic': [
        'Ù…Ø­ØªØ§Ø±',
        'Ù…ØªØ±Ø¯Ø¯',
        'Ù…Ø´ÙƒÙˆÙƒ',
        'ØºÙŠØ± Ù…ØªØ£ÙƒØ¯',
        'Ø­Ø§Ø¦Ø±',
        'Ù…ØªØ¶Ø§Ø±Ø¨'
      ],
      'urdu': [
        'Ø´Ú©',
        'ØªØ°Ø¨Ø°Ø¨',
        'Ú©Ù†ÙÛŒÙˆØ²Úˆ',
        'Ø§Ù„Ø¬Ú¾Ù†',
        'Ø¨Û’ ÛŒÙ‚ÛŒÙ†ÛŒ'
      ],
      'contextual': [
        'don\'t know what to do',
        'which path',
        'need guidance',
        'torn between',
        'can\'t decide'
      ],
    },
    EmotionalState.seekingGuidance: {
      'english': [
        'guidance',
        'help',
        'direction',
        'advice',
        'support',
        'assistance',
        'counsel',
        'wisdom',
        'insight'
      ],
      'arabic': [
        'Ù‡Ø¯Ø§ÙŠØ©',
        'Ø¥Ø±Ø´Ø§Ø¯',
        'Ù†ØµØ­',
        'Ù…Ø³Ø§Ø¹Ø¯Ø©',
        'Ø¯Ø¹Ù…',
        'ØªÙˆØ¬ÙŠÙ‡',
        'Ø­ÙƒÙ…Ø©'
      ],
      'urdu': [
        'ÛØ¯Ø§ÛŒØª',
        'Ø±ÛÙ†Ù…Ø§Ø¦ÛŒ',
        'Ù…Ø¯Ø¯',
        'Ù†ØµÛŒØ­Øª',
        'Ø±Ø§Û',
        'Ø³Ù¾ÙˆØ±Ù¹'
      ],
      'contextual': [
        'need allah\'s help',
        'show me the way',
        'what should i do',
        'pray for guidance',
        'lost my way'
      ],
    },
    EmotionalState.hopeful: {
      'english': [
        'hopeful',
        'optimistic',
        'positive',
        'confident',
        'expectant',
        'encouraged',
        'inspired',
        'uplifted'
      ],
      'arabic': [
        'Ù…ØªÙØ§Ø¦Ù„',
        'Ø±Ø§Ø¬ÙŠ',
        'Ù…Ø£Ù…ÙˆÙ„',
        'ÙˆØ§Ø«Ù‚',
        'Ù…Ø´Ø¬Ø¹',
        'Ù…Ù„Ù‡Ù…'
      ],
      'urdu': [
        'Ø§Ù…ÛŒØ¯ÙˆØ§Ø±',
        'Ù…Ø«Ø¨Øª',
        'Ø®ÙˆØ´ Ø§Ù…ÛŒØ¯',
        'Ø­ÙˆØµÙ„Û Ù…Ù†Ø¯',
        'Ù…ØªÙˆÙ‚Ø¹'
      ],
      'contextual': [
        'things will improve',
        'allah will provide',
        'trust in allah',
        'better days',
        'have faith'
      ],
    },
    EmotionalState.worried: {
      'english': [
        'worried',
        'concerned',
        'troubled',
        'apprehensive',
        'anxious about',
        'bothered',
        'disturbed'
      ],
      'arabic': [
        'Ù…Ù‡Ù…ÙˆÙ…',
        'Ù‚Ù„Ù‚',
        'Ù…Ø¶Ø·Ø±Ø¨',
        'Ø®Ø§Ø¦Ù Ù…Ù†',
        'Ù…Ø´ØºÙˆÙ„ Ø§Ù„Ø¨Ø§Ù„'
      ],
      'urdu': [
        'ÙÚ©Ø±Ù…Ù†Ø¯',
        'Ù¾Ø±ÛŒØ´Ø§Ù†',
        'Ø¨Û’ Ú†ÛŒÙ†ÛŒ',
        'ØªØ´ÙˆÛŒØ´',
        'Ø®Ø¯Ø´Û'
      ],
      'contextual': [
        'what if',
        'scared that',
        'worried about',
        'concerned for',
        'fear for'
      ],
    },
    EmotionalState.excited: {
      'english': [
        'excited',
        'thrilled',
        'enthusiastic',
        'elated',
        'joyful',
        'happy',
        'delighted',
        'ecstatic'
      ],
      'arabic': [
        'Ù…ØªØ­Ù…Ø³',
        'Ù…Ø¨ØªÙ‡Ø¬',
        'ÙØ±Ø­',
        'Ø³Ø¹ÙŠØ¯',
        'Ù…Ø³Ø±ÙˆØ±',
        'Ù…Ø±Ø­'
      ],
      'urdu': [
        'Ù¾Ø±Ø¬ÙˆØ´',
        'Ø®ÙˆØ´',
        'Ù…Ø³Ø±ÙˆØ±',
        'Ø®ÙˆØ´ÛŒ',
        'Ø¬ÙˆØ´',
        'ÙˆÙ„ÙˆÙ„Û'
      ],
      'contextual': [
        'can\'t wait',
        'so happy',
        'amazing news',
        'allah blessed',
        'fantastic'
      ],
    },
    EmotionalState.peaceful: {
      'english': [
        'peaceful',
        'calm',
        'serene',
        'tranquil',
        'relaxed',
        'content',
        'at ease',
        'harmonious'
      ],
      'arabic': [
        'Ù‡Ø§Ø¯Ø¦',
        'Ù…Ø·Ù…Ø¦Ù†',
        'Ø³Ø§ÙƒÙ†',
        'Ø±Ø§Ø¶',
        'Ù…Ø±ØªØ§Ø­',
        'Ø³Ù„Ø§Ù…'
      ],
      'urdu': [
        'Ù¾ÙØ± Ø³Ú©ÙˆÙ†',
        'Ø§Ø·Ù…ÛŒÙ†Ø§Ù†',
        'Ø³Ú©ÙˆÙ†',
        'Ø¢Ø±Ø§Ù…',
        'Ø±Ø§Ø­Øª'
      ],
      'contextual': [
        'feel at peace',
        'allah\'s peace',
        'heart calm',
        'no worries',
        'content'
      ],
    },
    EmotionalState.fearful: {
      'english': [
        'fearful',
        'scared',
        'afraid',
        'terrified',
        'frightened',
        'petrified',
        'horrified'
      ],
      'arabic': [
        'Ø®Ø§Ø¦Ù',
        'Ù…Ø°Ø¹ÙˆØ±',
        'Ù…Ø±Ø¹ÙˆØ¨',
        'ÙØ²Ø¹',
        'Ù‡Ù„Ø¹',
        'Ø±Ø¹Ø¨'
      ],
      'urdu': [
        'Ø®ÙˆÙØ²Ø¯Û',
        'ÚˆØ±Ø§ ÛÙˆØ§',
        'Ø®Ø§Ø¦Ù',
        'Ø¯ÛØ´Øª Ø²Ø¯Û',
        'Ú¯Ú¾Ø¨Ø±Ø§ÛŒØ§'
      ],
      'contextual': [
        'so scared',
        'afraid of',
        'terrified',
        'fear allah\'s punishment',
        'nightmares'
      ],
    },
  };

  // Islamic emotional expressions and phrases
  static const Map<String, EmotionalState> _islamicExpressions = {
    'alhamdulillah': EmotionalState.grateful,
    'subhanallah': EmotionalState.grateful,
    'mashallah': EmotionalState.grateful,
    'astaghfirullah': EmotionalState.worried,
    'inshallah': EmotionalState.hopeful,
    'la hawla wa la quwwata illa billah': EmotionalState.seekingGuidance,
    'allah yehdik': EmotionalState.seekingGuidance,
    'rabbi ishurni': EmotionalState.seekingGuidance,
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

      _prefs = await SharedPreferences.getInstance();

      // Initialize emotion models
      await _initializeEmotionModels();

      // Initialize context weights
      _initializeContextWeights();

      // Load user emotion history
      await _loadEmotionHistory();

      _isInitialized = true;
      AppLogger.info(
          'Enhanced Emotion Detection Service initialized successfully');
    } catch (e) {
      AppLogger.error(
          'Failed to initialize Enhanced Emotion Detection Service: $e');
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
      final lexicalEmotion =
          _detectLexicalEmotion(processedText, detectedLanguage);
      final contextualEmotion =
          _detectContextualEmotion(processedText, context);
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
      final adjustedConfidence =
          (combinedResult.confidence * intensityScore).clamp(0.0, 1.0);

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
          'Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ø¢ØªÙÙ†ÙŽØ§ ÙÙÙŠ Ø§Ù„Ø¯ÙÙ‘Ù†Ù’ÙŠÙŽØ§ Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙÙÙŠ Ø§Ù„Ù’Ø¢Ø®ÙØ±ÙŽØ©Ù Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙ‚ÙÙ†ÙŽØ§ Ø¹ÙŽØ°ÙŽØ§Ø¨ÙŽ Ø§Ù„Ù†ÙŽÙ‘Ø§Ø±Ù',
          'Ø­ÙŽØ³Ù’Ø¨ÙÙ†ÙŽØ§ Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù ÙˆÙŽÙ†ÙØ¹Ù’Ù…ÙŽ Ø§Ù„Ù’ÙˆÙŽÙƒÙÙŠÙ„Ù',
          'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø£ÙŽØµÙ’Ù„ÙØ­Ù’ Ù„ÙÙŠ Ø¯ÙÙŠÙ†ÙÙŠ Ø§Ù„ÙŽÙ‘Ø°ÙÙŠ Ù‡ÙÙˆÙŽ Ø¹ÙØµÙ’Ù…ÙŽØ©Ù Ø£ÙŽÙ…Ù’Ø±ÙÙŠ',
        ]);
        break;
      case EmotionalState.grateful:
        recommendations.addAll([
          'Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ù„ÙÙ„ÙŽÙ‘Ù‡Ù Ø±ÙŽØ¨ÙÙ‘ Ø§Ù„Ù’Ø¹ÙŽØ§Ù„ÙŽÙ…ÙÙŠÙ†ÙŽ',
          'Ø±ÙŽØ¨ÙÙ‘ Ø£ÙŽÙˆÙ’Ø²ÙØ¹Ù’Ù†ÙÙŠ Ø£ÙŽÙ†Ù’ Ø£ÙŽØ´Ù’ÙƒÙØ±ÙŽ Ù†ÙØ¹Ù’Ù…ÙŽØªÙŽÙƒÙŽ',
          'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø£ÙŽØ¹ÙÙ†ÙÙ‘ÙŠ Ø¹ÙŽÙ„ÙŽÙ‰ Ø°ÙÙƒÙ’Ø±ÙÙƒÙŽ ÙˆÙŽØ´ÙÙƒÙ’Ø±ÙÙƒÙŽ ÙˆÙŽØ­ÙØ³Ù’Ù†Ù Ø¹ÙØ¨ÙŽØ§Ø¯ÙŽØªÙÙƒÙŽ',
        ]);
        break;
      case EmotionalState.sad:
        recommendations.addAll([
          'Ù„ÙŽØ§ Ø¥ÙÙ„ÙŽÙ‡ÙŽ Ø¥ÙÙ„ÙŽÙ‘Ø§ Ø£ÙŽÙ†Ù’ØªÙŽ Ø³ÙØ¨Ù’Ø­ÙŽØ§Ù†ÙŽÙƒÙŽ Ø¥ÙÙ†ÙÙ‘ÙŠ ÙƒÙÙ†Ù’ØªÙ Ù…ÙÙ†ÙŽ Ø§Ù„Ø¸ÙŽÙ‘Ø§Ù„ÙÙ…ÙÙŠÙ†ÙŽ',
          'Ø±ÙŽØ¨ÙÙ‘ Ø§Ø´Ù’Ø±ÙŽØ­Ù’ Ù„ÙÙŠ ØµÙŽØ¯Ù’Ø±ÙÙŠ ÙˆÙŽÙŠÙŽØ³ÙÙ‘Ø±Ù’ Ù„ÙÙŠ Ø£ÙŽÙ…Ù’Ø±ÙÙŠ',
          'ÙˆÙŽÙ…ÙŽÙ†Ù’ ÙŠÙŽØªÙŽÙˆÙŽÙƒÙŽÙ‘Ù„Ù’ Ø¹ÙŽÙ„ÙŽÙ‰ Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù ÙÙŽÙ‡ÙÙˆÙŽ Ø­ÙŽØ³Ù’Ø¨ÙÙ‡Ù',
        ]);
        break;
      case EmotionalState.seekingGuidance:
        recommendations.addAll([
          'Ø±ÙŽØ¨ÙÙ‘ Ø§Ø´Ù’Ø±ÙŽØ­Ù’ Ù„ÙÙŠ ØµÙŽØ¯Ù’Ø±ÙÙŠ ÙˆÙŽÙŠÙŽØ³ÙÙ‘Ø±Ù’ Ù„ÙÙŠ Ø£ÙŽÙ…Ù’Ø±ÙÙŠ',
          'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø£ÙŽØ±ÙÙ†ÙÙŠ Ø§Ù„Ù’Ø­ÙŽÙ‚ÙŽÙ‘ Ø­ÙŽÙ‚Ù‹Ù‘Ø§ ÙˆÙŽØ§Ø±Ù’Ø²ÙÙ‚Ù’Ù†ÙÙŠ Ø§ØªÙÙ‘Ø¨ÙŽØ§Ø¹ÙŽÙ‡Ù',
          'Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ø¢ØªÙÙ†ÙŽØ§ Ù…ÙÙ†Ù’ Ù„ÙŽØ¯ÙÙ†Ù’ÙƒÙŽ Ø±ÙŽØ­Ù’Ù…ÙŽØ©Ù‹ ÙˆÙŽÙ‡ÙŽÙŠÙÙ‘Ø¦Ù’ Ù„ÙŽÙ†ÙŽØ§ Ù…ÙÙ†Ù’ Ø£ÙŽÙ…Ù’Ø±ÙÙ†ÙŽØ§ Ø±ÙŽØ´ÙŽØ¯Ù‹Ø§',
        ]);
        break;
      case EmotionalState.hopeful:
        recommendations.addAll([
          'ÙˆÙŽÙ…ÙŽÙ†Ù’ ÙŠÙŽØªÙŽÙˆÙŽÙƒÙŽÙ‘Ù„Ù’ Ø¹ÙŽÙ„ÙŽÙ‰ Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù ÙÙŽÙ‡ÙÙˆÙŽ Ø­ÙŽØ³Ù’Ø¨ÙÙ‡Ù',
          'Ø¥ÙÙ†ÙŽÙ‘ Ù…ÙŽØ¹ÙŽ Ø§Ù„Ù’Ø¹ÙØ³Ù’Ø±Ù ÙŠÙØ³Ù’Ø±Ù‹Ø§',
          'Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ù„ÙŽØ§ ØªÙØ²ÙØºÙ’ Ù‚ÙÙ„ÙÙˆØ¨ÙŽÙ†ÙŽØ§ Ø¨ÙŽØ¹Ù’Ø¯ÙŽ Ø¥ÙØ°Ù’ Ù‡ÙŽØ¯ÙŽÙŠÙ’ØªÙŽÙ†ÙŽØ§',
        ]);
        break;
      default:
        recommendations.addAll([
          'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù Ø§Ù„Ø±ÙŽÙ‘Ø­Ù’Ù…ÙŽÙ†Ù Ø§Ù„Ø±ÙŽÙ‘Ø­ÙÙŠÙ…Ù',
          'Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ù„ÙÙ„ÙŽÙ‘Ù‡Ù Ø±ÙŽØ¨ÙÙ‘ Ø§Ù„Ù’Ø¹ÙŽØ§Ù„ÙŽÙ…ÙÙŠÙ†ÙŽ',
          'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ ØµÙŽÙ„ÙÙ‘ ÙˆÙŽØ³ÙŽÙ„ÙÙ‘Ù…Ù’ Ø¹ÙŽÙ„ÙŽÙ‰ Ù†ÙŽØ¨ÙÙŠÙÙ‘Ù†ÙŽØ§ Ù…ÙØ­ÙŽÙ…ÙŽÙ‘Ø¯Ù',
        ]);
    }

    // Add cultural context if available
    if (culturalContext != null) {
      final culturalDuas =
          await _getCulturalDuaRecommendations(emotion, culturalContext);
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
  Future<List<EmotionalDetection>> getEmotionHistory(String userId,
      {int limit = 50}) async {
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

  void _initializeContextWeights() {
    _contextWeights = {
      'lexical': 0.4,
      'contextual': 0.3,
      'islamic': 0.2,
      'historical': 0.1
    };
  }

  Future<void> _loadEmotionHistory() async {
    try {
      final historyJson = _prefs?.getString(_emotionHistoryKey);
      if (historyJson != null) {
        final data = jsonDecode(historyJson) as Map<String, dynamic>;
        data.forEach((userId, history) {
          _emotionHistory[userId] = (history as List<dynamic>)
              .map((item) => EmotionalDetection.fromJson(item))
              .toList();
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

    final topEmotion =
        emotionScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    final confidence =
        (topEmotion.value / (text.split(' ').length + 1)).clamp(0.0, 1.0);
    return EmotionResult(topEmotion.key, confidence);
  }

  EmotionResult _detectContextualEmotion(
      String text, Map<String, dynamic>? context) {
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
      } else if (situation.contains('family') ||
          situation.contains('celebration')) {
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

    final topEmotion =
        emotionScores.entries.reduce((a, b) => a.value > b.value ? a : b);

    return EmotionResult(
        topEmotion.key, (topEmotion.value / totalScore).clamp(0.0, 1.0));
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
      emotionCounts[detection.detectedEmotion] =
          (emotionCounts[detection.detectedEmotion] ?? 0) + 1;
    }

    if (emotionCounts.isEmpty) {
      return EmotionResult(EmotionalState.neutral, 0.0);
    }

    final mostFrequent =
        emotionCounts.entries.reduce((a, b) => a.value > b.value ? a : b);

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

      weightedScores[result.emotion] = (weightedScores[result.emotion] ?? 0.0) +
          (result.confidence * weight);
    }

    if (weightedScores.isEmpty) {
      return EmotionResult(EmotionalState.neutral, 0.5);
    }

    final topEmotion =
        weightedScores.entries.reduce((a, b) => a.value > b.value ? a : b);

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
    final capitalRatio =
        text.split('').where((c) => c == c.toUpperCase()).length / text.length;
    if (capitalRatio > 0.3) {
      intensity *= 1.1;
    }

    return intensity.clamp(0.5, 2.0);
  }

  List<String> _findIslamicExpressions(String text) {
    return _islamicExpressions.keys
        .where((expr) => text.contains(expr))
        .toList();
  }

  Future<void> _updateEmotionHistory(
      String userId, EmotionalDetection detection) async {
    _emotionHistory.putIfAbsent(userId, () => []).insert(0, detection);

    // Limit history size
    if (_emotionHistory[userId]!.length > _maxHistoryEntries) {
      _emotionHistory[userId]!
          .removeRange(_maxHistoryEntries, _emotionHistory[userId]!.length);
    }

    await _saveEmotionHistory();
  }

  Future<void> _saveEmotionHistory() async {
    try {
      final historyData = <String, dynamic>{};
      _emotionHistory.forEach((userId, history) {
        historyData[userId] =
            history.map((detection) => detection.toJson()).toList();
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

  EmotionalPattern _identifyEmotionalPatterns(
      List<EmotionalDetection> history) {
    final emotionCounts = <EmotionalState, int>{};
    final emotionConfidences = <EmotionalState, List<double>>{};

    for (final detection in history) {
      emotionCounts[detection.detectedEmotion] =
          (emotionCounts[detection.detectedEmotion] ?? 0) + 1;
      emotionConfidences
          .putIfAbsent(detection.detectedEmotion, () => [])
          .add(detection.confidence);
    }

    // Calculate dominant emotions
    final sortedEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final dominantEmotions =
        sortedEmotions.take(3).map((entry) => entry.key).toList();

    // Calculate stability (variance in emotions)
    final stability =
        _calculateEmotionalStability(emotionCounts, history.length);

    return EmotionalPattern(
      userId: history.first.userId,
      dominantEmotions: dominantEmotions,
      stability: stability,
      culturalContext:
          'general', // Would be enhanced with actual cultural analysis
      patternStrength: sortedEmotions.first.value / history.length,
      analysisDate: DateTime.now(),
    );
  }

  double _calculateEmotionalStability(
      Map<EmotionalState, int> emotionCounts, int totalCount) {
    if (emotionCounts.length <= 1) return 1.0;

    final mean = totalCount / emotionCounts.length;
    final variance = emotionCounts.values
            .map((count) => pow(count - mean, 2))
            .reduce((a, b) => a + b) /
        emotionCounts.length;

    // Convert variance to stability score (0-1, higher = more stable)
    return (1.0 / (1.0 + variance / mean)).clamp(0.0, 1.0);
  }

  Future<List<String>> _getCulturalDuaRecommendations(
      EmotionalState emotion, String culturalContext) async {
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

  EmotionModel(
      {required this.emotion,
      required this.keywords,
      required this.confidence});
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
