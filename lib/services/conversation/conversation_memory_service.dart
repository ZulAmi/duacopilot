import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';
import '../secure_storage/secure_storage_service.dart';

/// Enhanced conversation memory service for sophisticated follow-up questions
/// Maintains conversation context, user preferences, and semantic understanding
class ConversationMemoryService {
  static ConversationMemoryService? _instance;
  static ConversationMemoryService get instance => _instance ??= ConversationMemoryService._();

  ConversationMemoryService._();

  // Storage keys
  static const String _conversationHistoryKey = 'conversation_history';
  static const String _contextWindowKey = 'context_window';
  static const String _userPreferencesKey = 'conversation_preferences';
  static const String _semanticMemoryKey = 'semantic_memory';

  // Configuration
  static const int _maxConversationHistory = 100;
  static const int _contextWindowSize = 10;
  static const double _semanticSimilarityThreshold = 0.75;

  // Services
  late SecureStorageService _secureStorage;
  SharedPreferences? _prefs;

  // Memory structures
  final Map<String, ConversationContext> _activeContexts = {};
  final Map<String, List<ConversationTurn>> _conversationHistory = {};
  final Map<String, Map<String, dynamic>> _userProfiles = {};
  final Map<String, List<SemanticMemory>> _semanticMemories = {};

  // Stream controllers
  final _conversationUpdateController = StreamController<ConversationUpdate>.broadcast();
  final _contextChangeController = StreamController<ConversationContext>.broadcast();

  // Public streams
  Stream<ConversationUpdate> get conversationUpdates => _conversationUpdateController.stream;
  Stream<ConversationContext> get contextChanges => _contextChangeController.stream;

  bool _isInitialized = false;

  /// Initialize conversation memory service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Conversation Memory Service...');

      _secureStorage = SecureStorageService.instance;
      _prefs = await SharedPreferences.getInstance();

      // Load existing conversations
      await _loadConversationHistory();
      await _loadUserProfiles();
      await _loadSemanticMemories();

