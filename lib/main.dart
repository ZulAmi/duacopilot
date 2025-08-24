import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/professional_theme.dart';
import 'presentation/screens/professional_home_screen.dart';
import 'services/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Initialize ad service
  await AdService.instance.initialize();

  runApp(const ProviderScope(child: ProfessionalDuaCopilotApp()));
}

/// Professional DuaCopilot App with Enterprise-Grade UI/UX Design
class ProfessionalDuaCopilotApp extends StatelessWidget {
  const ProfessionalDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot - Professional Islamic AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const ProfessionalHomeScreen(),
      
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
                MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
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
        background: ProfessionalTheme.backgroundColor,
        onPrimary: ProfessionalTheme.surfaceColor,
        onSecondary: ProfessionalTheme.surfaceColor,
        onSurface: ProfessionalTheme.textPrimary,
        onBackground: ProfessionalTheme.textPrimary,
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
        iconTheme: IconThemeData(
          color: ProfessionalTheme.textPrimary,
        ),
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
