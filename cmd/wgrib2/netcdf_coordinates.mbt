///|
fn build_netcdf_latitude_values(
  meta : @decode.Grib2RecordMeta,
) -> Result[Array[Double], String] {
  let values : Array[Double] = []
  let scan = meta.section3_scanning_mode
  let units = 0.000001
  let lat1 = meta.section3_lat1_microdeg.to_double() * units
  let lat2 = meta.section3_lat2_microdeg.to_double() * units
  let south_lat = if (scan & 0x40) != 0 { lat1 } else { lat2 }
  let north_lat = if (scan & 0x40) != 0 { lat2 } else { lat1 }
  let dy = if meta.section3_nj > 1 {
    ((north_lat - south_lat) / (meta.section3_nj - 1).to_double()).abs()
  } else {
    0.0
  }
  let y0 = if (scan & 0x40) != 0 {
    0.0
  } else {
    1.0 - meta.section3_nj.to_double()
  }
  for iy in 0..<meta.section3_nj {
    values.push(netcdf_fma(y0 + iy.to_double(), dy, lat1))
  }
  Ok(values)
}

///|
fn build_netcdf_longitude_values(
  meta : @decode.Grib2RecordMeta,
) -> Result[Array[Double], String] {
  let values : Array[Double] = []
  let scan = meta.section3_scanning_mode
  let units = 0.000001
  let lon1 = meta.section3_lon1_microdeg.to_double() * units
  let lon2 = meta.section3_lon2_microdeg.to_double() * units
  let mut west_lon = if (scan & 0x80) == 0 { lon1 } else { lon2 }
  let mut east_lon = if (scan & 0x80) == 0 { lon2 } else { lon1 }
  if east_lon <= west_lon {
    east_lon += 360.0
  }
  if east_lon - west_lon > 360.0 {
    east_lon -= 360.0
  }
  if west_lon < 0.0 {
    west_lon += 360.0
    east_lon += 360.0
  }
  let dx = if meta.section3_ni > 1 {
    ((east_lon - west_lon) / (meta.section3_ni - 1).to_double()).abs()
  } else {
    0.0
  }
  let x0 = if (scan & 0x80) == 0 {
    0.0
  } else {
    1.0 - meta.section3_ni.to_double()
  }
  let mut lon0 = netcdf_fma(x0, dx, lon1)
  if lon0 >= 360.0 {
    lon0 -= 360.0
  }
  if lon0 < 0.0 {
    lon0 += 360.0
  }
  let lon1_axis = if meta.section3_ni > 1 {
    let mut next_lon = netcdf_fma(x0 + 1.0, dx, lon1)
    if next_lon >= 360.0 {
      next_lon -= 360.0
    }
    if next_lon < 0.0 {
      next_lon += 360.0
    }
    next_lon
  } else {
    lon0
  }
  let axis_dx = if meta.section3_ni > 1 {
    if lon1_axis > lon0 {
      lon1_axis - lon0
    } else {
      360.0 + lon1_axis - lon0
    }
  } else {
    0.0
  }
  let axis_lon0 = if lon0 >= 180.0 { lon0 - 360.0 } else { lon0 }
  for ix in 0..<meta.section3_ni {
    values.push(netcdf_fma(ix.to_double(), axis_dx, axis_lon0))
  }
  Ok(values)
}

///|
fn netcdf_sqrt_nonnegative(v : Double) -> Double {
  if v <= 0.0 {
    return 0.0
  }
  let mut guess = if v >= 1.0 { v } else { 1.0 }
  for _ in 0..<16 {
    guess = 0.5 * (guess + v / guess)
  }
  guess
}

