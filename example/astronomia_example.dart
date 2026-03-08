import 'package:astronomia/astronomia.dart';

void main() {
  // Convert a date to Julian Day Number
  final jd = calendarGregorianToJD(2000, 1, 1.5);
  print('J2000.0 = JD $jd'); // 2451545.0

  // Convert back
  final date = jdToCalendar(jd);
  print('Date: ${date.year}-${date.month}-${date.day}');

  // Sexagesimal
  final angle = Sexa.fromDeg(23.4393);
  print('Obliquity: $angle');

  // Coordinate types
  final eq = Equatorial(toRad(10.684), toRad(41.269));
  print('M31: $eq');
}
