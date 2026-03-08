import 'package:astronomia/src/fit/fit.dart';
import 'package:test/test.dart';

void main() {
  group('linear', () {
    test('fits a straight line', () {
      final data = [
        (x: 1.0, y: 2.0),
        (x: 2.0, y: 4.0),
        (x: 3.0, y: 6.0),
        (x: 4.0, y: 8.0),
      ];
      final result = linear(data);
      expect(result.a, closeTo(2.0, 0.0001));
      expect(result.b, closeTo(0.0, 0.0001));
    });

    test('Meeus example - linear fit', () {
      // Table 4.a, p. 37
      final data = [
        (x: 73.0, y: 2.2),
        (x: 38.0, y: 0.8),
        (x: 35.0, y: 2.0),
        (x: 42.0, y: 1.2),
        (x: 78.0, y: 3.2),
        (x: 68.0, y: 2.5),
        (x: 74.0, y: 2.7),
        (x: 42.0, y: 1.4),
        (x: 52.0, y: 1.6),
        (x: 54.0, y: 2.1),
      ];
      final result = linear(data);
      expect(result.a, closeTo(0.0376, 0.001));
    });
  });

  group('correlationCoefficient', () {
    test('perfect correlation', () {
      final data = [
        (x: 1.0, y: 2.0),
        (x: 2.0, y: 4.0),
        (x: 3.0, y: 6.0),
      ];
      expect(correlationCoefficient(data), closeTo(1.0, 0.0001));
    });
  });

  group('quadratic', () {
    test('fits y = x^2', () {
      final data = [
        (x: -2.0, y: 4.0),
        (x: -1.0, y: 1.0),
        (x: 0.0, y: 0.0),
        (x: 1.0, y: 1.0),
        (x: 2.0, y: 4.0),
      ];
      final result = quadratic(data);
      expect(result.a, closeTo(1.0, 0.0001));
      expect(result.b, closeTo(0.0, 0.0001));
      expect(result.c, closeTo(0.0, 0.0001));
    });
  });

  group('func1', () {
    test('fits coefficient', () {
      final data = [
        (x: 1.0, y: 3.0),
        (x: 2.0, y: 6.0),
        (x: 3.0, y: 9.0),
      ];
      final a = func1(data, (x) => x);
      expect(a, closeTo(3.0, 0.0001));
    });
  });
}
