import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/smart_dua_entity.dart';
import '../../../services/ai/smart_dua_intelligence_service.dart';

/// Smart Dua Collections Screen with AI-powered contextual intelligence
class SmartDuaCollectionsScreen extends ConsumerStatefulWidget {
  const SmartDuaCollectionsScreen({super.key});

  @override
  ConsumerState<SmartDuaCollectionsScreen> createState() =>
      _SmartDuaCollectionsScreenState();
}

class _SmartDuaCollectionsScreenState
    extends ConsumerState<SmartDuaCollectionsScreen>
    with SingleTickerProviderStateMixin {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<SmartDuaRecommendation> _recommendations = [];
  List<SmartDuaCollection> _collections = [];
  bool _isAnalyzing = false;
  bool _showRecommendations = false;
  EmotionalState? _currentEmotion;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _initializeSmartFeatures();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Initialize smart features and load user data
  Future<void> _initializeSmartFeatures() async {
    try {
      final service = SmartDuaIntelligenceService.instance;

      // Load user's smart collections
      final userId = 'current_user'; // Get from auth service
      final collections = await service.getSmartCollections(userId);

      if (mounted) {
        setState(() {
          _collections = collections;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(
          'Failed to load smart features. Please ensure you have a premium subscription.',
        );
      }
    }
  }

  /// Analyze user input for contextual recommendations
  Future<void> _analyzeInput() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _showRecommendations = false;
    });

    try {
      final service = SmartDuaIntelligenceService.instance;
      final recommendations = await service.analyzeContextualInput(input);

      if (mounted) {
        setState(() {
          _recommendations = recommendations;
          _isAnalyzing = false;
          _showRecommendations = true;
          _currentEmotion =
              recommendations.isNotEmpty
                  ? recommendations.first.targetEmotion
                  : null;
        });

        // Auto-scroll to recommendations
        _scrollController.animateTo(
          300.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        _showErrorMessage(
          'Analysis failed. Please try again or check your subscription.',
        );
      }
    }
  }

  /// Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _initializeSmartFeatures,
          textColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Dua Collections'),
            Text(
              'AI-Powered Contextual Guidance',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.islamicGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.islamicGreen, AppColors.islamicGold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology),
            onPressed: () => _showAIInfoDialog(),
            tooltip: 'About AI Intelligence',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showAnalytics(),
            tooltip: 'View Analytics',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header section with input
            SliverToBoxAdapter(child: _buildHeaderSection(theme)),

            // Analysis results
            if (_showRecommendations) ...[
              SliverToBoxAdapter(child: _buildRecommendationsSection(theme)),
            ],

            // Smart Collections
            SliverToBoxAdapter(child: _buildSmartCollectionsSection(theme)),

            // Quick access emotions
            SliverToBoxAdapter(child: _buildQuickAccessSection(theme)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _analyzeInput,
        backgroundColor: AppColors.islamicGreen,
        icon:
            _isAnalyzing
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Icon(Icons.psychology),
        label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Feelings'),
      ),
    );
  }

  /// Build header section with input
  Widget _buildHeaderSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Text(
            'How are you feeling today?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.islamicGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Describe your emotions, situation, or what\'s on your heart. Our AI will recommend perfect duas for you.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // Input field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText:
                    'e.g., "Feeling anxious about job interview tomorrow" or "Grateful for family"',
                prefixIcon: Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.islamicGreen,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _analyzeInput,
                  color: AppColors.islamicGreen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _analyzeInput(),
            ),
          ),

          // Example suggestions
          if (!_showRecommendations) ...[
            const SizedBox(height: 16),
            Text(
              'Try these examples:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionChip('Feeling anxious'),
                _buildSuggestionChip('Job interview tomorrow'),
                _buildSuggestionChip('Traveling to new city'),
                _buildSuggestionChip('Sick child'),
                _buildSuggestionChip('Grateful for blessings'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build suggestion chip
  Widget _buildSuggestionChip(String suggestion) {
    return ActionChip(
      label: Text(suggestion),
      onPressed: () {
        _inputController.text = suggestion;
        _analyzeInput();
      },
      backgroundColor: AppColors.islamicGreen.withOpacity(0.1),
      labelStyle: TextStyle(color: AppColors.islamicGreen, fontSize: 12),
    );
  }

  /// Build recommendations section
  Widget _buildRecommendationsSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(Icons.psychology, color: AppColors.islamicGreen),
              const SizedBox(width: 8),
              Text(
                'AI Recommendations',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.islamicGreen,
                ),
              ),
              const Spacer(),
              if (_currentEmotion != null)
                Chip(
                  label: Text(_currentEmotion!.displayName),
                  backgroundColor: _getEmotionColor(
                    _currentEmotion!,
                  ).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getEmotionColor(_currentEmotion!),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Recommendations list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = _recommendations[index];
              return _buildRecommendationCard(recommendation, theme);
            },
          ),
        ],
      ),
    );
  }

  /// Build recommendation card
  Widget _buildRecommendationCard(
    SmartDuaRecommendation recommendation,
    ThemeData theme,
  ) {
    final confidenceColor = _getConfidenceColor(recommendation.confidence);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showRecommendationDetails(recommendation),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with confidence indicator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        recommendation.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: confidenceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recommendation.confidence.name.toUpperCase(),
                        style: TextStyle(
                          color: confidenceColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Arabic text
                Text(
                  recommendation.arabicTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Amiri',
                    color: AppColors.islamicGreen,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),

                // AI reasoning
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recommendation.reason,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Actions
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Listen'),
                      onPressed: () => _playRecommendation(recommendation),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.bookmark_border, size: 16),
                      label: const Text('Save'),
                      onPressed: () => _saveRecommendation(recommendation),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_outlined, size: 16),
                          onPressed:
                              () => _provideFeedback(recommendation, true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.thumb_down_outlined, size: 16),
                          onPressed:
                              () => _provideFeedback(recommendation, false),
                        ),
                      ],
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

  /// Build smart collections section
  Widget _buildSmartCollectionsSection(ThemeData theme) {
    if (_collections.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.auto_awesome, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Building Your Smart Collections',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the AI analysis feature to create personalized dua collections based on your emotions and situations.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Smart Collections',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.islamicGreen,
            ),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _collections.length,
            itemBuilder: (context, index) {
              final collection = _collections[index];
              return _buildCollectionCard(collection, theme);
            },
          ),
        ],
      ),
    );
  }

  /// Build collection card
  Widget _buildCollectionCard(SmartDuaCollection collection, ThemeData theme) {
    final emotionColor = _getEmotionColor(collection.primaryEmotion);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openCollection(collection),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                emotionColor.withOpacity(0.1),
                emotionColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: emotionColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getEmotionIcon(collection.primaryEmotion),
                        color: emotionColor,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: emotionColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${collection.duaIds.length}',
                        style: TextStyle(
                          color: emotionColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  collection.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                Text(
                  collection.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build quick access section
  Widget _buildQuickAccessSection(ThemeData theme) {
    final quickEmotions = [
      EmotionalState.anxious,
      EmotionalState.grateful,
      EmotionalState.peaceful,
      EmotionalState.seekingGuidance,
      EmotionalState.worried,
      EmotionalState.hopeful,
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.islamicGreen,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                quickEmotions.map((emotion) {
                  return _buildQuickEmotionChip(emotion);
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// Build quick emotion chip
  Widget _buildQuickEmotionChip(EmotionalState emotion) {
    final color = _getEmotionColor(emotion);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _quickAnalyzeEmotion(emotion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getEmotionIcon(emotion), color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              emotion.displayName,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// Get emotion color
  Color _getEmotionColor(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
      case EmotionalState.worried:
      case EmotionalState.fearful:
        return Colors.orange.shade600;
      case EmotionalState.stressed:
        return Colors.red.shade600;
      case EmotionalState.overwhelmed:
        return Colors.deepOrange.shade600;
      case EmotionalState.peaceful:
        return Colors.blue.shade600;
      case EmotionalState.grateful:
        return Colors.green.shade600;
      case EmotionalState.hopeful:
        return Colors.purple.shade600;
      case EmotionalState.excited:
        return Colors.pink.shade600;
      case EmotionalState.sad:
        return Colors.grey.shade600;
      case EmotionalState.confident:
        return Colors.teal.shade600;
      case EmotionalState.uncertain:
        return Colors.brown.shade600;
      case EmotionalState.seekingGuidance:
        return AppColors.islamicGold;
    }
  }

  /// Get emotion icon
  IconData _getEmotionIcon(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
        return Icons.psychology_alt;
      case EmotionalState.stressed:
        return Icons.warning_rounded;
      case EmotionalState.overwhelmed:
        return Icons.layers;
      case EmotionalState.peaceful:
        return Icons.self_improvement;
      case EmotionalState.grateful:
        return Icons.favorite;
      case EmotionalState.hopeful:
        return Icons.wb_sunny;
      case EmotionalState.excited:
        return Icons.celebration;
      case EmotionalState.sad:
        return Icons.sentiment_dissatisfied;
      case EmotionalState.fearful:
        return Icons.shield;
      case EmotionalState.confident:
        return Icons.trending_up;
      case EmotionalState.uncertain:
        return Icons.help_outline;
      case EmotionalState.worried:
        return Icons.cloud;
      case EmotionalState.seekingGuidance:
        return Icons.explore;
    }
  }

  /// Get confidence color
  Color _getConfidenceColor(AIConfidenceLevel confidence) {
    switch (confidence) {
      case AIConfidenceLevel.veryHigh:
        return Colors.green.shade600;
      case AIConfidenceLevel.high:
        return Colors.blue.shade600;
      case AIConfidenceLevel.medium:
        return Colors.orange.shade600;
      case AIConfidenceLevel.low:
        return Colors.red.shade600;
    }
  }

  /// Quick analyze emotion
  void _quickAnalyzeEmotion(EmotionalState emotion) {
    _inputController.text = emotion.displayName;
    _analyzeInput();
  }

  /// Show AI info dialog
  void _showAIInfoDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('AI Intelligence'),
            content: const Text(
              'Our Smart Dua Collections use advanced AI to analyze your emotions, context, and spiritual needs. '
              'The system learns from your preferences to provide increasingly accurate recommendations over time.\n\n'
              'All emotional data is encrypted and processed securely on your device.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  /// Show analytics
  void _showAnalytics() {
    // Navigate to analytics screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show recommendation details
  void _showRecommendationDetails(SmartDuaRecommendation recommendation) {
    // Navigate to dua details screen
  }

  /// Play recommendation
  void _playRecommendation(SmartDuaRecommendation recommendation) {
    // Integrate with premium audio service
  }

  /// Save recommendation
  void _saveRecommendation(SmartDuaRecommendation recommendation) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recommendation saved to your collections'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Provide feedback
  void _provideFeedback(SmartDuaRecommendation recommendation, bool helpful) {
    final service = SmartDuaIntelligenceService.instance;
    final feedback = AIFeedback(
      id: 'feedback_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      recommendationId: recommendation.id,
      wasHelpful: helpful,
      rating: helpful ? 5 : 2,
      feedbackType: helpful ? 'positive' : 'negative',
      providedAt: DateTime.now(),
    );

    service.submitFeedback(feedback);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          helpful
              ? 'Thank you for your feedback!'
              : 'We\'ll improve our recommendations',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Open collection
  void _openCollection(SmartDuaCollection collection) {
    // Navigate to collection details screen
  }
}
