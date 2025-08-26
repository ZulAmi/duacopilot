import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/rag_api_client.dart';
import '../../core/services/query_enhancement/query_enhancement_service.dart';
import '../../services/rag_service.dart';

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

/// Provider for RAG service with proper dependencies
final ragServiceProvider = Provider<RagService>((ref) {
  final apiClient = ref.watch(ragApiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return RagService(apiClient, prefs);
});

/// Example of how to configure providers in main.dart:
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
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
