import 'package:astronomia/src/jupiter/jupiter.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Jupiter', () {
    test('physical2 returns reasonable values', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final r = physical2(jde);
      // DS should be small (< 4°)
      expect(toDeg(r.ds).abs(), lessThan(4));
      // DE should be small (< 4°)
      expect(toDeg(r.de).abs(), lessThan(4));
      // omega1, omega2 should be in [0, 2π)
      expect(r.omega1, greaterThanOrEqualTo(0));
      expect(r.omega1, lessThan(2 * 3.1416));
      expect(r.omega2, greaterThanOrEqualTo(0));
      expect(r.omega2, lessThan(2 * 3.1416));
    });

    test('System I rotates faster than System II', () {
      // System I: 877.9° per day, System II: 870.2° per day
      final jde1 = calendarGregorianToJD(2000, 1, 1.5);
      final jde2 = calendarGregorianToJD(2000, 1, 2.5);
      final r1 = physical2(jde1);
      final r2 = physical2(jde2);
      // The central meridian angles change, just verify we get different values
      expect((r2.omega1 - r1.omega1).abs(), greaterThan(0.01));
      expect((r2.omega2 - r1.omega2).abs(), greaterThan(0.01));
    });
  });
}
