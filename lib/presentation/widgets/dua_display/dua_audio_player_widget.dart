import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Professional Islamic audio player widget for Dua recitations
class DuaAudioPlayerWidget extends StatefulWidget {
  final String? audioUrl;
  final String duaTitle;
  final VoidCallback? onDownload;
  final bool showDownloadOption;

  const DuaAudioPlayerWidget({
    super.key,
    this.audioUrl,
    required this.duaTitle,
    this.onDownload,
    this.showDownloadOption = true,
  });

  @override
  State<DuaAudioPlayerWidget> createState() => _DuaAudioPlayerWidgetState();
}

/// _DuaAudioPlayerWidgetState class implementation
class _DuaAudioPlayerWidgetState extends State<DuaAudioPlayerWidget>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _playButtonController;
  late AnimationController _progressController;
  late Animation<double> _playButtonAnimation;

  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _playButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isLoading = state == PlayerState.playing && _position == Duration.zero;
      });

      if (_isPlaying) {
        _playButtonController.forward();
      } else {
        _playButtonController.reverse();
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
      _playButtonController.reverse();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playButtonController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioUrl == null) {
      return _buildNoAudioAvailable();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          const SizedBox(height: 16),

          // Progress bar
          _buildProgressBar(),

          const SizedBox(height: 16),

          // Controls
          _buildControls(),

          if (widget.showDownloadOption) ...[
            const SizedBox(height: 12),
            _buildDownloadOption(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.headphones_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Audio Recitation',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                widget.duaTitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Speed control
        _buildSpeedControl(),
      ],
    );
  }

  Widget _buildSpeedControl() {
    return PopupMenuButton<double>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${_playbackSpeed}x',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      onSelected: (speed) {
        setState(() {
          _playbackSpeed = speed;
        });
        _audioPlayer.setPlaybackRate(speed);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 0.5, child: Text('0.5x')),
        const PopupMenuItem(value: 0.75, child: Text('0.75x')),
        const PopupMenuItem(value: 1.0, child: Text('1.0x')),
        const PopupMenuItem(value: 1.25, child: Text('1.25x')),
        const PopupMenuItem(value: 1.5, child: Text('1.5x')),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        // Visual waveform-like progress indicator
        SizedBox(
          height: 40,
          child: CustomPaint(
            size: const Size(double.infinity, 40),
            painter: AudioWaveformPainter(
              progress: _duration.inMilliseconds > 0
                  ? _position.inMilliseconds / _duration.inMilliseconds
                  : 0.0,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              isPlaying: _isPlaying,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Time labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(_position),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              _formatDuration(_duration),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip backward 10s
        _buildControlButton(
          icon: Icons.replay_10_rounded,
          onTap: () => _seekRelative(-10),
          tooltip: 'Rewind 10 seconds',
        ),

        const SizedBox(width: 20),

        // Play/Pause button
        _buildPlayPauseButton(),

        const SizedBox(width: 20),

        // Skip forward 10s
        _buildControlButton(
          icon: Icons.forward_10_rounded,
          onTap: () => _seekRelative(10),
          tooltip: 'Forward 10 seconds',
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: _isLoading
            ? Container(
                padding: const EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : AnimatedBuilder(
                animation: _playButtonAnimation,
                builder: (context, child) {
                  return Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadOption() {
    return InkWell(
      onTap: widget.onDownload,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Download Audio',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAudioAvailable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.headphones_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Audio recitation not available for this Du\'a',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_position >= _duration && _duration.inMilliseconds > 0) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play(UrlSource(widget.audioUrl!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _seekRelative(int seconds) {
    final newPosition = _position + Duration(seconds: seconds);
    final clampedPosition = Duration(
      milliseconds: newPosition.inMilliseconds.clamp(
        0,
        _duration.inMilliseconds,
      ),
    );
    _audioPlayer.seek(clampedPosition);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Professional audio waveform painter for Islamic audio player
class AudioWaveformPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final bool isPlaying;

  const AudioWaveformPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw waveform bars
    const barCount = 50;
    final barWidth = size.width / barCount;
    final progressWidth = size.width * progress;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth;
      final height = _getBarHeight(i, barCount) * size.height;
      final y = (size.height - height) / 2;

      final rect = Rect.fromLTRB(x, y, x + barWidth - 1, y + height);

      // Draw background bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1)),
        backgroundPaint,
      );

      // Draw progress bar
      if (x < progressWidth) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(1)),
          progressPaint,
        );
      }
    }
  }

  double _getBarHeight(int index, int total) {
    // Create a pseudo-random waveform pattern using sine functions
    final normalized = index / total;
    return 0.3 +
        0.7 *
            (0.5 +
                0.3 * math.sin(normalized * 15) +
                0.2 * math.sin(normalized * 23));
  }

  @override
  bool shouldRepaint(AudioWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying;
  }
}

