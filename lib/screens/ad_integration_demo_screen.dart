import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../presentation/widgets/ads/ad_widgets.dart';
import '../services/ads/ad_service.dart';

/// Demo screen showing ad integration in DuaCopilot
class AdIntegrationDemoScreen extends StatefulWidget {
  const AdIntegrationDemoScreen({Key? key}) : super(key: key);

  @override
  State<AdIntegrationDemoScreen> createState() =>
      _AdIntegrationDemoScreenState();
}

class _AdIntegrationDemoScreenState extends State<AdIntegrationDemoScreen> {
  int _searchCount = 0;
  bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _initializeAds();
  }

  Future<void> _initializeAds() async {
    await AdService.instance.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Integration Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Premium Status Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isPremiumUser ? Colors.amber : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPremiumUser ? Colors.amber : Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isPremiumUser ? Icons.star : Icons.star_border,
                  color: _isPremiumUser ? Colors.amber : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isPremiumUser
                        ? 'Premium User - No Ads'
                        : 'Free User - Ads Enabled',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          _isPremiumUser ? Colors.amber[800] : Colors.grey[700],
                    ),
                  ),
                ),
                Switch(
                  value: _isPremiumUser,
                  onChanged: (value) async {
                    setState(() => _isPremiumUser = value);
                    await AdService.instance.setPremiumUser(value);
                  },
                ),
              ],
            ),
          ),

          // Search Demo Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Count Display
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Search Count: $_searchCount',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Interstitial ads show every 3 searches for free users',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Demo Search Buttons
                  ElevatedButton.icon(
                    onPressed: _performDemoSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Perform Search (with Interstitial Ad)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rewarded Ad Button
                  if (AdService.instance.isRewardedAdAvailable)
                    RewardedAdButton(
                      rewardDescription: 'Premium Features (24 hours)',
                      onRewardEarned: (reward) {
                        _showRewardDialog(reward);
                      },
                      onAdClosed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Rewarded ad closed')),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // Demo Content Cards
                  ...List.generate(5, (index) => _buildDemoCard(index + 1)),

                  const SizedBox(height: 20),

                  // Ad Configuration (for testing)
                  const AdConfigWidget(),
                ],
              ),
            ),
          ),

          // Banner Ad at bottom
          const SmartBannerAd(margin: EdgeInsets.all(8)),
        ],
      ),
    );
  }

  Widget _buildDemoCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Text('$index')),
        title: Text('Du\'a Example $index'),
        subtitle: Text('This is a demo Islamic content item #$index'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _performDemoSearch(),
      ),
    );
  }

  Future<void> _performDemoSearch() async {
    setState(() {
      _searchCount++;
    });

    // Show interstitial ad with frequency control
    await AdService.instance.showInterstitialAd(
      onAdClosed: () {
        _showSearchResults();
      },
      onPremiumPrompt: () {
        _showPremiumUpgradeDialog();
      },
    );

    // If no ad shown (premium user or ad not available), show results immediately
    if (!AdService.instance.shouldShowAds) {
      _showSearchResults();
    }
  }

  void _showSearchResults() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Results'),
            content: Text('Search #$_searchCount completed successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => const PremiumUpgradeDialog(),
    );
  }

  void _showRewardDialog(RewardItem reward) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('🎉 Reward Earned!'),
            content: Text(
              'You earned ${reward.amount} ${reward.type}!\n\n'
              'Enjoy premium features for the next 24 hours.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Awesome!'),
              ),
            ],
          ),
    );
  }
}

/// Helper widget to demonstrate ad placement strategies
class AdPlacementDemoWidget extends StatelessWidget {
  const AdPlacementDemoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ad Placement Examples')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Example 1: Banner ad between content sections
            _buildContentSection('Morning Du\'as', Icons.wb_sunny),
            const SmartBannerAd(),

            _buildContentSection('Evening Du\'as', Icons.nights_stay),
            const SmartBannerAd(),

            _buildContentSection('Travel Du\'as', Icons.flight),

            // Example 2: Interstitial trigger on important actions
            InterstitialAdTrigger(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Audio played after ad')),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '▶ Play Audio Recitation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.green),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
