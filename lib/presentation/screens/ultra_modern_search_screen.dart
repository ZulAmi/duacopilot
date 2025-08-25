import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/ultra_modern_theme.dart';
import '../../services/ads/ad_service.dart';

/// Ultra-Modern Islamic Search Screen with Glassmorphism & Floating Elements
class UltraModernSearchScreen extends ConsumerStatefulWidget {
  final bool enableVoiceSearch;
  final bool enableArabicKeyboard;
  final bool showSearchHistory;
  final VoidCallback? onMenuPressed;

  const UltraModernSearchScreen({
    super.key,
    this.enableVoiceSearch = true,
    this.enableArabicKeyboard = true,
    this.showSearchHistory = true,
    this.onMenuPressed,
  });

  @override
  ConsumerState<UltraModernSearchScreen> createState() => _UltraModernSearchScreenState();
}

class _UltraModernSearchScreenState extends ConsumerState<UltraModernSearchScreen> with TickerProviderStateMixin {
  // Controllers
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  late final PageController _pageController;

  // Animation Controllers
  late final AnimationController _floatingController;
  late final AnimationController _pulseController;
  late final AnimationController _breatheController;
  late final AnimationController _glowController;

  // Animations
  late final Animation<double> _floatingAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _breatheAnimation;
  late final Animation<Color?> _glowAnimation;

