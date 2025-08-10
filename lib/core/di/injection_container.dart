import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
// import 'package:workmanager/workmanager.dart';  // Disabled for compatibility

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/database_helper.dart';
import '../storage/secure_storage_service.dart';
import '../../data/datasources/rag_remote_datasource.dart';
import '../../data/datasources/rag_api_service.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/repositories/rag_repository_impl.dart';
import '../../data/repositories/audio_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/rag_repository.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/search_rag.dart';
import '../../domain/usecases/get_query_history.dart';
import '../../domain/usecases/save_query_history.dart';
import '../../domain/usecases/download_audio.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';

final sl = GetIt.instance;

Future<void> init() async {
  try {
    // External
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => const FlutterSecureStorage());
    sl.registerLazySingleton(() => Connectivity());
    sl.registerLazySingleton(() => Logger());
    // sl.registerLazySingleton(() => Workmanager());  // Disabled for compatibility

    // Core
    sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(sl()),
    );

    // Database
    final database = await DatabaseHelper.instance.database;
    sl.registerLazySingleton<Database>(() => database);
    sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

    // Data sources
    sl.registerLazySingleton<RagRemoteDataSource>(
      () => RagRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<RagApiService>(
      () => RagApiService(networkInfo: sl(), secureStorage: sl(), logger: sl()),
    );
    sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));

    // Repository
    sl.registerLazySingleton<RagRepository>(
      () => RagRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );
    sl.registerLazySingleton<AudioRepository>(
      () => AudioRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(localDataSource: sl()),
    );

    // Use cases
    sl.registerLazySingleton(() => SearchRag(sl()));
    sl.registerLazySingleton(() => GetQueryHistory(sl()));
    sl.registerLazySingleton(() => SaveQueryHistory(sl()));
    sl.registerLazySingleton(() => DownloadAudio(sl()));
    sl.registerLazySingleton(() => GetFavorites(sl()));
    sl.registerLazySingleton(() => AddFavorite(sl()));
    sl.registerLazySingleton(() => RemoveFavorite(sl()));

    print('Dependency injection initialized successfully');
  } catch (e) {
    print('Error initializing dependency injection: $e');
    rethrow;
  }
}
