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
| interpolation   | meeus  | ⬜     | 3-point, 5-point interpolation (meeus: interp) |
| iterate         | meeus  | ⬜     | iterative equation solving |
| fit             | meeus  | ⬜     | curve fitting |

## Phase 2 — Time
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| deltat          | meeus  | ⬜     | Delta T (TT - UT) |
| sidereal        | meeus  | ⬜     | Greenwich sidereal time |
| eqtime          | meeus  | ⬜     | equation of time |

## Phase 3 — Coordinate Corrections
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| nutation        | meeus  | ⬜     | nutation, obliquity of ecliptic |
| precess         | meeus  | ⬜     | precession between epochs |
| coord           | meeus  | ⬜     | coordinate transforms |
| parallactic     | meeus  | ⬜     | parallactic angle |
| refraction      | meeus  | ⬜     | atmospheric refraction |
| parallax        | meeus  | ⬜     | parallax correction |
| apparent        | meeus  | ⬜     | apparent place of a star |

## Phase 4 — Sun
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| solar           | meeus  | ⬜     | solar coordinates |
| solarxyz        | meeus  | ⬜     | rectangular coords of Sun |
| solstice        | meeus  | ⬜     | equinoxes & solstices |
| solardisk       | meeus  | ⬜     | physical observations of Sun |
| sunrise         | astro  | ⬜     | sunrise/noon/sunset convenience |

## Phase 5 — Moon
| Module          | Source | Status | Notes |
|-----------------|--------|--------|-------|
| moonposition    | meeus  | ⬜     | Moon ecliptic position |
| moonphase       | meeus  | ⬜     | phases of the Moon |
| moonillum       | meeus  | ⬜     | illuminated fraction |
| moonnode        | meeus  | ⬜     | passages through nodes |
| moonmaxdec      | meeus  | ⬜     | maximum declinations |
| moon            | meeus  | ⬜     | physical observations |
| apsis           | meeus  | ⬜     | perigee & apogee |

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
- **Done:** 3
- **In progress:** 0
- **Remaining:** 54
