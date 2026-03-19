///|
priv enum NetcdfAttrValue {
  NetcdfAttrChars(String)
  NetcdfAttrInt(Int)
  NetcdfAttrFloat(Double)
  NetcdfAttrDouble(Double)
}

///|
priv struct NetcdfAttr {
  name : String
  value : NetcdfAttrValue
}

///|
priv struct NetcdfDimension {
  name : String
  length : Int
}

///|
priv struct NetcdfVariable {
  name : String
  dimids : Array[Int]
  attrs : Array[NetcdfAttr]
  xtype : Int
  values : Bytes
  is_record : Bool
}

///|
priv struct NetcdfVariablePlacement {
  begin : Int
  vsize : Int
}

///|
priv struct NetcdfBinaryFloat {
  negative : Bool
  significand : BigInt
  exponent : Int
}

///|
fn append_ascii_string_bytes(out : Array[Byte], text : String) -> Unit {
  for c in text {
    let code = c.to_int()
    let byte_code = if code >= 0 && code <= 255 { code } else { 63 }
    out.push(byte_code.to_byte())
  }
}

///|
fn append_zero_bytes(out : Array[Byte], count : Int) -> Unit {
  for _ in 0..<count {
    out.push(b'\x00')
  }
}

///|
fn netcdf_padded_size(size : Int) -> Int {
  let rem = size % 4
  if rem == 0 {
    size
  } else {
    size + 4 - rem
  }
}

///|
fn append_netcdf_name(out : Array[Byte], name : String) -> Unit {
  append_u32_bytes(out, name.length(), true)
  append_ascii_string_bytes(out, name)
  append_zero_bytes(out, netcdf_padded_size(name.length()) - name.length())
}

///|
fn netcdf_attr_xtype(value : NetcdfAttrValue) -> Int {
  match value {
    NetcdfAttrChars(_) => 2
    NetcdfAttrInt(_) => 4
    NetcdfAttrFloat(_) => 5
    NetcdfAttrDouble(_) => 6
  }
}

///|
fn netcdf_attr_payload_length(value : NetcdfAttrValue) -> Int {
  match value {
    NetcdfAttrChars(text) => text.length()
    NetcdfAttrInt(_) => 4
    NetcdfAttrFloat(_) => 4
    NetcdfAttrDouble(_) => 8
  }
}

///|
fn netcdf_attr_element_count(value : NetcdfAttrValue) -> Int {
  match value {
    NetcdfAttrChars(text) => text.length()
    _ => 1
  }
}

///|
fn netcdf_attr_payload_bytes(value : NetcdfAttrValue) -> Bytes {
  let out : Array[Byte] = []
  match value {
    NetcdfAttrChars(text) => append_ascii_string_bytes(out, text)
    NetcdfAttrInt(v) => append_u32_bytes(out, v, true)
    NetcdfAttrFloat(v) => append_bytes(out, Float::from_double(v).to_be_bytes())
    NetcdfAttrDouble(v) =>
      append_bytes(out, v.reinterpret_as_uint64().to_be_bytes())
  }
  Bytes::from_array(out)
}

///|
fn netcdf_attr_size(attr : NetcdfAttr) -> Int {
  4 +
  netcdf_padded_size(attr.name.length()) +
  4 +
  4 +
  netcdf_padded_size(netcdf_attr_payload_length(attr.value))
}

///|
fn netcdf_attr_list_size(attrs : Array[NetcdfAttr]) -> Int {
  let mut total = 8
  for attr in attrs {
    total += netcdf_attr_size(attr)
  }
  total
}

///|
fn netcdf_dimension_list_size(dims : Array[NetcdfDimension]) -> Int {
  let mut total = 8
  for dim in dims {
    total += 4 + netcdf_padded_size(dim.name.length()) + 4
  }
  total
}

///|
fn netcdf_variable_metadata_size(nc_var : NetcdfVariable) -> Int {
  4 +
  netcdf_padded_size(nc_var.name.length()) +
  4 +
  nc_var.dimids.length() * 4 +
  netcdf_attr_list_size(nc_var.attrs) +
  4 +
  4 +
  4
}

///|
fn netcdf_variable_list_size(vars : Array[NetcdfVariable]) -> Int {
  let mut total = 8
  for nc_var in vars {
    total += netcdf_variable_metadata_size(nc_var)
  }
  total
}

///|
fn netcdf_header_size(
  dims : Array[NetcdfDimension],
  global_attrs : Array[NetcdfAttr],
  vars : Array[NetcdfVariable],
) -> Int {
  8 +
  netcdf_dimension_list_size(dims) +
  netcdf_attr_list_size(global_attrs) +
  netcdf_variable_list_size(vars)
}