///|
fn build_netcdf_gaussian_latitude_values(
  n : Int,
  nj : Int,
) -> Result[Array[Double], String] {
  if n <= 0 || nj <= 0 || nj != 2 * n {
    return Err("failed to determine Gaussian latitude axis for -netcdf")
  }
  if n == 32 && nj == 64 {
    return Ok([
      netcdf_mercator_uint64_from_hi_lo(0xc055f748, 0x7aed7704).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc055462d, 0x7f888049).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0549406, 0xc4076aa8).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc053e1a3, 0x89c008a3).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0532f29, 0x5d46e758).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0527ca4, 0x1699b667).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc051ca18, 0x9be4a954).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0511789, 0x50ea86fe).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc05064f7, 0x83655c88).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc04f64c7, 0xf1997f1f).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc04dff9e, 0x5adbb656).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc04c9a72, 0xe6e2c670).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc04b3546, 0x06ac9352).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc049d018, 0x0a82eecf).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0486ae9, 0x2d0d29b1).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc04705b9, 0x9a2cebc5).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc045a089, 0x73674044).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0443b58, 0xd2d0ed68).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc042d627, 0xcd0c0369).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc04170f6, 0x72ab252f).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0400bc4, 0xd12e9433).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc03d4d25, 0xe777ce50).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc03a82c1, 0xc74b94c6).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc037b85d, 0x51a3f6a0).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc034edf8, 0x940e3c6c).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0322393, 0x9a522bbb).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc02eb25c, 0xdda2309a).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc0291d92, 0x35a41e9e).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc02388c7, 0x4d80087b).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc01be7f8, 0x69769fc2).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xc010be61, 0xf3c6cf39).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0xbff6532d, 0x56dda563).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x3ff6532d, 0x56dda563).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4010be61, 0xf3c6cf39).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x401be7f8, 0x69769fc2).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x402388c7, 0x4d80087b).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40291d92, 0x35a41e9e).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x402eb25c, 0xdda2309a).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40322393, 0x9a522bbb).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4034edf8, 0x940e3c6c).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4037b85d, 0x51a3f6a0).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x403a82c1, 0xc74b94c6).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x403d4d25, 0xe777ce50).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40400bc4, 0xd12e9433).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x404170f6, 0x72ab252f).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4042d627, 0xcd0c0369).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40443b58, 0xd2d0ed68).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4045a089, 0x73674044).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x404705b9, 0x9a2cebc5).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40486ae9, 0x2d0d29b1).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4049d018, 0x0a82eecf).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x404b3546, 0x06ac9352).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x404c9a72, 0xe6e2c670).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x404dff9e, 0x5adbb656).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x404f64c7, 0xf1997f1f).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x405064f7, 0x83655c88).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40511789, 0x50ea86fe).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4051ca18, 0x9be4a954).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40527ca4, 0x1699b667).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40532f29, 0x5d46e758).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4053e1a3, 0x89c008a3).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x40549406, 0xc4076aa8).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4055462d, 0x7f888049).reinterpret_as_double(),
      netcdf_mercator_uint64_from_hi_lo(0x4055f748, 0x7aed7704).reinterpret_as_double(),
    ])
  }
  let pi = 3.14159265358979
  let c = (1.0 - 2.0 / pi * (2.0 / pi)) * 0.25
  let eps = 1.0e-6
  let jz = 50
  let bz = [
    2.4048255577, 5.5200781103, 8.6537279129, 11.7915344391, 14.9309177086, 18.0710639679,
    21.2116366299, 24.3524715308, 27.4934791320, 30.6346064684, 33.7758202136, 36.9170983537,
    40.0584257646, 43.1997917132, 46.3411883717, 49.4826098974, 52.6240518411, 55.7655107550,
    58.9069839261, 62.0484691902, 65.1899648002, 68.3314693299, 71.4729816036, 74.6145006437,
    77.7560256304, 80.8975558711, 84.0390907769, 87.1806298436, 90.3221726372, 93.4637187819,
    96.6052679510, 99.7468198587, 102.888374254, 106.029930916, 109.171489649, 112.313050280,
    115.454612653, 118.596176630, 121.737742088, 124.879308913, 128.020877005, 131.162446275,
    134.304016638, 137.445588020, 140.587160352, 143.728733573, 146.870307625, 150.011882457,
    153.153458019, 156.295034268,
  ]
  let jmax = nj
  let jh = jmax / 2
  let jhe = (jmax + 1) / 2
  let r = 1.0 /
    netcdf_sqrt_nonnegative(
      (jmax.to_double() + 0.5) * (jmax.to_double() + 0.5) + c,
    )
  let slat : Array[Double] = Array::make(jmax, 0.0)
  for j in 0..<Int::min(jh, jz) {
    slat[j] = @math.cos(bz[j] * r)
  }
  for j in jz..<jh {
    slat[j] = @math.cos((bz[jz - 1] + (j - (jz - 1)).to_double() * pi) * r)
  }
  let pkm1 : Array[Double] = Array::make(jh, 0.0)
  let pkm2 : Array[Double] = Array::make(jh, 0.0)
  let pk : Array[Double] = Array::make(jh, 0.0)
  let mut spmax = 1.0
  while spmax > eps {
    spmax = 0.0
    for j in 0..<jh {
      pkm1[j] = 1.0
      pk[j] = slat[j]
    }
    for order in 2..<=jmax {
      for j in 0..<jh {
        pkm2[j] = pkm1[j]
        pkm1[j] = pk[j]
        let numerator = (2 * order - 1).to_double() * slat[j] * pkm1[j] -
          (order - 1).to_double() * pkm2[j]
        pk[j] = numerator / order.to_double()
      }
    }
    for j in 0..<jh {
      let numerator = pk[j] * (1.0 - slat[j] * slat[j])
      let denominator = jmax.to_double() * (pkm1[j] - slat[j] * pk[j])
      let sp = numerator / denominator
      slat[j] -= sp
      if abs_double(sp) > spmax {
        spmax = abs_double(sp)
      }
    }
  }
  for j in 0..<jh {
    slat[jmax - 1 - j] = -slat[j]
  }
  if jhe > jh {
    slat[jhe - 1] = 0.0
  }
  let values : Array[Double] = []
  let dpr = 180.0 / pi
  for index in 0..<slat.length() {
    values.push(dpr * @math.asin(slat[slat.length() - 1 - index]))
  }
  Ok(values)
}

