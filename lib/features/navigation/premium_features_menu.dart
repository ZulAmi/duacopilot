import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/screens/ai/smart_dua_collections_screen.dart';
import '../../presentation/screens/conversational_search_screen.dart';
import '../../presentation/screens/courses/islamic_courses_screen.dart';
import '../../presentation/screens/subscription/subscription_screen.dart';
import '../qibla/screens/qibla_compass_screen.dart';
import '../tasbih/screens/digital_tasbih_screen.dart';

/// Premium Features Navigation Menu
class PremiumFeaturesMenu extends ConsumerWidget {
  final VoidCallback? onClose;

  const PremiumFeaturesMenu({super.key, this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF6A4C93), const Color(0xFF6A4C93).withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.mosque, size: 40, color: Color(0xFF6A4C93)),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'DuaCopilot Premium',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('Islamic AI Companion', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    children: [
                      // Main Search
                      _buildMenuItem(
                        context,
                        icon: Icons.search,
                        title: 'AI Islamic Search',
                        subtitle: 'Conversational search with RAG',
                        onTap: () => _navigateTo(context, const ConversationalSearchScreen()),
                      ),

                      const Divider(),

                      // Premium Features Section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.workspace_premium, color: Colors.amber.shade600, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Premium Features',
                              style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      // Qibla Compass & Prayer Tracker
                      _buildMenuItem(
                        context,
                        icon: Icons.navigation,
                        title: '🧭 Qibla Compass',
                        subtitle: 'GPS compass & prayer tracker',
                        isPremium: true,
                        onTap: () => _navigateTo(context, const QiblaCompassScreen()),
                      ),

                      // Digital Tasbih
                      _buildMenuItem(
                        context,
                        icon: Icons.touch_app,
                        title: '📿 Digital Tasbih',
                        subtitle: 'Voice recognition & smart goals',
                        isPremium: true,
                        onTap: () => _navigateTo(context, const DigitalTasbihScreen()),
                      ),

                      // Smart Dua Collections
                      _buildMenuItem(
                        context,
                        icon: Icons.psychology,
                        title: '🧠 Smart Dua Collections',
                        subtitle: 'AI-powered contextual duas',
                        isPremium: true,
                        onTap: () => _navigateTo(context, const SmartDuaCollectionsScreen()),
                      ),

                      // Islamic Courses
                      _buildMenuItem(
                        context,
                        icon: Icons.school,
                        title: '📚 Islamic Courses',
                        subtitle: 'Learn & grow in faith',
                        onTap: () => _navigateTo(context, const IslamicCoursesScreen()),
                      ),

                      const Divider(),

                      // Additional Features
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite,
                        title: 'Favorites',
                        subtitle: 'Your saved duas & content',
                        onTap: () => _showComingSoon(context, 'Favorites'),
                      ),

                      _buildMenuItem(
                        context,
                        icon: Icons.history,
                        title: 'Prayer History',
                        subtitle: 'Track your spiritual journey',
                        isPremium: true,
                        onTap: () => _showComingSoon(context, 'Prayer History'),
                      ),

                      _buildMenuItem(
                        context,
                        icon: Icons.notifications,
                        title: 'Smart Reminders',
                        subtitle: 'AI-powered prayer alerts',
                        isPremium: true,
                        onTap: () => _showComingSoon(context, 'Smart Reminders'),
                      ),

                      _buildMenuItem(
                        context,
                        icon: Icons.analytics,
                        title: 'Spiritual Analytics',
                        subtitle: 'Track your progress',
                        isPremium: true,
                        onTap: () => _showComingSoon(context, 'Spiritual Analytics'),
                      ),

                      const Divider(),

                      // Settings & Support
                      _buildMenuItem(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        subtitle: 'Preferences & customization',
                        onTap: () => _showComingSoon(context, 'Settings'),
                      ),

                      _buildMenuItem(
                        context,
                        icon: Icons.help,
                        title: 'Help & Support',
                        subtitle: 'Get assistance & feedback',
                        onTap: () => _showComingSoon(context, 'Help & Support'),
                      ),

                      const SizedBox(height: 20),

                      // Subscription Button
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton.icon(
                          onPressed: () => _navigateTo(context, const SubscriptionScreen()),
                          icon: Icon(Icons.workspace_premium, color: Colors.amber.shade700),
                          label: const Text('Upgrade to Premium'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade50,
                            foregroundColor: Colors.amber.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.amber.shade200),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isPremium ? Colors.amber.shade50 : const Color(0xFF6A4C93).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isPremium ? Colors.amber.shade200 : const Color(0xFF6A4C93).withOpacity(0.3)),
        ),
        child: Icon(icon, color: isPremium ? Colors.amber.shade700 : const Color(0xFF6A4C93)),
      ),
      title: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
          if (isPremium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Text(
                'PRO',
                style: TextStyle(color: Colors.amber.shade700, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    onClose?.call();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  void _showComingSoon(BuildContext context, String feature) {
    onClose?.call();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.construction, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                const Text('Coming Soon'),
              ],
            ),
            content: Text('$feature is currently under development. Stay tuned for updates!'),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
          ),
    );
  }
}

/// Premium Features Navigation Provider
final premiumFeaturesMenuProvider = Provider<PremiumFeaturesMenu>((ref) {
  return const PremiumFeaturesMenu();
});
