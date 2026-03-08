# Astronomia

Astronomical algorithms in Dart, ported from Jean Meeus's
*Astronomical Algorithms* (2nd Ed.) via the Go
[meeus](https://github.com/soniakeys/meeus) library and the JS
[astronomia](https://github.com/commenthol/astronomia) library.

## Features

**53 modules** covering positional astronomy, celestial mechanics, and calendar computations:

| Category | Modules |
|----------|---------|
| **Time & Calendar** | Julian Day, Delta T, sidereal time, equation of time, Easter |
| **Coordinates** | Ecliptic/equatorial/horizontal/galactic transforms, precession, nutation, parallax, refraction, aberration |
| **Sun** | Solar position (low-acc + VSOP87), solstices & equinoxes, sunrise/sunset, solar disk ephemeris |
| **Moon** | Lunar position, phases, illumination, nodes, apsis, max declination, **moonrise/moonset** |
| **Planets** | VSOP87 heliocentric positions (all 8 planets), geocentric positions with light-time correction, Kepler solvers, orbital elements, conjunctions, oppositions, elongations, Pluto |
| **Orbits** | Elliptic, parabolic, and near-parabolic motion, velocity, orbit length |
| **Planet Details** | Illumination & magnitudes, Jupiter physical ephemeris, Galilean moons, **Saturn ring geometry** |
| **Rise/Set** | Meeus ch. 15 refined algorithm with 3-day interpolation for any body |
| **Geodesy** | Earth ellipsoid, geodetic distance, parallax constants |
| **Stellar** | Magnitude arithmetic, binary star orbits, angular separation |
| **Misc** | Eclipse prediction, semidiameters, sundials, smallest circle, collinearity |

## Getting started

```yaml
dependencies:
  astronomia: ^0.2.0
```

```dart
import 'package:astronomia/astronomia.dart';
```

## Usage

The barrel import gives you foundations (julian, coordinates, nutation, etc.):

```dart
import 'package:astronomia/astronomia.dart';

void main() {
  // Julian Day for J2000.0
  final jd = calendarGregorianToJD(2000, 1, 1.5);
  print('J2000.0 = JD $jd'); // 2451545.0

  // Date of Easter 2025
  final e = gregorian(2025);
  print('Easter 2025: April ${e.day}'); // April 20
}
```

For specialized modules, import them directly — many share common names
like `position`, `radius`, `eccentricity`, so prefixed imports keep things clear:

```dart
import 'package:astronomia/astronomia.dart';
import 'package:astronomia/src/solar/solar.dart' as solar;
import 'package:astronomia/src/moonposition/moonposition.dart' as moon;
import 'package:astronomia/src/moonphase/moonphase.dart' as phase;
import 'package:astronomia/src/rise/rise.dart' as rise;
import 'package:astronomia/src/globe/globe.dart' as globe;

void main() {
  final jd = calendarGregorianToJD(2000, 1, 1.5);

  // Solar ecliptic longitude
  final sunLon = solar.apparentLongitude(j2000Century(jd));

  // Moon position
  final pos = moon.position(jd);
  print('Moon: lon=${toDeg(pos.lon)}°, lat=${toDeg(pos.lat)}°');

  // Next new moon
  final newMoonJDE = phase.newMoon(2025.5);

  // Earth surface distance (km)
  final km = globe.distance(lat1, lon1, lat2, lon2);
}
```

### Moonrise / Moonset

```dart
import 'package:astronomia/astronomia.dart';
import 'package:astronomia/src/rise/rise.dart' as rise;
import 'package:astronomia/src/moonposition/moonposition.dart' as moon;
import 'package:astronomia/src/sidereal/sidereal.dart' as sid;
import 'package:astronomia/src/coord/coord.dart' as coord;
import 'dart:math' as math;

void main() {
  // London, 2025 March 8 at midnight UT
  final jd = calendarGregorianToJD(2025, 3, 8.0);
  final lat = toRad(51.5);
  final lon = toRad(0.0); // Greenwich, positive west
  final th0 = sid.apparent0UT(jd);

  final result = rise.moonTimes(jd, lat, lon, 69, th0, (jde) {
    final pos = moon.position(jde);
    final eps = toRad(23.44);
    final eq = coord.eclToEq(pos.lon, pos.lat, math.sin(eps), math.cos(eps));
    return (ra: eq.ra, dec: eq.dec, parallax: moon.parallax(pos.delta));
  });

  if (result != null) {
    print('Moonrise:  ${(result.rise / 3600).toStringAsFixed(1)}h UT');
    print('Transit:   ${(result.transit / 3600).toStringAsFixed(1)}h UT');
    print('Moonset:   ${(result.set / 3600).toStringAsFixed(1)}h UT');
  }
}
```

### Planet positions

```dart
import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:astronomia/src/elliptic/elliptic.dart' as elliptic;
import 'package:astronomia/src/base/math.dart';

void main() {
  final earth = Planet(planetEarth);
  final mars = Planet(planetMars);
  final jde = 2451545.0; // J2000

  // Heliocentric ecliptic (VSOP87)
  final pos = mars.position2000(jde);
  print('Mars: L=${toDeg(pos.lon)}°, R=${pos.range} AU');

  // Geocentric equatorial (observed)
  final eq = elliptic.position(mars, earth, jde);
  print('Mars: RA=${toDeg(eq.ra)}°, Dec=${toDeg(eq.dec)}°');
}
```

## Conventions

- All angles are in **radians** (`double`). Use `toRad()` / `toDeg()` to convert.
- Time is represented as **Julian Day numbers** (`double`).
- Multi-value returns use Dart **records**: `({double lon, double lat, double delta})`.
- The J2000.0 epoch constant is `j2000 = 2451545.0`.

## Status

53 of 57 modules are implemented. The remaining 4 are stubs for complex
computations (Mars physical ephemeris, Moon physical libration, Saturn moons,
planetary conjunctions).

202 tests passing, validated against examples from Meeus's book.

## References

- Meeus, Jean. *Astronomical Algorithms*. 2nd ed. Richmond: Willmann-Bell, 1998.
- [soniakeys/meeus](https://github.com/soniakeys/meeus) (Go)
- [commenthol/astronomia](https://github.com/commenthol/astronomia) (JS)

## License

MIT
