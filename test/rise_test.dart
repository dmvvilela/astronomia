import 'dart:math' as math;
import 'package:astronomia/src/rise/rise.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:astronomia/src/sidereal/sidereal.dart';
import 'package:astronomia/src/coord/coord.dart';
import 'package:astronomia/src/moonposition/moonposition.dart' as moon;
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Rise', () {
    test('Meeus example 15.a - Venus 1988 Mar 20', () {
      // Meeus example 15.a, p. 103.
      // Boston: 42°20'N, 71°5'W
      final lat = toRad(42 + 20 / 60);
      final lon = toRad(71 + 5 / 60); // positive west

      // Venus RA/dec for Mar 19, 20, 21 (dynamical time).
      // Original alpha3 attempt replaced by a3 below.

      // Meeus gives: α = 2h42m44s, 2h46m55s, 2h51m07s
      //              δ = +18°02', +18°26', +18°50'
      final a3 = [
        toRad((2 + 42 / 60 + 44 / 3600) * 15),
        toRad((2 + 46 / 60 + 55 / 3600) * 15),
        toRad((2 + 51 / 60 + 7 / 3600) * 15),
      ];
      final d3 = [
        toRad(18 + 2 / 60),
        toRad(18 + 26 / 60),
        toRad(18 + 50 / 60),
      ];
      // Th0 = 11h50m58.10s = 42658.10 seconds
      final th0 = 11 * 3600 + 50 * 60 + 58.10;
      // ΔT = 56s
      final deltaT = 56.0;

      final rs = times(lat, lon, deltaT, stdh0Stellar, th0, a3, d3);
      expect(rs, isNotNull);

      // Expected: rise ~12h26m, transit ~19h41m, set ~2h54m (next day)
      final riseH = rs!.rise / 3600;
      final transitH = rs.transit / 3600;
      final setH = rs.set / 3600;

      expect(riseH, closeTo(12.43, 0.15)); // ~12h26m
      expect(transitH, closeTo(19.69, 0.15)); // ~19h41m
      expect(setH, closeTo(2.9, 0.3)); // ~2h54m (next day shown as early morning)
    });

    test('approxTimes returns null for circumpolar', () {
      // Star at +85° declination seen from +80° latitude — circumpolar.
      final result = approxTimes(
          toRad(80), toRad(0), stdh0Stellar, 0, 0, toRad(85));
      expect(result, isNull);
    });

    test('approxTimes returns null for never-rises', () {
      // Star at -85° declination seen from +80° latitude — never rises.
      final result = approxTimes(
          toRad(80), toRad(0), stdh0Stellar, 0, 0, toRad(-85));
      expect(result, isNull);
    });

    test('hourAngle for circumpolar returns null', () {
      expect(hourAngle(toRad(80), stdh0Stellar, toRad(85)), isNull);
    });

    test('hourAngle at equator for equatorial star ~6h', () {
      final ha = hourAngle(0, stdh0Stellar, 0);
      expect(ha, isNotNull);
      // Should be close to π/2 (6 hours = 90°)
      expect(ha!, closeTo(math.pi / 2, 0.02));
    });

    test('lunar h0 is positive (Moon rises above geometric horizon)', () {
      // Moon parallax ~0.95° ≈ 0.0166 rad
      final h0 = stdh0Lunar(toRad(0.95));
      expect(h0, greaterThan(0));
    });

    test('moonTimes returns reasonable values', () {
      // 2020 Jan 1, observer at Greenwich
      final jd = calendarGregorianToJD(2020, 1, 1.0);
      final th0 = apparent0UT(jd);
      final lat = toRad(51.5); // London
      final lon = toRad(0); // Greenwich

      // Moon coordinate function using our moonposition module.
      ({double ra, double dec, double parallax}) moonCoordsFn(double jde) {
        final pos = moon.position(jde);
        final eps = toRad(23.44); // approximate obliquity
        final eq = eclToEq(pos.lon, pos.lat, math.sin(eps), math.cos(eps));
        final par = moon.parallax(pos.delta);
        return (ra: eq.ra, dec: eq.dec, parallax: par);
      }

      final result = moonTimes(jd, lat, lon, 69, th0, moonCoordsFn);
      // Moon should rise and set on most days at London.
      if (result != null) {
        expect(result.rise, greaterThanOrEqualTo(0));
        expect(result.rise, lessThan(86400));
        expect(result.transit, greaterThanOrEqualTo(0));
        expect(result.transit, lessThan(86400));
        expect(result.set, greaterThanOrEqualTo(0));
        expect(result.set, lessThan(86400));
      }
    });
  });
}
