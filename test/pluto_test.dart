import 'package:astronomia/src/pluto/pluto.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Pluto', () {
    test('Meeus example 37.a - 1992 Oct 13', () {
      // Meeus p. 266: 1992 Oct 13
      final jde = calendarGregorianToJD(1992, 10, 13.0);
      final pos = heliocentric(jde);
      final lonDeg = toDeg(pos.lon) % 360;
      final latDeg = toDeg(pos.lat);
      // Expected: L ≈ 232.74°, B ≈ 14.59°, R ≈ 29.711 AU
      expect(lonDeg, closeTo(232.74071, 0.00001));
      expect(latDeg, closeTo(14.58782, 0.00001));
      expect(pos.r, closeTo(29.711111, 0.000001));
    });

    test('distance is roughly 30-50 AU', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final pos = heliocentric(jde);
      expect(pos.r, greaterThan(28));
      expect(pos.r, lessThan(50));
    });
  });
}
