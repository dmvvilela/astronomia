import 'package:astronomia/src/sunrise/sunrise.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Sunrise', () {
    test('sunrise/sunset at equator near equinox', () {
      // Near March equinox, sunrise ~6am, sunset ~6pm
      final jd = calendarGregorianToJD(2000, 3, 20.0);
      final result = sunriseSunset(jd, 0, 0); // equator, Greenwich
      expect(result.rise, isNotNull);
      expect(result.set, isNotNull);
      // Rise and set should be roughly symmetric around noon
      final riseDay = jdToCalendar(result.rise!).day;
      final setDay = jdToCalendar(result.set!).day;
      // Sunrise and sunset should differ by roughly 12 hours
      expect(result.set! - result.rise!, closeTo(0.5, 0.1));
    });

    test('midnight sun at extreme latitude', () {
      // At 80°N in June, Sun never sets
      final jd = calendarGregorianToJD(2000, 6, 21.0);
      final result = sunriseSunset(jd, toRad(80), 0);
      // Should return null for rise/set (midnight sun)
      expect(result.rise, isNull);
      expect(result.set, isNull);
    });
  });
}
