import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/dua_entity.dart';

/// Platform types
enum PlatformType { ios, android, web, windows, macos, linux, fuchsia, unknown }

/// Device information wrapper
class DeviceInfo {
  final String model;
  final String version;
  final String identifier;
  final Map<String, dynamic> capabilities;

  DeviceInfo({
    required this.model,
    required this.version,
    required this.identifier,
    required this.capabilities,
  });
}

/// Notification priority levels
enum NotificationPriority { low, normal, high, urgent }

/// Share targets
enum ShareTarget { system, whatsapp, telegram, email, copy }

/// Background task priority
enum BackgroundTaskPriority { low, normal, high, urgent }

/// Comprehensive platform-specific optimization service
/// Handles iOS/Android differences in Flutter RAG integration
class PlatformOptimizationService {
  static PlatformOptimizationService? _instance;
  static PlatformOptimizationService get instance => _instance ??= PlatformOptimizationService._();

  PlatformOptimizationService._();

  // Platform detection
  late final PlatformType _platformType;
  late final DeviceInfo _deviceInfo;
  late final PackageInfo _packageInfo;

  // Platform-specific configurations
  final Map<String, dynamic> _platformConfig = {};
  bool _isInitialized = false;

  // Service instances
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final QuickActions _quickActions = const QuickActions();
  final AppLinks _appLinks = AppLinks();

  /// Initialize platform-specific optimizations
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🚀 Initializing platform-specific optimizations...');

      // Detect platform
      _platformType = _detectPlatform();
      AppLogger.info('📱 Platform detected: ${_platformType.name}');

      // Get device and app info
      await _initializeDeviceInfo();
      await _initializePackageInfo();

      // Initialize platform-specific services
      await _initializePlatformServices();

      // Load platform-specific configuration
      await _loadPlatformConfiguration();

