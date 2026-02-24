///|
/// Coordinate generation for GRIB2 grids.
/// Generates latitude/longitude arrays from Grid Definition Templates.

///|
/// Generated coordinate grid.
pub(all) struct CoordinateGrid {
  latitudes : Array[Double]
  longitudes : Array[Double]
  ni : Int
  nj : Int
}

///|
/// Scanning mode bit flags (from Code Table 3.4).
/// Bit 1: i direction (0=positive, 1=negative)
/// Bit 2: j direction (0=negative, 1=positive)
/// Bit 3: consecutive points (0=i direction, 1=j direction)
/// Bit 4: rows (0=same direction, 1=opposite directions)
pub(all) struct ScanningMode {
  i_negative : Bool
  j_positive : Bool
  consecutive_j : Bool
  alternating_rows : Bool
}

///|
pub fn parse_scanning_mode(mode : Int) -> ScanningMode {
  {
    i_negative: (mode & 0x80) != 0,
    j_positive: (mode & 0x40) != 0,
    consecutive_j: (mode & 0x20) != 0,
    alternating_rows: (mode & 0x10) != 0,
  }
}

///|
/// Generate lat/lon coordinate arrays from Template 3.0 (Latitude/Longitude).
///
/// Parameters:
/// - grid: Grid template 3.0 data
///
/// Returns array of latitudes and longitudes for each grid point.
/// The arrays are in the order defined by the scanning mode.
pub fn generate_latlon_coordinates(
  grid : Grib2GridTemplate30,
) -> CoordinateGrid {
  let ni = grid.ni
  let nj = grid.nj
  // Calculate basic angle unit
  // If basic_angle is 0 or missing, default to 1/1000000 degrees (microdegrees)
  let angle_unit = if grid.basic_angle == 0 ||
    grid.subdivisions_of_basic_angle == 0 {
    1.0 / 1000000.0 // microdegrees
  } else {
    grid.basic_angle.to_double() /
    grid.subdivisions_of_basic_angle.to_double() /
    1000000.0
  }
  // Convert coordinates from scaled integers to degrees
  let la1 = grid.la1.to_double() * angle_unit
  let lo1 = grid.lo1.to_double() * angle_unit
  let _la2 = grid.la2.to_double() * angle_unit
  let _lo2 = grid.lo2.to_double() * angle_unit
  let di = grid.di.to_double() * angle_unit
  let dj = grid.dj.to_double() * angle_unit
  let scan = parse_scanning_mode(grid.scanning_mode)
  // Calculate increments based on scanning mode
  let di_signed = if scan.i_negative { -di } else { di }
  let dj_signed = if scan.j_positive { dj } else { -dj }
  // Generate coordinates
  let total_points = ni * nj
  let latitudes : Array[Double] = Array::make(total_points, 0.0)
  let longitudes : Array[Double] = Array::make(total_points, 0.0)
  if scan.consecutive_j {
    // Points are consecutive in j direction
    for i = 0; i < ni; i = i + 1 {
      let lon = lo1 + i.to_double() * di_signed
      for j = 0; j < nj; j = j + 1 {
        let lat = la1 + j.to_double() * dj_signed
        let idx = i * nj + j
        latitudes[idx] = lat
        longitudes[idx] = normalize_longitude(lon)
      }
    }
  } else {
    // Points are consecutive in i direction (default)
    for j = 0; j < nj; j = j + 1 {
      let lat = la1 + j.to_double() * dj_signed
      for i = 0; i < ni; i = i + 1 {
        let lon = lo1 + i.to_double() * di_signed
        let idx = j * ni + i
        latitudes[idx] = lat
        longitudes[idx] = normalize_longitude(lon)
      }
    }
  }
  { latitudes, longitudes, ni, nj }
}

///|
/// Normalize longitude to [-180, 180) range.
fn normalize_longitude(lon : Double) -> Double {
  let mut result = lon
  while result >= 180.0 {
    result = result - 360.0
  }
  while result < -180.0 {
    result = result + 360.0
  }
  result
}

///|
/// Get latitude at specific grid point (i, j).
pub fn CoordinateGrid::get_lat(
  self : CoordinateGrid,
  i : Int,
  j : Int,
) -> Double {
  let idx = j * self.ni + i
  self.latitudes[idx]
}

///|
/// Get longitude at specific grid point (i, j).
pub fn CoordinateGrid::get_lon(
  self : CoordinateGrid,
  i : Int,
  j : Int,
) -> Double {
  let idx = j * self.ni + i
  self.longitudes[idx]
}

///|
test "generate_latlon_coordinates basic" {
  // Simple 3x2 grid
  // la1=60N, lo1=0E, la2=58N, lo2=4E, di=2deg, dj=1deg
  let grid : Grib2GridTemplate30 = {
    shape_of_earth: 6,
    scale_factor_radius: 0,
    scaled_value_radius: 0,
    scale_factor_major_axis: 0,
    scaled_value_major_axis: 0,
    scale_factor_minor_axis: 0,
    scaled_value_minor_axis: 0,
    ni: 3,
    nj: 2,
    basic_angle: 0,
    subdivisions_of_basic_angle: 0,
    la1: 60000000, // 60.0 degrees
    lo1: 0, // 0.0 degrees
    resolution_and_component_flags: 48,
    la2: 59000000, // 59.0 degrees
    lo2: 4000000, // 4.0 degrees
    di: 2000000, // 2.0 degrees
    dj: 1000000, // 1.0 degrees
    scanning_mode: 0, // i+, j-, consecutive in i
  }
  let coords = generate_latlon_coordinates(grid)
  inspect(coords.ni, content="3")
  inspect(coords.nj, content="2")
  // First row (j=0): lat=60, lon=0,2,4
  inspect(coords.get_lat(0, 0), content="60")
  inspect(coords.get_lon(0, 0), content="0")
  inspect(coords.get_lon(1, 0), content="2")
  inspect(coords.get_lon(2, 0), content="4")
  // Second row (j=1): lat=59 (j- direction means decreasing lat)
  inspect(coords.get_lat(0, 1), content="59")
}

///|
test "generate_latlon_coordinates j_positive" {
  // Test with j+ scanning mode (latitude increases with j)
  let grid : Grib2GridTemplate30 = {
    shape_of_earth: 6,
    scale_factor_radius: 0,
    scaled_value_radius: 0,
    scale_factor_major_axis: 0,
    scaled_value_major_axis: 0,
    scale_factor_minor_axis: 0,
    scaled_value_minor_axis: 0,
    ni: 2,
    nj: 2,
    basic_angle: 0,
    subdivisions_of_basic_angle: 0,
    la1: 30000000, // 30.0 degrees
    lo1: 100000000, // 100.0 degrees
    resolution_and_component_flags: 48,
    la2: 31000000, // 31.0 degrees
    lo2: 101000000, // 101.0 degrees
    di: 1000000, // 1.0 degrees
    dj: 1000000, // 1.0 degrees
    scanning_mode: 64, // i+, j+, consecutive in i
  }
  let coords = generate_latlon_coordinates(grid)
  // j=0: lat=30, j=1: lat=31 (increasing)
  inspect(coords.get_lat(0, 0), content="30")
  inspect(coords.get_lat(0, 1), content="31")
}

///|
test "normalize_longitude" {
  inspect(normalize_longitude(0.0), content="0")
  inspect(normalize_longitude(180.0), content="-180")
  inspect(normalize_longitude(360.0), content="0")
  inspect(normalize_longitude(-180.0), content="-180")
  inspect(normalize_longitude(-360.0), content="0")
}
