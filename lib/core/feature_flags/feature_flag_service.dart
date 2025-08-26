// lib/core/feature_flags/feature_flag_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../monitoring/production_analytics.dart';
import '../monitoring/production_crash_reporter.dart';

/// Feature Flag Keys
class FeatureFlags {
  static const String ragSystemEnabled = 'rag_system_enabled';
  static const String ragVectorSearch = 'rag_vector_search_enabled';
  static const String ragSemanticCache = 'rag_semantic_cache_enabled';
  static const String ragResponseStreaming = 'rag_response_streaming_enabled';
  static const String ragMultiLanguage = 'rag_multi_language_enabled';
  static const String ragOfflineMode = 'rag_offline_mode_enabled';
  static const String ragAdvancedFiltering = 'rag_advanced_filtering_enabled';
  static const String ragPremiumFeatures = 'rag_premium_features_enabled';
  static const String ragPerformanceMode = 'rag_performance_mode_enabled';
  static const String ragBetaFeatures = 'rag_beta_features_enabled';

  // Non-RAG feature flags
  static const String pushNotifications = 'push_notifications_enabled';
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';
  static const String performanceMonitoringEnabled =
      'performance_monitoring_enabled';
  static const String maintenanceMode = 'maintenance_mode';
  static const String forceUpdate = 'force_update_required';
}

/// Feature Flag Configuration
class FeatureFlagConfig {
  final bool ragSystemEnabled;
  final bool ragVectorSearch;
  final bool ragSemanticCache;
  final bool ragResponseStreaming;
  final bool ragMultiLanguage;
  final bool ragOfflineMode;
  final bool ragAdvancedFiltering;
  final bool ragPremiumFeatures;
  final bool ragPerformanceMode;
  final bool ragBetaFeatures;
  final bool pushNotifications;
  final bool analyticsEnabled;
  final bool crashReportingEnabled;
  final bool performanceMonitoringEnabled;
  final bool maintenanceMode;
  final bool forceUpdate;
  final Map<String, dynamic> customConfig;

  const FeatureFlagConfig({
    required this.ragSystemEnabled,
    required this.ragVectorSearch,
    required this.ragSemanticCache,
    required this.ragResponseStreaming,
    required this.ragMultiLanguage,
    required this.ragOfflineMode,
    required this.ragAdvancedFiltering,
    required this.ragPremiumFeatures,
    required this.ragPerformanceMode,
    required this.ragBetaFeatures,
    required this.pushNotifications,
    required this.analyticsEnabled,
    required this.crashReportingEnabled,
    required this.performanceMonitoringEnabled,
    required this.maintenanceMode,
    required this.forceUpdate,
    required this.customConfig,
  });

  factory FeatureFlagConfig.fromRemoteConfig(
    FirebaseRemoteConfig remoteConfig,
  ) {
    return FeatureFlagConfig(
      ragSystemEnabled: remoteConfig.getBool(FeatureFlags.ragSystemEnabled),
      ragVectorSearch: remoteConfig.getBool(FeatureFlags.ragVectorSearch),
      ragSemanticCache: remoteConfig.getBool(FeatureFlags.ragSemanticCache),
      ragResponseStreaming: remoteConfig.getBool(
        FeatureFlags.ragResponseStreaming,
      ),
      ragMultiLanguage: remoteConfig.getBool(FeatureFlags.ragMultiLanguage),
      ragOfflineMode: remoteConfig.getBool(FeatureFlags.ragOfflineMode),
      ragAdvancedFiltering: remoteConfig.getBool(
        FeatureFlags.ragAdvancedFiltering,
      ),
      ragPremiumFeatures: remoteConfig.getBool(FeatureFlags.ragPremiumFeatures),
      ragPerformanceMode: remoteConfig.getBool(FeatureFlags.ragPerformanceMode),
      ragBetaFeatures: remoteConfig.getBool(FeatureFlags.ragBetaFeatures),
      pushNotifications: remoteConfig.getBool(FeatureFlags.pushNotifications),
      analyticsEnabled: remoteConfig.getBool(FeatureFlags.analyticsEnabled),
      crashReportingEnabled: remoteConfig.getBool(
        FeatureFlags.crashReportingEnabled,
      ),
      performanceMonitoringEnabled: remoteConfig.getBool(
        FeatureFlags.performanceMonitoringEnabled,
      ),
      maintenanceMode: remoteConfig.getBool(FeatureFlags.maintenanceMode),
      forceUpdate: remoteConfig.getBool(FeatureFlags.forceUpdate),
      customConfig: _parseCustomConfig(remoteConfig),
    );
  }

