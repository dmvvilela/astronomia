import 'dart:math' as math;
import 'package:astronomia/src/kepler/kepler.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Kepler', () {
    test('Meeus example 30.a - E for e=0.1, M=5°', () {
      // Meeus p. 195
      final m = toRad(5);
      final e = kepler2(0.1, m);
      expect(toDeg(e), closeTo(5.554, 0.01));
    });

    test('true anomaly for circular orbit', () {
      // e=0 → ν = E = M
      expect(trueAnomaly(1.0, 0), closeTo(1.0, 1e-10));
    });

    test('radius at perihelion', () {
      // E=0 → r = a(1-e)
      expect(radius(0, 0.5, 2.0), closeTo(1.0, 1e-10));
    });

    test('radius at aphelion', () {
      // E=π → r = a(1+e)
      expect(radius(math.pi, 0.5, 2.0), closeTo(3.0, 1e-10));
    });

    test('all solvers agree for moderate e', () {
      final m = toRad(30);
      const e = 0.2;
      final e1 = kepler1(e, m);
      final e2 = kepler2(e, m);
      final e2a = kepler2a(e, m);
      final e2b = kepler2b(e, m);
      final e3 = kepler3(e, m);
      final e4 = kepler4(e, m); // approximate
      expect(toDeg(e1), closeTo(toDeg(e2), 0.0001));
      expect(toDeg(e2), closeTo(toDeg(e2a), 0.0001));
      expect(toDeg(e2a), closeTo(toDeg(e2b), 0.0001));
      expect(toDeg(e2b), closeTo(toDeg(e3), 0.0001));
      // kepler4 is approximate, wider tolerance
      expect(toDeg(e4), closeTo(toDeg(e2), 0.5));
    });

    test('kepler3 binary search', () {
      final m = toRad(200);
      final e3 = kepler3(0.99, m);
      final nu = trueAnomaly(e3, 0.99);
      // Just verify it returns something reasonable
      expect(nu.isFinite, isTrue);
    });
  });
}
