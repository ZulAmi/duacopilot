import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/dua_entity.dart';
import '../../domain/entities/audio_entity.dart';
import 'dua_audio_handler.dart';
import 'audio_cache_service.dart';

/// DuaAudioService class implementation
class DuaAudioService {
  static DuaAudioService? _instance;
  static DuaAudioService get instance => _instance ??= DuaAudioService._();

  DuaAudioService._();

  DuaAudioHandler? _audioHandler;
  AudioCacheService? _cacheService;

  bool _isInitialized = false;

  // Stream controllers for audio state
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController =
      StreamController<Duration?>.broadcast();
  final StreamController<List<MediaItem>> _queueController =
      StreamController<List<MediaItem>>.broadcast();
  final StreamController<int?> _currentIndexController =
      StreamController<int?>.broadcast();
  final StreamController<double> _speedController =
      StreamController<double>.broadcast();

  // Public streams
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration?> get durationStream => _durationController.stream;
  Stream<List<MediaItem>> get queueStream => _queueController.stream;
  Stream<int?> get currentIndexStream => _currentIndexController.stream;
  Stream<double> get speedStream => _speedController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize cache service
      _cacheService = AudioCacheService();
      await _cacheService!.initialize();

      // Initialize audio handler
      _audioHandler = await AudioService.init(
        builder: () => DuaAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.duacopilot.audio',
          androidNotificationChannelName: 'Du\'a Audio Playback',
          androidNotificationChannelDescription:
              'Background audio playback for Islamic Du\'as',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
          androidNotificationClickStartsActivity: true,
        ),
      );

      // Subscribe to audio handler streams
      _subscribeToAudioHandlerStreams();

      _isInitialized = true;
      debugPrint('Audio service initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize audio service: $e');
      rethrow;
    }
  }

  void _subscribeToAudioHandlerStreams() {
    if (_audioHandler == null) return;

    // Listen to playback state changes
    _audioHandler!.playbackState.listen((state) {
      _isPlayingController.add(state.playing);
      _positionController.add(state.updatePosition);
      _speedController.add(state.speed);
      _currentIndexController.add(state.queueIndex);
    });

    // Listen to media item changes
    _audioHandler!.mediaItem.listen((item) {
      if (item?.duration != null) {
        _durationController.add(item!.duration);
      }
    });

    // Listen to queue changes
    _audioHandler!.queue.listen((queue) {
      _queueController.add(queue);
    });
  }

  // Playback controls
  Future<void> play() async {
    await _ensureInitialized();
    await _audioHandler!.play();
  }

  Future<void> pause() async {
    await _ensureInitialized();
    await _audioHandler!.pause();
  }

  Future<void> stop() async {
    await _ensureInitialized();
    await _audioHandler!.stop();
  }

  Future<void> seek(Duration position) async {
    await _ensureInitialized();
    await _audioHandler!.seek(position);
  }

  Future<void> skipToNext() async {
    await _ensureInitialized();
    await _audioHandler!.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await _ensureInitialized();
    await _audioHandler!.skipToPrevious();
  }

  Future<void> skipToQueueItem(int index) async {
    await _ensureInitialized();
    await _audioHandler!.skipToQueueItem(index);
  }

  Future<void> setSpeed(double speed) async {
    await _ensureInitialized();
    await _audioHandler!.setSpeed(speed);
  }

  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    await _ensureInitialized();
    await _audioHandler!.setRepeatMode(repeatMode);
  }

  // Queue management
  Future<void> loadDuaPlaylist(List<DuaEntity> duas) async {
    await _ensureInitialized();

    // Pre-cache high confidence items
    if (_cacheService != null) {
      unawaited(_cacheService!.preloadHighConfidenceItems(duas));
    }

    await _audioHandler!.loadDuaPlaylist(duas);
  }

  Future<void> playDuaById(String duaId) async {
    await _ensureInitialized();
    await _audioHandler!.playDuaById(duaId);
  }

  Future<void> addDuaToQueue(DuaEntity dua) async {
    await _ensureInitialized();

    if (dua.audioUrl != null) {
      final mediaItem = MediaItem(
        id: dua.audioUrl!,
        album: dua.category,
        title: dua.category,
        artist: 'Islamic Recitation',
        duration: const Duration(minutes: 3), // Default duration
        artUri: Uri.parse('asset:///assets/images/dua_cover.png'),
        extras: {
          'duaId': dua.id,
          'arabicText': dua.arabicText,
          'translation': dua.translation,
          'ragScore': dua.ragConfidence.score,
        },
      );

      await _audioHandler!.addQueueItems([mediaItem]);
    }
  }

  // Speed control
  Future<void> increaseSpeed() async {
    final currentSpeed =
        _speedController.hasListener ? 1.0 : 1.0; // Default speed
    final newSpeed = (currentSpeed + 0.25).clamp(0.5, 2.0);
    await setSpeed(newSpeed);
  }

  Future<void> decreaseSpeed() async {
    final currentSpeed =
        _speedController.hasListener ? 1.0 : 1.0; // Default speed
    final newSpeed = (currentSpeed - 0.25).clamp(0.5, 2.0);
    await setSpeed(newSpeed);
  }

  Future<void> resetSpeed() async {
    await setSpeed(1.0);
  }

  // Seek controls
  Future<void> seekForward([int seconds = 10]) async {
    await _ensureInitialized();
    await _audioHandler!.customAction('seekForward', {'seconds': seconds});
  }

  Future<void> seekBackward([int seconds = 10]) async {
    await _ensureInitialized();
    await _audioHandler!.customAction('seekBackward', {'seconds': seconds});
  }

  // Volume controls
  Future<void> toggleMute() async {
    await _ensureInitialized();
    await _audioHandler!.customAction('toggleMute');
  }

  Future<void> setVolume(double volume) async {
    await _ensureInitialized();
    await _audioHandler!.customAction('setVolume', {'volume': volume});
  }

  // Cache management
  Future<bool> isAudioCached(String audioUrl) async {
    await _ensureInitialized();
    return await _cacheService?.isAudioCached(audioUrl) ?? false;
  }

  Future<String?> getCachedAudioPath(String audioUrl) async {
    await _ensureInitialized();
    return await _cacheService?.getCachedAudioPath(audioUrl);
  }

  Future<void> cacheAudio(
    String audioUrl, {
    CachePriority priority = CachePriority.normal,
  }) async {
    await _ensureInitialized();
    await _cacheService?.cacheAudio(audioUrl, priority: priority);
  }

  Future<void> removeCachedAudio(String audioUrl) async {
    await _ensureInitialized();
    await _cacheService?.removeCachedAudio(audioUrl);
  }

  Future<void> clearAllCache() async {
    await _ensureInitialized();
    await _cacheService?.clearAllCache();
  }

  Future<Map<String, dynamic>?> getCacheStats() async {
    await _ensureInitialized();
    return await _cacheService?.getCacheStats();
  }

  // Smart pre-caching
  Future<void> smartPreCache(List<DuaEntity> duas) async {
    await _ensureInitialized();
    await _cacheService?.smartPreCache(duas);
  }

  // RAG-based playlist generation
  Future<List<DuaEntity>> generateRelatedPlaylist(
    DuaEntity currentDua,
    List<DuaEntity> allDuas,
  ) async {
    // Simple implementation - in production, this would use more sophisticated RAG
    final relatedDuas =
        allDuas
            .where(
              (dua) =>
                  dua.id != currentDua.id &&
                  dua.category == currentDua.category &&
                  dua.ragConfidence.score > 0.5,
            )
            .toList()
          ..sort(
            (a, b) => b.ragConfidence.score.compareTo(a.ragConfidence.score),
          );

    return relatedDuas.take(10).toList();
  }

  Future<void> playRelatedDuas(
    DuaEntity currentDua,
    List<DuaEntity> allDuas,
  ) async {
    final relatedDuas = await generateRelatedPlaylist(currentDua, allDuas);
    final fullPlaylist = [currentDua, ...relatedDuas];
    await loadDuaPlaylist(fullPlaylist);
    await play();
  }

  // Utility methods
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  void dispose() {
    _isPlayingController.close();
    _positionController.close();
    _durationController.close();
    _queueController.close();
    _currentIndexController.close();
    _speedController.close();
    _audioHandler?.cleanup();
  }

  // Get current state
  bool get isPlaying => _audioHandler?.playbackState.value.playing ?? false;
  Duration get currentPosition =>
      _audioHandler?.playbackState.value.updatePosition ?? Duration.zero;
  double get currentSpeed => _audioHandler?.playbackState.value.speed ?? 1.0;
  List<MediaItem> get currentQueue => _audioHandler?.queue.value ?? [];
  int? get currentIndex => _audioHandler?.playbackState.value.queueIndex;
  MediaItem? get currentMediaItem => _audioHandler?.mediaItem.value;
}
