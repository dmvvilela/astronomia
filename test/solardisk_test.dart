import 'dart:math' as math;
import 'package:astronomia/src/solardisk/solardisk.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('Solardisk', () {
    test('Carrington cycle 1 starts near known date', () {
      // Carrington rotation 1 began 1853 Nov 9.
      final jde = cycle(1);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(1853));
      expect(cal.month, equals(11));
    });

    test('Carrington period is ~27.28 days', () {
      final jde1 = cycle(1000);
      final jde2 = cycle(1001);
      expect(jde2 - jde1, closeTo(27.28, 0.1));
    });

    test('ephemeris returns reasonable values', () {
      final earth = Planet(planetEarth);
      final jde = calendarGregorianToJD(1992, 10, 13.0);
      final eph = ephemeris(jde, earth);
      // P should be within ±30°
      expect(toDeg(eph.p).abs(), lessThan(30));
      // B0 should be within ±7.25° (solar axis inclination)
      expect(toDeg(eph.b0).abs(), lessThan(7.3));
      // L0 should be in [0, 360°)
      expect(toDeg(eph.l0), greaterThanOrEqualTo(0));
      expect(toDeg(eph.l0), lessThan(360));
    });

    test('ephemeris B0 oscillates within bounds', () {
      final earth = Planet(planetEarth);
      // Check at different times of year.
      for (var month = 1; month <= 12; month++) {
        final jde = calendarGregorianToJD(2000, month, 15.0);
        final eph = ephemeris(jde, earth);
        expect(toDeg(eph.b0).abs(), lessThan(7.3));
      }
    });
  });
}
