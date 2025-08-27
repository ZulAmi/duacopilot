import 'package:equatable/equatable.dart';
import 'query_context.dart';

/// Enhanced query with processing metadata and context
class EnhancedQuery extends Equatable {
  final String originalQuery;
  final String processedQuery;
  final String language;
  final QueryIntent intent;
  final QueryContext context;
  final List<String> semanticTags;
  final double confidence;
  final List<String> processingSteps;
  final Map<String, dynamic> metadata;

  const EnhancedQuery({
    required this.originalQuery,
    required this.processedQuery,
    required this.language,
    required this.intent,
    required this.context,
    required this.semanticTags,
    required this.confidence,
    required this.processingSteps,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
        originalQuery,
        processedQuery,
        language,
        intent,
        context,
        semanticTags,
        confidence,
        processingSteps,
        metadata,
      ];

  EnhancedQuery copyWith({
    String? originalQuery,
    String? processedQuery,
    String? language,
    QueryIntent? intent,
    QueryContext? context,
    List<String>? semanticTags,
    double? confidence,
    List<String>? processingSteps,
    Map<String, dynamic>? metadata,
  }) {
    return EnhancedQuery(
      originalQuery: originalQuery ?? this.originalQuery,
      processedQuery: processedQuery ?? this.processedQuery,
      language: language ?? this.language,
      intent: intent ?? this.intent,
      context: context ?? this.context,
      semanticTags: semanticTags ?? this.semanticTags,
      confidence: confidence ?? this.confidence,
      processingSteps: processingSteps ?? this.processingSteps,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'originalQuery': originalQuery,
      'processedQuery': processedQuery,
      'language': language,
      'intent': intent.name,
      'context': context.toMap(),
      'semanticTags': semanticTags,
      'confidence': confidence,
      'processingSteps': processingSteps,
      'metadata': metadata,
    };
  }

  /// Create from map for deserialization
  factory EnhancedQuery.fromMap(Map<String, dynamic> map) {
    return EnhancedQuery(
      originalQuery: map['originalQuery'] ?? '',
      processedQuery: map['processedQuery'] ?? '',
      language: map['language'] ?? 'en',
      intent: QueryIntent.values.firstWhere(
        (e) => e.name == map['intent'],
        orElse: () => QueryIntent.general,
      ),
      context: QueryContext.fromMap(map['context'] ?? {}),
      semanticTags: List<String>.from(map['semanticTags'] ?? []),
      confidence: map['confidence']?.toDouble() ?? 0.5,
      processingSteps: List<String>.from(map['processingSteps'] ?? []),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }
}

/// Query intent classification
enum QueryIntent {
  general,
  prayer,
  dua,
  quran,
  hadith,
  fasting,
  charity,
  pilgrimage,
  worship,
  guidance,
  healing,
  protection,
  gratitude,
  forgiveness,
  knowledge,
  travel,
  family,
  business,
  health,
  emergency,
  unknown,
}

/// Time of day classification
enum TimeOfDay { morning, afternoon, evening, night }

/// Prayer time classification
enum PrayerTime { fajr, duha, dhuhr, asr, maghrib, isha }
