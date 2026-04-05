///|
priv struct CressLolaTargetGrid {
  lon_start : Double
  lon_end : Double
  lat_start : Double
  lat_end : Double
  nx : Int
  ny : Int
  dlon : Double
  dlat : Double
  row_lats : Array[Double]
  out_x : Array[Double]
  out_y : Array[Double]
  out_z : Array[Double]
}

///|
priv struct CressLolaSourceField {
  raw_values : Array[Double]
  raw_lons : Array[Double]
  raw_lats : Array[Double]
  raw_x : Array[Double]
  raw_y : Array[Double]
  raw_z : Array[Double]
  valid_count : Int
  valid_mean : Double
}

///|
fn cress_lola_to_wgrib2_float(value : Double) -> Double {
  Float::from_double(value).to_double()
}

///|
fn cress_lola_apply_scale_factor(
  scaled_value : Int,
  scale_factor : Int,
) -> Double {
  if scale_factor == 0 {
    scaled_value.to_double()
  } else {
    scaled_value.to_double() / pow10_int(scale_factor)
  }
}

///|
fn cress_lola_earth_radius_from_meta(meta : @decode.Grib2RecordMeta) -> Double {
  let (major, minor) : (Double, Double) = match meta.section3_shape_of_earth {
    0 => (6367470.0, 6367470.0)
    1 => {
      let r = cress_lola_apply_scale_factor(
        meta.section3_scaled_value_radius,
        meta.section3_scale_factor_radius,
      )
      (r, r)
    }
    2 => (6378160.0, 6356775.0)
    3 => {
      let a = cress_lola_apply_scale_factor(
          meta.section3_scaled_value_major,
          meta.section3_scale_factor_major,
        ) *
        1000.0
      let b = cress_lola_apply_scale_factor(
          meta.section3_scaled_value_minor,
          meta.section3_scale_factor_minor,
        ) *
        1000.0
      (a, b)
    }
    4 => (6378137.0, 6356752.140)
    5 => (6378137.0, 6356752.245)
    6 => (6371229.0, 6371229.0)
    7 => {
      let a = cress_lola_apply_scale_factor(
        meta.section3_scaled_value_major,
        meta.section3_scale_factor_major,
      )
      let b = cress_lola_apply_scale_factor(
        meta.section3_scaled_value_minor,
        meta.section3_scale_factor_minor,
      )
      (a, b)
    }
    8 => (6371200.0, 6371200.0)
    9 => (6377563.396, 6356256.909)
    _ => (6367470.0, 6367470.0)
  }
  0.5 * (major + minor)
}

///|
fn cress_lola_deg_to_rad(degrees : Double) -> Double {
  degrees * @math.PI / 180.0
}

///|
fn cress_lola_radius_abs(radius_km : Double) -> Double {
  if radius_km < 0.0 {
    -radius_km
  } else {
    radius_km
  }
}

///|
fn cress_lola_adjust_input_lon(lon : Double, lon_start : Double) -> Double {
  if lon < lon_start {
    lon + 360.0
  } else {
    lon
  }
}

///|
fn cress_lola_target_lon_wraps(target : CressLolaTargetGrid) -> Bool {
  target.nx > 1 && target.dlon * target.nx.to_double() >= 360.0 - 1.0e-6
}

///|
fn build_cress_lola_target_grid(
  lon_spec : String,
  lat_spec : String,
) -> Result[CressLolaTargetGrid, String] {
  let (lon_start, nx, dlon) = match parse_lola_axis(lon_spec) {
    Some(v) => v
    None => return Err("-cress_lola: invalid lon axis")
  }
  let (lat_start, ny, dlat) = match parse_lola_axis(lat_spec) {
    Some(v) => v
    None => return Err("-cress_lola: invalid lat axis")
  }
  if dlon <= 0.0 {
    return Err("-cress_lola: dlon must be positive")
  }
  if dlat <= 0.0 {
    return Err("-cress_lola: dlat must be positive")
  }
  let lon_end = lon_start + (nx - 1).to_double() * dlon
  let lat_end = lat_start + (ny - 1).to_double() * dlat
  if lat_start < -90.0 || lat_end > 90.0 {
    return Err("-cress_lola: latitude axis is out of range")
  }
  let row_lats : Array[Double] = []
  let out_x : Array[Double] = []
  let out_y : Array[Double] = []
  let out_z : Array[Double] = []
  for j in 0..<ny {
    let lat = lat_start + j.to_double() * dlat
    row_lats.push(lat)
    let lat_rad = cress_lola_deg_to_rad(lat)
    let s = @math.sin(lat_rad)
    let c = (1.0 - s * s).sqrt()
    for i in 0..<nx {
      let lon = lon_start + i.to_double() * dlon
      let lon_rad = cress_lola_deg_to_rad(lon)
      out_z.push(s)
      out_x.push(c * @math.cos(lon_rad))
      out_y.push(c * @math.sin(lon_rad))
    }
  }
  Ok({
    lon_start,
    lon_end,
    lat_start,
    lat_end,
    nx,
    ny,
    dlon,
    dlat,
    row_lats,
    out_x,
    out_y,
    out_z,
  })
}

