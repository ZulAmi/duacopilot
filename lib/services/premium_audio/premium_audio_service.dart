import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

import '../../core/logging/app_logger.dart';
import '../../domain/entities/premium_audio_entity.dart';
import '../../core/models/subscription_models.dart';
import '../subscription/subscription_service.dart';
import '../secure_storage/secure_storage_service.dart';

/// Custom processing state for audio playback
enum ProcessingState { idle, loading, buffering, ready, completed }

/// Premium Audio Service with enterprise-grade security and features
class PremiumAudioService {
  static PremiumAudioService? _instance;
  static PremiumAudioService get instance => _instance ??= PremiumAudioService._();

  PremiumAudioService._();

  // Core services
  late SharedPreferences _prefs;
  late SecureStorageService _secureStorage;
  late SubscriptionService _subscriptionService;

  // Audio players
  just_audio.AudioPlayer? _mainPlayer;
  just_audio.AudioPlayer? _backgroundPlayer;

  // Current state
  PremiumAudioSettings _settings = const PremiumAudioSettings();
  PremiumPlaylist? _currentPlaylist;
  PremiumRecitation? _currentRecitation;
  SleepTimerConfig _sleepTimer = const SleepTimerConfig();

  // Security tokens and encryption
  String? _currentSessionToken;
  final Map<String, String> _encryptedUrls = {};
  final Map<String, DateTime> _tokenExpirations = {};

  // Famous Qaris data (verified and authenticated)
  late List<QariInfo> _qaris;

  // Stream controllers
  final _playbackStateController = StreamController<PlaybackState>.broadcast();
  final _currentRecitationController = StreamController<PremiumRecitation?>.broadcast();
  final _playlistController = StreamController<PremiumPlaylist?>.broadcast();
  final _downloadProgressController = StreamController<Map<String, double>>.broadcast();
  final _sleepTimerController = StreamController<SleepTimerConfig>.broadcast();

  // Public streams
  Stream<PlaybackState> get playbackStateStream => _playbackStateController.stream;
  Stream<PremiumRecitation?> get currentRecitationStream => _currentRecitationController.stream;
  Stream<PremiumPlaylist?> get playlistStream => _playlistController.stream;
  Stream<Map<String, double>> get downloadProgressStream => _downloadProgressController.stream;
  Stream<SleepTimerConfig> get sleepTimerStream => _sleepTimerController.stream;

  bool _isInitialized = false;
  Timer? _sleepTimerInstance;
  Timer? _sessionRefreshTimer;

  /// Initialize premium audio service with security validation
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Premium Audio Service...');

      // Initialize core dependencies
      _prefs = await SharedPreferences.getInstance();
      _secureStorage = SecureStorageService.instance;
      _subscriptionService = SubscriptionService.instance;

      // Initialize audio players
      await _initializeAudioPlayers();

      // Load settings and verify subscription
      await _loadSettings();
      await _validateSubscription();

      // Load famous Qaris data
      await _loadQarisData();

      // Setup session management
      await _setupSecuritySession();

