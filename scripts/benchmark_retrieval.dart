/// High-performance benchmark comparing local vector DB vs API retrieval latency.
/// 
/// Usage:
///   dart run scripts/benchmark_retrieval.dart
///   flutter test scripts/benchmark_retrieval.dart
/// 
/// Expected results:
///   - Local vector DB: 50-200ms
///   - API retrieval: 1000-3000ms
import 'dart:async';
import 'dart:math' as math;

import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/config/rag_config.dart';
import 'package:duacopilot/data/datasources/quran_vector_index.dart';
import 'package:duacopilot/data/datasources/islamic_rag_service.dart';
import 'package:duacopilot/data/datasources/quran_api_service.dart';
import 'package:duacopilot/data/datasources/rag_cache_service.dart';

Future<void> main() async {
  print('🚀 Starting Quran Vector Database Performance Benchmark\n');
  
  final benchmark = RetrievalBenchmark();
  await benchmark.run();
}

class RetrievalBenchmark {
  late QuranVectorIndex vectorIndex;
  late IslamicRagService ragService;
  late QuranApiService apiService;

  final List<String> testQueries = [
    'mercy and forgiveness',
    'patience in hardship and difficulty',
    'gratitude and thankfulness to Allah',
    'seeking knowledge and wisdom',
    'prayer and worship guidance',
    'family relationships and duties',
    'charity and helping the poor',
    'justice and fairness in Islam',
    'peace and tranquility',
    'guidance for righteous living',
  ];

  Future<void> run() async {
    await _initialize();
    await _warmup();
    
    final localResults = await _benchmarkLocalVector();
    final apiResults = await _benchmarkApiRetrieval();
    
    _printResults(localResults, apiResults);
    _analyzePerformance(localResults, apiResults);
  }

  Future<void> _initialize() async {
    print('📝 Initializing benchmark components...');
    
    // Initialize vector index
    vectorIndex = QuranVectorIndex.instance;
    await vectorIndex.initialize();
    
    // Initialize services
    apiService = QuranApiService();
    ragService = IslamicRagService(
      quranApi: apiService,
      cacheService: RagCacheService(),
    );
    
    print('✅ Initialization complete\n');
  }

  Future<void> _warmup() async {
    print('🔥 Warming up systems...');
    
    // Warmup vector index
    if (vectorIndex.isReady) {
      await vectorIndex.search(query: 'test warmup', limit: 1);
    }
    
    // Warmup API (with rate limiting consideration)
    try {
      await apiService.searchVerses(query: 'guidance', edition: 'en.sahih');
      await Future.delayed(Duration(milliseconds: 100)); // Rate limit courtesy
    } catch (e) {
      print('⚠️ API warmup failed: $e');
    }
    
    print('✅ Warmup complete\n');
  }

  Future<BenchmarkResults> _benchmarkLocalVector() async {
    print('🔍 Benchmarking Local Vector Database...');
    
    final latencies = <int>[];
    final resultCounts = <int>[];
    int failures = 0;

    for (int i = 0; i < testQueries.length; i++) {
      final query = testQueries[i];
      print('  Query ${i + 1}/${testQueries.length}: "$query"');

      try {
        final stopwatch = Stopwatch()..start();
        final results = await vectorIndex.search(query: query, limit: 10);
        stopwatch.stop();

        final latencyMs = stopwatch.elapsedMilliseconds;
        latencies.add(latencyMs);
        resultCounts.add(results.length);

        print('    ✅ ${latencyMs}ms, ${results.length} results');
      } catch (e) {
        failures++;
        print('    ❌ Failed: $e');
      }

      // Small delay between queries
      await Future.delayed(Duration(milliseconds: 50));
    }

    return BenchmarkResults(
      name: 'Local Vector Database',
      latencies: latencies,
      resultCounts: resultCounts,
      failures: failures,
    );
  }

