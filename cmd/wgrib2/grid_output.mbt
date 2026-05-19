///|
fn format_coord6(v : Double) -> String {
  let int_part = v.to_int()
  let frac_part = (v - int_part.to_double()).abs() * 1000000.0
  let frac_int = frac_part.to_int()
  let frac_str = frac_int.to_string()
  let padding = "0".repeat(6 - frac_str.length())
  if v < 0.0 && int_part == 0 {
    "-0." + padding + frac_str
  } else {
    int_part.to_string() + "." + padding + frac_str
  }
}

///|
fn grid_ij_to_latlon_from_meta(
  meta : @decode.Grib2RecordMeta,
  i : Int,
  j : Int,
) -> (Double, Double)? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
  let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
  let raw_di = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let raw_dj = meta.section3_dj_microdeg.to_double().abs() / 1000000.0
  let lon_span = {
    let raw = lon2 - lon1
    if raw < 0.0 {
      raw + 360.0
    } else {
      raw
    }
  }
  let di = if ni > 1 { lon_span / (ni - 1).to_double() } else { raw_di }
  let dj = if nj > 1 {
    (lat2 - lat1).abs() / (nj - 1).to_double()
  } else {
    raw_dj
  }
  let scan = meta.section3_scanning_mode
  let j_data = if (scan & 0x40) == 0 { nj - j + 1 } else { j }
  let i_inc = if (scan & 0x80) == 0 { di } else { -di }
  let j_inc = if (scan & 0x40) == 0 { -dj } else { dj }
  let mut lon = lon1 + (i - 1).to_double() * i_inc
  while lon < 0.0 {
    lon += 360.0
  }
  while lon >= 360.0 {
    lon -= 360.0
  }
  let lat = lat1 + (j_data - 1).to_double() * j_inc
  Some((lon, lat))
}

///|
fn grid_ij_to_latlon_microdeg_from_meta(
  meta : @decode.Grib2RecordMeta,
  i : Int,
  j : Int,
) -> (Int, Int)? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let lon1 = meta.section3_lon1_microdeg
  let lat1 = meta.section3_lat1_microdeg
  let lon2 = meta.section3_lon2_microdeg
  let lat2 = meta.section3_lat2_microdeg
  let scan = meta.section3_scanning_mode
  let west_lon = if (scan & 0x80) == 0 { lon1 } else { lon2 }
  let east_lon = if (scan & 0x80) == 0 { lon2 } else { lon1 }
  let south_lat = if (scan & 0x40) == 0 { lat2 } else { lat1 }
  let north_lat = if (scan & 0x40) == 0 { lat1 } else { lat2 }
  let lon_span = {
    let raw = east_lon - west_lon
    if raw < 0 {
      raw + 360_000_000
    } else {
      raw
    }
  }
  let interpolate_axis = fn(
    start : Int,
    span : Int,
    step : Int,
    denom : Int,
    sign : Int,
  ) {
    if denom <= 0 || step <= 0 {
      start
    } else {
      let delta = (span.to_int64() * step.to_int64() / denom.to_int64()).to_int()
      start + sign * delta
    }
  }
  let lat_span = {
    let raw = north_lat - south_lat
    if raw < 0 {
      -raw
    } else {
      raw
    }
  }
  let mut lon = interpolate_axis(west_lon, lon_span, i - 1, ni - 1, 1)
  while lon < 0 {
    lon += 360_000_000
  }
  while lon >= 360_000_000 {
    lon -= 360_000_000
  }
  let lat = interpolate_axis(south_lat, lat_span, j - 1, nj - 1, 1)
  Some((lon, lat))
}

///|
fn first_selected_record(selected : Array[Int]?) -> Int {
  match selected {
    Some(records) => if records.length() > 0 { records[0] } else { 1 }
    None => 1
  }
}

///|
fn error_final_op_name(op : ErrorFinalOperator) -> String {
  match op {
    ErrorFinalEq => "eq"
    ErrorFinalNe => "ne"
    ErrorFinalLe => "le"
    ErrorFinalLt => "lt"
    ErrorFinalGt => "gt"
    ErrorFinalGe => "ge"
  }
}

///|
fn error_final_count_matches(
  actual : Int,
  condition : ErrorFinalCountCondition,
) -> Bool {
  match condition.op {
    ErrorFinalEq => actual == condition.expected
    ErrorFinalNe => actual != condition.expected
    ErrorFinalLe => actual <= condition.expected
    ErrorFinalLt => actual < condition.expected
    ErrorFinalGt => actual > condition.expected
    ErrorFinalGe => actual >= condition.expected
  }
}

///|
fn error_final_message(init : CliInitOptions, actual : Int) -> String? {
  match init.error_final_count {
    Some(condition) =>
      if error_final_count_matches(actual, condition) {
        Some(
          "-error_final count " +
          error_final_op_name(condition.op) +
          " " +
          condition.expected.to_string() +
          " matched: count=" +
          actual.to_string(),
        )
      } else {
        None
      }
    None => None
  }
}

///|
fn selected_record_count(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
) -> Int {
  match selected {
    Some(records) => records.length()
    None => @decode.decode_records(context).length()
  }
}

///|
fn find_record_meta(
  context : @context.Grib2FileContext,
  record_index : Int,
) -> @decode.Grib2RecordMeta? {
  let records = @decode.decode_records(context)
  for meta in records {
    if meta.record_index == record_index {
      return Some(meta)
    }
  }
  None
}

///|
fn find_record_values(
  context : @context.Grib2FileContext,
  record_index : Int,
) -> Result[Array[Double], String] {
  let mut current = 1
  for message in context.messages {
    for submessage in message.submessages {
      if current == record_index {
        let unpacked = match @decode.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (AAIG output)",
            )
        }
        return Ok(unpacked.values)
      }
      current += 1
    }
  }
  Err("record not found for -AAIG: " + record_index.to_string())
}

///|
fn write_aaig_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
  long_name : Bool,
) -> Result[Unit, String] {
  let target_record = first_selected_record(selected)
  let meta = match find_record_meta(context, target_record) {
    Some(v) => v
    None =>
      return Err("record not found for -AAIG: " + target_record.to_string())
  }
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("-AAIG currently supports regular lat/lon grid (template 3.0)")
  }
  let values = match find_record_values(context, target_record) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if values.length() != ni * nj {
    return Err(
      "-AAIG requires ni*nj points, got " +
      values.length().to_string() +
      " expected " +
      (ni * nj).to_string(),
    )
  }
  let (lon_min, lat_min) = match grid_ij_to_latlon_from_meta(meta, 1, 1) {
    Some(v) => v
    None => return Err("failed to resolve lower-left grid point for -AAIG")
  }
  let cellsize = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let nodata = "9.999e20"
  let lines : Array[String] = []
  lines.push("ncols " + ni.to_string())
  lines.push("nrows " + nj.to_string())
  lines.push("xllcenter " + format_coord6(csv_lon_for_output(lon_min)))
  lines.push("yllcenter " + format_coord6(lat_min))
  lines.push("cellsize " + format_coord6(cellsize))
  lines.push("NODATA_VALUE " + nodata)
  for j = nj; j >= 1; j = j - 1 {
    for i = 1; i <= ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => continue
      }
      lines.push(format_aaig_value(values[idx]))
    }
  }
  let content = lines.join("\n") + "\n"
  if append_mode {
    native_append_string(destination, content)
  } else if long_name && !destination.has_suffix(".asc") {
    native_write_string(destination + ".asc", content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn parse_ijbox_axis(spec : String, max_n : Int) -> (Int, Int, Int)? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() < 2 || parts.length() > 3 {
    return None
  }
  let start = match parse_int_option(parts[0].to_string()) {
    Some(v) => v
    None => return None
  }
  let end = match parse_int_option(parts[1].to_string()) {
    Some(v) => v
    None => return None
  }
  let step = if parts.length() == 3 {
    match parse_int_option(parts[2].to_string()) {
      Some(v) => v
      None => return None
    }
  } else {
    1
  }
  if step <= 0 || start < 1 || end < start || end > max_n {
    return None
  }
  Some((start, end, step))
}

///|
fn value_index_for_ij(meta : @decode.Grib2RecordMeta, i : Int, j : Int) -> Int? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let scan_mode = meta.section3_scanning_mode
  let scan = @typed.parse_scanning_mode(scan_mode)
  let j_data = if scan.j_positive { j - 1 } else { nj - j }
  let i_data = if scan.i_negative { ni - i } else { i - 1 }
  Some(regular_grid_source_index_for_scan(ni, nj, scan_mode, i_data, j_data))
}

