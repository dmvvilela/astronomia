/// Planetary: Chapter 36, The Calculation of some Planetary Phenomena.
library;

import 'dart:math' as math;

import '../base/math.dart';
import '../julian/julian.dart';

// --- internal helpers ---

({double j, double m, double t}) _meanParts(double y, _Ca a) {
  final kk = (365.2425 * y + 1721060 - a.a) / a.b + 0.5;
  final k = kk.floorToDouble();
  final j = a.a + k * a.b;
  final m = pMod(a.m0 + k * a.m1, 360) * math.pi / 180;
  final t = j2000Century(j);
  return (j: j, m: m, t: t);
}

double _sum(double t, double m, List<List<double>> c) {
  var j = horner(t, c[0]);
  var mm = 0.0;
  var i = 1;
  while (i < c.length) {
    mm += m;
    j += math.sin(mm) * horner(t, c[i]);
    i++;
    j += math.cos(mm) * horner(t, c[i]);
    i++;
  }
  return j;
}

double _ms(double y, _Ca a, List<List<double>> c) {
  final p = _meanParts(y, a);
  return p.j + _sum(p.t, p.m, c);
}

double _sumA(double t, double m, List<List<double>> c, List<_Caa> aa) {
  final split = c.length - 2 * aa.length;
  var j = _sum(t, m, c.sublist(0, split));
  var i = split;
  for (var k = 0; k < aa.length; k++) {
    final angle = (aa[k].c + aa[k].f * t) * math.pi / 180;
    j += math.sin(angle) * horner(t, c[i]);
    i++;
    j += math.cos(angle) * horner(t, c[i]);
    i++;
  }
  return j;
}

double _msa(double y, _Ca a, List<List<double>> c, List<_Caa> aa) {
  final p = _meanParts(y, a);
  return p.j + _sumA(p.t, p.m, c, aa);
}

// --- public API ---

/// JDE of inferior conjunction of Mercury nearest decimal [year].
double mercuryInfConj(double year) => _ms(year, _micA, _micB);

/// JDE of superior conjunction of Mercury nearest decimal [year].
double mercurySupConj(double year) => _ms(year, _mscA, _mscB);

/// JDE of inferior conjunction of Venus nearest decimal [year].
double venusInfConj(double year) => _ms(year, _vicA, _vicB);

/// JDE of opposition of Mars nearest decimal [year].
double marsOpp(double year) => _ms(year, _moA, _moB);

/// JDE of opposition of Jupiter nearest decimal [year].
double jupiterOpp(double year) => _msa(year, _joA, _joB, _jaa);

/// JDE of opposition of Saturn nearest decimal [year].
double saturnOpp(double year) => _msa(year, _soA, _soB, _saa);

/// JDE of conjunction of Saturn nearest decimal [year].
double saturnConj(double year) => _msa(year, _scA, _scB, _saa);

/// JDE of opposition of Uranus nearest decimal [year].
double uranusOpp(double year) => _msa(year, _uoA, _uoB, _uaa);

/// JDE of opposition of Neptune nearest decimal [year].
double neptuneOpp(double year) => _msa(year, _noA, _noB, _naa);

/// JDE and elongation (radians) of greatest eastern elongation of Mercury.
({double jde, double elongation}) mercuryEastElongation(double year) {
  return _el(year, _micA, _met, _mee);
}

/// JDE and elongation (radians) of greatest western elongation of Mercury.
({double jde, double elongation}) mercuryWestElongation(double year) {
  return _el(year, _micA, _mwt, _mwe);
}

({double jde, double elongation}) _el(
    double year, _Ca a, List<List<double>> tc, List<List<double>> ec) {
  final p = _meanParts(year, a);
  return (
    jde: p.j + _sum(p.t, p.m, tc),
    elongation: toRad(_sum(p.t, p.m, ec)),
  );
}

/// JDE of second station of Mars nearest decimal [year].
double marsStation2(double year) {
  final p = _meanParts(year, _moA);
  return p.j + _sum(p.t, p.m, _ms2);
}

// --- data types ---

class _Ca {
  final double a, b, m0, m1;
  const _Ca(this.a, this.b, this.m0, this.m1);
}

class _Caa {
  final double c, f;
  const _Caa(this.c, this.f);
}

// --- Table 36.A, p. 250 ---

const _micA = _Ca(2451612.023, 115.8774771, 63.5867, 114.2088742);
const _mscA = _Ca(2451554.084, 115.8774771, 6.4822, 114.2088742);
const _vicA = _Ca(2451996.706, 583.921361, 82.7311, 215.513058);
const _moA = _Ca(2452097.382, 779.936104, 181.9573, 48.705244);
const _joA = _Ca(2451870.628, 398.884046, 318.4681, 33.140229);
const _soA = _Ca(2451870.17, 378.091904, 318.0172, 12.647487);
const _scA = _Ca(2451681.124, 378.091904, 131.6934, 12.647487);
const _uoA = _Ca(2451764.317, 369.656035, 213.6884, 4.333093);
const _noA = _Ca(2451753.122, 367.486703, 202.6544, 2.194998);

// Additional angles
const _jaa = [_Caa(82.74, 40.76)];
const _saa = [_Caa(82.74, 40.76), _Caa(29.86, 1181.36), _Caa(14.13, 590.68), _Caa(220.02, 1262.87)];
const _uaa = [_Caa(207.83, 8.51), _Caa(108.84, 419.96)];
const _naa = [_Caa(207.83, 8.51), _Caa(276.74, 209.98)];

// --- Table 36.B ---

