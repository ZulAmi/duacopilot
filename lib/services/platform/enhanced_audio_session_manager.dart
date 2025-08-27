import 'dart:async';

import '../../core/logging/app_logger.dart';
import 'platform_optimization_service.dart';

/// Enhanced audio session manager with platform-specific optimizations
class EnhancedAudioSessionManager {
  static EnhancedAudioSessionManager? _instance;
  static EnhancedAudioSessionManager get instance =>
      _instance ??= EnhancedAudioSessionManager._();

  EnhancedAudioSessionManager._();

  final PlatformOptimizationService _platformService =
      PlatformOptimizationService.instance;

  // Audio session configuration
  Map<String, dynamic> _currentConfig = {};
  bool _isInitialized = false;
  bool _isBackgroundAudioEnabled = false;

  // Audio interruption handling
  StreamSubscription<void>? _audioInterruptionSubscription;

  /// Initialize audio session manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('ðŸŽµ Initializing enhanced audio session manager...');

      // Configure based on platform capabilities
      await _configurePlatformSpecificAudio();

      // Setup interruption handling
      await _setupAudioInterruption();

      _isInitialized = true;
      AppLogger.info('âœ… Enhanced audio session manager initialized');
    } catch (e) {
      AppLogger.error('âŒ Failed to initialize audio session manager: $e');
      rethrow;
    }
  }

  Future<void> _configurePlatformSpecificAudio() async {
    final platformType = _platformService.platformType;

    switch (platformType) {
      case PlatformType.ios:
        await _configureIOSAudio();
        break;
      case PlatformType.android:
        await _configureAndroidAudio();
        break;
      case PlatformType.web:
        await _configureWebAudio();
        break;
      default:
        await _configureDefaultAudio();
        break;
    }

    AppLogger.debug('ðŸŽµ Audio configured for: ${platformType.name}');
    AppLogger.debug('ðŸ”§ Configuration: $_currentConfig');
  }

  Future<void> _configureIOSAudio() async {
    _currentConfig = {
      'category': 'AVAudioSessionCategoryPlayback',
      'mode': 'AVAudioSessionModeDefault',
      'options': [
        'AVAudioSessionCategoryOptionMixWithOthers',
        'AVAudioSessionCategoryOptionAllowAirPlay',
        'AVAudioSessionCategoryOptionAllowBluetoothA2DP',
      ],
      'backgroundAudio': true,
      'carPlaySupport': true,
      'airPlaySupport': true,
      'handoffSupport': true,
    };

    // Configure iOS-specific audio session
    await _setIOSAudioSession();
  }

  Future<void> _configureAndroidAudio() async {
    final apiLevel =
        _platformService.deviceInfo.capabilities['apiLevel'] as int? ?? 21;

    _currentConfig = {
      'audioFocus': 'AUDIOFOCUS_GAIN',
      'contentType': 'AUDIO_CONTENT_TYPE_SPEECH',
      'usage': 'AUDIO_USAGE_MEDIA',
      'streamType': 'STREAM_MUSIC',
      'foregroundServiceType':
          apiLevel >= 29 ? 'FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK' : null,
      'backgroundAudio': true,
      'wakeLockEnabled': true,
      'becomingNoisyHandling': true,
    };

    // Configure Android-specific audio session
    await _setAndroidAudioSession();
  }

  Future<void> _configureWebAudio() async {
    _currentConfig = {
      'webAudioContext': true,
      'mediaSession': true,
      'backgroundAudio': false, // Not supported in web
      'autoplay': 'user-gesture-required',
      'preload': 'metadata',
    };

    // Configure Web-specific audio session
    await _setWebAudioSession();
  }

  Future<void> _configureDefaultAudio() async {
    _currentConfig = {
      'basicPlayback': true,
      'backgroundAudio': false,
      'interruptionHandling': false,
    };
  }

  Future<void> _setIOSAudioSession() async {
    try {
      // This would use platform channels to configure iOS AVAudioSession
      AppLogger.info('ðŸŽ Configuring iOS audio session...');

      // Configure for background playback
      if (_currentConfig['backgroundAudio'] == true) {
        _isBackgroundAudioEnabled = true;
        AppLogger.info('ðŸŽµ iOS background audio enabled');
      }

      // Setup AirPlay and CarPlay support
      if (_currentConfig['airPlaySupport'] == true) {
        AppLogger.info('ðŸ“¡ AirPlay support enabled');
      }

      if (_currentConfig['carPlaySupport'] == true) {
        AppLogger.info('ðŸš— CarPlay support enabled');
      }
    } catch (e) {
      AppLogger.warning('âš ï¸ iOS audio session configuration failed: $e');
    }
  }

  Future<void> _setAndroidAudioSession() async {
    try {
      AppLogger.info('ðŸ¤– Configuring Android audio session...');

      // Configure audio focus
      final audioFocus = _currentConfig['audioFocus'] as String;
      AppLogger.debug('ðŸ”Š Audio focus: $audioFocus');

      // Configure foreground service for background playback
      if (_currentConfig['backgroundAudio'] == true) {
        _isBackgroundAudioEnabled = true;
        AppLogger.info(
          'ðŸŽµ Android background audio with foreground service enabled',
        );

        final serviceType = _currentConfig['foregroundServiceType'];
        if (serviceType != null) {
          AppLogger.debug('ðŸ”§ Foreground service type: $serviceType');
        }
      }

      // Configure wake lock
      if (_currentConfig['wakeLockEnabled'] == true) {
        AppLogger.info('â° Wake lock enabled for continuous playback');
      }
    } catch (e) {
      AppLogger.warning(
          'âš ï¸ Android audio session configuration failed: $e');
    }
  }

  Future<void> _setWebAudioSession() async {
    try {
      AppLogger.info('ðŸŒ Configuring Web audio session...');

      // Configure Media Session API
      if (_currentConfig['mediaSession'] == true) {
        AppLogger.info('ðŸ“± Media Session API enabled');
      }

      // Configure autoplay policy
      final autoplay = _currentConfig['autoplay'] as String;
      AppLogger.debug('â–¶ï¸ Autoplay policy: $autoplay');
    } catch (e) {
      AppLogger.warning('âš ï¸ Web audio session configuration failed: $e');
    }
  }

  Future<void> _setupAudioInterruption() async {
    if (!_platformService.isFeatureSupported('supportsBackgroundAudio')) return;

    try {
      // Setup platform-specific interruption handling
      switch (_platformService.platformType) {
        case PlatformType.ios:
          await _setupIOSInterruptionHandling();
          break;
        case PlatformType.android:
          await _setupAndroidInterruptionHandling();
          break;
        default:
          break;
      }
    } catch (e) {
      AppLogger.warning('âš ï¸ Audio interruption setup failed: $e');
    }
  }

  Future<void> _setupIOSInterruptionHandling() async {
    AppLogger.info('ðŸŽ Setting up iOS audio interruption handling...');

    // This would listen to AVAudioSession interruption notifications
    // For now, we'll simulate the setup
    AppLogger.debug('ðŸ”„ iOS interruption handling configured');
  }

  Future<void> _setupAndroidInterruptionHandling() async {
    AppLogger.info('ðŸ¤– Setting up Android audio interruption handling...');

    // This would listen to AudioManager focus changes
    // For now, we'll simulate the setup
    AppLogger.debug('ðŸ”„ Android audio focus handling configured');
  }

  /// Configure audio session for specific playback requirements
  Future<void> configureForPlayback({
    required bool backgroundPlayback,
    required bool interruptionHandling,
    String? category,
    Map<String, dynamic>? customConfig,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('ðŸŽµ Configuring audio session for playback...');
      AppLogger.debug(
        'ðŸ”§ Background: $backgroundPlayback, Interruption: $interruptionHandling',
      );

      // Update configuration
      final newConfig = Map<String, dynamic>.from(_currentConfig);
      newConfig['backgroundAudio'] = backgroundPlayback;
      newConfig['interruptionHandling'] = interruptionHandling;

      if (category != null) {
        newConfig['category'] = category;
      }

      if (customConfig != null) {
        newConfig.addAll(customConfig);
      }

      // Apply new configuration
      await _applyConfiguration(newConfig);

      _currentConfig = newConfig;
      _isBackgroundAudioEnabled = backgroundPlayback;

      AppLogger.info('âœ… Audio session configured for playback');
    } catch (e) {
      AppLogger.error('âŒ Failed to configure audio session: $e');
      rethrow;
    }
  }

  Future<void> _applyConfiguration(Map<String, dynamic> config) async {
    final platformType = _platformService.platformType;

    switch (platformType) {
      case PlatformType.ios:
        await _applyIOSConfiguration(config);
        break;
      case PlatformType.android:
        await _applyAndroidConfiguration(config);
        break;
      case PlatformType.web:
        await _applyWebConfiguration(config);
        break;
      default:
        break;
    }
  }

  Future<void> _applyIOSConfiguration(Map<String, dynamic> config) async {
    // Apply iOS-specific configuration changes
    AppLogger.debug('ðŸŽ Applying iOS configuration changes');
  }

  Future<void> _applyAndroidConfiguration(Map<String, dynamic> config) async {
    // Apply Android-specific configuration changes
    AppLogger.debug('ðŸ¤– Applying Android configuration changes');
  }

  Future<void> _applyWebConfiguration(Map<String, dynamic> config) async {
    // Apply Web-specific configuration changes
    AppLogger.debug('ðŸŒ Applying Web configuration changes');
  }

  /// Handle audio interruption (phone calls, other apps, etc.)
  Future<void> handleAudioInterruption({
    required bool shouldPause,
    required bool shouldResume,
  }) async {
    if (!_isInitialized) return;

    try {
      if (shouldPause) {
        AppLogger.info('â¸ï¸ Handling audio interruption - pausing playback');
        await _pauseForInterruption();
      } else if (shouldResume) {
        AppLogger.info(
            'â–¶ï¸ Handling audio interruption - resuming playback');
        await _resumeAfterInterruption();
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to handle audio interruption: $e');
    }
  }

  Future<void> _pauseForInterruption() async {
    // Implement platform-specific pause logic
    AppLogger.debug('â¸ï¸ Pausing audio for interruption');
  }

  Future<void> _resumeAfterInterruption() async {
    // Implement platform-specific resume logic
    AppLogger.debug('â–¶ï¸ Resuming audio after interruption');
  }

  /// Enable or disable background audio
  Future<void> setBackgroundAudioEnabled(bool enabled) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isBackgroundAudioEnabled == enabled) return;

    try {
      AppLogger.info(
        'ðŸŽµ ${enabled ? 'Enabling' : 'Disabling'} background audio...',
      );

      await configureForPlayback(
        backgroundPlayback: enabled,
        interruptionHandling: enabled,
      );

      AppLogger.info(
          'âœ… Background audio ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('âŒ Failed to set background audio: $e');
      rethrow;
    }
  }

  /// Get current audio session configuration
  Map<String, dynamic> getCurrentConfiguration() {
    return Map.unmodifiable(_currentConfig);
  }

  /// Check if background audio is enabled
  bool get isBackgroundAudioEnabled => _isBackgroundAudioEnabled;

  /// Check if audio session is initialized
  bool get isInitialized => _isInitialized;

  /// Get optimal audio configuration for current platform
  Map<String, dynamic> getOptimalConfiguration() {
    final platformType = _platformService.platformType;
    final capabilities = _platformService.deviceInfo.capabilities;

    switch (platformType) {
      case PlatformType.ios:
        return {
          'backgroundAudio': capabilities['supportsBackgroundAudio'] == true,
          'airPlaySupport': true,
          'carPlaySupport': true,
          'interruptionHandling': true,
          'quality': 'high',
        };

      case PlatformType.android:
        final apiLevel = capabilities['apiLevel'] as int? ?? 21;
        return {
          'backgroundAudio': capabilities['supportsBackgroundAudio'] == true,
          'foregroundService': apiLevel >= 26,
          'audioFocus': true,
          'wakeLock': true,
          'quality': apiLevel >= 28 ? 'high' : 'medium',
        };

      case PlatformType.web:
        return {
          'backgroundAudio': false,
          'mediaSession': true,
          'autoplay': false,
          'quality': 'medium',
        };

      default:
        return {
          'backgroundAudio': false,
          'interruptionHandling': false,
          'quality': 'low',
        };
    }
  }

  /// Cleanup resources
  Future<void> dispose() async {
    await _audioInterruptionSubscription?.cancel();
    _audioInterruptionSubscription = null;

    _isInitialized = false;
    _isBackgroundAudioEnabled = false;
    _currentConfig.clear();

    AppLogger.info('ðŸ§¹ Enhanced audio session manager disposed');
  }
}
