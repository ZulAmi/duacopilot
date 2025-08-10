import 'package:equatable/equatable.dart';

enum AudioDownloadStatus { pending, downloading, completed, failed, paused }

class AudioDownload extends Equatable {
  final int? id;
  final String url;
  final String? localPath;
  final String? title;
  final int? duration;
  final int? fileSize;
  final AudioDownloadStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double? progress;

  const AudioDownload({
    this.id,
    required this.url,
    this.localPath,
    this.title,
    this.duration,
    this.fileSize,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.progress,
  });

  @override
  List<Object?> get props => [
    id,
    url,
    localPath,
    title,
    duration,
    fileSize,
    status,
    createdAt,
    completedAt,
    progress,
  ];
}
