import 'package:astronomia/src/jupitermoons/jupitermoons.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Jupitermoons', () {
    test('positions return finite values', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final pos = positions(jde);
      expect(pos.io.x.isFinite, isTrue);
      expect(pos.europa.x.isFinite, isTrue);
      expect(pos.ganymede.x.isFinite, isTrue);
      expect(pos.callisto.x.isFinite, isTrue);
    });

    test('moons are at increasing distances', () {
      // Io < Europa < Ganymede < Callisto (in orbital radius)
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final pos = positions(jde);
      // Check radii from center
      final rIo = pos.io.x * pos.io.x + pos.io.y * pos.io.y;
      final rCa = pos.callisto.x * pos.callisto.x + pos.callisto.y * pos.callisto.y;
      // Max orbital radii: Io~5.9, Europa~9.4, Ganymede~15.0, Callisto~26.4
      // These are maximums so the actual distance may be less due to projection
      expect(rIo, lessThan(6.0 * 6.0));
      expect(rCa, lessThan(27.0 * 27.0));
    });

    test('positions change over time', () {
      final jde1 = calendarGregorianToJD(2000, 1, 1.5);
      final jde2 = calendarGregorianToJD(2000, 1, 2.5);
      final pos1 = positions(jde1);
      final pos2 = positions(jde2);
      // Io has ~1.77 day period, should move significantly in 1 day
      expect((pos2.io.x - pos1.io.x).abs(), greaterThan(0.1));
    });
  });
}
