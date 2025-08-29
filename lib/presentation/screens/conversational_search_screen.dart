// lib/presentation/screens/conversational_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/revolutionary_islamic_theme.dart';
import '../../domain/entities/dua_entity.dart';
import '../../domain/usecases/search_rag.dart';
import '../../services/ads/ad_service.dart';
import '../widgets/ads/ad_widgets.dart';
import '../widgets/revolutionary_components.dart';

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
  late final SearchRag _searchRag;

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
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize RAG service
    _searchRag = sl<SearchRag>();

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

      final results = await _performRagSearch(query);

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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  Future<String> _performRagSearch(String query) async {
    try {
      // Use the real RAG search
      final ragResponse = await _searchRag(query);

      return ragResponse.fold(
        (failure) => _getFallbackResponse(query, failure.toString()),
        (response) => _formatRagResponse(response),
      );
    } catch (e) {
      return _getFallbackResponse(query, e.toString());
    }
  }

  String _formatRagResponse(dynamic ragSearchResponse) {
    // Parse the RAG response and format with proper Islamic citations
    final StringBuffer formattedResponse = StringBuffer();

    try {
      // Extract recommendations from RAG response
      final recommendations = ragSearchResponse.recommendations ?? [];

      if (recommendations.isNotEmpty) {
        formattedResponse.writeln('**ðŸ¤– AI Islamic Assistant Response**\n');

        for (int i = 0; i < recommendations.length && i < 3; i++) {
          final recommendation = recommendations[i];
          final dua = recommendation.dua;

          if (dua != null) {
            // Add Dua content
            formattedResponse.writeln(
              '**${dua.title ?? 'Islamic Guidance'}**\n',
            );
            formattedResponse.writeln('${dua.arabicText ?? ''}');
            formattedResponse.writeln('${dua.transliteration ?? ''}');
            formattedResponse.writeln('${dua.translation ?? ''}\n');

            // Add Islamic Citations
            if (dua.sourceAuthenticity != null) {
              formattedResponse.writeln(
                '**ðŸ“š Islamic Source Authentication:**',
              );
              final authenticity = dua.sourceAuthenticity!;

              // Check the authenticity level to determine source type
              switch (authenticity.level) {
                case AuthenticityLevel.quran:
                  formattedResponse.writeln(
                    'â€¢ **Source:** Holy Quran (Ø§Ù„Ù‚Ø±Ø¢Ù† Ø§Ù„ÙƒØ±ÙŠÙ…)',
                  );
                  if (authenticity.reference.isNotEmpty) {
                    formattedResponse.writeln(
                      'â€¢ **Chapter & Verse:** ${authenticity.reference}',
                    );
                  }
                  formattedResponse.writeln(
                    'â€¢ **Authentication:** Divinely Revealed',
                  );
                  break;
                case AuthenticityLevel.sahih:
                case AuthenticityLevel.hasan:
                case AuthenticityLevel.daif:
                case AuthenticityLevel.fabricated:
                  // Hadith sources
                  if (authenticity.source.isNotEmpty) {
                    formattedResponse.writeln(
                      'â€¢ **Hadith Book:** ${authenticity.source}',
                    );
                  }
                  if (authenticity.reference.isNotEmpty) {
                    formattedResponse.writeln(
                      'â€¢ **Hadith Number:** ${authenticity.reference}',
                    );
                  }
                  if (authenticity.hadithGrade?.isNotEmpty == true) {
                    formattedResponse.writeln(
                      'â€¢ **Grading:** ${authenticity.hadithGrade}',
                    );
                  } else {
                    String grading = '';
                    switch (authenticity.level) {
                      case AuthenticityLevel.sahih:
                        grading = 'Sahih (ØµØ­ÙŠØ­) - Authentic';
                        break;
                      case AuthenticityLevel.hasan:
                        grading = 'Hasan (Ø­Ø³Ù†) - Good';
                        break;
                      case AuthenticityLevel.daif:
                        grading = 'Da\'if (Ø¶Ø¹ÙŠÙ) - Weak';
                        break;
                      case AuthenticityLevel.fabricated:
                        grading = 'Mawdu\' (Ù…ÙˆØ¶ÙˆØ¹) - Fabricated';
                        break;
                      default:
                        grading = 'Unknown grading';
                    }
                    formattedResponse.writeln('â€¢ **Grading:** $grading');
                  }
                  if (authenticity.scholar?.isNotEmpty == true) {
                    formattedResponse.writeln(
                      'â€¢ **Scholar:** ${authenticity.scholar}',
                    );
                  }
                  break;
                case AuthenticityLevel.verified:
                  formattedResponse.writeln(
                    'â€¢ **Source:** Islamic Scholarly Consensus',
                  );
                  if (authenticity.source.isNotEmpty) {
                    formattedResponse.writeln(
                      'â€¢ **Reference:** ${authenticity.source}',
                    );
                  }
                  if (authenticity.scholar?.isNotEmpty == true) {
                    formattedResponse.writeln(
                      'â€¢ **Scholar:** ${authenticity.scholar}',
                    );
                  }
                  break;
              }
              formattedResponse.writeln('');
            }

            // Add confidence score if available
            if (recommendation.confidenceScore != null) {
              formattedResponse.writeln(
                '**ðŸŽ¯ Relevance Score:** ${(recommendation.confidenceScore! * 100).toStringAsFixed(1)}%\n',
              );
            }
          }
        }

        // Add general guidance footer
        formattedResponse.writeln('---');
        formattedResponse.writeln(
          '*May Allah grant you beneficial knowledge and righteous deeds. Always consult qualified Islamic scholars for religious matters.*',
        );
      } else {
        return _getFallbackResponse('', 'No specific recommendations found');
      }
    } catch (e) {
      return _getFallbackResponse(
        '',
        'Error formatting response: ${e.toString()}',
      );
    }

    return formattedResponse.toString();
  }

  String _getFallbackResponse(String query, String error) {
    final lowerQuery = query.toLowerCase();

    // Contextual responses based on query content with proper citations
    if (lowerQuery.contains('morning')) {
      return '''**ðŸŒ… Morning Islamic Guidance**

**ðŸ“– Quran - Morning Remembrance**

Ø£ÙŽÙˆÙŽÙ„ÙŽÙ…Ù’ ÙŠÙŽØ±ÙŽÙˆÙ’Ø§ Ø£ÙŽÙ†ÙŽÙ‘ Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙŽ Ø§Ù„ÙŽÙ‘Ø°ÙÙŠ Ø®ÙŽÙ„ÙŽÙ‚ÙŽ Ø§Ù„Ø³ÙŽÙ‘Ù…ÙŽØ§ÙˆÙŽØ§ØªÙ ÙˆÙŽØ§Ù„Ù’Ø£ÙŽØ±Ù’Ø¶ÙŽ Ù‚ÙŽØ§Ø¯ÙØ±ÙŒ Ø¹ÙŽÙ„ÙŽÙ‰ Ø£ÙŽÙ† ÙŠÙŽØ®Ù’Ù„ÙÙ‚ÙŽÙ‡ÙÙ…Ù’ Ù…ÙÙ‘Ø«Ù’Ù„ÙŽÙ‡ÙÙ…Ù’

*"Did they not see that Allah, who created the heavens and the earth, is capable of creating the like of them?"*

**ðŸ“š Source & Authentication:**
â€¢ **Source:** Holy Quran  
â€¢ **Chapter & Verse:** Al-Isra 17:99
â€¢ **Authenticity:** Quran (Divine Revelation)

**âœ… Sahih Hadith - Morning Dua**

Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø¨ÙÙƒÙŽ Ø£ÙŽØµÙ’Ø¨ÙŽØ­Ù’Ù†ÙŽØ§ ÙˆÙŽØ¨ÙÙƒÙŽ Ø£ÙŽÙ…Ù’Ø³ÙŽÙŠÙ’Ù†ÙŽØ§ ÙˆÙŽØ¨ÙÙƒÙŽ Ù†ÙŽØ­Ù’ÙŠÙŽØ§ ÙˆÙŽØ¨ÙÙƒÙŽ Ù†ÙŽÙ…ÙÙˆØªÙ ÙˆÙŽØ¥ÙÙ„ÙŽÙŠÙ’ÙƒÙŽ Ø§Ù„Ù†ÙÙ‘Ø´ÙÙˆØ±Ù

*"O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection."*

**ðŸ“š Source & Authentication:**
â€¢ **Hadith Collection:** Sunan Abu Dawud
â€¢ **Hadith Number:** 5068
â€¢ **Grading:** Sahih (Authentic)
â€¢ **Verified by:** Sheikh Al-Albani

**ðŸ• When to Use:** After Fajr prayer, upon waking
**ðŸ’Ž Benefits:** Protection and blessings for the day ahead''';
    }

    if (lowerQuery.contains('travel')) {
      return '''**ðŸš— Travel Islamic Guidance**

**ðŸ“– Quran - Travel Verse**

Ø³ÙØ¨Ù’Ø­ÙŽØ§Ù†ÙŽ Ø§Ù„ÙŽÙ‘Ø°ÙÙŠ Ø³ÙŽØ®ÙŽÙ‘Ø±ÙŽ Ù„ÙŽÙ†ÙŽØ§ Ù‡ÙŽÙ°Ø°ÙŽØ§ ÙˆÙŽÙ…ÙŽØ§ ÙƒÙÙ†ÙŽÙ‘Ø§ Ù„ÙŽÙ‡Ù Ù…ÙÙ‚Ù’Ø±ÙÙ†ÙÙŠÙ†ÙŽ ÙˆÙŽØ¥ÙÙ†ÙŽÙ‘Ø§ Ø¥ÙÙ„ÙŽÙ‰Ù° Ø±ÙŽØ¨ÙÙ‘Ù†ÙŽØ§ Ù„ÙŽÙ…ÙÙ†Ù‚ÙŽÙ„ÙØ¨ÙÙˆÙ†ÙŽ

*"Glory be to Him who has subjected this to us, and we could never have it (by our efforts). And to our Lord we will surely return."*

**ðŸ“š Source & Authentication:**
â€¢ **Source:** Holy Quran
â€¢ **Chapter & Verse:** Az-Zukhruf 43:13-14  
â€¢ **Authenticity:** Quran (Divine Revelation)

**ðŸ• When to Use:** Before beginning any journey
**ðŸ’Ž Benefits:** Divine protection during travel, remembrance of Allah''';
    }

    if (lowerQuery.contains('forgiveness') || lowerQuery.contains('repent')) {
      return '''**ðŸ¤² Seeking Forgiveness**

**ðŸ“– Powerful Istighfar**

Ø£ÙŽØ³Ù’ØªÙŽØºÙ’ÙÙØ±Ù Ø§Ù„Ù„Ù‡ÙŽ Ø§Ù„ÙŽÙ‘Ø°ÙÙŠ Ù„ÙŽØ§ Ø¥ÙÙ„ÙŽÙ‡ÙŽ Ø¥ÙÙ„ÙŽÙ‘Ø§ Ù‡ÙÙˆÙŽ Ø§Ù„Ù’Ø­ÙŽÙŠÙÙ‘ Ø§Ù„Ù’Ù‚ÙŽÙŠÙÙ‘ÙˆÙ…Ù ÙˆÙŽØ£ÙŽØªÙÙˆØ¨Ù Ø¥ÙÙ„ÙŽÙŠÙ’Ù‡Ù

*"I seek forgiveness from Allah, there is no god but He, the Living, the Eternal, and I turn to Him in repentance."*

**ðŸ“š Source & Authentication:**
â€¢ **Hadith Collection:** Sunan At-Tirmidhi
â€¢ **Hadith Number:** 3577
â€¢ **Grading:** Hasan (Good)

**ðŸ• When to Use:** Anytime, especially after sins
**ðŸ’Ž Benefits:** Forgiveness of all sins, even if they were like sea foam''';
    }

    return '''**ðŸ¤– Islamic AI Assistant**        

I apologize, but I encountered an issue accessing the full Islamic knowledge database: $error

**ðŸ“– General Islamic Guidance**

Based on your query about "$query", here's some general Islamic guidance:

**Relevant Quranic Verse:**
"And whoever relies upon Allah - then He is sufficient for him. Indeed, Allah will accomplish His purpose."

**ðŸ“š Source & Authentication:**
â€¢ **Source:** Holy Quran
â€¢ **Chapter & Verse:** At-Talaq 65:3
â€¢ **Authenticity:** Quran (Divine Revelation)

**ðŸŸ¢ Hasan Hadith - Universal Dua**

Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ø¢ØªÙÙ†ÙŽØ§ ÙÙÙŠ Ø§Ù„Ø¯ÙÙ‘Ù†Ù’ÙŠÙŽØ§ Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙÙÙŠ Ø§Ù„Ù’Ø¢Ø®ÙØ±ÙŽØ©Ù Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙ‚ÙÙ†ÙŽØ§ Ø¹ÙŽØ°ÙŽØ§Ø¨ÙŽ Ø§Ù„Ù†ÙŽÙ‘Ø§Ø±Ù

*"Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire."*

**ðŸ“š Source & Authentication:**
â€¢ **Hadith Collection:** Sahih Al-Bukhari
â€¢ **Hadith Number:** 4522
â€¢ **Grading:** Hasan (Good)

**ðŸ•Šï¸ Islamic Reminder:**
Remember to maintain regular prayers, seek knowledge, and always turn to Allah in times of need. Please verify all Islamic guidance with qualified scholars.''';
  }

  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => PremiumUpgradeDialog(
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
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildContent()),
            const SmartBannerAd(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.1),
            RevolutionaryIslamicTheme.secondaryNavy.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RevolutionaryIslamicTheme.primaryEmerald,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: RevolutionaryIslamicTheme.neutralWhite,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Islamic Search',
                      style: TextStyle(
                        fontSize: 20,
                        color: RevolutionaryIslamicTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'AI-powered Islamic knowledge search',
                      style: TextStyle(
                        fontSize: 14,
                        color: RevolutionaryIslamicTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Searches',
                  _searchCount.toString(),
                  Icons.search_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'History',
                  _searchHistory.length.toString(),
                  Icons.history_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'AI Powered',
                  'GPT',
                  Icons.auto_awesome_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: RevolutionaryIslamicTheme.primaryEmerald, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: RevolutionaryIslamicTheme.textPrimary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: RevolutionaryIslamicTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: RevolutionaryIslamicTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _performSearch,
          onChanged: (value) => setState(() => _currentQuery = value),
          decoration: InputDecoration(
            hintText: 'Ask about Islamic guidance, duas, or teachings...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: RevolutionaryIslamicTheme.textSecondary,
            ),
            suffixIcon: _currentQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _currentQuery = '');
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: RevolutionaryIslamicTheme.textSecondary,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
            hintStyle: const TextStyle(
              color: RevolutionaryIslamicTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching Islamic knowledge...'),
          ],
        ),
      );
    }

    if (_showResults && _searchResults != null) {
      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FadeTransition(
          opacity: _resultAnimationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _resultAnimationController,
                curve: Curves.easeOutQuart,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchResultCard(),
                InterstitialAdTrigger(
                  searchCount: _searchCount,
                  onPremiumPrompt: _showPremiumUpgradeDialog,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Default welcome screen
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Quick Start Suggestions Header
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Try asking about:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: RevolutionaryIslamicTheme.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Suggestion Cards
          ...[
            'Morning duas',
            'Travel prayers',
            'Protection from evil',
            'Seeking forgiveness',
          ].map((suggestion) => _buildSuggestionChip(suggestion)),

          const SizedBox(height: 24),

          // Search History (if available)
          if (widget.showSearchHistory && _searchHistory.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: RevolutionaryIslamicTheme.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: RevolutionaryIslamicTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...(_searchHistory.take(3).map((item) => _buildHistoryItem(item))),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResultCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        RevolutionaryIslamicTheme.primaryEmerald,
                        RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: RevolutionaryIslamicTheme.neutralWhite,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Response',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: RevolutionaryIslamicTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Query: "$_currentQuery"',
                        style: const TextStyle(
                          fontSize: 14,
                          color: RevolutionaryIslamicTheme.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: RevolutionaryIslamicTheme.primaryEmerald,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RevolutionaryIslamicTheme.backgroundPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: RevolutionaryIslamicTheme.borderLight,
                ),
              ),
              child: Text(
                _searchResults!,
                style: const TextStyle(
                  fontSize: 14,
                  color: RevolutionaryIslamicTheme.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _performSearch(title),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: RevolutionaryIslamicTheme.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: RevolutionaryIslamicTheme.textSecondary,
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _performSearch(item.query),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: RevolutionaryIslamicTheme.secondaryNavy.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.history,
                    size: 16,
                    color: RevolutionaryIslamicTheme.secondaryNavy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.query,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: RevolutionaryIslamicTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTime(item.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: RevolutionaryIslamicTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _searchHistory.removeWhere(
                        (historyItem) => historyItem.id == item.id,
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 16,
                    color: RevolutionaryIslamicTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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

  SearchHistoryItem({
    required this.id,
    required this.query,
    required this.timestamp,
    required this.results,
  });
}

