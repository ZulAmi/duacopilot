// lib/presentation/screens/professional_islamic_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection_container.dart';
import '../../core/error/failures.dart';
import '../../core/theme/professional_islamic_theme.dart';
import '../../domain/usecases/search_rag.dart';
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
  ConsumerState<ProfessionalIslamicSearchScreen> createState() => _ProfessionalIslamicSearchScreenState();
}

class _ProfessionalIslamicSearchScreenState extends ConsumerState<ProfessionalIslamicSearchScreen>
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
      description: 'Authentic sayings of Prophet Ã¯Â·Âº',
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

  late final SearchRag _searchRag; // RAG use case
  String? _errorMessage; // store failures

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: ProfessionalIslamicTheme.animationNormal,
      vsync: this,
    );

    _searchRag = sl<SearchRag>();
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
      _errorMessage = null;
      _searchResults = null;
    });

    try {
      final ragEither = await _searchRag(query);
      ragEither.fold(
        (failure) {
          setState(() {
            _isSearching = false;
            _showResults = false;
            _errorMessage = _mapFailure(failure);
          });
          if (mounted) {
            ProfessionalComponents.showSnackBar(
              context: context,
              message: 'Search failed: ${_errorMessage ?? 'Unknown error'}',
              icon: Icons.error_rounded,
              backgroundColor: ProfessionalIslamicTheme.error,
            );
          }
        },
        (ragResponse) {
          final formatted = _formatRagResponse(ragResponse);
          setState(() {
            _searchResults = formatted;
            _isSearching = false;
            _showResults = true;
            _searchCount++;
          });
          final historyItem = IslamicSearchHistoryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            query: query,
            timestamp: DateTime.now(),
            results: formatted,
          );
          setState(() {
            _searchHistory.insert(0, historyItem);
            if (_searchHistory.length > 15) _searchHistory.removeLast();
          });
        },
      );
    } catch (e) {
      setState(() {
        _isSearching = false;
        _showResults = false;
        _errorMessage = e.toString();
      });
      if (mounted) {
        ProfessionalComponents.showSnackBar(
          context: context,
          message: 'Unexpected error during search',
          icon: Icons.error_outline,
          backgroundColor: ProfessionalIslamicTheme.error,
        );
      }
    }
  }

  // Replace old mock method with comprehensive RAG formatter
  String _formatRagResponse(dynamic ragSearchResponse) {
    try {
      // The RAG response already contains the comprehensive formatted content
      if (ragSearchResponse.response == null || ragSearchResponse.response.isEmpty) {
        return _buildFallback('No Islamic knowledge found for this query.');
      }

      // The response from IslamicRagService already contains:
      // - Compassionate opening
      // - Core Quranic foundations with verse citations
      // - Practical Islamic guidance with recommended duas
      // - Authentic hadith references (if available)
      // - Related Islamic themes
      // - Spiritual conclusion
      // - Comprehensive citations with confidence scores
      // Just return the formatted response directly
      return ragSearchResponse.response;
    } catch (e) {
      return _buildFallback('Error formatting RAG response: $e');
    }
  }

  String _buildFallback(String reason) {
    return '''**Islamic Guidance (Fallback)**\n\n$reason\n\n**Reminder:** Maintain prayers, seek knowledge, and remember Allah often.''';
  }

  String _mapFailure(Failure failure) {
    if (failure is NetworkFailure) return 'Network issue, please check your connection';
    if (failure is ServerFailure) return 'Server error fetching Islamic knowledge';
    if (failure is CacheFailure) return 'Cache error retrieving results';
    if (failure is ValidationFailure) return 'Invalid query';
    if (failure is AuthenticationFailure) return 'Authentication required';
    return 'Unknown error';
  }

  /// Handle back navigation ensuring user returns to home screen
  /// This method provides a robust navigation pattern that:
  /// 1. First attempts to pop to the previous screen (typically home)
  /// 2. Falls back to GoRouter navigation to home if no previous screen
  /// 3. Uses traditional navigation as final fallback
  void _handleBackNavigation() {
    // Check if we can pop (i.e., there's a previous screen)
    if (Navigator.of(context).canPop()) {
      // Pop back to the previous screen (should be home screen)
      Navigator.of(context).pop();
    } else {
      // Fallback: Navigate to home screen using GoRouter
      try {
        context.go('/');
      } catch (e) {
        // Final fallback: Use traditional navigation
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
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
            onPressed: () => _handleBackNavigation(),
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
                color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ProfessionalIslamicTheme.radiusSm,
                ),
                border: Border.all(
                  color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.2),
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
                children: _searchCategories.map((category) => _buildCompactCategoryChip(category)).toList(),
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
      margin: const EdgeInsets.all(ProfessionalIslamicTheme.space2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ProfessionalIslamicTheme.backgroundSecondary,
            ProfessionalIslamicTheme.backgroundSecondary.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Header with Islamic Pattern
          Container(
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ProfessionalIslamicTheme.islamicGreen,
                  ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.9),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ProfessionalIslamicTheme.radiusLg),
                topRight: Radius.circular(ProfessionalIslamicTheme.radiusLg),
              ),
            ),
            child: Row(
              children: [
                // Elegant Islamic Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
                    border: Border.all(
                      color: ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
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
                        'Islamic Guidance',
                        style: ProfessionalIslamicTheme.heading3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ProfessionalIslamicTheme.textOnIslamic,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
                        ),
                        child: Text(
                          'Query: "$_currentQuery"',
                          style: ProfessionalIslamicTheme.body2.copyWith(
                            color: ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Decorative Islamic Star
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Response Content with Beautiful Typography
          Container(
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
            child: _buildFormattedResponse(_searchResults!),
          ),

          // Beautiful Footer with Islamic Elements
          Container(
            margin: const EdgeInsets.fromLTRB(
              ProfessionalIslamicTheme.space4,
              0,
              ProfessionalIslamicTheme.space4,
              ProfessionalIslamicTheme.space4,
            ),
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.08),
                  ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusMd),
              border: Border.all(
                color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    size: 18,
                    color: ProfessionalIslamicTheme.islamicGreen,
                  ),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authentic Islamic Sources',
                        style: ProfessionalIslamicTheme.body1.copyWith(
                          color: ProfessionalIslamicTheme.islamicGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Generated from Quran, authentic Hadith & scholarly guidance',
                        style: ProfessionalIslamicTheme.body2.copyWith(
                          color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Islamic Crescent Moon
                Icon(
                  Icons.brightness_2_rounded,
                  size: 20,
                  color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),

          // Disclaimer with Professional Styling
          Container(
            margin: const EdgeInsets.fromLTRB(
              ProfessionalIslamicTheme.space4,
              0,
              ProfessionalIslamicTheme.space4,
              ProfessionalIslamicTheme.space5,
            ),
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space3),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusSm),
              border: Border.all(
                color: ProfessionalIslamicTheme.warning.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: ProfessionalIslamicTheme.warning.withValues(alpha: 0.8),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space2),
                Expanded(
                  child: Text(
                    'Always consult qualified Islamic scholars for religious rulings and verify guidance with authentic sources.',
                    style: ProfessionalIslamicTheme.body2.copyWith(
                      color: ProfessionalIslamicTheme.warning.withValues(alpha: 0.9),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedResponse(String response) {
    // Enhanced text rendering to handle the comprehensive RAG response format
    final lines = response.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Skip empty lines but add spacing
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Handle different formatting
      if (line.startsWith('## ')) {
        // Section headers
        widgets.add(_buildSectionHeader(line.substring(3)));
      } else if (line.startsWith('### ')) {
        // Subsection headers
        widgets.add(_buildSubsectionHeader(line.substring(4)));
      } else if (line.startsWith('**[') && line.contains(']')) {
        // Citations and references
        widgets.add(_buildCitationText(line));
      } else if (line.startsWith('> ')) {
        // Quoted text (Arabic, translations, etc.)
        widgets.add(_buildQuotedText(line.substring(2)));
      } else if (line.startsWith('*') && line.endsWith('*')) {
        // Italic/emphasis text
        widgets.add(_buildEmphasisText(line));
      } else if (line.contains('ï·º') || line.contains('ï·»')) {
        // Text with Islamic honorifics
        widgets.add(_buildIslamicText(line));
      } else if (line.trim() == '---') {
        // Divider
        widgets.add(_buildDivider());
      } else {
        // Regular text
        widgets.add(_buildRegularText(line));
      }

      // Add spacing between elements
      if (i < lines.length - 1) {
        widgets.add(const SizedBox(height: 6));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildSectionHeader(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ProfessionalIslamicTheme.islamicGreen,
                  ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.trim(),
              style: ProfessionalIslamicTheme.heading3.copyWith(
                color: ProfessionalIslamicTheme.islamicGreen,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 14,
              color: ProfessionalIslamicTheme.islamicGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsectionHeader(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.1),
            ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusMd),
        border: Border.all(
          color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.label_rounded,
            size: 16,
            color: ProfessionalIslamicTheme.islamicGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.trim(),
              style: ProfessionalIslamicTheme.body1.copyWith(
                color: ProfessionalIslamicTheme.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitationText(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.08),
            ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusMd),
        border: Border.all(
          color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.islamicGreen,
              borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
            ),
            child: Icon(
              Icons.format_quote_rounded,
              size: 12,
              color: ProfessionalIslamicTheme.textOnIslamic,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.trim(),
              style: ProfessionalIslamicTheme.body1.copyWith(
                color: ProfessionalIslamicTheme.islamicGreen,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotedText(String text) {
    final isArabic = text.contains('Arabic:');
    final isTranslation = text.contains('Translation:');
    final isTransliteration = text.contains('Transliteration:');

    Color backgroundColor;
    Color borderColor;
    IconData iconData;

    if (isArabic) {
      backgroundColor = ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.08);
      borderColor = ProfessionalIslamicTheme.islamicGreen;
      iconData = Icons.menu_book_rounded;
    } else if (isTranslation) {
      backgroundColor = ProfessionalIslamicTheme.warning.withValues(alpha: 0.08);
      borderColor = ProfessionalIslamicTheme.warning;
      iconData = Icons.translate_rounded;
    } else {
      backgroundColor = ProfessionalIslamicTheme.textSecondary.withValues(alpha: 0.05);
      borderColor = ProfessionalIslamicTheme.textSecondary.withValues(alpha: 0.3);
      iconData = Icons.text_fields_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, top: 6, bottom: 6, right: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusMd),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
          top: BorderSide(color: borderColor.withValues(alpha: 0.2)),
          right: BorderSide(color: borderColor.withValues(alpha: 0.2)),
          bottom: BorderSide(color: borderColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
            ),
            child: Icon(
              iconData,
              size: 14,
              color: borderColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.trim(),
              style: ProfessionalIslamicTheme.body1.copyWith(
                color: ProfessionalIslamicTheme.textPrimary,
                fontWeight: isArabic ? FontWeight.w600 : FontWeight.w500,
                fontStyle: isTransliteration ? FontStyle.italic : FontStyle.normal,
                height: 1.6,
                fontSize: isArabic ? 16 : 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmphasisText(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.textSecondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusSm),
        border: Border.all(
          color: ProfessionalIslamicTheme.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        text.trim().replaceAll('*', ''),
        style: ProfessionalIslamicTheme.body2.copyWith(
          color: ProfessionalIslamicTheme.textSecondary,
          fontStyle: FontStyle.italic,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIslamicText(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ProfessionalIslamicTheme.warning.withValues(alpha: 0.1),
            ProfessionalIslamicTheme.warning.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusMd),
        border: Border.all(
          color: ProfessionalIslamicTheme.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.star_rounded,
            size: 16,
            color: ProfessionalIslamicTheme.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.trim(),
              style: ProfessionalIslamicTheme.body1.copyWith(
                color: ProfessionalIslamicTheme.textPrimary,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusFull),
              border: Border.all(
                color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              Icons.brightness_2_rounded,
              size: 12,
              color: ProfessionalIslamicTheme.islamicGreen,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularText(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text.trim(),
        style: ProfessionalIslamicTheme.body1.copyWith(
          color: ProfessionalIslamicTheme.textPrimary,
          height: 1.7,
          fontWeight: FontWeight.w400,
        ),
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
              color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(
                ProfessionalIslamicTheme.radiusMd,
              ),
              border: Border.all(
                color: ProfessionalIslamicTheme.islamicGreen.withValues(alpha: 0.1),
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
                  'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„Ù‘ÙŽÙ‡Ù Ø§Ù„Ø±Ù‘ÙŽØ­Ù’Ù…ÙŽÙ°Ù†Ù Ø§Ù„Ø±Ù‘ÙŽØ­ÙÙŠÙ…Ù',
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
            ...(_searchHistory.take(5).map((item) => _buildHistoryItem(item)).toList()),
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