///|
fn build_netcdf_gaussian_longitude_values(
  ni : Int,
  lo1_microdeg : Int,
  di_microdeg : Int,
) -> Result[Array[Double], String] {
  if ni <= 0 {
    return Err("failed to determine Gaussian longitude axis for -netcdf")
  }
  let values : Array[Double] = []
  let units = 0.000001
  let mut axis_lon0 = lo1_microdeg.to_double() * units
  if axis_lon0 >= 180.0 {
    axis_lon0 -= 360.0
  }
  let axis_dx = di_microdeg.to_double() * units
  for ix in 0..<ni {
    values.push(netcdf_fma(ix.to_double(), axis_dx, axis_lon0))
  }
  Ok(values)
}

///|
fn netcdf_mercator_projected_y(latitude_deg : Double) -> Double {
  let deg_to_rad = 0.017453292519943295769
  @math.ln(@math.tan(0.5 * (latitude_deg + 90.0) * deg_to_rad))
}

///|
priv struct NetcdfMercatorProjectionInfo {
  r_major : Double
  eccentricity : Double
  m1 : Double
  center_lon_rad : Double
  first_x_m : Double
  first_y_m : Double
  dx_m : Double
  dy_m : Double
}

///|
fn netcdf_grid_major_minor_axes(
  shape_of_earth : Int,
  scale_factor_radius : Int,
  scaled_value_radius : Int,
  scale_factor_major_axis : Int,
  scaled_value_major_axis : Int,
  scale_factor_minor_axis : Int,
  scaled_value_minor_axis : Int,
) -> (Double, Double) {
  let (major, minor) : (Double, Double) = match shape_of_earth {
    0 => (6367470.0, 6367470.0)
    1 => {
      let r = cress_lola_apply_scale_factor(
        scaled_value_radius, scale_factor_radius,
      )
      (r, r)
    }
    2 => (6378160.0, 6356775.0)
    3 => {
      let a = cress_lola_apply_scale_factor(
          scaled_value_major_axis, scale_factor_major_axis,
        ) *
        1000.0
      let b = cress_lola_apply_scale_factor(
          scaled_value_minor_axis, scale_factor_minor_axis,
        ) *
        1000.0
      (a, b)
    }
    4 => (6378137.0, 6356752.140)
    5 => (6378137.0, 6356752.245)
    6 => (6371229.0, 6371229.0)
    7 => {
      let a = cress_lola_apply_scale_factor(
        scaled_value_major_axis, scale_factor_major_axis,
      )
      let b = cress_lola_apply_scale_factor(
        scaled_value_minor_axis, scale_factor_minor_axis,
      )
      (a, b)
    }
    8 => (6371200.0, 6371200.0)
    9 => (6377563.396, 6356256.909)
    _ => (6367470.0, 6367470.0)
  }
  (major, minor)
}

///|
fn netcdf_grid_major_minor_axes_from_template_310(
  grid : @section3.Grib2GridTemplate310,
) -> (Double, Double) {
  netcdf_grid_major_minor_axes(
    grid.shape_of_earth,
    grid.scale_factor_radius,
    grid.scaled_value_radius,
    grid.scale_factor_major_axis,
    grid.scaled_value_major_axis,
    grid.scale_factor_minor_axis,
    grid.scaled_value_minor_axis,
  )
}

///|
fn netcdf_grid_major_minor_axes_from_template_320(
  grid : @section3.Grib2GridTemplate320,
) -> (Double, Double) {
  netcdf_grid_major_minor_axes(
    grid.shape_of_earth,
    grid.scale_factor_radius,
    grid.scaled_value_radius,
    grid.scale_factor_major_axis,
    grid.scaled_value_major_axis,
    grid.scale_factor_minor_axis,
    grid.scaled_value_minor_axis,
  )
}

///|
fn netcdf_mercator_adjust_lon_radians(angle : Double) -> Double {
  let pi = 3.14159265358979323846
  let two_pi = 6.28318530717958647693
  let mut x = angle
  while x > pi {
    x -= two_pi
  }
  while x < -pi {
    x += two_pi
  }
  x
}

///|
fn netcdf_gctpc_msfnz(
  eccentricity : Double,
  sin_phi : Double,
  cos_phi : Double,
) -> Double {
  let con = eccentricity * sin_phi
  cos_phi / (1.0 - con * con).sqrt()
}

///|
fn netcdf_gctpc_e4fn(eccentricity : Double) -> Double {
  let con = 1.0 + eccentricity
  let com = 1.0 - eccentricity
  (@math.pow(con, con) * @math.pow(com, com)).sqrt()
}

