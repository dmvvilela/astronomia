/// Mars: Chapter 42, Ephemeris for Physical Observations of Mars.
///
/// All angular results (except k) are in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../coord/coord.dart' as coord;
import '../illum/illum.dart' as illum;
import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';

/// Physical computes quantities for physical observations of Mars.
///
/// [jde] is Julian ephemeris day.
/// [earth] and [mars] are VSOP87 planets.
///
/// Returns:
/// - [dE] planetocentric declination of the Earth (radians)
/// - [dS] planetocentric declination of the Sun (radians)
/// - [omega] areographic longitude of the central meridian (radians)
/// - [p] geocentric position angle of Mars' northern rotation pole (radians)
/// - [q] position angle of greatest defect of illumination (radians)
/// - [d] apparent diameter of Mars (radians)
/// - [k] illuminated fraction of the disk
/// - [defect] greatest defect of illumination (radians)
({
  double dE,
  double dS,
  double omega,
  double p,
  double q,
  double d,
  double k,
  double defect,
}) physical(double jde, Planet earth, Planet mars) {
  // Step 1
  final t = j2000Century(jde);
  final pr = math.pi / 180;
  // (42.1) p. 288
  var lambda0 = 352.9065 * pr + 1.1733 * pr * t;
  final beta0 = 63.2818 * pr - 0.00394 * pr * t;

  // Step 2
  final earthPos = earth.position(jde);
  final rr = earthPos.range;
  final fk5E = toFK5(earthPos.lon, earthPos.lat, jde);
  final l0 = fk5E.lon;
  final b0 = fk5E.lat;

  // Steps 3, 4
  final sl0 = math.sin(l0), cl0 = math.cos(l0);
  final sb0 = math.sin(b0);
  var delta = 0.5;
  var tau = lightTime(delta);
  var l = 0.0, b = 0.0, r = 0.0;
  var x = 0.0, y = 0.0, z = 0.0;

  void f() {
    final marsPos = mars.position(jde - tau);
    r = marsPos.range;
    final fk5 = toFK5(marsPos.lon, marsPos.lat, jde);
    l = fk5.lon;
    b = fk5.lat;
    final sb_ = math.sin(b), cb = math.cos(b);
    final sl = math.sin(l), cl = math.cos(l);
    x = r * cb * cl - rr * cl0;
    y = r * cb * sl - rr * sl0;
    z = r * sb_ - rr * sb0;
    delta = math.sqrt(x * x + y * y + z * z);
    tau = lightTime(delta);
  }

  f();
  f();

  // Step 5
  var lambda = math.atan2(y, x);
  var beta = math.atan(z / math.sqrt(x * x + y * y));

  // Step 6
  final sBeta0 = math.sin(beta0), cBeta0 = math.cos(beta0);
  final sBeta = math.sin(beta), cBeta = math.cos(beta);
  final dE =
      math.asin(-sBeta0 * sBeta - cBeta0 * cBeta * math.cos(lambda0 - lambda));

  // Step 7
  final n = 49.5581 * pr + 0.7721 * pr * t;
  final lPrime = l - 0.00697 * pr / r;
  final bPrime = b - 0.000225 * pr * math.cos(l - n) / r;

  // Step 8
  final sBprime = math.sin(bPrime), cBprime = math.cos(bPrime);
  final dS = math.asin(
      -sBeta0 * sBprime - cBeta0 * cBprime * math.cos(lambda0 - lPrime));

  // Step 9
  final w = 11.504 * pr + 350.89200025 * pr * (jde - tau - 2433282.5);

  // Step 10
  final eps0 = nut.meanObliquity(jde);
  final sEps0 = math.sin(eps0), cEps0 = math.cos(eps0);
  final eq0 = coord.eclToEq(lambda0, beta0, sEps0, cEps0);
  final alpha0 = eq0.ra, delta0 = eq0.dec;

  // Step 11
  final u = y * cEps0 - z * sEps0;
  final v = y * sEps0 + z * cEps0;
  final alpha = math.atan2(u, x);
  final delta_ = math.atan(v / math.sqrt(x * x + u * u));
  final sDelta = math.sin(delta_), cDelta = math.cos(delta_);
  final sDelta0 = math.sin(delta0), cDelta0 = math.cos(delta0);
  final sAlpha0Alpha = math.sin(alpha0 - alpha);
  final cAlpha0Alpha = math.cos(alpha0 - alpha);
  final zeta = math.atan2(
      sDelta0 * cDelta * cAlpha0Alpha - sDelta * cDelta0,
      cDelta * sAlpha0Alpha);

  // Step 12
  final omega = pMod(w - zeta, 2 * math.pi);

  // Step 13
  final nutResult = nut.nutation(jde);
  final deltaPsi = nutResult.dPsi;
  final deltaEps = nutResult.dEps;

  // Step 14
  final sl0lambda = math.sin(l0 - lambda);
  final cl0lambda = math.cos(l0 - lambda);
  lambda += 0.005693 * pr * cl0lambda / cBeta;
  beta += 0.005693 * pr * sl0lambda * sBeta;

  // Step 15
  lambda0 += deltaPsi;
  lambda += deltaPsi;
  final eps = eps0 + deltaEps;

  // Step 16
  final sEps = math.sin(eps), cEps = math.cos(eps);
  final eq0Prime = coord.eclToEq(lambda0, beta0, sEps, cEps);
  final alpha0Prime = eq0Prime.ra, delta0Prime = eq0Prime.dec;
  final eqPrime = coord.eclToEq(lambda, beta, sEps, cEps);
  final alphaPrime = eqPrime.ra, deltaPrime = eqPrime.dec;

  // Step 17
  final sDelta0Prime = math.sin(delta0Prime);
  final cDelta0Prime = math.cos(delta0Prime);
  final sDeltaPrime = math.sin(deltaPrime);
  final cDeltaPrime = math.cos(deltaPrime);
  final sAlpha0PrimeAlphaPrime = math.sin(alpha0Prime - alphaPrime);
  final cAlpha0PrimeAlphaPrime = math.cos(alpha0Prime - alphaPrime);
  // (42.4) p. 290
  var pp = math.atan2(
      cDelta0Prime * sAlpha0PrimeAlphaPrime,
      sDelta0Prime * cDeltaPrime -
          cDelta0Prime * sDeltaPrime * cAlpha0PrimeAlphaPrime);
  if (pp < 0) {
    pp += 2 * math.pi;
  }

  // Step 18
  final s = l0 + math.pi;
  final ss = math.sin(s), cs = math.cos(s);
  final alphaS = math.atan2(cEps * ss, cs);
  final deltaS = math.asin(sEps * ss);
  final sDeltaS = math.sin(deltaS), cDeltaS = math.cos(deltaS);
  final sAlphaSAlpha = math.sin(alphaS - alpha);
  final cAlphaSAlpha = math.cos(alphaS - alpha);
  final chi = math.atan2(cDeltaS * sAlphaSAlpha,
      sDeltaS * cDelta - cDeltaS * sDelta * cAlphaSAlpha);
  final qq = chi + math.pi;

  // Step 19
  final dd = 9.36 / 60 / 60 * math.pi / 180 / delta;
  final kk = illum.fraction(r, delta, rr);
  final defect = (1 - kk) * dd;

  return (
    dE: dE,
    dS: dS,
    omega: omega,
    p: pp,
    q: qq,
    d: dd,
    k: kk,
    defect: defect,
  );
}
