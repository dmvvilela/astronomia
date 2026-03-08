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
