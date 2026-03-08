/// Moonphase: Chapter 49, Phases of the Moon.
library;

import 'dart:math' as math;

import '../base/math.dart';

const double _ck = 1 / 1236.85;
const double _p = math.pi / 180;

double _mean(double t) {
  return horner(t, [2451550.09766, 29.530588861 / _ck,
      0.00015437, -0.00000015, 0.00000000073]);
}

double _snap(double y, double q) {
  final k = (y - 2000) * 12.3685;
  return (k - q + 0.5).floorToDouble() + q;
}

/// JDE of the mean New Moon nearest the given decimal [year].
double meanNew(double year) => _mean(_snap(year, 0) * _ck);

/// JDE of the mean First Quarter nearest the given decimal [year].
double meanFirst(double year) => _mean(_snap(year, 0.25) * _ck);

/// JDE of the mean Full Moon nearest the given decimal [year].
double meanFull(double year) => _mean(_snap(year, 0.5) * _ck);

/// JDE of the mean Last Quarter nearest the given decimal [year].
double meanLast(double year) => _mean(_snap(year, 0.75) * _ck);

/// JDE of New Moon nearest the given decimal [year].
double newMoon(double year) {
  final m = _Mp(year, 0);
  return _mean(m.t) + m._nfc(_nc) + m._a();
}

/// JDE of First Quarter nearest the given decimal [year].
double first(double year) {
  final m = _Mp(year, 0.25);
  return _mean(m.t) + m._flc() + m._w() + m._a();
}

/// JDE of Full Moon nearest the given decimal [year].
double full(double year) {
  final m = _Mp(year, 0.5);
  return _mean(m.t) + m._nfc(_fc) + m._a();
}

/// JDE of Last Quarter nearest the given decimal [year].
double last(double year) {
  final m = _Mp(year, 0.75);
  return _mean(m.t) + m._flc() - m._w() + m._a();
}

class _Mp {
  final double k, t, e, m, mp, f, omega;
  final List<double> aa;

  _Mp._(this.k, this.t, this.e, this.m, this.mp, this.f, this.omega, this.aa);

  factory _Mp(double y, double q) {
    final k = _snap(y, q);
    final t = k * _ck;
    final e = horner(t, [1.0, -0.002516, -0.0000074]);
    final m = horner(t, [2.5534 * _p, 29.1053567 * _p / _ck,
        -0.0000014 * _p, -0.00000011 * _p]);
    final mp = horner(t, [201.5643 * _p, 385.81693528 * _p / _ck,
        0.0107582 * _p, 0.00001238 * _p, -0.000000058 * _p]);
    final f = horner(t, [160.7108 * _p, 390.67050284 * _p / _ck,
        -0.0016118 * _p, -0.00000227 * _p, 0.000000011 * _p]);
    final omega = horner(t, [124.7746 * _p, -1.56375588 * _p / _ck,
        0.0020672 * _p, 0.00000215 * _p]);
    final aa = <double>[
      299.7 * _p + 0.107408 * _p * k - 0.009173 * t * t,
      251.88 * _p + 0.016321 * _p * k,
      251.83 * _p + 26.651886 * _p * k,
      349.42 * _p + 36.412478 * _p * k,
      84.66 * _p + 18.206239 * _p * k,
      141.74 * _p + 53.303771 * _p * k,
      207.17 * _p + 2.453732 * _p * k,
      154.84 * _p + 7.30686 * _p * k,
      34.52 * _p + 27.261239 * _p * k,
      207.19 * _p + 0.121824 * _p * k,
      291.34 * _p + 1.844379 * _p * k,
      161.72 * _p + 24.198154 * _p * k,
      239.56 * _p + 25.513099 * _p * k,
      331.55 * _p + 3.592518 * _p * k,
    ];
    return _Mp._(k, t, e, m, mp, f, omega, aa);
  }

