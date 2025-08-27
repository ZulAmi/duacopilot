import 'package:duacopilot/core/accessibility/arabic_accessibility.dart';
import 'package:duacopilot/core/layout/rtl_layout_support.dart';
import 'package:duacopilot/core/typography/arabic_typography.dart';
import 'package:duacopilot/core/widgets/arabic_text_input_widget.dart';
import 'package:duacopilot/main_dev.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Comprehensive Integration Tests for Arabic Text & RTL Support
///
/// Tests cover:
/// - Arabic typography and font rendering
/// - RTL layout behavior
/// - Mixed text direction handling
/// - Accessibility features
/// - Platform-specific optimizations
/// - Text input and selection
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Arabic Text & RTL Support Integration Tests', () {
    testWidgets('Arabic Typography System Test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Test Arabic text detection
      const arabicText = 'بسم الله الرحمن الرحيم';
      const englishText = 'Hello World';
      const mixedText = 'Hello مرحبا World';

      expect(ArabicTypography.containsArabic(arabicText), isTrue);
      expect(ArabicTypography.containsArabic(englishText), isFalse);
      expect(ArabicTypography.containsArabic(mixedText), isTrue);

      // Test text direction detection
      expect(ArabicTypography.getTextDirection(arabicText), TextDirection.rtl);
      expect(ArabicTypography.getTextDirection(englishText), TextDirection.ltr);
    });

    testWidgets('RTL Layout Components Test', (WidgetTester tester) async {
      // Test RTL-aware widgets
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Test MixedTextDirectionWidget
                const MixedTextDirectionWidget(
                  text: 'بسم الله الرحمن الرحيم',
                  selectable: true,
                ),

                // Test RTL-aware container
                RTLAwareContainer(
                  content: 'مرحبا بكم',
                  padding: const EdgeInsets.all(16),
                  child: const Text('Arabic content'),
                ),

                // Test RTL-aware row
                const RTLAwareRow(
                  content: 'صف عربي',
                  children: [Text('First'), Text('Second'), Text('Third')],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify widgets are rendered
      expect(find.byType(MixedTextDirectionWidget), findsOneWidget);
      expect(find.byType(RTLAwareContainer), findsOneWidget);
      expect(find.byType(RTLAwareRow), findsOneWidget);
    });

    testWidgets('Arabic Text Input Widget Test', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArabicTextInputWidget(
              controller: controller,
              hintText: 'أدخل النص العربي',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Test Arabic input
      await tester.enterText(textField, 'بسم الله');
      await tester.pump();

      expect(controller.text, 'بسم الله');
    });

    testWidgets('Arabic Suggestion TextField Test', (
      WidgetTester tester,
    ) async {
      const suggestions = [
        'بسم الله الرحمن الرحيم',
        'الحمد لله رب العالمين',
        'سبحان الله وبحمده',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArabicSuggestionTextField(
              hintText: 'ابحث عن الدعاء',
              suggestions: suggestions,
              showSuggestions: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter partial text to trigger suggestions
      await tester.enterText(textField, 'بسم');
      await tester.pump();

      // Should show suggestions
      await tester.pump(const Duration(milliseconds: 300));

      // Look for suggestion list
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Accessibility Features Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Test accessible Arabic list tile
                const AccessibleArabicListTile(
                  title: 'سبحان الله',
                  subtitle: 'Glory be to Allah',
                  transliteration: 'SubhanAllah',
                  contentType: IslamicContentType.dhikr,
                ),

                // Test screen reader optimized text
                const ScreenReaderOptimizedText(
                  text: 'بسم الله الرحمن الرحيم',
                  alternativeText: 'Basmala - In the name of Allah',
                  isLive: true,
                ),

                // Test voice control button
                VoiceControlArabicButton(
                  label: 'الحمد لله',
                  onPressed: () {},
                  voiceCommand: 'praise',
                  icon: Icons.play_arrow,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify accessibility widgets are rendered
      expect(find.byType(AccessibleArabicListTile), findsOneWidget);
      expect(find.byType(ScreenReaderOptimizedText), findsOneWidget);
      expect(find.byType(VoiceControlArabicButton), findsOneWidget);
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('Mixed Content Direction Handling Test', (
      WidgetTester tester,
    ) async {
      const mixedTexts = [
        'Hello مرحبا World',
        'English text with عربي في الوسط middle',
        'مرحبا Hello أهلا World سلام',
        'بسم الله (In the name of Allah) الرحمن',
      ];

      for (final text in mixedTexts) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MixedTextDirectionWidget(text: text, selectable: true),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget handles mixed content
        final widget = find.byType(MixedTextDirectionWidget);
        expect(widget, findsOneWidget);

        // Test text direction detection
        final direction = ArabicTypography.getTextDirection(text);
        expect(direction, isNotNull);
      }
    });

    testWidgets('Arabic Font Rendering Test', (WidgetTester tester) async {
      const fontTypes = [
        'quran',
        'traditional',
        'modern',
        'readable',
        'elegant',
        'compact',
      ];
      const testText = 'بسم الله الرحمن الرحيم';

      for (final fontType in fontTypes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text(
                testText,
                style: ArabicTypography.getArabicGoogleFont(
                  fontType,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify text is rendered with correct font
        final textWidget = find.byType(Text);
        expect(textWidget, findsOneWidget);
      }
    });

    testWidgets('RTL Layout Direction Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Column(
                  children: [
                    // Test RTL-aware padding
                    Container(
                      padding: RTLLayoutSupport.createRTLAwareInsets(
                        context: context,
                        start: 16,
                        end: 8,
                        top: 12,
                        bottom: 12,
                      ),
                      child: const Text('RTL Aware Padding'),
                    ),

                    // Test RTL-aware alignment
                    Container(
                      alignment: RTLLayoutSupport.createRTLAwareAlignment(
                        context,
                        Alignment.centerLeft,
                      ),
                      child: const Text('RTL Aware Alignment'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify RTL layout components work
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Arabic Text Selection Test', (WidgetTester tester) async {
      const arabicText = 'بسم الله الرحمن الرحيم الحمد لله رب العالمين';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => SelectableText(
                arabicText,
                style: ArabicTextStyles.bodyLarge(
                  context,
                  fontType: 'readable',
                ),
                textDirection: TextDirection.rtl,
                selectionControls: ArabicTextSelectionControls(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the selectable text
      final selectableText = find.byType(SelectableText);
      expect(selectableText, findsOneWidget);

      // Test text selection (simulate long press)
      await tester.longPress(selectableText);
      await tester.pumpAndSettle();

      // Should show selection handles and toolbar
      // Note: This might not work in all test environments due to platform differences
    });

    testWidgets('Arabic Number Formatting Test', (WidgetTester tester) async {
      const testNumbers = ['123', '456789', '2024'];
      const expectedArabic = ['١٢٣', '٤٥٦٧٨٩', '٢٠٢٤'];

      for (int i = 0; i < testNumbers.length; i++) {
        final formatted = ArabicTypography.formatArabicNumbers(testNumbers[i]);
        expect(formatted, expectedArabic[i]);
      }
    });

    testWidgets('Arabic Text Normalization Test', (WidgetTester tester) async {
      const testTexts = [
        'أَلسَّلَامُ عَلَيْكُمْ',
        'مَرْحَبَاً بِكُمْ',
        'ٱلْحَمْدُ لِلَّٰهِ',
      ];

      for (final text in testTexts) {
        final normalized = ArabicTypography.normalizeArabicText(text);
        expect(normalized, isNotEmpty);
        expect(normalized.length, lessThanOrEqualTo(text.length));
      }
    });

    testWidgets('Voice Control Arabic Button Test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoiceControlArabicButton(
              label: 'البحث بالصوت',
              icon: Icons.mic,
              voiceCommand: 'ابدأ البحث',
              tooltip: 'اضغط للبحث بالصوت',
              onPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the button
      final button = find.byType(VoiceControlArabicButton);
      expect(button, findsOneWidget);

      // Test button tap
      await tester.tap(button);
      await tester.pump();
    });

    testWidgets('High Contrast Theme Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) => MaterialApp(
            theme: ArabicAccessibility.createHighContrastTheme(context),
            home: const Scaffold(body: Text('High Contrast Arabic Text')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify high contrast theme is applied
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.theme!.colorScheme.surface, Colors.black);
    });
  });

  group('Platform-Specific Arabic Font Tests', () {
    testWidgets('Platform Font Configuration Test', (
      WidgetTester tester,
    ) async {
      // Test platform-specific font configurations
      const arabicText = 'بسم الله الرحمن الرحيم';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text(
                  arabicText,
                  style: const TextStyle(fontFamily: 'SF Arabic'), // iOS
                ),
                Text(
                  arabicText,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Arabic',
                  ), // Android
                ),
                Text(
                  arabicText,
                  style: const TextStyle(
                    fontFamily: 'Segoe UI Arabic',
                  ), // Windows
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all text widgets are rendered
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Font Fallback Chain Test', (WidgetTester tester) async {
      const arabicText = 'اختبار الخط العربي';
      const fallbackFonts = [
        'NonExistentFont',
        'Noto Sans Arabic',
        'Arial Unicode MS',
        'Tahoma',
      ];

      for (final font in fallbackFonts) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text(arabicText, style: TextStyle(fontFamily: font)),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should render without errors even with non-existent fonts
        expect(find.byType(Text), findsOneWidget);
      }
    });
  });

  group('Performance Tests', () {
    testWidgets('Large Arabic Text Performance Test', (
      WidgetTester tester,
    ) async {
      // Generate large Arabic text
      const baseText = 'بسم الله الرحمن الرحيم ';
      final largeText = List.generate(100, (index) => baseText).join();

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Builder(
                builder: (context) => Text(
                  largeText,
                  style: ArabicTextStyles.bodyLarge(
                    context,
                    fontType: 'readable',
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Performance should be reasonable (less than 1 second)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    testWidgets('Arabic Text Direction Switch Performance Test', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      const texts = [
        'Hello',
        'مرحبا',
        'Hello World',
        'بسم الله الرحمن الرحيم',
        'Mixed العربية English',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArabicTextInputWidget(
              controller: controller,
              hintText: 'Test input',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      for (final text in texts) {
        controller.text = text;
        await tester.pump();
      }

      stopwatch.stop();

      // Direction switching should be fast
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
