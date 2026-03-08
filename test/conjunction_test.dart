import 'package:astronomia/src/base/coord.dart';
import 'package:astronomia/src/conjunction/conjunction.dart' as conjunction;
import 'package:test/test.dart';

void main() {
  group('conjunction', () {
    test('planetary conjunction finds zero-crossing', () {
      // Two objects whose RA difference crosses zero in the middle
      final cs1 = [
        Equatorial(1.0, 0.1),
        Equatorial(1.1, 0.12),
        Equatorial(1.2, 0.14),
        Equatorial(1.3, 0.16),
        Equatorial(1.4, 0.18),
      ];
      final cs2 = [
        Equatorial(1.4, 0.2),
        Equatorial(1.3, 0.18),
        Equatorial(1.2, 0.16),
        Equatorial(1.1, 0.14),
        Equatorial(1.0, 0.12),
      ];
      final result = conjunction.planetary(0, 4, cs1, cs2);
      // Conjunction should occur near the midpoint
      expect(result.t, closeTo(2.0, 0.01));
      // deltaD should be finite
      expect(result.deltaD.isFinite, isTrue);
    });

    test('stellar conjunction finds zero-crossing', () {
      final star = Equatorial(1.2, 0.5);
      // Moving object crosses the star's RA
      final cs2 = [
        Equatorial(1.0, 0.4),
        Equatorial(1.1, 0.45),
        Equatorial(1.2, 0.5),
        Equatorial(1.3, 0.55),
        Equatorial(1.4, 0.6),
      ];
      final result = conjunction.stellar(0, 4, star, cs2);
      // Conjunction at midpoint where RA matches
      expect(result.t, closeTo(2.0, 0.01));
    });

    test('throws on wrong ephemeris length', () {
      expect(
        () => conjunction.planetary(0, 4, [Equatorial(0, 0)], [Equatorial(0, 0)]),
        throwsArgumentError,
      );
      expect(
        () => conjunction.stellar(0, 4, Equatorial(0, 0), [Equatorial(0, 0)]),
        throwsArgumentError,
      );
    });
  });
}
