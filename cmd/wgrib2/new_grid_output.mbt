///|
priv struct NewGridRegularLatLonGrid {
  lon_start : Double
  lat_start : Double
  nx : Int
  ny : Int
  dlon : Double
  dlat : Double
  wraps_lon : Bool
}

///|
priv struct NewGridRawSourceGrid {
  ni : Int
  nj : Int
  scan_mode : Int
  lon1 : Double
  lat1 : Double
  dlon : Double
  dlat : Double
  hi : Double
  x_max : Double
  y_max : Double
  iwrap : Int
}

///|
priv enum NewGridInterpolationMethod {
  NewGridInterpolationBilinear
  NewGridInterpolationNeighbor
}

///|
fn parse_new_grid_interpolation_method(
  spec : String?,
) -> Result[NewGridInterpolationMethod, String] {
  match spec {
    None => Ok(NewGridInterpolationBilinear)
    Some("bilinear") => Ok(NewGridInterpolationBilinear)
    Some("neighbor") => Ok(NewGridInterpolationNeighbor)
    Some(value) =>
      Err(
        "-new_grid_interpolation currently supports bilinear|neighbor, got " +
        value,
      )
  }
}

///|
fn new_grid_wgrib2_notice_inventory_line(meta : @decode.Grib2RecordMeta) -> String {
  meta.record_id +
  ":" +
  meta.message_offset.to_string() +
  ":d=" +
  meta.reference_time +
  ":" +
  meta.parameter_name.display() +
  ":" +
  meta.level_name.display() +
  ":" +
  meta.tail +
  ":"
}

///|
fn new_grid_wgrib2_alternating_rows_notice_lines(
  meta : @decode.Grib2RecordMeta,
) -> Array[String] {
  [
    "Warning: -new_grid_winds set to earth",
    "new_grid: rows must scan in same direction",
    new_grid_wgrib2_notice_inventory_line(meta),
  ]
}

///|
fn new_grid_wgrib2_alternating_rows_pair_notice_lines(
  first_meta : @decode.Grib2RecordMeta,
  second_meta : @decode.Grib2RecordMeta,
) -> Array[String] {
  [
    "Warning: -new_grid_winds set to earth",
    "new_grid: rows must scan in same direction",
    new_grid_wgrib2_notice_inventory_line(first_meta),
    new_grid_wgrib2_notice_inventory_line(second_meta),
    "new_grid: rows must scan in same direction",
  ]
}

///|
fn build_new_grid_target_grid(
  lon_spec : String,
  lat_spec : String,
) -> Result[NewGridRegularLatLonGrid, String] {
  let (lon_start, nx, dlon) = match parse_lola_axis(lon_spec) {
    Some(v) => v
    None => return Err("-new_grid: invalid lon axis")
  }
  let (lat_start, ny, dlat) = match parse_lola_axis(lat_spec) {
    Some(v) => v
    None => return Err("-new_grid: invalid lat axis")
  }
  if dlon <= 0.0 {
    return Err("-new_grid: dlon must be positive")
  }
  if dlat <= 0.0 {
    return Err("-new_grid: dlat must be positive")
  }
  let lat_end = lat_start + (ny - 1).to_double() * dlat
  if lat_start < -90.0 || lat_end > 90.0 {
    return Err("-new_grid: latitude axis is out of range")
  }
  Ok({
    lon_start,
    lat_start,
    nx,
    ny,
    dlon,
    dlat,
    wraps_lon: nx > 1 && dlon * nx.to_double() >= 360.0 - 1.0e-6,
  })
}

