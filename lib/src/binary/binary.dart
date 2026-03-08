/// Binary: Chapter 57, Binary Stars.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Mean anomaly of a binary star.
///
/// [year] is decimal year, [t] is time of periastron (decimal year),
/// [p] is period in years. Result in radians.
double meanAnomaly(double year, double t, double p) {
  final n = 2 * math.pi / p;
  return mod2pi(n * (year - t));
}

/// Apparent position angle and angular distance of binary components.
///
/// [e] eccentricity, [a] apparent semimajor axis (radians),
/// [i] inclination, [omega] position angle of ascending node,
/// [w] longitude of periastron, [eAnom] eccentric anomaly. All radians.
({double theta, double rho}) position(
    double e, double a, double i, double omega, double w, double eAnom) {
  final r = a * (1 - e * math.cos(eAnom));
  final nu = 2 * math.atan(math.sqrt((1 + e) / (1 - e)) * math.tan(eAnom / 2));
  final sNuW = math.sin(nu + w);
  final cNuW = math.cos(nu + w);
  final ci = math.cos(i);
  final num = sNuW * ci;
  final theta = mod2pi(math.atan2(num, cNuW) + omega);
  final rho = r * math.sqrt(num * num + cNuW * cNuW);
  return (theta: theta, rho: rho);
}

/// Apparent eccentricity from true orbital elements.
double apparentEccentricity(double e, double i, double w) {
  final ci = math.cos(i);
  final sW = math.sin(w), cW = math.cos(w);
  final aa = (1 - e * e * cW * cW) * ci * ci;
  final b = e * e * sW * cW * ci;
  final cc = 1 - e * e * sW * sW;
  final d = aa - cc;
  final sD = math.sqrt(d * d + 4 * b * b);
  return math.sqrt(2 * sD / (aa + cc + sD));
}
