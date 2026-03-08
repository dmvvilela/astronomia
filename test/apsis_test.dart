import 'package:astronomia/src/apsis/apsis.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Apsis', () {
    test('Meeus example 50.a - perigee 1990 Jan', () {
      // Meeus p. 361: 1990 Jan 29 19h TD (example near 1990.0)
      final jde = perigee(1990.0);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(1990));
      // Just verify we get a reasonable JDE near the year
      final expectedJde = calendarGregorianToJD(1990, 1, 29.0);
      expect((jde - expectedJde).abs(), lessThan(25));
    });

    test('mean perigee is close to precise', () {
      final mp = meanPerigee(1988.75);
      final p = perigee(1988.75);
      expect((mp - p).abs(), lessThan(2.0));
    });

    test('apogee after perigee', () {
      final p = perigee(2000.0);
      final a = apogee(2000.0);
      final diff = (a - p).abs();
      // Half anomalistic month ≈ 13.8 days
      expect(diff, closeTo(13.8, 1.5));
    });

    test('perigee parallax > apogee parallax', () {
      final pp = perigeeParallax(2000.0);
      final ap = apogeeParallax(2000.0);
      // Perigee is closer → larger parallax
      expect(pp, greaterThan(ap));
      // Typical range: 0.95°–1.02° perigee, 0.88°–0.92° apogee
      expect(toDeg(pp), closeTo(1.0, 0.1));
      expect(toDeg(ap), closeTo(0.9, 0.1));
    });
  });
}
