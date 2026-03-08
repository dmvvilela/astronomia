import 'package:astronomia/src/planetelements/planetelements.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Planetelements', () {
    test('Earth eccentricity at J2000', () {
      final e = mean(earth, j2000);
      expect(e.ecc, closeTo(0.01671, 0.001));
    });

    test('Earth semimajor axis is 1 AU', () {
      final e = mean(earth, j2000);
      expect(e.axis, closeTo(1.0, 0.001));
    });

    test('Mars eccentricity', () {
      final e = mean(mars, j2000);
      expect(e.ecc, closeTo(0.0934, 0.001));
    });

    test('Jupiter semimajor axis ~5.2 AU', () {
      final e = mean(jupiter, j2000);
      expect(e.axis, closeTo(5.2026, 0.01));
    });

    test('Mercury inclination ~7°', () {
      final i = toDeg(inc(mercury, j2000));
      expect(i, closeTo(7.005, 0.1));
    });

    test('all planets have positive axis', () {
      for (var p = 0; p < 8; p++) {
        final e = mean(p, j2000);
        expect(e.axis, greaterThan(0));
      }
    });

    test('node function matches mean', () {
      final n = node(mars, j2000);
      final e = mean(mars, j2000);
      expect(n, closeTo(e.node, 1e-10));
    });
  });
}
