# Astronomia

Astronomical algorithms in Dart, ported from Jean Meeus's
*Astronomical Algorithms* (2nd Ed.) via the Go
[meeus](https://github.com/soniakeys/meeus) library and the JS
[astronomia](https://github.com/commenthol/astronomia) library.

## Features

**56 modules** covering positional astronomy, celestial mechanics, and calendar computations:

| Category | Modules |
|----------|---------|
| **Time & Calendar** | Julian Day, Delta T, sidereal time, equation of time, Easter |
| **Coordinates** | Ecliptic/equatorial/horizontal/galactic transforms, precession, nutation, parallax, refraction, aberration |
| **Sun** | Solar position (low-acc + VSOP87), solstices & equinoxes, sunrise/sunset, solar disk ephemeris |
| **Moon** | Lunar position, phases, illumination, nodes, apsis, max declination, **moonrise/moonset**, physical libration, selenographic coords |
| **Planets** | VSOP87 heliocentric positions (all 8 planets), geocentric positions with light-time correction, Kepler solvers, orbital elements, **conjunctions**, oppositions, elongations, Pluto |
| **Orbits** | Elliptic, parabolic, and near-parabolic motion, velocity, orbit length |
| **Planet Details** | Illumination & magnitudes, Jupiter physical ephemeris, Galilean moons, **Saturn ring geometry**, **Saturn moons**, **Mars physical ephemeris** |
| **Rise/Set** | Meeus ch. 15 refined algorithm with 3-day interpolation for any body |
| **Geodesy** | Earth ellipsoid, geodetic distance, parallax constants |
| **Stellar** | Magnitude arithmetic, binary star orbits, angular separation |
| **Misc** | Eclipse prediction, semidiameters, sundials, smallest circle, collinearity |

## Getting started

```yaml
dependencies:
  astronomia: ^0.3.0
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
import 'package:astronomia/solar.dart' as solar;
import 'package:astronomia/moonposition.dart' as moon;
import 'package:astronomia/moonphase.dart' as phase;
import 'package:astronomia/rise.dart' as rise;
import 'package:astronomia/globe.dart' as globe;

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
import 'package:astronomia/rise.dart' as rise;
import 'package:astronomia/moonposition.dart' as moon;
import 'package:astronomia/sidereal.dart' as sid;
import 'package:astronomia/coord.dart' as coord;
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
import 'package:astronomia/planetposition.dart';
import 'package:astronomia/elliptic.dart' as elliptic;
import 'package:astronomia/astronomia.dart';

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

All 56 modules fully implemented (1 stub: Jewish/Moslem calendars). 216 tests passing, validated against examples from Meeus's book.

## References

- Meeus, Jean. *Astronomical Algorithms*. 2nd ed. Richmond: Willmann-Bell, 1998.
- [soniakeys/meeus](https://github.com/soniakeys/meeus) (Go)
- [commenthol/astronomia](https://github.com/commenthol/astronomia) (JS)

## License

MIT
