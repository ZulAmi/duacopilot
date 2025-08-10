import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/audio_download.dart';
import '../../domain/usecases/download_audio.dart';
import '../../core/di/injection_container.dart' as di;

// Audio state
class AudioState {
  final bool isLoading;
  final List<AudioDownload> downloads;
  final String? error;

  const AudioState({
    this.isLoading = false,
    this.downloads = const [],
    this.error,
  });

  AudioState copyWith({
    bool? isLoading,
    List<AudioDownload>? downloads,
    String? error,
  }) {
    return AudioState(
      isLoading: isLoading ?? this.isLoading,
      downloads: downloads ?? this.downloads,
      error: error ?? this.error,
    );
  }
}

// Audio provider
class AudioNotifier extends StateNotifier<AudioState> {
  final DownloadAudio downloadAudio;

  AudioNotifier(this.downloadAudio) : super(const AudioState());

  Future<void> startDownload(String url, {String? title}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await downloadAudio(url, title: title);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.toString());
      },
      (download) {
        final updatedDownloads = [...state.downloads, download];
        state = state.copyWith(
          isLoading: false,
          downloads: updatedDownloads,
          error: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void updateDownloadProgress(int downloadId, double progress) {
    final updatedDownloads =
        state.downloads.map((download) {
          if (download.id == downloadId) {
            return AudioDownload(
              id: download.id,
              url: download.url,
              localPath: download.localPath,
              title: download.title,
              duration: download.duration,
              fileSize: download.fileSize,
              status: download.status,
              createdAt: download.createdAt,
              completedAt: download.completedAt,
              progress: progress,
            );
          }
          return download;
        }).toList();

    state = state.copyWith(downloads: updatedDownloads);
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier(di.sl<DownloadAudio>());
});

// Active downloads provider
final activeDownloadsProvider = Provider<List<AudioDownload>>((ref) {
  final audioState = ref.watch(audioProvider);
  return audioState.downloads
      .where(
        (download) =>
            download.status == AudioDownloadStatus.downloading ||
            download.status == AudioDownloadStatus.pending,
      )
      .toList();
});

// Completed downloads provider
final completedDownloadsProvider = Provider<List<AudioDownload>>((ref) {
  final audioState = ref.watch(audioProvider);
  return audioState.downloads
      .where((download) => download.status == AudioDownloadStatus.completed)
      .toList();
});
