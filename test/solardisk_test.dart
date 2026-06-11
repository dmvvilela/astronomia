import 'package:astronomia/src/solardisk/solardisk.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('Solardisk', () {
    test('Meeus example 29.a - ephemeris 1992 Oct 13', () {
      // Meeus p. 189: P = 26°.27, B0 = +5°.99, L0 = 238°.63
      // JDE = 2448908.50068 (ΔT = +59s)
      final earth = Planet(planetEarth);
      final eph = ephemeris(2448908.50068, earth);
      expect(toDeg(eph.p), closeTo(26.27, 0.01));
      expect(toDeg(eph.b0), closeTo(5.99, 0.01));
      expect(toDeg(eph.l0), closeTo(238.643, 0.001));
    });

    test('Meeus example 28.b - Carrington cycle 1699', () {
      // Meeus p. 180: JDE = 2444480.7230
      expect(cycle(1699), closeTo(2444480.7230, 0.0001));
    });

    test('Carrington period is ~27.28 days', () {
      expect(cycle(1001) - cycle(1000), closeTo(27.199, 0.01));
    });
  });
}
