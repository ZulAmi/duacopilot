// filepath: j:\Programming\FlutterProject\duacopilot\lib\core\models\subscription_models.dart

/// Subscription tier enumeration
enum SubscriptionTier { free, basic, premium, family }

/// Subscription plan model
class SubscriptionPlan {
  final String id;
  final String name;
  final SubscriptionTier tier;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final String description;
  final bool isPopular;
  final double discountPercentage;
  final String? billingPeriod;
  final String? productId;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.tier,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    required this.description,
    this.isPopular = false,
    this.discountPercentage = 0.0,
    this.billingPeriod,
    this.productId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tier': tier.name,
    'monthlyPrice': monthlyPrice,
    'yearlyPrice': yearlyPrice,
    'features': features,
    'description': description,
    'isPopular': isPopular,
    'discountPercentage': discountPercentage,
    'billingPeriod': billingPeriod,
    'productId': productId,
  };

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json['id'],
        name: json['name'],
        tier: SubscriptionTier.values.firstWhere((e) => e.name == json['tier']),
        monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
        yearlyPrice: (json['yearlyPrice'] as num).toDouble(),
        features: List<String>.from(json['features']),
        description: json['description'],
        isPopular: json['isPopular'] ?? false,
        discountPercentage:
            (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
        billingPeriod: json['billingPeriod'],
        productId: json['productId'],
      );
}

/// User subscription status
class UserSubscription {
  final String userId;
  final SubscriptionTier tier;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool autoRenew;
  final String? subscriptionId;
  final String? paymentMethod;
  final double? lastPaymentAmount;
  final DateTime? lastPaymentDate;
  final DateTime? nextBillingDate;

  const UserSubscription({
    required this.userId,
    required this.tier,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.autoRenew = false,
    this.subscriptionId,
    this.paymentMethod,
    this.lastPaymentAmount,
    this.lastPaymentDate,
    this.nextBillingDate,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'tier': tier.name,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'isActive': isActive,
    'autoRenew': autoRenew,
    'subscriptionId': subscriptionId,
    'paymentMethod': paymentMethod,
    'lastPaymentAmount': lastPaymentAmount,
    'lastPaymentDate': lastPaymentDate?.toIso8601String(),
    'nextBillingDate': nextBillingDate?.toIso8601String(),
  };

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      UserSubscription(
        userId: json['userId'],
        tier: SubscriptionTier.values.firstWhere((e) => e.name == json['tier']),
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        isActive: json['isActive'] ?? true,
        autoRenew: json['autoRenew'] ?? false,
        subscriptionId: json['subscriptionId'],
        paymentMethod: json['paymentMethod'],
        lastPaymentAmount: (json['lastPaymentAmount'] as num?)?.toDouble(),
        lastPaymentDate:
            json['lastPaymentDate'] != null
                ? DateTime.parse(json['lastPaymentDate'])
                : null,
        nextBillingDate:
            json['nextBillingDate'] != null
                ? DateTime.parse(json['nextBillingDate'])
                : null,
      );

  /// Check if subscription is currently valid
  bool get isValid => isActive && DateTime.now().isBefore(endDate);

  /// Get days remaining in subscription
  int get daysRemaining =>
      isValid ? endDate.difference(DateTime.now()).inDays : 0;

  /// Check if subscription is expiring soon (within 7 days)
  bool get isExpiringSoon => isValid && daysRemaining <= 7;
}

/// Subscription feature model
class SubscriptionFeature {
  final String id;
  final String name;
  final String description;
  final SubscriptionTier requiredTier;
  final bool isCore;
  final String? iconCode;
  final String? category;

  const SubscriptionFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredTier,
    this.isCore = false,
    this.iconCode,
    this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'requiredTier': requiredTier.name,
    'isCore': isCore,
    'iconCode': iconCode,
    'category': category,
  };

  factory SubscriptionFeature.fromJson(Map<String, dynamic> json) =>
      SubscriptionFeature(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        requiredTier: SubscriptionTier.values.firstWhere(
          (e) => e.name == json['requiredTier'],
        ),
        isCore: json['isCore'] ?? false,
        iconCode: json['iconCode'],
        category: json['category'],
      );
}

