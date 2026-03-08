/// Nearparabolic: Chapter 35, Near-parabolic Motion.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// True anomaly and distance for a body in a near-parabolic orbit.
///
/// [timeP] is time of perihelion (JDE), [pDis] is perihelion distance (AU),
/// [ecc] is eccentricity (near 1.0).
///
/// Returns (nu, r) where nu is true anomaly in radians and r is distance in AU.
/// Throws if the algorithm fails to converge.
({double nu, double r}) anomalyDistance(
    double jde, double timeP, double pDis, double ecc) {
  final q1 = k * math.sqrt((1 + ecc) / pDis) / (2 * pDis);
  final g = (1 - ecc) / (1 + ecc);
  final t = jde - timeP;

  if (t == 0) return (nu: 0.0, r: pDis);

  const d1 = 10000.0;
  const d = 1e-9;
  final q2 = q1 * t;
  var s = 2.0 / (3 * q2.abs());
  s = 2 / math.tan(2 * math.atan(_cbrt(math.tan(math.atan(s) / 2))));
  if (t < 0) s = -s;

  if (ecc != 1) {
    var l = 0;
    for (;;) {
      final s0 = s;
      var z = 1.0;
      final y = s * s;
      var g1 = -y * s;
      var q3 = q2 + 2 * g * s * y / 3;
      for (;;) {
        z += 1;
        g1 = -g1 * g * y;
        final z1 = (z - (z + 1) * g) / (2 * z + 1);
        final f = z1 * g1;
        q3 += f;
        if (z > 50 || f.abs() > d1) {
          throw StateError('Near-parabolic: no convergence');
        }
        if (f.abs() <= d) break;
      }
      l++;
      if (l > 50) throw StateError('Near-parabolic: no convergence');
      for (;;) {
        final s1 = s;
        s = (2 * s * s * s / 3 + q3) / (s * s + 1);
        if ((s - s1).abs() <= d) break;
      }
      if ((s - s0).abs() <= d) break;
    }
  }

  var nu = 2 * math.atan(s);
  final r = pDis * (1 + ecc) / (1 + ecc * math.cos(nu));
  if (nu < 0) nu += 2 * math.pi;
  return (nu: nu, r: r);
}

double _cbrt(double x) => x.sign * math.pow(x.abs(), 1.0 / 3.0);
