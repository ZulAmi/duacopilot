// lib/presentation/screens/ultra_modern_home_simplified.dart

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/ultra_modern_theme.dart';

/// Simplified Ultra-modern home screen
class UltraModernHomeSimplified extends ConsumerStatefulWidget {
  const UltraModernHomeSimplified({super.key});

  @override
  ConsumerState<UltraModernHomeSimplified> createState() => _UltraModernHomeSimplifiedState();
}

class _UltraModernHomeSimplifiedState extends ConsumerState<UltraModernHomeSimplified> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _particleController;
  late ScrollController _scrollController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _particleController = AnimationController(duration: const Duration(seconds: 4), vsync: this);

    _scrollController = ScrollController();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic)),
    );

    _animationController.forward();
    _particleController.repeat();
  }

  void _setupData() {
    // Initialize data here
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Main content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero section
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(background: _buildHeroSection()),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: const Icon(Icons.menu, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // Quick actions
              SliverToBoxAdapter(child: _buildQuickActions()),

              // Featured content
              SliverToBoxAdapter(child: _buildFeaturedContent()),

              // Recent activities
              SliverToBoxAdapter(child: _buildRecentActivities()),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(gradient: UltraModernTheme.primaryGradient),
          child: CustomPaint(painter: ParticlesPainter(animationValue: _particleController.value), child: Container()),
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 30),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'As-salamu alaykum',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Welcome back to DuaCopilot',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search bar
                      _buildSearchBar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search for duas, verses, or guidance...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.8), size: 24),
              suffixIcon: Icon(Icons.mic, color: Colors.white.withOpacity(0.8), size: 24),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.menu_book, 'title': 'Quran', 'color': const Color(0xFF0D7C66)},
      {'icon': Icons.favorite, 'title': 'Duas', 'color': const Color(0xFF41A3B3)},
      {'icon': Icons.schedule, 'title': 'Prayer Times', 'color': const Color(0xFFE6B17A)},
      {'icon': Icons.psychology, 'title': 'AI Guidance', 'color': const Color(0xFF7BB3C7)},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: UltraModernTheme.softShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (action['color'] as Color).withOpacity(0.15),
                              ),
                              child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 24),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              action['title'] as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Today',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D7C66), Color(0xFF41A3B3)],
              ),
              boxShadow: UltraModernTheme.elevatedShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: IslamicPatternPainter())),
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Daily Reflection',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover personalized Islamic guidance based on your spiritual journey',
                          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Continue Your Journey',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: UltraModernTheme.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: UltraModernTheme.primaryGradient.colors.first.withOpacity(0.15),
                    ),
                    child: Icon(Icons.bookmark_outline, color: UltraModernTheme.primaryGradient.colors.first, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dua for Peace ${index + 1}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Continue reading from where you left off',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: UltraModernTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: UltraModernTheme.primaryGradient.colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () => HapticFeedback.lightImpact(),
          child: const Icon(Icons.psychology, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

/// Custom painter for particles
class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    final random = math.Random(123);

    for (int i = 0; i < 30; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 2 + 1;

      final double offsetX = math.sin(animationValue * 2 * math.pi + i) * 10;
      final double offsetY = math.cos(animationValue * 2 * math.pi + i * 0.5) * 5;

      canvas.drawCircle(Offset(x + offsetX, y + offsetY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for Islamic patterns
class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw geometric Islamic pattern
    for (int i = 0; i < 8; i++) {
      final double x = (i % 4) * (size.width / 4) + (size.width / 8);
      final double y = (i ~/ 4) * (size.height / 2) + (size.height / 4);

      canvas.drawCircle(Offset(x, y), 20, paint);

      // Draw connecting lines
      if (i > 0) {
        final double prevX = ((i - 1) % 4) * (size.width / 4) + (size.width / 8);
        final double prevY = ((i - 1) ~/ 4) * (size.height / 2) + (size.height / 4);
        canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
