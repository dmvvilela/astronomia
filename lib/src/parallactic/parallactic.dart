/// Parallactic: Chapter 14, The Parallactic Angle, and three other Topics.
///
/// All angles in radians.
library;

import 'dart:math' as math;

/// Returns the parallactic angle of a celestial object.
///
/// [phi] is geographic latitude of observer (radians).
/// [dec] is declination of observed object (radians).
/// [h] is hour angle of observed object (radians).
double parallacticAngle(double phi, double dec, double h) {
  return math.atan2(math.sin(h),
      math.tan(phi) * math.cos(dec) - math.sin(dec) * math.cos(h));
}

/// Parallactic angle on the horizon (special case when object rises/sets).
double parallacticAngleOnHorizon(double phi, double dec) {
  return math.acos(math.sin(phi) / math.cos(dec));
}

/// Computes how the ecliptic intersects the horizon.
///
/// [eps] is obliquity of the ecliptic (radians).
/// [phi] is geographic latitude (radians).
/// [theta] is local sidereal time (radians).
///
/// Returns ecliptic longitudes λ1, λ2 where the ecliptic meets the
/// horizon, and the angle I at which it intersects.
({double lambda1, double lambda2, double i}) eclipticAtHorizon(
    double eps, double phi, double theta) {
  final sEps = math.sin(eps);
  final cEps = math.cos(eps);
  final sPhi = math.sin(phi);
  final cPhi = math.cos(phi);
  final sTheta = math.sin(theta);
  final cTheta = math.cos(theta);

  var lambda = math.atan2(-cTheta, sEps * (sPhi / cPhi) + cEps * sTheta);
  if (lambda < 0) lambda += math.pi;

  return (
    lambda1: lambda,
    lambda2: lambda + math.pi,
    i: math.acos(cEps * sPhi - sEps * cPhi * sTheta),
  );
}

/// Angle between the ecliptic and parallels of ecliptic latitude.
double eclipticAtEquator(double lambda, double eps) {
  return math.atan(-math.cos(lambda) * math.tan(eps));
}

/// Angle of a celestial object's diurnal path relative to the horizon
/// at rising or setting.
double diurnalPathAtHorizon(double dec, double phi) {
  final tPhi = math.tan(phi);
  final b = math.tan(dec) * tPhi;
  final c = math.sqrt(1 - b * b);
  return math.atan(c * math.cos(dec) / tPhi);
}
