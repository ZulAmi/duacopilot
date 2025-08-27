import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/offline/offline_search_models.dart';
import '../rag_service.dart';
import 'fallback_template_service.dart';
import 'local_embedding_service.dart';
import 'local_vector_storage_service.dart';
import 'offline_semantic_search_service.dart';
import 'query_queue_service.dart';

/// Service for initializing and managing offline search capabilities
class OfflineSearchInitializationService {
  static const String _isInitializedKey = 'offline_search_initialized';
  static const String _lastSyncKey = 'offline_search_last_sync';

  static OfflineSemanticSearchService? _offlineSearchService;
  static bool _isInitialized = false;

  /// Initialize all offline search services
  static Future<void> initializeOfflineSearch() async {
    if (_isInitialized) {
      print('Offline search already initialized');
      return;
    }

    try {
      print('Initializing offline search services...');

      final prefs = await SharedPreferences.getInstance();
      final connectivity = Connectivity();

      // Initialize services
      final embeddingService = LocalEmbeddingService();
      final storageService = LocalVectorStorageService();
      final templateService = FallbackTemplateService(storageService);

      // Get existing RAG service from DI container
      final ragService = GetIt.instance<RagService>();

      final queueService = QueryQueueService(prefs, ragService, connectivity);

      // Create main offline search service
      _offlineSearchService = OfflineSemanticSearchService(
        embeddingService: embeddingService,
        storageService: storageService,
        queueService: queueService,
        templateService: templateService,
        ragService: ragService,
        connectivity: connectivity,
        prefs: prefs,
      );

      // Initialize the service
      await _offlineSearchService!.initialize();

      // Register in DI container
      GetIt.instance.registerSingleton<OfflineSemanticSearchService>(
        _offlineSearchService!,
      );

      // Mark as initialized
      await prefs.setBool(_isInitializedKey, true);
      _isInitialized = true;

      print('Offline search services initialized successfully');

      // Perform initial sync if needed
      await _performInitialSyncIfNeeded(prefs);
    } catch (e) {
      print('Failed to initialize offline search: $e');
      _isInitialized = false;
    }
  }

  /// Get the offline search service instance
  static OfflineSemanticSearchService? get offlineSearchService =>
      _offlineSearchService;

  /// Check if offline search is initialized
  static bool get isInitialized => _isInitialized;

