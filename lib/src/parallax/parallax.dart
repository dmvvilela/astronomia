/// Parallax: Chapter 40, Correction for Parallax.
///
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Equatorial horizontal parallax constant: 8.794″ in radians.
final double _hp = secToRad(8.794);

/// Returns equatorial horizontal parallax for a body at distance [delta] AU.
double horizontal(double delta) => _hp / delta;

/// Topocentric position using the rigorous method (40.2, 40.3).
///
/// [ra], [dec] geocentric equatorial coordinates (radians).
/// [delta] distance in AU.
/// [rhoSPhi], [rhoCPhi] parallax constants (see globe).
/// [lon] observer longitude (radians).
/// [h] hour angle (radians).
/// [sinPi] sine of equatorial horizontal parallax.
({double ra, double dec}) topocentric(
    double ra, double dec, double delta,
    double rhoSPhi, double rhoCPhi,
    double h, double sinPi) {
  final sH = math.sin(h);
  final cH = math.cos(h);
  final sDec = math.sin(dec);
  final cDec = math.cos(dec);
  final dAlpha = math.atan2(
      -rhoCPhi * sinPi * sH, cDec - rhoCPhi * sinPi * cH);
  final newRa = ra + dAlpha;
  final newDec = math.atan2(
      (sDec - rhoSPhi * sinPi) * math.cos(dAlpha),
      cDec - rhoCPhi * sinPi * cH);
  return (ra: newRa, dec: newDec);
}

/// Non-rigorous topocentric corrections (40.4, 40.5).
({double dAlpha, double dDelta}) topocentric2(
    double dec, double delta,
    double rhoSPhi, double rhoCPhi,
    double h) {
  final pi = horizontal(delta);
  final sH = math.sin(h);
  final cH = math.cos(h);
  final sDec = math.sin(dec);
  final cDec = math.cos(dec);
  return (
    dAlpha: -pi * rhoCPhi * sH / cDec,
    dDelta: -pi * (rhoSPhi * cDec - rhoCPhi * cH * sDec),
  );
}
