// lib/core/deployment/deployment_config_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../monitoring/production_analytics.dart';
import '../monitoring/production_crash_reporter.dart';

/// Deployment Environment
enum DeploymentEnvironment { development, staging, production }

/// Deployment Configuration
class DeploymentConfig {
  final DeploymentEnvironment environment;
  final String apiBaseUrl;
  final String ragServiceUrl;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;
  final bool enableFeatureFlags;
  final bool debugMode;
  final Map<String, dynamic> platformConfig;
  final Map<String, dynamic> ragConfig;
  final Map<String, dynamic> customConfig;

  const DeploymentConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.ragServiceUrl,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
    required this.enableFeatureFlags,
    required this.debugMode,
    required this.platformConfig,
    required this.ragConfig,
    required this.customConfig,
  });

  factory DeploymentConfig.development() {
    return const DeploymentConfig(
      environment: DeploymentEnvironment.development,
      apiBaseUrl: 'https://api-dev.duacopilot.com',
      ragServiceUrl: 'https://rag-dev.duacopilot.com',
      enableAnalytics: true,
      enableCrashReporting: true,
      enablePerformanceMonitoring: true,
      enableFeatureFlags: true,
      debugMode: true,
      platformConfig: {
        'timeout_seconds': 30,
        'retry_attempts': 3,
        'cache_enabled': true,
      },
      ragConfig: {
        'model_name': 'gpt-3.5-turbo',
        'max_tokens': 1000,
        'temperature': 0.7,
        'stream_responses': true,
        'enable_semantic_cache': true,
        'cache_ttl_minutes': 60,
      },
      customConfig: {},
    );
  }

  factory DeploymentConfig.staging() {
    return const DeploymentConfig(
      environment: DeploymentEnvironment.staging,
      apiBaseUrl: 'https://api-staging.duacopilot.com',
      ragServiceUrl: 'https://rag-staging.duacopilot.com',
      enableAnalytics: true,
      enableCrashReporting: true,
      enablePerformanceMonitoring: true,
      enableFeatureFlags: true,
      debugMode: false,
      platformConfig: {
        'timeout_seconds': 30,
        'retry_attempts': 3,
        'cache_enabled': true,
      },
      ragConfig: {
        'model_name': 'gpt-3.5-turbo',
        'max_tokens': 1500,
        'temperature': 0.7,
        'stream_responses': true,
        'enable_semantic_cache': true,
        'cache_ttl_minutes': 120,
      },
      customConfig: {},
    );
  }

  factory DeploymentConfig.production() {
    return const DeploymentConfig(
      environment: DeploymentEnvironment.production,
      apiBaseUrl: 'https://api.duacopilot.com',
      ragServiceUrl: 'https://rag.duacopilot.com',
      enableAnalytics: true,
      enableCrashReporting: true,
      enablePerformanceMonitoring: true,
      enableFeatureFlags: true,
      debugMode: false,
      platformConfig: {
        'timeout_seconds': 45,
        'retry_attempts': 5,
        'cache_enabled': true,
      },
      ragConfig: {
        'model_name': 'gpt-4',
        'max_tokens': 2000,
        'temperature': 0.7,
        'stream_responses': true,
        'enable_semantic_cache': true,
        'cache_ttl_minutes': 240,
      },
      customConfig: {},
    );
  }

  factory DeploymentConfig.fromMap(
    Map<String, dynamic>? configMap,
    DeploymentEnvironment fallbackEnvironment,
  ) {
    if (configMap == null) {
      return _fallbackFor(fallbackEnvironment);
    }
    try {
      return DeploymentConfig(
        environment: DeploymentEnvironment.values.firstWhere(
          (e) => e.name == configMap['environment'],
          orElse: () => fallbackEnvironment,
        ),
        apiBaseUrl: configMap['api_base_url'] ?? '',
        ragServiceUrl: configMap['rag_service_url'] ?? '',
        enableAnalytics: configMap['enable_analytics'] ?? true,
        enableCrashReporting: configMap['enable_crash_reporting'] ?? true,
        enablePerformanceMonitoring: configMap['enable_performance_monitoring'] ?? true,
        enableFeatureFlags: configMap['enable_feature_flags'] ?? true,
        debugMode: configMap['debug_mode'] ?? false,
        platformConfig: Map<String, dynamic>.from(
          configMap['platform_config'] ?? {},
        ),
        ragConfig: Map<String, dynamic>.from(configMap['rag_config'] ?? {}),
        customConfig: Map<String, dynamic>.from(
          configMap['custom_config'] ?? {},
        ),
      );
    } catch (_) {
      return _fallbackFor(fallbackEnvironment);
    }
  }

  static DeploymentConfig _fallbackFor(DeploymentEnvironment env) {
    switch (env) {
      case DeploymentEnvironment.development:
        return DeploymentConfig.development();
      case DeploymentEnvironment.staging:
        return DeploymentConfig.staging();
      case DeploymentEnvironment.production:
        return DeploymentConfig.production();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'environment': environment.name,
      'api_base_url': apiBaseUrl,
      'rag_service_url': ragServiceUrl,
      'enable_analytics': enableAnalytics,
      'enable_crash_reporting': enableCrashReporting,
      'enable_performance_monitoring': enablePerformanceMonitoring,
      'enable_feature_flags': enableFeatureFlags,
      'debug_mode': debugMode,
      'platform_config': platformConfig,
      'rag_config': ragConfig,
      'custom_config': customConfig,
    };
  }

  @override
  String toString() {
    return 'DeploymentConfig(${environment.name}: $apiBaseUrl)';
  }
}

