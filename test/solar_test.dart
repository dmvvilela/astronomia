import 'dart:math' as math;
import 'package:astronomia/src/solar/solar.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Solar', () {
    test('Meeus example 25.a - 1992 Oct 13', () {
      final jde = calendarGregorianToJD(1992, 10, 13.0);
      final t = j2000Century(jde);
      final sun = trueSun(t);
      final lonDeg = toDeg(sun.lon) % 360;
      // Expected: ☉ ≈ 199.907° (Meeus p. 165)
      expect(lonDeg, closeTo(199.91, 0.05));
    });

    test('mean anomaly is reasonable', () {
      final t = j2000Century(calendarGregorianToJD(2000, 1, 1.5));
      final m = toDeg(meanAnomaly(t));
      // At J2000.0, M ≈ 357.53°
      expect(m, closeTo(357.53, 0.1));
    });

    test('eccentricity is near 0.0167', () {
      expect(eccentricity(0), closeTo(0.016708634, 0.0001));
    });

    test('radius at J2000', () {
      final r = radius(0);
      // Earth-Sun distance should be near 1 AU (Jan 1 is near perihelion)
      expect(r, closeTo(0.983, 0.005));
    });

    test('apparent equatorial coordinates', () {
      final jde = calendarGregorianToJD(1992, 10, 13.0);
      final eq = apparentEquatorial(jde);
      final raDeg = toDeg(eq.ra);
      final decDeg = toDeg(eq.dec);
      // Meeus p. 165: α ≈ 13h 13m 31s ≈ 198.38°, δ ≈ -7°47′ ≈ -7.78°
      expect(raDeg, closeTo(198.38, 0.1));
      expect(decDeg, closeTo(-7.78, 0.1));
    });
  });
}