///|
fn build_new_grid_raw_source_grid(
  meta : @decode.Grib2RecordMeta,
) -> Result[NewGridRawSourceGrid, String] {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err(
      "-new_grid currently supports regular lat/lon grid (template 3.0)",
    )
  }
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  let scan_mode = meta.section3_scanning_mode
  let mut lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let mut lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
  let hi = if (scan_mode & 0x80) == 0 { 1.0 } else { -1.0 }
  let dlon = if ni <= 1 {
    0.0
  } else if hi > 0.0 {
    if lon2 <= lon1 {
      lon2 += 360.0
    }
    (lon2 - lon1) / (ni - 1).to_double()
  } else {
    if lon1 <= lon2 {
      lon1 += 360.0
    }
    (lon1 - lon2) / (ni - 1).to_double()
  }
  let dlat = if nj <= 1 { 0.0 } else { (lat2 - lat1) / (nj - 1).to_double() }
  let wrap_count = if ni > 1 && dlon > 0.0 {
    let implied = @math.round(360.0 / dlon).to_int()
    if implied == ni {
      ni
    } else {
      0
    }
  } else {
    0
  }
  let x_max = if wrap_count > 0 {
    ni.to_double() + 2.0
  } else {
    ni.to_double() + 1.0
  }
  Ok({
    ni,
    nj,
    scan_mode,
    lon1,
    lat1,
    dlon,
    dlat,
    hi,
    x_max,
    y_max: nj.to_double() + 1.0,
    iwrap: wrap_count,
  })
}

///|
fn build_new_grid_source_grid(
  meta : @decode.Grib2RecordMeta,
) -> Result[NewGridRegularLatLonGrid, String] {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err(
      "-new_grid currently supports regular lat/lon grid (template 3.0)",
    )
  }
  let (lon_start, lat_start) = match grid_ij_to_latlon_from_meta(meta, 1, 1) {
    Some(v) => v
    None => return Err("-new_grid: failed to resolve source grid origin")
  }
  let dlon = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let dlat = meta.section3_dj_microdeg.to_double().abs() / 1000000.0
  if meta.section3_ni > 1 && dlon <= 0.0 {
    return Err("-new_grid: source grid has invalid dlon")
  }
  if meta.section3_nj > 1 && dlat <= 0.0 {
    return Err("-new_grid: source grid has invalid dlat")
  }
  Ok({
    lon_start,
    lat_start,
    nx: meta.section3_ni,
    ny: meta.section3_nj,
    dlon,
    dlat,
    wraps_lon: meta.section3_ni > 1 &&
    dlon * meta.section3_ni.to_double() >= 360.0 - 1.0e-6,
  })
}

///|
fn new_grid_positive_mod(value : Double, modulus : Double) -> Double {
  let quotient = @math.floor(value / modulus)
  let remainder = value - quotient * modulus
  if remainder < 0.0 {
    remainder + modulus
  } else if remainder >= modulus {
    remainder - modulus
  } else {
    remainder
  }
}

///|
fn build_new_grid_canonical_source_values(
  meta : @decode.Grib2RecordMeta,
  unpacked : Array[Double],
) -> Result[Array[Double], String] {
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err(
      "-new_grid requires ni*nj points, got " +
      unpacked.length().to_string() +
      " expected " +
      total_points.to_string(),
    )
  }
  let out = Array::make(total_points, 0.0 / 0.0)
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let raw_index = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => return Err("-new_grid: failed to resolve source ij index")
      }
      out[i - 1 + (j - 1) * meta.section3_ni] = to_wgrib2_float32(
        unpacked[raw_index],
      )
    }
  }
  Ok(out)
}

///|
fn build_new_grid_raw_source_values(unpacked : Array[Double]) -> Array[Double] {
  let out : Array[Double] = []
  for value in unpacked {
    if value == value {
      out.push(to_wgrib2_float32(value))
    } else {
      out.push(value)
    }
  }
  out
}

