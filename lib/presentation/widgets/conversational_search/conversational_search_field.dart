import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../core/typography/arabic_typography.dart';

/// ConversationalSearchField class implementation
class ConversationalSearchField extends StatefulWidget {
  final String? hint;
  final Function(String) onSearch;
  final Function(String)? onTextChanged;
  final bool isLoading;
  final List<String> suggestions;
  final VoidCallback? onMicTapped;
  final bool supportArabic;
  final TextEditingController? controller;

  const ConversationalSearchField({
    super.key,
    this.hint,
    required this.onSearch,
    this.onTextChanged,
    this.isLoading = false,
    this.suggestions = const [],
    this.onMicTapped,
    this.supportArabic = true,
    this.controller,
  });

  @override
  State<ConversationalSearchField> createState() => _ConversationalSearchFieldState();
}

/// _ConversationalSearchFieldState class implementation
class _ConversationalSearchFieldState extends State<ConversationalSearchField> with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _micAnimationController;
  late Animation<double> _micAnimation;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;
  String _lastWords = '';

  OverlayEntry? _suggestionsOverlay;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    _micAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _micAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut));

    _initSpeech();
    _setupListeners();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onError: (error) {
        setState(() {
          _isListening = false;
        });
        _micAnimationController.stop();
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
          _micAnimationController.stop();
        }
      },
    );
    setState(() {});
  }

  void _setupListeners() {
    _controller.addListener(() {
      final text = _controller.text;
      widget.onTextChanged?.call(text);

      if (text.isNotEmpty && widget.suggestions.isNotEmpty) {
        _showSuggestions();
      } else {
        _hideSuggestions();
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _hideSuggestions();
      }
    });
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _lastWords = result.recognizedWords;
          _controller.text = _lastWords;
        });
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: widget.supportArabic ? 'ar-SA' : 'en-US',
      listenMode: stt.ListenMode.confirmation,
    );

    setState(() {
      _isListening = true;
    });

    _micAnimationController.repeat(reverse: true);
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
    _micAnimationController.stop();
  }

  void _showSuggestions() {
    _hideSuggestions();

    final filteredSuggestions =
        widget.suggestions
            .where(
              (suggestion) =>
                  suggestion.toLowerCase().contains(_controller.text.toLowerCase()) ||
                  _isArabicSimilar(suggestion, _controller.text),
            )
            .take(5)
            .toList();

    if (filteredSuggestions.isEmpty) return;

    _suggestionsOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            width: MediaQuery.of(context).size.width - 32,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 72),
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 280),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = filteredSuggestions[index];
                        return InkWell(
                          onTap: () {
                            _controller.text = suggestion;
                            _hideSuggestions();
                            widget.onSearch(suggestion);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.search_rounded,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_suggestionsOverlay!);
  }

  void _hideSuggestions() {
    _suggestionsOverlay?.remove();
    _suggestionsOverlay = null;
  }

  bool _isArabicSimilar(String suggestion, String query) {
    // Simple Arabic similarity check
    if (!widget.supportArabic) return false;

    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    final hasArabicSuggestion = arabicRegex.hasMatch(suggestion);
    final hasArabicQuery = arabicRegex.hasMatch(query);

    if (hasArabicSuggestion && hasArabicQuery) {
      // Basic Arabic root matching logic could be implemented here
      return suggestion.contains(query) || query.contains(suggestion);
    }

    return false;
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      widget.onSearch(value.trim());
      _hideSuggestions();
    }
  }

  @override
  void dispose() {
    _hideSuggestions();
    _micAnimationController.dispose();
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: colorScheme.surface,
          border: Border.all(
            color: _focusNode.hasFocus ? colorScheme.primary : colorScheme.outline.withOpacity(0.2),
            width: _focusNode.hasFocus ? 2 : 1,
          ),
          boxShadow:
              _focusNode.hasFocus
                  ? [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textDirection: ArabicTypography.getTextDirection(_controller.text),
          textAlign: ArabicTypography.getTextAlign(
            _controller.text,
            ArabicTypography.getTextDirection(_controller.text),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _onSubmitted,
          onChanged: (text) {
            // Update text direction dynamically as user types
            setState(() {});
            widget.onTextChanged?.call(text);
          },
          style: textTheme.bodyLarge
              ?.copyWith(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5)
              .merge(
                ArabicTypography.containsArabic(_controller.text)
                    ? ArabicTextStyles.bodyLarge(context, fontType: 'readable')
                    : null,
              ),
          decoration: InputDecoration(
            hintText:
                widget.supportArabic
                    ? 'Ask about duas, verses, and Islamic guidance... | اسأل عن الأدعية والآيات والإرشادات الإسلامية...'
                    : 'Ask about duas, verses, and Islamic guidance...',
            hintStyle: textTheme.bodyLarge
                ?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
                .merge(
                  widget.supportArabic && ArabicTypography.containsArabic(_controller.text)
                      ? ArabicTextStyles.bodyMedium(context, fontType: 'readable')
                      : null,
                ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            prefixIcon: Container(
              padding: const EdgeInsets.all(16),
              child: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant.withOpacity(0.6), size: 24),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isLoading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                  )
                else if (_speechEnabled) ...[
                  GestureDetector(
                    onTap: _isListening ? _stopListening : _startListening,
                    child: AnimatedBuilder(
                      animation: _micAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isListening ? _micAnimation.value : 1.0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration:
                                _isListening
                                    ? BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle)
                                    : null,
                            child: Icon(
                              _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                              color: _isListening ? colorScheme.primary : colorScheme.onSurfaceVariant.withOpacity(0.6),
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (_controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      _hideSuggestions();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant.withOpacity(0.6), size: 20),
                    ),
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
