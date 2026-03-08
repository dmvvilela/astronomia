import 'dart:math' as math;
import 'package:astronomia/src/angle/angle.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Angle', () {
    test('separation of same point is 0', () {
      expect(sep(1, 0.5, 1, 0.5), closeTo(0, 1e-10));
    });

    test('separation of poles is π', () {
      expect(sep(0, math.pi / 2, 0, -math.pi / 2), closeTo(math.pi, 1e-10));
    });

    test('sepHav agrees with sep', () {
      final s1 = sep(toRad(10), toRad(20), toRad(15), toRad(25));
      final s2 = sepHav(toRad(10), toRad(20), toRad(15), toRad(25));
      expect(toDeg(s1), closeTo(toDeg(s2), 0.01));
    });

    test('Meeus example 17.a', () {
      // Spica: 13h25m11.6s, -11°09'41" → radians
      // Arcturus: 14h15m39.7s, +19°10'57" → radians
      final ra1 = toRad((13 + 25 / 60 + 11.6 / 3600) * 15);
      final dec1 = toRad(-(11 + 9 / 60 + 41.0 / 3600));
      final ra2 = toRad((14 + 15 / 60 + 39.7 / 3600) * 15);
      final dec2 = toRad(19 + 10 / 60 + 57.0 / 3600);
      final d = toDeg(sep(ra1, dec1, ra2, dec2));
      // Expected: ~32.79°
      expect(d, closeTo(32.79, 0.1));
    });
  });
}
