import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../../data/datasources/quran_api_service.dart';
import '../../../data/datasources/quran_vector_index.dart';
import '../../widgets/revolutionary_components.dart';
import 'surah_reader_screen.dart';

class QuranExplorerScreen extends ConsumerStatefulWidget {
  const QuranExplorerScreen({super.key});

  @override
  ConsumerState<QuranExplorerScreen> createState() => _QuranExplorerScreenState();
}

class _QuranExplorerScreenState extends ConsumerState<QuranExplorerScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  final TextEditingController _searchController = TextEditingController();
  List<QuranSurahInfo> _surahs = [];
  List<QuranSurahInfo> _filteredSurahs = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _vectorReady = false;
  List<QuranSearchMatch> _searchResults = [];
  final Map<int, String> _transliterationCache = {};
  final Set<int> _favoriteSurahs = {};
  Timer? _debounce;
  final QuranApiService _quranApi = QuranApiService();

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
    try {
      // Initialize vector index in background
      unawaited(_initVectorIndex());

      // Use the comprehensive static method for instant loading
      final surahs = QuranApiService.getAllSurahsMetadata();

      if (mounted) {
        setState(() {
          _surahs = surahs;
          _filteredSurahs = _surahs;
          _isLoading = false;
        });
        _fadeController.forward();
      }
    } catch (e) {
      // Fallback to vector system data if static method fails
      if (mounted) {
        try {
          final vectorSurahs = QuranVectorIndex.instance.getAllSurahs();
          setState(() {
            _surahs = vectorSurahs.isNotEmpty ? vectorSurahs : _getFallbackSurahs();
            _filteredSurahs = _surahs;
            _isLoading = false;
          });
          _fadeController.forward();
        } catch (vectorError) {
          // Ultimate fallback to hardcoded data
          setState(() {
            _surahs = _getFallbackSurahs();
            _filteredSurahs = _surahs;
            _isLoading = false;
          });
          _fadeController.forward();
        }
      }
    }
  }

  List<QuranSurahInfo> _getFallbackSurahs() {
    // Essential Surahs with proper Arabic names for fallback
    return [
      QuranSurahInfo(
          number: 1,
          name: 'الفاتحة',
          englishName: 'Al-Fatiha',
          englishNameTranslation: 'The Opening',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 2,
          name: 'البقرة',
          englishName: 'Al-Baqarah',
          englishNameTranslation: 'The Cow',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 3,
          name: 'آل عمران',
          englishName: 'Ali \'Imran',
          englishNameTranslation: 'Family of Imran',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 4,
          name: 'النساء',
          englishName: 'An-Nisa',
          englishNameTranslation: 'The Women',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 5,
          name: 'المائدة',
          englishName: 'Al-Ma\'idah',
          englishNameTranslation: 'The Table Spread',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 6,
          name: 'الأنعام',
          englishName: 'Al-An\'am',
          englishNameTranslation: 'The Cattle',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 7,
          name: 'الأعراف',
          englishName: 'Al-A\'raf',
          englishNameTranslation: 'The Heights',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 8,
          name: 'الأنفال',
          englishName: 'Al-Anfal',
          englishNameTranslation: 'The Spoils of War',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 9,
          name: 'التوبة',
          englishName: 'At-Tawbah',
          englishNameTranslation: 'The Repentance',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 10, name: 'يونس', englishName: 'Yunus', englishNameTranslation: 'Jonah', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 67,
          name: 'الملك',
          englishName: 'Al-Mulk',
          englishNameTranslation: 'The Sovereignty',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 112,
          name: 'الإخلاص',
          englishName: 'Al-Ikhlas',
          englishNameTranslation: 'The Sincerity',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 113,
          name: 'الفلق',
          englishName: 'Al-Falaq',
          englishNameTranslation: 'The Daybreak',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 114,
          name: 'الناس',
          englishName: 'An-Nas',
          englishNameTranslation: 'Mankind',
          revelationType: 'Meccan'),
    ];
  }

  void _filterSurahs(String query) {
    // Debounced search: if query not empty perform vector search for verses
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      if (query.isEmpty) {
        setState(() {
          _isSearching = false;
          _filteredSurahs = _surahs;
          _searchResults = [];
        });
        return;
      }

      setState(() {
        _isSearching = true;
      });

      // Fallback to basic filter while vector loads
      if (!_vectorReady) {
        setState(() {
          _filteredSurahs = _surahs.where((surah) {
            return surah.englishName.toLowerCase().contains(query.toLowerCase()) ||
                surah.name.contains(query) ||
                surah.englishNameTranslation.toLowerCase().contains(query.toLowerCase()) ||
                surah.number.toString().contains(query);
          }).toList();
        });
      }

      // Vector verse search
      if (_vectorReady) {
        final matches = await QuranVectorIndex.instance.search(query: query, limit: 15, minSimilarity: 0.55);
        if (!mounted) return;
        setState(() {
          _searchResults = matches;
        });
        // No bulk transliteration prefetch; each visible item will lazily request its own.
      }
    });
  }

  Future<void> _initVectorIndex() async {
    try {
      await QuranVectorIndex.instance.initialize();
      if (!mounted) return;
      setState(() {
        _vectorReady = QuranVectorIndex.instance.isReady;
      });
    } catch (_) {
      // silently ignore; API fallback will be used elsewhere
    }
  }

  Future<void> _maybeLoadTransliteration(int verseGlobalNumber) async {
    if (_transliterationCache.containsKey(verseGlobalNumber)) return;
    try {
      final verses = await _quranApi.getVerseWithTranslations(
        verseGlobalNumber,
        editions: [
          QuranApiService.popularEditions['transliteration']!,
        ],
      );
      if (verses.isNotEmpty) {
        setState(() {
          _transliterationCache[verseGlobalNumber] = verses.first.text;
        });
      }
    } catch (_) {
      // ignore errors for individual transliteration fetches
    }
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
          Expanded(
            child: _isSearching && _searchResults.isNotEmpty
                ? _buildVerseSearchResults()
                : _isSearching && _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? _buildNoResults()
                    : _buildSurahsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: RevolutionaryIslamicTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              _vectorReady
                  ? 'No verses matched "${_searchController.text}"'
                  : 'Vector index loading... basic filtering active',
              textAlign: TextAlign.center,
              style: const TextStyle(color: RevolutionaryIslamicTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final match = _searchResults[index];
        _maybeLoadTransliteration(match.number); // lazy trigger when built
        final translit = _transliterationCache[match.number];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: RevolutionaryIslamicTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openSurah(match.surah, initialVerse: match.numberInSurah),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${match.surah.englishName} ${match.numberInSurah}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: RevolutionaryIslamicTheme.primaryEmerald,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Open Surah',
                        onPressed: () => _openSurah(
                          match.surah,
                          initialVerse: match.numberInSurah,
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        color: RevolutionaryIslamicTheme.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    match.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: RevolutionaryIslamicTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (translit != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      translit,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: RevolutionaryIslamicTheme.textSecondary,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
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
                  '${_surahs.where((s) => s.revelationType == 'Meccan').length}',
                  Icons.mosque_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Medinan',
                  '${_surahs.where((s) => s.revelationType == 'Medinan').length}',
                  Icons.account_balance_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Favorites',
                  '${_favoriteSurahs.length}',
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
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterSurahs('');
                    },
                    icon: const Icon(Icons.clear_rounded, color: RevolutionaryIslamicTheme.textSecondary),
                  )
                : (_vectorReady
                    ? const Icon(Icons.memory_rounded, color: RevolutionaryIslamicTheme.primaryEmerald, size: 18)
                    : const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )),
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

  Widget _buildSurahCard(QuranSurahInfo surah) {
    final isFavorite = _favoriteSurahs.contains(surah.number);

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
                        RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.8),
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
                              surah.englishName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: RevolutionaryIslamicTheme.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            surah.name,
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
                        surah.englishNameTranslation,
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
                              color: surah.revelationType == 'Meccan'
                                  ? RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.1)
                                  : RevolutionaryIslamicTheme.secondaryNavy.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: surah.revelationType == 'Meccan'
                                    ? RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.3)
                                    : RevolutionaryIslamicTheme.secondaryNavy.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              surah.revelationType,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: surah.revelationType == 'Meccan'
                                    ? RevolutionaryIslamicTheme.primaryEmerald
                                    : RevolutionaryIslamicTheme.secondaryNavy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'View Verses',
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : RevolutionaryIslamicTheme.textSecondary,
                        size: 20,
                      ),
                      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
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

  void _openSurah(QuranSurahInfo surah, {int? initialVerse}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahReaderScreen(
          surahNumber: surah.number,
          surahEnglishName: surah.englishName,
          surahArabicName: surah.name,
          initialVerse: initialVerse,
        ),
      ),
    );
  }

  void _toggleFavorite(QuranSurahInfo surah) {
    setState(() {
      if (_favoriteSurahs.contains(surah.number)) {
        _favoriteSurahs.remove(surah.number);
      } else {
        _favoriteSurahs.add(surah.number);
      }
    });

    final isFavorite = _favoriteSurahs.contains(surah.number);
    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: isFavorite ? '${surah.englishName} added to favorites' : '${surah.englishName} removed from favorites',
      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
    );
  }
}
