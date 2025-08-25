import 'dart:async';

import '../../core/logging/app_logger.dart';
import '../services/enhanced_services/sophisticated_rag_integration_service_fixed.dart';

/// Example usage of the fixed sophisticated RAG integration service
class SophisticatedRagExample {
  late SophisticatedRagIntegrationServiceFixed _ragService;

  Future<void> initialize() async {
    _ragService = SophisticatedRagIntegrationServiceFixed.instance;
    await _ragService.initialize();

    AppLogger.info('Sophisticated RAG Example initialized');
  }

  /// Process a text query with sophisticated features
  Future<void> processTextQuery(String query, {String? userId}) async {
    try {
      AppLogger.info('Processing text query: $query');

      // Process query with full sophisticated analysis
      final result = await _ragService.processQuery(
        query: query,
        queryType: QueryType.text,
        userId: userId,
        additionalContext: {'source': 'example_usage', 'session_type': 'interactive'},
      );

      // Display results
      AppLogger.info('Query processed successfully!');
      AppLogger.info('Query ID: ${result.queryId}');
      AppLogger.info('Processing Time: ${result.processingTime.inMilliseconds}ms');
      AppLogger.info('Detected Emotion: ${result.emotionAnalysis.detectedEmotion}');
      AppLogger.info('Emotion Confidence: ${result.emotionAnalysis.confidence}');
      AppLogger.info('Calendar Suggestions: ${result.calendarContext.length}');
      AppLogger.info('Cultural Recommendations: ${result.culturalRecommendations.length}');

      // Show cultural adaptations
      if (result.culturalRecommendations.isNotEmpty) {
        AppLogger.info('Cultural Duas suggested:');
        for (int i = 0; i < result.culturalRecommendations.length; i++) {
          AppLogger.info('  ${i + 1}. ${result.culturalRecommendations[i]}');
        }
      }

      // Show calendar context
      if (result.calendarContext.isNotEmpty) {
        AppLogger.info('Calendar context:');
        for (final suggestion in result.calendarContext) {
          AppLogger.info('  - ${suggestion.suggestionText} (${suggestion.category})');
        }
      }
    } catch (e) {
      AppLogger.error('Failed to process sophisticated query: $e');
    }
  }

  /// Process a voice query with sophisticated features
  Future<void> processVoiceQuery(String query, {String? userId}) async {
    try {
      AppLogger.info('Processing voice query: $query');

      // Start voice listening
      await _ragService.startVoiceListening(userId: userId);

      // Wait a moment for voice input (in real usage, this would be handled by voice service events)
      await Future.delayed(Duration(seconds: 2));

      // Stop voice listening
      await _ragService.stopVoiceListening();

      // Process the query as voice type
      await _ragService.processQuery(query: query, queryType: QueryType.voice, userId: userId);

      AppLogger.info('Voice query processed successfully!');
      AppLogger.info('Voice Status: ${_ragService.voiceStatus}');
    } catch (e) {
      AppLogger.error('Failed to process voice query: $e');
    }
  }

  /// Start a new conversation session
  Future<String> startNewConversationSession({String? userId}) async {
    try {
      final conversationId = await _ragService.startNewConversation(userId: userId);
      AppLogger.info('Started new conversation: $conversationId');
      return conversationId;
    } catch (e) {
      AppLogger.error('Failed to start new conversation: $e');
      rethrow;
    }
  }

  /// Get conversation history
  Future<void> showConversationHistory({String? conversationId}) async {
    try {
      final history = await _ragService.getConversationHistory(conversationId: conversationId);

      AppLogger.info('Conversation history (${history.length} turns):');
      for (int i = 0; i < history.length; i++) {
        final turn = history[i];
        AppLogger.info('  ${i + 1}. User: ${turn.userInput}');
        AppLogger.info('      System: ${turn.systemResponse}');
        AppLogger.info('      Intent: ${turn.intent}');
        AppLogger.info('      Time: ${turn.timestamp}');
      }
    } catch (e) {
      AppLogger.error('Failed to get conversation history: $e');
    }
  }