  double _nfc(List<double> c) {
    return c[0] * math.sin(mp) +
        c[1] * math.sin(m) * e +
        c[2] * math.sin(2 * mp) +
        c[3] * math.sin(2 * f) +
        c[4] * math.sin(mp - m) * e +
        c[5] * math.sin(mp + m) * e +
        c[6] * math.sin(2 * m) * e * e +
        c[7] * math.sin(mp - 2 * f) +
        c[8] * math.sin(mp + 2 * f) +
        c[9] * math.sin(2 * mp + m) * e +
        c[10] * math.sin(3 * mp) +
        c[11] * math.sin(m + 2 * f) * e +
        c[12] * math.sin(m - 2 * f) * e +
        c[13] * math.sin(2 * mp - m) * e +
        c[14] * math.sin(omega) +
        c[15] * math.sin(mp + 2 * m) +
        c[16] * math.sin(2 * (mp - f)) +
        c[17] * math.sin(3 * m) +
        c[18] * math.sin(mp + m - 2 * f) +
        c[19] * math.sin(2 * (mp + f)) +
        c[20] * math.sin(mp + m + 2 * f) +
        c[21] * math.sin(mp - m + 2 * f) +
        c[22] * math.sin(mp - m - 2 * f) +
        c[23] * math.sin(3 * mp + m) +
        c[24] * math.sin(4 * mp);
  }

  double _flc() {
    return -0.62801 * math.sin(mp) +
        0.17172 * math.sin(m) * e +
        -0.01183 * math.sin(mp + m) * e +
        0.00862 * math.sin(2 * mp) +
        0.00804 * math.sin(2 * f) +
        0.00454 * math.sin(mp - m) * e +
        0.00204 * math.sin(2 * m) * e * e +
        -0.0018 * math.sin(mp - 2 * f) +
        -0.0007 * math.sin(mp + 2 * f) +
        -0.0004 * math.sin(3 * mp) +
        -0.00034 * math.sin(2 * mp - m) +
        0.00032 * math.sin(m + 2 * f) * e +
        0.00032 * math.sin(m - 2 * f) * e +
        -0.00028 * math.sin(mp + 2 * m) * e * e +
        0.00027 * math.sin(2 * mp + m) * e +
        -0.00017 * math.sin(omega) +
        -0.00005 * math.sin(mp - m - 2 * f) +
        0.00004 * math.sin(2 * mp + 2 * f) +
        -0.00004 * math.sin(mp + m + 2 * f) +
        0.00004 * math.sin(mp - 2 * m) +
        0.00003 * math.sin(mp + m - 2 * f) +
        0.00003 * math.sin(3 * m) +
        0.00002 * math.sin(2 * mp - 2 * f) +
        0.00002 * math.sin(mp - m + 2 * f) +
        -0.00002 * math.sin(3 * mp + m);
  }

  double _w() {
    return 0.00306 - 0.00038 * e * math.cos(m) + 0.00026 * math.cos(mp) -
        0.00002 * (math.cos(mp - m) - math.cos(mp + m) - math.cos(2 * f));
  }

  double _a() {
    const ac = [0.000325, 0.000165, 0.000164, 0.000126, 0.00011,
        0.000062, 0.00006, 0.000056, 0.000047, 0.000042,
        0.000040, 0.000037, 0.000035, 0.000023];
    var a = 0.0;
    for (var i = 0; i < ac.length; i++) {
      a += ac[i] * math.sin(aa[i]);
    }
    return a;
  }
}

const _nc = [
  -0.4072, 0.17241, 0.01608, 0.01039, 0.00739,
  -0.00514, 0.00208, -0.00111, -0.00057, 0.00056,
  -0.00042, 0.00042, 0.00038, -0.00024, -0.00017,
  -0.00007, 0.00004, 0.00004, 0.00003, 0.00003,
  -0.00003, 0.00003, -0.00002, -0.00002, 0.00002,
];

const _fc = [
  -0.40614, 0.17302, 0.01614, 0.01043, 0.00734,
  -0.00515, 0.00209, -0.00111, -0.00057, 0.00056,
  -0.00042, 0.00042, 0.00038, -0.00024, -0.00017,
  -0.00007, 0.00004, 0.00004, 0.00003, 0.00003,
  -0.00003, 0.00003, -0.00002, -0.00002, 0.00002,
];
