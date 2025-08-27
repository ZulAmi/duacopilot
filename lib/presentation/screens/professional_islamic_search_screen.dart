// lib/presentation/screens/professional_islamic_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/professional_islamic_theme.dart';
import '../widgets/professional_components.dart';

/// Professional Islamic Search Screen
/// Designed with Islamic values and professional appearance in mind
class ProfessionalIslamicSearchScreen extends ConsumerStatefulWidget {
  final bool enableVoiceSearch;
  final bool enableArabicKeyboard;
  final bool showSearchHistory;
  final VoidCallback? onMenuPressed;

  const ProfessionalIslamicSearchScreen({
    super.key,
    this.enableVoiceSearch = false,
    this.enableArabicKeyboard = true,
    this.showSearchHistory = true,
    this.onMenuPressed,
  });

  @override
  ConsumerState<ProfessionalIslamicSearchScreen> createState() =>
      _ProfessionalIslamicSearchScreenState();
}

class _ProfessionalIslamicSearchScreenState
    extends ConsumerState<ProfessionalIslamicSearchScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  late final AnimationController _fadeController;

  String _currentQuery = '';
  bool _isSearching = false;
  bool _showResults = false;
  String? _searchResults;
  final List<IslamicSearchHistoryItem> _searchHistory = [];
  int _searchCount = 0;

  // Islamic search categories
  final List<IslamicSearchCategory> _searchCategories = [
    IslamicSearchCategory(
      icon: Icons.menu_book_rounded,
      title: 'Ø§Ù„Ù‚Ø±Ø¢Ù† Ø§Ù„ÙƒØ±ÙŠÙ…',
      titleEn: 'Holy Quran',
      description: 'Search verses and meanings',
    ),
    IslamicSearchCategory(
      icon: Icons.article_rounded,
      title: 'Ø§Ù„Ø£Ø­Ø§Ø¯ÙŠØ« Ø§Ù„Ù†Ø¨ÙˆÙŠØ©',
      titleEn: 'Prophetic Hadith',
      description: 'Authentic sayings of Prophet ï·º',
    ),
    IslamicSearchCategory(
      icon: Icons.favorite_rounded,
      title: 'Ø§Ù„Ø£Ø¯Ø¹ÙŠØ©',
      titleEn: 'Duas & Supplications',
      description: 'Daily prayers and supplications',
    ),
    IslamicSearchCategory(
      icon: Icons.school_rounded,
      title: 'Ø§Ù„ÙÙ‚Ù‡ Ø§Ù„Ø¥Ø³Ù„Ø§Ù…ÙŠ',
      titleEn: 'Islamic Jurisprudence',
      description: 'Islamic legal rulings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: ProfessionalIslamicTheme.animationNormal,
      vsync: this,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _currentQuery = query;
      _isSearching = true;
      _showResults = false;
    });

    try {
      // Simulate search with appropriate delay
      await Future.delayed(const Duration(seconds: 2));

      final results = await _simulateIslamicSearch(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _showResults = true;
        _searchCount++;
      });

      // Add to search history
      final historyItem = IslamicSearchHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        query: query,
        timestamp: DateTime.now(),
        results: results,
      );

      setState(() {
        _searchHistory.insert(0, historyItem);
        if (_searchHistory.length > 15) {
          _searchHistory.removeLast();
        }
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _showResults = false;
      });

      if (mounted) {
        ProfessionalComponents.showSnackBar(
          context: context,
          message: 'Search failed. Please try again.',
          icon: Icons.error_rounded,
          backgroundColor: ProfessionalIslamicTheme.error,
        );
      }
    }
  }

  Future<String> _simulateIslamicSearch(String query) async {
    final lowerQuery = query.toLowerCase();

    // Islamic contextual responses
    if (lowerQuery.contains('morning') || lowerQuery.contains('ØµØ¨Ø§Ø­')) {
      return '''**Ø£Ø°ÙƒØ§Ø± Ø§Ù„ØµØ¨Ø§Ø­ - Morning Remembrance**

**Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø¨ÙÙƒÙŽ Ø£ÙŽØµÙ’Ø¨ÙŽØ­Ù’Ù†ÙŽØ§ ÙˆÙŽØ¨ÙÙƒÙŽ Ø£ÙŽÙ…Ù’Ø³ÙŽÙŠÙ’Ù†ÙŽØ§ ÙˆÙŽØ¨ÙÙƒÙŽ Ù†ÙŽØ­Ù’ÙŠÙŽØ§ ÙˆÙŽØ¨ÙÙƒÙŽ Ù†ÙŽÙ…ÙÙˆØªÙ ÙˆÙŽØ¥ÙÙ„ÙŽÙŠÙ’ÙƒÙŽ Ø§Ù„Ù†ÙÙ‘Ø´ÙÙˆØ±Ù**

*"AllÄhumma bika aá¹£baá¸¥nÄ wa bika amsaynÄ wa bika naá¸¥yÄ wa bika namÅ«tu wa ilayka an-nushÅ«r"*

**Translation:** "O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection."

**Source:** Abu Dawud, At-Tirmidhi
**Time:** After Fajr prayer
**Benefits:** Protection and blessings for the day''';
    }

    if (lowerQuery.contains('travel') || lowerQuery.contains('Ø³ÙØ±')) {
      return '''**Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ø³ÙØ± - Travel Supplication**

**Ø³ÙØ¨Ù’Ø­ÙŽØ§Ù†ÙŽ Ø§Ù„ÙŽÙ‘Ø°ÙÙŠ Ø³ÙŽØ®ÙŽÙ‘Ø±ÙŽ Ù„ÙŽÙ†ÙŽØ§ Ù‡ÙŽÙ°Ø°ÙŽØ§ ÙˆÙŽÙ…ÙŽØ§ ÙƒÙÙ†ÙŽÙ‘Ø§ Ù„ÙŽÙ‡Ù Ù…ÙÙ‚Ù’Ø±ÙÙ†ÙÙŠÙ†ÙŽ ÙˆÙŽØ¥ÙÙ†ÙŽÙ‘Ø§ Ø¥ÙÙ„ÙŽÙ‰Ù° Ø±ÙŽØ¨ÙÙ‘Ù†ÙŽØ§ Ù„ÙŽÙ…ÙÙ†Ù‚ÙŽÙ„ÙØ¨ÙÙˆÙ†ÙŽ**

*"Subá¸¥Äna alladhÄ« sakhkhara lanÄ hÄdhÄ wa mÄ kunnÄ lahu muqrinÄ«n wa innÄ ilÄ rabbinÄ la-munqalibÅ«n"*

**Translation:** "Glory be to Him who has subjected this to us, and we could never have it (by our efforts). And to our Lord we will surely return."

**Source:** Quran 43:13-14
**When:** Before beginning any journey
**Benefits:** Protection during travel''';
    }

    if (lowerQuery.contains('forgiveness') ||
        lowerQuery.contains('Ø§Ø³ØªØºÙØ§Ø±')) {
      return '''**Ø§Ù„Ø§Ø³ØªØºÙØ§Ø± - Seeking Forgiveness**

**Ø£ÙŽØ³Ù’ØªÙŽØºÙ’ÙÙØ±Ù Ø§Ù„Ù„Ù‡ÙŽ Ø§Ù„ÙŽÙ‘Ø°ÙÙŠ Ù„ÙŽØ§ Ø¥ÙÙ„ÙŽÙ‡ÙŽ Ø¥ÙÙ„ÙŽÙ‘Ø§ Ù‡ÙÙˆÙŽ Ø§Ù„Ù’Ø­ÙŽÙŠÙÙ‘ Ø§Ù„Ù’Ù‚ÙŽÙŠÙÙ‘ÙˆÙ…Ù ÙˆÙŽØ£ÙŽØªÙÙˆØ¨Ù Ø¥ÙÙ„ÙŽÙŠÙ’Ù‡Ù**

*"Astaghfiru allÄha alladhÄ« lÄ ilÄha illÄ huwa al-á¸¥ayyu al-qayyÅ«mu wa atÅ«bu ilayh"*

**Translation:** "I seek forgiveness from Allah, besides whom there is no deity, the Ever-Living, the Self-Sustaining, and I repent to Him."

**Source:** Abu Dawud, At-Tirmidhi, Al-Hakim
**Benefits:** Complete forgiveness of sins
**Recommendation:** Recite 100 times daily''';
    }

    // Default response
    return '''**Ø¥Ø±Ø´Ø§Ø¯ Ø¥Ø³Ù„Ø§Ù…ÙŠ - Islamic Guidance**

Based on your query about "$query", here is relevant Islamic knowledge:

**Quranic Guidance:**
"ÙˆÙŽÙ…ÙŽÙ† ÙŠÙŽØªÙŽÙ‘Ù‚Ù Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙŽ ÙŠÙŽØ¬Ù’Ø¹ÙŽÙ„ Ù„ÙŽÙ‘Ù‡Ù Ù…ÙŽØ®Ù’Ø±ÙŽØ¬Ù‹Ø§ ÙˆÙŽÙŠÙŽØ±Ù’Ø²ÙÙ‚Ù’Ù‡Ù Ù…ÙÙ†Ù’ Ø­ÙŽÙŠÙ’Ø«Ù Ù„ÙŽØ§ ÙŠÙŽØ­Ù’ØªÙŽØ³ÙØ¨Ù"

*"And whoever fears Allah - He will make for him a way out and provide for him from where he does not expect."* - Quran 65:2-3

**Recommended Dua:**
**Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ø¢ØªÙÙ†ÙŽØ§ ÙÙÙŠ Ø§Ù„Ø¯ÙÙ‘Ù†Ù’ÙŠÙŽØ§ Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙÙÙŠ Ø§Ù„Ù’Ø¢Ø®ÙØ±ÙŽØ©Ù Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙ‚ÙÙ†ÙŽØ§ Ø¹ÙŽØ°ÙŽØ§Ø¨ÙŽ Ø§Ù„Ù†ÙŽÙ‘Ø§Ø±Ù**

*"RabbanÄ ÄtinÄ fÄ« ad-dunyÄ á¸¥asanatan wa fÄ« al-Äkhirati á¸¥asanatan wa qinÄ Ê¿adhÄba an-nÄr"*

**Translation:** "Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire."

**Islamic Guidance:** Remember Allah often, maintain regular prayers, seek beneficial knowledge, and always turn to Allah in times of need.''';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // Can be changed to RTL for Arabic
      child: Scaffold(
        backgroundColor: ProfessionalIslamicTheme.backgroundPrimary,
        appBar: AppBar(
          title: Text(
            'Islamic Knowledge Search',
            style: TextStyle(
              color: ProfessionalIslamicTheme.textOnIslamic,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: ProfessionalIslamicTheme.islamicGreen,
          foregroundColor: ProfessionalIslamicTheme.textOnIslamic,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeController,
            child: Column(
              children: [
                _buildProfessionalHeader(),
                _buildSearchSection(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.backgroundSecondary,
        border: Border(
          bottom: BorderSide(
            color: ProfessionalIslamicTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ProfessionalIslamicTheme.space3),
                decoration: BoxDecoration(
                  color: ProfessionalIslamicTheme.islamicGreen,
                  borderRadius: BorderRadius.circular(
                    ProfessionalIslamicTheme.radiusMd,
                  ),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: ProfessionalIslamicTheme.textOnIslamic,
                  size: 24,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø¥Ø³Ù„Ø§Ù…ÙŠ',
                      style: ProfessionalIslamicTheme.heading3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ProfessionalIslamicTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Search Islamic Knowledge & Guidance',
                      style: ProfessionalIslamicTheme.body2.copyWith(
                        color: ProfessionalIslamicTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_searchCount > 0) ...[
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ProfessionalIslamicTheme.space4,
                vertical: ProfessionalIslamicTheme.space2,
              ),
              decoration: BoxDecoration(
                color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ProfessionalIslamicTheme.radiusSm,
                ),
                border: Border.all(
                  color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    size: 16,
                    color: ProfessionalIslamicTheme.islamicGreen,
                  ),
                  const SizedBox(width: ProfessionalIslamicTheme.space2),
                  Text(
                    'Searches performed: $_searchCount',
                    style: ProfessionalIslamicTheme.body2.copyWith(
                      color: ProfessionalIslamicTheme.islamicGreen,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.backgroundSecondary,
              borderRadius: BorderRadius.circular(
                ProfessionalIslamicTheme.radiusMd,
              ),
              border: Border.all(color: ProfessionalIslamicTheme.borderLight),
              boxShadow: ProfessionalIslamicTheme.shadowSoft,
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: _performSearch,
              onChanged: (value) => setState(() => _currentQuery = value),
              decoration: InputDecoration(
                hintText: 'Search Quran, Hadith, Duas, or Islamic guidance...',
                hintStyle: TextStyle(
                  color: ProfessionalIslamicTheme.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: ProfessionalIslamicTheme.textSecondary,
                ),
                suffixIcon: _currentQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _currentQuery = '');
                        },
                        icon: Icon(
                          Icons.clear,
                          color: ProfessionalIslamicTheme.textSecondary,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(
                  ProfessionalIslamicTheme.space4,
                ),
              ),
              style: TextStyle(color: ProfessionalIslamicTheme.textPrimary),
            ),
          ),

          // Compact Search Categories - Only show when not searching/showing results
          if (!_isSearching && !_showResults) ...[
            const SizedBox(height: ProfessionalIslamicTheme.space3),
            Text(
              'Quick Search',
              style: ProfessionalIslamicTheme.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: ProfessionalIslamicTheme.textSecondary,
              ),
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space2),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _searchCategories
                    .map((category) => _buildCompactCategoryChip(category))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactCategoryChip(IslamicSearchCategory category) {
    return Container(
      margin: const EdgeInsets.only(right: ProfessionalIslamicTheme.space2),
      child: GestureDetector(
        onTap: () => _performSearch(category.titleEn),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ProfessionalIslamicTheme.space3,
            vertical: ProfessionalIslamicTheme.space2,
          ),
          decoration: BoxDecoration(
            color: ProfessionalIslamicTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(
              ProfessionalIslamicTheme.radiusFull,
            ),
            border: Border.all(color: ProfessionalIslamicTheme.borderLight),
            boxShadow: ProfessionalIslamicTheme.shadowSoft,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                size: 16,
                color: ProfessionalIslamicTheme.islamicGreen,
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space2),
              Text(
                category.titleEn,
                style: ProfessionalIslamicTheme.body2.copyWith(
                  color: ProfessionalIslamicTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: ProfessionalIslamicTheme.islamicGreen,
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            Text(
              'Searching Islamic knowledge...',
              style: ProfessionalIslamicTheme.body1.copyWith(
                color: ProfessionalIslamicTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_showResults && _searchResults != null) {
      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
        child: _buildSearchResults(),
      );
    }

    return _buildWelcomeContent();
  }

  Widget _buildSearchResults() {
    return Container(
      padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusMd),
        border: Border.all(color: ProfessionalIslamicTheme.borderLight),
        boxShadow: ProfessionalIslamicTheme.shadowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ProfessionalIslamicTheme.islamicGreen,
                  borderRadius: BorderRadius.circular(
                    ProfessionalIslamicTheme.radiusSm,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: ProfessionalIslamicTheme.textOnIslamic,
                  size: 20,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Results',
                      style: ProfessionalIslamicTheme.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ProfessionalIslamicTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Query: "$_currentQuery"',
                      style: ProfessionalIslamicTheme.body2.copyWith(
                        color: ProfessionalIslamicTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.backgroundPrimary,
              borderRadius: BorderRadius.circular(
                ProfessionalIslamicTheme.radiusSm,
              ),
              border: Border.all(color: ProfessionalIslamicTheme.borderLight),
            ),
            child: Text(
              _searchResults!,
              style: ProfessionalIslamicTheme.body1.copyWith(
                color: ProfessionalIslamicTheme.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(
                ProfessionalIslamicTheme.radiusMd,
              ),
              border: Border.all(
                color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.mosque_rounded,
                  size: 40,
                  color: ProfessionalIslamicTheme.islamicGreen,
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space3),
                Text(
                  'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„ÙŽÙ‘Ù‡Ù Ø§Ù„Ø±ÙŽÙ‘Ø­Ù’Ù…ÙŽÙ†Ù Ø§Ù„Ø±ÙŽÙ‘Ø­ÙÙŠÙ…Ù',
                  style: ProfessionalIslamicTheme.heading3.copyWith(
                    color: ProfessionalIslamicTheme.islamicGreen,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space2),
                Text(
                  'Welcome to Islamic Knowledge Search',
                  style: ProfessionalIslamicTheme.body1.copyWith(
                    color: ProfessionalIslamicTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space2),
                Text(
                  'Search for Quranic verses, authentic Hadith, daily duas, and Islamic guidance.',
                  style: ProfessionalIslamicTheme.body2.copyWith(
                    color: ProfessionalIslamicTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: ProfessionalIslamicTheme.space6),

          // Quick Suggestions
          Text(
            'Popular Searches',
            style: ProfessionalIslamicTheme.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: ProfessionalIslamicTheme.textPrimary,
            ),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space3),

          ...[
            'Morning remembrance',
            'Evening supplications',
            'Travel prayers',
            'Seeking forgiveness',
            'Prayer times',
            'Quranic wisdom',
          ].map((suggestion) => _buildSuggestionItem(suggestion)),

          // Search History
          if (widget.showSearchHistory && _searchHistory.isNotEmpty) ...[
            const SizedBox(height: ProfessionalIslamicTheme.space6),
            Text(
              'Recent Searches',
              style: ProfessionalIslamicTheme.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: ProfessionalIslamicTheme.textPrimary,
              ),
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space3),
            ...(_searchHistory
                .take(5)
                .map((item) => _buildHistoryItem(item))
                .toList()),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: ProfessionalIslamicTheme.space2),
      child: InkWell(
        onTap: () => _performSearch(suggestion),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space3),
          decoration: BoxDecoration(
            color: ProfessionalIslamicTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(
              ProfessionalIslamicTheme.radiusSm,
            ),
            border: Border.all(color: ProfessionalIslamicTheme.borderLight),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 18,
                color: ProfessionalIslamicTheme.textSecondary,
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space3),
              Expanded(
                child: Text(
                  suggestion,
                  style: ProfessionalIslamicTheme.body2.copyWith(
                    color: ProfessionalIslamicTheme.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: ProfessionalIslamicTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(IslamicSearchHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: ProfessionalIslamicTheme.space2),
      child: InkWell(
        onTap: () => _performSearch(item.query),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space3),
          decoration: BoxDecoration(
            color: ProfessionalIslamicTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(
              ProfessionalIslamicTheme.radiusSm,
            ),
            border: Border.all(color: ProfessionalIslamicTheme.borderLight),
          ),
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 18,
                color: ProfessionalIslamicTheme.textSecondary,
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.query,
                      style: ProfessionalIslamicTheme.body2.copyWith(
                        color: ProfessionalIslamicTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatDateTime(item.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: ProfessionalIslamicTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: ProfessionalIslamicTheme.textSecondary,
              ),
            ],
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

/// Islamic Search History Item
class IslamicSearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;
  final String results;

  IslamicSearchHistoryItem({
    required this.id,
    required this.query,
    required this.timestamp,
    required this.results,
  });
}

/// Islamic Search Category
class IslamicSearchCategory {
  final IconData icon;
  final String title; // Arabic
  final String titleEn; // English
  final String description;

  IslamicSearchCategory({
    required this.icon,
    required this.title,
    required this.titleEn,
    required this.description,
  });
}