  // State
  bool _isSearching = false;
  bool _showResults = false;
  String? _searchResults;
  final List<SearchHistoryItem> _searchHistory = [];
  int _searchCount = 0;
  bool _isVoiceListening = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startAnimations();
    AdService.instance.initialize();
  }

  void _initializeControllers() {
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _pageController = PageController();

    // Animation controllers
    _floatingController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _breatheController = AnimationController(duration: const Duration(milliseconds: 4000), vsync: this);
    _glowController = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this);
  }

  void _initializeAnimations() {
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _floatingController, curve: Curves.easeInOutSine));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.elasticInOut));

    _breatheAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutQuad));

    _glowAnimation = ColorTween(
      begin: UltraModernTheme.primaryGold.withOpacity(0.3),
      end: UltraModernTheme.deepEmerald.withOpacity(0.5),
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOutCubic));
  }

  void _startAnimations() {
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _breatheController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _breatheController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    HapticFeedback.mediumImpact();

    if (await AdService.instance.shouldShowPremiumUpgrade()) {
      _showPremiumUpgradeDialog();
      return;
    }

    _searchCount++;
    if (_searchCount % 3 == 0) {
      AdService.instance.showInterstitialAd();
    }

    setState(() {
      _isSearching = true;
      _showResults = false;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      final results = await _simulateSearch(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _showResults = true;
      });

      final historyItem = SearchHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        query: query,
        timestamp: DateTime.now(),
        results: results,
      );

      setState(() {
        _searchHistory.insert(0, historyItem);
        if (_searchHistory.length > 20) {
          _searchHistory.removeLast();
        }
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _searchResults = 'Search error: $e';
        _showResults = true;
      });
    }
  }

  Future<String> _simulateSearch(String query) async {
    final islamicResponses = {
      'morning':
          'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا\n"O Allah, by You we enter the morning and by You we enter the evening"\n\nRecite this beautiful morning dua to start your day with Allah\'s blessings.',
      'evening':
          'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا\n"O Allah, by You we enter the evening and by You we enter the morning"\n\nA peaceful evening remembrance to end your day.',
      'travel':
          'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ\n"Glory to Him who has subjected this to us, and we could never have it (by our efforts)"\n\nRecite before embarking on any journey.',
      'sleep':
          'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا\n"O Allah, in Your name I die and I live"\n\nA peaceful dua before sleep to place your soul in Allah\'s care.',
    };

    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();
    for (final key in islamicResponses.keys) {
      if (lowerQuery.contains(key)) {
        return islamicResponses[key]!;
      }
    }

    return 'SubhanAllah! 🌟\n\nI found some beautiful guidance for "$query":\n\n"And it is He who created the heavens and earth in truth. And the day He says, "Be," and it is, His word is the truth." - Quran 6:73\n\nMay Allah guide you in your search for Islamic knowledge. Try searching for specific duas like "morning dua", "travel dua", or "sleep dua".';
  }

  void _showPremiumUpgradeDialog() {
    showDialog(context: context, barrierDismissible: false, builder: (context) => _buildPremiumUpgradeDialog());
  }

  Widget _buildPremiumUpgradeDialog() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: GlassmorphicDecoration.light(borderRadius: 32),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: UltraModernTheme.goldGradient),
                  child: const Icon(Icons.star, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  'Unlock Premium Features',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: UltraModernTheme.deepEmerald),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Get unlimited searches, voice input, and ad-free experience',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: UltraModernTheme.charcoalBlack.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Maybe Later')),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate to premium screen
                        },
                        child: const Text('Upgrade Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltraModernTheme.softGray,
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F9FA), Color(0xFFF1F3F4), Color(0xFFE8F5E8)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),

        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildFloatingAppBar(),
              _buildHeroSection(),
              _buildSearchSection(),
              if (_showResults) _buildResultsSection(),
              if (widget.showSearchHistory && _searchHistory.isNotEmpty) _buildHistorySection(),
              _buildFeaturesGrid(),
              _buildFloatingElements(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),

      floatingActionButton: _buildFloatingActionButton(),
      drawer: null, // Premium features menu removed
    );
  }

  Widget _buildFloatingAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: AnimatedBuilder(
        animation: _breatheAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: GlassmorphicDecoration.light(opacity: 0.1 + (_breatheAnimation.value * 0.1)),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback:
                        (bounds) => LinearGradient(
                          colors: [
                            UltraModernTheme.deepEmerald,
                            _glowAnimation.value ?? UltraModernTheme.primaryGold,
                            UltraModernTheme.deepEmerald,
                          ],
                        ).createShader(bounds),
                    child: const Text(
                      'DuaCopilot',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  );
                },
              ),
              actions: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: UltraModernTheme.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: UltraModernTheme.deepEmerald.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.menu_rounded, color: Colors.white),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(24),
        child: AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_floatingAnimation.value * 2 * math.pi) * 10),
              child: Container(
                decoration: GlassmorphicDecoration.light(borderRadius: 32, opacity: 0.2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: UltraModernTheme.primaryGradient,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                                ),
                                child: const Icon(Icons.mosque, size: 48, color: Colors.white),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Islamic AI Assistant',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ask questions about Islam, Duas, and Quran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _breatheAnimation,
              builder: (context, child) {
                return Container(
                  decoration: GlassmorphicDecoration.light(
                    borderRadius: 24,
                    opacity: 0.15 + (_breatheAnimation.value * 0.1),
                    blur: 25,
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: UltraModernTheme.charcoalBlack, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: _isSearching ? 'Searching...' : 'Ask about Islamic guidance, duas, or Quran...',
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: UltraModernTheme.charcoalBlack.withOpacity(0.6)),
                      prefixIcon:
                          _isSearching
                              ? Container(
                                padding: const EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(UltraModernTheme.deepEmerald),
                                ),
                              )
                              : Icon(Icons.search_rounded, color: UltraModernTheme.deepEmerald, size: 24),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.enableVoiceSearch)
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isVoiceListening ? _pulseAnimation.value : 1.0,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: _isVoiceListening ? UltraModernTheme.goldGradient : null,
                                      color: _isVoiceListening ? null : UltraModernTheme.deepEmerald.withOpacity(0.1),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isVoiceListening ? Icons.mic : Icons.mic_none_rounded,
                                        color: _isVoiceListening ? Colors.white : UltraModernTheme.deepEmerald,
                                      ),
                                      onPressed: _toggleVoiceSearch,
                                    ),
                                  ),
                                );
                              },
                            ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: UltraModernTheme.primaryGradient,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send_rounded, color: Colors.white),
                              onPressed: () {
                                final query = _searchController.text;
                                if (query.isNotEmpty) {
                                  _performSearch(query);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: _performSearch,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Quick Action Chips
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildQuickActionChip('Morning Dua', Icons.wb_sunny_rounded),
                _buildQuickActionChip('Evening Dua', Icons.nights_stay_rounded),
                _buildQuickActionChip('Travel Prayer', Icons.flight_rounded),
                _buildQuickActionChip('Sleep Dua', Icons.bedtime_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon) {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _searchController.text = label.toLowerCase();
            _performSearch(label.toLowerCase());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: GlassmorphicDecoration.light(borderRadius: 20, opacity: 0.1 + (_breatheAnimation.value * 0.05)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: UltraModernTheme.deepEmerald),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: UltraModernTheme.deepEmerald),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsSection() {
    return SliverToBoxAdapter(
      child: AnimatedOpacity(
        opacity: _showResults ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: GlassmorphicDecoration.light(borderRadius: 24, opacity: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: UltraModernTheme.goldGradient),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Islamic Guidance',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: UltraModernTheme.deepEmerald,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.share_rounded, color: UltraModernTheme.deepEmerald),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Implement share functionality
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _searchResults ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 16, color: UltraModernTheme.charcoalBlack),
                ),
                const SizedBox(height: 16),
                // Ad banner placeholder
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: UltraModernTheme.softGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: UltraModernTheme.deepEmerald.withOpacity(0.1)),
                  ),
                  child: const Center(child: Text('Ad Space', style: TextStyle(color: Colors.grey, fontSize: 12))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Searches',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: UltraModernTheme.deepEmerald),
            ),
            const SizedBox(height: 12),
            ...(_searchHistory.take(3).map((item) => _buildHistoryItem(item))),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: GlassmorphicDecoration.light(borderRadius: 16, opacity: 0.05 + (_breatheAnimation.value * 0.03)),
          child: ListTile(
            leading: Icon(Icons.history_rounded, color: UltraModernTheme.deepEmerald.withOpacity(0.7), size: 20),
            title: Text(
              item.query,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              _formatTimestamp(item.timestamp),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: UltraModernTheme.charcoalBlack.withOpacity(0.6)),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              _searchController.text = item.query;
              _performSearch(item.query);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {'icon': Icons.book_rounded, 'title': 'Quran', 'subtitle': 'Read & Listen'},
      {'icon': Icons.schedule_rounded, 'title': 'Prayer Times', 'subtitle': 'Local Times'},
      {'icon': Icons.favorite_rounded, 'title': 'Favorites', 'subtitle': 'Save Duas'},
      {'icon': Icons.explore_rounded, 'title': 'Qibla', 'subtitle': 'Find Direction'},
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final feature = features[index];
          return AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.sin((_floatingAnimation.value + index * 0.25) * 2 * math.pi) * 5,
                  math.cos((_floatingAnimation.value + index * 0.25) * 2 * math.pi) * 5,
                ),
                child: Container(
                  decoration: GlassmorphicDecoration.light(borderRadius: 24, opacity: 0.15),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        // Navigate to feature
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: UltraModernTheme.primaryGradient,
                              ),
                              child: Icon(feature['icon'] as IconData, color: Colors.white, size: 28),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              feature['title'] as String,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: UltraModernTheme.deepEmerald,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feature['subtitle'] as String,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: UltraModernTheme.charcoalBlack.withOpacity(0.7)),
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
          );
        }, childCount: features.length),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: Stack(
          children: List.generate(6, (index) {
            return AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                final offset = (_floatingAnimation.value + index * 0.3) * 2 * math.pi;
                return Positioned(
                  left: 50 + math.sin(offset) * 100,
                  top: 50 + math.cos(offset) * 50,
                  child: Opacity(
                    opacity: 0.1,
                    child: Transform.rotate(
                      angle: offset,
                      child: Container(
                        width: 20 + (index * 5).toDouble(),
                        height: 20 + (index * 5).toDouble(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: index.isEven ? UltraModernTheme.primaryGradient : UltraModernTheme.goldGradient,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () {
              HapticFeedback.mediumImpact();
              // Show premium features or quick actions
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: GlassmorphicDecoration.light(borderRadius: 24, opacity: 0.9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: UltraModernTheme.goldGradient),
                    child: const Icon(Icons.star, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Premium',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: UltraModernTheme.deepEmerald, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleVoiceSearch() {
    setState(() {
      _isVoiceListening = !_isVoiceListening;
    });

    HapticFeedback.lightImpact();

    if (_isVoiceListening) {
      // Start voice recognition
      _startVoiceRecognition();
    } else {
      // Stop voice recognition
      _stopVoiceRecognition();
    }
  }

  void _startVoiceRecognition() {
    // Implement voice recognition logic
    // For now, simulate with timer
    Future.delayed(const Duration(seconds: 3), () {
      if (_isVoiceListening) {
        setState(() {
          _isVoiceListening = false;
          _searchController.text = 'morning dua';
        });
        _performSearch('morning dua');
      }
    });
  }

  void _stopVoiceRecognition() {
    // Stop voice recognition
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;
  final String results;

  SearchHistoryItem({required this.id, required this.query, required this.timestamp, required this.results});
}
