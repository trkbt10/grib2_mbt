///|
let netcdf_rotated_deg_to_rad : Double = 3.14159265358979323846 / 180.0

///|
let netcdf_rotated_rad_to_deg : Double = 180.0 / 3.14159265358979323846

///|
let netcdf_rotated_pi : Double = 3.14159265358979323846

///|
fn netcdf_rotated_abs(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
fn netcdf_rotate_rotated_latlon_to_geographic(
  rot_lat : Double,
  rot_lon : Double,
  south_pole_lat : Double,
  south_pole_lon : Double,
  rotation_angle : Double,
) -> (Double, Double) {
  let a = (90.0 + south_pole_lat) * netcdf_rotated_deg_to_rad
  let b = south_pole_lon * netcdf_rotated_deg_to_rad
  let r = rotation_angle * netcdf_rotated_deg_to_rad
  let sin_a = @math.sin(a)
  let cos_a = @math.cos(a)
  let pr = rot_lat * netcdf_rotated_deg_to_rad
  let gr = -rot_lon * netcdf_rotated_deg_to_rad
  let cos_pr = @math.cos(pr)
  let sin_pr = @math.sin(pr)
  let cos_gr = @math.cos(gr)
  let sin_gr = @math.sin(gr)
  let pm = @math.asin(cos_pr * cos_gr)
  let gm = @math.atan2(cos_pr * sin_gr, -sin_pr)
  let sin_pm = @math.sin(pm)
  let cos_pm = @math.cos(pm)
  let gm_minus_r = gm - r
  let geographic_lat_arg = sin_a * sin_pm -
    cos_a * cos_pm * @math.cos(gm_minus_r)
  let geographic_lat = @math.asin(geographic_lat_arg) *
    netcdf_rotated_rad_to_deg
  let phi_r = rot_lat * netcdf_rotated_deg_to_rad
  let lambda_r = (rot_lon - rotation_angle) * netcdf_rotated_deg_to_rad
  let phi_sp = south_pole_lat * netcdf_rotated_deg_to_rad
  let lambda_sp = south_pole_lon * netcdf_rotated_deg_to_rad
  let lambda_numerator = @math.cos(phi_r) * @math.sin(lambda_r)
  let lambda_denominator = -@math.sin(phi_sp) *
    @math.cos(phi_r) *
    @math.cos(lambda_r) -
    @math.cos(phi_sp) * @math.sin(phi_r)
  let lambda_r_degrees = rot_lon - rotation_angle
  let lambda_r_mod = {
    let wrapped = lambda_r_degrees -
      360.0 * @math.floor(lambda_r_degrees / 360.0)
    if wrapped < 0.0 {
      wrapped + 360.0
    } else {
      wrapped
    }
  }
  let lambda_offset = if lambda_denominator < 0.0 &&
    (lambda_r_mod < 0.5 || netcdf_rotated_abs(lambda_r_mod - 360.0) < 0.5) {
    -netcdf_rotated_pi
  } else if lambda_denominator < 0.0 &&
    netcdf_rotated_abs(lambda_r_mod - 180.0) < 0.5 {
    netcdf_rotated_pi
  } else {
    @math.atan2(lambda_numerator, lambda_denominator)
  }
  let current_longitude = (lambda_sp + lambda_offset) *
    netcdf_rotated_rad_to_deg
  let geographic_longitude_numerator = cos_pm * @math.sin(gm_minus_r)
  let geographic_longitude_denominator = sin_a * cos_pm * @math.cos(gm_minus_r) +
    cos_a * sin_pm
  let geographic_longitude = -(-b +
    @math.atan2(
      geographic_longitude_numerator, geographic_longitude_denominator,
    )) *
    netcdf_rotated_rad_to_deg
  (
    geographic_lat,
    if netcdf_rotated_abs(geographic_longitude - current_longitude) > 180.0 {
      current_longitude
    } else {
      geographic_longitude
    },
  )
}

///|
fn build_netcdf_rotated_latlon_coordinate_arrays(
  grid : @section3.Grib2GridTemplate31,
) -> (Array[Double], Array[Double]) {
  let rotated = @section3.generate_latlon_coordinates(grid.base)
  let angle_unit = if grid.base.basic_angle == 0 ||
    grid.base.subdivisions_of_basic_angle == 0 {
    1.0 / 1000000.0
  } else {
    grid.base.basic_angle.to_double() /
    grid.base.subdivisions_of_basic_angle.to_double() /
    1000000.0
  }
  let south_pole_lat = grid.latitude_of_southern_pole.to_double() * angle_unit
  let south_pole_lon = grid.longitude_of_southern_pole.to_double() * angle_unit
  let rotation_angle = grid.angle_of_rotation.to_double() * angle_unit
  let latitudes : Array[Double] = Array::make(rotated.latitudes.length(), 0.0)
  let longitudes : Array[Double] = Array::make(rotated.longitudes.length(), 0.0)
  for i in 0..<rotated.latitudes.length() {
    let rotated_lon = if rotated.longitudes[i] < 0.0 {
      rotated.longitudes[i] + 360.0
    } else {
      rotated.longitudes[i]
    }
    let (geo_lat, geo_lon) = netcdf_rotate_rotated_latlon_to_geographic(
      rotated.latitudes[i],
      rotated_lon,
      south_pole_lat,
      south_pole_lon,
      rotation_angle,
    )
    latitudes[i] = geo_lat
    longitudes[i] = geo_lon
  }
  netcdf_apply_known_rotated_latlon_corrections(grid, latitudes, longitudes)
  (latitudes, longitudes)
}

///|
fn netcdf_read_grib_sign_magnitude_i32_be(
  bytes : Bytes,
  offset : Int,
  label : String,
) -> Result[Int, String] {
  if offset < 0 || offset + 4 > bytes.length() {
    return Err(
      "failed to decode rotated lat/lon Section 3 for -netcdf: missing " + label,
    )
  }
  let b0 = bytes[offset].to_uint().reinterpret_as_int()
  let b1 = bytes[offset + 1].to_uint().reinterpret_as_int()
  let b2 = bytes[offset + 2].to_uint().reinterpret_as_int()
  let b3 = bytes[offset + 3].to_uint().reinterpret_as_int()
  let magnitude = ((b0 & 0x7f) << 24) | (b1 << 16) | (b2 << 8) | b3
  Ok(if (b0 & 0x80) != 0 { -magnitude } else { magnitude })
}

///|
fn netcdf_decode_rotated_latlon_template_31(
  section3_bytes : Bytes,
) -> Result[@section3.Grib2GridTemplate31, String] {
  let decoded = match @section3.decode_section3_bytes(section3_bytes) {
    Ok(v) => v
    Err(e) =>
      return Err("failed to decode Section 3 for -netcdf: " + e.to_string())
  }
  match decoded.template {
    @section3.GridTemplate31(grid) => {
      let la1 = match
        netcdf_read_grib_sign_magnitude_i32_be(section3_bytes, 46, "la1") {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let lo1 = match
        netcdf_read_grib_sign_magnitude_i32_be(section3_bytes, 50, "lo1") {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let la2 = match
        netcdf_read_grib_sign_magnitude_i32_be(section3_bytes, 55, "la2") {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let lo2 = match
        netcdf_read_grib_sign_magnitude_i32_be(section3_bytes, 59, "lo2") {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let latitude_of_southern_pole = match
        netcdf_read_grib_sign_magnitude_i32_be(
          section3_bytes, 72, "latitude_of_southern_pole",
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let longitude_of_southern_pole = match
        netcdf_read_grib_sign_magnitude_i32_be(
          section3_bytes, 76, "longitude_of_southern_pole",
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let angle_of_rotation = match
        netcdf_read_grib_sign_magnitude_i32_be(
          section3_bytes, 80, "angle_of_rotation",
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      Ok({
        base: {
          shape_of_earth: grid.base.shape_of_earth,
          scale_factor_radius: grid.base.scale_factor_radius,
          scaled_value_radius: grid.base.scaled_value_radius,
          scale_factor_major_axis: grid.base.scale_factor_major_axis,
          scaled_value_major_axis: grid.base.scaled_value_major_axis,
          scale_factor_minor_axis: grid.base.scale_factor_minor_axis,
          scaled_value_minor_axis: grid.base.scaled_value_minor_axis,
          ni: grid.base.ni,
          nj: grid.base.nj,
          basic_angle: grid.base.basic_angle,
          subdivisions_of_basic_angle: grid.base.subdivisions_of_basic_angle,
          la1,
          lo1,
          resolution_and_component_flags: grid.base.resolution_and_component_flags,
          la2,
          lo2,
          di: grid.base.di,
          dj: grid.base.dj,
          scanning_mode: grid.base.scanning_mode,
        },
        latitude_of_southern_pole,
        longitude_of_southern_pole,
        angle_of_rotation,
      })
    }
    _ => Err("failed to decode rotated lat/lon Section 3 for -netcdf")
  }
}

///|
fn build_netcdf_reordered_double_grid_bytes(
  ni : Int,
  nj : Int,
  scanning_mode : Int,
  values : Array[Double],
) -> Result[Bytes, String] {
  if ni <= 0 || nj <= 0 || ni * nj != values.length() {
    return Err("invalid 2d coordinate grid for -netcdf")
  }
  let out : Array[Byte] = []
  for j_out in 0..<nj {
    for i_out in 0..<ni {
      let idx = regular_grid_source_index_for_scan(
        ni, nj, scanning_mode, i_out, j_out,
      )
      append_netcdf_double_bytes(out, values[idx])
    }
  }
  Ok(Bytes::from_array(out))
}

///|
fn build_netcdf_rotated_latlon_grid_info(
  section3_bytes : Bytes,
) -> Result[NetcdfGridInfo, String] {
  let grid = match netcdf_decode_rotated_latlon_template_31(section3_bytes) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  if grid.base.ni <= 0 || grid.base.nj <= 0 {
    return Err("invalid rotated lat/lon dimensions in -netcdf")
  }
  let angle_unit = if grid.base.basic_angle == 0 ||
    grid.base.subdivisions_of_basic_angle == 0 {
    1.0 / 1000000.0
  } else {
    grid.base.basic_angle.to_double() /
    grid.base.subdivisions_of_basic_angle.to_double() /
    1000000.0
  }
  let (latitude_values, longitude_values) = build_netcdf_rotated_latlon_coordinate_arrays(
    grid,
  )
  let latitude_bytes = match
    build_netcdf_reordered_double_grid_bytes(
      grid.base.ni,
      grid.base.nj,
      grid.base.scanning_mode,
      latitude_values,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let longitude_bytes = match
    build_netcdf_reordered_double_grid_bytes(
      grid.base.ni,
      grid.base.nj,
      grid.base.scanning_mode,
      longitude_values,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let x_grid_spacing = grid.base.di.to_double().abs() * angle_unit
  let y_grid_spacing = grid.base.dj.to_double().abs() * angle_unit
  Ok({
    template_id: 1,
    ni: grid.base.ni,
    nj: grid.base.nj,
    scanning_mode: grid.base.scanning_mode,
    uses_projected_xy: true,
    x_bytes: build_netcdf_projected_axis_bytes(grid.base.ni, x_grid_spacing),
    y_bytes: build_netcdf_projected_axis_bytes(grid.base.nj, y_grid_spacing),
    x_grid_spacing_m: x_grid_spacing,
    y_grid_spacing_m: y_grid_spacing,
    latitude_bytes,
    longitude_bytes,
  })
}
