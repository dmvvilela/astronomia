import 'dart:math' as math;
import 'package:astronomia/src/binary/binary.dart';
import 'package:test/test.dart';

void main() {
  group('Binary', () {
    test('mean anomaly at periastron is 0', () {
      expect(meanAnomaly(2000, 2000, 50), closeTo(0, 1e-10));
    });

    test('mean anomaly after half period is π', () {
      expect(meanAnomaly(2025, 2000, 50), closeTo(math.pi, 0.01));
    });

    test('apparent eccentricity with i=0 equals true eccentricity', () {
      // Face-on orbit: apparent e = true e
      expect(apparentEccentricity(0.5, 0, 0), closeTo(0.5, 0.01));
    });
  });
}
