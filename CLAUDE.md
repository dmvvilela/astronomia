# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
dart test                          # Run all 216 tests
dart test test/mars_test.dart      # Run a single test file
dart analyze                       # Lint (uses package:lints/recommended.yaml)
dart pub publish --dry-run         # Check publish readiness
```

No build step needed — pure Dart library with zero runtime dependencies.

## Architecture

Port of Jean Meeus's *Astronomical Algorithms* (2nd Ed.) from Go [meeus](https://github.com/soniakeys/meeus) and JS [astronomia](https://github.com/commenthol/astronomia). 56 implemented modules, 1 stub (`jm` — Jewish/Moslem calendars).

### Module layout

Every module lives in `lib/src/<name>/<name>.dart` with a one-line re-export at `lib/<name>.dart`. The barrel file `lib/astronomia.dart` exports only non-conflicting foundational modules (julian, nutation, coord, etc.). Specialized modules (solar, moonposition, planetposition, etc.) must be imported directly with `as` prefixes because many share names like `position`, `radius`, `eccentricity`:

```dart
import 'package:astronomia/astronomia.dart';       // foundations
import 'package:astronomia/solar.dart' as solar;    // specialized
import 'package:astronomia/rise.dart' as rise;
```

### Internal imports

Modules import each other via **relative paths** (`import '../julian/julian.dart'`), never via `package:astronomia/...`.

### Key conventions

- All angles are **radians** (`double`). Convert with `toRad()`/`toDeg()` from `base/math.dart`.
- Time is **Julian Day numbers** (`double`). Constants: `j2000 = 2451545.0`, `julianCentury = 36525`.
- Multi-value returns use Dart **records**: `({double lon, double lat, double range})`.
- `math.pow()` returns `num` in Dart — always append `.toDouble()`.

### VSOP87 planetary data

Eight `vsop87B*.dart` files in `lib/src/planetposition/` (~1.6MB total) contain `const List<List<double>>` triplets `[amplitude, phase, frequency]`. They are tree-shakeable — unused planets get stripped by the Dart compiler. The `Planet` class evaluates these via Horner's method with `a × cos(b + c×τ)`.

### Dependency chain for complex modules

- `moon.dart` → needs `solar.apparentVSOP87()` → needs `planetposition` (Earth)
- `saturnmoons.dart` → needs `solar.trueVSOP87()`, `planetposition` (Earth + Saturn), `precess`
- `mars.dart` → needs `planetposition` (Earth + Mars), `illum`, `nutation`, `coord`
- `rise.dart` → needs `sidereal.apparent0UT()`, `moonposition`, `coord`

### Tests

Tests live in `test/<module>_test.dart` and validate against worked examples from Meeus's book. When adding a new module, include at least one Meeus example with known expected values and use `closeTo()` for floating-point comparisons.
