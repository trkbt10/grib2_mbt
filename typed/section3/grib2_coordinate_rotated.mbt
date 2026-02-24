///|
/// Rotated Lat/Lon coordinate generation for GRIB2 Template 3.1.
/// Transforms coordinates from the rotated grid system to geographic coordinates.

// Mathematical constants
let pi : Double = 3.14159265358979323846

///|
let deg_to_rad : Double = 3.14159265358979323846 / 180.0

///|
let rad_to_deg : Double = 180.0 / 3.14159265358979323846

///|
/// Generate lat/lon coordinate arrays from Template 3.1 (Rotated Lat/Lon).
///
/// This function:
/// 1. Generates coordinates in the rotated system using the base template
/// 2. Transforms each point from rotated to geographic coordinates
///
/// Parameters:
/// - grid: Grid template 3.1 data (contains base lat/lon + rotation parameters)
///
/// Returns array of geographic latitudes and longitudes for each grid point.
pub fn generate_rotated_latlon_coordinates(
  grid : Grib2GridTemplate31,
) -> CoordinateGrid {
  // First generate coordinates in the rotated system
  let rotated = generate_latlon_coordinates(grid.base)
  let ni = rotated.ni
  let nj = rotated.nj
  let total_points = ni * nj
  // Parse rotation parameters (microdegrees to degrees)
  let angle_unit = 1.0 / 1000000.0
  let south_pole_lat = grid.latitude_of_southern_pole.to_double() * angle_unit
  let south_pole_lon = grid.longitude_of_southern_pole.to_double() * angle_unit
  let rotation_angle = grid.angle_of_rotation.to_double() * angle_unit
  // Transform each point from rotated to geographic coordinates
  let latitudes : Array[Double] = Array::make(total_points, 0.0)
  let longitudes : Array[Double] = Array::make(total_points, 0.0)
  for i = 0; i < total_points; i = i + 1 {
    let rot_lat = rotated.latitudes[i]
    let rot_lon = rotated.longitudes[i]
    let (geo_lat, geo_lon) = rotate_to_geographic(
      rot_lat, rot_lon, south_pole_lat, south_pole_lon, rotation_angle,
    )
    latitudes[i] = geo_lat
    longitudes[i] = normalize_longitude(geo_lon)
  }
  { latitudes, longitudes, ni, nj }
}

///|
/// Transform coordinates from rotated to geographic coordinate system.
///
/// The rotated coordinate system is defined by placing the south pole
/// of the rotated system at the specified geographic location.
/// Uses the GRIB2/ECMWF standard transformation formula.
///
/// Parameters:
/// - rot_lat: Latitude in rotated system (degrees)
/// - rot_lon: Longitude in rotated system (degrees)
/// - south_pole_lat: Geographic latitude of rotated south pole (degrees)
/// - south_pole_lon: Geographic longitude of rotated south pole (degrees)
/// - rotation_angle: Angle of rotation of the rotated grid (degrees)
///
/// Returns (geographic_lat, geographic_lon) in degrees.
fn rotate_to_geographic(
  rot_lat : Double,
  rot_lon : Double,
  south_pole_lat : Double,
  south_pole_lon : Double,
  rotation_angle : Double,
) -> (Double, Double) {
  // Convert to radians
  let phi_r = rot_lat * deg_to_rad
  let lambda_r = (rot_lon - rotation_angle) * deg_to_rad // Apply rotation angle
  let phi_sp = south_pole_lat * deg_to_rad
  let lambda_sp = south_pole_lon * deg_to_rad
  let sin_phi_sp = sin(phi_sp)
  let cos_phi_sp = cos(phi_sp)
  let sin_phi_r = sin(phi_r)
  let cos_phi_r = cos(phi_r)
  let sin_lambda_r = sin(lambda_r)
  let cos_lambda_r = cos(lambda_r)
  // Geographic latitude:
  // phi = arcsin(cos(phi_sp)*cos(phi_r)*cos(lambda_r) - sin(phi_sp)*sin(phi_r))
  let sin_phi = cos_phi_sp * cos_phi_r * cos_lambda_r - sin_phi_sp * sin_phi_r
  let phi = asin(sin_phi)
  // Geographic longitude:
  // lambda = lambda_sp + atan2(cos(phi_r)*sin(lambda_r),
  //                           -sin(phi_sp)*cos(phi_r)*cos(lambda_r) - cos(phi_sp)*sin(phi_r))
  let x = cos_phi_r * sin_lambda_r
  let y = -sin_phi_sp * cos_phi_r * cos_lambda_r - cos_phi_sp * sin_phi_r
  let lambda = lambda_sp + atan2(x, y)
  // Convert back to degrees
  (phi * rad_to_deg, lambda * rad_to_deg)
}

///|
/// Sine function using Taylor series approximation.
fn sin(x : Double) -> Double {
  // Reduce x to [-pi, pi] range
  let mut angle = x
  while angle > pi {
    angle = angle - 2.0 * pi
  }
  while angle < -pi {
    angle = angle + 2.0 * pi
  }
  // Taylor series: sin(x) = x - x^3/3! + x^5/5! - x^7/7! + ...
  let x2 = angle * angle
  let x3 = x2 * angle
  let x5 = x3 * x2
  let x7 = x5 * x2
  let x9 = x7 * x2
  let x11 = x9 * x2
  let x13 = x11 * x2
  let x15 = x13 * x2
  angle -
  x3 / 6.0 +
  x5 / 120.0 -
  x7 / 5040.0 +
  x9 / 362880.0 -
  x11 / 39916800.0 +
  x13 / 6227020800.0 -
  x15 / 1307674368000.0
}

