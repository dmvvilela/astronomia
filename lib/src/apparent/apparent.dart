/// Apparent: Chapter 23, Apparent Place of a Star.
///
/// Provides corrections for nutation and aberration to obtain
/// apparent positions. Full Position() requires solar module.
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;

/// Constant of aberration κ in radians.
final double kappa = secToRad(20.49552);

/// Returns nutation corrections for equatorial coordinates.
///
/// [ra], [dec] in radians, [jd] is Julian day.
/// Returns corrections (dAlpha, dDelta) in radians.
/// Invalid for objects very near the celestial poles.
({double dAlpha, double dDelta}) nutationCorrection(
    double ra, double dec, double jd) {
  final eps = nut.meanObliquity(jd);
  final sEps = math.sin(eps);
  final cEps = math.cos(eps);
  final n = nut.nutation(jd);
  final sAlpha = math.sin(ra);
  final cAlpha = math.cos(ra);
  final tDelta = math.tan(dec);
  return (
    dAlpha: (cEps + sEps * sAlpha * tDelta) * n.dPsi - cAlpha * tDelta * n.dEps,
    dDelta: sEps * cAlpha * n.dPsi + sAlpha * n.dEps,
  );
}

/// Longitude of perihelion of Earth's orbit.
double _perihelion(double t) {
  return toRad(horner(t, [102.93735, 1.71946, 0.00046]));
}

/// Aberration corrections for equatorial coordinates.
///
/// Requires solar longitude and eccentricity. These are passed
/// as parameters to avoid circular dependency on solar module.
///
/// [ra], [dec] in radians.
/// [sunLon] true geometric longitude of the Sun (radians).
/// [eccentricity] of Earth's orbit.
/// [t] centuries from J2000.
({double dAlpha, double dDelta}) aberration(
    double ra, double dec,
    double sunLon, double eccentricity, double t) {
  final eps = nut.meanObliquity(julianYearToJDE(2000 + t * 100));
  final pi = _perihelion(t);
  final sAlpha = math.sin(ra);
  final cAlpha = math.cos(ra);
  final sDec = math.sin(dec);
  final cDec = math.cos(dec);
  final sS = math.sin(sunLon);
  final cS = math.cos(sunLon);
  final sPi = math.sin(pi);
  final cPi = math.cos(pi);
  final cEps = math.cos(eps);
  final tEps = math.tan(eps);
  final q1 = cAlpha * cEps;
  return (
    dAlpha: kappa *
        (eccentricity * (q1 * cPi + sAlpha * sPi) -
            (q1 * cS + sAlpha * sS)) /
        cDec,
    dDelta: kappa *
        (eccentricity *
                (cPi * (cEps * (tEps * cDec - sAlpha * sDec)) +
                    sPi * cAlpha * sDec) -
            (cS * (cEps * (tEps * cDec - sAlpha * sDec)) +
                sS * cAlpha * sDec)),
  );
}
