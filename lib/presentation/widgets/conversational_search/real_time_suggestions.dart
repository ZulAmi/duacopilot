import 'package:flutter/material.dart';
import 'dart:async';

/// SearchSuggestion class implementation
class SearchSuggestion {
  final String id;
  final String text;
  final String? description;
  final SuggestionType type;
  final double relevanceScore;
  final List<String>? keywords;
  final String? category;
  final IconData? icon;

  const SearchSuggestion({
    required this.id,
    required this.text,
    this.description,
    required this.type,
    required this.relevanceScore,
    this.keywords,
    this.category,
    this.icon,
  });
}

enum SuggestionType { query, completion, correction, related, popular, recent, semantic }

/// RealTimeSuggestionsController class implementation
class RealTimeSuggestionsController extends ChangeNotifier {
  final List<SearchSuggestion> _suggestions = [];
  final List<SearchSuggestion> _recentSearches = [];
  final List<SearchSuggestion> _popularSearches = [];
  final Map<String, int> _searchFrequency = {};

  Timer? _debounceTimer;
  String _currentQuery = '';
  bool _isLoading = false;

  List<SearchSuggestion> get suggestions => _suggestions;
  List<SearchSuggestion> get recentSearches => _recentSearches;
  List<SearchSuggestion> get popularSearches => _popularSearches;
  String get currentQuery => _currentQuery;
  bool get isLoading => _isLoading;

