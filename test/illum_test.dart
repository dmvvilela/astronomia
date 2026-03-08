import 'dart:math' as math;
import 'package:astronomia/src/illum/illum.dart';
import 'package:astronomia/src/julian/julian.dart';
import 'package:astronomia/src/base/math.dart';
import 'package:test/test.dart';

void main() {
  group('Illum', () {
    test('phase angle from distances', () {
      // Equilateral triangle: r=Δ=R → i = 60°
      final i = toDeg(phaseAngle(1, 1, 1));
      expect(i, closeTo(60, 0.01));
    });

    test('fraction at full illumination', () {
      // When i=0 (opposition), fraction should be 1
      // r=5, Δ=4, R=1 → i≈0 (nearly aligned)
      final f = fraction(5, 4, 1);
      expect(f, closeTo(1.0, 0.05));
    });

    test('fraction Venus approximation', () {
      final jde = calendarGregorianToJD(2000, 1, 1.5);
      final f = fractionVenus(jde);
      expect(f, greaterThan(0));
      expect(f, lessThanOrEqualTo(1));
    });

    test('Jupiter magnitude at typical opposition', () {
      // r≈5.2, Δ≈4.2 → mag ≈ -2.5
      final mag = magnitudeJupiter(5.2, 4.2);
      expect(mag, closeTo(-2.5, 0.5));
    });

    test('Venus is brighter than Mars', () {
      final vMag = magnitudeVenus(0.72, 1.0, toRad(90));
      final mMag = magnitudeMars(1.52, 1.5, toRad(30));
      expect(vMag, lessThan(mMag));
    });

    test('Neptune is dimmer than Jupiter', () {
      final jMag = magnitudeJupiter(5.2, 4.2);
      final nMag = magnitudeNeptune(30, 29);
      expect(nMag, greaterThan(jMag));
    });

    test('Mercury84 returns reasonable magnitude', () {
      final mag = magnitudeMercury84(0.39, 1.0, toRad(50));
      expect(mag, greaterThan(-3));
      expect(mag, lessThan(5));
    });
  });
}