  /// Update cultural preferences
  Future<void> updateUserCulturalPreferences({
    String? country,
    String? region,
    List<String>? languages,
    String? islamicSchool,
  }) async {
    try {
      await _ragService.updateCulturalPreferences(
        country: country ?? 'United States',
        region: region ?? 'North America',
        preferredLanguages: languages ?? ['en-US', 'ar'],
        islamicSchool: islamicSchool ?? 'Sunni',
        additionalPreferences: {'prayer_calculation_method': 'ISNA', 'hijri_adjustment': 0},
      );

      AppLogger.info('Cultural preferences updated successfully');

      final culturalContext = _ragService.currentCulturalContext;
      if (culturalContext != null) {
        AppLogger.info('Current cultural context: ${culturalContext.country}');
        AppLogger.info('Primary language: ${culturalContext.primaryLanguage}');
        AppLogger.info('Islamic school: ${culturalContext.islamicSchool}');
      }
    } catch (e) {
      AppLogger.error('Failed to update cultural preferences: $e');
    }
  }

  /// Get system analytics
  Future<void> showAnalytics({String? userId}) async {
    try {
      final analytics = await _ragService.getAnalytics(userId: userId);

      AppLogger.info('System Analytics:');
      AppLogger.info('Generated at: ${analytics['generated_at']}');
      AppLogger.info('Is initialized: ${analytics['is_initialized']}');
      AppLogger.info('Current conversation: ${analytics['current_conversation']}');

      if (analytics['cultural_context'] != null) {
        AppLogger.info('Cultural context: ${analytics['cultural_context']}');
      }
    } catch (e) {
      AppLogger.error('Failed to get analytics: $e');
    }
  }

  /// Subscribe to query processing events
  void subscribeToEvents() {
    // Subscribe to query processing results
    _ragService.queryProcessedStream.listen((result) {
      AppLogger.info('Query processed event: ${result.queryId}');
      AppLogger.info('Processing time: ${result.processingTime.inMilliseconds}ms');
    });

    // Subscribe to context updates
    _ragService.contextUpdateStream.listen((update) {
      AppLogger.info('Context update: ${update.type}');
      AppLogger.info('Data: ${update.data}');
      AppLogger.info('Timestamp: ${update.timestamp}');
    });
  }

  /// Comprehensive usage example
  Future<void> runComprehensiveExample() async {
    try {
      AppLogger.info('=== Starting Sophisticated RAG Example ===');

      // Initialize the service
      await initialize();

      // Subscribe to events
      subscribeToEvents();

      // Start a new conversation
      final conversationId = await startNewConversationSession(userId: 'demo_user');

      // Update cultural preferences
      await updateUserCulturalPreferences(
        country: 'Morocco',
        region: 'North Africa',
        languages: ['ar', 'fr', 'en'],
        islamicSchool: 'Maliki',
      );

      // Process various types of queries
      await processTextQuery('I need guidance on morning prayers and daily supplications', userId: 'demo_user');

      await Future.delayed(Duration(seconds: 1));

      await processTextQuery('I am feeling anxious about my job interview tomorrow', userId: 'demo_user');

      await Future.delayed(Duration(seconds: 1));

      await processVoiceQuery('What du\'a should I recite before traveling?', userId: 'demo_user');

      // Show conversation history
      await showConversationHistory(conversationId: conversationId);

      // Show analytics
      await showAnalytics(userId: 'demo_user');

      AppLogger.info('=== Sophisticated RAG Example Completed ===');
    } catch (e) {
      AppLogger.error('Comprehensive example failed: $e');
    }
  }

  /// Cleanup resources
  void dispose() {
    _ragService.dispose();
  }
}

/// Quick usage example function
Future<void> quickSophisticatedRagExample() async {
  final example = SophisticatedRagExample();

  try {
    await example.runComprehensiveExample();
  } finally {
    example.dispose();
  }
}
