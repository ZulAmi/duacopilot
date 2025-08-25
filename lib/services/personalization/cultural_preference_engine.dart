import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'personalization_models.dart';

/// Cultural preference engine for learning and adapting to user's cultural and linguistic preferences
/// Handles language preferences, cultural tags, and region-specific customizations
class CulturalPreferenceEngine {
  static const String _culturalPreferencesKey = 'cultural_preferences_';
  static const String _languageInteractionsKey = 'language_interactions_';
  static const String _culturalContextKey = 'cultural_context_';

  // Cache for performance
  final Map<String, CulturalPreferences> _preferencesCache = {};

  /// Initialize cultural engine for a user
  Future<void> initialize(String userId, SharedPreferences prefs) async {
    try {
      // Load existing cultural preferences
      await _loadPreferences(userId, prefs);

      debugPrint('✅ Cultural preference engine initialized for user: $userId');
    } catch (e) {
      debugPrint('❌ Error initializing cultural preference engine: $e');
      rethrow;
    }
  }

  /// Get cultural preferences for a user
  Future<CulturalPreferences> getPreferences(String userId) async {
    // Check cache first
    if (_preferencesCache.containsKey(userId)) {
      return _preferencesCache[userId]!;
    }

    // Load from storage
    final prefs = await SharedPreferences.getInstance();
    return await _loadPreferences(userId, prefs);
  }

  /// Update cultural preferences based on user input
  Future<void> updatePreferences(CulturalPreferenceUpdate update) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentPrefs = await getPreferences(update.userId);

      // Build updated preferences
      final updatedPrefs = currentPrefs.copyWith(
        preferredLanguages: update.preferredLanguages ?? currentPrefs.preferredLanguages,
        primaryLanguage: update.primaryLanguage ?? currentPrefs.primaryLanguage,
        culturalTags: update.culturalTags ?? currentPrefs.culturalTags,
        languagePreferences: update.languagePreferences ?? currentPrefs.languagePreferences,
        customPreferences: {...currentPrefs.customPreferences, ...(update.customPreferences ?? {})},
        lastUpdated: update.timestamp,
      );

      await _savePreferences(updatedPrefs, prefs);