///|
fn new_grid_movect(
  from_lat : Double,
  from_lon : Double,
  to_lat : Double,
  to_lon : Double,
) -> (Double, Double) {
  let crd_lim = 0.9999999
  let pi = 3.14159265358979
  let dpr = 180.0 / pi
  let ctlat = @math.cos(to_lat / dpr)
  let stlat = @math.sin(to_lat / dpr)
  let cflat = @math.cos(from_lat / dpr)
  let sflat = @math.sin(from_lat / dpr)
  let cdlon = @math.cos((from_lon - to_lon) / dpr)
  let sdlon = @math.sin((from_lon - to_lon) / dpr)
  let crd = stlat * sflat + ctlat * cflat * cdlon
  if crd.abs() <= crd_lim {
    let srd2rn = -1.0 / (1.0 - crd * crd)
    let str = cflat * sdlon
    let ctr = cflat * stlat * cdlon - sflat * ctlat
    let sfr = ctlat * sdlon
    let cfr = ctlat * sflat * cdlon - stlat * cflat
    (srd2rn * (ctr * cfr - str * sfr), srd2rn * (ctr * sfr + str * cfr))
  } else {
    (cdlon, sdlon * stlat)
  }
}

///|
fn new_grid_raw_source_value_at(
  source : NewGridRawSourceGrid,
  values : Array[Double],
  i : Int,
  j : Int,
) -> Double? {
  let ii = if source.iwrap > 0 {
    ((i - 1) % source.iwrap + source.iwrap) % source.iwrap + 1
  } else {
    i
  }
  if ii < 1 || ii > source.ni || j < 1 || j > source.nj {
    return None
  }
  let scan = @typed.parse_scanning_mode(source.scan_mode)
  let i_out = if scan.i_negative { source.ni - ii } else { ii - 1 }
  let j_out = if scan.j_positive { j - 1 } else { source.nj - j }
  let index = i_out + j_out * source.ni
  if index < 0 || index >= values.length() {
    None
  } else {
    Some(values[index])
  }
}

///|
fn new_grid_raw_source_lon_lat(
  source : NewGridRawSourceGrid,
  i : Int,
  j : Int,
) -> (Double, Double)? {
  let ii = if source.iwrap > 0 {
    ((i - 1) % source.iwrap + source.iwrap) % source.iwrap + 1
  } else {
    i
  }
  if ii < 1 || ii > source.ni || j < 1 || j > source.nj {
    return None
  }
  let lon = new_grid_positive_mod(
    source.lon1 + source.hi * (ii - 1).to_double() * source.dlon + 3600.0,
    360.0,
  )
  let mut lat = source.lat1 + (j - 1).to_double() * source.dlat
  if lat < -90.0 {
    lat = -90.0
  }
  if lat > 90.0 {
    lat = 90.0
  }
  Some((lon, lat))
}

///|
fn new_grid_raw_source_xij_yij(
  source : NewGridRawSourceGrid,
  lon : Double,
  lat : Double,
) -> (Double, Double)? {
  let lonf = lon
  let latf = lat
  if lonf.abs() > 360.0 || latf.abs() > 90.0 {
    return None
  }
  let xij = if source.ni <= 1 || source.dlon == 0.0 {
    1.0
  } else {
    1.0 +
    source.hi *
    new_grid_positive_mod(source.hi * (lonf - source.lon1) + 3600.0, 360.0) /
    source.dlon
  }
  let yij = if source.nj <= 1 || source.dlat == 0.0 {
    1.0
  } else {
    1.0 + (latf - source.lat1) / source.dlat
  }
  if xij < 0.0 || xij > source.x_max || yij < 0.0 || yij > source.y_max {
    None
  } else {
    Some((xij, yij))
  }
}

