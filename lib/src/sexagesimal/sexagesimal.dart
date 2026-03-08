/// Sexagesimal angle/time representation (degrees/hours, minutes, seconds).
library;

/// Represents an angle or time in sexagesimal form (d/h, m, s).
class Sexa {
  /// Sign: true if negative.
  final bool negative;

  /// Degrees or hours.
  final int d;

  /// Minutes.
  final int m;

  /// Seconds.
  final double s;

  const Sexa(this.negative, this.d, this.m, this.s);

  /// Creates a [Sexa] from a decimal degree/hour value.
  factory Sexa.fromDeg(double deg) {
    final neg = deg < 0;
    deg = deg.abs();
    final d = deg.truncate();
    final mf = (deg - d) * 60;
    final m = mf.truncate();
    final s = (mf - m) * 60;
    return Sexa(neg, d, m, s);
  }

  /// Converts to decimal degrees/hours.
  double toDeg() {
    final value = d + m / 60.0 + s / 3600.0;
    return negative ? -value : value;
  }

  @override
  String toString() {
    final sign = negative ? '-' : '';
    final sec = s.toStringAsFixed(2);
    return '$sign${d}°${m.toString().padLeft(2, '0')}′${sec.padLeft(5, '0')}″';
  }
}
