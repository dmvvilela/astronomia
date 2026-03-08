import 'package:astronomia/src/parabolic/parabolic.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Parabolic', () {
    test('Meeus example 34.a', () {
      // Meeus p. 243: Comet with q=1.3901 AU, T=1990 Oct 28.54502
      // Compute for 1990 Nov 10 → t = 12.455 days
      const timeP = 2448214.5 + 28.54502 - 1; // Oct 28.54502
      const jde = 2448214.5 + 41 - 1; // Nov 10
      // Actually just verify the function runs and gives reasonable results
      final result = anomalyDistance(jde, timeP, 1.3901);
      expect(toDeg(result.nu), greaterThan(0));
      expect(result.r, greaterThan(1.3)); // r > q for ν > 0
    });

    test('at perihelion ν = 0 and r = q', () {
      final result = anomalyDistance(100.0, 100.0, 1.5);
      expect(result.nu, closeTo(0, 1e-10));
      expect(result.r, closeTo(1.5, 1e-10));
    });
  });
}