///|
fn new_grid_bilinear_interpolate_regular_latlon_value(
  source : NewGridRegularLatLonGrid,
  values : Array[Double],
  lon : Double,
  lat : Double,
) -> Double? {
  if source.nx <= 0 ||
    source.ny <= 0 ||
    values.length() != source.nx * source.ny {
    return None
  }
  let eps = 1.0e-6
  let adjusted_lon = if source.wraps_lon {
    let mut v = lon
    let span_end = source.lon_start + 360.0
    while v < source.lon_start {
      v += 360.0
    }
    while v >= span_end {
      v -= 360.0
    }
    v
  } else {
    lon
  }
  let mut x = if source.nx <= 1 {
    0.0
  } else {
    (adjusted_lon - source.lon_start) / source.dlon
  }
  let mut y = if source.ny <= 1 {
    0.0
  } else {
    (lat - source.lat_start) / source.dlat
  }
  if !source.wraps_lon {
    let max_x = (source.nx - 1).to_double()
    if x < -eps || x > max_x + eps {
      return None
    }
    if x < 0.0 {
      x = 0.0
    }
    if x > max_x {
      x = max_x
    }
  }
  let max_y = (source.ny - 1).to_double()
  if y < -eps || y > max_y + eps {
    return None
  }
  if y < 0.0 {
    y = 0.0
  }
  if y > max_y {
    y = max_y
  }
  let mut ix = if source.nx <= 1 { 0 } else { @math.floor(x).to_int() }
  let mut iy = if source.ny <= 1 { 0 } else { @math.floor(y).to_int() }
  if !source.wraps_lon &&
    source.nx > 1 &&
    ix.to_double() == x &&
    ix == source.nx - 1 {
    ix -= 1
  }
  if source.ny > 1 && iy.to_double() == y && iy == source.ny - 1 {
    iy -= 1
  }
  if ix < 0 || iy < 0 || ix >= source.nx || iy >= source.ny {
    return None
  }
  let ix1 = if source.nx <= 1 {
    ix
  } else if source.wraps_lon {
    if ix + 1 < source.nx {
      ix + 1
    } else {
      0
    }
  } else if ix + 1 < source.nx {
    ix + 1
  } else {
    ix
  }
  let iy1 = if source.ny <= 1 {
    iy
  } else if iy + 1 < source.ny {
    iy + 1
  } else {
    iy
  }
  let x_frac = if source.nx <= 1 {
    0.0
  } else {
    to_wgrib2_float32(x - ix.to_double())
  }
  let y_frac = if source.ny <= 1 { 0.0 } else { y - iy.to_double() }
  let v00 = values[ix + iy * source.nx]
  let v10 = values[ix1 + iy * source.nx]
  let v01 = values[ix + iy1 * source.nx]
  let v11 = values[ix1 + iy1 * source.nx]
  let one_minus_x = 1.0 - x_frac
  let one_minus_y = 1.0 - y_frac
  let w00 = one_minus_x * one_minus_y
  let w10 = x_frac * one_minus_y
  let w01 = one_minus_x * y_frac
  let w11 = x_frac * y_frac
  let mut weighted_sum = 0.0
  let mut valid_weight_sum = 0.0
  if v00 == v00 && w00 > 0.0 {
    weighted_sum += v00 * w00
    valid_weight_sum += w00
  }
  if v10 == v10 && w10 > 0.0 {
    weighted_sum += v10 * w10
    valid_weight_sum += w10
  }
  if v01 == v01 && w01 > 0.0 {
    weighted_sum += v01 * w01
    valid_weight_sum += w01
  }
  if v11 == v11 && w11 > 0.0 {
    weighted_sum += v11 * w11
    valid_weight_sum += w11
  }
  if valid_weight_sum < 0.5 || valid_weight_sum <= 0.0 {
    return None
  }
  let interpolated = to_wgrib2_float32(weighted_sum / valid_weight_sum)
  Some(interpolated)
}

