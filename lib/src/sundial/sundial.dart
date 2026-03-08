/// Sundial: Chapter 58, Calculation of a Planar Sundial.
///
/// Stub — provides horizontal sundial hour line angles.
library;

import 'dart:math' as math;

/// Hour line angles for a horizontal sundial at latitude [phi] (radians).
///
/// Returns a map from hour offset (-6..6) to angle in radians from the noon line.
Map<int, double> horizontalHourAngles(double phi) {
  final sPhi = math.sin(phi);
  final result = <int, double>{};
  for (var h = -6; h <= 6; h++) {
    if (h == 0) {
      result[h] = 0;
    } else {
      final ha = h * 15 * math.pi / 180; // hour angle in radians
      result[h] = math.atan(sPhi * math.tan(ha));
    }
  }
  return result;
}
