import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Qibla & Tasbih
import '../../features/qibla/screens/qibla_compass_screen.dart';
import '../../features/tasbih/screens/digital_tasbih_screen.dart';
import '../../presentation/screens/assistance/screen_assistance.dart';
// Specialized Features
import '../../presentation/screens/conversational_search_screen.dart';
import '../../presentation/screens/islamic/islamic_calendar_screen.dart';
import '../../presentation/screens/islamic/prayer_times_screen.dart';
// Islamic Features
import '../../presentation/screens/islamic/quran_explorer_screen.dart';
import '../../presentation/screens/premium_features/islamic_university_screen.dart';
import '../../presentation/screens/premium_features/premium_audio_screen.dart';
// Premium Features
import '../../presentation/screens/premium_features/premium_features_hub.dart';
// Import screens
import '../../presentation/screens/professional_home_screen.dart';
import '../../presentation/screens/professional_islamic_search_screen.dart';
import '../../presentation/screens/revolutionary_home_screen.dart';
import '../../presentation/screens/revolutionary_voice_companion_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/subscription/subscription_screen.dart';

// Core navigation keys
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Professional GoRouter configuration for DuaCopilot
/// Handles all navigation including premium features, deep linking, and security
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false, // Disable in production
    // Initial route
    initialLocation: '/',

    // Error handling
    errorBuilder: (context, state) =>
        ErrorScreen(error: state.error.toString()),

    // Route definitions
    routes: [
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ  HOME ROUTES
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const ProfessionalHomeScreen(),
      ),

      GoRoute(
        path: '/revolutionary-home',
        name: 'revolutionary_home',
        builder: (context, state) => const RevolutionaryHomeScreen(),
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ•Œ ISLAMIC CORE FEATURES
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/quran',
        name: 'quran',
        builder: (context, state) => const QuranExplorerScreen(),
      ),

      GoRoute(
        path: '/prayer-times',
        name: 'prayer_times',
        builder: (context, state) => const PrayerTimesScreen(),
      ),

      GoRoute(
        path: '/qibla',
        name: 'qibla',
        builder: (context, state) => const QiblaCompassScreen(),
      ),

      GoRoute(
        path: '/tasbih',
        name: 'tasbih',
        builder: (context, state) => const DigitalTasbihScreen(),
      ),

      GoRoute(
        path: '/islamic-calendar',
        name: 'islamic_calendar',
        builder: (context, state) => const IslamicCalendarScreen(),
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ” SEARCH & AI FEATURES
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final enableVoice = state.uri.queryParameters['voice'] == 'true';
          return ConversationalSearchScreen(enableVoiceSearch: enableVoice);
        },
      ),

      GoRoute(
        path: '/islamic-search',
        name: 'islamic_search',
        builder: (context, state) => const ProfessionalIslamicSearchScreen(),
      ),

      GoRoute(
        path: '/voice-companion',
        name: 'voice_companion',
        builder: (context, state) => const RevolutionaryVoiceCompanionScreen(),
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ’Ž PREMIUM FEATURES HUB
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/premium',
        name: 'premium_hub',
        builder: (context, state) => const PremiumFeaturesHub(),
        routes: [
          // Premium Audio
          GoRoute(
            path: '/audio',
            name: 'premium_audio',
            builder: (context, state) => const PremiumAudioScreen(),
            routes: [
              GoRoute(
                path: '/qari/:qariId',
                name: 'qari_detail',
                builder: (context, state) {
                  final qariId = state.pathParameters['qariId']!;
                  return QariDetailScreen(qariId: qariId);
                },
              ),
              GoRoute(
                path: '/playlist/:playlistId',
                name: 'playlist_detail',
                builder: (context, state) {
                  final playlistId = state.pathParameters['playlistId']!;
                  return PlaylistDetailScreen(playlistId: playlistId);
                },
              ),
            ],
          ),

          // Islamic University
          GoRoute(
            path: '/university',
            name: 'islamic_university',
            builder: (context, state) => const IslamicUniversityScreen(),
            routes: [
              GoRoute(
                path: '/course/:courseId',
                name: 'course_detail',
                builder: (context, state) {
                  final courseId = state.pathParameters['courseId']!;
                  return CourseDetailScreen(courseId: courseId);
                },
              ),
              GoRoute(
                path: '/live-session/:sessionId',
                name: 'live_session',
                builder: (context, state) {
                  final sessionId = state.pathParameters['sessionId']!;
                  return LiveSessionScreen(sessionId: sessionId);
                },
              ),
            ],
          ),

          // Advanced Analytics
          GoRoute(
            path: '/analytics',
            name: 'premium_analytics',
            builder: (context, state) => const PremiumAnalyticsScreen(),
          ),

          // Smart Collections
          GoRoute(
            path: '/smart-collections',
            name: 'smart_collections',
            builder: (context, state) => const SmartCollectionsScreen(),
          ),

          // Personalized Learning
          GoRoute(
            path: '/learning',
            name: 'personalized_learning',
            builder: (context, state) => const PersonalizedLearningScreen(),
          ),
        ],
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ’³ SUBSCRIPTION & BILLING
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
        routes: [
          GoRoute(
            path: '/billing',
            name: 'billing',
            builder: (context, state) => const BillingScreen(),
          ),
          GoRoute(
            path: '/upgrade/:tier',
            name: 'upgrade',
            builder: (context, state) {
              final tier = state.pathParameters['tier']!;
              return UpgradeScreen(targetTier: tier);
            },
          ),
        ],
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // âš™ï¸ SETTINGS & SUPPORT
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: '/islamic-preferences',
            name: 'islamic_preferences',
            builder: (context, state) => const IslamicPreferencesScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notification_settings',
            builder: (context, state) => const NotificationSettingsScreen(),
          ),
          GoRoute(
            path: '/privacy',
            name: 'privacy_settings',
            builder: (context, state) => const PrivacySettingsScreen(),
          ),
          GoRoute(
            path: '/account',
            name: 'account_settings',
            builder: (context, state) => const AccountSettingsScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const ScreenAssistance(),
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ”— DEEP LINKING ROUTES
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/dua/:duaId',
        name: 'dua_detail',
        builder: (context, state) {
          final duaId = state.pathParameters['duaId']!;
          return DuaDetailScreen(duaId: duaId);
        },
      ),

      GoRoute(
        path: '/share/:type/:id',
        name: 'shared_content',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final id = state.pathParameters['id']!;
          return SharedContentScreen(contentType: type, contentId: id);
        },
      ),

      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      // ðŸ“± WEB-SPECIFIC ROUTES
      // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
      GoRoute(
        path: '/web-wrapper',
        name: 'web_wrapper',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] ?? '';
          return WebWrapperScreen(url: url);
        },
      ),
    ],

    // Redirect logic for authentication and subscription
    redirect: (context, state) {
      // Add any authentication or subscription checks here
      // For now, allow all routes
      return null;
    },
  );
});

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// ðŸ“± PLACEHOLDER SCREENS FOR MISSING PREMIUM FEATURES
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

