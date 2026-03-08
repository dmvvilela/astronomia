/// Stellar: Chapter 56, Stellar Magnitudes.
library;

import 'dart:math' as math;

/// Combined apparent magnitude of two stars.
double sum(double m1, double m2) {
  final x = 0.4 * (m2 - m1);
  return m2 - 2.5 * math.log(math.pow(10, x).toDouble() + 1) / math.ln10;
}

/// Combined apparent magnitude of multiple stars.
double sumN(List<double> magnitudes) {
  var s = 0.0;
  for (final mi in magnitudes) {
    s += math.pow(10, -0.4 * mi).toDouble();
  }
  return -2.5 * math.log(s) / math.ln10;
}

/// Brightness ratio of two stars.
double ratio(double m1, double m2) => math.pow(10, 0.4 * (m2 - m1)).toDouble();

/// Magnitude difference from brightness ratio.
double difference(double ratio) => 2.5 * math.log(ratio) / math.ln10;

/// Absolute magnitude from apparent magnitude and annual parallax (radians).
double absoluteByParallax(double m, double parallax) {
  return m + 5 + 5 * math.log(1 / parallax) / math.ln10;
}

/// Absolute magnitude from apparent magnitude and distance in parsecs.
double absoluteByDistance(double m, double d) {
  return m + 5 - 5 * math.log(d) / math.ln10;
}
