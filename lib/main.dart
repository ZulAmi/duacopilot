import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/ultra_modern_theme.dart';
import 'presentation/screens/ultra_modern_search_screen.dart';
import 'services/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Initialize ad service
  await AdService.instance.initialize();

  runApp(const ProviderScope(child: UltraModernDuaCopilotApp()));
}

/// Ultra-Modern DuaCopilot App with Revolutionary UI/UX Design
class UltraModernDuaCopilotApp extends StatelessWidget {
  const UltraModernDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot - Ultra Modern Islamic AI Assistant',
      theme: UltraModernTheme.lightTheme,
      darkTheme: UltraModernTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const UltraModernSearchScreen(),
      debugShowCheckedModeBanner: false,

      // App-wide configuration for better UX
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Ensure text scaling is reasonable for Islamic content
            textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
          ),
          child: child!,
        );
      },
    );
  }
}
