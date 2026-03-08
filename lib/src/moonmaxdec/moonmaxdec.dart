/// Moonmaxdec: Chapter 52, Maximum Declinations of the Moon.
///
/// Returns JDE and declination (radians) of maximum declination events.
library;

import 'dart:math' as math;

import '../base/math.dart';

const double _p = math.pi / 180;
const double _ck = 1 / 1336.86;

/// Maximum northern declination nearest the given decimal [year].
({double jde, double dec}) north(double year) => _max(year, _nc);

/// Maximum southern declination nearest the given decimal [year].
({double jde, double dec}) south(double year) => _max(year, _sc);

({double jde, double dec}) _max(double y, _Mc c) {
  var k = (y - 2000.03) * 13.3686;
  k = (k + 0.5).floorToDouble();
  final t = k * _ck;

  final d = horner(t, [c.d0, 333.0705546 * _p / _ck, -0.0004214 * _p, 0.00000011 * _p]);
  final m = horner(t, [c.m0, 26.9281592 * _p / _ck, -0.0000355 * _p, -0.0000001 * _p]);
  final mp = horner(t, [c.mp0, 356.9562794 * _p / _ck, 0.0103066 * _p, 0.00001251 * _p]);
  final f = horner(t, [c.f0, 1.4467807 * _p / _ck, -0.002069 * _p, -0.00000215 * _p]);
  final e = horner(t, [1.0, -0.002516, -0.0000074]);

  final jde = horner(t, [c.jde0, 27.321582247 / _ck, 0.000119804, -0.000000141]) +
      c.tc[0] * math.cos(f) +
      c.tc[1] * math.sin(mp) +
      c.tc[2] * math.sin(2 * f) +
      c.tc[3] * math.sin(2 * d - mp) +
      c.tc[4] * math.cos(mp - f) +
      c.tc[5] * math.cos(mp + f) +
      c.tc[6] * math.sin(2 * d) +
      c.tc[7] * math.sin(m) * e +
      c.tc[8] * math.cos(3 * f) +
      c.tc[9] * math.sin(mp + 2 * f) +
      c.tc[10] * math.cos(2 * d - f) +
      c.tc[11] * math.cos(2 * d - mp - f) +
      c.tc[12] * math.cos(2 * d - mp + f) +
      c.tc[13] * math.cos(2 * d + f) +
      c.tc[14] * math.sin(2 * mp) +
      c.tc[15] * math.sin(mp - 2 * f) +
      c.tc[16] * math.cos(2 * mp - f) +
      c.tc[17] * math.sin(mp + 3 * f) +
      c.tc[18] * math.sin(2 * d - m - mp) * e +
      c.tc[19] * math.cos(mp - 2 * f) +
      c.tc[20] * math.sin(2 * (d - mp)) +
      c.tc[21] * math.sin(f) +
      c.tc[22] * math.sin(2 * d + mp) +
      c.tc[23] * math.cos(mp + 2 * f) +
      c.tc[24] * math.sin(2 * d - m) * e +
      c.tc[25] * math.sin(mp + f) +
      c.tc[26] * math.sin(m - mp) * e +
      c.tc[27] * math.sin(mp - 3 * f) +
      c.tc[28] * math.sin(2 * mp + f) +
      c.tc[29] * math.cos(2 * (d - mp) - f) +
      c.tc[30] * math.sin(3 * f) +
      c.tc[31] * math.cos(mp + 3 * f) +
      c.tc[32] * math.cos(2 * mp) +
      c.tc[33] * math.cos(2 * d - mp) +
      c.tc[34] * math.cos(2 * d + mp + f) +
      c.tc[35] * math.cos(mp) +
      c.tc[36] * math.sin(3 * mp + f) +
      c.tc[37] * math.sin(2 * d - mp + f) +
      c.tc[38] * math.cos(2 * (d - mp)) +
      c.tc[39] * math.cos(d + f) +
      c.tc[40] * math.sin(m + mp) * e +
      c.tc[41] * math.sin(2 * (d - f)) +
      c.tc[42] * math.cos(2 * mp + f) +
      c.tc[43] * math.cos(3 * mp + f);

  final dec = (23.6961 * _p - 0.013004 * _p * t +
      c.dc[0] * math.sin(f) +
      c.dc[1] * math.cos(2 * f) +
      c.dc[2] * math.sin(2 * d - f) +
      c.dc[3] * math.sin(3 * f) +
      c.dc[4] * math.cos(2 * (d - f)) +
      c.dc[5] * math.cos(2 * d) +
      c.dc[6] * math.sin(mp - f) +
      c.dc[7] * math.sin(mp + 2 * f) +
      c.dc[8] * math.cos(f) +
      c.dc[9] * math.sin(2 * d + m - f) * e +
      c.dc[10] * math.sin(mp + 3 * f) +
      c.dc[11] * math.sin(d + f) +
      c.dc[12] * math.sin(mp - 2 * f) +
      c.dc[13] * math.sin(2 * d - m - f) * e +
      c.dc[14] * math.sin(2 * d - mp - f) +
      c.dc[15] * math.cos(mp + f) +
      c.dc[16] * math.cos(mp + 2 * f) +
      c.dc[17] * math.cos(2 * mp + f) +
      c.dc[18] * math.cos(mp - 3 * f) +
      c.dc[19] * math.cos(2 * mp - f) +
      c.dc[20] * math.cos(mp - 2 * f) +
      c.dc[21] * math.sin(2 * mp) +
      c.dc[22] * math.sin(3 * mp + f) +
      c.dc[23] * math.cos(2 * d + m - f) * e +
      c.dc[24] * math.cos(mp - f) +
      c.dc[25] * math.cos(3 * f) +
      c.dc[26] * math.sin(2 * d + f) +
      c.dc[27] * math.cos(mp + 3 * f) +
      c.dc[28] * math.cos(d + f) +
      c.dc[29] * math.sin(2 * mp - f) +
      c.dc[30] * math.cos(3 * mp + f) +
      c.dc[31] * math.cos(2 * (d + mp) + f) +
      c.dc[32] * math.sin(2 * (d - mp) - f) +
      c.dc[33] * math.cos(2 * mp) +
      c.dc[34] * math.cos(mp) +
      c.dc[35] * math.sin(2 * f) +
      c.dc[36] * math.sin(mp + f)) * c.sign;

  return (jde: jde, dec: dec);
}

