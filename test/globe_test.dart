import 'dart:math' as math;
import 'package:astronomia/src/globe/globe.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Globe', () {
    test('polar radius < equatorial radius', () {
      expect(polarRadius(earthEr, earthFl), lessThan(earthEr));
    });

    test('eccentricity is reasonable', () {
      final e = eccentricity(earthFl);
      expect(e, closeTo(0.0818, 0.001));
    });

    test('rho at equator is ~1', () {
      expect(rho(0), closeTo(1.0, 0.002));
    });

    test('rho at pole is less than 1', () {
      expect(rho(math.pi / 2), lessThan(1.0));
    });

    test('radius at equator equals equatorial radius', () {
      final r = radiusAtLatitude(0);
      expect(r, closeTo(earthEr, 0.1));
    });

    test('distance between same point is 0', () {
      final d = distance(toRad(40), toRad(0), toRad(40), toRad(0));
      expect(d, closeTo(0, 0.001));
    });

    test('Meeus example 11.a - Paris to Washington', () {
      // Paris: 48°50'N 2°20'E, Washington: 38°55'N 77°04'W
      final lat1 = toRad(48 + 50 / 60.0);
      final lon1 = toRad(-2 - 20 / 60.0); // east is negative in Meeus convention
      final lat2 = toRad(38 + 55 / 60.0);
      final lon2 = toRad(77 + 4 / 60.0);
      final d = distance(lat1, lon1, lat2, lon2);
      // Expected ~6181 km
      expect(d, closeTo(6181, 20));
    });
  });
}
