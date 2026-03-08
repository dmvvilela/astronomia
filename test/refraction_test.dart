import 'package:astronomia/src/refraction/refraction.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Refraction', () {
    test('gt15True at 45°', () {
      final r = gt15True(toRad(45));
      // Should be about 58″ at 45° altitude
      final rSec = toDeg(r) * 3600;
      expect(rSec, closeTo(58.3, 1.0));
    });

    test('bennett at low altitude', () {
      final r = bennett(toRad(5));
      final rMin = toDeg(r) * 60;
      // At 5° altitude, refraction should be about 9.9 arcmin
      expect(rMin, closeTo(9.9, 0.5));
    });

    test('saemundsson at 30°', () {
      final r = saemundsson(toRad(30));
      final rMin = toDeg(r) * 60;
      // At 30° true altitude, refraction should be about 1.7 arcmin
      expect(rMin, closeTo(1.7, 0.3));
    });
  });
}
