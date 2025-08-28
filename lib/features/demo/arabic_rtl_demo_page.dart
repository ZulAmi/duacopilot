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
            text: 'Arabic Text & RTL Support Demo - عرض النص العربي',
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
              const Tab(text: 'Typography - الخطوط'),
              const Tab(text: 'Layout - التخطيط'),
              const Tab(text: 'Input - الإدخال'),
              const Tab(text: 'Mixed - مختلط'),
              const Tab(text: 'Accessibility - إمكانية الوصول'),
              const Tab(text: 'Tests - الاختبارات'),
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
      'Quran': 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ',
      'Du\'a': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً',
      'Dhikr': 'سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ سُبْحَانَ اللّٰهِ الْعَظِيمِ',
      'Hadith': 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Typography Section Header
        ArabicAccessibility.createAccessibleText(
          text: 'Arabic Typography Styles - أنماط الخطوط العربية',
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
                  'Font Size Variations - تباين أحجام الخط',
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
                      'الحمد لله رب العالمين',
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
          text: 'RTL Layout Components - مكونات التخطيط',
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
                  'RTL-Aware Row - صف يدعم العربية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                RTLAwareRow(
                  content: 'عنصر أول',
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'أول',
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
                        'ثاني',
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
                        'ثالث',
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
                  'RTL-Aware Container - حاوية تدعم العربية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                RTLAwareContainer(
                  content: 'محتوى عربي',
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
                    'هذا محتوى عربي داخل حاوية يدعم اتجاه النص من اليمين إلى اليسار',
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
                  'RTL Positioning - المواضع العربية',
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
                        content: 'البداية',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'بداية',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RTLAwarePositioned(
                        end: 16,
                        top: 16,
                        content: 'النهاية',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'نهاية',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RTLAwarePositioned(
                        start: 16,
                        bottom: 16,
                        content: 'الأسفل',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'أسفل يسار',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RTLAwarePositioned(
                        end: 16,
                        bottom: 16,
                        content: 'أسفل يمين',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'أسفل يمين',
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
          text: 'Arabic Text Input - إدخال النص العربي',
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
                  'Enhanced Arabic Input - إدخال محسن للعربية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicTextInputWidget(
                  controller: _textController,
                  hintText: 'أدخل النص العربي أو الإنجليزي',
                  labelText: 'النص المختلط',
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
                  'Arabic Suggestions - اقتراحات عربية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicSuggestionTextField(
                  hintText: 'ابحث عن دعاء أو ذكر',
                  suggestions: const [
                    'بسم الله الرحمن الرحيم',
                    'الحمد لله رب العالمين',
                    'سبحان الله وبحمده',
                    'لا إله إلا الله',
                    'أستغفر الله العظيم',
                    'اللهم صل على محمد',
                    'رب اغفر لي ولوالدي',
                    'حسبنا الله ونعم الوكيل',
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
                  'Arabic Form Field - حقل نموذج عربي',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicTextFormField(
                  labelText: 'الاسم الكامل',
                  hintText: 'أدخل اسمك الكامل',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
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
                  'Current Input Analysis - تحليل الإدخال الحالي',
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
      'Hello مرحبا بكم World',
      'English text with عربي في الوسط middle Arabic',
      'مرحبا Hello أهلاً World سلام Goodbye',
      'Programming البرمجة is fun متعة',
      'Flutter + العربية = Amazing رائع',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Mixed Content Header
        ArabicAccessibility.createAccessibleText(
          text: 'Mixed Content Demo - عرض المحتوى المختلط',
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
                            ? Colors.green.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('Align: ${alignment.name}'),
                        backgroundColor: Colors.orange.withOpacity(0.2),
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
                  'Arabic Number Formatting - تنسيق الأرقام العربية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const Column(
                  children: [
                    _NumberFormattingRow(
                      'English: 123456789',
                      'Arabic: ١٢٣٤٥٦٧٨٩',
                    ),
                    _NumberFormattingRow(
                      'Date: 2024/12/25',
                      'التاريخ: ٢٠٢٤/١٢/٢٥',
                    ),
                    _NumberFormattingRow('Time: 14:30', 'الوقت: ١٤:٣٠'),
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
          text: 'Accessibility Features - ميزات إمكانية الوصول',
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
                  'Islamic Content with Accessibility - محتوى إسلامي مع إمكانية الوصول',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ArabicAccessibility.createIslamicContentWidget(
                  arabicText: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ',
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
                  'Accessible Arabic List - قائمة عربية يسهل الوصول إليها',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const AccessibleArabicListTile(
                title: 'سُبْحَانَ اللّٰهِ',
                subtitle: 'Glory be to Allah',
                transliteration: 'SubhanAllah',
                contentType: IslamicContentType.dhikr,
                leading: Icon(Icons.favorite, color: Colors.green),
              ),
              const AccessibleArabicListTile(
                title: 'الْحَمْدُ لِلّٰهِ',
                subtitle: 'Praise be to Allah',
                transliteration: 'Alhamdulillah',
                contentType: IslamicContentType.dhikr,
                leading: Icon(Icons.favorite, color: Colors.blue),
              ),
              const AccessibleArabicListTile(
                title: 'لَا إِلٰهَ إِلَّا اللّٰهُ',
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
                  'Voice Control Button - زر التحكم الصوتي',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                VoiceControlArabicButton(
                  label: 'البحث بالصوت',
                  icon: Icons.mic,
                  voiceCommand: 'ابدأ البحث الصوتي',
                  tooltip: 'اضغط للبحث بالصوت',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Voice search activated - تم تشغيل البحث الصوتي',
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
                  'Screen Reader Optimized - محسن لقارئ الشاشة',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const ScreenReaderOptimizedText(
                  text: 'اللهم اهدنا فيمن هديت',
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
          text: 'Feature Tests - اختبارات الميزات',
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
                  'Performance Test - اختبار الأداء',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _runPerformanceTest(),
                  child: const Text(
                    'Run Performance Test - تشغيل اختبار الأداء',
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
      ('Pure Arabic', 'بسم الله الرحمن الرحيم', TextDirection.rtl),
      ('Pure English', 'Hello World', TextDirection.ltr),
      ('Mixed (Arabic majority)', 'مرحبا Hello أهلاً', TextDirection.rtl),
      ('Mixed (English majority)', 'Hello مرحبا World', TextDirection.ltr),
      ('Numbers', '١٢٣ ABC ٤٥٦', TextDirection.rtl),
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
        subtitle: Text('${test.$2} → ${actualDirection.name}'),
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
    const testText = 'بسم الله الرحمن الرحيم Hello World';

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
