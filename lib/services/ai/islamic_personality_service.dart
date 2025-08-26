import 'dart:async';
import 'dart:math';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Islamic AI Personality Service - Creates a spiritual companion with Islamic character
/// Features: Wise responses, spiritual guidance, emotional support, teaching moments
class IslamicPersonalityService {
  static IslamicPersonalityService? _instance;
  static IslamicPersonalityService get instance => _instance ??= IslamicPersonalityService._();

  IslamicPersonalityService._();

  late SecureStorageService _secureStorage;
  bool _isInitialized = false;

  // AI Personality Traits - for future personality customization
  // ignore: unused_field
  final Map<String, dynamic> _personalityTraits = {
    'wisdom_level': 0.9, // How wise and thoughtful responses are
    'compassion_level': 0.95, // How empathetic and caring
    'teaching_style': 'gentle', // gentle, scholarly, encouraging
    'formality_level': 0.7, // How formal vs casual
    'spiritual_depth': 0.85, // How deep spiritual insights go
    'cultural_awareness': 0.9, // Understanding of different Islamic cultures
  };

  // Voice personality characteristics
  final Map<String, List<String>> _voicePersonality = {
    'greetings': [
      'Assalamu Alaikum, my dear brother/sister',
      'Peace be upon you, how may I guide you today?',
      'May Allah bless you, I\'m here to help',
      'Welcome back, faithful servant of Allah',
    ],
    'encouragements': [
      'SubhanAllah, what a beautiful question',
      'May Allah reward your seeking of knowledge',
      'Your spiritual journey inspires me',
      'Allah guides those who seek Him sincerely',
    ],
    'teaching_moments': [
      'Let me share some wisdom from our beloved Prophet ﷺ',
      'The Quran teaches us about this beautifully',
      'Our scholars have reflected deeply on this',
      'This reminds me of a beautiful hadith',
    ],
    'emotional_support': [
      'I understand your struggle, and Allah knows your heart',
      'Remember, Allah tests those He loves most',
      'Your feelings are valid, let\'s find comfort in faith',
      'In times of difficulty, we turn to Allah\'s mercy',
    ],
  };

  // Contextual response patterns
  final Map<String, Map<String, dynamic>> _responsePatterns = {
    'morning': {
      'tone': 'energetic_blessed',
      'prefix': 'Blessed morning to you!',
      'spiritual_context': 'morning_duas_and_gratitude',
    },
    'evening': {
      'tone': 'peaceful_reflective',
      'prefix': 'As the day draws to a close...',
      'spiritual_context': 'evening_reflection_and_forgiveness',
    },
    'distress': {
      'tone': 'compassionate_supportive',
      'prefix': 'I hear the concern in your voice...',
      'spiritual_context': 'comfort_and_healing_duas',
    },
    'celebration': {
      'tone': 'joyful_grateful',
      'prefix': 'Alhamdulillah! How wonderful!',
      'spiritual_context': 'gratitude_and_sharing_blessings',
    },
    'seeking_knowledge': {
      'tone': 'wise_teaching',
      'prefix': 'Ah, a seeker of knowledge - the most beloved to Allah',
      'spiritual_context': 'learning_and_wisdom_pursuit',
    },
  };

