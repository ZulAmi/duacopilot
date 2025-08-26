import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_logger.dart';
import '../../domain/entities/dua_entity.dart';
import '../time/islamic_time_service.dart';
import 'cultural_preference_engine.dart';
import 'personalization_models.dart';
import 'temporal_pattern_analyzer.dart';
import 'usage_pattern_analyzer.dart';

/// Comprehensive user personalization service for enhanced RAG recommendations
///
/// This service provides:
/// - Usage pattern tracking with local storage
/// - Session context maintenance using Riverpod state management
/// - Cultural and linguistic preference learning
/// - Temporal pattern recognition for habits
/// - Islamic calendar integration for seasonal recommendations
/// - Privacy-first personalization with on-device processing
class UserPersonalizationService {
  static UserPersonalizationService? _instance;
  static UserPersonalizationService get instance =>
      _instance ??= UserPersonalizationService._();

  UserPersonalizationService._();

  bool _isInitialized = false;
  String? _currentUserId;
  Timer? _sessionTimer;
  Timer? _analyticsTimer;

  // Core components
  late UsagePatternAnalyzer _usageAnalyzer;
  late CulturalPreferenceEngine _culturalEngine;
  late TemporalPatternAnalyzer _temporalAnalyzer;

  // Streams for real-time updates
  final StreamController<PersonalizationUpdate> _updateController =
      StreamController<PersonalizationUpdate>.broadcast();
  Stream<PersonalizationUpdate> get updateStream => _updateController.stream;

  final StreamController<List<EnhancedRecommendation>>
  _recommendationsController =
      StreamController<List<EnhancedRecommendation>>.broadcast();
  Stream<List<EnhancedRecommendation>> get recommendationsStream =>
      _recommendationsController.stream;

  // Session state management
  UserSession? _currentSession;
  final Map<String, dynamic> _sessionContext = {};

  // Privacy-first storage keys
  static const String _userContextKey = 'user_personalization_context';
  static const String _sessionHistoryKey = 'session_history';
  static const String _culturalPreferencesKey = 'cultural_preferences';
  static const String _temporalPatternsKey = 'temporal_patterns';
  static const String _usageStatisticsKey = 'usage_statistics';
  static const String _privacySettingsKey = 'privacy_settings';

  /// Initialize the personalization service
  Future<void> initialize({required String userId}) async {
    if (_isInitialized && _currentUserId == userId) return;

    try {
      _currentUserId = userId;

      // Initialize core components
      _usageAnalyzer = UsagePatternAnalyzer();
      _culturalEngine = CulturalPreferenceEngine();
      _temporalAnalyzer = TemporalPatternAnalyzer();

      // Load existing personalization data
      await _loadPersonalizationData();

      // Start session tracking
      await _startSession();

      // Initialize background analytics (privacy-first)
      _startAnalyticsProcessing();

      _isInitialized = true;
      AppLogger.info(
        '✅ User personalization service initialized for user: $userId',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to initialize personalization service: $e');
      rethrow;
    }
  }

  /// Public getters for accessing core components
  UsagePatternAnalyzer get usageAnalyzer => _usageAnalyzer;
  CulturalPreferenceEngine get culturalEngine => _culturalEngine;
  TemporalPatternAnalyzer get temporalAnalyzer => _temporalAnalyzer;

  /// Start a new user session
  Future<void> _startSession() async {
    final prefs = await SharedPreferences.getInstance();

    _currentSession = UserSession(
      id: _generateSessionId(),
      userId: _currentUserId!,
      startTime: DateTime.now(),
      context: _buildInitialSessionContext(),
      deviceInfo: await _getDeviceContext(),
    );

    // Update session context every 30 seconds
    _sessionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateSessionContext();
    });

