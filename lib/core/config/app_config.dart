/// Application Configuration Management
/// Handles environment-specific settings while maintaining app parity
class AppConfig {
  static const String _environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  /// Current environment (development, staging, production)
  static AppEnvironment get environment {
    switch (_environment.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'staging':
      case 'stage':
        return AppEnvironment.staging;
      case 'development':
      case 'dev':
      default:
        return AppEnvironment.development;
    }
  }

  /// App configuration based on environment
  static AppSettings get settings {
    switch (environment) {
      case AppEnvironment.production:
        return const AppSettings(
          appTitle: 'DuaCopilot - Islamic AI Assistant',
          debugMode: false,
          showDebugBanner: false,
          enableDetailedLogging: false,
          enablePerformanceOverlay: false,
          apiBaseUrl: 'https://api.duacopilot.com',
          enableAnalytics: true,
          enableCrashReporting: true,
        );
      case AppEnvironment.staging:
        return const AppSettings(
          appTitle: 'DuaCopilot (Staging) - Islamic AI Assistant',
          debugMode: true,
          showDebugBanner: true,
          enableDetailedLogging: true,
          enablePerformanceOverlay: false,
          apiBaseUrl: 'https://staging-api.duacopilot.com',
          enableAnalytics: true,
          enableCrashReporting: true,
        );
      case AppEnvironment.development:
        return const AppSettings(
          appTitle: 'DuaCopilot (Dev) - Islamic AI Assistant',
          debugMode: true,
          showDebugBanner: true,
          enableDetailedLogging: true,
          enablePerformanceOverlay: false,
          apiBaseUrl: 'https://dev-api.duacopilot.com',
          enableAnalytics: false,
          enableCrashReporting: false,
        );
    }
  }

  /// Feature flags based on environment
  static FeatureFlags get features {
    switch (environment) {
      case AppEnvironment.production:
        return const FeatureFlags(
          showRevolutionaryUI: false, // Use stable UI in production
          enableExperimentalFeatures: false,
          showPerformanceMetrics: false,
          enableDebugTools: false,
        );
      case AppEnvironment.staging:
        return const FeatureFlags(
          showRevolutionaryUI: true, // Test new UI in staging
          enableExperimentalFeatures: true,
          showPerformanceMetrics: true,
          enableDebugTools: true,
        );
      case AppEnvironment.development:
        return const FeatureFlags(
          showRevolutionaryUI: false, // Use professional Islamic theme instead
          useProfessionalIslamicTheme: true, // Enable professional Islamic green & white theme
          enableExperimentalFeatures: true,
          showPerformanceMetrics: true,
          enableDebugTools: true,
        );
    }
  }
}

enum AppEnvironment { development, staging, production }

class AppSettings {
  final String appTitle;
  final bool debugMode;
  final bool showDebugBanner;
  final bool enableDetailedLogging;
  final bool enablePerformanceOverlay;
  final String apiBaseUrl;
  final bool enableAnalytics;
  final bool enableCrashReporting;

  const AppSettings({
    required this.appTitle,
    required this.debugMode,
    required this.showDebugBanner,
    required this.enableDetailedLogging,
    required this.enablePerformanceOverlay,
    required this.apiBaseUrl,
    required this.enableAnalytics,
    required this.enableCrashReporting,
  });
}

class FeatureFlags {
  final bool showRevolutionaryUI;
  final bool useProfessionalIslamicTheme;
  final bool enableExperimentalFeatures;
  final bool showPerformanceMetrics;
  final bool enableDebugTools;

  const FeatureFlags({
    required this.showRevolutionaryUI,
    this.useProfessionalIslamicTheme = false,
    required this.enableExperimentalFeatures,
    required this.showPerformanceMetrics,
    required this.enableDebugTools,
  });
}
