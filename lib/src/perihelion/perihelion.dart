/// Perihelion: Chapter 38, Planets in Perihelion and Aphelion.
///
/// Approximate functions only. Precise versions require VSOP87.
library;

import 'dart:math' as math;

import '../base/math.dart';

const int mercury = 0;
const int venus = 1;
const int earth = 2;
const int mars = 3;
const int jupiter = 4;
const int saturn = 5;
const int uranus = 6;
const int neptune = 7;
const int emBary = 8;

/// Approximate JDE of perihelion nearest decimal [year] for planet [p].
double perihelion(int p, double year) => _ap(p, year, false);

/// Approximate JDE of aphelion nearest decimal [year] for planet [p].
double aphelion(int p, double year) => _ap(p, year, true);

double _ap(int p, double year, bool aph) {
  var i = p;
  if (i == emBary) i = earth;
  final k = aph
      ? _ka[i].a * (year - _ka[i].b) - 0.5 + 1 // floor + 0.5
      : (_ka[i].a * (year - _ka[i].b) + 0.5).floorToDouble();
  final kk = aph
      ? ((_ka[i].a * (year - _ka[i].b)).floorToDouble() + 0.5)
      : ((_ka[i].a * (year - _ka[i].b) + 0.5).floorToDouble());
  var j = horner(kk, _c[i]);
  if (p == earth) {
    final cc = aph ? _ea : _ep;
    for (var ii = 0; ii < 5; ii++) {
      j += cc[ii] * math.sin((_ec[ii].a + _ec[ii].b * kk) * math.pi / 180);
    }
  }
  return j;
}

class _Ab {
  final double a, b;
  const _Ab(this.a, this.b);
}

const _ka = <_Ab>[
  _Ab(4.15201, 2000.12),
  _Ab(1.62549, 2000.53),
  _Ab(0.99997, 2000.01),
  _Ab(0.53166, 2001.78),
  _Ab(0.0843, 2011.2),
  _Ab(0.03393, 2003.52),
  _Ab(0.0119, 2051.1),
  _Ab(0.00607, 2047.5),
];

const _c = <List<double>>[
  [2451590.257, 87.96934963],
  [2451738.233, 224.7008188, -0.0000000327],
  [2451547.507, 365.2596358, 0.0000000156],
  [2452195.026, 686.9957857, -0.0000001187],
  [2455636.936, 4332.897065, 0.0001367],
  [2452830.12, 10764.21676, 0.000827],
  [2470213.5, 30694.8767, -0.00541],
  [2468895.1, 60190.33, 0.03429],
];

const _ec = <_Ab>[
  _Ab(328.41, 132.788585),
  _Ab(316.13, 584.903153),
  _Ab(346.2, 450.380738),
  _Ab(136.95, 659.306737),
  _Ab(249.52, 329.653368),
];

const _ep = <double>[1.278, -0.055, -0.091, -0.056, -0.045];
const _ea = <double>[-1.352, 0.061, 0.062, 0.029, 0.031];
