// lib/presentation/screens/conversational_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/revolutionary_islamic_theme.dart';
import '../widgets/revolutionary_components.dart';
import '../../services/ads/ad_service.dart';
import '../widgets/ads/ad_widgets.dart';

/// ConversationalSearchScreen class implementation
class ConversationalSearchScreen extends ConsumerStatefulWidget {
  final bool enableVoiceSearch;
  final bool enableArabicKeyboard;
  final bool showSearchHistory;
  final VoidCallback? onMenuPressed;

  const ConversationalSearchScreen({
    super.key,
    this.enableVoiceSearch = false,
    this.enableArabicKeyboard = true,
    this.showSearchHistory = true,
    this.onMenuPressed,
  });

  @override
  ConsumerState<ConversationalSearchScreen> createState() => _ConversationalSearchScreenState();
}

class _ConversationalSearchScreenState extends ConsumerState<ConversationalSearchScreen> with TickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  late final AnimationController _searchAnimationController;
  late final AnimationController _resultAnimationController;

  String _currentQuery = '';
  bool _isSearching = false;
  bool _showResults = false;
  String? _searchResults;
  final List<SearchHistoryItem> _searchHistory = [];
  int _searchCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _searchAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _resultAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    // Initialize AdService
    AdService.instance.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchAnimationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    // Check if premium upgrade should be shown
    if (await AdService.instance.shouldShowPremiumUpgrade()) {
      _showPremiumUpgradeDialog();
      return;
    }

    // Show interstitial ad every 3 searches
    _searchCount++;
    if (_searchCount % 3 == 0) {
      AdService.instance.showInterstitialAd();
    }

    setState(() {
      _currentQuery = query;
      _isSearching = true;
      _showResults = false;
    });

    _searchAnimationController.forward();

    try {
      // Simulate search with loading delay
      await Future.delayed(const Duration(seconds: 2));

      final results = await _simulateSearch(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _showResults = true;
      });

      _resultAnimationController.forward();

      // Add to search history
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
        _showResults = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: ${e.toString()}'), backgroundColor: Colors.red.shade600));
    }
  }

  Future<String> _simulateSearch(String query) async {
    final lowerQuery = query.toLowerCase();

    // Contextual responses based on query content
    if (lowerQuery.contains('morning')) {
      return '''**Morning Duas**

اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ

*"O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection."*

**Recommended Time:** After Fajr prayer
**Benefits:** Protection and blessings for the day ahead''';
    }

    if (lowerQuery.contains('travel')) {
      return '''**Travel Duas**

سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ

*"Glory be to Him who has subjected this to us, and we could never have it (by our efforts). And to our Lord we will surely return."*

**Source:** Quran 43:13-14
**When to recite:** Before beginning any journey''';
    }

    return '''**Islamic Guidance**        

Based on your query about "$query", here are some relevant Islamic teachings and duas:

**Relevant Quranic Verse:**
"And whoever relies upon Allah - then He is sufficient for him. Indeed, Allah will accomplish His purpose." (65:3)

**Recommended Dua:**
رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ

*"Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire."*

**Practical Guidance:**
Remember to maintain regular prayers, seek knowledge, and always turn to Allah in times of need.''';
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
                  // Grant temporary premium access
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enjoy 30 minutes of ad-free searches!'),
                      backgroundColor: Colors.green,
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
    return Scaffold(
      backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Smart Search',
        showBackButton: true,
        showHamburger: false,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: RevolutionaryIslamicTheme.heroGradient,
            ),
            child: Column(
              children: [
                Text(
                  'Your AI Islamic Companion',
                  style: RevolutionaryIslamicTheme.body1.copyWith(
                    color: RevolutionaryIslamicTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Search Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: RevolutionaryComponents.modernSearchBar(
              controller: _searchController,
              onSubmitted: _performSearch,
              onChanged: (value) => setState(() => _currentQuery = value),
              hintText: 'Ask about Islamic guidance, duas, or teachings...',
            ),
          ),

          // Content Area
          Expanded(child: _buildContent()),

          // Banner Ad at Bottom
          const SmartBannerAd(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Searching Islamic knowledge...')],
        ),
      );
    }

    if (_showResults && _searchResults != null) {
      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: FadeTransition(
          opacity: _resultAnimationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: _resultAnimationController, curve: Curves.easeOutQuart)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        Theme.of(context).colorScheme.primary.withOpacity(0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI Response',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Based on your query: "$_currentQuery"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
                        ),
                        child: Text(
                          _searchResults!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Interstitial Ad Trigger (invisible, triggers based on search count)
                InterstitialAdTrigger(searchCount: _searchCount, onPremiumPrompt: _showPremiumUpgradeDialog),
              ],
            ),
          ),
        ),
      );
    }

    // Default welcome screen
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.mosque, size: 48, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to DuaCopilot',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your intelligent Islamic companion powered by AI. Ask about duas, Islamic teachings, or seek guidance for any situation.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Quick Start Suggestions
          Text(
            'Try asking about:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...['Morning duas', 'Travel prayers', 'Protection from evil', 'Seeking forgiveness'].map(
            (suggestion) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _buildSuggestionChip(suggestion)),
          ),

          const SizedBox(height: 32),

          // Search History (if available)
          if (widget.showSearchHistory && _searchHistory.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(_searchHistory.take(3).map((item) => _buildHistoryItem(item))),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String title) {
    return InkWell(
      onTap: () => _performSearch(title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.lightbulb_outline, size: 16, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.history),
        title: Text(item.query),
        subtitle: Text(_formatDateTime(item.timestamp)),
        onTap: () => _performSearch(item.query),
        trailing: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchHistory.removeWhere((historyItem) => historyItem.id == item.id);
            });
          },
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

/// SearchHistoryItem class implementation
class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;
  final String results;

  SearchHistoryItem({required this.id, required this.query, required this.timestamp, required this.results});
}
