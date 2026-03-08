import 'package:astronomia/astronomia.dart';
import 'package:test/test.dart';

void main() {
  group('Sexagesimal', () {
    test('from degrees', () {
      final s = Sexa.fromDeg(23.4393);
      expect(s.d, equals(23));
      expect(s.m, equals(26));
      expect(s.s, closeTo(21.48, 0.01));
      expect(s.negative, isFalse);
    });

    test('negative angle', () {
      final s = Sexa.fromDeg(-45.5);
      expect(s.negative, isTrue);
      expect(s.d, equals(45));
      expect(s.m, equals(30));
    });

    test('round-trip', () {
      const original = 123.456;
      final s = Sexa.fromDeg(original);
      expect(s.toDeg(), closeTo(original, 0.0001));
    });
  });
}
