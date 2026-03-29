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
  base_meta : @lib.Grib2RecordMeta
  reference_attrs : NetcdfReferenceAttrs
  reference_observations : Array[NetcdfReferenceObservation]
  time_values : Array[Int64]
  fields : Array[NetcdfFieldOutput]
}

///|
priv enum NetcdfPlanFatalReason {
  NetcdfMixedGridType
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
fn netcdf_supported_grid_error() -> String {
  "-netcdf currently supports regular lat/lon, rotated lat/lon, Mercator, polar stereographic, and Lambert conformal grids (templates 3.0/3.1/3.10/3.20/3.30)"
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
fn netcdf_variable_value_size(nc_var : NetcdfVariable) -> Int {
  if nc_var.is_record {
    if nc_var.record_values.length() == 0 {
      0
    } else {
      nc_var.record_values[0].length()
    }
  } else {
    nc_var.fixed_values.length()
  }
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
fn netcdf_ensure_range(
  bytes : Bytes,
  offset : Int,
  length : Int,
  context : String,
) -> Result[Unit, String] {
  if offset < 0 || length < 0 || offset + length > bytes.length() {
    Err("invalid netcdf payload while reading " + context)
  } else {
    Ok(())
  }
}

///|
fn netcdf_read_u32_be(bytes : Bytes, offset : Int) -> Int {
  bytes.unsafe_read_uint32_be(offset).reinterpret_as_int()
}

///|
fn netcdf_read_u64_be(bytes : Bytes, offset : Int) -> UInt64 {
  let mut value = UInt64::default()
  for i in 0..<8 {
    value = (value << 8).lor(UInt64::extend_uint(bytes[offset + i].to_uint()))
  }
  value
}

///|
fn netcdf_read_double_be(bytes : Bytes, offset : Int) -> Double {
  netcdf_read_u64_be(bytes, offset).reinterpret_as_double()
}

///|
fn netcdf_read_float_be(bytes : Bytes, offset : Int) -> Double {
  netcdf_read_u32_be(bytes, offset)
  .reinterpret_as_uint()
  .reinterpret_as_float()
  .to_double()
}

///|
fn netcdf_ascii_string_from_bytes(
  bytes : Bytes,
  offset : Int,
  length : Int,
) -> String {
  let out = StringBuilder::new()
  for i in 0..<length {
    out.write_char(
      Int::unsafe_to_char(bytes[offset + i].to_uint().reinterpret_as_int()),
    )
  }
  out.to_string()
}

///|
fn parse_netcdf_name(
  bytes : Bytes,
  offset : Int,
  context : String,
) -> Result[NetcdfParsedName, String] {
  match netcdf_ensure_range(bytes, offset, 4, context) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let length = netcdf_read_u32_be(bytes, offset)
  let padded = netcdf_padded_size(length)
  match netcdf_ensure_range(bytes, offset + 4, padded, context) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  Ok({
    name: netcdf_ascii_string_from_bytes(bytes, offset + 4, length),
    next_offset: offset + 4 + padded,
  })
}

///|
fn parse_netcdf_attr_list(
  bytes : Bytes,
  offset : Int,
  context : String,
) -> Result[NetcdfParsedAttrList, String] {
  match netcdf_ensure_range(bytes, offset, 8, context) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let tag = netcdf_read_u32_be(bytes, offset)
  let count = netcdf_read_u32_be(bytes, offset + 4)
  if tag == 0 && count == 0 {
    return Ok({ attrs: [], next_offset: offset + 8 })
  }
  if tag != 12 {
    return Err("invalid netcdf attr list tag in " + context)
  }
  let attrs : Array[NetcdfAttr] = []
  let mut cursor = offset + 8
  for _ in 0..<count {
    let parsed_name = match
      parse_netcdf_name(bytes, cursor, context + " attr name") {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    cursor = parsed_name.next_offset
    match netcdf_ensure_range(bytes, cursor, 8, context + " attr header") {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    let xtype = netcdf_read_u32_be(bytes, cursor)
    let element_count = netcdf_read_u32_be(bytes, cursor + 4)
    cursor += 8
    let element_size = match xtype {
      2 => 1
      4 => 4
      5 => 4
      6 => 8
      _ => return Err("unsupported netcdf attr xtype in " + context)
    }
    let payload_length = element_count * element_size
    let padded = netcdf_padded_size(payload_length)
    match
      netcdf_ensure_range(bytes, cursor, padded, context + " attr payload") {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    let value = match xtype {
      2 =>
        NetcdfAttrChars(
          netcdf_ascii_string_from_bytes(bytes, cursor, payload_length),
        )
      4 => {
        if element_count != 1 {
          return Err("unsupported netcdf attr int vector in " + context)
        }
        NetcdfAttrInt(netcdf_read_u32_be(bytes, cursor))
      }
      5 => {
        if element_count != 1 {
          return Err("unsupported netcdf attr float vector in " + context)
        }
        NetcdfAttrFloat(netcdf_read_float_be(bytes, cursor))
      }
      6 => {
        if element_count != 1 {
          return Err("unsupported netcdf attr double vector in " + context)
        }
        NetcdfAttrDouble(netcdf_read_double_be(bytes, cursor))
      }
      _ => return Err("unsupported netcdf attr xtype in " + context)
    }
    attrs.push({ name: parsed_name.name, value })
    cursor += padded
  }
  Ok({ attrs, next_offset: cursor })
}

///|
fn parse_netcdf_dimension_list(
  bytes : Bytes,
  offset : Int,
  context : String,
) -> Result[NetcdfParsedDimensionList, String] {
  match netcdf_ensure_range(bytes, offset, 8, context) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let tag = netcdf_read_u32_be(bytes, offset)
  let count = netcdf_read_u32_be(bytes, offset + 4)
  if tag == 0 && count == 0 {
    return Ok({ dims: [], next_offset: offset + 8 })
  }
  if tag != 10 {
    return Err("invalid netcdf dimension list tag in " + context)
  }
  let dims : Array[NetcdfDimension] = []
  let mut cursor = offset + 8
  for _ in 0..<count {
    let parsed_name = match
      parse_netcdf_name(bytes, cursor, context + " dim name") {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    cursor = parsed_name.next_offset
    match netcdf_ensure_range(bytes, cursor, 4, context + " dim length") {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    dims.push({
      name: parsed_name.name,
      length: netcdf_read_u32_be(bytes, cursor),
    })
    cursor += 4
  }
  Ok({ dims, next_offset: cursor })
}

///|
fn parse_netcdf_variable_list(
  bytes : Bytes,
  offset : Int,
  dims : Array[NetcdfDimension],
  context : String,
) -> Result[NetcdfParsedVariableList, String] {
  match netcdf_ensure_range(bytes, offset, 8, context) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let tag = netcdf_read_u32_be(bytes, offset)
  let count = netcdf_read_u32_be(bytes, offset + 4)
  if tag == 0 && count == 0 {
    return Ok({ vars: [], next_offset: offset + 8 })
  }
  if tag != 11 {
    return Err("invalid netcdf variable list tag in " + context)
  }
  let vars : Array[NetcdfParsedVariableInfo] = []
  let mut cursor = offset + 8
  for _ in 0..<count {
    let parsed_name = match
      parse_netcdf_name(bytes, cursor, context + " var name") {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    cursor = parsed_name.next_offset
    match netcdf_ensure_range(bytes, cursor, 4, context + " dimid count") {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    let dimid_count = netcdf_read_u32_be(bytes, cursor)
    cursor += 4
    let dimids : Array[Int] = []
    for _ in 0..<dimid_count {
      match netcdf_ensure_range(bytes, cursor, 4, context + " dimid") {
        Ok(_) => ()
        Err(error) => return Err(error)
      }
      let dimid = netcdf_read_u32_be(bytes, cursor)
      if dimid < 0 || dimid >= dims.length() {
        return Err("invalid netcdf dimid in " + context)
      }
      dimids.push(dimid)
      cursor += 4
    }
    let parsed_attrs = match
      parse_netcdf_attr_list(bytes, cursor, context + " var attrs") {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    cursor = parsed_attrs.next_offset
    match netcdf_ensure_range(bytes, cursor, 12, context + " var placement") {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    let xtype = netcdf_read_u32_be(bytes, cursor)
    let vsize = netcdf_read_u32_be(bytes, cursor + 4)
    let begin = netcdf_read_u32_be(bytes, cursor + 8)
    cursor += 12
    let is_record = dimids.length() > 0 && dims[dimids[0]].length == 0
    vars.push({
      name: parsed_name.name,
      dimids,
      attrs: parsed_attrs.attrs,
      xtype,
      vsize,
      begin,
      is_record,
    })
  }
  Ok({ vars, next_offset: cursor })
}

///|
fn netcdf_attr_string(attrs : Array[NetcdfAttr], name : String) -> String? {
  for attr in attrs {
    if attr.name == name {
      match attr.value {
        NetcdfAttrChars(value) => return Some(value)
        _ => return None
      }
    }
  }
  None
}

///|
fn netcdf_attr_int(attrs : Array[NetcdfAttr], name : String) -> Int? {
  for attr in attrs {
    if attr.name == name {
      match attr.value {
        NetcdfAttrInt(value) => return Some(value)
        _ => return None
      }
    }
  }
  None
}

///|
fn netcdf_attr_double(attrs : Array[NetcdfAttr], name : String) -> Double? {
  for attr in attrs {
    if attr.name == name {
      match attr.value {
        NetcdfAttrDouble(value) => return Some(value)
        NetcdfAttrFloat(value) => return Some(value)
        _ => return None
      }
    }
  }
  None
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
fn netcdf_record_reference_time_type(meta : @lib.Grib2RecordMeta) -> Int {
  if netcdf_record_is_analysis(meta) {
    1
  } else {
    3
  }
}

///|
fn netcdf_record_reference_time_description(
  meta : @lib.Grib2RecordMeta,
) -> String {
  if netcdf_record_is_analysis(meta) {
    "analyses, reference date is fixed"
  } else {
    "forecast or accumulated, reference date is fixed"
  }
}

///|
fn netcdf_record_is_analysis(meta : @lib.Grib2RecordMeta) -> Bool {
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
  meta : @lib.Grib2RecordMeta,
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
fn netcdf_variable_name(meta : @lib.Grib2RecordMeta) -> String {
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
fn netcdf_long_name_units(meta : @lib.Grib2RecordMeta) -> (String, String) {
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
fn build_netcdf_latitude_values(
  meta : @lib.Grib2RecordMeta,
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
  meta : @lib.Grib2RecordMeta,
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
  let scan = @lib.parse_scanning_mode(grid.scanning_mode)
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
  let scan = @lib.parse_scanning_mode(grid.scanning_mode)
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
  let scan = @lib.parse_scanning_mode(scan_mode)
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
  meta : @lib.Grib2RecordMeta,
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
    _ => Err(netcdf_supported_grid_error())
  }
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
  let scan = @lib.parse_scanning_mode(grid_info.scanning_mode)
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
  meta : @lib.Grib2RecordMeta,
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
  base_meta : @lib.Grib2RecordMeta,
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
  meta : @lib.Grib2RecordMeta,
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
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[(NetcdfOutputPlan, NetcdfPlanFatalReason?), String] {
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return Err("-netcdf requires at least one selected record")
  }
  let metas = @lib.decode_records(context)
  if refs.length() == 1 {
    let record_index = refs[0].record_index
    let meta = metas[record_index - 1]
    let message = context.messages[refs[0].message_index]
    let submessage = message.submessages[refs[0].submessage_index]
    let grid_info = match
      build_netcdf_grid_info(
        meta,
        section_frame_bytes(message, submessage.section3),
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let unpacked = match @lib.unpack_submessage_data(message, submessage) {
      Ok(v) => v
      Err(_) =>
        return Err(
          "failed to unpack record " + record_index.to_string() + " (-netcdf)",
        )
    }
    let plan = match
      build_single_record_netcdf_plan(meta, grid_info, unpacked.values) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    return Ok((plan, None))
  }
  let prepared : Array[NetcdfPreparedRecord] = []
  let reference_observations : Array[NetcdfReferenceObservation] = []
  let mut first_meta : @lib.Grib2RecordMeta? = None
  let mut first_grid_info : NetcdfGridInfo? = None
  let mut fatal_reason : NetcdfPlanFatalReason? = None
  for record_ref in refs {
    let meta_index = record_ref.record_index - 1
    if meta_index < 0 || meta_index >= metas.length() {
      return Err(
        "record not found for -netcdf: " + record_ref.record_index.to_string(),
      )
    }
    let meta = metas[meta_index]
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let grid_info = match
      build_netcdf_grid_info(
        meta,
        section_frame_bytes(message, submessage.section3),
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    match first_grid_info {
      Some(reference_grid_info) =>
        if !netcdf_grid_infos_match(reference_grid_info, grid_info) {
          fatal_reason = Some(NetcdfMixedGridType)
          break
        }
      None => {
        first_meta = Some(meta)
        first_grid_info = Some(grid_info)
      }
    }
    reference_observations.push(netcdf_reference_observation(meta))
    let unpacked = match @lib.unpack_submessage_data(message, submessage) {
      Ok(v) => v
      Err(_) =>
        return Err(
          "failed to unpack record " +
          record_ref.record_index.to_string() +
          " (-netcdf)",
        )
    }
    let expected_points = grid_info.ni * grid_info.nj
    if unpacked.values.length() != expected_points {
      return Err(
        "-netcdf requires regular-grid value count: expected=" +
        expected_points.to_string() +
        ", got=" +
        unpacked.values.length().to_string(),
      )
    }
    let variable_name = netcdf_variable_name(meta)
    let (long_name, units) = netcdf_long_name_units(meta)
    let normalized_values : Array[Double] = []
    for value in unpacked.values {
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
  context : @lib.Grib2FileContext,
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
  Ok((bytes, fatal_reason))
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
      merged_fields[field_index].slabs[time_index] = field.slabs[i]
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
  context : @lib.Grib2FileContext,
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
  context : @lib.Grib2FileContext,
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