///|
fn build_cress_lola_source_field(
  meta : @decode.Grib2RecordMeta,
  unpacked : Array[Double],
  target : CressLolaTargetGrid,
) -> Result[CressLolaSourceField, String] {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  let total_points = ni * nj
  if unpacked.length() != total_points {
    return Err(
      "-cress_lola requires ni*nj points, got " +
      unpacked.length().to_string() +
      " expected " +
      total_points.to_string(),
    )
  }
  let scan = @typed.parse_scanning_mode(meta.section3_scanning_mode)
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
  let west_lon = if scan.i_negative { lon2 } else { lon1 }
  let east_lon = if scan.i_negative { lon1 } else { lon2 }
  let south_lat = if scan.j_positive { lat1 } else { lat2 }
  let north_lat = if scan.j_positive { lat2 } else { lat1 }
  let dlon = if ni <= 1 {
    0.0
  } else {
    let mut east_lon = east_lon
    if east_lon < west_lon {
      east_lon += 360.0
    }
    (east_lon - west_lon) / (ni - 1).to_double()
  }
  let dlat = if nj <= 1 {
    0.0
  } else {
    (north_lat - south_lat).abs() / (nj - 1).to_double()
  }
  let raw_values = Array::make(total_points, 0.0 / 0.0)
  let raw_lons : Array[Double] = Array::make(total_points, 0.0)
  let raw_lats : Array[Double] = Array::make(total_points, 0.0)
  let raw_x : Array[Double] = Array::make(total_points, 0.0)
  let raw_y : Array[Double] = Array::make(total_points, 0.0)
  let raw_z : Array[Double] = Array::make(total_points, 0.0)
  let mut valid_count = 0
  let mut sum = 0.0
  for j_out in 0..<nj {
    let lat = south_lat + j_out.to_double() * dlat
    for i_out in 0..<ni {
      let canonical_index = i_out + j_out * ni
      let mut lon = west_lon + i_out.to_double() * dlon
      while lon < 0.0 {
        lon += 360.0
      }
      while lon >= 360.0 {
        lon -= 360.0
      }
      raw_lons[canonical_index] = lon
      raw_lats[canonical_index] = lat
      let value = cress_lola_to_wgrib2_float(unpacked[canonical_index])
      let adjusted_lon = cress_lola_adjust_input_lon(lon, target.lon_start)
      if value != value ||
        lat < target.lat_start ||
        lat > target.lat_end ||
        adjusted_lon > target.lon_end {
        continue
      }
      let lat_rad = cress_lola_deg_to_rad(lat)
      let s = @math.sin(lat_rad)
      let c = (1.0 - s * s).sqrt()
      let lon_rad = cress_lola_deg_to_rad(lon)
      raw_values[canonical_index] = value
      raw_z[canonical_index] = s
      raw_x[canonical_index] = c * @math.cos(lon_rad)
      raw_y[canonical_index] = c * @math.sin(lon_rad)
      valid_count += 1
      sum += value
    }
  }
  Ok({
    raw_values,
    raw_lons,
    raw_lats,
    raw_x,
    raw_y,
    raw_z,
    valid_count,
    valid_mean: if valid_count > 0 {
      sum / valid_count.to_double()
    } else {
      0.0
    },
  })
}

