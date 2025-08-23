import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../core/di/injection_container.dart' as di;

// Favorites state
/// FavoritesState class implementation
class FavoritesState {
  final bool isLoading;
  final List<Favorite> favorites;
  final String? error;

  const FavoritesState({
    this.isLoading = false,
    this.favorites = const [],
    this.error,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<Favorite>? favorites,
    String? error,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      error: error ?? this.error,
    );
  }
}

// Favorites provider
/// FavoritesNotifier class implementation
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  FavoritesNotifier(this.getFavorites, this.addFavorite, this.removeFavorite)
    : super(const FavoritesState());

  Future<void> loadFavorites({FavoriteType? type}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getFavorites(type: type);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.toString());
      },
      (favorites) {
        state = state.copyWith(
          isLoading: false,
          favorites: favorites,
          error: null,
        );
      },
    );
  }

  Future<void> addToFavorites(Favorite favorite) async {
    final result = await addFavorite(favorite);

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.toString());
      },
      (_) {
        final updatedFavorites = [...state.favorites, favorite];
        state = state.copyWith(favorites: updatedFavorites);
      },
    );
  }

  Future<void> removeFromFavorites(int favoriteId) async {
    final result = await removeFavorite(favoriteId);

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.toString());
      },
      (_) {
        final updatedFavorites =
            state.favorites
                .where((favorite) => favorite.id != favoriteId)
                .toList();
        state = state.copyWith(favorites: updatedFavorites);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      return FavoritesNotifier(
        di.sl<GetFavorites>(),
        di.sl<AddFavorite>(),
        di.sl<RemoveFavorite>(),
      );
    });

// Filtered favorites by type
final favoritesByTypeProvider = Provider.family<List<Favorite>, FavoriteType?>((
  ref,
  type,
) {
  final favoritesState = ref.watch(favoritesProvider);

  if (type == null) return favoritesState.favorites;

  return favoritesState.favorites
      .where((favorite) => favorite.itemType == type)
      .toList();
});