  static Map<String, dynamic> _parseCustomConfig(
    FirebaseRemoteConfig remoteConfig,
  ) {
    try {
      final customConfigJson = remoteConfig.getString('custom_config');
      if (customConfigJson.isNotEmpty) {
        return json.decode(customConfigJson) as Map<String, dynamic>;
      }
    } catch (e) {
      // Log error but don't crash
    }
    return {};
  }

  /// Check if RAG system should be available
  bool get isRagAvailable => ragSystemEnabled;

  /// Check if specific RAG feature is enabled
  bool isRagFeatureEnabled(String feature) {
    switch (feature) {
      case 'vector_search':
        return ragSystemEnabled && ragVectorSearch;
      case 'semantic_cache':
        return ragSystemEnabled && ragSemanticCache;
      case 'response_streaming':
        return ragSystemEnabled && ragResponseStreaming;
      case 'multi_language':
        return ragSystemEnabled && ragMultiLanguage;
      case 'offline_mode':
        return ragSystemEnabled && ragOfflineMode;
      case 'advanced_filtering':
        return ragSystemEnabled && ragAdvancedFiltering;
      case 'premium_features':
        return ragSystemEnabled && ragPremiumFeatures;
      case 'performance_mode':
        return ragSystemEnabled && ragPerformanceMode;
      case 'beta_features':
        return ragSystemEnabled && ragBetaFeatures;
      default:
        return false;
    }
  }

  @override
  String toString() =>
      'FeatureFlagConfig(ragSystemEnabled: $ragSystemEnabled, '
      'ragFeatures: {vectorSearch: $ragVectorSearch, semanticCache: $ragSemanticCache}, '
      'maintenanceMode: $maintenanceMode, forceUpdate: $forceUpdate)';
}

/// Production-Ready Feature Flag Service
class FeatureFlagService {
  static const String _cacheKey = 'feature_flags_cache';
  static const Duration _cacheDuration = Duration(hours: 1);
  static const Duration _fetchTimeout = Duration(seconds: 10);

  final FirebaseRemoteConfig _remoteConfig;
  final SharedPreferences _prefs;
  final Logger _logger = Logger();

  FeatureFlagConfig? _currentConfig;
  StreamController<FeatureFlagConfig>? _configController;
  Timer? _periodicFetchTimer;

  FeatureFlagService._(this._remoteConfig, this._prefs);

  static Future<FeatureFlagService> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final prefs = await SharedPreferences.getInstance();

