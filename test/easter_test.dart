import 'package:astronomia/src/easter/easter.dart';
import 'package:test/test.dart';

void main() {
  group('Easter', () {
    test('Gregorian Easter 2000 = April 23', () {
      final r = gregorian(2000);
      expect(r.month, equals(4));
      expect(r.day, equals(23));
    });

    test('Gregorian Easter 1991 = March 31', () {
      final r = gregorian(1991);
      expect(r.month, equals(3));
      expect(r.day, equals(31));
    });

    test('Gregorian Easter 2024 = March 31', () {
      final r = gregorian(2024);
      expect(r.month, equals(3));
      expect(r.day, equals(31));
    });

    test('Julian Easter 179 = April 12', () {
      // Meeus example
      final r = julian(179);
      expect(r.month, equals(4));
      expect(r.day, equals(12));
    });
  });
}
