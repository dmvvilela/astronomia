import 'package:astronomia/src/interpolation/interpolation.dart';
import 'package:test/test.dart';

void main() {
  group('Len3', () {
    test('interpolateN for quadratic data', () {
      // y = x^2: [1, 4, 9] at x = [1, 2, 3]
      final d = Len3(1, 3, [1.0, 4.0, 9.0]);
      // n=0.5 means x=2.5, y should be 6.25
      expect(d.interpolateN(0.5), closeTo(6.25, 0.0001));
    });

    test('interpolateX for known linear data', () {
      // y = 2x: exact interpolation
      final d = Len3(1, 3, [2.0, 4.0, 6.0]);
      expect(d.interpolateX(1.5), closeTo(3.0, 0.0001));
      expect(d.interpolateX(2.5), closeTo(5.0, 0.0001));
    });

    test('extremum', () {
      // Meeus Example 3.b
      final d = Len3(12, 20, [1.3814294, 1.3812213, 1.3812453]);
      final ext = d.extremum();
      expect(ext.x, closeTo(17.5, 0.1));
    });

    test('zero', () {
      // Meeus Example 3.c
      final d = Len3(26, 28, [-1693.4, 406.3, 2303.2]);
      final x = d.zero(strong: false);
      expect(x, closeTo(26.79873, 0.00001));
    });

    test('forInterpolateX from larger table', () {
      final y = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0];
      final d = Len3.forInterpolateX(3.5, 1.0, 7.0, y);
      final result = d.interpolateX(3.5);
      expect(result, closeTo(3.5, 0.0001));
    });
  });

  group('Len5', () {
    test('interpolateX for polynomial', () {
      // y = x^2, should interpolate exactly for degree <= 4
      final d = Len5(1, 5, [1.0, 4.0, 9.0, 16.0, 25.0]);
      final y = d.interpolateX(3.5);
      expect(y, closeTo(12.25, 0.0001));
    });

    test('interpolateX for known function', () {
      // y = x^2, should interpolate exactly for polynomial of degree <= 4
      final d = Len5(1, 5, [1.0, 4.0, 9.0, 16.0, 25.0]);
      expect(d.interpolateX(2.5), closeTo(6.25, 0.0001));
      expect(d.interpolateX(4.0), closeTo(16.0, 0.0001));
    });
  });

  group('len4Half', () {
    test('interpolates center value', () {
      final result = len4Half([1.0, 4.0, 9.0, 16.0]);
      // (9*(4+9) - 1 - 16) / 16 = (117 - 17) / 16 = 6.25
      expect(result, closeTo(6.25, 0.0001));
    });
  });

  group('lagrange', () {
    test('interpolates unequally spaced data', () {
      final table = [
        (x: 1.0, y: 1.0),
        (x: 3.0, y: 9.0),
        (x: 5.0, y: 25.0),
      ];
      final y = lagrange(2.0, table);
      expect(y, closeTo(4.0, 0.0001));
    });
  });
}
