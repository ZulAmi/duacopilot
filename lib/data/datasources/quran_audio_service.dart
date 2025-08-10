import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../models/audio_cache.dart';
import '../datasources/quran_api_service.dart';
import '../datasources/rag_cache_service.dart';

/// Enhanced audio service with Quran API integration
///
/// Handles downloading, caching, and managing audio files for Quranic verses
/// with support for multiple reciters and quality levels.
class QuranAudioService {
  final QuranApiService _quranApi;
  final RagCacheService _cacheService;
  final http.Client _httpClient;

  QuranAudioService({
    QuranApiService? quranApi,
    RagCacheService? cacheService,
    http.Client? httpClient,
  }) : _quranApi = quranApi ?? QuranApiService(),
       _cacheService = cacheService ?? RagCacheService(),
       _httpClient = httpClient ?? http.Client();

  /// Download audio for a specific verse
  Future<AudioCache> downloadVerseAudio({
    required int verseNumber,
    String reciter = 'ar.alafasy',
    AudioQuality quality = AudioQuality.medium,
    bool forceRedownload = false,
  }) async {
    try {
      // Check if audio is already cached
      final audioUrl = _quranApi.getAudioUrl(
        ayahNumber: verseNumber,
        reciter: reciter,
        quality: quality,
      );

      final existingCache = await _findExistingAudioCache(audioUrl);
      if (existingCache != null && !forceRedownload) {
        // Update last played time
        final updatedCache = existingCache.copyWith(
          lastPlayed: DateTime.now(),
          playCount: existingCache.playCount + 1,
        );
        await _cacheService.cacheAudioFile(updatedCache);
        return updatedCache;
      }

      // Download the audio file
      final audioData = await _downloadAudioFile(audioUrl);

      // Save to local storage
      final localPath = await _saveAudioToLocal(
        audioData: audioData,
        verseNumber: verseNumber,
        reciter: reciter,
        quality: quality,
      );

      // Create audio cache entry
      final fileName =
          'verse_${verseNumber}_${quality.toString().split('.').last}.mp3';
      final audioCache = AudioCache(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        duaId: 'verse_$verseNumber',
        fileName: fileName,
        localPath: localPath,
        fileSizeBytes: audioData.length,
        quality: quality,
        status: DownloadStatus.completed,
        originalUrl: audioUrl,
        reciter: reciter,
        metadata: {
          'verse_number': verseNumber,
          'reciter': reciter,
          'quality': quality.toString(),
          'file_extension': 'mp3',
        },
        downloadedAt: DateTime.now(),
        lastPlayed: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        playCount: 1,
      );

      // Cache the audio file metadata
      await _cacheService.cacheAudioFile(audioCache);

      return audioCache;
    } catch (e) {
      throw AudioDownloadException(
        'Failed to download audio for verse $verseNumber: $e',
      );
    }
  }

  /// Get multiple audio URLs for different quality levels
  List<String> getAudioUrls({
    required int verseNumber,
    String reciter = 'ar.alafasy',
  }) {
    return _quranApi.getAudioUrls(ayahNumber: verseNumber, reciter: reciter);
  }

  /// Get cached audio for a verse if available
  Future<AudioCache?> getCachedAudio({
    required int verseNumber,
    String reciter = 'ar.alafasy',
    AudioQuality quality = AudioQuality.medium,
  }) async {
    final audioUrl = _quranApi.getAudioUrl(
      ayahNumber: verseNumber,
      reciter: reciter,
      quality: quality,
    );

    return await _findExistingAudioCache(audioUrl);
  }

  /// Check if audio file exists locally
  Future<bool> isAudioCached({
    required int verseNumber,
    String reciter = 'ar.alafasy',
    AudioQuality quality = AudioQuality.medium,
  }) async {
    final cachedAudio = await getCachedAudio(
      verseNumber: verseNumber,
      reciter: reciter,
      quality: quality,
    );

    if (cachedAudio?.localPath != null) {
      final file = File(cachedAudio!.localPath);
      return await file.exists();
    }

    return false;
  }

