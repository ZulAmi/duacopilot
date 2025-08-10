import 'package:dartz/dartz.dart';
import '../entities/favorite.dart';
import '../../core/error/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Favorite>>> getFavorites({
    FavoriteType? type,
    int? limit,
    int? offset,
  });
  Future<Either<Failure, void>> addFavorite(Favorite favorite);
  Future<Either<Failure, void>> removeFavorite(int favoriteId);
  Future<Either<Failure, bool>> isFavorite(
    String itemId,
    FavoriteType itemType,
  );
  Future<Either<Failure, void>> clearFavorites();
}
