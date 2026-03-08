/// Moonillum: Chapter 48, Illuminated Fraction of the Moon's Disk.
///
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

/// Illuminated fraction of the Moon from phase angle.
///
/// [i] is the phase angle in radians.
double illuminated(double i) => (1 + math.cos(i)) / 2;

/// Phase angle from equatorial coordinates.
///
/// [ra], [dec], [delta] are Moon's geocentric RA, Dec, and distance.
/// [ra0], [dec0], [r] are Sun's geocentric RA, Dec, and distance.
/// Distances must be in the same units.
double phaseAngleEq(double ra, double dec, double delta,
    double ra0, double dec0, double r) {
  final cPsi = math.sin(dec0) * math.sin(dec) +
      math.cos(dec0) * math.cos(dec) * math.cos(ra0 - ra);
  final sPsi = math.sin(math.acos(cPsi));
  return math.atan2(r * sPsi, delta - r * cPsi);
}

/// Less accurate phase angle from equatorial coordinates (no distances).
double phaseAngleEq2(double ra, double dec, double ra0, double dec0) {
  final cPsi = math.sin(dec0) * math.sin(dec) +
      math.cos(dec0) * math.cos(dec) * math.cos(ra0 - ra);
  return math.acos(-cPsi);
}

/// Phase angle from ecliptic coordinates.
double phaseAngleEcl(double lon, double lat, double delta,
    double lon0, double r) {
  final cPsi = math.cos(lat) * math.cos(lon - lon0);
  final sPsi = math.sin(math.acos(cPsi));
  return math.atan2(r * sPsi, delta - r * cPsi);
}

/// Quick phase angle from JDE (less accurate).
double phaseAngle3(double jde) {
  final t = j2000Century(jde);
  final d = mod2pi(toRad(horner(t, [297.8501921, 445267.1114034,
      -0.0018819, 1 / 545868.0, -1 / 113065000.0])));
  final m = mod2pi(toRad(horner(t, [357.5291092, 35999.0502909,
      -0.0001535, 1 / 24490000.0])));
  final mp = mod2pi(toRad(horner(t, [134.9633964, 477198.8675055,
      0.0087414, 1 / 69699.0, -1 / 14712000.0])));
  return math.pi - d + toRad(
      -6.289 * math.sin(mp) +
      2.1 * math.sin(m) +
      -1.274 * math.sin(2 * d - mp) +
      -0.658 * math.sin(2 * d) +
      -0.214 * math.sin(2 * mp) +
      -0.11 * math.sin(d));
}

/// Position angle of the Moon's bright limb.
///
/// [ra], [dec] are Moon coordinates; [ra0], [dec0] are Sun coordinates.
/// All in radians. Returns position angle in radians.
double limb(double ra, double dec, double ra0, double dec0) {
  final sDa = math.sin(ra0 - ra);
  return math.atan2(
      math.cos(dec0) * sDa,
      math.sin(dec0) * math.cos(dec) - math.cos(dec0) * math.sin(dec) * math.cos(ra0 - ra));
}
