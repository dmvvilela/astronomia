/// Circle: Chapter 20, Smallest Circle containing three Celestial Bodies.
library;

import 'dart:math' as math;

import '../angle/angle.dart';

/// Smallest circle containing three celestial bodies.
///
/// All arguments in radians. Returns diameter in radians and whether
/// the solution is Type I (two points on circle, third inside).
({double diameter, bool typeI}) smallest(
    double ra1, double dec1,
    double ra2, double dec2,
    double ra3, double dec3) {
  var a = sep(ra1, dec1, ra2, dec2);
  var b = sep(ra2, dec2, ra3, dec3);
  var c = sep(ra3, dec3, ra1, dec1);

  // Sort so a >= b >= c
  if (a < b) { final t = a; a = b; b = t; }
  if (a < c) { final t = a; a = c; c = t; }
  if (b < c) { final t = b; b = c; c = t; }

  if (a >= math.sqrt(b * b + c * c)) {
    return (diameter: a, typeI: true);
  }
  // Type II: all three on circle
  final d = 2 * a * b * c /
      math.sqrt((a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c));
  return (diameter: d, typeI: false);
}