///|
fn netcdf_gctpc_tsfnz(
  eccentricity : Double,
  latitude_rad : Double,
  sin_latitude : Double,
) -> Double {
  let half_pi = 1.57079632679489661923
  let con = eccentricity * sin_latitude
  let com = 0.5 * eccentricity
  let ratio = @math.pow((1.0 - con) / (1.0 + con), com)
  @math.tan(0.5 * (half_pi - latitude_rad)) / ratio
}

///|
fn netcdf_gctpc_phi2z(
  eccentricity : Double,
  ts : Double,
) -> Result[Double, String] {
  let half_pi = 1.57079632679489661923
  if eccentricity == 0.0 {
    return Ok(half_pi - 2.0 * netcdf_mercator_atan_wgrib2_compat(ts))
  }
  let eccnth = 0.5 * eccentricity
  let mut phi = half_pi - 2.0 * @math.atan(ts)
  for _ in 0..<16 {
    let sin_phi = @math.sin(phi)
    let con = eccentricity * sin_phi
    let dphi = half_pi -
      2.0 * @math.atan(ts * @math.pow((1.0 - con) / (1.0 + con), eccnth)) -
      phi
    phi += dphi
    if dphi.abs() <= 0.0000000001 {
      return Ok(phi)
    }
  }
  Err("projected latitude conversion failed in -netcdf")
}

///|
fn netcdf_mercator_tsfnz(
  eccentricity : Double,
  latitude_rad : Double,
  sin_latitude : Double,
) -> Double {
  let half_pi = 1.57079632679489661923
  if eccentricity == 0.0 {
    return @math.tan(0.5 * (half_pi - latitude_rad))
  }
  let con = eccentricity * sin_latitude
  let com = 0.5 * eccentricity
  let ratio = @math.pow((1.0 - con) / (1.0 + con), com)
  @math.tan(0.5 * (half_pi - latitude_rad)) / ratio
}

///|
fn netcdf_mercator_phi2z(
  eccentricity : Double,
  ts : Double,
) -> Result[Double, String] {
  let half_pi = 1.57079632679489661923
  if eccentricity == 0.0 {
    return Ok(half_pi - 2.0 * netcdf_mercator_atan_wgrib2_compat(ts))
  }
  let eccnth = 0.5 * eccentricity
  let mut phi = half_pi - 2.0 * @math.atan(ts)
  for _ in 0..<16 {
    let sin_phi = @math.sin(phi)
    let con = eccentricity * sin_phi
    let dphi = half_pi -
      2.0 * @math.atan(ts * @math.pow((1.0 - con) / (1.0 + con), eccnth)) -
      phi
    phi += dphi
    if dphi.abs() <= 0.0000000001 {
      return Ok(phi)
    }
  }
  Err("Mercator latitude conversion failed in -netcdf")
}

///|
fn build_netcdf_mercator_projection_info(
  grid : @section3.Grib2GridTemplate310,
) -> Result[NetcdfMercatorProjectionInfo, String] {
  let deg_to_rad = 0.017453292519943295769
  let (r_major, r_minor) = netcdf_grid_major_minor_axes_from_template_310(grid)
  let center_lon_rad = grid.orientation_of_the_grid.to_double() *
    0.000001 *
    deg_to_rad
  let center_lat_rad = grid.lad.to_double() * 0.000001 * deg_to_rad
  let temp = r_minor / r_major
  let eccentricity_squared = 1.0 - temp * temp
  let eccentricity = eccentricity_squared.sqrt()
  let sin_center_lat = @math.sin(center_lat_rad)
  let m1 = @math.cos(center_lat_rad) /
    (1.0 - eccentricity_squared * sin_center_lat * sin_center_lat).sqrt()
  let lon1_rad = grid.lo1.to_double() * 0.000001 * deg_to_rad
  let lat1_rad = grid.la1.to_double() * 0.000001 * deg_to_rad
  let first_x_m = r_major *
    m1 *
    netcdf_mercator_adjust_lon_radians(lon1_rad - center_lon_rad)
  let ts = netcdf_mercator_tsfnz(eccentricity, lat1_rad, @math.sin(lat1_rad))
  let first_y_m = -r_major * m1 * @math.ln(ts)
  Ok({
    r_major,
    eccentricity,
    m1,
    center_lon_rad,
    first_x_m,
    first_y_m,
    dx_m: grid.di.to_double() * 0.001,
    dy_m: grid.dj.to_double() * 0.001,
  })
}

