/// Saturnmoons: Chapter 46, Positions of the Satellites of Saturn.
///
/// Positions of the eight major moons in Saturn radii.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';
import '../planetposition/planetposition.dart';
import '../precess/precess.dart';
import '../solar/solar.dart' as solar;

/// Moon indices for the positions array.
const int mimas = 0;
const int enceladus = 1;
const int tethys = 2;
const int dione = 3;
const int rhea = 4;
const int titan = 5;
const int hyperion = 6;
const int iapetus = 7;

/// Position of a Saturn moon in Saturn radii.
class MoonPosition {
  final double x;
  final double y;
  final double z;

  const MoonPosition(this.x, this.y, this.z);

  @override
  String toString() => 'MoonPosition(x: $x, y: $y, z: $z)';
}

const double _d = math.pi / 180;

const _k = [0, 20947, 23715, 26382, 29876, 35313, 53800, 59222, 91820];

/// Returns positions of the eight major moons of Saturn.
///
/// [jde] is Julian ephemeris day.
/// [earth] and [saturn] are VSOP87 planets.
/// Result units are Saturn radii.
/// Access individual moons via index constants ([mimas] through [iapetus]).
List<MoonPosition> positions(double jde, Planet earth, Planet saturn) {
  final sol = solar.trueVSOP87(earth, jde);
  final s = sol.lon, beta = sol.lat, rr = sol.range;
  final ss = math.sin(s), cs = math.cos(s);
  final sBeta = math.sin(beta);
  var delta = 9.0;
  var x = 0.0, y = 0.0, z = 0.0;
  var jde2 = jde;

  void f() {
    final tau = lightTime(delta);
    jde2 = jde - tau;
    final satPos = saturn.position(jde2);
    final fk5 = toFK5(satPos.lon, satPos.lat, jde2);
    final l = fk5.lon, b = fk5.lat;
    final sl = math.sin(l), cl = math.cos(l);
    final sb = math.sin(b), cb = math.cos(b);
    x = satPos.range * cb * cl + rr * cs;
    y = satPos.range * cb * sl + rr * ss;
    z = satPos.range * sb + rr * sBeta;
    delta = math.sqrt(x * x + y * y + z * z);
  }

  f();
  f();

  var lambda0 = math.atan2(y, x);
  var beta0 = math.atan(z / math.sqrt(x * x + y * y));

  // Precess to B1950
  final ep = EclipticPrecessor(jdeToJulianYear(jde), 1950.0);
  final precessed = ep.precess(lambda0, beta0);
  lambda0 = precessed.lon;
  beta0 = precessed.lat;

  final q = _Qs(jde2);
  final s4 = [
    _R4(), // index 0 unused
    q.mimasMoon(),
    q.enceladusMoon(),
    q.tethysMoon(),
    q.dioneMoon(),
    q.rheaMoon(),
    q.titanMoon(),
    q.hyperionMoon(),
    q.iapetusMoon(),
  ];

  final xArr = List<double>.filled(9, 0);
  final yArr = List<double>.filled(9, 0);
  final zArr = List<double>.filled(9, 0);

  for (var j = 1; j <= 8; j++) {
    final u = s4[j].lambda - s4[j].omega;
    final w = s4[j].omega - 168.8112 * _d;
    final su = math.sin(u), cu = math.cos(u);
    final sw = math.sin(w), cw = math.cos(w);
    final sGamma = math.sin(s4[j].gamma);
    final cGamma = math.cos(s4[j].gamma);
    final r = s4[j].r;
    xArr[j] = r * (cu * cw - su * cGamma * sw);
    yArr[j] = r * (su * cw * cGamma + cu * sw);
    zArr[j] = r * su * sGamma;
  }
  zArr[0] = 1;

  final sLambda0 = math.sin(lambda0), cLambda0 = math.cos(lambda0);
  final sBeta0 = math.sin(beta0), cBeta0 = math.cos(beta0);

  final aArr = List<double>.filled(9, 0);
  final bArr = List<double>.filled(9, 0);
  final cArr = List<double>.filled(9, 0);

  for (var j = 0; j <= 8; j++) {
    var a = xArr[j];
    var b = q.c1 * yArr[j] - q.s1 * zArr[j];
    final c = q.s1 * yArr[j] + q.c1 * zArr[j];
    final a0 = q.c2 * a - q.s2 * b;
    b = q.s2 * a + q.c2 * b;
    a = a0;

    aArr[j] = a * sLambda0 - b * cLambda0;
    b = a * cLambda0 + b * sLambda0;

    bArr[j] = b * cBeta0 + c * sBeta0;
    cArr[j] = c * cBeta0 - b * sBeta0;
  }

  final dd = math.atan2(aArr[0], cArr[0]);
  final sD = math.sin(dd), cD = math.cos(dd);

  final pos = List<MoonPosition>.filled(8, const MoonPosition(0, 0, 0));
  for (var j = 1; j <= 8; j++) {
    var xj = aArr[j] * cD - cArr[j] * sD;
    final yj = aArr[j] * sD + cArr[j] * cD;
    final zj = bArr[j];
    final dv = xj / s4[j].r;
    xj += zj.abs() / _k[j] * math.sqrt(1 - dv * dv);
    final ww = delta / (delta + zj / 2475);
    pos[j - 1] = MoonPosition(xj * ww, yj * ww, zj);
  }
  return pos;
}