///|
fn write_ijbox_output(
  i_spec : String,
  j_spec : String,
  destination : String,
  mode : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let text_lines : Array[String] = []
  let out_bytes : Array[Byte] = []
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
          return Err("record not found for -ijbox: " + record_index.to_string())
      }
      if meta.section3_template.id() != 0 ||
        meta.section3_ni <= 0 ||
        meta.section3_nj <= 0 {
        return Err(
          "-ijbox currently supports regular lat/lon grid (template 3.0)",
        )
      }
      let (i_start, i_end, i_step) = match
        parse_ijbox_axis(i_spec, meta.section3_ni) {
        Some(v) => v
        None => return Err("invalid -ijbox i-spec: " + i_spec)
      }
      let (j_start, j_end, j_step) = match
        parse_ijbox_axis(j_spec, meta.section3_nj) {
        Some(v) => v
        None => return Err("invalid -ijbox j-spec: " + j_spec)
      }
      let values = match @decode.unpack_submessage_data(message, submessage) {
        Ok(v) => v.values
        Err(_) =>
          return Err(
            "failed to unpack record " +
            record_index.to_string() +
            " (ijbox output)",
          )
      }
      let ni = (i_end - i_start) / i_step + 1
      let nj = (j_end - j_start) / j_step + 1
      if mode == "spread" {
        text_lines.push(" i-index, j-index, value,")
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            text_lines.push(
              i.to_string() +
              ", " +
              j.to_string() +
              ", " +
              format_data_value(values[idx]) +
              ",",
            )
          }
        }
      } else if mode == "text" {
        let ordered : Array[Double] = []
        text_lines.push(ni.to_string() + " " + nj.to_string())
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            ordered.push(values[idx])
          }
        }
        append_text_value_lines(text_lines, ordered, 1, None)
      } else if mode == "bin" {
        let payload : Array[Byte] = []
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            append_f32_bytes(
              payload,
              normalize_binary_output_value(values[idx]),
              false,
            )
          }
        }
        append_u32_bytes(out_bytes, payload.length(), false)
        append_bytes(out_bytes, Bytes::from_array(payload))
        append_u32_bytes(out_bytes, payload.length(), false)
      } else {
        return Err("unsupported -ijbox mode: " + mode)
      }
      record_index += 1
    }
  }
  if mode == "bin" {
    let bytes = Bytes::from_array(out_bytes)
    if append_mode {
      native_append_bytes(destination, bytes)
    } else {
      native_write_bytes(destination, bytes)
    }
  } else {
    let content = build_output_content(text_lines, false)
    if append_mode {
      native_append_string(destination, content)
    } else {
      native_write_string(destination, content)
    }
  }
}

///|
fn write_ijsmall_grib_output(
  i_spec : String,
  j_spec : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for -ijsmall_grib: " + record_index.to_string(),
          )
      }
      if meta.section3_template.id() != 0 ||
        meta.section3_ni <= 0 ||
        meta.section3_nj <= 0 {
        return Err(
          "-ijsmall_grib currently supports regular lat/lon grid (template 3.0)",
        )
      }
      let (i_start, i_end, i_step) = match
        parse_ijbox_axis(i_spec, meta.section3_ni) {
        Some(v) => v
        None => return Err("invalid -ijsmall_grib i-spec: " + i_spec)
      }
      let (j_start, j_end, j_step) = match
        parse_ijbox_axis(j_spec, meta.section3_nj) {
        Some(v) => v
        None => return Err("invalid -ijsmall_grib j-spec: " + j_spec)
      }
      if i_start != 1 ||
        i_end != meta.section3_ni ||
        i_step != 1 ||
        j_start != 1 ||
        j_end != meta.section3_nj ||
        j_step != 1 {
        return Err(
          "-ijsmall_grib currently supports only full-domain window (1:ni:1,1:nj:1)",
        )
      }
      record_index += 1
    }
  }
  write_identity_full_domain_grib_output(
    "-ijsmall_grib", destination, context, selected, append_mode,
  )
}

///|
fn parse_small_grib_bounds(spec : String) -> (Double, Double)? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() != 2 {
    return None
  }
  let a = match parse_double_option(parts[0].to_string()) {
    Some(v) => v
    None => return None
  }
  let b = match parse_double_option(parts[1].to_string()) {
    Some(v) => v
    None => return None
  }
  Some((a, b))
}

///|
fn format_microdegree_decimal(value_microdeg : Int) -> String {
  format_fixed(value_microdeg.to_double() / 1000000.0, 6)
}

///|
fn full_domain_lola_specs_for_meta(
  meta : @decode.Grib2RecordMeta,
) -> (String, String)? {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return None
  }
  let lon1 = meta.section3_lon1_microdeg
  let lon2 = meta.section3_lon2_microdeg
  let lat1 = meta.section3_lat1_microdeg
  let lat2 = meta.section3_lat2_microdeg
  let lon_min = if lon1 < lon2 { lon1 } else { lon2 }
  let lat_min = if lat1 < lat2 { lat1 } else { lat2 }
  let di = if meta.section3_di_microdeg < 0 {
    -meta.section3_di_microdeg
  } else {
    meta.section3_di_microdeg
  }
  let dj = if meta.section3_dj_microdeg < 0 {
    -meta.section3_dj_microdeg
  } else {
    meta.section3_dj_microdeg
  }
  Some(
    (
      format_microdegree_decimal(lon_min) +
      ":" +
      meta.section3_ni.to_string() +
      ":" +
      format_microdegree_decimal(di),
      format_microdegree_decimal(lat_min) +
      ":" +
      meta.section3_nj.to_string() +
      ":" +
      format_microdegree_decimal(dj),
    ),
  )
}

///|
fn nearly_equal(a : Double, b : Double, eps : Double) -> Bool {
  (a - b).abs() <= eps
}

///|
fn write_identity_full_domain_grib_output(
  option_name : String,
  destination : String,
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
            "record not found for " +
            option_name +
            ": " +
            record_index.to_string(),
          )
      }
      let (lon_spec, lat_spec) = match full_domain_lola_specs_for_meta(meta) {
        Some(v) => v
        None =>
          return Err(
            option_name +
            " currently supports regular lat/lon grid (template 3.0)",
          )
      }
      let bytes = match
        build_identity_lola_submessage_bytes(
          option_name, lon_spec, lat_spec, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
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

///|
fn write_small_grib_output(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (lon_w, lon_e) = match parse_small_grib_bounds(lon_spec) {
    Some(v) => v
    None => return Err("invalid -small_grib lon spec: " + lon_spec)
  }
  let (lat_s, lat_n) = match parse_small_grib_bounds(lat_spec) {
    Some(v) => v
    None => return Err("invalid -small_grib lat spec: " + lat_spec)
  }
  let eps = 1.0e-6
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for -small_grib: " + record_index.to_string(),
          )
      }
      if meta.section3_template.id() != 0 ||
        meta.section3_ni <= 0 ||
        meta.section3_nj <= 0 {
        return Err(
          "-small_grib currently supports regular lat/lon grid (template 3.0)",
        )
      }
      let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
      let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
      let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
      let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
      let lon_min = if lon1 < lon2 { lon1 } else { lon2 }
      let lon_max = if lon1 < lon2 { lon2 } else { lon1 }
      let lat_min = if lat1 < lat2 { lat1 } else { lat2 }
      let lat_max = if lat1 < lat2 { lat2 } else { lat1 }
      if !(nearly_equal(lon_w, lon_min, eps) &&
        nearly_equal(lon_e, lon_max, eps) &&
        nearly_equal(lat_s, lat_min, eps) &&
        nearly_equal(lat_n, lat_max, eps)) {
        return Err(
          "-small_grib currently supports only full-domain bounds (" +
          lon_min.to_string() +
          ":" +
          lon_max.to_string() +
          ", " +
          lat_min.to_string() +
          ":" +
          lat_max.to_string() +
          ")",
        )
      }
      record_index += 1
    }
  }
  write_identity_full_domain_grib_output(
    "-small_grib", destination, context, selected, append_mode,
  )
}

