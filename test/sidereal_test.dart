import 'package:astronomia/src/sidereal/sidereal.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Sidereal', () {
    test('Meeus example 12.a - mean sidereal time', () {
      // Meeus p. 88: 1987 April 10, 0h UT, JD = 2446895.5
      // Expected: 13h 10m 46.3668s
      const jd = 2446895.5;
      final hours = siderealToHours(mean(jd));
      expect(hours, closeTo(13.179546, 0.000001));
    });

    test('Meeus example 12.a - apparent sidereal time', () {
      // Expected: 13h 10m 46.1351s
      const jd = 2446895.5;
      final hours = siderealToHours(apparent(jd));
      expect(hours, closeTo(13.179482, 0.000001));
    });

    test('Meeus example 12.b - mean sidereal time', () {
      // Meeus p. 89: 1987 April 10, 19h 21m 00s UT
      final jd = calendarGregorianToJD(1987, 4, 10) + (19 + 21 / 60) / 24;
      final hours = siderealToHours(mean(jd));
      expect(hours, closeTo(8.582525, 0.000001));
    });

    test('result is in range [0, 86400)', () {
      final jd = calendarGregorianToJD(2024, 6, 15.0);
      final s = mean0UT(jd);
      expect(s, greaterThanOrEqualTo(0));
      expect(s, lessThan(86400));
    });
  });
}
