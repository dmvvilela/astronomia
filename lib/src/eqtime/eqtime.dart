/// Equation of Time: Chapter 28.
///
/// Note: Full implementation requires nutation, coord, solar, and
/// planetposition modules. This file provides the L0 polynomial and
/// will be completed when dependencies are ported.
library;

import '../base/math.dart';

/// Mean longitude of the Sun, L0, from (28.2) p. 183.
///
/// [tau] is in Julian millennia from J2000.0.
/// Returns L0 in degrees.
double l0(double tau) {
  return horner(tau, [
    280.4664567,
    360007.6982779,
    0.03032028,
    1 / 49931,
    -1 / 15300,
    -1 / 2000000,
  ]);
}