      _isInitialized = true;
      AppLogger.info('✅ Platform optimization service initialized');
    } catch (e) {
      AppLogger.error(
        '❌ Failed to initialize platform optimization service: $e',
      );
      rethrow;
    }
  }

  PlatformType _detectPlatform() {
    if (kIsWeb) return PlatformType.web;
    if (Platform.isIOS) return PlatformType.ios;
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isMacOS) return PlatformType.macos;
    if (Platform.isLinux) return PlatformType.linux;
    if (Platform.isFuchsia) return PlatformType.fuchsia;
    return PlatformType.unknown;
  }

  Future<void> _initializeDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> capabilities = {};
    String model = 'Unknown';
    String version = 'Unknown';
    String identifier = 'Unknown';

    switch (_platformType) {
      case PlatformType.ios:
        final iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.model;
        version = iosInfo.systemVersion;
        identifier = iosInfo.identifierForVendor ?? 'Unknown';
        capabilities = {
          'supportsBackgroundAudio': true,
          'supportsShortcuts': true,
          'supportsWidgets': true,
          'supportsNotifications': true,
          'supportsDeepLinking': true,
          'backgroundTaskLimit': 30, // seconds
          'maxConcurrentTasks': 3,
        };
        break;

      case PlatformType.android:
        final androidInfo = await deviceInfoPlugin.androidInfo;
        model = androidInfo.model;
        version = androidInfo.version.release;
        identifier = androidInfo.id;
        capabilities = {
          'supportsBackgroundAudio': true,
          'supportsShortcuts': androidInfo.version.sdkInt >= 25,
          'supportsWidgets': androidInfo.version.sdkInt >= 26,
          'supportsNotifications': true,
          'supportsDeepLinking': true,
          'backgroundTaskLimit': -1, // unlimited with foreground service
          'maxConcurrentTasks': 5,
          'apiLevel': androidInfo.version.sdkInt,
        };
        break;

      case PlatformType.web:
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        model = '${webInfo.browserName} ${webInfo.platform}';
        version = webInfo.appVersion ?? 'Unknown';
        identifier = webInfo.vendor ?? 'Unknown';
        capabilities = {
          'supportsBackgroundAudio': false,
          'supportsShortcuts': false,
          'supportsWidgets': false,
          'supportsNotifications': true,
          'supportsDeepLinking': true,
          'backgroundTaskLimit': 0,
          'maxConcurrentTasks': 2,
        };
        break;

      default:
        capabilities = {
          'supportsBackgroundAudio': false,
          'supportsShortcuts': false,
          'supportsWidgets': false,
          'supportsNotifications': false,
          'supportsDeepLinking': false,
          'backgroundTaskLimit': 0,
          'maxConcurrentTasks': 1,
        };
        break;
    }

    _deviceInfo = DeviceInfo(
      model: model,
      version: version,
      identifier: identifier,
      capabilities: capabilities,
    );

    AppLogger.info('📱 Device: ${_deviceInfo.model} (${_deviceInfo.version})');
    AppLogger.debug('🛠 Capabilities: ${_deviceInfo.capabilities}');
  }

  Future<void> _initializePackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    AppLogger.info(
      '📦 App: ${_packageInfo.appName} v${_packageInfo.version}+${_packageInfo.buildNumber}',
    );
  }

  Future<void> _initializePlatformServices() async {
    await _initializeNotifications();
    await _initializeQuickActions();
    await _initializeDeepLinking();
  }

  Future<void> _initializeNotifications() async {
    if (!isFeatureSupported('supportsNotifications')) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);
    AppLogger.info('🔔 Notifications initialized');
  }

  Future<void> _initializeQuickActions() async {
    if (!isFeatureSupported('supportsShortcuts')) return;

    try {
      // Initialize with default shortcuts
      _quickActions.initialize((type) {
        AppLogger.info('🚀 Quick action triggered: $type');
        // Handle quick action
      });

      AppLogger.info('⚡ Quick actions initialized');
    } catch (e) {
      AppLogger.warning('⚠️ Quick actions not available: $e');
    }
  }

  Future<void> _initializeDeepLinking() async {
    if (!isFeatureSupported('supportsDeepLinking')) return;

    // Listen for incoming links
    _appLinks.uriLinkStream.listen((Uri uri) {
      AppLogger.info('🔗 Deep link received: $uri');
      _handleDeepLink(uri.toString());
    });

    AppLogger.info('🔗 Deep linking initialized');
  }

  Future<void> _loadPlatformConfiguration() async {
    _platformConfig.addAll({
      'audio': _getAudioConfiguration(),
      'notifications': _getNotificationConfiguration(),
      'shortcuts': _getShortcutConfiguration(),
      'sharing': _getSharingConfiguration(),
      'background': _getBackgroundConfiguration(),
      'deepLinking': _getDeepLinkingConfiguration(),
    });

    AppLogger.debug(
      '⚙️ Platform configuration loaded: ${_platformConfig.keys.join(', ')}',
    );
  }

  Map<String, dynamic> _getAudioConfiguration() {
    switch (_platformType) {
      case PlatformType.ios:
        return {
          'category': 'playback',
          'mode': 'defaultMode',
          'enableBackgroundAudio': true,
          'enableAirPlay': true,
          'enableCarPlay': true,
          'interruptionHandling': true,
        };
      case PlatformType.android:
        return {
          'audioFocus': 'audiofocusGain',
          'contentType': 'speech',
          'usage': 'media',
          'enableBackgroundAudio': true,
          'foregroundServiceType': 'mediaPlayback',
        };
      default:
        return {'enableBackgroundAudio': false, 'interruptionHandling': false};
    }
  }

  Map<String, dynamic> _getNotificationConfiguration() {
    switch (_platformType) {
      case PlatformType.ios:
        return {
          'channels': ['general', 'dua_reminders', 'prayer_times'],
          'sounds': true,
          'badges': true,
          'alerts': true,
          'criticalAlerts': false,
        };
      case PlatformType.android:
        final apiLevel = _deviceInfo.capabilities['apiLevel'] as int? ?? 21;
        return {
          'channels': ['general', 'dua_reminders', 'prayer_times'],
          'bigText': apiLevel >= 16,
          'expandableNotifications': apiLevel >= 16,
          'channelGroups': apiLevel >= 26,
          'notificationStyles': apiLevel >= 24,
        };
      default:
        return {
          'channels': ['general'],
          'webPushSupport': _platformType == PlatformType.web,
        };
    }
  }

  Map<String, dynamic> _getShortcutConfiguration() {
    if (!isFeatureSupported('supportsShortcuts')) {
      return {'enabled': false};
    }

    return {
      'enabled': true,
      'maxShortcuts': _platformType == PlatformType.ios ? 4 : 5,
      'types': ['search_dua', 'favorite_duas', 'prayer_times', 'qibla'],
    };
  }

  Map<String, dynamic> _getSharingConfiguration() {
    return {
      'arabicTextSupport': true,
      'rightToLeftSupport': true,
      'platforms': {
        'whatsapp': true,
        'telegram': _platformType != PlatformType.ios,
        'email': true,
        'copy': true,
        'system': true,
      },
      'formatOptions': {
        'includeTranslation': true,
        'includeTransliteration': true,
        'includeAudio': _platformType != PlatformType.web,
      },
    };
  }

  Map<String, dynamic> _getBackgroundConfiguration() {
    switch (_platformType) {
      case PlatformType.ios:
        return {
          'backgroundRefresh': true,
          'backgroundProcessing': true,
          'timeLimit': 30,
          'backgroundModes': ['background-audio', 'background-processing'],
        };
      case PlatformType.android:
        return {
          'foregroundService': true,
          'wakeLocks': true,
          'workManager': true,
          'dozeOptimization': true,
        };
      default:
        return {
          'webWorkers': _platformType == PlatformType.web,
          'serviceWorkers': _platformType == PlatformType.web,
        };
    }
  }

  Map<String, dynamic> _getDeepLinkingConfiguration() {
    return {
      'schemes': ['duacopilot', 'https'],
      'hosts': ['duacopilot.app', 'www.duacopilot.app'],
      'pathPatterns': ['/dua/{id}', '/search/{query}', '/share/{type}'],
    };
  }

  // Public API methods

  /// Get platform type
  PlatformType get platformType => _platformType;

  /// Get device information
  DeviceInfo get deviceInfo => _deviceInfo;

  /// Get package information
  PackageInfo get packageInfo => _packageInfo;

  /// Get platform configuration
  Map<String, dynamic> get platformConfig => Map.unmodifiable(_platformConfig);

  /// Check if feature is supported
  bool isFeatureSupported(String feature) {
    return _deviceInfo.capabilities[feature] == true;
  }

  /// Configure audio session for optimal playback
  Future<void> configureAudioSession({
    required bool backgroundPlayback,
    required bool interruptionHandling,
    String category = 'playback',
  }) async {
    if (!isFeatureSupported('supportsBackgroundAudio')) return;

    // This would integrate with audio_service for actual implementation
    AppLogger.info(
      '🎵 Audio session configured: background=$backgroundPlayback',
    );
  }

  /// Show platform-optimized notification
  Future<void> showOptimizedNotification({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    if (!isFeatureSupported('supportsNotifications')) return;

    const androidDetails = AndroidNotificationDetails(
      'dua_channel',
      'Du\'a Notifications',
      channelDescription: 'Notifications for Du\'a reminders and updates',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );

    AppLogger.info('🔔 Notification shown: $title');
  }

  /// Setup quick actions/shortcuts
  Future<void> setupQuickActions(List<DuaEntity> favoritesDuas) async {
    if (!isFeatureSupported('supportsShortcuts')) return;

    try {
      final shortcutItems = <ShortcutItem>[
        const ShortcutItem(
          type: 'search_dua',
          localizedTitle: 'Search Du\'a',
          icon: 'ic_search',
        ),
        const ShortcutItem(
          type: 'favorite_duas',
          localizedTitle: 'Favorite Du\'as',
          icon: 'ic_favorite',
        ),
        const ShortcutItem(
          type: 'prayer_times',
          localizedTitle: 'Prayer Times',
          icon: 'ic_prayer',
        ),
        const ShortcutItem(
          type: 'qibla',
          localizedTitle: 'Qibla Direction',
          icon: 'ic_qibla',
        ),
      ];

      await _quickActions.setShortcutItems(shortcutItems);
      AppLogger.info(
        '⚡ Quick actions setup with ${shortcutItems.length} items',
      );
    } catch (e) {
      AppLogger.warning('⚠️ Failed to setup quick actions: $e');
    }
  }

  /// Share Du'a with platform-specific optimizations
  Future<void> shareOptimized({
    required DuaEntity dua,
    String? customMessage,
    ShareTarget target = ShareTarget.system,
  }) async {
    final shareText = _formatDuaForSharing(dua, customMessage);

    switch (target) {
      case ShareTarget.whatsapp:
        await _shareToWhatsApp(shareText);
        break;
      case ShareTarget.telegram:
        await _shareToTelegram(shareText);
        break;
      case ShareTarget.email:
        await _shareToEmail(shareText, dua);
        break;
      case ShareTarget.copy:
        await Clipboard.setData(ClipboardData(text: shareText));
        break;
      case ShareTarget.system:
        await Share.share(shareText);
        break;
    }

    AppLogger.info('💬 Du\'a shared via ${target.name}');
  }

  String _formatDuaForSharing(DuaEntity dua, String? customMessage) {
    final buffer = StringBuffer();

    if (customMessage != null) {
      buffer.writeln(customMessage);
      buffer.writeln();
    }

    buffer.writeln('🤲 ${dua.category}');
    buffer.writeln();

    if (dua.arabicText.isNotEmpty) {
      buffer.writeln('📖 ${dua.arabicText}');
      buffer.writeln();
    }

    if (dua.translation.isNotEmpty) {
      buffer.writeln('🔍 ${dua.translation}');
      buffer.writeln();
    }

    if (dua.transliteration.isNotEmpty) {
      buffer.writeln('🗣️ ${dua.transliteration}');
      buffer.writeln();
    }

    buffer.writeln('📱 Shared from DuaCopilot - Islamic AI Assistant');

    return buffer.toString();
  }

  Future<void> _shareToWhatsApp(String text) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final whatsappUrl = 'whatsapp://send?text=$encodedText';

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        await Share.share(text);
      }
    } catch (e) {
      await Share.share(text);
    }
  }

  Future<void> _shareToTelegram(String text) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final telegramUrl = 'tg://msg?text=$encodedText';

      if (await canLaunchUrl(Uri.parse(telegramUrl))) {
        await launchUrl(Uri.parse(telegramUrl));
      } else {
        await Share.share(text);
      }
    } catch (e) {
      await Share.share(text);
    }
  }

  Future<void> _shareToEmail(String text, DuaEntity dua) async {
    try {
      final subject = Uri.encodeComponent('Du\'a: ${dua.category}');
      final body = Uri.encodeComponent(text);
      final emailUrl = 'mailto:?subject=$subject&body=$body';

      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
      } else {
        await Share.share(text);
      }
    } catch (e) {
      await Share.share(text);
    }
  }

  /// Handle deep link
  Future<void> _handleDeepLink(String url) async {
    AppLogger.info('🔗 Processing deep link: $url');

    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) return;

    switch (pathSegments.first) {
      case 'dua':
        if (pathSegments.length > 1) {
          final duaId = pathSegments[1];
          AppLogger.info('📖 Opening Du\'a: $duaId');
          // Navigate to specific dua
        }
        break;
      case 'search':
        if (pathSegments.length > 1) {
          final query = pathSegments[1];
          AppLogger.info('🔍 Searching for: $query');
          // Perform search
        }
        break;
      case 'share':
        if (pathSegments.length > 1) {
          final shareType = pathSegments[1];
          AppLogger.info('💬 Opening share type: $shareType');
          // Handle shared content
        }
        break;
    }
  }

  /// Get memory optimization recommendations
  Map<String, dynamic> getMemoryOptimizations() {
    final recommendations = <String, dynamic>{};

    switch (_platformType) {
      case PlatformType.ios:
        recommendations['maxCacheSize'] = '100MB';
        recommendations['preloadLimit'] = 5;
        recommendations['compressionLevel'] = 0.8;
        break;

      case PlatformType.android:
        final apiLevel = _deviceInfo.capabilities['apiLevel'] as int? ?? 21;
        recommendations['maxCacheSize'] = apiLevel >= 26 ? '150MB' : '80MB';
        recommendations['preloadLimit'] = apiLevel >= 28 ? 8 : 5;
        recommendations['compressionLevel'] = 0.7;
        break;

      case PlatformType.web:
        recommendations['maxCacheSize'] = '50MB';
        recommendations['preloadLimit'] = 3;
        recommendations['compressionLevel'] = 0.9;
        break;

      default:
        recommendations['maxCacheSize'] = '200MB';
        recommendations['preloadLimit'] = 10;
        recommendations['compressionLevel'] = 0.6;
        break;
    }

    return recommendations;
  }

  /// Get network optimization settings
  Map<String, dynamic> getNetworkOptimizations() {
    final optimizations = <String, dynamic>{};

    switch (_platformType) {
      case PlatformType.ios:
        optimizations['timeout'] = 30000;
        optimizations['retries'] = 3;
        optimizations['concurrentConnections'] = 4;
        optimizations['compressionEnabled'] = true;
        break;

      case PlatformType.android:
        optimizations['timeout'] = 25000;
        optimizations['retries'] = 5;
        optimizations['concurrentConnections'] = 6;
        optimizations['compressionEnabled'] = true;
        break;

      case PlatformType.web:
        optimizations['timeout'] = 20000;
        optimizations['retries'] = 2;
        optimizations['concurrentConnections'] = 2;
        optimizations['compressionEnabled'] = false; // Browser handles it
        break;

      default:
        optimizations['timeout'] = 35000;
        optimizations['retries'] = 3;
        optimizations['concurrentConnections'] = 8;
        optimizations['compressionEnabled'] = true;
        break;
    }

    return optimizations;
  }

  /// Cleanup resources
  Future<void> dispose() async {
    _isInitialized = false;
    AppLogger.info('🧹 Platform optimization service disposed');
  }
}
