/// Jupiter: Chapter 43, Physical Observations of Jupiter.
///
/// Physical2 provides approximate quantities (no VSOP87 needed).
/// Physical (full accuracy) requires planetposition module.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

const double _p = math.pi / 180;

/// Approximate physical observations of Jupiter.
///
/// Returns (ds, de, omega1, omega2) all in radians:
/// - ds: Planetocentric declination of the Sun
/// - de: Planetocentric declination of the Earth
/// - omega1: System I central meridian longitude
/// - omega2: System II central meridian longitude
({double ds, double de, double omega1, double omega2}) physical2(double jde) {
  final d = jde - j2000;
  final v = 172.74 * _p + 0.00111588 * _p * d;
  final m = 357.529 * _p + 0.9856003 * _p * d;
  final sV = math.sin(v);
  final n = 20.02 * _p + 0.0830853 * _p * d + 0.329 * _p * sV;
  final j = 66.115 * _p + 0.9025179 * _p * d - 0.329 * _p * sV;
  final sM = math.sin(m), cM = math.cos(m);
  final sN = math.sin(n), cN = math.cos(n);
  final s2M = math.sin(2 * m), c2M = math.cos(2 * m);
  final s2N = math.sin(2 * n), c2N = math.cos(2 * n);
  final a = 1.915 * _p * sM + 0.02 * _p * s2M;
  final b = 5.555 * _p * sN + 0.168 * _p * s2N;
  final kk = j + a - b;
  final rr = 1.00014 - 0.01671 * cM - 0.00014 * c2M;
  final r = 5.20872 - 0.25208 * cN - 0.00611 * c2N;
  final sK = math.sin(kk), cK = math.cos(kk);
  final delta = math.sqrt(r * r + rr * rr - 2 * r * rr * cK);
  final psi = math.asin(rr / delta * sK);
  final dd = d - delta / 173;

  var omega1 = mod2pi(210.98 * _p + 877.8169088 * _p * dd + psi - b);
  var omega2 = mod2pi(187.23 * _p + 870.1869088 * _p * dd + psi - b);

  // Correction C
  final sinHalf = math.sin(psi / 2);
  var c = sinHalf * sinHalf;
  if (sK > 0) c = -c;
  omega1 = mod2pi(omega1 + c);
  omega2 = mod2pi(omega2 + c);

  final lambda = 34.35 * _p + 0.083091 * _p * d + 0.329 * _p * sV + b;
  final ds = 3.12 * _p * math.sin(lambda + 42.8 * _p);
  final de = ds - 2.22 * _p * math.sin(psi) * math.cos(lambda + 22 * _p) -
      1.3 * _p * (r - delta) / delta * math.sin(lambda - 100.5 * _p);

  return (ds: ds, de: de, omega1: omega1, omega2: omega2);
}
