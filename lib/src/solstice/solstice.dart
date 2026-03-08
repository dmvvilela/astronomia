/// Solstice: Chapter 27, Equinoxes and Solstices.
///
/// Low-accuracy methods valid for years -1000 to +3000.
/// Accuracy within one minute for 1951–2050.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

// Polynomial coefficients for years < 1000
const _mc0 = [1721139.29189, 365242.13740, 0.06134, 0.00111, -0.00071];
const _jc0 = [1721233.25401, 365241.72562, -0.05232, 0.00907, 0.00025];
const _sc0 = [1721325.70455, 365242.49558, -0.11677, -0.00297, 0.00074];
const _dc0 = [1721414.39987, 365242.88257, -0.00769, -0.00933, -0.00006];

// Polynomial coefficients for years >= 1000
const _mc2 = [2451623.80984, 365242.37404, 0.05169, -0.00411, -0.00057];
const _jc2 = [2451716.56767, 365241.62603, 0.00325, 0.00888, -0.00030];
const _sc2 = [2451810.21715, 365242.01767, -0.11575, 0.00337, 0.00078];
const _dc2 = [2451900.05952, 365242.74049, -0.06223, -0.00823, 0.00032];

// Periodic terms from Table 27.C
const _terms = <(double, double, double)>[
  (485, 324.96, 1934.136),
  (203, 337.23, 32964.467),
  (199, 342.08, 20.186),
  (182, 27.85, 445267.112),
  (156, 73.14, 45036.886),
  (136, 171.52, 22518.443),
  (77, 222.54, 65928.934),
  (74, 296.72, 3034.906),
  (70, 243.58, 9037.513),
  (58, 119.81, 33718.147),
  (52, 297.17, 150.678),
  (50, 21.02, 2281.226),
  (45, 247.54, 29929.562),
  (44, 325.15, 31555.956),
  (29, 60.93, 4443.417),
  (18, 155.12, 67555.328),
  (17, 288.79, 4562.452),
  (16, 198.04, 62894.029),
  (14, 199.76, 31436.921),
  (12, 95.39, 14577.848),
  (12, 287.11, 31931.756),
  (12, 320.81, 34777.259),
  (9, 227.73, 1222.114),
  (8, 15.45, 16859.074),
];

double _eq(int y, List<double> c) {
  final j0 = horner(y * 0.001, c);
  final t = j2000Century(j0);
  final w = toRad(35999.373 * t - 2.47);
  final dLambda = 1 + 0.0334 * math.cos(w) + 0.0007 * math.cos(2 * w);
  var s = 0.0;
  for (var i = _terms.length - 1; i >= 0; i--) {
    final (a, b, cc) = _terms[i];
    s += a * math.cos(toRad(b + cc * t));
  }
  return j0 + 0.00001 * s / dLambda;
}

/// JDE of the March equinox for the given year.
double march(int y) => y < 1000 ? _eq(y, _mc0) : _eq(y - 2000, _mc2);

/// JDE of the June solstice for the given year.
double june(int y) => y < 1000 ? _eq(y, _jc0) : _eq(y - 2000, _jc2);

/// JDE of the September equinox for the given year.
double september(int y) => y < 1000 ? _eq(y, _sc0) : _eq(y - 2000, _sc2);

/// JDE of the December solstice for the given year.
double december(int y) => y < 1000 ? _eq(y, _dc0) : _eq(y - 2000, _dc2);