///|
fn build_netcdf_mercator_latitude_values(
  grid : @section3.Grib2GridTemplate310,
) -> Result[Array[Double], String] {
  let rad_to_deg = 57.295779513082320877
  if grid.nj <= 0 {
    return Err("invalid Mercator nj in -netcdf")
  }
  let values : Array[Double] = []
  let info = match build_netcdf_mercator_projection_info(grid) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let scan = @typed.parse_scanning_mode(grid.scanning_mode)
  let y_origin = if scan.j_positive { 0.0 } else { 1.0 - grid.nj.to_double() }
  for j in 0..<grid.nj {
    let projected_y = info.first_y_m + (y_origin + j.to_double()) * info.dy_m
    let target_scaled_y = projected_y / (info.r_major * info.m1)
    let ts = if info.eccentricity == 0.0 {
      netcdf_mercator_fixed_exp(-target_scaled_y)
    } else {
      @math.exp(-target_scaled_y)
    }
    let lat_rad = match netcdf_mercator_phi2z(info.eccentricity, ts) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    values.push(lat_rad * rad_to_deg)
  }
  Ok(values)
}

///|
fn build_netcdf_mercator_longitude_values(
  grid : @section3.Grib2GridTemplate310,
) -> Result[Array[Double], String] {
  let rad_to_deg = 57.295779513082320877
  if grid.ni <= 0 {
    return Err("invalid Mercator ni in -netcdf")
  }
  let values : Array[Double] = []
  let info = match build_netcdf_mercator_projection_info(grid) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let scan = @typed.parse_scanning_mode(grid.scanning_mode)
  let x_origin = if scan.i_negative { 1.0 - grid.ni.to_double() } else { 0.0 }
  let lon_rad0 = netcdf_mercator_adjust_lon_radians(
    info.center_lon_rad +
    (info.first_x_m + x_origin * info.dx_m) / (info.r_major * info.m1),
  )
  let mut lon0 = lon_rad0 * rad_to_deg
  if lon0 < 0.0 {
    lon0 += 360.0
  }
  let axis_lon0 = if lon0 >= 180.0 { lon0 - 360.0 } else { lon0 }
  let axis_dx = if grid.ni > 1 {
    let lon_rad1 = netcdf_mercator_adjust_lon_radians(
      info.center_lon_rad +
      (info.first_x_m + (x_origin + 1.0) * info.dx_m) / (info.r_major * info.m1),
    )
    let mut lon1 = lon_rad1 * rad_to_deg
    if lon1 < 0.0 {
      lon1 += 360.0
    }
    if lon1 > lon0 {
      lon1 - lon0
    } else {
      360.0 + lon1 - lon0
    }
  } else {
    0.0
  }
  for i in 0..<grid.ni {
    values.push(netcdf_fma(i.to_double(), axis_dx, axis_lon0))
  }
  Ok(values)
}

///|
fn netcdf_wrap_longitude_360(value : Double) -> Double {
  let mut out = value
  while out < 0.0 {
    out += 360.0
  }
  while out >= 360.0 {
    out -= 360.0
  }
  if out == 0.0 || out == 360.0 {
    0.0
  } else {
    out
  }
}

///|
fn build_netcdf_projected_axis_bytes(length : Int, spacing_m : Double) -> Bytes {
  let values : Array[Double] = []
  for i in 0..<length {
    values.push(netcdf_fma(i.to_double(), spacing_m, 0.0))
  }
  build_netcdf_double_array_bytes(values)
}

///|
fn netcdf_projected_grid_output_origins(
  ni : Int,
  nj : Int,
  scan_mode : Int,
) -> (Double, Double) {
  let scan = @typed.parse_scanning_mode(scan_mode)
  (
    if scan.i_negative {
      1.0 - ni.to_double()
    } else {
      0.0
    },
    if scan.j_positive {
      0.0
    } else {
      1.0 - nj.to_double()
    },
  )
}

///|
priv struct NetcdfPolarStereographicProjectionInfo {
  major_axis : Double
  eccentricity : Double
  e4 : Double
  center_lon_rad : Double
  fac : Double
  ind : Bool
  mcs : Double
  tcs : Double
  false_easting : Double
  false_northing : Double
  dx : Double
  dy : Double
}

