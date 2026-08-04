/// Sunrise: Convenience functions for sunrise, solar noon, and sunset.
///
/// An astronomia extra (from JS astronomia, not in Go meeus).
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../coord/coord.dart' as coord;
import '../sidereal/sidereal.dart' as sidereal;
import '../solar/solar.dart' as solar;

/// Standard refraction + solar semidiameter correction for sunrise/sunset.
///
/// The Sun's center is 50 arcminutes below the horizon at rise/set.
final double _h0 = toRad(-50.0 / 60);

/// Times of sunrise, solar noon, and sunset.
///
/// [jd] is the Julian Day at 0h UT for the desired date.
/// [lat] is observer latitude (radians).
/// [lon] is observer longitude (radians, positive west).
///
/// Returns JD values for (sunrise, noon, sunset), or null components
/// if the Sun never rises or sets at that location/date.
({double? rise, double noon, double? set}) sunriseSunset(
  double jd,
  double lat,
  double lon,
) {
  // Walk the UT day in five-minute intervals, then refine every crossing.
  // Besides accounting for the equation of time and the Sun's changing
  // declination, this avoids treating the input midnight as solar noon.
  const step = 5 / 1440;
  double altitude(double instant) {
    final eq = solar.apparentEquatorial(instant);
    final st = sidereal.apparent(instant) / 86400 * 2 * math.pi;
    return coord.eqToHz(eq.ra, eq.dec, lat, lon, st).alt;
  }

  double? rise;
  double? set;
  var highestAt = jd;
  var highestAltitude = altitude(jd);
  var previousJd = jd;
  var previous = highestAltitude - _h0;

  for (var instant = jd + step; instant <= jd + 1 + 1e-12; instant += step) {
    final currentAltitude = altitude(instant);
    final current = currentAltitude - _h0;
    if (currentAltitude > highestAltitude) {
      highestAltitude = currentAltitude;
      highestAt = instant;
    }

    if (previous <= 0 && current > 0) {
      rise ??= _crossing(previousJd, instant, altitude);
    } else if (previous >= 0 && current < 0) {
      set ??= _crossing(previousJd, instant, altitude);
    }
    previousJd = instant;
    previous = current;
  }

  // Refine the sampled culmination with a ternary maximum search.
  var left = highestAt - step;
  var right = highestAt + step;
  for (var i = 0; i < 30; i++) {
    final third = (right - left) / 3;
    final a = left + third;
    final b = right - third;
    if (altitude(a) < altitude(b)) {
      left = a;
    } else {
      right = b;
    }
  }

  return (rise: rise, noon: (left + right) / 2, set: set);
}

double _crossing(double left, double right, double Function(double) altitude) {
  final rising = altitude(left) < _h0;
  for (var i = 0; i < 35; i++) {
    final middle = (left + right) / 2;
    final below = altitude(middle) < _h0;
    if (below == rising) {
      left = middle;
    } else {
      right = middle;
    }
  }
  return (left + right) / 2;
}
