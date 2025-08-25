import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/professional_theme.dart';
import '../../../services/personalization/personalization_models.dart';
import '../../../services/personalization/user_personalization_service.dart';

/// Simple demonstration screen for comprehensive user personalization system
class PersonalizationDemoScreen extends ConsumerStatefulWidget {
  const PersonalizationDemoScreen({super.key});

  @override
  ConsumerState<PersonalizationDemoScreen> createState() => _PersonalizationDemoScreenState();
}

class _PersonalizationDemoScreenState extends ConsumerState<PersonalizationDemoScreen> {
  final _personalizationService = UserPersonalizationService.instance;
  bool _isInitialized = false;
  final String _currentUserId = 'demo_user_123';
  int _totalInteractions = 0;

  @override
  void initState() {
    super.initState();
    _initializePersonalization();
  }

  Future<void> _initializePersonalization() async {
    try {
      await _personalizationService.initialize(userId: _currentUserId);

      // Listen to personalization updates
      _personalizationService.updateStream.listen((update) {
        if (mounted) {
          setState(() {
            _totalInteractions++;
          });
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing personalization: $e');
    }
  }

  Future<void> _simulateDuaInteraction(String duaId, InteractionType type) async {
    await _personalizationService.trackDuaInteraction(
      duaId: duaId,
      type: type,
      duration: const Duration(seconds: 30),
      metadata: {'language': 'en', 'cultural_context': 'demo', 'session_id': 'demo_session'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfessionalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('User Personalization System'),
        backgroundColor: ProfessionalTheme.surfaceColor,
        foregroundColor: ProfessionalTheme.textPrimary,
        elevation: 0,
      ),
      body:
          !_isInitialized
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Initializing Personalization System...'),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Demo status card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personalization Demo Status',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: ProfessionalTheme.primaryEmerald,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusItem('Total Interactions', _totalInteractions.toString()),
                                _buildStatusItem('System Status', 'Active'),
                                _buildStatusItem('Privacy Level', 'Balanced'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Features overview
                    Text(
                      'System Features',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ProfessionalTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildFeatureCard(
                      'Usage Pattern Tracking',
                      'Tracks user interactions using SharedPreferences for local storage',
                      Icons.analytics,
                      Colors.blue,
                    ),

                    _buildFeatureCard(
                      'Cultural & Linguistic Preferences',
                      'Learns from user language and cultural preferences',
                      Icons.language,
                      Colors.green,
                    ),

                    _buildFeatureCard(
                      'Temporal Pattern Recognition',
                      'Analyzes time-based habits for optimal recommendations',
                      Icons.schedule,
                      Colors.orange,
                    ),

                    _buildFeatureCard(
                      'Islamic Calendar Integration',
                      'Provides seasonal recommendations based on Islamic calendar',
                      Icons.calendar_month,
                      Colors.purple,
                    ),

                    _buildFeatureCard(
                      'Privacy-First Processing',
                      'All processing done on-device using compute isolates',
                      Icons.security,
                      Colors.red,
                    ),

                    const SizedBox(height: 24),

                    // Demo actions
                    Text(
                      'Try Demo Actions',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ProfessionalTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildActionButton(
                      'Read Morning Du\'as',
                      Icons.wb_sunny,
                      () => _simulateDuaInteraction('morning_duas', InteractionType.read),
                    ),

                    _buildActionButton(
                      'Bookmark Travel Du\'as',
                      Icons.bookmark,
                      () => _simulateDuaInteraction('travel_duas', InteractionType.bookmark),
                    ),

                    _buildActionButton(
                      'Play Audio',
                      Icons.play_arrow,
                      () => _simulateDuaInteraction('audio_dua', InteractionType.audio),
                    ),

                    _buildActionButton(
                      'Share Du\'a',
                      Icons.share,
                      () => _simulateDuaInteraction('shared_dua', InteractionType.share),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: ProfessionalTheme.primaryEmerald, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ProfessionalTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: ProfessionalTheme.primaryEmerald,
          foregroundColor: ProfessionalTheme.surfaceColor,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
