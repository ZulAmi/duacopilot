import 'dart:math';

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/local_search_models.dart';

/// TensorFlow Lite service for generating embeddings locally
class LocalEmbeddingService {
  static LocalEmbeddingService? _instance;
  static LocalEmbeddingService get instance => _instance ??= LocalEmbeddingService._();

  LocalEmbeddingService._();

  Interpreter? _interpreter;
  LocalModelInfo? _modelInfo;
  bool _isInitialized = false;

  // Model configuration
  static const String _modelAssetPath = 'assets/models/dua_embedding_model.tflite';
  static const int _maxSequenceLength = 128;
  static const int _embeddingDimension = 256;

  // Vocabulary and tokenization maps
  Map<String, int> _vocabMap = {};
  final Map<String, List<String>> _languageTokens = {};

  /// Initialize the embedding model
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load the TensorFlow Lite model
      await _loadModel();

      // Load vocabulary and tokenization data
      await _loadVocabulary();

      // Initialize model info
      _modelInfo = LocalModelInfo(
        modelPath: _modelAssetPath,
        version: '1.0.0',
        lastUpdated: DateTime.now(),
        embeddingDimension: _embeddingDimension,
        supportedLanguages: ['en', 'ar', 'ur', 'id'],
        metadata: {
          'max_sequence_length': _maxSequenceLength,
          'model_type': 'sentence_transformer',
          'architecture': 'bert_small',
        },
      );

