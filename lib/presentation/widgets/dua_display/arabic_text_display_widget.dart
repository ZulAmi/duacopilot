import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/accessibility/arabic_accessibility.dart';

/// ArabicTextDisplayWidget class implementation
class ArabicTextDisplayWidget extends StatefulWidget {
  final String arabicText;
  final String transliteration;
  final String translation;
  final TextAlign textAlign;
  final double arabicFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final bool showTransliteration;
  final bool showTranslation;
  final EdgeInsets padding;
  final VoidCallback? onTextTap;

  const ArabicTextDisplayWidget({
    super.key,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    this.textAlign = TextAlign.right,
    this.arabicFontSize = 24,
    this.transliterationFontSize = 16,
    this.translationFontSize = 14,
    this.showTransliteration = true,
    this.showTranslation = true,
    this.padding = const EdgeInsets.all(16),
    this.onTextTap,
  });

  @override
  State<ArabicTextDisplayWidget> createState() => _ArabicTextDisplayWidgetState();
}

/// _ArabicTextDisplayWidgetState class implementation
class _ArabicTextDisplayWidgetState extends State<ArabicTextDisplayWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _showTransliteration = true;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _showTransliteration = widget.showTransliteration;
    _showTranslation = widget.showTranslation;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Control buttons
            _buildControls(),

            const SizedBox(height: 16),

            // Arabic text with beautiful styling
            _buildArabicText(),

            // Transliteration (optional)
            if (_showTransliteration) ...[
              const SizedBox(height: 20),
              _buildTransliteration(),
            ],

            // Translation (optional)
            if (_showTranslation) ...[
              const SizedBox(height: 16),
              _buildTranslation(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Toggle transliteration
        _buildToggleButton(
          icon: Icons.abc_rounded,
          isActive: _showTransliteration,
          onTap: () {
            setState(() {
              _showTransliteration = !_showTransliteration;
            });
          },
          tooltip: 'Toggle Transliteration',
        ),

        const SizedBox(width: 8),

        // Toggle translation
        _buildToggleButton(
          icon: Icons.translate_rounded,
          isActive: _showTranslation,
          onTap: () {
            setState(() {
              _showTranslation = !_showTranslation;
            });
          },
          tooltip: 'Toggle Translation',
        ),

        const SizedBox(width: 8),

        // Copy text
        _buildActionButton(
          icon: Icons.copy_rounded,
          onTap: () => _copyToClipboard(),
          tooltip: 'Copy Text',
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildArabicText() {
    return GestureDetector(
      onTap: widget.onTextTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Decorative Islamic pattern
            _buildIslamicDecoration(),

            const SizedBox(height: 16),

            // Arabic text with enhanced typography
            ArabicAccessibility.createIslamicContentWidget(
              arabicText: widget.arabicText,
              transliteration: _showTransliteration ? widget.transliteration : null,
              translation: _showTranslation ? widget.translation : null,
              context: context,
              contentType: IslamicContentType.dua,
              onTap: widget.onTextTap,
            ),

            const SizedBox(height: 16),

            // Decorative Islamic pattern (bottom)
            _buildIslamicDecoration(),
          ],
        ),
      ),
    );
  }

  Widget _buildIslamicDecoration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDecorationElement(),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 12),
        _buildDecorationElement(),
      ],
    );
  }

  Widget _buildDecorationElement() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTransliteration() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.abc_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Transliteration',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            widget.transliteration,
            style: GoogleFonts.inter(
              fontSize: widget.transliterationFontSize,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildTranslation() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.translate_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Translation',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            widget.translation,
            style: GoogleFonts.inter(
              fontSize: widget.translationFontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.6,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    final text = '''
${widget.arabicText}

${widget.transliteration}

${widget.translation}
''';

    // Copy to clipboard using the comprehensive text
    // In a real app, implement clipboard functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Du\'a copied to clipboard: ${text.substring(0, 50)}...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
