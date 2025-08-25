import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// ML service for local semantic embeddings using TensorFlow Lite
class LocalEmbeddingService {
  static const String _modelPath = 'assets/models/semantic_search_model.tflite';
  static const String _vocabPath = 'assets/models/vocab.txt';
  static const int _maxSequenceLength = 128;
  static const int _embeddingDimension = 384; // MiniLM dimension

  Interpreter? _interpreter;
  Map<String, int>? _vocabulary;
  bool _isInitialized = false;

  /// Initialize the ML model and vocabulary
  Future<void> initialize() async {
    try {
      // Load the TFLite model
      _interpreter = await _loadModel();

      // Load vocabulary for tokenization
      _vocabulary = await _loadVocabulary();

      _isInitialized = true;
      print('LocalEmbeddingService initialized successfully');
    } catch (e) {
      print('Failed to initialize LocalEmbeddingService: $e');
      // Continue without ML model - will use fallback methods
      _isInitialized = false;
    }
  }

  /// Check if the service is ready for use
  bool get isReady => _isInitialized && _interpreter != null;

  /// Generate embedding for a text query
  Future<List<double>> generateEmbedding(String text) async {
    if (!isReady) {
      // Fallback: Simple hash-based "embedding" for basic similarity
      return _generateFallbackEmbedding(text);
    }

    try {
      // Tokenize the input text
      final tokens = _tokenizeText(text.toLowerCase());

      // Prepare input tensor
      final input = _prepareInputTensor(tokens);

      // Run inference
      final output = List.filled(_embeddingDimension, 0.0).reshape([1, _embeddingDimension]);
      _interpreter!.run(input, output);

      // Extract and normalize the embedding
      final embedding = output[0];
      return _normalizeVector(embedding);
    } catch (e) {
      print('Error generating embedding: $e');
      return _generateFallbackEmbedding(text);
    }
  }

  /// Calculate cosine similarity between two embeddings
  double calculateSimilarity(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) {
      return 0.0;
    }

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) {
      return 0.0;
    }

    return dotProduct / (math.sqrt(norm1) * math.sqrt(norm2));
  }

  /// Batch generate embeddings for multiple texts
  Future<List<List<double>>> generateBatchEmbeddings(List<String> texts) async {
    final embeddings = <List<double>>[];

    for (final text in texts) {
      embeddings.add(await generateEmbedding(text));
      // Small delay to prevent overwhelming the system
      if (embeddings.length % 10 == 0) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }

    return embeddings;
  }

  /// Find top-k most similar embeddings
  List<MapEntry<int, double>> findTopSimilar({
    required List<double> queryEmbedding,
    required List<List<double>> candidateEmbeddings,
    int k = 5,
    double minSimilarity = 0.3,
  }) {
    final similarities = <MapEntry<int, double>>[];

    for (int i = 0; i < candidateEmbeddings.length; i++) {
      final similarity = calculateSimilarity(queryEmbedding, candidateEmbeddings[i]);
      if (similarity >= minSimilarity) {
        similarities.add(MapEntry(i, similarity));
      }
    }

    // Sort by similarity (descending) and take top k
    similarities.sort((a, b) => b.value.compareTo(a.value));
    return similarities.take(k).toList();
  }

  /// Clean up resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _vocabulary?.clear();
    _isInitialized = false;
  }

  // Private methods

  Future<Interpreter> _loadModel() async {
    try {
      // First try to load from assets
      return await Interpreter.fromAsset(_modelPath);
    } catch (e) {
      // If model doesn't exist, create a minimal placeholder
      // In production, you'd download or bundle a real model
      throw Exception('Semantic search model not found. Please ensure the model is placed in $_modelPath');
    }
  }

  Future<Map<String, int>> _loadVocabulary() async {
    try {
      final vocabString = await rootBundle.loadString(_vocabPath);
      final lines = vocabString.split('\n');
      final vocabulary = <String, int>{};

      for (int i = 0; i < lines.length; i++) {
        final word = lines[i].trim();
        if (word.isNotEmpty) {
          vocabulary[word] = i;
        }
      }

      return vocabulary;
    } catch (e) {
      // Fallback vocabulary with common words
      return _createFallbackVocabulary();
    }
  }

  Map<String, int> _createFallbackVocabulary() {
    final commonWords = [
      'allah', 'dua', 'prayer', 'morning', 'evening', 'sleep', 'food', 'travel',
      'forgiveness', 'guidance', 'protection', 'blessing', 'mercy', 'peace',
      'strength', 'health', 'family', 'success', 'gratitude', 'patience',
      'knowledge', 'wisdom', 'faith', 'hope', 'love', 'help', 'support',
      // Arabic transliterations
      'bismillah', 'alhamdulillah', 'subhanallah', 'astaghfirullah', 'inshallah',
      'mashallah', 'barakallahu', 'rabbana', 'rabbighfir', 'allahuma',
    ];

    final vocabulary = <String, int>{};
    vocabulary['[UNK]'] = 0;
    vocabulary['[PAD]'] = 1;
    vocabulary['[CLS]'] = 2;
    vocabulary['[SEP]'] = 3;

    for (int i = 0; i < commonWords.length; i++) {
      vocabulary[commonWords[i]] = i + 4;
    }

    return vocabulary;
  }

  List<int> _tokenizeText(String text) {
    final words = text.split(' ');
    final tokens = <int>[2]; // [CLS] token

    for (final word in words.take(_maxSequenceLength - 2)) {
      final tokenId = _vocabulary![word] ?? 0; // [UNK] for unknown words
      tokens.add(tokenId);
    }

    tokens.add(3); // [SEP] token

    // Pad to max sequence length
    while (tokens.length < _maxSequenceLength) {
      tokens.add(1); // [PAD] token
    }

    return tokens.take(_maxSequenceLength).toList();
  }

  List<List<int>> _prepareInputTensor(List<int> tokens) {
    return [tokens];
  }

  List<double> _normalizeVector(List<double> vector) {
    double norm = 0.0;
    for (final value in vector) {
      norm += value * value;
    }
    norm = math.sqrt(norm);

    if (norm == 0.0) return vector;

    return vector.map((value) => value / norm).toList();
  }

  /// Fallback embedding generator using simple hashing and word features
  List<double> _generateFallbackEmbedding(String text) {
    final words = text.toLowerCase().split(' ');
    final embedding = List.filled(_embeddingDimension, 0.0);

    // Use word hashes and simple features
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final hash = word.hashCode.abs();

      // Distribute hash across embedding dimensions
      for (int j = 0; j < _embeddingDimension; j++) {
        final index = (hash + i + j) % _embeddingDimension;
        embedding[index] += (hash % 1000) / 1000.0;
      }

      // Add word length feature
      embedding[i % _embeddingDimension] += word.length / 10.0;
    }

    return _normalizeVector(embedding);
  }
}

/// Extensions for better vector operations
extension on List<double> {
  List<List<double>> reshape(List<int> shape) {
    if (shape.length != 2) {
      throw ArgumentError('Only 2D reshape supported');
    }

    final result = <List<double>>[];
    final rowSize = shape[1];

    for (int i = 0; i < shape[0]; i++) {
      final start = i * rowSize;
      final end = start + rowSize;
      result.add(sublist(start, end));
    }

    return result;
  }
}
