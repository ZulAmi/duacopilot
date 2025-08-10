import 'package:flutter/material.dart';

class SmartChipController extends ChangeNotifier {
  final List<SmartChipData> _contextualChips = [];
  String _currentContext = '';

  List<SmartChipData> get contextualChips => _contextualChips;

  void updateContext(String context) {
    _currentContext = context;
    _generateContextualChips();
    notifyListeners();
  }

  void _generateContextualChips() {
    _contextualChips.clear();

    if (_currentContext.isEmpty) {
      _contextualChips.addAll(_getDefaultChips());
    } else {
      _contextualChips.addAll(_getContextBasedChips(_currentContext));
    }
  }

  List<SmartChipData> _getDefaultChips() {
    return [
      SmartChipData(
        label: 'Morning Duas',
        query: 'morning duas',
        icon: Icons.wb_sunny,
        lastUsed: DateTime.now(),
        category: 'Daily',
      ),
      SmartChipData(
        label: 'Evening Prayers',
        query: 'evening prayers',
        icon: Icons.nightlight_round,
        lastUsed: DateTime.now(),
        category: 'Daily',
      ),
      SmartChipData(
        label: 'Travel Safety',
        query: 'travel safety duas',
        icon: Icons.flight,
        lastUsed: DateTime.now(),
        category: 'Travel',
      ),
    ];
  }

  List<SmartChipData> _getContextBasedChips(String context) {
    final lowerContext = context.toLowerCase();
    final chips = <SmartChipData>[];

    if (lowerContext.contains('morning')) {
      chips.addAll([
        SmartChipData(
          label: 'Fajr Prayer',
          query: 'fajr prayer duas',
          icon: Icons.wb_twilight,
          lastUsed: DateTime.now(),
          category: 'Prayer',
        ),
        SmartChipData(
          label: 'Dawn Dhikr',
          query: 'morning dhikr',
          icon: Icons.psychology,
          lastUsed: DateTime.now(),
          category: 'Remembrance',
        ),
      ]);
    }

    if (lowerContext.contains('travel')) {
      chips.addAll([
        SmartChipData(
          label: 'Journey Start',
          query: 'journey starting dua',
          icon: Icons.directions,
          lastUsed: DateTime.now(),
          category: 'Travel',
        ),
        SmartChipData(
          label: 'Safe Arrival',
          query: 'safe arrival prayer',
          icon: Icons.home,
          lastUsed: DateTime.now(),
          category: 'Travel',
        ),
      ]);
    }

    return chips;
  }
}

class SmartChipData {
  final String label;
  final String query;
  final IconData icon;
  final Color? color;
  final int usageCount;
  final DateTime lastUsed;
  final String category;

  const SmartChipData({
    required this.label,
    required this.query,
    required this.icon,
    this.color,
    this.usageCount = 0,
    required this.lastUsed,
    required this.category,
  });

  SmartChipData copyWith({
    String? label,
    String? query,
    IconData? icon,
    Color? color,
    int? usageCount,
    DateTime? lastUsed,
    String? category,
  }) {
    return SmartChipData(
      label: label ?? this.label,
      query: query ?? this.query,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
      category: category ?? this.category,
    );
  }
}

class SmartChipWidget extends StatefulWidget {
  final SmartChipData chipData;
  final VoidCallback onTap;
  final bool isSelected;
  final bool showUsageIndicator;

  const SmartChipWidget({
    Key? key,
    required this.chipData,
    required this.onTap,
    this.isSelected = false,
    this.showUsageIndicator = true,
  }) : super(key: key);

  @override
  State<SmartChipWidget> createState() => _SmartChipWidgetState();
}

