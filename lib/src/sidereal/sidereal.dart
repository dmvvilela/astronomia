/// Sidereal: Chapter 12, Sidereal Time at Greenwich.
///
/// Functions return sidereal time in seconds (range [0, 86400)).
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

/// IAU 1982 polynomial coefficients for mean sidereal time at 0h UT.
///
/// Polynomial in centuries from J2000.0. Coefficients from (12.2) p. 87.
const _iau82 = <double>[24110.54841, 8640184.812866, 0.093104, 0.0000062];

/// Splits a JD into centuries from J2000 (at 0h UT) and day fraction.
({double cen, double dayFrac}) _jdToCFrac(double jd) {
  final j0f = jd + 0.5;
  final j0 = j0f.floorToDouble();
  final f = j0f - j0;
  return (cen: j2000Century(j0 - 0.5), dayFrac: f);
}

/// Mean sidereal time at Greenwich at 0h UT, in seconds.
///
/// The result is in the range [0, 86400).
double mean0UT(double jd) {
  final r = _jdToCFrac(jd);
  final s = horner(r.cen, _iau82);
  return _mod86400(s);
}

/// Mean sidereal time at Greenwich for a given JD, in seconds.
///
/// The result is in the range [0, 86400).
double mean(double jd) {
  final r = _jdToCFrac(jd);
  final s = horner(r.cen, _iau82);
  final f = r.dayFrac * 86400; // day fraction in seconds
  return _mod86400(s + f * 1.00273790935);
}

/// Converts sidereal time in seconds to hours.
double siderealToHours(double seconds) => seconds / 3600.0;

/// Normalizes seconds to the range [0, 86400).
double _mod86400(double s) {
  final result = s % 86400;
  return result < 0 ? result + 86400 : result;
}
