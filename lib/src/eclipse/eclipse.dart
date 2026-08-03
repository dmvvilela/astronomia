/// Eclipse: Chapter 54, Eclipses.
library;

import 'dart:math' as math;

import '../angle/angle.dart' as angle;
import '../base/math.dart';
import '../coord/coord.dart' as coord;
import '../deltat/deltat.dart' as deltat;
import '../globe/globe.dart' as globe;
import '../julian/julian.dart';
import '../moonphase/moonphase.dart' as moonphase;
import '../moonposition/moonposition.dart' as moonposition;
import '../nutation/nutation.dart' as nutation;
import '../parallax/parallax.dart' as parallax;
import '../planetposition/planetposition.dart';
import '../semidiameter/semidiameter.dart' as semidiameter;
import '../sidereal/sidereal.dart' as sidereal;
import '../solar/solar.dart' as solarposition;

const int none = 0;
const int partial = 1;
const int annular = 2;
const int annularTotal = 3;
const int penumbral = 4;
const int umbral = 5;
const int total = 6;

final Planet _earth = Planet(planetEarth);

double _snap(double y, double q) {
  final k = (y - 2000) * 12.3685;
  return (k - q + 0.5).floorToDouble() + q;
}

({bool eclipse, double jmax, double gamma, double u, double mPrime}) _g(
  double k,
  double jm,
  double c1,
  double c2,
) {
  const ck = 1 / 1236.85;
  const p = math.pi / 180;
  final t = k * ck;
  final f = horner(t, [
    160.7108 * p,
    390.67050284 * p / ck,
    -0.0016118 * p,
    -0.00000227 * p,
    0.000000011 * p,
  ]);
  if (math.sin(f).abs() > 0.36) {
    return (eclipse: false, jmax: 0, gamma: 0, u: 0, mPrime: 0);
  }
  final e = horner(t, [1.0, -0.002516, -0.0000074]);
  final m = horner(t, [
    2.5534 * p,
    29.1053567 * p / ck,
    -0.0000014 * p,
    -0.00000011 * p,
  ]);
  final mPrime = horner(t, [
    201.5643 * p,
    385.81693528 * p / ck,
    0.0107582 * p,
    0.00001238 * p,
    -0.000000058 * p,
  ]);
  final omega = horner(t, [
    124.7746 * p,
    -1.56375588 * p / ck,
    0.0020672 * p,
    0.00000215 * p,
  ]);
  final sOmega = math.sin(omega);
  final f1 = f - 0.02665 * p * sOmega;
  final a1 = horner(t, [299.77 * p, 0.107408 * p / ck, -0.009173 * p]);

  final jmax =
      jm +
      c1 * math.sin(mPrime) +
      c2 * math.sin(m) * e +
      0.0161 * math.sin(2 * mPrime) +
      -0.0097 * math.sin(2 * f1) +
      0.0073 * math.sin(mPrime - m) * e +
      -0.005 * math.sin(mPrime + m) * e +
      -0.0023 * math.sin(mPrime - 2 * f1) +
      0.0021 * math.sin(2 * m) * e +
      0.0012 * math.sin(mPrime + 2 * f1) +
      0.0006 * math.sin(2 * mPrime + m) * e +
      -0.0004 * math.sin(3 * mPrime) +
      -0.0003 * math.sin(m + 2 * f1) * e +
      0.0003 * math.sin(a1) +
      -0.0002 * math.sin(m - 2 * f1) * e +
      -0.0002 * math.sin(2 * mPrime - m) * e +
      -0.0002 * sOmega;

  final pp =
      0.207 * math.sin(m) * e +
      0.0024 * math.sin(2 * m) * e +
      -0.0392 * math.sin(mPrime) +
      0.0116 * math.sin(2 * mPrime) +
      -0.0073 * math.sin(mPrime + m) * e +
      0.0067 * math.sin(mPrime - m) * e +
      0.0118 * math.sin(2 * f1);

  final q =
      5.2207 +
      -0.0048 * math.cos(m) * e +
      0.002 * math.cos(2 * m) * e +
      -0.3299 * math.cos(mPrime) +
      -0.006 * math.cos(mPrime + m) * e +
      0.0041 * math.cos(mPrime - m) * e;

  final sF1 = math.sin(f1), cF1 = math.cos(f1);
  final w = cF1.abs();
  final gamma = (pp * cF1 + q * sF1) * (1 - 0.0048 * w);
  final u =
      0.0059 +
      0.0046 * math.cos(m) * e +
      -0.0182 * math.cos(mPrime) +
      0.0004 * math.cos(2 * mPrime) +
      -0.0005 * math.cos(m + mPrime);

  return (eclipse: true, jmax: jmax, gamma: gamma, u: u, mPrime: mPrime);
}