/// Payment method model
class PaymentMethod {
  final String id;
  final String type;
  final String displayName;
  final bool isActive;
  final String? last4Digits;
  final String? expiryDate;
  final String? brand;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    this.isActive = true,
    this.last4Digits,
    this.expiryDate,
    this.brand,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'displayName': displayName,
    'isActive': isActive,
    'last4Digits': last4Digits,
    'expiryDate': expiryDate,
    'brand': brand,
  };

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json['id'],
    type: json['type'],
    displayName: json['displayName'],
    isActive: json['isActive'] ?? true,
    last4Digits: json['last4Digits'],
    expiryDate: json['expiryDate'],
    brand: json['brand'],
  );
}

/// Billing history model
class BillingHistory {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final DateTime date;
  final String status;
  final String description;
  final String? invoiceUrl;
  final String? receiptUrl;

  const BillingHistory({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.date,
    required this.status,
    required this.description,
    this.invoiceUrl,
    this.receiptUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'amount': amount,
    'currency': currency,
    'date': date.toIso8601String(),
    'status': status,
    'description': description,
    'invoiceUrl': invoiceUrl,
    'receiptUrl': receiptUrl,
  };

  factory BillingHistory.fromJson(Map<String, dynamic> json) => BillingHistory(
    id: json['id'],
    userId: json['userId'],
    amount: (json['amount'] as num).toDouble(),
    currency: json['currency'],
    date: DateTime.parse(json['date']),
    status: json['status'],
    description: json['description'],
    invoiceUrl: json['invoiceUrl'],
    receiptUrl: json['receiptUrl'],
  );
}

/// Predefined subscription plans
class SubscriptionPlans {
  static const free = SubscriptionPlan(
    id: 'free',
    name: 'Free',
    tier: SubscriptionTier.free,
    monthlyPrice: 0.0,
    yearlyPrice: 0.0,
    features: [
      'Basic duas access',
      'Limited search queries (10/day)',
      'Ad-supported experience',
      'Basic prayer times',
    ],
    description: 'Perfect for getting started with Islamic guidance',
  );

  static const basic = SubscriptionPlan(
    id: 'basic',
    name: 'Basic',
    tier: SubscriptionTier.basic,
    monthlyPrice: 4.99,
    yearlyPrice: 49.99,
    features: [
      'Unlimited duas access',
      'Ad-free experience',
      'Advanced search (50/day)',
      'Offline access',
      'Basic analytics',
      'Prayer time notifications',
    ],
    description: 'Essential features for daily Islamic practice',
    discountPercentage: 17.0, // Yearly discount
  );

  static const premium = SubscriptionPlan(
    id: 'premium',
    name: 'Premium',
    tier: SubscriptionTier.premium,
    monthlyPrice: 9.99,
    yearlyPrice: 99.99,
    features: [
      'Everything in Basic',
      'AI-powered Islamic guidance',
      'Unlimited search queries',
      'Personalized recommendations',
      'Advanced analytics',
      'Priority support',
      'Exclusive Islamic courses',
      'Community access',
      'Voice search',
      'Multiple languages',
    ],
    description: 'Complete Islamic companion with AI guidance',
    isPopular: true,
    discountPercentage: 17.0, // Yearly discount
  );

  static const family = SubscriptionPlan(
    id: 'family',
    name: 'Family',
    tier: SubscriptionTier.family,
    monthlyPrice: 14.99,
    yearlyPrice: 149.99,
    features: [
      'Everything in Premium',
      'Up to 6 family members',
      'Family progress tracking',
      'Parental controls',
      'Kids-friendly content',
      'Family challenges',
      'Shared prayer schedules',
      'Educational games',
    ],
    description: 'Perfect for Islamic families to grow together',
    discountPercentage: 17.0, // Yearly discount
  );

  static List<SubscriptionPlan> get allPlans => [free, basic, premium, family];

  static List<SubscriptionPlan> get paidPlans => [basic, premium, family];

  static SubscriptionPlan getPlanByTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return free;
      case SubscriptionTier.basic:
        return basic;
      case SubscriptionTier.premium:
        return premium;
      case SubscriptionTier.family:
        return family;
    }
  }
}
