import 'package:equatable/equatable.dart';

/// Local embedding vector for semantic search
class DuaEmbedding extends Equatable {
  final String id;
  final String query;
  final String duaText;
  final List<double> embedding;
  final String language;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final double popularity;
  final List<String> keywords;
  final String category;

  const DuaEmbedding({
    required this.id,
    required this.query,
    required this.duaText,
    required this.embedding,
    required this.language,
    required this.metadata,
    required this.createdAt,
    this.popularity = 0.0,
    this.keywords = const [],
    this.category = 'general',
  });

  @override
  List<Object?> get props => [
    id,
    query,
    duaText,
    embedding,
    language,
    metadata,
    createdAt,
    popularity,
    keywords,
    category,
  ];

  DuaEmbedding copyWith({
    String? id,
    String? query,
    String? duaText,
    List<double>? embedding,
    String? language,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    double? popularity,
    List<String>? keywords,
    String? category,
  }) {
    return DuaEmbedding(
      id: id ?? this.id,
      query: query ?? this.query,
      duaText: duaText ?? this.duaText,
      embedding: embedding ?? this.embedding,
      language: language ?? this.language,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      popularity: popularity ?? this.popularity,
      keywords: keywords ?? this.keywords,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'duaText': duaText,
      'embedding': embedding,
      'language': language,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'popularity': popularity,
      'keywords': keywords,
      'category': category,
    };
  }

  factory DuaEmbedding.fromJson(Map<String, dynamic> json) {
    return DuaEmbedding(
      id: json['id'] as String,
      query: json['query'] as String,
      duaText: json['duaText'] as String,
      embedding: (json['embedding'] as List).cast<double>(),
      language: json['language'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      popularity: json['popularity'] as double? ?? 0.0,
      keywords: (json['keywords'] as List?)?.cast<String>() ?? [],
      category: json['category'] as String? ?? 'general',
    );
  }
}

/// Pending query for offline queuing
class PendingQuery extends Equatable {
  final String id;
  final String query;
  final String language;
  final DateTime createdAt;
  final Map<String, dynamic> context;
  final int priority;
  final bool isProcessed;
  final String? localResponseId;
  final int retryCount;

