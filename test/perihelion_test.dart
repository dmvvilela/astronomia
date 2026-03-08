import 'package:astronomia/src/perihelion/perihelion.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Perihelion', () {
    test('Earth perihelion ~Jan each year', () {
      final jde = perihelion(earth, 2020.0);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
      expect(cal.month, equals(1));
      expect(cal.day, closeTo(5, 3));
    });

    test('Earth aphelion ~Jul each year', () {
      final jde = aphelion(earth, 2020.5);
      final cal = jdToCalendar(jde);
      expect(cal.year, equals(2020));
      expect(cal.month, equals(7));
    });

    test('Mars perihelion returns reasonable JDE', () {
      final jde = perihelion(mars, 2020.0);
      final cal = jdToCalendar(jde);
      expect(cal.year, anyOf(2019, 2020, 2021));
    });
  });
}
