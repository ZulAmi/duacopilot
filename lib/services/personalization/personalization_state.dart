import 'personalization_models.dart';

/// 🏗️ PERSONALIZATION STATE MANAGEMENT
/// Comprehensive state models for personalization UI components

/// Base personalization state
abstract class PersonalizationState {
  const PersonalizationState();

  /// Initial state before any personalization is loaded
  const factory PersonalizationState.initial() = PersonalizationInitial;

  /// Loading state while fetching personalization data
  const factory PersonalizationState.loading() = PersonalizationLoading;

  /// Loaded state with personalization data
  const factory PersonalizationState.loaded({
    required UsagePatterns usagePatterns,
    required CulturalPreferences culturalPreferences,
    bool isPersonalizationActive,
    List<EnhancedRecommendation> recommendations,
    List<EnhancedRecommendation> contextualSuggestions,
    TemporalPatterns? temporalPatterns,
    Map<String, dynamic> metadata,
  }) = PersonalizationLoaded;

  /// Error state when personalization fails
  const factory PersonalizationState.error(
    Object error,
    StackTrace stackTrace,
  ) = PersonalizationError;

  /// Pattern matching method
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(PersonalizationLoaded loaded) loaded,
    required T Function(Object error, StackTrace stackTrace) error,
  }) {
    if (this is PersonalizationInitial) {
      return initial();
    } else if (this is PersonalizationLoading) {
      return loading();
    } else if (this is PersonalizationLoaded) {
      return loaded(this as PersonalizationLoaded);
    } else if (this is PersonalizationError) {
      final errorState = this as PersonalizationError;
      return error(errorState.error, errorState.stackTrace);
    }
    throw Exception('Unknown state: $this');
  }
}

/// Initial state
class PersonalizationInitial extends PersonalizationState {
  const PersonalizationInitial();
}

/// Loading state
class PersonalizationLoading extends PersonalizationState {
  const PersonalizationLoading();
}

/// Loaded state
class PersonalizationLoaded extends PersonalizationState {
  final UsagePatterns usagePatterns;
  final CulturalPreferences culturalPreferences;
  final bool isPersonalizationActive;
  final List<EnhancedRecommendation> recommendations;
  final List<EnhancedRecommendation> contextualSuggestions;
  final TemporalPatterns? temporalPatterns;
  final Map<String, dynamic> metadata;

  const PersonalizationLoaded({
    required this.usagePatterns,
    required this.culturalPreferences,
    this.isPersonalizationActive = true,
    this.recommendations = const [],
    this.contextualSuggestions = const [],
    this.temporalPatterns,
    this.metadata = const {},
  });

  PersonalizationLoaded copyWith({
    UsagePatterns? usagePatterns,
    CulturalPreferences? culturalPreferences,
    bool? isPersonalizationActive,
    List<EnhancedRecommendation>? recommendations,
    List<EnhancedRecommendation>? contextualSuggestions,
    TemporalPatterns? temporalPatterns,
    Map<String, dynamic>? metadata,
  }) {
    return PersonalizationLoaded(
      usagePatterns: usagePatterns ?? this.usagePatterns,
      culturalPreferences: culturalPreferences ?? this.culturalPreferences,
      isPersonalizationActive:
          isPersonalizationActive ?? this.isPersonalizationActive,
      recommendations: recommendations ?? this.recommendations,
      contextualSuggestions:
          contextualSuggestions ?? this.contextualSuggestions,
      temporalPatterns: temporalPatterns ?? this.temporalPatterns,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Error state
class PersonalizationError extends PersonalizationState {
  final Object error;
  final StackTrace stackTrace;

  const PersonalizationError(this.error, this.stackTrace);
}
