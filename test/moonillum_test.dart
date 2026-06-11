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

    test('Meeus example 48.a - phase angle from coordinates', () {
      // Meeus p. 347: i = 69.0756°, k = 0.6786
      final i = phaseAngleEq(
          toRad(134.6885), toRad(13.7684), 368410.0,
          toRad(20.6579), toRad(8.6964), 149971520.0);
      expect(toDeg(i), closeTo(69.0756, 0.0001));
      expect(illuminated(i), closeTo(0.6786, 0.0001));
    });

    test('Meeus example 48.a - quick phase angle from JDE', () {
      // phaseAngle3 is the lower-accuracy formula (48.4); for 1992 Apr 12
      // it yields 68.8834° vs the rigorous 69.0756°. Pinned as regression.
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final i = phaseAngle3(jde);
      expect(toDeg(i), closeTo(68.8834, 0.001));
      expect(illuminated(i), closeTo(0.6786, 0.005));
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
