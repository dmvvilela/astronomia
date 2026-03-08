import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Planetposition', () {
    test('Earth position2000 at J2000 gives L ~100°', () {
      // At J2000 epoch, Earth's heliocentric longitude is about 100°
      final earth = Planet(planetEarth);
      final pos = earth.position2000(j2000);
      final lonDeg = toDeg(pos.lon);
      expect(lonDeg, closeTo(100.46, 0.5));
      expect(pos.range, closeTo(0.9833, 0.01));
    });

    test('Earth range is ~1 AU', () {
      final earth = Planet(planetEarth);
      final pos = earth.position2000(2451545.0);
      expect(pos.range, closeTo(1.0, 0.02));
    });

    test('Mars is farther than Earth', () {
      final earth = Planet(planetEarth);
      final mars = Planet(planetMars);
      final jde = 2451545.0;
      expect(mars.position2000(jde).range,
          greaterThan(earth.position2000(jde).range));
    });

    test('Mercury is closer than Earth', () {
      final earth = Planet(planetEarth);
      final mercury = Planet(planetMercury);
      final jde = 2451545.0;
      expect(mercury.position2000(jde).range,
          lessThan(earth.position2000(jde).range));
    });

    test('position (of date) differs slightly from position2000', () {
      final earth = Planet(planetEarth);
      final jde = 2451545.0; // at J2000 they should be very close
      final p2000 = earth.position2000(jde);
      final pDate = earth.position(jde);
      // At J2000, the difference should be essentially zero
      expect((p2000.lon - pDate.lon).abs(), lessThan(0.001));
      expect(p2000.range, closeTo(pDate.range, 0.0001));
    });

    test('all planets return valid positions', () {
      for (var i = 0; i < 8; i++) {
        final planet = Planet(i);
        final pos = planet.position2000(2451545.0);
        expect(pos.lon.isFinite, isTrue);
        expect(pos.lat.isFinite, isTrue);
        expect(pos.range, greaterThan(0));
      }
    });

    test('Meeus example 25.b - Venus 1992 Dec 20', () {
      // From Meeus, Table 33.a (approximate comparison)
      final venus = Planet(planetVenus);
      final jde = calendarGregorianToJD(1992, 12, 20.0);
      final pos = venus.position2000(jde);
      final lonDeg = toDeg(pos.lon);
      // Venus heliocentric longitude should be around 26° at this date
      expect(lonDeg, closeTo(26.1, 1.0));
      expect(pos.range, closeTo(0.724, 0.01));
    });

    test('toFK5 returns close values', () {
      final result = toFK5(1.0, 0.1, 2451545.0);
      expect((result.lon - 1.0).abs(), lessThan(0.001));
      expect((result.lat - 0.1).abs(), lessThan(0.001));
    });

    test('Jupiter range ~5.2 AU', () {
      final jupiter = Planet(planetJupiter);
      final pos = jupiter.position2000(2451545.0);
      expect(pos.range, closeTo(5.2, 0.5));
    });
  });
}