class _R4 {
  double lambda;
  double r;
  double gamma;
  double omega;

  _R4({this.lambda = 0, this.r = 0, this.gamma = 0, this.omega = 0});
}

class _Qs {
  final double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11;
  final double w0, w1, w2, w3, w4, w5, w6, w7, w8;
  final double s1, c1, s2, c2;
  final double e1;
  final double sW0, s3W0, s5W0;
  final double sW1, sW2;
  final double sW3, cW3, sW4, cW4;
  final double sW7, cW7;

  _Qs._(
    this.t1,
    this.t2,
    this.t3,
    this.t4,
    this.t5,
    this.t6,
    this.t7,
    this.t8,
    this.t9,
    this.t10,
    this.t11,
    this.w0,
    this.w1,
    this.w2,
    this.w3,
    this.w4,
    this.w5,
    this.w6,
    this.w7,
    this.w8,
    this.s1,
    this.c1,
    this.s2,
    this.c2,
    this.e1,
    this.sW0,
    this.s3W0,
    this.s5W0,
    this.sW1,
    this.sW2,
    this.sW3,
    this.cW3,
    this.sW4,
    this.cW4,
    this.sW7,
    this.cW7,
  );

  factory _Qs(double jde) {
    final t1 = jde - 2411093;
    final t2 = t1 / 365.25;
    final t3 = (jde - 2433282.423) / 365.25 + 1950;
    final t4 = jde - 2411368;
    final t5 = t4 / 365.25;
    final t6 = jde - 2415020;
    final t7 = t6 / 36525;
    final t8 = t6 / 365.25;
    final t9 = (jde - 2442000.5) / 365.25;
    final t10 = jde - 2409786;
    final t11 = t10 / 36525;
    final w0 = 5.095 * _d * (t3 - 1866.39);
    final w1 = 74.4 * _d + 32.39 * _d * t2;
    final w2 = 134.3 * _d + 92.62 * _d * t2;
    final w3 = 42 * _d - 0.5118 * _d * t5;
    final w4 = 276.59 * _d + 0.5118 * _d * t5;
    final w5 = 267.2635 * _d + 1222.1136 * _d * t7;
    final w6 = 175.4762 * _d + 1221.5515 * _d * t7;
    final w7 = 2.4891 * _d + 0.002435 * _d * t7;
    final w8 = 113.35 * _d - 0.2597 * _d * t7;

    return _Qs._(
      t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11,
      w0, w1, w2, w3, w4, w5, w6, w7, w8,
      math.sin(28.0817 * _d), // s1
      math.cos(28.0817 * _d), // c1
      math.sin(168.8112 * _d), // s2
      math.cos(168.8112 * _d), // c2
      0.05589 - 0.000346 * t7, // e1
      math.sin(w0), // sW0
      math.sin(3 * w0), // s3W0
      math.sin(5 * w0), // s5W0
      math.sin(w1), // sW1
      math.sin(w2), // sW2
      math.sin(w3), // sW3
      math.cos(w3), // cW3
      math.sin(w4), // sW4
      math.cos(w4), // cW4
      math.sin(w7), // sW7
      math.cos(w7), // cW7
    );
  }

  _R4 mimasMoon() {
    final ll = 127.64 * _d +
        381.994497 * _d * t1 -
        43.57 * _d * sW0 -
        0.72 * _d * s3W0 -
        0.02144 * _d * s5W0;
    final p = 106.1 * _d + 365.549 * _d * t2;
    final m = ll - p;
    final c = 2.18287 * _d * math.sin(m) +
        0.025988 * _d * math.sin(2 * m) +
        0.00043 * _d * math.sin(3 * m);
    return _R4(
      lambda: ll + c,
      r: 3.06879 / (1 + 0.01905 * math.cos(m + c)),
      gamma: 1.563 * _d,
      omega: 54.5 * _d - 365.072 * _d * t2,
    );
  }

