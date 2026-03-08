/// Astronomical algorithms in Dart.
///
/// A port of Jean Meeus's "Astronomical Algorithms" with extras
/// from astronomia.js.
///
/// This barrel file exports commonly used, non-conflicting modules.
/// For specialized modules (solar, moon, planets, etc.), import them
/// directly with a prefix:
///
/// ```dart
/// import 'package:astronomia/solar.dart' as solar;
/// import 'package:astronomia/moonposition.dart' as moonpos;
/// import 'package:astronomia/kepler.dart' as kepler;
/// ```
library;

// Foundations
export 'src/base/base.dart';
export 'src/base/math.dart';
export 'src/base/coord.dart';
export 'src/sexagesimal/sexagesimal.dart';
export 'src/julian/julian.dart';
export 'src/interpolation/interpolation.dart';
export 'src/iterate/iterate.dart';
export 'src/fit/fit.dart';

// Time
export 'src/deltat/deltat.dart';
export 'src/sidereal/sidereal.dart';

// Coordinate corrections
export 'src/nutation/nutation.dart';
export 'src/precess/precess.dart';
export 'src/coord/coord.dart';
export 'src/parallactic/parallactic.dart';
export 'src/refraction/refraction.dart';
export 'src/parallax/parallax.dart';

// Calendar
export 'src/easter/easter.dart';
export 'src/solstice/solstice.dart';