    await _saveSessionStart(prefs);
  }

  /// Build enhanced RAG recommendations based on personalization
  Future<List<EnhancedRecommendation>> getEnhancedRecommendations({
    required String query,
    required List<DuaEntity> candidateDuas,
    Map<String, dynamic>? contextOverrides,
  }) async {
    await _ensureInitialized();

    try {
      // Combine all personalization signals
      final personalizationContext = await _buildComprehensiveContext(
        query: query,
        contextOverrides: contextOverrides,
      );

      // Process recommendations in compute isolate for privacy
      final recommendations = await compute(
        processRecommendationsIsolate,
        PersonalizationInput(
          query: query,
          candidateDuas: candidateDuas,
          context: personalizationContext,
          userId: _currentUserId!,
        ),
      );

      // Track recommendation generation
      await _trackRecommendationGeneration(query, recommendations);

      _recommendationsController.add(recommendations);
      return recommendations;
    } catch (e) {
      AppLogger.error('❌ Error generating enhanced recommendations: $e');
      return candidateDuas
          .map((dua) => EnhancedRecommendation.fromDua(dua))
          .toList();
    }
  }

  /// Build comprehensive personalization context
  Future<PersonalizationContext> _buildComprehensiveContext({
    required String query,
    Map<String, dynamic>? contextOverrides,
  }) async {
    final now = DateTime.now();

    // Get usage patterns
    final usagePatterns = await _usageAnalyzer.getPatterns(_currentUserId!);

    // Get cultural preferences
    final culturalPrefs = await _culturalEngine.getPreferences(_currentUserId!);

    // Get temporal patterns
    final temporalPatterns = await _temporalAnalyzer.analyzePatterns(
      _currentUserId!,
      now,
    );

    // Get Islamic calendar context
    final islamicContext = IslamicTimeService.instance.getCurrentTimeContext();

    // Get location-based context (if permitted)
    final locationContext = await _getLocationContext();

    return PersonalizationContext(
      userId: _currentUserId!,
      sessionId: _currentSession?.id ?? '',
      query: query,
      timestamp: now,
      usagePatterns: usagePatterns,
      culturalPreferences: culturalPrefs,
      temporalPatterns: temporalPatterns,
      islamicTimeContext: islamicContext,
      locationContext: locationContext,
      sessionContext: _sessionContext,
      privacyLevel: await _getPrivacyLevel(),
      customContext: contextOverrides ?? {},
    );
  }

  /// Track Du'a interaction for pattern learning
  Future<void> trackDuaInteraction({
    required String duaId,
    required InteractionType type,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) async {
    await _ensureInitialized();

    try {
      final interaction = DuaInteraction(
        duaId: duaId,
        userId: _currentUserId!,
        sessionId: _currentSession?.id ?? '',
        type: type,
        timestamp: DateTime.now(),
        duration: duration,
        context: Map.from(_sessionContext),
        metadata: metadata ?? {},
      );

      // Update usage patterns
      await _usageAnalyzer.recordInteraction(interaction);

      // Update temporal patterns
      await _temporalAnalyzer.recordInteraction(interaction);

      // Update cultural preferences if relevant
      if (metadata?.containsKey('language') == true ||
          metadata?.containsKey('cultural_context') == true) {
        await _culturalEngine.recordCulturalInteraction(interaction);
      }

      // Broadcast update
      _updateController.add(
        PersonalizationUpdate(
          type: UpdateType.interaction,
          data: interaction,
          timestamp: DateTime.now(),
        ),
      );

      AppLogger.debug('📊 Tracked interaction: $type for Du\'a $duaId');
    } catch (e) {
      AppLogger.error('❌ Error tracking Du\'a interaction: $e');
    }
  }

  /// Update cultural and linguistic preferences
  Future<void> updateCulturalPreferences({
    List<String>? preferredLanguages,
    String? primaryLanguage,
    List<String>? culturalTags,
    Map<String, double>? languagePreferences,
    Map<String, dynamic>? customPreferences,
  }) async {
    await _ensureInitialized();

    try {
      final update = CulturalPreferenceUpdate(
        userId: _currentUserId!,
        preferredLanguages: preferredLanguages,
        primaryLanguage: primaryLanguage,
        culturalTags: culturalTags,
        languagePreferences: languagePreferences,
        customPreferences: customPreferences,
        timestamp: DateTime.now(),
      );

      await _culturalEngine.updatePreferences(update);

      // Broadcast update
      _updateController.add(
        PersonalizationUpdate(
          type: UpdateType.culturalPreferences,
          data: update,
          timestamp: DateTime.now(),
        ),
      );

      AppLogger.info(
        '🌍 Updated cultural preferences for user: $_currentUserId',
      );
    } catch (e) {
      AppLogger.error('❌ Error updating cultural preferences: $e');
    }
  }

  /// Get personalized Du'a suggestions for current time/context
  Future<List<EnhancedRecommendation>> getContextualSuggestions({
    int limit = 5,
  }) async {
    await _ensureInitialized();

    try {
      final now = DateTime.now();
      final islamicContext =
          IslamicTimeService.instance.getCurrentTimeContext();

      // Get time-based patterns
      final timePatterns = await _temporalAnalyzer.getTimeBasedPatterns(
        _currentUserId!,
        now,
      );

      // Get location-based suggestions (if available)
      final locationSuggestions = await _getLocationBasedSuggestions();

      // Combine with usage patterns
      final usagePatterns = await _usageAnalyzer.getPatterns(_currentUserId!);

      // Process suggestions in isolate
      final suggestions = await compute(
        generateContextualSuggestionsIsolate,
        ContextualSuggestionInput(
          userId: _currentUserId!,
          timestamp: now,
          islamicContext: islamicContext,
          timePatterns: timePatterns,
          usagePatterns: usagePatterns,
          locationSuggestions: locationSuggestions,
          limit: limit,
        ),
      );

      return suggestions;
    } catch (e) {
      AppLogger.error('❌ Error generating contextual suggestions: $e');
      return [];
    }
  }

  /// Get user's privacy level and settings
  Future<PrivacyLevel> _getPrivacyLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final privacySettings = prefs.getString(_privacySettingsKey);

    if (privacySettings != null) {
      final settings = json.decode(privacySettings);
      return PrivacyLevel.values.firstWhere(
        (level) => level.name == settings['level'],
        orElse: () => PrivacyLevel.balanced,
      );
    }

    return PrivacyLevel.balanced;
  }

  /// Get location context if permission granted and privacy allows
  Future<LocationContext?> _getLocationContext() async {
    try {
      final privacyLevel = await _getPrivacyLevel();
      if (privacyLevel == PrivacyLevel.strict) return null;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 5),
      );

      return LocationContext(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      AppLogger.debug('🗺️ Location context not available: $e');
      return null;
    }
  }

  /// Start background analytics processing (privacy-first)
  void _startAnalyticsProcessing() {
    // Process analytics data every 5 minutes
    _analyticsTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _processAnalytics();
    });
  }

  /// Process analytics data in background (privacy-first)
  Future<void> _processAnalytics() async {
    try {
      if (_currentSession == null) return;

      // Update temporal patterns
      await _temporalAnalyzer.processSessionData(_currentSession!);

      // Update usage statistics
      await _usageAnalyzer.processAnalytics(_currentUserId!);

      // Clean old data to preserve privacy
      await _cleanupOldData();

      AppLogger.debug('📈 Background analytics processed');
    } catch (e) {
      AppLogger.error('❌ Error processing analytics: $e');
    }
  }

  /// Clean up old data for privacy compliance
  Future<void> _cleanupOldData() async {
    final prefs = await SharedPreferences.getInstance();
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

    // Implementation would clean data older than privacy retention period
    await _usageAnalyzer.cleanupOldData(cutoffDate);
    await _temporalAnalyzer.cleanupOldData(cutoffDate);
    await _culturalEngine.cleanupOldData(cutoffDate);
  }

  /// Build initial session context
  Map<String, dynamic> _buildInitialSessionContext() {
    final now = DateTime.now();
    return {
      'session_start': now.toIso8601String(),
      'day_of_week': DateFormat('EEEE').format(now),
      'time_of_day': _getTimeOfDayCategory(now),
      'islamic_date': IslamicTimeService.instance.getCurrentTimeContext(),
    };
  }

  /// Update session context with current state
  void _updateSessionContext() {
    if (_currentSession == null) return;

    _sessionContext.addAll({
      'session_duration':
          DateTime.now().difference(_currentSession!.startTime).inMinutes,
      'last_update': DateTime.now().toIso8601String(),
    });
  }

  /// Generate unique session ID
  String _generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'session_${timestamp}_$random';
  }

  /// Get device context for session
  Future<Map<String, dynamic>> _getDeviceContext() async {
    return {
      'platform': defaultTargetPlatform.name,
      'locale': Intl.getCurrentLocale(),
      'timezone': DateTime.now().timeZoneName,
    };
  }

  /// Get time of day category
  String _getTimeOfDayCategory(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }

  /// Load existing personalization data
  Future<void> _loadPersonalizationData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load components
    await _usageAnalyzer.initialize(_currentUserId!, prefs);
    await _culturalEngine.initialize(_currentUserId!, prefs);
    await _temporalAnalyzer.initialize(_currentUserId!, prefs);
  }

  /// Save session start to storage
  Future<void> _saveSessionStart(SharedPreferences prefs) async {
    if (_currentSession == null) return;

    final sessions =
        prefs.getStringList('${_sessionHistoryKey}_$_currentUserId') ?? [];
    sessions.add(json.encode(_currentSession!.toJson()));

    // Keep only last 50 sessions for privacy
    if (sessions.length > 50) {
      sessions.removeRange(0, sessions.length - 50);
    }

    await prefs.setStringList(
      '${_sessionHistoryKey}_$_currentUserId',
      sessions,
    );
  }

  /// Track recommendation generation for learning
  Future<void> _trackRecommendationGeneration(
    String query,
    List<EnhancedRecommendation> recommendations,
  ) async {
    // Track for pattern learning (privacy-preserving)
    await _usageAnalyzer.trackQuery(query, recommendations.length);

    // Update temporal patterns
    final interaction = DuaInteraction(
      duaId: 'query_generation',
      userId: _currentUserId!,
      sessionId: _currentSession?.id ?? '',
      type: InteractionType.search,
      timestamp: DateTime.now(),
      duration: Duration.zero,
      context: {'query': query, 'result_count': recommendations.length},
      metadata: {'recommendations': recommendations.length},
    );

    await _temporalAnalyzer.recordInteraction(interaction);
  }

  /// Get location-based suggestions
  Future<List<String>> _getLocationBasedSuggestions() async {
    final locationContext = await _getLocationContext();
    if (locationContext == null) return [];

    // Implementation would provide location-aware suggestions
    // For example, travel Du'as when away from home location
    return [];
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      throw StateError(
        'PersonalizationService not initialized. Call initialize() first.',
      );
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    _sessionTimer?.cancel();
    _analyticsTimer?.cancel();
    await _updateController.close();
    await _recommendationsController.close();
    _isInitialized = false;
  }
}