///|
fn build_netcdf_dimension_list_bytes(dims : Array[NetcdfDimension]) -> Bytes {
  let out : Array[Byte] = []
  append_u32_bytes(out, 10, true)
  append_u32_bytes(out, dims.length(), true)
  for dim in dims {
    append_netcdf_name(out, dim.name)
    append_u32_bytes(out, dim.length, true)
  }
  Bytes::from_array(out)
}

///|
fn build_netcdf_attr_list_bytes(attrs : Array[NetcdfAttr]) -> Bytes {
  let out : Array[Byte] = []
  append_u32_bytes(out, 12, true)
  append_u32_bytes(out, attrs.length(), true)
  for attr in attrs {
    append_netcdf_name(out, attr.name)
    append_u32_bytes(out, netcdf_attr_xtype(attr.value), true)
    append_u32_bytes(out, netcdf_attr_element_count(attr.value), true)
    let payload = netcdf_attr_payload_bytes(attr.value)
    append_bytes(out, payload)
    append_zero_bytes(
      out,
      netcdf_padded_size(payload.length()) - payload.length(),
    )
  }
  Bytes::from_array(out)
}

///|
fn build_netcdf_variable_list_bytes(
  vars : Array[NetcdfVariable],
  placements : Array[NetcdfVariablePlacement],
) -> Bytes {
  let out : Array[Byte] = []
  append_u32_bytes(out, 11, true)
  append_u32_bytes(out, vars.length(), true)
  for i in 0..<vars.length() {
    let nc_var = vars[i]
    let placement = placements[i]
    append_netcdf_name(out, nc_var.name)
    append_u32_bytes(out, nc_var.dimids.length(), true)
    for dimid in nc_var.dimids {
      append_u32_bytes(out, dimid, true)
    }
    append_bytes(out, build_netcdf_attr_list_bytes(nc_var.attrs))
    append_u32_bytes(out, nc_var.xtype, true)
    append_u32_bytes(out, placement.vsize, true)
    append_u32_bytes(out, placement.begin, true)
  }
  Bytes::from_array(out)
}

///|
fn netcdf_record_reference_time_type(meta : @lib.Grib2RecordMeta) -> Int {
  if meta.tail.length() == 0 || meta.tail == "anl" {
    1
  } else {
    3
  }
}

///|
fn netcdf_record_reference_time_description(
  meta : @lib.Grib2RecordMeta,
) -> String {
  if meta.tail.length() == 0 || meta.tail == "anl" {
    "analyses, reference date is fixed"
  } else {
    "forecast or accumulated, reference date is fixed"
  }
}

///|
fn netcdf_reference_date_text(reference_time_full : String) -> String {
  if reference_time_full.length() == 14 {
    reference_time_full.substring(end=4) +
    "." +
    reference_time_full.substring(start=4, end=6) +
    "." +
    reference_time_full.substring(start=6, end=8) +
    " " +
    reference_time_full.substring(start=8, end=10) +
    ":" +
    reference_time_full.substring(start=10, end=12) +
    ":" +
    reference_time_full.substring(start=12, end=14) +
    " UTC"
  } else {
    reference_time_full
  }
}

///|
fn netcdf_verification_time_unix(meta : @lib.Grib2RecordMeta) -> Int64 {
  match csv_long_forecast_offset_seconds(meta) {
    Some(offset) => meta.unix_rt + offset
    None => meta.unix_rt
  }
}

///|
fn is_netcdf_name_char(code : Int) -> Bool {
  (code >= 48 && code <= 57) ||
  (code >= 65 && code <= 90) ||
  (code >= 97 && code <= 122) ||
  code == 95
}

///|
fn sanitize_netcdf_name_part(text : String) -> String {
  let parts : Array[String] = []
  for c in text {
    let code = c.to_int()
    if is_netcdf_name_char(code) {
      parts.push(c.to_string())
    }
  }
  if parts.length() == 0 {
    "value"
  } else {
    parts.join("")
  }
}

///|
fn netcdf_variable_name(meta : @lib.Grib2RecordMeta) -> String {
  let parameter = sanitize_netcdf_name_part(
    name_lookup_text(meta.parameter_name),
  )
  let level = sanitize_netcdf_name_part(name_lookup_text(meta.level_name))
  if level.length() == 0 {
    parameter
  } else {
    parameter + "_" + level
  }
}