  Future<BenchmarkResults> _benchmarkApiRetrieval() async {
    print('\n🌐 Benchmarking API Retrieval...');
    
    final latencies = <int>[];
    final resultCounts = <int>[];
    int failures = 0;

    for (int i = 0; i < testQueries.length; i++) {
      final query = testQueries[i];
      print('  Query ${i + 1}/${testQueries.length}: "$query"');

      try {
        final stopwatch = Stopwatch()..start();
        final result = await apiService.searchVerses(query: query, edition: 'en.sahih');
        stopwatch.stop();

        final latencyMs = stopwatch.elapsedMilliseconds;
        latencies.add(latencyMs);
        resultCounts.add(result.matches.length);

        print('    ✅ ${latencyMs}ms, ${result.matches.length} results');
      } catch (e) {
        failures++;
        print('    ❌ Failed: $e');
      }

      // Longer delay for API rate limiting
      await Future.delayed(Duration(milliseconds: 500));
    }

    return BenchmarkResults(
      name: 'API Retrieval',
      latencies: latencies,
      resultCounts: resultCounts,
      failures: failures,
    );
  }

  void _printResults(BenchmarkResults local, BenchmarkResults api) {
    print('\n📊 BENCHMARK RESULTS\n');
    print('=' * 60);
    
    _printResultsFor(local);
    print('');
    _printResultsFor(api);
    print('=' * 60);
  }

  void _printResultsFor(BenchmarkResults results) {
    if (results.latencies.isEmpty) {
      print('${results.name}: No successful queries');
      return;
    }

    final sorted = [...results.latencies]..sort();
    final mean = results.latencies.reduce((a, b) => a + b) / results.latencies.length;
    final median = _percentile(sorted, 50);
    final p95 = _percentile(sorted, 95);
    final min = sorted.first;
    final max = sorted.last;
    
    final avgResults = results.resultCounts.isNotEmpty
        ? results.resultCounts.reduce((a, b) => a + b) / results.resultCounts.length
        : 0;

    print('${results.name}:');
    print('  Latency: ${mean.toStringAsFixed(1)}ms avg, ${median}ms median, ${p95}ms p95');
    print('  Range: ${min}ms min, ${max}ms max');
    print('  Results: ${avgResults.toStringAsFixed(1)} avg per query');
    print('  Success: ${results.latencies.length}/${results.latencies.length + results.failures}');
  }

  void _analyzePerformance(BenchmarkResults local, BenchmarkResults api) {
    print('\n🎯 PERFORMANCE ANALYSIS\n');

    if (local.latencies.isNotEmpty && api.latencies.isNotEmpty) {
      final localMedian = _percentile([...local.latencies]..sort(), 50);
      final apiMedian = _percentile([...api.latencies]..sort(), 50);
      final speedup = apiMedian / localMedian;

      print('Speed Improvement: ${speedup.toStringAsFixed(1)}x faster');
      print('Local target (50-200ms): ${_checkTarget(local.latencies, 50, 200)}');
      
      // Check if local retrieval meets performance requirements
      final localP95 = _percentile([...local.latencies]..sort(), 95);
      if (localP95 <= 200) {
        print('🎉 SUCCESS: Local vector DB meets 50-200ms target!');
      } else {
        print('⚠️  WARNING: Local vector DB exceeds 200ms target (${localP95}ms p95)');
      }
    }

    // Recommend optimizations
    print('\n💡 OPTIMIZATION RECOMMENDATIONS:');
    
    if (vectorIndex.isReady) {
      print('✅ Vector index is ready and operational');
    } else {
      print('❌ Vector index not ready - check initialization');
    }
    
    print('📈 Consider:');
    print('  - Pre-compute embeddings with sentence-transformers');
    print('  - Use production Qdrant deployment for scaling');
    print('  - Implement connection pooling for API fallback');
    print('  - Add caching layer for frequent queries');
  }

  String _checkTarget(List<int> latencies, int minMs, int maxMs) {
    final sorted = [...latencies]..sort();
    final median = _percentile(sorted, 50);
    final p95 = _percentile(sorted, 95);
    
    if (median >= minMs && p95 <= maxMs) {
      return '✅ PASS (${median}ms median, ${p95}ms p95)';
    } else {
      return '❌ FAIL (${median}ms median, ${p95}ms p95)';
    }
  }

  int _percentile(List<int> sorted, int percentile) {
    if (sorted.isEmpty) return 0;
    final index = (sorted.length * percentile / 100).ceil() - 1;
    return sorted[math.max(0, math.min(index, sorted.length - 1))];
  }
}

class BenchmarkResults {
  final String name;
  final List<int> latencies;
  final List<int> resultCounts;
  final int failures;

  BenchmarkResults({
    required this.name,
    required this.latencies,
    required this.resultCounts,
    required this.failures,
  });
}
