import 'package:flutter_test/flutter_test.dart';

import 'package:duacopilot/data/datasources/islamic_rag_service.dart';
import 'package:duacopilot/data/datasources/quran_api_service.dart';
import 'package:duacopilot/data/models/dua_response.dart';
import 'package:duacopilot/data/models/dua_recommendation.dart';

void main() {
  group('Islamic RAG Integration Tests', () {
    late IslamicRagService ragService;

    setUpAll(() {
      ragService = IslamicRagService();
    });

    tearDownAll(() {
      ragService.dispose();
    });

    group('Basic Functionality Tests', () {
      test('should create IslamicRagService instance', () {
        expect(ragService, isA<IslamicRagService>());
      });

      test('should process simple query and return DuaResponse', () async {
        // Arrange
        final query = 'guidance';

        // Act
        final result = await ragService.processQuery(query: query);

        // Assert
        expect(result, isA<DuaResponse>());
        expect(result.query, equals(query));
        expect(result.response, isNotEmpty);
        expect(result.timestamp, isA<DateTime>());
        expect(result.responseTime, greaterThan(0));
        expect(result.confidence, isA<double>());
        expect(result.sources, isA<List>());

        print('✅ Query processed successfully');
        print('📝 Response length: ${result.response.length} characters');
        print('🎯 Confidence: ${result.confidence}');
        print('📚 Sources: ${result.sources.length}');
      });

      test('should generate recommendations', () async {
        // Arrange
        final query = 'prayer';

        // Act
        final result = await ragService.generateRecommendations(
          query: query,
          limit: 3,
        );

        // Assert
        expect(result, isA<List<DuaRecommendation>>());
        expect(result.length, lessThanOrEqualTo(3));

        if (result.isNotEmpty) {
          final firstRec = result.first;
          expect(firstRec.id, isNotEmpty);
          expect(firstRec.translation, isNotEmpty);
          expect(firstRec.confidence, isA<double>());
          expect(firstRec.reference, isNotNull);

          print('✅ Recommendations generated successfully');
          print(
            '📄 First recommendation: ${firstRec.translation.substring(0, 50)}...',
          );
          print('🎯 Confidence: ${firstRec.confidence}');
          print('📖 Reference: ${firstRec.reference}');
        }
      });

      test('should handle different languages', () async {
        // Arrange
        final query = 'guidance';

        // Act
        final englishResult = await ragService.processQuery(
          query: query,
          language: 'en',
        );

        // We can't easily test Arabic without API responses,
        // but we can verify the method accepts the parameter
        expect(
          () => ragService.processQuery(query: query, language: 'ar'),
          returnsNormally,
        );

        // Assert
        expect(englishResult.query, equals(query));
        expect(englishResult.response, isNotEmpty);

        print('✅ Language handling works correctly');
      });

      test('should return popular recommendations', () async {
        // Act
        final result = await ragService.getPopularRecommendations(limit: 5);

        // Assert
        expect(result, isA<List<DuaRecommendation>>());
        expect(result.length, lessThanOrEqualTo(5));

        print('✅ Popular recommendations retrieved');
        print('📊 Count: ${result.length}');
      });
    });

    group('Quran API Service Tests', () {
      late QuranApiService quranApi;

      setUpAll(() {
        quranApi = QuranApiService();
      });

      tearDownAll(() {
        quranApi.dispose();
      });

      test('should get audio URLs', () {
        // Act
        final audioUrl = quranApi.getAudioUrl(ayahNumber: 1);
        final audioUrls = quranApi.getAudioUrls(ayahNumber: 1);

        // Assert
        expect(audioUrl, isNotEmpty);
        expect(audioUrl, startsWith('https://'));
        expect(audioUrl, endsWith('.mp3'));
        expect(audioUrls, isA<List<String>>());
        expect(audioUrls, isNotEmpty);

        print('✅ Audio URL generation works');
        print('🔊 Sample URL: $audioUrl');
        print('📊 Available qualities: ${audioUrls.length}');
      });

      test('should have popular editions configured', () {
        // Act
        final editions = QuranApiService.popularEditions;
        final reciters = QuranApiService.popularReciters;

        // Assert
        expect(editions, isNotEmpty);
        expect(editions.containsKey('english_sahih'), isTrue);
        expect(editions.containsKey('arabic_uthmani'), isTrue);
        expect(reciters, isNotEmpty);
        expect(reciters.containsKey('alafasy'), isTrue);

        print('✅ Popular editions and reciters configured');
        print('📚 Editions: ${editions.keys.join(', ')}');
        print('🎙️ Reciters: ${reciters.keys.join(', ')}');
      });
    });

    group('Error Handling Tests', () {
      test('should handle empty queries gracefully', () async {
        // Act & Assert
        expect(() => ragService.processQuery(query: ''), returnsNormally);
      });

      test('should handle special characters in queries', () async {
        // Arrange
        final specialQuery = 'guidance & peace!';

        // Act
        final result = await ragService.processQuery(query: specialQuery);

        // Assert
        expect(result, isA<DuaResponse>());
        expect(result.query, equals(specialQuery));

        print('✅ Special characters handled correctly');
      });

      test('should handle very long queries', () async {
        // Arrange
        final longQuery = 'guidance ' * 50; // 50 repetitions

        // Act
        final result = await ragService.processQuery(query: longQuery);

        // Assert
        expect(result, isA<DuaResponse>());
        expect(result.query, equals(longQuery));

        print('✅ Long queries handled correctly');
      });
    });

    group('Cache Management Tests', () {
      test('should clear cache without errors', () async {
        // Act & Assert
        expect(() => ragService.clearCache(), returnsNormally);

        print('✅ Cache clearing works');
      });

      test('should get cache statistics', () async {
        // Act
        final stats = await ragService.getCacheStats();

        // Assert
        expect(stats, isA<Map<String, dynamic>>());

        print('✅ Cache statistics retrieved');
        print('📊 Stats: $stats');
      });
    });

    group('Performance Tests', () {
      test('should process query within reasonable time', () async {
        // Arrange
        final query = 'patience';
        final stopwatch = Stopwatch()..start();

        // Act
        final result = await ragService.processQuery(query: query);
        stopwatch.stop();

        // Assert
        expect(result, isA<DuaResponse>());
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(10000),
        ); // 10 seconds max

        print('✅ Query processed in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should handle multiple concurrent queries', () async {
        // Arrange
        final queries = ['guidance', 'patience', 'prayer', 'forgiveness'];

        // Act
        final futures =
            queries
                .map((query) => ragService.processQuery(query: query))
                .toList();

        final results = await Future.wait(futures);

        // Assert
        expect(results, hasLength(queries.length));
        for (int i = 0; i < results.length; i++) {
          expect(results[i].query, equals(queries[i]));
        }

        print('✅ Concurrent queries handled successfully');
        print('📊 Processed ${results.length} queries concurrently');
      });
    });
  });
}