/// Solar eclipse nearest decimal [year].
///
/// Returns eclipse type (none/partial/annular/annularTotal/total),
/// whether central, jmax, gamma, u, penumbral cone radius, and magnitude.
({
  int type,
  bool central,
  double jmax,
  double gamma,
  double u,
  double p,
  double mag,
})
solar(double year) {
  final r = _g(_snap(year, 0), moonphase.meanNew(year), -0.4075, 0.1721);
  final penumbra = r.u + 0.5461;
  if (!r.eclipse) {
    return (type: none, central: false, jmax: 0, gamma: 0, u: 0, p: 0, mag: 0);
  }
  final aGamma = r.gamma.abs();
  if (aGamma > 1.5433 + r.u) {
    return (
      type: none,
      central: false,
      jmax: r.jmax,
      gamma: r.gamma,
      u: r.u,
      p: penumbra,
      mag: 0,
    );
  }
  final central = aGamma < 0.9972;
  int eclType;
  double mag = 0;
  if (!central) {
    eclType = partial;
    if (aGamma < 1.026 && aGamma < 0.9972 + r.u.abs()) {
      eclType = total;
    }
  } else if (r.u < 0) {
    eclType = total;
  } else if (r.u > 0.0047) {
    eclType = annular;
  } else {
    final omega = 0.00464 * math.sqrt(1 - r.gamma * r.gamma);
    eclType = r.u < omega ? annularTotal : annular;
  }
  if (eclType == partial) {
    mag = (1.5433 + r.u - aGamma) / (0.5461 + 2 * r.u);
  }
  return (
    type: eclType,
    central: central,
    jmax: r.jmax,
    gamma: r.gamma,
    u: r.u,
    p: penumbra,
    mag: mag,
  );
}

/// Local circumstances for a solar eclipse near global maximum [jmax].
///
/// [jmax] is the Julian Ephemeris Day returned by [solar]. [lat] and [lon]
/// are the observer's geodetic latitude and longitude in radians, with
/// longitude positive west. [height] is metres above the reference ellipsoid.
///
/// The calculation samples the topocentric separation of the apparent Sun
/// and Moon over the global eclipse window, then refines the closest visible
/// approach. It determines whether any part of the solar disc is eclipsed
/// while above the geometric horizon. It does not calculate contact times or
/// account for the lunar limb profile or atmospheric refraction.
///
/// [deltaT] is TD - UT in seconds. When omitted, the package's polynomial or
/// tabular approximation is used.
({
  bool visible,
  int type,
  double? localMaximum,
  double magnitude,
  double obscuration,
  double? sunAltitude,
})
localSolar(
  double jmax,
  double lat,
  double lon, {
  double height = 0,
  double? deltaT,
}) {
  final dt = deltaT ?? _estimatedDeltaT(jmax);
  final observer = globe.parallaxConstants(lat, height);

  // The complete partial phase of even the longest solar eclipses fits well
  // inside this window. Two-minute samples avoid missing a short grazing
  // eclipse; the best interval is refined below.
  const halfWindow = 4 / 24;
  const step = 2 / 1440;
  _LocalSolarSample? best;

  for (
    var jde = jmax - halfWindow;
    jde <= jmax + halfWindow + step / 2;
    jde += step
  ) {
    final sample = _localSolarSample(jde, lat, lon, observer, dt);
    if (!sample.aboveHorizon) continue;
    if (best == null || sample.separation < best.separation) best = sample;
  }

  if (best == null) return _noLocalSolar;
  var resolved = best;

  // Refine the two-minute bracket around the best sampled instant.
  var lo = resolved.jde - step;
  var hi = resolved.jde + step;
  for (var i = 0; i < 32; i++) {
    final m1 = lo + (hi - lo) / 3;
    final m2 = hi - (hi - lo) / 3;
    final s1 = _localSolarSample(m1, lat, lon, observer, dt);
    final s2 = _localSolarSample(m2, lat, lon, observer, dt);
    final v1 = s1.aboveHorizon ? s1.separation : double.infinity;
    final v2 = s2.aboveHorizon ? s2.separation : double.infinity;
    if (v1 <= v2) {
      hi = m2;
      if (v1 < resolved.separation) resolved = s1;
    } else {
      lo = m1;
      if (v2 < resolved.separation) resolved = s2;
    }
  }

  final sum = resolved.sunRadius + resolved.moonRadius;
  if (resolved.separation >= sum) return _noLocalSolar;

  final difference = (resolved.sunRadius - resolved.moonRadius).abs();
  final int localType;
  final double magnitude;
  if (resolved.separation <= difference) {
    localType = resolved.moonRadius >= resolved.sunRadius ? total : annular;
    magnitude = resolved.moonRadius / resolved.sunRadius;
  } else {
    localType = partial;
    magnitude = (sum - resolved.separation) / (2 * resolved.sunRadius);
  }

  return (
    visible: true,
    type: localType,
    localMaximum: resolved.jde,
    magnitude: magnitude,
    obscuration: _discObscuration(
      resolved.sunRadius,
      resolved.moonRadius,
      resolved.separation,
    ),
    sunAltitude: resolved.sunAltitude,
  );
}