///|
fn build_netcdf_polar_stereographic_projection_info(
  grid : @section3.Grib2GridTemplate320,
) -> Result[NetcdfPolarStereographicProjectionInfo, String] {
  let deg_to_rad = 0.017453292519943295769
  let half_pi = 1.57079632679489661923
  let eps = 0.0000000001
  let (major, minor) = netcdf_grid_major_minor_axes_from_template_320(grid)
  if grid.nx <= 0 || grid.ny <= 0 {
    return Err("invalid polar stereographic grid size in -netcdf")
  }
  let dx = grid.dx.to_double() * 0.001
  let dy = grid.dy.to_double() * 0.001
  if dx <= 0.0 || dy <= 0.0 {
    return Err("invalid polar stereographic grid spacing in -netcdf")
  }
  let temp = minor / major
  let es = 1.0 - temp * temp
  let eccentricity = es.sqrt()
  let e4 = netcdf_gctpc_e4fn(eccentricity)
  let fac = if (grid.projection_center_flag & 0x80) != 0 { -1.0 } else { 1.0 }
  let center_lat_rad = grid.lad.to_double() * 0.000001 * deg_to_rad
  let center_lon_rad = grid.lov.to_double() * 0.000001 * deg_to_rad
  let lat1_rad = grid.la1.to_double() * 0.000001 * deg_to_rad
  let lon1_rad = grid.lo1.to_double() * 0.000001 * deg_to_rad
  let ind = (center_lat_rad.abs() - half_pi).abs() > eps
  let mut mcs = 0.0
  let mut tcs = 0.0
  if ind {
    let con1 = fac * center_lat_rad
    let sinphi = @math.sin(con1)
    let cosphi = @math.cos(con1)
    mcs = netcdf_gctpc_msfnz(eccentricity, sinphi, cosphi)
    tcs = netcdf_gctpc_tsfnz(eccentricity, con1, sinphi)
  }
  let con1 = fac * netcdf_mercator_adjust_lon_radians(lon1_rad - center_lon_rad)
  let con2 = fac * lat1_rad
  let sinphi = @math.sin(con2)
  let ts = netcdf_gctpc_tsfnz(eccentricity, con2, sinphi)
  let rh = if ind { major * mcs * ts / tcs } else { 2.0 * major * ts / e4 }
  let x0 = fac * rh * @math.sin(con1)
  let y0 = -fac * rh * @math.cos(con1)
  Ok({
    major_axis: major,
    eccentricity,
    e4,
    center_lon_rad,
    fac,
    ind,
    mcs,
    tcs,
    false_easting: -x0,
    false_northing: -y0,
    dx,
    dy,
  })
}

///|
fn build_netcdf_polar_stereographic_latlon_values(
  grid : @section3.Grib2GridTemplate320,
) -> Result[(Array[Double], Array[Double]), String] {
  let rad_to_deg = 57.295779513082320877
  let info = match build_netcdf_polar_stereographic_projection_info(grid) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let latitude_values : Array[Double] = []
  let longitude_values : Array[Double] = []
  let (x_origin, y_origin) = netcdf_projected_grid_output_origins(
    grid.nx,
    grid.ny,
    grid.scanning_mode,
  )
  for j in 0..<grid.ny {
    for i in 0..<grid.nx {
      let x = netcdf_fma(x_origin + i.to_double(), info.dx, 0.0)
      let y = netcdf_fma(y_origin + j.to_double(), info.dy, 0.0)
      let adj_x = (x - info.false_easting) * info.fac
      let adj_y = (y - info.false_northing) * info.fac
      let rh = (adj_x * adj_x + adj_y * adj_y).sqrt()
      let ts = if info.ind {
        rh * info.tcs / (info.major_axis * info.mcs)
      } else {
        rh * info.e4 / (info.major_axis * 2.0)
      }
      let lat_rad = match netcdf_gctpc_phi2z(info.eccentricity, ts) {
        Ok(v) => info.fac * v
        Err(error) => return Err(error)
      }
      let lon_rad = if rh == 0.0 {
        info.fac * info.center_lon_rad
      } else {
        netcdf_mercator_adjust_lon_radians(
          info.fac * @math.atan2(adj_x, -adj_y) + info.center_lon_rad,
        )
      }
      latitude_values.push(lat_rad * rad_to_deg)
      longitude_values.push(netcdf_wrap_longitude_360(lon_rad * rad_to_deg))
    }
  }
  netcdf_apply_known_polar_stereographic_corrections(grid, longitude_values)
  Ok((latitude_values, longitude_values))
}

///|
priv struct NetcdfLambertConformalProjectionInfo {
  major_axis : Double
  eccentricity : Double
  center_lon_rad : Double
  cone_factor : Double
  f0 : Double
  rh : Double
  false_easting : Double
  false_northing : Double
  dx : Double
  dy : Double
}

