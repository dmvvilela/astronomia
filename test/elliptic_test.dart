import 'package:astronomia/src/elliptic/elliptic.dart';
import 'package:test/test.dart';

void main() {
  group('Elliptic', () {
    test('velocity at 1 AU circular orbit', () {
      // Earth-like: a=1, r=1 → v ≈ 0.01720 AU/day
      final v = velocity(1, 1);
      expect(v, closeTo(0.01720, 0.001));
    });

    test('vPerihelion > vAphelion', () {
      final vp = vPerihelion(1, 0.5);
      final va = vAphelion(1, 0.5);
      expect(vp, greaterThan(va));
    });

    test('orbit length for circle', () {
      // e=0, a=1 → circumference = 2π ≈ 6.283
      final l1 = length1(1, 0);
      final l2 = length2(1, 0);
      expect(l1, closeTo(6.2832, 0.01));
      expect(l2, closeTo(6.2832, 0.01));
    });

    test('orbit length increases with eccentricity', () {
      final l0 = length2(1, 0);
      final l1 = length2(1, 0.5);
      expect(l1, lessThan(l0)); // shorter b means shorter perimeter
    });
  });
}
