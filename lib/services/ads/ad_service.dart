import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive ad service for DuaCopilot app
/// Handles banner ads, interstitial ads, and rewarded ads
class AdService {
  static AdService? _instance;
  static AdService get instance => _instance ??= AdService._();

  AdService._();

  // Ad Unit IDs
  static const String _bannerAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String _bannerAdUnitIdiOS =
      'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String _interstitialAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String _interstitialAdUnitIdiOS =
      'ca-app-pub-3940256099942544/4411468910'; // Test ID
  static const String _rewardedAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String _rewardedAdUnitIdiOS =
      'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // State management
  bool _isInitialized = false;
  bool _adsEnabled = true;
  bool _isPremiumUser = false;
  int _interstitialClickCount = 0;
  static const int _interstitialFrequency = 3; // Show every 3 searches/actions

  // Ad load states
  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  /// Initialize the ad service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Only initialize ads on supported platforms (Android, iOS) - skip web
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await MobileAds.instance.initialize();

        // Load user preferences
        await _loadUserPreferences();

        // Load initial ads if ads are enabled
        if (_adsEnabled && !_isPremiumUser) {
          await _loadBannerAd();
          await _loadInterstitialAd();
          await _loadRewardedAd();
        }
      } else {
        // For unsupported platforms (Windows, Web, etc.), just load preferences
        print(
          'AdService: Ads not supported on this platform, skipping ad initialization',
        );
        await _loadUserPreferences();
      }

      _isInitialized = true;
      print('AdService initialized successfully');
    } catch (e) {
      print('Error initializing AdService: $e');
      // Still mark as initialized to prevent crashes
      _isInitialized = true;
    }
  }

  /// Load user preferences for ad settings
  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _adsEnabled = prefs.getBool('ads_enabled') ?? true;
      _isPremiumUser = prefs.getBool('is_premium_user') ?? false;
      _interstitialClickCount = prefs.getInt('interstitial_click_count') ?? 0;
    } catch (e) {
      print('Error loading user preferences: $e');
    }
  }

  /// Update premium user status
  Future<void> setPremiumUser(bool isPremium) async {
    _isPremiumUser = isPremium;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_premium_user', isPremium);

      if (isPremium) {
        // Dispose all ads for premium users
        _disposeBannerAd();
        _disposeInterstitialAd();
        _disposeRewardedAd();
      } else {
        // Reload ads for non-premium users
        await _loadBannerAd();
        await _loadInterstitialAd();
        await _loadRewardedAd();
      }
    } catch (e) {
      print('Error setting premium user status: $e');
    }
  }

  /// Check if ads should be shown
  bool get shouldShowAds {
    if (kIsWeb) return false; // No ads on web
    
    return _adsEnabled &&
        !_isPremiumUser &&
        _isInitialized &&
        (Platform.isAndroid ||
            Platform.isIOS); // Only show ads on supported mobile platforms
  }

  /// Get platform-specific ad unit IDs
  String get _bannerAdUnitId {
    if (kIsWeb) return ''; // No ads on web
    
    if (Platform.isAndroid) {
      return _bannerAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return _bannerAdUnitIdiOS;
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get _interstitialAdUnitId {
    if (kIsWeb) return ''; // No ads on web
    
    if (Platform.isAndroid) {
      return _interstitialAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return _interstitialAdUnitIdiOS;
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get _rewardedAdUnitId {
    if (kIsWeb) return ''; // No ads on web
    
    if (Platform.isAndroid) {
      return _rewardedAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return _rewardedAdUnitIdiOS;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Load banner ad
  Future<void> _loadBannerAd() async {
    if (!shouldShowAds) return;

    try {
      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _isBannerAdLoaded = true;
            print('Banner ad loaded successfully');
          },
          onAdFailedToLoad: (ad, error) {
            _isBannerAdLoaded = false;
            print('Banner ad failed to load: $error');
            ad.dispose();
            // Retry loading after delay
            Future.delayed(const Duration(seconds: 30), _loadBannerAd);
          },
          onAdOpened: (ad) => print('Banner ad opened'),
          onAdClosed: (ad) => print('Banner ad closed'),
        ),
      );

      await _bannerAd?.load();
    } catch (e) {
      print('Error loading banner ad: $e');
    }
  }

  /// Load interstitial ad
  Future<void> _loadInterstitialAd() async {
    if (!shouldShowAds) return;

    try {
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isInterstitialAdLoaded = true;
            print('Interstitial ad loaded successfully');

            _interstitialAd?.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isInterstitialAdLoaded = false;
            print('Interstitial ad failed to load: $error');
            // Retry loading after delay
            Future.delayed(const Duration(seconds: 60), _loadInterstitialAd);
          },
        ),
      );
    } catch (e) {
      print('Error loading interstitial ad: $e');
    }
  }

  /// Load rewarded ad
  Future<void> _loadRewardedAd() async {
    if (!shouldShowAds) return;

    try {
      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isRewardedAdLoaded = true;
            print('Rewarded ad loaded successfully');
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isRewardedAdLoaded = false;
            print('Rewarded ad failed to load: $error');
            // Retry loading after delay
            Future.delayed(const Duration(seconds: 60), _loadRewardedAd);
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded ad: $e');
    }
  }

  /// Get banner ad widget
  Widget? getBannerAdWidget() {
    if (!shouldShowAds || !_isBannerAdLoaded || _bannerAd == null) {
      return null;
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// Show interstitial ad with frequency control
  Future<void> showInterstitialAd({
    VoidCallback? onAdClosed,
    VoidCallback? onPremiumPrompt,
  }) async {
    if (!shouldShowAds) return;

    _interstitialClickCount++;

    // Save updated count
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('interstitial_click_count', _interstitialClickCount);
    } catch (e) {
      print('Error saving interstitial click count: $e');
    }

    // Show ad based on frequency
    if (_interstitialClickCount % _interstitialFrequency == 0) {
      if (_isInterstitialAdLoaded && _interstitialAd != null) {
        _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent:
              (InterstitialAd ad) =>
                  print('Interstitial ad showed full screen content'),
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            print('Interstitial ad dismissed');
            ad.dispose();
            _loadInterstitialAd(); // Load next ad
            onAdClosed?.call();
          },
          onAdFailedToShowFullScreenContent: (
            InterstitialAd ad,
            AdError error,
          ) {
            print('Interstitial ad failed to show: $error');
            ad.dispose();
            _loadInterstitialAd(); // Load next ad
          },
        );

        await _interstitialAd?.show();
      } else {
        // If no ad available, show premium prompt
        onPremiumPrompt?.call();
      }
    }
  }

  /// Show rewarded ad
  Future<void> showRewardedAd({
    required Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) async {
    if (!shouldShowAds || !_isRewardedAdLoaded || _rewardedAd == null) {
      return;
    }

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent:
          (RewardedAd ad) => print('Rewarded ad showed full screen content'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Rewarded ad dismissed');
        ad.dispose();
        _loadRewardedAd(); // Load next ad
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Rewarded ad failed to show: $error');
        ad.dispose();
        _loadRewardedAd(); // Load next ad
      },
    );

    await _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) => onUserEarnedReward(reward),
    );
  }

  /// Check if rewarded ad is available
  bool get isRewardedAdAvailable =>
      _isRewardedAdLoaded && _rewardedAd != null && shouldShowAds;

  /// Check if premium upgrade should be shown
  Future<bool> shouldShowPremiumUpgrade() async {
    if (_isPremiumUser) return false;

    final prefs = await SharedPreferences.getInstance();
    final searchCount = prefs.getInt('search_count') ?? 0;

    // Show upgrade prompt every 5 searches for non-premium users
    return searchCount > 0 && searchCount % 5 == 0;
  }

  /// Dispose banner ad
  void _disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
  }

  /// Dispose interstitial ad
  void _disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
  }

  /// Dispose rewarded ad
  void _disposeRewardedAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdLoaded = false;
  }

  /// Disable ads temporarily (e.g., during prayer times)
  Future<void> setAdsEnabled(bool enabled) async {
    _adsEnabled = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ads_enabled', enabled);

      if (!enabled) {
        _disposeBannerAd();
        _disposeInterstitialAd();
        _disposeRewardedAd();
      } else if (!_isPremiumUser) {
        await _loadBannerAd();
        await _loadInterstitialAd();
        await _loadRewardedAd();
      }
    } catch (e) {
      print('Error setting ads enabled: $e');
    }
  }

  /// Get ad statistics
  Map<String, dynamic> getAdStats() {
    return {
      'is_initialized': _isInitialized,
      'ads_enabled': _adsEnabled,
      'is_premium_user': _isPremiumUser,
      'should_show_ads': shouldShowAds,
      'banner_ad_loaded': _isBannerAdLoaded,
      'interstitial_ad_loaded': _isInterstitialAdLoaded,
      'rewarded_ad_loaded': _isRewardedAdLoaded,
      'interstitial_click_count': _interstitialClickCount,
      'interstitial_frequency': _interstitialFrequency,
    };
  }

  /// Dispose all ads and clean up
  void dispose() {
    _disposeBannerAd();
    _disposeInterstitialAd();
    _disposeRewardedAd();
    _isInitialized = false;
    print('AdService disposed');
  }
}

/// Helper extension for easier integration
extension AdServiceExtension on AdService {
  /// Quick method to show interstitial with premium upgrade prompt
  Future<void> showInterstitialWithUpgradePrompt({
    required VoidCallback onShowUpgradeDialog,
    VoidCallback? onAdClosed,
  }) async {
    await showInterstitialAd(
      onAdClosed: onAdClosed,
      onPremiumPrompt: onShowUpgradeDialog,
    );
  }
}
