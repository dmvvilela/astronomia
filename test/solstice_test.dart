import 'package:astronomia/src/solstice/solstice.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Solstice', () {
    test('March equinox 2000', () {
      final jde = march(2000);
      final date = jdToCalendar(jde);
      expect(date.month, equals(3));
      expect(date.day, closeTo(20.0, 1.0));
    });

    test('June solstice 2000', () {
      final jde = june(2000);
      final date = jdToCalendar(jde);
      expect(date.month, equals(6));
      expect(date.day, closeTo(21.0, 1.0));
    });

    test('September equinox 2000', () {
      final jde = september(2000);
      final date = jdToCalendar(jde);
      expect(date.month, equals(9));
      expect(date.day, closeTo(22.0, 1.0));
    });

    test('December solstice 2000', () {
      final jde = december(2000);
      final date = jdToCalendar(jde);
      expect(date.month, equals(12));
      expect(date.day, closeTo(21.0, 1.0));
    });

    test('March equinox 1962 (Meeus example 27.a)', () {
      final jde = march(1962);
      final date = jdToCalendar(jde);
      expect(date.month, equals(3));
      // Expected: March 21 around 2h
      expect(date.day, closeTo(21.0, 0.5));
    });
  });
}