///|
fn parse_lola_axis(spec : String) -> (Double, Int, Double)? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() != 3 {
    return None
  }
  let start = match parse_double_option(parts[0].to_string()) {
    Some(v) => v
    None => return None
  }
  let count = match parse_int_option(parts[1].to_string()) {
    Some(v) => v
    None => return None
  }
  let delta = match parse_double_option(parts[2].to_string()) {
    Some(v) => v
    None => return None
  }
  if count <= 0 || delta == 0.0 {
    return None
  }
  Some((start, count, delta))
}

///|
fn lola_matches_meta(
  meta : @decode.Grib2RecordMeta,
  lon_spec : String,
  lat_spec : String,
) -> Bool {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return false
  }
  let lon = match parse_lola_axis(lon_spec) {
    Some(v) => v
    None => return false
  }
  let lat = match parse_lola_axis(lat_spec) {
    Some(v) => v
    None => return false
  }
  let (lon_start, nlon, dlon) = lon
  let (lat_start, nlat, dlat) = lat
  if dlon <= 0.0 || dlat <= 0.0 {
    return false
  }
  if nlon != meta.section3_ni || nlat != meta.section3_nj {
    return false
  }
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
  let lon_min = if lon1 < lon2 { lon1 } else { lon2 }
  let lat_min = if lat1 < lat2 { lat1 } else { lat2 }
  let di = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let dj = meta.section3_dj_microdeg.to_double().abs() / 1000000.0
  let eps = 1.0e-6
  nearly_equal(lon_start, lon_min, eps) &&
  nearly_equal(lat_start, lat_min, eps) &&
  nearly_equal(dlon.abs(), di, eps) &&
  nearly_equal(dlat.abs(), dj, eps)
}

///|
fn parse_cress_lola_radii(spec : String) -> Array[Double]? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() == 0 {
    return None
  }
  let radii : Array[Double] = []
  for part in parts {
    let radius = match parse_double_option(part.to_string()) {
      Some(v) => v
      None => return None
    }
    radii.push(radius)
  }
  Some(radii)
}

///|
fn encode_template30_coord(
  value : Double,
  basic_angle : Int,
  subdivisions_of_basic_angle : Int,
) -> Int {
  let scaled = if basic_angle == 0 || subdivisions_of_basic_angle == 0 {
    value * 1000000.0
  } else {
    value *
    subdivisions_of_basic_angle.to_double() *
    1000000.0 /
    basic_angle.to_double()
  }
  if scaled >= 0.0 {
    @math.floor(scaled + 0.5).to_int()
  } else {
    -@math.floor(-scaled + 0.5).to_int()
  }
}

