/// Precession: Chapter 21, Precession.
///
/// Functions take Julian epoch arguments (e.g. 2000.0, not JD).
/// All angles in radians.
library;

import 'dart:math' as math;

import '../base/math.dart';

const double _d = math.pi / 180;
const double _s = _d / 3600;

// Coefficients from (21.3) p. 134 — precession from J2000.0
final _zetaT = [2306.2181 * _s, 1.39656 * _s, -0.000139 * _s];
final _zT = [2306.2181 * _s, 1.39656 * _s, -0.000139 * _s];
final _thetaT = [2004.3109 * _s, -0.8533 * _s, -0.000217 * _s];

final _zetat = [2306.2181 * _s, 0.30188 * _s, 0.017998 * _s];
final _zt = [2306.2181 * _s, 1.09468 * _s, 0.018203 * _s];
final _thetat = [2004.3109 * _s, -0.42665 * _s, -0.041833 * _s];

/// Precessor for equatorial coordinates between two epochs.
class Precessor {
  final double _zeta; // RA offset (radians)
  final double _z; // angle offset (radians)
  final double _sTheta, _cTheta;

  Precessor._(this._zeta, this._z, this._sTheta, this._cTheta);

  /// Creates a Precessor from [epochFrom] to [epochTo] (Julian years).
  factory Precessor(double epochFrom, double epochTo) {
    List<double> zetaCoeff, zCoeff, thetaCoeff;
    if (epochFrom == 2000) {
      zetaCoeff = _zetat;
      zCoeff = _zt;
      thetaCoeff = _thetat;
    } else {
      final bigT = (epochFrom - 2000) * 0.01;
      zetaCoeff = [
        horner(bigT, _zetaT),
        0.30188 * _s - 0.000344 * _s * bigT,
        0.017998 * _s,
      ];
      zCoeff = [
        horner(bigT, _zT),
        1.09468 * _s + 0.000066 * _s * bigT,
        0.018203 * _s,
      ];
      thetaCoeff = [
        horner(bigT, _thetaT),
        -0.42665 * _s - 0.000217 * _s * bigT,
        -0.041833 * _s,
      ];
    }
    final t = (epochTo - epochFrom) * 0.01;
    final zeta = horner(t, zetaCoeff) * t;
    final z = horner(t, zCoeff) * t;
    final theta = horner(t, thetaCoeff) * t;
    return Precessor._(zeta, z, math.sin(theta), math.cos(theta));
  }

  /// Precesses equatorial coordinates (ra, dec) in radians.
  ({double ra, double dec}) precess(double ra, double dec) {
    final sDec = math.sin(dec);
    final cDec = math.cos(dec);
    final sRaZeta = math.sin(ra + _zeta);
    final cRaZeta = math.cos(ra + _zeta);
    final a = cDec * sRaZeta;
    final b = _cTheta * cDec * cRaZeta - _sTheta * sDec;
    final c = _sTheta * cDec * cRaZeta + _cTheta * sDec;
    final newRa = mod2pi(math.atan2(a, b) + _z);
    double newDec;
    if (c.abs() < cosSmallAngle) {
      newDec = math.asin(c);
    } else {
      newDec = math.acos(math.sqrt(a * a + b * b));
      if (c < 0) newDec = -newDec;
    }
    return (ra: newRa, dec: newDec);
  }
}

/// Precesses equatorial coordinates including proper motion.
///
/// [mAlpha] is annual proper motion in RA (radians/year).
/// [mDelta] is annual proper motion in Dec (radians/year).
({double ra, double dec}) position(
    double ra, double dec,
    double epochFrom, double epochTo,
    double mAlpha, double mDelta) {
  final p = Precessor(epochFrom, epochTo);
  final t = epochTo - epochFrom;
  return p.precess(ra + mAlpha * t, dec + mDelta * t);
}

/// Approximate annual precession in RA and Dec.
({double dAlpha, double dDelta}) approxAnnualPrecession(
    double ra, double dec, double epochFrom, double epochTo) {
  final t = (epochTo - epochFrom) * 0.01;
  final m = (3.07496 + 0.00186 * t) * 15 * _s; // convert time-seconds to radians
  final nAlpha = (1.33621 - 0.00057 * t) * 15 * _s;
  final nDelta = (20.0431 - 0.0085 * t) * _s;
  return (
    dAlpha: m + nAlpha * math.sin(ra) * math.tan(dec),
    dDelta: nDelta * math.cos(ra),
  );
}

/// Ecliptic precession from one epoch to another.
class EclipticPrecessor {
  final double _sEta, _cEta;
  final double _pi; // π angle (radians)
  final double _p; // p angle (radians)

  EclipticPrecessor._(this._sEta, this._cEta, this._pi, this._p);

  static final _etaT = [47.0029 * _s, -0.06603 * _s, 0.000598 * _s];
  static final _piT = [174.876384 * _d, 3289.4789 * _s, 0.60622 * _s];
  static final _pT = [5029.0966 * _s, 2.22226 * _s, -0.000042 * _s];
  static final _etat = [47.0029 * _s, -0.03302 * _s, 0.000060 * _s];
  static final _pit = [174.876384 * _d, -869.8089 * _s, 0.03536 * _s];
  static final _pt = [5029.0966 * _s, 1.11113 * _s, -0.000006 * _s];

  factory EclipticPrecessor(double epochFrom, double epochTo) {
    List<double> etaCoeff, piCoeff, pCoeff;
    if (epochFrom == 2000) {
      etaCoeff = EclipticPrecessor._etat;
      piCoeff = EclipticPrecessor._pit;
      pCoeff = EclipticPrecessor._pt;
    } else {
      final bigT = (epochFrom - 2000) * 0.01;
      etaCoeff = [
        horner(bigT, EclipticPrecessor._etaT),
        -0.03302 * _s + 0.000598 * _s * bigT,
        0.000060 * _s,
      ];
      piCoeff = [
        horner(bigT, EclipticPrecessor._piT),
        -869.8089 * _s - 0.50491 * _s * bigT,
        0.03536 * _s,
      ];
      pCoeff = [
        horner(bigT, EclipticPrecessor._pT),
        1.11113 * _s - 0.000042 * _s * bigT,
        -0.000006 * _s,
      ];
    }
    final t = (epochTo - epochFrom) * 0.01;
    final pi = horner(t, piCoeff);
    final p = horner(t, pCoeff) * t;
    final eta = horner(t, etaCoeff) * t;
    return EclipticPrecessor._(math.sin(eta), math.cos(eta), pi, p);
  }

  /// Precesses ecliptic coordinates (lon, lat) in radians.
  ({double lon, double lat}) precess(double lon, double lat) {
    final sLat = math.sin(lat);
    final cLat = math.cos(lat);
    final sd = math.sin(_pi - lon);
    final cd = math.cos(_pi - lon);
    final a = _cEta * cLat * sd - _sEta * sLat;
    final b = cLat * cd;
    final c = _cEta * sLat + _sEta * cLat * sd;
    final newLon = _p + _pi - math.atan2(a, b);
    double newLat;
    if (c.abs() < cosSmallAngle) {
      newLat = math.asin(c);
    } else {
      newLat = math.acos(math.sqrt(a * a + b * b));
      if (c < 0) newLat = -newLat;
    }
    return (lon: newLon, lat: newLat);
  }
}