/// Error screen for navigation issues
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Navigation Error',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for QariDetailScreen
class QariDetailScreen extends StatelessWidget {
  final String qariId;

  const QariDetailScreen({super.key, required this.qariId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qari Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 64),
            const SizedBox(height: 16),
            Text(
              'Qari Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Qari ID: $qariId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for PlaylistDetailScreen
class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.playlist_play, size: 64),
            const SizedBox(height: 16),
            Text(
              'Playlist Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Playlist ID: $playlistId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for CourseDetailScreen
class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 64),
            const SizedBox(height: 16),
            Text(
              'Course Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Course ID: $courseId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for LiveSessionScreen
class LiveSessionScreen extends StatelessWidget {
  final String sessionId;

  const LiveSessionScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Session')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.live_tv, size: 64),
            const SizedBox(height: 16),
            Text(
              'Live Session',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Session ID: $sessionId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder screens for missing premium features
class PremiumAnalyticsScreen extends StatelessWidget {
  const PremiumAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Premium Analytics',
      'Advanced spiritual analytics and progress tracking',
      Icons.analytics,
    );
  }
}

class SmartCollectionsScreen extends StatelessWidget {
  const SmartCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Smart Collections',
      'AI-powered personalized Dua collections',
      Icons.psychology,
    );
  }
}

class PersonalizedLearningScreen extends StatelessWidget {
  const PersonalizedLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Personalized Learning',
      'Adaptive Islamic learning experience',
      Icons.school,
    );
  }
}

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Billing & Payment',
      'Manage your subscription and payment methods',
      Icons.payment,
    );
  }
}

class UpgradeScreen extends StatelessWidget {
  final String targetTier;

  const UpgradeScreen({super.key, required this.targetTier});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Upgrade to $targetTier',
      'Complete your upgrade to unlock premium features',
      Icons.upgrade,
    );
  }
}

class IslamicPreferencesScreen extends StatelessWidget {
  const IslamicPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Islamic Preferences',
      'Customize your Islamic experience and calculations',
      Icons.tune,
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Notification Settings',
      'Manage prayer reminders and app notifications',
      Icons.notifications,
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Privacy Settings',
      'Control your privacy and data sharing preferences',
      Icons.privacy_tip,
    );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Account Settings',
      'Manage your account information and preferences',
      Icons.account_circle,
    );
  }
}

class DuaDetailScreen extends StatelessWidget {
  final String duaId;

  const DuaDetailScreen({super.key, required this.duaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dua Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 64),
            const SizedBox(height: 16),
            Text(
              'Dua Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Dua ID: $duaId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class SharedContentScreen extends StatelessWidget {
  final String contentType;
  final String contentId;

  const SharedContentScreen({
    super.key,
    required this.contentType,
    required this.contentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Content')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.share, size: 64),
            const SizedBox(height: 16),
            Text(
              'Shared Content',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Type: $contentType'),
            Text('ID: $contentId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class WebWrapperScreen extends StatelessWidget {
  final String url;

  const WebWrapperScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return _buildComingSoonScreen(
      context,
      'Web View',
      'Enhanced web wrapper for external content',
      Icons.web,
    );
  }
}

/// Helper function to build "coming soon" screens
Widget _buildComingSoonScreen(
  BuildContext context,
  String title,
  String description,
  IconData icon,
) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(
              context,
            ).colorScheme.primaryContainer.withOpacity(0.1),
            Theme.of(
              context,
            ).colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Coming Soon',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: () => context.go('/premium'),
                    icon: const Icon(Icons.star),
                    label: const Text('View Premium'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
