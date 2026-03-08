/// Apsis: Chapter 50, Perigee and Apogee of the Moon.
library;

import 'dart:math' as math;

import '../base/math.dart';

const double _ck = 1 / 1325.55;
const double _p = math.pi / 180;

double _mean(double t) {
  return horner(t, [2451534.6698, 27.55454989 / _ck,
      -0.0006691, -0.000001098, 0.0000000052]);
}

double _snap(double y, double h) {
  final k = (y - 1999.97) * 13.2555;
  return (k - h + 0.5).floorToDouble() + h;
}

/// JDE of the mean perigee nearest the given decimal [year].
double meanPerigee(double year) => _mean(_snap(year, 0) * _ck);

/// JDE of the mean apogee nearest the given decimal [year].
double meanApogee(double year) => _mean(_snap(year, 0.5) * _ck);

/// JDE of perigee nearest the given decimal [year].
double perigee(double year) {
  final l = _La(year, 0);
  return _mean(l.t) + l._pc();
}

/// JDE of apogee nearest the given decimal [year].
double apogee(double year) {
  final l = _La(year, 0.5);
  return _mean(l.t) + l._ac();
}

/// Equatorial horizontal parallax at apogee nearest [year], in radians.
double apogeeParallax(double year) => _La(year, 0.5)._ap();

/// Equatorial horizontal parallax at perigee nearest [year], in radians.
double perigeeParallax(double year) => _La(year, 0)._pp();

class _La {
  final double k, t, d, m, f;

  _La._(this.k, this.t, this.d, this.m, this.f);

  factory _La(double y, double h) {
    final k = _snap(y, h);
    final t = k * _ck;
    final d = horner(t, [171.9179 * _p, 335.9106046 * _p / _ck,
        -0.0100383 * _p, -0.00001156 * _p, 0.000000055 * _p]);
    final m = horner(t, [347.3477 * _p, 27.1577721 * _p / _ck,
        -0.000813 * _p, -0.000001 * _p]);
    final f = horner(t, [316.6109 * _p, 364.5287911 * _p / _ck,
        -0.0125053 * _p, -0.0000148 * _p]);
    return _La._(k, t, d, m, f);
  }

  double _pc() {
    return -1.6769 * math.sin(2 * d) +
        0.4589 * math.sin(4 * d) +
        -0.1856 * math.sin(6 * d) +
        0.0883 * math.sin(8 * d) +
        (-0.0773 + 0.00019 * t) * math.sin(2 * d - m) +
        (0.0502 - 0.00013 * t) * math.sin(m) +
        -0.046 * math.sin(10 * d) +
        (0.0422 - 0.00011 * t) * math.sin(4 * d - m) +
        -0.0256 * math.sin(6 * d - m) +
        0.0253 * math.sin(12 * d) +
        0.0237 * math.sin(d) +
        0.0162 * math.sin(8 * d - m) +
        -0.0145 * math.sin(14 * d) +
        0.0129 * math.sin(2 * f) +
        -0.0112 * math.sin(3 * d) +
        -0.0104 * math.sin(10 * d - m) +
        0.0086 * math.sin(16 * d) +
        0.0069 * math.sin(12 * d - m) +
        0.0066 * math.sin(5 * d) +
        -0.0053 * math.sin(2 * (d + f)) +
        -0.0052 * math.sin(18 * d) +
        -0.0046 * math.sin(14 * d - m) +
        -0.0041 * math.sin(7 * d) +
        0.004 * math.sin(2 * d + m) +
        0.0032 * math.sin(20 * d) +
        -0.0032 * math.sin(d + m) +
        0.0031 * math.sin(16 * d - m) +
        -0.0029 * math.sin(4 * d + m) +
        0.0027 * math.sin(9 * d) +
        0.0027 * math.sin(4 * d + 2 * f) +
        -0.0027 * math.sin(2 * (d - m)) +
        0.0024 * math.sin(4 * d - 2 * m) +
        -0.0021 * math.sin(6 * d - 2 * m) +
        -0.0021 * math.sin(22 * d) +
        -0.0021 * math.sin(18 * d - m) +
        0.0019 * math.sin(6 * d + m) +
        -0.0018 * math.sin(11 * d) +
        -0.0014 * math.sin(8 * d + m) +
        -0.0014 * math.sin(4 * d - 2 * f) +
        -0.0014 * math.sin(6 * d + 2 * f) +
        0.0014 * math.sin(3 * d + m) +
        -0.0014 * math.sin(5 * d + m) +
        0.0013 * math.sin(13 * d) +
        0.0013 * math.sin(20 * d - m) +
        0.0011 * math.sin(3 * d + 2 * m) +
        -0.0011 * math.sin(2 * (2 * d + f - m)) +
        -0.001 * math.sin(d + 2 * m) +
        -0.0009 * math.sin(22 * d - m) +
        -0.0008 * math.sin(4 * f) +
        0.0008 * math.sin(6 * d - 2 * f) +
        0.0008 * math.sin(2 * (d - f) + m) +
        0.0007 * math.sin(2 * m) +
        0.0007 * math.sin(2 * f - m) +
        0.0007 * math.sin(2 * d + 4 * f) +
        -0.0006 * math.sin(2 * (f - m)) +
        -0.0006 * math.sin(2 * (d - f + m)) +
        0.0006 * math.sin(24 * d) +
        0.0005 * math.sin(4 * (d - f)) +
        0.0005 * math.sin(2 * (d + m)) +
        -0.0004 * math.sin(d - m);
  }

