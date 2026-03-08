/// Solardisk: Chapter 29, Ephemeris for Physical Observations of the Sun.
///
/// Provides Carrington rotation cycle and solar ephemeris (P, B0, L0).
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';

/// Returns the JDE of the start of the given Carrington synodic rotation.
///
/// [c] is the Carrington cycle number. Result is dynamical time.
double cycle(int c) {
  final cf = c.toDouble();
  final jde = 2398140.227 + 27.2752316 * cf;
  final m = (281.96 + 26.882476 * cf) * math.pi / 180;
  final s2m = math.sin(2 * m);
  final c2m = math.cos(2 * m);
  return jde + 0.1454 * math.sin(m) - 0.0085 * s2m - 0.0141 * c2m;
}

/// Solar ephemeris: position angle P, heliographic latitude B0,
/// and heliographic longitude L0 of the center of the solar disk.
///
/// [jde] is Julian ephemeris day, [earth] is a Planet object for Earth.
/// Returns (p, b0, l0) all in radians.
({double p, double b0, double l0}) ephemeris(double jde, Planet earth) {
  // Sun's ecliptic coords from Earth's VSOP87 position.
  final posEarth = earth.position2000(jde);
  var sunLon = pMod(posEarth.lon + math.pi, 2 * math.pi);

  // Nutation and obliquity.
  final n = nut.nutation(jde);
  final eps = nut.meanObliquity(jde) + n.dEps;
  // Apparent longitude.
  final lambdaPrime = sunLon + n.dPsi;

  // Constants (p. 189).
  const iRad = 7.25 * math.pi / 180; // inclination of solar equator
  final kk = toRad(73.6667 + 1.3958333 * (jde - 2396758) / julianCentury);
  final theta = (jde - 2398220) * 2 * math.pi / 25.38;

  // Position angle of north pole, P. (29.1)
  final p1 = math.atan2(-math.cos(lambdaPrime) * math.tan(eps), 1);
  final p2 = math.atan2(-math.cos(sunLon - kk) * math.tan(iRad), 1);
  final p = p1 + p2;

  // Heliographic latitude of center, B0. (29.2)
  final b0 = math.asin(math.sin(sunLon - kk) * math.sin(iRad));

  // Heliographic longitude of center, L0. (29.3)
  final eta = math.atan2(-math.sin(sunLon - kk) * math.cos(iRad), -math.cos(sunLon - kk));
  final l0 = pMod(eta - theta, 2 * math.pi);

  return (p: p, b0: b0, l0: l0);
}