  /// Initialize the Islamic personality system
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _secureStorage = SecureStorageService.instance;
      await _loadPersonalityPreferences();
      _isInitialized = true;
      AppLogger.info('Islamic Personality Service initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize Islamic Personality Service: $e');
      rethrow;
    }
  }

  /// Generate personalized response with Islamic wisdom
  Future<String> generatePersonalizedResponse({
    required String originalResponse,
    required String userQuery,
    required String detectedEmotion,
    required String timeContext,
    String? userLanguage,
  }) async {
    await _ensureInitialized();

    try {
      // Analyze user's emotional and spiritual needs
      final responseContext = _analyzeResponseContext(
        userQuery: userQuery,
        detectedEmotion: detectedEmotion,
        timeContext: timeContext,
      );

      // Generate personality-infused response
      final personalizedResponse = await _craftPersonalizedResponse(
        originalResponse: originalResponse,
        context: responseContext,
        userLanguage: userLanguage ?? 'en',
      );

      return personalizedResponse;
    } catch (e) {
      AppLogger.error('Failed to generate personalized response: $e');
      return originalResponse; // Fallback to original
    }
  }

  /// Craft response with Islamic personality
  Future<String> _craftPersonalizedResponse({
    required String originalResponse,
    required Map<String, dynamic> context,
    required String userLanguage,
  }) async {
    final responseType = context['type'] as String;
    final emotionalTone = context['emotional_tone'] as String;

    // Select appropriate greeting/prefix
    final prefix = _selectPersonalityPrefix(responseType, emotionalTone);

    // Add spiritual context
    final spiritualInsight = _generateSpiritualInsight(context);

    // Add teaching moment if appropriate
    final teachingMoment = _generateTeachingMoment(context);

    // Add emotional support if needed
    final emotionalSupport = _generateEmotionalSupport(context);

    // Craft the complete personalized response
    final personalizedResponse = _assemblePersonalizedResponse(
      prefix: prefix,
      originalResponse: originalResponse,
      spiritualInsight: spiritualInsight,
      teachingMoment: teachingMoment,
      emotionalSupport: emotionalSupport,
      context: context,
    );

    return personalizedResponse;
  }

  /// Analyze user context for appropriate personality response
  Map<String, dynamic> _analyzeResponseContext({
    required String userQuery,
    required String detectedEmotion,
    required String timeContext,
  }) {
    final lowerQuery = userQuery.toLowerCase();

    // Determine response type based on query analysis
    String responseType = 'general';
    if (lowerQuery.contains(RegExp(r'help|guidance|advice'))) {
      responseType = 'seeking_guidance';
    } else if (lowerQuery.contains(RegExp(r'sad|difficult|hard|struggle'))) {
      responseType = 'distress';
    } else if (lowerQuery.contains(RegExp(r'happy|grateful|blessed|alhamdulillah'))) {
      responseType = 'celebration';
    } else if (lowerQuery.contains(RegExp(r'learn|teach|explain|understand'))) {
      responseType = 'seeking_knowledge';
    }

    // Add time-based context
    if (timeContext.contains('morning'))
      responseType = 'morning';
    else if (timeContext.contains('evening'))
      responseType = 'evening';

    return {
      'type': responseType,
      'emotional_tone': detectedEmotion,
      'time_context': timeContext,
      'query_complexity': _calculateQueryComplexity(userQuery),
      'spiritual_depth_needed': _determineNeededSpiritualDepth(userQuery, detectedEmotion),
    };
  }

  /// Select appropriate personality prefix
  String _selectPersonalityPrefix(String responseType, String emotionalTone) {
    final patterns = _responsePatterns[responseType];
    if (patterns != null) {
      return patterns['prefix'] as String;
    }

    // Fallback to emotion-based prefix
    final greetings = _voicePersonality['greetings']!;
    return greetings[Random().nextInt(greetings.length)];
  }

  /// Generate spiritual insight based on context
  String? _generateSpiritualInsight(Map<String, dynamic> context) {
    final responseType = context['type'] as String;
    final spiritualDepth = context['spiritual_depth_needed'] as double;

    if (spiritualDepth < 0.3) return null; // Don't add spiritual insight for simple queries

    final insights = {
      'distress': [
        'Remember, Allah says: "And it is He who created the heavens and earth in truth. And the day He says, \'Be,\' and it is, His word is the truth." (6:73)',
        'The Prophet ﷺ said: "No fatigue, nor disease, nor sorrow, nor sadness, nor hurt, nor distress befalls a Muslim, not even a prick of a thorn, but that Allah expiates some of his sins for that."',
      ],
      'seeking_knowledge': [
        'The Prophet ﷺ said: "The seeking of knowledge is obligatory upon every Muslim."',
        'Allah says: "And say, \'My Lord, increase me in knowledge.\'" (20:114)',
      ],
      'celebration': [
        'Allah says: "And [remember] when your Lord proclaimed, \'If you are grateful, I will certainly give you more.\'" (14:7)',
        'The Prophet ﷺ said: "He who does not thank people does not thank Allah."',
      ],
    };

    final relevantInsights = insights[responseType];
    if (relevantInsights != null) {
      return relevantInsights[Random().nextInt(relevantInsights.length)];
    }

    return null;
  }

  /// Generate teaching moment
  String? _generateTeachingMoment(Map<String, dynamic> context) {
    final queryComplexity = context['query_complexity'] as double;

    if (queryComplexity < 0.5) return null; // Simple queries don't need teaching moments

    final teachings = _voicePersonality['teaching_moments']!;
    return teachings[Random().nextInt(teachings.length)];
  }

  /// Generate emotional support
  String? _generateEmotionalSupport(Map<String, dynamic> context) {
    final emotionalTone = context['emotional_tone'] as String;
    final needsSupport = ['sadness', 'anxiety', 'distress', 'worry'].contains(emotionalTone);

    if (!needsSupport) return null;

    final support = _voicePersonality['emotional_support']!;
    return support[Random().nextInt(support.length)];
  }

  /// Assemble the complete personalized response
  String _assemblePersonalizedResponse({
    required String prefix,
    required String originalResponse,
    String? spiritualInsight,
    String? teachingMoment,
    String? emotionalSupport,
    required Map<String, dynamic> context,
  }) {
    final parts = <String>[];

    // Add personalized prefix
    parts.add(prefix);

    // Add emotional support if needed
    if (emotionalSupport != null) {
      parts.add('\n\n$emotionalSupport');
    }

    // Add the main response
    parts.add('\n\n$originalResponse');

    // Add spiritual insight
    if (spiritualInsight != null) {
      parts.add('\n\n🌙 **Spiritual Reflection:**\n$spiritualInsight');
    }

    // Add teaching moment
    if (teachingMoment != null) {
      parts.add('\n\n📚 **Learning Moment:**\n$teachingMoment');
    }

    // Add personalized closing
    final closing = _generatePersonalizedClosing(context);
    parts.add('\n\n$closing');

    return parts.join('');
  }

  /// Generate personalized closing
  String _generatePersonalizedClosing(Map<String, dynamic> context) {
    final closings = [
      'May Allah bless you and increase you in knowledge and faith. 🤲',
      'Barakallahu feeki/feek (May Allah bless you). I\'m always here to help. ✨',
      'Remember, Allah is always with those who are patient and grateful. 🌸',
      'May your heart find peace and your soul find guidance. Ameen. 🕌',
    ];

    return closings[Random().nextInt(closings.length)];
  }

  /// Calculate query complexity
  double _calculateQueryComplexity(String query) {
    final complexWords = ['why', 'how', 'explain', 'difference', 'understand', 'meaning'];
    final hasComplexWords = complexWords.any((word) => query.toLowerCase().contains(word));
    final wordCount = query.split(' ').length;

    double complexity = wordCount > 5 ? 0.6 : 0.3;
    if (hasComplexWords) complexity += 0.3;

    return complexity.clamp(0.0, 1.0);
  }

  /// Determine needed spiritual depth
  double _determineNeededSpiritualDepth(String query, String emotion) {
    final spiritualKeywords = ['allah', 'prayer', 'dua', 'faith', 'islam', 'quran', 'prophet'];
    final hasSpiritual = spiritualKeywords.any((word) => query.toLowerCase().contains(word));

    double depth = hasSpiritual ? 0.8 : 0.3;

    // Increase depth for emotional queries
    if (['sadness', 'anxiety', 'distress'].contains(emotion)) {
      depth += 0.3;
    }

    return depth.clamp(0.0, 1.0);
  }

  /// Load personality preferences
  Future<void> _loadPersonalityPreferences() async {
    try {
      // Load user's preferred personality settings
      final prefs = await _secureStorage.read('islamic_personality_prefs');
      if (prefs != null) {
        // Update personality traits based on user preferences
        // This could include preferred teaching style, formality level, etc.
      }
    } catch (e) {
      AppLogger.debug('No personality preferences found, using defaults');
    }
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
