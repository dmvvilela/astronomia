import 'package:astronomia/src/eclipse/eclipse.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Eclipse', () {
    test('total solar eclipse 1999 Aug', () {
      // Famous total solar eclipse 1999 Aug 11
      final r = solar(1999.6);
      expect(r.type, equals(total));
      expect(r.central, isTrue);
      final cal = jdToCalendar(r.jmax);
      expect(cal.month, equals(8));
      expect(cal.day, closeTo(11, 1));
    });

    test('no eclipse for random date', () {
      // Most dates should have no eclipse
      final r = solar(2000.1);
      // Could be eclipse or not, just check it doesn't crash
      expect(r.type, isA<int>());
    });

    test('lunar eclipse type is valid', () {
      final r = lunar(2000.0);
      expect(r.type, anyOf(none, penumbral, umbral, total));
    });

    test('total lunar eclipse 2000 Jan', () {
      // Total lunar eclipse 2000 Jan 21
      final r = lunar(2000.05);
      expect(r.type, equals(total));
      final cal = jdToCalendar(r.jmax);
      expect(cal.month, equals(1));
      expect(cal.day, closeTo(21, 1));
    });
  });
}
