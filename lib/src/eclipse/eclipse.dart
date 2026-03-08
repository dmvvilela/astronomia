/// Eclipse: Chapter 54, Eclipses.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../moonphase/moonphase.dart' as moonphase;

const int none = 0;
const int partial = 1;
const int annular = 2;
const int annularTotal = 3;
const int penumbral = 4;
const int umbral = 5;
const int total = 6;

double _snap(double y, double q) {
  final k = (y - 2000) * 12.3685;
  return (k - q + 0.5).floorToDouble() + q;
}

({bool eclipse, double jmax, double gamma, double u, double mPrime})
    _g(double k, double jm, double c1, double c2) {
  const ck = 1 / 1236.85;
  const p = math.pi / 180;
  final t = k * ck;
  final f = horner(t, [160.7108 * p, 390.67050284 * p / ck,
      -0.0016118 * p, -0.00000227 * p, 0.000000011 * p]);
  if (math.sin(f).abs() > 0.36) {
    return (eclipse: false, jmax: 0, gamma: 0, u: 0, mPrime: 0);
  }
  final e = horner(t, [1.0, -0.002516, -0.0000074]);
  final m = horner(t, [2.5534 * p, 29.1053567 * p / ck,
      -0.0000014 * p, -0.00000011 * p]);
  final mPrime = horner(t, [201.5643 * p, 385.81693528 * p / ck,
      0.0107582 * p, 0.00001238 * p, -0.000000058 * p]);
  final omega = horner(t, [124.7746 * p, -1.56375588 * p / ck,
      0.0020672 * p, 0.00000215 * p]);
  final sOmega = math.sin(omega);
  final f1 = f - 0.02665 * p * sOmega;
  final a1 = horner(t, [299.77 * p, 0.107408 * p / ck, -0.009173 * p]);

  final jmax = jm +
      c1 * math.sin(mPrime) +
      c2 * math.sin(m) * e +
      0.0161 * math.sin(2 * mPrime) +
      -0.0097 * math.sin(2 * f1) +
      0.0073 * math.sin(mPrime - m) * e +
      -0.005 * math.sin(mPrime + m) * e +
      -0.0023 * math.sin(mPrime - 2 * f1) +
      0.0021 * math.sin(2 * m) * e +
      0.0012 * math.sin(mPrime + 2 * f1) +
      0.0006 * math.sin(2 * mPrime + m) * e +
      -0.0004 * math.sin(3 * mPrime) +
      -0.0003 * math.sin(m + 2 * f1) * e +
      0.0003 * math.sin(a1) +
      -0.0002 * math.sin(m - 2 * f1) * e +
      -0.0002 * math.sin(2 * mPrime - m) * e +
      -0.0002 * sOmega;

  final pp = 0.207 * math.sin(m) * e +
      0.0024 * math.sin(2 * m) * e +
      -0.0392 * math.sin(mPrime) +
      0.0116 * math.sin(2 * mPrime) +
      -0.0073 * math.sin(mPrime + m) * e +
      0.0067 * math.sin(mPrime - m) * e +
      0.0118 * math.sin(2 * f1);

  final q = 5.2207 +
      -0.0048 * math.cos(m) * e +
      0.002 * math.cos(2 * m) * e +
      -0.3299 * math.cos(mPrime) +
      -0.006 * math.cos(mPrime + m) * e +
      0.0041 * math.cos(mPrime - m) * e;

  final sF1 = math.sin(f1), cF1 = math.cos(f1);
  final w = cF1.abs();
  final gamma = (pp * cF1 + q * sF1) * (1 - 0.0048 * w);
  final u = 0.0059 +
      0.0046 * math.cos(m) * e +
      -0.0182 * math.cos(mPrime) +
      0.0004 * math.cos(2 * mPrime) +
      -0.0005 * math.cos(m + mPrime);

  return (eclipse: true, jmax: jmax, gamma: gamma, u: u, mPrime: mPrime);
}

/// Solar eclipse nearest decimal [year].
///
/// Returns eclipse type (none/partial/annular/annularTotal/total),
/// whether central, jmax, gamma, u, penumbral cone radius, and magnitude.
({int type, bool central, double jmax, double gamma, double u, double p, double mag})
    solar(double year) {
  final r = _g(_snap(year, 0), moonphase.meanNew(year), -0.4075, 0.1721);
  final penumbra = r.u + 0.5461;
  if (!r.eclipse) {
    return (type: none, central: false, jmax: 0, gamma: 0, u: 0, p: 0, mag: 0);
  }
  final aGamma = r.gamma.abs();
  if (aGamma > 1.5433 + r.u) {
    return (type: none, central: false, jmax: r.jmax, gamma: r.gamma, u: r.u, p: penumbra, mag: 0);
  }
  final central = aGamma < 0.9972;
  int eclType;
  double mag = 0;
  if (!central) {
    eclType = partial;
    if (aGamma < 1.026 && aGamma < 0.9972 + r.u.abs()) {
      eclType = total;
    }
  } else if (r.u < 0) {
    eclType = total;
  } else if (r.u > 0.0047) {
    eclType = annular;
  } else {
    final omega = 0.00464 * math.sqrt(1 - r.gamma * r.gamma);
    eclType = r.u < omega ? annularTotal : annular;
  }
  if (eclType == partial) {
    mag = (1.5433 + r.u - aGamma) / (0.5461 + 2 * r.u);
  }
  return (type: eclType, central: central, jmax: r.jmax, gamma: r.gamma, u: r.u, p: penumbra, mag: mag);
}

/// Lunar eclipse nearest decimal [year].
///
/// Returns eclipse type, jmax, gamma, rho, sigma, magnitude, and semidurations
/// (total, partial, penumbral) in days.
({int type, double jmax, double gamma, double rho, double sigma, double mag,
    double sdTotal, double sdPartial, double sdPenumbral})
    lunar(double year) {
  final r = _g(_snap(year, 0.5), moonphase.meanFull(year), -0.4065, 0.1727);
  if (!r.eclipse) {
    return (type: none, jmax: 0, gamma: 0, rho: 0, sigma: 0, mag: 0,
        sdTotal: 0, sdPartial: 0, sdPenumbral: 0);
  }
  final rho = 1.2848 + r.u;
  final sigma = 0.7403 - r.u;
  final aGamma = r.gamma.abs();
  var mag = (1.0128 - r.u - aGamma) / 0.545;
  int eclType;
  if (mag > 1) {
    eclType = total;
  } else if (mag > 0) {
    eclType = umbral;
  } else {
    mag = (1.5573 + r.u - aGamma) / 0.545;
    if (mag < 0) {
      return (type: none, jmax: r.jmax, gamma: r.gamma, rho: rho, sigma: sigma,
          mag: 0, sdTotal: 0, sdPartial: 0, sdPenumbral: 0);
    }
    eclType = penumbral;
  }

  final p = 1.0128 - r.u;
  final t = 0.4678 - r.u;
  final n = 0.5458 + 0.04 * math.cos(r.mPrime);
  final g2 = r.gamma * r.gamma;
  final sdTotal = eclType == total
      ? math.sqrt(t * t - g2) / n / 24
      : 0.0;
  final sdPartial = (eclType == total || eclType == umbral)
      ? math.sqrt(p * p - g2) / n / 24
      : 0.0;
  final h = 1.5573 + r.u;
  final sdPenumbral = math.sqrt(h * h - g2) / n / 24;

  return (type: eclType, jmax: r.jmax, gamma: r.gamma, rho: rho, sigma: sigma,
      mag: mag, sdTotal: sdTotal, sdPartial: sdPartial, sdPenumbral: sdPenumbral);
}