  _R4 enceladusMoon() {
    final ll = 200.317 * _d +
        262.7319002 * _d * t1 +
        0.25667 * _d * sW1 +
        0.20883 * _d * sW2;
    final p = 309.107 * _d + 123.44121 * _d * t2;
    final m = ll - p;
    final c =
        0.55577 * _d * math.sin(m) + 0.00168 * _d * math.sin(2 * m);
    return _R4(
      lambda: ll + c,
      r: 3.94118 / (1 + 0.00485 * math.cos(m + c)),
      gamma: 0.0262 * _d,
      omega: 348 * _d - 151.95 * _d * t2,
    );
  }

  _R4 tethysMoon() {
    return _R4(
      lambda: 285.306 * _d +
          190.69791226 * _d * t1 +
          2.063 * _d * sW0 +
          0.03409 * _d * s3W0 +
          0.001015 * _d * s5W0,
      r: 4.880998,
      gamma: 1.0976 * _d,
      omega: 111.33 * _d - 72.2441 * _d * t2,
    );
  }

  _R4 dioneMoon() {
    final ll = 254.712 * _d +
        131.53493193 * _d * t1 -
        0.0215 * _d * sW1 -
        0.01733 * _d * sW2;
    final p = 174.8 * _d + 30.82 * _d * t2;
    final m = ll - p;
    final c =
        0.24717 * _d * math.sin(m) + 0.00033 * _d * math.sin(2 * m);
    return _R4(
      lambda: ll + c,
      r: 6.24871 / (1 + 0.002157 * math.cos(m + c)),
      gamma: 0.0139 * _d,
      omega: 232 * _d - 30.27 * _d * t2,
    );
  }

  _R4 rheaMoon() {
    final pPrime = 342.7 * _d + 10.057 * _d * t2;
    final spPrime = math.sin(pPrime), cpPrime = math.cos(pPrime);
    final a1 = 0.000265 * spPrime + 0.001 * sW4;
    final a2 = 0.000265 * cpPrime + 0.001 * cW4;
    final e = math.sqrt(a1 * a1 + a2 * a2);
    final p = math.atan2(a1, a2);
    final n = 345 * _d - 10.057 * _d * t2;
    final sN = math.sin(n), cN = math.cos(n);
    final lambdaPrime =
        359.244 * _d + 79.6900472 * _d * t1 + 0.086754 * _d * sN;
    final i = 28.0362 * _d + 0.346898 * _d * cN + 0.0193 * _d * cW3;
    final omega = 168.8034 * _d + 0.736936 * _d * sN + 0.041 * _d * sW3;
    final a = 8.725924;
    return _subr(lambdaPrime, p, e, a, omega, i);
  }

  _R4 _subr(
      double lambdaPrime, double p, double e, double a, double omega, double i) {
    final m = lambdaPrime - p;
    final e2 = e * e;
    final e3 = e2 * e;
    final e4 = e2 * e2;
    final e5 = e3 * e2;
    final c = (2 * e - 0.25 * e3 + 0.0520833333 * e5) * math.sin(m) +
        (1.25 * e2 - 0.458333333 * e4) * math.sin(2 * m) +
        (1.083333333 * e3 - 0.671875 * e5) * math.sin(3 * m) +
        1.072917 * e4 * math.sin(4 * m) +
        1.142708 * e5 * math.sin(5 * m);
    final r = a * (1 - e2) / (1 + e * math.cos(m + c));
    final g = omega - 168.8112 * _d;
    final si = math.sin(i), ci = math.cos(i);
    final sg = math.sin(g), cg = math.cos(g);
    final a1 = si * sg;
    final a2 = c1 * si * cg - s1 * ci;
    final gamma = math.asin(math.sqrt(a1 * a1 + a2 * a2));
    final u = math.atan2(a1, a2);
    final w = 168.8112 * _d + u;
    final h = c1 * si - s1 * ci * cg;
    final psi = math.atan2(s1 * sg, h);
    final lambda = lambdaPrime + c + u - g - psi;
    return _R4(lambda: lambda, r: r, gamma: gamma, omega: w);
  }

