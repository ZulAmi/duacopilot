import 'dart:convert';
import 'dart:math' as math;

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../config/rag_config.dart';

/// Lightweight local vector index for Hadith texts (English & Arabic) using the
/// comprehensive combined embeddings file produced by the population script.
/// Focuses on fast (<<200ms) semantic lookup similar to QuranVectorIndex but
/// scoped to hadith entries only.
class HadithVectorIndex {
  static HadithVectorIndex? _instance;
  static HadithVectorIndex get instance => _instance ??= HadithVectorIndex._();

  HadithVectorIndex._();

  bool _initialized = false;

  // Key: hadith id (string key from embeddings file) -> embedding vector
  final Map<String, List<double>> _embeddings = {};
  final Map<String, _HadithMeta> _metadata = {};

  static const int embeddingDim = RagConfig.embeddingDimension;
  static const String embeddingsAssetPath = 'assets/data/comprehensive_islamic_embeddings.json';
  static const String textsAssetPath = 'assets/data/comprehensive_islamic_texts.json';

  bool get isReady => _initialized && _embeddings.isNotEmpty;

  Future<void> initialize() async {
    if (_initialized) return;
    final sw = Stopwatch()..start();
    try {
      await _loadMetadata();
      await _loadEmbeddings();
      _initialized = true;
      sw.stop();
      AppLogger.debug(
          '🕌 HadithVectorIndex initialized with ${_embeddings.length} hadith embeddings in ${sw.elapsedMilliseconds}ms');
    } catch (e) {
      sw.stop();
      AppLogger.debug('⚠️ HadithVectorIndex init failed: $e');
      _initialized = false;
    }
  }

  Future<void> _loadMetadata() async {
    try {
      final raw = await rootBundle.loadString(textsAssetPath);
      final data = jsonDecode(raw) as Map<String, dynamic>;
      int count = 0;
      data.forEach((key, value) {
        final map = value as Map<String, dynamic>;
        if (map['type'] == 'hadith') {
          _metadata[key] = _HadithMeta(
            id: key,
            collection: map['collection']?.toString() ?? 'unknown',
            hadithNumber: map['hadithNumber']?.toString() ?? '',
            language: map['language']?.toString() ?? 'en',
            englishText: map['englishText']?.toString() ?? map['text']?.toString() ?? '',
            arabicText: map['arabicText']?.toString() ?? '',
            narrator: map['narrator']?.toString() ?? '',
            author: map['author']?.toString() ?? '',
          );
          count++;
        }
      });
      AppLogger.debug('📚 Loaded $count hadith metadata entries');
    } catch (e) {
      AppLogger.debug('❌ Failed loading hadith metadata: $e');
    }
  }

  Future<void> _loadEmbeddings() async {
    try {
      final raw = await rootBundle.loadString(embeddingsAssetPath);
      final data = jsonDecode(raw) as Map<String, dynamic>;
      int kept = 0;
      for (final entry in data.entries) {
        if (!_metadata.containsKey(entry.key)) continue; // only hadith keys
        final vec = (entry.value as List).map((e) => (e as num).toDouble()).toList();
        if (vec.length == embeddingDim) {
          _embeddings[entry.key] = vec;
          kept++;
        }
      }
      AppLogger.debug('📥 Loaded $kept hadith embeddings');
    } catch (e) {
      AppLogger.debug('❌ Failed loading hadith embeddings: $e');
    }
  }

  Future<List<HadithSearchMatch>> search({
    required String query,
    int limit = 5,
    double minSimilarity = 0.60,
  }) async {
    if (!isReady || query.trim().isEmpty) return [];
    final sw = Stopwatch()..start();
    final queryVec = _generateFallbackEmbedding(query);
    final scores = <String, double>{};
    for (final entry in _embeddings.entries) {
      final sim = _cosine(queryVec, entry.value);
      if (sim >= minSimilarity) scores[entry.key] = sim;
    }
    final sorted = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final results = <HadithSearchMatch>[];
    for (final e in sorted.take(limit)) {
      final meta = _metadata[e.key];
      if (meta == null) continue;
      results.add(HadithSearchMatch(
        id: meta.id,
        collection: meta.collection,
        hadithNumber: meta.hadithNumber,
        language: meta.language,
        englishText: meta.englishText,
        arabicText: meta.arabicText,
        narrator: meta.narrator,
        author: meta.author,
        score: e.value,
      ));
    }
    sw.stop();
    AppLogger.debug('🕌 Hadith vector search produced ${results.length} results in ${sw.elapsedMilliseconds}ms');
    return results;
  }

  // Reuse light-weight deterministic embedding (same approach as Quran index)
  List<double> _generateFallbackEmbedding(String text) {
    final vector = List<double>.filled(embeddingDim, 0.0);
    if (text.isEmpty) return vector;
    for (int i = 0; i < text.length; i++) {
      final c = text.codeUnitAt(i);
      final h1 = c % embeddingDim;
      final h2 = (c * 31) % embeddingDim;
      final h3 = (c * c) % embeddingDim;
      vector[h1] += 1;
      vector[h2] += .5;
      vector[h3] += .3;
    }
    final norm = math.sqrt(vector.fold(0.0, (s, v) => s + v * v));
    if (norm > 0) {
      for (int i = 0; i < vector.length; i++) {
        vector[i] /= norm;
      }
    }
    return vector;
  }

  double _cosine(List<double> a, List<double> b) {
    double dot = 0, na = 0, nb = 0;
    for (int i = 0; i < a.length; i++) {
      final av = a[i];
      final bv = b[i];
      dot += av * bv;
      na += av * av;
      nb += bv * bv;
    }
    final denom = math.sqrt(na) * math.sqrt(nb);
    return denom == 0 ? 0 : dot / denom;
  }
}

class _HadithMeta {
  final String id;
  final String collection;
  final String hadithNumber;
  final String language;
  final String englishText;
  final String arabicText;
  final String narrator;
  final String author;

  _HadithMeta({
    required this.id,
    required this.collection,
    required this.hadithNumber,
    required this.language,
    required this.englishText,
    required this.arabicText,
    required this.narrator,
    required this.author,
  });
}

class HadithSearchMatch {
  final String id;
  final String collection;
  final String hadithNumber;
  final String language;
  final String englishText;
  final String arabicText;
  final String narrator;
  final String author;
  final double score;

  HadithSearchMatch({
    required this.id,
    required this.collection,
    required this.hadithNumber,
    required this.language,
    required this.englishText,
    required this.arabicText,
    required this.narrator,
    required this.author,
    required this.score,
  });
}
