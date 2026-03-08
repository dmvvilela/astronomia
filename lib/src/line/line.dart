/// Line: Chapter 19, Bodies in Straight Line.
library;

import 'dart:math' as math;

import '../angle/angle.dart';

/// Angular deviation of a third body from the line connecting two others.
///
/// All coordinates in radians. Result in radians.
double angle(double ra1, double dec1, double ra2, double dec2,
    double ra3, double dec3) {
  final d12 = sep(ra1, dec1, ra2, dec2);
  final d13 = sep(ra1, dec1, ra3, dec3);
  final d23 = sep(ra2, dec2, ra3, dec3);
  // semi-perimeter
  final s = (d12 + d13 + d23) / 2;
  // area via Heron's formula
  final area = math.sqrt(s * (s - d12) * (s - d13) * (s - d23));
  // perpendicular distance = 2*area / base
  return 2 * area / d12;
}
