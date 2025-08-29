import 'package:flutter/material.dart';

import '../../../core/feedback_system_integration.dart';
import '../../../presentation/widgets/analytics/usage_analytics_widgets.dart';
import '../../../presentation/widgets/feedback/contextual_feedback_forms.dart';
import '../../../presentation/widgets/feedback/dua_rating_widgets.dart';
import '../../../presentation/widgets/feedback/scholar_feedback_system.dart';
import '../../../services/ab_testing_framework.dart';

/// Example screen demonstrating the comprehensive feedback system
class FeedbackSystemDemoScreen extends StatefulWidget {
  const FeedbackSystemDemoScreen({super.key});

  @override
  State<FeedbackSystemDemoScreen> createState() => _FeedbackSystemDemoScreenState();
}

class _FeedbackSystemDemoScreenState extends State<FeedbackSystemDemoScreen> with FeedbackMixin {
  final String _selectedContentId = 'demo_dua_001';
  bool _showRatingWidget = false;
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();

    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      feedbackService.trackUsageAnalytics(
        action: 'screen_view',
        contentId: 'feedback_demo_screen',
        contentType: 'demo',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ABThemeProvider(
      abTesting: abTesting,
      child: UsageAnalyticsWidget(
        contentId: 'feedback_demo_screen',
        contentType: 'demo_screen',
        feedbackService: feedbackService,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Comprehensive Feedback System'),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                _buildHeaderCard(),

                const SizedBox(height: 16),

                // Du'a Rating Section
                _buildDuaRatingSection(),

                const SizedBox(height: 16),

                // Contextual Feedback Section
                _buildContextualFeedbackSection(),

                const SizedBox(height: 16),

                // Analytics Tracking Section
                _buildAnalyticsSection(),

                const SizedBox(height: 16),

                // A/B Testing Section
                _buildABTestingSection(),

                const SizedBox(height: 16),

                // Scholar Verification Section
                _buildScholarVerificationSection(),

                const SizedBox(height: 16),

                // Privacy & Data Section
                _buildPrivacySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withValues(alpha: 0.1),
              theme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.psychology, size: 48, color: theme.primaryColor),
            const SizedBox(height: 12),
            Text(
              'Comprehensive Feedback System',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Experience advanced feedback collection, analytics tracking, A/B testing, and scholar verification systems.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaRatingSection() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Du\'a Relevance Rating',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sample Du'a content
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ø¢ØªÙÙ†ÙŽØ§ ÙÙÙŠ Ø§Ù„Ø¯ÙÙ‘Ù†Ù’ÙŠÙŽØ§ Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙÙÙŠ Ø§Ù„Ù’Ø¢Ø®ÙØ±ÙŽØ©Ù Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙ‚ÙÙ†ÙŽØ§ Ø¹ÙŽØ°ÙŽØ§Ø¨ÙŽ Ø§Ù„Ù†ÙŽÙ‘Ø§Ø±Ù\n\n'
                'Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            if (!_showRatingWidget) ...[
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showRatingWidget = true;
                    });
                    feedbackService.trackUsageAnalytics(
                      action: 'rating_widget_opened',
                      contentId: _selectedContentId,
                      contentType: 'dua',
                    );
                  },
                  icon: const Icon(Icons.star_border),
                  label: const Text('Rate This Du\'a'),
                ),
              ),
            ] else ...[
              DuaRelevanceRatingWidget(
                initialRating: _currentRating,
                duaId: _selectedContentId,
                queryId: 'demo_query_001',
                style: getVariant('rating_widget_type', 'modern'),
                onRatingUpdate: (rating) async {
                  setState(() {
                    _currentRating = rating;
                  });

                  // Submit rating
                  await rateDua(_selectedContentId, 'demo_query_001', rating);

                  // Track A/B test conversion
                  if (rating >= 4.0) {
                    await abTesting.trackConversion(
                      experimentName: 'rating_widget_type',
                      conversionType: 'high_rating',
                      value: rating,
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContextualFeedbackSection() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.feedback, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Contextual Feedback',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Feedback Widget
            QuickFeedbackWidget(
              contentId: _selectedContentId,
              contentType: 'dua',
              onSubmit: (data) async {
                await feedbackService.submitContextualFeedback(
                  contentId: _selectedContentId,
                  contentType: 'dua',
                  feedbackData: data,
                  tags: ['quick_feedback'],
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quick feedback submitted!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 12),

            Center(
              child: ABFeedbackButton(
                abTesting: abTesting,
                text: 'Detailed Feedback',
                onPressed: () {
                  _showDetailedFeedbackForm();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Usage Analytics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAnalyticsButton('Track Reading', Icons.book, () async {
                  await trackReading(
                    _selectedContentId,
                    const Duration(minutes: 2),
                  );
                  _showSnackbar('Reading time tracked!');
                }),
                _buildAnalyticsButton(
                  'Track Audio',
                  Icons.audio_file,
                  () async {
                    await trackAudio(
                      _selectedContentId,
                      const Duration(minutes: 1, seconds: 30),
                    );
                    _showSnackbar('Audio playback tracked!');
                  },
                ),
                _buildAnalyticsButton('Track Share', Icons.share, () async {
                  await trackSharing(_selectedContentId, 'demo_share');
                  _showSnackbar('Share event tracked!');
                }),
              ],
            ),

            const SizedBox(height: 12),

            // Analytics Display
            AnimatedRatingDisplayWidget(
              rating: _currentRating,
              totalRatings: 42,
              contentId: _selectedContentId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildABTestingSection() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'A/B Testing',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current variants display
            _buildVariantDisplay(
              'Feedback Button Style',
              getVariant('feedback_button_style', 'modern'),
            ),
            _buildVariantDisplay(
              'Rating Widget Type',
              getVariant('rating_widget_type', 'stars'),
            ),
            _buildVariantDisplay(
              'Color Scheme',
              getVariant('color_scheme', 'default'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                await abTesting.trackConversion(
                  experimentName: 'feedback_button_style',
                  conversionType: 'demo_conversion',
                  value: 1.0,
                );
                _showSnackbar('A/B test conversion tracked!');
              },
              icon: const Icon(Icons.track_changes),
              label: const Text('Track Test Conversion'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScholarVerificationSection() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Scholar Verification',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Verification badge
            const ScholarVerificationBadge(
              status: ScholarVerificationStatus(
                contentId: 'demo_dua_001',
                isVerified: true,
                verificationCount: 3,
                averageRating: 4.5,
                lastUpdated: '2024-01-15',
                verifyingScholars: [
                  ScholarInfo(
                    id: 'scholar1',
                    name: 'Dr. Ahmad Ibn Hassan',
                    level: ScholarLevel.scholar,
                    institution: 'Al-Azhar University',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showDetailedScholarForm();
                },
                icon: const Icon(Icons.edit_note),
                label: const Text('Submit Scholar Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.privacy_tip, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Privacy & Data Control',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPrivacyButton(
                  'View Analytics',
                  Icons.bar_chart,
                  () async {
                    final analytics = await feedbackService.getAggregatedAnalytics();
                    debugPrint('Analytics: $analytics');
                    _showSnackbar('Analytics data retrieved!');
                  },
                ),
                _buildPrivacyButton('Export Data', Icons.download, () async {
                  final data = await feedbackService.exportAnonymizedData();
                  debugPrint('Exported data size: ${data.keys.length}');
                  _showSnackbar('Anonymized data exported!');
                }),
                _buildPrivacyButton('Clear Data', Icons.delete, () async {
                  await _showClearDataDialog();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InteractionTracker(
      actionName: 'analytics_button_pressed',
      contentId: 'demo_analytics',
      feedbackService: feedbackService,
      additionalData: {'button_label': label},
      onTap: onPressed,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildPrivacyButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildVariantDisplay(String experiment, String variant) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(experiment, style: theme.textTheme.bodyMedium)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              variant,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _showClearDataDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'This will permanently delete all your feedback data, ratings, and analytics. '
            'This action cannot be undone. Are you sure you want to continue?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Data'),
              onPressed: () async {
                Navigator.of(context).pop();
                await feedbackService.clearAllData();
                _showSnackbar('All data cleared successfully!');
              },
            ),
          ],
        );
      },
    );
  }

  // Modal sheets
  void _showDetailedFeedbackForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ContextualFeedbackForm(
          contentId: _selectedContentId,
          contentType: 'dua',
          onSubmit: (data) async {
            Navigator.pop(context);
            await feedbackService.submitContextualFeedback(
              contentId: _selectedContentId,
              contentType: 'dua',
              feedbackData: data,
            );
            _showSnackbar('Detailed feedback submitted!');
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showDetailedScholarForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ScholarFeedbackForm(
          contentId: _selectedContentId,
          contentType: 'dua',
          onSubmit: (data) async {
            Navigator.pop(context);
            _showSnackbar('Scholar verification submitted!');
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

