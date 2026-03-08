/// Elliptic: Chapter 33, Elliptic Motion.
///
/// Provides velocity, orbit length, and geocentric planet positions.
library;

import 'dart:math' as math;

import '../apparent/apparent.dart' as apparent;
import '../base/math.dart';
import '../coord/coord.dart';
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';

/// Observed equatorial coordinates of a planet.
///
/// [planet] and [earth] are VSOP87 Planet objects.
/// Returns right ascension and declination in radians.
({double ra, double dec}) position(Planet planet, Planet earth, double jde) {
  // Earth's heliocentric position at equinox of date.
  final posEarth = earth.position(jde);
  final sB0 = math.sin(posEarth.lat);
  final cB0 = math.cos(posEarth.lat);
  final sL0 = math.sin(posEarth.lon);
  final cL0 = math.cos(posEarth.lon);

  // Compute geocentric rectangular coordinates.
  ({double x, double y, double z}) computePos(double tau) {
    final pos = planet.position(jde - tau);
    final sB = math.sin(pos.lat);
    final cB = math.cos(pos.lat);
    final sL = math.sin(pos.lon);
    final cL = math.cos(pos.lon);
    return (
      x: pos.range * cB * cL - posEarth.range * cB0 * cL0,
      y: pos.range * cB * sL - posEarth.range * cB0 * sL0,
      z: pos.range * sB - posEarth.range * sB0,
    );
  }

  // First pass — no light-time correction.
  var p = computePos(0);
  final delta = math.sqrt(p.x * p.x + p.y * p.y + p.z * p.z); // (33.4)
  final tau = lightTime(delta);
  // Second pass — with light-time correction.
  p = computePos(tau);

  var lambda = math.atan2(p.y, p.x); // (33.1)
  var beta = math.atan2(p.z, math.sqrt(p.x * p.x + p.y * p.y)); // (33.2)

  // Ecliptic aberration.
  final ab = apparent.eclipticAberration(lambda, beta, jde);
  lambda += ab.dLon;
  beta += ab.dLat;

  // FK5 correction.
  final fk5 = toFK5(lambda, beta, jde);
  lambda = fk5.lon;
  beta = fk5.lat;

  // Nutation.
  final n = nut.nutation(jde);
  lambda += n.dPsi;
  final eps = nut.meanObliquity(jde) + n.dEps;

  // Ecliptic to equatorial.
  return eclToEq(lambda, beta, math.sin(eps), math.cos(eps));
}

/// Velocity of a body at distance [r] in an orbit with semimajor axis [a].
///
/// Both in AU. Result in AU/day.
double velocity(double a, double r) {
  return 0.0172021 * math.sqrt(2 / r - 1 / a);
}

/// Velocity at aphelion for eccentricity [e] and semimajor axis [a].
double vAphelion(double a, double e) {
  return 0.0172021 * math.sqrt((1 - e) / (a * (1 + e)));
}

/// Velocity at perihelion for eccentricity [e] and semimajor axis [a].
double vPerihelion(double a, double e) {
  return 0.0172021 * math.sqrt((1 + e) / (a * (1 - e)));
}

/// Approximate length of an elliptic orbit (Ramanujan, first approximation).
///
/// [a] is semimajor axis, [e] is eccentricity. Result in same units as [a].
double length1(double a, double e) {
  final b = a * math.sqrt(1 - e * e);
  return math.pi * (3 * (a + b) - math.sqrt((3 * a + b) * (a + 3 * b)));
}

/// Approximate length of an elliptic orbit (Ramanujan, second approximation).
double length2(double a, double e) {
  final b = a * math.sqrt(1 - e * e);
  final h = ((a - b) / (a + b));
  final h2 = h * h;
  return math.pi * (a + b) * (1 + 3 * h2 / (10 + math.sqrt(4 - 3 * h2)));
}

/// Length of an elliptic orbit by numerical integration (4-point).
double length4(double a, double e) {
  final b = a * math.sqrt(1 - e * e);
  final m = (a - b) / (a + b);
  final m2 = m * m;
  return math.pi * (a + b) *
      (64 + 16 * m2) / (64 - 48 * m2 + 3 * m2 * m2 + m2 * m2 * m2 / 4);
}
