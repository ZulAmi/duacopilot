import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/dua_entity.dart';

class DuaAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final List<MediaItem> _queue = [];
  int _currentIndex = 0;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  DuaAudioHandler() {
    _initialize();
  }

  void _initialize() {
    // Listen to player state changes
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
          playbackState.add(
            playbackState.value.copyWith(
              playing: false,
              processingState: AudioProcessingState.idle,
            ),
          );
          break;
        case ProcessingState.loading:
        case ProcessingState.buffering:
          playbackState.add(
            playbackState.value.copyWith(
              playing: false,
              processingState: AudioProcessingState.loading,
            ),
          );
          break;
        case ProcessingState.ready:
          playbackState.add(
            playbackState.value.copyWith(
              playing: state.playing,
              processingState: AudioProcessingState.ready,
            ),
          );
          break;
        case ProcessingState.completed:
          _handleTrackCompletion();
          break;
      }
    });

    // Listen to position changes
    _positionSubscription = _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    // Listen to duration changes
    _durationSubscription = _player.durationStream.listen((duration) {
      if (duration != null && _currentIndex < _queue.length) {
        final currentItem = _queue[_currentIndex];
        mediaItem.add(currentItem.copyWith(duration: duration));
      }
    });

    // Initialize playback state
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
          MediaAction.setSpeed,
          MediaAction.setRepeatMode,
        },
        androidCompactActionIndices: const [0, 1, 4],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
        speed: 1.0,
        queueIndex: 0,
      ),
    );
  }

  // Queue management
  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    _queue.addAll(mediaItems);
    queue.add(_queue);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    _queue.clear();
    _queue.addAll(queue);
    this.queue.add(_queue);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      queue.add(_queue);

      // Adjust current index if necessary
      if (index < _currentIndex) {
        _currentIndex--;
      } else if (index == _currentIndex && _currentIndex >= _queue.length) {
        _currentIndex = _queue.length - 1;
      }
    }
  }

  // Playback controls
  @override
  Future<void> play() async {
    if (_queue.isEmpty) return;

    final currentItem = _queue[_currentIndex];
    await _loadAndPlayTrack(currentItem);
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
        updatePosition: Duration.zero,
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await _playCurrentTrack();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await _playCurrentTrack();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < _queue.length) {
      _currentIndex = index;
      await _playCurrentTrack();
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    playbackState.add(playbackState.value.copyWith(speed: speed));
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    LoopMode loopMode;
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        loopMode = LoopMode.off;
        break;
      case AudioServiceRepeatMode.one:
        loopMode = LoopMode.one;
        break;
      case AudioServiceRepeatMode.all:
        loopMode = LoopMode.all;
        break;
      case AudioServiceRepeatMode.group:
        loopMode = LoopMode.all;
        break;
    }
    await _player.setLoopMode(loopMode);
  }

  // Custom actions for Du'a specific features
  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    switch (name) {
      case 'setPlaybackRate':
        final rate = extras?['rate'] as double? ?? 1.0;
        await setSpeed(rate);
        return;

      case 'seekForward':
        final seconds = extras?['seconds'] as int? ?? 10;
        final newPosition = _player.position + Duration(seconds: seconds);
        final duration = _player.duration ?? Duration.zero;
        await seek(newPosition > duration ? duration : newPosition);
        return;

      case 'seekBackward':
        final seconds = extras?['seconds'] as int? ?? 10;
        final newPosition = _player.position - Duration(seconds: seconds);
        await seek(newPosition < Duration.zero ? Duration.zero : newPosition);
        return;

      case 'toggleMute':
        final currentVolume = _player.volume;
        await _player.setVolume(currentVolume > 0 ? 0.0 : 1.0);
        return;

      case 'setVolume':
        final volume = extras?['volume'] as double? ?? 1.0;
        await _player.setVolume(volume.clamp(0.0, 1.0));
        return;

      case 'createPlaylistFromDuas':
        final duas = extras?['duas'] as List<DuaEntity>? ?? [];
        return await _createPlaylistFromDuas(duas);

      case 'preloadTrack':
        final trackId = extras?['trackId'] as String?;
        if (trackId != null) {
          await _preloadTrack(trackId);
        }
        return;

      default:
        return super.customAction(name, extras);
    }
  }

  Future<void> _loadAndPlayTrack(MediaItem item) async {
    try {
      mediaItem.add(item);

      // Check if track is cached locally
      final localPath = item.extras?['localPath'] as String?;
      final url = localPath ?? item.id;

      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      await _player.play();

      playbackState.add(
        playbackState.value.copyWith(queueIndex: _currentIndex),
      );
    } catch (e) {
      debugPrint('Error loading track: $e');
      playbackState.add(
        playbackState.value.copyWith(
          playing: false,
          processingState: AudioProcessingState.error,
        ),
      );
    }
  }

  Future<void> _playCurrentTrack() async {
    if (_currentIndex >= 0 && _currentIndex < _queue.length) {
      await _loadAndPlayTrack(_queue[_currentIndex]);
    }
  }

  void _handleTrackCompletion() {
    final repeatMode = _player.loopMode;

    if (repeatMode == LoopMode.one) {
      // Track will repeat automatically
      return;
    }

    if (_currentIndex < _queue.length - 1) {
      // Move to next track
      skipToNext();
    } else if (repeatMode == LoopMode.all) {
      // Restart from beginning
      _currentIndex = 0;
      _playCurrentTrack();
    } else {
      // Stop playback
      playbackState.add(
        playbackState.value.copyWith(
          playing: false,
          processingState: AudioProcessingState.completed,
        ),
      );
    }
  }

  Future<List<MediaItem>> _createPlaylistFromDuas(List<DuaEntity> duas) async {
    final mediaItems = <MediaItem>[];

    for (final dua in duas) {
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
        mediaItems.add(mediaItem);
      }
    }

    return mediaItems;
  }

  Future<void> _preloadTrack(String trackId) async {
    // Implement track preloading logic
    debugPrint('Preloading track: $trackId');
  }

  Future<void> loadDuaPlaylist(List<DuaEntity> duas) async {
    final mediaItems = await _createPlaylistFromDuas(duas);
    await updateQueue(mediaItems);
  }

  Future<void> playDuaById(String duaId) async {
    final index = _queue.indexWhere((item) => item.extras?['duaId'] == duaId);
    if (index >= 0) {
      await skipToQueueItem(index);
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  @override
  Future<void> onNotificationDeleted() async {
    await stop();
  }

  Future<void> cleanup() async {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    await _player.dispose();
  }
}
