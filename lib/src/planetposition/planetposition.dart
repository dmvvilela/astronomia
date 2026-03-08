/// Planetposition: Chapter 32, Positions of the Planets.
///
/// Heliocentric ecliptic coordinates using VSOP87 theory.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';
import '../precess/precess.dart';
import 'vsop87Bmercury.dart' as mercury_data;
import 'vsop87Bvenus.dart' as venus_data;
import 'vsop87Bearth.dart' as earth_data;
import 'vsop87Bmars.dart' as mars_data;
import 'vsop87Bjupiter.dart' as jupiter_data;
import 'vsop87Bsaturn.dart' as saturn_data;
import 'vsop87Buranus.dart' as uranus_data;
import 'vsop87Bneptune.dart' as neptune_data;

/// Planet indices.
const int planetMercury = 0;
const int planetVenus = 1;
const int planetEarth = 2;
const int planetMars = 3;
const int planetJupiter = 4;
const int planetSaturn = 5;
const int planetUranus = 6;
const int planetNeptune = 7;

/// VSOP87 series data for a single coordinate (L, B, or R).
/// Contains up to 6 polynomial series (T^0 through T^5).
typedef _Series = List<List<List<double>>>;

/// VSOP87 representation of a planet.
class Planet {
  final String name;
  final _Series _l;
  final _Series _b;
  final _Series _r;

  Planet._(this.name, this._l, this._b, this._r);

  /// Creates a Planet from a planet index constant.
  factory Planet(int index) {
    switch (index) {
      case planetMercury:
        return Planet._('mercury', _mercuryL, _mercuryB, _mercuryR);
      case planetVenus:
        return Planet._('venus', _venusL, _venusB, _venusR);
      case planetEarth:
        return Planet._('earth', _earthL, _earthB, _earthR);
      case planetMars:
        return Planet._('mars', _marsL, _marsB, _marsR);
      case planetJupiter:
        return Planet._('jupiter', _jupiterL, _jupiterB, _jupiterR);
      case planetSaturn:
        return Planet._('saturn', _saturnL, _saturnB, _saturnR);
      case planetUranus:
        return Planet._('uranus', _uranusL, _uranusB, _uranusR);
      case planetNeptune:
        return Planet._('neptune', _neptuneL, _neptuneB, _neptuneR);
      default:
        throw ArgumentError('Invalid planet index: $index');
    }
  }

  /// Heliocentric position at dynamical equinox and ecliptic J2000.
  ({double lon, double lat, double range}) position2000(double jde) {
    final tau = j2000Century(jde) * 0.1;
    final lon = pMod(_sum(tau, _l), 2 * math.pi);
    final lat = _sum(tau, _b);
    final range = _sum(tau, _r);
    return (lon: lon, lat: lat, range: range);
  }

  /// Heliocentric position at equinox and ecliptic of date.
  ({double lon, double lat, double range}) position(double jde) {
    final tau = j2000Century(jde) * 0.1;
    final lon = pMod(_sum(tau, _l), 2 * math.pi);
    final lat = _sum(tau, _b);
    final range = _sum(tau, _r);
    // VSOP87B is J2000 reference frame — precess to date.
    final precessor = EclipticPrecessor(2000.0, jdeToJulianYear(jde));
    final precessed = precessor.precess(lon, lat);
    return (lon: precessed.lon, lat: precessed.lat, range: range);
  }
}

/// Evaluates a VSOP87 series at time [tau] (Julian millennia from J2000).
double _sum(double tau, _Series series) {
  final coeffs = <double>[];
  for (var i = 0; i < series.length; i++) {
    var s = 0.0;
    for (final term in series[i]) {
      s += term[0] * math.cos(term[1] + term[2] * tau);
    }
    coeffs.add(s);
  }
  return horner(tau, coeffs);
}

/// Converts ecliptic longitude and latitude from dynamical frame to FK5.
///
/// Formula 32.3, p. 219.
({double lon, double lat}) toFK5(double lon, double lat, double jde) {
  final t = j2000Century(jde);
  final lp = lon - toRad((1.397 + 0.00031 * t) * t);
  final sLp = math.sin(lp);
  final cLp = math.cos(lp);
  final l5 = lon + secToRad(-0.09033 + 0.03916 * (cLp + sLp) * math.tan(lat));
  final b5 = lat + secToRad(0.03916 * (cLp - sLp));
  return (lon: l5, lat: b5);
}

