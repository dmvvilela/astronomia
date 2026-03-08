/// DeltaT: Chapter 10, Dynamical Time and Universal Time.
///
/// ΔT = TD - UT, returned in seconds.
library;

import '../base/math.dart';
import '../interpolation/interpolation.dart';
import '../julian/julian.dart';

/// Table 10.A — ΔT values from 1620 to 2010, every 2 years.
const _tableYear1 = 1620.0;
const _tableYearN = 2010.0;

const _table10A = <double>[
  121, 112, 103, 95, 88, 82, 77, 72, 68, 63,
  60, 56, 53, 51, 48, 46, 44, 42, 40, 38,
  35, 33, 31, 29, 26, 24, 22, 20, 18, 16,
  14, 12, 11, 10, 9, 8, 7, 7, 7, 7,
  7, 7, 8, 8, 9, 9, 9, 9, 9, 10,
  10, 10, 10, 10, 10, 10, 10, 11, 11, 11,
  11, 11, 12, 12, 12, 12, 13, 13, 13, 14,
  14, 14, 14, 15, 15, 15, 15, 15, 16, 16,
  16, 16, 16, 16, 16, 16, 15, 15, 14, 13,
  13.1, 12.5, 12.2, 12, 12, 12, 12, 12, 12, 11.9,
  11.6, 11, 10.2, 9.2, 8.2, 7.1, 6.2, 5.6, 5.4, 5.3,
  5.4, 5.6, 5.9, 6.2, 6.5, 6.8, 7.1, 7.3, 7.5, 7.6,
  7.7, 7.3, 6.2, 5.2, 2.7, 1.4, -1.2, -2.8, -3.8, -4.8,
  -5.5, -5.3, -5.6, -5.7, -5.9, -6, -6.3, -6.5, -6.2, -4.7,
  -2.8, -0.1, 2.6, 5.3, 7.7, 10.4, 13.3, 16, 18.2, 20.2,
  21.1, 22.4, 23.5, 23.8, 24.3, 24, 23.9, 23.9, 23.7, 24,
  24.3, 25.3, 26.2, 27.3, 28.2, 29.1, 30, 30.7, 31.4, 32.2,
  33.1, 34, 35, 36.5, 38.3, 40.2, 42.2, 44.5, 46.5, 48.5,
  50.5, 52.2, 53.8, 54.9, 55.8, 56.9, 58.3, 60, 61.6, 63,
  63.8, 64.3, 64.6, 64.8, 65.5, 66.1,
];

/// Interpolated ΔT from Table 10.A, accurate for years 1620–2010.
///
/// [jde] is a Julian Ephemeris Day.
/// Returns ΔT in seconds.
double interp10A(double jde) {
  final cal = jdToCalendar(jde);
  final leap = isLeapYearGregorian(cal.year);
  final yl = leap ? 366.0 : 365.0;
  final yf = cal.year +
      dayOfYear(cal.year, cal.month, cal.day.round()) / yl;
  final d3 = Len3.forInterpolateX(yf, _tableYear1, _tableYearN, _table10A);
  return d3.interpolateX(yf);
}

double _c2000(double year) => (year - 2000) * 0.01;

/// Polynomial approximation of ΔT for calendar years before 948.
double polyBefore948(double year) {
  return horner(_c2000(year), [2177, 497, 44.1]);
}

/// Polynomial approximation of ΔT for calendar years 948–1600.
double poly948to1600(double year) {
  return horner(_c2000(year), [102, 102, 25.3]);
}

/// Polynomial approximation of ΔT for calendar years after 2000.
double polyAfter2000(double year) {
  var dt = poly948to1600(year);
  if (year < 2100) {
    dt += 0.37 * (year - 2100);
  }
  return dt;
}

double _jc1900(double jde) => (jde - j1900) / julianCentury;

/// Polynomial approximation of ΔT for years 1800–1997.
///
/// Accuracy within 2.3 seconds.
double poly1800to1997(double jde) {
  return horner(_jc1900(jde), [
    -1.02, 91.02, 265.90, -839.16, -1545.20,
    3603.62, 4385.98, -6993.23, -6090.04,
    6298.12, 4102.86, -2137.64, -1081.51,
  ]);
}

/// Polynomial approximation of ΔT for years 1800–1899.
///
/// Accuracy within 0.9 seconds.
double poly1800to1899(double jde) {
  return horner(_jc1900(jde), [
    -2.50, 228.95, 5218.61, 56282.84, 324011.78,
    1061660.75, 2087298.89, 2513807.78,
    1818961.41, 727058.63, 123563.95,
  ]);
}

/// Polynomial approximation of ΔT for years 1900–1997.
///
/// Accuracy within 0.9 seconds.
double poly1900to1997(double jde) {
  return horner(_jc1900(jde), [
    -2.44, 87.24, 815.20, -2637.80, -18756.33,
    124906.15, -303191.19, 372919.88,
    -232424.66, 58353.42,
  ]);
}
