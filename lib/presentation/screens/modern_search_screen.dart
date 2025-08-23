// Modern, award-winning UI for DuaCopilot Islamic Search Assistant
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/ads/ad_service.dart';
import '../widgets/ads/ad_widgets.dart';
import 'courses/islamic_courses_screen.dart';
import 'subscription/subscription_screen.dart';

/// Award-winning modern UI for DuaCopilot
class ModernSearchScreen extends ConsumerStatefulWidget {
  final bool enableVoiceSearch;
  final bool enableArabicKeyboard;
  final bool showSearchHistory;
  final VoidCallback? onMenuPressed;

  const ModernSearchScreen({
    super.key,
    this.enableVoiceSearch = true,
    this.enableArabicKeyboard = true,
    this.showSearchHistory = true,
    this.onMenuPressed,
  });

  @override
  ConsumerState<ModernSearchScreen> createState() => _ModernSearchScreenState();
}

class _ModernSearchScreenState extends ConsumerState<ModernSearchScreen> with TickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _pulseController;
  late final AnimationController _breatheController;
  late final AnimationController _floatingController;

  String _currentQuery = '';
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
    AdService.instance.initialize();
  }

  void _initializeControllers() {
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _breatheController = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _floatingController = AnimationController(duration: const Duration(seconds: 4), vsync: this);
  }

  void _initializeAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _breatheController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _breatheController.dispose();
    _floatingController.dispose();
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
      _currentQuery = query;
      _isSearching = true;
      _showResults = false;
    });

    _pulseController.repeat();

    try {
      await Future.delayed(const Duration(seconds: 2));
      final results = await _simulateSearch(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _showResults = true;
      });

      _pulseController.stop();
      _pulseController.reset();

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
        _searchResults = 'Sorry, there was an error processing your request. Please try again.';
        _showResults = true;
      });
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  Future<String> _simulateSearch(String query) async {
    final responses = [
      'Based on Islamic teachings, here are some relevant du\'as and guidance for "$query":\n\n'
          '🤲 اللَّهُمَّ اهْدِنِي فِي مَنْ هَدَيْتَ\n'
          'Translation: "O Allah, guide me among those You have guided"\n\n'
          '📖 This beautiful du\'a comes from the authentic hadith collections and is perfect for seeking guidance in all matters of life.',
      'Here is what Islam teaches us about "$query":\n\n'
          '🌙 رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ\n'
          'Translation: "Our Lord, give us good in this world and good in the Hereafter, and save us from the torment of Fire"\n\n'
          '✨ This comprehensive du\'a from the Quran (2:201) covers all aspects of seeking goodness.',
      'Islamic guidance for "$query":\n\n'
          '🕌 سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ\n'
          'Translation: "Glory be to Allah and praise be to Him, Glory be to Allah the Magnificent"\n\n'
          '💫 The Prophet (ﷺ) said these are light on the tongue, heavy on the scales, and beloved to the Most Merciful.',
    ];
    return responses[math.Random().nextInt(responses.length)];
  }

  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => PremiumUpgradeDialog(
            onUpgrade: () {
              Navigator.of(context).pop();
              // Handle premium upgrade
            },
            onWatchAd: () async {
              Navigator.of(context).pop();
              await AdService.instance.showRewardedAd(
                onUserEarnedReward: (reward) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Enjoy 30 minutes of ad-free searches! 🎉'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated background gradient
          _buildAnimatedBackground(),

          // Floating particles effect
          _buildFloatingParticles(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Modern header with glassmorphism
                _buildGlassmorphicHeader(),

                // Search input with modern design
                _buildModernSearchInput(),

                // Content area
                Expanded(child: _buildContent()),

                // Bottom navigation/ads
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _breatheController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5 + (_breatheController.value * 0.3),
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final offset = _floatingController.value * 2 * math.pi;
            final x = 50 + (index * 40) + (30 * math.sin(offset + index));
            final y = 100 + (index * 80) + (20 * math.cos(offset + index));

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: 0.1 + (0.1 * math.sin(offset + index)),
                child: Container(
                  width: 6 + (2 * math.sin(offset + index)),
                  height: 6 + (2 * math.sin(offset + index)),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildGlassmorphicHeader() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut)),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(
            children: [
              // Logo with pulse animation
              AnimatedBuilder(
                animation: _breatheController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_breatheController.value * 0.1),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.mosque, color: Colors.white, size: 28),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DuaCopilot',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'AI Islamic Companion',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Courses button
                  _buildNavButton(
                    icon: Icons.school_rounded,
                    tooltip: 'Islamic Courses',
                    onTap:
                        () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (context) => const IslamicCoursesScreen())),
                  ),
                  const SizedBox(width: 8),

                  // Subscription button
                  _buildNavButton(
                    icon: Icons.workspace_premium_rounded,
                    tooltip: 'Subscription',
                    onTap:
                        () => Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (context) => const SubscriptionScreen())),
                  ),

                  // Menu button (if provided)
                  if (widget.onMenuPressed != null) ...[
                    const SizedBox(width: 8),
                    _buildNavButton(icon: Icons.menu_rounded, tooltip: 'Menu', onTap: widget.onMenuPressed!),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, required String tooltip, required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeTransition(
        opacity: _fadeController,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white.withOpacity(0.95)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary.withOpacity(0.7), size: 24),
                const SizedBox(width: 16),

                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _performSearch,
                    decoration: InputDecoration(
                      hintText: 'Ask about Islamic guidance, duas, teachings...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Voice search button with modern design
                if (widget.enableVoiceSearch)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isVoiceListening ? 1.0 + (_pulseController.value * 0.1) : 1.0,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            gradient:
                                _isVoiceListening
                                    ? LinearGradient(
                                      colors: [Colors.red.withOpacity(0.8), Colors.redAccent.withOpacity(0.6)],
                                    )
                                    : LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                      ],
                                    ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: _toggleVoiceSearch,
                            icon: Icon(
                              _isVoiceListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                              color: _isVoiceListening ? Colors.white : Theme.of(context).colorScheme.primary,
                              size: 22,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Send button
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => _performSearch(_searchController.text),
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleVoiceSearch() {
    setState(() {
      _isVoiceListening = !_isVoiceListening;
    });

    if (_isVoiceListening) {
      _pulseController.repeat();
      HapticFeedback.lightImpact();
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }

    // TODO: Implement actual voice search functionality
  }

  Widget _buildContent() {
    if (_isSearching) {
      return _buildLoadingContent();
    }

    if (_showResults && _searchResults != null) {
      return _buildSearchResults();
    }

    return _buildWelcomeContent();
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Searching Islamic Knowledge...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we find the best guidance for you',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Islamic Guidance',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Based on your query: "$_currentQuery"',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Results content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      _searchResults!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.8, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: FadeTransition(
        opacity: _fadeController,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut)),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Welcome illustration
              AnimatedBuilder(
                animation: _breatheController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_breatheController.value * 0.05),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              Text(
                'Welcome to DuaCopilot',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Your intelligent Islamic companion powered by AI. Ask about duas, Islamic teachings, or seek guidance for any situation.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.6),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Quick suggestions
              Text(
                'Try asking about:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              ...[
                'Morning duas & prayers',
                'Travel protection duas',
                'Seeking forgiveness (Istighfar)',
                'Evening remembrance',
              ].asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - _slideController.value) * 50 * (entry.key + 1)),
                        child: Opacity(
                          opacity: _slideController.value,
                          child: _buildSuggestionCard(entry.value, entry.key),
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 40),

              // Recent searches if available
              if (widget.showSearchHistory && _searchHistory.isNotEmpty) ...[
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                ..._searchHistory.take(3).map((item) => _buildHistoryCard(item)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String suggestion, int index) {
    return InkWell(
      onTap: () => _performSearch(suggestion),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withOpacity(0.9)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getSuggestionIcon(index), color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
          ],
        ),
      ),
    );
  }

  IconData _getSuggestionIcon(int index) {
    const icons = [Icons.wb_sunny_rounded, Icons.flight_rounded, Icons.favorite_rounded, Icons.nights_stay_rounded];
    return icons[index % icons.length];
  }

  Widget _buildHistoryCard(SearchHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.history_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.query, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(
                  _formatDateTime(item.timestamp),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        const SmartBannerAd(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Made with ❤️ for the Muslim Community',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

// Search history item class
class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;
  final String results;

  SearchHistoryItem({required this.id, required this.query, required this.timestamp, required this.results});
}
