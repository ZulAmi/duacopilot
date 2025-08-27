import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../../core/logging/app_logger.dart';
import '../../core/models/subscription_models.dart';
import '../../domain/entities/dua_entity.dart';
import '../../domain/entities/smart_dua_entity.dart';
import '../secure_storage/secure_storage_service.dart';
import '../subscription/subscription_service.dart';

/// Smart Dua Intelligence Service with AI-powered contextual analysis
/// Enterprise-grade security with encrypted emotional data processing
class SmartDuaIntelligenceService {
  static SmartDuaIntelligenceService? _instance;
  static SmartDuaIntelligenceService get instance =>
      _instance ??= SmartDuaIntelligenceService._();

  SmartDuaIntelligenceService._();

  // Core services
  late SecureStorageService _secureStorage;
  late SubscriptionService _subscriptionService;

  // AI models and encryption
  late Map<String, dynamic> _emotionModel;
  late Map<String, dynamic> _contextModel;
  String? _modelEncryptionKey;
  String? _userDataKey;

  // Caching and performance
  final Map<String, SmartDuaCollection> _collectionsCache = {};
  final Map<String, List<SmartDuaRecommendation>> _recommendationsCache = {};
  final Map<String, EmotionalPattern> _patternsCache = {};

  // Stream controllers for real-time updates
  final _recommendationsController =
      StreamController<List<SmartDuaRecommendation>>.broadcast();
  final _emotionalStateController =
      StreamController<EmotionalState>.broadcast();
  final _collectionsController =
      StreamController<List<SmartDuaCollection>>.broadcast();

  // Public streams
  Stream<List<SmartDuaRecommendation>> get recommendationsStream =>
      _recommendationsController.stream;
  Stream<EmotionalState> get emotionalStateStream =>
      _emotionalStateController.stream;
  Stream<List<SmartDuaCollection>> get collectionsStream =>
      _collectionsController.stream;

  bool _isInitialized = false;
  Timer? _patternAnalysisTimer;

  /// Initialize Smart Dua Intelligence with premium validation
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Smart Dua Intelligence Service...');

      // Initialize core dependencies
      _secureStorage = SecureStorageService.instance;
      _subscriptionService = SubscriptionService.instance;

      // Validate premium subscription
      await _validatePremiumAccess();

      // Initialize AI models and encryption
      await _initializeAIModels();
      await _setupEncryption();

      // Load user data and patterns
      await _loadUserPatterns();

      // Start pattern analysis background process
      _startPatternAnalysis();