/// Top-level function for compute isolate processing
List<EnhancedRecommendation> processRecommendationsIsolate(
  PersonalizationInput input,
) {
  // Process recommendations based on personalization context
  // This runs in an isolate for privacy and performance

  final recommendations = <EnhancedRecommendation>[];

  for (final dua in input.candidateDuas) {
    final score = calculatePersonalizationScore(dua, input.context);

    recommendations.add(
      EnhancedRecommendation(
        dua: dua,
        personalizationScore: score,
        reasoning: generateReasoning(dua, input.context, score),
        contextTags: generateContextTags(dua, input.context),
        confidence: score.overall,
      ),
    );
  }

  // Sort by personalization score
  recommendations.sort(
    (a, b) => b.personalizationScore.overall.compareTo(
      a.personalizationScore.overall,
    ),
  );

  return recommendations;
}

/// Calculate personalization score for a Du'a
PersonalizationScore calculatePersonalizationScore(
  DuaEntity dua,
  PersonalizationContext context,
) {
  double usageScore = 0.0;
  double culturalScore = 0.0;
  double temporalScore = 0.0;
  double contextualScore = 0.0;

  // Calculate usage-based score
  if (context.usagePatterns.frequentDuas.contains(dua.id)) {
    usageScore += 0.8;
  }

  if (context.usagePatterns.recentDuas.contains(dua.id)) {
    usageScore += 0.6;
  }

  // Calculate cultural score
  // Check if Du'a has content in preferred languages (simplified approach)
  final hasArabic = dua.arabicText.isNotEmpty;
  final hasTranslation = dua.translation.isNotEmpty;

  if ((context.culturalPreferences.preferredLanguages.contains('ar') &&
          hasArabic) ||
      (context.culturalPreferences.preferredLanguages.any(
            (lang) => lang != 'ar',
          ) &&
          hasTranslation)) {
    culturalScore += 0.9;
  }

  // Calculate temporal score
  final currentHour = context.timestamp.hour;
  if (context.temporalPatterns.hourlyPatterns.containsKey(currentHour)) {
    final hourPattern = context.temporalPatterns.hourlyPatterns[currentHour]!;
    if (hourPattern.popularDuas.contains(dua.id)) {
      temporalScore += 0.7;
    }
  }

  // Calculate contextual score (Islamic calendar, location, etc.)
  if (context.islamicTimeContext.specialOccasions.isNotEmpty) {
    // Boost score for occasion-appropriate Du'as
    contextualScore += 0.5;
  }

  final overall =
      (usageScore + culturalScore + temporalScore + contextualScore) / 4;

  return PersonalizationScore(
    usage: usageScore,
    cultural: culturalScore,
    temporal: temporalScore,
    contextual: contextualScore,
    overall: overall,
  );
}

