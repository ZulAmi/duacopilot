import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../widgets/revolutionary_components.dart';

class QuranExplorerScreen extends ConsumerStatefulWidget {
  const QuranExplorerScreen({super.key});

  @override
  ConsumerState<QuranExplorerScreen> createState() => _QuranExplorerScreenState();
}

class _QuranExplorerScreenState extends ConsumerState<QuranExplorerScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  final TextEditingController _searchController = TextEditingController();
  List<Surah> _surahs = [];
  List<Surah> _filteredSurahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadSurahs();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    // Simulate loading Quran data
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _surahs = _getMockSurahs();
        _filteredSurahs = _surahs;
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  List<Surah> _getMockSurahs() {
    return [
      Surah(1, 'Al-Fatiha', 'الفاتحة', 'The Opening', 7, 'Meccan', true),
      Surah(2, 'Al-Baqarah', 'البقرة', 'The Cow', 286, 'Medinan', true),
      Surah(
        3,
        'Ali \'Imran',
        'آل عمران',
        'Family of Imran',
        200,
        'Medinan',
        false,
      ),
      Surah(4, 'An-Nisa', 'النساء', 'The Women', 176, 'Medinan', false),
      Surah(
        5,
        'Al-Ma\'idah',
        'المائدة',
        'The Table Spread',
        120,
        'Medinan',
        false,
      ),
      Surah(6, 'Al-An\'am', 'الأنعام', 'The Cattle', 165, 'Meccan', false),
      Surah(7, 'Al-A\'raf', 'الأعراف', 'The Heights', 206, 'Meccan', false),
      Surah(
        8,
        'Al-Anfal',
        'الأنفال',
        'The Spoils of War',
        75,
        'Medinan',
        false,
      ),
      Surah(9, 'At-Tawbah', 'التوبة', 'The Repentance', 129, 'Medinan', false),
      Surah(10, 'Yunus', 'يونس', 'Jonah', 109, 'Meccan', false),
      Surah(67, 'Al-Mulk', 'الملك', 'The Sovereignty', 30, 'Meccan', true),
      Surah(112, 'Al-Ikhlas', 'الإخلاص', 'The Sincerity', 4, 'Meccan', true),
      Surah(113, 'Al-Falaq', 'الفلق', 'The Daybreak', 5, 'Meccan', true),
      Surah(114, 'An-Nas', 'الناس', 'Mankind', 6, 'Meccan', true),
    ];
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _surahs;
      } else {
        _filteredSurahs = _surahs.where((surah) {
          return surah.name.toLowerCase().contains(query.toLowerCase()) ||
              surah.arabicName.contains(query) ||
              surah.englishName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              surah.number.toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Quran Explorer',
        showBackButton: true,
        showHamburger: false,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: _isLoading ? _buildLoadingState() : _buildQuranContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              RevolutionaryIslamicTheme.primaryEmerald,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading Quran...',
            style: TextStyle(
              fontSize: 16,
              color: RevolutionaryIslamicTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranContent() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(child: _buildSurahsList()),
        ],
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
                  Icons.menu_book_rounded,
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
                      'Holy Quran',
                      style: TextStyle(
                        fontSize: 20,
                        color: RevolutionaryIslamicTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '114 Surahs • 6,236 Verses',
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
                  'Meccan',
                  '${_surahs.where((s) => s.type == 'Meccan').length}',
                  Icons.mosque_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Medinan',
                  '${_surahs.where((s) => s.type == 'Medinan').length}',
                  Icons.account_balance_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Favorites',
                  '${_surahs.where((s) => s.isFavorite).length}',
                  Icons.favorite_rounded,
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
              color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterSurahs,
          decoration: InputDecoration(
            hintText: 'Search surahs by name, number...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: RevolutionaryIslamicTheme.textSecondary,
            ),
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

  Widget _buildSurahsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        return _buildSurahCard(surah);
      },
    );
  }

  Widget _buildSurahCard(Surah surah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openSurah(surah),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Surah Number
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        RevolutionaryIslamicTheme.primaryEmerald,
                        RevolutionaryIslamicTheme.primaryEmerald.withValues(
                          alpha: 0.8,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      surah.number.toString(),
                      style: const TextStyle(
                        color: RevolutionaryIslamicTheme.neutralWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Surah Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              surah.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: RevolutionaryIslamicTheme.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            surah.arabicName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        surah.englishName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: RevolutionaryIslamicTheme.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: surah.type == 'Meccan'
                                  ? RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.1)
                                  : RevolutionaryIslamicTheme.secondaryNavy.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: surah.type == 'Meccan'
                                    ? RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.3)
                                    : RevolutionaryIslamicTheme.secondaryNavy.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              surah.type,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: surah.type == 'Meccan'
                                    ? RevolutionaryIslamicTheme.primaryEmerald
                                    : RevolutionaryIslamicTheme.secondaryNavy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${surah.verses} verses',
                            style: const TextStyle(
                              fontSize: 12,
                              color: RevolutionaryIslamicTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _toggleFavorite(surah),
                      icon: Icon(
                        surah.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: surah.isFavorite ? Colors.red : RevolutionaryIslamicTheme.textSecondary,
                        size: 20,
                      ),
                      tooltip: surah.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: RevolutionaryIslamicTheme.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSurah(Surah surah) {
    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: 'Opening ${surah.name}...',
      icon: Icons.menu_book_rounded,
    );
    // TODO: Navigate to surah reading screen
  }

  void _toggleFavorite(Surah surah) {
    setState(() {
      surah.isFavorite = !surah.isFavorite;
    });

    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: surah.isFavorite ? '${surah.name} added to favorites' : '${surah.name} removed from favorites',
      icon: surah.isFavorite ? Icons.favorite : Icons.favorite_border,
    );
  }
}

class Surah {
  final int number;
  final String name;
  final String arabicName;
  final String englishName;
  final int verses;
  final String type; // 'Meccan' or 'Medinan'
  bool isFavorite;

  Surah(
    this.number,
    this.name,
    this.arabicName,
    this.englishName,
    this.verses,
    this.type,
    this.isFavorite,
  );
}