/// Deployment Configuration Service
class DeploymentConfigService {
  static final Logger _logger = Logger();
  static SharedPreferences? _prefs;
  static PackageInfo? _packageInfo;
  static bool _isInitialized = false;

  static DeploymentConfig? _currentConfig;
  static StreamController<DeploymentConfig>? _configController;

  static const String _configCacheKey = 'deployment_config_cache';
  static const String _environmentKey = 'deployment_environment';

  /// Initialize deployment configuration service
  static Future<void> initialize({
    DeploymentEnvironment? forcedEnvironment,
  }) async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _packageInfo = await PackageInfo.fromPlatform();

      // Determine environment
      final environment = forcedEnvironment ?? await _determineEnvironment();

      // Load configuration
      await _loadConfiguration(environment);

      // Setup config stream
      _configController = StreamController<DeploymentConfig>.broadcast();

      _isInitialized = true;
      _logger.i('DeploymentConfigService initialized for ${environment.name}');

      // Track initialization
      await ProductionAnalytics.trackEvent('deployment_config_initialized', {
        'environment': environment.name,
        'app_version': _packageInfo?.version ?? 'unknown',
        'platform': Platform.operatingSystem,
      });
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize DeploymentConfigService',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'DeploymentConfigService.initialize',
      );

      // Fallback to development config
      _currentConfig = DeploymentConfig.development();
    }
  }

  /// Get current deployment configuration
  static DeploymentConfig get config {
    if (!_isInitialized) {
      throw StateError('DeploymentConfigService not initialized');
    }
    return _currentConfig ?? DeploymentConfig.development();
  }

  /// Stream of configuration updates
  static Stream<DeploymentConfig> get configStream {
    if (!_isInitialized) {
      throw StateError('DeploymentConfigService not initialized');
    }
    return _configController!.stream;
  }

  /// Update configuration from remote config
  static Future<void> updateFromRemoteConfig() async {
    try {
      if (!_isInitialized) return;
      // Previously fetched from Firebase Remote Config. Now just re-emit existing config.
      final newConfig =
          _currentConfig ?? _fallbackForEnv(_currentConfig?.environment ?? DeploymentEnvironment.production);

      if (_isDifferentConfig(newConfig)) {
        await _updateConfiguration(newConfig);

        _logger.i('Deployment configuration updated from remote config');

        // Track config update
        await ProductionAnalytics.trackEvent('deployment_config_updated', {
          'environment': newConfig.environment.name,
          'source': 'remote_config',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to update from remote config',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'DeploymentConfigService.updateFromRemoteConfig',
      );
    }
  }

  /// Force environment change (development/testing only)
  static Future<void> forceEnvironment(
    DeploymentEnvironment environment,
  ) async {
    if (kReleaseMode) {
      _logger.w('Cannot force environment in release mode');
      return;
    }

    try {
      await _prefs?.setString(_environmentKey, environment.name);
      await _loadConfiguration(environment);

      _logger.i('Environment forced to ${environment.name}');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to force environment',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'DeploymentConfigService.forceEnvironment',
      );
    }
  }

  /// Get deployment information
  static Map<String, dynamic> getDeploymentInfo() {
    final config = _currentConfig;
    if (config == null) return {};

    return {
      'environment': config.environment.name,
      'api_base_url': config.apiBaseUrl,
      'rag_service_url': config.ragServiceUrl,
      'app_version': _packageInfo?.version ?? 'unknown',
      'build_number': _packageInfo?.buildNumber ?? 'unknown',
      'platform': Platform.operatingSystem,
      'debug_mode': config.debugMode,
      'features_enabled': {
        'analytics': config.enableAnalytics,
        'crash_reporting': config.enableCrashReporting,
        'performance_monitoring': config.enablePerformanceMonitoring,
        'feature_flags': config.enableFeatureFlags,
      },
    };
  }

  /// Validate current configuration
  static Future<bool> validateConfiguration() async {
    try {
      final config = _currentConfig;
      if (config == null) return false;

      // Validate URLs
      if (config.apiBaseUrl.isEmpty || config.ragServiceUrl.isEmpty) {
        return false;
      }

      // Validate environment consistency
      if (kDebugMode && config.environment == DeploymentEnvironment.production) {
        _logger.w('Debug mode enabled in production environment');
        return false;
      }

      // Additional validations can be added here

      return true;
    } catch (e, stackTrace) {
      _logger.e(
        'Configuration validation failed',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'DeploymentConfigService.validateConfiguration',
      );
      return false;
    }
  }

  /// Get RAG configuration
  static Map<String, dynamic> getRagConfig() {
    return config.ragConfig;
  }

  /// Get platform configuration
  static Map<String, dynamic> getPlatformConfig() {
    return config.platformConfig;
  }

  /// Check if feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature.toLowerCase()) {
      case 'analytics':
        return config.enableAnalytics;
      case 'crash_reporting':
        return config.enableCrashReporting;
      case 'performance_monitoring':
        return config.enablePerformanceMonitoring;
      case 'feature_flags':
        return config.enableFeatureFlags;
      default:
        return false;
    }
  }

  // Private helper methods
  static Future<DeploymentEnvironment> _determineEnvironment() async {
    // Check for forced environment (debug only)
    if (kDebugMode) {
      final forcedEnv = _prefs?.getString(_environmentKey);
      if (forcedEnv != null) {
        return DeploymentEnvironment.values.firstWhere(
          (e) => e.name == forcedEnv,
          orElse: () => DeploymentEnvironment.development,
        );
      }
    }

    // Determine based on build mode
    if (kDebugMode) {
      return DeploymentEnvironment.development;
    } else if (kProfileMode) {
      return DeploymentEnvironment.staging;
    } else {
      return DeploymentEnvironment.production;
    }
  }

  static Future<void> _loadConfiguration(
    DeploymentEnvironment environment,
  ) async {
    try {
      // Try to load from cache first
      await _loadCachedConfiguration(environment);

      // Then try to update from remote config if available
      if (config.enableFeatureFlags) {
        try {
          // Remote config removed – skip dynamic fetch
        } catch (e) {
          _logger.w(
            'Failed to load from remote config, using defaults',
            error: e,
          );
        }
      }

      // Fallback to default configuration
      if (_currentConfig == null) {
        switch (environment) {
          case DeploymentEnvironment.development:
            _currentConfig = DeploymentConfig.development();
            break;
          case DeploymentEnvironment.staging:
            _currentConfig = DeploymentConfig.staging();
            break;
          case DeploymentEnvironment.production:
            _currentConfig = DeploymentConfig.production();
            break;
        }
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to load configuration',
        error: e,
        stackTrace: stackTrace,
      );
      await ProductionCrashReporter.recordError(
        e,
        stackTrace,
        context: 'DeploymentConfigService._loadConfiguration',
      );
    }
  }

  // Local helper duplicating earlier factory fallback
  static DeploymentConfig _fallbackForEnv(DeploymentEnvironment env) {
    switch (env) {
      case DeploymentEnvironment.development:
        return DeploymentConfig.development();
      case DeploymentEnvironment.staging:
        return DeploymentConfig.staging();
      case DeploymentEnvironment.production:
        return DeploymentConfig.production();
    }
  }

  static Future<void> _loadCachedConfiguration(
    DeploymentEnvironment environment,
  ) async {
    try {
      final cachedConfig = _prefs?.getString(_configCacheKey);
      if (cachedConfig != null) {
        final configMap = json.decode(cachedConfig) as Map<String, dynamic>;

        // Check if cached config is for the same environment
        if (configMap['environment'] == environment.name) {
          _currentConfig = DeploymentConfig(
            environment: environment,
            apiBaseUrl: configMap['api_base_url'] ?? '',
            ragServiceUrl: configMap['rag_service_url'] ?? '',
            enableAnalytics: configMap['enable_analytics'] ?? true,
            enableCrashReporting: configMap['enable_crash_reporting'] ?? true,
            enablePerformanceMonitoring: configMap['enable_performance_monitoring'] ?? true,
            enableFeatureFlags: configMap['enable_feature_flags'] ?? true,
            debugMode: configMap['debug_mode'] ?? false,
            platformConfig: Map<String, dynamic>.from(
              configMap['platform_config'] ?? {},
            ),
            ragConfig: Map<String, dynamic>.from(configMap['rag_config'] ?? {}),
            customConfig: Map<String, dynamic>.from(
              configMap['custom_config'] ?? {},
            ),
          );

          _logger.i('Loaded cached deployment configuration');
        }
      }
    } catch (e) {
      _logger.w('Failed to load cached configuration', error: e);
    }
  }

  static Future<void> _updateConfiguration(DeploymentConfig newConfig) async {
    _currentConfig = newConfig;

    // Cache the configuration
    await _cacheConfiguration(newConfig);

    // Notify listeners
    _configController?.add(newConfig);

    // Validate the new configuration
    await validateConfiguration();
  }

  static Future<void> _cacheConfiguration(DeploymentConfig config) async {
    try {
      final configJson = json.encode(config.toMap());
      await _prefs?.setString(_configCacheKey, configJson);
    } catch (e) {
      _logger.w('Failed to cache configuration', error: e);
    }
  }

  static bool _isDifferentConfig(DeploymentConfig newConfig) {
    if (_currentConfig == null) return true;

    return _currentConfig!.apiBaseUrl != newConfig.apiBaseUrl ||
        _currentConfig!.ragServiceUrl != newConfig.ragServiceUrl ||
        _currentConfig!.enableAnalytics != newConfig.enableAnalytics ||
        _currentConfig!.enableCrashReporting != newConfig.enableCrashReporting ||
        _currentConfig!.enablePerformanceMonitoring != newConfig.enablePerformanceMonitoring ||
        _currentConfig!.enableFeatureFlags != newConfig.enableFeatureFlags;
  }

  /// Dispose resources
  static void dispose() {
    _configController?.close();
    _configController = null;
  }
}
