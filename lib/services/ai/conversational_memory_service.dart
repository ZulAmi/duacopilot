import 'dart:async';
import 'dart:convert';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Advanced Conversational Memory Service
/// Maintains context, builds relationships, remembers user preferences
/// and creates truly conversational AI interactions
class ConversationalMemoryService {
  static ConversationalMemoryService? _instance;
  static ConversationalMemoryService get instance =>
      _instance ??= ConversationalMemoryService._();

  ConversationalMemoryService._();

  late SecureStorageService _secureStorage;
  bool _isInitialized = false;

  // Conversation session management
  String? _currentSessionId;
  final Map<String, ConversationSession> _activeSessions = {};
  // ignore: unused_field
  final Map<String, UserProfile> _userProfiles =
      {}; // For future user profiling

  // Memory types
  final List<ConversationTurn> _shortTermMemory = []; // Current session
  final List<ConversationPattern> _longTermMemory = []; // Across sessions
  final Map<String, dynamic> _userPreferences = {}; // Learned preferences

  /// Initialize conversational memory
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _secureStorage = SecureStorageService.instance;
      await _loadConversationalMemory();
      _startNewSession();
      _isInitialized = true;
      AppLogger.info('Conversational Memory Service initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize Conversational Memory: $e');
      rethrow;
    }
  }

  /// Start a new conversation session
  void _startNewSession() {
    _currentSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    _activeSessions[_currentSessionId!] = ConversationSession(
      id: _currentSessionId!,
      startTime: DateTime.now(),
      turns: [],
    );
  }

  /// Add conversation turn to memory
  Future<void> addConversationTurn({
    required String userInput,
    required String assistantResponse,
    required String detectedEmotion,
    required String topic,
    Map<String, dynamic>? metadata,
  }) async {
    await _ensureInitialized();

    final turn = ConversationTurn(
      id: 'turn_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: _currentSessionId!,
      timestamp: DateTime.now(),
      userInput: userInput,
      assistantResponse: assistantResponse,
      detectedEmotion: detectedEmotion,
      topic: topic,
      metadata: metadata ?? {},
    );

    // Add to short-term memory
    _shortTermMemory.add(turn);

    // Add to current session
    _activeSessions[_currentSessionId]?.turns.add(turn);

    // Analyze and update patterns
    await _analyzeConversationPatterns(turn);

    // Save periodically
    await _saveConversationalMemory();
  }

  /// Get conversational context for current response
  Future<ConversationalContext> getConversationalContext() async {
    await _ensureInitialized();

    final recentTurns = _shortTermMemory.take(5).toList();
    final currentTopic = _determineCurrentTopic(recentTurns);
    final emotionalState = _analyzeEmotionalProgression(recentTurns);
    final userPreferences = await _getUserPreferences();
    final conversationFlow = _analyzeConversationFlow(recentTurns);

    return ConversationalContext(
      recentTurns: recentTurns,
      currentTopic: currentTopic,
      emotionalProgression: emotionalState,
      userPreferences: userPreferences,
      conversationFlow: conversationFlow,
      sessionDuration: DateTime.now().difference(
        _activeSessions[_currentSessionId]?.startTime ?? DateTime.now(),
      ),
    );
  }

  /// Generate contextually aware response suggestions
  Future<List<String>> generateContextualSuggestions() async {
    final context = await getConversationalContext();
    final suggestions = <String>[];

    // Topic-based suggestions
    switch (context.currentTopic) {
      case 'prayer':
        suggestions.addAll([
          'Would you like me to remind you of the next prayer time?',
          'Shall I share a beautiful dua for after prayer?',
          'Would you like to learn about the spiritual benefits of this prayer?',
        ]);
        break;
      case 'quran':
        suggestions.addAll([
          'Would you like me to explain the context of this verse?',
          'Shall I share related verses on this topic?',
          'Would you like to hear the beautiful recitation?',
        ]);
        break;
      case 'personal_struggles':
        suggestions.addAll([
          'Would you like me to share some comforting duas?',
          'Shall we explore what Islamic teachings say about this?',
          'Would you like to practice some dhikr together?',
        ]);
        break;
    }

    // Emotional state-based suggestions
    if (context.emotionalProgression.contains('sadness')) {
      suggestions.add(
        'Would you like me to share some verses that bring comfort?',
      );
    } else if (context.emotionalProgression.contains('joy')) {
      suggestions.add(
        'MashaAllah! Shall we express gratitude through some duas?',
      );
    }

    // Preference-based suggestions
    if (context.userPreferences['prefers_hadith'] == true) {
      suggestions.add('Would you like me to share a relevant hadith?');
    }

    return suggestions.take(3).toList();
  }

  /// Check if user is asking for continuation or clarification
  bool isFollowUpQuestion(String userInput) {
    final followUpPatterns = [
      'explain more',
      'tell me more',
      'what about',
      'can you elaborate',
      'but what if',
      'however',
      'also',
      'and',
      'more details',
    ];

    final lowerInput = userInput.toLowerCase();
    return followUpPatterns.any((pattern) => lowerInput.contains(pattern));
  }

  /// Get conversation history for reference
  List<ConversationTurn> getRecentHistory({int limit = 10}) {
    return _shortTermMemory.reversed.take(limit).toList();
  }

  /// Analyze conversation patterns
  Future<void> _analyzeConversationPatterns(ConversationTurn turn) async {
    // Analyze user preferences
    await _updateUserPreferences(turn);

    // Identify conversation patterns
    final pattern = ConversationPattern(
      id: 'pattern_${DateTime.now().millisecondsSinceEpoch}',
      userQuery: turn.userInput,
      topic: turn.topic,
      emotion: turn.detectedEmotion,
      responseType: _classifyResponseType(turn.assistantResponse),
      timestamp: DateTime.now(),
    );

    _longTermMemory.add(pattern);

    // Keep only recent patterns
    if (_longTermMemory.length > 1000) {
      _longTermMemory.removeRange(0, _longTermMemory.length - 1000);
    }
  }

  /// Update user preferences based on conversation
  Future<void> _updateUserPreferences(ConversationTurn turn) async {
    final input = turn.userInput.toLowerCase();

    // Detect language preference
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(input)) {
      _userPreferences['prefers_arabic'] = true;
    }

    // Detect content preferences
    if (input.contains('hadith')) {
      _userPreferences['prefers_hadith'] = true;
    }
    if (input.contains('quran') || input.contains('verse')) {
      _userPreferences['prefers_quran'] = true;
    }
    if (input.contains('dua')) {
      _userPreferences['prefers_duas'] = true;
    }

    // Detect learning style
    if (input.contains('explain') || input.contains('why')) {
      _userPreferences['learning_style'] = 'detailed_explanations';
    } else if (input.contains('quick') || input.contains('brief')) {
      _userPreferences['learning_style'] = 'concise_answers';
    }

    // Detect emotional needs
    if (turn.detectedEmotion == 'sadness') {
      _userPreferences['needs_emotional_support'] = true;
    }
  }

  /// Determine current conversation topic
  String _determineCurrentTopic(List<ConversationTurn> recentTurns) {
    if (recentTurns.isEmpty) return 'general';

    // Look at the most recent turns for topic consistency
    final recentTopics = recentTurns.map((turn) => turn.topic).toList();
    final topicCounts = <String, int>{};

    for (final topic in recentTopics) {
      topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
    }

    // Return most frequent topic
    return topicCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Analyze emotional progression throughout conversation
  List<String> _analyzeEmotionalProgression(List<ConversationTurn> turns) {
    return turns.map((turn) => turn.detectedEmotion).toList();
  }

  /// Analyze conversation flow
  String _analyzeConversationFlow(List<ConversationTurn> turns) {
    if (turns.isEmpty) return 'starting';
    if (turns.length == 1) return 'beginning';
    if (turns.length < 5) return 'building';

    // Analyze if conversation is deepening or shifting
    final topics = turns.map((t) => t.topic).toList();
    final uniqueTopics = topics.toSet().length;

    if (uniqueTopics == 1) return 'deepening';
    if (uniqueTopics > topics.length / 2) return 'exploring';
    return 'developing';
  }

  /// Get user preferences
  Future<Map<String, dynamic>> _getUserPreferences() async {
    return Map.from(_userPreferences);
  }

  /// Classify response type
  String _classifyResponseType(String response) {
    if (response.contains('Quran') || response.contains('verse'))
      return 'quranic_guidance';
    if (response.contains('Prophet') || response.contains('hadith'))
      return 'prophetic_guidance';
    if (response.contains('dua') || response.contains('prayer'))
      return 'spiritual_practice';
    if (response.contains('Allah') && response.contains('mercy'))
      return 'divine_comfort';
    return 'general_guidance';
  }

  /// Load conversational memory from storage
  Future<void> _loadConversationalMemory() async {
    try {
      // Load long-term memory
      final longTermData = await _secureStorage.read('long_term_memory');
      if (longTermData != null) {
        final patterns = jsonDecode(longTermData) as List;
        _longTermMemory.addAll(
          patterns.map((p) => ConversationPattern.fromJson(p)).toList(),
        );
      }

      // Load user preferences
      final prefsData = await _secureStorage.read('conversation_preferences');
      if (prefsData != null) {
        _userPreferences.addAll(jsonDecode(prefsData));
      }
    } catch (e) {
      AppLogger.debug('No previous conversation memory found');
    }
  }

  /// Save conversational memory to storage
  Future<void> _saveConversationalMemory() async {
    try {
      // Save long-term memory (last 500 patterns)
      final recentPatterns = _longTermMemory.take(500).toList();
      await _secureStorage.write(
        'long_term_memory',
        jsonEncode(recentPatterns.map((p) => p.toJson()).toList()),
      );

      // Save user preferences
      await _secureStorage.write(
        'conversation_preferences',
        jsonEncode(_userPreferences),
      );
    } catch (e) {
      AppLogger.error('Failed to save conversation memory: $e');
    }
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}

/// Represents a single conversation turn
class ConversationTurn {
  final String id;
  final String sessionId;
  final DateTime timestamp;
  final String userInput;
  final String assistantResponse;
  final String detectedEmotion;
  final String topic;
  final Map<String, dynamic> metadata;

  ConversationTurn({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.userInput,
    required this.assistantResponse,
    required this.detectedEmotion,
    required this.topic,
    required this.metadata,
  });
}

/// Represents a conversation session
class ConversationSession {
  final String id;
  final DateTime startTime;
  final List<ConversationTurn> turns;
  DateTime? endTime;

  ConversationSession({
    required this.id,
    required this.startTime,
    required this.turns,
    this.endTime,
  });
}

/// Represents a conversation pattern
class ConversationPattern {
  final String id;
  final String userQuery;
  final String topic;
  final String emotion;
  final String responseType;
  final DateTime timestamp;

  ConversationPattern({
    required this.id,
    required this.userQuery,
    required this.topic,
    required this.emotion,
    required this.responseType,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userQuery': userQuery,
    'topic': topic,
    'emotion': emotion,
    'responseType': responseType,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ConversationPattern.fromJson(Map<String, dynamic> json) =>
      ConversationPattern(
        id: json['id'],
        userQuery: json['userQuery'],
        topic: json['topic'],
        emotion: json['emotion'],
        responseType: json['responseType'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Represents user profile information
class UserProfile {
  final String id;
  final Map<String, dynamic> preferences;
  final List<String> interests;
  final String learningStyle;
  final Map<String, int> topicInteractions;

  UserProfile({
    required this.id,
    required this.preferences,
    required this.interests,
    required this.learningStyle,
    required this.topicInteractions,
  });
}

/// Represents conversational context
class ConversationalContext {
  final List<ConversationTurn> recentTurns;
  final String currentTopic;
  final List<String> emotionalProgression;
  final Map<String, dynamic> userPreferences;
  final String conversationFlow;
  final Duration sessionDuration;

  ConversationalContext({
    required this.recentTurns,
    required this.currentTopic,
    required this.emotionalProgression,
    required this.userPreferences,
    required this.conversationFlow,
    required this.sessionDuration,
  });
}