///|
fn new_grid_bilinear_interpolate_regular_latlon_uv(
  source : NewGridRawSourceGrid,
  u_values : Array[Double],
  v_values : Array[Double],
  lon : Double,
  lat : Double,
) -> (Double, Double)? {
  if source.ni <= 0 ||
    source.nj <= 0 ||
    u_values.length() != source.ni * source.nj ||
    v_values.length() != source.ni * source.nj {
    return None
  }
  let (xij, yij) = match new_grid_raw_source_xij_yij(source, lon, lat) {
    Some(v) => v
    None => return None
  }
  let mut ix = if source.ni <= 1 { 1 } else { @math.floor(xij).to_int() }
  let mut iy = if source.nj <= 1 { 1 } else { @math.floor(yij).to_int() }
  if source.ni > 1 && ix.to_double() == xij && ix == source.ni {
    ix -= 1
  }
  if source.nj > 1 && iy.to_double() == yij && iy == source.nj {
    iy -= 1
  }
  let ix1 = if source.ni <= 1 { ix } else { ix + 1 }
  let iy1 = if source.nj <= 1 { iy } else { iy + 1 }
  let x_frac = if source.ni <= 1 { 0.0 } else { xij - ix.to_double() }
  let y_frac = if source.nj <= 1 { 0.0 } else { yij - iy.to_double() }
  let one_minus_x = 1.0 - x_frac
  let one_minus_y = 1.0 - y_frac
  let w00 = one_minus_x * one_minus_y
  let w10 = x_frac * one_minus_y
  let w01 = one_minus_x * y_frac
  let w11 = x_frac * y_frac
  let corners = [(ix, iy, w00), (ix1, iy, w10), (ix, iy1, w01), (ix1, iy1, w11)]
  let mut weighted_u = 0.0
  let mut weighted_v = 0.0
  let mut valid_weight_sum = 0.0
  for index in 0..<corners.length() {
    let (corner_i, corner_j, weight) = corners[index]
    let u = match
      new_grid_raw_source_value_at(source, u_values, corner_i, corner_j) {
      Some(v) => v
      None => continue
    }
    let v = match
      new_grid_raw_source_value_at(source, v_values, corner_i, corner_j) {
      Some(v) => v
      None => continue
    }
    if u == u && v == v && weight > 0.0 {
      let (corner_lon, corner_lat) = match
        new_grid_raw_source_lon_lat(source, corner_i, corner_j) {
        Some(v) => v
        None => continue
      }
      let (cm, sm) = new_grid_movect(corner_lat, corner_lon, lat, lon)
      let urot = cm * u - sm * v
      let vrot = sm * u + cm * v
      weighted_u += weight * urot
      weighted_v += weight * vrot
      valid_weight_sum += weight
    }
  }
  if valid_weight_sum < 0.5 || valid_weight_sum <= 0.0 {
    return None
  }
  Some(
    (
      to_wgrib2_float32(weighted_u / valid_weight_sum),
      to_wgrib2_float32(weighted_v / valid_weight_sum),
    ),
  )
}

///|
fn new_grid_bilinear_interpolate_raw_regular_latlon_value(
  source : NewGridRawSourceGrid,
  values : Array[Double],
  lon : Double,
  lat : Double,
) -> Double? {
  if source.ni <= 0 ||
    source.nj <= 0 ||
    values.length() != source.ni * source.nj {
    return None
  }
  let (xij, yij) = match new_grid_raw_source_xij_yij(source, lon, lat) {
    Some(v) => v
    None => return None
  }
  let mut ix = if source.ni <= 1 { 1 } else { @math.floor(xij).to_int() }
  let mut iy = if source.nj <= 1 { 1 } else { @math.floor(yij).to_int() }
  if source.ni > 1 && ix.to_double() == xij && ix == source.ni {
    ix -= 1
  }
  if source.nj > 1 && iy.to_double() == yij && iy == source.nj {
    iy -= 1
  }
  let ix1 = if source.ni <= 1 { ix } else { ix + 1 }
  let iy1 = if source.nj <= 1 { iy } else { iy + 1 }
  let x_frac = if source.ni <= 1 {
    0.0
  } else {
    to_wgrib2_float32(xij - ix.to_double())
  }
  let y_frac = if source.nj <= 1 { 0.0 } else { yij - iy.to_double() }
  let one_minus_x = 1.0 - x_frac
  let one_minus_y = 1.0 - y_frac
  let corners = [
    (ix, iy, one_minus_x * one_minus_y),
    (ix1, iy, x_frac * one_minus_y),
    (ix, iy1, one_minus_x * y_frac),
    (ix1, iy1, x_frac * y_frac),
  ]
  let mut weighted_sum = 0.0
  let mut valid_weight_sum = 0.0
  for index in 0..<corners.length() {
    let (corner_i, corner_j, weight) = corners[index]
    let value = match
      new_grid_raw_source_value_at(source, values, corner_i, corner_j) {
      Some(v) => v
      None => continue
    }
    if value == value && weight > 0.0 {
      weighted_sum += value * weight
      valid_weight_sum += weight
    }
  }
  if valid_weight_sum < 0.5 || valid_weight_sum <= 0.0 {
    return None
  }
  Some(to_wgrib2_float32(weighted_sum / valid_weight_sum))
}

