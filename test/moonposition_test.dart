import 'package:astronomia/src/moonposition/moonposition.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/nutation/nutation.dart' as nutation;
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Moonposition', () {
    test('Meeus example 47.a - 1992 Apr 12', () {
      // Meeus p. 342-343
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final pos = position(jde);
      // Expected: λ = 133.162655°, β = -3.229126°, Δ = 368409.7 km
      expect(toDeg(pos.lon) % 360, closeTo(133.162655, 0.00001));
      expect(toDeg(pos.lat), closeTo(-3.229126, 0.00001));
      expect(pos.delta, closeTo(368409.7, 0.1));
    });

    test('Meeus example 47.a - apparent longitude', () {
      // λ + Δψ = 133.167265°
      final jde = calendarGregorianToJD(1992, 4, 12.0);
      final pos = position(jde);
      final nut = nutation.nutation(jde);
      expect(toDeg(pos.lon + nut.dPsi), closeTo(133.167265, 0.00001));
    });

    test('Meeus example 47.a - parallax', () {
      // For Δ = 368409.7 km, π = 0.991990°
      final p = toDeg(parallax(368409.7));
      expect(p, closeTo(0.991990, 0.000005));
    });

    test('mean ascending node at J2000', () {
      // Leading polynomial term: Ω₀ = 125.0445479°
      final n = toDeg(node(j2000)) % 360;
      expect(n, closeTo(125.0445479, 0.0000001));
    });

    test('perigee longitude at J2000', () {
      // Leading polynomial term: ϖ₀ = 83.3532465°
      final p = toDeg(perigee(j2000)) % 360;
      expect(p, closeTo(83.3532465, 0.0000001));
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
