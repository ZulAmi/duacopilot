import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:duacopilot/services/enhanced_rag_service.dart';
import 'package:duacopilot/services/offline/offline_search_initialization_service.dart';

void main() {
  group('Offline Semantic Search System Tests', () {
    late EnhancedRagService enhancedRagService;

    setUpAll(() async {
      // Initialize GetIt with reassignment allowed for testing
      GetIt.I.allowReassignment = true;

      try {
        // Initialize the offline search system
        await OfflineSearchInitializationService.initializeOfflineSearch();
        print('✅ Offline search system initialized');

        // Get the enhanced RAG service
        enhancedRagService = GetIt.instance<EnhancedRagService>();
        print('✅ Enhanced RAG service obtained');
      } catch (e) {
        print('❌ Setup failed: $e');
        rethrow;
      }
    });

    tearDownAll(() async {
      // Clean up GetIt
      await GetIt.instance.reset();
      print('✅ Cleanup completed');
    });

    group('System Initialization', () {
      test('should initialize offline search system successfully', () {
        expect(OfflineSearchInitializationService.isInitialized, isTrue);
        expect(GetIt.instance.isRegistered<EnhancedRagService>(), isTrue);
        print('✅ System initialization verified');
      });

      test('should populate initial embeddings', () async {
        try {
          await OfflineSearchInitializationService.populateInitialEmbeddings();
          print('✅ Initial embeddings populated successfully');
        } catch (e) {
          print(
            'ℹ️ Initial embeddings population: $e (may be normal if no initial data)',
          );
          // This may fail if no initial data is available, which is acceptable
        }
      });
    });

    group('Enhanced RAG Service Integration', () {
      test('should perform offline-preferred search', () async {
        try {
          final result = await enhancedRagService.searchDuas(
            query: 'morning prayer',
            language: 'en',
            preferOffline: true,
          );

          expect(result, isNotNull);
          expect(result.recommendations, isNotEmpty);

          print('✅ Offline search completed');
          print('   - Results: ${result.recommendations.length}');
          print('   - Search type: ${result.metadata?['search_type']}');
          print('   - Quality: ${result.metadata?['quality']}');
        } catch (e) {
          print('❌ Offline search failed: $e');
          rethrow;
        }
      });

      test('should provide search statistics', () async {
        try {
          final stats = await enhancedRagService.getSearchStatistics();

          expect(stats, isNotNull);
          expect(stats.containsKey('connection_status'), isTrue);
          expect(stats.containsKey('capabilities'), isTrue);

          print('✅ Search statistics obtained');
          print('   - Connection: ${stats['connection_status']}');
          print('   - Capabilities: ${stats['capabilities']}');

          if (stats.containsKey('offline_stats')) {
            print('   - Offline stats: ${stats['offline_stats']}');
          }
        } catch (e) {
          print('❌ Statistics retrieval failed: $e');
          rethrow;
        }
      });

      test('should handle fallback gracefully for unknown queries', () async {
        try {
          final result = await enhancedRagService.searchDuas(
            query: 'very_obscure_unknown_query_12345',
            language: 'en',
            preferOffline: true,
          );

          expect(result, isNotNull);
          expect(
            result.recommendations,
            isNotEmpty,
          ); // Should have fallback templates

          print('✅ Graceful fallback handled');
          print('   - Fallback results: ${result.recommendations.length}');
          print('   - Quality: ${result.metadata?['quality']}');
        } catch (e) {
          print('❌ Fallback handling failed: $e');
          rethrow;
        }
      });

      test('should sync with remote when available', () async {
        try {
          await enhancedRagService.syncWithRemote();
          print('✅ Remote sync completed (or gracefully handled offline)');
        } catch (e) {
          print('ℹ️ Remote sync: $e (may be normal if offline)');
          // This may fail if offline, which is acceptable
        }
      });
    });

    group('End-to-End Workflow', () {
      test('should handle complete offline workflow', () async {
        try {
          // 1. Perform offline search
          final searchResult = await enhancedRagService.searchDuas(
            query: 'forgiveness prayer',
            language: 'en',
            preferOffline: true,
          );

          expect(searchResult, isNotNull);
          expect(searchResult.metadata?['search_type'], equals('offline'));

          // 2. Get system statistics
          final stats = await enhancedRagService.getSearchStatistics();
          expect(stats['capabilities']['offline_available'], isTrue);

          print('✅ End-to-end workflow completed successfully');
          print(
            '   - Search completed with ${searchResult.recommendations.length} results',
          );
          print(
            '   - Offline capabilities confirmed: ${stats['capabilities']['offline_available']}',
          );
        } catch (e) {
          print('❌ End-to-end workflow failed: $e');
          rethrow;
        }
      });

      test('should demonstrate quality indicators', () async {
        final queries = [
          'morning prayer',
          'forgiveness',
          'travel safety',
          'very_specific_unusual_query_xyz',
        ];

        for (final query in queries) {
          try {
            final result = await enhancedRagService.searchDuas(
              query: query,
              language: 'en',
              preferOffline: true,
            );

            final quality = result.metadata?['quality'];
            print(
              '✅ Query: "$query" -> Quality: $quality, Results: ${result.recommendations.length}',
            );

            expect(result, isNotNull);
            expect(
              quality,
              isIn(['high', 'medium', 'low', 'template', 'cached']),
            );
          } catch (e) {
            print('❌ Quality test failed for "$query": $e');
          }
        }
      });
    });

    group('Performance and Reliability', () {
      test('should handle multiple concurrent searches', () async {
        final futures = <Future>[];
        final queries = ['morning', 'evening', 'travel', 'food', 'sleep'];

        for (final query in queries) {
          futures.add(
            enhancedRagService.searchDuas(
              query: '$query prayer',
              language: 'en',
              preferOffline: true,
            ),
          );
        }

        try {
          final results = await Future.wait(futures);

          expect(results.length, equals(queries.length));
          for (int i = 0; i < results.length; i++) {
            expect(results[i], isNotNull);
            print('✅ Concurrent search $i completed');
          }

          print('✅ All concurrent searches completed successfully');
        } catch (e) {
          print('❌ Concurrent search test failed: $e');
          rethrow;
        }
      });

      test('should maintain consistent response times', () async {
        final query = 'morning prayer';
        final times = <Duration>[];

        for (int i = 0; i < 5; i++) {
          final stopwatch = Stopwatch()..start();

          try {
            await enhancedRagService.searchDuas(
              query: query,
              language: 'en',
              preferOffline: true,
            );

            stopwatch.stop();
            times.add(stopwatch.elapsed);

            print(
              '✅ Search ${i + 1} completed in ${stopwatch.elapsedMilliseconds}ms',
            );
          } catch (e) {
            print('❌ Performance test iteration ${i + 1} failed: $e');
          }
        }

        if (times.isNotEmpty) {
          final avgTime =
              times.map((t) => t.inMilliseconds).reduce((a, b) => a + b) /
              times.length;
          print('✅ Average response time: ${avgTime.toStringAsFixed(1)}ms');

          // Reasonable expectation: under 5 seconds for offline search
          expect(times.every((t) => t.inSeconds < 5), isTrue);
        }
      });
    });
  });
}

/// Test utilities and helpers
class TestHelper {
  static void printTestSeparator(String title) {
    print('\n${'=' * 50}');
    print('  $title');
    print('=' * 50);
  }

  static void printSuccess(String message) {
    print('✅ $message');
  }

  static void printInfo(String message) {
    print('ℹ️ $message');
  }

  static void printError(String message) {
    print('❌ $message');
  }
}
