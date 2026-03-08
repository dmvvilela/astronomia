/// Ecliptic coordinates referenced to the ecliptic and equinox of date.
class Ecliptic {
  /// Longitude in radians.
  final double lon;

  /// Latitude in radians.
  final double lat;

  const Ecliptic(this.lon, this.lat);

  @override
  String toString() => 'Ecliptic(lon: $lon, lat: $lat)';
}

/// Equatorial coordinates referenced to the equator and equinox of date.
class Equatorial {
  /// Right ascension in radians.
  final double ra;

  /// Declination in radians.
  final double dec;

  const Equatorial(this.ra, this.dec);

  @override
  String toString() => 'Equatorial(ra: $ra, dec: $dec)';
}

/// Horizontal coordinates referenced to the observer's horizon.
class Horizontal {
  /// Azimuth in radians, measured westward from south.
  final double az;

  /// Altitude in radians, positive above horizon.
  final double alt;

  const Horizontal(this.az, this.alt);

  @override
  String toString() => 'Horizontal(az: $az, alt: $alt)';
}

/// Galactic coordinates.
class Galactic {
  /// Longitude in radians.
  final double lon;

  /// Latitude in radians.
  final double lat;

  const Galactic(this.lon, this.lat);

  @override
  String toString() => 'Galactic(lon: $lon, lat: $lat)';
}