///|
fn cress_lola_background_value(
  target : CressLolaTargetGrid,
  background : Array[Double],
  lon : Double,
  lat : Double,
) -> Result[Double, String] {
  let nx = target.nx
  let ny = target.ny
  let x = if nx <= 1 {
    0.0
  } else {
    (cress_lola_adjust_input_lon(lon, target.lon_start) - target.lon_start) /
    target.dlon
  }
  let y = if ny <= 1 { 0.0 } else { (lat - target.lat_start) / target.dlat }
  let mut ix = if nx <= 1 { 0 } else { @math.floor(x).to_int() }
  let mut iy = if ny <= 1 { 0 } else { @math.floor(y).to_int() }
  if nx > 1 && ix.to_double() == x && ix == nx - 1 {
    ix -= 1
  }
  if ny > 1 && iy.to_double() == y && iy == ny - 1 {
    iy -= 1
  }
  if ix < 0 || iy < 0 || ix >= nx || iy >= ny {
    return Err("-cress_lola: source observation is outside the target grid")
  }
  let ix1 = if ix + 1 < nx { ix + 1 } else { ix }
  let iy1 = if iy + 1 < ny { iy + 1 } else { iy }
  let x_frac = if nx <= 1 { 0.0 } else { x - ix.to_double() }
  let y_frac = if ny <= 1 { 0.0 } else { y - iy.to_double() }
  let v00 = background[ix + iy * nx]
  let v10 = background[ix1 + iy * nx]
  let v01 = background[ix + iy1 * nx]
  let v11 = background[ix1 + iy1 * nx]
  Ok(
    v00 * (1.0 - x_frac) * (1.0 - y_frac) +
    v10 * x_frac * (1.0 - y_frac) +
    v01 * (1.0 - x_frac) * y_frac +
    v11 * x_frac * y_frac,
  )
}

