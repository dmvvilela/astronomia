import 'package:astronomia/src/nutation/nutation.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Nutation', () {
    test('Meeus example 22.a - 1987 April 10', () {
      final jde = calendarGregorianToJD(1987, 4, 10.0);
      final n = nutation(jde);
      final arcsec = (double rad) => rad * 180 * 3600 / 3.141592653589793;
      expect(arcsec(n.dPsi), closeTo(-3.788, 0.001));
      expect(arcsec(n.dEps), closeTo(9.443, 0.001));
    });

    test('meanObliquity for 1987 April 10', () {
      final jde = calendarGregorianToJD(1987, 4, 10.0);
      final epsDeg = meanObliquity(jde) * 180 / 3.141592653589793;
      expect(epsDeg, closeTo(23.440946, 0.000001));
    });

    test('meanObliquityLaskar agrees with IAU 1980 near J2000', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final eps80 = meanObliquity(jde);
      final epsL = meanObliquityLaskar(jde);
      // Should agree within a few arcseconds near J2000
      expect((eps80 - epsL).abs(), lessThan(0.0001));
    });

    test('approxNutation agrees roughly with full nutation', () {
      final jde = calendarGregorianToJD(1987, 4, 10.0);
      final full = nutation(jde);
      final approx = approxNutation(jde);
      // Approximate should be within 1″ of full
      expect((full.dPsi - approx.dPsi).abs(), lessThan(0.000005));
      expect((full.dEps - approx.dEps).abs(), lessThan(0.000005));
    });
  });
}
