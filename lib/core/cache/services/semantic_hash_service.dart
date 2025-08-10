import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../models/cache_models.dart';

/// Semantic similarity hashing service for query deduplication
class SemanticHashService {
  // Arabic normalization mappings
  static const Map<String, String> _arabicNormalization = {
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'ة': 'ه',
    'ي': 'ى',
    'ؤ': 'و',
    'ئ': 'ى',
  };

  // Islamic term synonyms for semantic matching
  static const Map<String, List<String>> _islamicSynonyms = {
    'prayer': ['salah', 'namaz', 'worship', 'prostration'],
    'dua': ['supplication', 'invocation', 'prayer', 'request'],
    'quran': ['qur\'an', 'book', 'scripture', 'revelation'],
    'allah': ['god', 'creator', 'almighty'],
    'prophet': ['messenger', 'rasul', 'nabi'],
    'صلاة': ['عبادة', 'ركوع', 'سجود', 'قيام'],
    'دعاء': ['استغاثة', 'توسل', 'ابتهال', 'طلب'],
    'قرآن': ['كتاب', 'وحي', 'تنزيل'],
    'الله': ['رب', 'خالق', 'إله'],
  };

  // Stop words for different languages
  static const Map<String, List<String>> _stopWords = {
    'en': [
      'i',
      'me',
      'my',
      'myself',
      'we',
      'our',
      'ours',
      'ourselves',
      'you',
      'your',
      'yours',
      'yourself',
      'yourselves',
      'he',
      'him',
      'his',
      'himself',
      'she',
      'her',
      'hers',
      'herself',
      'it',
      'its',
      'itself',
      'they',
      'them',
      'their',
      'theirs',
      'themselves',
      'what',
      'which',
      'who',
      'whom',
      'this',
      'that',
      'these',
      'those',
      'am',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'having',
      'do',
      'does',
      'did',
      'doing',
      'a',
      'an',
      'the',
      'and',
      'but',
      'if',
      'or',
      'because',
      'as',
      'until',
      'while',
      'of',
      'at',
      'by',
      'for',
      'with',
      'through',
      'during',
      'before',
      'after',
      'above',
      'below',
      'up',
      'down',
      'in',
      'out',
      'on',
      'off',
      'over',
      'under',
      'again',
      'further',
      'then',
      'once',
    ],
    'ar': [
      'في',
      'من',
      'إلى',
      'على',
      'عن',
      'مع',
      'كل',
      'بعض',
      'هذا',
      'هذه',
      'ذلك',
      'تلك',
      'التي',
      'الذي',
      'التي',
      'أن',
      'إن',
      'كان',
      'يكون',
      'تكون',
      'سوف',
      'قد',
      'لم',
      'لن',
      'ما',
      'لا',
      'نعم',
      'كيف',
      'متى',
      'أين',
    ],
    'ur': [
      'کے',
      'کی',
      'کو',
      'کا',
      'میں',
      'پر',
      'سے',
      'کے لیے',
      'یہ',
      'وہ',
      'جو',
      'کہ',
      'اور',
      'یا',
      'لیکن',
      'ہے',
      'ہیں',
      'تھا',
      'تھے',
      'ہو',
      'ہوں',
    ],
    'id': [
      'yang',
      'di',
      'ke',
      'dari',
      'untuk',
      'dengan',
      'pada',
      'ini',
      'itu',
      'adalah',
      'atau',
      'dan',
      'tetapi',
      'saya',
      'anda',
      'dia',
      'mereka',
      'kita',
      'kami',
    ],
  };

  /// Generate semantic hash for a query
  static SemanticHash generateSemanticHash(
    String query,
    String language, {
    double similarityThreshold = 0.8,
  }) {
    // Step 1: Normalize the query
    final normalizedQuery = _normalizeQuery(query, language);

    // Step 2: Extract semantic tokens
    final semanticTokens = _extractSemanticTokens(normalizedQuery, language);

    // Step 3: Generate hash from semantic tokens
    final hash = _generateHash(semanticTokens, language);

    // Step 4: Calculate confidence based on token quality
    final confidence = _calculateConfidence(semanticTokens, language);

    return SemanticHash(
      hash: hash,
      normalizedQuery: normalizedQuery,
      semanticTokens: semanticTokens,
      language: language,
      confidence: confidence,
    );
  }