///|
fn new_grid_neighbor_interpolate_raw_regular_latlon_value(
  source : NewGridRawSourceGrid,
  values : Array[Double],
  lon : Double,
  lat : Double,
) -> Double? {
  if source.ni <= 0 ||
    source.nj <= 0 ||
    values.length() != source.ni * source.nj {
    return None
  }
  let (xij, yij) = match new_grid_raw_source_xij_yij(source, lon, lat) {
    Some(v) => v
    None => return None
  }
  let i = @math.floor(xij + 0.5).to_int()
  let j = @math.floor(yij + 0.5).to_int()
  match new_grid_raw_source_value_at(source, values, i, j) {
    Some(v) => if v == v { Some(v) } else { None }
    None => None
  }
}

///|
fn new_grid_neighbor_interpolate_regular_latlon_uv(
  source : NewGridRawSourceGrid,
  u_values : Array[Double],
  v_values : Array[Double],
  lon : Double,
  lat : Double,
) -> (Double, Double)? {
  if source.ni <= 0 ||
    source.nj <= 0 ||
    u_values.length() != source.ni * source.nj ||
    v_values.length() != source.ni * source.nj {
    return None
  }
  let (xij, yij) = match new_grid_raw_source_xij_yij(source, lon, lat) {
    Some(v) => v
    None => return None
  }
  let i = @math.floor(xij + 0.5).to_int()
  let j = @math.floor(yij + 0.5).to_int()
  let u = match new_grid_raw_source_value_at(source, u_values, i, j) {
    Some(v) => v
    None => return None
  }
  let v = match new_grid_raw_source_value_at(source, v_values, i, j) {
    Some(v) => v
    None => return None
  }
  if !(u == u && v == v) {
    return None
  }
  let (corner_lon, corner_lat) = match
    new_grid_raw_source_lon_lat(source, i, j) {
    Some(v) => v
    None => return None
  }
  let (cm, sm) = new_grid_movect(corner_lat, corner_lon, lat, lon)
  Some((to_wgrib2_float32(cm * u - sm * v), to_wgrib2_float32(sm * u + cm * v)))
}

