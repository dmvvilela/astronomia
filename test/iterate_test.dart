import 'package:astronomia/src/iterate/iterate.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('decimalPlaces', () {
    test('cos iteration converges', () {
      // Example from Meeus p. 48: iterating x = cos(x)
      final result = decimalPlaces(math.cos, 1.0, places: 6);
      expect(result, closeTo(0.739085, 0.000001));
    });
  });

  group('fullPrecision', () {
    test('cos iteration converges', () {
      final result = fullPrecision(math.cos, 1.0, maxIterations: 200);
      expect(result, closeTo(0.7390851332151607, 1e-10));
    });
  });

  group('binaryRoot', () {
    test('finds root of x^2 - 2', () {
      final root = binaryRoot((x) => x * x - 2, 1.0, 2.0);
      expect(root, closeTo(math.sqrt2, 1e-14));
    });

    test('finds root of sin', () {
      final root = binaryRoot(math.sin, 3.0, 4.0);
      expect(root, closeTo(math.pi, 1e-14));
    });
  });
}
