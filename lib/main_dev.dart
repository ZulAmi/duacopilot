import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'presentation/screens/conversational_search_screen.dart';
import 'services/ads/ad_service.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize dependency injection with platform awareness
    await di.init();
    
    // Initialize ad service only on supported platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await AdService.instance.initialize();
    }
    
    print('✅ DuaCopilot initialized successfully');
  } catch (e) {
    print('⚠️  DuaCopilot initialization error: $e');
    // Continue anyway with limited functionality
  }

  runApp(const ProviderScope(child: DuaCopilotApp()));
}

class DuaCopilotApp extends StatelessWidget {
  const DuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dua Copilot - Islamic Search Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Deep Islamic green
          brightness: Brightness.light,
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF4CAF50),
          surface: const Color(0xFFFAFAFA),
          background: const Color(0xFFF5F5F5),
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.15,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF1F8E9),
          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2E7D32), width: 1),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.dark,
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFF81C784),
          surface: const Color(0xFF1E1E1E),
          background: const Color(0xFF121212),
        ),
        useMaterial3: true,
      ),
      home: const ConversationalSearchScreen(), // Same screen for all platforms
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebSafeLandingScreen extends StatelessWidget {
  const WebSafeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DuaCopilot - Islamic Search'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Islamic Content Search',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to DuaCopilot - your AI-powered Islamic search assistant',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 32),
            Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Web Version (Limited)',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'The web version is currently in development. For full functionality, please use the mobile or desktop application.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Features available in full app:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Conversational Islamic search'),
                    Text('• Quran verses and duas'),
                    Text('• Audio recitations'),
                    Text('• Multi-language support'),
                    Text('• Semantic search capabilities'),
                    Text('• Offline functionality'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
