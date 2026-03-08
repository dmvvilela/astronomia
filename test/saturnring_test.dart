import 'package:astronomia/src/saturnring/saturnring.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('Saturnring', () {
    test('ring returns reasonable B for 1992 Dec', () {
      final earth = Planet(planetEarth);
      final saturn = Planet(planetSaturn);
      final jde = calendarGregorianToJD(1992, 12, 16.0);
      final r = ring(jde, earth, saturn);
      // B (tilt toward Earth) should be within ±27° (ring inclination)
      expect(toDeg(r.b).abs(), lessThan(28));
      expect(toDeg(r.bPrime).abs(), lessThan(28));
    });

    test('ring semi-major axis is positive', () {
      final earth = Planet(planetEarth);
      final saturn = Planet(planetSaturn);
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final r = ring(jde, earth, saturn);
      expect(r.a, greaterThan(0));
      expect(r.bAxis, greaterThanOrEqualTo(0));
      expect(r.bAxis, lessThanOrEqualTo(r.a));
    });

    test('ring constants are valid', () {
      expect(innerEdgeOfOuter, greaterThan(outerEdgeOfInner));
      expect(outerEdgeOfInner, greaterThan(innerEdgeOfInner));
      expect(innerEdgeOfInner, greaterThan(innerEdgeOfDusky));
    });

    test('ub returns consistent values with ring', () {
      final earth = Planet(planetEarth);
      final saturn = Planet(planetSaturn);
      final jde = calendarGregorianToJD(2000, 6, 15.0);
      final r = ring(jde, earth, saturn);
      final u = ub(jde, earth, saturn);
      expect(u.b, closeTo(r.b, 1e-10));
      expect(u.deltaU, closeTo(r.deltaU, 1e-10));
    });
  });
}
