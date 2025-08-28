import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../typography/arabic_typography.dart';

/// Enhanced Arabic Text Input Widget with comprehensive RTL support
///
/// Features:
/// - Automatic text direction detection and switching
/// - Custom Arabic keyboard suggestions
/// - Proper text selection handling for RTL content
/// - Mixed content support (Arabic + English)
/// - Accessibility enhancements for Arabic text
/// - Platform-optimized input behavior
class ArabicTextInputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final InputDecoration? decoration;
  final bool enableInteractiveSelection;
  final bool showCursor;
  final double cursorHeight;
  final Color? cursorColor;
  final bool readOnly;
  final bool enabled;

  const ArabicTextInputWidget({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.textStyle,
    this.hintStyle,
    this.keyboardType,
    this.inputFormatters,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.decoration,
    this.enableInteractiveSelection = true,
    this.showCursor = true,
    this.cursorHeight = 2.0,
    this.cursorColor,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<ArabicTextInputWidget> createState() => _ArabicTextInputWidgetState();
}

class _ArabicTextInputWidgetState extends State<ArabicTextInputWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  TextDirection _currentDirection = TextDirection.ltr;
  TextAlign _currentAlignment = TextAlign.start;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Listen to text changes to update direction
    _controller.addListener(_updateTextDirection);

    // Set initial direction
    _updateTextDirection();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateTextDirection);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _updateTextDirection() {
    final text = _controller.text;
    final newDirection = ArabicTypography.getTextDirection(text);
    final newAlignment = ArabicTypography.getTextAlign(text, newDirection);

    if (newDirection != _currentDirection || newAlignment != _currentAlignment) {
      setState(() {
        _currentDirection = newDirection;
        _currentAlignment = newAlignment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = _currentDirection == TextDirection.rtl;

    // Create enhanced text style for Arabic content
    TextStyle? effectiveTextStyle = widget.textStyle;
    if (isRTL && ArabicTypography.containsArabic(_controller.text)) {
      effectiveTextStyle = ArabicTypography.getArabicGoogleFont(
        'readable',
        fontSize: widget.textStyle?.fontSize ?? 16,
        fontWeight: widget.textStyle?.fontWeight ?? FontWeight.normal,
        color: widget.textStyle?.color ?? theme.colorScheme.onSurface,
      );
    }

    // Create RTL-aware decoration
    final decoration = widget.decoration ??
        InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: widget.hintStyle,
          prefixIcon: isRTL ? widget.suffixIcon : widget.prefixIcon,
          suffixIcon: isRTL ? widget.prefixIcon : widget.suffixIcon,
          contentPadding: widget.contentPadding,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        );

    return Directionality(
      textDirection: _currentDirection,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: effectiveTextStyle,
        textAlign: _currentAlignment,
        textDirection: _currentDirection,
        keyboardType: widget.keyboardType,
        inputFormatters: [
          ...widget.inputFormatters ?? [],
          _ArabicTextInputFormatter(),
        ],
        autofocus: widget.autofocus,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        obscureText: widget.obscureText,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        textCapitalization: widget.textCapitalization,
        onTap: widget.onTap,
        onChanged: (value) {
          widget.onChanged?.call(value);
          _updateTextDirection();
        },
        onSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        decoration: decoration,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        showCursor: widget.showCursor,
        cursorHeight: widget.cursorHeight,
        cursorColor: widget.cursorColor ?? theme.colorScheme.primary,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        selectionControls: _ArabicTextSelectionControls(),
      ),
    );
  }
}

/// Custom text input formatter for Arabic content
class _ArabicTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Normalize Arabic text input
    final normalizedText = _normalizeArabicInput(newValue.text);

    return newValue.copyWith(
      text: normalizedText,
      selection: newValue.selection,
    );
  }

  String _normalizeArabicInput(String text) {
    // Handle common Arabic input corrections
    return text
        // Fix common typing mistakes
        .replaceAll('ك', 'ك') // Replace garbled Kaf with proper Arabic Kaf (idempotent)
        .replaceAll('ي', 'ي') // Normalize Yeh variations (idempotent)
        // Add intelligent space handling for Arabic
        .replaceAllMapped(RegExp(r'([^\u0600-\u06FF\s])([^\u0600-\u06FF\s])'), (
      match,
    ) {
      return '${match.group(1)} ${match.group(2)}';
    });
  }
}

