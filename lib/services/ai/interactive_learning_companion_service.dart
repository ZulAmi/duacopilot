import 'dart:async';
import 'dart:math';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';
import 'conversational_memory_service.dart';

/// Interactive Islamic Learning Companion
/// Provides structured, adaptive Islamic education through voice interaction
/// Features: Personalized curriculum, Socratic questioning, progress tracking
class InteractiveLearningCompanionService {
  static InteractiveLearningCompanionService? _instance;
  static InteractiveLearningCompanionService get instance => _instance ??= InteractiveLearningCompanionService._();

  InteractiveLearningCompanionService._();

  late SecureStorageService _secureStorage;
  late ConversationalMemoryService _memoryService;
  bool _isInitialized = false;

  // Learning state management
  LearningSession? _currentSession;
  final Map<String, LearningModule> _availableModules = {};
  final Map<String, double> _learningProgress = {};
  // ignore: unused_field
  final List<String> _completedLessons = []; // For future progress tracking

  /// Initialize interactive learning companion
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _secureStorage = SecureStorageService.instance;
      _memoryService = ConversationalMemoryService.instance;

      await _initializeLearningModules();
      await _loadLearningProgress();
      _isInitialized = true;

      AppLogger.info('Interactive Learning Companion initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize Interactive Learning Companion: $e');
      rethrow;
    }
  }

  /// Start interactive learning session
  Future<LearningResponse> startLearningSession({
    required String topic,
    String? specificSubject,
    String userLevel = 'beginner',
  }) async {
    await _ensureInitialized();

    try {
      // Find or create appropriate learning module
      final module = await _getOrCreateLearningModule(topic, userLevel);

      // Start new learning session
      _currentSession = LearningSession(
        id: 'session_${DateTime.now().millisecondsSinceEpoch}',
        moduleId: module.id,
        startTime: DateTime.now(),
        userLevel: userLevel,
        currentStep: 0,
      );

      // Generate opening response
      return await _generateOpeningResponse(module, specificSubject);
    } catch (e) {
      AppLogger.error('Failed to start learning session: $e');
      rethrow;
    }
  }

  /// Process learning interaction
  Future<LearningResponse> processLearningInteraction(String userInput) async {
    await _ensureInitialized();

    if (_currentSession == null) {
      return LearningResponse(
        response: 'Assalamu Alaikum! I\'d love to teach you about Islam. What would you like to learn today?',
        responseType: 'invitation',
        suggestedTopics: ['Prayer', 'Quran', 'Prophet\'s Life', 'Islamic Values'],
      );
    }

    try {
      final module = _availableModules[_currentSession!.moduleId]!;
      final currentLesson = module.lessons[_currentSession!.currentStep];

      // Process user's response to current lesson
      final understanding = await _assessUnderstanding(userInput, currentLesson);

      // Generate appropriate response based on understanding
      return await _generateLearningResponse(understanding: understanding, lesson: currentLesson, userInput: userInput);
    } catch (e) {
      AppLogger.error('Failed to process learning interaction: $e');
      return LearningResponse(
        response: 'I apologize, I had trouble understanding. Could you please repeat that?',
        responseType: 'clarification',
      );
    }
  }

  /// Get personalized learning suggestions
  Future<List<String>> getPersonalizedLearningTopics() async {
    await _ensureInitialized();

    try {
      final context = await _memoryService.getConversationalContext();
      final suggestions = <String>[];

      // Based on conversation history
      final recentTopics = context.recentTurns.map((turn) => turn.topic).where((topic) => topic != 'general').toSet();

      for (final topic in recentTopics) {
        final deeperTopics = _getRelatedLearningTopics(topic);
        suggestions.addAll(deeperTopics);
      }

      // Based on learning progress gaps
      final gaps = _identifyKnowledgeGaps();
      suggestions.addAll(gaps);

      // Remove duplicates and limit
      return suggestions.toSet().take(5).toList();
    } catch (e) {
      AppLogger.error('Failed to get personalized topics: $e');
      return ['Basics of Islam', 'Prayer Guide', 'Quran Understanding'];
    }
  }

  /// Initialize learning modules
  Future<void> _initializeLearningModules() async {
    // Create comprehensive Islamic learning modules

    // Module 1: Fundamentals of Faith
    _availableModules['fundamentals'] = LearningModule(
      id: 'fundamentals',
      title: 'Fundamentals of Islamic Faith',
      description: 'Core beliefs and pillars of Islam',
      level: 'beginner',
      estimatedDuration: Duration(minutes: 45),
      lessons: [
        LearningLesson(
          id: 'shahada',
          title: 'The Declaration of Faith (Shahada)',
          content: 'The Shahada is the first and most important pillar of Islam',
          questions: [
            'What does "La ilaha illa Allah" mean to you personally?',
            'How does believing in one God change how we live?',
            'What makes Prophet Muhammad ﷺ special as Allah\'s messenger?',
          ],
          keyPoints: [
            'Monotheism (Tawhid) is central to Islam',
            'Prophet Muhammad ﷺ is the final messenger',
            'The Shahada is both declaration and commitment',
          ],
          interactiveElements: [
            'Let\'s practice pronouncing the Shahada together',
            'Think of three ways this belief affects daily life',
            'Share what drew you to learn about Islam',
          ],
        ),
        LearningLesson(
          id: 'prayer_intro',
          title: 'Introduction to Prayer (Salah)',
          content: 'Prayer is our direct connection with Allah',
          questions: [
            'Why do you think Muslims pray five times a day?',
            'How might regular prayer change someone\'s character?',
            'What do you find most beautiful about Islamic prayer?',
          ],
          keyPoints: [
            'Prayer is worship and remembrance of Allah',
            'Five daily prayers structure our day around faith',
            'Prayer involves physical, mental, and spiritual elements',
          ],
          interactiveElements: [
            'Let\'s explore the meaning of prayer movements',
            'I\'ll teach you a simple opening prayer',
            'Describe how you feel when you remember Allah',
          ],
        ),
      ],
    );

    // Module 2: The Beautiful Quran
    _availableModules['quran_study'] = LearningModule(
      id: 'quran_study',
      title: 'Understanding the Quran',
      description: 'Interactive exploration of Allah\'s final revelation',
      level: 'intermediate',
      estimatedDuration: Duration(hours: 1),
      lessons: [
        LearningLesson(
          id: 'quran_nature',
          title: 'The Nature and Miracle of the Quran',
          content: 'The Quran is Allah\'s direct speech to humanity',
          questions: [
            'What makes the Quran unique among religious texts?',
            'How has the Quran been preserved throughout history?',
            'What emotions do you feel when you hear Quranic recitation?',
          ],
          keyPoints: [
            'The Quran is the direct word of Allah',
            'It has been preserved unchanged for 1400+ years',
            'It contains guidance for all aspects of life',
          ],
          interactiveElements: [
            'Let\'s listen to a beautiful recitation together',
            'I\'ll explain the meaning of a short verse',
            'Share your first impression of the Quran',
          ],
        ),
      ],
    );

    // Module 3: Prophet's Beautiful Life
    _availableModules['prophet_life'] = LearningModule(
      id: 'prophet_life',
      title: 'The Life and Character of Prophet Muhammad ﷺ',
      description: 'Learning from the best example of human conduct',
      level: 'all_levels',
      estimatedDuration: Duration(hours: 2),
      lessons: [
        LearningLesson(
          id: 'prophet_character',
          title: 'The Character of the Prophet ﷺ',
          content: 'Even his enemies called him "Al-Amin" (The Trustworthy)',
          questions: [
            'What character traits made the Prophet ﷺ so beloved?',
            'How can we apply his example in modern life?',
            'What story about the Prophet ﷺ inspires you most?',
          ],
          keyPoints: [
            'He was known for truthfulness even before prophethood',
            'He showed mercy to all people, even enemies',
            'His character was a living example of the Quran',
          ],
          interactiveElements: [
            'Let me share a beautiful story about his kindness',
            'Think of how you can follow his example today',
            'What questions do you have about his life?',
          ],
        ),
      ],
    );
  }

  /// Generate opening response for learning session
  Future<LearningResponse> _generateOpeningResponse(LearningModule module, String? specificSubject) async {
    final firstLesson = module.lessons.first;

    final response = '''
Assalamu Alaikum, my eager student! 📚✨

I'm absolutely delighted you want to learn about ${module.title}! 
MashaAllah, seeking knowledge is one of the most beloved acts to Allah.

${specificSubject != null ? 'Since you\'re interested in $specificSubject, we\'ll explore that deeply together.' : 'We\'ll start with ${firstLesson.title} and build from there.'}

The Prophet ﷺ said: "Whoever follows a path in the pursuit of knowledge, Allah will make a path to Paradise easy for him."

Are you ready to begin this beautiful journey? Let me know if you prefer:
- Interactive discussions (we explore together)
- Story-based learning (through beautiful narratives)  
- Practical application (how it applies to daily life)

What excites you most about learning this topic?
''';

    return LearningResponse(
      response: response,
      responseType: 'opening',
      currentLesson: firstLesson,
      suggestedResponses: [
        'I love interactive discussions!',
        'Tell me stories please',
        'Show me practical applications',
        'I have specific questions',
      ],
    );
  }

  /// Assess user's understanding
  Future<UnderstandingAssessment> _assessUnderstanding(String userInput, LearningLesson lesson) async {
    final input = userInput.toLowerCase();

    // Simple understanding assessment
    double understanding = 0.5; // baseline

    // Check for key concepts
    for (final keyPoint in lesson.keyPoints) {
      final keywords = keyPoint.toLowerCase().split(' ');
      if (keywords.any((keyword) => input.contains(keyword))) {
        understanding += 0.2;
      }
    }

    // Check for engagement indicators
    final engagementWords = ['because', 'why', 'how', 'what', 'interesting', 'beautiful'];
    if (engagementWords.any((word) => input.contains(word))) {
      understanding += 0.1;
    }

    // Check for questions (indicates active learning)
    if (input.contains('?')) {
      understanding += 0.1;
    }

    understanding = understanding.clamp(0.0, 1.0);

    return UnderstandingAssessment(
      level: understanding,
      showsEngagement: understanding > 0.6,
      hasQuestions: input.contains('?'),
      needsClarification: understanding < 0.4,
    );
  }

  /// Generate learning response
  Future<LearningResponse> _generateLearningResponse({
    required UnderstandingAssessment understanding,
    required LearningLesson lesson,
    required String userInput,
  }) async {
    String response;
    String responseType;

    if (understanding.hasQuestions) {
      response = await _handleLearningQuestion(userInput, lesson);
      responseType = 'explanation';
    } else if (understanding.needsClarification) {
      response = await _provideClarification(lesson);
      responseType = 'clarification';
    } else if (understanding.showsEngagement) {
      response = await _deepenUnderstanding(userInput, lesson);
      responseType = 'deepening';
    } else {
      response = await _encourageEngagement(lesson);
      responseType = 'encouragement';
    }

    // Check if ready to move to next lesson
    final readyToAdvance = understanding.level > 0.7 && understanding.showsEngagement;

    return LearningResponse(
      response: response,
      responseType: responseType,
      currentLesson: lesson,
      readyToAdvance: readyToAdvance,
      suggestedResponses: _generateSuggestedResponses(lesson, understanding),
    );
  }

  /// Handle learning questions
  Future<String> _handleLearningQuestion(String userInput, LearningLesson lesson) async {
    // This would integrate with your RAG system for detailed answers
    return '''
SubhanAllah, what a thoughtful question! 

Let me share some insights about ${lesson.title}...

${lesson.content}

This connects to what we discussed because...

What other aspects would you like to explore?
''';
  }

  /// Provide clarification
  Future<String> _provideClarification(LearningLesson lesson) async {
    return '''
Let me explain this in a different way, my dear student.

Think of ${lesson.title} like this:

${lesson.keyPoints.first}

Does this make it clearer? What part would you like me to elaborate on?
''';
  }

  /// Deepen understanding
  Future<String> _deepenUnderstanding(String userInput, LearningLesson lesson) async {
    return '''
MashaAllah! I can see you're really reflecting on this.

You mentioned something beautiful - let me build on that thought...

Here's a deeper perspective: ${lesson.keyPoints.last}

This is why the scholars say...

What do you think about this connection?
''';
  }

  /// Encourage engagement
  Future<String> _encourageEngagement(LearningLesson lesson) async {
    final encouragements = [
      'What are your thoughts on this concept?',
      'How do you think this applies to daily life?',
      'What questions come to mind?',
      'Does this remind you of anything from your experience?',
    ];

    final encouragement = encouragements[Random().nextInt(encouragements.length)];

    return '''
This is a beautiful topic to reflect upon.

${lesson.content}

$encouragement

Remember, there are no wrong questions in learning - only opportunities to grow! 🌱
''';
  }

  /// Generate suggested responses
  List<String> _generateSuggestedResponses(LearningLesson lesson, UnderstandingAssessment understanding) {
    if (understanding.needsClarification) {
      return ['Can you explain that differently?', 'Give me an example please', 'What does that mean exactly?'];
    } else if (understanding.showsEngagement) {
      return [
        'Tell me more about this',
        'How does this connect to...?',
        'What\'s the wisdom behind this?',
        'Can you share a story about this?',
      ];
    } else {
      return ['That\'s interesting', 'I have a question', 'Can you give an example?', 'How do I apply this?'];
    }
  }

  /// Get related learning topics
  List<String> _getRelatedLearningTopics(String topic) {
    final relatedTopics = {
      'prayer': ['Prayer times', 'Prayer meanings', 'Spiritual purification'],
      'quran': ['Quranic stories', 'Verses for daily life', 'Quranic Arabic'],
      'prophet': ['Prophetic traditions', 'Companion stories', 'Islamic history'],
      'faith': ['Pillars of Islam', 'Islamic beliefs', 'Spiritual development'],
    };

    return relatedTopics[topic] ?? [];
  }

  /// Identify knowledge gaps
  List<String> _identifyKnowledgeGaps() {
    // Based on learning progress, identify what hasn't been covered
    final allTopics = ['Prayer basics', 'Quran understanding', 'Prophet\'s character', 'Islamic values'];
    return allTopics.where((topic) => _learningProgress[topic] == null).toList();
  }

  /// Load learning progress
  Future<void> _loadLearningProgress() async {
    try {
      final progressData = await _secureStorage.read('learning_progress');
      if (progressData != null) {
        // Parse progress data
      }
    } catch (e) {
      AppLogger.debug('No previous learning progress found');
    }
  }

  /// Get or create learning module
  Future<LearningModule> _getOrCreateLearningModule(String topic, String level) async {
    // Find existing module or create new one
    final moduleKey = '${topic.toLowerCase()}_$level';

    if (_availableModules.containsKey(moduleKey)) {
      return _availableModules[moduleKey]!;
    }

    // Return closest match
    return _availableModules.values.first;
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}

