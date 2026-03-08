/// Sunrise: Convenience functions for sunrise, solar noon, and sunset.
///
/// An astronomia extra (from JS astronomia, not in Go meeus).
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../solar/solar.dart' as solar;

/// Standard refraction + solar semidiameter correction for sunrise/sunset.
///
/// The Sun's center is 50 arcminutes below the horizon at rise/set.
final double _h0 = toRad(-50.0 / 60);

/// Approximate hour angle of sunrise/sunset.
///
/// [dec] is solar declination (radians).
/// [lat] is observer latitude (radians).
/// Returns the hour angle in radians, or null if the Sun never rises/sets.
double? _hourAngle(double dec, double lat) {
  final cosH = (math.sin(_h0) - math.sin(lat) * math.sin(dec)) /
      (math.cos(lat) * math.cos(dec));
  if (cosH < -1 || cosH > 1) return null; // never rises or never sets
  return math.acos(cosH);
}

/// Approximate times of sunrise, solar noon, and sunset.
///
/// [jd] is the Julian Day at 0h UT for the desired date.
/// [lat] is observer latitude (radians).
/// [lon] is observer longitude (radians, positive west).
///
/// Returns JD values for (sunrise, noon, sunset), or null components
/// if the Sun never rises or sets at that location/date.
({double? rise, double noon, double? set}) sunriseSunset(
    double jd, double lat, double lon) {
  final t = j2000Century(jd);
  final sun = solar.trueSun(t);

  // Solar noon approximation
  final eq = solar.apparentEquatorial(jd);
  // Approximate transit
  final noon = jd + lon / (2 * math.pi);

  final h = _hourAngle(eq.dec, lat);
  if (h == null) {
    return (rise: null, noon: noon, set: null);
  }

  final hDays = h / (2 * math.pi); // hour angle as fraction of day
  return (
    rise: noon - hDays,
    noon: noon,
    set: noon + hDays,
  );
}
