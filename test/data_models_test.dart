import 'package:duacopilot/data/models/audio_cache.dart';
import 'package:duacopilot/data/models/dua_recommendation.dart';
import 'package:duacopilot/data/models/dua_response.dart';
import 'package:duacopilot/data/models/query_history.dart';
import 'package:duacopilot/data/models/user_preference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RAG Data Models Tests', () {
    test('QueryHistory model creation and database conversion', () {
      final queryHistory = QueryHistory(
        id: 'test_id',
        query: 'What is the dua for traveling?',
        response: 'The dua for traveling is...',
        timestamp: DateTime.now(),
        responseTime: 500,
        semanticHash: 'hash123',
        confidence: 0.95,
      );

      expect(queryHistory.id, equals('test_id'));
      expect(queryHistory.confidence, equals(0.95));

      // Test database conversion
      final dbMap = queryHistory.toDatabase();
      expect(dbMap['id'], equals('test_id'));
      expect(dbMap['confidence'], equals(0.95));

      // Test semantic hash generation
      final hash = QueryHistoryHelper.generateSemanticHash('test query');
      expect(hash, isNotNull);
    });

    test('DuaRecommendation model creation', () {
      final recommendation = DuaRecommendation(
        id: 'rec_1',
        arabicText: 'اللهم بارك لنا فيما رزقتنا',
        transliteration: 'Allahumma barik lana fima razaqtana',
        translation: 'O Allah, bless us in what You have provided us',
        confidence: 0.9,
        category: 'food',
      );

      expect(recommendation.arabicText, isNotEmpty);
      expect(recommendation.confidence, equals(0.9));

      final dbMap = recommendation.toDatabase();
      expect(dbMap['arabic_text'], equals('اللهم بارك لنا فيما رزقتنا'));
    });

    test('UserPreference model with different types', () {
      final stringPref = UserPreference(
        id: 'pref_1',
        userId: 'user_123',
        key: 'language',
        value: 'en',
        type: 'string',
      );

      final intPref = UserPreference(
        id: 'pref_2',
        userId: 'user_123',
        key: 'audio_quality',
        value: '128',
        type: 'int',
      );

      final boolPref = UserPreference(
        id: 'pref_3',
        userId: 'user_123',
        key: 'notifications_enabled',
        value: 'true',
        type: 'bool',
      );

      expect(stringPref.stringValue, equals('en'));
      expect(intPref.intValue, equals(128));
      expect(boolPref.boolValue, equals(true));
    });

    test('AudioCache model with quality enum', () {
      final audioCache = AudioCache(
        id: 'audio_1',
        duaId: 'dua_123',
        fileName: 'travel_dua.mp3',
        localPath: '/storage/audio/travel_dua.mp3',
        fileSizeBytes: 2048000,
        quality: AudioQuality.high,
        status: DownloadStatus.completed,
      );

      expect(audioCache.quality.bitrate, equals(192));
      expect(audioCache.status.displayName, equals('Downloaded'));

      final dbMap = audioCache.toDatabase();
      expect(dbMap['quality'], equals('high'));
      expect(dbMap['status'], equals('completed'));
    });

    test('DuaResponse model with sources', () {
      final source = DuaSource(
        id: 'source_1',
        title: 'Sahih Bukhari',
        content: 'Hadith content...',
        relevanceScore: 0.95,
      );

      final response = DuaResponse(
        id: 'resp_1',
        query: 'Travel dua',
        response: 'The travel dua is...',
        timestamp: DateTime.now(),
        responseTime: 750,
        confidence: 0.92,
        sources: [source],
      );

      expect(response.sources.length, equals(1));
      expect(response.sources.first.relevanceScore, equals(0.95));
    });
  });

  group('Data Model Utility Tests', () {
    test('Semantic hash generation', () {
      final hash1 = QueryHistoryHelper.generateSemanticHash(
        'What is the dua for traveling?',
      );
      final hash2 = QueryHistoryHelper.generateSemanticHash(
        'What is the dua for traveling?',
      );
      final hash3 = QueryHistoryHelper.generateSemanticHash(
        'How to pray for travel?',
      );

      expect(hash1, isNotEmpty);
      expect(hash1, equals(hash2)); // Same query should have same hash
      expect(
        hash1,
        isNot(equals(hash3)),
      ); // Different queries should have different hashes
    });
  });
}
