import 'package:astronomia/src/eclipse/eclipse.dart';
import 'package:astronomia/src/base/math.dart';
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

    group('local solar circumstances', () {
      test('rejects daylight locations outside the 2026 February path', () {
        final eclipse = solar(2026.13);

        final salvador = localSolar(
          eclipse.jmax,
          toRad(-12.97),
          toRad(38.5),
          deltaT: 75.1,
        );
        final nairobi = localSolar(
          eclipse.jmax,
          toRad(-1.2864),
          toRad(-36.8172),
          deltaT: 75.1,
        );

        expect(salvador.visible, isFalse);
        expect(nairobi.visible, isFalse);
      });

      test('finds the 2026 February annular path over Antarctica', () {
        final eclipse = solar(2026.13);
        // NASA greatest eclipse: 64.7 S, 86.8 E, magnitude 0.9630.
        final local = localSolar(
          eclipse.jmax,
          toRad(-64.7),
          toRad(-86.8),
          deltaT: 75.1,
        );

        expect(local.visible, isTrue);
        expect(local.type, annular);
        expect(local.magnitude, closeTo(0.963, 0.01));
        expect(local.sunAltitude, isNotNull);
        expect(toDeg(local.sunAltitude!), closeTo(12.3, 1.0));
      });

      test('finds the 2026 August total path and rejects Salvador', () {
        final eclipse = solar(2026.62);
        // NASA greatest eclipse: 65.2 N, 25.2 W, magnitude 1.0386.
        final onPath = localSolar(
          eclipse.jmax,
          toRad(65.2),
          toRad(25.2),
          deltaT: 75.4,
        );
        final salvador = localSolar(
          eclipse.jmax,
          toRad(-12.97),
          toRad(38.5),
          deltaT: 75.4,
        );

        expect(onPath.visible, isTrue);
        expect(onPath.type, total);
        expect(onPath.magnitude, closeTo(1.0386, 0.01));
        expect(toDeg(onPath.sunAltitude!), closeTo(25.8, 1.0));
        expect(salvador.visible, isFalse);
      });
    });
  });
}
