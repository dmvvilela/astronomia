import 'package:astronomia/src/stellar/stellar.dart';
import 'package:test/test.dart';

void main() {
  group('Stellar', () {
    test('sum of equal magnitudes is ~0.75 mag brighter', () {
      // Two stars of mag 5 → combined ~4.25
      expect(sum(5, 5), closeTo(4.25, 0.01));
    });

    test('sumN of single star returns same magnitude', () {
      expect(sumN([3.0]), closeTo(3.0, 0.001));
    });

    test('ratio of 5 magnitudes is 100', () {
      expect(ratio(0, 5), closeTo(100, 0.1));
    });

    test('difference of ratio 100 is 5', () {
      expect(difference(100), closeTo(5, 0.001));
    });

    test('absolute magnitude at 10 pc equals apparent', () {
      expect(absoluteByDistance(5, 10), closeTo(5, 0.001));
    });
  });
}
