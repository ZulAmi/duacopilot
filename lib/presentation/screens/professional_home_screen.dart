import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/professional_islamic_theme.dart';
import '../../features/qibla/screens/qibla_compass_screen.dart';
import '../../features/tasbih/screens/digital_tasbih_screen.dart';
import '../widgets/professional_components.dart';
import 'conversational_search_screen.dart';
import 'islamic/islamic_calendar_screen.dart';
import 'islamic/prayer_times_screen.dart';
import 'islamic/quran_explorer_screen.dart';
import 'premium_features/premium_features_hub.dart';
import 'professional_islamic_search_screen.dart';

class ProfessionalHomeScreen extends ConsumerStatefulWidget {
  const ProfessionalHomeScreen({super.key});

  @override
  ConsumerState<ProfessionalHomeScreen> createState() =>
      _ProfessionalHomeScreenState();
}

class _ProfessionalHomeScreenState extends ConsumerState<ProfessionalHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  bool _isSearching = false;
  bool _isVoiceListening = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfessionalIslamicTheme.backgroundPrimary,
      appBar: ProfessionalComponents.appBar(
        title: 'DuaCopilot',
        onMenuPressed: () => _showDrawer(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              _buildWelcomeSection(),

              const SizedBox(height: ProfessionalIslamicTheme.space12),

              // Search Bar
              _buildSearchSection(),

              const SizedBox(height: ProfessionalIslamicTheme.space12),

              // Quick Stats
              _buildQuickStats(),

              const SizedBox(height: ProfessionalIslamicTheme.space12),

              // Main Features
              _buildMainFeatures(),

              const SizedBox(height: ProfessionalIslamicTheme.space12),

              // Islamic Tools
              _buildIslamicTools(),

              const SizedBox(height: ProfessionalIslamicTheme.space10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ProfessionalIslamicTheme.islamicGreen,
                    borderRadius: BorderRadius.circular(
                      ProfessionalIslamicTheme.radiusLg,
                    ),
                    boxShadow: ProfessionalIslamicTheme.shadowMedium,
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    color: ProfessionalIslamicTheme.pureWhite,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamu Alaikum',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: ProfessionalIslamicTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your AI Islamic Companion',
                        style: TextStyle(
                          fontSize: 16,
                          color: ProfessionalIslamicTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            Container(
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
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: ProfessionalIslamicTheme.islamicGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ask me anything about Islam, get Quranic guidance, or find the perfect Dua',
                      style: TextStyle(
                        fontSize: 14,
                        color: ProfessionalIslamicTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search & Explore',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ProfessionalIslamicTheme.textPrimary,
              ),
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            ProfessionalComponents.searchBar(
              controller: _searchController,
              onSubmitted: _handleSearch,
              onChanged: (value) => setState(() {}),
              isLoading: _isSearching,
              onVoiceSearch: _toggleVoiceSearch,
              isVoiceListening: _isVoiceListening,
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space2),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickSearchChip('Prayer times'),
                _buildQuickSearchChip('Quran verse'),
                _buildQuickSearchChip('Morning Duas'),
                _buildQuickSearchChip('Hadith'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSearchChip(String label) {
    return InkWell(
      onTap: () => _handleQuickSearch(label),
      borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ProfessionalIslamicTheme.gray100,
          borderRadius: BorderRadius.circular(
            ProfessionalIslamicTheme.radiusSm,
          ),
          border: Border.all(color: ProfessionalIslamicTheme.borderLight),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ProfessionalIslamicTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Islamic Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ProfessionalIslamicTheme.textPrimary,
            ),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),
          Row(
            children: [
              Expanded(
                child: ProfessionalComponents.statsCard(
                  value: '5',
                  label: 'Daily Prayers',
                  icon: Icons.schedule_rounded,
                  accentColor: ProfessionalIslamicTheme.islamicGreen,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space2),
              Expanded(
                child: ProfessionalComponents.statsCard(
                  value: '114',
                  label: 'Quran Suras',
                  icon: Icons.menu_book_rounded,
                  accentColor: ProfessionalIslamicTheme.goldAccent,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space2),
              Expanded(
                child: ProfessionalComponents.statsCard(
                  value: '6236',
                  label: 'Verses',
                  icon: Icons.lightbulb_rounded,
                  accentColor: ProfessionalIslamicTheme.islamicGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeatures() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Main Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ProfessionalIslamicTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => _showDrawer(context),
                child: const Text(
                  'View All â†’',
                  style: TextStyle(
                    color: ProfessionalIslamicTheme.islamicGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.95,
            mainAxisSpacing: ProfessionalIslamicTheme.space2,
            crossAxisSpacing: ProfessionalIslamicTheme.space2,
            children: [
              ProfessionalComponents.featureCard(
                icon: Icons.search_rounded,
                title: 'Smart Search',
                description: 'AI-powered Islamic knowledge search with context',
                onTap: () => _navigateToSearch(),
              ),
              ProfessionalComponents.featureCard(
                icon: Icons.menu_book_rounded,
                title: 'Quran Explorer',
                description: 'Browse, search and study the Holy Quran',
                onTap: () => _navigateToQuran(),
              ),
              ProfessionalComponents.featureCard(
                icon: Icons.favorite_rounded,
                title: 'Digital Tasbih',
                description: 'Collection of daily prayers and supplications',
                onTap: () => _navigateToDuas(),
              ),
              ProfessionalComponents.featureCard(
                icon: Icons.mic_rounded,
                title: 'Voice Assistant',
                description: 'Ask questions using your voice in any language',
                onTap: () => _navigateToVoiceAssistant(),
                badge: 'AI',
              ),
            ],
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space12),

          // Additional Premium Features Row
          Text(
            'Premium Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ProfessionalIslamicTheme.textPrimary,
            ),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPremiumFeatureCard(
                  icon: Icons.school_rounded,
                  title: 'Islamic Courses',
                  description: 'Learn from scholars',
                  onTap: () => _navigateToIslamicCourses(),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space2),
                _buildPremiumFeatureCard(
                  icon: Icons.headphones_rounded,
                  title: 'Premium Audio',
                  description: 'Quran recitations',
                  onTap: () => _navigateToPremiumAudio(),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space2),
                _buildPremiumFeatureCard(
                  icon: Icons.psychology_rounded,
                  title: 'Smart Collections',
                  description: 'AI Dua suggestions',
                  onTap: () => _navigateToSmartCollections(),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space2),
                _buildPremiumFeatureCard(
                  icon: Icons.workspace_premium_rounded,
                  title: 'All Features',
                  description: 'Explore premium',
                  onTap: () => _showDrawer(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 140,
      child: ProfessionalComponents.featureCard(
        icon: icon,
        title: title,
        description: description,
        onTap: onTap,
        badge: 'PRO',
      ),
    );
  }

  Widget _buildIslamicTools() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Islamic Tools',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ProfessionalIslamicTheme.textPrimary,
            ),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),
          ProfessionalComponents.featureCard(
            icon: Icons.access_time_rounded,
            title: 'Prayer Times',
            description: 'Accurate prayer times for your location',
            onTap: () => _navigateToPrayerTimes(),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space2),
          ProfessionalComponents.featureCard(
            icon: Icons.compass_calibration_rounded,
            title: 'Qibla Direction',
            description: 'Find the direction to Kaaba from anywhere',
            onTap: () => _navigateToQibla(),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space2),
          ProfessionalComponents.featureCard(
            icon: Icons.calendar_today_rounded,
            title: 'Islamic Calendar',
            description: 'Hijri dates and Islamic events',
            onTap: () => _navigateToCalendar(),
          ),
        ],
      ),
    );
  }

  // Event Handlers
  void _handleSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isSearching = true);

    try {
      // TODO: Implement actual search logic
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        ProfessionalComponents.showSnackBar(
          context: context,
          message: 'Searching for: $query',
          icon: Icons.search_rounded,
        );
      }
    } catch (e) {
      if (mounted) {
        ProfessionalComponents.showSnackBar(
          context: context,
          message: 'Search failed. Please try again.',
          icon: Icons.error_rounded,
          backgroundColor: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _handleQuickSearch(String query) {
    _searchController.text = query;
    _handleSearch(query);
  }

  void _toggleVoiceSearch() {
    setState(() => _isVoiceListening = !_isVoiceListening);

    if (_isVoiceListening) {
      // TODO: Start voice recognition
      ProfessionalComponents.showSnackBar(
        context: context,
        message: 'Listening... Speak now',
        icon: Icons.mic_rounded,
        backgroundColor: ProfessionalIslamicTheme.islamicGreen,
      );

      // Simulate voice input
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _isVoiceListening = false);
        }
      });
    }
  }

  // Navigation Methods
  void _navigateToSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfessionalIslamicSearchScreen(),
      ),
    );
  }

  void _navigateToQuran() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QuranExplorerScreen()),
    );
  }

  void _navigateToDuas() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DigitalTasbihScreen()),
    );
  }

  void _navigateToPrayerTimes() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PrayerTimesScreen()));
  }

  void _navigateToQibla() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const QiblaCompassScreen()));
  }

  void _navigateToCalendar() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const IslamicCalendarScreen()),
    );
  }

  void _navigateToVoiceAssistant() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const ConversationalSearchScreen(enableVoiceSearch: true),
      ),
    );
  }

  void _navigateToIslamicCourses() {
    // Navigate to Islamic Courses screen when available
    ProfessionalComponents.showSnackBar(
      context: context,
      message: 'Islamic Courses - Premium feature coming soon...',
      icon: Icons.school_rounded,
    );
  }

  void _navigateToPremiumAudio() {
    // Navigate to Premium Audio screen when available
    ProfessionalComponents.showSnackBar(
      context: context,
      message: 'Premium Audio - High-quality Quran recitations coming soon...',
      icon: Icons.headphones_rounded,
    );
  }

  void _navigateToSmartCollections() {
    // Navigate to Smart Dua Collections when available
    ProfessionalComponents.showSnackBar(
      context: context,
      message: 'Smart Dua Collections - AI-powered suggestions coming soon...',
      icon: Icons.psychology_rounded,
    );
  }

  void _showDrawer(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PremiumFeaturesHub()));
  }
}
