## 0.3.3

- Fix moon phase corrections to match Meeus Ch. 49 exactly: `A1 = 299.77°`, `A7 = 207.14°`, and the missing `E` factor on the quarter-phase `−0.00034 sin(2M′−M)` term.
- Fix Sun mean anomaly T² coefficient in moon physical ephemeris (`−0.0001535`, was `−0.0001536`).
- Tighten moon module tests to book-precision Meeus worked examples (47.a–53.a); 220 tests passing.

## 0.3.2

- Rename VSOP87 data files to `lower_case_with_underscores` (fixes 8 `file_names` lint issues).
- Remove unused imports and variables across test files.
- Fix unnecessary brace in string interpolation in `sexagesimal.dart`.
- Zero `dart analyze` issues.

## 0.3.1

- Add `lib/<module>.dart` public re-export files for all modules (fixes `implementation_imports` lint).
- Add missing `lib/base.dart` re-export, remove empty `node` directory.

## 0.3.0

- **All 56 modules complete** — no more stubs.
- **Mars physical ephemeris** — planetocentric declinations, areographic meridian, position angles, illuminated fraction (Ch. 42).
- **Moon physical libration** — optical + physical librations, selenographic Sun coordinates, sunrise/sunset on lunar surface, 52-feature catalog (Ch. 53).
- **Saturn moons** — positions of all 8 major moons (Mimas through Iapetus) in Saturn radii (Ch. 46).
- **Planetary conjunctions** — Len5 interpolation for planetary and stellar conjunctions (Ch. 18).
- **Solar VSOP87** — added `trueVSOP87()` and `apparentVSOP87()` high-accuracy functions.
- **Public re-export files** — every module now has a `lib/<module>.dart` re-export. Import as `package:astronomia/solar.dart` instead of reaching into `src/`. No more `implementation_imports` lint.
- 216 tests passing.

## 0.2.0

- **VSOP87 planetary positions** — full heliocentric coordinates for all 8 planets via `planetposition` module.
- **Rise/transit/set** — Meeus ch. 15 refined algorithm with 3-day interpolation. Includes `moonTimes()` with lunar parallax correction.
- **Geocentric planet positions** — `elliptic.position()` with light-time correction, aberration, FK5, nutation.
- **Equation of time** — high-accuracy `e()` and simplified `eSmart()`.
- **Solar disk ephemeris** — P, B0, L0 for physical observations of the Sun.
- **Saturn ring geometry** — B, B', ΔU, P, and ring axes.
- **Ecliptic aberration** — `apparent.eclipticAberration()` for ecliptic coordinates.
- **Apparent sidereal time** — `sidereal.apparent0UT()` with nutation correction.
- Cleaned up barrel file — non-conflicting foundational exports only, specialized modules imported directly.
- Fixed all lint warnings. 202 tests passing.

## 0.1.0

- Initial release with 45 fully ported modules from Meeus's "Astronomical Algorithms".
- Sun: position, solstices, sunrise/sunset, equation of time.
- Moon: position, phases, illumination, nodes, apsis, max declination.
- Planets: Kepler solvers, orbital elements, conjunctions, oppositions, Pluto.
- Coordinates: ecliptic/equatorial/horizontal/galactic, precession, nutation, parallax, refraction.
- Misc: eclipses, Easter, magnitudes, binary stars, geodesy, angular separation, sundials.
- 12 modules stubbed pending VSOP87 planetary theory data.
