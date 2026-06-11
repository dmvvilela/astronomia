/// Moon: Chapter 53, Ephemeris for Physical Observations of the Moon.
///
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/coord.dart';
import '../base/math.dart';
import '../coord/coord.dart' as coord;
import '../julian/julian.dart';
import '../moonposition/moonposition.dart' as moonposition;
import '../nutation/nutation.dart' as nut;
import '../planetposition/planetposition.dart';
import '../solar/solar.dart' as solar;

const double _d2r = math.pi / 180;
final double _i = 1.54242 * _d2r; // IAU inclination of mean lunar equator
final double _sI = math.sin(_i);
final double _cI = math.cos(_i);

/// Physical returns quantities for physical observation of the Moon.
///
/// [jde] is Julian ephemeris day.
/// [earth] is VSOP87 Planet Earth.
///
/// Returns:
/// - [cMoon] selenographic longitude/latitude of the Moon (librations)
/// - [p] position angle of the Moon's axis of rotation (radians)
/// - [cSun] selenographic longitude/latitude of the Sun
({Ecliptic cMoon, double p, Ecliptic cSun}) physical(
    double jde, Planet earth) {
  final pos = moonposition.position(jde);
  final m = MoonPhysical(jde);
  final lib = m.lib(pos.lon, pos.lat);
  final p = m.pa(pos.lon, pos.lat, lib.b);
  final sun = m.sun(pos.lon, pos.lat, pos.delta, earth);
  return (
    cMoon: Ecliptic(lib.l, lib.b),
    p: p,
    cSun: Ecliptic(sun.l, sun.b),
  );
}

/// Internal computation state for Moon physical ephemeris.
class MoonPhysical {
  final double jde;
  late final double _deltaPsi;
  late final double _f;
  late final double _omega;
  late final double _eps;
  late final double _sEps, _cEps;
  late final double _rho, _sigma, _tau;

  MoonPhysical(this.jde) {
    final nutResult = nut.nutation(jde);
    _deltaPsi = nutResult.dPsi;
    final t = j2000Century(jde);

    _f = horner(t, [
      93.272095 * _d2r,
      483202.0175233 * _d2r,
      -0.0036539 * _d2r,
      -_d2r / 3526000,
      _d2r / 863310000,
    ]);
    _omega = horner(t, [
      125.0445479 * _d2r,
      -1934.1362891 * _d2r,
      0.0020754 * _d2r,
      _d2r / 467441,
      -_d2r / 60616000,
    ]);

    _eps = nut.meanObliquity(jde) + nutResult.dEps;
    _sEps = math.sin(_eps);
    _cEps = math.cos(_eps);

    // rho, sigma, tau — p. 372, 373
    final d = horner(t, [
      297.8501921 * _d2r,
      445267.1114034 * _d2r,
      -0.0018819 * _d2r,
      _d2r / 545868,
      -_d2r / 113065000,
    ]);
    final m = horner(t, [
      357.5291092 * _d2r,
      35999.0502909 * _d2r,
      -0.0001535 * _d2r,
      _d2r / 24490000,
    ]);
    final mp = horner(t, [
      134.9633964 * _d2r,
      477198.8675055 * _d2r,
      0.0087414 * _d2r,
      _d2r / 69699,
      -_d2r / 14712000,
    ]);
    final e = horner(t, [1.0, -0.002516, -0.0000074]);
    final k1 = 119.75 * _d2r + 131.849 * _d2r * t;
    final k2 = 72.56 * _d2r + 20.186 * _d2r * t;

    _rho = -0.02752 * _d2r * math.cos(mp) +
        -0.02245 * _d2r * math.sin(_f) +
        0.00684 * _d2r * math.cos(mp - 2 * _f) +
        -0.00293 * _d2r * math.cos(2 * _f) +
        -0.00085 * _d2r * math.cos(2 * (_f - d)) +
        -0.00054 * _d2r * math.cos(mp - 2 * d) +
        -0.0002 * _d2r * math.sin(mp + _f) +
        -0.0002 * _d2r * math.cos(mp + 2 * _f) +
        -0.0002 * _d2r * math.cos(mp - _f) +
        0.00014 * _d2r * math.cos(mp + 2 * (_f - d));

    _sigma = -0.02816 * _d2r * math.sin(mp) +
        0.02244 * _d2r * math.cos(_f) +
        -0.00682 * _d2r * math.sin(mp - 2 * _f) +
        -0.00279 * _d2r * math.sin(2 * _f) +
        -0.00083 * _d2r * math.sin(2 * (_f - d)) +
        0.00069 * _d2r * math.sin(mp - 2 * d) +
        0.0004 * _d2r * math.cos(mp + _f) +
        -0.00025 * _d2r * math.sin(2 * mp) +
        -0.00023 * _d2r * math.sin(mp + 2 * _f) +
        0.0002 * _d2r * math.cos(mp - _f) +
        0.00019 * _d2r * math.sin(mp - _f) +
        0.00013 * _d2r * math.sin(mp + 2 * (_f - d)) +
        -0.0001 * _d2r * math.cos(mp - 3 * _f);

    _tau = 0.0252 * _d2r * math.sin(m) * e +
        0.00473 * _d2r * math.sin(2 * (mp - _f)) +
        -0.00467 * _d2r * math.sin(mp) +
        0.00396 * _d2r * math.sin(k1) +
        0.00276 * _d2r * math.sin(2 * (mp - d)) +
        0.00196 * _d2r * math.sin(_omega) +
        -0.00183 * _d2r * math.cos(mp - _f) +
        0.00115 * _d2r * math.sin(mp - 2 * d) +
        -0.00096 * _d2r * math.sin(mp - d) +
        0.00046 * _d2r * math.sin(2 * (_f - d)) +
        -0.00039 * _d2r * math.sin(mp - _f) +
        -0.00032 * _d2r * math.sin(mp - m - d) +
        0.00027 * _d2r * math.sin(2 * (mp - d) - m) +
        0.00023 * _d2r * math.sin(k2) +
        -0.00014 * _d2r * math.sin(2 * d) +
        0.00014 * _d2r * math.cos(2 * (mp - _f)) +
        -0.00012 * _d2r * math.sin(mp - 2 * _f) +
        -0.00012 * _d2r * math.sin(2 * mp) +
        0.00011 * _d2r * math.sin(2 * (mp - m - d));
  }