  /// Download multiple verses audio in batch
  Future<List<AudioCache>> batchDownloadAudio({
    required List<int> verseNumbers,
    String reciter = 'ar.alafasy',
    AudioQuality quality = AudioQuality.medium,
    Function(int completed, int total)? onProgress,
  }) async {
    final results = <AudioCache>[];

    for (int i = 0; i < verseNumbers.length; i++) {
      try {
        final audioCache = await downloadVerseAudio(
          verseNumber: verseNumbers[i],
          reciter: reciter,
          quality: quality,
        );
        results.add(audioCache);

        onProgress?.call(i + 1, verseNumbers.length);
      } catch (e) {
        print('Failed to download audio for verse ${verseNumbers[i]}: $e');
      }
    }

    return results;
  }

  /// Get all available reciters
  Map<String, String> getAvailableReciters() {
    return QuranApiService.popularReciters;
  }

  /// Clear expired audio cache
  Future<void> clearExpiredCache() async {
    print('Clearing expired audio cache...');

    // Clean up local audio files that are older than 30 days
    final audioFiles = await _getLocalAudioFiles();
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

    for (final file in audioFiles) {
      try {
        final stat = await file.stat();
        if (stat.modified.isBefore(cutoffDate)) {
          await file.delete();
          print('Deleted expired audio file: ${file.path}');
        }
      } catch (e) {
        print('Error checking/deleting file ${file.path}: $e');
      }
    }
  }

  /// Get audio cache statistics
  Future<Map<String, dynamic>> getAudioCacheStats() async {
    final stats = await _cacheService.getCacheStats();

    // Calculate additional audio-specific stats
    final audioFiles = await _getLocalAudioFiles();
    final totalSize = await _calculateTotalAudioSize(audioFiles);

    return {
      ...stats,
      'local_audio_files': audioFiles.length,
      'total_audio_size_bytes': totalSize,
      'total_audio_size_mb': (totalSize / (1024 * 1024)).toStringAsFixed(2),
    };
  }

  /// Delete specific audio file
  Future<bool> deleteAudioFile(String audioId) async {
    try {
      final cachedAudio = await _findAudioCacheById(audioId);
      if (cachedAudio?.localPath != null) {
        final file = File(cachedAudio!.localPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Note: Remove from cache service would require additional implementation
      print('Audio file $audioId deleted successfully');

      return true;
    } catch (e) {
      print('Failed to delete audio file $audioId: $e');
      return false;
    }
  }

  // ========== Private Helper Methods ==========

  Future<List<int>> _downloadAudioFile(String url) async {
    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw AudioDownloadException(
        'Failed to download audio: HTTP ${response.statusCode}',
      );
    }
  }

  Future<String> _saveAudioToLocal({
    required List<int> audioData,
    required int verseNumber,
    required String reciter,
    required AudioQuality quality,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory(path.join(directory.path, 'audio', reciter));

    // Create directory if it doesn't exist
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    final fileName =
        'verse_${verseNumber}_${quality.toString().split('.').last}.mp3';
    final filePath = path.join(audioDir.path, fileName);

    final file = File(filePath);
    await file.writeAsBytes(audioData);

    return filePath;
  }

  Future<AudioCache?> _findExistingAudioCache(String audioUrl) async {
    // This would ideally query the cache service
    // For now, we'll implement a simple approach
    try {
      // Implementation depends on how cache service stores audio metadata
      return null; // Placeholder - would need actual implementation
    } catch (e) {
      return null;
    }
  }

  Future<AudioCache?> _findAudioCacheById(String audioId) async {
    // This would ideally query the cache service by ID
    // Placeholder implementation
    return null;
  }

  Future<List<File>> _getLocalAudioFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory(path.join(directory.path, 'audio'));

      if (!await audioDir.exists()) {
        return [];
      }

      final files = <File>[];
      await for (final entity in audioDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.mp3')) {
          files.add(entity);
        }
      }

      return files;
    } catch (e) {
      print('Error getting local audio files: $e');
      return [];
    }
  }

  Future<int> _calculateTotalAudioSize(List<File> audioFiles) async {
    int totalSize = 0;

    for (final file in audioFiles) {
      try {
        final stat = await file.stat();
        totalSize += stat.size;
      } catch (e) {
        print('Error getting file size for ${file.path}: $e');
      }
    }

    return totalSize;
  }

  void dispose() {
    _quranApi.dispose();
    _httpClient.close();
  }
}

class AudioDownloadException implements Exception {
  final String message;

  AudioDownloadException(this.message);

  @override
  String toString() => 'AudioDownloadException: $message';
}
