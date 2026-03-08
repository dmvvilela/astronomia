/// Rise: Chapter 15, Rising, Transit, and Setting.
///
/// Provides approximate and refined rise/transit/set times for
/// celestial objects using Meeus's interpolation method.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../interpolation/interpolation.dart';

const double _secsPerDay = 86400;
const double _secsPerDeg = 240; // 86400 / 360
const double _d2r = math.pi / 180;

/// Mean refraction of the atmosphere (radians). 0°34'.
final double meanRefraction = toRad(34 / 60);

/// Standard altitude for stellar objects (radians). -0°34'.
final double stdh0Stellar = -meanRefraction;

/// Standard altitude for the Sun (radians). -0°50' (upper limb + refraction).
final double stdh0Solar = toRad(-50 / 60);

/// Standard altitude for the Moon, low accuracy (radians). 0.125°.
final double stdh0LunarMean = toRad(0.125);

/// Standard altitude for the Moon considering horizontal parallax [pi].
///
/// Meeus eq. 15.4: h0 = 0.7275 * π - 0°34'.
double stdh0Lunar(double pi) => 0.7275 * pi - meanRefraction;

/// Approximate hour angle for rise/set.
///
/// Returns null if circumpolar or never rises.
double? hourAngle(double lat, double h0, double dec) {
  final cosH = (math.sin(h0) - math.sin(lat) * math.sin(dec)) /
      (math.cos(lat) * math.cos(dec));
  if (cosH < -1 || cosH > 1) return null;
  return math.acos(cosH);
}

/// Approximate rise, transit, set times.
///
/// [lat], [lon] observer geographic coords (radians, lon positive west).
/// [h0] standard altitude (radians).
/// [th0] apparent sidereal time at Greenwich at 0h UT (seconds of day, [0..86400)).
/// [alpha] right ascension (radians), [delta] declination (radians).
///
/// Returns seconds of day for rise, transit, set. Range [0, 86400).
/// Returns null if the body is circumpolar or never rises.
({double rise, double transit, double set})? approxTimes(
    double lat, double lon, double h0,
    double th0, double alpha, double delta) {
  final hAngle = hourAngle(lat, h0, delta);
  if (hAngle == null) return null;
  final h0Secs = hAngle * _secsPerDeg * 180 / math.pi;

  // Transit time (15.2).
  final mt = (lon + alpha) * _secsPerDeg * 180 / math.pi - th0;
  return (
    rise: _mod86400(mt - h0Secs),
    transit: _mod86400(mt),
    set: _mod86400(mt + h0Secs),
  );
}

/// Refined rise, transit, set times using 3-day interpolation.
///
/// [lat], [lon] observer coords (radians, lon positive west).
/// [deltaT] in seconds.
/// [h0] standard altitude (radians).
/// [th0] apparent sidereal time at Greenwich at 0h UT (seconds, [0..86400)).
/// [alpha3] right ascensions for day-1, day0, day+1 (radians).
/// [delta3] declinations for day-1, day0, day+1 (radians).
///
/// Returns seconds of day. Range [0, 86400).
/// Returns null if body never rises.
({double rise, double transit, double set})? times(
    double lat, double lon, double deltaT, double h0,
    double th0, List<double> alpha3, List<double> delta3) {
  final rs = approxTimes(lat, lon, h0, th0, alpha3[1], delta3[1]);
  if (rs == null) return null;

  final d3a = Len3(-_secsPerDay, _secsPerDay, alpha3);
  final d3d = Len3(-_secsPerDay, _secsPerDay, delta3);

  // Adjust transit.
  var mTransit = rs.transit;
  {
    final ut = mTransit + deltaT;
    final alpha = d3a.interpolateX(ut);
    final sth0 = _th0(th0, mTransit);
    final h = -((lon + alpha) * _secsPerDeg * 180 / math.pi - sth0);
    mTransit -= h;
  }

  // Adjust rise and set.
  final sLat = math.sin(lat);
  final cLat = math.cos(lat);

  double adjustRS(double m) {
    final ut = m + deltaT;
    final alpha = d3a.interpolateX(ut);
    final delta = d3d.interpolateX(ut);
    final sth0 = _th0(th0, m);
    final h0Calc = -((lon + alpha) * _secsPerDeg * 180 / math.pi - sth0);
    final hRad = (h0Calc / _secsPerDeg) * _d2r;
    final altitude = math.asin(
        sLat * math.sin(delta) + cLat * math.cos(delta) * math.cos(hRad));
    final dm = _secsPerDay *
        (altitude - h0) /
        (math.cos(delta) * cLat * math.sin(hRad) * 2 * math.pi);
    return m + dm;
  }

  return (
    rise: _mod86400(adjustRS(rs.rise)),
    transit: _mod86400(mTransit),
    set: _mod86400(adjustRS(rs.set)),
  );
}

/// Convenience: moonrise/moonset/transit for a Julian Day at midnight.
///
/// [jd] should be at 0h UT (midnight). [lat], [lon] in radians (lon positive west).
/// [moonCoords] is a function that returns (ra, dec, parallax) for a given JDE.
/// [deltaT] in seconds.
///
/// Returns seconds of day, or null if the Moon doesn't rise/set.
({double rise, double transit, double set})? moonTimes(
    double jd,
    double lat,
    double lon,
    double deltaT,
    double th0,
    ({double ra, double dec, double parallax}) Function(double jde) moonCoords) {
  // Compute RA/dec at day-1, day0, day+1.
  final c0 = moonCoords(jd - 1);
  final c1 = moonCoords(jd);
  final c2 = moonCoords(jd + 1);

  final h0 = stdh0Lunar(c1.parallax);
  return times(lat, lon, deltaT, h0, th0,
      [c0.ra, c1.ra, c2.ra], [c0.dec, c1.dec, c2.dec]);
}

/// Corrected sidereal time for a fraction of the day.
double _th0(double th0, double m) {
  return _mod86400(th0 + m * 360.985647 / 360);
}

double _mod86400(double s) {
  final r = s % _secsPerDay;
  return r < 0 ? r + _secsPerDay : r;
}
