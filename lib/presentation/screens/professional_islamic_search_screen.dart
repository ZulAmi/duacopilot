// lib/presentation/screens/professional_islamic_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      title: 'القرآن الكريم',
      titleEn: 'Holy Quran',
      description: 'Search verses and meanings',
    ),
    IslamicSearchCategory(
      icon: Icons.article_rounded,
      title: 'الأحاديث النبوية',
      titleEn: 'Prophetic Hadith',
      description: 'Authentic sayings of Prophet ï·º',
    ),
    IslamicSearchCategory(
      icon: Icons.favorite_rounded,
      title: 'الأدعية',
      titleEn: 'Duas & Supplications',
      description: 'Daily prayers and supplications',
    ),
    IslamicSearchCategory(
      icon: Icons.school_rounded,
      title: 'الفقه الإسلامي',
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

  // Replace old mock method with formatter & fallback
  String _formatRagResponse(dynamic ragSearchResponse) {
    final buffer = StringBuffer();
    try {
      // RagResponse has 'response' (content) and 'sources' fields, not 'recommendations'
      if (ragSearchResponse.response == null || ragSearchResponse.response.isEmpty) {
        return _buildFallback('No Islamic knowledge found for this query.');
      }

      buffer.writeln('**📖 Islamic Knowledge Response**\n');

      // Add the main response content
      buffer.writeln(ragSearchResponse.response);

      // Add sources if available
      if (ragSearchResponse.sources != null && ragSearchResponse.sources.isNotEmpty) {
        buffer.writeln('\n**📚 Sources:**');
        for (var source in ragSearchResponse.sources) {
          buffer.writeln('• $source');
        }
      }

      // Add confidence/metadata if available
      if (ragSearchResponse.metadata != null) {
        final metadata = ragSearchResponse.metadata;
        if (metadata['retrieval_confidence'] != null) {
          final confidence = (metadata['retrieval_confidence'] * 100).toStringAsFixed(1);
          buffer.writeln('\n**Confidence:** $confidence%');
        }
        if (metadata['rag_enabled'] == true) {
          buffer.writeln('*Enhanced with TRUE RAG system*');
        }
      }

      buffer.writeln('\n---');
      buffer.writeln('*Always verify with qualified scholars for religious rulings.*');
      return buffer.toString();
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
                      'البحث الإسلامي',
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
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
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