  /// Check if two queries are semantically similar
  static bool areSimilar(
    SemanticHash hash1,
    SemanticHash hash2, {
    double threshold = 0.8,
  }) {
    // Same language check
    if (hash1.language != hash2.language) {
      return false;
    }

    // Direct hash comparison for exact matches
    if (hash1.hash == hash2.hash) {
      return true;
    }

    // Semantic similarity calculation
    final similarity = _calculateSemanticSimilarity(
      hash1.semanticTokens,
      hash2.semanticTokens,
      hash1.language,
    );

    return similarity >= threshold;
  }

  /// Generate multiple hash variants for similar query detection
  static List<String> generateHashVariants(String query, String language) {
    final variants = <String>[];

    // Original hash
    final originalHash = generateSemanticHash(query, language);
    variants.add(originalHash.hash);

    // Synonym-based variants
    final synonymVariants = _generateSynonymVariants(query, language);
    for (final variant in synonymVariants) {
      final hash = generateSemanticHash(variant, language);
      variants.add(hash.hash);
    }

    // Normalized variants (remove diacritics, etc.)
    final normalizedVariants = _generateNormalizedVariants(query, language);
    for (final variant in normalizedVariants) {
      final hash = generateSemanticHash(variant, language);
      variants.add(hash.hash);
    }

    return variants.toSet().toList(); // Remove duplicates
  }

  /// Normalize query text based on language
  static String _normalizeQuery(String query, String language) {
    var normalized = query.toLowerCase().trim();

    switch (language) {
      case 'ar':
        // Arabic normalization
        _arabicNormalization.forEach((from, to) {
          normalized = normalized.replaceAll(from, to);
        });

        // Remove diacritics
        normalized = normalized.replaceAll(
          RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
          '',
        );

        // Normalize whitespace
        normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
        break;

      case 'ur':
        // Urdu normalization
        normalized = normalized.replaceAll('ک', 'ك');
        normalized = normalized.replaceAll('ی', 'ي');
        break;

      case 'id':
        // Indonesian normalization
        normalized = normalized.replaceAll(RegExp(r'[^\w\s]'), '');
        break;

      case 'en':
      default:
        // English normalization
        normalized = normalized.replaceAll(RegExp(r'[^\w\s]'), '');
        break;
    }

    return normalized;
  }

  /// Extract semantic tokens from normalized query
  static List<String> _extractSemanticTokens(
    String normalized,
    String language,
  ) {
    final words =
        normalized
            .split(RegExp(r'\s+'))
            .where((word) => word.isNotEmpty)
            .toList();

    // Remove stop words
    final stopWords = _stopWords[language] ?? _stopWords['en']!;
    final meaningfulWords =
        words.where((word) => !stopWords.contains(word.toLowerCase())).toList();

    // Expand with synonyms
    final expandedTokens = <String>[];
    for (final word in meaningfulWords) {
      expandedTokens.add(word);

      // Add synonyms if available
      final synonyms = _islamicSynonyms[word.toLowerCase()];
      if (synonyms != null) {
        expandedTokens.addAll(synonyms);
      }
    }

    // Sort for consistent ordering
    expandedTokens.sort();

    return expandedTokens;
  }

