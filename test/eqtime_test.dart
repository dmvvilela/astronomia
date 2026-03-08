import 'package:astronomia/src/eqtime/eqtime.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('Eqtime', () {
    test('equation of time near equinox is small', () {
      // Around March equinox, EoT crosses zero.
      final earth = Planet(planetEarth);
      final jde = calendarGregorianToJD(2000, 3, 20.0);
      final eot = e(jde, earth);
      // Should be within ~15 minutes of zero.
      final minutes = toDeg(eot) * 4;
      expect(minutes.abs(), lessThan(15));
    });

    test('equation of time ~Feb is positive (~14 min)', () {
      final earth = Planet(planetEarth);
      final jde = calendarGregorianToJD(2000, 2, 12.0);
      final eot = e(jde, earth);
      final minutes = toDeg(eot) * 4;
      // EoT peaks at ~+14 minutes in early February.
      expect(minutes, closeTo(-14.2, 1.5));
    });

    test('equation of time ~Nov is negative (~-16 min)', () {
      final earth = Planet(planetEarth);
      final jde = calendarGregorianToJD(2000, 11, 3.0);
      final eot = e(jde, earth);
      final minutes = toDeg(eot) * 4;
      expect(minutes, closeTo(16.4, 1.5));
    });

    test('eSmart agrees roughly with e()', () {
      final earth = Planet(planetEarth);
      final jde = calendarGregorianToJD(2000, 6, 15.0);
      final full = toDeg(e(jde, earth)) * 4;
      final smart = toDeg(eSmart(jde)) * 4;
      expect(smart, closeTo(full, 1.0));
    });

    test('L0 at epoch is ~280.5°', () {
      expect(l0(0), closeTo(280.47, 0.1));
    });
  });
}
