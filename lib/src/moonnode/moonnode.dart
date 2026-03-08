/// Moonnode: Chapter 51, Passages of the Moon through the Nodes.
library;

import 'dart:math' as math;

import '../base/math.dart';

const double _p = math.pi / 180;
const double _ck = 1 / 1342.23;

/// JDE of the Moon's ascending node passage nearest the given decimal [year].
double ascending(double year) => _node(year, 0);

/// JDE of the Moon's descending node passage nearest the given decimal [year].
double descending(double year) => _node(year, 0.5);

double _node(double y, double h) {
  var k = (y - 2000.05) * 13.4223;
  k = (k - h + 0.5).floorToDouble() + h;
  final t = k * _ck;

  final d = horner(t, [183.638 * _p, 331.73735682 * _p / _ck,
      0.0014852 * _p, 0.00000209 * _p, -0.00000001 * _p]);
  final m = horner(t, [17.4006 * _p, 26.8203725 * _p / _ck,
      0.0001186 * _p, 0.00000006 * _p]);
  final mp = horner(t, [38.3776 * _p, 355.52747313 * _p / _ck,
      0.0123499 * _p, 0.000014627 * _p, -0.000000069 * _p]);
  final omega = horner(t, [123.9767 * _p, -1.44098956 * _p / _ck,
      0.0020608 * _p, 0.00000214 * _p, -0.000000016 * _p]);
  final v = horner(t, [299.75 * _p, 132.85 * _p, -0.009173 * _p]);
  final pp = omega + 272.75 * _p - 2.3 * _p * t;
  final e = horner(t, [1.0, -0.002516, -0.0000074]);

  return horner(t, [2451565.1619, 27.212220817 / _ck,
      0.0002762, 0.000000021, -0.000000000088]) +
      -0.4721 * math.sin(mp) +
      -0.1649 * math.sin(2 * d) +
      -0.0868 * math.sin(2 * d - mp) +
      0.0084 * math.sin(2 * d + mp) +
      -0.0083 * math.sin(2 * d - m) * e +
      -0.0039 * math.sin(2 * d - m - mp) * e +
      0.0034 * math.sin(2 * mp) +
      -0.0031 * math.sin(2 * (d - mp)) +
      0.003 * math.sin(2 * d + m) * e +
      0.0028 * math.sin(m - mp) * e +
      0.0026 * math.sin(m) * e +
      0.0025 * math.sin(4 * d) +
      0.0024 * math.sin(d) +
      0.0022 * math.sin(m + mp) * e +
      0.0017 * math.sin(omega) +
      0.0014 * math.sin(4 * d - mp) +
      0.0005 * math.sin(2 * d + m - mp) * e +
      0.0004 * math.sin(2 * d - m + mp) * e +
      -0.0003 * math.sin(2 * (d - m)) * e +
      0.0003 * math.sin(4 * d - m) * e +
      0.0003 * math.sin(v) +
      0.0003 * math.sin(pp);
}
