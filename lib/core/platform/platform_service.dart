import 'dart:io';

import 'package:flutter/foundation.dart';

/// Comprehensive platform detection and capability management service
class PlatformService {
  static PlatformService? _instance;
  static PlatformService get instance => _instance ??= PlatformService._();

  PlatformService._();

  // Platform Detection
  bool get isMobile => Platform.isAndroid || Platform.isIOS;
  bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;
  bool get isWindows => Platform.isWindows;
  bool get isMacOS => Platform.isMacOS;
  bool get isLinux => Platform.isLinux;
  bool get isWeb => kIsWeb;

  // Feature Capabilities
  bool get supportsSecureStorage => isMobile && !isWeb;
  bool get supportsAds => isMobile && !isWeb;
  bool get supportsSpeechToText => isMobile || isDesktop;
  bool get supportsVibration => isMobile;
  bool get supportsSensors => isMobile;
  bool get supportsLocation => isMobile || isDesktop;
  bool get supportsNotifications => !isWeb;
  bool get supportsBackgroundTasks => isMobile;
  bool get supportsCalendar => isMobile || isDesktop;
  bool get supportsQuickActions => isMobile;
  bool get supportsAppLinks => !isWeb;
  bool get supportsAudio => true; // All platforms support audio
  // Firebase removed
  bool get supportsFirebase => false;
  bool get supportsCaching => true; // All platforms support caching

  // Storage Capabilities
  bool get prefersSqlite => isDesktop || isMobile;
  bool get prefersHive => isWeb || isDesktop;
  bool get supportsFileSystem => !isWeb;

  // Network Capabilities
  bool get supportsRealTimeFeatures => true; // All platforms
  bool get supportsWebSockets => true; // All platforms

  // Development Helpers
  String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWindows) return 'Windows';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  List<String> get availableFeatures {
    final features = <String>[];

    if (supportsSecureStorage) features.add('Secure Storage');
    if (supportsAds) features.add('Google Mobile Ads');
    if (supportsSpeechToText) features.add('Speech to Text');
    if (supportsVibration) features.add('Vibration');
    if (supportsSensors) features.add('Sensors');
    if (supportsLocation) features.add('Location Services');
    if (supportsNotifications) features.add('Local Notifications');
    if (supportsBackgroundTasks) features.add('Background Tasks');
    if (supportsCalendar) features.add('Device Calendar');
    if (supportsQuickActions) features.add('Quick Actions');
    if (supportsAppLinks) features.add('App Links');
    // Firebase removed
    features.add('Audio Playback');
    features.add('Caching');

    return features;
  }

  Map<String, dynamic> get platformInfo => {
        'platform': platformName,
        'isMobile': isMobile,
        'isDesktop': isDesktop,
        'isWeb': isWeb,
        'features': availableFeatures,
        'storage': {
          'secure': supportsSecureStorage,
          'sqlite': prefersSqlite,
          'hive': prefersHive,
          'filesystem': supportsFileSystem,
        },
        'capabilities': {
          'ads': supportsAds,
          'speech': supportsSpeechToText,
          'vibration': supportsVibration,
          'sensors': supportsSensors,
          'location': supportsLocation,
          'notifications': supportsNotifications,
          'background': supportsBackgroundTasks,
          'calendar': supportsCalendar,
          'quickActions': supportsQuickActions,
          'appLinks': supportsAppLinks,
        },
      };

  /// Initialize platform-specific services
  Future<void> initialize() async {
    if (kDebugMode) {
      print('ðŸš€ PlatformService initialized for $platformName');
      print('ðŸ“± Available features: ${availableFeatures.join(', ')}');
    }
  }

  /// Check if a specific feature is available
  bool hasFeature(String feature) {
    switch (feature.toLowerCase()) {
      case 'secure_storage':
        return supportsSecureStorage;
      case 'ads':
      case 'google_mobile_ads':
        return supportsAds;
      case 'speech_to_text':
      case 'speech':
        return supportsSpeechToText;
      case 'vibration':
        return supportsVibration;
      case 'sensors':
        return supportsSensors;
      case 'location':
      case 'geolocator':
        return supportsLocation;
      case 'notifications':
        return supportsNotifications;
      case 'background_tasks':
      case 'workmanager':
        return supportsBackgroundTasks;
      case 'calendar':
        return supportsCalendar;
      case 'quick_actions':
        return supportsQuickActions;
      case 'app_links':
        return supportsAppLinks;
      case 'audio':
        return supportsAudio;
      case 'firebase':
        return false; // Firebase removed
      case 'caching':
        return supportsCaching;
      default:
        return false;
    }
  }

  /// Get platform-specific configuration
  T getPlatformConfig<T>({
    T? mobile,
    T? desktop,
    T? web,
    T? android,
    T? ios,
    T? windows,
    T? macos,
    T? linux,
    required T fallback,
  }) {
    if (isWeb && web != null) return web;
    if (isAndroid && android != null) return android;
    if (isIOS && ios != null) return ios;
    if (isWindows && windows != null) return windows;
    if (isMacOS && macos != null) return macos;
    if (isLinux && linux != null) return linux;
    if (isMobile && mobile != null) return mobile;
    if (isDesktop && desktop != null) return desktop;
    return fallback;
  }

  /// Execute platform-specific code
  Future<T?> runPlatformSpecific<T>({
    Future<T> Function()? mobile,
    Future<T> Function()? desktop,
    Future<T> Function()? web,
    Future<T> Function()? android,
    Future<T> Function()? ios,
    Future<T> Function()? windows,
    Future<T> Function()? macos,
    Future<T> Function()? linux,
  }) async {
    try {
      if (isWeb && web != null) return await web();
      if (isAndroid && android != null) return await android();
      if (isIOS && ios != null) return await ios();
      if (isWindows && windows != null) return await windows();
      if (isMacOS && macos != null) return await macos();
      if (isLinux && linux != null) return await linux();
      if (isMobile && mobile != null) return await mobile();
      if (isDesktop && desktop != null) return await desktop();
    } catch (e) {
      if (kDebugMode) {
        print('âŒ Platform-specific execution failed: $e');
      }
    }
    return null;
  }
}
