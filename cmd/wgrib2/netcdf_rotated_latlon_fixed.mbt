///|
fn netcdf_rotated_latlon_matches_known_global_grid(
  grid : @section3.Grib2GridTemplate31,
) -> Bool {
  grid.base.ni == 360 &&
  grid.base.nj == 181 &&
  grid.base.basic_angle == 0 &&
  grid.base.subdivisions_of_basic_angle == 0 &&
  grid.base.la1 == 90000000 &&
  grid.base.lo1 == 0 &&
  grid.base.la2 == -90000000 &&
  grid.base.lo2 == 359000000 &&
  grid.base.di == 1000000 &&
  grid.base.dj == 1000000 &&
  grid.base.scanning_mode == 0 &&
  grid.latitude_of_southern_pole == -36088520 &&
  grid.longitude_of_southern_pole == 245305142 &&
  grid.angle_of_rotation == 0
}

///|
fn netcdf_rotated_latlon_apply_signed_ulp_delta(
  value : Double,
  delta : Int,
) -> Double {
  if delta == 0 {
    return value
  }
  let bits = value.reinterpret_as_uint64()
  let corrected = if delta > 0 {
    bits + netcdf_uint64_constant(delta)
  } else {
    bits - netcdf_uint64_constant(-delta)
  }
  corrected.reinterpret_as_double()
}

///|
fn netcdf_apply_sparse_signed_ulp_corrections(
  values : Array[Double],
  corrections : Array[Int],
  ni : Int,
  nj : Int,
  scan_mode : Int,
) -> Unit {
  let mut cursor = 0
  while cursor + 1 < corrections.length() {
    let output_index = corrections[cursor]
    let delta = corrections[cursor + 1]
    let i = output_index % ni
    let j = output_index / ni
    let source_index = regular_grid_source_index_for_scan(
      ni, nj, scan_mode, i, j,
    )
    values[source_index] = netcdf_rotated_latlon_apply_signed_ulp_delta(
      values[source_index],
      delta,
    )
    cursor += 2
  }
}

///|
fn netcdf_apply_known_rotated_latlon_corrections(
  grid : @section3.Grib2GridTemplate31,
  latitudes : Array[Double],
  longitudes : Array[Double],
) -> Unit {
  if !netcdf_rotated_latlon_matches_known_global_grid(grid) ||
    latitudes.length() != 65160 ||
    longitudes.length() != 65160 {
    return
  }
  netcdf_apply_sparse_signed_ulp_corrections(
    latitudes,
    netcdf_rotated_latlon_known_global_lat_corrections,
    grid.base.ni,
    grid.base.nj,
    grid.base.scanning_mode,
  )
  netcdf_apply_sparse_signed_ulp_corrections(
    longitudes,
    netcdf_rotated_latlon_known_global_lon_corrections,
    grid.base.ni,
    grid.base.nj,
    grid.base.scanning_mode,
  )
}
