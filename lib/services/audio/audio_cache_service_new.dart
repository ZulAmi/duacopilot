import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../domain/entities/dua_entity.dart';
import '../../domain/entities/audio_entity.dart';

/// AudioCacheService class implementation
class AudioCacheService {
  static const String _cacheDirectory = 'audio_cache';
  static const String _metadataFile = 'cache_metadata.json';
  static const int _maxCacheSize = 500 * 1024 * 1024; // 500MB
  static const int _maxCacheItems = 1000;

  // RAG confidence thresholds for intelligent caching
  static const double _highConfidenceThreshold = 0.8;
  static const double _mediumConfidenceThreshold = 0.6;
  static const double _lowConfidenceThreshold = 0.3;

  late Directory _cacheDir;
  late File _metadataFile_;
  Map<String, AudioCacheItem> _cacheMetadata = {};

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDir = Directory('${appDir.path}/$_cacheDirectory');

      if (!await _cacheDir.exists()) {
        await _cacheDir.create(recursive: true);
      }

      _metadataFile_ = File('${_cacheDir.path}/$_metadataFile');
      await _loadMetadata();

      _isInitialized = true;
      debugPrint('Audio cache service initialized at: ${_cacheDir.path}');
    } catch (e) {
      debugPrint('Failed to initialize audio cache service: $e');
      rethrow;
    }
  }

  Future<void> _loadMetadata() async {
    try {
      if (await _metadataFile_.exists()) {
        final jsonString = await _metadataFile_.readAsString();
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        _cacheMetadata = jsonData.map(
          (key, value) => MapEntry(key, AudioCacheItem.fromJson(value as Map<String, dynamic>)),
        );

        debugPrint('Loaded ${_cacheMetadata.length} cache items');
      }
    } catch (e) {
      debugPrint('Error loading cache metadata: $e');
      _cacheMetadata = {};
    }
  }

  Future<void> _saveMetadata() async {
    try {
      final jsonData = _cacheMetadata.map((key, value) => MapEntry(key, value.toJson()));

      final jsonString = json.encode(jsonData);
      await _metadataFile_.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving cache metadata: $e');
    }
  }

  /// Intelligent pre-caching based on RAG confidence scores
  Future<void> smartPreCache(List<DuaEntity> duas) async {
    await initialize();

    // Sort duas by RAG confidence score (highest first)
    final sortedDuas = List<DuaEntity>.from(duas)
      ..sort((a, b) => b.ragConfidence.score.compareTo(a.ragConfidence.score));

    final preloadTasks = <Future<void>>[];

    for (final dua in sortedDuas) {
      if (dua.audioUrl == null) continue;

      final priority = _calculateCachePriority(dua.ragConfidence.score);

      // Only cache based on confidence thresholds
      if (priority == CachePriority.high ||
          (priority == CachePriority.normal && _hasFreeCacheSpace()) ||
          (priority == CachePriority.low && _hasAmpleCacheSpace())) {
        if (!await isAudioCached(dua.audioUrl!)) {
          final task = _cacheAudioWithPriority(dua, priority);
          preloadTasks.add(task);

          // Limit concurrent downloads
          if (preloadTasks.length >= 3) {
            await Future.wait(preloadTasks);
            preloadTasks.clear();
          }
        }
      }
    }

    // Wait for remaining tasks
    if (preloadTasks.isNotEmpty) {
      await Future.wait(preloadTasks);
    }

    await _cleanupOldCache();
  }

  CachePriority _calculateCachePriority(double ragScore) {
    if (ragScore >= _highConfidenceThreshold) {
      return CachePriority.high;
    } else if (ragScore >= _mediumConfidenceThreshold) {
      return CachePriority.normal;
    } else if (ragScore >= _lowConfidenceThreshold) {
      return CachePriority.low;
    } else {
      return CachePriority.low;
    }
  }

  bool _hasFreeCacheSpace() {
    return _cacheMetadata.length < (_maxCacheItems * 0.7);
  }

  bool _hasAmpleCacheSpace() {
    return _cacheMetadata.length < (_maxCacheItems * 0.5);
  }

  Future<void> _cacheAudioWithPriority(DuaEntity dua, CachePriority priority) async {
    try {
      final audioUrl = dua.audioUrl!;
      final fileName = _generateFileName(audioUrl);
      final filePath = '${_cacheDir.path}/$fileName';

      debugPrint('Caching audio for ${dua.category} (Priority: $priority)');

      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        final checksum = _calculateChecksum(response.bodyBytes);
        final cacheItem = AudioCacheItem(
          trackId: audioUrl,
          localPath: filePath,
          fileSizeBytes: response.bodyBytes.length,
          checksumMd5: checksum,
          cachedAt: DateTime.now(),
          lastAccessed: DateTime.now(),
          accessCount: 0,
          priority: priority,
        );

        _cacheMetadata[audioUrl] = cacheItem;
        await _saveMetadata();

        debugPrint('Successfully cached: $fileName (${_formatFileSize(response.bodyBytes.length)})');
      } else {
        debugPrint('Failed to download audio: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error caching audio for ${dua.category}: $e');
    }
  }

  String _generateFileName(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      final originalName = pathSegments.last;
      final hash = sha256.convert(utf8.encode(url)).toString().substring(0, 8);
      return '${hash}_$originalName';
    }
    return '${sha256.convert(utf8.encode(url)).toString()}.mp3';
  }

  String _calculateChecksum(Uint8List data) {
    return sha256.convert(data).toString();
  }

  Future<bool> isAudioCached(String audioUrl) async {
    await initialize();

    final cacheItem = _cacheMetadata[audioUrl];
    if (cacheItem == null) return false;

    final file = File(cacheItem.localPath);
    final exists = await file.exists();

    if (!exists) {
      // Remove from metadata if file doesn't exist
      _cacheMetadata.remove(audioUrl);
      await _saveMetadata();
      return false;
    }

    // Verify file integrity
    try {
      final fileData = await file.readAsBytes();
      final checksum = _calculateChecksum(fileData);

      if (checksum != cacheItem.checksumMd5) {
        // File is corrupted, remove it
        await file.delete();
        _cacheMetadata.remove(audioUrl);
        await _saveMetadata();
        return false;
      }
    } catch (e) {
      debugPrint('Error verifying cached file: $e');
      return false;
    }

    // Update access info
    final updatedItem = cacheItem.copyWith(lastAccessed: DateTime.now(), accessCount: cacheItem.accessCount + 1);
    _cacheMetadata[audioUrl] = updatedItem;

    return true;
  }

  Future<String?> getCachedAudioPath(String audioUrl) async {
    if (await isAudioCached(audioUrl)) {
      return _cacheMetadata[audioUrl]?.localPath;
    }
    return null;
  }

  Future<void> cacheAudio(String audioUrl, {CachePriority priority = CachePriority.normal}) async {
    await initialize();

    if (await isAudioCached(audioUrl)) {
      debugPrint('Audio already cached: $audioUrl');
      return;
    }

    try {
      final fileName = _generateFileName(audioUrl);
      final filePath = '${_cacheDir.path}/$fileName';

      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        final checksum = _calculateChecksum(response.bodyBytes);
        final cacheItem = AudioCacheItem(
          trackId: audioUrl,
          localPath: filePath,
          fileSizeBytes: response.bodyBytes.length,
          checksumMd5: checksum,
          cachedAt: DateTime.now(),
          lastAccessed: DateTime.now(),
          accessCount: 0,
          priority: priority,
        );

        _cacheMetadata[audioUrl] = cacheItem;
        await _saveMetadata();

        debugPrint('Audio cached successfully: $fileName');
      }
    } catch (e) {
      debugPrint('Error caching audio: $e');
      rethrow;
    }
  }

  Future<void> removeCachedAudio(String audioUrl) async {
    await initialize();

    final cacheItem = _cacheMetadata[audioUrl];
    if (cacheItem != null) {
      try {
        final file = File(cacheItem.localPath);
        if (await file.exists()) {
          await file.delete();
        }

        _cacheMetadata.remove(audioUrl);
        await _saveMetadata();

        debugPrint('Removed cached audio: $audioUrl');
      } catch (e) {
        debugPrint('Error removing cached audio: $e');
      }
    }
  }

  Future<void> _cleanupOldCache() async {
    final itemsToRemove = <String>[];

    // Remove items if cache is too large
    if (_cacheMetadata.length > _maxCacheItems) {
      final sortedItems =
          _cacheMetadata.entries.toList()..sort((a, b) {
            // Sort by priority first, then by last accessed date
            final priorityCompare = a.value.priority.index.compareTo(b.value.priority.index);
            if (priorityCompare != 0) return priorityCompare;

            final aLastAccessed = a.value.lastAccessed ?? DateTime(2000);
            final bLastAccessed = b.value.lastAccessed ?? DateTime(2000);
            return aLastAccessed.compareTo(bLastAccessed);
          });

      final excessCount = _cacheMetadata.length - _maxCacheItems;
      for (int i = 0; i < excessCount; i++) {
        itemsToRemove.add(sortedItems[i].key);
      }
    }

    // Remove cache size overflow
    final totalSize = _cacheMetadata.values.fold<int>(0, (sum, item) => sum + item.fileSizeBytes);
    if (totalSize > _maxCacheSize) {
      final sortedBySize =
          _cacheMetadata.entries.toList()..sort((a, b) {
            final aLastAccessed = a.value.lastAccessed ?? DateTime(2000);
            final bLastAccessed = b.value.lastAccessed ?? DateTime(2000);
            return aLastAccessed.compareTo(bLastAccessed);
          });

      int currentSize = totalSize;
      for (final entry in sortedBySize) {
        if (currentSize <= _maxCacheSize) break;
        if (!itemsToRemove.contains(entry.key)) {
          itemsToRemove.add(entry.key);
          currentSize -= entry.value.fileSizeBytes;
        }
      }
    }

    // Perform cleanup
    for (final audioUrl in itemsToRemove) {
      await removeCachedAudio(audioUrl);
    }

    if (itemsToRemove.isNotEmpty) {
      debugPrint('Cleaned up ${itemsToRemove.length} cache items');
    }
  }

  Future<Map<String, dynamic>> getCacheStats() async {
    await initialize();

    final totalSize = _cacheMetadata.values.fold<int>(0, (sum, item) => sum + item.fileSizeBytes);
    final totalCount = _cacheMetadata.length;

    final priorityStats = <CachePriority, int>{};

    for (final item in _cacheMetadata.values) {
      priorityStats[item.priority] = (priorityStats[item.priority] ?? 0) + 1;
    }

    return {
      'totalSize': totalSize,
      'totalSizeFormatted': _formatFileSize(totalSize),
      'totalCount': totalCount,
      'maxSize': _maxCacheSize,
      'maxSizeFormatted': _formatFileSize(_maxCacheSize),
      'maxCount': _maxCacheItems,
      'utilizationPercent': (totalSize / _maxCacheSize * 100).toInt(),
      'priorityStats': priorityStats.map((k, v) => MapEntry(k.toString(), v)),
      'cacheDirectory': _cacheDir.path,
    };
  }

  Future<void> clearAllCache() async {
    await initialize();

    try {
      if (await _cacheDir.exists()) {
        await _cacheDir.delete(recursive: true);
        await _cacheDir.create(recursive: true);
      }

      _cacheMetadata.clear();
      await _saveMetadata();

      debugPrint('All cache cleared');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  List<AudioCacheItem> getCachedItems() {
    return _cacheMetadata.values.toList()..sort((a, b) {
      final aLastAccessed = a.lastAccessed ?? DateTime(2000);
      final bLastAccessed = b.lastAccessed ?? DateTime(2000);
      return bLastAccessed.compareTo(aLastAccessed);
    });
  }

  /// Pre-cache high confidence items
  Future<void> preloadHighConfidenceItems(List<DuaEntity> duas) async {
    final highConfidenceItems = duas.where((dua) => dua.ragConfidence.score >= _highConfidenceThreshold).toList();

    await smartPreCache(highConfidenceItems);
  }
}
