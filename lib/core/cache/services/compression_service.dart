import 'dart:convert';
import 'dart:io';

/// Compression service for cache data using gzip
class CompressionService {
  /// Compress string data using gzip
  static String compressString(String data) {
    try {
      final bytes = utf8.encode(data);
      final compressed = gzip.encode(bytes);
      return base64Encode(compressed);
    } catch (e) {
      // If compression fails, return original data
      return data;
    }
  }

  /// Decompress gzip compressed data
  static String decompressString(String compressedData) {
    try {
      final compressed = base64Decode(compressedData);
      final decompressed = gzip.decode(compressed);
      return utf8.decode(decompressed);
    } catch (e) {
      // If decompression fails, assume it's uncompressed data
      return compressedData;
    }
  }

  /// Calculate compression ratio
  static double calculateCompressionRatio(String original, String compressed) {
    if (original.isEmpty) return 1.0;

    final originalSize = utf8.encode(original).length;
    final compressedSize = compressed.length;

    return compressedSize / originalSize;
  }

  /// Check if compression is beneficial
  static bool shouldCompress(
    String data, {
    int minimumSize = 100,
    double maxRatio = 0.9,
  }) {
    if (data.length < minimumSize) return false;

    // Test compression
    final compressed = compressString(data);
    final ratio = calculateCompressionRatio(data, compressed);

    return ratio < maxRatio;
  }

  /// Compress data conditionally
  static CompressionResult compressConditionally(
    String data, {
    int minimumSize = 100,
    double maxRatio = 0.9,
  }) {
    if (!shouldCompress(data, minimumSize: minimumSize, maxRatio: maxRatio)) {
      return CompressionResult(
        data: data,
        isCompressed: false,
        compressionRatio: 1.0,
        originalSize: data.length,
        compressedSize: data.length,
      );
    }

    final compressed = compressString(data);
    final ratio = calculateCompressionRatio(data, compressed);

    return CompressionResult(
      data: compressed,
      isCompressed: true,
      compressionRatio: ratio,
      originalSize: data.length,
      compressedSize: compressed.length,
    );
  }

  /// Batch compress multiple data entries
  static Map<String, CompressionResult> batchCompress(
    Map<String, String> data, {
    int minimumSize = 100,
    double maxRatio = 0.9,
  }) {
    final results = <String, CompressionResult>{};

    for (final entry in data.entries) {
      results[entry.key] = compressConditionally(
        entry.value,
        minimumSize: minimumSize,
        maxRatio: maxRatio,
      );
    }

    return results;
  }

  /// Smart compression for Arabic text
  static CompressionResult compressArabicText(String arabicText) {
    // Arabic text often compresses very well due to repeated patterns
    // Use more aggressive compression settings

    if (arabicText.length < 50) {
      return CompressionResult(
        data: arabicText,
        isCompressed: false,
        compressionRatio: 1.0,
        originalSize: arabicText.length,
        compressedSize: arabicText.length,
      );
    }

    // Pre-process Arabic text for better compression
    var processed = _preprocessArabicForCompression(arabicText);

    final compressed = compressString(processed);
    final ratio = calculateCompressionRatio(processed, compressed);

    // Arabic text should compress to at least 60% for it to be worth it
    if (ratio > 0.6) {
      return CompressionResult(
        data: arabicText,
        isCompressed: false,
        compressionRatio: 1.0,
        originalSize: arabicText.length,
        compressedSize: arabicText.length,
      );
    }

    return CompressionResult(
      data: compressed,
      isCompressed: true,
      compressionRatio: ratio,
      originalSize: arabicText.length,
      compressedSize: compressed.length,
      metadata: {'preprocessed': true, 'language': 'arabic'},
    );
  }

  /// Preprocess Arabic text for better compression
  static String _preprocessArabicForCompression(String text) {
    var processed = text;

    // Normalize common Arabic patterns
    final normalizations = {
      'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…': 'ï·½',
      'ØµÙ„Ù‰ Ø§Ù„Ù„Ù‡ Ø¹Ù„ÙŠÙ‡ ÙˆØ³Ù„Ù…': 'ï·º',
      'Ø¹Ù„ÙŠÙ‡ Ø§Ù„Ø³Ù„Ø§Ù…': 'Ø',
      'Ø±Ø¶ÙŠ Ø§Ù„Ù„Ù‡ Ø¹Ù†Ù‡': 'ØØ“',
      'Ø±Ø¶ÙŠ Ø§Ù„Ù„Ù‡ Ø¹Ù†Ù‡Ø§': 'ØØ“',
    };

    normalizations.forEach((pattern, replacement) {
      processed = processed.replaceAll(pattern, replacement);
    });

    return processed;
  }

  /// Decompress with metadata handling
  static String smartDecompress(CompressionResult result) {
    if (!result.isCompressed) {
      return result.data;
    }

    var decompressed = decompressString(result.data);

    // Handle Arabic preprocessing reversal if needed
    if (result.metadata['preprocessed'] == true &&
        result.metadata['language'] == 'arabic') {
      decompressed = _reverseArabicPreprocessing(decompressed);
    }

    return decompressed;
  }

