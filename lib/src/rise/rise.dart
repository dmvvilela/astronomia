/// Rise: Chapter 15, Rising, Transit, and Setting.
///
/// Provides approximate rise/transit/set times.
/// Full accuracy versions require planetposition (VSOP87).
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Standard altitude for stellar objects (radians).
final double stdh0Stellar = toRad(-0.5667);

/// Standard altitude for the Sun (radians).
final double stdh0Solar = toRad(-0.8333);

/// Approximate rise, transit, set times.
///
/// [lat], [lon] observer geographic coords (radians, lon positive west),
/// [h0] standard altitude (radians),
/// [th0] apparent sidereal time at Greenwich at 0h UT (radians),
/// [alpha] right ascension (radians), [delta] declination (radians).
///
/// Returns fractions of a day for rise, transit, set.
/// Returns null if the body is circumpolar or never rises.
({double rise, double transit, double set})? approxTimes(
    double lat, double lon, double h0,
    double th0, double alpha, double delta) {
  final cH = (math.sin(h0) - math.sin(lat) * math.sin(delta)) /
      (math.cos(lat) * math.cos(delta));
  if (cH < -1 || cH > 1) return null; // circumpolar or never rises
  final hh = math.acos(cH);

  final m0 = pMod(alpha + lon - th0, 2 * math.pi) / (2 * math.pi);
  final m1 = m0 - hh / (2 * math.pi);
  final m2 = m0 + hh / (2 * math.pi);

  return (
    rise: pMod(m1, 1),
    transit: pMod(m0, 1),
    set: pMod(m2, 1),
  );
}
