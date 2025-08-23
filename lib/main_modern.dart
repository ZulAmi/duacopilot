// Modern award-winning main app for DuaCopilot
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/logging/app_logger.dart';
import 'core/theme/modern_islamic_theme.dart';
import 'presentation/screens/modern_splash_screen.dart';
import 'presentation/screens/modern_search_screen.dart';
import 'services/ads/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize dependency injection with platform awareness
    await di.init();

    // Initialize ad service only on supported platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await AdService.instance.initialize();
    }

    AppLogger.debug('✅ DuaCopilot Modern UI initialized successfully');
  } catch (e) {
    AppLogger.debug('⚠️  DuaCopilot initialization error: $e');
    // Continue anyway with limited functionality
  }

  runApp(const ProviderScope(child: ModernDuaCopilotApp()));
}

/// Modern award-winning DuaCopilot app with stunning UI/UX
class ModernDuaCopilotApp extends StatelessWidget {
  const ModernDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot - Modern Islamic AI Companion',
      debugShowCheckedModeBanner: false,

      // Apply modern Islamic theme
      theme: ModernIslamicTheme.lightTheme,
      darkTheme: ModernIslamicTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Modern splash screen with beautiful animations
      home: const ModernAppWrapper(),

      // App-wide configuration
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Ensure text scaling is reasonable
            textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
          ),
          child: child!,
        );
      },
    );
  }
}

/// App wrapper that handles splash screen and main navigation
class ModernAppWrapper extends StatefulWidget {
  const ModernAppWrapper({super.key});

  @override
  State<ModernAppWrapper> createState() => _ModernAppWrapperState();
}

class _ModernAppWrapperState extends State<ModernAppWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Perform any additional initialization here
    // The splash screen will handle its own timing
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return ModernSplashScreen(onAnimationComplete: _onSplashComplete);
    }

    // Determine which main screen to show based on platform
    return _buildMainScreen();
  }

  Widget _buildMainScreen() {
    if (kIsWeb) {
      return _buildWebMainScreen();
    }

    // Mobile/Desktop main screen
    return const ModernSearchScreen(enableVoiceSearch: true, enableArabicKeyboard: true, showSearchHistory: true);
  }

  Widget _buildWebMainScreen() {
    return const ModernWebLandingScreen();
  }
}

/// Modern web-optimized landing screen
class ModernWebLandingScreen extends StatefulWidget {
  const ModernWebLandingScreen({super.key});

  @override
  State<ModernWebLandingScreen> createState() => _ModernWebLandingScreenState();
}

class _ModernWebLandingScreenState extends State<ModernWebLandingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(theme),

          // Main content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo and title
                        _buildHeader(theme),

                        const SizedBox(height: 48),

                        // Feature highlights
                        _buildFeatureSection(theme),

                        const SizedBox(height: 48),

                        // Call to action
                        _buildCallToAction(theme, screenSize),

                        const SizedBox(height: 32),

                        // Platform notes
                        _buildPlatformNotes(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
            theme.colorScheme.surface,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 50),
        ),

        const SizedBox(height: 24),

        // Title
        Text(
          'DuaCopilot',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -1.0,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          'Modern AI-Powered Islamic Companion',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureSection(ThemeData theme) {
    final features = [
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'AI-Powered Guidance',
        'description': 'Intelligent Islamic advice powered by advanced AI',
      },
      {
        'icon': Icons.search_rounded,
        'title': 'Smart Search',
        'description': 'Find relevant du\'as and Islamic teachings instantly',
      },
      {
        'icon': Icons.language_rounded,
        'title': 'Multi-Language',
        'description': 'Arabic, English, and transliteration support',
      },
      {
        'icon': Icons.offline_bolt_rounded,
        'title': 'Works Offline',
        'description': 'Access Islamic knowledge anytime, anywhere',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 24),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: ModernIslamicTheme.modernCardDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(feature['icon'] as IconData, color: theme.colorScheme.primary, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    feature['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature['description'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCallToAction(ThemeData theme, Size screenSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: ModernIslamicTheme.glassmorphicDecoration(
        backgroundColor: theme.colorScheme.primary,
        borderRadius: 20,
      ),
      child: Column(
        children: [
          Text(
            'Experience the Full App',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'The web version offers limited functionality. For the complete DuaCopilot experience with advanced features, please use our mobile or desktop applications.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Navigation to simple search
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => const ModernSearchScreen(
                        enableVoiceSearch: false,
                        enableArabicKeyboard: true,
                        showSearchHistory: false,
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            child: const Text('Try Web Version'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformNotes(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ModernIslamicTheme.modernCardDecoration(backgroundColor: theme.colorScheme.surfaceContainerHighest),
      child: Column(
        children: [
          Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary, size: 24),

          const SizedBox(height: 12),

          Text(
            'Platform Information',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'DuaCopilot is optimized for mobile devices and desktop applications. Web functionality is limited but provides a taste of our Islamic AI companion.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