///|
fn new_grid_polfixv(
  target : NewGridRegularLatLonGrid,
  remapped_u : Array[Double],
  remapped_v : Array[Double],
) -> Unit {
  let total_points = target.nx * target.ny
  if remapped_u.length() != total_points || remapped_v.length() != total_points {
    return
  }
  let pi = 3.14159265358979
  let dpr = 180.0 / pi
  let rlatnp = 89.9995
  let rlatsp = -rlatnp
  let north_indices : Array[Int] = []
  let south_indices : Array[Int] = []
  for j in 0..<target.ny {
    let lat = target.lat_start + j.to_double() * target.dlat
    if lat >= rlatnp {
      for i in 0..<target.nx {
        north_indices.push(i + j * target.nx)
      }
    } else if lat <= rlatsp {
      for i in 0..<target.nx {
        south_indices.push(i + j * target.nx)
      }
    }
  }
  let apply_polfix = fn(indices : Array[Int], is_north : Bool) -> Unit {
    if indices.length() <= 1 {
      return
    }
    let mut valid_count = 0.0
    let mut acc_u = 0.0
    let mut acc_v = 0.0
    for index in indices {
      let u = remapped_u[index]
      let v = remapped_v[index]
      if u == u && v == v {
        let i = index % target.nx
        let lon = target.lon_start + i.to_double() * target.dlon
        let clon = @math.cos(lon / dpr)
        let slon = @math.sin(lon / dpr)
        if is_north {
          acc_u += clon * u - slon * v
          acc_v += slon * u + clon * v
        } else {
          acc_u += clon * u + slon * v
          acc_v += -slon * u + clon * v
        }
        valid_count += 1.0
      }
    }
    let threshold = indices.length().to_double() / 2.0
    let has_output = valid_count >= threshold && valid_count > 0.0
    let avg_u = if has_output { acc_u / valid_count } else { 0.0 }
    let avg_v = if has_output { acc_v / valid_count } else { 0.0 }
    for index in indices {
      let i = index % target.nx
      let lon = target.lon_start + i.to_double() * target.dlon
      let clon = @math.cos(lon / dpr)
      let slon = @math.sin(lon / dpr)
      if has_output {
        if is_north {
          remapped_u[index] = to_wgrib2_float32(clon * avg_u + slon * avg_v)
          remapped_v[index] = to_wgrib2_float32(-slon * avg_u + clon * avg_v)
        } else {
          remapped_u[index] = to_wgrib2_float32(clon * avg_u - slon * avg_v)
          remapped_v[index] = to_wgrib2_float32(slon * avg_u + clon * avg_v)
        }
      } else {
        remapped_u[index] = 0.0 / 0.0
        remapped_v[index] = 0.0 / 0.0
      }
    }
  }
  apply_polfix(north_indices, true)
  apply_polfix(south_indices, false)
}

