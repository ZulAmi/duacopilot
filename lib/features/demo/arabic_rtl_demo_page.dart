import 'package:flutter/material.dart';

import '../../core/accessibility/arabic_accessibility.dart';
import '../../core/layout/rtl_layout_support.dart';
import '../../core/platform/platform_arabic_fonts.dart';
import '../../core/typography/arabic_typography.dart';
import '../../core/widgets/arabic_text_input_widget.dart';

/// Comprehensive Arabic Text & RTL Support Demo Page
///
/// Showcases all implemented features:
/// - Arabic typography with different font styles
/// - RTL layout components
/// - Mixed text direction handling
/// - Accessibility features
/// - Text input and selection
/// - Platform-specific optimizations
class ArabicRTLDemoPage extends StatefulWidget {
  const ArabicRTLDemoPage({super.key});

  @override
  State<ArabicRTLDemoPage> createState() => _ArabicRTLDemoPageState();
}

class _ArabicRTLDemoPageState extends State<ArabicRTLDemoPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  bool _showHighContrast = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    PlatformArabicFontConfig.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _showHighContrast ? ArabicAccessibility.createHighContrastTheme(context) : Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const MixedTextDirectionWidget(
            text: 'Arabic Text & RTL Support Demo - Ø¹Ø±Ø¶ Ø§Ù„Ù†Øµ Ø§Ù„Ø¹Ø±Ø¨ÙŠ',
          ),
          actions: [
            IconButton(
              icon: Icon(
                _showHighContrast ? Icons.contrast : Icons.contrast_outlined,
              ),
              tooltip: 'Toggle High Contrast',
              onPressed: () {
                setState(() {
                  _showHighContrast = !_showHighContrast;
                });
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              const Tab(text: 'Typography - Ø§Ù„Ø®Ø·ÙˆØ·'),
              const Tab(text: 'Layout - Ø§Ù„ØªØ®Ø·ÙŠØ·'),
              const Tab(text: 'Input - Ø§Ù„Ø¥Ø¯Ø®Ø§Ù„'),
              const Tab(text: 'Mixed - Ù…Ø®ØªÙ„Ø·'),
              const Tab(text: 'Accessibility - Ø¥Ù…ÙƒØ§Ù†ÙŠØ© Ø§Ù„ÙˆØµÙˆÙ„'),
              const Tab(text: 'Tests - Ø§Ù„Ø§Ø®ØªØ¨Ø§Ø±Ø§Øª'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTypographyDemo(),
            _buildLayoutDemo(),
            _buildInputDemo(),
            _buildMixedContentDemo(),
            _buildAccessibilityDemo(),
            _buildTestsDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyDemo() {
    const arabicTexts = {
      'Quran': 'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„Ù‘Ù°Ù‡Ù Ø§Ù„Ø±ÙŽÙ‘Ø­Ù’Ù…Ù°Ù†Ù Ø§Ù„Ø±ÙŽÙ‘Ø­ÙÙŠÙ…Ù',
      'Du\'a': 'Ø±ÙŽØ¨ÙŽÙ‘Ù†ÙŽØ§ Ø¢ØªÙÙ†ÙŽØ§ ÙÙÙŠ Ø§Ù„Ø¯ÙÙ‘Ù†Ù’ÙŠÙŽØ§ Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹ ÙˆÙŽÙÙÙŠ Ø§Ù„Ø¢Ø®ÙØ±ÙŽØ©Ù Ø­ÙŽØ³ÙŽÙ†ÙŽØ©Ù‹',
      'Dhikr': 'Ø³ÙØ¨Ù’Ø­ÙŽØ§Ù†ÙŽ Ø§Ù„Ù„Ù‘Ù°Ù‡Ù ÙˆÙŽØ¨ÙØ­ÙŽÙ…Ù’Ø¯ÙÙ‡Ù Ø³ÙØ¨Ù’Ø­ÙŽØ§Ù†ÙŽ Ø§Ù„Ù„Ù‘Ù°Ù‡Ù Ø§Ù„Ù’Ø¹ÙŽØ¸ÙÙŠÙ…Ù',
      'Hadith': 'Ø¥ÙÙ†ÙŽÙ‘Ù…ÙŽØ§ Ø§Ù„Ø£ÙŽØ¹Ù’Ù…ÙŽØ§Ù„Ù Ø¨ÙØ§Ù„Ù†ÙÙ‘ÙŠÙŽÙ‘Ø§ØªÙ',
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Typography Section Header
        ArabicAccessibility.createAccessibleText(
          text: 'Arabic Typography Styles - Ø£Ù†Ù…Ø§Ø· Ø§Ù„Ø®Ø·ÙˆØ· Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
          context: context,
          isHeading: true,
        ),
        const SizedBox(height: 24),

        // Font Type Examples
        ...arabicTexts.entries.map((entry) {
          final fontType = entry.key.toLowerCase().contains('quran')
              ? 'quran'
              : entry.key.toLowerCase().contains('du')
                  ? 'traditional'
                  : entry.key.toLowerCase().contains('dhikr')
                      ? 'elegant'
                      : 'readable';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${entry.key} Style',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  AccessibleArabicText(
                    text: entry.value,
                    style: ArabicTextStyles.bodyLarge(
                      context,
                      fontType: fontType,
                    ),
                    semanticsLabel: '${entry.key}: ${entry.value}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Font Type: $fontType',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }),

        // Font Size Variations
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Font Size Variations - ØªØ¨Ø§ÙŠÙ† Ø£Ø­Ø¬Ø§Ù… Ø§Ù„Ø®Ø·',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...[
                  'Small (14)',
                  'Medium (18)',
                  'Large (24)',
                  'Extra Large (32)',
                ].asMap().entries.map((entry) {
                  final sizes = [14.0, 18.0, 24.0, 32.0];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡ Ø±Ø¨ Ø§Ù„Ø¹Ø§Ù„Ù…ÙŠÙ†',
                      style: ArabicTypography.getArabicGoogleFont(
                        'readable',
                        fontSize: sizes[entry.key],
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Layout Components Header
        ArabicAccessibility.createAccessibleText(
          text: 'RTL Layout Components - Ù…ÙƒÙˆÙ†Ø§Øª Ø§Ù„ØªØ®Ø·ÙŠØ·',
          context: context,
          isHeading: true,
        ),
        const SizedBox(height: 24),

        // RTL-Aware Row
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RTL-Aware Row - ØµÙ ÙŠØ¯Ø¹Ù… Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                RTLAwareRow(
                  content: 'Ø¹Ù†ØµØ± Ø£ÙˆÙ„',
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ø£ÙˆÙ„',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ø«Ø§Ù†ÙŠ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ø«Ø§Ù„Ø«',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // RTL-Aware Container
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RTL-Aware Container - Ø­Ø§ÙˆÙŠØ© ØªØ¯Ø¹Ù… Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                RTLAwareContainer(
                  content: 'Ù…Ø­ØªÙˆÙ‰ Ø¹Ø±Ø¨ÙŠ',
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Ù‡Ø°Ø§ Ù…Ø­ØªÙˆÙ‰ Ø¹Ø±Ø¨ÙŠ Ø¯Ø§Ø®Ù„ Ø­Ø§ÙˆÙŠØ© ÙŠØ¯Ø¹Ù… Ø§ØªØ¬Ø§Ù‡ Ø§Ù„Ù†Øµ Ù…Ù† Ø§Ù„ÙŠÙ…ÙŠÙ† Ø¥Ù„Ù‰ Ø§Ù„ÙŠØ³Ø§Ø±',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),

        // RTL Positioning Demo
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RTL Positioning - Ø§Ù„Ù…ÙˆØ§Ø¶Ø¹ Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      RTLAwarePositioned(
                        start: 16,
                        top: 16,
                        content: 'Ø§Ù„Ø¨Ø¯Ø§ÙŠØ©',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ø¨Ø¯Ø§ÙŠØ©',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RTLAwarePositioned(
                        end: 16,
                        top: 16,
                        content: 'Ø§Ù„Ù†Ù‡Ø§ÙŠØ©',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ù†Ù‡Ø§ÙŠØ©',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RTLAwarePositioned(
                        start: 16,
                        bottom: 16,
                        content: 'Ø§Ù„Ø£Ø³ÙÙ„',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ø£Ø³ÙÙ„ ÙŠØ³Ø§Ø±',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RTLAwarePositioned(
                        end: 16,
                        bottom: 16,
                        content: 'Ø£Ø³ÙÙ„ ÙŠÙ…ÙŠÙ†',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ø£Ø³ÙÙ„ ÙŠÙ…ÙŠÙ†',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Input Components Header
        ArabicAccessibility.createAccessibleText(
          text: 'Arabic Text Input - Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ù†Øµ Ø§Ù„Ø¹Ø±Ø¨ÙŠ',
          context: context,
          isHeading: true,
        ),
        const SizedBox(height: 24),

        // Arabic Text Input Widget
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enhanced Arabic Input - Ø¥Ø¯Ø®Ø§Ù„ Ù…Ø­Ø³Ù† Ù„Ù„Ø¹Ø±Ø¨ÙŠØ©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicTextInputWidget(
                  controller: _textController,
                  hintText: 'Ø£Ø¯Ø®Ù„ Ø§Ù„Ù†Øµ Ø§Ù„Ø¹Ø±Ø¨ÙŠ Ø£Ùˆ Ø§Ù„Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠ',
                  labelText: 'Ø§Ù„Ù†Øµ Ø§Ù„Ù…Ø®ØªÙ„Ø·',
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),

        // Arabic Suggestion Text Field
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arabic Suggestions - Ø§Ù‚ØªØ±Ø§Ø­Ø§Øª Ø¹Ø±Ø¨ÙŠØ©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicSuggestionTextField(
                  hintText: 'Ø§Ø¨Ø­Ø« Ø¹Ù† Ø¯Ø¹Ø§Ø¡ Ø£Ùˆ Ø°ÙƒØ±',
                  suggestions: const [
                    'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…',
                    'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡ Ø±Ø¨ Ø§Ù„Ø¹Ø§Ù„Ù…ÙŠÙ†',
                    'Ø³Ø¨Ø­Ø§Ù† Ø§Ù„Ù„Ù‡ ÙˆØ¨Ø­Ù…Ø¯Ù‡',
                    'Ù„Ø§ Ø¥Ù„Ù‡ Ø¥Ù„Ø§ Ø§Ù„Ù„Ù‡',
                    'Ø£Ø³ØªØºÙØ± Ø§Ù„Ù„Ù‡ Ø§Ù„Ø¹Ø¸ÙŠÙ…',
                    'Ø§Ù„Ù„Ù‡Ù… ØµÙ„ Ø¹Ù„Ù‰ Ù…Ø­Ù…Ø¯',
                    'Ø±Ø¨ Ø§ØºÙØ± Ù„ÙŠ ÙˆÙ„ÙˆØ§Ù„Ø¯ÙŠ',
                    'Ø­Ø³Ø¨Ù†Ø§ Ø§Ù„Ù„Ù‡ ÙˆÙ†Ø¹Ù… Ø§Ù„ÙˆÙƒÙŠÙ„',
                  ],
                  maxSuggestions: 4,
                ),
              ],
            ),
          ),
        ),

        // Arabic Form Field
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arabic Form Field - Ø­Ù‚Ù„ Ù†Ù…ÙˆØ°Ø¬ Ø¹Ø±Ø¨ÙŠ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicTextFormField(
                  labelText: 'Ø§Ù„Ø§Ø³Ù… Ø§Ù„ÙƒØ§Ù…Ù„',
                  hintText: 'Ø£Ø¯Ø®Ù„ Ø§Ø³Ù…Ùƒ Ø§Ù„ÙƒØ§Ù…Ù„',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ù‡Ø°Ø§ Ø§Ù„Ø­Ù‚Ù„ Ù…Ø·Ù„ÙˆØ¨';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),

        // Text Direction Indicator
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Input Analysis - ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ø­Ø§Ù„ÙŠ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textController,
                  builder: (context, value, child) {
                    final text = value.text;
                    final direction = ArabicTypography.getTextDirection(text);
                    final hasArabic = ArabicTypography.containsArabic(text);
                    final arabicWords = ArabicTypography.extractArabicWords(
                      text,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Text: $text'),
                        Text('Direction: ${direction.name}'),
                        Text('Contains Arabic: $hasArabic'),
                        Text('Arabic Words: ${arabicWords.join(', ')}'),
                        if (text.isNotEmpty)
                          Text(
                            'Normalized: ${ArabicTypography.normalizeArabicText(text)}',
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMixedContentDemo() {
    const mixedTexts = [
      'Hello Ù…Ø±Ø­Ø¨Ø§ Ø¨ÙƒÙ… World',
      'English text with Ø¹Ø±Ø¨ÙŠ ÙÙŠ Ø§Ù„ÙˆØ³Ø· middle Arabic',
      'Ù…Ø±Ø­Ø¨Ø§ Hello Ø£Ù‡Ù„Ø§Ù‹ World Ø³Ù„Ø§Ù… Goodbye',
      'Programming Ø§Ù„Ø¨Ø±Ù…Ø¬Ø© is fun Ù…ØªØ¹Ø©',
      'Flutter + Ø§Ù„Ø¹Ø±Ø¨ÙŠØ© = Amazing Ø±Ø§Ø¦Ø¹',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Mixed Content Header
        ArabicAccessibility.createAccessibleText(
          text: 'Mixed Content Demo - Ø¹Ø±Ø¶ Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ù…Ø®ØªÙ„Ø·',
          context: context,
          isHeading: true,
        ),
        const SizedBox(height: 24),

        // Mixed Text Examples
        ...mixedTexts.map((text) {
          final direction = ArabicTypography.getTextDirection(text);
          final alignment = ArabicTypography.getTextAlign(text, direction);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mixed Text Example',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  MixedTextDirectionWidget(
                    text: text,
                    style: Theme.of(context).textTheme.bodyLarge,
                    selectable: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text('Direction: ${direction.name}'),
                        backgroundColor: direction == TextDirection.rtl
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.blue.withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('Align: ${alignment.name}'),
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        // Arabic Number Formatting Demo
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arabic Number Formatting - ØªÙ†Ø³ÙŠÙ‚ Ø§Ù„Ø£Ø±Ù‚Ø§Ù… Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const Column(
                  children: [
                    _NumberFormattingRow(
                      'English: 123456789',
                      'Arabic: Ù¡Ù¢Ù£Ù¤Ù¥Ù¦Ù§Ù¨Ù©',
                    ),
                    _NumberFormattingRow(
                      'Date: 2024/12/25',
                      'Ø§Ù„ØªØ§Ø±ÙŠØ®: Ù¢Ù Ù¢Ù¤/Ù¡Ù¢/Ù¢Ù¥',
                    ),
                    _NumberFormattingRow('Time: 14:30', 'Ø§Ù„ÙˆÙ‚Øª: Ù¡Ù¤:Ù£Ù '),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Accessibility Header
        ArabicAccessibility.createAccessibleText(
          text: 'Accessibility Features - Ù…ÙŠØ²Ø§Øª Ø¥Ù…ÙƒØ§Ù†ÙŠØ© Ø§Ù„ÙˆØµÙˆÙ„',
          context: context,
          isHeading: true,
        ),
        const SizedBox(height: 24),

        // Islamic Content with Accessibility
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Islamic Content with Accessibility - Ù…Ø­ØªÙˆÙ‰ Ø¥Ø³Ù„Ø§Ù…ÙŠ Ù…Ø¹ Ø¥Ù…ÙƒØ§Ù†ÙŠØ© Ø§Ù„ÙˆØµÙˆÙ„',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicAccessibility.createIslamicContentWidget(
                  arabicText: 'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„Ù‘Ù°Ù‡Ù Ø§Ù„Ø±ÙŽÙ‘Ø­Ù’Ù…Ù°Ù†Ù Ø§Ù„Ø±ÙŽÙ‘Ø­ÙÙŠÙ…Ù',
                  transliteration: 'Bismillahir Rahmanir Raheem',
                  translation: 'In the name of Allah, the Most Gracious, the Most Merciful',
                  context: context,
                  contentType: IslamicContentType.quranVerse,
                ),
              ],
            ),
          ),
        ),

        // Accessible Arabic List Tiles
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Accessible Arabic List - Ù‚Ø§Ø¦Ù…Ø© Ø¹Ø±Ø¨ÙŠØ© ÙŠØ³Ù‡Ù„ Ø§Ù„ÙˆØµÙˆÙ„ Ø¥Ù„ÙŠÙ‡Ø§',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const AccessibleArabicListTile(
                title: 'Ø³ÙØ¨Ù’Ø­ÙŽØ§Ù†ÙŽ Ø§Ù„Ù„Ù‘Ù°Ù‡Ù',
                subtitle: 'Glory be to Allah',
                transliteration: 'SubhanAllah',
                contentType: IslamicContentType.dhikr,
                leading: Icon(Icons.favorite, color: Colors.green),
              ),
              const AccessibleArabicListTile(
                title: 'Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ù„ÙÙ„Ù‘Ù°Ù‡Ù',
                subtitle: 'Praise be to Allah',
                transliteration: 'Alhamdulillah',
                contentType: IslamicContentType.dhikr,
                leading: Icon(Icons.favorite, color: Colors.blue),
              ),
              const AccessibleArabicListTile(
                title: 'Ù„ÙŽØ§ Ø¥ÙÙ„Ù°Ù‡ÙŽ Ø¥ÙÙ„ÙŽÙ‘Ø§ Ø§Ù„Ù„Ù‘Ù°Ù‡Ù',
                subtitle: 'There is no god but Allah',
                transliteration: 'La ilaha illa Allah',
                contentType: IslamicContentType.dhikr,
                leading: Icon(Icons.favorite, color: Colors.red),
              ),
            ],
          ),
        ),

        // Voice Control Button
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Control Button - Ø²Ø± Ø§Ù„ØªØ­ÙƒÙ… Ø§Ù„ØµÙˆØªÙŠ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                VoiceControlArabicButton(
                  label: 'Ø§Ù„Ø¨Ø­Ø« Ø¨Ø§Ù„ØµÙˆØª',
                  icon: Icons.mic,
                  voiceCommand: 'Ø§Ø¨Ø¯Ø£ Ø§Ù„Ø¨Ø­Ø« Ø§Ù„ØµÙˆØªÙŠ',
                  tooltip: 'Ø§Ø¶ØºØ· Ù„Ù„Ø¨Ø­Ø« Ø¨Ø§Ù„ØµÙˆØª',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Voice search activated - ØªÙ… ØªØ´ØºÙŠÙ„ Ø§Ù„Ø¨Ø­Ø« Ø§Ù„ØµÙˆØªÙŠ',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Screen Reader Optimized Text
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Screen Reader Optimized - Ù…Ø­Ø³Ù† Ù„Ù‚Ø§Ø±Ø¦ Ø§Ù„Ø´Ø§Ø´Ø©',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const ScreenReaderOptimizedText(
                  text: 'Ø§Ù„Ù„Ù‡Ù… Ø§Ù‡Ø¯Ù†Ø§ ÙÙŠÙ…Ù† Ù‡Ø¯ÙŠØª',
                  alternativeText: 'Islamic supplication: O Allah, guide us among those You have guided',
                  isLive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Tests Header
        ArabicAccessibility.createAccessibleText(
          text: 'Feature Tests - Ø§Ø®ØªØ¨Ø§Ø±Ø§Øª Ø§Ù„Ù…ÙŠØ²Ø§Øª',
          context: context,
          isHeading: true,
        ),
        const SizedBox(height: 24),

        // Platform Font Test
        FutureBuilder<bool>(
          future: PlatformArabicFontConfig.testArabicFontSupport(),
          builder: (context, snapshot) {
            return Card(
              child: ListTile(
                leading: Icon(
                  snapshot.data == true ? Icons.check_circle : Icons.error,
                  color: snapshot.data == true ? Colors.green : Colors.red,
                ),
                title: const Text('Arabic Font Support Test'),
                subtitle: Text(
                  snapshot.hasData
                      ? snapshot.data!
                          ? 'Arabic fonts are supported on this platform'
                          : 'Arabic font support is limited'
                      : 'Testing Arabic font support...',
                ),
              ),
            );
          },
        ),

        // Text Direction Tests
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Text Direction Detection Tests',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ..._buildTextDirectionTests(),
              ],
            ),
          ),
        ),

        // Performance Test
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Test - Ø§Ø®ØªØ¨Ø§Ø± Ø§Ù„Ø£Ø¯Ø§Ø¡',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _runPerformanceTest(),
                  child: const Text(
                    'Run Performance Test - ØªØ´ØºÙŠÙ„ Ø§Ø®ØªØ¨Ø§Ø± Ø§Ù„Ø£Ø¯Ø§Ø¡',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTextDirectionTests() {
    const testCases = [
      ('Pure Arabic', 'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…', TextDirection.rtl),
      ('Pure English', 'Hello World', TextDirection.ltr),
      ('Mixed (Arabic majority)', 'Ù…Ø±Ø­Ø¨Ø§ Hello Ø£Ù‡Ù„Ø§Ù‹', TextDirection.rtl),
      ('Mixed (English majority)', 'Hello Ù…Ø±Ø­Ø¨Ø§ World', TextDirection.ltr),
      ('Numbers', 'Ù¡Ù¢Ù£ ABC Ù¤Ù¥Ù¦', TextDirection.rtl),
    ];

    return testCases.map((test) {
      final actualDirection = ArabicTypography.getTextDirection(test.$2);
      final isCorrect = actualDirection == test.$3;

      return ListTile(
        leading: Icon(
          isCorrect ? Icons.check : Icons.close,
          color: isCorrect ? Colors.green : Colors.red,
        ),
        title: Text(test.$1),
        subtitle: Text('${test.$2} â†’ ${actualDirection.name}'),
        trailing: Icon(
          test.$3 == TextDirection.rtl ? Icons.arrow_back : Icons.arrow_forward,
        ),
      );
    }).toList();
  }

  void _runPerformanceTest() {
    final stopwatch = Stopwatch()..start();

    // Simulate performance test
    const iterations = 10000;
    const testText = 'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ… Hello World';

    for (int i = 0; i < iterations; i++) {
      ArabicTypography.getTextDirection(testText);
      ArabicTypography.containsArabic(testText);
      ArabicTypography.normalizeArabicText(testText);
    }

    stopwatch.stop();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Performance Test Complete: ${stopwatch.elapsedMilliseconds}ms for $iterations operations',
          ),
        ),
      );
    }
  }
}

class _NumberFormattingRow extends StatelessWidget {
  final String english;
  final String arabic;

  const _NumberFormattingRow(this.english, this.arabic);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(english, textAlign: TextAlign.left)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

/// Main entry point for running the Arabic RTL Demo as a standalone app
void main() {
  runApp(const ArabicRTLDemoApp());
}

/// Demo app wrapper
class ArabicRTLDemoApp extends StatelessWidget {
  const ArabicRTLDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic RTL Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ArabicRTLDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

