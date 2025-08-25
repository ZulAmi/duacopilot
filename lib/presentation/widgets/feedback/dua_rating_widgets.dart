import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Custom rating widget for Du'a relevance with Islamic theming
class DuaRelevanceRatingWidget extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingUpdate;
  final String? duaId;
  final String? queryId;
  final bool readOnly;
  final String style;

  const DuaRelevanceRatingWidget({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingUpdate,
    this.duaId,
    this.queryId,
    this.readOnly = false,
    this.style = 'modern',
  });

  @override
  State<DuaRelevanceRatingWidget> createState() => _DuaRelevanceRatingWidgetState();
}

class _DuaRelevanceRatingWidgetState extends State<DuaRelevanceRatingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _currentRating = 0.0;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
    _hasRated = widget.initialRating > 0;

    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onRatingChanged(double rating) {
    setState(() {
      _currentRating = rating;
      _hasRated = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Scale animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onRatingUpdate(rating);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor.withOpacity(0.1), theme.primaryColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'How relevant was this Du\'a to your query?',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.primaryColor),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Rating Widget
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder:
                (context, child) => Transform.scale(scale: _scaleAnimation.value, child: _buildRatingWidget(theme)),
          ),

          const SizedBox(height: 12),

          // Rating Text
          if (_hasRated) ...[
            Text(
              _getRatingText(_currentRating),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _getRatingColor(_currentRating),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Additional Context
          if (_hasRated && _currentRating < 3.0) ...[
            Text(
              'Thank you for your feedback. We\'ll use this to improve our recommendations.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingWidget(ThemeData theme) {
    switch (widget.style) {
      case 'stars':
        return _buildStarsRating(theme);
      case 'hearts':
        return _buildHeartsRating(theme);
      case 'thumbs':
        return _buildThumbsRating(theme);
      case 'modern':
      default:
        return _buildModernRating(theme);
    }
  }

  Widget _buildModernRating(ThemeData theme) {
    return RatingBar.builder(
      initialRating: _currentRating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 40,
      ignoreGestures: widget.readOnly,
      itemBuilder:
          (context, index) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(Icons.star_rounded, color: Colors.white, size: 24),
          ),
      onRatingUpdate: _onRatingChanged,
      unratedColor: theme.primaryColor.withOpacity(0.2),
      glowColor: theme.primaryColor.withOpacity(0.6),
      glow: true,
      glowRadius: 2,
    );
  }

  Widget _buildStarsRating(ThemeData theme) {
    return RatingBar.builder(
      initialRating: _currentRating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 35,
      ignoreGestures: widget.readOnly,
      itemBuilder: (context, _) => Icon(Icons.star, color: theme.primaryColor),
      onRatingUpdate: _onRatingChanged,
      unratedColor: theme.primaryColor.withOpacity(0.3),
    );
  }

  Widget _buildHeartsRating(ThemeData theme) {
    return RatingBar.builder(
      initialRating: _currentRating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 35,
      ignoreGestures: widget.readOnly,
      itemBuilder: (context, _) => Icon(Icons.favorite, color: Colors.red),
      onRatingUpdate: _onRatingChanged,
      unratedColor: Colors.red.withOpacity(0.3),
    );
  }

  Widget _buildThumbsRating(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildThumbButton(
          icon: Icons.thumb_down,
          isSelected: _currentRating == 1.0,
          onTap: () => _onRatingChanged(1.0),
          color: Colors.red,
        ),
        _buildThumbButton(
          icon: Icons.thumb_up,
          isSelected: _currentRating == 5.0,
          onTap: () => _onRatingChanged(5.0),
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildThumbButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: widget.readOnly ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : color, size: 24),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating <= 1.0) return 'Not relevant';
    if (rating <= 2.0) return 'Slightly relevant';
    if (rating <= 3.0) return 'Moderately relevant';
    if (rating <= 4.0) return 'Very relevant';
    return 'Perfectly relevant';
  }

  Color _getRatingColor(double rating) {
    if (rating <= 2.0) return Colors.red;
    if (rating <= 3.0) return Colors.orange;
    if (rating <= 4.0) return Colors.blue;
    return Colors.green;
  }
}

/// Quick rating widget for simple interactions
class QuickDuaRatingWidget extends StatelessWidget {
  final ValueChanged<double> onRatingUpdate;
  final String? duaId;
  final bool showLabel;

  const QuickDuaRatingWidget({super.key, required this.onRatingUpdate, this.duaId, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[Text('Rate:', style: theme.textTheme.bodySmall), const SizedBox(width: 8)],
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 20,
          itemBuilder: (context, _) => Icon(Icons.star, color: theme.primaryColor),
          onRatingUpdate: (rating) {
            HapticFeedback.selectionClick();
            onRatingUpdate(rating);
          },
          unratedColor: theme.primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }
}

/// Animated rating display widget
class AnimatedRatingDisplayWidget extends StatefulWidget {
  final double rating;
  final int totalRatings;
  final String? contentId;

  const AnimatedRatingDisplayWidget({super.key, required this.rating, required this.totalRatings, this.contentId});

  @override
  State<AnimatedRatingDisplayWidget> createState() => _AnimatedRatingDisplayWidgetState();
}

class _AnimatedRatingDisplayWidgetState extends State<AnimatedRatingDisplayWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ratingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _ratingAnimation = Tween<double>(
      begin: 0.0,
      end: widget.rating,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedRatingDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating) {
      _ratingAnimation = Tween<double>(
        begin: oldWidget.rating,
        end: widget.rating,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _ratingAnimation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBarIndicator(
              rating: _ratingAnimation.value,
              itemBuilder: (context, _) => Icon(Icons.star, color: theme.primaryColor),
              itemCount: 5,
              itemSize: 16,
              unratedColor: theme.primaryColor.withOpacity(0.3),
            ),
            const SizedBox(width: 8),
            Text(
              '${_ratingAnimation.value.toStringAsFixed(1)} (${widget.totalRatings})',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
        );
      },
    );
  }
}
