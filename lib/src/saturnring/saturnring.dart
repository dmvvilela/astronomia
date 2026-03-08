/// Saturnring: Chapter 45, The Ring of Saturn.
///
/// Provides ring geometry calculations.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../coord/coord.dart';
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';

/// Ring edge ratios (ratio of ring radius to Saturn's equatorial radius).
const double innerEdgeOfOuter = 0.8801;
const double outerEdgeOfInner = 0.8599;
const double innerEdgeOfInner = 0.6650;
const double innerEdgeOfDusky = 0.5486;

/// Outer edge of outer ring (arcseconds).
const double outerEdgeArcsec = 375.35;

/// Ring geometry of Saturn.
///
/// [jde] is Julian ephemeris day.
/// [earth] and [saturn] are VSOP87 Planet objects.
///
/// Returns:
/// - b: Saturnicentric latitude of Earth (radians)
/// - bPrime: Saturnicentric latitude of Sun (radians)
/// - deltaU: difference in longitudes of Sun and Earth (radians)
/// - p: position angle of ring's north pole (radians)
/// - a: semi-major axis of outer edge (arcseconds)
/// - bAxis: semi-minor axis of outer edge (arcseconds)
({double b, double bPrime, double deltaU, double p, double a, double bAxis})
    ring(double jde, Planet earth, Planet saturn) {
  // Inclination and node of Saturn's ring plane.
  final t = j2000Century(jde);
  final inc = toRad(horner(t, [28.075216, -0.012998, 0.000004]));
  final omega = toRad(horner(t, [169.508470, 1.394681, 0.000412]));
  final sInc = math.sin(inc);
  final cInc = math.cos(inc);

  // Earth's heliocentric position.
  final posEarth = earth.position(jde);
  final r0 = posEarth.range;
  final l0 = posEarth.lon;
  final b0 = posEarth.lat;

  // Saturn's heliocentric position with light-time iteration.
  var posSat = saturn.position(jde);
  var r = posSat.range;
  var l = posSat.lon;
  var b = posSat.lat;

  // Geocentric rectangular coords with light-time iteration.
  final sB0 = math.sin(b0), cB0 = math.cos(b0);
  final sL0 = math.sin(l0), cL0 = math.cos(l0);
  var x = 0.0, y = 0.0, z = 0.0, delta = 0.0;
  for (var i = 0; i < 2; i++) {
    final sB = math.sin(b), cB = math.cos(b);
    final sL = math.sin(l), cL = math.cos(l);
    x = r * cB * cL - r0 * cB0 * cL0;
    y = r * cB * sL - r0 * cB0 * sL0;
    z = r * sB - r0 * sB0;
    delta = math.sqrt(x * x + y * y + z * z);
    final tau = lightTime(delta);
    posSat = saturn.position(jde - tau);
    r = posSat.range;
    l = posSat.lon;
    b = posSat.lat;
  }

  // Geocentric ecliptic longitude and latitude of Saturn.
  final lambda = math.atan2(y, x);
  final beta = math.atan2(z, math.sqrt(x * x + y * y));

  // Saturnicentric latitude of Earth, B.
  final sinB = math.sin(inc) * math.cos(beta) * math.sin(lambda - omega) -
      math.cos(inc) * math.sin(beta);
  final bEarth = math.asin(sinB);

  // Saturnicentric latitude of Sun, B'.
  final lSat = posSat.lon;
  final bSat = posSat.lat;
  final sinBPrime =
      sInc * math.cos(bSat) * math.sin(lSat - omega) - cInc * math.sin(bSat);
  final bPrime = math.asin(sinBPrime);

  // ΔU: difference in longitude of Saturn seen from Sun vs Earth.
  final n = toRad(113.6655 + 0.8771 * t * 100);
  final lPrime = l - toRad(0.01759) / r;
  final bPrimeSat = b - toRad(0.000764) * math.cos(l - n) / r;
  final u1 = math.atan2(
      sInc * math.sin(bPrimeSat) + cInc * math.cos(bPrimeSat) * math.sin(lPrime - omega),
      math.cos(bPrimeSat) * math.cos(lPrime - omega));
  final u2 = math.atan2(
      sInc * math.sin(beta) + cInc * math.cos(beta) * math.sin(lambda - omega),
      math.cos(beta) * math.cos(lambda - omega));
  final deltaU = (u1 - u2).abs();

  // Position angle P.
  final nn = nut.nutation(jde);
  final eps = nut.meanObliquity(jde) + nn.dEps;
  // Ring pole ecliptic → equatorial.
  final eqPole = eclToEq(omega, math.pi / 2 - inc, math.sin(eps), math.cos(eps));
  final eqSat = eclToEq(lambda + nn.dPsi, beta, math.sin(eps), math.cos(eps));
  final p = math.atan2(
      math.cos(eqPole.dec) * math.sin(eqPole.ra - eqSat.ra),
      math.sin(eqPole.dec) * math.cos(eqSat.dec) -
          math.cos(eqPole.dec) * math.sin(eqSat.dec) * math.cos(eqPole.ra - eqSat.ra));

  // Ring axes.
  final aAxis = secToRad(outerEdgeArcsec) / delta; // apparent semi-major
  final bAxisVal = aAxis * sinB.abs();

  return (
    b: bEarth,
    bPrime: bPrime,
    deltaU: deltaU,
    p: p,
    a: toDeg(aAxis) * 3600, // back to arcseconds
    bAxis: toDeg(bAxisVal) * 3600,
  );
}

/// Simpler function returning just ΔU and B.
({double deltaU, double b}) ub(double jde, Planet earth, Planet saturn) {
  final r = ring(jde, earth, saturn);
  return (deltaU: r.deltaU, b: r.b);
}
