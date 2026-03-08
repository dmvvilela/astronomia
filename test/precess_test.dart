import 'package:astronomia/src/precess/precess.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Precession', () {
    test('Meeus example 21.b - Theta Persei', () {
      // From J2000.0 to J2028.5 (epoch 2028.5)
      // α = 2h 44m 11.986s = 41.04994°
      // δ = 49° 13′ 42.48″ = 49.22847°
      final ra = toRad(41.04994);
      final dec = toRad(49.22847);
      // Proper motions converted to rad/year
      final mAlpha = toRad(0.03425 / 3600 * 15); // 0.03425s in RA
      final mDelta = toRad(-0.0895 / 3600); // -0.0895″ in Dec

      final result = position(ra, dec, 2000, 2028.5, mAlpha, mDelta);
      final raDeg = toDeg(result.ra);
      final decDeg = toDeg(result.dec);
      // Expected: α ≈ 2h 46m 12s ≈ 41.55°, δ ≈ 49°21′ ≈ 49.35°
      expect(raDeg, closeTo(41.55, 0.1));
      expect(decDeg, closeTo(49.35, 0.1));
    });

    test('identity precession (same epoch)', () {
      final ra = toRad(100);
      final dec = toRad(30);
      final result = position(ra, dec, 2000, 2000, 0, 0);
      expect(result.ra, closeTo(ra, 0.0001));
      expect(result.dec, closeTo(dec, 0.0001));
    });

    test('EclipticPrecessor roundtrip', () {
      final p1 = EclipticPrecessor(2000, 2050);
      final p2 = EclipticPrecessor(2050, 2000);
      const lon = 2.0;
      const lat = 0.3;
      final fwd = p1.precess(lon, lat);
      final back = p2.precess(fwd.lon, fwd.lat);
      expect(back.lon, closeTo(lon, 0.0001));
      expect(back.lat, closeTo(lat, 0.0001));
    });
  });
}