const _noLocalSolar = (
  visible: false,
  type: none,
  localMaximum: null,
  magnitude: 0.0,
  obscuration: 0.0,
  sunAltitude: null,
);

class _LocalSolarSample {
  final double jde;
  final double separation;
  final double sunRadius;
  final double moonRadius;
  final double sunAltitude;

  const _LocalSolarSample({
    required this.jde,
    required this.separation,
    required this.sunRadius,
    required this.moonRadius,
    required this.sunAltitude,
  });

  bool get aboveHorizon => sunAltitude + sunRadius > 0;
}

_LocalSolarSample _localSolarSample(
  double jde,
  double lat,
  double lon,
  ({double rhsSinPhiPrime, double rhoCosPrime}) observer,
  double deltaT,
) {
  final n = nutation.nutation(jde);
  final eps = nutation.meanObliquity(jde) + n.dEps;
  final sinEps = math.sin(eps);
  final cosEps = math.cos(eps);

  final sunEcliptic = solarposition.apparentVSOP87(_earth, jde);
  final sunEq = coord.eclToEq(sunEcliptic.lon, sunEcliptic.lat, sinEps, cosEps);

  final moonEcliptic = moonposition.position(jde);
  final moonEq = coord.eclToEq(
    moonEcliptic.lon + n.dPsi,
    moonEcliptic.lat,
    sinEps,
    cosEps,
  );

  final jdUt = jde - deltaT / 86400;
  final theta = sidereal.apparent(jdUt) * 2 * math.pi / 86400;
  final sunHourAngle = theta - lon - sunEq.ra;
  final moonHourAngle = theta - lon - moonEq.ra;

  final sunTopo = parallax.topocentric(
    sunEq.ra,
    sunEq.dec,
    sunEcliptic.range,
    observer.rhsSinPhiPrime,
    observer.rhoCosPrime,
    sunHourAngle,
    math.sin(parallax.horizontal(sunEcliptic.range)),
  );
  final moonTopo = parallax.topocentric(
    moonEq.ra,
    moonEq.dec,
    moonEcliptic.delta / au,
    observer.rhsSinPhiPrime,
    observer.rhoCosPrime,
    moonHourAngle,
    math.sin(moonposition.parallax(moonEcliptic.delta)),
  );

  final horizontal = coord.eqToHz(sunTopo.ra, sunTopo.dec, lat, lon, theta);

  return _LocalSolarSample(
    jde: jde,
    separation: angle.sepHav(
      sunTopo.ra,
      sunTopo.dec,
      moonTopo.ra,
      moonTopo.dec,
    ),
    sunRadius: semidiameter.semidiameter(semidiameter.sunSd, sunEcliptic.range),
    moonRadius: semidiameter.semidiameter(
      semidiameter.moonSd,
      moonEcliptic.delta,
    ),
    sunAltitude: horizontal.alt,
  );
}

