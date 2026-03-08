/// Julian day conversions.
///
/// Chapter 7 of Meeus, "Astronomical Algorithms".
library;

/// Julian date of the J2000.0 epoch (2000 January 1.5 TT).
const double j2000 = 2451545.0;

/// Julian days per Julian century.
const double julianCentury = 36525.0;

/// Julian days per Julian year.
const double julianYear = 365.25;

/// Julian date of the J1900.0 epoch.
const double j1900 = 2415020.0;

/// Modified Julian Day epoch (JD 2400000.5).
const double mjdEpoch = 2400000.5;

/// Converts a calendar date to Julian Day Number.
///
/// [y] is the year, [m] is the month (1-12), [d] is the day (with fractional
/// part for time of day).
/// Uses the Gregorian calendar for dates on or after 1582-10-15,
/// and the Julian calendar for earlier dates.
double calendarGregorianToJD(int y, int m, double d) {
  if (m <= 2) {
    y -= 1;
    m += 12;
  }
  final a = y ~/ 100;
  final b = 2 - a + a ~/ 4;
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      d +
      b -
      1524.5;
}

/// Converts a calendar date (Julian calendar) to Julian Day Number.
double calendarJulianToJD(int y, int m, double d) {
  if (m <= 2) {
    y -= 1;
    m += 12;
  }
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      d -
      1524.5;
}

/// Converts a Julian Day Number to a Gregorian calendar date.
///
/// Returns a record of (year, month, day).
({int year, int month, double day}) jdToCalendar(double jd) {
  final z = (jd + 0.5).floor();
  final a = z < 2299161 ? z : () {
    final alpha = ((z - 1867216.25) / 36524.25).floor();
    return z + 1 + alpha - alpha ~/ 4;
  }();
  final b = a + 1524;
  final c = ((b - 122.1) / 365.25).floor();
  final d = (365.25 * c).floor();
  final e = ((b - d) / 30.6001).floor();

  final day = b - d - (30.6001 * e).floor() + (jd + 0.5 - z);
  final month = e < 14 ? e - 1 : e - 13;
  final year = month > 2 ? c - 4716 : c - 4715;

  return (year: year, month: month, day: day);
}

/// Day of the year (1-366) for a given Gregorian date.
int dayOfYear(int y, int m, int d) {
  final k = isLeapYearGregorian(y) ? 1 : 2;
  return (275 * m ~/ 9) - k * ((m + 9) ~/ 12) + d - 30;
}

/// Whether a Gregorian year is a leap year.
bool isLeapYearGregorian(int y) =>
    y % 4 == 0 && (y % 100 != 0 || y % 400 == 0);

/// Julian Day Number for J2000.0 epoch.
double j2000Century(double jd) => (jd - j2000) / julianCentury;
