import 'package:astronomia/src/planetary/planetary.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Planetary', () {
    test('Mars opposition 2020', () {
      // Mars opposition 2020 Oct 13
      final jde = marsOpp(2020.75);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
      expect(cal.month, equals(10));
      expect(cal.day, closeTo(13, 3));
    });

    test('Jupiter opposition 2019', () {
      // Jupiter opposition 2019 Jun 10
      final jde = jupiterOpp(2019.4);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2019));
      expect(cal.month, equals(6));
      expect(cal.day, closeTo(10, 3));
    });

    test('Saturn opposition 2020', () {
      // Saturn opposition 2020 Jul 20
      final jde = saturnOpp(2020.5);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
      expect(cal.month, equals(7));
      expect(cal.day, closeTo(20, 3));
    });

    test('Mercury east elongation returns angle', () {
      final r = mercuryEastElongation(2020.0);
      final elDeg = toDeg(r.elongation);
      // Greatest elongation should be 18°-28°
      expect(elDeg, greaterThan(15));
      expect(elDeg, lessThan(30));
    });

    test('Mercury west elongation returns angle', () {
      final r = mercuryWestElongation(2020.0);
      final elDeg = toDeg(r.elongation);
      expect(elDeg, greaterThan(15));
      expect(elDeg, lessThan(30));
    });

    test('Venus inferior conjunction', () {
      final jde = venusInfConj(2020.5);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
    });

    test('Saturn conjunction', () {
      final jde = saturnConj(2020.0);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
    });

    test('Uranus opposition', () {
      final jde = uranusOpp(2020.8);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
    });

    test('Neptune opposition', () {
      final jde = neptuneOpp(2020.7);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
    });

    test('Mars station 2', () {
      final jde = marsStation2(2020.9);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
    });
  });
}
