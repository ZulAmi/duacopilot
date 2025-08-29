import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection_container.dart' as di;
import '../../core/network/rag_api_client.dart';
import '../../core/services/query_enhancement/query_enhancement_service.dart';
import '../../domain/repositories/rag_repository.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences provider not initialized. Call ProviderScope.overrideWith in main.dart',
  );
});

/// Provider for RAG API client
final ragApiClientProvider = Provider<RagApiClient>((ref) {
  return RagApiClient();
});

/// Provider for Query Enhancement Service
final queryEnhancementServiceProvider = Provider<QueryEnhancementService>((
  ref,
) {
  return QueryEnhancementService();
});

/// Provider for RAG repository with proper dependencies
final ragRepositoryProvider = Provider<RagRepository>((ref) {
  // Use the dependency injection container to get the properly configured repository
  return di.sl<RagRepository>();
});

/// Example of how to configure providers in main.dart:
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize dependency injection container
///   await di.init();
///
///   final sharedPreferences = await SharedPreferences.getInstance();
///
///   runApp(
///     ProviderScope(
///       overrides: [
///         sharedPreferencesProvider.overrideWithValue(sharedPreferences),
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
