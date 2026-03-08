import 'package:astronomia/src/planetposition/planetposition.dart';
import 'package:astronomia/src/saturnmoons/saturnmoons.dart' as sm;
import 'package:test/test.dart';

void main() {
  group('saturnmoons', () {
    late Planet earth;
    late Planet saturn;

    setUpAll(() {
      earth = Planet(planetEarth);
      saturn = Planet(planetSaturn);
    });

    test('positions returns 8 moons', () {
      const jde = 2451545.0; // J2000
      final pos = sm.positions(jde, earth, saturn);
      expect(pos.length, equals(8));
    });

    test('all positions are finite', () {
      const jde = 2451545.0;
      final pos = sm.positions(jde, earth, saturn);
      for (var i = 0; i < 8; i++) {
        expect(pos[i].x.isFinite, isTrue, reason: 'moon $i x');
        expect(pos[i].y.isFinite, isTrue, reason: 'moon $i y');
        expect(pos[i].z.isFinite, isTrue, reason: 'moon $i z');
      }
    });

    test('Titan is farther than Mimas', () {
      const jde = 2451545.0;
      final pos = sm.positions(jde, earth, saturn);
      final mimasR = pos[sm.mimas].x * pos[sm.mimas].x +
          pos[sm.mimas].y * pos[sm.mimas].y;
      final titanR = pos[sm.titan].x * pos[sm.titan].x +
          pos[sm.titan].y * pos[sm.titan].y;
      expect(titanR, greaterThan(mimasR));
    });

    test('index constants are correct', () {
      expect(sm.mimas, equals(0));
      expect(sm.enceladus, equals(1));
      expect(sm.tethys, equals(2));
      expect(sm.dione, equals(3));
      expect(sm.rhea, equals(4));
      expect(sm.titan, equals(5));
      expect(sm.hyperion, equals(6));
      expect(sm.iapetus, equals(7));
    });
  });
}
