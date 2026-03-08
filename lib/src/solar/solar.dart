/// Solar: Chapter 25, Solar Coordinates.
///
/// Low-accuracy solar position using the method of Meeus Ch. 25.
/// High-accuracy VSOP87 methods will be added with planetposition module.
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../coord/coord.dart' as coord;
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;

/// True geometric longitude and anomaly of the Sun.
///
/// [t] is centuries from J2000 (see [j2000Century]).
/// Returns (lon, anomaly) referenced to mean equinox of date.
({double lon, double anomaly}) trueSun(double t) {
  final l0 = toRad(horner(t, [280.46646, 36000.76983, 0.0003032]));
  final m = meanAnomaly(t);
  final c = toRad(
      horner(t, [1.914602, -0.004817, -0.000014]) * math.sin(m) +
          (0.019993 - 0.000101 * t) * math.sin(2 * m) +
          0.000289 * math.sin(3 * m));
  return (
    lon: mod2pi(l0 + c),
    anomaly: mod2pi(m + c),
  );
}

/// Mean anomaly of the Sun.
///
/// [t] is centuries from J2000.
double meanAnomaly(double t) {
  return toRad(horner(t, [357.52911, 35999.05029, -0.0001537]));
}

/// Eccentricity of Earth's orbit.
double eccentricity(double t) {
  return horner(t, [0.016708634, -0.000042037, -0.0000001267]);
}

/// Sun-Earth distance in AU.
double radius(double t) {
  final sun = trueSun(t);
  final e = eccentricity(t);
  return 1.000001018 * (1 - e * e) / (1 + e * math.cos(sun.anomaly));
}

double _node(double t) {
  return toRad(125.04 - 1934.136 * t);
}

/// Apparent longitude of the Sun (includes nutation and aberration).
///
/// [t] is centuries from J2000.
double apparentLongitude(double t) {
  final omega = _node(t);
  final sun = trueSun(t);
  return sun.lon - toRad(0.00569) - toRad(0.00478) * math.sin(omega);
}

/// True geometric longitude referenced to equinox J2000.
({double lon, double anomaly}) true2000(double t) {
  final sun = trueSun(t);
  return (
    lon: sun.lon - toRad(0.01397) * t * 100,
    anomaly: sun.anomaly,
  );
}

/// True equatorial coordinates of the Sun.
({double ra, double dec}) trueEquatorial(double jde) {
  final sun = trueSun(j2000Century(jde));
  final eps = nut.meanObliquity(jde);
  final sS = math.sin(sun.lon);
  final cS = math.cos(sun.lon);
  final sEps = math.sin(eps);
  final cEps = math.cos(eps);
  return (
    ra: mod2pi(math.atan2(cEps * sS, cS)),
    dec: math.asin(sEps * sS),
  );
}

/// Apparent equatorial coordinates of the Sun.
({double ra, double dec}) apparentEquatorial(double jde) {
  final t = j2000Century(jde);
  final lambda = apparentLongitude(t);
  var eps = nut.meanObliquity(jde);
  eps += toRad(0.00256) * math.cos(_node(t));
  final sLambda = math.sin(lambda);
  final cLambda = math.cos(lambda);
  final sEps = math.sin(eps);
  final cEps = math.cos(eps);
  return (
    ra: mod2pi(math.atan2(cEps * sLambda, cLambda)),
    dec: math.asin(sEps * sLambda),
  );
}

/// Low-accuracy aberration correction.
double aberration(double r) {
  return secToRad(-20.4898) / r;
}