      _isInitialized = true;
      AppLogger.debug('Local embedding service initialized successfully');
    } catch (e) {
      AppLogger.debug('Error initializing local embedding service: $e');
      // Fall back to simple embedding generation
      await _initializeFallbackEmbedding();
    }
  }

  /// Generate embedding for a query
  Future<List<double>> generateEmbedding(String query, String language) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_interpreter != null) {
        return await _generateMLEmbedding(query, language);
      } else {
        return _generateFallbackEmbedding(query, language);
      }
    } catch (e) {
      AppLogger.debug('Error generating embedding: $e');
      return _generateFallbackEmbedding(query, language);
    }
  }

  /// Generate embeddings in batch for efficiency
  Future<List<List<double>>> generateBatchEmbeddings(
    List<String> queries,
    String language,
  ) async {
    final embeddings = <List<double>>[];

    for (final query in queries) {
      final embedding = await generateEmbedding(query, language);
      embeddings.add(embedding);
    }

    return embeddings;
  }

  /// Calculate cosine similarity between two embeddings
  static double calculateSimilarity(
    List<double> embedding1,
    List<double> embedding2,
  ) {
    if (embedding1.length != embedding2.length) {
      throw ArgumentError('Embeddings must have the same dimension');
    }

    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      magnitude1 += embedding1[i] * embedding1[i];
      magnitude2 += embedding2[i] * embedding2[i];
    }

    magnitude1 = sqrt(magnitude1);
    magnitude2 = sqrt(magnitude2);

    if (magnitude1 == 0 || magnitude2 == 0) return 0.0;

    return dotProduct / (magnitude1 * magnitude2);
  }

  /// Find most similar embeddings from a list
  List<SimilarityMatch> findMostSimilar(
    List<double> queryEmbedding,
    List<DuaEmbedding> candidates, {
    int limit = 5,
    double minSimilarity = 0.5,
  }) {
    final matches = <SimilarityMatch>[];

    for (final candidate in candidates) {
      final similarity = calculateSimilarity(
        queryEmbedding,
        candidate.embedding,
      );

      if (similarity >= minSimilarity) {
        final matchReason = _generateMatchReason(similarity);
        matches.add(
          SimilarityMatch(
            embedding: candidate,
            similarity: similarity,
            matchReason: matchReason,
          ),
        );
      }
    }

    // Sort by similarity (descending) and take top results
    matches.sort((a, b) => b.similarity.compareTo(a.similarity));
    return matches.take(limit).toList();
  }

  /// Dispose resources
  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }

  // Private methods

  Future<void> _loadModel() async {
    try {
      // Try to load the model from assets
      final modelData = await rootBundle.load(_modelAssetPath);
      _interpreter = Interpreter.fromBuffer(modelData.buffer.asUint8List());
      AppLogger.debug('TensorFlow Lite model loaded successfully');
    } catch (e) {
      AppLogger.debug('Could not load TensorFlow Lite model: $e');
      AppLogger.debug('Falling back to simple embedding generation');
      // Continue without the model - we'll use fallback embedding
    }
  }

  Future<void> _loadVocabulary() async {
    try {
      // Load vocabulary for different languages
      const vocabularies = {
        'en': 'assets/offline_data/vocab_en.json',
        'ar': 'assets/offline_data/vocab_ar.json',
        'ur': 'assets/offline_data/vocab_ur.json',
        'id': 'assets/offline_data/vocab_id.json',
      };

      for (final entry in vocabularies.entries) {
        try {
          await rootBundle.loadString(entry.value);
          // Parse and store vocabulary
          // For now, create a simple vocabulary
          _languageTokens[entry.key] = _createSimpleVocabulary(entry.key);
        } catch (e) {
          AppLogger.debug('Could not load vocabulary for ${entry.key}: $e');
          _languageTokens[entry.key] = _createSimpleVocabulary(entry.key);
        }
      }
    } catch (e) {
      AppLogger.debug('Error loading vocabularies: $e');
      _createDefaultVocabularies();
    }
  }

  Future<void> _initializeFallbackEmbedding() async {
    _createDefaultVocabularies();
    _isInitialized = true;
    AppLogger.debug('Fallback embedding initialized');
  }

  Future<List<double>> _generateMLEmbedding(
    String query,
    String language,
  ) async {
    if (_interpreter == null) {
      return _generateFallbackEmbedding(query, language);
    }

    try {
      // Tokenize the input
      final tokens = _tokenizeText(query, language);

      // Pad or truncate to max sequence length
      final paddedTokens = _padTokens(tokens, _maxSequenceLength);

      // Prepare input tensor
      final input = [paddedTokens];
      final inputTensor = [input];

      // Prepare output tensor
      final output = List.filled(1, List.filled(_embeddingDimension, 0.0));
      final outputTensor = [output];

      // Run inference
      _interpreter!.run(inputTensor, outputTensor);

      // Extract and normalize embedding
      final embedding = outputTensor[0][0].cast<double>();
      return _normalizeEmbedding(embedding);
    } catch (e) {
      AppLogger.debug('ML embedding generation failed: $e');
      return _generateFallbackEmbedding(query, language);
    }
  }

  List<double> _generateFallbackEmbedding(String query, String language) {
    // Simple embedding generation using TF-IDF like approach
    final words = _preprocessText(query, language);
    final embedding = List.filled(_embeddingDimension, 0.0);

    // Generate embedding based on word hashes and language-specific features
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final hash = word.hashCode;

      for (int j = 0; j < _embeddingDimension; j++) {
        final seedValue = (hash + i + j) % 1000000;
        final random = Random(seedValue);
        embedding[j] += random.nextGaussian() * (1.0 / sqrt(words.length));
      }
    }

    // Add language-specific bias
    _addLanguageBias(embedding, language);

    // Add Islamic terms boost
    _addIslamicTermsBoost(embedding, words, language);

    return _normalizeEmbedding(embedding);
  }

  List<String> _preprocessText(String text, String language) {
    String processed = text.toLowerCase().trim();

    // Language-specific preprocessing
    switch (language) {
      case 'ar':
        processed = _preprocessArabic(processed);
        break;
      case 'ur':
        processed = _preprocessUrdu(processed);
        break;
      default:
        processed = _preprocessEnglish(processed);
    }

    return processed.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
  }

  String _preprocessArabic(String text) {
    // Remove Arabic diacritics and normalize
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
        .replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _preprocessUrdu(String text) {
    // Similar to Arabic but with Urdu-specific considerations
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
        .replaceAll(RegExp(r'[^\u0600-\u06FF\u0750-\u077F\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _preprocessEnglish(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]'), ' ').replaceAll(RegExp(r'\s+'), ' ');
  }

  List<int> _tokenizeText(String text, String language) {
    final words = _preprocessText(text, language);
    final tokens = <int>[];

    for (final word in words) {
      final tokenId = _vocabMap[word] ?? _vocabMap['[UNK]'] ?? 1;
      tokens.add(tokenId);
    }

    return tokens;
  }

  List<int> _padTokens(List<int> tokens, int maxLength) {
    if (tokens.length >= maxLength) {
      return tokens.take(maxLength).toList();
    } else {
      final padded = List<int>.from(tokens);
      while (padded.length < maxLength) {
        padded.add(0); // PAD token
      }
      return padded;
    }
  }

  List<double> _normalizeEmbedding(List<double> embedding) {
    final magnitude = sqrt(embedding.map((x) => x * x).reduce((a, b) => a + b));
    if (magnitude == 0) return embedding;

    return embedding.map((x) => x / magnitude).toList();
  }

  void _addLanguageBias(List<double> embedding, String language) {
    final bias = _getLanguageBias(language);
    for (int i = 0; i < embedding.length && i < bias.length; i++) {
      embedding[i] += bias[i] * 0.1;
    }
  }

  List<double> _getLanguageBias(String language) {
    final random = Random(language.hashCode);
    return List.generate(
      _embeddingDimension,
      (_) => random.nextGaussian() * 0.1,
    );
  }

  void _addIslamicTermsBoost(
    List<double> embedding,
    List<String> words,
    String language,
  ) {
    final islamicTerms = _getIslamicTerms(language);
    double boost = 0.0;

    for (final word in words) {
      if (islamicTerms.contains(word)) {
        boost += 0.2;
      }
    }

    if (boost > 0) {
      final boostVector = _generateBoostVector(boost);
      for (int i = 0; i < embedding.length && i < boostVector.length; i++) {
        embedding[i] += boostVector[i];
      }
    }
  }

  Set<String> _getIslamicTerms(String language) {
    switch (language) {
      case 'ar':
        return {
          'الله',
          'صلاة',
          'دعاء',
          'قرآن',
          'حديث',
          'إسلام',
          'مسلم',
          'رمضان',
          'حج',
          'زكاة',
          'صوم',
          'جهاد',
          'إيمان',
        };
      case 'ur':
        return {
          'اللہ',
          'نماز',
          'دعا',
          'قرآن',
          'حدیث',
          'اسلام',
          'مسلمان',
          'رمضان',
          'حج',
          'زکاة',
          'روزہ',
          'جہاد',
          'ایمان',
        };
      default:
        return {
          'allah',
          'prayer',
          'dua',
          'quran',
          'hadith',
          'islam',
          'muslim',
          'ramadan',
          'hajj',
          'zakat',
          'fasting',
          'jihad',
          'faith',
        };
    }
  }

  List<double> _generateBoostVector(double intensity) {
    final random = Random(42); // Fixed seed for consistency
    return List.generate(
      _embeddingDimension,
      (_) => random.nextGaussian() * intensity * 0.1,
    );
  }

  String _generateMatchReason(double similarity) {
    if (similarity >= 0.9) return 'Exact semantic match';
    if (similarity >= 0.8) return 'Very similar meaning';
    if (similarity >= 0.7) return 'Similar context';
    if (similarity >= 0.6) return 'Related topic';
    return 'Partial match';
  }

  List<String> _createSimpleVocabulary(String language) {
    // Create a basic vocabulary for the language
    final commonWords = <String>[];

    switch (language) {
      case 'ar':
        commonWords.addAll([
          'الله',
          'صلاة',
          'دعاء',
          'قرآن',
          'حديث',
          'إسلام',
          'مسلم',
          'في',
          'من',
          'إلى',
          'على',
          'مع',
          'هذا',
          'التي',
          'التي',
        ]);
        break;
      case 'ur':
        commonWords.addAll([
          'اللہ',
          'نماز',
          'دعا',
          'قرآن',
          'حدیث',
          'اسلام',
          'مسلمان',
          'میں',
          'سے',
          'کو',
          'پر',
          'کے',
          'یہ',
          'جو',
          'کہ',
        ]);
        break;
      default:
        commonWords.addAll([
          'allah',
          'prayer',
          'dua',
          'quran',
          'hadith',
          'islam',
          'muslim',
          'the',
          'of',
          'to',
          'and',
          'a',
          'in',
          'is',
          'it',
        ]);
    }

    return commonWords;
  }

  void _createDefaultVocabularies() {
    _vocabMap = {'[PAD]': 0, '[UNK]': 1, '[CLS]': 2, '[SEP]': 3};

    // Add basic vocabularies for all languages
    for (final language in ['en', 'ar', 'ur', 'id']) {
      final vocab = _createSimpleVocabulary(language);
      for (int i = 0; i < vocab.length; i++) {
        _vocabMap[vocab[i]] = _vocabMap.length;
      }
    }
  }

  /// Get model information
  LocalModelInfo? get modelInfo => _modelInfo;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}

/// Extension for Random to generate Gaussian distributed numbers
extension RandomGaussian on Random {
  double nextGaussian({double mean = 0.0, double stdDev = 1.0}) {
    double u, v, s;
    do {
      u = nextDouble() * 2 - 1;
      v = nextDouble() * 2 - 1;
      s = u * u + v * v;
    } while (s >= 1 || s == 0);

    final factor = sqrt(-2 * log(s) / s);
    return u * factor * stdDev + mean;
  }
}