// Planet data wiring — each planet's L, B, R series.

final _mercuryL = [
  mercury_data.l0, mercury_data.l1, mercury_data.l2,
  mercury_data.l3, mercury_data.l4, mercury_data.l5,
];
final _mercuryB = [
  mercury_data.b0, mercury_data.b1, mercury_data.b2,
  mercury_data.b3, mercury_data.b4, mercury_data.b5,
];
final _mercuryR = [
  mercury_data.r0, mercury_data.r1, mercury_data.r2,
  mercury_data.r3, mercury_data.r4, mercury_data.r5,
];

final _venusL = [
  venus_data.l0, venus_data.l1, venus_data.l2,
  venus_data.l3, venus_data.l4, venus_data.l5,
];
final _venusB = [
  venus_data.b0, venus_data.b1, venus_data.b2,
  venus_data.b3, venus_data.b4, venus_data.b5,
];
final _venusR = [
  venus_data.r0, venus_data.r1, venus_data.r2,
  venus_data.r3, venus_data.r4, venus_data.r5,
];

final _earthL = [
  earth_data.l0, earth_data.l1, earth_data.l2,
  earth_data.l3, earth_data.l4, earth_data.l5,
];
final _earthB = [
  earth_data.b0, earth_data.b1, earth_data.b2,
  earth_data.b3, earth_data.b4, earth_data.b5,
];
final _earthR = [
  earth_data.r0, earth_data.r1, earth_data.r2,
  earth_data.r3, earth_data.r4, earth_data.r5,
];

final _marsL = [
  mars_data.l0, mars_data.l1, mars_data.l2,
  mars_data.l3, mars_data.l4, mars_data.l5,
];
final _marsB = [
  mars_data.b0, mars_data.b1, mars_data.b2,
  mars_data.b3, mars_data.b4, mars_data.b5,
];
final _marsR = [
  mars_data.r0, mars_data.r1, mars_data.r2,
  mars_data.r3, mars_data.r4, mars_data.r5,
];

final _jupiterL = [
  jupiter_data.l0, jupiter_data.l1, jupiter_data.l2,
  jupiter_data.l3, jupiter_data.l4, jupiter_data.l5,
];
final _jupiterB = [
  jupiter_data.b0, jupiter_data.b1, jupiter_data.b2,
  jupiter_data.b3, jupiter_data.b4, jupiter_data.b5,
];
final _jupiterR = [
  jupiter_data.r0, jupiter_data.r1, jupiter_data.r2,
  jupiter_data.r3, jupiter_data.r4, jupiter_data.r5,
];

final _saturnL = [
  saturn_data.l0, saturn_data.l1, saturn_data.l2,
  saturn_data.l3, saturn_data.l4, saturn_data.l5,
];
final _saturnB = [
  saturn_data.b0, saturn_data.b1, saturn_data.b2,
  saturn_data.b3, saturn_data.b4, saturn_data.b5,
];
final _saturnR = [
  saturn_data.r0, saturn_data.r1, saturn_data.r2,
  saturn_data.r3, saturn_data.r4, saturn_data.r5,
];

final _uranusL = [
  uranus_data.l0, uranus_data.l1, uranus_data.l2,
  uranus_data.l3, uranus_data.l4,
];
final _uranusB = [
  uranus_data.b0, uranus_data.b1, uranus_data.b2,
  uranus_data.b3,
];
final _uranusR = [
  uranus_data.r0, uranus_data.r1, uranus_data.r2,
  uranus_data.r3, uranus_data.r4,
];

final _neptuneL = [
  neptune_data.l0, neptune_data.l1, neptune_data.l2,
  neptune_data.l3,
];
final _neptuneB = [
  neptune_data.b0, neptune_data.b1, neptune_data.b2,
  neptune_data.b3,
];
final _neptuneR = [
  neptune_data.r0, neptune_data.r1, neptune_data.r2,
  neptune_data.r3, neptune_data.r4,
];