    final service = FeatureFlagService._(remoteConfig, prefs);
    await service._initialize();
    return service;
  }

  Future<void> _initialize() async {
    try {
      // Set remote config settings
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: _fetchTimeout,
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Set default values
      await _remoteConfig.setDefaults(_getDefaultValues());

      // Load cached config first
      await _loadCachedConfig();

      // Fetch latest config
      await fetchAndActivate();

      // Setup periodic refresh
      _setupPeriodicRefresh();

      // Setup config stream
      _setupConfigStream();

      _logger.i('FeatureFlagService initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize FeatureFlagService',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'FeatureFlagService.initialize',
      );

      // Fallback to defaults
      _currentConfig = FeatureFlagConfig.fromRemoteConfig(_remoteConfig);
    }
  }

  Map<String, Object> _getDefaultValues() {
    return {
      // RAG System Defaults (Conservative rollout)
      FeatureFlags.ragSystemEnabled: false,
      FeatureFlags.ragVectorSearch: false,
      FeatureFlags.ragSemanticCache: false,
      FeatureFlags.ragResponseStreaming: false,
      FeatureFlags.ragMultiLanguage: false,
      FeatureFlags.ragOfflineMode: false,
      FeatureFlags.ragAdvancedFiltering: false,
      FeatureFlags.ragPremiumFeatures: false,
      FeatureFlags.ragPerformanceMode: true,
      FeatureFlags.ragBetaFeatures: false,

      // Core Features Defaults
      FeatureFlags.pushNotifications: true,
      FeatureFlags.analyticsEnabled: true,
      FeatureFlags.crashReportingEnabled: true,
      FeatureFlags.performanceMonitoringEnabled: true,
      FeatureFlags.maintenanceMode: false,
      FeatureFlags.forceUpdate: false,

      // Custom configuration
      'custom_config': '{}',
    };
  }

  /// Fetch and activate remote config
  Future<bool> fetchAndActivate() async {
    try {
      final fetchResult = await _remoteConfig.fetchAndActivate();

      if (fetchResult) {
        final newConfig = FeatureFlagConfig.fromRemoteConfig(_remoteConfig);
        await _updateConfig(newConfig);

        // Track config update
        await ProductionAnalytics.trackEvent('feature_flags_updated', {
          'config_version': DateTime.now().millisecondsSinceEpoch.toString(),
          'rag_enabled': newConfig.ragSystemEnabled,
          'maintenance_mode': newConfig.maintenanceMode,
        });

        _logger.i('Remote config fetched and activated successfully');
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to fetch remote config',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'FeatureFlagService.fetchAndActivate',
      );
      return false;
    }
  }

  Future<void> _updateConfig(FeatureFlagConfig newConfig) async {
    _currentConfig = newConfig;

    // Cache the config
    await _cacheConfig(newConfig);

    // Notify listeners
    _configController?.add(newConfig);
  }

  Future<void> _cacheConfig(FeatureFlagConfig config) async {
    try {
      final cacheData = {
        'config': {
          'ragSystemEnabled': config.ragSystemEnabled,
          'ragVectorSearch': config.ragVectorSearch,
          'ragSemanticCache': config.ragSemanticCache,
          'ragResponseStreaming': config.ragResponseStreaming,
          'ragMultiLanguage': config.ragMultiLanguage,
          'ragOfflineMode': config.ragOfflineMode,
          'ragAdvancedFiltering': config.ragAdvancedFiltering,
          'ragPremiumFeatures': config.ragPremiumFeatures,
          'ragPerformanceMode': config.ragPerformanceMode,
          'ragBetaFeatures': config.ragBetaFeatures,
          'pushNotifications': config.pushNotifications,
          'analyticsEnabled': config.analyticsEnabled,
          'crashReportingEnabled': config.crashReportingEnabled,
          'performanceMonitoringEnabled': config.performanceMonitoringEnabled,
          'maintenanceMode': config.maintenanceMode,
          'forceUpdate': config.forceUpdate,
          'customConfig': config.customConfig,
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _prefs.setString(_cacheKey, json.encode(cacheData));
    } catch (e) {
      _logger.w('Failed to cache feature flags', error: e);
    }
  }

  Future<void> _loadCachedConfig() async {
    try {
      final cachedData = _prefs.getString(_cacheKey);
      if (cachedData != null) {
        final cache = json.decode(cachedData) as Map<String, dynamic>;
        final timestamp = cache['timestamp'] as int;
        final configData = cache['config'] as Map<String, dynamic>;

        // Check if cache is still valid
        final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (cacheAge < _cacheDuration.inMilliseconds) {
          // Reconstruct config from cache
          _currentConfig = FeatureFlagConfig(
            ragSystemEnabled: configData['ragSystemEnabled'] ?? false,
            ragVectorSearch: configData['ragVectorSearch'] ?? false,
            ragSemanticCache: configData['ragSemanticCache'] ?? false,
            ragResponseStreaming: configData['ragResponseStreaming'] ?? false,
            ragMultiLanguage: configData['ragMultiLanguage'] ?? false,
            ragOfflineMode: configData['ragOfflineMode'] ?? false,
            ragAdvancedFiltering: configData['ragAdvancedFiltering'] ?? false,
            ragPremiumFeatures: configData['ragPremiumFeatures'] ?? false,
            ragPerformanceMode: configData['ragPerformanceMode'] ?? true,
            ragBetaFeatures: configData['ragBetaFeatures'] ?? false,
            pushNotifications: configData['pushNotifications'] ?? true,
            analyticsEnabled: configData['analyticsEnabled'] ?? true,
            crashReportingEnabled: configData['crashReportingEnabled'] ?? true,
            performanceMonitoringEnabled:
                configData['performanceMonitoringEnabled'] ?? true,
            maintenanceMode: configData['maintenanceMode'] ?? false,
            forceUpdate: configData['forceUpdate'] ?? false,
            customConfig: Map<String, dynamic>.from(
              configData['customConfig'] ?? {},
            ),
          );

          _logger.i('Loaded cached feature flags');
        }
      }
    } catch (e) {
      _logger.w('Failed to load cached config', error: e);
    }
  }

  void _setupPeriodicRefresh() {
    _periodicFetchTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      fetchAndActivate();
    });
  }

  void _setupConfigStream() {
    _configController = StreamController<FeatureFlagConfig>.broadcast();
  }

  /// Get current feature flag configuration
  FeatureFlagConfig get config =>
      _currentConfig ?? FeatureFlagConfig.fromRemoteConfig(_remoteConfig);

  /// Stream of configuration updates
  Stream<FeatureFlagConfig> get configStream {
    _configController ??= StreamController<FeatureFlagConfig>.broadcast();
    return _configController!.stream;
  }

  /// Check if a specific feature is enabled
  bool isEnabled(String featureFlag) {
    return _remoteConfig.getBool(featureFlag);
  }

  /// Get string value for a feature flag
  String getString(String featureFlag) {
    return _remoteConfig.getString(featureFlag);
  }

  /// Get int value for a feature flag
  int getInt(String featureFlag) {
    return _remoteConfig.getInt(featureFlag);
  }

  /// Get double value for a feature flag
  double getDouble(String featureFlag) {
    return _remoteConfig.getDouble(featureFlag);
  }

  /// Force refresh configuration
  Future<void> refreshConfig() async {
    await fetchAndActivate();
  }

  /// RAG-specific feature checks
  bool get isRagEnabled => config.ragSystemEnabled;
  bool get isRagVectorSearchEnabled =>
      config.isRagFeatureEnabled('vector_search');
  bool get isRagSemanticCacheEnabled =>
      config.isRagFeatureEnabled('semantic_cache');
  bool get isRagStreamingEnabled =>
      config.isRagFeatureEnabled('response_streaming');
  bool get isRagMultiLanguageEnabled =>
      config.isRagFeatureEnabled('multi_language');
  bool get isRagOfflineModeEnabled =>
      config.isRagFeatureEnabled('offline_mode');
  bool get isRagAdvancedFilteringEnabled =>
      config.isRagFeatureEnabled('advanced_filtering');
  bool get isRagPremiumFeaturesEnabled =>
      config.isRagFeatureEnabled('premium_features');
  bool get isRagPerformanceModeEnabled =>
      config.isRagFeatureEnabled('performance_mode');
  bool get isRagBetaFeaturesEnabled =>
      config.isRagFeatureEnabled('beta_features');

  /// App-level feature checks
  bool get isMaintenanceModeEnabled => config.maintenanceMode;
  bool get isForceUpdateRequired => config.forceUpdate;
  bool get isAnalyticsEnabled => config.analyticsEnabled;
  bool get isCrashReportingEnabled => config.crashReportingEnabled;
  bool get isPerformanceMonitoringEnabled =>
      config.performanceMonitoringEnabled;

  /// Dispose resources
  void dispose() {
    _periodicFetchTimer?.cancel();
    _configController?.close();
  }
}

/// Riverpod Provider for Feature Flag Service
final featureFlagServiceProvider = Provider<FeatureFlagService>((ref) {
  throw UnimplementedError('FeatureFlagService must be initialized first');
});

/// Riverpod Provider for Feature Flag Configuration
final featureFlagConfigProvider = StreamProvider<FeatureFlagConfig>((ref) {
  final service = ref.read(featureFlagServiceProvider);
  return service.configStream;
});

/// Helper extension for easy feature flag checks
extension FeatureFlagContext on WidgetRef {
  FeatureFlagService get featureFlags => read(featureFlagServiceProvider);

  bool isFeatureEnabled(String flag) => featureFlags.isEnabled(flag);
  bool get isRagEnabled => featureFlags.isRagEnabled;
  bool get isMaintenanceMode => featureFlags.isMaintenanceModeEnabled;
  bool get forceUpdate => featureFlags.isForceUpdateRequired;
}
