import 'dart:async';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';
import '../calendar/advanced_calendar_service.dart';
import '../conversation/conversation_memory_service.dart';
import '../cultural/cultural_adaptation_service.dart';
import '../emotion/enhanced_emotion_detection_service.dart';
import '../secure_storage/secure_storage_service.dart';
import '../voice/enhanced_voice_service.dart';
import 'proactive_background_service.dart' as proactive;

/// Fixed sophisticated RAG integration service that works with existing APIs
class SophisticatedRagIntegrationServiceFixed {
  // Service instances
  late ConversationMemoryService _conversationMemory;
  late EnhancedVoiceService _voiceService;
  late AdvancedCalendarService _calendarService;
  late EnhancedEmotionDetectionService _emotionService;
  late proactive.ProactiveBackgroundService _backgroundService;
  late CulturalAdaptationService _culturalService;
  late SecureStorageService _secureStorage;

  // State management
  bool _isInitialized = false;
  String? _currentConversationId;
  CulturalContext? _currentCulturalContext;

  // Stream controllers
  final _queryProcessedController = StreamController<SophisticatedQueryResult>.broadcast();
  final _contextUpdateController = StreamController<ContextUpdate>.broadcast();

  // Public streams
  Stream<SophisticatedQueryResult> get queryProcessedStream => _queryProcessedController.stream;
  Stream<ContextUpdate> get contextUpdateStream => _contextUpdateController.stream;

  // Singleton pattern
  static SophisticatedRagIntegrationServiceFixed? _instance;
  static SophisticatedRagIntegrationServiceFixed get instance =>
      _instance ??= SophisticatedRagIntegrationServiceFixed._();

  SophisticatedRagIntegrationServiceFixed._() {
    _initializeServices();
  }

  /// Initialize all services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Fixed Sophisticated RAG Integration Service...');

      // Initialize core services
      _secureStorage = SecureStorageService.instance;
      await _secureStorage.initialize();

      // Initialize enhanced services
      await _conversationMemory.initialize();
      await _voiceService.initialize();
      await _calendarService.initialize();
      await _emotionService.initialize();
      await _culturalService.initialize();

      // Start background service
      await _backgroundService.startService();

      // Load current cultural context
      _currentCulturalContext = await _culturalService.getCurrentCulturalContext();

