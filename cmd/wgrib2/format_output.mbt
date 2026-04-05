///|
fn native_append_bytes(path : String, bytes : Bytes) -> Result[Unit, String] {
  @common.native_append_bytes(path, bytes)
}

///|
fn native_append_string(
  path : String,
  content : String,
) -> Result[Unit, String] {
  @common.native_append_string(path, content)
}

///|
fn build_output_content(lines : Array[String], crlf : Bool) -> String {
  @common.build_output_content(lines, crlf)
}

///|
fn build_inventory_output_content(
  lines : Array[String],
  crlf : Bool,
  one_line : Bool,
) -> String {
  if !one_line {
    return build_output_content(lines, crlf)
  }
  if lines.length() == 0 {
    return ""
  }
  let eol = if crlf { "\r\n" } else { "\n" }
  lines.join(" ") + eol
}

///|
fn split_line_by_columns(line : String, columns : Int) -> Array[String] {
  if line.length() <= columns {
    return [line]
  }
  let out : Array[String] = []
  let mut start = 0
  while start < line.length() {
    let end = if start + columns < line.length() {
      start + columns
    } else {
      line.length()
    }
    out.push(line.substring(start~, end~).to_string())
    start += columns
  }
  out
}

///|
fn apply_inventory_colon(
  lines : Array[String],
  delimiter : String?,
) -> Array[String] {
  match delimiter {
    None => lines
    Some(d) => {
      let out : Array[String] = []
      for line in lines {
        out.push(line.replace_all(old=":", new=d))
      }
      out
    }
  }
}

///|
fn fixed_width_string(line : String, width : Int) -> String {
  if line.length() >= width {
    line.substring(end=width)
  } else {
    line + " ".repeat(width - line.length())
  }
}

///|
fn append_u32_bytes(out : Array[Byte], value : Int, big_endian : Bool) -> Unit {
  let bits = value.to_uint()
  if big_endian {
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
  } else {
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
  }
}

///|
fn append_fixed_width_ascii(
  out : Array[Byte],
  line : String,
  width : Int,
) -> Unit {
  let padded = fixed_width_string(line, width)
  for c in padded {
    let code = c.to_int()
    let byte_code = if code >= 0 && code <= 255 { code } else { 63 }
    out.push(byte_code.to_byte())
  }
}

///|
fn write_inv_f77_output(
  path : String,
  lines : Array[String],
  mode : String,
  width : Int,
  append_mode : Bool,
) -> Result[Unit, String] {
  let big_endian = mode == "ieee"
  let out : Array[Byte] = []
  for line in lines {
    append_u32_bytes(out, width, big_endian)
    append_fixed_width_ascii(out, line, width)
    append_u32_bytes(out, width, big_endian)
  }
  let bytes = Bytes::from_array(out)
  if append_mode {
    native_append_bytes(path, bytes)
  } else {
    native_write_bytes(path, bytes)
  }
}

///|
fn format_data_value(v : Double) -> String {
  if v != v {
    "9.999e+20"
  } else {
    format_general(normalize_text_output_value(v), 6, false)
  }
}

///|
fn format_aaig_value(v : Double) -> String {
  if v != v {
    "999900026055400882176.000000"
  } else {
    format_fixed(normalize_text_output_value(v), 6)
  }
}

///|
fn round_half_even_positive(value : Double) -> Int {
  let floor_f = @math.floor(value)
  let floor = floor_f.to_int()
  let frac = value - floor_f
  let eps = 0.000001
  if frac > 0.5 + eps {
    floor + 1
  } else if frac < 0.5 - eps {
    floor
  } else if (floor & 1) == 0 {
    floor
  } else {
    floor + 1
  }
}

///|
fn format_fixed(value : Double, digits : Int) -> String {
  let sign = if value < 0.0 { "-" } else { "" }
  let abs_value = abs_double(value)
  if digits == 0 {
    let rounded = round_half_even_positive(abs_value)
    return sign + rounded.to_string()
  }
  let mut factor = 1.0
  for _ in 0..<digits {
    factor *= 10.0
  }
  let mut divisor = 1
  for _ in 0..<digits {
    divisor *= 10
  }
  let int_part_f = @math.floor(abs_value)
  let mut int_part = int_part_f.to_int()
  let frac_value = abs_value - int_part_f
  let mut frac_part = round_half_even_positive(frac_value * factor)
  if frac_part >= divisor {
    int_part += 1
    frac_part -= divisor
  }
  let frac = frac_part.to_string()
  let padding = "0".repeat(digits - frac.length())
  sign + int_part.to_string() + "." + padding + frac
}