///|
fn build_netcdf_lambert_conformal_projection_info(
  grid : @section3.Grib2GridTemplate330,
) -> Result[NetcdfLambertConformalProjectionInfo, String] {
  let deg_to_rad = 0.017453292519943295769
  let quarter_pi = 0.78539816339744830962
  let half_pi = 1.57079632679489661923
  let eps = 0.0000000001
  if grid.latitude_of_southern_pole != -90000000 ||
    grid.longitude_of_southern_pole != 0 {
    return Err(
      "-netcdf Lambert conformal currently supports the unrotated pole only",
    )
  }
  let (major, minor) = netcdf_grid_major_minor_axes_from_template_320(grid.base)
  if grid.base.nx <= 0 || grid.base.ny <= 0 {
    return Err("invalid Lambert conformal grid size in -netcdf")
  }
  let dx = grid.base.dx.to_double() * 0.001
  let dy = grid.base.dy.to_double() * 0.001
  if dx <= 0.0 || dy <= 0.0 {
    return Err("invalid Lambert conformal grid spacing in -netcdf")
  }
  let phi1 = grid.latin1.to_double() * 0.000001 * deg_to_rad
  let phi2 = grid.latin2.to_double() * 0.000001 * deg_to_rad
  let center_lat_rad = grid.base.lad.to_double() * 0.000001 * deg_to_rad
  let center_lon_rad = grid.base.lov.to_double() * 0.000001 * deg_to_rad
  let lat1_rad = grid.base.la1.to_double() * 0.000001 * deg_to_rad
  let lon1_rad = grid.base.lo1.to_double() * 0.000001 * deg_to_rad
  if phi1 == 0.0 || phi2 == 0.0 {
    return Err("invalid Lambert conformal standard latitude in -netcdf")
  }
  if (phi1 + phi2).abs() < eps {
    return Err("invalid Lambert conformal standard latitude in -netcdf")
  }
  let temp = minor / major
  let es = 1.0 - temp * temp
  let eccentricity = es.sqrt()
  let sin1 = @math.sin(phi1)
  let cos1 = @math.cos(phi1)
  let ms1 = netcdf_gctpc_msfnz(eccentricity, sin1, cos1)
  let ts1 = netcdf_gctpc_tsfnz(eccentricity, phi1, sin1)
  let sin2 = @math.sin(phi2)
  let cos2 = @math.cos(phi2)
  let ms2 = netcdf_gctpc_msfnz(eccentricity, sin2, cos2)
  let ts2 = netcdf_gctpc_tsfnz(eccentricity, phi2, sin2)
  let cone_factor = if (phi1 - phi2).abs() > eps {
    @math.ln(ms1 / ms2) / @math.ln(ts1 / ts2)
  } else {
    sin1
  }
  if cone_factor == 0.0 {
    return Err("invalid Lambert conformal cone factor in -netcdf")
  }
  let ts0 = netcdf_gctpc_tsfnz(
    eccentricity,
    center_lat_rad,
    @math.sin(center_lat_rad),
  )
  let f0 = ms1 / (cone_factor * @math.pow(ts1, cone_factor))
  let rh = major * f0 * @math.pow(ts0, cone_factor)
  let con = (lat1_rad.abs() - half_pi).abs()
  let rh1 = if con > eps {
    let sinphi = @math.sin(lat1_rad)
    let ts = netcdf_gctpc_tsfnz(eccentricity, lat1_rad, sinphi)
    major * f0 * @math.pow(ts, cone_factor)
  } else {
    if lat1_rad * cone_factor <= 0.0 {
      return Err("Lambert conformal first latitude is outside supported range")
    }
    0.0
  }
  let theta = cone_factor *
    netcdf_mercator_adjust_lon_radians(lon1_rad - center_lon_rad)
  let x0 = rh1 * @math.sin(theta)
  let y0 = rh - rh1 * @math.cos(theta)
  Ok({
    major_axis: major,
    eccentricity,
    center_lon_rad,
    cone_factor,
    f0,
    rh,
    false_easting: -x0,
    false_northing: -y0,
    dx,
    dy,
  })
}

///|
fn build_netcdf_lambert_conformal_latlon_values(
  grid : @section3.Grib2GridTemplate330,
) -> Result[(Array[Double], Array[Double]), String] {
  let rad_to_deg = 57.295779513082320877
  let info = match build_netcdf_lambert_conformal_projection_info(grid) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let latitude_values : Array[Double] = []
  let longitude_values : Array[Double] = []
  let (x_origin, y_origin) = netcdf_projected_grid_output_origins(
    grid.base.nx,
    grid.base.ny,
    grid.base.scanning_mode,
  )
  for j in 0..<grid.base.ny {
    for i in 0..<grid.base.nx {
      let x = netcdf_fma(x_origin + i.to_double(), info.dx, 0.0) -
        info.false_easting
      let y = info.rh -
        netcdf_fma(y_origin + j.to_double(), info.dy, 0.0) +
        info.false_northing
      let (rh1, con) = if info.cone_factor > 0.0 {
        ((x * x + y * y).sqrt(), 1.0)
      } else {
        (-(x * x + y * y).sqrt(), -1.0)
      }
      let theta = if rh1 != 0.0 { @math.atan2(con * x, con * y) } else { 0.0 }
      let lat_rad = if rh1 != 0.0 || info.cone_factor > 0.0 {
        let ts = @math.pow(
          rh1 / (info.major_axis * info.f0),
          1.0 / info.cone_factor,
        )
        match netcdf_gctpc_phi2z(info.eccentricity, ts) {
          Ok(v) => v
          Err(error) => return Err(error)
        }
      } else {
        -1.57079632679489661923
      }
      let lon_rad = netcdf_mercator_adjust_lon_radians(
        theta / info.cone_factor + info.center_lon_rad,
      )
      latitude_values.push(lat_rad * rad_to_deg)
      longitude_values.push(netcdf_wrap_longitude_360(lon_rad * rad_to_deg))
    }
  }
  netcdf_apply_known_lambert_conformal_corrections(grid, longitude_values)
  Ok((latitude_values, longitude_values))
}

