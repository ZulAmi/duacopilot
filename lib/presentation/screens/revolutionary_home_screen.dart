import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/professional_islamic_theme.dart';
import '../../features/qibla/screens/qibla_compass_screen.dart';
import '../../features/tasbih/screens/digital_tasbih_screen.dart';
import '../widgets/revolutionary_components.dart';
import 'assistance/screen_assistance.dart';
import 'islamic/islamic_calendar_screen.dart';
import 'islamic/quran_explorer_screen.dart';
import 'islamic/revolutionary_prayer_times_screen.dart';
import 'premium_features/premium_features_hub.dart';
import 'professional_islamic_search_screen.dart';
import 'revolutionary_voice_companion_screen.dart';
import 'settings/settings_screen.dart';

class RevolutionaryHomeScreen extends ConsumerStatefulWidget {
  const RevolutionaryHomeScreen({super.key});

  @override
  ConsumerState<RevolutionaryHomeScreen> createState() => _RevolutionaryHomeScreenState();
}

class _RevolutionaryHomeScreenState extends ConsumerState<RevolutionaryHomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  bool _isSearching = false;
  bool _isVoiceListening = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: ProfessionalIslamicTheme.animationNormal,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: ProfessionalIslamicTheme.animationSlow,
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: ProfessionalIslamicTheme.animationSlow,
      vsync: this,
    );

    // Start animations with stagger
    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ProfessionalIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'DuaCopilot',
        showBackButton: false,
        showHamburger: true,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: _buildModernDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: ProfessionalIslamicTheme.islamicGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroWelcomeSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space8),
              _buildModernSearchSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space8),
              _buildDailyInsightsSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space8),
              _buildMainFeaturesSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space8),
              _buildIslamicToolsSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space8),
              _buildPremiumFeaturesSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingSearchButton(),
    );
  }

  Widget _buildModernDrawer() {
    return RevolutionaryComponents.modernDrawer(
      onHomePressed: () => Navigator.of(context).pop(),
      onSettingsPressed: () => _handleDrawerNavigation(_navigateToSettings),
      onHelpPressed: () => _handleDrawerNavigation(_navigateToHelp),
      menuItems: [
        DrawerMenuItem(
          icon: Icons.search_rounded,
          title: 'Smart Search',
          subtitle: 'AI-powered Islamic search',
          onTap: () => _handleDrawerNavigation(_navigateToSearch),
          badge: 'AI',
        ),
        DrawerMenuItem(
          icon: Icons.menu_book_rounded,
          title: 'Quran Explorer',
          subtitle: 'Read & study the Quran',
          onTap: () => _handleDrawerNavigation(_navigateToQuran),
        ),
        DrawerMenuItem(
          icon: Icons.access_time_rounded,
          title: 'Prayer Times',
          subtitle: 'Accurate prayer schedules',
          onTap: () => _handleDrawerNavigation(_navigateToPrayerTimes),
        ),
        DrawerMenuItem(
          icon: Icons.compass_calibration_rounded,
          title: 'Qibla Direction',
          subtitle: 'Find the direction to Mecca',
          onTap: () => _handleDrawerNavigation(_navigateToQibla),
        ),
        DrawerMenuItem(
          icon: Icons.calendar_today_rounded,
          title: 'Islamic Calendar',
          subtitle: 'Hijri dates & events',
          onTap: () => _handleDrawerNavigation(_navigateToCalendar),
        ),
        DrawerMenuItem(
          icon: Icons.favorite_rounded,
          title: 'Daily Duas',
          subtitle: 'Beautiful supplications',
          onTap: () => _handleDrawerNavigation(_navigateToDuas),
        ),
        DrawerMenuItem(
          icon: Icons.mic_rounded,
          title: 'Voice Assistant',
          subtitle: 'Ask questions with voice',
          onTap: () => _handleDrawerNavigation(_navigateToVoiceAssistant),
          badge: 'NEW',
        ),
        DrawerMenuItem(
          icon: Icons.workspace_premium_rounded,
          title: 'Premium Features',
          subtitle: 'Unlock all capabilities',
          onTap: () => _handleDrawerNavigation(_navigateToPremiumHub),
          badge: 'PRO',
        ),
      ],
    );
  }

  // Uniform drawer navigation handler
  void _handleDrawerNavigation(VoidCallback navigationMethod) {
    Navigator.of(context).pop(); // Close drawer first
    navigationMethod(); // Then navigate
  }

  Widget _buildHeroWelcomeSection() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
          decoration: BoxDecoration(
            gradient: ProfessionalIslamicTheme.islamicGradient,
            borderRadius: BorderRadius.circular(
              ProfessionalIslamicTheme.radius3Xl,
            ),
            boxShadow: ProfessionalIslamicTheme.shadowMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      ProfessionalIslamicTheme.space4,
                    ),
                    decoration: BoxDecoration(
                      color: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        ProfessionalIslamicTheme.radius2Xl,
                      ),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: ProfessionalIslamicTheme.textOnIslamic,
                      size: 32,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ProfessionalIslamicTheme.space3,
                      vertical: ProfessionalIslamicTheme.space2,
                    ),
                    decoration: BoxDecoration(
                      color: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(
                        ProfessionalIslamicTheme.radiusFull,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: ProfessionalIslamicTheme.textOnIslamic,
                          size: 16,
                        ),
                        const SizedBox(width: ProfessionalIslamicTheme.space1),
                        Text(
                          'AI Powered',
                          style: ProfessionalIslamicTheme.caption.copyWith(
                            color: ProfessionalIslamicTheme.textOnIslamic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              Text(
                'السلام عليكم',
                style: ProfessionalIslamicTheme.display2.copyWith(
                  color: ProfessionalIslamicTheme.textOnIslamic,
                  fontWeight: FontWeight.w900,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: ProfessionalIslamicTheme.space1),
              Text(
                'Assalamu Alaikum',
                style: ProfessionalIslamicTheme.body1.copyWith(
                  color: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: ProfessionalIslamicTheme.space2),
              Text(
                'Your intelligent Islamic companion for spiritual guidance, Quranic wisdom, and daily prayers.',
                style: ProfessionalIslamicTheme.body1.copyWith(
                  color: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToSearch,
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: const Text('Start Exploring'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProfessionalIslamicTheme.textOnIslamic,
                        foregroundColor: ProfessionalIslamicTheme.islamicGreen,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: ProfessionalIslamicTheme.space4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  IconButton(
                    onPressed: _toggleVoiceSearch,
                    icon: Icon(
                      _isVoiceListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: ProfessionalIslamicTheme.textOnIslamic,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.2),
                      padding: const EdgeInsets.all(
                        ProfessionalIslamicTheme.space3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchSection() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search & Discover',
              style: ProfessionalIslamicTheme.heading2.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            RevolutionaryComponents.modernSearchBar(
              controller: _searchController,
              onSubmitted: _handleSearch,
              onChanged: (value) => setState(() {}),
              isLoading: _isSearching,
              onVoiceSearch: _toggleVoiceSearch,
              isVoiceListening: _isVoiceListening,
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: ProfessionalIslamicTheme.space1,
              ),
              child: Row(
                children: [
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  _buildQuickSearchChip('Morning Duas', Icons.wb_sunny_rounded),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  _buildQuickSearchChip(
                    'Prayer Times',
                    Icons.access_time_rounded,
                  ),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  _buildQuickSearchChip(
                    'Quran Verses',
                    Icons.menu_book_rounded,
                  ),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  _buildQuickSearchChip('Hadith', Icons.auto_stories_rounded),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  _buildQuickSearchChip('Islamic Calendar', Icons.calendar_today_rounded),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  _buildQuickSearchChip('Qibla Direction', Icons.compass_calibration_rounded),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSearchChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _handleQuickSearch(label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ProfessionalIslamicTheme.space4,
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
            Icon(icon, size: 16, color: ProfessionalIslamicTheme.islamicGreen),
            const SizedBox(width: ProfessionalIslamicTheme.space2),
            Text(
              label,
              style: ProfessionalIslamicTheme.body2.copyWith(
                fontWeight: FontWeight.w500,
                color: ProfessionalIslamicTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyInsightsSection() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today\'s Islamic Insights',
                style: ProfessionalIslamicTheme.heading3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ProfessionalIslamicTheme.space2,
                  vertical: ProfessionalIslamicTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: ProfessionalIslamicTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ProfessionalIslamicTheme.radiusFull,
                  ),
                ),
                child: Text(
                  'Live',
                  style: ProfessionalIslamicTheme.caption.copyWith(
                    color: ProfessionalIslamicTheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),
          Row(
            children: [
              Expanded(
                child: RevolutionaryComponents.modernStatsCard(
                  value: '5',
                  label: 'Daily Prayers',
                  icon: Icons.access_time_rounded,
                  accentColor: ProfessionalIslamicTheme.islamicGreen,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space3),
              Expanded(
                child: RevolutionaryComponents.modernStatsCard(
                  value: '114',
                  label: 'Quran Suras',
                  icon: Icons.menu_book_rounded,
                  accentColor: ProfessionalIslamicTheme.deepNavy,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space3),
              Expanded(
                child: RevolutionaryComponents.modernStatsCard(
                  value: '6236',
                  label: 'Verses',
                  icon: Icons.auto_awesome_rounded,
                  accentColor: ProfessionalIslamicTheme.goldAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeaturesSection() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Core Features',
                style: ProfessionalIslamicTheme.heading3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton.icon(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.grid_view_rounded, size: 18),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  backgroundColor: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1),
                  foregroundColor: ProfessionalIslamicTheme.islamicGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced from space4 (16px) to 12px
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.95, // Increased from 0.85 to 0.95 for less vertical height
            mainAxisSpacing: 10, // Reduced from space3 (12px) to 10px
            crossAxisSpacing: 10, // Reduced from space3 (12px) to 10px
            children: [
              RevolutionaryComponents.modernFeatureCard(
                icon: Icons.search_rounded,
                title: 'Smart Search',
                description: 'AI-powered Islamic knowledge search with contextual understanding',
                onTap: _navigateToSearch,
                badge: 'AI',
                gradientColors: [
                  ProfessionalIslamicTheme.islamicGreen,
                  ProfessionalIslamicTheme.islamicGreenLight,
                ],
              ),
              RevolutionaryComponents.modernFeatureCard(
                icon: Icons.menu_book_rounded,
                title: 'Quran Explorer',
                description: 'Browse, search and study the Holy Quran with translations',
                onTap: _navigateToQuran,
                gradientColors: [
                  ProfessionalIslamicTheme.deepNavy,
                  ProfessionalIslamicTheme.islamicGreenLight,
                ],
              ),
              RevolutionaryComponents.modernFeatureCard(
                icon: Icons.favorite_rounded,
                title: 'Digital Tasbih',
                description: 'Beautiful collection of daily prayers and supplications',
                onTap: _navigateToDuas,
                gradientColors: [
                  ProfessionalIslamicTheme.goldAccent,
                  ProfessionalIslamicTheme.islamicGreenLight,
                ],
              ),
              RevolutionaryComponents.modernFeatureCard(
                icon: Icons.mic_rounded,
                title: 'Voice Assistant',
                description: 'Ask Islamic questions using voice in any language',
                onTap: _navigateToVoiceAssistant,
                badge: 'NEW',
                gradientColors: [
                  ProfessionalIslamicTheme.warning,
                  ProfessionalIslamicTheme.islamicGreenLight,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicToolsSection() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Islamic Tools',
            style: ProfessionalIslamicTheme.heading3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space4),
          _buildToolRow(
            Icons.access_time_rounded,
            'Prayer Times',
            'Accurate prayer times for your location',
            _navigateToPrayerTimes,
            ProfessionalIslamicTheme.islamicGreen,
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space3),
          _buildToolRow(
            Icons.compass_calibration_rounded,
            'Qibla Direction',
            'Find the exact direction to Kaaba',
            _navigateToQibla,
            ProfessionalIslamicTheme.deepNavy,
          ),
          const SizedBox(height: ProfessionalIslamicTheme.space3),
          _buildToolRow(
            Icons.calendar_today_rounded,
            'Islamic Calendar',
            'Hijri dates and Islamic events',
            _navigateToCalendar,
            ProfessionalIslamicTheme.goldAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildToolRow(
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
        decoration: BoxDecoration(
          color: ProfessionalIslamicTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(
            ProfessionalIslamicTheme.radius2Xl,
          ),
          border: Border.all(color: ProfessionalIslamicTheme.borderLight),
          boxShadow: ProfessionalIslamicTheme.shadowSoft,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ProfessionalIslamicTheme.space3),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ProfessionalIslamicTheme.radius2Xl,
                ),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: ProfessionalIslamicTheme.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ProfessionalIslamicTheme.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: ProfessionalIslamicTheme.space1),
                  Text(
                    description,
                    style: ProfessionalIslamicTheme.body2.copyWith(
                      color: ProfessionalIslamicTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: ProfessionalIslamicTheme.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeaturesSection() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
        decoration: BoxDecoration(
          gradient: ProfessionalIslamicTheme.goldAccentGradient,
          borderRadius: BorderRadius.circular(
            ProfessionalIslamicTheme.radius3Xl,
          ),
          boxShadow: ProfessionalIslamicTheme.shadowMedium,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    ProfessionalIslamicTheme.space3,
                  ),
                  decoration: BoxDecoration(
                    color: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      ProfessionalIslamicTheme.radius2Xl,
                    ),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: ProfessionalIslamicTheme.textOnIslamic,
                    size: 24,
                  ),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Premium Features',
                        style: ProfessionalIslamicTheme.heading3.copyWith(
                          color: ProfessionalIslamicTheme.textOnIslamic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: ProfessionalIslamicTheme.space1),
                      Text(
                        'Advanced Islamic learning tools & personalized content',
                        style: ProfessionalIslamicTheme.body2.copyWith(
                          color: ProfessionalIslamicTheme.textOnIslamic.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space4),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToPremiumHub,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProfessionalIslamicTheme.textOnIslamic,
                      foregroundColor: ProfessionalIslamicTheme.goldAccent,
                    ),
                    child: const Text('Explore Premium'),
                  ),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space3),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Learn More',
                    style: ProfessionalIslamicTheme.body2.copyWith(
                      color: ProfessionalIslamicTheme.textOnIslamic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingSearchButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToSearch,
      backgroundColor: ProfessionalIslamicTheme.islamicGreen,
      foregroundColor: ProfessionalIslamicTheme.textOnIslamic,
      icon: const Icon(Icons.auto_awesome_rounded),
      label: const Text('Ask AI'),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ProfessionalIslamicTheme.radiusFull,
        ),
      ),
    );
  }

  // Event Handlers
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      RevolutionaryComponents.showModernSnackBar(
        context: context,
        message: 'Content refreshed successfully',
        icon: Icons.check_circle_rounded,
      );
    }
  }

  void _handleSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isSearching = true);

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Searching for: $query',
          icon: Icons.search_rounded,
        );
        _navigateToSearch();
      }
    } catch (e) {
      if (mounted) {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Search failed. Please try again.',
          icon: Icons.error_rounded,
          backgroundColor: ProfessionalIslamicTheme.error,
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
      RevolutionaryComponents.showModernSnackBar(
        context: context,
        message: 'Listening... Speak now',
        icon: Icons.mic_rounded,
        backgroundColor: ProfessionalIslamicTheme.islamicGreen,
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _isVoiceListening = false);
        }
      });
    }
  }

  // Navigation Methods - Uniform Implementation
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RevolutionaryPrayerTimesScreen(),
      ),
    );
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
    // Launch Revolutionary AI Islamic Companion instead of basic conversational search
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RevolutionaryVoiceCompanionScreen(),
      ),
    );
  }

  void _navigateToPremiumHub() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PremiumFeaturesHub()));
  }

  void _navigateToSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  void _navigateToHelp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ScreenAssistance()));
  }
}
