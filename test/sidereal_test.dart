import 'package:astronomia/src/sidereal/sidereal.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Sidereal', () {
    test('mean0UT for Meeus example 12.a', () {
      // Meeus p. 88: 1987 April 10, 0h UT
      final jd = calendarGregorianToJD(1987, 4, 10.0);
      final s = mean0UT(jd);
      // Expected: 13h 08m 46.8461s = 47326.8461s
      final hours = siderealToHours(s);
      expect(hours, closeTo(13.1795, 0.05));
    });

    test('mean for Meeus example 12.b', () {
      // Meeus p. 89: 1987 April 10, 19h 21m 00s UT
      // JD = 2446896.0 + 19.35/24
      final jd = calendarGregorianToJD(1987, 4, 10.0) + 19.35 / 24;
      final s = mean(jd);
      final hours = siderealToHours(s);
      // Expected: about 8h 34m = 8.57h
      expect(hours, closeTo(8.58, 0.1));
    });

    test('result is in range [0, 86400)', () {
      final jd = calendarGregorianToJD(2024, 6, 15.0);
      final s = mean0UT(jd);
      expect(s, greaterThanOrEqualTo(0));
      expect(s, lessThan(86400));
    });
  });
}
