/// Simple benchmark test for local vector database performance
/// This runs without Flutter dependencies to test basic functionality
library;

import 'dart:math';

void main() async {
  print('Starting Local Vector Database Performance Test');
  print('====================================================');

  // Test basic vector operations
  await testVectorSimilarity();

  print('\nTest completed successfully!');
}

Future<void> testVectorSimilarity() async {
  print('\n🧮 Testing Vector Similarity Calculations...');

  final random = Random();
  const embeddingSize = 384;

  // Generate test vectors
  List<double> vector1 = List.generate(embeddingSize, (_) => random.nextDouble() * 2 - 1);
  List<double> vector2 = List.generate(embeddingSize, (_) => random.nextDouble() * 2 - 1);

  final stopwatch = Stopwatch()..start();

  // Test cosine similarity calculation
  double similarity = cosineSimilarity(vector1, vector2);

  stopwatch.stop();

  print('✅ Cosine similarity calculated: ${similarity.toStringAsFixed(4)}');
  print('⏱️  Calculation time: ${stopwatch.elapsedMicroseconds} microseconds');

  // Test multiple calculations for performance
  print('\n📊 Performance Test with 1000 calculations:');
  final perfStopwatch = Stopwatch()..start();

  for (int i = 0; i < 1000; i++) {
    cosineSimilarity(vector1, vector2);
  }

  perfStopwatch.stop();
  double avgMicroseconds = perfStopwatch.elapsedMicroseconds / 1000;

  print('🚀 Average time per calculation: ${avgMicroseconds.toStringAsFixed(2)} μs');
  print('🎯 Target performance: <200ms total retrieval time');

  if (avgMicroseconds < 200) {
    print('✅ EXCELLENT: Vector calculations are fast enough!');
  } else {
    print('⚠️  WARNING: Vector calculations might be slow');
  }
}

/// Calculate cosine similarity between two vectors
double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) {
    throw ArgumentError('Vectors must have the same length');
  }

  double dotProduct = 0.0;
  double normA = 0.0;
  double normB = 0.0;

  for (int i = 0; i < a.length; i++) {
    dotProduct += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }

  normA = sqrt(normA);
  normB = sqrt(normB);

  if (normA == 0.0 || normB == 0.0) {
    return 0.0;
  }

  return dotProduct / (normA * normB);
}
