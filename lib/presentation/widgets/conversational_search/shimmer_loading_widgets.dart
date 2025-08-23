import 'package:flutter/material.dart';

/// ShimmerEffect class implementation
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

/// _ShimmerEffectState class implementation
class _ShimmerEffectState extends State<ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.period, vsync: this);
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, highlightColor, baseColor],
              stops:
                  [
                    _animation.value - 0.3,
                    _animation.value,
                    _animation.value + 0.3,
                  ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// RAGLoadingWidget class implementation
class RAGLoadingWidget extends StatelessWidget {
  final String? message;
  final bool showPulse;

  const RAGLoadingWidget({super.key, this.message, this.showPulse = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPulse) _buildPulsingIcon(colorScheme),
          const SizedBox(height: 16),
          _buildShimmerText(context),
          const SizedBox(height: 24),
          _buildLoadingCards(colorScheme),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPulsingIcon(ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.primaryContainer]),
              boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
            ),
            child: Icon(Icons.auto_awesome, color: colorScheme.onPrimary, size: 30),
          ),
        );
      },
      onEnd: () {
        // This will cause the animation to repeat
      },
    );
  }

  Widget _buildShimmerText(BuildContext context) {
    return Column(
      children: [
        ShimmerEffect(
          child: Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 8),
        ShimmerEffect(
          child: Container(
            height: 16,
            width: 160,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCards(ColorScheme colorScheme) {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ShimmerEffect(
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 200,
                      decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(6)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// TypingIndicator class implementation
class TypingIndicator extends StatefulWidget {
  final String text;
  final Duration typingSpeed;
  final TextStyle? textStyle;

  const TypingIndicator({
    super.key,
    required this.text,
    this.typingSpeed = const Duration(milliseconds: 50),
    this.textStyle,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

/// _TypingIndicatorState class implementation
class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late AnimationController _controller;
  String _displayText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.typingSpeed * widget.text.length, vsync: this);

    _startTyping();
  }

  void _startTyping() {
    _controller.addListener(() {
      final progress = _controller.value;
      final targetIndex = (progress * widget.text.length).floor();

      if (targetIndex > _currentIndex && _currentIndex < widget.text.length) {
        setState(() {
          _currentIndex = targetIndex;
          _displayText = widget.text.substring(0, _currentIndex);
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_displayText, style: widget.textStyle),
        if (_currentIndex < widget.text.length)
          Container(
            width: 2,
            height: 20,
            margin: const EdgeInsets.only(left: 2),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: (_controller.value * 2) % 1,
                  child: Container(color: Theme.of(context).colorScheme.primary),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// SearchResultShimmer class implementation
class SearchResultShimmer extends StatelessWidget {
  final int itemCount;

  const SearchResultShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ShimmerEffect(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(9)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(7)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(7)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 60,
                        decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(6)),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