///|
fn build_identity_lola_section3_bytes(
  option_name : String,
  source_section3 : @decode.Grib2Section3Decoded,
  lon_spec : String,
  lat_spec : String,
) -> Result[Bytes, String] {
  let (lon_start, nlon, dlon) = match parse_lola_axis(lon_spec) {
    Some(v) => v
    None => return Err(option_name + ": invalid lon axis")
  }
  let (lat_start, nlat, dlat) = match parse_lola_axis(lat_spec) {
    Some(v) => v
    None => return Err(option_name + ": invalid lat axis")
  }
  match source_section3.template {
    @section3.GridTemplate30(grid) => {
      let section_subdivisions = if (
          option_name == "-new_grid" || option_name == "-cress_lola"
        ) &&
        grid.basic_angle == 0 &&
        grid.subdivisions_of_basic_angle == 0 {
        -1
      } else {
        grid.subdivisions_of_basic_angle
      }
      let lon_end = normalize_irr_grid_lon(
        lon_start + (nlon - 1).to_double() * dlon,
      )
      let lat_end = lat_start + (nlat - 1).to_double() * dlat
      Ok(
        @decode.encode_section3_bytes({
          source_of_grid_definition: source_section3.source_of_grid_definition,
          number_of_data_points: nlon * nlat,
          optional_points_octet_count: 0,
          optional_points_interpretation: 0,
          template: @section3.GridTemplate30({
            shape_of_earth: grid.shape_of_earth,
            scale_factor_radius: grid.scale_factor_radius,
            scaled_value_radius: grid.scaled_value_radius,
            scale_factor_major_axis: grid.scale_factor_major_axis,
            scaled_value_major_axis: grid.scaled_value_major_axis,
            scale_factor_minor_axis: grid.scale_factor_minor_axis,
            scaled_value_minor_axis: grid.scaled_value_minor_axis,
            ni: nlon,
            nj: nlat,
            basic_angle: grid.basic_angle,
            subdivisions_of_basic_angle: section_subdivisions,
            la1: encode_i32_sign_magnitude(
              encode_template30_coord(
                lat_start,
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            lo1: encode_i32_sign_magnitude(
              encode_template30_coord(
                normalize_irr_grid_lon(lon_start),
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            resolution_and_component_flags: grid.resolution_and_component_flags,
            la2: encode_i32_sign_magnitude(
              encode_template30_coord(
                lat_end,
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            lo2: encode_i32_sign_magnitude(
              encode_template30_coord(
                lon_end,
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            di: encode_template30_coord(
              dlon,
              grid.basic_angle,
              grid.subdivisions_of_basic_angle,
            ),
            dj: encode_template30_coord(
              dlat,
              grid.basic_angle,
              grid.subdivisions_of_basic_angle,
            ),
            scanning_mode: 64,
          }),
          optional_points_raw: b"",
        }),
      )
    }
    _ =>
      Err(
        option_name + " currently supports regular lat/lon grid (template 3.0)",
      )
  }
}

///|
fn build_identity_lola_submessage_bytes(
  option_name : String,
  lon_spec : String,
  lat_spec : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
) -> Result[Bytes, String] {
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      option_name +
      " is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let source_section3 = match
    @decode.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err("failed to decode Section 3 for " + option_name + ": \{e}")
  }
  let section3 = match
    build_identity_lola_section3_bytes(
      option_name, source_section3, lon_spec, lat_spec,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for " +
        option_name,
      )
  }
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err(
      "failed to derive regular-grid values for " +
      option_name +
      " record " +
      meta.record_index.to_string(),
    )
  }
  let defined_values : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make((total_points + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  let mut point = 0
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => return Err("invalid ij point in " + option_name)
      }
      let value = unpacked[idx]
      if value == value {
        defined_values.push(value)
        bitmap_mark_defined(bitmap_out, point)
      } else {
        needs_bitmap = true
      }
      point += 1
    }
  }
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
  let sec6 = if needs_bitmap {
    @decode.encode_section6_bytes({
      bitmap_indicator: 0,
      bitmap_raw: Bytes::from_array(bitmap_out),
    })
  } else {
    @decode.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
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
fn write_identity_lola_grib_output(
  option_name : String,
  lon_spec : String,
  lat_spec : String,
  destination : String,
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
            "record not found for " +
            option_name +
            ": " +
            record_index.to_string(),
          )
      }
      if !lola_matches_meta(meta, lon_spec, lat_spec) {
        return Err(
          option_name +
          " currently supports only identity remap (same regular lat/lon grid)",
        )
      }
      let bytes = match
        build_identity_lola_submessage_bytes(
          option_name, lon_spec, lat_spec, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
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

///|
fn write_lola_output(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  mode : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  crlf : Bool,
  append_mode : Bool,
  text_col : Int?,
  text_fmt : String?,
  binary_big_endian : Bool,
) -> Result[Unit, String] {
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err(
              "record not found for -lola: " + record_index.to_string(),
            )
        }
        if !lola_matches_meta(meta, lon_spec, lat_spec) {
          return Err(
            "-lola currently supports only identity remap (same regular lat/lon grid)",
          )
        }
      }
      record_index += 1
    }
  }
  if mode == "bin" {
    write_binary_output(
      destination, context, selected, append_mode, binary_big_endian,
    )
  } else if mode == "text" {
    write_text_output(
      destination, context, selected, crlf, append_mode, false, text_col, text_fmt,
    )
  } else if mode == "spread" {
    write_spread_output(
      destination, context, selected, crlf, append_mode, text_fmt,
    )
  } else if mode == "grib" {
    write_identity_lola_grib_output(
      "-lola", lon_spec, lat_spec, destination, context, selected, append_mode,
    )
  } else {
    Err("unsupported -lola mode: " + mode)
  }
}

///|
fn write_cress_lola_output(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  radii_spec : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let radii = match parse_cress_lola_radii(radii_spec) {
    Some(v) => v
    None =>
      return Err("-cress_lola radius list must be numbers separated by ':'")
  }
  write_cress_lola_output_impl(
    lon_spec, lat_spec, destination, radii, context, selected, append_mode,
  )
}

///|
fn write_new_grid_output(
  projection : String,
  lon_spec : String,
  lat_spec : String,
  destination : String,
  interpolation : String?,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if projection != "latlon" {
    return Err("-new_grid currently supports only latlon projection")
  }
  let metas = @decode.decode_records(context)
  let refs = collect_selected_record_refs(context, selected)
  let u_candidates : Map[Bytes, SelectedRecordRef] = {}
  let v_candidates : Map[Bytes, SelectedRecordRef] = {}
  for record_ref in refs {
    let meta_index = record_ref.record_index - 1
    if meta_index >= metas.length() {
      continue
    }
    let meta = metas[meta_index]
    if !is_wind_u_component(meta) && !is_wind_v_component(meta) {
      continue
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let pair_key = build_wind_pair_key(message, submessage)
    if pair_key.length() == 0 {
      continue
    }
    if is_wind_u_component(meta) {
      u_candidates.set(pair_key, record_ref)
    } else if is_wind_v_component(meta) {
      v_candidates.set(pair_key, record_ref)
    }
  }
  let consumed = Array::make(metas.length() + 1, false)
  let out : Array[Byte] = []
  for record_ref in refs {
    if record_ref.record_index < consumed.length() &&
      consumed[record_ref.record_index] {
      continue
    }
    let record_index = record_ref.record_index
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta_index = record_index - 1
    if meta_index >= metas.length() {
      continue
    }
    let meta = metas[meta_index]
    let is_identity = lola_matches_meta(meta, lon_spec, lat_spec)
    let scan = @typed.parse_scanning_mode(meta.section3_scanning_mode)
    if !is_identity &&
      scan.alternating_rows &&
      (is_wind_u_component(meta) || is_wind_v_component(meta)) {
      let pair_key = build_wind_pair_key(message, submessage)
      if pair_key.length() == 0 {
        consumed[record_index] = true
        continue
      }
      let u_ref = match u_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let v_ref = match v_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let first_index = if u_ref.record_index < v_ref.record_index {
        u_ref.record_index
      } else {
        v_ref.record_index
      }
      if record_index != first_index {
        continue
      }
      let u_meta = metas[u_ref.record_index - 1]
      let v_meta = metas[v_ref.record_index - 1]
      let (first_meta, second_meta) = if u_ref.record_index <=
        v_ref.record_index {
        (u_meta, v_meta)
      } else {
        (v_meta, u_meta)
      }
      for
        line in new_grid_wgrib2_alternating_rows_pair_notice_lines(
          first_meta, second_meta,
        ) {
        println(line)
      }
      consumed[u_ref.record_index] = true
      consumed[v_ref.record_index] = true
      continue
    }
    if !is_identity && scan.alternating_rows {
      for line in new_grid_wgrib2_alternating_rows_notice_lines(meta) {
        println(line)
      }
      consumed[record_index] = true
      continue
    }
    if !is_identity && (is_wind_u_component(meta) || is_wind_v_component(meta)) {
      let pair_key = build_wind_pair_key(message, submessage)
      if pair_key.length() == 0 {
        consumed[record_index] = true
        continue
      }
      let u_ref = match u_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let v_ref = match v_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let first_index = if u_ref.record_index < v_ref.record_index {
        u_ref.record_index
      } else {
        v_ref.record_index
      }
      if record_index != first_index {
        continue
      }
      let u_meta = metas[u_ref.record_index - 1]
      let v_meta = metas[v_ref.record_index - 1]
      let u_message = context.messages[u_ref.message_index]
      let u_submessage = u_message.submessages[u_ref.submessage_index]
      let v_message = context.messages[v_ref.message_index]
      let v_submessage = v_message.submessages[v_ref.submessage_index]
      let (u_bytes, v_bytes) = match
        build_new_grid_wind_pair_submessage_bytes(
          lon_spec, lat_spec, interpolation, u_message, u_submessage, u_meta, v_message,
          v_submessage, v_meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, u_bytes)
      append_bytes(out, v_bytes)
      consumed[u_ref.record_index] = true
      consumed[v_ref.record_index] = true
      continue
    }
    let bytes = if is_identity {
      match
        build_identity_lola_submessage_bytes(
          "-new_grid", lon_spec, lat_spec, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
    } else {
      match
        build_new_grid_submessage_bytes(
          lon_spec, lat_spec, interpolation, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
    }
    append_bytes(out, bytes)
    consumed[record_index] = true
  }
  if append_mode {
    let _ = native_append_bytes(destination, Bytes::from_array(out))
  } else {
    let _ = native_write_bytes(destination, Bytes::from_array(out))
  }
  Ok(())
}

///|
fn normalize_irr_grid_lon(lon : Double) -> Double {
  let mut normalized = lon
  while normalized < 0.0 {
    normalized += 360.0
  }
  while normalized >= 360.0 {
    normalized -= 360.0
  }
  normalized
}

///|
fn irr_grid_microdegrees(value : Double) -> Int {
  let scaled = value * 1000000.0
  if scaled >= 0.0 {
    @math.floor(scaled + 0.5).to_int()
  } else {
    -@math.floor(-scaled + 0.5).to_int()
  }
}

///|
fn parse_irr_grid_requested_points(
  spec : String,
) -> Result[Array[IrrGridRequestedPoint], String] {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() < 2 || parts.length() % 2 != 0 {
    return Err("irr_grid: need lon0:lat0:lon1:lat1:..:lonN:latN")
  }
  let points : Array[IrrGridRequestedPoint] = []
  let mut index = 0
  while index < parts.length() {
    let lon_raw = parts[index].to_string()
    let lat_raw = parts[index + 1].to_string()
    let lon = match parse_double_option(lon_raw) {
      Some(v) => normalize_irr_grid_lon(v)
      None => return Err("irr_grid: lat-lon list, " + spec)
    }
    let lat = match parse_double_option(lat_raw) {
      Some(v) => v
      None => return Err("irr_grid: lat-lon list, " + spec)
    }
    if lat < -90.0 || lat > 90.0 {
      return Err("irr_grid: bad latitude")
    }
    points.push({
      lon_microdeg: irr_grid_microdegrees(lon),
      lat_microdeg: irr_grid_microdegrees(lat),
    })
    index += 2
  }
  Ok(points)
}

///|
fn validate_irr_grid_radius(radius_spec : String) -> Result[Unit, String] {
  match parse_double_option(radius_spec) {
    Some(_) => Ok(())
    None => Err("irr_grid: radius " + radius_spec)
  }
}

///|
fn irr_grid_lon_delta_abs_microdeg(a : Int, b : Int) -> Int {
  let raw = (a - b).abs()
  if raw > 180_000_000 {
    360_000_000 - raw
  } else {
    raw
  }
}

///|
fn find_nearest_grid_point_for_irr_grid(
  meta : @decode.Grib2RecordMeta,
  point : IrrGridRequestedPoint,
) -> Result[(Int, Int), String] {
  let mut found = false
  let mut best_i = 1
  let mut best_j = 1
  let mut best_distance = 0L
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let (lon_microdeg, lat_microdeg) = match
        grid_ij_to_latlon_microdeg_from_meta(meta, i, j) {
        Some(v) => v
        None => return Err("failed to derive lon/lat for -irr_grid")
      }
      let lon_delta = irr_grid_lon_delta_abs_microdeg(
        point.lon_microdeg,
        lon_microdeg,
      )
      let lat_delta = (point.lat_microdeg - lat_microdeg).abs()
      let distance = lon_delta.to_int64() * lon_delta.to_int64() +
        lat_delta.to_int64() * lat_delta.to_int64()
      if !found || distance < best_distance {
        found = true
        best_i = i
        best_j = j
        best_distance = distance
      }
    }
  }
  if found {
    Ok((best_i, best_j))
  } else {
    Err("failed to derive lon/lat for -irr_grid")
  }
}

///|
fn collect_points_for_irr_grid(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  requested_points : Array[IrrGridRequestedPoint],
) -> Result[(Array[Int], Array[Int], Array[Double], Bytes?), String] {
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) => return Err("failed to unpack data for -irr_grid")
  }
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err("failed to derive regular-grid values for -irr_grid")
  }
  let latitudes : Array[Int] = []
  let longitudes : Array[Int] = []
  let defined_values : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make(
    (requested_points.length() + 7) / 8,
    b'\x00',
  )
  let mut needs_bitmap = false
  for point_index in 0..<requested_points.length() {
    let point = requested_points[point_index]
    let (i, j) = match find_nearest_grid_point_for_irr_grid(meta, point) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let idx = match value_index_for_ij(meta, i, j) {
      Some(v) => v
      None => return Err("invalid ij point in -irr_grid")
    }
    latitudes.push(point.lat_microdeg)
    longitudes.push(point.lon_microdeg)
    let value = unpacked[idx]
    if value == value {
      defined_values.push(value)
      bitmap_mark_defined(bitmap_out, point_index)
    } else {
      needs_bitmap = true
    }
  }
  Ok(
    (
      latitudes,
      longitudes,
      defined_values,
      if needs_bitmap {
        Some(Bytes::from_array(bitmap_out))
      } else {
        None
      },
    ),
  )
}