  /// Generate hash from semantic tokens
  static String _generateHash(List<String> tokens, String language) {
    final tokenString = tokens.join('|');
    final bytes = utf8.encode('$language:$tokenString');
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16); // Use first 16 characters
  }

  /// Calculate confidence score for semantic tokens
  static double _calculateConfidence(List<String> tokens, String language) {
    if (tokens.isEmpty) return 0.0;

    // Base confidence
    double confidence = 0.5;

    // Bonus for meaningful tokens count
    if (tokens.length >= 3) confidence += 0.2;
    if (tokens.length >= 5) confidence += 0.1;

    // Bonus for Islamic terminology
    int islamicTermCount = 0;
    for (final token in tokens) {
      if (_islamicSynonyms.containsKey(token.toLowerCase())) {
        islamicTermCount++;
      }
    }

    if (islamicTermCount > 0) {
      confidence += (islamicTermCount / tokens.length) * 0.3;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Calculate semantic similarity between token lists
  static double _calculateSemanticSimilarity(
    List<String> tokens1,
    List<String> tokens2,
    String language,
  ) {
    if (tokens1.isEmpty && tokens2.isEmpty) return 1.0;
    if (tokens1.isEmpty || tokens2.isEmpty) return 0.0;

    final set1 = tokens1.toSet();
    final set2 = tokens2.toSet();

    // Jaccard similarity
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);

    if (union.isEmpty) return 0.0;

    double similarity = intersection.length / union.length;

    // Bonus for synonym matches
    int synonymMatches = 0;
    for (final token1 in set1) {
      for (final token2 in set2) {
        if (_areSynonyms(token1, token2)) {
          synonymMatches++;
        }
      }
    }

    // Add synonym bonus
    if (synonymMatches > 0) {
      similarity += (synonymMatches / union.length) * 0.2;
    }

    return similarity.clamp(0.0, 1.0);
  }

  /// Check if two tokens are synonyms
  static bool _areSynonyms(String token1, String token2) {
    for (final synonymGroup in _islamicSynonyms.values) {
      if (synonymGroup.contains(token1.toLowerCase()) &&
          synonymGroup.contains(token2.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// Generate synonym-based query variants
  static List<String> _generateSynonymVariants(String query, String language) {
    final variants = <String>[];
    final words = query.toLowerCase().split(RegExp(r'\s+'));

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final synonyms = _islamicSynonyms[word];

      if (synonyms != null) {
        for (final synonym in synonyms) {
          final newWords = List<String>.from(words);
          newWords[i] = synonym;
          variants.add(newWords.join(' '));
        }
      }
    }

    return variants;
  }

  /// Generate normalized variants
  static List<String> _generateNormalizedVariants(
    String query,
    String language,
  ) {
    final variants = <String>[];

    switch (language) {
      case 'ar':
        // Remove diacritics variant
        var noDiacritics = query.replaceAll(
          RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
          '',
        );
        variants.add(noDiacritics);

        // Normalize alif variants
        var normalizedAlif = query;
        _arabicNormalization.forEach((from, to) {
          normalizedAlif = normalizedAlif.replaceAll(from, to);
        });
        variants.add(normalizedAlif);
        break;

      case 'en':
        // Remove punctuation variant
        variants.add(query.replaceAll(RegExp(r'[^\w\s]'), ''));

        // Singular/plural handling (basic)
        final singular = query.replaceAll(RegExp(r's\b'), '');
        variants.add(singular);
        break;
    }

    return variants;
  }

  /// Batch generate hashes for multiple queries
  static Map<String, SemanticHash> batchGenerateHashes(
    Map<String, String> queries, // query -> language
  ) {
    final hashes = <String, SemanticHash>{};

    for (final entry in queries.entries) {
      final query = entry.key;
      final language = entry.value;

      hashes[query] = generateSemanticHash(query, language);
    }

    return hashes;
  }

  /// Find similar queries from a list
  static List<String> findSimilarQueries(
    String targetQuery,
    String language,
    List<String> candidateQueries, {
    double threshold = 0.8,
  }) {
    final targetHash = generateSemanticHash(targetQuery, language);
    final similarQueries = <String>[];

    for (final candidate in candidateQueries) {
      final candidateHash = generateSemanticHash(candidate, language);

      if (areSimilar(targetHash, candidateHash, threshold: threshold)) {
        similarQueries.add(candidate);
      }
    }

    return similarQueries;
  }
}
