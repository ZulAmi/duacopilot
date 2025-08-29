import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/premium_audio_entity.dart';
import '../../../services/premium_audio/premium_audio_service.dart';
import '../../../services/subscription/subscription_service.dart';

/// Premium Audio Screen - World-Class Islamic Audio Experience
class PremiumAudioScreen extends ConsumerStatefulWidget {
  const PremiumAudioScreen({super.key});

  @override
  ConsumerState<PremiumAudioScreen> createState() => _PremiumAudioScreenState();
}

class _PremiumAudioScreenState extends ConsumerState<PremiumAudioScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PremiumAudioService _audioService = PremiumAudioService.instance;

  // Current playback state
  PremiumRecitation? _currentRecitation;
  bool _isPlaying = false;
  bool _isLoading = false;
  final Duration _currentPosition = Duration.zero;
  final Duration _totalDuration = Duration.zero;

  // Famous Qaris data
  List<QariInfo> _qaris = [];
  List<PremiumRecitation> _recitations = [];
  List<PremiumPlaylist> _playlists = [];

  // Sleep timer
  SleepTimerConfig? _sleepTimer;
  Timer? _sleepCountdownTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeAudioService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sleepCountdownTimer?.cancel();
    super.dispose();
  }

  /// Initialize audio service and load data
  Future<void> _initializeAudioService() async {
    setState(() => _isLoading = true);

    try {
      // Validate subscription
      final subscriptionService = SubscriptionService.instance;
      if (!subscriptionService.hasActiveSubscription) {
        _showSubscriptionRequired();
        return;
      }

      await _audioService.initialize();

      // Load famous Qaris
      _qaris = _audioService.getQaris();

      // Load featured recitations
      _recitations = await _audioService.getQariRecitations(_qaris.first.id);

      // Load user playlists
      _playlists = await _audioService.getUserPlaylists();
    } catch (e) {
      _showError('Failed to initialize premium audio: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoading() : _buildContent(),
      bottomNavigationBar:
          _currentRecitation != null ? _buildMiniPlayer() : null,
    );
  }

  /// Build app bar with premium branding
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.headphones, color: Colors.white),
          SizedBox(width: 8),
          Text('Premium Audio'),
          SizedBox(width: 8),
          Icon(Icons.star, color: Colors.amber, size: 20),
        ],
      ),
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.bedtime),
          onPressed: _showSleepTimerDialog,
          tooltip: 'Sleep Timer',
        ),
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _showDownloadManager(),
          tooltip: 'Download Manager',
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'Qaris', icon: Icon(Icons.person)),
          Tab(text: 'Recitations', icon: Icon(Icons.audiotrack)),
          Tab(text: 'Playlists', icon: Icon(Icons.queue_music)),
          Tab(text: 'Downloads', icon: Icon(Icons.download_done)),
        ],
      ),
    );
  }

  /// Build loading widget
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading Premium Audio Content...'),
        ],
      ),
    );
  }

  /// Build main content with tabs
  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF667eea).withValues(alpha: 0.1), Colors.white],
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildQarisTab(),
          _buildRecitationsTab(),
          _buildPlaylistsTab(),
          _buildDownloadsTab(),
        ],
      ),
    );
  }

  /// Build Famous Qaris tab
  Widget _buildQarisTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _qaris.length,
      itemBuilder: (context, index) {
        final qari = _qaris[index];
        return _buildQariCard(qari);
      },
    );
  }

  /// Build individual Qari card
  Widget _buildQariCard(QariInfo qari) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showQariDetails(qari),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Qari Avatar
              Hero(
                tag: 'qari_${qari.id}',
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(qari.profileImageUrl),
                ),
              ),
              const SizedBox(width: 16),

              // Qari Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            qari.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (qari.isVerified)
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      qari.arabicName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'Amiri', // Arabic font
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(qari.rating.toStringAsFixed(1)),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.audiotrack,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text('${qari.totalRecitations} Recitations'),
                      ],
                    ),
                  ],
                ),
              ),

              // Play button
              IconButton(
                onPressed: () => _playQariSample(qari),
                icon: const Icon(Icons.play_circle_outline),
                iconSize: 40,
                color: const Color(0xFF667eea),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Recitations tab
  Widget _buildRecitationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recitations.length,
      itemBuilder: (context, index) {
        final recitation = _recitations[index];
        return _buildRecitationTile(recitation);
      },
    );
  }

  /// Build recitation tile
  Widget _buildRecitationTile(PremiumRecitation recitation) {
    final isCurrentlyPlaying =
        _currentRecitation?.id == recitation.id && _isPlaying;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF667eea),
          child: isCurrentlyPlaying
              ? const Icon(Icons.pause, color: Colors.white)
              : const Icon(Icons.play_arrow, color: Colors.white),
        ),
        title: Text(recitation.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reciter: ${_getQariName(recitation.qariId)}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(_formatDuration(Duration(seconds: recitation.duration))),
                const SizedBox(width: 16),
                Icon(Icons.high_quality, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(recitation.quality.name.toUpperCase()),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadRecitation(recitation),
              tooltip: 'Download',
            ),
            IconButton(
              icon: const Icon(Icons.playlist_add),
              onPressed: () => _addToPlaylist(recitation),
              tooltip: 'Add to Playlist',
            ),
          ],
        ),
        onTap: () => _playRecitation(recitation),
      ),
    );
  }

  /// Build Playlists tab
  Widget _buildPlaylistsTab() {
    return Column(
      children: [
        // Create new playlist button
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _createNewPlaylist,
            icon: const Icon(Icons.add),
            label: const Text('Create New Playlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),

        // Playlists list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _playlists.length,
            itemBuilder: (context, index) {
              final playlist = _playlists[index];
              return _buildPlaylistCard(playlist);
            },
          ),
        ),
      ],
    );
  }

  /// Build playlist card
  Widget _buildPlaylistCard(PremiumPlaylist playlist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openPlaylist(playlist),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Playlist artwork
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: const Icon(
                  Icons.queue_music,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Playlist info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${playlist.recitationIds.length} recitations',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      playlist.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // More options
              PopupMenuButton<String>(
                onSelected: (value) => _handlePlaylistAction(value, playlist),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'play',
                    child: Text('Play All'),
                  ),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'share', child: Text('Share')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Downloads tab
  Widget _buildDownloadsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_done, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Downloaded Recitations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Your offline recitations will appear here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Build mini player at bottom
  Widget _buildMiniPlayer() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: _totalDuration.inMilliseconds > 0
                ? _currentPosition.inMilliseconds /
                    _totalDuration.inMilliseconds
                : 0.0,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
          ),

          // Player controls
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Recitation info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentRecitation?.title ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _currentRecitation != null
                              ? _getQariName(_currentRecitation!.qariId)
                              : '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Control buttons
                  IconButton(
                    onPressed: _previousTrack,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: _togglePlayPause,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 32,
                  ),
                  IconButton(
                    onPressed: _nextTrack,
                    icon: const Icon(Icons.skip_next),
                  ),

                  // Time display
                  Text(
                    '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Audio playback methods
  Future<void> _playRecitation(PremiumRecitation recitation) async {
    try {
      setState(() {
        _currentRecitation = recitation;
        _isPlaying = true;
      });

      await _audioService.playRecitation(recitation);
    } catch (e) {
      _showError('Failed to play recitation: $e');
    }
  }

  Future<void> _playQariSample(QariInfo qari) async {
    try {
      // Get recitations from this Qari and play the first one as sample
      final qariRecitations = await _audioService.getQariRecitations(qari.id);
      if (qariRecitations.isNotEmpty) {
        await _playRecitation(qariRecitations.first);
      } else {
        _showError('No recitations available for this Qari');
      }
    } catch (e) {
      _showError('Failed to play Qari sample: $e');
    }
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    // Implement actual play/pause logic
  }

  void _nextTrack() {
    // Implement next track logic
  }

  void _previousTrack() {
    // Implement previous track logic
  }

  // UI interaction methods
  void _showQariDetails(QariInfo qari) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQariDetailsSheet(qari),
    );
  }

  Widget _buildQariDetailsSheet(QariInfo qari) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Qari header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Hero(
                  tag: 'qari_${qari.id}',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(qari.profileImageUrl),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qari.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        qari.arabicName,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(qari.rating.toStringAsFixed(1)),
                          const SizedBox(width: 16),
                          if (qari.isVerified) ...[
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            const Text('Verified'),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Biography
          if (qari.bioEnglish.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biography',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(qari.bioEnglish),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _playQariSample(qari),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Sample'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewAllQariRecitations(qari),
                    icon: const Icon(Icons.library_music),
                    label: const Text('All Recitations'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSleepTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildSleepTimerDialog(),
    );
  }

  Widget _buildSleepTimerDialog() {
    return AlertDialog(
      title: const Text('Sleep Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Set audio to stop after:'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _buildTimerChip('15 min', 15),
              _buildTimerChip('30 min', 30),
              _buildTimerChip('45 min', 45),
              _buildTimerChip('1 hour', 60),
              _buildTimerChip('Custom', 0),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (_sleepTimer != null)
          TextButton(
            onPressed: _cancelSleepTimer,
            child: const Text('Stop Timer'),
          ),
      ],
    );
  }

  Widget _buildTimerChip(String label, int minutes) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        if (minutes > 0) {
          _setSleepTimer(minutes);
        } else {
          _showCustomTimerDialog();
        }
        Navigator.pop(context);
      },
    );
  }

  void _setSleepTimer(int minutes) {
    setState(() {
      _sleepTimer = SleepTimerConfig(
        duration: Duration(minutes: minutes),
        isActive: true,
        startTime: DateTime.now(),
      );
    });

    // Start countdown timer
    _sleepCountdownTimer = Timer(Duration(minutes: minutes), () {
      _stopPlaybackAndDisableTimer();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sleep timer set for $minutes minutes')),
    );
  }

  void _cancelSleepTimer() {
    setState(() => _sleepTimer = null);
    _sleepCountdownTimer?.cancel();
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sleep timer cancelled')));
  }

  void _stopPlaybackAndDisableTimer() {
    setState(() {
      _isPlaying = false;
      _sleepTimer = null;
    });
    _sleepCountdownTimer?.cancel();
    // Stop audio playback
  }

  void _showCustomTimerDialog() {
    // Implement custom timer input
  }

  void _createNewPlaylist() {
    // Implement playlist creation
  }

  void _openPlaylist(PremiumPlaylist playlist) {
    // Implement playlist details view
  }

  void _handlePlaylistAction(String action, PremiumPlaylist playlist) {
    switch (action) {
      case 'play':
        // Play all songs in playlist
        break;
      case 'edit':
        // Edit playlist
        break;
      case 'share':
        // Share playlist
        break;
      case 'delete':
        // Delete playlist
        break;
    }
  }

  void _downloadRecitation(PremiumRecitation recitation) {
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${recitation.title}...')),
    );
  }

  void _addToPlaylist(PremiumRecitation recitation) {
    // Show playlist selection dialog
  }

  void _showDownloadManager() {
    // Show download manager screen
  }

  void _viewAllQariRecitations(QariInfo qari) {
    // Navigate to qari's all recitations
    Navigator.pop(context);
  }

  void _showSubscriptionRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Subscription Required'),
        content: const Text(
          'Premium Audio features require an active subscription. '
          'Upgrade now to access world-class Quranic recitations from famous Qaris.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to subscription screen
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          textColor: Colors.white,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getQariName(String qariId) {
    try {
      return _qaris.firstWhere((qari) => qari.id == qariId).name;
    } catch (e) {
      return 'Unknown Qari';
    }
  }
}

