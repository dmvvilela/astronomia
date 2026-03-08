import 'package:astronomia/src/nearparabolic/nearparabolic.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Nearparabolic', () {
    test('reduces to parabolic when e=1', () {
      final result = anomalyDistance(112.0, 100.0, 1.5, 1.0);
      expect(toDeg(result.nu), greaterThan(0));
      expect(result.r, greaterThan(1.5));
    });

    test('at perihelion ν=0, r=q', () {
      final result = anomalyDistance(100.0, 100.0, 1.5, 0.99);
      expect(result.nu, closeTo(0, 1e-10));
      expect(result.r, closeTo(1.5, 1e-10));
    });

    test('e slightly less than 1 gives bounded orbit', () {
      final result = anomalyDistance(120.0, 100.0, 0.5, 0.995);
      expect(result.nu.isFinite, isTrue);
      expect(result.r.isFinite, isTrue);
      expect(result.r, greaterThan(0));
    });
  });
}