///|
fn cress_lola_update_background_for_radius(
  target : CressLolaTargetGrid,
  source : CressLolaSourceField,
  background : Array[Double],
  radius_km : Double,
  earth_radius_m : Double,
) -> Result[Array[Bool]?, String] {
  let nx = target.nx
  let ny = target.ny
  let nxny = nx * ny
  let radius_unit = cress_lola_radius_abs(radius_km) / (earth_radius_m / 1000.0)
  let radius_sq = radius_unit * radius_unit
  let angular_radius = if radius_unit >= 2.0 {
    @math.PI
  } else {
    2.0 * @math.asin(radius_unit / 2.0)
  }
  let angular_radius_deg = angular_radius * 180.0 / @math.PI
  let inc : Array[Double] = Array::make(nxny, 0.0)
  let wt : Array[Double] = Array::make(nxny, 0.0)
  let wraps_lon = cress_lola_target_lon_wraps(target)
  for raw_index in 0..<source.raw_values.length() {
    let value = source.raw_values[raw_index]
    if value != value {
      continue
    }
    let background_value = match
      cress_lola_background_value(
        target,
        background,
        source.raw_lons[raw_index],
        source.raw_lats[raw_index],
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let increment = value - background_value
    let adjusted_lon = cress_lola_adjust_input_lon(
      source.raw_lons[raw_index],
      target.lon_start,
    )
    let obs_x = source.raw_x[raw_index]
    let obs_y = source.raw_y[raw_index]
    let obs_z = source.raw_z[raw_index]
    let mut j_start = ((
        source.raw_lats[raw_index] - target.lat_start - angular_radius_deg
      ) /
      target.dlat)
      .floor()
      .to_int() -
      1
    let mut j_end = ((
        source.raw_lats[raw_index] - target.lat_start + angular_radius_deg
      ) /
      target.dlat)
      .ceil()
      .to_int() +
      1
    if j_start < 0 {
      j_start = 0
    }
    if j_end >= ny {
      j_end = ny - 1
    }
    for j in j_start..<=j_end {
      let row_lat_rad = cress_lola_deg_to_rad(target.row_lats[j])
      let row_cos = @math.cos(row_lat_rad).abs()
      let lon_window_deg = if row_cos < 1.0e-12 {
        360.0
      } else {
        angular_radius_deg / row_cos
      }
      let left = adjusted_lon - target.lon_start - lon_window_deg
      let right = adjusted_lon - target.lon_start + lon_window_deg
      let scan_all_i = wraps_lon &&
        (left < 0.0 || right > target.lon_end - target.lon_start)
      let mut i_start = 0
      let mut i_end = nx - 1
      if !scan_all_i {
        i_start = (left / target.dlon).floor().to_int() - 1
        i_end = (right / target.dlon).ceil().to_int() + 1
        if i_start < 0 {
          i_start = 0
        }
        if i_end >= nx {
          i_end = nx - 1
        }
      }
      for i in i_start..<=i_end {
        let point = i + j * nx
        let dx = obs_x - target.out_x[point]
        let dy = obs_y - target.out_y[point]
        let dz = obs_z - target.out_z[point]
        let dist_sq = dx * dx + dy * dy + dz * dz
        if dist_sq < radius_sq {
          let weight = (radius_sq - dist_sq) / (radius_sq + dist_sq)
          wt[point] += weight
          inc[point] += weight * increment
        }
      }
    }
  }
  for point in 0..<nxny {
    if wt[point] > 0.0 {
      background[point] = cress_lola_to_wgrib2_float(
        background[point] + inc[point] / wt[point],
      )
    }
  }
  if radius_km < 0.0 {
    let mask = Array::make(nxny, false)
    for point in 0..<nxny {
      mask[point] = wt[point] > 0.0
    }
    Ok(Some(mask))
  } else {
    Ok(None)
  }
}

///|
fn build_cress_lola_masked_section6_and_defined_values(
  values : Array[Double],
  mask : Array[Bool],
) -> (Bytes, Array[Double]) {
  let bitmap_raw = Array::make((values.length() + 7) / 8, b'\x00')
  let defined_values : Array[Double] = []
  let mut has_undefined = false
  for index in 0..<values.length() {
    if mask[index] {
      bitmap_mark_defined(bitmap_raw, index)
      defined_values.push(values[index])
    } else {
      has_undefined = true
    }
  }
  let sec6 = if has_undefined {
    @decode.encode_section6_bytes({
      bitmap_indicator: 0,
      bitmap_raw: Bytes::from_array(bitmap_raw),
    })
  } else {
    build_no_bitmap_section6_bytes()
  }
  (sec6, defined_values)
}

///|
fn build_cress_lola_submessage_bytes(
  lon_spec : String,
  lat_spec : String,
  radii : Array[Double],
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
) -> Result[Bytes, String] {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err(
      "-cress_lola currently supports regular lat/lon grid (template 3.0)",
    )
  }
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 4 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      "-cress_lola is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let target = match build_cress_lola_target_grid(lon_spec, lat_spec) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let source_section3 = match
    @decode.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 3 for -cress_lola: \{e}")
  }
  let section3 = match
    build_identity_lola_section3_bytes(
      "-cress_lola", source_section3, lon_spec, lat_spec,
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
        " for -cress_lola",
      )
  }
  let source = match build_cress_lola_source_field(meta, unpacked, target) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7, sec6) = if source.valid_count == 0 {
    let rebuilt = match
      try_build_simple_packed_sections_with_scaling(
        [],
        meta.section5_reference_value_ieee,
        meta.section5_binary_scale_factor,
        meta.section5_decimal_scale_factor,
        original_field_value_type,
      ) {
      Some(v) => v
      None =>
        return Err(
          "failed to rebuild simple-packed data for -cress_lola record " +
          meta.record_index.to_string(),
        )
    }
    (
      rebuilt.0,
      rebuilt.1,
      build_all_undefined_bitmap_section6_bytes(target.nx * target.ny),
    )
  } else {
    let background : Array[Double] = Array::make(
      target.nx * target.ny,
      cress_lola_to_wgrib2_float(source.valid_mean),
    )
    let earth_radius_m = cress_lola_earth_radius_from_meta(meta)
    let mut final_mask : Array[Bool]? = None
    for radius in radii {
      match
        cress_lola_update_background_for_radius(
          target, source, background, radius, earth_radius_m,
        ) {
        Ok(mask) =>
          match mask {
            Some(v) => final_mask = Some(v)
            None => ()
          }
        Err(e) => return Err(e)
      }
    }
    let (sec6, packed_values) = match final_mask {
      Some(mask) =>
        build_cress_lola_masked_section6_and_defined_values(background, mask)
      None => (build_no_bitmap_section6_bytes(), background)
    }
    let rebuilt = match
      try_build_simple_packed_sections_with_scaling(
        packed_values,
        meta.section5_reference_value_ieee,
        meta.section5_binary_scale_factor,
        meta.section5_decimal_scale_factor,
        original_field_value_type,
      ) {
      Some(v) => v
      None =>
        return Err(
          "failed to rebuild simple-packed data for -cress_lola record " +
          meta.record_index.to_string(),
        )
    }
    (rebuilt.0, rebuilt.1, sec6)
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
fn write_cress_lola_output_impl(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  radii : Array[Double],
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for -cress_lola: " + record_index.to_string(),
          )
      }
      let bytes = match
        build_cress_lola_submessage_bytes(
          lon_spec, lat_spec, radii, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      append_bytes(out, bytes)
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}
