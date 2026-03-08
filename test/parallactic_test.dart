import 'dart:math' as math;
import 'package:astronomia/src/parallactic/parallactic.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Parallactic', () {
    test('parallacticAngle returns reasonable value', () {
      final phi = toRad(51.5); // London
      final dec = toRad(30);
      final h = toRad(30); // hour angle 2h
      final q = parallacticAngle(phi, dec, h);
      // Should be some angle between -π and π
      expect(q.abs(), lessThan(math.pi));
    });

    test('eclipticAtHorizon', () {
      final eps = toRad(23.44);
      final phi = toRad(51);
      final theta = toRad(90);
      final result = eclipticAtHorizon(eps, phi, theta);
      // λ2 should be λ1 + π
      expect(result.lambda2, closeTo(result.lambda1 + math.pi, 0.0001));
      // Angle should be positive
      expect(result.i, greaterThan(0));
    });
  });
}