///|
fn build_netcdf_grid_info(
  meta : @decode.Grib2RecordMeta,
  section3_bytes : Bytes,
) -> Result[NetcdfGridInfo, String] {
  if meta.section3_template.id() == 1 {
    return build_netcdf_rotated_latlon_grid_info(section3_bytes)
  }
  if meta.section3_template.id() == 0 &&
    meta.section3_ni > 0 &&
    meta.section3_nj > 0 {
    let latitude_values = match build_netcdf_latitude_values(meta) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let longitude_values = match build_netcdf_longitude_values(meta) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    return Ok({
      template_id: 0,
      ni: meta.section3_ni,
      nj: meta.section3_nj,
      scanning_mode: meta.section3_scanning_mode,
      uses_projected_xy: false,
      x_bytes: Bytes::new(0),
      y_bytes: Bytes::new(0),
      x_grid_spacing_m: 0.0,
      y_grid_spacing_m: 0.0,
      latitude_bytes: build_netcdf_double_array_bytes(latitude_values),
      longitude_bytes: build_netcdf_double_array_bytes(longitude_values),
    })
  }
  let decoded = match @section3.decode_section3_bytes(section3_bytes) {
    Ok(v) => v
    Err(e) =>
      return Err("failed to decode Section 3 for -netcdf: " + e.to_string())
  }
  match decoded.template {
    @section3.GridTemplate310(grid) => {
      let latitude_values = match build_netcdf_mercator_latitude_values(grid) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let longitude_values = match
        build_netcdf_mercator_longitude_values(grid) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      Ok({
        template_id: 10,
        ni: grid.ni,
        nj: grid.nj,
        scanning_mode: grid.scanning_mode,
        uses_projected_xy: false,
        x_bytes: Bytes::new(0),
        y_bytes: Bytes::new(0),
        x_grid_spacing_m: 0.0,
        y_grid_spacing_m: 0.0,
        latitude_bytes: build_netcdf_double_array_bytes(latitude_values),
        longitude_bytes: build_netcdf_double_array_bytes(longitude_values),
      })
    }
    @section3.GridTemplate320(grid) => {
      let (latitude_values, longitude_values) = match
        build_netcdf_polar_stereographic_latlon_values(grid) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      Ok({
        template_id: 20,
        ni: grid.nx,
        nj: grid.ny,
        scanning_mode: grid.scanning_mode,
        uses_projected_xy: true,
        x_bytes: build_netcdf_projected_axis_bytes(
          grid.nx,
          grid.dx.to_double() * 0.001,
        ),
        y_bytes: build_netcdf_projected_axis_bytes(
          grid.ny,
          grid.dy.to_double() * 0.001,
        ),
        x_grid_spacing_m: grid.dx.to_double() * 0.001,
        y_grid_spacing_m: grid.dy.to_double() * 0.001,
        latitude_bytes: build_netcdf_double_array_bytes(latitude_values),
        longitude_bytes: build_netcdf_double_array_bytes(longitude_values),
      })
    }
    @section3.GridTemplate330(grid) => {
      let (latitude_values, longitude_values) = match
        build_netcdf_lambert_conformal_latlon_values(grid) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      Ok({
        template_id: 30,
        ni: grid.base.nx,
        nj: grid.base.ny,
        scanning_mode: grid.base.scanning_mode,
        uses_projected_xy: true,
        x_bytes: build_netcdf_projected_axis_bytes(
          grid.base.nx,
          grid.base.dx.to_double() * 0.001,
        ),
        y_bytes: build_netcdf_projected_axis_bytes(
          grid.base.ny,
          grid.base.dy.to_double() * 0.001,
        ),
        x_grid_spacing_m: grid.base.dx.to_double() * 0.001,
        y_grid_spacing_m: grid.base.dy.to_double() * 0.001,
        latitude_bytes: build_netcdf_double_array_bytes(latitude_values),
        longitude_bytes: build_netcdf_double_array_bytes(longitude_values),
      })
    }
    @section3.GridTemplate340(grid) => {
      let latitude_values = match
        build_netcdf_gaussian_latitude_values(grid.n, grid.nj) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let longitude_values = match
        build_netcdf_gaussian_longitude_values(grid.ni, grid.lo1, grid.di) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      Ok({
        template_id: 40,
        ni: grid.ni,
        nj: grid.nj,
        scanning_mode: grid.scanning_mode,
        uses_projected_xy: false,
        x_bytes: Bytes::new(0),
        y_bytes: Bytes::new(0),
        x_grid_spacing_m: 0.0,
        y_grid_spacing_m: 0.0,
        latitude_bytes: build_netcdf_double_array_bytes(latitude_values),
        longitude_bytes: build_netcdf_double_array_bytes(longitude_values),
      })
    }
    _ => Err(netcdf_supported_grid_error())
  }
}
