import 'dart:math' as math;
import 'package:astronomia/src/coord/coord.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Coord', () {
    test('eclToEq and eqToEcl roundtrip', () {
      const lon = 2.0; // radians
      const lat = 0.5;
      const eps = 0.4091; // ~23.44°
      final sEps = math.sin(eps);
      final cEps = math.cos(eps);

      final eq = eclToEq(lon, lat, sEps, cEps);
      final ecl = eqToEcl(eq.ra, eq.dec, sEps, cEps);
      expect(ecl.lon, closeTo(lon, 0.0001));
      expect(ecl.lat, closeTo(lat, 0.0001));
    });

    test('eqToHz and hzToEq roundtrip', () {
      final ra = toRad(100);
      final dec = toRad(30);
      final phi = toRad(52);
      final psi = toRad(-5);
      final st = toRad(120);

      final hz = eqToHz(ra, dec, phi, psi, st);
      final eq = hzToEq(hz.az, hz.alt, phi, psi, st);
      expect(eq.ra, closeTo(ra, 0.001));
      expect(eq.dec, closeTo(dec, 0.001));
    });

    test('eqToGal and galToEq roundtrip', () {
      final ra = toRad(180);
      final dec = toRad(45);
      final gal = eqToGal(ra, dec);
      final eq = galToEq(gal.lon, gal.lat);
      expect(eq.ra, closeTo(ra, 0.001));
      expect(eq.dec, closeTo(dec, 0.001));
    });
  });
}
