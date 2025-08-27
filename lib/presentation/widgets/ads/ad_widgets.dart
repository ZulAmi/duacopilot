import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../services/ads/ad_service.dart';

/// Smart banner ad widget that only shows for non-premium users
class SmartBannerAd extends StatefulWidget {
  final EdgeInsets? margin;
  final Color? backgroundColor;

  const SmartBannerAd({super.key, this.margin, this.backgroundColor});

  @override
  State<SmartBannerAd> createState() => _SmartBannerAdState();
}

/// _SmartBannerAdState class implementation
class _SmartBannerAdState extends State<SmartBannerAd> {
  @override
  Widget build(BuildContext context) {
    final adWidget = AdService.instance.getBannerAdWidget();

    if (adWidget == null) {
      return const SizedBox.shrink(); // Don't show anything if no ad
    }

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: adWidget),
    );
  }
}

/// Interstitial ad trigger widget
class InterstitialAdTrigger extends StatelessWidget {
  final Widget? child;
  final int? searchCount;
  final VoidCallback? onTap;
  final VoidCallback? onAdClosed;
  final VoidCallback? onPremiumPrompt;
  final bool showUpgradePrompt;

  const InterstitialAdTrigger({
    super.key,
    this.child,
    this.searchCount,
    this.onTap,
    this.onAdClosed,
    this.onPremiumPrompt,
    this.showUpgradePrompt = true,
  });

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () async {
        // Execute the original tap action first
        onTap?.call();

        // Then potentially show ad
        if (AdService.instance.shouldShowAds) {
          await AdService.instance.showInterstitialAd(
            onAdClosed: onAdClosed,
            onPremiumPrompt:
                showUpgradePrompt ? () => _showUpgradeDialog(context) : null,
          );
        }
      },
      child: child,
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PremiumUpgradeDialog(),
    );
  }
}

/// Rewarded ad button for unlocking premium features temporarily
class RewardedAdButton extends StatefulWidget {
  final String rewardDescription;
  final Function(RewardItem reward) onRewardEarned;
  final VoidCallback? onAdClosed;
  final Widget? child;

  const RewardedAdButton({
    super.key,
    required this.rewardDescription,
    required this.onRewardEarned,
    this.onAdClosed,
    this.child,
  });

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

/// _RewardedAdButtonState class implementation
class _RewardedAdButtonState extends State<RewardedAdButton> {
  @override
  Widget build(BuildContext context) {
    final isAvailable = AdService.instance.isRewardedAdAvailable;

    return ElevatedButton.icon(
      onPressed: isAvailable ? _showRewardedAd : null,
      icon: const Icon(Icons.play_circle_filled),
      label: widget.child ??
          Text(
            isAvailable
                ? 'Watch Ad for ${widget.rewardDescription}'
                : 'Loading...',
          ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAvailable ? Colors.green : Colors.grey,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showRewardedAd() async {
    await AdService.instance.showRewardedAd(
      onUserEarnedReward: widget.onRewardEarned,
      onAdClosed: widget.onAdClosed,
    );
  }
}

/// Premium upgrade dialog
class PremiumUpgradeDialog extends StatelessWidget {
  final VoidCallback? onUpgrade;
  final VoidCallback? onWatchAd;

  const PremiumUpgradeDialog({super.key, this.onUpgrade, this.onWatchAd});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 8),
          Text('Upgrade to Premium'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enjoy an ad-free experience with premium features:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          FeatureItem(
            icon: Icons.search,
            text: 'Unlimited AI-powered searches',
          ),
          FeatureItem(
            icon: Icons.offline_bolt,
            text: 'Full offline semantic search',
          ),
          FeatureItem(icon: Icons.audiotrack, text: 'Premium audio features'),
          FeatureItem(icon: Icons.analytics, text: 'Advanced habit tracking'),
          FeatureItem(icon: Icons.block, text: 'No advertisements'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Maybe Later'),
        ),
        if (onWatchAd != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onWatchAd?.call();
            },
            child: const Text('Watch Ad'),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onUpgrade?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: const Text('Upgrade Now'),
        ),
      ],
    );
  }
}

/// Feature item widget for premium dialog
class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

/// Ad configuration widget for testing and development
class AdConfigWidget extends StatelessWidget {
  const AdConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ad Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: Future.value(AdService.instance.getAdStats()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final stats = snapshot.data!;
                return Column(
                  children: stats.entries.map((entry) {
                    return ListTile(
                      title: Text(
                        entry.key.replaceAll('_', ' ').toUpperCase(),
                      ),
                      trailing: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          color: entry.value is bool
                              ? (entry.value ? Colors.green : Colors.red)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AdService.instance.setPremiumUser(true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Premium mode enabled')),
                        );
                      }
                    },
                    child: const Text('Enable Premium'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AdService.instance.setPremiumUser(false);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Premium mode disabled'),
                          ),
                        );
                      }
                    },
                    child: const Text('Disable Premium'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
