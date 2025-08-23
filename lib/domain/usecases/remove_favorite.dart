import 'package:dartz/dartz.dart';
import '../repositories/favorites_repository.dart';
import '../../core/error/failures.dart';

/// RemoveFavorite class implementation
class RemoveFavorite {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Failure, void>> call(int favoriteId) async {
    return await repository.removeFavorite(favoriteId);
  }
}
