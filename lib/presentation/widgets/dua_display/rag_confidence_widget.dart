import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/dua_entity.dart';

/// RAGConfidenceWidget class implementation
class RAGConfidenceWidget extends StatefulWidget {
  final RAGConfidence confidence;
  final bool showDetailed;
  final VoidCallback? onExpandToggle;

  const RAGConfidenceWidget({
    super.key,
    required this.confidence,
    this.showDetailed = false,
    this.onExpandToggle,
  });

  @override
  State<RAGConfidenceWidget> createState() => _RAGConfidenceWidgetState();
}

/// _RAGConfidenceWidgetState class implementation
class _RAGConfidenceWidgetState extends State<RAGConfidenceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    if (widget.showDetailed) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(RAGConfidenceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showDetailed != oldWidget.showDetailed) {
      if (widget.showDetailed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getConfidenceColor().withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getConfidenceColor().withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with confidence score
          _buildHeader(),

          // Detailed information (expandable)
          if (widget.showDetailed)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, _slideAnimation.value),
                      end: const Offset(0, 0),
                    ).animate(_animationController),
                    child: _buildDetailedContent(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: widget.onExpandToggle,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // AI Icon with animated background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getConfidenceColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.psychology_rounded,
                color: _getConfidenceColor(),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Confidence info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AI Confidence',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildConfidenceBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getConfidenceDescription(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Expand/collapse indicator
            if (widget.onExpandToggle != null)
              AnimatedRotation(
                turns: widget.showDetailed ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getConfidenceColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${(widget.confidence.score * 100).toInt()}%',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetailedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 12),

          // Reasoning explanation
          _buildSection(
            'Why this Du\'a was recommended:',
            widget.confidence.reasoning,
            Icons.lightbulb_outline_rounded,
          ),

          const SizedBox(height: 16),

          // Keywords and context
          _buildKeywordsSection(),

          const SizedBox(height: 16),

          // Context match details
          _buildContextMatchSection(),

          if (widget.confidence.supportingEvidence.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSupportingEvidence(),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.4,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildKeywordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Matched Keywords:',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.confidence.keywords.map((keyword) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                keyword,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContextMatchSection() {
    final contextMatch = widget.confidence.contextMatch;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Context Analysis:',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getRelevanceColor(
                  contextMatch.relevanceScore,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(contextMatch.relevanceScore * 100).toInt()}% match',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getRelevanceColor(contextMatch.relevanceScore),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Context details
        ...contextMatch.matchingCriteria.map((criteria) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    criteria,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSupportingEvidence() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.verified_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Supporting Evidence:',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.confidence.supportingEvidence.map((evidence) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                evidence,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _getConfidenceColor() {
    if (widget.confidence.score >= 0.8) {
      return Colors.green;
    } else if (widget.confidence.score >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getRelevanceColor(double score) {
    if (score >= 0.8) {
      return Colors.green;
    } else if (score >= 0.6) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  String _getConfidenceDescription() {
    if (widget.confidence.score >= 0.9) {
      return 'Highly confident match';
    } else if (widget.confidence.score >= 0.7) {
      return 'Good confidence level';
    } else if (widget.confidence.score >= 0.5) {
      return 'Moderate confidence';
    } else {
      return 'Low confidence match';
    }
  }
}