///|
fn netcdf_long_name_units(meta : @lib.Grib2RecordMeta) -> (String, String) {
  let name = name_lookup_text(meta.parameter_name)
  let (desc, units) = gribtable_used_desc_units(
    meta.discipline,
    meta.section4_parameter_category,
    meta.section4_parameter_number,
    name,
  )
  if meta.discipline == 0 &&
    meta.section4_parameter_category == 3 &&
    meta.section4_parameter_number == 5 {
    (desc, "m")
  } else {
    (desc, units)
  }
}

///|
fn netcdf_uint64_constant(value : Int) -> UInt64 {
  UInt64::extend_uint(value.reinterpret_as_uint())
}

///|
fn netcdf_bigint_abs(value : BigInt) -> BigInt {
  if value.compare_int(0) < 0 {
    -value
  } else {
    value
  }
}

///|
fn netcdf_bigint_is_odd(value : BigInt) -> Bool {
  !value.land(BigInt::from_int(1)).is_zero()
}

///|
fn netcdf_bigint_round_shift(value : BigInt, shift : Int) -> BigInt {
  if shift <= 0 {
    value << -shift
  } else {
    let truncated = value >> shift
    let remainder = value - (truncated << shift)
    if remainder.is_zero() {
      truncated
    } else {
      let half = BigInt::from_int(1) << (shift - 1)
      let cmp_half = remainder.compare(half)
      if cmp_half > 0 || (cmp_half == 0 && netcdf_bigint_is_odd(truncated)) {
        truncated + BigInt::from_int(1)
      } else {
        truncated
      }
    }
  }
}

///|
fn netcdf_binary_float_from_double(value : Double) -> NetcdfBinaryFloat? {
  let bits = value.reinterpret_as_uint64()
  let sign_mask = netcdf_uint64_constant(1) << 63
  let exponent_mask = netcdf_uint64_constant(2047) << 52
  let fraction_mask = (netcdf_uint64_constant(1) << 52) -
    netcdf_uint64_constant(1)
  let negative = bits.land(sign_mask) != UInt64::default()
  let exponent_bits = (bits.land(exponent_mask) >> 52).to_int()
  let fraction_bits = bits.land(fraction_mask)
  if exponent_bits == 2047 {
    None
  } else if exponent_bits == 0 {
    Some({
      negative,
      significand: BigInt::from_uint64(fraction_bits),
      exponent: -1074,
    })
  } else {
    Some({
      negative,
      significand: BigInt::from_uint64(
        (netcdf_uint64_constant(1) << 52).lor(fraction_bits),
      ),
      exponent: exponent_bits - 1023 - 52,
    })
  }
}

///|
fn netcdf_double_from_exact_binary(
  significand : BigInt,
  exponent : Int,
) -> Double {
  if significand.is_zero() {
    return 0.0
  }
  let negative = significand.compare_int(0) < 0
  let abs_significand = netcdf_bigint_abs(significand)
  let bit_length = abs_significand.bit_length()
  let mut exponent2 = exponent + bit_length - 1
  let sign_bit = if negative {
    netcdf_uint64_constant(1) << 63
  } else {
    UInt64::default()
  }
  if exponent2 > 1023 {
    return sign_bit
      .lor(netcdf_uint64_constant(2047) << 52)
      .reinterpret_as_double()
  }
  let fraction_limit = BigInt::from_uint64(netcdf_uint64_constant(1) << 52)
  if exponent2 >= -1022 {
    let shift = bit_length - 53
    let mut rounded = netcdf_bigint_round_shift(abs_significand, shift)
    let hidden_limit = BigInt::from_uint64(netcdf_uint64_constant(1) << 53)
    if rounded.compare(hidden_limit) >= 0 {
      rounded = rounded >> 1
      exponent2 += 1
    }
    if exponent2 > 1023 {
      return sign_bit
        .lor(netcdf_uint64_constant(2047) << 52)
        .reinterpret_as_double()
    }
    let exponent_bits = netcdf_uint64_constant(exponent2 + 1023) << 52
    let fraction_bits = (rounded - fraction_limit).to_uint64()
    sign_bit.lor(exponent_bits).lor(fraction_bits).reinterpret_as_double()
  } else {
    let shift = -(exponent + 1074)
    let rounded = netcdf_bigint_round_shift(abs_significand, shift)
    if rounded.is_zero() {
      sign_bit.reinterpret_as_double()
    } else if rounded.compare(fraction_limit) >= 0 {
      sign_bit.lor(netcdf_uint64_constant(1) << 52).reinterpret_as_double()
    } else {
      sign_bit.lor(rounded.to_uint64()).reinterpret_as_double()
    }
  }
}

