import 'package:astronomia/src/deltat/deltat.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('DeltaT', () {
    test('interp10A for 1900', () {
      final jde = calendarGregorianToJD(1900, 1, 1.0);
      final dt = interp10A(jde);
      // ΔT around 1900 was about -2.8 seconds
      expect(dt, closeTo(-2.8, 1.0));
    });

    test('interp10A for 2000', () {
      final jde = calendarGregorianToJD(2000, 1, 1.0);
      final dt = interp10A(jde);
      // ΔT around 2000 was about 63.8 seconds
      expect(dt, closeTo(63.8, 1.0));
    });

    test('polyBefore948', () {
      final dt = polyBefore948(500);
      // ΔT should be large and positive for ancient dates
      expect(dt, greaterThan(4000));
    });

    test('poly948to1600', () {
      final dt = poly948to1600(1200);
      // ΔT around 1200 should be positive
      expect(dt, greaterThan(0));
    });

    test('polyAfter2000', () {
      final dt = polyAfter2000(2050);
      expect(dt, greaterThan(0));
    });

    test('poly1900to1997', () {
      final jde = calendarGregorianToJD(1950, 1, 1.0);
      final dt = poly1900to1997(jde);
      // ΔT around 1950 was about 29 seconds
      expect(dt, closeTo(29, 3));
    });
  });
}
