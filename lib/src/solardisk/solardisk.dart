/// Solardisk: Chapter 29, Ephemeris for Physical Observations of the Sun.
///
/// Provides Carrington rotation cycle and solar ephemeris (P, B0, L0).
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';
import '../solar/solar.dart' as solar;

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
  const iRad = 7.25 * math.pi / 180;
  final kk = toRad(73.6667 + 1.3958333 * (jde - 2396758) / julianCentury);
  final theta = (jde - 2398220) * 2 * math.pi / 25.38;

  final sun = solar.trueVSOP87(earth, jde);
  final n = nut.nutation(jde);
  final eps = nut.meanObliquity(jde) + n.dEps;
  final lambda = sun.lon - solar.aberration(sun.range);
  final lambdaPrime = lambda + n.dPsi;

  final sLambdaK = math.sin(lambda - kk);
  final cLambdaK = math.cos(lambda - kk);
  final sI = math.sin(iRad);
  final cI = math.cos(iRad);

  // Position angle of north pole, P. (29.1)
  final p = math.atan(-math.cos(lambdaPrime) * math.tan(eps)) +
      math.atan(-cLambdaK * math.tan(iRad));

  // Heliographic latitude of center, B0. (29.2)
  final b0 = math.asin(sLambdaK * sI);

  // Heliographic longitude of center, L0. (29.3)
  final eta = math.atan2(-sLambdaK * cI, -cLambdaK);
  final l0 = pMod(eta - theta, 2 * math.pi);

  return (p: p, b0: b0, l0: l0);
}
