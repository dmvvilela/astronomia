/// Kepler: Chapter 30, Equation of Kepler.
library;

import 'dart:math' as math;

import '../iterate/iterate.dart';

/// True anomaly ν from eccentric anomaly [e_anom] and eccentricity [e].
///
/// All angles in radians.
double trueAnomaly(double eAnom, double e) {
  return 2 * math.atan(math.sqrt((1 + e) / (1 - e)) * math.tan(eAnom / 2));
}

/// Radius distance from eccentric anomaly [eAnom], eccentricity [e],
/// and semimajor axis [a].
///
/// Result unit matches [a] (typically AU).
double radius(double eAnom, double e, double a) {
  return a * (1 - e * math.cos(eAnom));
}

/// Solves Kepler's equation by simple iteration.
///
/// E₁ = M + e·sin(E₀)
///
/// May fail to converge for some values of [e] and [m].
double kepler1(double e, double m, {int places = 8}) {
  return decimalPlaces(
    (e0) => m + e * math.sin(e0),
    m,
    places: places,
    maxIterations: places * 5,
  );
}

/// Solves Kepler's equation by Newton-like iteration.
///
/// E₁ = E₀ + (M + e·sin(E₀) - E₀) / (1 - e·cos(E₀))
///
/// Converges over a wider range than [kepler1].
double kepler2(double e, double m, {int places = 8}) {
  return decimalPlaces(
    (e0) {
      final se = math.sin(e0);
      final ce = math.cos(e0);
      return e0 + (m + e * se - e0) / (1 - e * ce);
    },
    m,
    places: places,
    maxIterations: places,
  );
}

/// Kepler2 with Leingärtner limiting to avoid divergence.
double kepler2a(double e, double m, {int places = 8}) {
  return decimalPlaces(
    (e0) {
      final se = math.sin(e0);
      final ce = math.cos(e0);
      return e0 + math.asin(math.sin((m + e * se - e0) / (1 - e * ce)));
    },
    m,
    places: places,
    maxIterations: places * 5,
  );
}

/// Kepler2 with Steele limiting to avoid divergence.
double kepler2b(double e, double m, {int places = 8}) {
  return decimalPlaces(
    (e0) {
      final se = math.sin(e0);
      final ce = math.cos(e0);
      var d = (m + e * se - e0) / (1 - e * ce);
      if (d > 0.5) {
        d = 0.5;
      } else if (d < -0.5) {
        d = -0.5;
      }
      return e0 + d;
    },
    m,
    places: places,
    maxIterations: places,
  );
}

/// Solves Kepler's equation by binary search (53 iterations).
double kepler3(double e, double m) {
  var mr = m % (2 * math.pi);
  if (mr < 0) mr += 2 * math.pi;
  var f = 1;
  if (mr > math.pi) {
    f = -1;
    mr = 2 * math.pi - mr;
  }
  var e0 = math.pi * 0.5;
  var d = math.pi * 0.25;
  for (var i = 0; i < 53; i++) {
    final m1 = e0 - e * math.sin(e0);
    if (mr - m1 < 0) {
      e0 -= d;
    } else {
      e0 += d;
    }
    d *= 0.5;
  }
  if (f < 0) e0 = -e0;
  return e0;
}

/// Approximate solution valid only for small eccentricity.
double kepler4(double e, double m) {
  return math.atan2(math.sin(m), math.cos(m) - e);
}