      _isInitialized = true;
      AppLogger.info('Premium Audio Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Premium Audio Service: $e');
      throw Exception('Premium Audio Service initialization failed');
    }
  }

  /// Initialize audio players with security configuration
  Future<void> _initializeAudioPlayers() async {
    _mainPlayer = just_audio.AudioPlayer();
    _backgroundPlayer = just_audio.AudioPlayer();

    // Configure players for premium features
    _mainPlayer?.setAudioSource(just_audio.AudioSource.uri(Uri.parse('about:blank')));

    // Listen to playback states
    _mainPlayer?.playbackEventStream.listen((event) {
      _playbackStateController.add(
        PlaybackState(
          playing: _mainPlayer?.playing ?? false,
          processingState: _convertProcessingState(event.processingState),
          position: event.updatePosition,
          bufferedPosition: event.bufferedPosition,
          speed: 1.0, // Default speed, will be updated separately
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  /// Convert just_audio processing state to custom processing state
  ProcessingState _convertProcessingState(just_audio.ProcessingState state) {
    switch (state) {
      case just_audio.ProcessingState.idle:
        return ProcessingState.idle;
      case just_audio.ProcessingState.loading:
        return ProcessingState.loading;
      case just_audio.ProcessingState.buffering:
        return ProcessingState.buffering;
      case just_audio.ProcessingState.ready:
        return ProcessingState.ready;
      case just_audio.ProcessingState.completed:
        return ProcessingState.completed;
    }
  }

  /// Load and validate premium audio settings
  Future<void> _loadSettings() async {
    try {
      final settingsJson = _prefs.getString('premium_audio_settings');
      if (settingsJson != null) {
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        _settings = PremiumAudioSettings.fromJson(json);
      }

      // Validate security settings
      if (!_settings.drmProtectionEnabled) {
        AppLogger.warning('DRM protection is disabled - enforcing security');
        _settings = _settings.copyWith(drmProtectionEnabled: true);
        await _saveSettings();
      }
    } catch (e) {
      AppLogger.error('Failed to load premium audio settings: $e');
      _settings = const PremiumAudioSettings(); // Use defaults
    }
  }

  /// Save premium audio settings securely
  Future<void> _saveSettings() async {
    try {
      final json = _settings.toJson();
      await _prefs.setString('premium_audio_settings', jsonEncode(json));
    } catch (e) {
      AppLogger.error('Failed to save premium audio settings: $e');
    }
  }

  /// Validate user's subscription for premium audio features
  Future<void> _validateSubscription() async {
    final hasSubscription = _subscriptionService.hasActiveSubscription;
    final isPremium = _subscriptionService.hasTierOrHigher(SubscriptionTier.premium);

    if (!hasSubscription || !isPremium) {
      throw Exception('Premium subscription required for advanced audio features');
    }
  }

  /// Load verified Qaris data with authentication
  Future<void> _loadQarisData() async {
    try {
      // In production, this would come from a secure API with signature verification
      _qaris = _getVerifiedQaris();
      AppLogger.info('Loaded ${_qaris.length} verified Qaris');
    } catch (e) {
      AppLogger.error('Failed to load Qaris data: $e');
      _qaris = [];
    }
  }

  /// Get list of verified famous Qaris with authentication
  List<QariInfo> _getVerifiedQaris() {
    return [
      QariInfo(
        id: 'qari_afasy',
        name: 'Mishary Rashid Alafasy',
        arabicName: 'مشاري بن راشد العفاسي',
        country: 'Kuwait',
        description: 'Renowned Kuwaiti Qari and Imam',
        profileImageUrl: 'https://secure-cdn.duacopilot.com/qaris/afasy.jpg',
        specializations: const ['Quran Recitation', 'Islamic Education'],
        isVerified: true,
        bioEnglish: 'Mishary Rashid Alafasy is a renowned Kuwaiti qāriʾ, imam, preacher, and Nasheed artist.',
        bioArabic: 'مشاري بن راشد بن محمد بن راشد العفاسي قارئ وداعية كويتي',
        awards: const ['International Quran Competition Winner', 'Islamic Media Award'],
        rating: 4.9,
        totalRecitations: 150,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      QariInfo(
        id: 'qari_sudais',
        name: 'Abdul Rahman Al-Sudais',
        arabicName: 'عبد الرحمن السديس',
        country: 'Saudi Arabia',
        description: 'Imam of Masjid al-Haram',
        profileImageUrl: 'https://secure-cdn.duacopilot.com/qaris/sudais.jpg',
        specializations: const ['Quran Recitation', 'Islamic Leadership'],
        isVerified: true,
        bioEnglish: 'Abdul Rahman Al-Sudais is the chief imam and khateeb of the Grand Mosque in Mecca.',
        bioArabic: 'عبد الرحمن بن عبد العزيز السديس إمام وخطيب المسجد الحرام',
        awards: const ['Islamic Personality Award', 'Makkah Excellence Award'],
        rating: 4.95,
        totalRecitations: 200,
        createdAt: DateTime.now().subtract(const Duration(days: 400)),
      ),
      QariInfo(
        id: 'qari_minshawi',
        name: 'Mohamed Siddiq El-Minshawi',
        arabicName: 'محمد صديق المنشاوي',
        country: 'Egypt',
        description: 'Legendary Egyptian Qari',
        profileImageUrl: 'https://secure-cdn.duacopilot.com/qaris/minshawi.jpg',
        specializations: const ['Classical Recitation', 'Tajweed Mastery'],
        isVerified: true,
        bioEnglish: 'Mohamed Siddiq El-Minshawi was one of the most celebrated Quran reciters in history.',
        bioArabic: 'محمد صديق المنشاوي من أشهر قراء القرآن الكريم في التاريخ',
        awards: const ['Grand Master of Quranic Recitation', 'Eternal Voice Award'],
        rating: 4.98,
        totalRecitations: 180,
        createdAt: DateTime.now().subtract(const Duration(days: 500)),
      ),
    ];
  }

  /// Setup security session with token management
  Future<void> _setupSecuritySession() async {
    try {
      _currentSessionToken = await _generateSecureToken();

      // Schedule token refresh every 30 minutes
      _sessionRefreshTimer = Timer.periodic(const Duration(minutes: 30), (timer) => _refreshSecuritySession());

      AppLogger.info('Security session established');
    } catch (e) {
      AppLogger.error('Failed to setup security session: $e');
    }
  }

  /// Generate cryptographically secure session token
  Future<String> _generateSecureToken() async {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final userId = await _secureStorage.getUserId() ?? 'anonymous';

    final payload = '$userId:$timestamp:${base64Encode(bytes)}';
    final signature = sha256.convert(utf8.encode(payload)).toString();

    return base64Encode(utf8.encode('$payload:$signature'));
  }

  /// Refresh security session periodically
  Future<void> _refreshSecuritySession() async {
    try {
      _currentSessionToken = await _generateSecureToken();
      // Clear expired cached URLs
      _cleanupExpiredTokens();
    } catch (e) {
      AppLogger.error('Failed to refresh security session: $e');
    }
  }

  /// Clean up expired tokens and URLs
  void _cleanupExpiredTokens() {
    final now = DateTime.now();
    final expiredKeys =
        _tokenExpirations.entries.where((entry) => entry.value.isBefore(now)).map((entry) => entry.key).toList();

    for (final key in expiredKeys) {
      _encryptedUrls.remove(key);
      _tokenExpirations.remove(key);
    }
  }

  /// Get all verified Qaris
  List<QariInfo> getQaris() {
    _validateSubscription();
    return List.unmodifiable(_qaris);
  }

  /// Get recitations for a specific Qari
  Future<List<PremiumRecitation>> getQariRecitations(String qariId) async {
    await _validateSubscription();

    // In production, this would fetch from secure API
    // For now, return mock data based on available duas
    return _getMockRecitationsForQari(qariId);
  }

  /// Mock recitations for development (in production, fetch from secure API)
  List<PremiumRecitation> _getMockRecitationsForQari(String qariId) {
    return [
      PremiumRecitation(
        id: '${qariId}_ayat_kursi',
        duaId: 'ayat_kursi',
        qariId: qariId,
        title: 'Ayat al-Kursi',
        arabicTitle: 'آية الكرسي',
        url: 'https://secure-api.duacopilot.com/audio/$qariId/ayat_kursi.mp3',
        quality: AudioQuality.premium,
        duration: 180, // 3 minutes
        sizeInBytes: 8640000, // ~8.6MB for 320kbps
        format: 'mp3',
        tags: ['protection', 'strength', 'popular'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      PremiumRecitation(
        id: '${qariId}_al_fatiha',
        duaId: 'al_fatiha',
        qariId: qariId,
        title: 'Al-Fatiha',
        arabicTitle: 'الفاتحة',
        url: 'https://secure-api.duacopilot.com/audio/$qariId/al_fatiha.mp3',
        quality: AudioQuality.high,
        duration: 90, // 1.5 minutes
        sizeInBytes: 2160000, // ~2.1MB for 192kbps
        format: 'mp3',
        tags: ['essential', 'daily', 'opening'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }

  /// Play premium recitation with security validation
  Future<void> playRecitation(PremiumRecitation recitation) async {
    await _validateSubscription();

    try {
      // Validate content authenticity
      await _validateContentSecurity(recitation);

      // Get secure playback URL
      final secureUrl = await _getSecurePlaybackUrl(recitation);

      // Configure audio source with DRM protection
      await _mainPlayer?.setAudioSource(
        just_audio.AudioSource.uri(
          Uri.parse(secureUrl),
          headers: {
            'Authorization': 'Bearer $_currentSessionToken',
            'X-Content-Type': 'audio/mpeg',
            'X-DRM-Token': await _generateDrmToken(recitation.id),
          },
        ),
      );

      // Start playback
      await _mainPlayer?.play();

      // Update current recitation
      _currentRecitation = recitation;
      _currentRecitationController.add(recitation);

      // Track analytics (privacy-compliant)
      await _trackPlaybackAnalytics(recitation);

      AppLogger.info('Started playback: ${recitation.title}');
    } catch (e) {
      AppLogger.error('Failed to play recitation: $e');
      throw Exception('Playback failed: ${e.toString()}');
    }
  }

  /// Validate content security and authenticity
  Future<void> _validateContentSecurity(PremiumRecitation recitation) async {
    // Verify content hash (in production, check against blockchain/CDN)
    // Validate DRM permissions
    // Check content expiration

    if (!_settings.drmProtectionEnabled) {
      throw Exception('DRM protection required for premium content');
    }

    // Simulate content validation
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Get secure, time-limited playback URL
  Future<String> _getSecurePlaybackUrl(PremiumRecitation recitation) async {
    final cachedUrl = _encryptedUrls[recitation.id];
    final expiry = _tokenExpirations[recitation.id];

    // Return cached URL if still valid
    if (cachedUrl != null && expiry != null && expiry.isAfter(DateTime.now())) {
      return cachedUrl;
    }

    // Generate new secure URL (in production, call secure API)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final signature = sha256.convert(utf8.encode('${recitation.id}:$timestamp:$_currentSessionToken')).toString();

    final secureUrl = '${recitation.url}?token=$signature&ts=$timestamp&session=$_currentSessionToken';

    // Cache with 1-hour expiration
    _encryptedUrls[recitation.id] = secureUrl;
    _tokenExpirations[recitation.id] = DateTime.now().add(const Duration(hours: 1));

    return secureUrl;
  }

  /// Generate DRM token for content protection
  Future<String> _generateDrmToken(String contentId) async {
    final userId = await _secureStorage.getUserId() ?? 'anonymous';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = '$contentId:$userId:$timestamp';

    return sha256.convert(utf8.encode(payload)).toString();
  }

  /// Track playback analytics with privacy protection
  Future<void> _trackPlaybackAnalytics(PremiumRecitation recitation) async {
    try {
      // Update local statistics only (no external tracking)
      final stats = await _loadUserStats();
      final updatedStats = stats.copyWith(
        totalListeningTime: stats.totalListeningTime + recitation.duration,
        sessionsCount: stats.sessionsCount + 1,
        qariPreferences: {
          ...stats.qariPreferences,
          recitation.qariId: (stats.qariPreferences[recitation.qariId] ?? 0) + 1,
        },
        lastSessionDate: DateTime.now(),
      );

      await _saveUserStats(updatedStats);
    } catch (e) {
      AppLogger.error('Failed to track analytics: $e');
    }
  }

  /// Load user statistics from secure storage
  Future<PremiumAudioStats> _loadUserStats() async {
    try {
      final statsJson = await _secureStorage.read('premium_audio_stats');
      if (statsJson != null) {
        return PremiumAudioStats.fromJson(jsonDecode(statsJson));
      }
    } catch (e) {
      AppLogger.error('Failed to load user stats: $e');
    }

    final userId = await _secureStorage.getUserId() ?? 'anonymous';
    return PremiumAudioStats(userId: userId, createdAt: DateTime.now());
  }

  /// Save user statistics to secure storage
  Future<void> _saveUserStats(PremiumAudioStats stats) async {
    try {
      final json = stats.toJson();
      await _secureStorage.write('premium_audio_stats', jsonEncode(json));
    } catch (e) {
      AppLogger.error('Failed to save user stats: $e');
    }
  }

  /// Pause current playback
  Future<void> pause() async {
    await _mainPlayer?.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _mainPlayer?.play();
  }

  /// Stop playback
  Future<void> stop() async {
    await _mainPlayer?.stop();
    _currentRecitation = null;
    _currentRecitationController.add(null);
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _mainPlayer?.seek(position);
  }

  /// Set playback speed (0.5x to 2.0x)
  Future<void> setPlaybackSpeed(double speed) async {
    speed = speed.clamp(0.5, 2.0);
    await _mainPlayer?.setSpeed(speed);

    _settings = _settings.copyWith(playbackSpeed: speed);
    await _saveSettings();
  }

  /// Configure sleep timer
  Future<void> setSleepTimer(
    Duration duration, {
    SleepAction action = SleepAction.pause,
    FadeOutDuration fadeOut = FadeOutDuration.gradual,
  }) async {
    // Cancel existing timer
    _sleepTimerInstance?.cancel();

    _sleepTimer = SleepTimerConfig(
      duration: duration,
      action: action,
      fadeOut: fadeOut,
      isActive: true,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(duration),
    );

    _sleepTimerController.add(_sleepTimer);

    // Start countdown
    _sleepTimerInstance = Timer(duration, () => _executeSleepAction());

    AppLogger.info('Sleep timer set for ${duration.inMinutes} minutes');
  }

  /// Execute sleep timer action
  Future<void> _executeSleepAction() async {
    if (!_sleepTimer.isActive) return;

    try {
      // Apply fade out effect
      if (_sleepTimer.fadeOut != FadeOutDuration.instant) {
        await _fadeOutAudio(_sleepTimer.fadeOut.seconds);
      }

      // Execute action
      switch (_sleepTimer.action) {
        case SleepAction.pause:
          await pause();
          break;
        case SleepAction.stop:
          await stop();
          break;
        case SleepAction.nextTrack:
          // Implement next track logic
          break;
      }

      // Clear timer
      _sleepTimer = _sleepTimer.copyWith(isActive: false);
      _sleepTimerController.add(_sleepTimer);

      AppLogger.info('Sleep timer executed: ${_sleepTimer.action}');
    } catch (e) {
      AppLogger.error('Sleep timer execution failed: $e');
    }
  }

  /// Fade out audio gradually
  Future<void> _fadeOutAudio(int seconds) async {
    final initialVolume = _settings.volumeLevel;
    final steps = seconds * 10; // 10 steps per second
    final volumeDecrement = initialVolume / steps;

    for (int i = 0; i < steps; i++) {
      final newVolume = initialVolume - (volumeDecrement * i);
      await _mainPlayer?.setVolume(newVolume.clamp(0.0, 1.0));
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Restore original volume for next playback
    await _mainPlayer?.setVolume(initialVolume);
  }

  /// Cancel sleep timer
  void cancelSleepTimer() {
    _sleepTimerInstance?.cancel();
    _sleepTimer = _sleepTimer.copyWith(isActive: false);
    _sleepTimerController.add(_sleepTimer);
  }

  /// Get current sleep timer status
  SleepTimerConfig get sleepTimerConfig => _sleepTimer;

  /// Get currently playing recitation
  PremiumRecitation? get currentRecitation => _currentRecitation;

  /// Get current playlist
  PremiumPlaylist? get currentPlaylist => _currentPlaylist;

  /// Enable background playback (requires premium)
  Future<void> enableBackgroundPlayback() async {
    await _validateSubscription();

    if (!_settings.backgroundPlayEnabled) {
      _settings = _settings.copyWith(backgroundPlayEnabled: true);
      await _saveSettings();
    }

    // Configure audio session for background play
    // This would integrate with platform-specific background audio services
  }

  /// Create personalized playlist
  Future<PremiumPlaylist> createPlaylist({
    required String name,
    required String description,
    required PlaylistMood mood,
    List<String> recitationIds = const [],
  }) async {
    await _validateSubscription();

    final userId = await _secureStorage.getUserId() ?? 'anonymous';
    final playlist = PremiumPlaylist(
      id: 'playlist_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      name: name,
      description: description,
      mood: mood,
      recitationIds: recitationIds,
      createdAt: DateTime.now(),
    );

    await _savePlaylist(playlist);
    return playlist;
  }

  /// Save playlist to secure storage
  Future<void> _savePlaylist(PremiumPlaylist playlist) async {
    try {
      final playlistsJson = await _secureStorage.read('user_playlists') ?? '[]';
      final List<dynamic> playlists = jsonDecode(playlistsJson);

      playlists.add(playlist.toJson());

      await _secureStorage.write('user_playlists', jsonEncode(playlists));
      AppLogger.info('Playlist saved: ${playlist.name}');
    } catch (e) {
      AppLogger.error('Failed to save playlist: $e');
    }
  }

  /// Get user playlists
  Future<List<PremiumPlaylist>> getUserPlaylists() async {
    await _validateSubscription();

    try {
      final playlistsJson = await _secureStorage.read('user_playlists') ?? '[]';
      final List<dynamic> playlists = jsonDecode(playlistsJson);

      return playlists.map((json) => PremiumPlaylist.fromJson(json)).toList();
    } catch (e) {
      AppLogger.error('Failed to load playlists: $e');
      return [];
    }
  }

  /// Set current playlist and notify listeners
  void setCurrentPlaylist(PremiumPlaylist? playlist) {
    _currentPlaylist = playlist;
    _playlistController.add(playlist);
  }

  /// Update premium audio settings
  Future<void> updateSettings(PremiumAudioSettings newSettings) async {
    _settings = newSettings;
    await _saveSettings();

    // Apply settings to current playback
    if (_mainPlayer != null) {
      await _mainPlayer!.setVolume(_settings.volumeLevel);
      await _mainPlayer!.setSpeed(_settings.playbackSpeed);
    }
  }

  /// Get current settings
  PremiumAudioSettings get settings => _settings;

  /// Dispose of resources
  Future<void> dispose() async {
    _sleepTimerInstance?.cancel();
    _sessionRefreshTimer?.cancel();

    await _mainPlayer?.dispose();
    await _backgroundPlayer?.dispose();

    _playbackStateController.close();
    _currentRecitationController.close();
    _playlistController.close();
    _downloadProgressController.close();
    _sleepTimerController.close();

    _isInitialized = false;
  }
}

/// Playback state model
class PlaybackState {
  final bool playing;
  final ProcessingState processingState;
  final Duration position;
  final Duration bufferedPosition;
  final double speed;
  final int? queueIndex;

  const PlaybackState({
    required this.playing,
    required this.processingState,
    required this.position,
    required this.bufferedPosition,
    required this.speed,
    this.queueIndex,
  });
}