  /// Combined optical and physical librations.
  ({double l, double b}) lib(double lambda, double beta) {
    final opt = _optical(lambda, beta);
    final phys = _physical(opt.a, opt.bPrime);
    var l = opt.lPrime + phys.lDelta;
    if (l > math.pi) l -= 2 * math.pi;
    final b = opt.bPrime + phys.bDelta;
    return (l: l, b: b);
  }

  ({double lPrime, double bPrime, double a}) _optical(
      double lambda, double beta) {
    // (53.1) p. 372
    final w = lambda - _omega;
    final sW = math.sin(w), cW = math.cos(w);
    final sBeta = math.sin(beta), cBeta = math.cos(beta);
    final a = math.atan2(sW * cBeta * _cI - sBeta * _sI, cW * cBeta);
    final lPrime = pMod(a - _f, 2 * math.pi);
    final bPrime = math.asin(-sW * cBeta * _sI - sBeta * _cI);
    return (lPrime: lPrime, bPrime: bPrime, a: a);
  }

  ({double lDelta, double bDelta}) _physical(double a, double bPrime) {
    // (53.2) p. 373
    final sA = math.sin(a), cA = math.cos(a);
    final lDelta = -_tau + (_rho * cA + _sigma * sA) * math.tan(bPrime);
    final bDelta = _sigma * cA - _rho * sA;
    return (lDelta: lDelta, bDelta: bDelta);
  }

  /// Position angle of Moon's axis of rotation.
  double pa(double lambda, double beta, double b) {
    final v = _omega + _deltaPsi + _sigma / _sI;
    final sV = math.sin(v), cV = math.cos(v);
    final sIRho = math.sin(_i + _rho), cIRho = math.cos(_i + _rho);
    final xp = sIRho * sV;
    final yp = sIRho * cV * _cEps - cIRho * _sEps;
    final w = math.atan2(xp, yp);
    final eq = coord.eclToEq(lambda + _deltaPsi, beta, _sEps, _cEps);
    var p = math.asin(
        math.sqrt(xp * xp + yp * yp) * math.cos(eq.ra - w) / math.cos(b));
    if (p < 0) p += 2 * math.pi;
    return p;
  }

  /// Selenographic coordinates of the Sun.
  ({double l, double b}) sun(
      double lambda, double beta, double delta, Planet earth) {
    final app = solar.apparentVSOP87(earth, jde);
    final deltaR = delta / (app.range * au);
    final lambdaH = app.lon +
        math.pi +
        57.296 * _d2r * deltaR * math.cos(beta) * math.sin(app.lon - lambda);
    final betaH = deltaR * beta;
    return lib(lambdaH, betaH);
  }
}