class _Mc {
  final double d0, m0, mp0, f0, jde0, sign;
  final List<double> tc;
  final List<double> dc;
  const _Mc(this.d0, this.m0, this.mp0, this.f0, this.jde0, this.sign, this.tc, this.dc);
}

final _nc = _Mc(
  152.2029 * _p, 14.8591 * _p, 4.6881 * _p, 325.8867 * _p,
  2451562.5897, 1,
  [.8975, -.4726, -.1030, -.0976, -.0462, -.0461, -.0438,
   .0162, -.0157, .0145, .0136, -.0095, -.0091, -.0089,
   .0075, -.0068, .0061, -.0047, -.0043, -.004, -.0037,
   .0031, .0030, -.0029, -.0029, -.0027, .0024, -.0021,
   .0019, .0018, .0018, .0017, .0017, -.0014, .0013,
   .0013, .0012, .0011, -.0011, .001, .001, -.0009, .0007, -.0007],
  [5.1093*_p, .2658*_p, .1448*_p, -.0322*_p, .0133*_p, .0125*_p,
   -.0124*_p, -.0101*_p, .0097*_p, -.0087*_p, .0074*_p, .0067*_p,
   .0063*_p, .0060*_p, -.0057*_p, -.0056*_p, .0052*_p, .0041*_p,
   -.004*_p, .0038*_p, -.0034*_p, -.0029*_p, .0029*_p, -.0028*_p,
   -.0028*_p, -.0023*_p, -.0021*_p, .0019*_p, .0018*_p, .0017*_p,
   .0015*_p, .0014*_p, -.0012*_p, -.0012*_p, -.001*_p, -.001*_p, .0006*_p],
);

final _sc = _Mc(
  345.6676 * _p, 1.3951 * _p, 186.21 * _p, 145.1633 * _p,
  2451548.9289, -1,
  [-.8975, -.4726, -.1030, -.0976, .0541, .0516, -.0438,
   .0112, .0157, .0023, -.0136, .011, .0091, .0089,
   .0075, -.003, -.0061, -.0047, -.0043, .004, -.0037,
   -.0031, .0030, .0029, -.0029, -.0027, .0024, -.0021,
   -.0019, -.0006, -.0018, -.0017, .0017, .0014, -.0013,
   -.0013, .0012, .0011, .0011, .001, .001, -.0009, -.0007, -.0007],
  [-5.1093*_p, .2658*_p, -.1448*_p, .0322*_p, .0133*_p, .0125*_p,
   -.0015*_p, .0101*_p, -.0097*_p, .0087*_p, .0074*_p, .0067*_p,
   -.0063*_p, -.0060*_p, .0057*_p, -.0056*_p, -.0052*_p, -.0041*_p,
   -.004*_p, -.0038*_p, .0034*_p, -.0029*_p, .0029*_p, .0028*_p,
   -.0028*_p, .0023*_p, .0021*_p, .0019*_p, .0018*_p, -.0017*_p,
   .0015*_p, .0014*_p, .0012*_p, -.0012*_p, .001*_p, -.001*_p, .0037*_p],
);