/// Custom text selection controls optimized for Arabic
class _ArabicTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Swap handles for RTL text
    TextSelectionHandleType adjustedType = type;
    if (isRTL) {
      switch (type) {
        case TextSelectionHandleType.left:
          adjustedType = TextSelectionHandleType.right;
          break;
        case TextSelectionHandleType.right:
          adjustedType = TextSelectionHandleType.left;
          break;
        case TextSelectionHandleType.collapsed:
          adjustedType = TextSelectionHandleType.collapsed;
          break;
      }
    }

    return super.buildHandle(context, adjustedType, textLineHeight, onTap);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    // Slightly larger handles for Arabic text selection
    return Size(24.0, textLineHeight + 8.0);
  }
}

/// Enhanced Arabic TextField with built-in suggestions
class ArabicSuggestionTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final List<String> suggestions;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSuggestionSelected;
  final int maxSuggestions;
  final TextStyle? textStyle;
  final TextStyle? suggestionStyle;
  final bool showSuggestions;

  const ArabicSuggestionTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suggestions = const [],
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.maxSuggestions = 5,
    this.textStyle,
    this.suggestionStyle,
    this.showSuggestions = true,
  });

  @override
  State<ArabicSuggestionTextField> createState() => _ArabicSuggestionTextFieldState();
}

class _ArabicSuggestionTextFieldState extends State<ArabicSuggestionTextField> {
  late TextEditingController _controller;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _removeOverlay();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text.toLowerCase();
    if (text.isEmpty || !widget.showSuggestions) {
      _removeOverlay();
      return;
    }

    // Filter suggestions based on Arabic text matching
    _filteredSuggestions = widget.suggestions
        .where((suggestion) {
          final normalizedSuggestion = ArabicTypography.normalizeArabicText(
            suggestion.toLowerCase(),
          );
          final normalizedText = ArabicTypography.normalizeArabicText(text);
          return normalizedSuggestion.contains(normalizedText);
        })
        .take(widget.maxSuggestions)
        .toList();

    if (_filteredSuggestions.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }

    widget.onChanged?.call(_controller.text);
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 300, // Adjust width as needed
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60), // Position below the text field
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _filteredSuggestions[index];
                  final isArabic = ArabicTypography.containsArabic(
                    suggestion,
                  );

                  return ListTile(
                    dense: true,
                    title: Text(
                      suggestion,
                      style: widget.suggestionStyle ??
                          (isArabic
                              ? ArabicTextStyles.bodyMedium(
                                  context,
                                  fontType: 'readable',
                                )
                              : null),
                      textDirection: ArabicTypography.getTextDirection(
                        suggestion,
                      ),
                    ),
                    onTap: () {
                      _controller.text = suggestion;
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: suggestion.length),
                      );
                      widget.onSuggestionSelected?.call(suggestion);
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ArabicTextInputWidget(
        controller: _controller,
        hintText: widget.hintText,
        textStyle: widget.textStyle,
        onChanged: (value) => _onTextChanged(),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}

/// Arabic Text Form Field with validation support
class ArabicTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final AutovalidateMode? autovalidateMode;
  final InputDecoration? decoration;

  const ArabicTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.textStyle,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final text = controller?.text ?? initialValue ?? '';
    final textDirection = ArabicTypography.getTextDirection(text);

    return Directionality(
      textDirection: textDirection,
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        style: textStyle ??
            (ArabicTypography.containsArabic(text) ? ArabicTextStyles.bodyLarge(context, fontType: 'readable') : null),
        textDirection: textDirection,
        textAlign: ArabicTypography.getTextAlign(text, textDirection),
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        enabled: enabled,
        readOnly: readOnly,
        autovalidateMode: autovalidateMode,
        decoration: decoration ??
            InputDecoration(
              hintText: hintText,
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
      ),
    );
  }
}