      debugPrint('🌍 Updated cultural preferences for user: ${update.userId}');
    } catch (e) {
      debugPrint('❌ Error updating cultural preferences: $e');
    }
  }

  /// Record cultural interaction for learning
  Future<void> recordCulturalInteraction(DuaInteraction interaction) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Extract cultural context from interaction
      final culturalContext = _extractCulturalContext(interaction);

      if (culturalContext.isNotEmpty) {
        await _recordCulturalContext(interaction.userId, culturalContext, prefs);
        await _updateLanguagePreferences(interaction, prefs);
      }

      debugPrint('🌐 Recorded cultural interaction for: ${interaction.userId}');
    } catch (e) {
      debugPrint('❌ Error recording cultural interaction: $e');
    }
  }

  /// Auto-detect user's preferred language based on interactions
  Future<String> detectPreferredLanguage(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final interactions = prefs.getStringList('$_languageInteractionsKey$userId') ?? [];

      final languageFrequency = <String, int>{};

      for (final interactionJson in interactions) {
        try {
          final data = json.decode(interactionJson);
          final language = data['language'] as String?;

          if (language != null) {
            languageFrequency[language] = (languageFrequency[language] ?? 0) + 1;
          }
        } catch (e) {
          continue; // Skip invalid entries
        }
      }

      if (languageFrequency.isNotEmpty) {
        // Return most frequently used language
        final mostUsed = languageFrequency.entries.reduce((a, b) => a.value > b.value ? a : b);

        debugPrint('🔍 Detected preferred language: ${mostUsed.key}');
        return mostUsed.key;
      }

      return 'en'; // Default to English
    } catch (e) {
      debugPrint('❌ Error detecting preferred language: $e');
      return 'en';
    }
  }

  /// Get cultural recommendations based on user context
  Future<List<String>> getCulturalRecommendations(String userId, String duaCategory) async {
    try {
      final preferences = await getPreferences(userId);
      final recommendations = <String>[];

      // Add language-specific recommendations
      for (final language in preferences.preferredLanguages) {
        recommendations.add('${duaCategory}_$language');
      }

      // Add cultural tag recommendations
      for (final tag in preferences.culturalTags) {
        recommendations.add('${duaCategory}_$tag');
      }

      return recommendations;
    } catch (e) {
      debugPrint('❌ Error getting cultural recommendations: $e');
      return [];
    }
  }

  /// Learn from user's cultural interaction patterns
  Future<void> learnFromPatterns(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final culturalData = prefs.getStringList('$_culturalContextKey$userId') ?? [];

      if (culturalData.isEmpty) return;

      // Analyze cultural patterns
      final regionFrequency = <String, int>{};
      final languageFrequency = <String, int>{};
      final timeOfDayLanguage = <String, Map<String, int>>{};

      for (final dataJson in culturalData) {
        try {
          final data = json.decode(dataJson);
          final region = data['region'] as String?;
          final language = data['language'] as String?;
          final timeOfDay = data['time_of_day'] as String?;

          if (region != null) {
            regionFrequency[region] = (regionFrequency[region] ?? 0) + 1;
          }

          if (language != null) {
            languageFrequency[language] = (languageFrequency[language] ?? 0) + 1;

            if (timeOfDay != null) {
              timeOfDayLanguage[timeOfDay] ??= {};
              timeOfDayLanguage[timeOfDay]![language] = (timeOfDayLanguage[timeOfDay]![language] ?? 0) + 1;
            }
          }
        } catch (e) {
          continue; // Skip invalid entries
        }
      }

      // Update preferences based on learned patterns
      await _updatePreferencesFromPatterns(userId, regionFrequency, languageFrequency, timeOfDayLanguage, prefs);

      debugPrint('🧠 Learned cultural patterns for user: $userId');
    } catch (e) {
      debugPrint('❌ Error learning from cultural patterns: $e');
    }
  }

  /// Clean up old cultural data for privacy compliance
  Future<void> cleanupOldData(DateTime cutoffDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get all cultural data keys
      final keys = prefs.getKeys().where(
        (key) =>
            key.contains('cultural_preferences_') ||
            key.contains('language_interactions_') ||
            key.contains('cultural_context_'),
      );

      for (final key in keys) {
        await _cleanupDataForKey(key, cutoffDate, prefs);
      }

      debugPrint('🧹 Cleaned up old cultural data before: $cutoffDate');
    } catch (e) {
      debugPrint('❌ Error cleaning up cultural data: $e');
    }
  }

  /// Load cultural preferences from storage
  Future<CulturalPreferences> _loadPreferences(String userId, SharedPreferences prefs) async {
    try {
      final prefsJson = prefs.getString('$_culturalPreferencesKey$userId');

      if (prefsJson != null) {
        final preferences = CulturalPreferences.fromJson(json.decode(prefsJson));
        _preferencesCache[userId] = preferences;
        return preferences;
      } else {
        // Create default preferences for new user
        final defaultPrefs = CulturalPreferences.defaultFor(userId);
        _preferencesCache[userId] = defaultPrefs;
        await _savePreferences(defaultPrefs, prefs);
        return defaultPrefs;
      }
    } catch (e) {
      debugPrint('❌ Error loading cultural preferences: $e');
      return CulturalPreferences.defaultFor(userId);
    }
  }

  /// Save cultural preferences to storage
  Future<void> _savePreferences(CulturalPreferences preferences, SharedPreferences prefs) async {
    try {
      final prefsJson = json.encode(preferences.toJson());
      await prefs.setString('$_culturalPreferencesKey${preferences.userId}', prefsJson);
      _preferencesCache[preferences.userId] = preferences;
    } catch (e) {
      debugPrint('❌ Error saving cultural preferences: $e');
    }
  }

  /// Extract cultural context from interaction
  Map<String, dynamic> _extractCulturalContext(DuaInteraction interaction) {
    final context = <String, dynamic>{};

    // Extract language if available
    if (interaction.metadata.containsKey('language')) {
      context['language'] = interaction.metadata['language'];
    }

    // Extract cultural markers
    if (interaction.metadata.containsKey('cultural_context')) {
      context['cultural_context'] = interaction.metadata['cultural_context'];
    }

    // Extract region if available
    if (interaction.metadata.containsKey('region')) {
      context['region'] = interaction.metadata['region'];
    }

    // Add time context
    context['time_of_day'] = _getTimeOfDayCategory(interaction.timestamp.hour);
    context['timestamp'] = interaction.timestamp.toIso8601String();

    return context;
  }

  /// Record cultural context for learning
  Future<void> _recordCulturalContext(String userId, Map<String, dynamic> context, SharedPreferences prefs) async {
    try {
      final contextHistory = prefs.getStringList('$_culturalContextKey$userId') ?? [];

      contextHistory.add(json.encode(context));

      // Keep only last 200 entries for privacy
      if (contextHistory.length > 200) {
        contextHistory.removeRange(0, contextHistory.length - 200);
      }

      await prefs.setStringList('$_culturalContextKey$userId', contextHistory);
    } catch (e) {
      debugPrint('❌ Error recording cultural context: $e');
    }
  }

  /// Update language preferences based on interaction
  Future<void> _updateLanguagePreferences(DuaInteraction interaction, SharedPreferences prefs) async {
    try {
      final language = interaction.metadata['language'] as String?;
      if (language == null) return;

      final interactions = prefs.getStringList('$_languageInteractionsKey${interaction.userId}') ?? [];

      final languageData = {
        'language': language,
        'interaction_type': interaction.type.name,
        'duration': interaction.duration.inSeconds,
        'timestamp': interaction.timestamp.toIso8601String(),
      };

      interactions.add(json.encode(languageData));

      // Keep only last 100 language interactions
      if (interactions.length > 100) {
        interactions.removeRange(0, interactions.length - 100);
      }

      await prefs.setStringList('$_languageInteractionsKey${interaction.userId}', interactions);
    } catch (e) {
      debugPrint('❌ Error updating language preferences: $e');
    }
  }

  /// Update preferences based on learned patterns
  Future<void> _updatePreferencesFromPatterns(
    String userId,
    Map<String, int> regionFrequency,
    Map<String, int> languageFrequency,
    Map<String, Map<String, int>> timeOfDayLanguage,
    SharedPreferences prefs,
  ) async {
    try {
      final currentPrefs = await getPreferences(userId);

      // Update language preferences based on frequency
      final updatedLanguagePrefs = <String, double>{};
      final totalInteractions = languageFrequency.values.fold(0, (sum, count) => sum + count);

      languageFrequency.forEach((language, count) {
        updatedLanguagePrefs[language] = count / totalInteractions;
      });

      // Update primary language if we have enough data
      String? newPrimaryLanguage;
      if (languageFrequency.isNotEmpty) {
        newPrimaryLanguage = languageFrequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      }

      // Update cultural tags based on regions
      final culturalTags = regionFrequency.keys.toList();

      final updatedPrefs = currentPrefs.copyWith(
        primaryLanguage: newPrimaryLanguage ?? currentPrefs.primaryLanguage,
        languagePreferences: updatedLanguagePrefs.isNotEmpty ? updatedLanguagePrefs : currentPrefs.languagePreferences,
        culturalTags: culturalTags.isNotEmpty ? culturalTags : currentPrefs.culturalTags,
        lastUpdated: DateTime.now(),
      );

      await _savePreferences(updatedPrefs, prefs);
    } catch (e) {
      debugPrint('❌ Error updating preferences from patterns: $e');
    }
  }

  /// Clean up data for a specific key based on cutoff date
  Future<void> _cleanupDataForKey(String key, DateTime cutoffDate, SharedPreferences prefs) async {
    try {
      if (key.contains('language_interactions_') || key.contains('cultural_context_')) {
        // Clean up interaction/context data
        final data = prefs.getStringList(key) ?? [];
        final filteredData = <String>[];

        for (final item in data) {
          try {
            final itemData = json.decode(item);
            final timestamp = DateTime.parse(itemData['timestamp']);

            if (timestamp.isAfter(cutoffDate)) {
              filteredData.add(item);
            }
          } catch (e) {
            continue; // Skip invalid entries
          }
        }

        await prefs.setStringList(key, filteredData);
      }
    } catch (e) {
      debugPrint('❌ Error cleaning up data for key $key: $e');
    }
  }

  /// Get time of day category
  String _getTimeOfDayCategory(int hour) {
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }

  /// Dispose resources
  void dispose() {
    _preferencesCache.clear();
  }
}
