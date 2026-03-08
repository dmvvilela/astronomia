/// Easter: Chapter 8, Date of Easter.
library;

/// Date of Easter in the Gregorian calendar.
({int month, int day}) gregorian(int y) {
  final a = y % 19;
  final b = y ~/ 100, c = y % 100;
  final d = b ~/ 4, e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4, k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final n = h + l - 7 * m + 114;
  return (month: n ~/ 31, day: n % 31 + 1);
}

/// Date of Easter in the Julian calendar.
({int month, int day}) julian(int y) {
  final a = y % 4;
  final b = y % 7;
  final c = y % 19;
  final d = (19 * c + 15) % 30;
  final e = (2 * a + 4 * b - d + 34) % 7;
  final f = d + e + 114;
  return (month: f ~/ 31, day: f % 31 + 1);
}
