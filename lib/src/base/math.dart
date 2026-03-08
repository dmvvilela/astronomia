import 'dart:math' as math;

/// Degrees to radians conversion factor.
const double deg2rad = math.pi / 180.0;

/// Radians to degrees conversion factor.
const double rad2deg = 180.0 / math.pi;

/// Converts degrees to radians.
double toRad(double deg) => deg * deg2rad;

/// Converts radians to degrees.
double toDeg(double rad) => rad * rad2deg;

/// Polynomial evaluation using Horner's method.
///
/// Evaluates a polynomial with the given [coefficients] at point [x].
/// Coefficients are ordered from constant term to highest degree.
double horner(double x, List<double> coefficients) {
  var result = coefficients.last;
  for (var i = coefficients.length - 2; i >= 0; i--) {
    result = result * x + coefficients[i];
  }
  return result;
}

/// Normalizes an angle in radians to the range [0, 2π).
double pMod(double x, double y) {
  final result = x % y;
  return result < 0 ? result + y : result;
}

/// Floor modulus — always returns a non-negative result.
int floorMod(int a, int b) {
  final result = a % b;
  return result < 0 ? result + b : result;
}
