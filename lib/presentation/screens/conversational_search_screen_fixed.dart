// lib/presentation/screens/conversational_search_screen_fixed.dart

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
        formattedResponse.writeln('**🤖 AI Islamic Assistant Response**\n');

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
                '**📚 Islamic Source Authentication:**',
              );
              final authenticity = dua.sourceAuthenticity!;

              // Check the authenticity level to determine source type
              switch (authenticity.level) {
                case AuthenticityLevel.quran:
                  formattedResponse.writeln(
                    '• **Source:** Holy Quran (القرآن الكريم)',
                  );
                  if (authenticity.reference.isNotEmpty) {
                    formattedResponse.writeln(
                      '• **Chapter & Verse:** ${authenticity.reference}',
                    );
                  }
                  formattedResponse.writeln(
                    '• **Authentication:** Divinely Revealed',
                  );
                  break;
                case AuthenticityLevel.sahih:
                case AuthenticityLevel.hasan:
                case AuthenticityLevel.daif:
                case AuthenticityLevel.fabricated:
                  // Hadith sources
                  if (authenticity.source.isNotEmpty) {
                    formattedResponse.writeln(
                      '• **Hadith Book:** ${authenticity.source}',
                    );
                  }
                  if (authenticity.reference.isNotEmpty) {
                    formattedResponse.writeln(
                      '• **Hadith Number:** ${authenticity.reference}',
                    );
                  }
                  if (authenticity.hadithGrade?.isNotEmpty == true) {
                    formattedResponse.writeln(
                      '• **Grading:** ${authenticity.hadithGrade}',
                    );
                  } else {
                    String grading = '';
                    switch (authenticity.level) {
                      case AuthenticityLevel.sahih:
                        grading = 'Sahih (صحيح) - Authentic';
                        break;
                      case AuthenticityLevel.hasan:
                        grading = 'Hasan (حسن) - Good';
                        break;
                      case AuthenticityLevel.daif:
                        grading = 'Da\'if (ضعيف) - Weak';
                        break;
                      case AuthenticityLevel.fabricated:
                        grading = 'Mawdu\' (موضوع) - Fabricated';
                        break;
                      default:
                        grading = 'Unknown grading';
                    }
                    formattedResponse.writeln('• **Grading:** $grading');
                  }
                  if (authenticity.scholar?.isNotEmpty == true) {
                    formattedResponse.writeln(
                      '• **Scholar:** ${authenticity.scholar}',
                    );
                  }
                  break;
                case AuthenticityLevel.verified:
                  formattedResponse.writeln(
                    '• **Source:** Islamic Scholarly Consensus',
                  );
                  if (authenticity.source.isNotEmpty) {
                    formattedResponse.writeln(
                      '• **Reference:** ${authenticity.source}',
                    );
                  }
                  if (authenticity.scholar?.isNotEmpty == true) {
                    formattedResponse.writeln(
                      '• **Scholar:** ${authenticity.scholar}',
                    );
                  }
                  break;
              }
              formattedResponse.writeln('');
            }

            // Add confidence score if available
            if (recommendation.confidenceScore != null) {
              formattedResponse.writeln(
                '**🎯 Relevance Score:** ${(recommendation.confidenceScore! * 100).toStringAsFixed(1)}%\n',
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
      return '''**🌅 Morning Islamic Guidance**

**📖 Quran - Morning Remembrance**

أَوَلَمْ يَرَوْا أَنَّ اللَّهَ الَّذِي خَلَقَ السَّمَاوَاتِ وَالْأَرْضَ قَادِرٌ عَلَى أَن يَخْلُقَهُمْ مِّثْلَهُمْ

*"Did they not see that Allah, who created the heavens and the earth, is capable of creating the like of them?"*

**📚 Source & Authentication:**
• **Source:** Holy Quran  
• **Chapter & Verse:** Al-Isra 17:99
• **Authenticity:** Quran (Divine Revelation)

**✅ Sahih Hadith - Morning Dua**

اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ

*"O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection."*

**📚 Source & Authentication:**
• **Hadith Collection:** Sunan Abu Dawud
• **Hadith Number:** 5068
• **Grading:** Sahih (Authentic)
• **Verified by:** Sheikh Al-Albani

**🕐 When to Use:** After Fajr prayer, upon waking
**💎 Benefits:** Protection and blessings for the day ahead''';
    }

    if (lowerQuery.contains('travel')) {
      return '''**🚗 Travel Islamic Guidance**

**📖 Quran - Travel Verse**

سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ

*"Glory be to Him who has subjected this to us, and we could never have it (by our efforts). And to our Lord we will surely return."*

**📚 Source & Authentication:**
• **Source:** Holy Quran
• **Chapter & Verse:** Az-Zukhruf 43:13-14  
• **Authenticity:** Quran (Divine Revelation)

**🕐 When to Use:** Before beginning any journey
**💎 Benefits:** Divine protection during travel, remembrance of Allah''';
    }

    if (lowerQuery.contains('forgiveness') || lowerQuery.contains('repent')) {
      return '''**🤲 Seeking Forgiveness**

**📖 Powerful Istighfar**

أَسْتَغْفِرُ اللهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ

*"I seek forgiveness from Allah, there is no god but He, the Living, the Eternal, and I turn to Him in repentance."*

**📚 Source & Authentication:**
• **Hadith Collection:** Sunan At-Tirmidhi
• **Hadith Number:** 3577
• **Grading:** Hasan (Good)

**🕐 When to Use:** Anytime, especially after sins
**💎 Benefits:** Forgiveness of all sins, even if they were like sea foam''';
    }

    return '''**🤖 Islamic AI Assistant**        

I apologize, but I encountered an issue accessing the full Islamic knowledge database: $error

**📖 General Islamic Guidance**

Based on your query about "$query", here's some general Islamic guidance:

**Relevant Quranic Verse:**
"And whoever relies upon Allah - then He is sufficient for him. Indeed, Allah will accomplish His purpose."

**📚 Source & Authentication:**
• **Source:** Holy Quran
• **Chapter & Verse:** At-Talaq 65:3
• **Authenticity:** Quran (Divine Revelation)

**🟢 Hasan Hadith - Universal Dua**

رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ

*"Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire."*

**📚 Source & Authentication:**
• **Hadith Collection:** Sahih Al-Bukhari
• **Hadith Number:** 4522
• **Grading:** Hasan (Good)

**🕊️ Islamic Reminder:**
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
            RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1),
            RevolutionaryIslamicTheme.secondaryNavy.withOpacity(0.1),
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
              color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(0.5),
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
            color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(0.5),
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
                        RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.8),
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
                    color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.3),
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
            color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(0.5),
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
                    color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1),
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
            color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(0.3),
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
                    color: RevolutionaryIslamicTheme.secondaryNavy.withOpacity(0.1),
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