  void updateQuery(String query) {
    _currentQuery = query;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _generateSuggestions(query);
    });
  }

  void addRecentSearch(String query) {
    final suggestion = SearchSuggestion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: query,
      type: SuggestionType.recent,
      relevanceScore: 1.0,
    );

    _recentSearches.removeWhere((s) => s.text.toLowerCase() == query.toLowerCase());
    _recentSearches.insert(0, suggestion);

    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }

    _updateSearchFrequency(query);
    _updatePopularSearches();
    notifyListeners();
  }

  void _updateSearchFrequency(String query) {
    final normalizedQuery = query.toLowerCase().trim();
    _searchFrequency[normalizedQuery] = (_searchFrequency[normalizedQuery] ?? 0) + 1;
  }

  void _updatePopularSearches() {
    final sortedEntries = _searchFrequency.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    _popularSearches.clear();
    for (int i = 0; i < sortedEntries.length && i < 5; i++) {
      final entry = sortedEntries[i];
      _popularSearches.add(
        SearchSuggestion(
          id: 'popular_$i',
          text: entry.key,
          type: SuggestionType.popular,
          relevanceScore: entry.value.toDouble(),
          description: 'Searched ${entry.value} times',
        ),
      );
    }
  }

  void _generateSuggestions(String query) {
    _isLoading = true;
    notifyListeners();

    _suggestions.clear();

    if (query.isEmpty) {
      _suggestions.addAll(_getEmptyStateSuggestions());
    } else {
      _suggestions.addAll(_getQueryCompletions(query));
      _suggestions.addAll(_getSemanticSuggestions(query));
      _suggestions.addAll(_getSpellingCorrections(query));
      _suggestions.addAll(_getRelatedQueries(query));
    }

    // Sort by relevance score
    _suggestions.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    // Limit to top 8 suggestions
    if (_suggestions.length > 8) {
      _suggestions.removeRange(8, _suggestions.length);
    }

    _isLoading = false;
    notifyListeners();
  }

  List<SearchSuggestion> _getEmptyStateSuggestions() {
    final suggestions = <SearchSuggestion>[];

    // Add recent searches
    suggestions.addAll(_recentSearches.take(3));

    // Add popular searches
    suggestions.addAll(_popularSearches.take(3));

    // Add default suggestions
    suggestions.addAll(_getDefaultSuggestions());

    return suggestions;
  }

  List<SearchSuggestion> _getDefaultSuggestions() {
    return [
      const SearchSuggestion(
        id: 'morning_duas',
        text: 'Morning duas',
        description: 'Duas for starting the day',
        type: SuggestionType.query,
        relevanceScore: 0.9,
        icon: Icons.wb_sunny,
        category: 'Daily Prayers',
      ),
      const SearchSuggestion(
        id: 'prayer_times',
        text: 'Prayer times duas',
        description: 'Duas for different prayer times',
        type: SuggestionType.query,
        relevanceScore: 0.8,
        icon: Icons.schedule,
        category: 'Prayer',
      ),
      const SearchSuggestion(
        id: 'travel_duas',
        text: 'Travel duas',
        description: 'Duas for traveling',
        type: SuggestionType.query,
        relevanceScore: 0.7,
        icon: Icons.flight,
        category: 'Travel',
      ),
      const SearchSuggestion(
        id: 'forgiveness',
        text: 'Forgiveness duas',
        description: 'Seeking Allah\'s forgiveness',
        type: SuggestionType.query,
        relevanceScore: 0.6,
        icon: Icons.favorite,
        category: 'Spiritual',
      ),
    ];
  }

  List<SearchSuggestion> _getQueryCompletions(String query) {
    final completions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    final commonCompletions = {
      'morning': ['morning duas', 'morning prayer', 'morning remembrance'],
      'evening': ['evening duas', 'evening prayer', 'evening dhikr'],
      'travel': ['travel duas', 'traveling prayer', 'journey safety'],
      'food': ['food duas', 'eating prayer', 'meal blessing'],
      'sleep': ['sleep duas', 'bedtime prayer', 'night protection'],
      'prayer': ['prayer times', 'prayer duas', 'prayer direction'],
      'forgive': ['forgiveness duas', 'seeking forgiveness', 'istighfar'],
      'protect': ['protection duas', 'safety prayers', 'evil eye protection'],
      'quran': ['quran verses', 'quran duas', 'quranic prayers'],
      'dhikr': ['dhikr duas', 'remembrance of allah', 'morning dhikr'],
    };

    for (final entry in commonCompletions.entries) {
      if (entry.key.startsWith(lowerQuery)) {
        for (final completion in entry.value) {
          if (completion.toLowerCase().contains(lowerQuery)) {
            completions.add(
              SearchSuggestion(
                id: 'completion_${completion.replaceAll(' ', '_')}',
                text: completion,
                type: SuggestionType.completion,
                relevanceScore: _calculateCompletionScore(query, completion),
              ),
            );
          }
        }
      }
    }

    return completions;
  }

  List<SearchSuggestion> _getSemanticSuggestions(String query) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    final semanticMappings = {
      'morning': {
        'duas': ['fajr duas', 'sunrise prayers', 'dawn remembrance'],
        'prayer': ['fajr prayer', 'morning salah', 'dawn prayer'],
      },
      'evening': {
        'duas': ['maghrib duas', 'sunset prayers', 'evening remembrance'],
        'prayer': ['maghrib prayer', 'evening salah', 'sunset prayer'],
      },
      'protect': {
        'duas': ['safety prayers', 'shield from evil', 'divine protection'],
        'evil': ['evil eye protection', 'harm prevention', 'negative energy'],
      },
      'forgive': {
        'duas': ['repentance prayers', 'seeking mercy', 'tawbah'],
        'sin': ['sin forgiveness', 'cleansing prayers', 'purification'],
      },
    };

    for (final category in semanticMappings.keys) {
      if (lowerQuery.contains(category)) {
        for (final subcategory in semanticMappings[category]!.keys) {
          if (lowerQuery.contains(subcategory)) {
            for (final suggestion in semanticMappings[category]![subcategory]!) {
              suggestions.add(
                SearchSuggestion(
                  id: 'semantic_${suggestion.replaceAll(' ', '_')}',
                  text: suggestion,
                  type: SuggestionType.semantic,
                  relevanceScore: _calculateSemanticScore(query, suggestion),
                  description: 'Related to "$query"',
                ),
              );
            }
          }
        }
      }
    }

    return suggestions;
  }

  List<SearchSuggestion> _getSpellingCorrections(String query) {
    final corrections = <SearchSuggestion>[];
    final commonMisspellings = {
      'dua': ['due', 'dua\'s', 'duas'],
      'prayer': ['pryer', 'prayr', 'prayar'],
      'morning': ['mornign', 'morining', 'moring'],
      'evening': ['evenign', 'evning', 'eveing'],
      'protection': ['protecton', 'protction', 'proection'],
      'forgiveness': ['forgivness', 'forgivenes', 'forgivenss'],
      'travel': ['travle', 'travl', 'trvel'],
      'dhikr': ['dikr', 'zikr', 'dhikir'],
      'quran': ['qoran', 'kuran', 'qur\'an'],
    };

    for (final entry in commonMisspellings.entries) {
      final correct = entry.key;
      final misspellings = entry.value;

      for (final misspelling in misspellings) {
        if (_calculateEditDistance(query.toLowerCase(), misspelling) <= 2) {
          corrections.add(
            SearchSuggestion(
              id: 'correction_$correct',
              text: correct,
              type: SuggestionType.correction,
              relevanceScore: 0.8,
              description: 'Did you mean "$correct"?',
            ),
          );
        }
      }
    }

    return corrections;
  }

  List<SearchSuggestion> _getRelatedQueries(String query) {
    final related = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    final relatedQueries = {
      'morning': ['evening duas', 'daily prayers', 'fajr time'],
      'evening': ['morning duas', 'night prayers', 'maghrib time'],
      'travel': ['journey safety', 'airplane prayer', 'safe arrival'],
      'food': ['drink blessing', 'meal gratitude', 'hunger relief'],
      'sleep': ['nightmare protection', 'peaceful rest', 'bedtime dhikr'],
      'prayer': ['qibla direction', 'wudu steps', 'prayer times'],
      'forgiveness': ['repentance guide', 'mercy seeking', 'sin cleansing'],
      'protection': ['evil eye remedy', 'harm prevention', 'safety shield'],
    };

    for (final category in relatedQueries.keys) {
      if (lowerQuery.contains(category)) {
        for (final relatedQuery in relatedQueries[category]!) {
          related.add(
            SearchSuggestion(
              id: 'related_${relatedQuery.replaceAll(' ', '_')}',
              text: relatedQuery,
              type: SuggestionType.related,
              relevanceScore: 0.6,
              description: 'Related search',
            ),
          );
        }
      }
    }

    return related;
  }

  double _calculateCompletionScore(String query, String completion) {
    final queryLength = query.length;
    final completionLength = completion.length;

    if (queryLength == 0) return 0.0;

    // Exact prefix match gets higher score
    if (completion.toLowerCase().startsWith(query.toLowerCase())) {
      return 0.9 - (completionLength - queryLength) * 0.01;
    }

    // Contains query gets lower score
    if (completion.toLowerCase().contains(query.toLowerCase())) {
      return 0.7 - (completionLength - queryLength) * 0.01;
    }

    return 0.3;
  }

  double _calculateSemanticScore(String query, String suggestion) {
    final queryWords = query.toLowerCase().split(' ');
    final suggestionWords = suggestion.toLowerCase().split(' ');

    int matchCount = 0;
    for (final queryWord in queryWords) {
      for (final suggestionWord in suggestionWords) {
        if (queryWord == suggestionWord || queryWord.contains(suggestionWord) || suggestionWord.contains(queryWord)) {
          matchCount++;
        }
      }
    }

    return (matchCount / queryWords.length) * 0.8;
  }

  int _calculateEditDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;

    final dp = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));

    for (int i = 0; i <= len1; i++) {
      dp[i][0] = i;
    }
    for (int j = 0; j <= len2; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[len1][len2];
  }

  void clearSuggestions() {
    _suggestions.clear();
    _currentQuery = '';
    _debounceTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// RealTimeSuggestionsWidget class implementation
class RealTimeSuggestionsWidget extends StatefulWidget {
  final RealTimeSuggestionsController controller;
  final Function(SearchSuggestion) onSuggestionTapped;
  final bool showIcons;
  final bool showDescriptions;
  final double maxHeight;

  const RealTimeSuggestionsWidget({
    super.key,
    required this.controller,
    required this.onSuggestionTapped,
    this.showIcons = true,
    this.showDescriptions = true,
    this.maxHeight = 300,
  });

  @override
  State<RealTimeSuggestionsWidget> createState() => _RealTimeSuggestionsWidgetState();
}

/// _RealTimeSuggestionsWidgetState class implementation
class _RealTimeSuggestionsWidgetState extends State<RealTimeSuggestionsWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.suggestions.isEmpty && !widget.controller.isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: widget.controller.isLoading ? _buildLoadingState() : _buildSuggestionsList(),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Generating suggestions...',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.controller.suggestions.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
      itemBuilder: (context, index) {
        final suggestion = widget.controller.suggestions[index];
        return _buildSuggestionItem(suggestion);
      },
    );
  }

  Widget _buildSuggestionItem(SearchSuggestion suggestion) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onSuggestionTapped(suggestion),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (widget.showIcons) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getSuggestionTypeColor(suggestion.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    suggestion.icon ?? _getSuggestionTypeIcon(suggestion.type),
                    size: 16,
                    color: _getSuggestionTypeColor(suggestion.type),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.text,
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.showDescriptions && suggestion.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        suggestion.description!,
                        style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.north_west, size: 14, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSuggestionTypeIcon(SuggestionType type) {
    switch (type) {
      case SuggestionType.completion:
        return Icons.auto_awesome;
      case SuggestionType.correction:
        return Icons.spellcheck;
      case SuggestionType.related:
        return Icons.link;
      case SuggestionType.popular:
        return Icons.trending_up;
      case SuggestionType.recent:
        return Icons.history;
      case SuggestionType.semantic:
        return Icons.psychology;
      default:
        return Icons.search;
    }
  }

  Color _getSuggestionTypeColor(SuggestionType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case SuggestionType.completion:
        return Colors.blue;
      case SuggestionType.correction:
        return Colors.orange;
      case SuggestionType.related:
        return Colors.green;
      case SuggestionType.popular:
        return Colors.purple;
      case SuggestionType.recent:
        return Colors.grey;
      case SuggestionType.semantic:
        return colorScheme.primary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}
