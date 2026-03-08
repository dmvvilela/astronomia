/// Jupitermoons: Chapter 44, Positions of the Satellites of Jupiter.
///
/// Positions() provides approximate positions (no VSOP87 needed).
/// E5 (high accuracy) requires planetposition module.
library;

import 'dart:math' as math;

import '../julian/julian.dart';

const double _p = math.pi / 180;

/// Approximate positions of the four Galilean moons.
///
/// Returns positions in units of Jupiter radii for Io, Europa, Ganymede, Callisto.
({({double x, double y}) io, ({double x, double y}) europa,
    ({double x, double y}) ganymede, ({double x, double y}) callisto})
    positions(double jde) {
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
  final lambda = 34.35 * _p + 0.083091 * _p * d + 0.329 * _p * sV + b;
  final ds = 3.12 * _p * math.sin(lambda + 42.8 * _p);
  final de = ds - 2.22 * _p * math.sin(psi) * math.cos(lambda + 22 * _p) -
      1.3 * _p * (r - delta) / delta * math.sin(lambda - 100.5 * _p);
  final dd = d - delta / 173;

  final u1 = 163.8069 * _p + 203.4058646 * _p * dd + psi - b;
  final u2 = 358.414 * _p + 101.2916335 * _p * dd + psi - b;
  final u3 = 5.7176 * _p + 50.234518 * _p * dd + psi - b;
  final u4 = 224.8092 * _p + 21.48798 * _p * dd + psi - b;
  final g = 331.18 * _p + 50.310482 * _p * dd;
  final h = 87.45 * _p + 21.569231 * _p * dd;

  final s212 = math.sin(2 * (u1 - u2)), c212 = math.cos(2 * (u1 - u2));
  final s223 = math.sin(2 * (u2 - u3)), c223 = math.cos(2 * (u2 - u3));
  final sG = math.sin(g), cG = math.cos(g);
  final sH = math.sin(h), cH = math.cos(h);

  final c1 = 0.473 * _p * s212;
  final c2 = 1.065 * _p * s223;
  final c3 = 0.165 * _p * sG;
  final c4 = 0.843 * _p * sH;
  final r1 = 5.9057 - 0.0244 * c212;
  final r2 = 9.3966 - 0.0882 * c223;
  final r3 = 14.9883 - 0.0216 * cG;
  final r4 = 26.3627 - 0.1939 * cH;

  final sDE = math.sin(de);
  ({double x, double y}) xy(double u, double radius) {
    return (x: radius * math.sin(u), y: -radius * math.cos(u) * sDE);
  }

  return (
    io: xy(u1 + c1, r1),
    europa: xy(u2 + c2, r2),
    ganymede: xy(u3 + c3, r3),
    callisto: xy(u4 + c4, r4),
  );
}