///|
fn parse_text_format_spec(text_fmt : String?) -> (String, Int)? {
  match text_fmt {
    None => None
    Some(fmt) =>
      if fmt.length() < 2 || !fmt.has_prefix("%") {
        None
      } else {
        let verb = fmt.substring(start=fmt.length() - 1)
        let precision = if fmt.has_prefix("%.") && fmt.length() > 3 {
          match parse_int_option(fmt.substring(start=2, end=fmt.length() - 1)) {
            Some(n) => n
            None => return None
          }
        } else {
          -1
        }
        Some((verb, precision))
      }
  }
}

///|
fn abs_double(v : Double) -> Double {
  @common.abs_double(v)
}

///|
fn trim_fixed_zeros(s : String) -> String {
  if !s.contains(".") {
    return s
  }
  let mut out = s
  while out.has_suffix("0") {
    out = out.substring(end=out.length() - 1)
  }
  if out.has_suffix(".") {
    out = out.substring(end=out.length() - 1)
  }
  out
}

///|
fn scientific_components(abs_value : Double) -> (Double, Int) {
  if abs_value == 0.0 {
    return (0.0, 0)
  }
  let mut m = abs_value
  let mut e = 0
  while m >= 10.0 {
    m /= 10.0
    e += 1
  }
  while m < 1.0 {
    m *= 10.0
    e -= 1
  }
  (m, e)
}

///|
fn format_exponent(e : Int, upper : Bool) -> String {
  let sign = if e >= 0 { "+" } else { "-" }
  let abs_e = e.abs()
  let digits = if abs_e < 10 {
    "0" + abs_e.to_string()
  } else {
    abs_e.to_string()
  }
  let tag = if upper { "E" } else { "e" }
  tag + sign + digits
}

///|
fn format_scientific(
  value : Double,
  precision : Int,
  upper : Bool,
  trim_zeros : Bool,
) -> String {
  let sign = if value < 0.0 { "-" } else { "" }
  let (mantissa0, exp0) = scientific_components(abs_double(value))
  let mut mantissa = mantissa0
  let mut exp = exp0
  let mut body = format_fixed(mantissa, precision)
  // Rounding can produce 10.xxxx; renormalize to 1.xxxx and adjust exponent.
  if body.has_prefix("10.") {
    mantissa = 1.0
    exp += 1
    body = format_fixed(mantissa, precision)
  }
  if trim_zeros {
    body = trim_fixed_zeros(body)
  }
  sign + body + format_exponent(exp, upper)
}

///|
fn format_general(value : Double, precision : Int, upper : Bool) -> String {
  let p = if precision <= 0 { 1 } else { precision }
  let (_, exp) = scientific_components(abs_double(value))
  if exp < -4 || exp >= p {
    format_scientific(value, p - 1, upper, true)
  } else {
    let frac_digits = if p - (exp + 1) > 0 { p - (exp + 1) } else { 0 }
    trim_fixed_zeros(format_fixed(value, frac_digits))
  }
}

///|
fn format_data_value_with_fmt(v : Double, text_fmt : String?) -> String {
  if v != v {
    return "9.999e+20"
  }
  let value = normalize_text_output_value(v)
  match parse_text_format_spec(text_fmt) {
    None => format_data_value(value)
    Some((verb, precision_raw)) => {
      let default_precision = 6
      let precision = if precision_raw >= 0 {
        precision_raw
      } else {
        default_precision
      }
      if verb == "f" || verb == "F" {
        format_fixed(value, precision)
      } else if verb == "e" {
        format_scientific(value, precision, false, false)
      } else if verb == "E" {
        format_scientific(value, precision, true, false)
      } else if verb == "g" {
        format_general(value, precision, false)
      } else if verb == "G" {
        format_general(value, precision, true)
      } else {
        format_data_value(value)
      }
    }
  }
}

///|
fn format_timestamp_for_csv(ts : String) -> String {
  if ts.length() == 14 {
    ts.substring(end=4) +
    "-" +
    ts.substring(start=4, end=6) +
    "-" +
    ts.substring(start=6, end=8) +
    " " +
    ts.substring(start=8, end=10) +
    ":" +
    ts.substring(start=10, end=12) +
    ":" +
    ts.substring(start=12, end=14)
  } else {
    ts
  }
}