  double _ac() {
    return 0.4392 * math.sin(2 * d) +
        0.0684 * math.sin(4 * d) +
        (0.0456 - 0.00011 * t) * math.sin(m) +
        (0.0426 - 0.00011 * t) * math.sin(2 * d - m) +
        0.0212 * math.sin(2 * f) +
        -0.0189 * math.sin(d) +
        0.0144 * math.sin(6 * d) +
        0.0113 * math.sin(4 * d - m) +
        0.0047 * math.sin(2 * (d + f)) +
        0.0036 * math.sin(d + m) +
        0.0035 * math.sin(8 * d) +
        0.0034 * math.sin(6 * d - m) +
        -0.0034 * math.sin(2 * (d - f)) +
        0.0022 * math.sin(2 * (d - m)) +
        -0.0017 * math.sin(3 * d) +
        0.0013 * math.sin(4 * d + 2 * f) +
        0.0011 * math.sin(8 * d - m) +
        0.001 * math.sin(4 * d - 2 * m) +
        0.0009 * math.sin(10 * d) +
        0.0007 * math.sin(3 * d + m) +
        0.0006 * math.sin(2 * m) +
        0.0005 * math.sin(2 * d + m) +
        0.0005 * math.sin(2 * (d + m)) +
        0.0004 * math.sin(6 * d + 2 * f) +
        0.0004 * math.sin(6 * d - 2 * m) +
        0.0004 * math.sin(10 * d - m) +
        -0.0004 * math.sin(5 * d) +
        -0.0004 * math.sin(4 * d - 2 * f) +
        0.0003 * math.sin(2 * f + m) +
        0.0003 * math.sin(12 * d) +
        0.0003 * math.sin(2 * d + 2 * f - m) +
        -0.0003 * math.sin(d - m);
  }

  double _ap() {
    return secToRad(
        3245.251 +
        -9.147 * math.cos(2 * d) +
        -0.841 * math.cos(d) +
        0.697 * math.cos(2 * f) +
        (-0.656 + 0.0016 * t) * math.cos(m) +
        0.355 * math.cos(4 * d) +
        0.159 * math.cos(2 * d - m) +
        0.127 * math.cos(d + m) +
        0.065 * math.cos(4 * d - m) +
        0.052 * math.cos(6 * d) +
        0.043 * math.cos(2 * d + m) +
        0.031 * math.cos(2 * (d + f)) +
        -0.023 * math.cos(2 * (d - f)) +
        0.022 * math.cos(2 * (d - m)) +
        0.019 * math.cos(2 * (d + m)) +
        -0.016 * math.cos(2 * m) +
        0.014 * math.cos(6 * d - m) +
        0.01 * math.cos(8 * d));
  }

  double _pp() {
    return secToRad(
        3629.215 +
        63.224 * math.cos(2 * d) +
        -6.990 * math.cos(4 * d) +
        (2.834 - 0.0071 * t) * math.cos(2 * d - m) +
        1.927 * math.cos(6 * d) +
        -1.263 * math.cos(d) +
        -0.702 * math.cos(8 * d) +
        (0.696 - 0.0017 * t) * math.cos(m) +
        -0.690 * math.cos(2 * f) +
        (-0.629 + 0.0016 * t) * math.cos(4 * d - m) +
        -0.392 * math.cos(2 * (d - f)) +
        0.297 * math.cos(10 * d) +
        0.260 * math.cos(6 * d - m) +
        0.201 * math.cos(3 * d) +
        -0.161 * math.cos(2 * d + m) +
        0.157 * math.cos(d + m) +
        -0.138 * math.cos(12 * d) +
        -0.127 * math.cos(8 * d - m) +
        0.104 * math.cos(2 * (d + f)) +
        0.104 * math.cos(2 * (d - m)) +
        -0.079 * math.cos(5 * d) +
        0.068 * math.cos(14 * d) +
        0.067 * math.cos(10 * d - m) +
        0.054 * math.cos(4 * d + m) +
        -0.038 * math.cos(12 * d - m) +
        -0.038 * math.cos(4 * d - 2 * m) +
        0.037 * math.cos(7 * d) +
        -0.037 * math.cos(4 * d + 2 * f) +
        -0.035 * math.cos(16 * d) +
        -0.030 * math.cos(3 * d + m) +
        0.029 * math.cos(d - m));
  }
}