  _R4 titanMoon() {
    final ll = 261.1582 * _d + 22.57697855 * _d * t4 + 0.074025 * _d * sW3;
    final iPrime = 27.45141 * _d + 0.295999 * _d * cW3;
    final omegaPrime = 168.66925 * _d + 0.628808 * _d * sW3;
    final siPrime = math.sin(iPrime), ciPrime = math.cos(iPrime);
    final sOmegaPrimeW8 = math.sin(omegaPrime - w8);
    final cOmegaPrimeW8 = math.cos(omegaPrime - w8);
    final a1 = sW7 * sOmegaPrimeW8;
    final a2 = cW7 * siPrime - sW7 * ciPrime * cOmegaPrimeW8;
    final psi = math.atan2(a1, a2);
    final sv = math.sqrt(a1 * a1 + a2 * a2);
    var g = w4 - omegaPrime - psi;
    var varpi = 0.0;
    final s2g0 = math.sin(2 * 102.8623 * _d);
    final c2g0 = math.cos(2 * 102.8623 * _d);
    void iterate() {
      varpi = w4 + 0.37515 * _d * (math.sin(2 * g) - s2g0);
      g = varpi - omegaPrime - psi;
    }

    iterate();
    iterate();
    iterate();

    final ePrime = 0.029092 + 0.00019048 * (math.cos(2 * g) - c2g0);
    final qq = 2 * (w5 - varpi);
    final b1 = siPrime * sOmegaPrimeW8;
    final b2 = cW7 * siPrime * cOmegaPrimeW8 - sW7 * ciPrime;
    final theta = math.atan2(b1, b2) + w8;
    final sq = math.sin(qq), cq = math.cos(qq);
    final ee = ePrime + 0.002778797 * ePrime * cq;
    final pp = varpi + 0.159215 * _d * sq;
    final u = 2 * w5 - 2 * theta + psi;
    final su = math.sin(u), cu = math.cos(u);
    final h =
        0.9375 * ePrime * ePrime * sq +
        0.1875 * sv * sv * math.sin(2 * (w5 - theta));
    final lambdaPrime = ll -
        0.254744 * _d *
            (e1 * math.sin(w6) +
                0.75 * e1 * e1 * math.sin(2 * w6) +
                h);
    final i = iPrime + 0.031843 * _d * sv * cu;
    final omega = omegaPrime + 0.031843 * _d * sv * su / siPrime;
    final a = 20.216193;
    return _subr(lambdaPrime, pp, ee, a, omega, i);
  }

  _R4 hyperionMoon() {
    final eta = 92.39 * _d + 0.5621071 * _d * t6;
    final zeta = 148.19 * _d - 19.18 * _d * t8;
    final theta = 184.8 * _d - 35.41 * _d * t9;
    final thetaPrime = theta - 7.5 * _d;
    final as_ = 176 * _d + 12.22 * _d * t8;
    final bs = 8 * _d + 24.44 * _d * t8;
    final cs_ = bs + 5 * _d;
    final varpi = 69.898 * _d - 18.67088 * _d * t8;
    final phi = 2 * (varpi - w5);
    final chi = 94.9 * _d - 2.292 * _d * t8;
    final sEta = math.sin(eta), cEta = math.cos(eta);
    final sZeta = math.sin(zeta), cZeta = math.cos(zeta);
    final s2Zeta = math.sin(2 * zeta), c2Zeta = math.cos(2 * zeta);
    final s3Zeta = math.sin(3 * zeta), c3Zeta = math.cos(3 * zeta);
    final sZetaPEta = math.sin(zeta + eta), cZetaPEta = math.cos(zeta + eta);
    final sZetaMEta = math.sin(zeta - eta), cZetaMEta = math.cos(zeta - eta);
    final sPhi = math.sin(phi), cPhi = math.cos(phi);
    final sChi = math.sin(chi);
    final sCs = math.sin(cs_), cCs = math.cos(cs_);

    final a = 24.50601 -
        0.08686 * cEta -
        0.00166 * cZetaPEta +
        0.00175 * cZetaMEta;
    final e = 0.103458 -
        0.004099 * cEta -
        0.000167 * cZetaPEta +
        0.000235 * cZetaMEta +
        0.02303 * cZeta -
        0.00212 * c2Zeta +
        0.000151 * c3Zeta +
        0.00013 * cPhi;
    final p = varpi +
        0.15648 * _d * sChi -
        0.4457 * _d * sEta -
        0.2657 * _d * sZetaPEta -
        0.3573 * _d * sZetaMEta -
        12.872 * _d * sZeta +
        1.668 * _d * s2Zeta -
        0.2419 * _d * s3Zeta -
        0.07 * _d * sPhi;
    final lambdaPrime = 177.047 * _d +
        16.91993829 * _d * t6 +
        0.15648 * _d * sChi +
        9.142 * _d * sEta +
        0.007 * _d * math.sin(2 * eta) -
        0.014 * _d * math.sin(3 * eta) +
        0.2275 * _d * sZetaPEta +
        0.2112 * _d * sZetaMEta -
        0.26 * _d * sZeta -
        0.0098 * _d * s2Zeta -
        0.013 * _d * math.sin(as_) +
        0.017 * _d * math.sin(bs) -
        0.0303 * _d * sPhi;
    final i = 27.3347 * _d +
        0.6434886 * _d * math.cos(chi) +
        0.315 * _d * cW3 +
        0.018 * _d * math.cos(theta) -
        0.018 * _d * cCs;
    final omega = 168.6812 * _d +
        1.40136 * _d * math.cos(chi) +
        0.68599 * _d * sW3 -
        0.0392 * _d * sCs +
        0.0366 * _d * math.sin(thetaPrime);
    return _subr(lambdaPrime, p, e, a, omega, i);
  }

