/// Planetelements: Chapter 31, Elements of Planetary Orbits.
///
/// Mean elements referenced to mean dynamical ecliptic and equinox of date.
library;

import '../base/math.dart';
import '../julian/julian.dart';

const int mercury = 0;
const int venus = 1;
const int earth = 2;
const int mars = 3;
const int jupiter = 4;
const int saturn = 5;
const int uranus = 6;
const int neptune = 7;

/// Mean orbital elements for planet [p] at [jde].
///
/// Returns (lon, axis, ecc, inc, node, peri) where angular elements are in
/// radians and axis is in AU.
///
/// Derived quantities:
/// - Mean anomaly M = lon - peri
/// - Argument of perihelion ω = peri - node
({double lon, double axis, double ecc, double inc, double node, double peri})
    mean(int p, double jde) {
  final t = j2000Century(jde);
  final c = _cMean[p];
  return (
    lon: mod2pi(toRad(horner(t, c.l))),
    axis: horner(t, c.a),
    ecc: horner(t, c.e),
    inc: toRad(horner(t, c.i)),
    node: toRad(horner(t, c.n)),
    peri: toRad(horner(t, c.p)),
  );
}

/// Mean inclination for planet [p] at [jde], in radians.
double inc(int p, double jde) =>
    toRad(horner(j2000Century(jde), _cMean[p].i));

/// Mean longitude of ascending node for planet [p] at [jde], in radians.
double node(int p, double jde) =>
    toRad(horner(j2000Century(jde), _cMean[p].n));

class _C6 {
  final List<double> l, a, e, i, n, p;
  const _C6(this.l, this.a, this.e, this.i, this.n, this.p);
}

// Table 31.A, p. 212
const _cMean = <_C6>[
  // Mercury
  _C6(
    [252.250906, 149474.0722491, .0003035, .000000018],
    [.38709831],
    [.20563175, .000020407, -.0000000283, -.00000000018],
    [7.004986, .0018215, -.0000181, .000000056],
    [48.330893, 1.1861883, .00017542, .000000215],
    [77.456119, 1.5564776, .00029544, .000000009],
  ),
  // Venus
  _C6(
    [181.979801, 58519.2130302, .00031014, .000000015],
    [.72332982],
    [.00677192, -.000047765, .0000000981, .00000000046],
    [3.394662, .0010037, -.00000088, -.000000007],
    [76.67992, .9011206, .00040618, -.000000093],
    [131.563703, 1.4022288, -.00107618, -.000005678],
  ),
  // Earth
  _C6(
    [100.466457, 36000.7698278, .00030322, .00000002],
    [1.000001018],
    [.01670863, -.000042037, -.0000001267, .00000000014],
    [0],
    [0], // Earth has no meaningful node in this system
    [102.937348, 1.7195366, .00045688, -.000000018],
  ),
  // Mars
  _C6(
    [355.433, 19141.6964471, .00031052, .000000016],
    [1.523679342],
    [.09340065, .000090484, -.0000000806, -.00000000025],
    [1.849726, -.0006011, .00001276, -.000000007],
    [49.558093, .7720959, .00001557, .000002267],
    [336.060234, 1.8410449, .00013477, .000000536],
  ),
  // Jupiter
  _C6(
    [34.351519, 3036.3027748, .0002233, .000000037],
    [5.202603209, .0000001913],
    [.04849793, .000163225, -.0000004714, -.00000000201],
    [1.303267, -.0054965, .00000466, -.000000002],
    [100.464407, 1.0209774, .00040315, .000000404],
    [14.331207, 1.6126352, .00103042, -.000004464],
  ),
  // Saturn
  _C6(
    [50.077444, 1223.5110686, .00051908, -.00000003],
    [9.554909192, -.0000021390, .000000004],
    [.05554814, -.000346641, -.0000006436, .0000000034],
    [2.488879, -.0037362, -.00001519, .000000087],
    [113.665503, .877088, -.00012176, -.000002249],
    [93.057237, 1.9637613, .00083753, .000004928],
  ),
  // Uranus
  _C6(
    [314.055005, 429.8640561, .0003039, .000000026],
    [19.218446062, -.0000000372, .00000000098],
    [.04638122, -.000027293, .0000000789, .00000000024],
    [.773197, .0007744, .00003749, -.000000092],
    [74.005957, .5211278, .00133947, .000018484],
    [173.005291, 1.486379, .00021406, .000000434],
  ),
  // Neptune
  _C6(
    [304.348665, 219.8833092, .00030882, .000000018],
    [30.110386869, -.0000001663, .00000000069],
    [.00945575, .000006033, 0, -.00000000005],
    [1.769953, -.0093082, -.00000708, .000000027],
    [131.784057, 1.1022039, .00025952, -.000000637],
    [48.120276, 1.4262957, .00038434, .00000002],
  ),
];
