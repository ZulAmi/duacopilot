import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/rag_response.dart';
import '../../domain/entities/query_history.dart';
import '../../domain/usecases/search_rag.dart';
import '../../domain/usecases/get_query_history.dart';
import '../../domain/usecases/save_query_history.dart';
import '../../core/di/injection_container.dart' as di;

// Search state
/// SearchState class implementation
class SearchState {
  final bool isLoading;
  final RagResponse? response;
  final String? error;
  final String? currentQuery;

  const SearchState({
    this.isLoading = false,
    this.response,
    this.error,
    this.currentQuery,
  });

  SearchState copyWith({
    bool? isLoading,
    RagResponse? response,
    String? error,
    String? currentQuery,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}

// Search provider
/// SearchNotifier class implementation
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRag searchRag;
  final SaveQueryHistory saveQueryHistory;

  SearchNotifier(this.searchRag, this.saveQueryHistory)
    : super(const SearchState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null, currentQuery: query);

    final result = await searchRag(query);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.toString());
      },
      (response) {
        state = state.copyWith(
          isLoading: false,
          response: response,
          error: null,
        );

        // Save to history
        _saveToHistory(query, response.response, response.responseTime, true);
      },
    );
  }

  Future<void> _saveToHistory(
    String query,
    String response,
    int responseTime,
    bool success,
  ) async {
    final queryHistory = QueryHistory(
      query: query,
      response: response,
      timestamp: DateTime.now(),
      responseTime: responseTime,
      success: success,
    );

    await saveQueryHistory(queryHistory);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearResponse() {
    state = state.copyWith(response: null, currentQuery: null);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(di.sl<SearchRag>(), di.sl<SaveQueryHistory>());
});

// Query history provider
final queryHistoryProvider = FutureProvider<List<QueryHistory>>((ref) async {
  final getQueryHistory = di.sl<GetQueryHistory>();
  final result = await getQueryHistory();

  return result.fold((failure) => throw failure, (history) => history);
});

// Filtered query history provider
final filteredQueryHistoryProvider =
    Provider.family<List<QueryHistory>, String>((ref, filter) {
      final asyncHistory = ref.watch(queryHistoryProvider);

      return asyncHistory.when(
        data: (history) {
          if (filter.isEmpty) return history;
          return history
              .where(
                (query) =>
                    query.query.toLowerCase().contains(filter.toLowerCase()) ||
                    (query.response?.toLowerCase().contains(
                          filter.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
        },
        loading: () => [],
        error: (_, __) => [],
      );
    });
