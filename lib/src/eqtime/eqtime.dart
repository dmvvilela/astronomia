/// Equation of Time: Chapter 28.
///
/// The equation of time is the difference between apparent solar time
/// and mean solar time.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../coord/coord.dart';
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';

/// Mean longitude of the Sun, L0, from (28.2) p. 183.
///
/// [tau] is in Julian millennia from J2000.0.
/// Returns L0 in degrees.
double l0(double tau) {
  return horner(tau, [
    280.4664567,
    360007.6982779,
    0.03032028,
    1 / 49931,
    -1 / 15300,
    -1 / 2000000,
  ]);
}

/// Equation of time using VSOP87 Earth position.
///
/// [jde] is Julian ephemeris day, [earth] is a Planet object for Earth.
/// Returns the equation of time in radians (multiply by 180/π × 4 for minutes).
double e(double jde, Planet earth) {
  final tau = j2000Century(jde) * 0.1; // Julian millennia
  final sunPos = earth.position2000(jde);
  // Sun longitude is Earth + π.
  final sunLon = pMod(sunPos.lon + math.pi, 2 * math.pi);
  // Nutation and obliquity.
  final n = nut.nutation(jde);
  final eps = nut.meanObliquity(jde) + n.dEps;
  // Sun's apparent RA from ecliptic coords.
  final eq = eclToEq(sunLon + n.dPsi, -sunPos.lat, math.sin(eps), math.cos(eps));
  // Mean longitude L0.
  final meanLon = pMod(toRad(l0(tau)), 2 * math.pi);
  // (28.1) p. 183.
  var eot = meanLon - toRad(0.0057183) - eq.ra + n.dPsi * math.cos(eps);
  // Normalize to [-π, π].
  eot = pMod(eot + math.pi, 2 * math.pi) - math.pi;
  return eot;
}

/// Simplified equation of time (lower accuracy, no VSOP87 needed).
///
/// Formula 28.3, p. 185. Returns the equation of time in radians.
double eSmart(double jde) {
  final t = j2000Century(jde);
  final tau = t * 0.1;
  final eps = nut.meanObliquity(jde);
  final y = math.tan(eps / 2);
  final y2 = y * y;
  // Mean longitude and anomaly from low-accuracy solar.
  final meanLon = toRad(l0(tau));
  final e = horner(t, [0.016708634, -0.000042037, -0.0000001267]);
  final m = toRad(horner(t, [357.52911, 35999.05029, -0.0001537]));
  // (28.3)
  final eot = y2 * math.sin(2 * meanLon) -
      2 * e * math.sin(m) +
      4 * e * y2 * math.sin(m) * math.cos(2 * meanLon) -
      0.5 * y2 * y2 * math.sin(4 * meanLon) -
      1.25 * e * e * math.sin(2 * m);
  return eot;
}
