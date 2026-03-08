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

/// Cosine threshold for small angles near the pole.
const double cosSmallAngle = 9.999999999999998e-1; // cos(0.000005°)

/// Converts arcseconds to radians.
double secToRad(double sec) => sec * math.pi / (180 * 3600);

/// Converts arcminutes to radians.
double minToRad(double min) => min * math.pi / (180 * 60);

/// Converts sexagesimal (sign, degrees, minutes, seconds) to decimal degrees.
double fromSexaSec(int d, int m, double s) => d + m / 60.0 + s / 3600.0;

/// Normalizes an angle in radians to the range [0, 2π).
double mod2pi(double x) => pMod(x, 2 * math.pi);

/// Gaussian gravitational constant.
const double k = 0.01720209895;

/// One astronomical unit in km.
const double au = 149597870;

/// Sine of obliquity at J2000.
const double sOblJ2000 = 0.397777156;

/// Cosine of obliquity at J2000.
const double cOblJ2000 = 0.917482062;

/// Time for light to travel distance [delta] (in AU). Result in days.
double lightTime(double delta) => 0.0057755183 * delta;
