import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'personalization_models.dart';
import 'user_personalization_service.dart';

/// Provider for UserPersonalizationService
final userPersonalizationServiceProvider = Provider<UserPersonalizationService>(
  (ref) {
    return UserPersonalizationService.instance;
  },
);

/// StateNotifier for managing personalization state
class PersonalizationNotifier extends StateNotifier<PersonalizationState> {
  final UserPersonalizationService _service;
  final String? _userId;

  PersonalizationNotifier(this._service, this._userId)
      : super(const PersonalizationState.initial());

  /// Initialize personalization for user
  Future<void> initialize(String userId) async {
    state = const PersonalizationState.loading();

    try {
      await _service.initialize(userId: userId);

      // Load initial data
      final usagePatterns = await _service.usageAnalyzer.getPatterns(userId);
      final culturalPreferences = await _service.culturalEngine.getPreferences(
        userId,
      );

      state = PersonalizationState.loaded(
        usagePatterns: usagePatterns,
        culturalPreferences: culturalPreferences,
        isPersonalizationActive: true,
      );
    } catch (error, stackTrace) {
      state = PersonalizationState.error(error, stackTrace);
    }
  }

  /// Update cultural preferences
  Future<void> updateCulturalPreferences(
    CulturalPreferenceUpdate update,
  ) async {
    try {
      await _service.updateCulturalPreferences(
        preferredLanguages: update.preferredLanguages,
        primaryLanguage: update.primaryLanguage,
        culturalTags: update.culturalTags,
        languagePreferences: update.languagePreferences,
        customPreferences: update.customPreferences,
      );

      // Refresh state
      if (_userId != null) {
        final updatedPrefs = await _service.culturalEngine.getPreferences(
          _userId,
        );
        state = state.maybeWhen(
          loaded: (
            usagePatterns,
            culturalPreferences,
            isActive,
            recommendations,
            contextualSuggestions,
            temporalPatterns,
            metadata,
          ) =>
              PersonalizationState.loaded(
            usagePatterns: usagePatterns,
            culturalPreferences: updatedPrefs,
            isPersonalizationActive: isActive,
            recommendations: recommendations,
            contextualSuggestions: contextualSuggestions,
            temporalPatterns: temporalPatterns,
            metadata: metadata,
          ),
          orElse: () => state,
        );
      }
    } catch (error, stackTrace) {
      state = PersonalizationState.error(error, stackTrace);
    }
  }

  /// Track Du'a interaction
  Future<void> trackInteraction({
    required String duaId,
    required InteractionType type,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _service.trackDuaInteraction(
        duaId: duaId,
        type: type,
        duration: duration,
        metadata: metadata,
      );
    } catch (error) {
      // Log error but don't change state for tracking failures
      print('Error tracking interaction: $error');
    }
  }

  /// Get enhanced recommendations
  Future<List<EnhancedRecommendation>> getRecommendations({
    required String query,
    required List<dynamic> candidateDuas, // Dynamic to avoid import issues
    Map<String, dynamic>? contextOverrides,
  }) async {
    try {
      // This would need proper DuaEntity conversion
      return [];
    } catch (error) {
      print('Error getting recommendations: $error');
      return [];
    }
  }
}

/// Provider for PersonalizationNotifier
final personalizationNotifierProvider = StateNotifierProvider.family<
    PersonalizationNotifier, PersonalizationState, String?>((ref, userId) {
  final service = ref.watch(userPersonalizationServiceProvider);
  return PersonalizationNotifier(service, userId);
});

/// Provider for usage patterns
final usagePatternsProvider = FutureProvider.family<UsagePatterns, String>((
  ref,
  userId,
) async {
  final service = ref.watch(userPersonalizationServiceProvider);
  return service.usageAnalyzer.getPatterns(userId);
});

/// Provider for cultural preferences
final culturalPreferencesProvider =
    FutureProvider.family<CulturalPreferences, String>((ref, userId) async {
  final service = ref.watch(userPersonalizationServiceProvider);
  return service.culturalEngine.getPreferences(userId);
});

/// Provider for temporal patterns
final temporalPatternsProvider =
    FutureProvider.family<TemporalPatterns, String>((ref, userId) async {
  final service = ref.watch(userPersonalizationServiceProvider);
  return service.temporalAnalyzer.analyzePatterns(userId, DateTime.now());
});

/// Provider for contextual suggestions
final contextualSuggestionsProvider =
    FutureProvider.family<List<EnhancedRecommendation>, String>((
  ref,
  userId,
) async {
  final service = ref.watch(userPersonalizationServiceProvider);
  return service.getContextualSuggestions(limit: 10);
});

/// Provider for personalization updates stream
final personalizationUpdatesProvider =
    StreamProvider.family<PersonalizationUpdate, String>((ref, userId) {
  final service = ref.watch(userPersonalizationServiceProvider);
  return service.updateStream;
});

/// Provider for recommendations stream
final recommendationsStreamProvider =
    StreamProvider.family<List<EnhancedRecommendation>, String>((ref, userId) {
  final service = ref.watch(userPersonalizationServiceProvider);
  return service.recommendationsStream;
});

/// Session context provider for maintaining session state
final sessionContextProvider =
    StateNotifierProvider<SessionContextNotifier, Map<String, dynamic>>(
  (ref) => SessionContextNotifier(),
);

class SessionContextNotifier extends StateNotifier<Map<String, dynamic>> {
  SessionContextNotifier() : super({});

  void updateContext(String key, dynamic value) {
    state = {...state, key: value};
  }

  void clearContext() {
    state = {};
  }

  void updateMultiple(Map<String, dynamic> updates) {
    state = {...state, ...updates};
  }
}

/// Provider for current user ID
final currentUserIdProvider = StateProvider<String?>((ref) => null);

/// Provider for privacy level settings
final privacyLevelProvider = StateProvider<PrivacyLevel>(
  (ref) => PrivacyLevel.balanced,
);

/// Provider for personalization settings
final personalizationSettingsProvider = StateNotifierProvider<
    PersonalizationSettingsNotifier,
    PersonalizationSettings>((ref) => PersonalizationSettingsNotifier());

class PersonalizationSettingsNotifier
    extends StateNotifier<PersonalizationSettings> {
  PersonalizationSettingsNotifier() : super(PersonalizationSettings.defaults());

  void updateSettings(PersonalizationSettings settings) {
    state = settings;
  }

  void togglePersonalization() {
    state = state.copyWith(isEnabled: !state.isEnabled);
  }

  void setPrivacyLevel(PrivacyLevel level) {
    state = state.copyWith(privacyLevel: level);
  }

  void setAnalyticsEnabled(bool enabled) {
    state = state.copyWith(analyticsEnabled: enabled);
  }
}

/// Provider for Islamic calendar integration
final islamicCalendarProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  // This would integrate with the Islamic time service
  return {};
});

/// Provider for location-based personalization
final locationPersonalizationProvider = FutureProvider<LocationContext?>((
  ref,
) async {
  final settings = ref.watch(personalizationSettingsProvider);

  if (!settings.locationEnabled) {
    return null;
  }

  // This would integrate with location services
  return null;
});