      _isInitialized = true;
      AppLogger.info('Fixed Sophisticated RAG Integration Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Fixed Sophisticated RAG Integration Service: $e');
      rethrow;
    }
  }

  /// Process sophisticated query using existing APIs
  Future<SophisticatedQueryResult> processQuery({
    required String query,
    QueryType queryType = QueryType.text,
    String? userId,
    Map<String, dynamic>? additionalContext,
  }) async {
    await _ensureInitialized();

    try {
      AppLogger.info('Processing sophisticated query: ${query.substring(0, 50)}...');

      final startTime = DateTime.now();
      final queryId = 'query_${startTime.millisecondsSinceEpoch}';
      final userIdFinal = userId ?? 'anonymous';

      // Start or continue conversation using existing API
      if (_currentConversationId == null) {
        final context = await _conversationMemory.startConversation(userIdFinal);
        _currentConversationId = context.conversationId;
      }

      // Detect emotion using correct API
      final emotionResult = await _emotionService.detectEmotion(text: query, userId: userIdFinal);

      // Get calendar context using correct API
      final calendarContext = await _calendarService.getContextualSuggestions();

      // Get cultural adaptations using existing API
      final culturalRecommendations = await _culturalService.getCulturalDuaRecommendations(
        category: _categorizeQuery(query),
        userId: userIdFinal,
        emotionalState: emotionResult.detectedEmotion,
      );

      // Add conversation turn using correct API
      await _conversationMemory.addConversationTurn(
        conversationId: _currentConversationId!,
        userInput: query,
        systemResponse: 'Processing sophisticated query...',
        intent: _categorizeQuery(query),
        metadata: {
          'query_type': queryType.toString(),
          'emotion_confidence': emotionResult.confidence,
          'cultural_context': _currentCulturalContext?.country,
        },
      );

      // Build result
      final result = SophisticatedQueryResult(
        queryId: queryId,
        originalQuery: query,
        processedQuery: query,
        queryType: queryType,
        conversationId: _currentConversationId!,
        emotionAnalysis: emotionResult,
        voiceResult: null,
        calendarContext: calendarContext,
        culturalRecommendations: culturalRecommendations,
        contextualPrompt: _buildContextualPrompt(query, emotionResult, calendarContext, culturalRecommendations),
        culturalContext: _currentCulturalContext,
        processingTime: DateTime.now().difference(startTime),
        timestamp: startTime,
      );

      // Record interaction
      await _recordInteraction(query, emotionResult.detectedEmotion, queryType);

      // Emit result
      _queryProcessedController.add(result);

      AppLogger.info('Sophisticated query processed successfully in ${result.processingTime.inMilliseconds}ms');
      return result;
    } catch (e) {
      AppLogger.error('Failed to process sophisticated query: $e');
      rethrow;
    }
  }

  /// Start new conversation
  Future<String> startNewConversation({String? userId}) async {
    await _ensureInitialized();

    final context = await _conversationMemory.startConversation(userId ?? 'anonymous');
    _currentConversationId = context.conversationId;

    AppLogger.info('Started new conversation: $_currentConversationId');
    return _currentConversationId!;
  }

  /// Get conversation history
  Future<List<ConversationTurn>> getConversationHistory({String? conversationId}) async {
    await _ensureInitialized();

    final id = conversationId ?? _currentConversationId;
    if (id == null) return [];

    return await _conversationMemory.getRecentHistory(id);
  }

  /// Start voice listening
  Future<void> startVoiceListening({String? userId}) async {
    await _ensureInitialized();

    // Get preferred language from cultural context
    final culturalLanguages = await _culturalService.getPreferredLanguages();
    final primaryLanguage = culturalLanguages.isNotEmpty ? culturalLanguages.first : 'en-US';

    await _voiceService.startListening(language: primaryLanguage, enableArabicEnhancements: true);
  }

  /// Stop voice listening
  Future<void> stopVoiceListening() async {
    await _ensureInitialized();
    await _voiceService.stopListening();
  }

  /// Get voice service status
  VoiceStatus get voiceStatus => _voiceService.isListening ? VoiceStatus.listening : VoiceStatus.stopped;

  /// Get upcoming Islamic events
  Future<List<CalendarEvent>> getUpcomingIslamicEvents() async {
    await _ensureInitialized();
    return await _calendarService.getUpcomingEvents();
  }

  /// Update cultural preferences
  Future<void> updateCulturalPreferences({
    String? country,
    String? region,
    List<String>? preferredLanguages,
    String? islamicSchool,
    Map<String, dynamic>? additionalPreferences,
  }) async {
    await _ensureInitialized();

    if (country != null && region != null) {
      await _culturalService.setManualCulturalContext(
        country: country,
        region: region,
        primaryLanguage: preferredLanguages?.first ?? 'en',
        preferredLanguages: preferredLanguages ?? ['en'],
        islamicSchool: islamicSchool ?? 'Sunni',
        additionalPreferences: additionalPreferences,
      );

      _currentCulturalContext = await _culturalService.getCurrentCulturalContext();

      _contextUpdateController.add(
        ContextUpdate(
          type: ContextUpdateType.cultural,
          data: _currentCulturalContext?.toJson() ?? {},
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  /// Get analytics
  Future<Map<String, dynamic>> getAnalytics({String? userId}) async {
    await _ensureInitialized();

    // Simple analytics using available APIs
    return {
      'cultural_context': _currentCulturalContext?.toJson(),
      'current_conversation': _currentConversationId,
      'is_initialized': _isInitialized,
      'generated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Check if services are initialized
  bool get isInitialized => _isInitialized;

  /// Get current cultural context
  CulturalContext? get currentCulturalContext => _currentCulturalContext;

  // Private helper methods

  void _initializeServices() {
    _conversationMemory = ConversationMemoryService.instance;
    _voiceService = EnhancedVoiceService.instance;
    _calendarService = AdvancedCalendarService.instance;
    _emotionService = EnhancedEmotionDetectionService.instance;
    _backgroundService = proactive.ProactiveBackgroundService.instance;
    _culturalService = CulturalAdaptationService.instance;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  String _categorizeQuery(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('travel') || lowerQuery.contains('journey')) return 'travel';
    if (lowerQuery.contains('work') || lowerQuery.contains('job')) return 'work';
    if (lowerQuery.contains('health') || lowerQuery.contains('sick')) return 'health';
    if (lowerQuery.contains('guidance') || lowerQuery.contains('help')) return 'guidance';
    if (lowerQuery.contains('gratitude') || lowerQuery.contains('thank')) return 'gratitude';

    return 'general';
  }

  String _buildContextualPrompt(
    String query,
    EmotionalDetection emotionResult,
    List<ContextualSuggestion> calendarContext,
    List<String> culturalRecommendations,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('Query: $query');
    buffer.writeln('Emotional State: ${emotionResult.detectedEmotion}');
    buffer.writeln('Confidence: ${emotionResult.confidence}');

    if (calendarContext.isNotEmpty) {
      buffer.writeln('Calendar Context: ${calendarContext.map((s) => s.suggestionText).join(', ')}');
    }

    if (culturalRecommendations.isNotEmpty) {
      buffer.writeln('Cultural Recommendations: ${culturalRecommendations.join(', ')}');
    }

    return buffer.toString();
  }

  Future<void> _recordInteraction(String query, EmotionalState? emotion, QueryType queryType) async {
    final interaction = proactive.UserInteraction(
      id: 'interaction_${DateTime.now().millisecondsSinceEpoch}',
      category: _categorizeQuery(query),
      action: 'query_processed',
      timestamp: DateTime.now(),
      emotionalState: emotion,
      metadata: {'query_type': queryType.toString(), 'query_length': query.length},
    );

    await _backgroundService.recordInteraction(interaction);
  }

  /// Cleanup resources
  void dispose() {
    _queryProcessedController.close();
    _contextUpdateController.close();
  }
}

// Supporting classes with simple implementations

enum QueryType { text, voice }

enum VoiceStatus { stopped, listening, processing }

enum ContextUpdateType { cultural, location, conversation }

class SophisticatedQueryResult {
  final String queryId;
  final String originalQuery;
  final String processedQuery;
  final QueryType queryType;
  final String conversationId;
  final EmotionalDetection emotionAnalysis;
  final VoiceQueryResult? voiceResult;
  final List<ContextualSuggestion> calendarContext;
  final List<String> culturalRecommendations;
  final String contextualPrompt;
  final CulturalContext? culturalContext;
  final Duration processingTime;
  final DateTime timestamp;

  SophisticatedQueryResult({
    required this.queryId,
    required this.originalQuery,
    required this.processedQuery,
    required this.queryType,
    required this.conversationId,
    required this.emotionAnalysis,
    this.voiceResult,
    required this.calendarContext,
    required this.culturalRecommendations,
    required this.contextualPrompt,
    this.culturalContext,
    required this.processingTime,
    required this.timestamp,
  });
}

class VoiceQueryResult {
  final String transcription;
  final double confidence;
  final List<String> alternatives;
  final String language;
  final Duration processingTime;
  final DateTime timestamp;

  VoiceQueryResult({
    required this.transcription,
    required this.confidence,
    required this.alternatives,
    required this.language,
    required this.processingTime,
    required this.timestamp,
  });
}

class ContextUpdate {
  final ContextUpdateType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  ContextUpdate({required this.type, required this.data, required this.timestamp});
}
