/// Interpolation: Chapter 3, Interpolation.
///
/// Provides second difference (Len3) and fourth difference (Len5)
/// interpolation for equidistant tables, plus Lagrange interpolation
/// for unequally-spaced data.
library;

import '../base/math.dart';

/// Second difference interpolation from a table of 3 equidistant values.
class Len3 {
  final double x1;
  final double x3;
  final List<double> y;
  final double _c;
  final double _abSum, _xSum, _xDiff;

  Len3._(this.x1, this.x3, this.y, this._c, this._abSum,
      this._xSum, this._xDiff);

  /// Creates a [Len3] from first and last x values and 3 y values.
  ///
  /// X values must be equally spaced. [x1] must not equal [x3].
  /// [y] must have exactly 3 elements.
  factory Len3(double x1, double x3, List<double> y) {
    if (y.length != 3) {
      throw ArgumentError('y must have length 3');
    }
    if (x3 == x1) {
      throw ArgumentError('x3 cannot equal x1');
    }
    final a = y[1] - y[0];
    final b = y[2] - y[1];
    final c = b - a;
    return Len3._(x1, x3, List.of(y), c, a + b, x3 + x1, x3 - x1);
  }

  /// Special constructor that selects the best 3 rows from a larger table
  /// for interpolating at [x].
  factory Len3.forInterpolateX(
      double x, double x1, double xn, List<double> y) {
    if (y.length > 3) {
      final interval = (xn - x1) / (y.length - 1);
      if (interval == 0) {
        throw ArgumentError('x range cannot be zero');
      }
      var nearestX = ((x - x1) / interval + 0.5).toInt();
      if (nearestX < 1) nearestX = 1;
      if (nearestX > y.length - 2) nearestX = y.length - 2;
      y = y.sublist(nearestX - 1, nearestX + 2);
      xn = x1 + (nearestX + 1) * interval;
      x1 = x1 + (nearestX - 1) * interval;
    }
    return Len3(x1, xn, y);
  }

  /// Interpolates for a given x value.
  double interpolateX(double x) {
    final n = (2 * x - _xSum) / _xDiff;
    return interpolateN(n);
  }

  /// Interpolates for x, restricting x to [x1, x3].
  double interpolateXStrict(double x) {
    final n = (2 * x - _xSum) / _xDiff;
    if (n < -1 || n > 1) {
      throw RangeError('x outside of range x1 to x3');
    }
    return interpolateN(n);
  }

  /// Interpolates for a given interpolating factor [n].
  ///
  /// Formula (3.3). The factor n is x-x2 in units of the tabular interval.
  double interpolateN(double n) {
    return y[1] + n * 0.5 * (_abSum + n * _c);
  }

  /// Interpolates for [n], restricting n to [-1, 1].
  double interpolateNStrict(double n) {
    if (n < -1 || n > 1) {
      throw RangeError('n must be in range -1 to 1');
    }
    return interpolateN(n);
  }

  /// Returns the (x, y) at the extremum within the table range.
  ({double x, double y}) extremum() {
    if (_c == 0) {
      throw StateError('No extremum in table');
    }
    final n = _abSum / (-2 * _c);
    if (n < -1 || n > 1) {
      throw StateError('Extremum falls outside of table');
    }
    return (
      x: 0.5 * (_xSum + _xDiff * n),
      y: y[1] - (_abSum * _abSum) / (8 * _c),
    );
  }

  /// Finds x where y=0 within the table range.
  ///
  /// [strong] selects a more robust but expensive estimation strategy.
  double zero({bool strong = false}) {
    double Function(double) f;
    if (strong) {
      f = (n0) =>
          n0 -
          (2 * y[1] + n0 * (_abSum + _c * n0)) / (_abSum + 2 * _c * n0);
    } else {
      f = (n0) => -2 * y[1] / (_abSum + _c * n0);
    }
    final n0 = _iterate(0, f);
    if (n0 > 1 || n0 < -1) {
      throw StateError('Zero falls outside of table');
    }
    return 0.5 * (_xSum + _xDiff * n0);
  }
}

/// Fourth difference interpolation from a table of 5 equidistant values.
class Len5 {
  final double x1;
  final double x5;
  final List<double> y;
  final double _b, _c;
  final double _f;
  final double _h, _j, _k;
  final double _y3;
  final double _xSum, _xDiff;
  final List<double> _interpCoeff;

  Len5._(
      this.x1,
      this.x5,
      this.y,
      this._b,
      this._c,
      this._f,
      this._h,
      this._j,
      this._k,
      this._y3,
      this._xSum,
      this._xDiff,
      this._interpCoeff);

  /// Creates a [Len5] from first and last x values and 5 y values.
  factory Len5(double x1, double x5, List<double> y) {
    if (y.length != 5) {
      throw ArgumentError('y must have length 5');
    }
    if (x5 == x1) {
      throw ArgumentError('x5 cannot equal x1');
    }
    final a = y[1] - y[0];
    final b = y[2] - y[1];
    final c = y[3] - y[2];
    final d = y[4] - y[3];
    final e = b - a;
    final f = c - b;
    final g = d - c;
    final h = f - e;
    final j = g - f;
    final k = j - h;
    final xSum = x5 + x1;
    final xDiff = x5 - x1;
    final interpCoeff = [
      y[2],
      (b + c) / 2 - (h + j) / 12,
      f / 2 - k / 24,
      (h + j) / 12,
      k / 24,
    ];
    return Len5._(
        x1, x5, List.of(y), b, c, f, h, j, k, y[2],
        xSum, xDiff, interpCoeff);
  }

