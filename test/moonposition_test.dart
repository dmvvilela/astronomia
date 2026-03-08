import 'package:astronomia/src/moonposition/moonposition.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Moonposition', () {
    test('Meeus example 47.a - 1992 Apr 12', () {
      // Meeus p. 342
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final pos = position(jde);
      final lonDeg = toDeg(pos.lon) % 360;
      final latDeg = toDeg(pos.lat);
      // Expected: λ ≈ 133.162°, β ≈ -3.229°, Δ ≈ 368409.7 km
      expect(lonDeg, closeTo(133.16, 0.1));
      expect(latDeg, closeTo(-3.23, 0.1));
      expect(pos.delta, closeTo(368409.7, 100));
    });

    test('parallax', () {
      // For a distance of ~368410 km, parallax ≈ 0.9913°
      final p = toDeg(parallax(368409.7));
      expect(p, closeTo(0.9913, 0.01));
    });

    test('mean ascending node at J2000', () {
      final n = toDeg(node(j2000)) % 360;
      // Ω₀ ≈ 125.04°
      expect(n, closeTo(125.04, 0.1));
    });

    test('perigee longitude at J2000', () {
      final p = toDeg(perigee(j2000)) % 360;
      // ϖ₀ ≈ 83.35°
      expect(p, closeTo(83.35, 0.1));
    });

    test('trueNode is close to mean node', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final mean = node(jde);
      final tr = trueNode(jde);
      // True node should be within ~2° of mean node
      expect(toDeg((tr - mean).abs()), lessThan(2.0));
    });
  });
}
