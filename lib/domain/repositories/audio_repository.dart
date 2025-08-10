import 'package:dartz/dartz.dart';
import '../entities/audio_download.dart';
import '../../core/error/failures.dart';

abstract class AudioRepository {
  Future<Either<Failure, AudioDownload>> downloadAudio(
    String url,
    String? title,
  );
  Future<Either<Failure, List<AudioDownload>>> getDownloads({
    AudioDownloadStatus? status,
  });
  Future<Either<Failure, void>> pauseDownload(int downloadId);
  Future<Either<Failure, void>> resumeDownload(int downloadId);
  Future<Either<Failure, void>> cancelDownload(int downloadId);
  Future<Either<Failure, void>> deleteDownload(int downloadId);
  Future<Either<Failure, double>> getDownloadProgress(int downloadId);
}
