//filepath: j:\Programming\FlutterProject\duacopilot\lib\presentation\screens\subscription\subscription_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/subscription_models.dart';
import '../../../services/subscription/subscription_service.dart';
import '../../widgets/modern_ui_components.dart';

/// Modern subscription management screen
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  bool _isLoading = true;
  bool _isYearly = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSubscriptionService();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  Future<void> _initializeSubscriptionService() async {
    try {
      await _subscriptionService.initialize();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: _isLoading ? _buildLoadingScreen() : _buildSubscriptionContent(),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(child: ModernLoadingIndicator());
  }

  Widget _buildSubscriptionContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildCurrentStatus(),
                    const SizedBox(height: 32),
                    _buildBillingToggle(),
                    const SizedBox(height: 24),
                    _buildSubscriptionPlans(),
                    const SizedBox(height: 32),
                    _buildFeatureComparison(),
                    const SizedBox(height: 32),
                    _buildRestoreButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Animated particles effect
              ...List.generate(20, (index) {
                return Positioned(
                  left: (index * 30.0) % MediaQuery.of(context).size.width,
                  top: (index * 20.0) % 200,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_rounded, size: 48, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Choose Your Plan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Unlock the full Islamic experience',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStatus() {
    final currentTier = _subscriptionService.currentTier;
    final plan = SubscriptionPlans.getPlanByTier(currentTier);
    final isActive = _subscriptionService.hasActiveSubscription;
    final theme = Theme.of(context);

    return GlassmorphicContainer(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.info_outline,
                color: isActive ? Colors.green : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Current Plan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (currentTier != SubscriptionTier.free)
                Text(
                  _subscriptionService.getFormattedPrice(
                    currentTier,
                    yearly: _isYearly,
                  ),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          if (_subscriptionService.isExpiringSoon) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your subscription expires in ${_subscriptionService.daysUntilExpiration} days',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBillingToggle() {
    final theme = Theme.of(context);

    return GlassmorphicContainer(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isYearly
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !_isYearly ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isYearly
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Yearly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isYearly ? Colors.white : Colors.grey[600],
                      ),
                    ),
                    if (_isYearly)
                      Text(
                        'Save 17%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    final plans = SubscriptionPlans.paidPlans;

    return Column(children: plans.map((plan) => _buildPlanCard(plan)).toList());
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isCurrentPlan = _subscriptionService.currentTier == plan.tier;
    final theme = Theme.of(context);
    final price = _isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    final savingsText = _isYearly && plan.discountPercentage > 0
        ? 'Save ${plan.discountPercentage.toInt()}%'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ModernAnimatedCard(
        onTap: isCurrentPlan ? () {} : () => _handlePlanSelection(plan),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (plan.isPopular) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'POPULAR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          _isYearly ? '/year' : '/month',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (savingsText != null)
                          Text(
                            savingsText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: plan.features.take(6).map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (plan.features.length > 6) ...[
                  const SizedBox(height: 8),
                  Text(
                    '+${plan.features.length - 6} more features',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 16),
                ModernGradientButton(
                  onPressed: () =>
                      isCurrentPlan ? null : _handlePlanSelection(plan),
                  text: isCurrentPlan ? 'Current Plan' : 'Choose Plan',
                ),
              ],
            ),
            if (isCurrentPlan)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureComparison() {
    final theme = Theme.of(context);

    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature Comparison',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureRow('Unlimited Duas Access', [false, true, true, true]),
          _buildFeatureRow('Ad-free Experience', [false, true, true, true]),
          _buildFeatureRow('AI-powered Guidance', [false, false, true, true]),
          _buildFeatureRow('Voice Search', [false, false, true, true]),
          _buildFeatureRow('Family Sharing', [false, false, false, true]),
          _buildFeatureRow('Priority Support', [false, false, true, true]),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, List<bool> availability) {
    final tiers = ['Free', 'Basic', 'Premium', 'Family'];
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: theme.textTheme.bodyMedium),
          ),
          ...tiers.asMap().entries.map((entry) {
            final index = entry.key;
            final isAvailable = availability[index];

            return Expanded(
              child: Center(
                child: Icon(
                  isAvailable ? Icons.check_circle : Icons.close,
                  color: isAvailable ? Colors.green : Colors.grey[400],
                  size: 20,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRestoreButton() {
    return ElevatedButton(
      onPressed: _handleRestorePurchases,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Restore Purchases',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _handlePlanSelection(SubscriptionPlan plan) async {
    HapticFeedback.mediumImpact();

    final confirmed = await _showPurchaseConfirmation(plan);
    if (confirmed == true) {
      _processPurchase(plan);
    }
  }

  Future<bool?> _showPurchaseConfirmation(SubscriptionPlan plan) {
    final price = _isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    final period = _isYearly ? 'year' : 'month';

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are about to purchase:'),
            const SizedBox(height: 8),
            Text(
              '${plan.name} Plan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('\$${price.toStringAsFixed(2)}/$period'),
            if (_isYearly && plan.discountPercentage > 0) ...[
              const SizedBox(height: 8),
              Text(
                'You save ${plan.discountPercentage.toInt()}% with yearly billing!',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPurchase(SubscriptionPlan plan) async {
    try {
      setState(() => _isLoading = true);

      final success = await _subscriptionService.purchaseSubscription(
        plan.tier,
        yearly: _isYearly,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully subscribed to ${plan.name}!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {}); // Refresh UI
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRestorePurchases() async {
    try {
      setState(() => _isLoading = true);
      await _subscriptionService.restorePurchases();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {}); // Refresh UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

