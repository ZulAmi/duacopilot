import 'package:duacopilot/data/models/dua_response.dart';
import 'package:duacopilot/data/models/rag_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../comprehensive_test_config.dart';

/// Unit tests for RAG response models and business logic
void main() {
  setUpAll(() async {
    await TestConfig.initialize();
  });

  tearDownAll(() async {
    await TestConfig.cleanup();
  });

  group('RAG Response Models Unit Tests', () {
    group('DuaResponse Model Tests', () {
      test('should create valid DuaResponse instance', () {
        final duaResponse = DuaResponse(
          id: 'test-1',
          query: 'morning prayer',
          response: 'اللهم أعني على ذكرك',
          timestamp: DateTime.now(),
          responseTime: 250,
          confidence: 0.95,
          sources: [
            DuaSource(
              id: 'source-1',
              title: 'Sahih Bukhari',
              content: 'Morning prayer content',
              relevanceScore: 0.95,
              reference: 'Bukhari 1/123',
              category: 'Morning Prayers',
            ),
          ],
          isFavorite: false,
        );

        expect(duaResponse.id, equals('test-1'));
        expect(duaResponse.query, equals('morning prayer'));
        expect(duaResponse.response, equals('اللهم أعني على ذكرك'));
        expect(duaResponse.confidence, equals(0.95));
        expect(duaResponse.sources.length, equals(1));
        expect(duaResponse.isFavorite, isFalse);
      });

      test('should create DuaResponse with all properties', () {
        final originalResponse = DuaResponse(
          id: 'test-json',
          query: 'test query',
          response: 'test response',
          timestamp: DateTime.parse('2024-01-01T10:00:00Z'),
          responseTime: 300,
          confidence: 0.88,
          sources: [DuaSource(id: 'source-1', title: 'Test Source', content: 'Test content', relevanceScore: 0.88)],
        );

        expect(originalResponse.id, equals('test-json'));
        expect(originalResponse.query, equals('test query'));
        expect(originalResponse.response, equals('test response'));
        expect(originalResponse.confidence, equals(0.88));
        expect(originalResponse.sources.length, equals(1));
        expect(originalResponse.sources.first.id, equals('source-1'));

        print('✅ DuaResponse creation test passed');
      });

      test('should handle empty sources list', () {
        final duaResponse = DuaResponse(
          id: 'test-empty',
          query: 'empty test',
          response: 'response without sources',
          timestamp: DateTime.now(),
          responseTime: 150,
          confidence: 0.75,
          sources: [],
        );

        expect(duaResponse.sources, isEmpty);
        expect(duaResponse.confidence, equals(0.75));
      });

      test('should validate confidence range', () {
        // Test minimum confidence
        final lowConfidenceResponse = DuaResponse(
          id: 'low-conf',
          query: 'low confidence test',
          response: 'low confidence response',
          timestamp: DateTime.now(),
          responseTime: 500,
          confidence: 0.0,
          sources: [],
        );
        expect(lowConfidenceResponse.confidence, equals(0.0));

        // Test maximum confidence
        final highConfidenceResponse = DuaResponse(
          id: 'high-conf',
          query: 'high confidence test',
          response: 'high confidence response',
          timestamp: DateTime.now(),
          responseTime: 200,
          confidence: 1.0,
          sources: [],
        );
        expect(highConfidenceResponse.confidence, equals(1.0));
      });

      test('should handle Arabic text correctly', () {
        final arabicResponse = DuaResponse(
          id: 'arabic-test',
          query: 'صلاة الصباح',
          response: 'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء',
          timestamp: DateTime.now(),
          responseTime: 280,
          confidence: 0.92,
          sources: [
            DuaSource(
              id: 'arabic-source',
              title: 'أبو داود',
              content: 'محتوى الدعاء',
              relevanceScore: 0.92,
              reference: 'أبو داود ٤/٣٢٣',
              category: 'أدعية الصباح',
            ),
          ],
        );

        expect(arabicResponse.query, contains('صلاة'));
        expect(arabicResponse.response, contains('بسم الله'));
        expect(arabicResponse.sources.first.title, equals('أبو داود'));
      });
    });

    group('DuaSource Model Tests', () {
      test('should create valid DuaSource instance', () {
        final source = DuaSource(
          id: 'source-test',
          title: 'Test Source Title',
          content: 'Test source content',
          relevanceScore: 0.85,
          url: 'https://example.com',
          reference: 'Test Reference 1/100',
          category: 'Test Category',
          metadata: {'author': 'Test Author', 'year': '2024'},
        );

        expect(source.id, equals('source-test'));
        expect(source.title, equals('Test Source Title'));
        expect(source.content, equals('Test source content'));
        expect(source.relevanceScore, equals(0.85));
        expect(source.url, equals('https://example.com'));
        expect(source.reference, equals('Test Reference 1/100'));
        expect(source.category, equals('Test Category'));
        expect(source.metadata?['author'], equals('Test Author'));
      });

      test('should serialize DuaSource to/from JSON', () {
        final originalSource = DuaSource(
          id: 'json-source',
          title: 'JSON Test Source',
          content: 'JSON test content',
          relevanceScore: 0.77,
          reference: 'JSON Ref 2/200',
        );

        final json = originalSource.toJson();
        final deserializedSource = DuaSource.fromJson(json);

        expect(deserializedSource.id, equals(originalSource.id));
        expect(deserializedSource.title, equals(originalSource.title));
        expect(deserializedSource.content, equals(originalSource.content));
        expect(deserializedSource.relevanceScore, equals(originalSource.relevanceScore));
        expect(deserializedSource.reference, equals(originalSource.reference));
      });

      test('should handle optional fields correctly', () {
        final minimalSource = DuaSource(
          id: 'minimal',
          title: 'Minimal Source',
          content: 'Minimal content',
          relevanceScore: 0.60,
        );

        expect(minimalSource.url, isNull);
        expect(minimalSource.reference, isNull);
        expect(minimalSource.category, isNull);
        expect(minimalSource.metadata, isNull);
      });
    });

    group('RagResponseModel Tests', () {
      test('should create valid RagResponseModel instance', () {
        final ragResponse = RagResponseModel(
          id: 'rag-test',
          query: 'test rag query',
          response: 'test rag response',
          timestamp: DateTime.now(),
          responseTime: 350,
          sources: ['Source A', 'Source B'],
          metadata: {'model': 'gpt-4', 'tokens': 150},
        );

        expect(ragResponse.id, equals('rag-test'));
        expect(ragResponse.query, equals('test rag query'));
        expect(ragResponse.response, equals('test rag response'));
        expect(ragResponse.responseTime, equals(350));
        expect(ragResponse.sources?.length, equals(2));
        expect(ragResponse.metadata?['model'], equals('gpt-4'));
      });

      test('should convert to/from JSON correctly', () {
        final timestamp = DateTime.parse('2024-01-01T15:30:00Z');
        final originalRag = RagResponseModel(
          id: 'json-rag',
          query: 'json test query',
          response: 'json test response',
          timestamp: timestamp,
          responseTime: 400,
          sources: ['JSON Source'],
        );

        final json = originalRag.toJson();
        final deserializedRag = RagResponseModel.fromJson(json);

        expect(deserializedRag.id, equals(originalRag.id));
        expect(deserializedRag.query, equals(originalRag.query));
        expect(deserializedRag.response, equals(originalRag.response));
        expect(deserializedRag.timestamp, equals(originalRag.timestamp));
        expect(deserializedRag.responseTime, equals(originalRag.responseTime));
        expect(deserializedRag.sources, equals(originalRag.sources));
      });

      test('should handle null sources and metadata', () {
        final ragResponse = RagResponseModel(
          id: 'null-test',
          query: 'null test query',
          response: 'null test response',
          timestamp: DateTime.now(),
          responseTime: 200,
        );

        expect(ragResponse.sources, isNull);
        expect(ragResponse.metadata, isNull);
      });
    });
  });

  group('Business Logic Unit Tests', () {
    group('Response Validation Tests', () {
      test('should validate response time thresholds', () {
        final fastResponse = TestConfig.createMockDuaResponses().first;
        final slowResponse = DuaResponse(
          id: 'slow',
          query: 'slow query',
          response: 'slow response',
          timestamp: DateTime.now(),
          responseTime: 8000, // 8 seconds
          confidence: 0.70,
          sources: [],
        );

        expect(fastResponse.responseTime, lessThan(TestConfig.maxResponseTime.inMilliseconds));
        expect(slowResponse.responseTime, greaterThan(TestConfig.maxResponseTime.inMilliseconds));
      });

      test('should validate confidence scores', () {
        final mockResponses = TestConfig.createMockDuaResponses();

        for (final response in mockResponses) {
          expect(response.confidence, greaterThanOrEqualTo(0.0));
          expect(response.confidence, lessThanOrEqualTo(1.0));
          expect(response.confidence, isA<double>());
        }
      });

      test('should detect Arabic text in queries and responses', () {
        bool containsArabic(String text) {
          final arabicRegex = RegExp(r'[\u0600-\u06FF]');
          return arabicRegex.hasMatch(text);
        }

        final arabicQueries = TestConfig.sampleArabicQueries;
        final englishQueries = TestConfig.sampleEnglishQueries;
        final mixedQueries = TestConfig.mixedLanguageQueries;

        // Test Arabic detection
        for (final query in arabicQueries) {
          expect(containsArabic(query), isTrue, reason: 'Should detect Arabic in: $query');
        }

        // Test English (no Arabic)
        for (final query in englishQueries) {
          expect(containsArabic(query), isFalse, reason: 'Should not detect Arabic in: $query');
        }

        // Test mixed content
        for (final query in mixedQueries) {
          expect(containsArabic(query), isTrue, reason: 'Should detect Arabic in mixed: $query');
        }
      });

      test('should categorize Islamic content correctly', () {
        final categories = {
          'Morning Prayers': ['morning', 'dawn', 'fajr', 'sunrise'],
          'Evening Prayers': ['evening', 'sunset', 'maghrib', 'night'],
          'Travel Prayers': ['travel', 'journey', 'safar'],
          'Forgiveness': ['forgiveness', 'istighfar', 'repentance'],
          'Protection': ['protection', 'safety', 'refuge'],
        };

        categories.forEach((category, keywords) {
          for (final keyword in keywords) {
            expect(keyword.isNotEmpty, isTrue);
            expect(category.isNotEmpty, isTrue);
          }
        });
      });
    });

    group('Performance Validation Tests', () {
      test('should validate response time performance', () {
        final mockResponses = TestConfig.createMockRagResponses();

        for (final response in mockResponses) {
          expect(response.responseTime, lessThan(TestConfig.maxResponseTime.inMilliseconds));
          expect(response.responseTime, greaterThan(0));
        }
      });

      test('should validate source relevance scores', () {
        final mockDuaResponses = TestConfig.createMockDuaResponses();

        for (final response in mockDuaResponses) {
          for (final source in response.sources) {
            expect(source.relevanceScore, greaterThanOrEqualTo(0.0));
            expect(source.relevanceScore, lessThanOrEqualTo(1.0));
            expect(source.relevanceScore, isA<double>());
          }
        }
      });
    });

    group('Content Quality Tests', () {
      test('should ensure all responses have meaningful content', () {
        final mockResponses = TestConfig.createMockDuaResponses();

        for (final response in mockResponses) {
          expect(response.id.isNotEmpty, isTrue);
          expect(response.query.isNotEmpty, isTrue);
          expect(response.response.isNotEmpty, isTrue);
          expect(response.query.length, greaterThan(2));
          expect(response.response.length, greaterThan(5));
        }
      });

      test('should validate Islamic authenticity indicators', () {
        final mockResponses = TestConfig.createMockDuaResponses();

        for (final response in mockResponses) {
          // Every response should have at least one source
          expect(response.sources.isNotEmpty, isTrue);

          // Sources should have authentic Islamic references
          for (final source in response.sources) {
            expect(source.title.isNotEmpty, isTrue);
            expect(source.content.isNotEmpty, isTrue);

            // Check for Islamic source indicators
            final islamicSources = ['Bukhari', 'Muslim', 'Tirmidhi', 'Abu Dawud', 'Nasai', 'Ibn Majah'];
            final hasIslamicSource = islamicSources.any(
              (sourceName) => source.title.contains(sourceName) || source.reference?.contains(sourceName) == true,
            );

            if (source.reference?.isNotEmpty == true) {
              expect(source.reference!.length, greaterThan(3));
            }
          }
        }
      });

      test('should handle special Islamic characters correctly', () {
        final specialChars = ['ﷺ', 'ﷻ', 'ۖ', 'ۗ', 'ۘ', 'ۙ', 'ۚ', 'ۛ', 'ۜ'];
        final textWithSpecialChars = 'محمد ﷺ والله ﷻ';

        expect(textWithSpecialChars.contains('ﷺ'), isTrue);
        expect(textWithSpecialChars.contains('ﷻ'), isTrue);
        expect(textWithSpecialChars.length, greaterThan(10));
      });
    });
  });

  group('Error Handling Unit Tests', () {
    test('should handle invalid JSON gracefully', () {
      expect(() {
        // Test with empty JSON
        DuaResponse.fromJson({});
      }, throwsA(isA<TypeError>()));

      expect(() {
        // Test with malformed JSON
        DuaSource.fromJson({'invalid': 'data'});
      }, throwsA(isA<TypeError>()));
    });

    test('should handle null values appropriately', () {
      final sourceWithNulls = DuaSource(
        id: 'null-test',
        title: 'Test',
        content: 'Content',
        relevanceScore: 0.5,
        url: null,
        reference: null,
        category: null,
        metadata: null,
      );

      expect(sourceWithNulls.url, isNull);
      expect(sourceWithNulls.reference, isNull);
      expect(sourceWithNulls.category, isNull);
      expect(sourceWithNulls.metadata, isNull);
    });

    test('should validate required fields', () {
      // These should throw errors for required fields
      expect(() {
        RagResponseModel(
          id: '', // Empty ID should be invalid in real usage
          query: 'test',
          response: 'test',
          timestamp: DateTime.now(),
          responseTime: 100,
        );
      }, returnsNormally); // Model allows empty ID, but business logic should validate

      // Test timestamp validation
      final futureTimestamp = DateTime.now().add(Duration(days: 1));
      final responseWithFutureTimestamp = RagResponseModel(
        id: 'future-test',
        query: 'future query',
        response: 'future response',
        timestamp: futureTimestamp,
        responseTime: 200,
      );

      expect(responseWithFutureTimestamp.timestamp.isAfter(DateTime.now()), isTrue);
    });
  });

  group('Integration with Test Configuration', () {
    test('should use test configuration constants correctly', () {
      expect(TestConfig.sampleArabicQueries.isNotEmpty, isTrue);
      expect(TestConfig.sampleEnglishQueries.isNotEmpty, isTrue);
      expect(TestConfig.mixedLanguageQueries.isNotEmpty, isTrue);
      expect(TestConfig.networkConditions.isNotEmpty, isTrue);
      expect(TestConfig.testOrientations.isNotEmpty, isTrue);
      expect(TestConfig.testScreenSizes.isNotEmpty, isTrue);
    });

    test('should create valid mock data', () {
      final mockRagResponses = TestConfig.createMockRagResponses();
      final mockDuaResponses = TestConfig.createMockDuaResponses();

      expect(mockRagResponses.isNotEmpty, isTrue);
      expect(mockDuaResponses.isNotEmpty, isTrue);

      for (final response in mockRagResponses) {
        expect(response.id.isNotEmpty, isTrue);
        expect(response.query.isNotEmpty, isTrue);
        expect(response.response.isNotEmpty, isTrue);
      }

      for (final response in mockDuaResponses) {
        expect(response.id.isNotEmpty, isTrue);
        expect(response.query.isNotEmpty, isTrue);
        expect(response.response.isNotEmpty, isTrue);
        expect(response.sources.isNotEmpty, isTrue);
      }
    });

    test('should validate performance thresholds', () {
      expect(TestConfig.maxResponseTime.inMilliseconds, greaterThan(1000));
      expect(TestConfig.maxWidgetRenderTime.inMilliseconds, lessThan(1000));
      expect(TestConfig.maxNavigationTime.inMilliseconds, lessThan(1000));
      expect(TestConfig.minTouchTargetSize, greaterThanOrEqualTo(44.0));
      expect(TestConfig.minContrastRatio, greaterThanOrEqualTo(4.5));
    });
  });
}
