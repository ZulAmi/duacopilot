import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ArabicKeyboardController class implementation
class ArabicKeyboardController extends ChangeNotifier {
  bool _isArabicMode = false;
  bool _isShiftPressed = false;
  String _currentInput = '';
  final TextEditingController _textController;

  ArabicKeyboardController(this._textController);

  bool get isArabicMode => _isArabicMode;
  bool get isShiftPressed => _isShiftPressed;
  String get currentInput => _currentInput;

  void toggleArabicMode() {
    _isArabicMode = !_isArabicMode;
    notifyListeners();
  }

  void setShiftPressed(bool pressed) {
    _isShiftPressed = pressed;
    notifyListeners();
  }

  void insertText(String text) {
    final currentText = _textController.text;
    final selection = _textController.selection;

    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );

    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(
      offset: selection.start + text.length,
    );

    _currentInput = newText;
    notifyListeners();
  }

  void deleteText() {
    final currentText = _textController.text;
    final selection = _textController.selection;

    if (selection.start > 0) {
      final newText = currentText.replaceRange(
        selection.start - 1,
        selection.end,
        '',
      );

      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(
        offset: selection.start - 1,
      );

      _currentInput = newText;
      notifyListeners();
    }
  }

  void clearText() {
    _textController.clear();
    _currentInput = '';
    notifyListeners();
  }
}

/// ArabicKeyboardWidget class implementation
class ArabicKeyboardWidget extends StatefulWidget {
  final ArabicKeyboardController controller;
  final VoidCallback? onDone;
  final bool showTransliteration;
  final double height;

  const ArabicKeyboardWidget({
    super.key,
    required this.controller,
    this.onDone,
    this.showTransliteration = true,
    this.height = 300,
  });

  @override
  State<ArabicKeyboardWidget> createState() => _ArabicKeyboardWidgetState();
}

/// _ArabicKeyboardWidgetState class implementation
class _ArabicKeyboardWidgetState extends State<ArabicKeyboardWidget> {
  final Map<String, String> _transliterationMap = {
    'ا': 'a',
    'ب': 'b',
    'ت': 't',
    'ث': 'th',
    'ج': 'j',
    'ح': 'h',
    'خ': 'kh',
    'د': 'd',
    'ذ': 'dh',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': 'sh',
    'ص': 's',
    'ض': 'd',
    'ط': 't',
    'ظ': 'z',
    'ع': 'a',
    'غ': 'gh',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'و': 'w',
    'ي': 'y',
    'ة': 'h',
    'ى': 'a',
    'ء': "'",
    'ئ': "'",
    'ؤ': "'",
    'لا': 'la',
  };

