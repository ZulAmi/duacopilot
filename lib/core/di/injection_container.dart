import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Temporarily disabled
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/datasources/islamic_rag_service.dart'; // Islamic knowledge retrieval
import '../../data/datasources/local_datasource.dart';
import '../../data/datasources/mock_local_datasource.dart'; // Add mock local datasource
import '../../data/datasources/quran_api_service.dart'; // Quran API integration
import '../../data/datasources/quran_vector_index.dart'; // Local vector database
import '../../data/datasources/rag_remote_datasource.dart';
import '../../data/repositories/audio_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/unified_rag_repository_impl.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/rag_repository.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/download_audio.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/get_query_history.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/save_query_history.dart';
import '../../domain/usecases/search_rag.dart';
// import 'package:workmanager/workmanager.dart';  // Disabled for compatibility

// Revolutionary AI Services
import '../../services/ai/conversational_memory_service.dart';
import '../../services/ai/interactive_learning_companion_service.dart';
import '../../services/ai/islamic_personality_service.dart';
import '../../services/ai/proactive_spiritual_companion_service.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/voice/enhanced_voice_service.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/database_helper.dart';
import '../storage/secure_storage_service.dart'; // Re-enabled with mock implementation

final sl = GetIt.instance;

Future<void> init() async {
  try {
    AppLogger.debug('ðŸ”§ Initializing DuaCopilot services...');

    // External dependencies
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => Connectivity());
    sl.registerLazySingleton(() => Logger());

    // Core services
    sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    // Secure storage (mock implementation for development)
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(),
    );

    // Database initialization with platform awareness
    if (kIsWeb) {
      AppLogger.debug('ðŸŒ Web platform detected - using memory-based storage');
      // For web, register mock local data source directly (no database needed)
      try {
        sl.registerLazySingleton<LocalDataSource>(() => MockLocalDataSource());
        AppLogger.debug('âœ… Mock local data source initialized for web');
      } catch (e) {
        AppLogger.debug('âš ï¸  Mock local data source initialization failed: $e');
      }
    } else {
      try {
        final database = await DatabaseHelper.instance.database;
        sl.registerLazySingleton<Database>(() => database);
        sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

        // Register real local data source for desktop/mobile
        sl.registerLazySingleton<LocalDataSource>(
          () => LocalDataSourceImpl(sl()),
        );
        AppLogger.debug(
          'âœ… Database and local data source initialized successfully',
        );
      } catch (e) {
        AppLogger.debug('âš ï¸  Database initialization failed: $e');
        // Fallback to mock implementation
        try {
          sl.registerLazySingleton<LocalDataSource>(
            () => MockLocalDataSource(),
          );
          AppLogger.debug('âœ… Fallback to mock local data source');
        } catch (mockError) {
          AppLogger.debug(
            'âŒ Mock local data source fallback failed: $mockError',
          );
        }
      }
    }

    // Data sources
    try {
      sl.registerLazySingleton<RagRemoteDataSource>(
        () => RagRemoteDataSourceImpl(sl<Dio>()),
      );

      // Islamic services for TRUE RAG
      sl.registerLazySingleton<QuranApiService>(() => QuranApiService());

      // Local Vector Database for fast retrieval
      sl.registerLazySingleton<QuranVectorIndex>(() => QuranVectorIndex.instance);

      // Initialize vector index asynchronously for fast startup
      sl<QuranVectorIndex>().initialize().catchError((e) {
        AppLogger.debug('⚠️ Vector index initialization failed: $e');
      });

      sl.registerLazySingleton<IslamicRagService>(
        () => IslamicRagService(
          quranApi: sl<QuranApiService>(),
        ),
      );

      AppLogger.debug(
        'âœ… Remote data sources and TRUE RAG services initialized',
      );
    } catch (e) {
      AppLogger.debug('âš ï¸  Data source initialization error: $e');
    }

    // Repositories
    try {
      sl.registerLazySingleton<RagRepository>(
        () => UnifiedRagRepositoryImpl(
          localDataSource: sl.isRegistered<LocalDataSource>() ? sl<LocalDataSource>() : MockLocalDataSource(),
          islamicRagService: sl<IslamicRagService>(),
          networkInfo: sl<NetworkInfo>(),
          logger: sl<Logger>(),
        ),
      );

      if (sl.isRegistered<LocalDataSource>()) {
        sl.registerLazySingleton<AudioRepository>(
          () => AudioRepositoryImpl(
            localDataSource: sl<LocalDataSource>(),
            networkInfo: sl<NetworkInfo>(),
          ),
        );
        sl.registerLazySingleton<FavoritesRepository>(
          () => FavoritesRepositoryImpl(localDataSource: sl<LocalDataSource>()),
        );
      }
      AppLogger.debug('âœ… Repositories initialized');
    } catch (e) {
      AppLogger.debug('âš ï¸  Repository initialization error: $e');
    }

    // Use cases
    try {
      sl.registerLazySingleton<SearchRag>(() => SearchRag(sl<RagRepository>()));

      if (sl.isRegistered<LocalDataSource>()) {
        sl.registerLazySingleton<GetQueryHistory>(
          () => GetQueryHistory(sl<RagRepository>()),
        );
        sl.registerLazySingleton<SaveQueryHistory>(
          () => SaveQueryHistory(sl<RagRepository>()),
        );
        sl.registerLazySingleton<DownloadAudio>(
          () => DownloadAudio(sl<AudioRepository>()),
        );
        sl.registerLazySingleton<GetFavorites>(
          () => GetFavorites(sl<FavoritesRepository>()),
        );
        sl.registerLazySingleton<AddFavorite>(
          () => AddFavorite(sl<FavoritesRepository>()),
        );
        sl.registerLazySingleton<RemoveFavorite>(
          () => RemoveFavorite(sl<FavoritesRepository>()),
        );
      }
      AppLogger.debug('âœ… Use cases initialized');
    } catch (e) {
      AppLogger.debug('âš ï¸  Use case initialization error: $e');
    }

    // Revolutionary AI Services - Islamic Spiritual Companion
    try {
      // Notification service for proactive messaging
      sl.registerLazySingleton<NotificationService>(
        () => NotificationService.instance,
      );

      // Core AI services
      sl.registerLazySingleton<IslamicPersonalityService>(
        () => IslamicPersonalityService.instance,
      );
      sl.registerLazySingleton<ConversationalMemoryService>(
        () => ConversationalMemoryService.instance,
      );
      sl.registerLazySingleton<ProactiveSpiritualCompanionService>(
        () => ProactiveSpiritualCompanionService.instance,
      );
      sl.registerLazySingleton<InteractiveLearningCompanionService>(
        () => InteractiveLearningCompanionService.instance,
      );

      // Voice service
      sl.registerLazySingleton<EnhancedVoiceService>(
        () => EnhancedVoiceService.instance,
      );

      AppLogger.debug(
        'âœ… Revolutionary AI Services initialized - Islamic Spiritual Companion ready!',
      );
    } catch (e) {
      AppLogger.debug('âš ï¸  AI Services initialization error: $e');
    }

    AppLogger.debug('âœ… Dependency injection initialization completed');
  } catch (e) {
    AppLogger.debug('âŒ Critical dependency injection error: $e');
    rethrow;
  }
}