///|
fn build_irr_grid_submessage_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  requested_points : Array[IrrGridRequestedPoint],
) -> Result[Bytes, String] {
  let (latitudes_microdeg, longitudes_microdeg, defined_values, bitmap_raw) = match
    collect_points_for_irr_grid(message, submessage, meta, requested_points) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect values for -irr_grid record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec3 = build_grib_out_irr_section3_bytes(
    meta, latitudes_microdeg, longitudes_microdeg,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let rebuilt = match
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
        "failed to rebuild simple-packed data for -irr_grid record " +
        meta.record_index.to_string(),
      )
  }
  let (sec5, sec7) = rebuilt
  let sec6 = match bitmap_raw {
    Some(v) =>
      @decode.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw: v })
    None =>
      @decode.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_irr_grid_output(
  requested_points_spec : String,
  radius_spec : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let requested_points = match
    parse_irr_grid_requested_points(requested_points_spec) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  match validate_irr_grid_radius(radius_spec) {
    Ok(_) => ()
    Err(e) => return Err(e)
  }
  let metas = @decode.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -irr_grid record " +
            record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        if meta.section3_template.id() != 0 ||
          meta.section3_ni <= 0 ||
          meta.section3_nj <= 0 {
          return Err(
            "-irr_grid currently supports regular lat/lon grid (template 3.0)",
          )
        }
        let bytes = match
          build_irr_grid_submessage_bytes(
            message, submessage, meta, requested_points,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_grib_out_irr_output(
  selector : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if selector != "all" && selector != "defined" {
    return Err("-grib_out_irr selector must be all or defined")
  }
  let metas = @decode.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -grib_out_irr record " +
            record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        if meta.section3_template.id() != 0 ||
          meta.section3_ni <= 0 ||
          meta.section3_nj <= 0 {
          return Err(
            "-grib_out_irr currently supports regular lat/lon grid (template 3.0)",
          )
        }
        let bytes = match
          build_grib_out_irr_submessage_bytes(
            message, submessage, meta, selector,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn collect_points_for_grib_out_irr(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  selector : String,
) -> Result[(Array[Int], Array[Int], Array[Double], Bytes?), String] {
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) => return Err("failed to unpack data for -grib_out_irr")
  }
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err("failed to derive regular-grid values for -grib_out_irr")
  }
  let latitudes : Array[Int] = []
  let longitudes : Array[Int] = []
  let defined_values : Array[Double] = []
  if selector == "defined" {
    for j = 1; j <= meta.section3_nj; j = j + 1 {
      for i = 1; i <= meta.section3_ni; i = i + 1 {
        let idx = match value_index_for_ij(meta, i, j) {
          Some(v) => v
          None => return Err("invalid ij point in -grib_out_irr")
        }
        let value = unpacked[idx]
        if value != value {
          continue
        }
        let (lon_microdeg, lat_microdeg) = match
          grid_ij_to_latlon_microdeg_from_meta(meta, i, j) {
          Some(v) => v
          None => return Err("failed to derive lon/lat for -grib_out_irr")
        }
        latitudes.push(lat_microdeg)
        longitudes.push(lon_microdeg)
        defined_values.push(value)
      }
    }
    return Ok((latitudes, longitudes, defined_values, None))
  }
  let bitmap_out : Array[Byte] = Array::make((total_points + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  let mut point = 0
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => return Err("invalid ij point in -grib_out_irr")
      }
      let (lon_microdeg, lat_microdeg) = match
        grid_ij_to_latlon_microdeg_from_meta(meta, i, j) {
        Some(v) => v
        None => return Err("failed to derive lon/lat for -grib_out_irr")
      }
      latitudes.push(lat_microdeg)
      longitudes.push(lon_microdeg)
      let value = unpacked[idx]
      if value == value {
        defined_values.push(value)
        bitmap_mark_defined(bitmap_out, point)
      } else {
        needs_bitmap = true
      }
      point += 1
    }
  }
  Ok(
    (
      latitudes,
      longitudes,
      defined_values,
      if needs_bitmap {
        Some(Bytes::from_array(bitmap_out))
      } else {
        None
      },
    ),
  )
}

///|
fn build_grib_out_irr_section3_bytes(
  meta : @decode.Grib2RecordMeta,
  latitudes_microdeg : Array[Int],
  longitudes_microdeg : Array[Int],
) -> Bytes {
  let npts = latitudes_microdeg.length()
  let out : Array[Byte] = []
  append_u32_bytes(out, 30 + npts * 8, true)
  out.push(b'\x03')
  out.push(b'\x00')
  append_u32_bytes(out, npts, true)
  out.push(b'\x00')
  out.push(b'\x00')
  out.push(b'\x00')
  out.push(b'\x82')
  out.push(meta.section3_shape_of_earth.to_byte())
  out.push(meta.section3_scale_factor_radius.to_byte())
  append_u32_bytes(out, meta.section3_scaled_value_radius, true)
  out.push(meta.section3_scale_factor_major.to_byte())
  append_u32_bytes(out, meta.section3_scaled_value_major, true)
  out.push(meta.section3_scale_factor_minor.to_byte())
  append_u32_bytes(out, meta.section3_scaled_value_minor, true)
  for point in 0..<npts {
    append_u32_bytes(
      out,
      encode_i32_sign_magnitude(latitudes_microdeg[point]),
      true,
    )
    append_u32_bytes(
      out,
      encode_i32_sign_magnitude(longitudes_microdeg[point]),
      true,
    )
  }
  Bytes::from_array(out)
}

///|
fn build_grib_out_irr_submessage_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  selector : String,
) -> Result[Bytes, String] {
  let (latitudes_microdeg, longitudes_microdeg, defined_values, bitmap_raw) = match
    collect_points_for_grib_out_irr(message, submessage, meta, selector) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect values for -grib_out_irr record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec3 = build_grib_out_irr_section3_bytes(
    meta, latitudes_microdeg, longitudes_microdeg,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let rebuilt = match
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
        "failed to rebuild simple-packed data for -grib_out_irr record " +
        meta.record_index.to_string(),
      )
  }
  let (sec5, sec7) = rebuilt
  let sec6 = match bitmap_raw {
    Some(v) =>
      @decode.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw: v })
    None =>
      @decode.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn uuid_hex_value(code_unit : UInt16) -> Int? {
  let code = code_unit.to_int()
  if code >= '0'.to_int() && code <= '9'.to_int() {
    return Some(code - '0'.to_int())
  }
  if code >= 'a'.to_int() && code <= 'f'.to_int() {
    return Some(code - 'a'.to_int() + 10)
  }
  if code >= 'A'.to_int() && code <= 'F'.to_int() {
    return Some(code - 'A'.to_int() + 10)
  }
  None
}