double _discObscuration(double sunRadius, double moonRadius, double distance) {
  if (distance >= sunRadius + moonRadius) return 0;
  if (distance <= (sunRadius - moonRadius).abs()) {
    if (moonRadius >= sunRadius) return 1;
    return moonRadius * moonRadius / (sunRadius * sunRadius);
  }

  final sunAngle = math.acos(
    (distance * distance + sunRadius * sunRadius - moonRadius * moonRadius) /
        (2 * distance * sunRadius),
  );
  final moonAngle = math.acos(
    (distance * distance + moonRadius * moonRadius - sunRadius * sunRadius) /
        (2 * distance * moonRadius),
  );
  final lens =
      sunRadius * sunRadius * sunAngle +
      moonRadius * moonRadius * moonAngle -
      0.5 *
          math.sqrt(
            (-distance + sunRadius + moonRadius) *
                (distance + sunRadius - moonRadius) *
                (distance - sunRadius + moonRadius) *
                (distance + sunRadius + moonRadius),
          );
  return lens / (math.pi * sunRadius * sunRadius);
}

double _estimatedDeltaT(double jde) {
  final year = jdeToJulianYear(jde);
  if (year >= 1620 && year <= 2010) return deltat.interp10A(jde);
  if (year >= 2000) return deltat.polyAfter2000(year);
  if (year >= 948) return deltat.poly948to1600(year);
  return deltat.polyBefore948(year);
}

/// Lunar eclipse nearest decimal [year].
///
/// Returns eclipse type, jmax, gamma, rho, sigma, magnitude, and semidurations
/// (total, partial, penumbral) in days.
({
  int type,
  double jmax,
  double gamma,
  double rho,
  double sigma,
  double mag,
  double sdTotal,
  double sdPartial,
  double sdPenumbral,
})
lunar(double year) {
  final r = _g(_snap(year, 0.5), moonphase.meanFull(year), -0.4065, 0.1727);
  if (!r.eclipse) {
    return (
      type: none,
      jmax: 0,
      gamma: 0,
      rho: 0,
      sigma: 0,
      mag: 0,
      sdTotal: 0,
      sdPartial: 0,
      sdPenumbral: 0,
    );
  }
  final rho = 1.2848 + r.u;
  final sigma = 0.7403 - r.u;
  final aGamma = r.gamma.abs();
  var mag = (1.0128 - r.u - aGamma) / 0.545;
  int eclType;
  if (mag > 1) {
    eclType = total;
  } else if (mag > 0) {
    eclType = umbral;
  } else {
    mag = (1.5573 + r.u - aGamma) / 0.545;
    if (mag < 0) {
      return (
        type: none,
        jmax: r.jmax,
        gamma: r.gamma,
        rho: rho,
        sigma: sigma,
        mag: 0,
        sdTotal: 0,
        sdPartial: 0,
        sdPenumbral: 0,
      );
    }
    eclType = penumbral;
  }

  final p = 1.0128 - r.u;
  final t = 0.4678 - r.u;
  final n = 0.5458 + 0.04 * math.cos(r.mPrime);
  final g2 = r.gamma * r.gamma;
  final sdTotal = eclType == total ? math.sqrt(t * t - g2) / n / 24 : 0.0;
  final sdPartial = (eclType == total || eclType == umbral)
      ? math.sqrt(p * p - g2) / n / 24
      : 0.0;
  final h = 1.5573 + r.u;
  final sdPenumbral = math.sqrt(h * h - g2) / n / 24;

  return (
    type: eclType,
    jmax: r.jmax,
    gamma: r.gamma,
    rho: rho,
    sigma: sigma,
    mag: mag,
    sdTotal: sdTotal,
    sdPartial: sdPartial,
    sdPenumbral: sdPenumbral,
  );
}
