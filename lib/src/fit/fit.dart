/// Curve Fitting: Chapter 4, Curve Fitting.
///
/// Provides least-squares curve fitting for linear, quadratic,
/// and custom function combinations.
library;

import 'dart:math' as math;

/// A data point for curve fitting.
typedef DataPoint = ({double x, double y});

/// Fits a line y = ax + b to sample data.
///
/// Returns (a, b) coefficients of the best fit line.
({double a, double b}) linear(List<DataPoint> p) {
  var sx = 0.0, sy = 0.0, sx2 = 0.0, sxy = 0.0;
  for (final pt in p) {
    sx += pt.x;
    sy += pt.y;
    sx2 += pt.x * pt.x;
    sxy += pt.x * pt.y;
  }
  final n = p.length.toDouble();
  final d = n * sx2 - sx * sx;
  return (
    a: (n * sxy - sx * sy) / d,
    b: (sy * sx2 - sx * sxy) / d,
  );
}

/// Returns the correlation coefficient for sample data.
double correlationCoefficient(List<DataPoint> p) {
  var sx = 0.0, sy = 0.0, sx2 = 0.0, sy2 = 0.0, sxy = 0.0;
  for (final pt in p) {
    sx += pt.x;
    sy += pt.y;
    sx2 += pt.x * pt.x;
    sy2 += pt.y * pt.y;
    sxy += pt.x * pt.y;
  }
  final n = p.length.toDouble();
  return (n * sxy - sx * sy) /
      (math.sqrt(n * sx2 - sx * sx) * math.sqrt(n * sy2 - sy * sy));
}

/// Fits y = ax^2 + bx + c to sample data.
///
/// Returns (a, b, c) coefficients of the best fit quadratic.
({double a, double b, double c}) quadratic(List<DataPoint> p) {
  var pSum = 0.0, q = 0.0, r = 0.0, s = 0.0;
  var t = 0.0, u = 0.0, v = 0.0;
  for (final pt in p) {
    final x = pt.x;
    final y = pt.y;
    final x2 = x * x;
    pSum += x;
    q += x2;
    r += x * x2;
    s += x2 * x2;
    t += y;
    u += x * y;
    v += x2 * y;
  }
  final n = p.length.toDouble();
  final d = n * q * s + 2 * pSum * q * r -
      q * q * q - pSum * pSum * s - n * r * r;
  return (
    a: (n * q * v + pSum * r * t + pSum * q * u -
            q * q * t - pSum * pSum * v - n * r * u) / d,
    b: (n * s * u + pSum * q * v + q * r * t -
            q * q * u - pSum * s * t - n * r * v) / d,
    c: (q * s * t + q * r * u + pSum * r * v -
            q * q * v - pSum * s * u - r * r * t) / d,
  );
}

/// Fits y = a*f0(x) + b*f1(x) + c*f2(x) to sample data.
({double a, double b, double c}) func3(
  List<DataPoint> p,
  double Function(double) f0,
  double Function(double) f1,
  double Function(double) f2,
) {
  var m = 0.0, pp = 0.0, q = 0.0, r = 0.0, s = 0.0;
  var t = 0.0, u = 0.0, v = 0.0, w = 0.0;
  for (final pt in p) {
    final y0 = f0(pt.x);
    final y1 = f1(pt.x);
    final y2 = f2(pt.x);
    m += y0 * y0;
    pp += y0 * y1;
    q += y0 * y2;
    r += y1 * y1;
    s += y1 * y2;
    t += y2 * y2;
    u += pt.y * y0;
    v += pt.y * y1;
    w += pt.y * y2;
  }
  final d = m * r * t + 2 * pp * q * s - m * s * s - r * q * q - t * pp * pp;
  return (
    a: (u * (r * t - s * s) + v * (q * s - pp * t) + w * (pp * s - q * r)) / d,
    b: (u * (s * q - pp * t) + v * (m * t - q * q) + w * (pp * q - m * s)) / d,
    c: (u * (pp * s - r * q) + v * (pp * q - m * s) + w * (m * r - pp * pp)) / d,
  );
}

/// Fits y = a*f(x) to sample data.
double func1(List<DataPoint> p, double Function(double) f) {
  var syf = 0.0, sf2 = 0.0;
  for (final pt in p) {
    final fv = f(pt.x);
    syf += pt.y * fv;
    sf2 += fv * fv;
  }
  return syf / sf2;
}
