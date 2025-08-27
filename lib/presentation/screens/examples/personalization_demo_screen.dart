import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/professional_theme.dart';
import '../../../services/personalization/personalization_models.dart';
import '../../../services/personalization/user_personalization_service.dart';
import '../../widgets/professional_components.dart';

/// Demonstration screen for comprehensive user personalization system
///
/// Features demonstrated:
/// - Usage pattern tracking with SharedPreferences
/// - Session context maintenance using Riverpod state management
/// - Cultural and linguistic preference learning
/// - Temporal pattern recognition for habits
/// - Islamic calendar integration for seasonal Du'a recommendations
/// - Privacy-first personalization with on-device processing
class PersonalizationDemoScreen extends ConsumerStatefulWidget {
  const PersonalizationDemoScreen({super.key});

  @override
  ConsumerState<PersonalizationDemoScreen> createState() =>
      _PersonalizationDemoScreenState();
}

class _PersonalizationDemoScreenState
    extends ConsumerState<PersonalizationDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _personalizationService = UserPersonalizationService.instance;

  // Demo state
  bool _isInitialized = false;
  final String _currentUserId = 'demo_user_123';
  final List<String> _preferredLanguages = ['en', 'ar'];
  String _primaryLanguage = 'en';
  PrivacyLevel _privacyLevel = PrivacyLevel.balanced;

  // Interaction tracking
  int _totalInteractions = 0;
  final Map<String, int> _interactionTypes = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializePersonalization();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializePersonalization() async {
    try {
      await _personalizationService.initialize(userId: _currentUserId);

      // Listen to personalization updates
      _personalizationService.updateStream.listen((update) {
        if (mounted) {
          setState(() {
            _handlePersonalizationUpdate(update);
          });
        }
      });

      setState(() {
        _isInitialized = true;
      });

      // Load initial contextual suggestions
      _loadContextualSuggestions();
    } catch (e) {
      debugPrint('Error initializing personalization: $e');
    }
  }

  void _handlePersonalizationUpdate(PersonalizationUpdate update) {
    switch (update.type) {
      case UpdateType.interaction:
        _totalInteractions++;
        final interaction = update.data as DuaInteraction;
        _interactionTypes[interaction.type.name] =
            (_interactionTypes[interaction.type.name] ?? 0) + 1;
        break;
      case UpdateType.culturalPreferences:
        // Handle cultural preference updates
        break;
      case UpdateType.usagePatterns:
        // Handle usage pattern updates
        break;
      case UpdateType.temporalPatterns:
        // Handle temporal pattern updates
        break;
      case UpdateType.sessionStart:
        // Handle session start
        break;
      case UpdateType.sessionEnd:
        // Handle session end
        break;
    }
  }

  Future<void> _loadContextualSuggestions() async {
    try {
      final suggestions =
          await _personalizationService.getContextualSuggestions(limit: 5);
      // Suggestions would be used to update UI in a real implementation
      debugPrint('Loaded ${suggestions.length} contextual suggestions');
    } catch (e) {
      debugPrint('Error loading contextual suggestions: $e');
    }
  }

  Future<void> _simulateDuaInteraction(
      String duaId, InteractionType type) async {
    await _personalizationService.trackDuaInteraction(
      duaId: duaId,
      type: type,
      duration: const Duration(seconds: 30),
      metadata: {
        'language': _primaryLanguage,
        'cultural_context': 'demo',
        'session_id': 'demo_session'
      },
    );
  }

  Future<void> _updateCulturalPreferences() async {
    await _personalizationService.updateCulturalPreferences(
      preferredLanguages: _preferredLanguages,
      primaryLanguage: _primaryLanguage,
      culturalTags: ['middle_east', 'south_asia'],
      languagePreferences: {'en': 0.7, 'ar': 0.9, 'ur': 0.6},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfessionalTheme.backgroundColor,
      appBar: ProfessionalComponents.appBar(
        title: 'User Personalization System',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContextualSuggestions,
            tooltip: 'Refresh Suggestions',
          ),
        ],
      ),
      body: !_isInitialized
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
          : Column(
              children: [
                // Tab bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: ProfessionalTheme.primaryEmerald,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: ProfessionalTheme.primaryEmerald,
                    tabs: const [
                      Tab(text: 'Usage Patterns'),
                      Tab(text: 'Cultural Prefs'),
                      Tab(text: 'Temporal Analysis'),
                      Tab(text: 'Islamic Calendar'),
                      Tab(text: 'Privacy & Settings'),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUsagePatternsTab(),
                      _buildCulturalPreferencesTab(),
                      _buildTemporalAnalysisTab(),
                      _buildIslamicCalendarTab(),
                      _buildPrivacySettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simulateRandomInteraction,
        backgroundColor: ProfessionalTheme.primaryEmerald,
        label: const Text('Simulate Interaction'),
        icon: const Icon(Icons.psychology),
      ),
    );
  }

  Widget _buildUsagePatternsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage Pattern Tracking',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ProfessionalTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'Local storage with SharedPreferences',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ProfessionalTheme.textSecondary),
          ),

          const SizedBox(height: 16),

          // Statistics cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Interactions',
                  _totalInteractions.toString(),
                  Icons.touch_app,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Session Duration',
                  '${DateTime.now().difference(DateTime.now().subtract(const Duration(minutes: 15))).inMinutes} min',
                  Icons.timer,
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Interaction types breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interaction Types',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._interactionTypes.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key.toUpperCase()),
                          Chip(
                            label: Text('${entry.value}'),
                            backgroundColor:
                                ProfessionalTheme.primaryColor.withOpacity(0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildCulturalPreferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfessionalComponents.buildSectionHeader(
            'Cultural & Linguistic Preferences',
            'Settings persistence with learning',
          ),

          const SizedBox(height: 16),

          // Language preferences
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferred Languages',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['English', 'Arabic', 'Urdu', 'Turkish', 'Malay']
                        .map((language) {
                      final code = language.substring(0, 2).toLowerCase();
                      final isSelected = _preferredLanguages.contains(code);
                      return FilterChip(
                        label: Text(language),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _preferredLanguages.add(code);
                            } else {
                              _preferredLanguages.remove(code);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Primary language
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Primary Language',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _primaryLanguage,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: 'en', child: Text('English')),
                      const DropdownMenuItem(
                          value: 'ar', child: Text('Arabic')),
                      const DropdownMenuItem(value: 'ur', child: Text('Urdu')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _primaryLanguage = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Update button
          ElevatedButton.icon(
            onPressed: _updateCulturalPreferences,
            icon: const Icon(Icons.save),
            label: const Text('Update Preferences'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfessionalTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemporalAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfessionalComponents.buildSectionHeader(
              'Temporal Pattern Recognition', 'DateTime analysis for habits'),

          const SizedBox(height: 16),

          // Time-based insights
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Time Context',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTimeContextItem('Time of Day', _getTimeOfDay()),
                  _buildTimeContextItem('Day of Week', _getDayOfWeek()),
                  _buildTimeContextItem('Islamic Date', 'Loading...'),
                  _buildTimeContextItem(
                      'Prayer Time Context', 'Between Dhuhr & Asr'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Habit strength indicators
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Habit Strength Analysis',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildHabitStrengthItem('Morning Du\'as', 0.8),
                  _buildHabitStrengthItem('Travel Du\'as', 0.6),
                  _buildHabitStrengthItem('Evening Dhikr', 0.9),
                  _buildHabitStrengthItem('Before Meals', 0.4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfessionalComponents.buildSectionHeader(
              'Islamic Calendar Integration', 'Seasonal Du\'a recommendations'),

          const SizedBox(height: 16),

          // Islamic date context
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Islamic Calendar Context',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildCalendarContextItem('Current Month', 'Rabi\' al-awwal'),
                  _buildCalendarContextItem('Is Holy Month', 'No'),
                  _buildCalendarContextItem(
                      'Special Occasion', 'Mawlid an-Nabi approaching'),
                  _buildCalendarContextItem('Season', 'Winter'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Seasonal recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seasonal Recommendations',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendationItem(
                    'Prophet\'s Birthday Du\'as',
                    'Special prayers for Mawlid celebration',
                    Icons.celebration,
                  ),
                  _buildRecommendationItem(
                    'Winter Weather Du\'as',
                    'Prayers for cold weather and protection',
                    Icons.ac_unit,
                  ),
                  _buildRecommendationItem(
                    'Daily Sunnah Prayers',
                    'Regular prayers emphasized in this month',
                    Icons.auto_awesome,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfessionalComponents.buildSectionHeader(
            'Privacy-First Personalization',
            'On-device processing with compute isolates',
          ),

          const SizedBox(height: 16),

          // Privacy level
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Level',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...PrivacyLevel.values.map(
                    (level) => RadioListTile<PrivacyLevel>(
                      title: Text(_getPrivacyLevelName(level)),
                      subtitle: Text(_getPrivacyLevelDescription(level)),
                      value: level,
                      groupValue: _privacyLevel,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _privacyLevel = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Data processing info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Processing',
                    style: ProfessionalTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDataProcessingItem('Local Storage', 'SharedPreferences',
                      Icons.storage, true),
                  _buildDataProcessingItem('On-Device Processing',
                      'Compute Isolates', Icons.security, true),
                  _buildDataProcessingItem(
                      'Cloud Sync', 'Optional', Icons.cloud_off, false),
                  _buildDataProcessingItem(
                      'Analytics', 'Privacy-Preserving', Icons.analytics, true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: ProfessionalTheme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: ProfessionalTheme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions',
            style: ProfessionalTheme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () =>
                  _simulateDuaInteraction('morning_duas', InteractionType.read),
              icon: const Icon(Icons.wb_sunny),
              label: const Text('Read Morning Du\'as'),
            ),
            ElevatedButton.icon(
              onPressed: () => _simulateDuaInteraction(
                  'travel_duas', InteractionType.bookmark),
              icon: const Icon(Icons.bookmark),
              label: const Text('Bookmark Travel Du\'as'),
            ),
            ElevatedButton.icon(
              onPressed: () => _simulateDuaInteraction(
                  'evening_dhikr', InteractionType.audio),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Evening Dhikr'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeContextItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildHabitStrengthItem(String habit, double strength) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(habit), Text('${(strength * 100).toInt()}%')],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: strength,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              strength > 0.7
                  ? Colors.green
                  : strength > 0.4
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContextItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
      String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: ProfessionalTheme.primaryColor),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Would navigate to specific Du'a
      },
    );
  }

  Widget _buildDataProcessingItem(
      String title, String description, IconData icon, bool enabled) {
    return ListTile(
      leading: Icon(icon, color: enabled ? Colors.green : Colors.grey),
      title: Text(title),
      subtitle: Text(description),
      trailing: enabled
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.cancel, color: Colors.grey),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 21) return 'Evening';
    return 'Night';
  }

  String _getDayOfWeek() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[DateTime.now().weekday - 1];
  }

  String _getPrivacyLevelName(PrivacyLevel level) {
    switch (level) {
      case PrivacyLevel.strict:
        return 'Strict Privacy';
      case PrivacyLevel.balanced:
        return 'Balanced';
      case PrivacyLevel.enhanced:
        return 'Enhanced Personalization';
    }
  }

  String _getPrivacyLevelDescription(PrivacyLevel level) {
    switch (level) {
      case PrivacyLevel.strict:
        return 'Minimal data collection, local processing only';
      case PrivacyLevel.balanced:
        return 'Standard privacy with some analytics';
      case PrivacyLevel.enhanced:
        return 'Full personalization with comprehensive analytics';
    }
  }

  void _simulateRandomInteraction() {
    final duaIds = [
      'morning_duas',
      'travel_duas',
      'evening_dhikr',
      'meal_duas',
      'sleep_duas'
    ];
    final types = InteractionType.values;

    final randomDua = duaIds[DateTime.now().millisecond % duaIds.length];
    final randomType = types[DateTime.now().microsecond % types.length];

    _simulateDuaInteraction(randomDua, randomType);
  }
}
