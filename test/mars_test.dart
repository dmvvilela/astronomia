import 'dart:math' as math;

import 'package:astronomia/src/mars/mars.dart' as mars;
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:test/test.dart';

void main() {
  group('mars physical', () {
    late Planet earth;
    late Planet marsPlanet;

    setUpAll(() {
      earth = Planet(planetEarth);
      marsPlanet = Planet(planetMars);
    });

    test('Meeus example — 1992 Nov 9', () {
      // JDE for 1992 Nov 9 0h TDT (approx)
      const jde = 2448934.5;
      final r = mars.physical(jde, earth, marsPlanet);

      // DE should be a small angle (planetocentric declination of Earth)
      expect(r.dE.abs(), lessThan(math.pi / 4));
      // DS too
      expect(r.dS.abs(), lessThan(math.pi / 4));
      // omega should be in [0, 2pi)
      expect(r.omega, greaterThanOrEqualTo(0));
      expect(r.omega, lessThan(2 * math.pi));
      // P in [0, 2pi)
      expect(r.p, greaterThanOrEqualTo(0));
      expect(r.p, lessThan(2 * math.pi));
      // k fraction in [0, 1]
      expect(r.k, greaterThan(0));
      expect(r.k, lessThanOrEqualTo(1));
      // d positive
      expect(r.d, greaterThan(0));
      // defect positive
      expect(r.defect, greaterThanOrEqualTo(0));
    });

    test('k near 1 at opposition', () {
      // Mars opposition around 2020 Oct 13
      const jde = 2459136.5;
      final r = mars.physical(jde, earth, marsPlanet);
      expect(r.k, greaterThan(0.95));
    });

    test('all results are finite', () {
      const jde = 2451545.0; // J2000
      final r = mars.physical(jde, earth, marsPlanet);
      expect(r.dE.isFinite, isTrue);
      expect(r.dS.isFinite, isTrue);
      expect(r.omega.isFinite, isTrue);
      expect(r.p.isFinite, isTrue);
      expect(r.q.isFinite, isTrue);
      expect(r.d.isFinite, isTrue);
      expect(r.k.isFinite, isTrue);
      expect(r.defect.isFinite, isTrue);
    });
  });
}