/// Generate reasoning for recommendation
List<String> generateReasoning(
  DuaEntity dua,
  PersonalizationContext context,
  PersonalizationScore score,
) {
  final reasons = <String>[];

  if (score.usage > 0.5) {
    reasons.add('Based on your reading history');
  }

  if (score.cultural > 0.5) {
    reasons.add('Matches your language preferences');
  }

  if (score.temporal > 0.5) {
    reasons.add('Popular at this time of day');
  }

  if (score.contextual > 0.5) {
    reasons.add('Appropriate for current Islamic date');
  }

  return reasons;
}

/// Generate context tags for recommendation
List<String> generateContextTags(
  DuaEntity dua,
  PersonalizationContext context,
) {
  final tags = <String>[];

  if (context.islamicTimeContext.isRamadan) {
    tags.add('ramadan');
  }

  if (context.islamicTimeContext.isHajjSeason) {
    tags.add('hajj');
  }

  tags.add(context.timestamp.hour < 12 ? 'morning' : 'evening');

  return tags;
}

/// Top-level function for contextual suggestions isolate
List<EnhancedRecommendation> generateContextualSuggestionsIsolate(
  ContextualSuggestionInput input,
) {
  // Generate contextual suggestions in isolate
  final suggestions = <EnhancedRecommendation>[];

  // Implementation would use temporal and usage patterns
  // to generate relevant suggestions

  return suggestions.take(input.limit).toList();
}