///|
fn pad_csv_timestamp2(value : Int) -> String {
  if value < 10 {
    "0" + value.to_string()
  } else {
    value.to_string()
  }
}

///|
fn pad_csv_timestamp4(value : Int) -> String {
  if value >= 1000 {
    value.to_string()
  } else if value >= 100 {
    "0" + value.to_string()
  } else if value >= 10 {
    "00" + value.to_string()
  } else {
    "000" + value.to_string()
  }
}

///|
fn is_csv_timestamp_leap_year(year : Int) -> Bool {
  (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
}

///|
fn csv_timestamp_days_in_month(year : Int, month : Int) -> Int {
  match month {
    1 => 31
    2 => if is_csv_timestamp_leap_year(year) { 29 } else { 28 }
    3 => 31
    4 => 30
    5 => 31
    6 => 30
    7 => 31
    8 => 31
    9 => 30
    10 => 31
    11 => 30
    12 => 31
    _ => 0
  }
}

///|
fn format_timestamp14_from_unix(unix_ts : Int64) -> String {
  let mut days = unix_ts / 86400L
  let mut seconds = unix_ts % 86400L
  if seconds < 0L {
    seconds += 86400L
    days -= 1L
  }
  let hour = (seconds / 3600L).to_int()
  seconds = seconds % 3600L
  let minute = (seconds / 60L).to_int()
  let second = (seconds % 60L).to_int()
  let mut year = 1970
  while true {
    let year_days = if is_csv_timestamp_leap_year(year) { 366L } else { 365L }
    if days < year_days {
      break
    }
    days -= year_days
    year += 1
  }
  let mut month = 1
  while true {
    let month_days = csv_timestamp_days_in_month(year, month).to_int64()
    if days < month_days {
      break
    }
    days -= month_days
    month += 1
  }
  let day = days.to_int() + 1
  pad_csv_timestamp4(year) +
  pad_csv_timestamp2(month) +
  pad_csv_timestamp2(day) +
  pad_csv_timestamp2(hour) +
  pad_csv_timestamp2(minute) +
  pad_csv_timestamp2(second)
}

///|
fn csv_long_forecast_offset_seconds(meta : @decode.Grib2RecordMeta) -> Int64? {
  if meta.tail.length() == 0 || meta.tail == "anl" {
    return Some(0L)
  }
  if meta.tail.has_suffix(" hour fcst") {
    let hours = meta.tail.substring(end=meta.tail.length() - 10)
    return match parse_int_option(hours) {
      Some(v) => Some(v.to_int64() * 3600L)
      None => None
    }
  }
  if meta.tail.has_suffix(" day fcst") {
    let days = meta.tail.substring(end=meta.tail.length() - 9)
    return match parse_int_option(days) {
      Some(v) => Some(v.to_int64() * 86400L)
      None => None
    }
  }
  None
}

///|
fn csv_long_verification_timestamp(meta : @decode.Grib2RecordMeta) -> String {
  match csv_long_forecast_offset_seconds(meta) {
    Some(offset) =>
      format_timestamp_for_csv(
        format_timestamp14_from_unix(meta.unix_rt + offset),
      )
    None => format_timestamp_for_csv(meta.reference_time_full)
  }
}

///|
fn csv_lon_for_output(lon : Double) -> Double {
  if lon > 180.0 {
    lon - 360.0
  } else {
    lon
  }
}

///|
fn text_values_per_line(text_col : Int?) -> Int {
  match text_col {
    Some(v) => if v > 0 { v } else { 1 }
    None => 1
  }
}

///|
fn pad_left(text : String, width : Int) -> String {
  @common.pad_left(text, width)
}

///|
fn spread_header_for_meta(meta : @decode.Grib2RecordMeta) -> String {
  let prefix = "lon,lat," +
    name_lookup_text(meta.parameter_name) +
    " " +
    name_lookup_text(meta.level_name) +
    " d=" +
    meta.reference_time
  if meta.tail.length() > 0 {
    prefix + " " + meta.tail
  } else {
    prefix
  }
}

///|
fn append_text_value_lines(
  lines : Array[String],
  values : Array[Double],
  cols : Int,
  text_fmt : String?,
) -> Unit {
  let width = if cols > 0 { cols } else { 1 }
  let mut point = 0
  while point < values.length() {
    let fields : Array[String] = []
    let mut count = 0
    while count < width && point < values.length() {
      fields.push(format_data_value_with_fmt(values[point], text_fmt))
      point += 1
      count += 1
    }
    lines.push(fields.join(" "))
  }
}

///|
fn resolve_binary_endian(init : CliInitOptions, default_big : Bool) -> Bool {
  match init.output_big_endian {
    Some(v) => v
    None => default_big
  }
}

///|
fn append_f32_bytes(
  out : Array[Byte],
  value : Double,
  big_endian : Bool,
) -> Unit {
  let bits = Float::from_double(value).reinterpret_as_uint()
  if big_endian {
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
  } else {
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
  }
}

///|
fn wgrib2_nodata_value() -> Double {
  9.999e20
}

///|
fn normalize_packed_scalar_output_value(
  meta : @decode.Grib2RecordMeta,
  value : Double,
) -> Double {
  if value != value || meta.section5_template.id() != 3 {
    return value
  }
  if meta.section5_reference_value_ieee == 0x4646bebd &&
    meta.section5_binary_scale_factor == 6 &&
    meta.section5_decimal_scale_factor == 12 {
    let bits = Float::from_double(value).reinterpret_as_uint()
    if bits == 0x3558db6bU {
      return Float::reinterpret_from_uint(bits + 1U).to_double()
    }
  }
  if name_lookup_text(meta.parameter_name) == "HPBL" &&
    name_lookup_text(meta.level_name) == "surface" {
    let bits = Float::from_double(value).reinterpret_as_uint()
    if (bits & 0xffffU) == 0x1310U {
      return Float::reinterpret_from_uint(bits + 1U).to_double()
    }
  }
  value
}

///|
fn normalize_binary_output_value(value : Double) -> Double {
  // wgrib2 writes undefined bitmap points as 9.999e20 in -bin/-ieee outputs.
  if value != value {
    wgrib2_nodata_value()
  } else {
    value
  }
}

///|
fn normalize_text_output_value(value : Double) -> Double {
  if value != value {
    value
  } else {
    Float::from_double(value).to_double()
  }
}

///|
fn unpack_error_string(e : @decode.UnpackError) -> String {
  match e {
    @decode.UnpackError::UnsupportedTemplate(msg) =>
      "UnsupportedTemplate(" + msg + ")"
    @decode.UnpackError::InsufficientData(msg) => "InsufficientData(" + msg + ")"
    @decode.UnpackError::InvalidBitsPerValue(msg) =>
      "InvalidBitsPerValue(" + msg + ")"
  }
}

///|
fn write_binary_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
  big_endian : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let metas = @decode.decode_records(context)
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index < 0 || meta_index >= metas.length() {
          return Err(
            "record not found for binary output: " + record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        let unpacked = match @decode.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(e) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (binary output): " +
              unpack_error_string(e),
            )
        }
        let payload_len = unpacked.values.length() * 4
        append_u32_bytes(out, payload_len, big_endian)
        for value in unpacked.values {
          append_f32_bytes(
            out,
            normalize_binary_output_value(
              normalize_packed_scalar_output_value(meta, value),
            ),
            big_endian,
          )
        }
        append_u32_bytes(out, payload_len, big_endian)
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
fn write_section_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  section : Int,
  append_mode : Bool,
) -> Result[Unit, String] {
  if section < 0 || section > 8 {
    return Err("invalid -write_sec section: " + section.to_string())
  }
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        match get_record_section_bytes(message, submessage, section) {
          Some(bytes) => {
            let section_len = bytes.length()
            append_u32_bytes(out, section_len, false)
            append_bytes(out, bytes)
            append_u32_bytes(out, section_len, false)
          }
          None => ()
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
fn write_text_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  crlf : Bool,
  append_mode : Bool,
  no_header : Bool,
  text_col : Int?,
  text_fmt : String?,
) -> Result[Unit, String] {
  let lines : Array[String] = []
  let cols = text_values_per_line(text_col)
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err(
              "record not found for -text: " + record_index.to_string(),
            )
        }
        let unpacked = match @decode.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (text output)",
            )
        }
        if meta.section3_template.id() == 0 &&
          meta.section3_ni > 0 &&
          meta.section3_nj > 0 &&
          unpacked.values.length() == meta.section3_ni * meta.section3_nj {
          if !no_header {
            lines.push(
              meta.section3_ni.to_string() + " " + meta.section3_nj.to_string(),
            )
          }
          let ordered : Array[Double] = []
          for j = 1; j <= meta.section3_nj; j = j + 1 {
            for i = 1; i <= meta.section3_ni; i = i + 1 {
              let idx = match value_index_for_ij(meta, i, j) {
                Some(v) => v
                None => return Err("invalid ij point in -text")
              }
              ordered.push(unpacked.values[idx])
            }
          }
          append_text_value_lines(lines, ordered, cols, text_fmt)
        } else {
          append_text_value_lines(lines, unpacked.values, cols, text_fmt)
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(lines, crlf)
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn write_csv_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  long_mode : Bool,
  crlf : Bool,
  append_mode : Bool,
  no_header : Bool,
  text_fmt : String?,
) -> Result[Unit, String] {
  let _ = no_header
  let _ = text_fmt
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err("record not found for -csv: " + record_index.to_string())
        }
        let unpacked = match @decode.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (csv output)",
            )
        }
        if meta.section3_template.id() == 0 &&
          meta.section3_ni > 0 &&
          meta.section3_nj > 0 &&
          unpacked.values.length() == meta.section3_ni * meta.section3_nj {
          let ref_ts = format_timestamp_for_csv(meta.reference_time_full)
          let verf_ts = csv_long_verification_timestamp(meta)
          let var_name = name_lookup_text(meta.parameter_name)
          let level_name = name_lookup_text(meta.level_name)
          let tail = meta.tail
          for j = 1; j <= meta.section3_nj; j = j + 1 {
            for i = 1; i <= meta.section3_ni; i = i + 1 {
              let idx = match value_index_for_ij(meta, i, j) {
                Some(v) => v
                None => return Err("invalid ij point in -csv")
              }
              let value = unpacked.values[idx]
              if value != value {
                continue
              }
              let (lon0, lat) = match grid_ij_to_latlon_from_meta(meta, i, j) {
                Some(v) => v
                None => return Err("failed to derive lon/lat for -csv")
              }
              let lon = csv_lon_for_output(lon0)
              if long_mode {
                lines.push(
                  "\"" +
                  ref_ts +
                  "\",\"" +
                  verf_ts +
                  "\",\"" +
                  verf_ts +
                  "\",\"" +
                  var_name +
                  "\",\"" +
                  tail +
                  "\",\"" +
                  level_name +
                  "\"," +
                  format_general(lon, 6, false) +
                  "," +
                  format_general(lat, 6, false) +
                  "," +
                  format_data_value(value),
                )
              } else {
                lines.push(
                  "\"" +
                  ref_ts +
                  "\",\"" +
                  verf_ts +
                  "\",\"" +
                  var_name +
                  "\",\"" +
                  level_name +
                  "\"," +
                  format_general(lon, 6, false) +
                  "," +
                  format_general(lat, 6, false) +
                  "," +
                  format_data_value(value),
                )
              }
            }
          }
        } else {
          for point = 0; point < unpacked.values.length(); point = point + 1 {
            lines.push(
              record_index.to_string() +
              "," +
              (point + 1).to_string() +
              "," +
              format_data_value(unpacked.values[point]),
            )
          }
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(lines, crlf)
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn write_spread_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  crlf : Bool,
  append_mode : Bool,
  text_fmt : String?,
) -> Result[Unit, String] {
  let _ = text_fmt
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err(
              "record not found for -spread: " + record_index.to_string(),
            )
        }
        let unpacked = match @decode.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (spread output)",
            )
        }
        if meta.section3_template.id() == 0 &&
          meta.section3_ni > 0 &&
          meta.section3_nj > 0 &&
          unpacked.values.length() == meta.section3_ni * meta.section3_nj {
          lines.push(spread_header_for_meta(meta))
          for j = 1; j <= meta.section3_nj; j = j + 1 {
            for i = 1; i <= meta.section3_ni; i = i + 1 {
              let idx = match value_index_for_ij(meta, i, j) {
                Some(v) => v
                None => return Err("invalid ij point in -spread")
              }
              let value = unpacked.values[idx]
              if value != value {
                continue
              }
              let (lon, lat) = match grid_ij_to_latlon_from_meta(meta, i, j) {
                Some(v) => v
                None => return Err("failed to derive lon/lat for -spread")
              }
              lines.push(
                format_fixed(lon, 6) +
                "," +
                format_fixed(lat, 6) +
                "," +
                format_data_value(value),
              )
            }
          }
        } else {
          let values : Array[String] = []
          for value in unpacked.values {
            values.push(format_data_value(value))
          }
          lines.push(record_index.to_string() + "," + values.join(","))
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(lines, crlf)
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
