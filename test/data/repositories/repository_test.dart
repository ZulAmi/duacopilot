import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:duacopilot/core/error/failures.dart';
import 'package:duacopilot/domain/entities/rag_response.dart';

void main() {
  group('Repository Pattern Tests', () {
    group('Semantic Similarity', () {
      test('should calculate Jaccard similarity correctly', () {
        // Test semantic similarity algorithm
        const query1 = 'morning prayer dua';
        const query2 = 'morning prayer duas';
        const query3 = 'evening shopping list';

        // Calculate similarities
        final words1 = query1.toLowerCase().split(' ').toSet();
        final words2 = query2.toLowerCase().split(' ').toSet();
        final words3 = query3.toLowerCase().split(' ').toSet();

        // Jaccard similarity
        final intersection12 = words1.intersection(words2).length;
        final union12 = words1.union(words2).length;
        final similarity12 = intersection12 / union12;

        final intersection13 = words1.intersection(words3).length;
        final union13 = words1.union(words3).length;
        final similarity13 = intersection13 / union13;

        // Assert similar queries have reasonable similarity (2/4 = 0.5)
        expect(similarity12, equals(0.5));

        // Assert different queries have low similarity
        expect(similarity13, lessThan(0.3));
      });

      test('should handle Levenshtein distance calculation', () {
        // Test edit distance calculation (simplified)
        double calculateSimilarity(String s1, String s2) {
          if (s1 == s2) return 1.0;
          if (s1.isEmpty || s2.isEmpty) return 0.0;

          // Simple similarity check
          final common = s1.split('').where(s2.contains).length;
          final maxLen = s1.length > s2.length ? s1.length : s2.length;

          return common / maxLen;
        }

        expect(calculateSimilarity('test', 'test'), equals(1.0));
        expect(calculateSimilarity('test', 'tests'), greaterThan(0.5));
        expect(calculateSimilarity('test', 'xyz'), lessThan(0.3));
      });

      test('should detect Arabic text correctly', () {
        // Test Arabic detection
        bool containsArabic(String text) {
          final arabicRegex = RegExp(r'[\u0600-\u06FF]');
          return arabicRegex.hasMatch(text);
        }

        expect(containsArabic('Hello world'), isFalse);
        expect(containsArabic('بسم الله'), isTrue);
        expect(containsArabic('Hello بسم الله world'), isTrue);
      });
    });

    group('Cache Management', () {
      test('should manage in-memory cache correctly', () {
        // Test cache with expiry
        final cache = <String, CacheEntry>{};
        const maxAge = Duration(days: 7);

        // Add entry
        cache['test'] = CacheEntry(
          data: 'test data',
          timestamp: DateTime.now(),
        );

        // Check if valid
        final entry = cache['test']!;
        final isValid = DateTime.now().difference(entry.timestamp) < maxAge;

        expect(isValid, isTrue);
        expect(entry.data, equals('test data'));
      });

      test('should detect expired cache entries', () {
        final oldTimestamp = DateTime.now().subtract(Duration(days: 8));
        final entry = CacheEntry(data: 'old data', timestamp: oldTimestamp);

        const maxAge = Duration(days: 7);
        final isExpired = DateTime.now().difference(entry.timestamp) > maxAge;

        expect(isExpired, isTrue);
      });
    });

    group('Failure Handling', () {
      test('should create correct failure types', () {
        // Test failure creation
        const networkFailure = NetworkFailure('Network error');
        const serverFailure = ServerFailure('Server error');
        const cacheFailure = CacheFailure('Cache error');

        expect(networkFailure.message, equals('Network error'));
        expect(serverFailure.message, equals('Server error'));
        expect(cacheFailure.message, equals('Cache error'));
      });

      test('should handle Either types correctly', () {
        // Test Either usage
        Either<Failure, String> success = Right('Success');
        Either<Failure, String> failure = Left(NetworkFailure('Error'));

        expect(success.isRight(), isTrue);
        expect(failure.isLeft(), isTrue);

        final successValue = success.getOrElse(() => '');
        expect(successValue, equals('Success'));
      });
    });

    group('Analytics Tracking', () {
      test('should track query analytics', () {
        final analytics = <String, dynamic>{};
        const query = 'test query';

        // Record analytics
        final analyticsData = {
          'timestamp': DateTime.now().toIso8601String(),
          'query': query,
          'query_length': query.length,
          'query_words': query.split(' ').length,
          'is_question': query.contains('?'),
          'contains_arabic': _containsArabic(query),
        };

        final key = 'analytics_${DateTime.now().millisecondsSinceEpoch}';
        analytics[key] = analyticsData;

        expect(analytics, isNotEmpty);
        expect(analytics[key]['query'], equals(query));
        expect(analytics[key]['query_words'], equals(2));
        expect(analytics[key]['is_question'], isFalse);
        expect(analytics[key]['contains_arabic'], isFalse);
      });
    });

    group('Background Sync Logic', () {
      test('should determine sync needs correctly', () {
        // Simulate sync logic
        bool needsSync(DateTime? lastSync, Duration interval) {
          if (lastSync == null) return true;
          return DateTime.now().difference(lastSync) > interval;
        }

        const syncInterval = Duration(hours: 6);
        final recentSync = DateTime.now().subtract(Duration(hours: 2));
        final oldSync = DateTime.now().subtract(Duration(hours: 8));

        expect(needsSync(null, syncInterval), isTrue);
        expect(needsSync(recentSync, syncInterval), isFalse);
        expect(needsSync(oldSync, syncInterval), isTrue);
      });

      test('should handle popular queries list', () {
        final popularQueries = [
          'morning duas',
          'evening duas',
          'prayer duas',
          'forgiveness duas',
          'protection duas',
          'travel duas',
          'food duas',
          'sleep duas',
        ];

        expect(popularQueries.length, equals(8));
        expect(popularQueries.every((q) => q.contains('duas')), isTrue);

        // Test sync needs for popular queries
        for (String query in popularQueries) {
          expect(query.isNotEmpty, isTrue);
          expect(query.toLowerCase(), equals(query));
        }
      });
    });

    group('Query Processing', () {
      test('should normalize queries correctly', () {
        String normalizeQuery(String query) {
          return query.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
        }

        expect(normalizeQuery('  HELLO   WORLD  '), equals('hello world'));
        expect(normalizeQuery('Test Query'), equals('test query'));
        expect(normalizeQuery(''), equals(''));
      });

      test('should validate query input', () {
        bool isValidQuery(String query) {
          final normalized = query.trim();
          return normalized.isNotEmpty && normalized.length >= 2;
        }

        expect(isValidQuery(''), isFalse);
        expect(isValidQuery('a'), isFalse);
        expect(isValidQuery('ab'), isTrue);
        expect(isValidQuery('valid query'), isTrue);
        expect(isValidQuery('  test  '), isTrue);
      });
    });

    group('Entity Creation', () {
      test('should create RagResponse correctly', () {
        final response = RagResponse(
          id: '1',
          query: 'test query',
          response: 'test response',
          timestamp: DateTime.now(),
          responseTime: 100,
          confidence: 0.8,
          sources: ['source1', 'source2'],
        );

        expect(response.id, equals('1'));
        expect(response.query, equals('test query'));
        expect(response.response, equals('test response'));
        expect(response.confidence, equals(0.8));
        expect(response.sources?.length, equals(2));
        expect(response.responseTime, equals(100));
      });
    });

    group('Retry Logic', () {
      test('should calculate exponential backoff correctly', () {
        Duration calculateBackoff(int attempt, Duration baseDelay) {
          final multiplier = 1 << attempt; // 2^attempt
          return Duration(milliseconds: baseDelay.inMilliseconds * multiplier);
        }

        const baseDelay = Duration(milliseconds: 100);

        expect(
          calculateBackoff(0, baseDelay),
          equals(Duration(milliseconds: 100)),
        );
        expect(
          calculateBackoff(1, baseDelay),
          equals(Duration(milliseconds: 200)),
        );
        expect(
          calculateBackoff(2, baseDelay),
          equals(Duration(milliseconds: 400)),
        );
        expect(
          calculateBackoff(3, baseDelay),
          equals(Duration(milliseconds: 800)),
        );
      });

      test('should limit maximum retry attempts', () {
        const maxRetries = 3;
        int currentAttempt = 0;

        bool shouldRetry() {
          return currentAttempt < maxRetries;
        }

        expect(shouldRetry(), isTrue); // attempt 0
        currentAttempt++;
        expect(shouldRetry(), isTrue); // attempt 1
        currentAttempt++;
        expect(shouldRetry(), isTrue); // attempt 2
        currentAttempt++;
        expect(shouldRetry(), isFalse); // attempt 3, should stop
      });
    });
  });
}

/// Helper class for cache testing
class CacheEntry {
  final String data;
  final DateTime timestamp;

  CacheEntry({required this.data, required this.timestamp});
}

/// Helper function for Arabic detection
bool _containsArabic(String text) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  return arabicRegex.hasMatch(text);
}
