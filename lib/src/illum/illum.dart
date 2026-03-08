/// Illum: Chapter 41, Illuminated Fraction of the Disk and Magnitude of a Planet.
///
/// All phase angles in radians. Distances in AU.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

const double _p = math.pi / 180;

/// Phase angle from distances.
///
/// [r] planet-Sun, [delta] planet-Earth, [rr] Sun-Earth. All in AU.
double phaseAngle(double r, double delta, double rr) {
  return math.acos((r * r + delta * delta - rr * rr) / (2 * r * delta));
}

/// Illuminated fraction from distances.
double fraction(double r, double delta, double rr) {
  final s = r + delta;
  return (s * s - rr * rr) / (4 * r * delta);
}

/// Phase angle from heliocentric ecliptic coordinates.
///
/// [lon], [lat] planet heliocentric ecliptic (radians), [r] planet-Sun distance,
/// [lon0] Earth heliocentric longitude, [r0] Earth-Sun, [delta] planet-Earth.
double phaseAngle2(double lon, double lat, double r,
    double lon0, double r0, double delta) {
  return math.acos((r - r0 * math.cos(lat) * math.cos(lon - lon0)) / delta);
}

/// Phase angle from heliocentric ecliptic + cartesian.
double phaseAngle3(double lon, double lat,
    double x, double y, double z, double delta) {
  final sL = math.sin(lon), cL = math.cos(lon);
  final sB = math.sin(lat), cB = math.cos(lat);
  return math.acos((x * cB * cL + y * cB * sL + z * sB) / delta);
}

/// Approximate illuminated fraction of Venus.
double fractionVenus(double jde) {
  final t = j2000Century(jde);
  final v = 261.51 * _p + 22518.443 * _p * t;
  final m = 177.53 * _p + 35999.05 * _p * t;
  final n = 50.42 * _p + 58517.811 * _p * t;
  final w = v + 1.91 * _p * math.sin(m) + 0.78 * _p * math.sin(n);
  final delta = math.sqrt(1.52321 + 1.44666 * math.cos(w));
  final s = 0.72333 + delta;
  return (s * s - 1) / 2.89332 / delta;
}

/// Visual magnitude of Mercury. [i] is phase angle in radians.
double magnitudeMercury(double r, double delta, double i) {
  final s = toDeg(i) - 50;
  return 1.16 + 5 * math.log(r * delta) / math.ln10 + (0.02838 + 0.0001023 * s) * s;
}

/// Visual magnitude of Venus. [i] is phase angle in radians.
double magnitudeVenus(double r, double delta, double i) {
  final id = toDeg(i);
  return -4 + 5 * math.log(r * delta) / math.ln10 + (0.01322 + 0.0000004247 * id * id) * id;
}

/// Visual magnitude of Mars. [i] is phase angle in radians.
double magnitudeMars(double r, double delta, double i) {
  return -1.3 + 5 * math.log(r * delta) / math.ln10 + 0.01486 * toDeg(i);
}

/// Visual magnitude of Jupiter.
double magnitudeJupiter(double r, double delta) {
  return -8.93 + 5 * math.log(r * delta) / math.ln10;
}

/// Visual magnitude of Saturn.
///
/// [b] Saturnicentric latitude of Earth (radians),
/// [deltaU] difference of Saturnicentric longitudes Sun-Earth (radians).
double magnitudeSaturn(double r, double delta, double b, double deltaU) {
  final s = math.sin(b).abs();
  return -8.68 + 5 * math.log(r * delta) / math.ln10 +
      0.044 * toDeg(deltaU).abs() - 2.6 * s + 1.25 * s * s;
}

/// Visual magnitude of Uranus.
double magnitudeUranus(double r, double delta) {
  return -6.85 + 5 * math.log(r * delta) / math.ln10;
}

/// Visual magnitude of Neptune.
double magnitudeNeptune(double r, double delta) {
  return -7.05 + 5 * math.log(r * delta) / math.ln10;
}

// --- 1984 Astronomical Almanac formulae ---

double magnitudeMercury84(double r, double delta, double i) {
  return horner(toDeg(i), [-0.42 + 5 * math.log(r * delta) / math.ln10, 0.038, -0.000273, 0.000002]);
}

double magnitudeVenus84(double r, double delta, double i) {
  return horner(toDeg(i), [-4.4 + 5 * math.log(r * delta) / math.ln10, 0.0009, -0.000239, 0.00000065]);
}

double magnitudeMars84(double r, double delta, double i) {
  return -1.52 + 5 * math.log(r * delta) / math.ln10 + 0.016 * toDeg(i);
}

double magnitudeJupiter84(double r, double delta, double i) {
  return -9.4 + 5 * math.log(r * delta) / math.ln10 + 0.005 * toDeg(i);
}

double magnitudeSaturn84(double r, double delta, double b, double deltaU) {
  final s = math.sin(b).abs();
  return -8.88 + 5 * math.log(r * delta) / math.ln10 +
      0.044 / toDeg(deltaU).abs() - 2.6 * s + 1.25 * s * s;
}

double magnitudeUranus84(double r, double delta) {
  return -7.19 + 5 * math.log(r * delta) / math.ln10;
}

double magnitudeNeptune84(double r, double delta) {
  return -6.87 + 5 * math.log(r * delta) / math.ln10;
}

double magnitudePluto84(double r, double delta) {
  return -1 + 5 * math.log(r * delta) / math.ln10;
}
