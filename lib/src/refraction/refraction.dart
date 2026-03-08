/// Refraction: Chapter 16, Atmospheric Refraction.
///
/// Functions assume atmospheric pressure 1010 mb, temperature 10°C,
/// yellow light. All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Refraction for apparent altitude > 15° to get true altitude.
///
/// [h0] is measured apparent altitude in radians.
/// Returns refraction in radians to subtract from h0.
double gt15True(double h0) {
  final t = math.tan(math.pi / 2 - h0);
  return secToRad(58.294) * t - secToRad(0.0668) * t * t * t;
}

/// Refraction for true altitude > 15° to get apparent altitude.
///
/// [h] is computed true altitude in radians.
/// Returns refraction in radians to add to h.
double gt15Apparent(double h) {
  final t = math.tan(math.pi / 2 - h);
  return secToRad(58.276) * t - secToRad(0.0824) * t * t * t;
}

/// Bennett's formula for refraction (apparent → true).
///
/// [h0] is measured apparent altitude in radians.
/// Accurate to 0.07 arcmin from horizon to zenith.
/// Returns refraction in radians to subtract from h0.
double bennett(double h0) {
  final hd = toDeg(h0);
  return minToRad(1 / math.tan(toRad(hd + 7.31 / (hd + 4.4))));
}

/// Bennett's formula with correction. Accurate to 0.015 arcmin.
double bennett2(double h0) {
  final r = toDeg(bennett(h0)) * 60; // refraction in arcminutes
  return minToRad(r - 0.06 * math.sin(toRad(14.7 * r + 13)));
}

/// Saemundsson's formula for refraction (true → apparent).
///
/// [h] is computed true altitude in radians.
/// Returns refraction in radians to add to h.
/// Consistent with Bennett to within 4 arcsec.
double saemundsson(double h) {
  final hd = toDeg(h);
  return minToRad(1.02 / math.tan(toRad(hd + 10.3 / (hd + 5.11))));
}
