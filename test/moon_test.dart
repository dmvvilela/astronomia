import 'dart:math' as math;

import 'package:astronomia/src/base/coord.dart';
import 'package:astronomia/src/moon/moon.dart' as moon;
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('moon physical', () {
    late Planet earth;

    setUpAll(() {
      earth = Planet(planetEarth);
    });

    test('physical returns valid librations', () {
      const jde = 2451545.0; // J2000
      final r = moon.physical(jde, earth);
      // Libration in longitude: typically ±8°
      expect(r.cMoon.lon.abs(), lessThan(15 * math.pi / 180));
      // Libration in latitude: typically ±7°
      expect(r.cMoon.lat.abs(), lessThan(15 * math.pi / 180));
      // P in reasonable range
      expect(r.p.isFinite, isTrue);
      // Sun coords finite
      expect(r.cSun.lon.isFinite, isTrue);
      expect(r.cSun.lat.isFinite, isTrue);
    });

    test('sunAltitude returns reasonable value', () {
      final site = Ecliptic(-20 * math.pi / 180, 9.7 * math.pi / 180); // Copernicus
      final sunCoord = Ecliptic(0.1, 0.05);
      final alt = moon.sunAltitude(site, sunCoord);
      expect(alt.isFinite, isTrue);
      expect(alt.abs(), lessThanOrEqualTo(math.pi / 2));
    });

    test('selenographic catalog has known craters', () {
      expect(moon.selenographic.containsKey('copernicus'), isTrue);
      expect(moon.selenographic.containsKey('tycho'), isTrue);
      expect(moon.selenographic.containsKey('plato'), isTrue);
      expect(moon.selenographic.length, equals(52));
    });

    test('sunrise/sunset bracket physical', () {
      const jde = 2451545.0;
      final site = moon.selenographic['copernicus']!;
      final sr = moon.sunrise(site, jde, earth);
      final ss = moon.sunset(site, jde, earth);
      // Both should be finite JDEs
      expect(sr.isFinite, isTrue);
      expect(ss.isFinite, isTrue);
      // Sunrise should differ from sunset
      expect((ss - sr).abs(), greaterThan(0));
    });
  });
}
