import 'package:astronomia/src/moonmaxdec/moonmaxdec.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Moonmaxdec', () {
    test('Meeus example 52.a - north 1988 Dec', () {
      // Meeus p. 370: JDE = 2447518.3347 (1988 Dec 22, 20:02 TD), δ = +28.1562°
      final r = north(1988.95);
      expect(r.jde, closeTo(2447518.3347, 0.0001));
      expect(toDeg(r.dec), closeTo(28.1562, 0.0001));
      final cal = jdToCalendar(r.jde);
      expect(cal.month, equals(12));
      expect(cal.day, closeTo(22.83, 0.01));
    });

    test('south declination is negative', () {
      final r = south(2000.0);
      expect(r.dec, lessThan(0));
      // Magnitude should be roughly 18°–29°
      final decDeg = toDeg(r.dec.abs());
      expect(decDeg, greaterThan(18));
      expect(decDeg, lessThan(30));
    });

    test('north declination is positive', () {
      final r = north(2000.0);
      expect(r.dec, greaterThan(0));
      final decDeg = toDeg(r.dec);
      expect(decDeg, greaterThan(18));
      expect(decDeg, lessThan(30));
    });

    test('events are ~27.3 days apart', () {
      final r1 = north(2000.0);
      final r2 = north(2000.0 + 27.4 / 365.25);
      final diff = (r2.jde - r1.jde).abs();
      expect(diff, closeTo(27.32, 0.5));
    });
  });
}
