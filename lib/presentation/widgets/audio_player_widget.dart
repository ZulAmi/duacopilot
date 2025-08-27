import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/dua_entity.dart';
import '../../services/audio/audio_service.dart';

/// AudioPlayerWidget class implementation
class AudioPlayerWidget extends StatefulWidget {
  final List<DuaEntity> duas;

  const AudioPlayerWidget({super.key, required this.duas});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

/// _AudioPlayerWidgetState class implementation
class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final DuaAudioService _audioService = DuaAudioService.instance;

  bool _isInitialized = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;
  double _speed = 1.0;
  List<MediaItem> _queue = [];
  int? _currentIndex;
  Map<String, dynamic>? _cacheStats;

  @override
  void initState() {
    super.initState();
    _initializeAudioService();
  }

  Future<void> _initializeAudioService() async {
    try {
      await _audioService.initialize();

      // Subscribe to audio streams
      _audioService.isPlayingStream.listen((playing) {
        if (mounted) setState(() => _isPlaying = playing);
      });

      _audioService.positionStream.listen((position) {
        if (mounted) setState(() => _position = position);
      });

      _audioService.durationStream.listen((duration) {
        if (mounted) setState(() => _duration = duration);
      });

      _audioService.speedStream.listen((speed) {
        if (mounted) setState(() => _speed = speed);
      });

      _audioService.queueStream.listen((queue) {
        if (mounted) setState(() => _queue = queue);
      });

      _audioService.currentIndexStream.listen((index) {
        if (mounted) setState(() => _currentIndex = index);
      });

      // Load the duas as a playlist
      await _audioService.loadDuaPlaylist(widget.duas);

      // Get cache stats
      _updateCacheStats();

      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Failed to initialize audio service: $e');
    }
  }

  Future<void> _updateCacheStats() async {
    final stats = await _audioService.getCacheStats();
    if (mounted) setState(() => _cacheStats = stats);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.audiotrack, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Smart Audio Player',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (_cacheStats != null)
                  Chip(
                    label: Text(
                      'Cache: ${_cacheStats!['utilizationPercent']}%',
                    ),
                    backgroundColor: Colors.teal.shade50,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Current track info
            if (_queue.isNotEmpty && _currentIndex != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _queue[_currentIndex!].title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _queue[_currentIndex!].artist ?? 'Unknown Artist',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    if (_queue[_currentIndex!].extras?['ragScore'] != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.psychology,
                              size: 16,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'RAG Score: ${(_queue[_currentIndex!].extras!['ragScore'] as double).toStringAsFixed(2)}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Progress slider
            if (_duration != null)
              Column(
                children: [
                  Slider(
                    value: _position.inMilliseconds.toDouble(),
                    max: _duration!.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      _audioService.seek(Duration(milliseconds: value.round()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration!)),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Main controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _audioService.skipToPrevious,
                  icon: const Icon(Icons.skip_previous),
                ),
                IconButton(
                  onPressed: () {
                    _audioService.seekBackward(10);
                  },
                  icon: const Icon(Icons.replay_10),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_isPlaying) {
                        _audioService.pause();
                      } else {
                        _audioService.play();
                      }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _audioService.seekForward(10);
                  },
                  icon: const Icon(Icons.forward_10),
                ),
                IconButton(
                  onPressed: _audioService.skipToNext,
                  icon: const Icon(Icons.skip_next),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Speed and additional controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Speed control
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _audioService.decreaseSpeed,
                        icon: const Icon(Icons.remove, size: 16),
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                      Text('${_speed.toStringAsFixed(1)}x'),
                      IconButton(
                        onPressed: _audioService.increaseSpeed,
                        icon: const Icon(Icons.add, size: 16),
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Smart cache button
                ElevatedButton.icon(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    await _audioService.smartPreCache(widget.duas);
                    _updateCacheStats();
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Smart pre-caching completed!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Smart Cache'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),

                // Stop button
                IconButton(
                  onPressed: _audioService.stop,
                  icon: const Icon(Icons.stop),
                ),
              ],
            ),

            // Cache stats
            if (_cacheStats != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Cache Statistics',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cached Items: ${_cacheStats!['totalCount']}'),
                        Text('Size: ${_cacheStats!['totalSizeFormatted']}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (_cacheStats!['utilizationPercent'] as int) / 100.0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Note: We don't dispose the audio service as it's a singleton
    // and may be used by other parts of the app
    super.dispose();
  }
}
