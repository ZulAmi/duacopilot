import 'package:dartz/dartz.dart';
import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';
import '../../core/error/failures.dart';

/// GetFavorites class implementation
class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<Favorite>>> call({
    FavoriteType? type,
    int? limit,
    int? offset,
  }) async {
    return await repository.getFavorites(
      type: type,
      limit: limit,
      offset: offset,
    );
  }
}