///|
fn parse_uuid_bytes(uuid : String) -> Bytes? {
  if uuid.length() != 36 {
    return None
  }
  for hyphen_index in [8, 13, 18, 23] {
    if uuid[hyphen_index].to_int() != '-'.to_int() {
      return None
    }
  }
  let out : Array[Byte] = []
  let mut index = 0
  while index < uuid.length() {
    if uuid[index].to_int() == '-'.to_int() {
      index += 1
      continue
    }
    if index + 1 >= uuid.length() {
      return None
    }
    let high = match uuid_hex_value(uuid[index]) {
      Some(v) => v
      None => return None
    }
    let low = match uuid_hex_value(uuid[index + 1]) {
      Some(v) => v
      None => return None
    }
    out.push(((high << 4) | low).to_byte())
    index += 2
  }
  if out.length() != 16 {
    return None
  }
  Some(Bytes::from_array(out))
}

///|
fn bitmap_mark_defined(bitmap_raw : Array[Byte], bit_index : Int) -> Unit {
  let byte_index = bit_index / 8
  if byte_index >= bitmap_raw.length() {
    return
  }
  let bit_offset = 7 - bit_index % 8
  let mask = 1 << bit_offset
  let current = bitmap_raw[byte_index].to_uint().reinterpret_as_int()
  bitmap_raw[byte_index] = (current | mask).to_byte()
}

///|
fn collect_points_for_grib_out_irr2(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  npnts : Int,
) -> Result[(Array[Double], Bytes?), String] {
  let wgrib2_scan_order = match
    @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) => return Err("failed to unpack data for -grib_out_irr2")
  }
  let defined_values : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make((npnts + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  for point in 0..<npnts {
    let defined = if point < wgrib2_scan_order.length() {
      let value = wgrib2_scan_order[point]
      value == value
    } else {
      false
    }
    if defined {
      defined_values.push(wgrib2_scan_order[point])
      bitmap_mark_defined(bitmap_out, point)
    } else {
      needs_bitmap = true
    }
  }
  Ok(
    (
      defined_values,
      if needs_bitmap {
        Some(Bytes::from_array(bitmap_out))
      } else {
        None
      },
    ),
  )
}

///|
fn build_grib_out_irr2_section3_bytes(
  npnts : Int,
  grid_no : Int,
  grid_ref : Int,
  uuid_bytes : Bytes,
  shape_of_earth : Int,
) -> Bytes {
  let section3 : @decode.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: npnts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate3101({
      shape_of_earth,
      number_of_grid_used: grid_no,
      number_of_grid_in_reference: grid_ref,
      uuid_of_horizontal_grid: uuid_bytes,
    }),
    optional_points_raw: b"",
  }
  @decode.encode_section3_bytes(section3)
}

///|
fn build_grib_out_irr2_submessage_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  npnts : Int,
  grid_no : Int,
  grid_ref : Int,
  uuid_bytes : Bytes,
) -> Result[Bytes, String] {
  let (defined_values, bitmap_raw) = match
    collect_points_for_grib_out_irr2(message, submessage, npnts) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect values for -grib_out_irr2 record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
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
        "failed to rebuild simple-packed data for -grib_out_irr2 record " +
        meta.record_index.to_string(),
      )
  }
  let sec3 = build_grib_out_irr2_section3_bytes(
    npnts,
    grid_no,
    grid_ref,
    uuid_bytes,
    if meta.section3_shape_of_earth >= 0 {
      meta.section3_shape_of_earth
    } else {
      0
    },
  )
  let sec6 = match bitmap_raw {
    Some(v) =>
      @decode.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw: v })
    None =>
      @decode.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_grib_out_irr2_output(
  npnts : String,
  grid_no : String,
  grid_ref : String,
  uuid : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let npnts_int = match parse_int_option(npnts) {
    Some(v) => v
    None => return Err("-grib_out_irr2 npnts must be an integer")
  }
  if npnts_int <= 0 {
    return Err("-grib_out_irr2 npnts must be > 0")
  }
  let grid_no_int = match parse_int_option(grid_no) {
    Some(v) => v
    None => return Err("-grib_out_irr2 grid_no must be an integer")
  }
  if grid_no_int < 0 || grid_no_int > 16777215 {
    return Err("-grib_out_irr2 grid_no must be in 0..16777215")
  }
  let grid_ref_int = match parse_int_option(grid_ref) {
    Some(v) => v
    None => return Err("-grib_out_irr2 grid_ref must be an integer")
  }
  if grid_ref_int < 0 || grid_ref_int > 255 {
    return Err("-grib_out_irr2 grid_ref must be in 0..255")
  }
  let uuid_bytes = match parse_uuid_bytes(uuid) {
    Some(v) => v
    None =>
      return Err("-grib_out_irr2 uuid must be a canonical 36-char hex UUID")
  }
  let metas = @decode.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -grib_out_irr2 record " +
            record_index.to_string(),
          )
        }
        let bytes = match
          build_grib_out_irr2_submessage_bytes(
            message,
            submessage,
            metas[meta_index],
            npnts_int,
            grid_no_int,
            grid_ref_int,
            uuid_bytes,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_new_grid_order_output(
  out_path : String,
  out2_path : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  // Limited compatibility: write selected records to out_path and create/append out2_path.
  match write_raw_output(out_path, context, selected, append_mode) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if append_mode {
    native_append_bytes(out2_path, Bytes::new(0))
  } else {
    native_write_bytes(out2_path, Bytes::new(0))
  }
}

///|
fn collect_selected_record_refs(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
) -> Array[SelectedRecordRef] {
  let refs : Array[SelectedRecordRef] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      if record_is_selected(record_index, selected) {
        refs.push({ record_index, message_index, submessage_index })
      }
      record_index += 1
    }
  }
  refs
}

///|
fn vector_pair_messages_compatible(
  context : @context.Grib2FileContext,
  lhs : SelectedRecordRef,
  rhs : SelectedRecordRef,
) -> Bool {
  let lhs_message = context.messages[lhs.message_index]
  let rhs_message = context.messages[rhs.message_index]
  lhs_message.discipline == rhs_message.discipline &&
  section_frame_bytes(lhs_message, lhs_message.section1) ==
  section_frame_bytes(rhs_message, rhs_message.section1)
}

///|
fn build_grouped_submessage_grib_bytes(
  context : @context.Grib2FileContext,
  refs : Array[SelectedRecordRef],
) -> Result[Bytes, String] {
  if refs.length() == 0 {
    return Err("internal: empty record group for vector combine output")
  }
  let header_message = context.messages[refs[0].message_index]
  let body : Array[Byte] = []
  append_bytes(
    body,
    section_frame_bytes(header_message, header_message.section1),
  )
  let mut previous_section3 : Bytes? = None
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    if message.discipline != header_message.discipline {
      return Err("vector combine requires a common discipline")
    }
    let submessage = message.submessages[record_ref.submessage_index]
    match submessage.section2 {
      Some(section2) =>
        append_bytes(body, section_frame_bytes(message, section2))
      None => ()
    }
    let section3 = section_frame_bytes(message, submessage.section3)
    let include_section3 = match previous_section3 {
      Some(prev) => prev != section3
      None => true
    }
    if include_section3 {
      append_bytes(body, section3)
    }
    previous_section3 = Some(section3)
    append_bytes(body, section_frame_bytes(message, submessage.section4))
    append_bytes(body, section_frame_bytes(message, submessage.section5))
    append_bytes(body, section_frame_bytes(message, submessage.section6))
    append_bytes(body, section_frame_bytes(message, submessage.section7))
  }
  let total_len = 16 + body.length() + 4
  let sec0 = build_sec0_with_length(header_message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, Bytes::from_array(body))
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  Ok(Bytes::from_array(out))
}

