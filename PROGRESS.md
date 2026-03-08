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
| kepler          | meeus  | ⬜     | Kepler's equation |
| elliptic        | meeus  | ⬜     | elliptic motion |
| parabolic       | meeus  | ⬜     | parabolic motion |
| nearparabolic   | meeus  | ⬜     | near-parabolic motion |
| planetelements  | meeus  | ⬜     | mean orbital elements |
| planetposition  | meeus  | ⬜     | VSOP87 positions |
| planetary       | meeus  | ⬜     | planetary phenomena |
| pluto           | meeus  | ⬜     | Pluto position |

## Phase 7 — Planet Details
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| illum           | meeus  | ⬜     | illuminated fraction & magnitude |
| mars            | meeus  | ⬜     | Mars physical observations |
| jupiter         | meeus  | ⬜     | Jupiter physical observations |
| jupitermoons    | meeus  | ⬜     | Galilean satellites |
| saturnring      | meeus  | ⬜     | Saturn ring appearance |
| saturnmoons     | meeus  | ⬜     | Saturn satellites |

## Phase 8 — Misc
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| globe           | meeus  | ⬜     | Earth ellipsoid, geodetic coords |
| rise            | meeus  | ⬜     | rise, transit, set times |
| angle           | meeus  | ⬜     | angular separation |
| conjunction     | meeus  | ⬜     | planetary conjunctions |
| line            | meeus  | ⬜     | three bodies in a line |
| circle          | meeus  | ⬜     | smallest circle containing 3 bodies |
| eclipse         | meeus  | ⬜     | solar & lunar eclipses |
| semidiameter    | meeus  | ⬜     | angular diameters |
| stellar         | meeus  | ⬜     | stellar magnitudes |
| binary          | meeus  | ⬜     | binary stars |
| sundial         | meeus  | ⬜     | planar sundial |
| easter          | meeus  | ⬜     | date of Easter |
| jm              | meeus  | ⬜     | Jewish & Muslim calendars |
| elementequinox  | meeus  | ⬜     | ecliptical element reduction |
| perihelion      | meeus  | ⬜     | perihelion & aphelion |
| node            | meeus  | ⬜     | passages through nodes |

## Summary
- **Total modules:** 57
- **Done:** 24
- **In progress:** 4
- **Remaining:** 29