  final List<String> _diacritics = [
    'ً', // Fathatan
    'ٌ', // Dammatan
    'ٍ', // Kasratan
    'َ', // Fatha
    'ُ', // Damma
    'ِ', // Kasra
    'ّ', // Shadda
    'ْ', // Sukun
    'ٓ', // Maddah Above
    'ٔ', // Hamza Above
    'ٕ', // Hamza Below
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildKeyboardHeader(),
          Expanded(
            child: widget.controller.isArabicMode ? _buildArabicKeyboard() : _buildEnglishKeyboard(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.controller.toggleArabicMode,
            icon: Icon(
              Icons.language,
              color: widget.controller.isArabicMode ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            widget.controller.isArabicMode ? 'عربي' : 'English',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const Spacer(),
          if (widget.showTransliteration && widget.controller.isArabicMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Transliteration',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
          const SizedBox(width: 8),
          if (widget.onDone != null)
            IconButton(
              onPressed: widget.onDone,
              icon: Icon(
                Icons.keyboard_hide,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArabicKeyboard() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // First row
          _buildKeyboardRow([
            'ض',
            'ص',
            'ث',
            'ق',
            'ف',
            'غ',
            'ع',
            'ه',
            'خ',
            'ح',
            'ج',
          ]),
          const SizedBox(height: 4),

          // Second row
          _buildKeyboardRow([
            'ش',
            'س',
            'ي',
            'ب',
            'ل',
            'ا',
            'ت',
            'ن',
            'م',
            'ك',
            'ط',
          ]),
          const SizedBox(height: 4),

          // Third row
          Row(
            children: [
              _buildActionKey(
                Icons.keyboard_arrow_up,
                () {
                  widget.controller.setShiftPressed(
                    !widget.controller.isShiftPressed,
                  );
                },
                isToggle: true,
                isActive: widget.controller.isShiftPressed,
              ),
              const SizedBox(width: 4),
              ..._buildKeyboardRowKeys([
                'ئ',
                'ء',
                'ؤ',
                'ر',
                'لا',
                'ى',
                'ة',
                'و',
                'ز',
                'ظ',
              ]),
              const SizedBox(width: 4),
              _buildActionKey(Icons.backspace, widget.controller.deleteText),
            ],
          ),
          const SizedBox(height: 4),

          // Diacritics row
          if (widget.controller.isShiftPressed) _buildDiacriticsRow(),

          // Bottom row
          Row(
            children: [
              _buildActionKey(
                Icons.language,
                widget.controller.toggleArabicMode,
              ),
              const SizedBox(width: 4),
              _buildSpaceKey(),
              const SizedBox(width: 4),
              _buildKey('.'),
              const SizedBox(width: 4),
              if (widget.onDone != null) _buildActionKey(Icons.done, widget.onDone!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnglishKeyboard() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // QWERTY rows
          _buildKeyboardRow(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']),
          const SizedBox(height: 4),
          _buildKeyboardRow(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l']),
          const SizedBox(height: 4),

          Row(
            children: [
              _buildActionKey(
                Icons.keyboard_arrow_up,
                () {
                  widget.controller.setShiftPressed(
                    !widget.controller.isShiftPressed,
                  );
                },
                isToggle: true,
                isActive: widget.controller.isShiftPressed,
              ),
              const SizedBox(width: 4),
              ..._buildKeyboardRowKeys(['z', 'x', 'c', 'v', 'b', 'n', 'm']),
              const SizedBox(width: 4),
              _buildActionKey(Icons.backspace, widget.controller.deleteText),
            ],
          ),
          const SizedBox(height: 4),

          // Bottom row
          Row(
            children: [
              _buildActionKey(
                Icons.language,
                widget.controller.toggleArabicMode,
              ),
              const SizedBox(width: 4),
              _buildSpaceKey(),
              const SizedBox(width: 4),
              _buildKey('.'),
              const SizedBox(width: 4),
              if (widget.onDone != null) _buildActionKey(Icons.done, widget.onDone!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildKeyboardRowKeys(keys),
    );
  }

  List<Widget> _buildKeyboardRowKeys(List<String> keys) {
    return keys.map((key) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: _buildKey(key),
        ),
      );
    }).toList();
  }

  Widget _buildKey(String key) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayKey = widget.controller.isShiftPressed && !widget.controller.isArabicMode ? key.toUpperCase() : key;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.controller.insertText(displayKey);
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayKey,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (widget.showTransliteration &&
                    widget.controller.isArabicMode &&
                    _transliterationMap.containsKey(key))
                  Text(
                    _transliterationMap[key]!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          fontSize: 10,
                        ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(
    IconData icon,
    VoidCallback onTap, {
    bool isToggle = false,
    bool isActive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isToggle && isActive ? colorScheme.primary : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isToggle && isActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSpaceKey() {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      flex: 4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.controller.insertText(' ');
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Center(child: Text('Space')),
          ),
        ),
      ),
    );
  }

  Widget _buildDiacriticsRow() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _diacritics.length,
        itemBuilder: (context, index) {
          final diacritic = _diacritics[index];
          return Container(
            width: 40,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.controller.insertText(diacritic);
                  HapticFeedback.lightImpact();
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      diacritic,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ArabicInputField class implementation
class ArabicInputField extends StatefulWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enableKeyboard;
  final bool showTransliteration;
  final TextEditingController? controller;

  const ArabicInputField({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.enableKeyboard = true,
    this.showTransliteration = true,
    this.controller,
  });

  @override
  State<ArabicInputField> createState() => _ArabicInputFieldState();
}

/// _ArabicInputFieldState class implementation
class _ArabicInputFieldState extends State<ArabicInputField> {
  late TextEditingController _textController;
  late ArabicKeyboardController _keyboardController;
  bool _showKeyboard = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _keyboardController = ArabicKeyboardController(_textController);

    _keyboardController.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_keyboardController.currentInput);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textController.dispose();
    }
    _keyboardController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.enableKeyboard) {
              setState(() {
                _showKeyboard = !_showKeyboard;
              });
            } else {
              _focusNode.requestFocus();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _textController.text.isEmpty
                        ? (widget.hintText ?? 'Type in Arabic or English...')
                        : _textController.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _textController.text.isEmpty
                              ? Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant.withOpacity(0.6)
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                    textDirection: _isArabicText(_textController.text) ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
                if (widget.enableKeyboard)
                  Icon(
                    _showKeyboard ? Icons.keyboard_hide : Icons.keyboard,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
        if (_showKeyboard && widget.enableKeyboard)
          ArabicKeyboardWidget(
            controller: _keyboardController,
            showTransliteration: widget.showTransliteration,
            onDone: () {
              setState(() {
                _showKeyboard = false;
              });
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(_textController.text);
              }
            },
          ),
      ],
    );
  }

  bool _isArabicText(String text) {
    if (text.isEmpty) return false;

    final arabicRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );
    final arabicChars = arabicRegex.allMatches(text).length;
    return arabicChars > text.length * 0.3; // If more than 30% Arabic characters
  }
}
