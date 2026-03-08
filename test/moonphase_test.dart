import 'package:astronomia/src/moonphase/moonphase.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Moonphase', () {
    test('Meeus example 49.a - New Moon 1977 Feb', () {
      // Meeus p. 353: New Moon 1977 Feb 18 03:37 TD
      final jde = newMoon(1977.13);
      final cal = jdToCalendar(jde);
      expect(cal.month, equals(2));
      expect(cal.day, closeTo(18.15, 0.1)); // ~03:37 is day 18.15
    });

    test('mean new moon is close to precise', () {
      final mn = meanNew(1977.13);
      final n = newMoon(1977.13);
      // Mean and precise should be within ~1 day
      expect((mn - n).abs(), lessThan(1.0));
    });

    test('full moon is ~14.75 days after new moon', () {
      final n = newMoon(2000.0);
      final f = full(2000.0);
      final diff = (f - n).abs();
      // Should be roughly half a synodic month (~14.75 days)
      expect(diff, closeTo(14.76, 1.0));
    });

    test('first quarter is ~7.4 days after new moon', () {
      final n = newMoon(2000.25);
      final fq = first(2000.25);
      final diff = (fq - n).abs();
      // Quarter synodic month ≈ 7.38 days
      expect(diff, closeTo(7.38, 1.0));
    });

    test('mean functions return reasonable JDEs', () {
      final mn = meanNew(2000.0);
      final mfirst = meanFirst(2000.0);
      final mfull = meanFull(2000.0);
      final mlast = meanLast(2000.0);
      // All should be near J2000
      for (final jde in [mn, mfirst, mfull, mlast]) {
        expect((jde - j2000).abs(), lessThan(365.0));
      }
    });
  });
}