///|
fn write_vector_combine_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let metas = @decode.decode_records(context)
  let refs = collect_selected_record_refs(context, selected)
  let u_candidates : Map[Bytes, SelectedRecordRef] = {}
  let v_candidates : Map[Bytes, SelectedRecordRef] = {}
  for record_ref in refs {
    let meta_index = record_ref.record_index - 1
    if meta_index >= metas.length() {
      continue
    }
    let meta = metas[meta_index]
    if !is_wind_u_component(meta) && !is_wind_v_component(meta) {
      continue
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let pair_key = build_wind_pair_key(message, submessage)
    if pair_key.length() == 0 {
      continue
    }
    if is_wind_u_component(meta) {
      u_candidates.set(pair_key, record_ref)
    } else if is_wind_v_component(meta) {
      v_candidates.set(pair_key, record_ref)
    }
  }
  let consumed = Array::make(metas.length() + 1, false)
  let out : Array[Byte] = []
  for record_ref in refs {
    if record_ref.record_index < consumed.length() &&
      consumed[record_ref.record_index] {
      continue
    }
    let meta_index = record_ref.record_index - 1
    if meta_index < metas.length() {
      let meta = metas[meta_index]
      if is_wind_u_component(meta) || is_wind_v_component(meta) {
        let message = context.messages[record_ref.message_index]
        let submessage = message.submessages[record_ref.submessage_index]
        let pair_key = build_wind_pair_key(message, submessage)
        if pair_key.length() > 0 {
          match u_candidates.get(pair_key) {
            Some(u_ref) =>
              match v_candidates.get(pair_key) {
                Some(v_ref) => {
                  let first_index = if u_ref.record_index < v_ref.record_index {
                    u_ref.record_index
                  } else {
                    v_ref.record_index
                  }
                  if record_ref.record_index == first_index &&
                    vector_pair_messages_compatible(context, u_ref, v_ref) {
                    let pair_refs : Array[SelectedRecordRef] = [u_ref, v_ref]
                    let combined = match
                      build_grouped_submessage_grib_bytes(context, pair_refs) {
                      Ok(v) => v
                      Err(e) => return Err(e)
                    }
                    append_bytes(out, combined)
                    consumed[u_ref.record_index] = true
                    consumed[v_ref.record_index] = true
                    continue
                  }
                }
                None => ()
              }
            None => ()
          }
        }
      }
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    append_bytes(out, build_submessage_grib_bytes(message, submessage))
    if record_ref.record_index < consumed.length() {
      consumed[record_ref.record_index] = true
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_tosubmsg_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let same_as_previous_section6 = b"\x00\x00\x00\x06\x06\xfe"
  let mut base_discipline : Int? = None
  let mut base_message : @context.Grib2MessageContext? = None
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if record_is_selected(record_index, selected) && base_discipline is None {
        base_discipline = Some(message.discipline)
        base_message = Some(message)
      }
      record_index += 1
    }
  }
  match base_discipline {
    None =>
      if append_mode {
        return native_append_bytes(destination, Bytes::new(0))
      } else {
        return native_write_bytes(destination, Bytes::new(0))
      }
    Some(_) => ()
  }
  let base = match base_discipline {
    Some(v) => v
    None => 0
  }
  let message_for_header = match base_message {
    Some(v) => v
    None => return Err("internal: base message not found for -tosubmsg")
  }
  let body : Array[Byte] = []
  append_bytes(
    body,
    section_frame_bytes(message_for_header, message_for_header.section1),
  )
  let mut previous_section3 : Bytes? = None
  let mut previous_section6 : Bytes? = None
  record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if !record_is_selected(record_index, selected) ||
        message.discipline != base {
        record_index += 1
        continue
      }
      match submessage.section2 {
        Some(section2) =>
          append_bytes(body, section_frame_bytes(message, section2))
        None => ()
      }
      let section3 = section_frame_bytes(message, submessage.section3)
      let include_section3 = match previous_section3 {
        Some(prev) => prev != section3
        None => true
      }
      if include_section3 {
        append_bytes(body, section3)
      }
      previous_section3 = Some(section3)
      append_bytes(body, section_frame_bytes(message, submessage.section4))
      append_bytes(body, section_frame_bytes(message, submessage.section5))
      let section6 = section_frame_bytes(message, submessage.section6)
      let include_full_section6 = match previous_section6 {
        Some(prev) => prev != section6
        None => true
      }
      if include_full_section6 {
        append_bytes(body, section6)
      } else if section6.length() == 6 && section6[5] == b'\xff' {
        append_bytes(body, section6)
      } else {
        append_bytes(body, same_as_previous_section6)
      }
      previous_section6 = Some(section6)
      append_bytes(body, section_frame_bytes(message, submessage.section7))
      record_index += 1
    }
  }
  let total_len = 16 + body.length() + 4
  let sec0 = build_sec0_with_length(message_for_header, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, Bytes::from_array(body))
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn reduced_gaussian_method_supported(interp_method : String) -> Bool {
  interp_method == "neighbor" ||
  interp_method == "neighbor-extrapolate" ||
  interp_method == "linear" ||
  interp_method == "linear-extrapolate"
}

///|
fn is_reduced_gaussian_interp_linear(interp_method : String) -> Bool {
  interp_method == "linear" || interp_method == "linear-extrapolate"
}

///|
fn is_reduced_gaussian_template_id(template_id : Int) -> Bool {
  @common.is_reduced_gaussian_template_id(template_id)
}

///|
fn decode_reduced_gaussian_row_counts_for_cli(
  section3 : @decode.Grib2Section3Decoded,
  expected_rows : Int,
) -> Array[Int]? {
  let octets = section3.optional_points_octet_count
  if expected_rows <= 0 || octets <= 0 || octets > 4 {
    return None
  }
  if section3.optional_points_interpretation != 1 {
    return None
  }
  let raw = section3.optional_points_raw
  if raw.length() != expected_rows * octets {
    return None
  }
  let row_counts : Array[Int] = []
  for row in 0..<expected_rows {
    let mut value = 0
    let offset = row * octets
    for byte_index in 0..<octets {
      value = (value << 8) |
        raw[offset + byte_index].to_uint().reinterpret_as_int()
    }
    row_counts.push(value)
  }
  Some(row_counts)
}

///|
fn build_reduced_gaussian_row_offsets(row_counts : Array[Int]) -> Array[Int] {
  let offsets : Array[Int] = Array::make(row_counts.length(), 0)
  let mut offset = 0
  for index in 0..<row_counts.length() {
    offsets[index] = offset
    offset += row_counts[index]
  }
  offsets
}

///|
fn normalize_reduced_gaussian_values_for_cli(
  section3 : @decode.Grib2Section3Decoded,
  values : Array[Double],
) -> Result[(Array[Double], Array[Int]), String] {
  let grid_info = @typed.get_section3_grid_info(section3.template)
  let nj = grid_info.nj
  if nj <= 0 {
    return Err("failed to determine reduced Gaussian row count")
  }
  let scan = @typed.parse_scanning_mode(grid_info.scan_mode)
  if !reduced_gaussian_scan_mode_supported(section3) {
    return Err(
      "-reduced_gaussian_grid currently requires consecutive-i Gaussian rows",
    )
  }
  let input_row_counts = match
    decode_reduced_gaussian_row_counts_for_cli(section3, nj) {
    Some(v) => v
    None => return Err("failed to decode reduced Gaussian row counts")
  }
  let input_offsets = build_reduced_gaussian_row_offsets(input_row_counts)
  let output_offsets : Array[Int] = Array::make(nj, 0)
  let output_row_counts : Array[Int] = Array::make(nj, 0)
  let mut output_total = 0
  for j_out in 0..<nj {
    output_offsets[j_out] = output_total
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    let row_count = input_row_counts[j_in]
    output_row_counts[j_out] = row_count
    output_total += row_count
  }
  if output_total != values.length() {
    return Err(
      "reduced Gaussian point count mismatch: values=" +
      values.length().to_string() +
      " rows=" +
      output_total.to_string(),
    )
  }
  let normalized : Array[Double] = Array::make(output_total, 0.0)
  for j_out in 0..<nj {
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    let row_count = input_row_counts[j_in]
    let src_start = input_offsets[j_in]
    let dst_start = output_offsets[j_out]
    for i_out in 0..<row_count {
      let i_in = if scan.i_negative { row_count - 1 - i_out } else { i_out }
      normalized[dst_start + i_out] = values[src_start + i_in]
    }
  }
  Ok((normalized, output_row_counts))
}

