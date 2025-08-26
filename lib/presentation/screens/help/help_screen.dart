import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/professional_islamic_theme.dart';

/// Professional Help & Support Screen for DuaCopilot
class ScreenAssistance extends ConsumerStatefulWidget {
  const ScreenAssistance({super.key});

  @override
  ConsumerState<ScreenAssistance> createState() => _ScreenAssistanceState();
}

class _ScreenAssistanceState extends ConsumerState<ScreenAssistance>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  int _selectedSection = 0;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfessionalIslamicTheme.backgroundSecondary,
      appBar: _buildAppBar(context),
      body: Row(
        children: [
          // Left Navigation Panel
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.backgroundPrimary,
              border: Border(
                right: BorderSide(
                  color: ProfessionalIslamicTheme.gray200,
                  width: 1,
                ),
              ),
            ),
            child: _buildNavigationPanel(context),
          ),
          // Main Content Area
          Expanded(child: _buildMainContent(context)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ProfessionalIslamicTheme.backgroundPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: ProfessionalIslamicTheme.textPrimary,
        ),
        onPressed: () => Navigator.of(context).pop(),
        style: IconButton.styleFrom(
          backgroundColor: ProfessionalIslamicTheme.gray100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ProfessionalIslamicTheme.radiusXl,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space4),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.islamicGreen,
              borderRadius: BorderRadius.circular(
                ProfessionalIslamicTheme.radiusLg,
              ),
            ),
            child: Icon(
              Icons.help_outline_rounded,
              color: ProfessionalIslamicTheme.textOnIslamic,
              size: 20,
            ),
          ),
          const SizedBox(width: ProfessionalIslamicTheme.space6),
          Text(
            'Help & Support',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: ProfessionalIslamicTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationPanel(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1),
                  ProfessionalIslamicTheme.islamicGreenLight.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: ProfessionalIslamicTheme.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    ProfessionalIslamicTheme.space4,
                  ),
                  decoration: BoxDecoration(
                    color: ProfessionalIslamicTheme.islamicGreen,
                    borderRadius: BorderRadius.circular(
                      ProfessionalIslamicTheme.radiusLg,
                    ),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: ProfessionalIslamicTheme.textOnIslamic,
                  ),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support Center',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ProfessionalIslamicTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Get help with DuaCopilot',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ProfessionalIslamicTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
              children: [
                _buildNavigationItem(
                  context,
                  0,
                  Icons.quiz_rounded,
                  'FAQ',
                  'Frequently Asked Questions',
                ),
                _buildNavigationItem(
                  context,
                  1,
                  Icons.menu_book_rounded,
                  'User Guide',
                  'Step-by-step tutorials',
                ),
                _buildNavigationItem(
                  context,
                  2,
                  Icons.contact_support_rounded,
                  'Contact Support',
                  'Get direct help',
                ),
                _buildNavigationItem(
                  context,
                  3,
                  Icons.feedback_rounded,
                  'Send Feedback',
                  'Help us improve',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    int index,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _selectedSection == index;

    return Container(
      margin: const EdgeInsets.only(bottom: ProfessionalIslamicTheme.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        color:
            isSelected
                ? ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1)
                : null,
        border:
            isSelected
                ? Border.all(
                  color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.3),
                  width: 1,
                )
                : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space2),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? ProfessionalIslamicTheme.islamicGreen
                    : ProfessionalIslamicTheme.gray200,
            borderRadius: BorderRadius.circular(
              ProfessionalIslamicTheme.radiusMd,
            ),
          ),
          child: Icon(
            icon,
            color:
                isSelected
                    ? ProfessionalIslamicTheme.textOnIslamic
                    : ProfessionalIslamicTheme.textSecondary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color:
                isSelected
                    ? ProfessionalIslamicTheme.islamicGreen
                    : ProfessionalIslamicTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ProfessionalIslamicTheme.textSecondary,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedSection = index;
          });
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        padding: const EdgeInsets.all(ProfessionalIslamicTheme.space8),
        child: _buildSectionContent(),
      ),
    );
  }

  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case 0:
        return _buildFAQSection();
      case 1:
        return _buildUserGuideSection();
      case 2:
        return _buildContactSupportSection();
      case 3:
        return _buildFeedbackSection();
      default:
        return _buildFAQSection();
    }
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'How do I perform voice search for Islamic queries?',
        'answer':
            'Tap the microphone icon in the search bar and ask your Islamic question in natural language. DuaCopilot uses advanced AI to understand your query and provide authentic Islamic answers.',
      },
      {
        'question': 'How accurate are the prayer times?',
        'answer':
            'Our prayer times are calculated using precise algorithms based on your location and selected calculation method. You can customize the calculation method in Settings > Islamic Preferences.',
      },
      {
        'question': 'Can I use DuaCopilot offline?',
        'answer':
            'Yes! DuaCopilot includes extensive offline content including Duas, Quran verses, and basic Islamic knowledge. Enable offline mode in Settings > Advanced.',
      },
      {
        'question': 'How do I change the Quran reciter?',
        'answer':
            'Go to Settings > Islamic Preferences > Quran Reciter and choose from our collection of renowned reciters including Sheikh Abdul Basit, Sheikh Mishary, and others.',
      },
      {
        'question': 'Is my data secure and private?',
        'answer':
            'Absolutely. DuaCopilot uses end-to-end encryption for all your personal data. Your Islamic journey and preferences are kept completely private and secure.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Frequently Asked Questions',
          'Find answers to common questions about DuaCopilot',
          Icons.quiz_rounded,
        ),
        const SizedBox(height: ProfessionalIslamicTheme.space8),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              return _buildFAQItem(
                faqs[index]['question']!,
                faqs[index]['answer']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: ProfessionalIslamicTheme.space6),
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        border: Border.all(color: ProfessionalIslamicTheme.gray200),
        boxShadow: ProfessionalIslamicTheme.shadowSoft,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ProfessionalIslamicTheme.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ProfessionalIslamicTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserGuideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'User Guide',
          'Step-by-step tutorials to help you master DuaCopilot',
          Icons.menu_book_rounded,
        ),
        const SizedBox(height: ProfessionalIslamicTheme.space8),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildGuideCard(
                  'Getting Started',
                  'Learn the basics of using DuaCopilot',
                  Icons.play_arrow_rounded,
                  [
                    'Set up your profile and Islamic preferences',
                    'Configure prayer times for your location',
                    'Explore voice search for Islamic queries',
                    'Set up prayer and dhikr reminders',
                  ],
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space6),
                _buildGuideCard(
                  'Prayer Features',
                  'Master prayer times and Qibla features',
                  Icons.access_time_rounded,
                  [
                    'Select your calculation method',
                    'Customize prayer notifications',
                    'Use the Qibla compass',
                    'Access prayer supplications',
                  ],
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space6),
                _buildGuideCard(
                  'Quran & Knowledge',
                  'Explore Quran reading and Islamic learning',
                  Icons.menu_book_rounded,
                  [
                    'Browse Quran with translations',
                    'Listen to various reciters',
                    'Search verses and topics',
                    'Access Islamic calendar',
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideCard(
    String title,
    String description,
    IconData icon,
    List<String> steps,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        border: Border.all(color: ProfessionalIslamicTheme.gray200),
        boxShadow: ProfessionalIslamicTheme.shadowSoft,
      ),
      child: Padding(
        padding: const EdgeInsets.all(ProfessionalIslamicTheme.space8),
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
                    color: ProfessionalIslamicTheme.islamicGreen.withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(
                      ProfessionalIslamicTheme.radiusLg,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: ProfessionalIslamicTheme.islamicGreen,
                  ),
                ),
                const SizedBox(width: ProfessionalIslamicTheme.space6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ProfessionalIslamicTheme.islamicGreen,
                        ),
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ProfessionalIslamicTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: ProfessionalIslamicTheme.space6),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: ProfessionalIslamicTheme.space4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: ProfessionalIslamicTheme.islamicGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: ProfessionalIslamicTheme.textOnIslamic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: ProfessionalIslamicTheme.space6),
                    Expanded(
                      child: Text(
                        step,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ProfessionalIslamicTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Contact Support',
          'Get direct help from our support team',
          Icons.contact_support_rounded,
        ),
        const SizedBox(height: ProfessionalIslamicTheme.space8),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildContactCard(
                  'Email Support',
                  'Get detailed help via email',
                  Icons.email_rounded,
                  'support@duacopilot.com',
                  'Usually responds within 24 hours',
                  () => _launchEmail(),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space6),
                _buildContactCard(
                  'Community Forum',
                  'Connect with other users',
                  Icons.forum_rounded,
                  'community.duacopilot.com',
                  'Get help from fellow Muslims',
                  () => _launchCommunity(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(
    String title,
    String description,
    IconData icon,
    String contact,
    String availability,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        border: Border.all(color: ProfessionalIslamicTheme.gray200),
        boxShadow: ProfessionalIslamicTheme.shadowSoft,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
                decoration: BoxDecoration(
                  color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ProfessionalIslamicTheme.radiusLg,
                  ),
                ),
                child: Icon(
                  icon,
                  color: ProfessionalIslamicTheme.islamicGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ProfessionalIslamicTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: ProfessionalIslamicTheme.space2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ProfessionalIslamicTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: ProfessionalIslamicTheme.space2),
                    Text(
                      contact,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ProfessionalIslamicTheme.islamicGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      availability,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ProfessionalIslamicTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: ProfessionalIslamicTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Send Feedback',
          'Help us improve DuaCopilot with your suggestions',
          Icons.feedback_rounded,
        ),
        const SizedBox(height: ProfessionalIslamicTheme.space8),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildFeedbackOption(
                  'Feature Request',
                  'Suggest new Islamic features or improvements',
                  Icons.add_circle_outline_rounded,
                  () => _sendFeatureRequest(),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space6),
                _buildFeedbackOption(
                  'Report Bug',
                  'Let us know about any issues you encountered',
                  Icons.bug_report_outlined,
                  () => _reportBug(),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space6),
                _buildFeedbackOption(
                  'Islamic Content',
                  'Suggest corrections or additions to Islamic content',
                  Icons.mosque_rounded,
                  () => _suggestIslamicContent(),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space6),
                _buildFeedbackOption(
                  'General Feedback',
                  'Share your overall experience and suggestions',
                  Icons.star_outline_rounded,
                  () => _sendGeneralFeedback(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackOption(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: ProfessionalIslamicTheme.backgroundPrimary,
        border: Border.all(color: ProfessionalIslamicTheme.gray200),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        boxShadow: ProfessionalIslamicTheme.shadowSoft,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
          child: Row(
            children: [
              Icon(
                icon,
                color: ProfessionalIslamicTheme.islamicGreen,
                size: 24,
              ),
              const SizedBox(width: ProfessionalIslamicTheme.space6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ProfessionalIslamicTheme.textPrimary,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ProfessionalIslamicTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: ProfessionalIslamicTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(ProfessionalIslamicTheme.space8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ProfessionalIslamicTheme.islamicGreen.withOpacity(0.1),
            ProfessionalIslamicTheme.goldAccent.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ProfessionalIslamicTheme.radiusLg),
        border: Border.all(
          color: ProfessionalIslamicTheme.islamicGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ProfessionalIslamicTheme.space6),
            decoration: BoxDecoration(
              color: ProfessionalIslamicTheme.islamicGreen,
              borderRadius: BorderRadius.circular(
                ProfessionalIslamicTheme.radiusLg,
              ),
            ),
            child: Icon(
              icon,
              color: ProfessionalIslamicTheme.textOnIslamic,
              size: 28,
            ),
          ),
          const SizedBox(width: ProfessionalIslamicTheme.space6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ProfessionalIslamicTheme.islamicGreen,
                  ),
                ),
                const SizedBox(height: ProfessionalIslamicTheme.space2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ProfessionalIslamicTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@duacopilot.com',
      queryParameters: {'subject': 'DuaCopilot Support Request'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchCommunity() async {
    final Uri uri = Uri.parse('https://community.duacopilot.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendFeatureRequest() {
    _launchEmail();
  }

  void _reportBug() {
    _launchEmail();
  }

  void _suggestIslamicContent() {
    _launchEmail();
  }

  void _sendGeneralFeedback() {
    _launchEmail();
  }
}