  /// Reverse Arabic preprocessing
  static String _reverseArabicPreprocessing(String text) {
    var restored = text;

    final reversals = {
      'ï·½': 'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…',
      'ï·º': 'ØµÙ„Ù‰ Ø§Ù„Ù„Ù‡ Ø¹Ù„ÙŠÙ‡ ÙˆØ³Ù„Ù…',
      'Ø': 'Ø¹Ù„ÙŠÙ‡ Ø§Ù„Ø³Ù„Ø§Ù…',
      'ØØ“': 'Ø±Ø¶ÙŠ Ø§Ù„Ù„Ù‡ Ø¹Ù†Ù‡', // Note: This is simplified
    };

    reversals.forEach((symbol, expansion) {
      restored = restored.replaceAll(symbol, expansion);
    });

    return restored;
  }

  /// Get compression statistics
  static CompressionStats getCompressionStats(List<CompressionResult> results) {
    if (results.isEmpty) {
      return CompressionStats(
        totalOriginalSize: 0,
        totalCompressedSize: 0,
        averageCompressionRatio: 1.0,
        compressionCount: 0,
        uncompressedCount: 0,
        totalSpaceSaved: 0,
      );
    }

    int totalOriginalSize = 0;
    int totalCompressedSize = 0;
    int compressionCount = 0;
    int uncompressedCount = 0;

    for (final result in results) {
      totalOriginalSize += result.originalSize;
      totalCompressedSize += result.compressedSize;

      if (result.isCompressed) {
        compressionCount++;
      } else {
        uncompressedCount++;
      }
    }

    final averageRatio =
        totalOriginalSize > 0 ? totalCompressedSize / totalOriginalSize : 1.0;

    return CompressionStats(
      totalOriginalSize: totalOriginalSize,
      totalCompressedSize: totalCompressedSize,
      averageCompressionRatio: averageRatio,
      compressionCount: compressionCount,
      uncompressedCount: uncompressedCount,
      totalSpaceSaved: totalOriginalSize - totalCompressedSize,
    );
  }
}

/// Result of compression operation
class CompressionResult {
  final String data;
  final bool isCompressed;
  final double compressionRatio;
  final int originalSize;
  final int compressedSize;
  final Map<String, dynamic> metadata;

  const CompressionResult({
    required this.data,
    required this.isCompressed,
    required this.compressionRatio,
    required this.originalSize,
    required this.compressedSize,
    this.metadata = const {},
  });

  int get spaceSaved => originalSize - compressedSize;

  double get spaceSavedPercentage =>
      originalSize > 0 ? (spaceSaved / originalSize) * 100 : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'isCompressed': isCompressed,
      'compressionRatio': compressionRatio,
      'originalSize': originalSize,
      'compressedSize': compressedSize,
      'metadata': metadata,
    };
  }

  factory CompressionResult.fromJson(Map<String, dynamic> json) {
    return CompressionResult(
      data: json['data'],
      isCompressed: json['isCompressed'] ?? false,
      compressionRatio: json['compressionRatio']?.toDouble() ?? 1.0,
      originalSize: json['originalSize'] ?? 0,
      compressedSize: json['compressedSize'] ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Compression statistics
class CompressionStats {
  final int totalOriginalSize;
  final int totalCompressedSize;
  final double averageCompressionRatio;
  final int compressionCount;
  final int uncompressedCount;
  final int totalSpaceSaved;

  const CompressionStats({
    required this.totalOriginalSize,
    required this.totalCompressedSize,
    required this.averageCompressionRatio,
    required this.compressionCount,
    required this.uncompressedCount,
    required this.totalSpaceSaved,
  });

  int get totalCount => compressionCount + uncompressedCount;

  double get compressionPercentage =>
      totalCount > 0 ? (compressionCount / totalCount) * 100 : 0.0;

  double get spaceSavedPercentage =>
      totalOriginalSize > 0 ? (totalSpaceSaved / totalOriginalSize) * 100 : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'totalOriginalSize': totalOriginalSize,
      'totalCompressedSize': totalCompressedSize,
      'averageCompressionRatio': averageCompressionRatio,
      'compressionCount': compressionCount,
      'uncompressedCount': uncompressedCount,
      'totalSpaceSaved': totalSpaceSaved,
    };
  }

  factory CompressionStats.fromJson(Map<String, dynamic> json) {
    return CompressionStats(
      totalOriginalSize: json['totalOriginalSize'] ?? 0,
      totalCompressedSize: json['totalCompressedSize'] ?? 0,
      averageCompressionRatio:
          json['averageCompressionRatio']?.toDouble() ?? 1.0,
      compressionCount: json['compressionCount'] ?? 0,
      uncompressedCount: json['uncompressedCount'] ?? 0,
      totalSpaceSaved: json['totalSpaceSaved'] ?? 0,
    );
  }
}
