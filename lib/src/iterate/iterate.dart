/// Iteration: Chapter 5, Iteration.
///
/// Provides iterative methods for solving equations.
library;

/// Iterates to a fixed number of decimal places.
///
/// [better] is an improvement function, [start] is the initial guess,
/// [places] is the number of decimal places desired, and [maxIterations]
/// limits the number of iterations.
double decimalPlaces(
  double Function(double) better,
  double start, {
  int places = 8,
  int maxIterations = 50,
}) {
  final d = _pow10(-places);
  for (var i = 0; i < maxIterations; i++) {
    final n = better(start);
    if ((n - start).abs() < d) {
      return n;
    }
    start = n;
  }
  throw StateError('Maximum iterations reached');
}

/// Iterates to (nearly) full float64 precision (15 significant figures).
double fullPrecision(
  double Function(double) better,
  double start, {
  int maxIterations = 50,
}) {
  for (var i = 0; i < maxIterations; i++) {
    final n = better(start);
    if (start != 0 && ((n - start) / start).abs() < 1e-15) {
      return n;
    }
    start = n;
  }
  throw StateError('Maximum iterations reached');
}

/// Finds a root between [lower] and [upper] by binary search.
///
/// A root must exist between the given bounds.
double binaryRoot(
  double Function(double) f,
  double lower,
  double upper,
) {
  var yLower = f(lower);
  var mid = 0.0;
  for (var j = 0; j < 52; j++) {
    mid = (lower + upper) / 2;
    final yMid = f(mid);
    if (yMid == 0) break;
    if (yLower.isNegative == yMid.isNegative) {
      lower = mid;
      yLower = yMid;
    } else {
      upper = mid;
    }
  }
  return mid;
}

double _pow10(int n) {
  var result = 1.0;
  final base = n < 0 ? 0.1 : 10.0;
  final count = n.abs();
  for (var i = 0; i < count; i++) {
    result *= base;
  }
  return result;
}