  /// Interpolates for a given x value.
  double interpolateX(double x) {
    final n = (4 * x - 2 * _xSum) / _xDiff;
    return interpolateN(n);
  }

  /// Interpolates for x, restricting x to [x1, x5].
  double interpolateXStrict(double x) {
    final n = (4 * x - 2 * _xSum) / _xDiff;
    if (n < -1 || n > 1) {
      throw RangeError('x outside of range x1 to x5');
    }
    return interpolateN(n);
  }

  /// Interpolates for a given interpolating factor [n].
  double interpolateN(double n) {
    return horner(n, _interpCoeff);
  }

  /// Interpolates for [n], restricting n to [-1, 1].
  double interpolateNStrict(double n) {
    if (n < -1 || n > 1) {
      throw RangeError('n must be in range -1 to 1');
    }
    return horner(n, _interpCoeff);
  }

  /// Returns the (x, y) at the extremum within the table range.
  ({double x, double y}) extremum() {
    final nCoeff = [
      6 * (_b + _c) - _h - _j,
      0.0,
      3 * (_h + _k),
      2 * _k,
    ];
    final den = _k - 12 * _f;
    if (den == 0) {
      throw StateError('Extremum falls outside of table');
    }
    final n0 = _iterate(0, (n0) => horner(n0, nCoeff) / den);
    if (n0 < -2 || n0 > 2) {
      throw StateError('Extremum falls outside of table');
    }
    return (
      x: 0.5 * _xSum + 0.25 * _xDiff * n0,
      y: horner(n0, _interpCoeff),
    );
  }

  /// Finds x where y=0 within the table range.
  double zero({bool strong = false}) {
    double Function(double) f;
    if (strong) {
      final m = _k / 24;
      final nn = (_h + _j) / 12;
      final p = _f / 2 - m;
      final q = (_b + _c) / 2 - nn;
      final numCoeff = [_y3, q, p, nn, m];
      final denCoeff = [q, 2 * p, 3 * nn, 4 * m];
      f = (n0) => n0 - horner(n0, numCoeff) / horner(n0, denCoeff);
    } else {
      final numCoeff = [
        -24 * _y3,
        0.0,
        _k - 12 * _f,
        -2 * (_h + _j),
        -_k,
      ];
      final den = 12 * (_b + _c) - 2 * (_h + _j);
      f = (n0) => horner(n0, numCoeff) / den;
    }
    final n0 = _iterate(0, f);
    if (n0 > 2 || n0 < -2) {
      throw StateError('Zero falls outside of table');
    }
    return 0.5 * _xSum + 0.25 * _xDiff * n0;
  }
}

/// Interpolates a center value from a table of four rows.
double len4Half(List<double> y) {
  if (y.length != 4) {
    throw ArgumentError('y must have length 4');
  }
  return (9 * (y[1] + y[2]) - y[0] - y[3]) / 16;
}

/// Lagrange interpolation for unequally-spaced data.
///
/// Given a table of (x, y) pairs, interpolates y for the given [x].
double lagrange(double x, List<({double x, double y})> table) {
  var sum = 0.0;
  for (var i = 0; i < table.length; i++) {
    final xi = table[i].x;
    var prod = 1.0;
    for (var j = 0; j < table.length; j++) {
      if (i != j) {
        final xj = table[j].x;
        prod *= (x - xj) / (xi - xj);
      }
    }
    sum += table[i].y * prod;
  }
  return sum;
}

/// Returns interpolating polynomial coefficients using Lagrange's formula.
///
/// The returned list can be evaluated with [horner].
List<double> lagrangePoly(List<({double x, double y})> table) {
  final n = table.length;
  final sum = List<double>.filled(n, 0);
  final prod = List<double>.filled(n, 0);
  final last = n - 1;
  for (var i = 0; i < n; i++) {
    final xi = table[i].x;
    final yi = table[i].y;
    prod[last] = 1;
    var den = 1.0;
    var idx = last;
    for (var j = 0; j < n; j++) {
      if (i != j) {
        final xj = table[j].x;
        prod[idx - 1] = prod[idx] * -xj;
        for (var k = idx; k < last; k++) {
          prod[k] -= prod[k + 1] * xj;
        }
        idx--;
        den *= (xi - xj);
      }
    }
    for (var j = 0; j < n; j++) {
      sum[j] += yi * prod[j] / den;
    }
  }
  return sum;
}

/// Internal iteration helper for zero/extremum finding.
double _iterate(double n0, double Function(double) f) {
  for (var i = 0; i < 50; i++) {
    final n1 = f(n0);
    if (n1.isInfinite || n1.isNaN) {
      throw StateError('Failure to converge');
    }
    if (n0 != 0 && (n1 - n0).abs() / n0.abs() < 1e-15) {
      return n1;
    }
    if (n0 == 0 && n1.abs() < 1e-15) {
      return n1;
    }
    n0 = n1;
  }
  throw StateError('Failure to converge');
}
