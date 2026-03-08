/// Elliptic: Chapter 33, Elliptic Motion.
///
/// Stub — full implementation requires planetposition (VSOP87).
/// Provides velocity and orbit length functions that are self-contained.
library;

import 'dart:math' as math;


/// Velocity of a body at distance [r] in an orbit with semimajor axis [a].
///
/// Both in AU. Result in AU/day.
double velocity(double a, double r) {
  return 0.0172021 * math.sqrt(2 / r - 1 / a);
}

/// Velocity at aphelion for eccentricity [e] and semimajor axis [a].
double vAphelion(double a, double e) {
  return 0.0172021 * math.sqrt((1 - e) / (a * (1 + e)));
}

/// Velocity at perihelion for eccentricity [e] and semimajor axis [a].
double vPerihelion(double a, double e) {
  return 0.0172021 * math.sqrt((1 + e) / (a * (1 - e)));
}

/// Approximate length of an elliptic orbit (Ramanujan, first approximation).
///
/// [a] is semimajor axis, [e] is eccentricity. Result in same units as [a].
double length1(double a, double e) {
  final b = a * math.sqrt(1 - e * e);
  return math.pi * (3 * (a + b) - math.sqrt((3 * a + b) * (a + 3 * b)));
}

/// Approximate length of an elliptic orbit (Ramanujan, second approximation).
double length2(double a, double e) {
  final b = a * math.sqrt(1 - e * e);
  final h = ((a - b) / (a + b));
  final h2 = h * h;
  return math.pi * (a + b) * (1 + 3 * h2 / (10 + math.sqrt(4 - 3 * h2)));
}

/// Length of an elliptic orbit by numerical integration (4-point).
double length4(double a, double e) {
  final b = a * math.sqrt(1 - e * e);
  final m = (a - b) / (a + b);
  final m2 = m * m;
  return math.pi * (a + b) *
      (64 + 16 * m2) / (64 - 48 * m2 + 3 * m2 * m2 + m2 * m2 * m2 / 4);
}