class _SmartChipWidgetState extends State<SmartChipWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final chipColor = widget.chipData.color ?? colorScheme.primary;
    final backgroundColor =
        widget.isSelected ? chipColor : chipColor.withOpacity(0.1);
    final foregroundColor =
        widget.isSelected ? colorScheme.onPrimary : chipColor;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border:
                    widget.isSelected
                        ? null
                        : Border.all(
                          color: chipColor.withOpacity(0.3),
                          width: 1,
                        ),
                boxShadow:
                    widget.isSelected || _isPressed
                        ? [
                          BoxShadow(
                            color: chipColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.chipData.icon, size: 16, color: foregroundColor),
                  const SizedBox(width: 8),
                  Text(
                    widget.chipData.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: foregroundColor,
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (widget.showUsageIndicator &&
                      widget.chipData.usageCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: foregroundColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.chipData.usageCount}',
                        style: textTheme.labelSmall?.copyWith(
                          color: foregroundColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SmartChipsSection extends StatefulWidget {
  final List<SmartChipData> chips;
  final Function(String) onChipSelected;
  final String? selectedCategory;
  final int maxVisibleChips;
  final bool groupByCategory;

  const SmartChipsSection({
    Key? key,
    required this.chips,
    required this.onChipSelected,
    this.selectedCategory,
    this.maxVisibleChips = 8,
    this.groupByCategory = true,
  }) : super(key: key);

  @override
  State<SmartChipsSection> createState() => _SmartChipsSectionState();
}

class _SmartChipsSectionState extends State<SmartChipsSection> {
  String? _selectedChipQuery;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.chips.isEmpty) return const SizedBox.shrink();

    final sortedChips = _getSortedChips();
    final visibleChips =
        _showAll
            ? sortedChips
            : sortedChips.take(widget.maxVisibleChips).toList();

    if (widget.groupByCategory) {
      return _buildGroupedChips(sortedChips);
    }

    return _buildLinearChips(
      visibleChips,
      sortedChips.length > widget.maxVisibleChips,
    );
  }

  List<SmartChipData> _getSortedChips() {
    final chips = List<SmartChipData>.from(widget.chips);

    // Sort by usage count (descending) and recency
    chips.sort((a, b) {
      if (a.usageCount != b.usageCount) {
        return b.usageCount.compareTo(a.usageCount);
      }
      return b.lastUsed.compareTo(a.lastUsed);
    });

    return chips;
  }

  Widget _buildLinearChips(List<SmartChipData> chips, bool hasMore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              chips.map((chip) {
                return SmartChipWidget(
                  chipData: chip,
                  isSelected: _selectedChipQuery == chip.query,
                  onTap: () {
                    setState(() {
                      _selectedChipQuery = chip.query;
                    });
                    widget.onChipSelected(chip.query);
                  },
                );
              }).toList(),
        ),
        if (hasMore) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showAll ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _showAll ? 'Show Less' : 'Show More',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGroupedChips(List<SmartChipData> chips) {
    final groupedChips = <String, List<SmartChipData>>{};

    for (final chip in chips) {
      groupedChips.putIfAbsent(chip.category, () => []).add(chip);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          groupedChips.entries.map((entry) {
            final category = entry.key;
            final categoryChips = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        categoryChips.map((chip) {
                          return SmartChipWidget(
                            chipData: chip,
                            isSelected: _selectedChipQuery == chip.query,
                            onTap: () {
                              setState(() {
                                _selectedChipQuery = chip.query;
                              });
                              widget.onChipSelected(chip.query);
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class ContextualQuickActions {
  static List<SmartChipData> getIslamicQuickActions() {
    final now = DateTime.now();

    return [
      SmartChipData(
        label: 'Morning Duas',
        query: 'morning duas for daily routine',
        icon: Icons.wb_sunny,
        color: Colors.orange,
        usageCount: 15,
        lastUsed: now.subtract(const Duration(hours: 2)),
        category: 'Daily Prayers',
      ),
      SmartChipData(
        label: 'Evening Duas',
        query: 'evening duas for protection',
        icon: Icons.nightlight_round,
        color: Colors.indigo,
        usageCount: 12,
        lastUsed: now.subtract(const Duration(hours: 8)),
        category: 'Daily Prayers',
      ),
      SmartChipData(
        label: 'Prayer Times',
        query: 'prayer times and duas',
        icon: Icons.schedule,
        color: Colors.green,
        usageCount: 20,
        lastUsed: now.subtract(const Duration(minutes: 30)),
        category: 'Salah',
      ),
      SmartChipData(
        label: 'Istighfar',
        query: 'istighfar duas for forgiveness',
        icon: Icons.favorite,
        color: Colors.red,
        usageCount: 8,
        lastUsed: now.subtract(const Duration(days: 1)),
        category: 'Forgiveness',
      ),
      SmartChipData(
        label: 'Travel Duas',
        query: 'travel duas for safe journey',
        icon: Icons.flight,
        color: Colors.blue,
        usageCount: 5,
        lastUsed: now.subtract(const Duration(days: 3)),
        category: 'Travel',
      ),
      SmartChipData(
        label: 'Food Duas',
        query: 'food duas before and after eating',
        icon: Icons.restaurant,
        color: Colors.brown,
        usageCount: 10,
        lastUsed: now.subtract(const Duration(hours: 4)),
        category: 'Daily Life',
      ),
      SmartChipData(
        label: 'Sleep Duas',
        query: 'sleep duas for peaceful rest',
        icon: Icons.bedtime,
        color: Colors.purple,
        usageCount: 7,
        lastUsed: now.subtract(const Duration(hours: 12)),
        category: 'Daily Life',
      ),
      SmartChipData(
        label: 'Protection',
        query: 'protection duas from evil',
        icon: Icons.shield,
        color: Colors.teal,
        usageCount: 13,
        lastUsed: now.subtract(const Duration(hours: 6)),
        category: 'Protection',
      ),
      SmartChipData(
        label: 'Quran Verses',
        query: 'Quran verses for guidance',
        icon: Icons.menu_book,
        color: Colors.deepPurple,
        usageCount: 18,
        lastUsed: now.subtract(const Duration(hours: 1)),
        category: 'Quran',
      ),
      SmartChipData(
        label: 'Dhikr',
        query: 'dhikr and remembrance of Allah',
        icon: Icons.psychology,
        color: Colors.amber,
        usageCount: 9,
        lastUsed: now.subtract(const Duration(hours: 3)),
        category: 'Remembrance',
      ),
    ];
  }

  static List<SmartChipData> getPersonalizedActions(
    List<String> recentQueries,
    Map<String, int> queryFrequency,
  ) {
    final actions = <SmartChipData>[];
    final now = DateTime.now();

    // Generate chips based on user patterns
    for (final query in recentQueries.take(5)) {
      final frequency = queryFrequency[query] ?? 1;
      actions.add(
        SmartChipData(
          label: _generateLabel(query),
          query: query,
          icon: _getIconForQuery(query),
          color: _getColorForQuery(query),
          usageCount: frequency,
          lastUsed: now.subtract(Duration(hours: recentQueries.indexOf(query))),
          category: 'Recent',
        ),
      );
    }

    return actions;
  }

  static String _generateLabel(String query) {
    if (query.length <= 20) return query;

    final words = query.split(' ');
    if (words.length <= 3) return query;

    return '${words.take(3).join(' ')}...';
  }

  static IconData _getIconForQuery(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('morning')) return Icons.wb_sunny;
    if (lowerQuery.contains('evening')) return Icons.nightlight_round;
    if (lowerQuery.contains('prayer') || lowerQuery.contains('salah'))
      return Icons.schedule;
    if (lowerQuery.contains('travel')) return Icons.flight;
    if (lowerQuery.contains('food')) return Icons.restaurant;
    if (lowerQuery.contains('sleep')) return Icons.bedtime;
    if (lowerQuery.contains('protection')) return Icons.shield;
    if (lowerQuery.contains('quran')) return Icons.menu_book;
    if (lowerQuery.contains('forgive')) return Icons.favorite;

    return Icons.search;
  }

  static Color _getColorForQuery(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('morning')) return Colors.orange;
    if (lowerQuery.contains('evening')) return Colors.indigo;
    if (lowerQuery.contains('prayer')) return Colors.green;
    if (lowerQuery.contains('travel')) return Colors.blue;
    if (lowerQuery.contains('food')) return Colors.brown;
    if (lowerQuery.contains('sleep')) return Colors.purple;
    if (lowerQuery.contains('protection')) return Colors.teal;
    if (lowerQuery.contains('quran')) return Colors.deepPurple;
    if (lowerQuery.contains('forgive')) return Colors.red;

    return Colors.grey;
  }
}
