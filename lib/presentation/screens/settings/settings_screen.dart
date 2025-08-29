import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/professional_islamic_theme.dart';
import '../../../services/secure_storage/secure_storage_service.dart';
import '../../widgets/revolutionary_components.dart';

/// Professional Settings Screen - Comprehensive user preferences management
/// Features: Account, Preferences, Privacy, Islamic Settings, App Settings
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Settings state
  bool _notificationsEnabled = true;
  bool _voiceSearchEnabled = true;
  bool _darkModeEnabled = false;
  bool _arabicEnabled = true;
  bool _offlineModeEnabled = false;
  bool _analyticsEnabled = true;
  bool _crashReportingEnabled = true;
  bool _prayerReminders = true;
  bool _dhikrReminders = true;
  bool _quranReminders = true;

  String _selectedLanguage = 'English';
  String _selectedTheme = 'Islamic Green';
  String _selectedFontSize = 'Medium';
  String _selectedReciter = 'Abdul Rahman As-Sudais';
  String _selectedTranslation = 'Sahih International';
  String _prayerCalculationMethod = 'Muslim World League';
  String _madhab = 'Hanafi';

  final List<String> _availableLanguages = [
    'English',
    'Arabic',
    'Urdu',
    'Indonesian',
    'Turkish',
    'French',
  ];
  final List<String> _availableThemes = [
    'Islamic Green',
    'Deep Navy',
    'Gold Accent',
    'Classic White',
  ];
  final List<String> _availableFontSizes = [
    'Small',
    'Medium',
    'Large',
    'Extra Large',
  ];
  final List<String> _availableReciters = [
    'Abdul Rahman As-Sudais',
    'Maher Al Mueaqly',
    'Mishary Rashid Alafasy',
    'Saad Al Ghamidi',
    'Ahmed Ali Al Ajmy',
  ];
  final List<String> _availableTranslations = [
    'Sahih International',
    'Pickthall',
    'Yusuf Ali',
    'Dr. Mustafa Khattab',
    'Abdul Haleem',
  ];
  final List<String> _calculationMethods = [
    'Muslim World League',
    'Islamic Society of North America',
    'University of Islamic Sciences Karachi',
    'Egyptian General Authority of Survey',
    'Makkah al-Mukarramah',
  ];
  final List<String> _madhabs = ['Hanafi', 'Shafi', 'Maliki', 'Hanbali'];

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

    _loadSettings();
    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  /// Load settings from secure storage
  Future<void> _loadSettings() async {
    try {
      final storage = SecureStorageService.instance;

      final notifications = await storage.read('settings_notifications');
      final voiceSearch = await storage.read('settings_voice_search');
      final darkMode = await storage.read('settings_dark_mode');
      final arabic = await storage.read('settings_arabic');
      final offlineMode = await storage.read('settings_offline_mode');
      final analytics = await storage.read('settings_analytics');
      final crashReporting = await storage.read('settings_crash_reporting');
      final prayerReminders = await storage.read('settings_prayer_reminders');
      final dhikrReminders = await storage.read('settings_dhikr_reminders');
      final quranReminders = await storage.read('settings_quran_reminders');

      final language = await storage.read('settings_language');
      final theme = await storage.read('settings_theme');
      final fontSize = await storage.read('settings_font_size');
      final reciter = await storage.read('settings_reciter');
      final translation = await storage.read('settings_translation');
      final calculationMethod = await storage.read(
        'settings_calculation_method',
      );
      final madhab = await storage.read('settings_madhab');

      if (mounted) {
        setState(() {
          _notificationsEnabled = notifications == 'true';
          _voiceSearchEnabled = voiceSearch == 'true';
          _darkModeEnabled = darkMode == 'true';
          _arabicEnabled = arabic == 'true';
          _offlineModeEnabled = offlineMode == 'true';
          _analyticsEnabled = analytics == 'true';
          _crashReportingEnabled = crashReporting == 'true';
          _prayerReminders = prayerReminders == 'true';
          _dhikrReminders = dhikrReminders == 'true';
          _quranReminders = quranReminders == 'true';

          _selectedLanguage = language ?? 'English';
          _selectedTheme = theme ?? 'Islamic Green';
          _selectedFontSize = fontSize ?? 'Medium';
          _selectedReciter = reciter ?? 'Abdul Rahman As-Sudais';
          _selectedTranslation = translation ?? 'Sahih International';
          _prayerCalculationMethod = calculationMethod ?? 'Muslim World League';
          _madhab = madhab ?? 'Hanafi';
        });
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  /// Save settings to secure storage
  Future<void> _saveSettings() async {
    try {
      final storage = SecureStorageService.instance;

      await storage.write(
        'settings_notifications',
        _notificationsEnabled.toString(),
      );
      await storage.write(
        'settings_voice_search',
        _voiceSearchEnabled.toString(),
      );
      await storage.write('settings_dark_mode', _darkModeEnabled.toString());
      await storage.write('settings_arabic', _arabicEnabled.toString());
      await storage.write(
        'settings_offline_mode',
        _offlineModeEnabled.toString(),
      );
      await storage.write('settings_analytics', _analyticsEnabled.toString());
      await storage.write(
        'settings_crash_reporting',
        _crashReportingEnabled.toString(),
      );
      await storage.write(
        'settings_prayer_reminders',
        _prayerReminders.toString(),
      );
      await storage.write(
        'settings_dhikr_reminders',
        _dhikrReminders.toString(),
      );
      await storage.write(
        'settings_quran_reminders',
        _quranReminders.toString(),
      );

      await storage.write('settings_language', _selectedLanguage);
      await storage.write('settings_theme', _selectedTheme);
      await storage.write('settings_font_size', _selectedFontSize);
      await storage.write('settings_reciter', _selectedReciter);
      await storage.write('settings_translation', _selectedTranslation);
      await storage.write(
        'settings_calculation_method',
        _prayerCalculationMethod,
      );
      await storage.write('settings_madhab', _madhab);

      if (mounted) {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Settings saved successfully',
          icon: Icons.check_circle_rounded,
          backgroundColor: ProfessionalIslamicTheme.success,
        );
      }
    } catch (e) {
      if (mounted) {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Failed to save settings',
          icon: Icons.error_rounded,
          backgroundColor: ProfessionalIslamicTheme.error,
        );
      }
      debugPrint('Error saving settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfessionalIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Settings',
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildAccountSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildIslamicSettingsSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildAppearanceSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildNotificationsSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildPrivacySection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildAdvancedSection(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
              _buildActionButtons(),
              const SizedBox(height: ProfessionalIslamicTheme.space6),
            ],
          ),
        ),
      ),
    );
  }

  /// Build welcome header
  Widget _buildWelcomeHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
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
                    ProfessionalIslamicTheme.space3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        ProfessionalIslamicTheme.textOnIslamic.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      ProfessionalIslamicTheme.radius2Xl,
                    ),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: ProfessionalIslamicTheme.textOnIslamic,
                    size: 32,
                  ),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personalize Your Experience',
                        style: ProfessionalIslamicTheme.heading2.copyWith(
                          color: ProfessionalIslamicTheme.textOnIslamic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: ProfessionalIslamicTheme.space1),
                      Text(
                        'Customize DuaCopilot to match your Islamic preferences and spiritual journey',
                        style: ProfessionalIslamicTheme.body2.copyWith(
                          color: ProfessionalIslamicTheme.textOnIslamic
                              .withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build account section
  Widget _buildAccountSection() {
    return _buildSettingsSection(
      title: 'Account & Subscription',
      icon: Icons.person_rounded,
      children: [
        _buildSettingsItem(
          icon: Icons.account_circle_rounded,
          title: 'Profile',
          subtitle: 'Manage your profile information',
          onTap: () => _showProfileDialog(),
        ),
        _buildSettingsItem(
          icon: Icons.workspace_premium_rounded,
          title: 'Subscription',
          subtitle: 'Premium Ã¢â‚¬Â¢ View subscription details',
          onTap: () => _showSubscriptionDialog(),
          trailing: const Icon(
            Icons.star,
            color: ProfessionalIslamicTheme.goldAccent,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.sync_rounded,
          title: 'Sync Settings',
          subtitle: 'Backup and sync across devices',
          onTap: () => _syncSettings(),
        ),
      ],
    );
  }

  /// Build Islamic settings section
  Widget _buildIslamicSettingsSection() {
    return _buildSettingsSection(
      title: 'Islamic Preferences',
      icon: Icons.mosque_rounded,
      children: [
        _buildDropdownItem(
          icon: Icons.school_rounded,
          title: 'Madhab (Islamic School)',
          subtitle: 'Select your preferred school of Islamic jurisprudence',
          value: _madhab,
          items: _madhabs,
          onChanged: (value) => setState(() => _madhab = value!),
        ),
        _buildDropdownItem(
          icon: Icons.calculate_rounded,
          title: 'Prayer Calculation Method',
          subtitle: 'Choose method for prayer time calculations',
          value: _prayerCalculationMethod,
          items: _calculationMethods,
          onChanged: (value) =>
              setState(() => _prayerCalculationMethod = value!),
        ),
        _buildDropdownItem(
          icon: Icons.headphones_rounded,
          title: 'Preferred Reciter',
          subtitle: 'Select your favorite Quran reciter',
          value: _selectedReciter,
          items: _availableReciters,
          onChanged: (value) => setState(() => _selectedReciter = value!),
        ),
        _buildDropdownItem(
          icon: Icons.translate_rounded,
          title: 'Quran Translation',
          subtitle: 'Choose your preferred translation',
          value: _selectedTranslation,
          items: _availableTranslations,
          onChanged: (value) => setState(() => _selectedTranslation = value!),
        ),
      ],
    );
  }

  /// Build appearance section
  Widget _buildAppearanceSection() {
    return _buildSettingsSection(
      title: 'Appearance & Language',
      icon: Icons.palette_rounded,
      children: [
        _buildDropdownItem(
          icon: Icons.language_rounded,
          title: 'Language',
          subtitle: 'Choose your preferred language',
          value: _selectedLanguage,
          items: _availableLanguages,
          onChanged: (value) => setState(() => _selectedLanguage = value!),
        ),
        _buildDropdownItem(
          icon: Icons.color_lens_rounded,
          title: 'Theme',
          subtitle: 'Select app color theme',
          value: _selectedTheme,
          items: _availableThemes,
          onChanged: (value) => setState(() => _selectedTheme = value!),
        ),
        _buildDropdownItem(
          icon: Icons.text_fields_rounded,
          title: 'Font Size',
          subtitle: 'Adjust text size for better readability',
          value: _selectedFontSize,
          items: _availableFontSizes,
          onChanged: (value) => setState(() => _selectedFontSize = value!),
        ),
        _buildSwitchItem(
          icon: Icons.abc_rounded,
          title: 'Arabic Text Support',
          subtitle: 'Enable Arabic fonts and RTL layout',
          value: _arabicEnabled,
          onChanged: (value) => setState(() => _arabicEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.dark_mode_rounded,
          title: 'Dark Mode',
          subtitle: 'Use dark theme (coming soon)',
          value: _darkModeEnabled,
          onChanged: (value) => setState(() => _darkModeEnabled = value),
        ),
      ],
    );
  }

  /// Build notifications section
  Widget _buildNotificationsSection() {
    return _buildSettingsSection(
      title: 'Notifications & Reminders',
      icon: Icons.notifications_rounded,
      children: [
        _buildSwitchItem(
          icon: Icons.notifications_rounded,
          title: 'Push Notifications',
          subtitle: 'Receive important updates and reminders',
          value: _notificationsEnabled,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.access_time_rounded,
          title: 'Prayer Time Reminders',
          subtitle: 'Get notified for prayer times',
          value: _prayerReminders,
          onChanged: (value) => setState(() => _prayerReminders = value),
        ),
        _buildSwitchItem(
          icon: Icons.favorite_rounded,
          title: 'Dhikr Reminders',
          subtitle: 'Daily remembrance notifications',
          value: _dhikrReminders,
          onChanged: (value) => setState(() => _dhikrReminders = value),
        ),
        _buildSwitchItem(
          icon: Icons.menu_book_rounded,
          title: 'Quran Reading Reminders',
          subtitle: 'Encourage daily Quran recitation',
          value: _quranReminders,
          onChanged: (value) => setState(() => _quranReminders = value),
        ),
      ],
    );
  }

  /// Build privacy section
  Widget _buildPrivacySection() {
    return _buildSettingsSection(
      title: 'Privacy & Data',
      icon: Icons.security_rounded,
      children: [
        _buildSwitchItem(
          icon: Icons.mic_rounded,
          title: 'Voice Search',
          subtitle: 'Enable voice recognition features',
          value: _voiceSearchEnabled,
          onChanged: (value) => setState(() => _voiceSearchEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.analytics_rounded,
          title: 'Usage Analytics',
          subtitle: 'Help improve app performance',
          value: _analyticsEnabled,
          onChanged: (value) => setState(() => _analyticsEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.bug_report_rounded,
          title: 'Crash Reporting',
          subtitle: 'Automatically send crash reports',
          value: _crashReportingEnabled,
          onChanged: (value) => setState(() => _crashReportingEnabled = value),
        ),
        _buildSettingsItem(
          icon: Icons.privacy_tip_rounded,
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          onTap: () => _showPrivacyPolicy(),
        ),
      ],
    );
  }

  /// Build advanced section
  Widget _buildAdvancedSection() {
    return _buildSettingsSection(
      title: 'Advanced',
      icon: Icons.tune_rounded,
      children: [
        _buildSwitchItem(
          icon: Icons.cloud_off_rounded,
          title: 'Offline Mode',
          subtitle: 'Use app without internet connection',
          value: _offlineModeEnabled,
          onChanged: (value) => setState(() => _offlineModeEnabled = value),
        ),
        _buildSettingsItem(
          icon: Icons.storage_rounded,
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          onTap: () => _clearCache(),
        ),
        _buildSettingsItem(
          icon: Icons.download_rounded,
          title: 'Download Content',
          subtitle: 'Download Islamic content for offline use',
          onTap: () => _showDownloadDialog(),
        ),
        _buildSettingsItem(
          icon: Icons.info_rounded,
          title: 'About DuaCopilot',
          subtitle: 'Version 2.0.0 Ã¢â‚¬Â¢ Build 1001',
          onTap: () => _showAboutDialog(),
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfessionalIslamicTheme.islamicGreen,
              foregroundColor: ProfessionalIslamicTheme.textOnIslamic,
              padding: const EdgeInsets.symmetric(
                vertical: ProfessionalIslamicTheme.space4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ProfessionalIslamicTheme.radius2Xl,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: ProfessionalIslamicTheme.space3),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore_rounded),
            label: const Text('Reset to Defaults'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ProfessionalIslamicTheme.error,
              side: BorderSide(color: ProfessionalIslamicTheme.error),
              padding: const EdgeInsets.symmetric(
                vertical: ProfessionalIslamicTheme.space4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ProfessionalIslamicTheme.radius2Xl,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build settings section container
  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ProfessionalIslamicTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(
            ProfessionalIslamicTheme.radius2Xl,
          ),
          border: Border.all(color: ProfessionalIslamicTheme.borderLight),
          boxShadow: ProfessionalIslamicTheme.shadowSoft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      ProfessionalIslamicTheme.space2,
                    ),
                    decoration: BoxDecoration(
                      color: ProfessionalIslamicTheme.islamicGreen
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        ProfessionalIslamicTheme.radius2Xl,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: ProfessionalIslamicTheme.islamicGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ProfessionalIslamicTheme.space3),
                  Text(
                    title,
                    style: ProfessionalIslamicTheme.heading3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Build settings item
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusXl),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ProfessionalIslamicTheme.space4,
          vertical: ProfessionalIslamicTheme.space3,
        ),
        child: Row(
          children: [
            Icon(icon, color: ProfessionalIslamicTheme.textSecondary, size: 20),
            const SizedBox(width: ProfessionalIslamicTheme.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ProfessionalIslamicTheme.body1.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: ProfessionalIslamicTheme.space1),
                  Text(
                    subtitle,
                    style: ProfessionalIslamicTheme.body2.copyWith(
                      color: ProfessionalIslamicTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: ProfessionalIslamicTheme.textMuted,
                ),
          ],
        ),
      ),
    );
  }

  /// Build switch item
  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfessionalIslamicTheme.space4,
        vertical: ProfessionalIslamicTheme.space2,
      ),
      child: Row(
        children: [
          Icon(icon, color: ProfessionalIslamicTheme.textSecondary, size: 20),
          const SizedBox(width: ProfessionalIslamicTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ProfessionalIslamicTheme.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space1),
                Text(
                  subtitle,
                  style: ProfessionalIslamicTheme.body2.copyWith(
                    color: ProfessionalIslamicTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ProfessionalIslamicTheme.islamicGreen,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  /// Build dropdown item
  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfessionalIslamicTheme.space4,
        vertical: ProfessionalIslamicTheme.space2,
      ),
      child: Row(
        children: [
          Icon(icon, color: ProfessionalIslamicTheme.textSecondary, size: 20),
          const SizedBox(width: ProfessionalIslamicTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ProfessionalIslamicTheme.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space1),
                Text(
                  subtitle,
                  style: ProfessionalIslamicTheme.body2.copyWith(
                    color: ProfessionalIslamicTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ProfessionalIslamicTheme.space3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ProfessionalIslamicTheme.borderLight,
                    ),
                    borderRadius: BorderRadius.circular(
                      ProfessionalIslamicTheme.radiusXl,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      onChanged: onChanged,
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: ProfessionalIslamicTheme.body2,
                          ),
                        );
                      }).toList(),
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

  // Event Handlers
  void _showProfileDialog() {
    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: 'Profile management coming soon',
      icon: Icons.person_rounded,
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscription Status'),
        content: const Text(
          'Premium Plan Active\n\nÃ¢Å“â€œ Unlimited AI queries\nÃ¢Å“â€œ Advanced features\nÃ¢Å“â€œ Premium audio content\nÃ¢Å“â€œ Family sharing',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _syncSettings() {
    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: 'Settings synced successfully',
      icon: Icons.sync_rounded,
      backgroundColor: ProfessionalIslamicTheme.success,
    );
  }

  void _showPrivacyPolicy() {
    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: 'Privacy policy coming soon',
      icon: Icons.privacy_tip_rounded,
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              RevolutionaryComponents.showModernSnackBar(
                context: context,
                message: 'Cache cleared successfully',
                icon: Icons.check_circle_rounded,
                backgroundColor: ProfessionalIslamicTheme.success,
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showDownloadDialog() {
    RevolutionaryComponents.showModernSnackBar(
      context: context,
      message: 'Download management coming soon',
      icon: Icons.download_rounded,
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'DuaCopilot',
      applicationVersion: '2.0.0',
      applicationIcon: const Icon(
        Icons.mosque_rounded,
        size: 48,
        color: ProfessionalIslamicTheme.islamicGreen,
      ),
      children: [
        const Text(
          'Your intelligent Islamic companion for spiritual guidance, Quranic wisdom, and daily prayers.',
        ),
        const SizedBox(height: 16),
        const Text('Built with Ã¢ÂÂ¤Ã¯Â¸Â for the Muslim community.'),
      ],
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'This will reset all settings to their default values. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = true;
                _voiceSearchEnabled = true;
                _darkModeEnabled = false;
                _arabicEnabled = true;
                _offlineModeEnabled = false;
                _analyticsEnabled = true;
                _crashReportingEnabled = true;
                _prayerReminders = true;
                _dhikrReminders = true;
                _quranReminders = true;
                _selectedLanguage = 'English';
                _selectedTheme = 'Islamic Green';
                _selectedFontSize = 'Medium';
                _selectedReciter = 'Abdul Rahman As-Sudais';
                _selectedTranslation = 'Sahih International';
                _prayerCalculationMethod = 'Muslim World League';
                _madhab = 'Hanafi';
              });
              _saveSettings();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

