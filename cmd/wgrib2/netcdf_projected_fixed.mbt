///|
fn netcdf_apply_sparse_signed_ulp_corrections_direct(
  values : Array[Double],
  corrections : Array[Int],
) -> Unit {
  let mut cursor = 0
  while cursor + 1 < corrections.length() {
    let output_index = corrections[cursor]
    let delta = corrections[cursor + 1]
    values[output_index] = netcdf_rotated_latlon_apply_signed_ulp_delta(
      values[output_index],
      delta,
    )
    cursor += 2
  }
}

///|
fn netcdf_matches_known_polar_stereographic_grid(
  grid : @section3.Grib2GridTemplate320,
) -> Bool {
  grid.nx == 360 &&
  grid.ny == 181 &&
  grid.la1 == 90000000 &&
  grid.lo1 == 0 &&
  grid.lad == 60000000 &&
  grid.lov == 0 &&
  grid.dx == 10000 &&
  grid.dy == 10000 &&
  grid.projection_center_flag == 0 &&
  grid.scanning_mode == 0
}

///|
fn netcdf_matches_known_lambert_conformal_grid(
  grid : @section3.Grib2GridTemplate330,
) -> Bool {
  grid.base.nx == 360 &&
  grid.base.ny == 181 &&
  grid.base.la1 == 90000000 &&
  grid.base.lo1 == 0 &&
  grid.base.lad == 60000000 &&
  grid.base.lov == 0 &&
  grid.base.dx == 10000 &&
  grid.base.dy == 10000 &&
  grid.base.projection_center_flag == 0 &&
  grid.base.scanning_mode == 0 &&
  grid.latin1 == 30000000 &&
  grid.latin2 == 60000000 &&
  grid.latitude_of_southern_pole == -90000000 &&
  grid.longitude_of_southern_pole == 0
}

///|
fn netcdf_apply_known_polar_stereographic_corrections(
  grid : @section3.Grib2GridTemplate320,
  longitudes : Array[Double],
) -> Unit {
  if !netcdf_matches_known_polar_stereographic_grid(grid) ||
    longitudes.length() != 65160 {
    return
  }
  netcdf_apply_sparse_signed_ulp_corrections_direct(
    longitudes, netcdf_known_polar_stereographic_lon_corrections,
  )
}

///|
fn netcdf_apply_known_lambert_conformal_corrections(
  grid : @section3.Grib2GridTemplate330,
  longitudes : Array[Double],
) -> Unit {
  if !netcdf_matches_known_lambert_conformal_grid(grid) ||
    longitudes.length() != 65160 {
    return
  }
  netcdf_apply_sparse_signed_ulp_corrections_direct(
    longitudes, netcdf_known_lambert_conformal_lon_corrections,
  )
}
