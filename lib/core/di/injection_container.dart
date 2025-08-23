import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Temporarily disabled
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/datasources/local_datasource.dart';
import '../../data/datasources/mock_local_datasource.dart'; // Add mock local datasource
import '../../data/datasources/rag_api_service.dart'; // Re-enabled with mock secure storage
import '../../data/datasources/rag_remote_datasource.dart';
import '../../data/repositories/audio_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/rag_repository_impl.dart';
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

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/database_helper.dart';
import '../storage/secure_storage_service.dart'; // Re-enabled with mock implementation

final sl = GetIt.instance;

Future<void> init() async {
  try {
    AppLogger.debug('🔧 Initializing DuaCopilot services...');

    // External dependencies
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => Connectivity());
    sl.registerLazySingleton(() => Logger());

    // Core services
    sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    // Secure storage (mock implementation for development)
    sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

    // Database initialization with platform awareness
    if (kIsWeb) {
      AppLogger.debug('🌐 Web platform detected - using memory-based storage');
      // For web, register mock local data source directly (no database needed)
      try {
        sl.registerLazySingleton<LocalDataSource>(() => MockLocalDataSource());
        AppLogger.debug('✅ Mock local data source initialized for web');
      } catch (e) {
        AppLogger.debug('⚠️  Mock local data source initialization failed: $e');
      }
    } else {
      try {
        final database = await DatabaseHelper.instance.database;
        sl.registerLazySingleton<Database>(() => database);
        sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

        // Register real local data source for desktop/mobile
        sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
        AppLogger.debug('✅ Database and local data source initialized successfully');
      } catch (e) {
        AppLogger.debug('⚠️  Database initialization failed: $e');
        // Fallback to mock implementation
        try {
          sl.registerLazySingleton<LocalDataSource>(() => MockLocalDataSource());
          AppLogger.debug('✅ Fallback to mock local data source');
        } catch (mockError) {
          AppLogger.debug('❌ Mock local data source fallback failed: $mockError');
        }
      }
    }

    // Data sources
    try {
      sl.registerLazySingleton<RagRemoteDataSource>(() => RagRemoteDataSourceImpl(sl()));
      sl.registerLazySingleton<RagApiService>(
        () => RagApiService(networkInfo: sl(), secureStorage: sl(), logger: sl()),
      );

      AppLogger.debug('✅ Remote data sources initialized');
    } catch (e) {
      AppLogger.debug('⚠️  Data source initialization error: $e');
    }

    // Repositories
    try {
      sl.registerLazySingleton<RagRepository>(
        () => RagRepositoryImpl(
          remoteDataSource: sl(),
          localDataSource: sl.isRegistered<LocalDataSource>() ? sl() : null,
          networkInfo: sl(),
        ),
      );

      if (sl.isRegistered<LocalDataSource>()) {
        sl.registerLazySingleton<AudioRepository>(() => AudioRepositoryImpl(localDataSource: sl(), networkInfo: sl()));
        sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(localDataSource: sl()));
      }
      AppLogger.debug('✅ Repositories initialized');
    } catch (e) {
      AppLogger.debug('⚠️  Repository initialization error: $e');
    }

    // Use cases
    try {
      sl.registerLazySingleton(() => SearchRag(sl()));

      if (sl.isRegistered<LocalDataSource>()) {
        sl.registerLazySingleton(() => GetQueryHistory(sl()));
        sl.registerLazySingleton(() => SaveQueryHistory(sl()));
        sl.registerLazySingleton(() => DownloadAudio(sl()));
        sl.registerLazySingleton(() => GetFavorites(sl()));
        sl.registerLazySingleton(() => AddFavorite(sl()));
        sl.registerLazySingleton(() => RemoveFavorite(sl()));
      }
      AppLogger.debug('✅ Use cases initialized');
    } catch (e) {
      AppLogger.debug('⚠️  Use case initialization error: $e');
    }

    AppLogger.debug('✅ Dependency injection initialization completed');
  } catch (e) {
    AppLogger.debug('❌ Critical dependency injection error: $e');
    rethrow;
  }
}
