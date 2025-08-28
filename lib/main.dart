import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routing/app_router.dart';
import 'core/security/production_config.dart';
import 'core/security/secure_telemetry.dart';
import 'core/theme/professional_theme.dart';
import 'services/ads/ad_service.dart';
import 'services/aws_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SECURITY: Validate production security requirements
  ProductionSecurityAssertion.assertProductionSecurity();

  // Initialize AWS services
  await AWSRemoteConfigService.fetchAndActivate();

  // Initialize secure telemetry (production-ready)
  await SecureTelemetry.initialize();

  // Initialize dependency injection
  await di.init();

  // Initialize ad service
  await AdService.instance.initialize();

  // Track app launch securely
  await SecureTelemetry.trackUserAction(
    action: 'app_launched',
    category: 'lifecycle',
    properties: ProductionConfig.getAppInfo(),
  );

  // Log security audit event
  await SecurityAuditLogger.logSecurityEvent(
    event: 'app_startup',
    level: SecurityLevel.info,
    context: ProductionConfig.getSecurityConfig(),
  );

  runApp(const ProviderScope(child: SecureDuaCopilotApp()));
}

/// Secure DuaCopilot App with Production Security Hardening
class SecureDuaCopilotApp extends ConsumerWidget {
  const SecureDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SECURITY: Track screen view with secure telemetry only
    SecureTelemetry.trackUserAction(
      action: 'screen_view',
      category: 'navigation',
      properties: {'screen_name': 'app_start', 'environment': 'production'},
    );

    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'DuaCopilot - Professional Islamic AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      routerConfig: router,

      // App-wide configuration for better UX
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: ProfessionalTheme.surfaceColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Ensure text scaling is reasonable for Islamic content
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: ProfessionalTheme.primaryEmerald,
        brightness: Brightness.light,
        primary: ProfessionalTheme.primaryEmerald,
        secondary: ProfessionalTheme.secondaryGold,
        surface: ProfessionalTheme.surfaceColor,
        onPrimary: ProfessionalTheme.surfaceColor,
        onSecondary: ProfessionalTheme.surfaceColor,
        onSurface: ProfessionalTheme.textPrimary,
      ),

      // Scaffold theme
      scaffoldBackgroundColor: ProfessionalTheme.backgroundColor,

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: ProfessionalTheme.surfaceColor,
        foregroundColor: ProfessionalTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: ProfessionalTheme.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: ProfessionalTheme.textPrimary),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ProfessionalTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: ProfessionalTheme.borderLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: ProfessionalTheme.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: ProfessionalTheme.primaryEmerald,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(ProfessionalTheme.spaceMd),
        hintStyle: const TextStyle(
          color: ProfessionalTheme.textTertiary,
          fontSize: 16,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ProfessionalTheme.primaryEmerald,
          foregroundColor: ProfessionalTheme.surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfessionalTheme.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ProfessionalTheme.spaceMd,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