///|
fn reduced_gaussian_target_ni(row_counts : Array[Int], n : Int) -> Int {
  let mut max_count = 0
  for row_count in row_counts {
    if row_count > max_count {
      max_count = row_count
    }
  }
  let regular_count = if n > 0 { 4 * n } else { 0 }
  if regular_count > max_count {
    regular_count
  } else {
    max_count
  }
}

///|
fn reduced_gaussian_scan_mode_supported(
  section3 : @decode.Grib2Section3Decoded,
) -> Bool {
  let grid_info = @typed.get_section3_grid_info(section3.template)
  let scan = @typed.parse_scanning_mode(grid_info.scan_mode)
  !scan.consecutive_j && !scan.alternating_rows
}

///|
fn reduced_gaussian_wgrib2_unsupported_scan_notice_lines(
  meta : @decode.Grib2RecordMeta,
) -> Array[String] {
  [
    "reduced_gaussian_grid: only WESN or WENS processed",
    wgrib2_default_inventory_line(meta),
  ]
}

///|
fn append_reduced_gaussian_interpolated_row(
  out : Array[Double],
  values : Array[Double],
  row_start : Int,
  row_count : Int,
  target_count : Int,
  linear : Bool,
) -> Result[Unit, String] {
  if row_count <= 0 || target_count <= 0 {
    return Err("reduced Gaussian interpolation requires positive row sizes")
  }
  if row_start < 0 || row_start + row_count > values.length() {
    return Err("reduced Gaussian row slice out of bounds")
  }
  let to_wgrib2_float = fn(value : Double) -> Double {
    Float::from_double(value).to_double()
  }
  for i in 0..<target_count {
    let x = i.to_double() * row_count.to_double() / target_count.to_double()
    let left = @math.floor(x).to_int()
    if linear {
      let frac = x - left.to_double()
      let right = if left + 1 < row_count { left + 1 } else { 0 }
      let v0 = to_wgrib2_float(values[row_start + left])
      let v1 = to_wgrib2_float(values[row_start + right])
      let interpolated = (1.0 - frac) * v0 + frac * v1
      out.push(to_wgrib2_float(interpolated))
    } else {
      let mut nearest = @math.floor(x + 0.5).to_int()
      if nearest >= row_count {
        nearest -= row_count
      }
      out.push(to_wgrib2_float(values[row_start + nearest]))
    }
  }
  Ok(())
}

///|
fn regularize_reduced_gaussian_values(
  values : Array[Double],
  row_counts : Array[Int],
  target_ni : Int,
  interp_method : String,
) -> Result[Array[Double], String] {
  let row_offsets = build_reduced_gaussian_row_offsets(row_counts)
  let linear = is_reduced_gaussian_interp_linear(interp_method)
  let out : Array[Double] = []
  for row_index in 0..<row_counts.length() {
    let row_count = row_counts[row_index]
    if row_count == target_ni {
      for offset in 0..<row_count {
        out.push(
          Float::from_double(values[row_offsets[row_index] + offset]).to_double(),
        )
      }
    } else {
      match
        append_reduced_gaussian_interpolated_row(
          out,
          values,
          row_offsets[row_index],
          row_count,
          target_ni,
          linear,
        ) {
        Ok(_) => ()
        Err(e) => return Err(e)
      }
    }
  }
  Ok(out)
}

///|
fn build_reduced_gaussian_regular_section3_bytes(
  section3 : @decode.Grib2Section3Decoded,
  target_ni : Int,
) -> Result[Bytes, String] {
  if target_ni <= 0 {
    return Err("reduced Gaussian target grid must have positive ni")
  }
  let target_di = (360_000_000L / target_ni.to_int64()).to_int()
  match section3.template {
    @section3.GridTemplate340(grid) => {
      let mut lo2 = (grid.lo1.to_int64() +
      (target_ni - 1).to_int64() * target_di.to_int64()).to_int()
      while lo2 < 0 {
        lo2 += 360_000_000
      }
      while lo2 >= 360_000_000 {
        lo2 -= 360_000_000
      }
      Ok(
        @decode.encode_section3_bytes({
          source_of_grid_definition: section3.source_of_grid_definition,
          number_of_data_points: target_ni * grid.nj,
          optional_points_octet_count: 0,
          optional_points_interpretation: 0,
          template: @section3.GridTemplate340({
            shape_of_earth: grid.shape_of_earth,
            scale_factor_radius: grid.scale_factor_radius,
            scaled_value_radius: grid.scaled_value_radius,
            scale_factor_major_axis: grid.scale_factor_major_axis,
            scaled_value_major_axis: grid.scaled_value_major_axis,
            scale_factor_minor_axis: grid.scale_factor_minor_axis,
            scaled_value_minor_axis: grid.scaled_value_minor_axis,
            ni: target_ni,
            nj: grid.nj,
            basic_angle: grid.basic_angle,
            subdivisions_of_basic_angle: grid.subdivisions_of_basic_angle,
            la1: grid.la1,
            lo1: grid.lo1,
            resolution_and_component_flags: grid.resolution_and_component_flags,
            la2: grid.la2,
            lo2,
            di: target_di,
            n: grid.n,
            scanning_mode: 0,
          }),
          optional_points_raw: b"",
        }),
      )
    }
    _ => Err("-reduced_gaussian_grid currently supports Gaussian template 3.40")
  }
}

///|
fn build_reduced_gaussian_submessage_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  interp_method : String,
) -> Result[Bytes, String] {
  let section3 = match @decode.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 3: \{e}")
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(e) =>
      return Err(
        "failed to unpack reduced Gaussian data: " + unpack_error_string(e),
      )
  }
  let (normalized_values, row_counts) = match
    normalize_reduced_gaussian_values_for_cli(section3, unpacked) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let target_ni = match section3.template {
    @section3.GridTemplate340(grid) =>
      reduced_gaussian_target_ni(row_counts, grid.n)
    _ => reduced_gaussian_target_ni(row_counts, 0)
  }
  let regularized_values = match
    regularize_reduced_gaussian_values(
      normalized_values, row_counts, target_ni, interp_method,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let sec3 = match
    build_reduced_gaussian_regular_section3_bytes(section3, target_ni) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let rebuilt = try_build_simple_packed_sections_with_scaling(
    regularized_values,
    meta.section5_reference_value_ieee,
    meta.section5_binary_scale_factor,
    meta.section5_decimal_scale_factor,
    original_field_value_type,
  )
  let (sec5, sec7) = match rebuilt {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -reduced_gaussian_grid record " +
        meta.record_index.to_string(),
      )
  }
  let sec6 = @decode.encode_section6_bytes({
    bitmap_indicator: 255,
    bitmap_raw: b"",
  })
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_reduced_gaussian_grid_output(
  destination : String,
  y_arg : String,
  interp_method : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if y_arg != "-1" {
    return Err("reduced_gaussian_grid: arg: " + y_arg + " should be -1")
  }
  if !reduced_gaussian_method_supported(interp_method) {
    return Err(
      "reduced_gaussian_grid: method must be neighbor|linear[-extrapolate]",
    )
  }
  let metas = @decode.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -reduced_gaussian_grid record " +
            record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        if is_reduced_gaussian_template_id(meta.section3_template.id()) {
          let section3 = match
            @decode.decode_submessage_section3(message, submessage) {
            Ok(v) => v
            Err(e) => return Err("failed to decode Section 3: \{e}")
          }
          if !reduced_gaussian_scan_mode_supported(section3) {
            for
              line in reduced_gaussian_wgrib2_unsupported_scan_notice_lines(
                meta,
              ) {
              println(line)
            }
            record_index += 1
            continue
          }
          let bytes = match
            build_reduced_gaussian_submessage_bytes(
              message, submessage, meta, interp_method,
            ) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          append_bytes(out, bytes)
        }
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
