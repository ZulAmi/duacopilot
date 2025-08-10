import 'package:dartz/dartz.dart';
import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';
import '../../core/error/failures.dart';

class AddFavorite {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  Future<Either<Failure, void>> call(Favorite favorite) async {
    return await repository.addFavorite(favorite);
  }
}