      _isInitialized = true;
      AppLogger.info('Conversation Memory Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Conversation Memory Service: $e');
      throw Exception('Conversation Memory Service initialization failed');
    }
  }

  /// Start a new conversation or get existing context
  Future<ConversationContext> startConversation(String userId, {String? sessionId}) async {
    await _ensureInitialized();

    final conversationId = sessionId ?? 'conv_${DateTime.now().millisecondsSinceEpoch}';

    final context = ConversationContext(
      conversationId: conversationId,
      userId: userId,
      startTime: DateTime.now(),
      lastActivity: DateTime.now(),
      turnCount: 0,
      currentTopic: null,
      emotionalState: EmotionalState.neutral,
      contextTags: [],
      userProfile: await _getUserProfile(userId),
      semanticContext: {},
    );

    _activeContexts[conversationId] = context;
    await _saveConversationContext(context);

    AppLogger.info('Started conversation: $conversationId for user: $userId');
    return context;
  }

  /// Add a conversation turn with context analysis
  Future<void> addConversationTurn({
    required String conversationId,
    required String userInput,
    required String systemResponse,
    required String intent,
    Map<String, dynamic>? metadata,
  }) async {
    await _ensureInitialized();

    final context = _activeContexts[conversationId];
    if (context == null) {
      throw Exception('Conversation context not found: $conversationId');
    }

    // Create conversation turn
    final turn = ConversationTurn(
      turnId: 'turn_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      userInput: userInput,
      systemResponse: systemResponse,
      intent: intent,
      timestamp: DateTime.now(),
      emotionalState: _detectEmotionalState(userInput),
      topicTags: _extractTopics(userInput),
      semanticEmbedding: await _generateSemanticEmbedding(userInput),
      metadata: metadata ?? {},
    );

    // Update conversation history
    _conversationHistory.putIfAbsent(conversationId, () => []).add(turn);

    // Maintain conversation window size
    if (_conversationHistory[conversationId]!.length > _maxConversationHistory) {
      _conversationHistory[conversationId]!.removeRange(
        0,
        _conversationHistory[conversationId]!.length - _maxConversationHistory,
      );
    }

    // Update context
    final updatedContext = context.copyWith(
      lastActivity: DateTime.now(),
      turnCount: context.turnCount + 1,
      currentTopic: turn.topicTags.isNotEmpty ? turn.topicTags.first : context.currentTopic,
      emotionalState: turn.emotionalState,
      contextTags: _updateContextTags(context.contextTags, turn.topicTags),
      semanticContext: _updateSemanticContext(context.semanticContext, turn),
    );

    _activeContexts[conversationId] = updatedContext;

    // Store semantic memory
    await _storeSemanticMemory(context.userId, turn);

    // Save to persistent storage
    await _saveConversationTurn(turn);
    await _saveConversationContext(updatedContext);

    // Notify listeners
    _conversationUpdateController.add(
      ConversationUpdate(
        conversationId: conversationId,
        turn: turn,
        updatedContext: updatedContext,
        updateType: ConversationUpdateType.turnAdded,
      ),
    );

    AppLogger.debug('Added conversation turn to: $conversationId');
  }

  /// Get conversation context for follow-up processing
  Future<ConversationContext?> getConversationContext(String conversationId) async {
    await _ensureInitialized();
    return _activeContexts[conversationId];
  }

  /// Get recent conversation history for context
  Future<List<ConversationTurn>> getRecentHistory(String conversationId, {int limit = 5}) async {
    await _ensureInitialized();

    final history = _conversationHistory[conversationId] ?? [];
    final recentCount = min(limit, history.length);
    return history.skip(history.length - recentCount).toList();
  }

  /// Find similar conversations for context enhancement
  Future<List<SimilarConversation>> findSimilarConversations(
    String userId,
    String currentInput, {
    int limit = 3,
  }) async {
    await _ensureInitialized();

    final currentEmbedding = await _generateSemanticEmbedding(currentInput);
    final userMemories = _semanticMemories[userId] ?? [];
    final similarities = <SimilarConversation>[];

    for (final memory in userMemories) {
      final similarity = _calculateCosineSimilarity(currentEmbedding, memory.embedding);
      if (similarity > _semanticSimilarityThreshold) {
        similarities.add(
          SimilarConversation(
            conversationId: memory.conversationId,
            turnId: memory.turnId,
            similarity: similarity,
            originalInput: memory.userInput,
            response: memory.systemResponse,
            timestamp: memory.timestamp,
            topics: memory.topics,
          ),
        );
      }
    }

    similarities.sort((a, b) => b.similarity.compareTo(a.similarity));
    return similarities.take(limit).toList();
  }

  /// Generate contextual prompt for RAG enhancement
  Future<String> generateContextualPrompt({
    required String conversationId,
    required String currentInput,
    required String basePrompt,
  }) async {
    await _ensureInitialized();

    final context = await getConversationContext(conversationId);
    if (context == null) return basePrompt;

    final recentHistory = await getRecentHistory(conversationId, limit: _contextWindowSize);
    final similarConversations = await findSimilarConversations(context.userId, currentInput, limit: 3);

    // Build enhanced prompt
    final promptBuilder = StringBuffer(basePrompt);

    // Add conversation context
    if (recentHistory.isNotEmpty) {
      promptBuilder.writeln('\n--- Recent Conversation Context ---');
      for (final turn in recentHistory) {
        promptBuilder.writeln('User: ${turn.userInput}');
        promptBuilder.writeln('Assistant: ${turn.systemResponse}');
      }
    }

    // Add similar conversation insights
    if (similarConversations.isNotEmpty) {
      promptBuilder.writeln('\n--- Related Past Conversations ---');
      for (final similar in similarConversations) {
        promptBuilder.writeln('Previous Query: ${similar.originalInput}');
        promptBuilder.writeln('Context: ${similar.topics.join(', ')}');
      }
    }

    // Add user profile context
    if (context.userProfile.preferences.isNotEmpty) {
      promptBuilder.writeln('\n--- User Preferences ---');
      context.userProfile.preferences.forEach((key, value) {
        promptBuilder.writeln('$key: $value');
      });
    }

    // Add emotional context
    promptBuilder.writeln('\n--- Emotional Context ---');
    promptBuilder.writeln('Current State: ${context.emotionalState.name}');
    promptBuilder.writeln('Topics: ${context.contextTags.join(', ')}');

    return promptBuilder.toString();
  }

  /// Update user profile based on conversation patterns
  Future<void> updateUserProfile(String userId, Map<String, dynamic> profileUpdates) async {
    await _ensureInitialized();

    final existingProfile = _userProfiles[userId] ?? {};
    final updatedProfile = {...existingProfile, ...profileUpdates};

    _userProfiles[userId] = updatedProfile;
    await _saveUserProfile(userId, updatedProfile);

    AppLogger.debug('Updated user profile for: $userId');
  }

  /// End conversation and cleanup
  Future<void> endConversation(String conversationId) async {
    await _ensureInitialized();

    final context = _activeContexts[conversationId];
    if (context != null) {
      final endedContext = context.copyWith(endTime: DateTime.now(), isActive: false);

      await _saveConversationContext(endedContext);
      _activeContexts.remove(conversationId);

      _contextChangeController.add(endedContext);
      AppLogger.info('Ended conversation: $conversationId');
    }
  }

  /// Get conversation statistics
  Future<ConversationStats> getConversationStats(String userId) async {
    await _ensureInitialized();

    final userConversations =
        _conversationHistory.entries.where((entry) => _activeContexts[entry.key]?.userId == userId).toList();

    final totalConversations = userConversations.length;
    final totalTurns = userConversations.fold<int>(0, (sum, entry) => sum + entry.value.length);

    final avgTurnsPerConversation = totalConversations > 0 ? totalTurns / totalConversations : 0.0;

    // Calculate topic distribution
    final topicCounts = <String, int>{};
    for (final entry in userConversations) {
      for (final turn in entry.value) {
        for (final topic in turn.topicTags) {
          topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
        }
      }
    }

    return ConversationStats(
      userId: userId,
      totalConversations: totalConversations,
      totalTurns: totalTurns,
      averageTurnsPerConversation: avgTurnsPerConversation,
      mostDiscussedTopics:
          topicCounts.entries.map((e) => TopicFrequency(topic: e.key, frequency: e.value)).toList()
            ..sort((a, b) => b.frequency.compareTo(a.frequency)),
      lastConversationDate: userConversations.isNotEmpty ? userConversations.last.value.last.timestamp : null,
    );
  }

  // Private helper methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _loadConversationHistory() async {
    try {
      final historyJson = _prefs?.getString(_conversationHistoryKey);
      if (historyJson != null) {
        final data = jsonDecode(historyJson) as Map<String, dynamic>;
        data.forEach((conversationId, turns) {
          _conversationHistory[conversationId] =
              (turns as List<dynamic>).map((turn) => ConversationTurn.fromJson(turn)).toList();
        });
      }
    } catch (e) {
      AppLogger.warning('Failed to load conversation history: $e');
    }
  }

  Future<void> _loadUserProfiles() async {
    try {
      final profilesJson = _prefs?.getString(_userPreferencesKey);
      if (profilesJson != null) {
        final data = jsonDecode(profilesJson) as Map<String, dynamic>;
        _userProfiles.addAll(data.map((k, v) => MapEntry(k, v as Map<String, dynamic>)));
      }
    } catch (e) {
      AppLogger.warning('Failed to load user profiles: $e');
    }
  }

  Future<void> _loadSemanticMemories() async {
    try {
      final memoriesJson = _prefs?.getString(_semanticMemoryKey);
      if (memoriesJson != null) {
        final data = jsonDecode(memoriesJson) as Map<String, dynamic>;
        data.forEach((userId, memories) {
          _semanticMemories[userId] =
              (memories as List<dynamic>).map((memory) => SemanticMemory.fromJson(memory)).toList();
        });
      }
    } catch (e) {
      AppLogger.warning('Failed to load semantic memories: $e');
    }
  }

  Future<UserProfile> _getUserProfile(String userId) async {
    final profileData = _userProfiles[userId] ?? {};
    return UserProfile(
      userId: userId,
      preferences: profileData,
      conversationStyle: profileData['conversation_style'] ?? 'balanced',
      topicInterests: (profileData['topic_interests'] as List<dynamic>?)?.cast<String>() ?? [],
      emotionalPatterns: (profileData['emotional_patterns'] as Map<String, dynamic>?) ?? {},
    );
  }

  EmotionalState _detectEmotionalState(String input) {
    // Simple emotion detection - could be enhanced with ML
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains(RegExp(r'\b(anxious|worried|nervous|scared)\b'))) {
      return EmotionalState.anxious;
    } else if (lowerInput.contains(RegExp(r'\b(happy|joyful|excited|grateful)\b'))) {
      return EmotionalState.grateful;
    } else if (lowerInput.contains(RegExp(r'\b(sad|depressed|down|upset)\b'))) {
      return EmotionalState.sad;
    } else if (lowerInput.contains(RegExp(r'\b(confused|lost|uncertain)\b'))) {
      return EmotionalState.uncertain;
    } else if (lowerInput.contains(RegExp(r'\b(guidance|help|direction)\b'))) {
      return EmotionalState.seeking_guidance;
    }

    return EmotionalState.neutral;
  }

  List<String> _extractTopics(String input) {
    // Enhanced topic extraction
    final topics = <String>[];
    final lowerInput = input.toLowerCase();

    final topicPatterns = {
      'prayer': r'\b(prayer|salah|namaz|dua|worship)\b',
      'family': r'\b(family|mother|father|child|parent|spouse)\b',
      'work': r'\b(work|job|career|business|office)\b',
      'health': r'\b(health|sick|illness|healing|medicine)\b',
      'travel': r'\b(travel|journey|trip|voyage)\b',
      'education': r'\b(education|study|exam|school|university)\b',
      'financial': r'\b(money|wealth|debt|financial|income)\b',
      'spiritual': r'\b(spiritual|faith|religion|Allah|God)\b',
      'guidance': r'\b(guidance|help|advice|direction)\b',
      'protection': r'\b(protection|safety|security|harm)\b',
    };

    topicPatterns.forEach((topic, pattern) {
      if (RegExp(pattern).hasMatch(lowerInput)) {
        topics.add(topic);
      }
    });

    return topics;
  }

  Future<List<double>> _generateSemanticEmbedding(String text) async {
    // Simple embedding generation - should use proper ML model
    final words = text.toLowerCase().split(RegExp(r'\W+'));
    final embedding = List.filled(128, 0.0); // 128-dimensional embedding

    final random = Random(text.hashCode);
    for (int i = 0; i < embedding.length; i++) {
      embedding[i] = random.nextDouble() * 2 - 1; // Range [-1, 1]
    }

    return embedding;
  }

  double _calculateCosineSimilarity(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) return 0.0;

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;

    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }

  List<String> _updateContextTags(List<String> existingTags, List<String> newTags) {
    final updatedTags = Set<String>.from(existingTags)..addAll(newTags);
    return updatedTags.take(10).toList(); // Keep only top 10 most recent tags
  }

  Map<String, dynamic> _updateSemanticContext(Map<String, dynamic> existingContext, ConversationTurn turn) {
    final updatedContext = Map<String, dynamic>.from(existingContext);
    updatedContext['last_intent'] = turn.intent;
    updatedContext['last_topics'] = turn.topicTags;
    updatedContext['last_emotional_state'] = turn.emotionalState.name;
    updatedContext['turn_count'] = (updatedContext['turn_count'] ?? 0) + 1;
    return updatedContext;
  }

  Future<void> _storeSemanticMemory(String userId, ConversationTurn turn) async {
    final memory = SemanticMemory(
      userId: userId,
      conversationId: turn.conversationId,
      turnId: turn.turnId,
      userInput: turn.userInput,
      systemResponse: turn.systemResponse,
      embedding: turn.semanticEmbedding,
      topics: turn.topicTags,
      emotionalState: turn.emotionalState,
      timestamp: turn.timestamp,
    );

    _semanticMemories.putIfAbsent(userId, () => []).add(memory);

    // Maintain memory size limit
    if (_semanticMemories[userId]!.length > 500) {
      _semanticMemories[userId]!.removeRange(0, _semanticMemories[userId]!.length - 500);
    }
  }

  Future<void> _saveConversationTurn(ConversationTurn turn) async {
    // Save individual turns for persistence
    await _saveConversationHistory();
  }

  Future<void> _saveConversationContext(ConversationContext context) async {
    final contextJson = jsonEncode(context.toJson());
    await _prefs?.setString('${_contextWindowKey}_${context.conversationId}', contextJson);
  }

  Future<void> _saveConversationHistory() async {
    try {
      final historyData = <String, dynamic>{};
      _conversationHistory.forEach((conversationId, turns) {
        historyData[conversationId] = turns.map((turn) => turn.toJson()).toList();
      });
      await _prefs?.setString(_conversationHistoryKey, jsonEncode(historyData));
    } catch (e) {
      AppLogger.error('Failed to save conversation history: $e');
    }
  }

  Future<void> _saveUserProfile(String userId, Map<String, dynamic> profile) async {
    try {
      _userProfiles[userId] = profile;
      await _prefs?.setString(_userPreferencesKey, jsonEncode(_userProfiles));
    } catch (e) {
      AppLogger.error('Failed to save user profile: $e');
    }
  }

  /// Cleanup resources
  void dispose() {
    _conversationUpdateController.close();
    _contextChangeController.close();
  }
}
