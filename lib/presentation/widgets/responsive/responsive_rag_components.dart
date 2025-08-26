import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/rag_response.dart';
import '../../../core/rag/enterprise_rag_architecture.dart';

/// 🎨 RESPONSIVE FLUTTER UI WITH OPTIMIZED STATE MANAGEMENT
/// Enterprise-grade UI components with ML-powered personalization

/// High-performance RAG response state notifier
class ResponsiveRagNotifier extends StateNotifier<ResponsiveRagState> {
  final EnterpriseRagService _ragService;
  
  ResponsiveRagNotifier(this._ragService) : super(const ResponsiveRagState());

  /// Execute intelligent query with personalization
  Future<void> performQuery({
    required String query,
    required String language,
    Map<String, dynamic>? userContext,
    Map<String, dynamic>? personalizationData,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentQuery: query,
    );

    try {
      // Enhance query with personalization context
      final enhancedContext = {
        ...?userContext,
        'personalization': personalizationData ?? {},
        'ui_context': {
          'screen_size': _getScreenSize(),
          'theme_mode': _getThemeMode(),
          'accessibility_enabled': _isAccessibilityEnabled(),
        },
      };

      final response = await _ragService.queryRag(
        query: query,
        language: language,
        context: enhancedContext,
      );

      state = state.copyWith(
        isLoading: false,
        response: response,
        responses: [...state.responses, response],
        performanceMetrics: _ragService.getPerformanceAnalytics(),
      );

    } catch (error, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// Clear conversation history
  void clearHistory() {
    state = state.copyWith(
      responses: [],
      response: null,
      error: null,
    );
  }

  /// Filter responses based on user preferences
  void filterResponses({
    double? minConfidence,
    List<String>? categories,
    String? searchTerm,
  }) {
    var filteredResponses = state.allResponses;

    if (minConfidence != null) {
      filteredResponses = filteredResponses
          .where((r) => (r.confidence ?? 0.0) >= minConfidence)
          .toList();
    }

    if (categories != null && categories.isNotEmpty) {
      filteredResponses = filteredResponses
          .where((r) => r.metadata?['category'] != null &&
                      categories.contains(r.metadata!['category']))
          .toList();
    }

    if (searchTerm != null && searchTerm.isNotEmpty) {
      filteredResponses = filteredResponses
          .where((r) => r.response.toLowerCase().contains(searchTerm.toLowerCase()) ||
                      r.query.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    state = state.copyWith(responses: filteredResponses);
  }

  Map<String, dynamic> _getScreenSize() {
    return {
      'width': 0.0, // Would get from MediaQuery in real implementation
      'height': 0.0,
      'scale': 1.0,
    };
  }

  String _getThemeMode() {
    return 'light'; // Would get from Theme in real implementation
  }

  bool _isAccessibilityEnabled() {
    return false; // Would get from MediaQuery in real implementation
  }
}

/// Immutable state for responsive RAG UI
@immutable
class ResponsiveRagState {
  final bool isLoading;
  final RagResponse? response;
  final List<RagResponse> responses;
  final String? error;
  final StackTrace? stackTrace;
  final String? currentQuery;
  final Map<String, dynamic>? personalizationData;
  final Map<String, dynamic>? performanceMetrics;

  const ResponsiveRagState({
    this.isLoading = false,
    this.response,
    this.responses = const [],
    this.error,
    this.stackTrace,
    this.currentQuery,
    this.personalizationData,
    this.performanceMetrics,
  });

  List<RagResponse> get allResponses => responses;

  bool get hasData => response != null || responses.isNotEmpty;
  bool get hasError => error != null;

  ResponsiveRagState copyWith({
    bool? isLoading,
    RagResponse? response,
    List<RagResponse>? responses,
    String? error,
    StackTrace? stackTrace,
    String? currentQuery,
    Map<String, dynamic>? personalizationData,
    Map<String, dynamic>? performanceMetrics,
  }) {
    return ResponsiveRagState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      responses: responses ?? this.responses,
      error: error,
      stackTrace: stackTrace,
      currentQuery: currentQuery ?? this.currentQuery,
      personalizationData: personalizationData ?? this.personalizationData,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
    );
  }
}

/// Provider for responsive RAG state management
final responsiveRagProvider = StateNotifierProvider<ResponsiveRagNotifier, ResponsiveRagState>((ref) {
  return ResponsiveRagNotifier(ref.watch(enterpriseRagServiceProvider));
});

/// 🎨 RESPONSIVE UI COMPONENTS

/// Adaptive RAG response card with intelligent layout
class AdaptiveRagResponseCard extends ConsumerWidget {
  final RagResponse response;
  final VoidCallback? onTap;
  final bool showMetadata;

  const AdaptiveRagResponseCard({
    super.key,
    required this.response,
    this.onTap,
    this.showMetadata = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 8.0 : 16.0,
        vertical: 4.0,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Query section
              _buildQuerySection(theme, isCompact),
              
              const SizedBox(height: 12),
              
              // Response section
              _buildResponseSection(theme, isCompact),
              
              if (showMetadata) ...[
                const SizedBox(height: 12),
                _buildMetadataSection(theme, isCompact),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuerySection(ThemeData theme, bool isCompact) {
    return Row(
      children: [
        Icon(
          Icons.question_answer,
          size: isCompact ? 18 : 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            response.query,
            style: (isCompact ? theme.textTheme.bodyMedium : theme.textTheme.titleSmall)
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: isCompact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if ((response.confidence ?? 0.0) > 0) ...[
          const SizedBox(width: 8),
          _ConfidenceBadge(
            confidence: response.confidence ?? 0.0,
            isCompact: isCompact,
          ),
        ],
      ],
    );
  }

  Widget _buildResponseSection(ThemeData theme, bool isCompact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 8.0 : 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Text(
        response.response,
        style: (isCompact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
            ?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        maxLines: isCompact ? 3 : null,
        overflow: isCompact ? TextOverflow.ellipsis : null,
      ),
    );
  }

  Widget _buildMetadataSection(ThemeData theme, bool isCompact) {
    return Row(
      children: [
        // Sources
        if (response.sources?.isNotEmpty == true)
          _MetadataChip(
            icon: Icons.source,
            label: '${response.sources!.length} source${response.sources!.length != 1 ? 's' : ''}',
            isCompact: isCompact,
          ),
        
        const SizedBox(width: 8),
        
        // Response time
        if (response.responseTime > 0)
          _MetadataChip(
            icon: Icons.schedule,
            label: '${response.responseTime}ms',
            isCompact: isCompact,
          ),

        const Spacer(),
        
        // Timestamp
        Text(
          _formatTimestamp(response.timestamp),
          style: (isCompact ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)
              ?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Confidence indicator badge
class _ConfidenceBadge extends StatelessWidget {
  final double confidence;
  final bool isCompact;

  const _ConfidenceBadge({
    required this.confidence,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getConfidenceColor(confidence, theme);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 4.0 : 6.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '${(confidence * 100).round()}%',
        style: (isCompact ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)
            ?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: isCompact ? 10 : 11,
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence, ThemeData theme) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

/// Metadata display chip
class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCompact;

  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 4.0 : 6.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 12 : 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: (isCompact ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)
                ?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: isCompact ? 10 : 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive loading indicator with performance metrics
class ResponsiveLoadingWidget extends ConsumerWidget {
  final String? loadingText;

  const ResponsiveLoadingWidget({
    super.key,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    final ragState = ref.watch(responsiveRagProvider);

    return Container(
      padding: EdgeInsets.all(isCompact ? 16.0 : 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading indicator
          SizedBox(
            width: isCompact ? 32 : 40,
            height: isCompact ? 32 : 40,
            child: CircularProgressIndicator(
              strokeWidth: isCompact ? 2.5 : 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),

          SizedBox(height: isCompact ? 12 : 16),

          // Loading text
          Text(
            loadingText ?? 'Processing your request...',
            style: (isCompact ? theme.textTheme.bodyMedium : theme.textTheme.titleSmall)
                ?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          // Performance metrics (if available)
          if (ragState.performanceMetrics != null) ...[
            SizedBox(height: isCompact ? 8 : 12),
            _PerformanceMetricsWidget(
              metrics: ragState.performanceMetrics!,
              isCompact: isCompact,
            ),
          ],
        ],
      ),
    );
  }
}

/// Performance metrics display widget
class _PerformanceMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;
  final bool isCompact;

  const _PerformanceMetricsWidget({
    required this.metrics,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8.0 : 12.0,
        vertical: isCompact ? 4.0 : 6.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Avg: ${metrics['average_response_time']?.toStringAsFixed(0) ?? 0}ms • '
        'Success: ${metrics['success_rate']?.toStringAsFixed(1) ?? 0}%',
        style: (isCompact ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)
            ?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Advanced error widget with retry functionality
class ResponsiveErrorWidget extends ConsumerWidget {
  final String error;
  final VoidCallback? onRetry;

  const ResponsiveErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isCompact ? 16.0 : 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon
          Icon(
            Icons.error_outline,
            size: isCompact ? 48 : 64,
            color: theme.colorScheme.error,
          ),

          SizedBox(height: isCompact ? 12 : 16),

          // Error title
          Text(
            'Something went wrong',
            style: (isCompact ? theme.textTheme.titleMedium : theme.textTheme.titleLarge)
                ?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isCompact ? 8 : 12),

          // Error message
          Container(
            padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withOpacity(0.2),
              ),
            ),
            child: Text(
              error,
              style: (isCompact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
                  ?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          if (onRetry != null) ...[
            SizedBox(height: isCompact ? 16 : 24),

            // Retry button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 16.0 : 24.0,
                  vertical: isCompact ? 8.0 : 12.0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