///|
fn netcdf_fma(a : Double, b : Double, c : Double) -> Double {
  let a_parts = match netcdf_binary_float_from_double(a) {
    Some(v) => v
    None => return a * b + c
  }
  let b_parts = match netcdf_binary_float_from_double(b) {
    Some(v) => v
    None => return a * b + c
  }
  let c_parts = match netcdf_binary_float_from_double(c) {
    Some(v) => v
    None => return a * b + c
  }
  let mut product_significand = a_parts.significand * b_parts.significand
  if a_parts.negative != b_parts.negative {
    product_significand = -product_significand
  }
  let product_exponent = a_parts.exponent + b_parts.exponent
  let mut addend_significand = c_parts.significand
  if c_parts.negative {
    addend_significand = -addend_significand
  }
  let common_exponent = if product_exponent < c_parts.exponent {
    product_exponent
  } else {
    c_parts.exponent
  }
  let exact = (product_significand << (product_exponent - common_exponent)) +
    (addend_significand << (c_parts.exponent - common_exponent))
  netcdf_double_from_exact_binary(exact, common_exponent)
}

///|
fn build_netcdf_latitude_values(
  meta : @lib.Grib2RecordMeta,
) -> Result[Array[Double], String] {
  let values : Array[Double] = []
  let scan = meta.section3_scanning_mode
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
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
  meta : @lib.Grib2RecordMeta,
) -> Result[Array[Double], String] {
  let values : Array[Double] = []
  let scan = meta.section3_scanning_mode
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
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
fn append_netcdf_double_bytes(out : Array[Byte], value : Double) -> Unit {
  append_bytes(out, value.reinterpret_as_uint64().to_be_bytes())
}

///|
fn append_netcdf_float_bytes(out : Array[Byte], value : Double) -> Unit {
  append_bytes(out, Float::from_double(value).to_be_bytes())
}

///|
fn build_netcdf_double_array_bytes(values : Array[Double]) -> Bytes {
  let out : Array[Byte] = []
  for value in values {
    append_netcdf_double_bytes(out, value)
  }
  Bytes::from_array(out)
}

///|
fn build_netcdf_float_grid_bytes(
  meta : @lib.Grib2RecordMeta,
  values : Array[Double],
) -> Result[Bytes, String] {
  let out : Array[Byte] = []
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => return Err("invalid ij point in -netcdf")
      }
      let value = values[idx]
      append_netcdf_float_bytes(
        out,
        if value == value {
          value
        } else {
          wgrib2_nodata_value()
        },
      )
    }
  }
  Ok(Bytes::from_array(out))
}

