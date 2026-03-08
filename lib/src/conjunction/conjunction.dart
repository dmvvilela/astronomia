/// Conjunction: Chapter 18, Planetary Conjunctions.
///
/// Uses Len5 interpolation to find conjunctions between moving objects.
/// All angles in radians, times in JDE.
library;

import '../base/coord.dart';
import '../interpolation/interpolation.dart';

/// Computes a conjunction between two moving objects (e.g. planets).
///
/// Conjunction is found with interpolation against length-5 ephemerides.
/// [t1], [t5] are times of first and last rows.
/// [cs1], [cs2] are 5-row ephemerides as [Equatorial] coordinates.
///
/// Returns time of conjunction [t] and the amount [deltaD] that object 2
/// was "above" object 1 at the time of conjunction (in declination, radians).
({double t, double deltaD}) planetary(
    double t1, double t5, List<Equatorial> cs1, List<Equatorial> cs2) {
  if (cs1.length != 5 || cs2.length != 5) {
    throw ArgumentError('Five rows required in ephemerides');
  }
  final dr = List<double>.generate(5, (i) => cs2[i].ra - cs1[i].ra);
  final dd = List<double>.generate(5, (i) => cs2[i].dec - cs1[i].dec);
  return _conj(t1, t5, dr, dd);
}

/// Computes a conjunction between a moving object and a fixed star.
///
/// [c1] is the fixed object, [cs2] is the 5-row ephemeris of the mover.
({double t, double deltaD}) stellar(
    double t1, double t5, Equatorial c1, List<Equatorial> cs2) {
  if (cs2.length != 5) {
    throw ArgumentError('Five rows required in ephemerides');
  }
  final dr = List<double>.generate(5, (i) => cs2[i].ra - c1.ra);
  final dd = List<double>.generate(5, (i) => cs2[i].dec - c1.dec);
  return _conj(t1, t5, dr, dd);
}

({double t, double deltaD}) _conj(
    double t1, double t5, List<double> dr, List<double> dd) {
  var l5 = Len5(t1, t5, dr);
  final t = l5.zero(strong: true);
  l5 = Len5(t1, t5, dd);
  final deltaD = l5.interpolateXStrict(t);
  return (t: t, deltaD: deltaD);
}
