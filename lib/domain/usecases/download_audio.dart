import 'package:dartz/dartz.dart';
import '../entities/audio_download.dart';
import '../repositories/audio_repository.dart';
import '../../core/error/failures.dart';

class DownloadAudio {
  final AudioRepository repository;

  DownloadAudio(this.repository);

  Future<Either<Failure, AudioDownload>> call(
    String url, {
    String? title,
  }) async {
    if (url.trim().isEmpty) {
      return const Left(ValidationFailure('URL cannot be empty'));
    }

    return await repository.downloadAudio(url.trim(), title);
  }
}
