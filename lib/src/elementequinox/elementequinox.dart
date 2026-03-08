/// Elementequinox: Chapter 24, Reduction of Ecliptical Elements
/// from one Equinox to another.
library;

import 'dart:math' as math;

const double _p = math.pi / 180;

/// Reduce ecliptical elements from B1950 to J2000.
///
/// [inc], [peri], [node] are inclination, argument of perihelion, and
/// longitude of ascending node, all in radians.
/// Returns corrected values in radians.
({double inc, double peri, double node}) reduceB1950ToJ2000(
    double inc, double peri, double node) {
  const incPrime = 1.3970 * _p;
  const nodePrime = 174.298 * _p;
  const psiA = 47.0029 * _p;

  final sNd = math.sin(node - nodePrime);
  final cNd = math.cos(node - nodePrime);
  final si = math.sin(inc);
  final ci = math.cos(inc);

  final a = si * sNd;
  final b = -math.sin(psiA) * ci + math.cos(psiA) * si * cNd;
  final incNew = math.asin(math.sqrt(a * a + b * b));
  final nodeNew = math.atan2(a, b) + 174.997 * _p;
  final periNew = peri + math.atan2(-math.sin(psiA) * sNd,
      si * math.cos(psiA) - ci * math.sin(psiA) * cNd);

  return (inc: incNew, peri: periNew, node: nodeNew);
}