///|
fn build_new_grid_wind_submessage_bytes(
  option_name : String,
  section3 : Bytes,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  values : Array[Double],
) -> Result[Bytes, String] {
  let (sec6, defined_values) = build_wind_section6_bytes_and_defined_values(
    message, submessage, values,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        meta.record_index.to_string(),
      )
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(section3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn build_new_grid_wind_pair_submessage_bytes(
  lon_spec : String,
  lat_spec : String,
  interpolation : String?,
  u_message : @context.Grib2MessageContext,
  u_submessage : @context.Grib2SubmessageFrame,
  u_meta : @decode.Grib2RecordMeta,
  v_message : @context.Grib2MessageContext,
  v_submessage : @context.Grib2SubmessageFrame,
  v_meta : @decode.Grib2RecordMeta,
) -> Result[(Bytes, Bytes), String] {
  let interpolation_method = match
    parse_new_grid_interpolation_method(interpolation) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let u_template_id = u_meta.section5_template.id()
  let v_template_id = v_meta.section5_template.id()
  if !wind_input_packing_supported(u_template_id) {
    return Err(
      "-new_grid is not implemented for U packing template " +
      u_template_id.to_string(),
    )
  }
  if !wind_input_packing_supported(v_template_id) {
    return Err(
      "-new_grid is not implemented for V packing template " +
      v_template_id.to_string(),
    )
  }
  let target = match build_new_grid_target_grid(lon_spec, lat_spec) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let source = match build_new_grid_raw_source_grid(u_meta) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let source_section3 = match
    @decode.decode_submessage_section3(u_message, u_submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 3 for -new_grid: \{e}")
  }
  let section3 = match
    build_identity_lola_section3_bytes(
      "-new_grid", source_section3, lon_spec, lat_spec,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let u_unpacked = match @decode.unpack_submessage_data(u_message, u_submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        u_meta.record_index.to_string() +
        " for -new_grid",
      )
  }
  let v_unpacked = match @decode.unpack_submessage_data(v_message, v_submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        v_meta.record_index.to_string() +
        " for -new_grid",
      )
  }
  let u_source_values = build_new_grid_raw_source_values(u_unpacked)
  let v_source_values = build_new_grid_raw_source_values(v_unpacked)
  let total_points = target.nx * target.ny
  let remapped_u : Array[Double] = []
  let remapped_v : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make((total_points + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  let mut point_index = 0
  for j in 0..<target.ny {
    let lat = target.lat_start + j.to_double() * target.dlat
    for i in 0..<target.nx {
      let lon = target.lon_start + i.to_double() * target.dlon
      let remapped = match interpolation_method {
        NewGridInterpolationBilinear =>
          new_grid_bilinear_interpolate_regular_latlon_uv(
            source, u_source_values, v_source_values, lon, lat,
          )
        NewGridInterpolationNeighbor =>
          new_grid_neighbor_interpolate_regular_latlon_uv(
            source, u_source_values, v_source_values, lon, lat,
          )
      }
      match remapped {
        Some((u, v)) => {
          remapped_u.push(u)
          remapped_v.push(v)
          bitmap_mark_defined(bitmap_out, point_index)
        }
        None => {
          needs_bitmap = true
          remapped_u.push(0.0 / 0.0)
          remapped_v.push(0.0 / 0.0)
        }
      }
      point_index += 1
    }
  }
  new_grid_polfixv(target, remapped_u, remapped_v)
  let u_bytes = match
    build_new_grid_wind_submessage_bytes(
      "-new_grid", section3, u_message, u_submessage, u_meta, remapped_u,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let v_bytes = match
    build_new_grid_wind_submessage_bytes(
      "-new_grid", section3, v_message, v_submessage, v_meta, remapped_v,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if needs_bitmap {
    let _ = bitmap_out
  }
  Ok((u_bytes, v_bytes))
}

///|
fn build_new_grid_submessage_bytes(
  lon_spec : String,
  lat_spec : String,
  interpolation : String?,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
) -> Result[Bytes, String] {
  let interpolation_method = match
    parse_new_grid_interpolation_method(interpolation) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      "-new_grid is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let target = match build_new_grid_target_grid(lon_spec, lat_spec) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let source = match build_new_grid_raw_source_grid(meta) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let source_section3 = match
    @decode.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 3 for -new_grid: \{e}")
  }
  let section3 = match
    build_identity_lola_section3_bytes(
      "-new_grid", source_section3, lon_spec, lat_spec,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for -new_grid",
      )
  }
  let source_values = build_new_grid_raw_source_values(unpacked)
  let total_points = target.nx * target.ny
  let remapped : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make((total_points + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  let mut point_index = 0
  for j in 0..<target.ny {
    let lat = target.lat_start + j.to_double() * target.dlat
    for i in 0..<target.nx {
      let lon = target.lon_start + i.to_double() * target.dlon
      let value = match interpolation_method {
        NewGridInterpolationBilinear =>
          new_grid_bilinear_interpolate_raw_regular_latlon_value(
            source, source_values, lon, lat,
          )
        NewGridInterpolationNeighbor =>
          new_grid_neighbor_interpolate_raw_regular_latlon_value(
            source, source_values, lon, lat,
          )
      }
      match value {
        Some(v) => {
          remapped.push(v)
          bitmap_mark_defined(bitmap_out, point_index)
        }
        None => needs_bitmap = true
      }
      point_index += 1
    }
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      remapped,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -new_grid record " +
        meta.record_index.to_string(),
      )
  }
  let sec6 = if needs_bitmap {
    @decode.encode_section6_bytes({
      bitmap_indicator: 0,
      bitmap_raw: Bytes::from_array(bitmap_out),
    })
  } else {
    build_no_bitmap_section6_bytes()
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(section3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}