const _micB = <List<double>>[
  [.0545, .0002],
  [-6.2008, .0074, .00003],
  [-3.275, -.0197, .00001],
  [.4737, -.0052, -.00001],
  [.8111, .0033, -.00002],
  [.0037, .0018],
  [-.1768, 0, .00001],
  [-.0211, -.0004],
  [.0326, -.0003],
  [.0083, .0001],
  [-.004, .0001],
];

const _mscB = <List<double>>[
  [-.0548, -.0002],
  [7.3894, -.01, -.00003],
  [3.22, .0197, -.00001],
  [.8383, -.0064, -.00001],
  [.9666, .0039, -.00003],
  [.077, -.0026],
  [.2758, .0002, -.00002],
  [-.0128, -.0008],
  [.0734, -.0004, -.00001],
  [-.0122, -.0002],
  [.0173, -.0002],
];

const _vicB = <List<double>>[
  [-.0096, .0002, -.00001],
  [2.0009, -.0033, -.00001],
  [.598, -.0104, .00001],
  [.0967, -.0018, -.00003],
  [.0913, .0009, -.00002],
  [.0046, -.0002],
  [.0079, .0001],
];

const _moB = <List<double>>[
  [-.3088, 0, .00002],
  [-17.6965, .0363, .00005],
  [18.3131, .0467, -.00006],
  [-.2162, -.0198, -.00001],
  [-4.5028, -.0019, .00007],
  [.8987, .0058, -.00002],
  [.7666, -.005, -.00003],
  [-.3636, -.0001, .00002],
  [.0402, .0032],
  [.0737, -.0008],
  [-.098, -.0011],
];

const _joB = <List<double>>[
  [-.1029, 0, -.00009],
  [-1.9658, -.0056, .00007],
  [6.1537, .021, -.00006],
  [-.2081, -.0013],
  [-.1116, -.001],
  [.0074, .0001],
  [-.0097, -.0001],
  [0, .0144, -.00008],
  [.3642, -.0019, -.00029],
];

const _soB = <List<double>>[
  [-.0209, .0006, .00023],
  [4.5795, -.0312, -.00017],
  [1.1462, -.0351, .00011],
  [.0985, -.0015],
  [.0733, -.0031, .00001],
  [.0025, -.0001],
  [.005, -.0002],
  [0, -.0337, .00018],
  [-.851, .0044, .00068],
  [0, -.0064, .00004],
  [.2397, -.0012, -.00008],
  [0, -.001],
  [.1245, .0006],
  [0, .0024, -.00003],
  [.0477, -.0005, -.00006],
];

const _scB = <List<double>>[
  [.0172, -.0006, .00023],
  [-8.5885, .0411, .00020],
  [-1.147, .0352, -.00011],
  [.3331, -.0034, -.00001],
  [.1145, -.0045, .00002],
  [-.0169, .0002],
  [-.0109, .0004],
  [0, -.0337, .00018],
  [-.851, .0044, .00068],
  [0, -.0064, .00004],
  [.2397, -.0012, -.00008],
  [0, -.001],
  [.1245, .0006],
  [0, .0024, -.00003],
  [.0477, -.0005, -.00006],
];

const _uoB = <List<double>>[
  [.0844, -.0006],
  [-.1048, .0246],
  [-5.1221, .0104, .00003],
  [-.1428, .0005],
  [-.0148, -.0013],
  [0],
  [.0055],
  [0],
  [.885],
  [0],
  [.2153],
];

const _noB = <List<double>>[
  [-.014, 0, .00001],
  [-1.3486, .001, .00001],
  [.8597, 0.0037],
  [-.0082, -.0002, .00001],
  [.0037, -.0003],
  [0],
  [-.5964],
  [0],
  [.0728],
];

// --- Table 36.C ---

const _met = <List<double>>[
  [-21.6106, .0002],
  [-1.9803, -.006, .00001],
  [1.4151, -.0072, -.00001],
  [.5528, -.0005, -.00001],
  [.2905, .0034, .00001],
  [-.1121, -.0001, .00001],
  [-.0098, -.0015],
  [.0192],
  [.0111, .0004],
  [-.0061],
  [-.0032, -.0001],
];

const _mee = <List<double>>[
  [22.4697],
  [-4.2666, .0054, .00002],
  [-1.8537, -.0137],
  [.3598, .0008, -.00001],
  [-.068, .0026],
  [-.0524, -.0003],
  [.0052, -.0006],
  [.0107, .0001],
  [-.0013, .0001],
  [-.0021],
  [.0003],
];

const _mwt = <List<double>>[
  [21.6249, -.0002],
  [.1306, .0065],
  [-2.7661, -.0011, .00001],
  [.2438, -.0024, -.00001],
  [.5767, .0023],
  [.1041],
  [-.0184, .0007],
  [-.0051, -.0001],
  [.0048, .0001],
  [.0026],
  [.0037],
];

const _mwe = <List<double>>[
  [22.4143, -.0001],
  [4.3651, -.0048, -.00002],
  [2.3787, .0121, -.00001],
  [.2674, .0022],
  [-.3873, .0008, .00001],
  [-.0369, -.0001],
  [.0017, -.0001],
  [.0059],
  [.0061, .0001],
  [.0007],
  [-.0011],
];

// --- Table 36.D ---

const _ms2 = <List<double>>[
  [36.7191, .0016, .00003],
  [-12.6163, .0417, -.00001],
  [20.1218, .0379, -.00006],
  [-1.636, -.019],
  [-3.9657, .0045, .00007],
  [1.1546, .0029, -.00003],
  [.2888, -.0073, -.00002],
  [-.3128, .0017, .00002],
  [.2513, .0026, -.00002],
  [-.0021, -.0016],
  [-.1497, -.0006],
];
