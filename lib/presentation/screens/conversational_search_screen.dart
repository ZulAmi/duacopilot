import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/conversational_search/conversational_search_field.dart';
import '../widgets/conversational_search/search_history_list.dart';
import '../widgets/conversational_search/smart_chip_widgets.dart';
import '../widgets/conversational_search/real_time_suggestions.dart';
import '../widgets/conversational_search/shimmer_loading_widgets.dart';
import '../../data/mock_dua_data_service.dart';
import '../../domain/entities/dua_entity.dart';
import 'dua_display_screen.dart';

class ConversationalSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final bool enableVoiceSearch;
  final bool enableArabicKeyboard;
  final bool showSearchHistory;

  const ConversationalSearchScreen({
    Key? key,
    this.initialQuery,
    this.enableVoiceSearch = true,
    this.enableArabicKeyboard = true,
    this.showSearchHistory = true,
  }) : super(key: key);

  @override
  State<ConversationalSearchScreen> createState() =>
      _ConversationalSearchScreenState();
}

class _ConversationalSearchScreenState extends State<ConversationalSearchScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late RealTimeSuggestionsController _suggestionsController;
  late SmartChipController _chipController;
  late AnimationController _searchAnimationController;
  late AnimationController _resultAnimationController;

  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<SearchHistoryItem> _searchHistory = [];
  String _currentQuery = '';
  bool _isSearching = false;
  bool _showResults = false;
  String? _searchResults;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSearchHistory();

    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
  }

  void _initializeControllers() {
    _searchController = TextEditingController();
    _suggestionsController = RealTimeSuggestionsController();
    _chipController = SmartChipController();

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _searchController.addListener(() {
      final query = _searchController.text;
      if (query != _currentQuery) {
        _currentQuery = query;
        _suggestionsController.updateQuery(query);
        _chipController.updateContext(query);
      }
    });
  }

  void _loadSearchHistory() {
    // In a real app, load from persistent storage
    _searchHistory = [
      SearchHistoryItem(
        id: '1',
        query: 'Morning duas',
        response:
            'Here are some beautiful morning duas to start your day with blessings...',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        success: true,
        confidence: 0.95,
        responseTime: 450,
      ),
      SearchHistoryItem(
        id: '2',
        query: 'Travel prayer',
        response: 'Dua for safe travel and protection during journey...',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        success: true,
        confidence: 0.88,
        responseTime: 320,
      ),
      SearchHistoryItem(
        id: '3',
        query: 'Evening dhikr',
        response: 'Evening remembrance and duas for protection...',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        success: true,
        confidence: 0.92,
        responseTime: 380,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _suggestionsController.dispose();
    _chipController.dispose();
    _searchAnimationController.dispose();
    _resultAnimationController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _showResults = false;
    });

    _searchAnimationController.forward();

    // Add to suggestions controller
    _suggestionsController.addRecentSearch(query);

    try {
      // Simulate search with delay for demonstration
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, call your RAG repository here
      final results = await _simulateSearch(query);

      setState(() {
        _searchResults = results;
        _showResults = true;
        _isSearching = false;
      });

      _resultAnimationController.forward();

      // Add to search history
      _addToSearchHistory(query, results);
    } catch (error) {
      setState(() {
        _isSearching = false;
        _showResults = true;
        _searchResults =
            'Sorry, an error occurred while searching. Please try again.';
      });

      _addToSearchHistory(query, 'Error: $error', success: false);
    }
  }

  Future<String> _simulateSearch(String query) async {
    // Check if this is a specific dua query
    final foundDuas = MockDuaDataService.searchDuas(query);

    if (foundDuas.isNotEmpty) {
      // Navigate to dua display screen for the first match
      final firstDua = foundDuas.first;
      final relatedDuas = MockDuaDataService.getRelatedDuas(firstDua.id);

      // Navigate to the comprehensive dua display
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => DuaDisplayScreen(
                dua: firstDua,
                relatedDuas: relatedDuas,
                onFavoriteToggle: () {
                  // Implement favorite toggle
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Favorite toggled')));
                },
                onShare: () {
                  // Implement share functionality
                  _shareDua(firstDua);
                },
                onRelatedDuaTap: (relatedDua) {
                  // Navigate to related dua
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => DuaDisplayScreen(
                            dua: relatedDua,
                            relatedDuas: MockDuaDataService.getRelatedDuas(
                              relatedDua.id,
                            ),
                          ),
                    ),
                  );
                },
              ),
        ),
      );

      // Return a summary for the search results
      return '''**${firstDua.category}**

${firstDua.translation}

*Tap above to view the complete Du'a with Arabic text, audio recitation, and detailed Islamic guidance.*

**Source:** ${firstDua.authenticity.source}
**AI Confidence:** ${(firstDua.ragConfidence.score * 100).toInt()}%
''';
    }

    // Simulate different responses based on query for other cases
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('morning')) {
      return '''**Morning Duas**

**1. Upon Waking Up:**
الحَمْدُ للهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ

*"Praise is to Allah who gave us life after having taken it from us and unto Him is the resurrection."*

**2. Morning Dhikr:**
أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ

*"We have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah."*

**3. Seeking Protection:**
أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ

*"I seek refuge in the perfect words of Allah from the evil of what He has created."*''';
    }

    if (lowerQuery.contains('travel')) {
      return '''**Travel Duas**

**Before Starting Journey:**
بِسْمِ اللهِ تَوَكَّلْتُ عَلَى اللهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ

*"In the name of Allah, I trust in Allah, and there is no might nor power except with Allah."*

**During Travel:**
سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ

*"Glory be to Him who has subjected this to us, and we could never have it (by our efforts)."*

**For Safe Arrival:**
اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ خَيْرِ هَذِهِ الْقَرْيَةِ وَخَيْرِ أَهْلِهَا

*"O Allah, I ask You for the good of this town and the good of its people."*''';
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

  void _addToSearchHistory(
    String query,
    String response, {
    bool success = true,
  }) {
    final historyItem = SearchHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      query: query,
      response: response,
      timestamp: DateTime.now(),
      success: success,
      confidence: success ? 0.9 : 0.0,
      responseTime: success ? 400 : null,
    );

    setState(() {
      _searchHistory.insert(0, historyItem);
      if (_searchHistory.length > 20) {
        _searchHistory.removeLast();
      }
    });
  }

  void _onSuggestionTapped(SearchSuggestion suggestion) {
    _searchController.text = suggestion.text;
    _performSearch(suggestion.text);
  }

  void _onSmartChipTapped(SmartChipData chip) {
    // Use the query property instead of action
    _performSearch(chip.query);

    // Record usage if the controller has such a method
    // _chipController.recordChipUsage(chip);
  }

  void _clearSearch() {
    _searchController.clear();
    _suggestionsController.clearSuggestions();
    setState(() {
      _currentQuery = '';
      _isSearching = false;
      _showResults = false;
      _searchResults = null;
    });
    _searchAnimationController.reset();
    _resultAnimationController.reset();
  }

  void _shareDua(DuaEntity dua) {
    final shareText = '''
${dua.category}

${dua.arabicText}

${dua.transliteration}

${dua.translation}

Source: ${dua.authenticity.source} - ${dua.authenticity.reference}

Shared from Dua Copilot - Islamic Search Assistant
''';

    // In a real app, use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Du\'a formatted for sharing'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: shareText));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Professional Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and clear button
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dua Copilot',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Islamic Search Assistant',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_currentQuery.isNotEmpty || _showResults)
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: _clearSearch,
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            tooltip: 'New Search',
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Main Search Field
                  ConversationalSearchField(
                    controller: _searchController,
                    onSearch: _performSearch,
                    onTextChanged: (query) {
                      _suggestionsController.updateQuery(query);
                      _chipController.updateContext(query);
                    },
                    isLoading: _isSearching,
                    supportArabic: widget.enableArabicKeyboard,
                  ),

                  // Real-time Suggestions
                  AnimatedBuilder(
                    animation: _suggestionsController,
                    builder: (context, child) {
                      if (_suggestionsController.suggestions.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: RealTimeSuggestionsWidget(
                          controller: _suggestionsController,
                          onSuggestionTapped: _onSuggestionTapped,
                          maxHeight: 200,
                        ),
                      );
                    },
                  ),

                  // Smart Chips
                  AnimatedBuilder(
                    animation: _chipController,
                    builder: (context, child) {
                      if (_chipController.contextualChips.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _chipController.contextualChips.length,
                          itemBuilder: (context, index) {
                            final chip = _chipController.contextualChips[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: SmartChipWidget(
                                chipData: chip,
                                onTap: () => _onSmartChipTapped(chip),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isSearching) {
      return _buildSearchingState();
    }

    if (_showResults && _searchResults != null) {
      return _buildSearchResults();
    }

    return _buildEmptyState();
  }

  Widget _buildSearchingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RAGLoadingWidget(),
          const SizedBox(height: 24),
          Text(
            'Searching Islamic knowledge...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          const TypingIndicator(text: 'Finding the best answer for you'),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return FadeTransition(
      opacity: _resultAnimationController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _resultAnimationController,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Results Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      Theme.of(context).colorScheme.primary.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    width: 1,
                  ),
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
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Islamic Guidance',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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

              const SizedBox(height: 24),

              // Response Content
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  _searchResults!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Related Actions
              Text(
                'Related Actions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildActionChip('Copy Text', Icons.copy_rounded),
                  _buildActionChip('Share', Icons.share_rounded),
                  _buildActionChip('Save', Icons.bookmark_add_rounded),
                  _buildActionChip('Read Aloud', Icons.volume_up_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () {
        // Handle action
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label action performed')));
      },
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Welcome Section
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mosque_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Dua Copilot',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your AI-powered Islamic knowledge assistant. Search for duas, verses, and Islamic guidance.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Popular Searches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 4.5,
            children: [
              _buildQuickActionCard('Morning Duas', Icons.wb_sunny_rounded),
              _buildQuickActionCard('Travel Prayer', Icons.flight_rounded),
              _buildQuickActionCard('Forgiveness', Icons.favorite_rounded),
              _buildQuickActionCard(
                'Gratitude',
                Icons.volunteer_activism_rounded,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Search History
          if (widget.showSearchHistory && _searchHistory.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SearchHistoryListView(
              historyItems: _searchHistory,
              onItemTapped: (query) {
                _searchController.text = query;
                _performSearch(query);
              },
              onItemDeleted: (id) {
                setState(() {
                  _searchHistory.removeWhere((item) => item.id == id);
                });
              },
              maxItemsPerGroup: 3,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon) {
    return InkWell(
      onTap: () => _performSearch(title),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