/// Altitude of the Sun above the lunar horizon.
///
/// [cOnMoon] is selenographic (lon, lat) of a site on the Moon.
/// [cSun] is selenographic coordinates of the Sun.
/// Returns altitude in radians.
double sunAltitude(Ecliptic cOnMoon, Ecliptic cSun) {
  final c0 = math.pi / 2 - cSun.lon;
  final sb0 = math.sin(cSun.lat), cb0 = math.cos(cSun.lat);
  final sTheta = math.sin(cOnMoon.lat), cTheta = math.cos(cOnMoon.lat);
  return math.asin(sb0 * sTheta + cb0 * cTheta * math.sin(c0 + cOnMoon.lon));
}

/// Time of sunrise for a point on the Moon near the given [jde].
double sunrise(Ecliptic cOnMoon, double jde, Planet earth) {
  jde -= _srCorr(cOnMoon, jde, earth);
  return jde - _srCorr(cOnMoon, jde, earth);
}

/// Time of sunset for a point on the Moon near the given [jde].
double sunset(Ecliptic cOnMoon, double jde, Planet earth) {
  jde += _srCorr(cOnMoon, jde, earth);
  return jde + _srCorr(cOnMoon, jde, earth);
}

double _srCorr(Ecliptic cOnMoon, double jde, Planet earth) {
  final phy = physical(jde, earth);
  final h = sunAltitude(cOnMoon, phy.cSun);
  return h / (12.19075 * _d2r * math.cos(cOnMoon.lat));
}

Ecliptic _lunarCoord(double eta, double theta) =>
    Ecliptic(eta * _d2r, theta * _d2r);

/// Selenographic coordinates of some lunar features (Table 53.A).
final Map<String, Ecliptic> selenographic = {
  'archimedes': _lunarCoord(-3.9, 29.7),
  'aristarchus': _lunarCoord(-47.5, 23.7),
  'aristillus': _lunarCoord(1.2, 33.9),
  'aristoteles': _lunarCoord(17.3, 50.1),
  'arzachel': _lunarCoord(-1.9, -17.7),
  'autolycus': _lunarCoord(1.5, 30.7),
  'billy': _lunarCoord(-50, -13.8),
  'birt': _lunarCoord(-8.5, -22.3),
  'campanus': _lunarCoord(-27.7, -28),
  'censorinus': _lunarCoord(32.7, -0.4),
  'clavius': _lunarCoord(-14, -58),
  'copernicus': _lunarCoord(-20, 9.7),
  'delambre': _lunarCoord(17.5, -1.9),
  'dionysius': _lunarCoord(17.3, 2.8),
  'endymion': _lunarCoord(56.4, 53.6),
  'eratosthenes': _lunarCoord(-11.3, 14.5),
  'eudoxus': _lunarCoord(16.3, 44.3),
  'fracastorius': _lunarCoord(33.2, -21),
  'fraMauro': _lunarCoord(-17, -6),
  'gassendi': _lunarCoord(-39.9, -17.5),
  'goclenius': _lunarCoord(45, -10.1),
  'grimaldi': _lunarCoord(-68.5, -5.8),
  'harpalus': _lunarCoord(-43.4, 52.6),
  'horrocks': _lunarCoord(5.9, -4),
  'kepler': _lunarCoord(-38, 8.1),
  'langrenus': _lunarCoord(60.9, -8.9),
  'lansberg': _lunarCoord(-26.6, -0.3),
  'letronne': _lunarCoord(-43, -10),
  'macrobius': _lunarCoord(46, 21.2),
  'manilius': _lunarCoord(9.1, 14.5),
  'menelaus': _lunarCoord(16, 16.3),
  'messier': _lunarCoord(47.6, -1.9),
  'petavius': _lunarCoord(61, -25),
  'pico': _lunarCoord(-8.8, 45.8),
  'pitatus': _lunarCoord(-13.5, -29.8),
  'piton': _lunarCoord(-0.8, 40.8),
  'plato': _lunarCoord(-9.2, 51.4),
  'plinius': _lunarCoord(23.6, 15.3),
  'posidonius': _lunarCoord(30, 31.9),
  'proclus': _lunarCoord(46.9, 16.1),
  'ptolemeusA': _lunarCoord(-0.8, -8.5),
  'pytheas': _lunarCoord(-20.6, 20.5),
  'reinhold': _lunarCoord(-22.8, 3.2),
  'riccioli': _lunarCoord(-74.3, -3.2),
  'schickard': _lunarCoord(-54.5, -44),
  'schiller': _lunarCoord(-39, -52),
  'tauruntius': _lunarCoord(46.5, 5.6),
  'theophilus': _lunarCoord(26.5, -11.4),
  'timocharis': _lunarCoord(-13.1, 26.7),
  'tycho': _lunarCoord(-11, -43.2),
  'vitruvius': _lunarCoord(31.3, 17.6),
  'walter': _lunarCoord(1, -33),
};
