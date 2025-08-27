import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../core/models/subscription_models.dart';

/// Mock product details for development
class ProductDetails {
  final String id;
  final String title;
  final String description;
  final String price;
  final double rawPrice;
  final String currencyCode;

  ProductDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
  });
}

/// Mock purchase details for development
class PurchaseDetails {
  final String productID;
  final String purchaseID;
  final String status;
  final dynamic error;
  final bool pendingCompletePurchase;

  PurchaseDetails({
    required this.productID,
    required this.purchaseID,
    required this.status,
    this.error,
    this.pendingCompletePurchase = false,
  });
}

/// Purchase status enum
enum PurchaseStatus { purchased, error, pending, canceled, restored }

/// Subscription service for managing user subscriptions
class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService get instance =>
      _instance ??= SubscriptionService._();

  SubscriptionService._();

  // Purchase stream controller for mock implementation
  final StreamController<List<PurchaseDetails>> _purchaseStreamController =
      StreamController<List<PurchaseDetails>>.broadcast();

  // Current user subscription state
  UserSubscription? _currentSubscription;
  List<ProductDetails> _availableProducts = [];
  bool _isInitialized = false;

  // Product IDs for different plans
  static const Map<SubscriptionTier, String> _productIds = {
    SubscriptionTier.basic: 'duacopilot_basic_monthly',
    SubscriptionTier.premium: 'duacopilot_premium_monthly',
    SubscriptionTier.family: 'duacopilot_family_monthly',
  };

  static const Map<SubscriptionTier, String> _yearlyProductIds = {
    SubscriptionTier.basic: 'duacopilot_basic_yearly',
    SubscriptionTier.premium: 'duacopilot_premium_yearly',
    SubscriptionTier.family: 'duacopilot_family_yearly',
  };

  /// Initialize the subscription service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // For now, we'll use mock data for development
      await _loadMockProducts();
      await _loadCurrentSubscription();

      _isInitialized = true;
      AppLogger.debug('SubscriptionService initialized successfully');
    } catch (e) {
      AppLogger.error('Error initializing SubscriptionService: $e');
      await _loadMockSubscription(); // Fallback for development
    }
  }

  /// Load mock products for development
  Future<void> _loadMockProducts() async {
    _availableProducts = [
      ProductDetails(
        id: 'duacopilot_basic_monthly',
        title: 'DuaCopilot Basic Monthly',
        description: 'Essential Islamic features',
        price: '\$4.99',
        rawPrice: 4.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'duacopilot_premium_monthly',
        title: 'DuaCopilot Premium Monthly',
        description: 'Complete Islamic companion',
        price: '\$9.99',
        rawPrice: 9.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'duacopilot_family_monthly',
        title: 'DuaCopilot Family Monthly',
        description: 'Perfect for Islamic families',
        price: '\$14.99',
        rawPrice: 14.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'duacopilot_basic_yearly',
        title: 'DuaCopilot Basic Yearly',
        description: 'Essential Islamic features (Save 17%)',
        price: '\$49.99',
        rawPrice: 49.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'duacopilot_premium_yearly',
        title: 'DuaCopilot Premium Yearly',
        description: 'Complete Islamic companion (Save 17%)',
        price: '\$99.99',
        rawPrice: 99.99,
        currencyCode: 'USD',
      ),
      ProductDetails(
        id: 'duacopilot_family_yearly',
        title: 'DuaCopilot Family Yearly',
        description: 'Perfect for Islamic families (Save 17%)',
        price: '\$149.99',
        rawPrice: 149.99,
        currencyCode: 'USD',
      ),
    ];

    AppLogger.debug('Loaded ${_availableProducts.length} mock products');
  }

  /// Purchase a subscription (mock implementation for development)
  Future<bool> purchaseSubscription(
    SubscriptionTier tier, {
    bool yearly = false,
  }) async {
    try {
      final String productId =
          yearly ? _yearlyProductIds[tier]! : _productIds[tier]!;

      final ProductDetails? product =
          _availableProducts.where((p) => p.id == productId).firstOrNull;

      if (product == null) {
        AppLogger.error('Product not found: $productId');
        return false;
      }

      // Simulate purchase process
      await Future.delayed(const Duration(seconds: 1));

      // Create mock purchase
      final purchase = PurchaseDetails(
        productID: productId,
        purchaseID: 'mock_purchase_${DateTime.now().millisecondsSinceEpoch}',
        status: 'purchased',
      );

      // Process the purchase
      await _processPurchase(purchase, tier, yearly);

      AppLogger.debug('Mock purchase completed for $productId');
      return true;
    } catch (e) {
      AppLogger.error('Error purchasing subscription: $e');
      return false;
    }
  }

  /// Process successful purchase
  Future<void> _processPurchase(
    PurchaseDetails purchase,
    SubscriptionTier tier,
    bool yearly,
  ) async {
    try {
      final now = DateTime.now();
      final endDate = yearly
          ? now.add(const Duration(days: 365))
          : now.add(const Duration(days: 30));

      final product = _availableProducts
          .where((p) => p.id == purchase.productID)
          .firstOrNull;

      _currentSubscription = UserSubscription(
        userId: 'current_user', // Replace with actual user ID
        tier: tier,
        startDate: now,
        endDate: endDate,
        subscriptionId: purchase.purchaseID,
        lastPaymentAmount: product?.rawPrice,
        lastPaymentDate: now,
        nextBillingDate: endDate,
      );

      await _saveCurrentSubscription();
      AppLogger.debug('Purchase processed successfully for tier: ${tier.name}');
    } catch (e) {
      AppLogger.error('Error processing purchase: $e');
    }
  }

  /// Load current subscription from storage
  Future<void> _loadCurrentSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tierIndex = prefs.getInt('subscription_tier');
      final startDateMs = prefs.getInt('subscription_start_date');
      final endDateMs = prefs.getInt('subscription_end_date');

      if (tierIndex != null && startDateMs != null && endDateMs != null) {
        final tier = SubscriptionTier.values[tierIndex];
        final startDate = DateTime.fromMillisecondsSinceEpoch(startDateMs);
        final endDate = DateTime.fromMillisecondsSinceEpoch(endDateMs);

        _currentSubscription = UserSubscription(
          userId: 'current_user',
          tier: tier,
          startDate: startDate,
          endDate: endDate,
        );

        AppLogger.debug('Loaded subscription: ${tier.name}');
      }
    } catch (e) {
      AppLogger.debug('No saved subscription found or error loading: $e');
    }
  }

  /// Save current subscription to storage
  Future<void> _saveCurrentSubscription() async {
    try {
      if (_currentSubscription != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
          'subscription_tier',
          _currentSubscription!.tier.index,
        );
        await prefs.setInt(
          'subscription_start_date',
          _currentSubscription!.startDate.millisecondsSinceEpoch,
        );
        await prefs.setInt(
          'subscription_end_date',
          _currentSubscription!.endDate.millisecondsSinceEpoch,
        );

        AppLogger.debug('Subscription saved successfully');
      }
    } catch (e) {
      AppLogger.error('Error saving subscription: $e');
    }
  }

  /// Load mock subscription for testing
  Future<void> _loadMockSubscription() async {
    if (kDebugMode) {
      // Default to free tier
      _currentSubscription = UserSubscription(
        userId: 'test_user',
        tier: SubscriptionTier.free,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
      );
    }
  }

  /// Get current subscription
  UserSubscription? get currentSubscription => _currentSubscription;

  /// Get current subscription tier
  SubscriptionTier get currentTier =>
      _currentSubscription?.tier ?? SubscriptionTier.free;

  /// Check if user has active subscription
  bool get hasActiveSubscription => _currentSubscription?.isValid ?? false;

  /// Check if user is premium (basic or higher)
  bool get isPremium => currentTier.index >= SubscriptionTier.basic.index;

  /// Check if user has specific tier or higher
  bool hasTierOrHigher(SubscriptionTier tier) {
    return currentTier.index >= tier.index;
  }

  /// Get available products
  List<ProductDetails> get availableProducts => _availableProducts;

  /// Get product details for specific tier
  ProductDetails? getProductDetails(
    SubscriptionTier tier, {
    bool yearly = false,
  }) {
    final String productId =
        yearly ? _yearlyProductIds[tier]! : _productIds[tier]!;

    return _availableProducts.where((p) => p.id == productId).firstOrNull;
  }

  /// Restore purchases (mock implementation)
  Future<void> restorePurchases() async {
    try {
      // In a real implementation, this would restore from platform stores
      AppLogger.debug('Mock purchases restored');
    } catch (e) {
      AppLogger.error('Error restoring purchases: $e');
    }
  }

  /// Cancel subscription (platform-specific)
  Future<void> cancelSubscription() async {
    try {
      if (Platform.isIOS) {
        AppLogger.debug('Direct user to iOS subscription settings');
      } else if (Platform.isAndroid) {
        AppLogger.debug('Direct user to Google Play subscription settings');
      } else {
        // For development, just clear the subscription
        _currentSubscription = UserSubscription(
          userId: 'current_user',
          tier: SubscriptionTier.free,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 365)),
        );
        await _saveCurrentSubscription();
      }
    } catch (e) {
      AppLogger.error('Error canceling subscription: $e');
    }
  }

  /// Get subscription plan details
  SubscriptionPlan getCurrentPlan() {
    return SubscriptionPlans.getPlanByTier(currentTier);
  }

  /// Check if feature is available for current tier
  bool isFeatureAvailable(String featureId) {
    final Map<String, SubscriptionTier> featureRequirements = {
      'unlimited_search': SubscriptionTier.basic,
      'ai_guidance': SubscriptionTier.premium,
      'voice_search': SubscriptionTier.premium,
      'family_sharing': SubscriptionTier.family,
      'offline_access': SubscriptionTier.basic,
      'ad_free': SubscriptionTier.basic,
      'priority_support': SubscriptionTier.premium,
      'advanced_analytics': SubscriptionTier.premium,
      'islamic_courses': SubscriptionTier.premium,
      'community_access': SubscriptionTier.premium,
      'personalized_recommendations': SubscriptionTier.premium,
      'multi_language': SubscriptionTier.premium,
      'family_tracking': SubscriptionTier.family,
      'parental_controls': SubscriptionTier.family,
      'kids_content': SubscriptionTier.family,
    };

    final requiredTier =
        featureRequirements[featureId] ?? SubscriptionTier.free;
    return hasTierOrHigher(requiredTier);
  }

  /// Get days until subscription expires
  int get daysUntilExpiration => _currentSubscription?.daysRemaining ?? 0;

  /// Check if subscription is expiring soon
  bool get isExpiringSoon => _currentSubscription?.isExpiringSoon ?? false;

  /// Get subscription renewal date
  DateTime? get renewalDate => _currentSubscription?.nextBillingDate;

  /// Set mock subscription for testing
  Future<void> setMockSubscription(SubscriptionTier tier) async {
    if (kDebugMode) {
      final now = DateTime.now();
      _currentSubscription = UserSubscription(
        userId: 'test_user',
        tier: tier,
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
      );
      await _saveCurrentSubscription();
      AppLogger.debug('Mock subscription set to: ${tier.name}');
    }
  }

  /// Get tier display name
  String getTierDisplayName(SubscriptionTier tier) {
    return SubscriptionPlans.getPlanByTier(tier).name;
  }

  /// Get tier features list
  List<String> getTierFeatures(SubscriptionTier tier) {
    return SubscriptionPlans.getPlanByTier(tier).features;
  }

  /// Calculate savings for yearly subscription
  double calculateYearlySavings(SubscriptionTier tier) {
    final plan = SubscriptionPlans.getPlanByTier(tier);
    final monthlyCost = plan.monthlyPrice * 12;
    return monthlyCost - plan.yearlyPrice;
  }

  /// Get formatted price for tier
  String getFormattedPrice(SubscriptionTier tier, {bool yearly = false}) {
    final plan = SubscriptionPlans.getPlanByTier(tier);
    final price = yearly ? plan.yearlyPrice : plan.monthlyPrice;

    if (price == 0.0) return 'Free';

    return yearly
        ? '\$${price.toStringAsFixed(2)}/year'
        : '\$${price.toStringAsFixed(2)}/month';
  }

  /// Dispose resources
  void dispose() {
    _purchaseStreamController.close();
  }
}

/// Extension for easier subscription checks
extension SubscriptionExtensions on SubscriptionService {
  /// Quick check for ad-free experience
  bool get isAdFree => hasTierOrHigher(SubscriptionTier.basic);

  /// Quick check for AI features
  bool get hasAIFeatures => hasTierOrHigher(SubscriptionTier.premium);

  /// Quick check for family features
  bool get hasFamilyFeatures => hasTierOrHigher(SubscriptionTier.family);

  /// Get formatted subscription status
  String get subscriptionStatusText {
    if (!hasActiveSubscription) return 'Free Plan';

    final plan = getCurrentPlan();
    final daysLeft = daysUntilExpiration;

    if (daysLeft > 0) {
      return '${plan.name} Plan ($daysLeft days left)';
    } else {
      return '${plan.name} Plan (Expired)';
    }
  }
}
