import 'package:astronomia/src/circle/circle.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Circle', () {
    test('three collinear points', () {
      final r = smallest(0, 0, toRad(1), 0, toRad(2), 0);
      expect(r.typeI, isTrue);
      expect(toDeg(r.diameter), closeTo(2, 0.01));
    });

    test('equilateral triangle', () {
      final r = smallest(0, toRad(1), toRad(1), toRad(-0.5), toRad(-1), toRad(-0.5));
      expect(r.diameter, greaterThan(0));
    });
  });
}