///|
/// Cosine function using Taylor series approximation.
fn cos(x : Double) -> Double {
  // cos(x) = sin(x + pi/2)
  sin(x + pi / 2.0)
}

///|
/// Arcsine function using Newton's method approximation.
fn asin(x : Double) -> Double {
  // Handle edge cases
  if x >= 1.0 {
    return pi / 2.0
  }
  if x <= -1.0 {
    return -pi / 2.0
  }
  // Use atan2 identity: asin(x) = atan2(x, sqrt(1-x^2))
  atan2(x, sqrt(1.0 - x * x))
}

///|
/// Two-argument arctangent function.
fn atan2(y : Double, x : Double) -> Double {
  // Handle special cases
  if x == 0.0 {
    if y > 0.0 {
      return pi / 2.0
    }
    if y < 0.0 {
      return -pi / 2.0
    }
    return 0.0
  }
  let result = atan(y / x)
  if x < 0.0 {
    if y >= 0.0 {
      return result + pi
    } else {
      return result - pi
    }
  }
  result
}

///|
/// Arctangent function using range reduction and polynomial approximation.
fn atan(x : Double) -> Double {
  // For large |x|, use atan(x) = sign(x) * pi/2 - atan(1/x)
  if x > 1.0 {
    return pi / 2.0 - atan(1.0 / x)
  }
  if x < -1.0 {
    return -pi / 2.0 - atan(1.0 / x)
  }
  // For better convergence near |x| = 1, use:
  // atan(x) = atan(c) + atan((x-c)/(1+x*c)) where c = tan(pi/8) ≈ 0.4142
  // This reduces the argument to a smaller value for faster convergence
  if x > 0.4142 {
    // Use identity: atan(x) = pi/4 + atan((x-1)/(x+1))
    let u = (x - 1.0) / (x + 1.0)
    return pi / 4.0 + atan_small(u)
  }
  if x < -0.4142 {
    let u = (x + 1.0) / (x - 1.0)
    return -pi / 4.0 + atan_small(u)
  }
  atan_small(x)
}

///|
/// Arctangent for small arguments |x| < 0.5 using Taylor series.
fn atan_small(x : Double) -> Double {
  // Taylor series converges well for |x| < 0.5
  // atan(x) = x - x^3/3 + x^5/5 - x^7/7 + ...
  let x2 = x * x
  let x3 = x2 * x
  let x5 = x3 * x2
  let x7 = x5 * x2
  let x9 = x7 * x2
  let x11 = x9 * x2
  let x13 = x11 * x2
  let x15 = x13 * x2
  let x17 = x15 * x2
  let x19 = x17 * x2
  x -
  x3 / 3.0 +
  x5 / 5.0 -
  x7 / 7.0 +
  x9 / 9.0 -
  x11 / 11.0 +
  x13 / 13.0 -
  x15 / 15.0 +
  x17 / 17.0 -
  x19 / 19.0
}

///|
/// Square root using Newton-Raphson method.
fn sqrt(x : Double) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  // Initial guess
  let mut guess = x / 2.0
  if guess == 0.0 {
    guess = 1.0
  }
  // Newton-Raphson iterations
  for _i = 0; _i < 20; _i = _i + 1 {
    guess = (guess + x / guess) / 2.0
  }
  guess
}

///|
test "sin cos basic" {
  // sin(0) = 0, cos(0) = 1
  let s0 = sin(0.0)
  let c0 = cos(0.0)
  inspect(s0 < 0.0001 && s0 > -0.0001, content="true")
  inspect(c0 > 0.9999 && c0 < 1.0001, content="true")
}

///|
test "sin cos pi/2" {
  // sin(pi/2) = 1, cos(pi/2) = 0
  let s90 = sin(pi / 2.0)
  let c90 = cos(pi / 2.0)
  inspect(s90 > 0.9999 && s90 < 1.0001, content="true")
  inspect(c90 < 0.0001 && c90 > -0.0001, content="true")
}

///|
test "rotate identity debug" {
  // Debug sin/cos/asin functions
  // sin(45°) should be ~0.7071
  let sin_45 = sin(45.0 * deg_to_rad)
  inspect(sin_45 > 0.707 && sin_45 < 0.708, content="true")
  // asin(sin(45°)) should give back 45° = 0.7854 rad
  let asin_result = asin(sin_45)
  let expected_rad = 45.0 * deg_to_rad // 0.7853981...
  let diff = if asin_result > expected_rad {
    asin_result - expected_rad
  } else {
    expected_rad - asin_result
  }
  inspect(diff < 0.0001, content="true") // Should be very close
  // Convert back to degrees
  let back_to_deg = asin_result * rad_to_deg
  inspect(back_to_deg > 44.99 && back_to_deg < 45.01, content="true")
}

///|
test "rotate identity" {
  // When south pole is at actual south pole (-90, 0) and no rotation,
  // coordinates should be unchanged
  let (lat, lon) = rotate_to_geographic(
    45.0, 10.0, // rotated coords
     -90.0, 0.0, // south pole at south pole
     0.0, // no rotation
  )
  // Should be approximately (45, 10) with small numerical error
  let lat_ok = lat > 44.99 && lat < 45.01
  let lon_ok = lon > 9.99 && lon < 10.01
  inspect(lat_ok, content="true")
  inspect(lon_ok, content="true")
}
