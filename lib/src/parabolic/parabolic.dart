/// Parabolic: Chapter 34, Parabolic Motion.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// True anomaly and distance for a body in a parabolic orbit.
///
/// [timeP] is time of perihelion (JDE), [pDis] is perihelion distance (AU).
/// Returns (nu, r) where nu is true anomaly in radians and r is distance in AU.
({double nu, double r}) anomalyDistance(double jde, double timeP, double pDis) {
  final w = 3 * k / math.sqrt2 * (jde - timeP) / pDis / math.sqrt(pDis);
  final g = w * 0.5;
  final y = _cbrt(g + math.sqrt(g * g + 1));
  final s = y - 1 / y;
  return (nu: 2 * math.atan(s), r: pDis * (1 + s * s));
}

double _cbrt(double x) => x.sign * math.pow(x.abs(), 1.0 / 3.0);
