import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/dua_entity.dart';
import '../../services/favorites_service.dart';
import '../../services/dua_share_service.dart';
import '../widgets/dua_display/arabic_text_display_widget.dart';
import '../widgets/dua_display/rag_confidence_widget.dart';
import '../widgets/dua_display/authenticity_badge_widget.dart';
import '../widgets/dua_display/dua_audio_player_widget.dart';

/// DuaDisplayScreen class implementation
class DuaDisplayScreen extends StatefulWidget {
  final DuaEntity dua;
  final List<DuaEntity> relatedDuas;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShare;
  final Function(DuaEntity)? onRelatedDuaTap;

  const DuaDisplayScreen({
    super.key,
    required this.dua,
    this.relatedDuas = const [],
    this.onFavoriteToggle,
    this.onShare,
    this.onRelatedDuaTap,
  });

  @override
  State<DuaDisplayScreen> createState() => _DuaDisplayScreenState();
}

/// _DuaDisplayScreenState class implementation
class _DuaDisplayScreenState extends State<DuaDisplayScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late PageController _relatedDuasController;

  bool _showRAGDetails = false;
  bool _showAuthenticityDetails = false;
  int _currentRelatedIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _slideController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _relatedDuasController = PageController();

    _fadeController.forward();
    _loadFavoriteStatus();
    _addToRecentlyViewed();
  }

  void _loadFavoriteStatus() async {
    final isFav = await FavoritesService.isFavorite(widget.dua.id);
    setState(() {
      _isFavorite = isFav;
    });
  }

  void _addToRecentlyViewed() async {
    await FavoritesService.addToRecentlyViewed(widget.dua);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _relatedDuasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),

            // Main Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Du'a Header with category and tags
                      _buildDuaHeader(),

                      const SizedBox(height: 20),

                      // Arabic Text Display
                      ArabicTextDisplayWidget(
                        arabicText: widget.dua.arabicText,
                        transliteration: widget.dua.transliteration,
                        translation: widget.dua.translation,
                      ),

                      const SizedBox(height: 20),

                      // Audio Player (if available)
                      DuaAudioPlayerWidget(
                        audioUrl: widget.dua.audioUrl,
                        duaTitle: widget.dua.category,
                        onDownload: () => _downloadAudio(),
                      ),

                      const SizedBox(height: 20),

                      // RAG Confidence Widget
                      RAGConfidenceWidget(
                        confidence: widget.dua.ragConfidence,
                        showDetailed: _showRAGDetails,
                        onExpandToggle: () {
                          setState(() {
                            _showRAGDetails = !_showRAGDetails;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Source Authenticity Badge
                      AuthenticityBadgeWidget(
                        authenticity: widget.dua.authenticity,
                        showDetailed: _showAuthenticityDetails,
                        onTap: () {
                          setState(() {
                            _showAuthenticityDetails = !_showAuthenticityDetails;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Context and Benefits (if available)
                      if (widget.dua.context != null || widget.dua.benefits != null) _buildContextAndBenefits(),

                      const SizedBox(height: 20),

                      // Related Du'as Carousel
                      if (widget.relatedDuas.isNotEmpty) _buildRelatedDuasSection(),

                      const SizedBox(height: 20),

                      // Action Buttons
                      _buildActionButtons(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Du\'a Details',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  widget.dua.category,
                  style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // Favorite button
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface,
            ),
          ),

          // Share button
          IconButton(
            onPressed: _shareDua,
            icon: Icon(Icons.share_rounded, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildDuaHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.secondary.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.mosque_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.dua.category,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tags
          if (widget.dua.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.dua.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 1),
                      ),
                      child: Text(
                        tag,
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
      ),
    );
  }

  Widget _buildContextAndBenefits() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.dua.context != null) ...[
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Context',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.dua.context!,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          if (widget.dua.context != null && widget.dua.benefits != null) const SizedBox(height: 16),

          if (widget.dua.benefits != null) ...[
            Row(
              children: [
                Icon(Icons.star_outline_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Benefits',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.dua.benefits!,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRelatedDuasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Related Du\'as',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              'Based on semantic similarity',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _relatedDuasController,
            itemCount: widget.relatedDuas.length,
            onPageChanged: (index) {
              setState(() {
                _currentRelatedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final relatedDua = widget.relatedDuas[index];
              return Container(margin: const EdgeInsets.only(right: 12), child: _buildRelatedDuaCard(relatedDua));
            },
          ),
        ),

        // Page indicator
        if (widget.relatedDuas.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.relatedDuas.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color:
                      index == _currentRelatedIndex
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRelatedDuaCard(DuaEntity dua) {
    return GestureDetector(
      onTap: () => widget.onRelatedDuaTap?.call(dua),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1), width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dua.category,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Text(
                dua.translation,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(dua.ragConfidence.score * 100).toInt()}% match',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _shareDua,
            icon: Icon(Icons.share_rounded),
            label: Text('Share Du\'a'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
            label: Text(_isFavorite ? 'Saved' : 'Save'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  void _downloadAudio() {
    // Implement audio download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Audio download started'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _toggleFavorite() async {
    await FavoritesService.toggleFavorite(widget.dua.id);
    final newStatus = await FavoritesService.isFavorite(widget.dua.id);
    setState(() {
      _isFavorite = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _shareDua() async {
    await DuaShareService.shareDua(widget.dua);
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Share Du\'a', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                ListTile(
                  leading: Icon(Icons.share_rounded),
                  title: Text('Share Full Du\'a'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareDua();
                  },
                ),

                ListTile(
                  leading: Icon(Icons.copy_rounded),
                  title: Text('Copy to Clipboard'),
                  onTap: () async {
                    Navigator.pop(context);
                    await DuaShareService.copyToClipboard(widget.dua);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Du\'a copied to clipboard')));
                  },
                ),

                if (widget.dua.audioUrl != null)
                  ListTile(
                    leading: Icon(Icons.audiotrack_rounded),
                    title: Text('Share Audio Link'),
                    onTap: () async {
                      Navigator.pop(context);
                      await DuaShareService.shareAudioLink(widget.dua);
                    },
                  ),
              ],
            ),
          ),
    );
  }
}
