import 'package:flutter/material.dart';
import '../widgets/ads/ad_widgets.dart';

/// AdDemoScreen class implementation
class AdDemoScreen extends StatefulWidget {
  const AdDemoScreen({super.key});

  @override
  State<AdDemoScreen> createState() => _AdDemoScreenState();
}

/// _AdDemoScreenState class implementation
class _AdDemoScreenState extends State<AdDemoScreen> {
  int _searchCount = 0;
  bool _isPremium = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Integration Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // Premium Status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isPremium ? Colors.green.shade100 : Colors.orange.shade100,
            child: Row(
              children: [
                Icon(_isPremium ? Icons.star : Icons.star_border, color: _isPremium ? Colors.green : Colors.orange),
                const SizedBox(width: 8),
                Text(
                  _isPremium ? 'Premium User (Ad-Free)' : 'Free User (Ad-Supported)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isPremium ? Colors.green.shade800 : Colors.orange.shade800,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _isPremium,
                  onChanged: (value) {
                    setState(() {
                      _isPremium = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Search Counter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                Text('Searches Performed: $_searchCount', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Interstitial ads show every 3 searches', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _searchCount++;
                    });
                    _simulateSearch();
                  },
                  child: const Text('Simulate Search'),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ad Integration Examples
                  Text('Ad Integration Examples', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),

                  // Rewarded Ad Example
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.play_circle_filled, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Text('Rewarded Ad Example', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Users can watch ads to unlock premium features temporarily.'),
                          const SizedBox(height: 16),
                          RewardedAdButton(
                            rewardDescription: 'Get 30 minutes of ad-free experience',
                            onRewardEarned: (reward) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Reward earned: ${reward.amount} ${reward.type}! 30 minutes ad-free!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Premium Upgrade Example
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text('Premium Upgrade', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Show premium upgrade dialogs to convert free users.'),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _showPremiumDialog, child: const Text('Show Premium Dialog')),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Monetization Strategy
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monetization Strategy', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          const Text(
                            '💰 Freemium Model: \$6.99-9.99/month\n'
                            '📱 Banner ads at bottom of screens\n'
                            '🎯 Interstitial ads every 3 searches\n'
                            '🎁 Rewarded ads for premium features\n'
                            '⭐ Premium removes all ads\n'
                            '🌍 Regional pricing optimization\n'
                            '📊 A/B testing for conversion',
                            style: TextStyle(height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Technical Implementation
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Technical Implementation', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          const Text(
                            '✅ Google AdMob SDK integrated\n'
                            '✅ Ad service with singleton pattern\n'
                            '✅ Reusable ad widgets created\n'
                            '✅ Frequency controls implemented\n'
                            '✅ Premium user management\n'
                            '✅ Cross-platform configuration\n'
                            '✅ Test ad units configured\n'
                            '✅ Production-ready architecture',
                            style: TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: const Text(
                              '📝 Next Steps:\n'
                              '1. Replace test ad unit IDs with production IDs\n'
                              '2. Configure AdMob account and app settings\n'
                              '3. Implement in-app purchase for premium\n'
                              '4. Add analytics tracking for ad performance\n'
                              '5. Test on real devices before publishing',
                              style: TextStyle(fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Space for banner ad
                ],
              ),
            ),
          ),

          // Banner Ad (shows when not premium)
          if (!_isPremium) const SmartBannerAd(),
        ],
      ),
    );
  }

  void _simulateSearch() {
    // Simulate interstitial ad trigger every 3 searches
    if (_searchCount % 3 == 0 && !_isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎯 Interstitial ad would show here (every 3 searches)'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Show premium upgrade prompt occasionally
    if (_searchCount % 5 == 0 && !_isPremium) {
      Future.delayed(const Duration(seconds: 1), _showPremiumDialog);
    }
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder:
          (context) => PremiumUpgradeDialog(
            onUpgrade: () {
              Navigator.of(context).pop();
              setState(() {
                _isPremium = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎉 Welcome to Premium! Ads removed.'), backgroundColor: Colors.green),
              );
            },
            onWatchAd: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎁 Watched ad! 30 minutes ad-free experience.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
    );
  }
}
