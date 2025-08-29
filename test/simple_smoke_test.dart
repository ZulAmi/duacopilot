import 'package:flutter_test/flutter_test.dart';

/// Simple smoke tests that don't require dependency injection
/// These can run even when DI setup fails
void main() {
  group('Simple Smoke Tests', () {
    test('Basic Dart functionality works', () {
      expect(1 + 1, equals(2));
      expect('DuaCopilot'.toLowerCase(), equals('duacopilot'));
      expect([1, 2, 3].length, equals(3));
    });

    test('DateTime functionality works', () {
      final now = DateTime.now();
      expect(now.year, greaterThan(2020));
      expect(now.month, inInclusiveRange(1, 12));
    });

    test('String operations work correctly', () {
      const arabicText = 'بسم الله الرحمن الرحيم';
      const englishText = 'In the name of Allah';
      
      expect(arabicText.isNotEmpty, isTrue);
      expect(englishText.split(' ').length, equals(5));
      expect('${englishText}_modified'.contains('Allah'), isTrue);
    });

    test('List operations work correctly', () {
      final duas = ['Morning Dua', 'Evening Dua', 'Travel Dua'];
      expect(duas.length, equals(3));
      expect(duas.first, equals('Morning Dua'));
      expect(duas.contains('Travel Dua'), isTrue);
    });
  });
}
