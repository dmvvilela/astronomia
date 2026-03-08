/// Globe: Chapter 11, The Earth's Globe.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// IAU 1976 Earth ellipsoid. Equatorial radius in km.
const double earthEr = 6378.14;

/// IAU 1976 flattening.
const double earthFl = 1 / 298.257;

/// Polar radius in km.
double polarRadius(double er, double fl) => er * (1 - fl);

/// Eccentricity of a meridian.
double eccentricity(double fl) => math.sqrt((2 - fl) * fl);

/// Parallax constants ρ sin φ′ and ρ cos φ′.
///
/// [phi] geographic latitude (radians), [h] height above ellipsoid (meters).
({double rhsSinPhiPrime, double rhoCosPrime}) parallaxConstants(
    double phi, double h, {double er = earthEr, double fl = earthFl}) {
  final boa = 1 - fl;
  final su = math.sin(math.atan(boa * math.tan(phi)));
  final cu = math.cos(math.atan(boa * math.tan(phi)));
  final sPhi = math.sin(phi), cPhi = math.cos(phi);
  final hoa = h * 1e-3 / er;
  return (
    rhsSinPhiPrime: su * boa + hoa * sPhi,
    rhoCosPrime: cu + hoa * cPhi,
  );
}

/// Distance from Earth center to point on ellipsoid at latitude [phi].
///
/// Result is fraction of equatorial radius.
double rho(double phi) {
  return 0.9983271 + 0.0016764 * math.cos(2 * phi) -
      0.0000035 * math.cos(4 * phi);
}

/// Radius of the parallel of latitude [phi] in km.
double radiusAtLatitude(double phi,
    {double er = earthEr, double fl = earthFl}) {
  final s = math.sin(phi), c = math.cos(phi);
  return er * c / math.sqrt(1 - (2 - fl) * fl * s * s);
}

/// Length of one degree of longitude at a given parallel radius [rp] (km).
double oneDegreeOfLongitude(double rp) => rp * math.pi / 180;

/// Rotational angular velocity (rad/s) at epoch 1996.5.
const double rotationRate19965 = 7.292114992e-5;

/// Radius of curvature of meridian at latitude [phi] in km.
double radiusOfCurvature(double phi,
    {double er = earthEr, double fl = earthFl}) {
  final s = math.sin(phi);
  final e2 = (2 - fl) * fl;
  return er * (1 - e2) / math.pow(1 - e2 * s * s, 1.5);
}

/// Length of one degree of latitude at a given meridian curvature radius [rm] (km).
double oneDegreeOfLatitude(double rm) => rm * math.pi / 180;

/// Geographic latitude minus geocentric latitude (radians).
double geocentricLatitudeDifference(double phi) {
  return secToRad(692.73 * math.sin(2 * phi) - 1.16 * math.sin(4 * phi));
}

/// Cosine of angular distance between two geographic points.
double approxAngularDistance(double lat1, double lon1, double lat2, double lon2) {
  return math.sin(lat1) * math.sin(lat2) +
      math.cos(lat1) * math.cos(lat2) * math.cos(lon1 - lon2);
}

/// Approximate linear distance on Earth surface in km.
double approxLinearDistance(double angularDist) => 6371 * angularDist;

/// Distance between two points on an ellipsoid in km.
double distance(double lat1, double lon1, double lat2, double lon2,
    {double er = earthEr, double fl = earthFl}) {
  final f2 = (lat1 + lat2) / 2;
  final g2 = (lat1 - lat2) / 2;
  final l2 = (lon1 - lon2) / 2;
  final sf = math.sin(f2), cf = math.cos(f2);
  final sg = math.sin(g2), cg = math.cos(g2);
  final sl = math.sin(l2), cl = math.cos(l2);
  final s2f = sf * sf, c2f = cf * cf;
  final s2g = sg * sg, c2g = cg * cg;
  final s2l = sl * sl, c2l = cl * cl;
  final s = s2g * c2l + c2f * s2l;
  final c = c2g * c2l + s2f * s2l;
  if (s == 0) return 0; // same point
  final omega = math.atan(math.sqrt(s / c));
  final r = math.sqrt(s * c) / omega;
  final d = 2 * omega * er;
  final h1 = (3 * r - 1) / (2 * c);
  final h2 = (3 * r + 1) / (2 * s);
  return d * (1 + fl * (h1 * s2f * c2g - h2 * c2f * s2g));
}