  const PendingQuery({
    required this.id,
    required this.query,
    required this.language,
    required this.createdAt,
    this.context = const {},
    this.priority = 0,
    this.isProcessed = false,
    this.localResponseId,
    this.retryCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    query,
    language,
    createdAt,
    context,
    priority,
    isProcessed,
    localResponseId,
    retryCount,
  ];

  PendingQuery copyWith({
    String? id,
    String? query,
    String? language,
    DateTime? createdAt,
    Map<String, dynamic>? context,
    int? priority,
    bool? isProcessed,
    String? localResponseId,
    int? retryCount,
  }) {
    return PendingQuery(
      id: id ?? this.id,
      query: query ?? this.query,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      context: context ?? this.context,
      priority: priority ?? this.priority,
      isProcessed: isProcessed ?? this.isProcessed,
      localResponseId: localResponseId ?? this.localResponseId,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'context': context,
      'priority': priority,
      'isProcessed': isProcessed,
      'localResponseId': localResponseId,
      'retryCount': retryCount,
    };
  }

  factory PendingQuery.fromJson(Map<String, dynamic> json) {
    return PendingQuery(
      id: json['id'] as String,
      query: json['query'] as String,
      language: json['language'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      context: json['context'] as Map<String, dynamic>? ?? {},
      priority: json['priority'] as int? ?? 0,
      isProcessed: json['isProcessed'] as bool? ?? false,
      localResponseId: json['localResponseId'] as String?,
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}

/// Local search result with quality indicators
class LocalSearchResult extends Equatable {
  final String id;
  final String query;
  final String response;
  final double confidence;
  final String source;
  final bool isOffline;
  final Map<String, dynamic> metadata;
  final List<String> relatedQueries;
  final DateTime timestamp;
  final String language;
  final ResponseQuality quality;

  const LocalSearchResult({
    required this.id,
    required this.query,
    required this.response,
    required this.confidence,
    required this.source,
    required this.isOffline,
    required this.metadata,
    required this.relatedQueries,
    required this.timestamp,
    required this.language,
    required this.quality,
  });

  @override
  List<Object?> get props => [
    id,
    query,
    response,
    confidence,
    source,
    isOffline,
    metadata,
    relatedQueries,
    timestamp,
    language,
    quality,
  ];

  LocalSearchResult copyWith({
    String? id,
    String? query,
    String? response,
    double? confidence,
    String? source,
    bool? isOffline,
    Map<String, dynamic>? metadata,
    List<String>? relatedQueries,
    DateTime? timestamp,
    String? language,
    ResponseQuality? quality,
  }) {
    return LocalSearchResult(
      id: id ?? this.id,
      query: query ?? this.query,
      response: response ?? this.response,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      isOffline: isOffline ?? this.isOffline,
      metadata: metadata ?? this.metadata,
      relatedQueries: relatedQueries ?? this.relatedQueries,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      quality: quality ?? this.quality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'confidence': confidence,
      'source': source,
      'isOffline': isOffline,
      'metadata': metadata,
      'relatedQueries': relatedQueries,
      'timestamp': timestamp.toIso8601String(),
      'language': language,
      'quality': quality.toJson(),
    };
  }

  factory LocalSearchResult.fromJson(Map<String, dynamic> json) {
    return LocalSearchResult(
      id: json['id'] as String,
      query: json['query'] as String,
      response: json['response'] as String,
      confidence: json['confidence'] as double,
      source: json['source'] as String,
      isOffline: json['isOffline'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>,
      relatedQueries: (json['relatedQueries'] as List).cast<String>(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      language: json['language'] as String,
      quality: ResponseQuality.fromJson(
        json['quality'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response quality indicators
class ResponseQuality extends Equatable {
  final double accuracy;
  final double completeness;
  final double relevance;
  final bool hasCitations;
  final bool isVerified;
  final String sourceType;
  final int citationCount;
  final double userRating;

  const ResponseQuality({
    required this.accuracy,
    required this.completeness,
    required this.relevance,
    required this.hasCitations,
    required this.isVerified,
    required this.sourceType,
    this.citationCount = 0,
    this.userRating = 0.0,
  });

  @override
  List<Object?> get props => [
    accuracy,
    completeness,
    relevance,
    hasCitations,
    isVerified,
    sourceType,
    citationCount,
    userRating,
  ];

  /// Calculate overall quality score
  double get overallScore {
    final base = (accuracy + completeness + relevance) / 3;
    final bonuses = [
      if (hasCitations) 0.1,
      if (isVerified) 0.15,
      if (userRating > 4.0) 0.1,
      if (citationCount >= 3) 0.05,
    ].fold(0.0, (sum, bonus) => sum + bonus);

    return (base + bonuses).clamp(0.0, 1.0);
  }

  /// Get quality level as string
  String get qualityLevel {
    final score = overallScore;
    if (score >= 0.8) return 'Excellent';
    if (score >= 0.6) return 'Good';
    if (score >= 0.4) return 'Fair';
    return 'Poor';
  }

  ResponseQuality copyWith({
    double? accuracy,
    double? completeness,
    double? relevance,
    bool? hasCitations,
    bool? isVerified,
    String? sourceType,
    int? citationCount,
    double? userRating,
  }) {
    return ResponseQuality(
      accuracy: accuracy ?? this.accuracy,
      completeness: completeness ?? this.completeness,
      relevance: relevance ?? this.relevance,
      hasCitations: hasCitations ?? this.hasCitations,
      isVerified: isVerified ?? this.isVerified,
      sourceType: sourceType ?? this.sourceType,
      citationCount: citationCount ?? this.citationCount,
      userRating: userRating ?? this.userRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy,
      'completeness': completeness,
      'relevance': relevance,
      'hasCitations': hasCitations,
      'isVerified': isVerified,
      'sourceType': sourceType,
      'citationCount': citationCount,
      'userRating': userRating,
    };
  }

  factory ResponseQuality.fromJson(Map<String, dynamic> json) {
    return ResponseQuality(
      accuracy: json['accuracy'] as double,
      completeness: json['completeness'] as double,
      relevance: json['relevance'] as double,
      hasCitations: json['hasCitations'] as bool,
      isVerified: json['isVerified'] as bool,
      sourceType: json['sourceType'] as String,
      citationCount: json['citationCount'] as int? ?? 0,
      userRating: json['userRating'] as double? ?? 0.0,
    );
  }

  /// Create quality for offline responses
  factory ResponseQuality.offline({
    double accuracy = 0.7,
    double completeness = 0.6,
    double relevance = 0.8,
  }) {
    return ResponseQuality(
      accuracy: accuracy,
      completeness: completeness,
      relevance: relevance,
      hasCitations: false,
      isVerified: false,
      sourceType: 'local_cache',
    );
  }

  /// Create quality for online responses
  factory ResponseQuality.online({
    double accuracy = 0.9,
    double completeness = 0.9,
    double relevance = 0.9,
    bool hasCitations = true,
    bool isVerified = true,
  }) {
    return ResponseQuality(
      accuracy: accuracy,
      completeness: completeness,
      relevance: relevance,
      hasCitations: hasCitations,
      isVerified: isVerified,
      sourceType: 'online_rag',
    );
  }
}

/// Similarity search result
class SimilarityMatch extends Equatable {
  final DuaEmbedding embedding;
  final double similarity;
  final String matchReason;

  const SimilarityMatch({
    required this.embedding,
    required this.similarity,
    required this.matchReason,
  });

  @override
  List<Object?> get props => [embedding, similarity, matchReason];
}

/// Local model information
class LocalModelInfo extends Equatable {
  final String modelPath;
  final String version;
  final DateTime lastUpdated;
  final int embeddingDimension;
  final List<String> supportedLanguages;
  final Map<String, dynamic> metadata;

  const LocalModelInfo({
    required this.modelPath,
    required this.version,
    required this.lastUpdated,
    required this.embeddingDimension,
    required this.supportedLanguages,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    modelPath,
    version,
    lastUpdated,
    embeddingDimension,
    supportedLanguages,
    metadata,
  ];
}
