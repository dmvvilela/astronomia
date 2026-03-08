import 'package:astronomia/src/solarxyz/solarxyz.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Solarxyz', () {
    test('position at J2000 is reasonable', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final pos = position(jde);
      // At J2000, Sun should be roughly at x ≈ -0.18, y ≈ 0.97, z ≈ 0.42
      // (approximate, depends on exact formulation)
      final r = pos.x * pos.x + pos.y * pos.y + pos.z * pos.z;
      // Distance should be near 1 AU
      expect(r, closeTo(0.983 * 0.983, 0.02));
    });
  });
}
