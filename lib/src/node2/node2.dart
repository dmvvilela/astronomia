/// Node: Chapter 39, Passages through the Nodes.
///
/// Named node2 to avoid conflict with moonnode module.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Time and distance at ascending node for an elliptic orbit.
///
/// [axis] semimajor axis (AU), [ecc] eccentricity, [argP] argument of
/// perihelion (radians), [timeP] time of perihelion (JDE).
({double jde, double r}) ellipticAscending(
    double axis, double ecc, double argP, double timeP) {
  return _el(-argP, axis, ecc, timeP);
}

/// Time and distance at descending node for an elliptic orbit.
({double jde, double r}) ellipticDescending(
    double axis, double ecc, double argP, double timeP) {
  return _el(math.pi - argP, axis, ecc, timeP);
}

({double jde, double r}) _el(double nu, double axis, double ecc, double timeP) {
  final ee = 2 * math.atan(math.sqrt((1 - ecc) / (1 + ecc)) * math.tan(nu / 2));
  final sE = math.sin(ee), cE = math.cos(ee);
  final m = ee - ecc * sE;
  final n = k / axis / math.sqrt(axis);
  return (jde: timeP + m / n, r: axis * (1 - ecc * cE));
}

/// Time and distance at ascending node for a parabolic orbit.
///
/// [q] perihelion distance (AU), [argP] argument of perihelion (radians),
/// [timeP] time of perihelion (JDE).
({double jde, double r}) parabolicAscending(
    double q, double argP, double timeP) {
  return _pa(-argP, q, timeP);
}

/// Time and distance at descending node for a parabolic orbit.
({double jde, double r}) parabolicDescending(
    double q, double argP, double timeP) {
  return _pa(math.pi - argP, q, timeP);
}

({double jde, double r}) _pa(double nu, double q, double timeP) {
  final s = math.tan(nu / 2);
  return (
    jde: timeP + 27.403895 * s * (s * s + 3) * q * math.sqrt(q),
    r: q * (1 + s * s),
  );
}