  /// Populate initial embeddings for common Du'as
  static Future<void> populateInitialEmbeddings() async {
    if (!_isInitialized || _offlineSearchService == null) {
      throw Exception('Offline search not initialized');
    }

    try {
      print('Populating initial embeddings...');

      // Sample Du'a data for initial population
      final initialDuas = _getInitialDuaData();

      // Create a new storage service instance for initialization
      final storageService = LocalVectorStorageService();
      await storageService.initialize();

      // Check if embeddings already exist
      final existingEmbeddings = await storageService.getAllEmbeddings();
      if (existingEmbeddings.isNotEmpty) {
        print('Embeddings already exist (${existingEmbeddings.length} items)');
        return;
      }

      // Generate embeddings for initial data
      final embeddingService = LocalEmbeddingService();
      if (!embeddingService.isReady) {
        await embeddingService.initialize();
      }

      final embeddings = <DuaEmbedding>[];

      for (int i = 0; i < initialDuas.length; i++) {
        final dua = initialDuas[i];

        try {
          final embedding = await embeddingService.generateEmbedding(
            dua['text'] as String,
          );

          final duaEmbedding = DuaEmbedding(
            id: 'initial_${dua['id']}',
            duaId: dua['id'] as String,
            text: dua['text'] as String,
            language: dua['language'] as String,
            vector: embedding,
            category: dua['category'] as String,
            keywords: List<String>.from(dua['keywords'] as List),
            metadata: {
              'translation': dua['translation'] as String,
              'transliteration': dua['transliteration'] as String? ?? '',
              'source': 'initial_data',
              'created_at': DateTime.now().toIso8601String(),
            },
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          embeddings.add(duaEmbedding);

          // Show progress
          if ((i + 1) % 10 == 0) {
            print('Processed ${i + 1}/${initialDuas.length} embeddings');
          }
        } catch (e) {
          print('Error processing embedding for ${dua['id']}: $e');
        }
      }

      // Store all embeddings
      if (embeddings.isNotEmpty) {
        await storageService.storeBatchEmbeddings(embeddings);
        print('Stored ${embeddings.length} initial embeddings');
      }

      // Update sync timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('Error populating initial embeddings: $e');
    }
  }

  /// Reset offline search data
  static Future<void> resetOfflineData() async {
    if (_offlineSearchService != null) {
      await _offlineSearchService!.clearOfflineData();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isInitializedKey);
    await prefs.remove(_lastSyncKey);

    _isInitialized = false;
    print('Offline search data reset');
  }

  // Private helper methods

  static Future<void> _performInitialSyncIfNeeded(
    SharedPreferences prefs,
  ) async {
    final lastSync = prefs.getString(_lastSyncKey);

    if (lastSync == null) {
      // First time setup - populate initial data
      await populateInitialEmbeddings();
    } else {
      final lastSyncTime = DateTime.parse(lastSync);
      final daysSinceSync = DateTime.now().difference(lastSyncTime).inDays;

      if (daysSinceSync > 7) {
        // Sync with remote if more than 7 days
        await _offlineSearchService?.syncWithRemote();
      }
    }
  }

  static List<Map<String, dynamic>> _getInitialDuaData() {
    // Sample Du'a data for initial setup
    return [
      {
        'id': 'morning_adhkar_1',
        'text':
            'Ø§Ù„Ù„Ù‡Ù… Ø¨Ùƒ Ø£ØµØ¨Ø­Ù†Ø§ ÙˆØ¨Ùƒ Ø£Ù…Ø³ÙŠÙ†Ø§ ÙˆØ¨Ùƒ Ù†Ø­ÙŠØ§ ÙˆØ¨Ùƒ Ù†Ù…ÙˆØª ÙˆØ¥Ù„ÙŠÙƒ Ø§Ù„Ù†Ø´ÙˆØ±',
        'translation':
            'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
        'transliteration':
            'Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilayka an-nushur',
        'language': 'ar',
        'category': 'morning',
        'keywords': [
          'ØµØ¨Ø§Ø­',
          'morning',
          'Ø£ØµØ¨Ø­Ù†Ø§',
          'awakening',
          'protection'
        ],
      },
      {
        'id': 'morning_adhkar_1_en',
        'text':
            'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
        'translation':
            'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
        'transliteration':
            'Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilayka an-nushur',
        'language': 'en',
        'category': 'morning',
        'keywords': [
          'morning',
          'dawn',
          'awakening',
          'protection',
          'start',
          'day',
        ],
      },
      {
        'id': 'istighfar_1',
        'text':
            'Ø£Ø³ØªØºÙØ± Ø§Ù„Ù„Ù‡ Ø§Ù„Ø°ÙŠ Ù„Ø§ Ø¥Ù„Ù‡ Ø¥Ù„Ø§ Ù‡Ùˆ Ø§Ù„Ø­ÙŠ Ø§Ù„Ù‚ÙŠÙˆÙ… ÙˆØ£ØªÙˆØ¨ Ø¥Ù„ÙŠÙ‡',
        'translation':
            'I seek forgiveness from Allah, there is no god but Him, the Living, the Eternal, and I repent to Him.',
        'transliteration':
            'Astaghfir Allah al-ladhi la ilaha illa huwa al-hayy al-qayyum wa atubu ilayh',
        'language': 'ar',
        'category': 'forgiveness',
        'keywords': [
          'Ø§Ø³ØªØºÙØ§Ø±',
          'forgiveness',
          'repentance',
          'mercy',
          'ØªÙˆØ¨Ø©'
        ],
      },
      {
        'id': 'istighfar_1_en',
        'text':
            'I seek forgiveness from Allah, there is no god but Him, the Living, the Eternal, and I repent to Him.',
        'translation':
            'I seek forgiveness from Allah, there is no god but Him, the Living, the Eternal, and I repent to Him.',
        'transliteration':
            'Astaghfir Allah al-ladhi la ilaha illa huwa al-hayy al-qayyum wa atubu ilayh',
        'language': 'en',
        'category': 'forgiveness',
        'keywords': ['forgiveness', 'repentance', 'mercy', 'seeking', 'pardon'],
      },
      {
        'id': 'travel_dua_1',
        'text':
            'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ØŒ ØªÙˆÙƒÙ„Øª Ø¹Ù„Ù‰ Ø§Ù„Ù„Ù‡ØŒ Ù„Ø§ Ø­ÙˆÙ„ ÙˆÙ„Ø§ Ù‚ÙˆØ© Ø¥Ù„Ø§ Ø¨Ø§Ù„Ù„Ù‡',
        'translation':
            'In the name of Allah, I place my trust in Allah, there is no power except with Allah.',
        'transliteration':
            'Bismillah, tawakkaltu ala Allah, la hawla wa la quwwata illa billah',
        'language': 'ar',
        'category': 'travel',
        'keywords': [
          'Ø³ÙØ±',
          'travel',
          'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡',
          'protection',
          'ØªÙˆÙƒÙ„'
        ],
      },
      {
        'id': 'travel_dua_1_en',
        'text':
            'In the name of Allah, I place my trust in Allah, there is no power except with Allah.',
        'translation':
            'In the name of Allah, I place my trust in Allah, there is no power except with Allah.',
        'transliteration':
            'Bismillah, tawakkaltu ala Allah, la hawla wa la quwwata illa billah',
        'language': 'en',
        'category': 'travel',
        'keywords': ['travel', 'journey', 'trust', 'protection', 'bismillah'],
      },
      {
        'id': 'before_food_1',
        'text': 'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡',
        'translation': 'In the name of Allah',
        'transliteration': 'Bismillah',
        'language': 'ar',
        'category': 'food',
        'keywords': [
          'Ø·Ø¹Ø§Ù…',
          'food',
          'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡',
          'eating',
          'blessing'
        ],
      },
      {
        'id': 'before_food_1_en',
        'text': 'In the name of Allah',
        'translation': 'In the name of Allah',
        'transliteration': 'Bismillah',
        'language': 'en',
        'category': 'food',
        'keywords': ['food', 'eating', 'meal', 'blessing', 'bismillah'],
      },
      {
        'id': 'after_food_1',
        'text':
            'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡ Ø§Ù„Ø°ÙŠ Ø£Ø·Ø¹Ù…Ù†ÙŠ Ù‡Ø°Ø§ ÙˆØ±Ø²Ù‚Ù†ÙŠÙ‡ Ù…Ù† ØºÙŠØ± Ø­ÙˆÙ„ Ù…Ù†ÙŠ ÙˆÙ„Ø§ Ù‚ÙˆØ©',
        'translation':
            'All praise is due to Allah who fed me this and provided it for me without any strength or power on my part.',
        'transliteration':
            'Alhamdulillahi alladhi at\'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah',
        'language': 'ar',
        'category': 'food',
        'keywords': [
          'Ø·Ø¹Ø§Ù…',
          'food',
          'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡',
          'gratitude',
          'thanks'
        ],
      },
      {
        'id': 'after_food_1_en',
        'text':
            'All praise is due to Allah who fed me this and provided it for me without any strength or power on my part.',
        'translation':
            'All praise is due to Allah who fed me this and provided it for me without any strength or power on my part.',
        'transliteration':
            'Alhamdulillahi alladhi at\'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah',
        'language': 'en',
        'category': 'food',
        'keywords': ['food', 'gratitude', 'thanks', 'meal', 'praise'],
      },
      {
        'id': 'sleep_dua_1',
        'text': 'Ø§Ù„Ù„Ù‡Ù… Ø¨Ø§Ø³Ù…Ùƒ Ø£Ù…ÙˆØª ÙˆØ£Ø­ÙŠØ§',
        'translation': 'O Allah, in Your name I die and I live.',
        'transliteration': 'Allahumma bismika amutu wa ahya',
        'language': 'ar',
        'category': 'sleep',
        'keywords': ['Ù†ÙˆÙ…', 'sleep', 'Ø±Ø§Ø­Ø©', 'rest', 'protection'],
      },
      {
        'id': 'sleep_dua_1_en',
        'text': 'O Allah, in Your name I die and I live.',
        'translation': 'O Allah, in Your name I die and I live.',
        'transliteration': 'Allahumma bismika amutu wa ahya',
        'language': 'en',
        'category': 'sleep',
        'keywords': ['sleep', 'rest', 'night', 'protection', 'bedtime'],
      },
      {
        'id': 'general_dua_1',
        'text':
            'Ø±Ø¨Ù†Ø§ Ø¢ØªÙ†Ø§ ÙÙŠ Ø§Ù„Ø¯Ù†ÙŠØ§ Ø­Ø³Ù†Ø© ÙˆÙÙŠ Ø§Ù„Ø¢Ø®Ø±Ø© Ø­Ø³Ù†Ø© ÙˆÙ‚Ù†Ø§ Ø¹Ø°Ø§Ø¨ Ø§Ù„Ù†Ø§Ø±',
        'translation':
            'Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire.',
        'transliteration':
            'Rabbana atina fi\'d-dunya hasanatan wa fi\'l-akhirati hasanatan wa qina \'adhab an-nar',
        'language': 'ar',
        'category': 'general',
        'keywords': ['Ø¹Ø§Ù…', 'general', 'Ø¯Ø¹Ø§Ø¡', 'prayer', 'Ø®ÙŠØ±'],
      },
      {
        'id': 'general_dua_1_en',
        'text':
            'Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire.',
        'translation':
            'Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire.',
        'transliteration':
            'Rabbana atina fi\'d-dunya hasanatan wa fi\'l-akhirati hasanatan wa qina \'adhab an-nar',
        'language': 'en',
        'category': 'general',
        'keywords': ['general', 'prayer', 'good', 'blessing', 'comprehensive'],
      },
      {
        'id': 'guidance_dua_1',
        'text': 'Ø§Ù„Ù„Ù‡Ù… Ø§Ù‡Ø¯Ù†ÙŠ ÙÙŠÙ…Ù† Ù‡Ø¯ÙŠØª',
        'translation': 'O Allah, guide me among those You have guided.',
        'transliteration': 'Allahumma ahdini fiman hadayt',
        'language': 'ar',
        'category': 'guidance',
        'keywords': [
          'Ù‡Ø¯Ø§ÙŠØ©',
          'guidance',
          'Ø§Ù‡Ø¯Ù†ÙŠ',
          'direction',
          'path'
        ],
      },
      {
        'id': 'guidance_dua_1_en',
        'text': 'O Allah, guide me among those You have guided.',
        'translation': 'O Allah, guide me among those You have guided.',
        'transliteration': 'Allahumma ahdini fiman hadayt',
        'language': 'en',
        'category': 'guidance',
        'keywords': ['guidance', 'direction', 'path', 'help', 'wisdom'],
      },
    ];
  }
}
