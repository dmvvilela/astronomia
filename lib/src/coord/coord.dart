/// Coord: Chapter 13, Transformation of Coordinates.
///
/// All angles in radians. Functions use plain doubles for coordinates.
library;

import 'dart:math' as math;

import '../base/math.dart';

/// Converts equatorial (α, δ) to ecliptic (λ, β) coordinates.
///
/// [ra] is right ascension, [dec] is declination (radians).
/// [sEps], [cEps] are sine/cosine of obliquity.
({double lon, double lat}) eqToEcl(
    double ra, double dec, double sEps, double cEps) {
  final sRa = math.sin(ra);
  final cRa = math.cos(ra);
  final sDec = math.sin(dec);
  final cDec = math.cos(dec);
  return (
    lon: math.atan2(sRa * cEps + (sDec / cDec) * sEps, cRa),
    lat: math.asin(sDec * cEps - cDec * sEps * sRa),
  );
}

/// Converts ecliptic (λ, β) to equatorial (α, δ) coordinates.
///
/// [lon] is ecliptic longitude, [lat] is ecliptic latitude (radians).
/// [sEps], [cEps] are sine/cosine of obliquity.
({double ra, double dec}) eclToEq(
    double lon, double lat, double sEps, double cEps) {
  final sLon = math.sin(lon);
  final cLon = math.cos(lon);
  final sLat = math.sin(lat);
  final cLat = math.cos(lat);
  return (
    ra: mod2pi(math.atan2(sLon * cEps - (sLat / cLat) * sEps, cLon)),
    dec: math.asin(sLat * cEps + cLat * sEps * sLon),
  );
}

/// Converts equatorial to horizontal coordinates.
///
/// [ra] right ascension, [dec] declination (radians).
/// [phi] observer latitude, [psi] observer longitude (radians).
/// [st] sidereal time at Greenwich in radians.
///
/// Returns azimuth (westward from south) and altitude.
({double az, double alt}) eqToHz(
    double ra, double dec, double phi, double psi, double st) {
  final h = st - psi - ra;
  final sH = math.sin(h);
  final cH = math.cos(h);
  final sPhi = math.sin(phi);
  final cPhi = math.cos(phi);
  final sDec = math.sin(dec);
  final cDec = math.cos(dec);
  return (
    az: math.atan2(sH, cH * sPhi - (sDec / cDec) * cPhi),
    alt: math.asin(sPhi * sDec + cPhi * cDec * cH),
  );
}

/// Converts horizontal to equatorial coordinates.
///
/// [az] azimuth, [alt] altitude (radians).
/// [phi] observer latitude, [psi] observer longitude (radians).
/// [st] sidereal time at Greenwich in radians.
({double ra, double dec}) hzToEq(
    double az, double alt, double phi, double psi, double st) {
  final sA = math.sin(az);
  final cA = math.cos(az);
  final sAlt = math.sin(alt);
  final cAlt = math.cos(alt);
  final sPhi = math.sin(phi);
  final cPhi = math.cos(phi);
  final h = math.atan2(sA, cA * sPhi + sAlt / cAlt * cPhi);
  return (
    ra: mod2pi(st - psi - h),
    dec: math.asin(sPhi * sAlt - cPhi * cAlt * cA),
  );
}

/// Galactic North Pole coordinates (B1950.0 equinox).
const _galNorthRA = 192.25 * math.pi / 180; // 12h 49m
const _galNorthDec = 27.4 * math.pi / 180;
const _galLon0 = 33.0 * math.pi / 180;

/// Converts equatorial (B1950.0) to galactic coordinates.
({double lon, double lat}) eqToGal(double ra, double dec) {
  final sdRa = math.sin(_galNorthRA - ra);
  final cdRa = math.cos(_galNorthRA - ra);
  final sgDec = math.sin(_galNorthDec);
  final cgDec = math.cos(_galNorthDec);
  final sDec = math.sin(dec);
  final cDec = math.cos(dec);
  final x = math.atan2(sdRa, cdRa * sgDec - (sDec / cDec) * cgDec);
  return (
    lon: mod2pi(_galLon0 + 1.5 * math.pi - x),
    lat: math.asin(sDec * sgDec + cDec * cgDec * cdRa),
  );
}

/// Converts galactic to equatorial (B1950.0) coordinates.
({double ra, double dec}) galToEq(double lon, double lat) {
  final sdLon = math.sin(lon - _galLon0 - math.pi / 2);
  final cdLon = math.cos(lon - _galLon0 - math.pi / 2);
  final sgDec = math.sin(_galNorthDec);
  final cgDec = math.cos(_galNorthDec);
  final sLat = math.sin(lat);
  final cLat = math.cos(lat);
  final y = math.atan2(sdLon, cdLon * sgDec - (sLat / cLat) * cgDec);
  return (
    ra: mod2pi(y + _galNorthRA - math.pi),
    dec: math.asin(sLat * sgDec + cLat * cgDec * cdLon),
  );
}
