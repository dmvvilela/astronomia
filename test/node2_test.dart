import 'dart:math' as math;
import 'package:astronomia/src/node2/node2.dart';
import 'package:test/test.dart';

void main() {
  group('Node2', () {
    test('elliptic ascending and descending are different', () {
      final a = ellipticAscending(2.0, 0.5, math.pi / 4, 2451545.0);
      final d = ellipticDescending(2.0, 0.5, math.pi / 4, 2451545.0);
      expect((a.jde - d.jde).abs(), greaterThan(0));
    });

    test('parabolic ascending returns positive distance', () {
      final a = parabolicAscending(1.0, math.pi / 6, 2451545.0);
      expect(a.r, greaterThan(0));
    });

    test('parabolic descending returns positive distance', () {
      final d = parabolicDescending(1.0, math.pi / 3, 2451545.0);
      expect(d.r, greaterThan(0));
    });
  });
}
