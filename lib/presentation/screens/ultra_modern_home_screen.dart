// lib/presentation/screens/ultra_modern_home_screen.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/ultra_modern_theme.dart';
import '../../services/ads/ad_service.dart';
import '../widgets/ads/ad_widgets.dart';
import '../widgets/ultra_modern_components.dart';
import 'ai/smart_dua_collections_screen.dart';
import 'courses/islamic_courses_screen.dart';
import 'subscription/subscription_screen.dart';

/// Ultra-modern home screen with award-winning design
class UltraModernHomeScreen extends ConsumerStatefulWidget {
  final bool enableVoiceSearch;
  final bool enableArabicKeyboard;
  final bool showSearchHistory;
  final VoidCallback? onMenuPressed;

  const UltraModernHomeScreen({
    super.key,
    this.enableVoiceSearch = true,
    this.enableArabicKeyboard = true,
    this.showSearchHistory = true,
    this.onMenuPressed,
  });

  @override
  ConsumerState<UltraModernHomeScreen> createState() => _UltraModernHomeScreenState();
}

class _UltraModernHomeScreenState extends ConsumerState<UltraModernHomeScreen> with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _cardsAnimationController;
  late ScrollController _scrollController;

  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _cardsAnimation;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _quickActions = [];
  List<Map<String, dynamic>> _featuredContent = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // Initialize animation controllers
    _heroAnimationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _cardsAnimationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    // Setup scroll controller listener
    _scrollController.addListener(() {
      setState(() {});
    });

    // Setup animations
    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroAnimationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOutQuart)),
    );

    _heroSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _heroAnimationController, curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic)),
    );

    _cardsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardsAnimationController, curve: Curves.easeOutBack));

    // Initialize data
    _initializeContent();

    // Start animations
    _startAnimations();

    // Initialize ads
    AdService.instance.initialize();
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _cardsAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _heroAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _cardsAnimationController.forward();
  }

  void _initializeContent() {
    _quickActions = [
      {
        'title': 'Smart Duas',
        'subtitle': 'AI-powered recommendations',
        'icon': Icons.psychology_rounded,
        'color': const Color(0xFF6366F1),
        'onTap': () => _navigateToScreen(const SmartDuaCollectionsScreen()),
      },
      {
        'title': 'Qibla Finder',
        'subtitle': 'Find prayer direction',
        'icon': Icons.navigation_rounded,
        'color': const Color(0xFF10B981),
        'onTap': () => _showComingSoon('Qibla Finder'),
      },
      {
        'title': 'Prayer Times',
        'subtitle': 'Never miss a prayer',
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFFF59E0B),
        'onTap': () => _showComingSoon('Prayer Times'),
      },
      {
        'title': 'Tasbih Counter',
        'subtitle': 'Digital prayer beads',
        'icon': Icons.touch_app_rounded,
        'color': const Color(0xFFEF4444),
        'onTap': () => _showComingSoon('Tasbih Counter'),
      },
    ];

    _featuredContent = [
      {
        'title': 'Daily Duas',
        'description': 'Essential prayers for everyday life',
        'image': 'https://via.placeholder.com/300x200/0D7C66/FFFFFF?text=Daily+Duas',
        'category': 'Essential',
        'duration': '5 min read',
      },
      {
        'title': 'Quranic Verses',
        'description': 'Beautiful verses with translations',
        'image': 'https://via.placeholder.com/300x200/41A3B3/FFFFFF?text=Quran',
        'category': 'Spiritual',
        'duration': '10 min read',
      },
      {
        'title': 'Islamic Courses',
        'description': 'Learn and grow in your faith',
        'image': 'https://via.placeholder.com/300x200/E6B17A/FFFFFF?text=Courses',
        'category': 'Learning',
        'duration': 'Full course',
      },
    ];
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: UltraModernComponents.glassmorphicContainer(
              width: 320,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.construction_rounded, size: 48, color: context.colorScheme.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Coming Soon!',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$feature is currently under development. Stay tuned for updates!',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  UltraModernComponents.animatedGradientButton(
                    text: 'Got it',
                    onPressed: () => Navigator.of(context).pop(),
                    width: 120,
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
    );
  }

  double get _parallaxOffset {
    if (!_scrollController.hasClients) return 0.0;
    return _scrollController.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: null, // Premium features menu removed
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar with Hero Section
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(background: _buildHeroSection()),
            leading: Builder(
              builder:
                  (context) => IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: context.softShadow,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.menu_rounded, color: context.colorScheme.onSurface, size: 20),
                    ),
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _navigateToScreen(const SubscriptionScreen());
                },
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: context.softShadow,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.workspace_premium_rounded, color: context.colorScheme.primary, size: 20),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),

          // Search Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _heroAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _heroFadeAnimation,
                  child: SlideTransition(
                    position: _heroSlideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: UltraModernComponents.floatingSearchBar(
                        controller: _searchController,
                        onChanged: (query) {
                          // Handle search query change
                        },
                        hintText: 'Ask anything about Islam...',
                        onMicrophonePressed: widget.enableVoiceSearch ? () => _startVoiceSearch() : null,
                        showMicrophone: widget.enableVoiceSearch,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _cardsAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _cardsAnimation,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _cardsAnimation.value)),
                    child: _buildQuickActionsSection(),
                  ),
                );
              },
            ),
          ),

          // Featured Content Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _cardsAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _cardsAnimation,
                  child: Transform.translate(
                    offset: Offset(0, 75 * (1 - _cardsAnimation.value)),
                    child: _buildFeaturedContentSection(),
                  ),
                );
              },
            ),
          ),

          // Ad Banner (if not premium user)
          SliverToBoxAdapter(
            child: Consumer(
              builder: (context, ref, child) {
                return const Padding(padding: EdgeInsets.all(16), child: SmartBannerAd());
              },
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Floating Action Button
      floatingActionButton: UltraModernComponents.glowingFAB(
        onPressed: () => _navigateToScreen(const SmartDuaCollectionsScreen()),
        icon: Icons.auto_awesome_rounded,
        size: 64,
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withOpacity(0.8),
            context.colorScheme.secondary,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated background particles
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlesPainter(
                animationValue: _heroAnimationController.value,
                particleColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Parallax background shapes
          UltraModernComponents.parallaxEffect(
            offset: _parallaxOffset,
            factor: 0.3,
            child: Positioned(
              top: 50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
              ),
            ),
          ),

          UltraModernComponents.parallaxEffect(
            offset: _parallaxOffset,
            factor: 0.5,
            child: Positioned(
              bottom: 30,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
          ),

          // Main hero content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // App Icon with glow effect
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                    ),
                    child: Icon(Icons.mosque_rounded, size: 60, color: Colors.white),
                  ),

                  const SizedBox(height: 24),

                  // App Title
                  Text(
                    'DuaCopilot',
                    style: context.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Your AI Islamic Companion',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Animated statistics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('10K+', 'Duas'),
                      _buildStatCard('50+', 'Languages'),
                      _buildStatCard('24/7', 'Available'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return UltraModernComponents.glassmorphicContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: Colors.white.withOpacity(0.1),
      child: Column(
        children: [
          UltraModernComponents.animatedCounter(
            value: int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0,
            textStyle: context.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            suffix:
                value.contains('K')
                    ? 'K+'
                    : value.contains('/')
                    ? '/7'
                    : '+',
          ),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _quickActions.length,
            itemBuilder: (context, index) {
              final action = _quickActions[index];
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500 + (index * 100)),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: UltraModernComponents.modernCard(
                      onTap: action['onTap'],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, (action['color'] as Color).withOpacity(0.05)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (action['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(action['icon'], size: 32, color: action['color']),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            action['title'],
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            action['subtitle'],
                            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedContentSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Content',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToScreen(const IslamicCoursesScreen()),
                child: Text(
                  'View All',
                  style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _featuredContent.length,
              itemBuilder: (context, index) {
                final content = _featuredContent[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 700 + (index * 150)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(50 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          width: 250,
                          margin: EdgeInsets.only(right: index < _featuredContent.length - 1 ? 16 : 0),
                          child: UltraModernComponents.modernCard(
                            padding: EdgeInsets.zero,
                            onTap: () => _navigateToScreen(const IslamicCoursesScreen()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Content image with gradient overlay
                                Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    gradient: LinearGradient(
                                      colors: [context.colorScheme.primary, context.colorScheme.secondary],
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Icon(Icons.book_rounded, size: 48, color: Colors.white.withOpacity(0.8)),
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            content['category'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Content details
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content['title'],
                                        style: context.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        content['description'],
                                        style: context.textTheme.bodySmall?.copyWith(
                                          color: context.colorScheme.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(Icons.schedule_rounded, size: 16, color: context.colorScheme.primary),
                                          const SizedBox(width: 4),
                                          Text(
                                            content['duration'],
                                            style: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startVoiceSearch() {
    HapticFeedback.mediumImpact();
    // TODO: Implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice search activated!'),
        backgroundColor: context.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Custom painter for animated particles background
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color particleColor;

  ParticlesPainter({required this.animationValue, required this.particleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = particleColor
          ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent animation

    for (int i = 0; i < 50; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 3 + 1;

      // Animate particles with a floating effect
      final double offsetY = math.sin(animationValue * 2 * math.pi + i * 0.1) * 10;
      final double opacity = (math.sin(animationValue * 2 * math.pi + i * 0.2) + 1) / 2;

      paint.color = particleColor.withOpacity(opacity * 0.6);
      canvas.drawCircle(Offset(x, y + offsetY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
