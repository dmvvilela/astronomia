/// Semidiameter: Chapter 55, Semidiameters of the Sun, Moon, and Planets.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Standard semidiameters at distance 1 AU, in arcseconds.
const double sunSd = 959.63;
const double mercurySd = 3.36;
const double venusSurfaceSd = 8.34;
const double venusCloudSd = 8.41;
const double marsSd = 4.68;
const double jupiterEqSd = 98.44;
const double jupiterPolSd = 92.06;
const double saturnEqSd = 82.73;
const double saturnPolSd = 73.82;
const double uranusSd = 35.02;
const double neptuneSd = 33.50;
const double plutoSd = 2.07;
const double moonSd = 358473400; // constant k for Moon, not a standard s0

/// Semidiameter at distance [delta] given standard semidiameter [s0] (arcsec).
/// Result in radians.
double semidiameter(double s0, double delta) {
  return secToRad(s0 / delta);
}

/// Asteroid diameter in km from absolute magnitude [h] and albedo [a].
double asteroidDiameter(double h, double a) {
  return math.pow(10, 3.12 - 0.2 * h - 0.5 * math.log(a) / math.ln10).toDouble();
}

/// Asteroid apparent semidiameter in radians from diameter [d] (km)
/// and distance [delta] (AU).
double asteroidSemidiameter(double d, double delta) {
  return secToRad(0.0013788 * d / delta);
}
