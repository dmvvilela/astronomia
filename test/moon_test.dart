import 'dart:math' as math;

import 'package:astronomia/src/base/coord.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/moon/moon.dart' as moon;
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('moon physical', () {
    late Planet earth;

    setUpAll(() {
      earth = Planet(planetEarth);
    });

    test('Meeus example 53.a - physical ephemeris 1992 Apr 12', () {
      // Meeus p. 374: l = -1.23°, b = +4.20°, P = 15.08°,
      // selenographic Sun l0 = 67.90°, b0 = +1.46°
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final r = moon.physical(jde, earth);
      const r2d = 180 / math.pi;
      expect(r.cMoon.lon * r2d, closeTo(-1.23, 0.005));
      expect(r.cMoon.lat * r2d, closeTo(4.20, 0.005));
      expect(r.p * r2d, closeTo(15.08, 0.005));
      expect(r.cSun.lon * r2d, closeTo(67.90, 0.005));
      expect(r.cSun.lat * r2d, closeTo(1.46, 0.005));
    });

    test('sunAltitude at Copernicus for 1992 Apr 12', () {
      // Reference example: h = +2.318°
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final r = moon.physical(jde, earth);
      final site = Ecliptic(-20 * math.pi / 180, 9.7 * math.pi / 180);
      final alt = moon.sunAltitude(site, r.cSun);
      expect(alt * 180 / math.pi, closeTo(2.318, 0.001));
    });

    test('sunrise at Copernicus near 1992 Apr 15', () {
      // Reference example: 1992 April 11.8069 TD
      final j0 = calendarGregorianToJD(1992, 4, 15.0);
      final site = Ecliptic(-20 * math.pi / 180, 9.7 * math.pi / 180);
      final sr = moon.sunrise(site, j0, earth);
      final cal = jdToCalendar(sr);
      expect(cal.month, equals(4));
      expect(cal.day, closeTo(11.8069, 0.0005));
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
