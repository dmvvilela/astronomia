/// Nutation: Chapter 22, Nutation and the Obliquity of the Ecliptic.
///
/// All angles in radians unless noted otherwise.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

/// Returns nutation in longitude (Δψ) and nutation in obliquity (Δε)
/// for a given JDE, both in radians.
({double dPsi, double dEps}) nutation(double jde) {
  final t = j2000Century(jde);
  final d = horner(t, [297.85036, 445267.11148, -0.0019142, 1 / 189474])
      * math.pi / 180;
  final m = horner(t, [357.52772, 35999.050340, -0.0001603, -1 / 300000])
      * math.pi / 180;
  final n = horner(t, [134.96298, 477198.867398, 0.0086972, 1 / 5620])
      * math.pi / 180;
  final f = horner(t, [93.27191, 483202.017538, -0.0036825, 1 / 327270])
      * math.pi / 180;
  final omega = horner(t, [125.04452, -1934.136261, 0.0020708, 1 / 450000])
      * math.pi / 180;

  var dPsiS = 0.0;
  var dEpsS = 0.0;
  for (var i = _table22A.length - 1; i >= 0; i--) {
    final row = _table22A[i];
    final arg = row[0] * d + row[1] * m + row[2] * n + row[3] * f + row[4] * omega;
    final sinArg = math.sin(arg);
    final cosArg = math.cos(arg);
    dPsiS += sinArg * (row[5] + row[6] * t);
    dEpsS += cosArg * (row[7] + row[8] * t);
  }
  return (
    dPsi: secToRad(dPsiS * 0.0001),
    dEps: secToRad(dEpsS * 0.0001),
  );
}

/// Fast approximation of nutation. Accuracy: 0.5″ in Δψ, 0.1″ in Δε.
({double dPsi, double dEps}) approxNutation(double jde) {
  final t = (jde - j2000) / 36525;
  final omega = (125.04452 - 1934.136261 * t) * math.pi / 180;
  final l = (280.4665 + 36000.7698 * t) * math.pi / 180;
  final n = (218.3165 + 481267.8813 * t) * math.pi / 180;

  final sOmega = math.sin(omega);
  final cOmega = math.cos(omega);
  final s2L = math.sin(2 * l);
  final c2L = math.cos(2 * l);
  final s2N = math.sin(2 * n);
  final c2N = math.cos(2 * n);
  final s2Omega = math.sin(2 * omega);
  final c2Omega = math.cos(2 * omega);

  return (
    dPsi: secToRad(-17.2 * sOmega - 1.32 * s2L - 0.23 * s2N + 0.21 * s2Omega),
    dEps: secToRad(9.2 * cOmega + 0.57 * c2L + 0.1 * c2N - 0.09 * c2Omega),
  );
}

/// Mean obliquity of the ecliptic (ε₀) using the IAU 1980 polynomial.
///
/// Returns radians. Accuracy: 1″ over 1000–3000 years.
double meanObliquity(double jde) {
  return secToRad(horner(j2000Century(jde), [
    fromSexaSec(23, 26, 21.448) * 3600, // convert degrees to arcseconds
    -46.815,
    -0.00059,
    0.001813,
  ]));
}

/// Mean obliquity using the Laskar 1986 polynomial.
///
/// Accuracy: .01″ over 1000–3000 years. Valid -8000 to +12000.
double meanObliquityLaskar(double jde) {
  return secToRad(horner(j2000Century(jde) * 0.01, [
    fromSexaSec(23, 26, 21.448) * 3600,
    -4680.93,
    -1.55,
    1999.25,
    -51.38,
    -249.67,
    -39.05,
    7.12,
    27.87,
    5.79,
    2.45,
  ]));
}

/// Nutation in right ascension (equation of the equinoxes), in radians.
double nutationInRA(double jde) {
  final nut = nutation(jde);
  final eps0 = meanObliquity(jde);
  return nut.dPsi * math.cos(eps0 + nut.dEps);
}

