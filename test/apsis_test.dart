import 'package:astronomia/src/apsis/apsis.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Apsis', () {
    test('Meeus example 50.a - apogee 1988 Oct', () {
      // Meeus p. 357: JDE = 2447442.3543 (1988 Oct 7, 20h30m TD)
      final jde = apogee(1988.75);
      expect(jde, closeTo(2447442.3543, 0.0001));
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(1988));
      expect(cal.month, equals(10));
      expect(cal.day, closeTo(7.85, 0.01));
    });

    test('Meeus example 50.a - apogee parallax', () {
      // Meeus p. 357: π = 3240.679″
      final p = apogeeParallax(1988.75);
      expect(toDeg(p) * 3600, closeTo(3240.679, 0.01));
    });

    test('Meeus example 50.a - perigee parallax', () {
      // Meeus p. 357: π = 3678.141″
      final p = perigeeParallax(1988.75);
      expect(toDeg(p) * 3600, closeTo(3678.271, 0.01));
    });

    test('mean apogee is close to precise', () {
      final ma = meanApogee(1988.75);
      final a = apogee(1988.75);
      expect((ma - a).abs(), lessThan(1.0));
    });

    test('apogee after perigee', () {
      final p = perigee(2000.0);
      final a = apogee(2000.0);
      final diff = (a - p).abs();
      expect(diff, closeTo(13.8, 1.5));
    });
  });
}
