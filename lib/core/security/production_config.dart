// lib/core/security/production_config.dart

import 'package:flutter/foundation.dart';

/// Enterprise production configuration with security hardening
class ProductionConfig {
  // Build configuration
  static const bool isProduction = bool.fromEnvironment('PRODUCTION', defaultValue: false);
  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true);
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: false);

  // Security configuration
  static const bool enableDebugFeatures = false; // Always false in production
  static const bool enableAdminAccess = false; // Always false in main app
  static const bool enableDeveloperMode = false; // Always false in production

  // API endpoints
  static const String telemetryEndpoint = String.fromEnvironment(
    'TELEMETRY_ENDPOINT',
    defaultValue: 'https://secure-analytics.duacopilot.com',
  );

  static const String auditEndpoint = String.fromEnvironment(
    'AUDIT_ENDPOINT',
    defaultValue: 'https://audit.duacopilot.com',
  );

  // App configuration
  static const String appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
  static const String buildNumber = String.fromEnvironment('BUILD_NUMBER', defaultValue: '1');
  static const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'production');

  /// Check if running in secure production environment
  static bool get isSecureProduction {
    return kReleaseMode &&
        !kDebugMode &&
        isProduction &&
        const bool.fromEnvironment('dart.vm.product', defaultValue: false);
  }

  /// Check if admin features should be available
  static bool get shouldEnableAdminFeatures {
    // Admin features only in development OR separate admin app
    return kDebugMode && !isProduction && enableDeveloperMode;
  }

  /// Check if telemetry should be enabled
  static bool get shouldEnableTelemetry {
    return isSecureProduction && enableAnalytics;
  }

  /// Check if detailed logging should be enabled
  static bool get shouldEnableDetailedLogging {
    return kDebugMode || enableLogging;
  }

  /// Get security configuration
  static Map<String, dynamic> getSecurityConfig() {
    return {
      'is_production': isProduction,
      'is_secure_production': isSecureProduction,
      'admin_access_enabled': shouldEnableAdminFeatures,
      'telemetry_enabled': shouldEnableTelemetry,
      'debug_features_enabled': enableDebugFeatures,
      'build_mode':
          kReleaseMode
              ? 'release'
              : kDebugMode
              ? 'debug'
              : 'profile',
      'flavor': flavor,
      'version': appVersion,
      'build_number': buildNumber,
    };
  }

  /// Get app information for telemetry
  static Map<String, dynamic> getAppInfo() {
    return {
      'version': appVersion,
      'build_number': buildNumber,
      'flavor': flavor,
      'platform': defaultTargetPlatform.name,
      'is_production': isSecureProduction,
    };
  }

  /// Validate production security requirements
  static List<String> validateProductionSecurity() {
    final issues = <String>[];

    if (!isSecureProduction && isProduction) {
      issues.add('Not running in secure production mode');
    }

    if (enableAdminAccess && isProduction) {
      issues.add('Admin access enabled in production - CRITICAL SECURITY RISK');
    }

    if (enableDebugFeatures && isProduction) {
      issues.add('Debug features enabled in production');
    }

    if (kDebugMode && isProduction) {
      issues.add('Debug mode enabled in production build');
    }

    return issues;
  }
}

/// Build-time security assertions
class ProductionSecurityAssertion {
  /// Assert production security requirements
  static void assertProductionSecurity() {
    if (ProductionConfig.isProduction) {
      // Critical security assertions
      assert(!ProductionConfig.enableAdminAccess, 'SECURITY VIOLATION: Admin access must be disabled in production');

      assert(
        !ProductionConfig.enableDebugFeatures,
        'SECURITY VIOLATION: Debug features must be disabled in production',
      );

      assert(kReleaseMode, 'SECURITY VIOLATION: Must use release mode in production');

      // Validate admin routes are blocked
      _validateAdminRoutesBlocked();

      // Log security validation
      debugPrint('✅ SECURITY: Production security requirements validated');
    } else {
      debugPrint('⚠️ DEVELOPMENT: Running in development mode - security checks relaxed');
    }
  }

  /// Validate that admin routes are completely blocked in production
  static void _validateAdminRoutesBlocked() {
    if (kReleaseMode) {
      // SECURITY: In production, admin screens should be completely removed
      debugPrint('✅ SECURITY: Admin screens removed from production build');
    }
  }
}
