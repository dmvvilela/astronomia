# Astronomia Dart — Porting Progress

Port of Go [meeus](https://github.com/soniakeys/meeus) + JS [astronomia](https://github.com/commenthol/astronomia) to Dart.

## Status Legend
- ✅ Done (ported + tested)
- 🔧 In progress
- ⬜ Not started

## Phase 1 — Foundations
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| base            | meeus  | ✅     | math utils, coordinate types |
| sexagesimal     | astro  | ✅     | d°m′s″ representation |
| julian          | meeus  | ✅     | JD conversions, day-of-year, leap year |
| interpolation   | meeus  | ✅     | 3-point, 5-point interpolation, Lagrange |
| iterate         | meeus  | ✅     | decimalPlaces, fullPrecision, binaryRoot |
| fit             | meeus  | ✅     | linear, quadratic, func1, func3, correlation |

## Phase 2 — Time
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| deltat          | meeus  | ✅     | interp10A, polynomial approx for all eras |
| sidereal        | meeus  | ✅     | mean0UT, mean (apparent needs nutation) |
| eqtime          | meeus  | 🔧     | L0 polynomial only, needs nutation/solar/coord |

## Phase 3 — Coordinate Corrections
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| nutation        | meeus  | ✅     | IAU 1980 + Laskar, approx, table 22.A |
| precess         | meeus  | ✅     | equatorial + ecliptic precessors |
| coord           | meeus  | ✅     | ecl↔eq, eq↔hz, eq↔gal transforms |
| parallactic     | meeus  | ✅     | parallactic angle, ecliptic at horizon |
| refraction      | meeus  | ✅     | gt15, Bennett, Saemundsson |
| parallax        | meeus  | ✅     | horizontal, topocentric, topocentric2 |
| apparent        | meeus  | 🔧     | nutation/aberration corrections (Position needs solar) |

## Phase 4 — Sun
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| solar           | meeus  | ✅     | trueSun, apparentLongitude, equatorial coords |
| solarxyz        | meeus  | ✅     | rectangular coords (low-acc, VSOP87 pending) |
| solstice        | meeus  | ✅     | march/june/september/december |
| solardisk       | meeus  | 🔧     | Carrington cycle done, ephemeris needs VSOP87 |
| sunrise         | astro  | ✅     | sunrise/noon/sunset with midnight sun |

## Phase 5 — Moon
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| moonposition    | meeus  | ✅     | Moon ecliptic position, node, perigee, trueNode |
| moonphase       | meeus  | ✅     | mean + precise phases (new/first/full/last) |
| moonillum       | meeus  | ✅     | illuminated fraction, phase angle, limb |
| moonnode        | meeus  | ✅     | ascending/descending node passages |
| moonmaxdec      | meeus  | ✅     | north/south maximum declinations |
| moon            | meeus  | 🔧     | stub — needs VSOP87 |
| apsis           | meeus  | ✅     | perigee/apogee with parallax |

## Phase 6 — Planets & Orbits
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| kepler          | meeus  | ✅     | 6 solvers + true anomaly + radius |
| elliptic        | meeus  | 🔧     | velocity/length done, Position needs VSOP87 |
| parabolic       | meeus  | ✅     | anomalyDistance for parabolic orbits |
| nearparabolic   | meeus  | ✅     | anomalyDistance for near-parabolic orbits |
| planetelements  | meeus  | ✅     | mean elements for 8 planets (Table 31.A) |
| planetposition  | meeus  | 🔧     | stub — needs VSOP87 data files |
| planetary       | meeus  | ✅     | conjunctions, oppositions, elongations |
| pluto           | meeus  | ✅     | heliocentric coords (astrometric needs VSOP87) |

## Phase 7 — Planet Details
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| illum           | meeus  | ✅     | phase angle, fraction, magnitudes for all planets |
| mars            | meeus  | 🔧     | stub — needs VSOP87 |
| jupiter         | meeus  | ✅     | physical2 (approximate, no VSOP87) |
| jupitermoons    | meeus  | ✅     | approximate Galilean moon positions |
| saturnring      | meeus  | 🔧     | constants only — needs VSOP87 |
| saturnmoons     | meeus  | 🔧     | stub — needs VSOP87 |

## Phase 8 — Misc
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| globe           | meeus  | ✅     | Earth ellipsoid, geodetic coords, distance |
| rise            | meeus  | 🔧     | approxTimes done, Planet/ApproxPlanet need VSOP87 |
| angle           | meeus  | ✅     | sep, sepHav, relativePosition |
| conjunction     | meeus  | 🔧     | stub — needs VSOP87 |
| line            | meeus  | ✅     | collinearity deviation angle |
| circle          | meeus  | ✅     | smallest circle containing 3 bodies |
| eclipse         | meeus  | ✅     | solar & lunar eclipses |
| semidiameter    | meeus  | ✅     | standard values, asteroid diameter |
| stellar         | meeus  | ✅     | sum, ratio, absolute magnitude |
| binary          | meeus  | ✅     | mean anomaly, position, apparent eccentricity |
| sundial         | meeus  | ✅     | horizontal hour angles |
| easter          | meeus  | ✅     | Gregorian & Julian Easter |
| jm              | meeus  | 🔧     | stub — complex calendar logic |
| elementequinox  | meeus  | ✅     | B1950→J2000 reduction |
| perihelion      | meeus  | ✅     | perihelion & aphelion for all planets |
| node2           | meeus  | ✅     | elliptic & parabolic node passages |

## Summary
- **Total modules:** 57
- **Done:** 45
- **In progress:** 12 (mostly VSOP87-dependent)
- **Remaining:** 0
