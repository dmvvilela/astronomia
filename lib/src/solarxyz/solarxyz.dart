/// Solarxyz: Chapter 26, Rectangular Coordinates of the Sun.
///
/// Low-accuracy rectangular coordinates using the solar module.
/// VSOP87-based methods will be added with planetposition module.
library;

import 'dart:math' as math;

import '../julian/julian.dart';
import '../nutation/nutation.dart' as nut;
import '../solar/solar.dart' as solar;

/// Rectangular coordinates referenced to the mean equinox of date.
///
/// Uses low-accuracy solar position. For high accuracy, use VSOP87
/// (to be added with planetposition module).
({double x, double y, double z}) position(double jde) {
  final t = j2000Century(jde);
  final sun = solar.trueSun(t);
  final r = solar.radius(t);
  final eps = nut.meanObliquity(jde);
  final sS = math.sin(sun.lon);
  final cS = math.cos(sun.lon);
  final sEps = math.sin(eps);
  final cEps = math.cos(eps);
  return (
    x: r * cS,
    y: r * (sS * cEps),
    z: r * (sS * sEps),
  );
}