///|
fn build_single_record_netcdf_bytes(
  meta : @lib.Grib2RecordMeta,
  values : Array[Double],
) -> Result[Bytes, String] {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("-netcdf currently supports regular lat/lon grid (template 3.0)")
  }
  let expected_points = meta.section3_ni * meta.section3_nj
  if values.length() != expected_points {
    return Err(
      "-netcdf requires regular-grid value count: expected=" +
      expected_points.to_string() +
      ", got=" +
      values.length().to_string(),
    )
  }
  let latitude_values = match build_netcdf_latitude_values(meta) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let longitude_values = match build_netcdf_longitude_values(meta) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let verification_time = netcdf_verification_time_unix(meta).to_double()
  let variable_name = netcdf_variable_name(meta)
  let (long_name, units) = netcdf_long_name_units(meta)
  let dims : Array[NetcdfDimension] = [
    { name: "latitude", length: meta.section3_nj },
    { name: "longitude", length: meta.section3_ni },
    { name: "time", length: 0 },
  ]
  let global_attrs : Array[NetcdfAttr] = [
    { name: "Conventions", value: NetcdfAttrChars("COARDS") },
    { name: "History", value: NetcdfAttrChars("created by wgrib2") },
    { name: "GRIB2_grid_template", value: NetcdfAttrInt(0) },
  ]
  let vars : Array[NetcdfVariable] = [
    {
      name: "latitude",
      dimids: [0],
      attrs: [
        { name: "units", value: NetcdfAttrChars("degrees_north") },
        { name: "long_name", value: NetcdfAttrChars("latitude") },
      ],
      xtype: 6,
      values: build_netcdf_double_array_bytes(latitude_values),
      is_record: false,
    },
    {
      name: "longitude",
      dimids: [1],
      attrs: [
        { name: "units", value: NetcdfAttrChars("degrees_east") },
        { name: "long_name", value: NetcdfAttrChars("longitude") },
      ],
      xtype: 6,
      values: build_netcdf_double_array_bytes(longitude_values),
      is_record: false,
    },
    {
      name: "time",
      dimids: [2],
      attrs: [
        {
          name: "units",
          value: NetcdfAttrChars("seconds since 1970-01-01 00:00:00.0 0:00"),
        },
        {
          name: "long_name",
          value: NetcdfAttrChars(
            "verification time generated by wgrib2 function verftime()",
          ),
        },
        {
          name: "reference_time",
          value: NetcdfAttrDouble(meta.unix_rt.to_double()),
        },
        {
          name: "reference_time_type",
          value: NetcdfAttrInt(netcdf_record_reference_time_type(meta)),
        },
        {
          name: "reference_date",
          value: NetcdfAttrChars(
            netcdf_reference_date_text(meta.reference_time_full),
          ),
        },
        {
          name: "reference_time_description",
          value: NetcdfAttrChars(netcdf_record_reference_time_description(meta)),
        },
        { name: "time_step_setting", value: NetcdfAttrChars("auto") },
        { name: "time_step", value: NetcdfAttrDouble(0.0) },
      ],
      xtype: 6,
      values: build_netcdf_double_array_bytes([verification_time]),
      is_record: true,
    },
    {
      name: variable_name,
      dimids: [2, 0, 1],
      attrs: [
        { name: "_FillValue", value: NetcdfAttrFloat(wgrib2_nodata_value()) },
        { name: "short_name", value: NetcdfAttrChars(variable_name) },
        { name: "long_name", value: NetcdfAttrChars(long_name) },
        {
          name: "level",
          value: NetcdfAttrChars(name_lookup_text(meta.level_name)),
        },
        { name: "units", value: NetcdfAttrChars(units) },
      ],
      xtype: 5,
      values: match build_netcdf_float_grid_bytes(meta, values) {
        Ok(v) => v
        Err(error) => return Err(error)
      },
      is_record: true,
    },
  ]
  let header_size = netcdf_header_size(dims, global_attrs, vars)
  let mut next_non_record_begin = header_size
  let mut record_region_begin = header_size
  for nc_var in vars {
    if !nc_var.is_record {
      record_region_begin += netcdf_padded_size(nc_var.values.length())
    }
  }
  let mut next_record_begin = record_region_begin
  let placements : Array[NetcdfVariablePlacement] = []
  for nc_var in vars {
    if nc_var.is_record {
      placements.push({
        begin: next_record_begin,
        vsize: nc_var.values.length(),
      })
      next_record_begin += netcdf_padded_size(nc_var.values.length())
    } else {
      placements.push({
        begin: next_non_record_begin,
        vsize: nc_var.values.length(),
      })
      next_non_record_begin += netcdf_padded_size(nc_var.values.length())
    }
  }
  let out : Array[Byte] = []
  append_ascii_string_bytes(out, "CDF")
  out.push(b'\x01')
  append_u32_bytes(out, 1, true)
  append_bytes(out, build_netcdf_dimension_list_bytes(dims))
  append_bytes(out, build_netcdf_attr_list_bytes(global_attrs))
  append_bytes(out, build_netcdf_variable_list_bytes(vars, placements))
  for nc_var in vars {
    if nc_var.is_record {
      continue
    }
    append_bytes(out, nc_var.values)
    append_zero_bytes(
      out,
      netcdf_padded_size(nc_var.values.length()) - nc_var.values.length(),
    )
  }
  for nc_var in vars {
    if !nc_var.is_record {
      continue
    }
    append_bytes(out, nc_var.values)
    append_zero_bytes(
      out,
      netcdf_padded_size(nc_var.values.length()) - nc_var.values.length(),
    )
  }
  Ok(Bytes::from_array(out))
}

///|
fn write_netcdf_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if append_mode {
    return Err("-netcdf currently does not support -append")
  }
  if selected_record_count(context, selected) != 1 {
    return Err("-netcdf currently supports exactly one selected record")
  }
  let target_record = first_selected_record(selected)
  let meta = match find_record_meta(context, target_record) {
    Some(v) => v
    None =>
      return Err("record not found for -netcdf: " + target_record.to_string())
  }
  let values = match find_record_values(context, target_record) {
    Ok(v) => v
    Err(_) =>
      return Err(
        "failed to unpack record " + target_record.to_string() + " (-netcdf)",
      )
  }
  let bytes = match build_single_record_netcdf_bytes(meta, values) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  native_write_bytes(destination, bytes)
}
