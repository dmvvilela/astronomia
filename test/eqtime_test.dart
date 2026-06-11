import 'package:astronomia/src/eqtime/eqtime.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('Eqtime', () {
    test('Meeus example 28.b - eSmart 1992 Oct 13', () {
      // Meeus p. 185: E = +13m42.7 = +0.0598256 rad
      final jde = calendarGregorianToJD(1992, 10, 13.0);
      expect(eSmart(jde), closeTo(0.0598256, 0.0000001));
    });

    test('Meeus example 28.b - VSOP87 e() agrees with eSmart', () {
      final earth = Planet(planetEarth);
      final jde = calendarGregorianToJD(1992, 10, 13.0);
      expect(e(jde, earth), closeTo(eSmart(jde), 0.00001));
    });

    test('L0 at epoch matches (28.2)', () {
      expect(l0(0), closeTo(280.4664567, 0.0000001));
    });
  });
}
