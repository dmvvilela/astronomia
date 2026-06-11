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
  final t = j2000Century(jde);
  final inc = toRad(horner(t, [28.075216, -0.012998, 0.000004]));
  final omega = toRad(horner(t, [169.508470, 1.394681, 0.000412]));
  final sInc = math.sin(inc);
  final cInc = math.cos(inc);

  // Step 2: Earth's heliocentric position (FK5).
  var posEarth = earth.position(jde);
  final fk5Earth = toFK5(posEarth.lon, posEarth.lat, jde);
  final l0 = fk5Earth.lon;
  final b0 = fk5Earth.lat;
  final r0 = posEarth.range;
  final sB0 = math.sin(b0), cB0 = math.cos(b0);
  final sL0 = math.sin(l0), cL0 = math.cos(l0);

  // Steps 3–4: Saturn with light-time iteration (FK5).
  var delta = 9.0;
  var x = 0.0, y = 0.0, z = 0.0;
  var l = 0.0, b = 0.0, r = 0.0;
  for (var i = 0; i < 2; i++) {
    final tau = lightTime(delta);
    final posSat = saturn.position(jde - tau);
    final fk5Sat = toFK5(posSat.lon, posSat.lat, jde);
    l = fk5Sat.lon;
    b = fk5Sat.lat;
    r = posSat.range;
    final sB = math.sin(b), cB = math.cos(b);
    final sL = math.sin(l), cL = math.cos(l);
    x = r * cB * cL - r0 * cB0 * cL0;
    y = r * cB * sL - r0 * cB0 * sL0;
    z = r * sB - r0 * sB0;
    delta = math.sqrt(x * x + y * y + z * z);
  }

  // Step 5: geocentric ecliptic coords of Saturn.
  var lambda = math.atan2(y, x);
  var beta = math.atan2(z, math.sqrt(x * x + y * y));

  // Step 6 (partial): Saturnicentric latitude of Earth, B.
  final sinB = sInc * math.cos(beta) * math.sin(lambda - omega) -
      cInc * math.sin(beta);
  final bEarth = math.asin(sinB);

  // Step 7: aberration-corrected heliocentric Saturn coords.
  final nSat = toRad(113.6655 + 0.8771 * t * 100);
  final lPrime = l - toRad(0.01759) / r;
  final bPrimeHelio = b - toRad(0.000764) * math.cos(l - nSat) / r;

  // Step 8: Saturnicentric latitude of Sun, B'.
  final sinBPrime = sInc * math.cos(bPrimeHelio) * math.sin(lPrime - omega) -
      cInc * math.sin(bPrimeHelio);
  final bPrime = math.asin(sinBPrime);

  // Step 9: ΔU.
  final u1 = math.atan2(
      sInc * math.sin(bPrimeHelio) +
          cInc * math.cos(bPrimeHelio) * math.sin(lPrime - omega),
      math.cos(bPrimeHelio) * math.cos(lPrime - omega));
  final u2 = math.atan2(
      sInc * math.sin(beta) + cInc * math.cos(beta) * math.sin(lambda - omega),
      math.cos(beta) * math.cos(lambda - omega));
  final deltaU = (u1 - u2).abs();

  // Steps 10–15: position angle P with aberration and nutation.
  final nn = nut.nutation(jde);
  final eps = nut.meanObliquity(jde) + nn.dEps;
  final sEps = math.sin(eps), cEps = math.cos(eps);

  // Step 11: ring pole in ecliptic coords.
  var lambda0 = omega - math.pi / 2;
  final beta0 = math.pi / 2 - inc;

  // Step 12: aberration on geocentric Saturn coords.
  final sL0L = math.sin(l0 - lambda);
  final cL0L = math.cos(l0 - lambda);
  final sBeta = math.sin(beta), cBeta = math.cos(beta);
  lambda += toRad(0.005693) * cL0L / cBeta;
  beta += toRad(0.005693) * sL0L * sBeta;

  // Step 13: nutation.
  lambda0 += nn.dPsi;
  lambda += nn.dPsi;

  // Step 14–15: position angle.
  final eqPole = eclToEq(lambda0, beta0, sEps, cEps);
  final eqSat = eclToEq(lambda, beta, sEps, cEps);
  final p = math.atan2(
      math.cos(eqPole.dec) * math.sin(eqPole.ra - eqSat.ra),
      math.sin(eqPole.dec) * math.cos(eqSat.dec) -
          math.cos(eqPole.dec) * math.sin(eqSat.dec) * math.cos(eqPole.ra - eqSat.ra));

  // Ring axes from step 6.
  final aAxis = secToRad(outerEdgeArcsec) / delta;
  final bAxisVal = aAxis * sinB.abs();

  return (
    b: bEarth,
    bPrime: bPrime,
    deltaU: deltaU,
    p: p,
    a: toDeg(aAxis) * 3600,
    bAxis: toDeg(bAxisVal) * 3600,
  );
}

/// Simpler function returning just ΔU and B.
({double deltaU, double b}) ub(double jde, Planet earth, Planet saturn) {
  final r = ring(jde, earth, saturn);
  return (deltaU: r.deltaU, b: r.b);
}
