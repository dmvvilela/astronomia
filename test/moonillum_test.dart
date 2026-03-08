import 'dart:math' as math;
import 'package:astronomia/src/moonillum/moonillum.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Moonillum', () {
    test('illuminated fraction at full moon', () {
      // Phase angle 0 → fully illuminated
      expect(illuminated(0), closeTo(1.0, 0.001));
    });

    test('illuminated fraction at new moon', () {
      // Phase angle π → not illuminated
      expect(illuminated(math.pi), closeTo(0.0, 0.001));
    });

    test('illuminated fraction at quarter', () {
      // Phase angle π/2 → half illuminated
      expect(illuminated(math.pi / 2), closeTo(0.5, 0.001));
    });

    test('Meeus example 48.a - phase angle', () {
      // Meeus p. 346: 1992 Apr 12
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final i = phaseAngle3(jde);
      final iDeg = toDeg(i);
      // Expected: i ≈ 69.1° (Meeus p. 347)
      expect(iDeg, closeTo(69.1, 1.0));
      // Illuminated fraction ≈ 0.680
      expect(illuminated(i), closeTo(0.68, 0.02));
    });

    test('phaseAngleEq with known positions', () {
      // Sun and Moon 180° apart should give phase angle near 0 (full moon)
      final i = phaseAngleEq(0, 0, 384400, math.pi, 0, 1.496e8);
      expect(toDeg(i).abs(), lessThan(5.0));
    });

    test('limb returns angle in valid range', () {
      final chi = limb(0, 0, math.pi / 6, 0);
      expect(chi.abs(), lessThanOrEqualTo(math.pi));
    });
  });
}
