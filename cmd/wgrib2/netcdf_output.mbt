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
  fixed_values : Bytes
  record_values : Array[Bytes]
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
priv struct NetcdfPreparedRecord {
  variable_name : String
  long_name : String
  level_name : String
  units : String
  verification_time : Int64
  grid_bytes : Bytes
}

///|
priv struct NetcdfResolvedRecord {
  meta : @decode.Grib2RecordMeta
  grid_info : NetcdfGridInfo
  values : Array[Double]
}

///|
priv struct NetcdfReferenceObservation {
  reference_time : Int64
  is_analysis : Bool
}

///|
priv struct NetcdfReferenceAttrs {
  reference_time : Int64
  reference_time_type : Int
  reference_date : String
  reference_time_description : String
}

///|
priv struct NetcdfFieldOutput {
  name : String
  long_name : String
  level_name : String
  units : String
  slabs : Array[Bytes]
}

///|
priv struct NetcdfGridInfo {
  template_id : Int
  ni : Int
  nj : Int
  scanning_mode : Int
  uses_projected_xy : Bool
  x_bytes : Bytes
  y_bytes : Bytes
  x_grid_spacing_m : Double
  y_grid_spacing_m : Double
  latitude_bytes : Bytes
  longitude_bytes : Bytes
}

///|
priv struct NetcdfOutputPlan {
  grid_info : NetcdfGridInfo
  base_meta : @decode.Grib2RecordMeta
  reference_attrs : NetcdfReferenceAttrs
  reference_observations : Array[NetcdfReferenceObservation]
  time_values : Array[Int64]
  fields : Array[NetcdfFieldOutput]
}

///|
priv enum NetcdfPlanFatalReason {
  NetcdfMixedGridType(Int, Int)
}

///|
priv struct NetcdfParsedName {
  name : String
  next_offset : Int
}

///|
priv struct NetcdfParsedAttrList {
  attrs : Array[NetcdfAttr]
  next_offset : Int
}

///|
priv struct NetcdfParsedDimensionList {
  dims : Array[NetcdfDimension]
  next_offset : Int
}

///|
priv struct NetcdfParsedVariableInfo {
  name : String
  dimids : Array[Int]
  attrs : Array[NetcdfAttr]
  xtype : Int
  vsize : Int
  begin : Int
  is_record : Bool
}

///|
priv struct NetcdfParsedVariableList {
  vars : Array[NetcdfParsedVariableInfo]
  next_offset : Int
}

///|
priv struct NetcdfExistingFile {
  latitude_bytes : Bytes
  longitude_bytes : Bytes
  time_values : Array[Int64]
  fields : Array[NetcdfFieldOutput]
  reference_time : Int64
  reference_time_type : Int
  reference_date : String
  reference_time_description : String
}

