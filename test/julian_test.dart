import 'package:astronomia/astronomia.dart';
import 'package:test/test.dart';

void main() {
  group('Julian Day', () {
    test('Meeus example 7.a - 1957 Oct 4.81', () {
      final jd = calendarGregorianToJD(1957, 10, 4.81);
      expect(jd, closeTo(2436116.31, 0.01));
    });

    test('J2000.0 epoch', () {
      final jd = calendarGregorianToJD(2000, 1, 1.5);
      expect(jd, equals(j2000));
    });

    test('round-trip conversion', () {
      final jd = calendarGregorianToJD(2024, 6, 15.0);
      final date = jdToCalendar(jd);
      expect(date.year, equals(2024));
      expect(date.month, equals(6));
      expect(date.day, closeTo(15.0, 0.0001));
    });

    test('day of year', () {
      expect(dayOfYear(1978, 11, 14), equals(318));
      expect(dayOfYear(1988, 4, 22), equals(113));
    });

    test('leap year', () {
      expect(isLeapYearGregorian(2000), isTrue);
      expect(isLeapYearGregorian(1900), isFalse);
      expect(isLeapYearGregorian(2024), isTrue);
      expect(isLeapYearGregorian(2023), isFalse);
    });
  });
}
