import 'package:astronomia/src/apparent/apparent.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Apparent', () {
    test('nutation correction returns reasonable values', () {
      final jd = calendarGregorianToJD(2000, 1, 1.5);
      final ra = toRad(100);
      final dec = toRad(30);
      final corr = nutationCorrection(ra, dec, jd);
      // Nutation corrections should be small (< 1 arcmin)
      expect(corr.dAlpha.abs(), lessThan(toRad(1 / 60)));
      expect(corr.dDelta.abs(), lessThan(toRad(1 / 60)));
    });

    test('kappa is about 20.5 arcseconds', () {
      final kappaSec = toDeg(kappa) * 3600;
      expect(kappaSec, closeTo(20.4955, 0.001));
    });
  });
}