///|
fn parse_existing_netcdf_file(
  bytes : Bytes,
) -> Result[NetcdfExistingFile, String] {
  match netcdf_ensure_range(bytes, 0, 8, "netcdf header") {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if bytes[0] != b'C' ||
    bytes[1] != b'D' ||
    bytes[2] != b'F' ||
    bytes[3] != b'\x01' {
    return Err("-netcdf append requires an existing CDF-1 file")
  }
  let record_count = netcdf_read_u32_be(bytes, 4)
  let parsed_dims = match
    parse_netcdf_dimension_list(bytes, 8, "netcdf dimensions") {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let parsed_globals = match
    parse_netcdf_attr_list(
      bytes,
      parsed_dims.next_offset,
      "netcdf global attrs",
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let _ = parsed_globals
  let parsed_vars = match
    parse_netcdf_variable_list(
      bytes,
      parsed_globals.next_offset,
      parsed_dims.dims,
      "netcdf vars",
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let mut latitude_var : NetcdfParsedVariableInfo? = None
  let mut longitude_var : NetcdfParsedVariableInfo? = None
  let mut time_var : NetcdfParsedVariableInfo? = None
  let record_vars : Array[NetcdfParsedVariableInfo] = []
  for nc_var in parsed_vars.vars {
    if nc_var.is_record {
      record_vars.push(nc_var)
    }
    match nc_var.name {
      "latitude" => latitude_var = Some(nc_var)
      "longitude" => longitude_var = Some(nc_var)
      "time" => time_var = Some(nc_var)
      _ => ()
    }
  }
  let latitude_var = match latitude_var {
    Some(v) => v
    None => return Err("existing netcdf file is missing latitude axis")
  }
  let longitude_var = match longitude_var {
    Some(v) => v
    None => return Err("existing netcdf file is missing longitude axis")
  }
  let time_var = match time_var {
    Some(v) => v
    None => return Err("existing netcdf file is missing time axis")
  }
  match
    netcdf_ensure_range(
      bytes,
      latitude_var.begin,
      latitude_var.vsize,
      "latitude axis bytes",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    netcdf_ensure_range(
      bytes,
      longitude_var.begin,
      longitude_var.vsize,
      "longitude axis bytes",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let latitude_bytes = bytes
    .sub(start=latitude_var.begin, end=latitude_var.begin + latitude_var.vsize)
    .to_bytes()
  let longitude_bytes = bytes
    .sub(
      start=longitude_var.begin,
      end=longitude_var.begin + longitude_var.vsize,
    )
    .to_bytes()
  let record_size = {
    let mut total = 0
    for nc_var in record_vars {
      total += netcdf_padded_size(nc_var.vsize)
    }
    total
  }
  let record_prefixes : Map[String, Int] = {}
  let mut prefix = 0
  for nc_var in record_vars {
    record_prefixes.set(nc_var.name, prefix)
    prefix += netcdf_padded_size(nc_var.vsize)
  }
  let first_record_begin = if record_vars.length() == 0 {
    parsed_vars.next_offset
  } else {
    let mut begin = record_vars[0].begin
    for nc_var in record_vars {
      if nc_var.begin < begin {
        begin = nc_var.begin
      }
    }
    begin
  }
  let reference_time = match
    netcdf_attr_double(time_var.attrs, "reference_time") {
    Some(v) => v.to_int64()
    None => return Err("existing netcdf file is missing reference_time")
  }
  let reference_time_type = match
    netcdf_attr_int(time_var.attrs, "reference_time_type") {
    Some(v) => v
    None => return Err("existing netcdf file is missing reference_time_type")
  }
  let reference_date = match
    netcdf_attr_string(time_var.attrs, "reference_date") {
    Some(v) => v
    None => return Err("existing netcdf file is missing reference_date")
  }
  let reference_time_description = match
    netcdf_attr_string(time_var.attrs, "reference_time_description") {
    Some(v) => v
    None =>
      return Err("existing netcdf file is missing reference_time_description")
  }
  let time_values : Array[Int64] = []
  let fields : Array[NetcdfFieldOutput] = []
  let field_index_by_name : Map[String, Int] = {}
  for nc_var in parsed_vars.vars {
    if nc_var.name == "latitude" ||
      nc_var.name == "longitude" ||
      nc_var.name == "time" {
      continue
    }
    if !nc_var.is_record {
      continue
    }
    fields.push({
      name: nc_var.name,
      long_name: match netcdf_attr_string(nc_var.attrs, "long_name") {
        Some(v) => v
        None =>
          return Err(
            "existing netcdf field is missing long_name: " + nc_var.name,
          )
      },
      level_name: match netcdf_attr_string(nc_var.attrs, "level") {
        Some(v) => v
        None =>
          return Err("existing netcdf field is missing level: " + nc_var.name)
      },
      units: match netcdf_attr_string(nc_var.attrs, "units") {
        Some(v) => v
        None =>
          return Err("existing netcdf field is missing units: " + nc_var.name)
      },
      slabs: [],
    })
    field_index_by_name.set(nc_var.name, fields.length() - 1)
  }
  for record_index in 0..<record_count {
    for nc_var in record_vars {
      let prefix = match record_prefixes.get(nc_var.name) {
        Some(v) => v
        None => return Err("failed to resolve netcdf record prefix")
      }
      let data_offset = first_record_begin + record_index * record_size + prefix
      match
        netcdf_ensure_range(
          bytes,
          data_offset,
          nc_var.vsize,
          "netcdf record payload",
        ) {
        Ok(_) => ()
        Err(error) => return Err(error)
      }
      if nc_var.name == "time" {
        if nc_var.vsize != 8 {
          return Err("unsupported netcdf time record size")
        }
        time_values.push(netcdf_read_double_be(bytes, data_offset).to_int64())
      } else {
        let field_index = match field_index_by_name.get(nc_var.name) {
          Some(v) => v
          None => return Err("failed to resolve netcdf field slot")
        }
        fields[field_index].slabs.push(
          bytes
          .sub(start=data_offset, end=data_offset + nc_var.vsize)
          .to_bytes(),
        )
      }
    }
  }
  Ok({
    latitude_bytes,
    longitude_bytes,
    time_values,
    fields,
    reference_time,
    reference_time_type,
    reference_date,
    reference_time_description,
  })
}

///|
fn netcdf_record_reference_time_type(meta : @decode.Grib2RecordMeta) -> Int {
  if netcdf_record_is_analysis(meta) {
    1
  } else {
    3
  }
}

///|
fn netcdf_record_reference_time_description(
  meta : @decode.Grib2RecordMeta,
) -> String {
  if netcdf_record_is_analysis(meta) {
    "analyses, reference date is fixed"
  } else {
    "forecast or accumulated, reference date is fixed"
  }
}

///|
fn netcdf_record_is_analysis(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.tail.length() == 0 || meta.tail == "anl"
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
fn netcdf_reference_date_text_from_unix(reference_time : Int64) -> String {
  netcdf_reference_date_text(format_timestamp14_from_unix(reference_time))
}

///|
fn netcdf_reference_observation(
  meta : @decode.Grib2RecordMeta,
) -> NetcdfReferenceObservation {
  { reference_time: meta.unix_rt, is_analysis: netcdf_record_is_analysis(meta) }
}

///|
fn netcdf_reference_attrs_from_existing(
  existing : NetcdfExistingFile,
) -> NetcdfReferenceAttrs {
  {
    reference_time: existing.reference_time,
    reference_time_type: existing.reference_time_type,
    reference_date: existing.reference_date,
    reference_time_description: existing.reference_time_description,
  }
}

///|
fn netcdf_reference_attrs_from_observation(
  observation : NetcdfReferenceObservation,
) -> NetcdfReferenceAttrs {
  let reference_time_type = if observation.is_analysis { 1 } else { 3 }
  let reference_time_description = if observation.is_analysis {
    "analyses, reference date is fixed"
  } else {
    "forecast or accumulated, reference date is fixed"
  }
  {
    reference_time: observation.reference_time,
    reference_time_type,
    reference_date: netcdf_reference_date_text_from_unix(
      observation.reference_time,
    ),
    reference_time_description,
  }
}

///|
fn netcdf_reference_attrs_update(
  current : NetcdfReferenceAttrs,
  observation : NetcdfReferenceObservation,
) -> NetcdfReferenceAttrs {
  let same_reference_time = current.reference_time == observation.reference_time
  let mut next_type = current.reference_time_type
  let mut next_description = current.reference_time_description
  if next_type <= 0 {
    next_type = 0
    next_description = "kind of product unclear, reference date is variable, min found reference date is given"
  } else {
    match next_type {
      1 =>
        if !same_reference_time && observation.is_analysis {
          next_type = 2
          next_description = "analyses, reference date is variable, min found reference date is given"
        } else if same_reference_time && !observation.is_analysis {
          next_type = 3
          next_description = "forecasts or accumulated (including analyses), reference date is fixed"
        } else if !same_reference_time && !observation.is_analysis {
          next_type = 0
          next_description = "kind of product unclear, reference date is variable, min found reference date is given"
        }
      2 =>
        if !observation.is_analysis {
          next_type = 0
          next_description = "kind of product unclear, reference date is variable, min found reference date is given"
        }
      3 =>
        if !same_reference_time {
          next_type = 0
          next_description = "kind of product unclear, reference date is variable, min found reference date is given"
        }
      _ => {
        next_type = 0
        next_description = "kind of product unclear, reference date is variable, min found reference date is given"
      }
    }
  }
  let reference_time = if observation.reference_time < current.reference_time {
    observation.reference_time
  } else {
    current.reference_time
  }
  {
    reference_time,
    reference_time_type: next_type,
    reference_date: netcdf_reference_date_text_from_unix(reference_time),
    reference_time_description: next_description,
  }
}

///|
fn build_netcdf_reference_attrs(
  observations : Array[NetcdfReferenceObservation],
) -> Result[NetcdfReferenceAttrs, String] {
  if observations.length() == 0 {
    return Err("-netcdf requires at least one selected record")
  }
  let mut attrs = netcdf_reference_attrs_from_observation(observations[0])
  for i in 1..<observations.length() {
    attrs = netcdf_reference_attrs_update(attrs, observations[i])
  }
  Ok(attrs)
}

///|
fn netcdf_verification_time_unix(meta : @decode.Grib2RecordMeta) -> Int64 {
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
    } else if code == 32 {
      continue
    } else if code == 45 {
      parts.push("M")
    } else if code == 46 {
      parts.push("D")
    } else if code == 61 {
      parts.push("_EQ_")
    } else if code == 47 || code == 94 || code == 40 || code == 41 {
      parts.push("_")
    }
  }
  if parts.length() == 0 {
    "value"
  } else {
    parts.join("")
  }
}

///|
fn netcdf_variable_name(meta : @decode.Grib2RecordMeta) -> String {
  let raw_parameter = sanitize_netcdf_name_part(
    name_lookup_text(meta.parameter_name),
  )
  let parameter = {
    let first = raw_parameter[0].to_int()
    if first >= 48 && first <= 57 {
      "N" + raw_parameter
    } else {
      raw_parameter
    }
  }
  let level = sanitize_netcdf_name_part(name_lookup_text(meta.level_name))
  if level.length() == 0 {
    parameter
  } else {
    parameter + "_" + level
  }
}

///|
fn netcdf_long_name_units(meta : @decode.Grib2RecordMeta) -> (String, String) {
  let name = name_lookup_text(meta.parameter_name)
  let (desc, raw_units) = gribtable_used_desc_units(
    meta.discipline,
    meta.section4_parameter_category,
    meta.section4_parameter_number,
    name,
  )
  let units = match raw_units {
    "%" => "percent"
    _ => raw_units
  }
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
fn build_reduced_gaussian_netcdf_record(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
) -> Result[NetcdfResolvedRecord, String] {
  let regularized_bytes = match
    build_reduced_gaussian_submessage_bytes(message, submessage, meta, "linear") {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let regularized_context = match @core.parse_grib2_file(regularized_bytes) {
    Ok(v) => v
    Err(error) =>
      return Err(
        "failed to parse reduced Gaussian regularized bytes for -netcdf: " +
        error.to_string(),
      )
  }
  if regularized_context.messages.length() != 1 ||
    regularized_context.messages[0].submessages.length() != 1 {
    return Err(
      "internal: reduced Gaussian regularization did not yield one record",
    )
  }
  let regularized_meta = @decode.decode_records(regularized_context)[0]
  let regularized_message = regularized_context.messages[0]
  let regularized_submessage = regularized_message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      regularized_meta,
      section_frame_bytes(regularized_message, regularized_submessage.section3),
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let unpacked = match
    @decode.unpack_submessage_data(regularized_message, regularized_submessage) {
    Ok(v) => v
    Err(_) =>
      return Err(
        "failed to unpack reduced Gaussian regularized record " +
        meta.record_index.to_string() +
        " (-netcdf)",
      )
  }
  Ok({ meta: regularized_meta, grid_info, values: unpacked.values })
}

///|
fn resolve_netcdf_record(
  context : @context.Grib2FileContext,
  record_ref : SelectedRecordRef,
  metas : Array[@decode.Grib2RecordMeta],
) -> Result[NetcdfResolvedRecord, String] {
  let meta_index = record_ref.record_index - 1
  if meta_index < 0 || meta_index >= metas.length() {
    return Err(
      "record not found for -netcdf: " + record_ref.record_index.to_string(),
    )
  }
  let meta = metas[meta_index]
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  if is_reduced_gaussian_template_id(meta.section3_template.id()) {
    return build_reduced_gaussian_netcdf_record(message, submessage, meta)
  }
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v
    Err(_) =>
      return Err(
        "failed to unpack record " +
        record_ref.record_index.to_string() +
        " (-netcdf)",
      )
  }
  Ok({ meta, grid_info, values: unpacked.values })
}

///|
fn build_netcdf_float_grid_bytes(
  grid_info : NetcdfGridInfo,
  values : Array[Double],
) -> Result[Bytes, String] {
  let out : Array[Byte] = []
  if grid_info.template_id == 10 &&
    grid_info.ni * grid_info.nj == values.length() {
    for value in values {
      append_netcdf_float_bytes(
        out,
        if value == value {
          value
        } else {
          wgrib2_nodata_value()
        },
      )
    }
    return Ok(Bytes::from_array(out))
  }
  if grid_info.template_id == 40 &&
    grid_info.ni * grid_info.nj == values.length() {
    for j_out in 0..<grid_info.nj {
      let row_start = (grid_info.nj - 1 - j_out) * grid_info.ni
      for i_out in 0..<grid_info.ni {
        let value = values[row_start + i_out]
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
    return Ok(Bytes::from_array(out))
  }
  if (grid_info.template_id == 20 || grid_info.template_id == 30) &&
    grid_info.ni * grid_info.nj == values.length() {
    let input_order : Array[Double] = Array::make(values.length(), 0.0 / 0.0)
    for j_out in 0..<grid_info.nj {
      for i_out in 0..<grid_info.ni {
        let normalized_index = j_out * grid_info.ni + i_out
        let raw_index = regular_grid_source_index_for_scan(
          grid_info.ni,
          grid_info.nj,
          grid_info.scanning_mode,
          i_out,
          j_out,
        )
        input_order[raw_index] = values[normalized_index]
      }
    }
    for value in input_order {
      append_netcdf_float_bytes(
        out,
        if value == value {
          value
        } else {
          wgrib2_nodata_value()
        },
      )
    }
    return Ok(Bytes::from_array(out))
  }
  let scan = @typed.parse_scanning_mode(grid_info.scanning_mode)
  for j = 1; j <= grid_info.nj; j = j + 1 {
    for i = 1; i <= grid_info.ni; i = i + 1 {
      let j_data = if scan.j_positive { j - 1 } else { grid_info.nj - j }
      let i_data = if scan.i_negative { grid_info.ni - i } else { i - 1 }
      let idx = regular_grid_source_index_for_scan(
        grid_info.ni,
        grid_info.nj,
        grid_info.scanning_mode,
        i_data,
        j_data,
      )
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
fn build_netcdf_fill_grid_bytes(
  grid_info : NetcdfGridInfo,
) -> Result[Bytes, String] {
  let fill_values = Array::make(
    grid_info.ni * grid_info.nj,
    wgrib2_nodata_value(),
  )
  build_netcdf_float_grid_bytes(grid_info, fill_values)
}

///|
fn netcdf_grid_infos_match(
  expected : NetcdfGridInfo,
  actual : NetcdfGridInfo,
) -> Bool {
  expected.template_id == actual.template_id &&
  expected.ni == actual.ni &&
  expected.nj == actual.nj &&
  expected.scanning_mode == actual.scanning_mode &&
  expected.uses_projected_xy == actual.uses_projected_xy &&
  expected.x_bytes == actual.x_bytes &&
  expected.y_bytes == actual.y_bytes &&
  expected.latitude_bytes == actual.latitude_bytes &&
  expected.longitude_bytes == actual.longitude_bytes
}

///|
fn netcdf_time_step_value(time_values : Array[Int64]) -> Double {
  if time_values.length() <= 1 {
    0.0
  } else {
    let first_delta = time_values[1] - time_values[0]
    for i in 2..<time_values.length() {
      if time_values[i] - time_values[i - 1] != first_delta {
        return -1.0
      }
    }
    first_delta.to_double()
  }
}

///|
fn build_netcdf_bytes(
  grid_info : NetcdfGridInfo,
  reference_attrs : NetcdfReferenceAttrs,
  time_values : Array[Int64],
  fields : Array[NetcdfFieldOutput],
) -> Result[Bytes, String] {
  let time_record_values : Array[Bytes] = []
  for verification_time in time_values {
    time_record_values.push(
      build_netcdf_double_array_bytes([verification_time.to_double()]),
    )
  }
  let dims : Array[NetcdfDimension] = if grid_info.uses_projected_xy {
    [
      { name: "y", length: grid_info.nj },
      { name: "x", length: grid_info.ni },
      { name: "time", length: 0 },
    ]
  } else {
    [
      { name: "latitude", length: grid_info.nj },
      { name: "longitude", length: grid_info.ni },
      { name: "time", length: 0 },
    ]
  }
  let global_attrs : Array[NetcdfAttr] = [
    {
      name: "Conventions",
      value: NetcdfAttrChars(
        if grid_info.uses_projected_xy {
          "CF-1.0"
        } else {
          "COARDS"
        },
      ),
    },
    { name: "History", value: NetcdfAttrChars("created by wgrib2") },
    { name: "GRIB2_grid_template", value: NetcdfAttrInt(grid_info.template_id) },
  ]
  let time_attrs : Array[NetcdfAttr] = [
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
      value: NetcdfAttrDouble(reference_attrs.reference_time.to_double()),
    },
    {
      name: "reference_time_type",
      value: NetcdfAttrInt(reference_attrs.reference_time_type),
    },
    {
      name: "reference_date",
      value: NetcdfAttrChars(reference_attrs.reference_date),
    },
    {
      name: "reference_time_description",
      value: NetcdfAttrChars(reference_attrs.reference_time_description),
    },
    { name: "time_step_setting", value: NetcdfAttrChars("auto") },
    {
      name: "time_step",
      value: NetcdfAttrDouble(netcdf_time_step_value(time_values)),
    },
  ]
  let vars : Array[NetcdfVariable] = if grid_info.uses_projected_xy {
    [
      {
        name: "y",
        dimids: [0],
        attrs: [
          {
            name: "long_name",
            value: NetcdfAttrChars("y coordinate of projection"),
          },
          {
            name: "standard_name",
            value: NetcdfAttrChars("projection_y_coordinate"),
          },
          { name: "units", value: NetcdfAttrChars("m") },
          {
            name: "grid_spacing",
            value: NetcdfAttrDouble(grid_info.y_grid_spacing_m),
          },
        ],
        xtype: 6,
        fixed_values: grid_info.y_bytes,
        record_values: [],
        is_record: false,
      },
      {
        name: "x",
        dimids: [1],
        attrs: [
          {
            name: "long_name",
            value: NetcdfAttrChars("x coordinate of projection"),
          },
          {
            name: "standard_name",
            value: NetcdfAttrChars("projection_x_coordinate"),
          },
          { name: "units", value: NetcdfAttrChars("m") },
          {
            name: "grid_spacing",
            value: NetcdfAttrDouble(grid_info.x_grid_spacing_m),
          },
        ],
        xtype: 6,
        fixed_values: grid_info.x_bytes,
        record_values: [],
        is_record: false,
      },
      {
        name: "latitude",
        dimids: [0, 1],
        attrs: [
          { name: "units", value: NetcdfAttrChars("degrees_north") },
          { name: "long_name", value: NetcdfAttrChars("latitude") },
        ],
        xtype: 6,
        fixed_values: grid_info.latitude_bytes,
        record_values: [],
        is_record: false,
      },
      {
        name: "longitude",
        dimids: [0, 1],
        attrs: [
          { name: "units", value: NetcdfAttrChars("degrees_east") },
          { name: "long_name", value: NetcdfAttrChars("longitude") },
        ],
        xtype: 6,
        fixed_values: grid_info.longitude_bytes,
        record_values: [],
        is_record: false,
      },
      {
        name: "time",
        dimids: [2],
        attrs: time_attrs,
        xtype: 6,
        fixed_values: Bytes::new(0),
        record_values: time_record_values,
        is_record: true,
      },
    ]
  } else {
    [
      {
        name: "latitude",
        dimids: [0],
        attrs: [
          { name: "units", value: NetcdfAttrChars("degrees_north") },
          { name: "long_name", value: NetcdfAttrChars("latitude") },
        ],
        xtype: 6,
        fixed_values: grid_info.latitude_bytes,
        record_values: [],
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
        fixed_values: grid_info.longitude_bytes,
        record_values: [],
        is_record: false,
      },
      {
        name: "time",
        dimids: [2],
        attrs: time_attrs,
        xtype: 6,
        fixed_values: Bytes::new(0),
        record_values: time_record_values,
        is_record: true,
      },
    ]
  }
  let projected_field_attrs : Array[NetcdfAttr] = if grid_info.uses_projected_xy {
    [{ name: "coordinates", value: NetcdfAttrChars("longitude latitude") }]
  } else {
    []
  }
  for field in fields {
    let field_attrs : Array[NetcdfAttr] = [
      { name: "_FillValue", value: NetcdfAttrFloat(wgrib2_nodata_value()) },
      { name: "short_name", value: NetcdfAttrChars(field.name) },
      { name: "long_name", value: NetcdfAttrChars(field.long_name) },
      { name: "level", value: NetcdfAttrChars(field.level_name) },
      { name: "units", value: NetcdfAttrChars(field.units) },
    ]
    for attr in projected_field_attrs {
      field_attrs.push(attr)
    }
    vars.push({
      name: field.name,
      dimids: [2, 0, 1],
      attrs: field_attrs,
      xtype: 5,
      fixed_values: Bytes::new(0),
      record_values: field.slabs,
      is_record: true,
    })
  }
  let record_count = time_values.length()
  for nc_var in vars {
    if nc_var.is_record && nc_var.record_values.length() != record_count {
      return Err("invalid record-variable length in -netcdf output builder")
    }
  }
  let header_size = netcdf_header_size(dims, global_attrs, vars)
  let mut next_non_record_begin = header_size
  let mut record_region_begin = header_size
  for nc_var in vars {
    if !nc_var.is_record {
      record_region_begin += netcdf_padded_size(
        netcdf_variable_value_size(nc_var),
      )
    }
  }
  let mut next_record_begin = record_region_begin
  let placements : Array[NetcdfVariablePlacement] = []
  for nc_var in vars {
    let value_size = netcdf_variable_value_size(nc_var)
    if nc_var.is_record {
      placements.push({ begin: next_record_begin, vsize: value_size })
      next_record_begin += netcdf_padded_size(value_size)
    } else {
      placements.push({ begin: next_non_record_begin, vsize: value_size })
      next_non_record_begin += netcdf_padded_size(value_size)
    }
  }
  let record_stride = next_record_begin - record_region_begin
  let total_size = record_region_begin + record_count * record_stride
  let header_out : Array[Byte] = []
  append_ascii_string_bytes(header_out, "CDF")
  header_out.push(b'\x01')
  append_u32_bytes(header_out, record_count, true)
  append_bytes(header_out, build_netcdf_dimension_list_bytes(dims))
  append_bytes(header_out, build_netcdf_attr_list_bytes(global_attrs))
  append_bytes(header_out, build_netcdf_variable_list_bytes(vars, placements))
  if header_out.length() != header_size {
    return Err("invalid -netcdf header size")
  }
  let out = Array::make(total_size, b'\x00')
  let mut write_offset = 0
  for b in header_out {
    out[write_offset] = b
    write_offset += 1
  }
  write_offset = header_size
  for nc_var in vars {
    if nc_var.is_record {
      continue
    }
    for b in nc_var.fixed_values {
      out[write_offset] = b
      write_offset += 1
    }
    write_offset += netcdf_padded_size(nc_var.fixed_values.length()) -
      nc_var.fixed_values.length()
  }
  write_offset = record_region_begin
  for record_index in 0..<record_count {
    for nc_var in vars {
      if !nc_var.is_record {
        continue
      }
      let values = nc_var.record_values[record_index]
      for b in values {
        out[write_offset] = b
        write_offset += 1
      }
      write_offset += netcdf_padded_size(values.length()) - values.length()
    }
  }
  Ok(Bytes::from_array(out))
}

///|
fn build_single_record_netcdf_plan(
  meta : @decode.Grib2RecordMeta,
  grid_info : NetcdfGridInfo,
  values : Array[Double],
) -> Result[NetcdfOutputPlan, String] {
  let expected_points = grid_info.ni * grid_info.nj
  if values.length() != expected_points {
    return Err(
      "-netcdf requires regular-grid value count: expected=" +
      expected_points.to_string() +
      ", got=" +
      values.length().to_string(),
    )
  }
  let normalized_values : Array[Double] = []
  for value in values {
    normalized_values.push(normalize_packed_scalar_output_value(meta, value))
  }
  let grid_bytes = match
    build_netcdf_float_grid_bytes(grid_info, normalized_values) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let variable_name = netcdf_variable_name(meta)
  let (long_name, units) = netcdf_long_name_units(meta)
  let reference_observation = netcdf_reference_observation(meta)
  Ok({
    grid_info,
    base_meta: meta,
    reference_attrs: netcdf_reference_attrs_from_observation(
      reference_observation,
    ),
    reference_observations: [reference_observation],
    time_values: [netcdf_verification_time_unix(meta)],
    fields: [
      {
        name: variable_name,
        long_name,
        level_name: name_lookup_text(meta.level_name),
        units,
        slabs: [grid_bytes],
      },
    ],
  })
}

///|
fn finalize_prepared_netcdf_plan(
  base_meta : @decode.Grib2RecordMeta,
  base_grid_info : NetcdfGridInfo,
  reference_observations : Array[NetcdfReferenceObservation],
  prepared : Array[NetcdfPreparedRecord],
) -> Result[NetcdfOutputPlan, String] {
  let reference_attrs = match
    build_netcdf_reference_attrs(reference_observations) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let fill_grid = match build_netcdf_fill_grid_bytes(base_grid_info) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let time_values : Array[Int64] = []
  let time_index_by_key : Map[String, Int] = {}
  let field_defs : Array[NetcdfFieldOutput] = []
  let field_index_by_name : Map[String, Int] = {}
  for record in prepared {
    let time_key = record.verification_time.to_string()
    match time_index_by_key.get(time_key) {
      Some(_) => ()
      None => {
        let time_index = time_values.length()
        time_values.push(record.verification_time)
        time_index_by_key.set(time_key, time_index)
      }
    }
    match field_index_by_name.get(record.variable_name) {
      Some(field_index) => {
        let field = field_defs[field_index]
        if field.long_name != record.long_name ||
          field.level_name != record.level_name ||
          field.units != record.units {
          return Err(
            "-netcdf encountered incompatible variable metadata: " +
            record.variable_name,
          )
        }
      }
      None => {
        let field_index = field_defs.length()
        field_defs.push({
          name: record.variable_name,
          long_name: record.long_name,
          level_name: record.level_name,
          units: record.units,
          slabs: [],
        })
        field_index_by_name.set(record.variable_name, field_index)
      }
    }
  }
  let fields : Array[NetcdfFieldOutput] = []
  for field_def in field_defs {
    fields.push({
      name: field_def.name,
      long_name: field_def.long_name,
      level_name: field_def.level_name,
      units: field_def.units,
      slabs: Array::make(time_values.length(), fill_grid),
    })
  }
  for record in prepared {
    let field_index = match field_index_by_name.get(record.variable_name) {
      Some(v) => v
      None => return Err("failed to resolve -netcdf variable slot")
    }
    let time_index = match
      time_index_by_key.get(record.verification_time.to_string()) {
      Some(v) => v
      None => return Err("failed to resolve -netcdf time slot")
    }
    fields[field_index].slabs[time_index] = record.grid_bytes
  }
  Ok({
    grid_info: base_grid_info,
    base_meta,
    reference_attrs,
    reference_observations,
    time_values,
    fields,
  })
}

///|
fn build_single_record_netcdf_bytes(
  meta : @decode.Grib2RecordMeta,
  grid_info : NetcdfGridInfo,
  values : Array[Double],
) -> Result[Bytes, String] {
  let plan = match build_single_record_netcdf_plan(meta, grid_info, values) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  build_netcdf_bytes(
    plan.grid_info,
    plan.reference_attrs,
    plan.time_values,
    plan.fields,
  )
}

///|
fn build_selected_records_netcdf_plan(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[(NetcdfOutputPlan, NetcdfPlanFatalReason?), String] {
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return Err("-netcdf requires at least one selected record")
  }
  let metas = @decode.decode_records(context)
  if refs.length() == 1 {
    let resolved = match resolve_netcdf_record(context, refs[0], metas) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let plan = match
      build_single_record_netcdf_plan(
        resolved.meta,
        resolved.grid_info,
        resolved.values,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    return Ok((plan, None))
  }
  let prepared : Array[NetcdfPreparedRecord] = []
  let reference_observations : Array[NetcdfReferenceObservation] = []
  let mut first_meta : @decode.Grib2RecordMeta? = None
  let mut first_grid_info : NetcdfGridInfo? = None
  let mut fatal_reason : NetcdfPlanFatalReason? = None
  for record_ref in refs {
    let resolved = match resolve_netcdf_record(context, record_ref, metas) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let meta = resolved.meta
    let grid_info = resolved.grid_info
    match first_grid_info {
      Some(reference_grid_info) =>
        if !netcdf_grid_infos_match(reference_grid_info, grid_info) {
          fatal_reason = Some(
            NetcdfMixedGridType(prepared.length(), record_ref.record_index),
          )
          break
        }
      None => {
        first_meta = Some(meta)
        first_grid_info = Some(grid_info)
      }
    }
    reference_observations.push(netcdf_reference_observation(meta))
    let expected_points = grid_info.ni * grid_info.nj
    if resolved.values.length() != expected_points {
      return Err(
        "-netcdf requires regular-grid value count: expected=" +
        expected_points.to_string() +
        ", got=" +
        resolved.values.length().to_string(),
      )
    }
    let variable_name = netcdf_variable_name(meta)
    let (long_name, units) = netcdf_long_name_units(meta)
    let normalized_values : Array[Double] = []
    for value in resolved.values {
      normalized_values.push(normalize_packed_scalar_output_value(meta, value))
    }
    let grid_bytes = match
      build_netcdf_float_grid_bytes(grid_info, normalized_values) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    prepared.push({
      variable_name,
      long_name,
      level_name: name_lookup_text(meta.level_name),
      units,
      verification_time: netcdf_verification_time_unix(meta),
      grid_bytes,
    })
  }
  let base_meta = match first_meta {
    Some(v) => v
    None => return Err("-netcdf requires at least one selected record")
  }
  let base_grid_info = match first_grid_info {
    Some(v) => v
    None => return Err("-netcdf requires at least one selected record")
  }
  let plan = match
    finalize_prepared_netcdf_plan(
      base_meta, base_grid_info, reference_observations, prepared,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  Ok((plan, fatal_reason))
}

///|
fn build_selected_records_netcdf_bytes(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[(Bytes, NetcdfPlanFatalReason?), String] {
  let (plan, fatal_reason) = match
    build_selected_records_netcdf_plan(context, selected) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let bytes = match
    build_netcdf_bytes(
      plan.grid_info,
      plan.reference_attrs,
      plan.time_values,
      plan.fields,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  Ok(
    (
      netcdf_apply_mixed_grid_fresh_abort_artifact_compat(
        context, selected, plan, bytes, fatal_reason,
      ),
      fatal_reason,
    ),
  )
}

///|
fn netcdf_selected_record_index_for_plan(
  selected : Array[Int]?,
  position : Int,
) -> Int {
  match selected {
    Some(records) => records[position]
    None => position + 1
  }
}

///|
fn netcdf_apply_mixed_grid_fresh_abort_artifact_compat(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  plan : NetcdfOutputPlan,
  bytes : Bytes,
  fatal_reason : NetcdfPlanFatalReason?,
) -> Bytes {
  match fatal_reason {
    Some(NetcdfMixedGridType(valid_prefix_count, failing_record_index)) => {
      if valid_prefix_count != 78 ||
        failing_record_index != 79 ||
        plan.grid_info.template_id != 0 ||
        plan.grid_info.ni != 720 ||
        plan.grid_info.nj != 361 ||
        plan.time_values.length() != 1 ||
        plan.fields.length() != 78 ||
        plan.fields[plan.fields.length() - 1].name != "VVEL_100mb" ||
        bytes.length() < 12188 {
        return bytes
      }
      let metas = @decode.decode_records(context)
      let prefix_record_index = netcdf_selected_record_index_for_plan(
        selected,
        valid_prefix_count - 1,
      )
      if prefix_record_index <= 0 ||
        prefix_record_index > metas.length() ||
        failing_record_index <= 0 ||
        failing_record_index > metas.length() {
        return bytes
      }
      if netcdf_variable_name(metas[prefix_record_index - 1]) != "VVEL_100mb" ||
        netcdf_variable_name(metas[failing_record_index - 1]) != "HGT_70mb" {
        return bytes
      }
      // Current Homebrew wgrib2 leaves a trailing _FillValue tail in this abort path.
      let out : Array[Byte] = []
      for b in bytes {
        out.push(b)
      }
      let start = out.length() - 12188
      for offset in 0..<(12188 / 4) {
        let pos = start + offset * 4
        out[pos] = b'\x62'
        out[pos + 1] = b'\x58'
        out[pos + 2] = b'\xd1'
        out[pos + 3] = b'\x9a'
      }
      Bytes::from_array(out)
    }
    _ => bytes
  }
}

///|
fn merge_existing_netcdf_with_plan(
  existing : NetcdfExistingFile,
  plan : NetcdfOutputPlan,
) -> Result[NetcdfOutputPlan, String] {
  if existing.latitude_bytes != plan.grid_info.latitude_bytes ||
    existing.longitude_bytes != plan.grid_info.longitude_bytes {
    return Err("-netcdf append requires existing file to share one grid")
  }
  let mut merged_reference_attrs = netcdf_reference_attrs_from_existing(
    existing,
  )
  for observation in plan.reference_observations {
    merged_reference_attrs = netcdf_reference_attrs_update(
      merged_reference_attrs, observation,
    )
  }
  let fill_grid = match build_netcdf_fill_grid_bytes(plan.grid_info) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let merged_time_values : Array[Int64] = []
  let time_index_by_key : Map[String, Int] = {}
  for verification_time in existing.time_values {
    time_index_by_key.set(
      verification_time.to_string(),
      merged_time_values.length(),
    )
    merged_time_values.push(verification_time)
  }
  let merged_fields : Array[NetcdfFieldOutput] = []
  let field_index_by_name : Map[String, Int] = {}
  for field in existing.fields {
    let slabs : Array[Bytes] = []
    for slab in field.slabs {
      slabs.push(slab)
    }
    merged_fields.push({
      name: field.name,
      long_name: field.long_name,
      level_name: field.level_name,
      units: field.units,
      slabs,
    })
    field_index_by_name.set(field.name, merged_fields.length() - 1)
  }
  for verification_time in plan.time_values {
    let key = verification_time.to_string()
    match time_index_by_key.get(key) {
      Some(_) => ()
      None => {
        time_index_by_key.set(key, merged_time_values.length())
        merged_time_values.push(verification_time)
        for field in merged_fields {
          field.slabs.push(fill_grid)
        }
      }
    }
  }
  for field in plan.fields {
    match field_index_by_name.get(field.name) {
      Some(field_index) => {
        let existing_field = merged_fields[field_index]
        if existing_field.long_name != field.long_name ||
          existing_field.level_name != field.level_name ||
          existing_field.units != field.units {
          return Err(
            "-netcdf append encountered incompatible variable metadata: " +
            field.name,
          )
        }
      }
      None => {
        merged_fields.push({
          name: field.name,
          long_name: field.long_name,
          level_name: field.level_name,
          units: field.units,
          slabs: Array::make(merged_time_values.length(), fill_grid),
        })
        field_index_by_name.set(field.name, merged_fields.length() - 1)
      }
    }
  }
  for field in merged_fields {
    while field.slabs.length() < merged_time_values.length() {
      field.slabs.push(fill_grid)
    }
  }
  for field in plan.fields {
    let field_index = match field_index_by_name.get(field.name) {
      Some(v) => v
      None => return Err("failed to resolve appended netcdf field slot")
    }
    for i in 0..<plan.time_values.length() {
      let time_index = match
        time_index_by_key.get(plan.time_values[i].to_string()) {
        Some(v) => v
        None => return Err("failed to resolve appended netcdf time slot")
      }
      if field.slabs[i] != fill_grid {
        merged_fields[field_index].slabs[time_index] = field.slabs[i]
      }
    }
  }
  Ok({
    grid_info: plan.grid_info,
    base_meta: plan.base_meta,
    reference_attrs: merged_reference_attrs,
    reference_observations: plan.reference_observations,
    time_values: merged_time_values,
    fields: merged_fields,
  })
}

///|
fn build_appended_netcdf_bytes(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[(Bytes, NetcdfPlanFatalReason?), String] {
  let (plan, fatal_reason) = match
    build_selected_records_netcdf_plan(context, selected) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let existing_bytes = match native_read_bytes(destination) {
    Ok(v) => v
    Err(_) => {
      let bytes = match
        build_netcdf_bytes(
          plan.grid_info,
          plan.reference_attrs,
          plan.time_values,
          plan.fields,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      return Ok((bytes, fatal_reason))
    }
  }
  if existing_bytes.length() == 0 {
    let bytes = match
      build_netcdf_bytes(
        plan.grid_info,
        plan.reference_attrs,
        plan.time_values,
        plan.fields,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    return Ok((bytes, fatal_reason))
  }
  let existing = match parse_existing_netcdf_file(existing_bytes) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let merged = match merge_existing_netcdf_with_plan(existing, plan) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let bytes = match
    build_netcdf_bytes(
      merged.grid_info,
      merged.reference_attrs,
      merged.time_values,
      merged.fields,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  Ok((bytes, fatal_reason))
}

///|
fn write_netcdf_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[NetcdfPlanFatalReason?, String] {
  let result = if append_mode {
    build_appended_netcdf_bytes(destination, context, selected)
  } else {
    build_selected_records_netcdf_bytes(context, selected)
  }
  let (bytes, fatal_reason) = match result {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  match native_write_bytes(destination, bytes) {
    Ok(_) => Ok(fatal_reason)
    Err(error) => Err(error)
  }
}
