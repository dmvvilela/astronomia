# Astronomia

Astronomical algorithms in Dart, ported from Jean Meeus's
*Astronomical Algorithms* (2nd Ed.) via the Go
[meeus](https://github.com/soniakeys/meeus) library and the JS
[astronomia](https://github.com/commenthol/astronomia) library.

## Features

**45 modules** covering positional astronomy, celestial mechanics, and calendar computations:

| Category | Modules |
|----------|---------|
| **Time & Calendar** | Julian Day, Delta T, sidereal time, Easter (Gregorian & Julian) |
| **Coordinates** | Ecliptic/equatorial/horizontal/galactic transforms, precession, nutation, parallax, refraction, aberration |
| **Sun** | Solar position, solstices & equinoxes, sunrise/sunset, equation of time |
| **Moon** | Lunar position, phases (new/first/full/last), illumination, nodes, apsis (perigee/apogee), max declination |
| **Planets** | Kepler's equation (6 solvers), orbital elements, conjunctions, oppositions, elongations, Pluto heliocentric coords |
| **Orbits** | Elliptic, parabolic, and near-parabolic motion, velocity, orbit length |
| **Planet Details** | Illumination & magnitudes, Jupiter physical ephemeris, Galilean moon positions |
| **Geodesy** | Earth ellipsoid, geodetic distance, parallax constants |
| **Stellar** | Magnitude arithmetic, binary star orbits, angular separation |
| **Misc** | Eclipse prediction, semidiameters, sundials, smallest circle, collinearity |

## Getting started

```yaml
dependencies:
  astronomia: ^0.1.0
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
import 'package:astronomia/src/globe/globe.dart' as globe;
import 'package:astronomia/src/angle/angle.dart' as angle;

void main() {
  final jd = calendarGregorianToJD(2000, 1, 1.5);

  // Solar ecliptic longitude
  final sunLon = solar.apparentLongitude(jd);

  // Moon position
  final pos = moon.position(jd);
  print('Moon: lon=${toDeg(pos.lon)}°, lat=${toDeg(pos.lat)}°');

  // Next new moon
  final newMoonJDE = phase.newMoon(2025.5);

  // Earth surface distance (km)
  final km = globe.distance(lat1, lon1, lat2, lon2);

  // Angular separation between two stars
  final d = angle.sep(ra1, dec1, ra2, dec2);
}
```

## Conventions

- All angles are in **radians** (`double`). Use `toRad()` / `toDeg()` to convert.
- Time is represented as **Julian Day numbers** (`double`).
- Multi-value returns use Dart **records**: `({double lon, double lat, double delta})`.
- The J2000.0 epoch constant is `j2000 = 2451545.0`.

## Status

This is a `0.1.0` release. 45 of 57 modules are fully ported. The remaining 12
are stubs awaiting VSOP87 planetary theory data (needed for high-precision
planetary positions, Saturn rings, and a few dependent calculations).

All ported modules are tested against examples from Meeus's book.

## References

- Meeus, Jean. *Astronomical Algorithms*. 2nd ed. Richmond: Willmann-Bell, 1998.
- [soniakeys/meeus](https://github.com/soniakeys/meeus) (Go)
- [commenthol/astronomia](https://github.com/commenthol/astronomia) (JS)

## License

MIT