  _R4 iapetusMoon() {
    final ll = 261.1582 * _d + 22.57697855 * _d * t4;
    final varpiPrime = 91.796 * _d + 0.562 * _d * t7;
    final psi = 4.367 * _d - 0.195 * _d * t7;
    final theta = 146.819 * _d - 3.198 * _d * t7;
    final phi = 60.47 * _d + 1.521 * _d * t7;
    final bigPhi = 205.055 * _d - 2.091 * _d * t7;
    final ePrime = 0.028298 + 0.001156 * t11;
    final varpi0 = 352.91 * _d + 11.71 * _d * t11;
    final mu = 76.3852 * _d + 4.53795125 * _d * t10;
    final iPrime = horner(
        t11, [18.4602 * _d, -0.9518 * _d, -0.072 * _d, 0.0054 * _d]);
    final omegaPrime = horner(
        t11, [143.198 * _d, -3.919 * _d, 0.116 * _d, 0.008 * _d]);
    final l = mu - varpi0;
    final g = varpi0 - omegaPrime - psi;
    final g1 = varpi0 - omegaPrime - phi;
    final ls = w5 - varpiPrime;
    final gs = varpiPrime - theta;
    final lT = ll - w4;
    final gT = w4 - bigPhi;
    final u1 = 2 * (l + g - ls - gs);
    final u2 = l + g1 - lT - gT;
    final u3 = l + 2 * (g - ls - gs);
    final u4 = lT + gT - g1;
    final u5 = 2 * (ls + gs);

    final sl = math.sin(l);
    final su1 = math.sin(u1), cu1 = math.cos(u1);
    final su2 = math.sin(u2), cu2 = math.cos(u2);
    final su3 = math.sin(u3), cu3 = math.cos(u3);
    final su4 = math.sin(u4), cu4 = math.cos(u4);
    final slu2 = math.sin(l + u2), clu2 = math.cos(l + u2);
    final sg1gT = math.sin(g1 - gT), cg1gT = math.cos(g1 - gT);
    final su52g = math.sin(u5 - 2 * g), cu52g = math.cos(u5 - 2 * g);
    final su5psi = math.sin(u5 + psi), cu5psi = math.cos(u5 + psi);
    final su2phi = math.sin(u2 + phi), cu2phi = math.cos(u2 + phi);
    final s5 = math.sin(l + g1 + lT + gT + phi);
    final c5 = math.cos(l + g1 + lT + gT + phi);
    final cl = math.cos(l);

    final a = 58.935028 + 0.004638 * cu1 + 0.058222 * cu2;
    final e = ePrime -
        0.0014097 * cg1gT +
        0.0003733 * cu52g +
        0.000118 * cu3 +
        0.0002408 * cl +
        0.0002849 * clu2 +
        0.000619 * cu4;
    final w = 0.08077 * _d * sg1gT +
        0.02139 * _d * su52g -
        0.00676 * _d * su3 +
        0.0138 * _d * sl +
        0.01632 * _d * slu2 +
        0.03547 * _d * su4;
    final p = varpi0 + w / ePrime;
    final lambdaPrime = mu -
        0.04299 * _d * su2 -
        0.00789 * _d * su1 -
        0.06312 * _d * math.sin(ls) -
        0.00295 * _d * math.sin(2 * ls) -
        0.02231 * _d * math.sin(u5) +
        0.0065 * _d * su5psi;
    final i = iPrime +
        0.04204 * _d * cu5psi +
        0.00235 * _d * c5 +
        0.0036 * _d * cu2phi;
    final wPrime = 0.04204 * _d * su5psi +
        0.00235 * _d * s5 +
        0.00358 * _d * su2phi;
    final omega = omegaPrime + wPrime / math.sin(iPrime);
    return _subr(lambdaPrime, p, e, a, omega, i);
  }
}
