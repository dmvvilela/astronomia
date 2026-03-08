/// Solardisk: Chapter 29, Ephemeris for Physical Observations of the Sun.
///
/// Provides Carrington rotation cycle calculations. Full ephemeris
/// (P, B0, L0) requires VSOP87 and will be completed with planetposition.
library;

import 'dart:math' as math;

/// Returns the JDE of the start of the given Carrington synodic rotation.
///
/// [c] is the Carrington cycle number. Result is dynamical time.
double cycle(int c) {
  final cf = c.toDouble();
  final jde = 2398140.227 + 27.2752316 * cf;
  final m = (281.96 + 26.882476 * cf) * math.pi / 180;
  final s2m = math.sin(2 * m);
  final c2m = math.cos(2 * m);
  return jde + 0.1454 * math.sin(m) - 0.0085 * s2m - 0.0141 * c2m;
}