/// Learning module structure
class LearningModule {
  final String id;
  final String title;
  final String description;
  final String level;
  final Duration estimatedDuration;
  final List<LearningLesson> lessons;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.estimatedDuration,
    required this.lessons,
  });
}

/// Individual learning lesson
class LearningLesson {
  final String id;
  final String title;
  final String content;
  final List<String> questions;
  final List<String> keyPoints;
  final List<String> interactiveElements;

  LearningLesson({
    required this.id,
    required this.title,
    required this.content,
    required this.questions,
    required this.keyPoints,
    required this.interactiveElements,
  });
}

/// Learning session state
class LearningSession {
  final String id;
  final String moduleId;
  final DateTime startTime;
  final String userLevel;
  int currentStep;
  DateTime? endTime;

  LearningSession({
    required this.id,
    required this.moduleId,
    required this.startTime,
    required this.userLevel,
    required this.currentStep,
    this.endTime,
  });
}

/// Learning response structure
class LearningResponse {
  final String response;
  final String responseType;
  final LearningLesson? currentLesson;
  final List<String>? suggestedTopics;
  final List<String>? suggestedResponses;
  final bool readyToAdvance;

  LearningResponse({
    required this.response,
    required this.responseType,
    this.currentLesson,
    this.suggestedTopics,
    this.suggestedResponses,
    this.readyToAdvance = false,
  });
}

/// Understanding assessment
class UnderstandingAssessment {
  final double level;
  final bool showsEngagement;
  final bool hasQuestions;
  final bool needsClarification;

  UnderstandingAssessment({
    required this.level,
    required this.showsEngagement,
    required this.hasQuestions,
    required this.needsClarification,
  });
}
