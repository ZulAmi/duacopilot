import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'premium_audio_screen.dart';
import 'islamic_university_screen.dart';

// Subscription tier enum
enum SubscriptionTier { free, premium, ultimate, family }

// Mock subscription data
class SubscriptionData {
  final bool isActive;
  final SubscriptionTier tier;

  const SubscriptionData({
    this.isActive = true, // Always active for demo
    this.tier = SubscriptionTier.premium,
  });
}

// Simple mock provider
final subscriptionProvider = Provider<SubscriptionData>((ref) {
  return const SubscriptionData();
});

/// Premium Features Hub - Gateway to All Premium Islamic Features
class PremiumFeaturesHub extends ConsumerWidget {
  const PremiumFeaturesHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Islamic Features'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: subscription.isActive
          ? _buildPremiumFeatures(context, subscription.tier)
          : _buildSubscriptionRequired(context),
    );
  }

  /// Build subscription required screen
  Widget _buildSubscriptionRequired(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_outline,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Premium Subscription Required',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Unlock exclusive Islamic content with famous Qaris, Islamic Knowledge University, and advanced spiritual features.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/subscription'),
              icon: const Icon(Icons.upgrade),
              label: const Text('Upgrade to Premium'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build premium features grid
  Widget _buildPremiumFeatures(BuildContext context, SubscriptionTier tier) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.05),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context, tier),
            const SizedBox(height: 24),
            _buildFeaturesGrid(context, tier),
            const SizedBox(height: 24),
            _buildQuickAccess(context),
            const SizedBox(height: 24),
            _buildRecommendations(context),
          ],
        ),
      ),
    );
  }

  /// Build welcome header with subscription tier
  Widget _buildWelcomeHeader(BuildContext context, SubscriptionTier tier) {
    final tierName = tier.toString().split('.').last.toUpperCase();
    final tierColor = _getTierColor(tier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tierColor.withOpacity(0.1), tierColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tierColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$tierName MEMBER',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.star, color: tierColor, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to Premium Islamic Experience',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Access exclusive content from world-renowned Islamic scholars and Qaris',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Build features grid
  Widget _buildFeaturesGrid(BuildContext context, SubscriptionTier tier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              context: context,
              title: 'Premium Audio',
              subtitle: 'Famous Qaris & Advanced Audio Features',
              icon: Icons.headphones,
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PremiumAudioScreen(),
                ),
              ),
              features: [
                'Al-Afasy',
                'Sudais',
                'Minshawi',
                'Sleep Timer',
                'Offline Downloads',
              ],
            ),
            _buildFeatureCard(
              context: context,
              title: 'Islamic University',
              subtitle: 'Learn from Renowned Scholars',
              icon: Icons.school,
              gradient: const LinearGradient(
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const IslamicUniversityScreen(),
                ),
              ),
              features: [
                'Video Courses',
                'Live Q&A',
                'Certificates',
                'Personal Curriculum',
                'Expert Guidance',
              ],
            ),
            _buildFeatureCard(
              context: context,
              title: 'Advanced Analytics',
              subtitle: 'Track Your Spiritual Journey',
              icon: Icons.analytics,
              gradient: const LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
              onTap: () => context.push('/premium/analytics'),
              features: [
                'Prayer Tracking',
                'Learning Progress',
                'Goals & Achievements',
              ],
            ),
            _buildFeatureCard(
              context: context,
              title: 'AI Islamic Assistant',
              subtitle: 'Personalized Islamic Guidance',
              icon: Icons.psychology,
              gradient: const LinearGradient(
                colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
              ),
              onTap: () => context.push('/premium/ai-assistant'),
              features: [
                'Smart Q&A',
                'Personalized Duas',
                'Islamic Decision Support',
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Build individual feature card
  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
    required List<String> features,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 28),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features
                        .take(3)
                        .map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build quick access section
  Widget _buildQuickAccess(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickAccessTile(
                context: context,
                title: 'Continue Learning',
                subtitle: 'Resume your course',
                icon: Icons.play_circle_outline,
                onTap: () => context.push('/premium/continue-learning'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickAccessTile(
                context: context,
                title: 'Daily Duas',
                subtitle: 'Today\'s collection',
                icon: Icons.today,
                onTap: () => context.push('/premium/daily-duas'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build quick access tile
  Widget _buildQuickAccessTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build recommendations section
  Widget _buildRecommendations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRecommendationCard(
                context: context,
                title: 'Arabic Foundations',
                instructor: 'Nouman Ali Khan',
                image: 'assets/images/courses/arabic_foundations.jpg',
                onTap: () => context.push('/course/arabic_foundations'),
              ),
              _buildRecommendationCard(
                context: context,
                title: 'Spiritual Development',
                instructor: 'Dr. Omar Suleiman',
                image: 'assets/images/courses/spiritual_development.jpg',
                onTap: () => context.push('/course/spiritual_development'),
              ),
              _buildRecommendationCard(
                context: context,
                title: 'Al-Afasy Recitations',
                instructor: 'Sheikh Mishary',
                image: 'assets/images/qaris/al_afasy.jpg',
                onTap: () => context.push('/audio/al-afasy'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build recommendation card
  Widget _buildRecommendationCard({
    required BuildContext context,
    required String title,
    required String instructor,
    required String image,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.8),
                        Theme.of(context).primaryColor,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        instructor,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  /// Get tier color
  Color _getTierColor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.premium:
        return const Color(0xFFFFD700); // Gold
      case SubscriptionTier.family:
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF2196F3); // Blue
    }
  }
}