/// Table 22.A — IAU 1980 nutation coefficients.
/// Each row: [d, m, n, f, ω, s0, s1, c0, c1]
const _table22A = <List<double>>[
  [0, 0, 0, 0, 1, -171996, -174.2, 92025, 8.9],
  [-2, 0, 0, 2, 2, -13187, -1.6, 5736, -3.1],
  [0, 0, 0, 2, 2, -2274, -0.2, 977, -0.5],
  [0, 0, 0, 0, 2, 2062, 0.2, -895, 0.5],
  [0, 1, 0, 0, 0, 1426, -3.4, 54, -0.1],
  [0, 0, 1, 0, 0, 712, 0.1, -7, 0],
  [-2, 1, 0, 2, 2, -517, 1.2, 224, -0.6],
  [0, 0, 0, 2, 1, -386, -0.4, 200, 0],
  [0, 0, 1, 2, 2, -301, 0, 129, -0.1],
  [-2, -1, 0, 2, 2, 217, -0.5, -95, 0.3],
  [-2, 0, 1, 0, 0, -158, 0, 0, 0],
  [-2, 0, 0, 2, 1, 129, 0.1, -70, 0],
  [0, 0, -1, 2, 2, 123, 0, -53, 0],
  [2, 0, 0, 0, 0, 63, 0, 0, 0],
  [0, 0, 1, 0, 1, 63, 0.1, -33, 0],
  [2, 0, -1, 2, 2, -59, 0, 26, 0],
  [0, 0, -1, 0, 1, -58, -0.1, 32, 0],
  [0, 0, 1, 2, 1, -51, 0, 27, 0],
  [-2, 0, 2, 0, 0, 48, 0, 0, 0],
  [0, 0, -2, 2, 1, 46, 0, -24, 0],
  [2, 0, 0, 2, 2, -38, 0, 16, 0],
  [0, 0, 2, 2, 2, -31, 0, 13, 0],
  [0, 0, 2, 0, 0, 29, 0, 0, 0],
  [-2, 0, 1, 2, 2, 29, 0, -12, 0],
  [0, 0, 0, 2, 0, 26, 0, 0, 0],
  [-2, 0, 0, 2, 0, -22, 0, 0, 0],
  [0, 0, -1, 2, 1, 21, 0, -10, 0],
  [0, 2, 0, 0, 0, 17, -0.1, 0, 0],
  [2, 0, -1, 0, 1, 16, 0, -8, 0],
  [-2, 2, 0, 2, 2, -16, 0.1, 7, 0],
  [0, 1, 0, 0, 1, -15, 0, 9, 0],
  [-2, 0, 1, 0, 1, -13, 0, 7, 0],
  [0, -1, 0, 0, 1, -12, 0, 6, 0],
  [0, 0, 2, -2, 0, 11, 0, 0, 0],
  [2, 0, -1, 2, 1, -10, 0, 5, 0],
  [2, 0, 1, 2, 2, -8, 0, 3, 0],
  [0, 1, 0, 2, 2, 7, 0, -3, 0],
  [-2, 1, 1, 0, 0, -7, 0, 0, 0],
  [0, -1, 0, 2, 2, -7, 0, 3, 0],
  [2, 0, 0, 2, 1, -7, 0, 3, 0],
  [2, 0, 1, 0, 0, 6, 0, 0, 0],
  [-2, 0, 2, 2, 2, 6, 0, -3, 0],
  [-2, 0, 1, 2, 1, 6, 0, -3, 0],
  [2, 0, -2, 0, 1, -6, 0, 3, 0],
  [2, 0, 0, 0, 1, -6, 0, 3, 0],
  [0, -1, 1, 0, 0, 5, 0, 0, 0],
  [-2, -1, 0, 2, 1, -5, 0, 3, 0],
  [-2, 0, 0, 0, 1, -5, 0, 3, 0],
  [0, 0, 2, 2, 1, -5, 0, 3, 0],
  [-2, 0, 2, 0, 1, 4, 0, 0, 0],
  [-2, 1, 0, 2, 1, 4, 0, 0, 0],
  [0, 0, 1, -2, 0, 4, 0, 0, 0],
  [-1, 0, 1, 0, 0, -4, 0, 0, 0],
  [-2, 1, 0, 0, 0, -4, 0, 0, 0],
  [1, 0, 0, 0, 0, -4, 0, 0, 0],
  [0, 0, 1, 2, 0, 3, 0, 0, 0],
  [0, 0, -2, 2, 2, -3, 0, 0, 0],
  [-1, -1, 1, 0, 0, -3, 0, 0, 0],
  [0, 1, 1, 0, 0, -3, 0, 0, 0],
  [0, -1, 1, 2, 2, -3, 0, 0, 0],
  [2, -1, -1, 2, 2, -3, 0, 0, 0],
  [0, 0, 3, 2, 2, -3, 0, 0, 0],
  [2, -1, 0, 2, 2, -3, 0, 0, 0],
];
