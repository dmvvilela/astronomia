/// Angle: Chapter 17, Angular Separation.
library;

import 'dart:math' as math;

/// Angular separation between two equatorial positions.
///
/// [ra1], [dec1], [ra2], [dec2] all in radians. Result in radians.
double sep(double ra1, double dec1, double ra2, double dec2) {
  final sd1 = math.sin(dec1), cd1 = math.cos(dec1);
  final sd2 = math.sin(dec2), cd2 = math.cos(dec2);
  final cDra = math.cos(ra1 - ra2);
  return math.acos(sd1 * sd2 + cd1 * cd2 * cDra);
}

/// Angular separation using haversine formula (better for small angles).
double sepHav(double ra1, double dec1, double ra2, double dec2) {
  final dDec = dec2 - dec1;
  final dRa = ra2 - ra1;
  final a = _hav(dDec) + math.cos(dec1) * math.cos(dec2) * _hav(dRa);
  return 2 * math.asin(math.sqrt(a));
}

double _hav(double a) {
  final s = math.sin(a / 2);
  return s * s;
}

/// Position angle from point 1 to point 2.
double relativePosition(double ra1, double dec1, double ra2, double dec2) {
  final sDra = math.sin(ra2 - ra1);
  final cDra = math.cos(ra2 - ra1);
  return math.atan2(sDra, math.cos(dec1) * math.tan(dec2) -
      math.sin(dec1) * cDra);
}