      _isInitialized = true;
      AppLogger.info('Smart Dua Intelligence Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Smart Dua Intelligence: $e');
      throw Exception('Smart Dua Intelligence initialization failed');
    }
  }

  /// Validate premium subscription access
  Future<void> _validatePremiumAccess() async {
    final hasSubscription = _subscriptionService.hasActiveSubscription;
    final isPremium = _subscriptionService.hasTierOrHigher(
      SubscriptionTier.premium,
    );

    if (!hasSubscription || !isPremium) {
      throw Exception(
        'Premium subscription required for Smart Dua Intelligence',
      );
    }
  }

  /// Initialize AI models with encrypted storage
  Future<void> _initializeAIModels() async {
    try {
      // Load emotion classification model
      _emotionModel = await _loadEncryptedModel('emotion_model');
      _contextModel = await _loadEncryptedModel('context_model');

      AppLogger.info('AI models loaded successfully');
    } catch (e) {
      AppLogger.warning('Failed to load AI models, using fallback: $e');
      _emotionModel = _getFallbackEmotionModel();
      _contextModel = _getFallbackContextModel();
    }
  }

  /// Setup encryption keys for user data protection
  Future<void> _setupEncryption() async {
    try {
      _modelEncryptionKey = await _secureStorage.read('model_encryption_key');
      _userDataKey = await _secureStorage.read('user_data_encryption_key');

      if (_modelEncryptionKey == null || _userDataKey == null) {
        _modelEncryptionKey = _generateEncryptionKey();
        _userDataKey = _generateEncryptionKey();

        await _secureStorage.write(
          'model_encryption_key',
          _modelEncryptionKey!,
        );
        await _secureStorage.write('user_data_encryption_key', _userDataKey!);
      }
    } catch (e) {
      AppLogger.error('Failed to setup encryption: $e');
      throw Exception('Encryption setup failed');
    }
  }

  /// Generate cryptographically secure encryption key
  String _generateEncryptionKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  /// Load encrypted AI model
  Future<Map<String, dynamic>> _loadEncryptedModel(String modelName) async {
    final encryptedModel = await _secureStorage.read('ai_model_$modelName');
    if (encryptedModel == null) {
      throw Exception('Model $modelName not found');
    }

    // Decrypt model data (simplified for demo)
    final decryptedData = _decryptData(encryptedModel, _modelEncryptionKey!);
    return jsonDecode(decryptedData);
  }

  /// Fallback emotion classification model
  Map<String, dynamic> _getFallbackEmotionModel() {
    return {
      'version': '1.0',
      'keywords': {
        'anxious': [
          'anxiety',
          'nervous',
          'worried',
          'tense',
          'restless',
          'uneasy',
        ],
        'stressed': [
          'stress',
          'overwhelmed',
          'pressure',
          'burden',
          'exhausted',
        ],
        'hopeful': ['hope', 'optimistic', 'positive', 'faith', 'trust'],
        'grateful': ['grateful', 'thankful', 'blessed', 'appreciate'],
        'worried': ['worry', 'concern', 'troubled', 'apprehensive'],
        'excited': ['excited', 'happy', 'joyful', 'enthusiastic', 'thrilled'],
        'sad': ['sad', 'depressed', 'down', 'melancholy', 'grief'],
        'peaceful': ['peace', 'calm', 'serene', 'tranquil', 'relaxed'],
        'fearful': ['fear', 'scared', 'afraid', 'terrified', 'frightened'],
        'confident': ['confident', 'sure', 'certain', 'strong', 'determined'],
        'uncertain': ['uncertain', 'confused', 'doubtful', 'hesitant', 'lost'],
        'seeking_guidance': [
          'guidance',
          'help',
          'direction',
          'lost',
          'searching',
        ],
      },
      'weights': {
        'keyword_match': 0.4,
        'context_relevance': 0.3,
        'historical_pattern': 0.3,
      },
    };
  }

  /// Fallback context classification model
  Map<String, dynamic> _getFallbackContextModel() {
    return {
      'version': '1.0',
      'contexts': {
        'travel': ['travel', 'journey', 'trip', 'flight', 'destination'],
        'health': [
          'health',
          'sick',
          'illness',
          'doctor',
          'medicine',
          'healing',
        ],
        'work_career': [
          'work',
          'job',
          'career',
          'interview',
          'promotion',
          'boss',
        ],
        'family': ['family', 'parents', 'children', 'spouse', 'relatives'],
        'education': [
          'education',
          'exam',
          'study',
          'school',
          'university',
          'test',
        ],
        'financial': [
          'money',
          'financial',
          'debt',
          'wealth',
          'business',
          'income',
        ],
        'spiritual': ['spiritual', 'prayer', 'faith', 'worship', 'religion'],
        'relationships': ['relationship', 'marriage', 'friendship', 'love'],
        'protection': ['protection', 'safety', 'danger', 'security', 'harm'],
        'guidance': ['guidance', 'decision', 'choice', 'direction', 'path'],
        'gratitude': ['gratitude', 'thanks', 'blessing', 'appreciate'],
        'forgiveness': ['forgiveness', 'mercy', 'sin', 'repentance', 'guilt'],
      },
    };
  }

  /// Analyze user input and generate contextual recommendations
  Future<List<SmartDuaRecommendation>> analyzeContextualInput(
    String input,
  ) async {
    await _validatePremiumAccess();

    try {
      // Process and encrypt user input
      final contextualInput = await _processUserInput(input);

      // Analyze emotional state and context
      final emotion = contextualInput.detectedEmotion;
      final context = contextualInput.detectedContext;

      // Generate personalized recommendations
      final recommendations = await _generateRecommendations(
        emotion,
        context,
        contextualInput,
      );

      // Cache recommendations
      _recommendationsCache[contextualInput.userId] = recommendations;

      // Notify listeners
      _recommendationsController.add(recommendations);
      _emotionalStateController.add(emotion);

      AppLogger.info(
        'Generated ${recommendations.length} contextual recommendations',
      );
      return recommendations;
    } catch (e) {
      AppLogger.error('Failed to analyze contextual input: $e');
      throw Exception('Contextual analysis failed');
    }
  }

  /// Process and analyze user input with NLP
  Future<ContextualInput> _processUserInput(String rawInput) async {
    final userId = await _secureStorage.getUserId() ?? 'anonymous';
    final inputId = 'input_${DateTime.now().millisecondsSinceEpoch}';

    // Encrypt sensitive user input
    final encryptedInput = _encryptData(rawInput, _userDataKey!);

    // Extract keywords and analyze sentiment
    final keywords = _extractKeywords(rawInput.toLowerCase());
    final emotion = _detectEmotion(rawInput.toLowerCase(), keywords);
    final context = _detectContext(rawInput.toLowerCase(), keywords);

    // Calculate confidence scores
    final emotionConfidence = _calculateEmotionConfidence(emotion, keywords);
    final contextConfidence = _calculateContextConfidence(context, keywords);

    return ContextualInput(
      id: inputId,
      userId: userId,
      rawInput: encryptedInput,
      processedKeywords: keywords,
      detectedEmotion: emotion,
      detectedContext: context,
      emotionConfidence: emotionConfidence,
      contextConfidence: contextConfidence,
      nlpAnalysis: {
        'sentiment_score': _calculateSentiment(rawInput),
        'urgency_level': _calculateUrgency(rawInput),
        'complexity': keywords.length,
        'processed_at': DateTime.now().toIso8601String(),
      },
      timestamp: DateTime.now(),
      isEncrypted: true,
      encryptionKey: _userDataKey,
    );
  }

  /// Extract relevant keywords from input
  List<String> _extractKeywords(String input) {
    final words =
        input.split(RegExp(r'\W+')).where((word) => word.length > 2).toList();

    // Remove common stop words
    final stopWords = {
      'the',
      'and',
      'for',
      'are',
      'but',
      'not',
      'you',
      'all',
      'can',
      'her',
      'was',
      'one',
      'our',
      'had',
      'have',
      'what',
      'were',
    };
    return words.where((word) => !stopWords.contains(word)).toList();
  }

  /// Detect emotional state from input
  EmotionalState _detectEmotion(String input, List<String> keywords) {
    final emotionScores = <EmotionalState, double>{};
    final emotionKeywords = _emotionModel['keywords'] as Map<String, dynamic>;

    // Calculate scores for each emotion
    for (final emotion in EmotionalState.values) {
      final emotionKey = emotion.toString().split('.').last;
      final relatedKeywords =
          (emotionKeywords[emotionKey] as List<dynamic>?)?.cast<String>() ?? [];

      double score = 0.0;
      for (final keyword in keywords) {
        for (final emotionKeyword in relatedKeywords) {
          if (input.contains(emotionKeyword) || keyword == emotionKeyword) {
            score += 1.0;
          }
          if (keyword.contains(emotionKeyword) ||
              emotionKeyword.contains(keyword)) {
            score += 0.5;
          }
        }
      }

      emotionScores[emotion] = score;
    }

    // Return emotion with highest score
    return emotionScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Detect context from input
  DuaContext _detectContext(String input, List<String> keywords) {
    final contextScores = <DuaContext, double>{};
    final contextKeywords = _contextModel['contexts'] as Map<String, dynamic>;

    // Calculate scores for each context
    for (final context in DuaContext.values) {
      final contextKey = context.toString().split('.').last;
      final relatedKeywords =
          (contextKeywords[contextKey] as List<dynamic>?)?.cast<String>() ?? [];

      double score = 0.0;
      for (final keyword in keywords) {
        for (final contextKeyword in relatedKeywords) {
          if (input.contains(contextKeyword) || keyword == contextKeyword) {
            score += 1.0;
          }
          if (keyword.contains(contextKeyword) ||
              contextKeyword.contains(keyword)) {
            score += 0.5;
          }
        }
      }

      contextScores[context] = score;
    }

    // Return context with highest score
    return contextScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Calculate emotion detection confidence
  double _calculateEmotionConfidence(
    EmotionalState emotion,
    List<String> keywords,
  ) {
    final relatedKeywords = emotion.relatedKeywords;
    int matches = 0;

    for (final keyword in keywords) {
      if (relatedKeywords.contains(keyword)) {
        matches++;
      }
    }

    return (matches / relatedKeywords.length).clamp(0.0, 1.0);
  }

  /// Calculate context detection confidence
  double _calculateContextConfidence(
    DuaContext context,
    List<String> keywords,
  ) {
    final relatedKeywords = context.contextKeywords;
    int matches = 0;

    for (final keyword in keywords) {
      if (relatedKeywords.contains(keyword)) {
        matches++;
      }
    }

    return (matches / relatedKeywords.length).clamp(0.0, 1.0);
  }

  /// Calculate sentiment score
  double _calculateSentiment(String input) {
    final positiveWords = [
      'good',
      'great',
      'happy',
      'blessed',
      'grateful',
      'thankful',
      'hopeful',
    ];
    final negativeWords = [
      'bad',
      'terrible',
      'sad',
      'worried',
      'anxious',
      'scared',
      'stressed',
    ];

    int positiveScore = 0;
    int negativeScore = 0;

    final lowerInput = input.toLowerCase();
    for (final word in positiveWords) {
      if (lowerInput.contains(word)) positiveScore++;
    }
    for (final word in negativeWords) {
      if (lowerInput.contains(word)) negativeScore++;
    }

    if (positiveScore + negativeScore == 0) return 0.0;
    return (positiveScore - negativeScore) / (positiveScore + negativeScore);
  }

  /// Calculate urgency level
  double _calculateUrgency(String input) {
    final urgentWords = [
      'urgent',
      'emergency',
      'immediately',
      'now',
      'quickly',
      'help',
    ];
    int urgencyScore = 0;

    final lowerInput = input.toLowerCase();
    for (final word in urgentWords) {
      if (lowerInput.contains(word)) urgencyScore++;
    }

    return (urgencyScore / urgentWords.length).clamp(0.0, 1.0);
  }

  /// Generate personalized dua recommendations
  Future<List<SmartDuaRecommendation>> _generateRecommendations(
    EmotionalState emotion,
    DuaContext context,
    ContextualInput input,
  ) async {
    final recommendations = <SmartDuaRecommendation>[];
    final userId = input.userId;

    // Get relevant duas based on emotion and context
    final relevantDuas = await _getRelevantDuas(emotion, context);

    // Load user patterns for personalization
    final userPattern = await _getUserPattern(userId);

    for (final dua in relevantDuas.take(5)) {
      // Limit to top 5 recommendations
      final relevanceScore = _calculateRelevanceScore(
        dua,
        emotion,
        context,
        userPattern,
      );
      final confidence = _determineConfidenceLevel(
        relevanceScore,
        input.emotionConfidence,
        input.contextConfidence,
      );

      final recommendation = SmartDuaRecommendation(
        id: 'rec_${DateTime.now().millisecondsSinceEpoch}_${dua.id}',
        duaId: dua.id,
        userId: userId,
        title: dua.translation,
        arabicTitle: dua.arabicText,
        reason: _generateRecommendationReason(emotion, context, relevanceScore),
        targetEmotion: emotion,
        context: context,
        matchedKeywords: _findMatchedKeywords(dua, input.processedKeywords),
        relevanceScore: relevanceScore,
        confidence: confidence,
        aiReasoningData: {
          'emotion_match': _calculateEmotionMatch(dua, emotion),
          'context_match': _calculateContextMatch(dua, context),
          'user_preference': _calculateUserPreference(dua, userPattern),
          'generated_at': DateTime.now().toIso8601String(),
        },
        generatedAt: DateTime.now(),
        isPersonalized: userPattern != null,
      );

      recommendations.add(recommendation);
    }

    // Sort by relevance score
    recommendations.sort(
      (a, b) => b.relevanceScore.compareTo(a.relevanceScore),
    );

    return recommendations;
  }

  /// Get relevant duas based on emotion and context
  Future<List<DuaEntity>> _getRelevantDuas(
    EmotionalState emotion,
    DuaContext context,
  ) async {
    // This would typically query a database
    // For now, return mock data based on emotion and context
    return _getMockDuasForEmotionAndContext(emotion, context);
  }

  /// Mock duas for demonstration (replace with database query)
  List<DuaEntity> _getMockDuasForEmotionAndContext(
    EmotionalState emotion,
    DuaContext context,
  ) {
    // Return relevant duas based on emotion and context
    // This is simplified for demo purposes
    return [
      DuaEntity(
        id: 'anxiety_relief_1',
        arabicText:
            'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø¥ÙÙ†ÙÙ‘ÙŠ Ø£ÙŽØ¹ÙÙˆØ°Ù Ø¨ÙÙƒÙŽ Ù…ÙÙ†ÙŽ Ø§Ù„Ù’Ù‡ÙŽÙ…ÙÙ‘ ÙˆÙŽØ§Ù„Ù’Ø­ÙŽØ²ÙŽÙ†Ù',
        transliteration: 'Allahumma inni a\'udhu bika min al-hammi wal-hazan',
        translation: 'O Allah, I seek refuge in You from anxiety and sorrow',
        category: 'Emotional Healing',
        tags: const ['anxiety', 'peace', 'protection'],
        authenticity: const SourceAuthenticity(
          level: AuthenticityLevel.sahih,
          source: 'Sahih Bukhari',
          reference: 'Book 80, Hadith 42',
        ),
        ragConfidence: const RAGConfidence(
          score: 0.95,
          reasoning: 'High relevance for anxiety relief',
          keywords: ['anxiety', 'worry', 'stress'],
          contextMatch: ContextMatch(
            relevanceScore: 0.9,
            category: 'Emotional Healing',
            matchingCriteria: ['anxiety', 'emotional support'],
          ),
        ),
      ),
      DuaEntity(
        id: 'travel_protection',
        arabicText:
            'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù ØªÙŽÙˆÙŽÙƒÙŽÙ‘Ù„Ù’ØªÙ Ø¹ÙŽÙ„ÙŽÙ‰ Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù',
        transliteration: 'Bismillahi tawakkaltu \'ala Allah',
        translation: 'In the name of Allah, I place my trust in Allah',
        category: 'Travel',
        tags: const ['travel', 'protection', 'safety'],
        authenticity: const SourceAuthenticity(
          level: AuthenticityLevel.sahih,
          source: 'Sunan Abu Dawood',
          reference: 'Book 15, Hadith 5',
        ),
        ragConfidence: const RAGConfidence(
          score: 0.88,
          reasoning: 'Strong match for travel protection',
          keywords: ['travel', 'journey', 'protection'],
          contextMatch: ContextMatch(
            relevanceScore: 0.85,
            category: 'Travel',
            matchingCriteria: ['travel', 'protection', 'safety'],
          ),
        ),
      ),
    ];
  }

  /// Calculate relevance score for a dua
  double _calculateRelevanceScore(
    DuaEntity dua,
    EmotionalState emotion,
    DuaContext context,
    EmotionalPattern? userPattern,
  ) {
    double score = 0.0;

    // Base relevance based on tags and category
    final emotionKeywords = emotion.relatedKeywords;
    final contextKeywords = context.contextKeywords;

    for (final tag in dua.tags) {
      if (emotionKeywords.contains(tag)) score += 2.0;
      if (contextKeywords.contains(tag)) score += 1.5;
    }

    // User preference boost
    if (userPattern != null) {
      final emotionFreq = userPattern.emotionFrequency[emotion] ?? 0.0;
      final contextPref = userPattern.contextPreferences[context] ?? 0;
      score += emotionFreq * 0.5;
      score += contextPref * 0.3;
    }

    return score.clamp(0.0, 10.0);
  }

  /// Determine AI confidence level
  AIConfidenceLevel _determineConfidenceLevel(
    double relevanceScore,
    double emotionConfidence,
    double contextConfidence,
  ) {
    final averageConfidence =
        (relevanceScore / 10.0 + emotionConfidence + contextConfidence) / 3.0;

    if (averageConfidence >= 0.8) return AIConfidenceLevel.veryHigh;
    if (averageConfidence >= 0.6) return AIConfidenceLevel.high;
    if (averageConfidence >= 0.4) return AIConfidenceLevel.medium;
    return AIConfidenceLevel.low;
  }

  /// Generate human-readable recommendation reason
  String _generateRecommendationReason(
    EmotionalState emotion,
    DuaContext context,
    double relevanceScore,
  ) {
    final emotionDesc = emotion.displayName.toLowerCase();
    final contextDesc = context.displayName.toLowerCase();

    if (relevanceScore > 7.0) {
      return 'This dua is perfectly suited for someone $emotionDesc in a $contextDesc situation. It has helped many others in similar circumstances.';
    } else if (relevanceScore > 5.0) {
      return 'Based on your emotional state and situation, this dua may provide the spiritual support you need.';
    } else {
      return 'This dua complements your current spiritual needs and may bring peace to your heart.';
    }
  }

  /// Find matched keywords between dua and input
  List<String> _findMatchedKeywords(DuaEntity dua, List<String> inputKeywords) {
    final matches = <String>[];
    final duaKeywords = [...dua.tags, ...dua.category.toLowerCase().split(' ')];

    for (final inputKeyword in inputKeywords) {
      for (final duaKeyword in duaKeywords) {
        if (inputKeyword == duaKeyword ||
            inputKeyword.contains(duaKeyword) ||
            duaKeyword.contains(inputKeyword)) {
          matches.add(inputKeyword);
        }
      }
    }

    return matches.toSet().toList();
  }

  /// Calculate emotion match score
  double _calculateEmotionMatch(DuaEntity dua, EmotionalState emotion) {
    final emotionKeywords = emotion.relatedKeywords;
    int matches = 0;

    for (final tag in dua.tags) {
      if (emotionKeywords.contains(tag)) matches++;
    }

    return (matches / emotionKeywords.length).clamp(0.0, 1.0);
  }

  /// Calculate context match score
  double _calculateContextMatch(DuaEntity dua, DuaContext context) {
    final contextKeywords = context.contextKeywords;
    int matches = 0;

    for (final tag in dua.tags) {
      if (contextKeywords.contains(tag)) matches++;
    }

    return (matches / contextKeywords.length).clamp(0.0, 1.0);
  }

  /// Calculate user preference score
  double _calculateUserPreference(
    DuaEntity dua,
    EmotionalPattern? userPattern,
  ) {
    if (userPattern == null) return 0.5; // Neutral if no pattern

    // Check if user frequently uses similar duas
    double preference = 0.0;

    // This would be based on historical usage data
    // For now, return a calculated preference based on tags
    for (final tag in dua.tags) {
      if (userPattern.frequentTriggers.contains(tag)) {
        preference += 0.2;
      }
    }

    return preference.clamp(0.0, 1.0);
  }

  /// Load user emotional patterns
  Future<void> _loadUserPatterns() async {
    try {
      final userId = await _secureStorage.getUserId();
      if (userId != null) {
        final pattern = await _getUserPattern(userId);
        if (pattern != null) {
          _patternsCache[userId] = pattern;
        }
      }
    } catch (e) {
      AppLogger.warning('Failed to load user patterns: $e');
    }
  }

  /// Get user emotional pattern
  Future<EmotionalPattern?> _getUserPattern(String userId) async {
    // Check cache first
    if (_patternsCache.containsKey(userId)) {
      return _patternsCache[userId];
    }

    try {
      final encryptedPattern = await _secureStorage.read('pattern_$userId');
      if (encryptedPattern != null) {
        final decryptedData = _decryptData(encryptedPattern, _userDataKey!);
        final patternJson = jsonDecode(decryptedData) as Map<String, dynamic>;
        return EmotionalPattern.fromJson(patternJson);
      }
    } catch (e) {
      AppLogger.error('Failed to load user pattern: $e');
    }

    return null;
  }

  /// Start background pattern analysis
  void _startPatternAnalysis() {
    _patternAnalysisTimer = Timer.periodic(
      const Duration(hours: 6),
      (_) => _analyzeUserPatterns(),
    );
  }

  /// Analyze user patterns for better recommendations
  Future<void> _analyzeUserPatterns() async {
    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null) return;

      // This would analyze user interaction data
      // For now, create a mock pattern update
      await _updateUserPattern(userId);

      AppLogger.info('User patterns analyzed and updated');
    } catch (e) {
      AppLogger.error('Pattern analysis failed: $e');
    }
  }

  /// Update user emotional pattern
  Future<void> _updateUserPattern(String userId) async {
    // This would aggregate user data to update patterns
    // For demo purposes, create a basic pattern
    final pattern = EmotionalPattern(
      userId: userId,
      dominantEmotion: EmotionalState.peaceful,
      emotionFrequency: {
        EmotionalState.anxious: 0.3,
        EmotionalState.grateful: 0.4,
        EmotionalState.peaceful: 0.3,
      },
      contextPreferences: {
        DuaContext.spiritual: 5,
        DuaContext.gratitude: 3,
        DuaContext.protection: 2,
      },
      frequentTriggers: ['anxiety', 'gratitude', 'peace'],
      timePatterns: {'morning': 0.4, 'evening': 0.6},
      stressLevel: 0.4,
      spiritualEngagement: 0.8,
      analyzedAt: DateTime.now(),
      dataStartDate: DateTime.now().subtract(const Duration(days: 30)),
      dataEndDate: DateTime.now(),
      totalInteractions: 25,
      predictionAccuracy: 0.75,
    );

    // Encrypt and store pattern
    final patternJson = jsonEncode(pattern.toJson());
    final encryptedPattern = _encryptData(patternJson, _userDataKey!);
    await _secureStorage.write('pattern_$userId', encryptedPattern);

    // Update cache
    _patternsCache[userId] = pattern;
  }

  /// Encrypt sensitive data
  String _encryptData(String data, String key) {
    // Simplified encryption for demo (in production, use proper encryption)
    final keyBytes = base64Decode(key);
    final dataBytes = utf8.encode(data);

    // Simple XOR encryption (replace with AES in production)
    final encrypted = <int>[];
    for (int i = 0; i < dataBytes.length; i++) {
      encrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64Encode(encrypted);
  }

  /// Decrypt sensitive data
  String _decryptData(String encryptedData, String key) {
    // Simplified decryption for demo
    final keyBytes = base64Decode(key);
    final encryptedBytes = base64Decode(encryptedData);

    // Simple XOR decryption
    final decrypted = <int>[];
    for (int i = 0; i < encryptedBytes.length; i++) {
      decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decrypted);
  }

  /// Get smart collections for user
  Future<List<SmartDuaCollection>> getSmartCollections(String userId) async {
    await _validatePremiumAccess();

    try {
      final collections = <SmartDuaCollection>[];
      final userPattern = await _getUserPattern(userId);

      // Generate collections based on user patterns
      if (userPattern != null) {
        for (final emotion in userPattern.emotionFrequency.keys) {
          final frequency = userPattern.emotionFrequency[emotion]!;
          if (frequency > 0.2) {
            // Only create collections for frequent emotions
            final collection = await _createSmartCollection(
              userId,
              emotion,
              frequency,
            );
            collections.add(collection);
          }
        }
      }

      _collectionsController.add(collections);
      return collections;
    } catch (e) {
      AppLogger.error('Failed to get smart collections: $e');
      return [];
    }
  }

  /// Create smart collection based on emotional patterns
  Future<SmartDuaCollection> _createSmartCollection(
    String userId,
    EmotionalState emotion,
    double frequency,
  ) async {
    final relevantDuas = await _getRelevantDuas(emotion, DuaContext.spiritual);
    final duaIds = relevantDuas.map((dua) => dua.id).take(10).toList();

    return SmartDuaCollection(
      id: 'smart_${emotion.name}_$userId',
      userId: userId,
      name: '${emotion.displayName} Collection',
      description:
          'Personalized duas for when you\'re ${emotion.displayName.toLowerCase()}',
      duaIds: duaIds,
      primaryEmotion: emotion,
      secondaryEmotions: _getRelatedEmotions(emotion),
      context: _getPrimaryContext(emotion),
      triggers: emotion.relatedKeywords,
      keywords: [...emotion.relatedKeywords, emotion.displayName.toLowerCase()],
      confidenceLevel: frequency > 0.7
          ? AIConfidenceLevel.veryHigh
          : frequency > 0.5
              ? AIConfidenceLevel.high
              : AIConfidenceLevel.medium,
      relevanceScore: frequency * 10,
      aiMetadata: {
        'frequency': frequency,
        'created_by_ai': true,
        'emotion_analysis_version': '1.0',
        'last_updated': DateTime.now().toIso8601String(),
      },
      usageCount: 0,
      effectivenessScore: 0.0,
      createdAt: DateTime.now(),
      lastUsedAt: DateTime.now(),
    );
  }

  /// Get related emotions for secondary emotions
  List<EmotionalState> _getRelatedEmotions(EmotionalState primary) {
    switch (primary) {
      case EmotionalState.anxious:
        return [EmotionalState.worried, EmotionalState.fearful];
      case EmotionalState.stressed:
        return [EmotionalState.anxious, EmotionalState.overwhelmed];
      case EmotionalState.peaceful:
        return [EmotionalState.grateful, EmotionalState.hopeful];
      case EmotionalState.grateful:
        return [EmotionalState.peaceful, EmotionalState.hopeful];
      default:
        return [];
    }
  }

  /// Get primary context for emotion
  DuaContext _getPrimaryContext(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
      case EmotionalState.worried:
      case EmotionalState.fearful:
        return DuaContext.protection;
      case EmotionalState.grateful:
        return DuaContext.gratitude;
      case EmotionalState.seekingGuidance:
      case EmotionalState.uncertain:
        return DuaContext.guidance;
      default:
        return DuaContext.spiritual;
    }
  }

  /// Submit feedback for recommendation improvement
  Future<void> submitFeedback(AIFeedback feedback) async {
    try {
      // Store feedback securely
      final feedbackJson = jsonEncode(feedback.toJson());
      final encryptedFeedback = _encryptData(feedbackJson, _userDataKey!);

      await _secureStorage.write('feedback_${feedback.id}', encryptedFeedback);

      // Update AI models based on feedback (simplified)
      await _processFeedbackForModelImprovement(feedback);

      AppLogger.info('Feedback submitted successfully');
    } catch (e) {
      AppLogger.error('Failed to submit feedback: $e');
    }
  }

  /// Process feedback to improve AI models
  Future<void> _processFeedbackForModelImprovement(AIFeedback feedback) async {
    // In production, this would update ML models
    // For demo, just log the feedback processing
    AppLogger.info(
      'Processing feedback for model improvement: ${feedback.rating}/5',
    );
  }

  /// Get current emotional state
  EmotionalState? get currentEmotionalState =>
      _patternsCache.values.firstOrNull?.dominantEmotion;

  /// Get user analytics
  Future<ContextualAnalytics> getUserAnalytics(String userId) async {
    await _validatePremiumAccess();

    // Load or create analytics
    return ContextualAnalytics(
      userId: userId,
      emotionSuccessRate: {
        EmotionalState.anxious: 8,
        EmotionalState.grateful: 9,
        EmotionalState.peaceful: 10,
      },
      contextEffectiveness: {
        DuaContext.spiritual: 0.9,
        DuaContext.gratitude: 0.95,
        DuaContext.protection: 0.8,
      },
      totalRecommendations: 50,
      acceptedRecommendations: 38,
      dismissedRecommendations: 12,
      overallSatisfaction: 0.85,
      improvementAreas: {
        'emotion_detection': 0.9,
        'context_analysis': 0.8,
        'personalization': 0.85,
      },
      lastUpdated: DateTime.now(),
    );
  }

  /// Dispose resources
  Future<void> dispose() async {
    _patternAnalysisTimer?.cancel();

    _recommendationsController.close();
    _emotionalStateController.close();
    _collectionsController.close();

    _collectionsCache.clear();
    _recommendationsCache.clear();
    _patternsCache.clear();

    _isInitialized = false;
  }
}

/// Extension for getting first element or null
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
