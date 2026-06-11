import 'package:astronomia/src/moonnode/moonnode.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:test/test.dart';

void main() {
  group('Moonnode', () {
    test('Meeus example 51.a - ascending 1987 May', () {
      // Meeus p. 365: JDE = 2446938.76803 (1987 May 23, 06:25:58 TD)
      final jde = ascending(1987.37);
      expect(jde, closeTo(2446938.76803, 0.00005));
      final cal = jdToCalendar(jde);
      expect(cal.month, equals(5));
      expect(cal.day, closeTo(23.268, 0.001));
    });

    test('descending is ~13.6 days after ascending', () {
      final a = ascending(2000.0);
      final d = descending(2000.0);
      final diff = (d - a).abs();
      // Half draconic month ≈ 13.6 days
      expect(diff, closeTo(13.6, 1.0));
    });

    test('ascending nodes are ~27.2 days apart', () {
      final a1 = ascending(2000.0);
      final a2 = ascending(2000.0 + 27.3 / 365.25);
      final diff = (a2 - a1).abs();
      // Draconic month ≈ 27.21 days
      expect(diff, closeTo(27.21, 0.5));
    });
  });
}
