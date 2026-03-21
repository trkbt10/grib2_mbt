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
priv struct NetcdfFieldOutput {
  name : String
  long_name : String
  level_name : String
  units : String
  slabs : Array[Bytes]
}

///|
priv struct NetcdfOutputPlan {
  base_meta : @lib.Grib2RecordMeta
  time_values : Array[Int64]
  fields : Array[NetcdfFieldOutput]
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
fn build_netcdf_fill_grid_bytes(
  meta : @lib.Grib2RecordMeta,
) -> Result[Bytes, String] {
  let fill_values = Array::make(
    meta.section3_ni * meta.section3_nj,
    wgrib2_nodata_value(),
  )
  build_netcdf_float_grid_bytes(meta, fill_values)
}

///|
fn netcdf_records_share_grid(
  expected : @lib.Grib2RecordMeta,
  actual : @lib.Grib2RecordMeta,
) -> Bool {
  expected.section3_template.id() == actual.section3_template.id() &&
  expected.section3_ni == actual.section3_ni &&
  expected.section3_nj == actual.section3_nj &&
  expected.section3_lat1_microdeg == actual.section3_lat1_microdeg &&
  expected.section3_lon1_microdeg == actual.section3_lon1_microdeg &&
  expected.section3_lat2_microdeg == actual.section3_lat2_microdeg &&
  expected.section3_lon2_microdeg == actual.section3_lon2_microdeg &&
  expected.section3_scanning_mode == actual.section3_scanning_mode
}

///|
fn netcdf_records_share_reference(
  expected : @lib.Grib2RecordMeta,
  actual : @lib.Grib2RecordMeta,
) -> Bool {
  expected.unix_rt == actual.unix_rt &&
  expected.reference_time_full == actual.reference_time_full &&
  netcdf_record_reference_time_type(expected) ==
  netcdf_record_reference_time_type(actual) &&
  netcdf_record_reference_time_description(expected) ==
  netcdf_record_reference_time_description(actual)
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
  meta : @lib.Grib2RecordMeta,
  time_values : Array[Int64],
  fields : Array[NetcdfFieldOutput],
) -> Result[Bytes, String] {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("-netcdf currently supports regular lat/lon grid (template 3.0)")
  }
  let latitude_values = match build_netcdf_latitude_values(meta) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let longitude_values = match build_netcdf_longitude_values(meta) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let time_record_values : Array[Bytes] = []
  for verification_time in time_values {
    time_record_values.push(
      build_netcdf_double_array_bytes([verification_time.to_double()]),
    )
  }
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
      fixed_values: build_netcdf_double_array_bytes(latitude_values),
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
      fixed_values: build_netcdf_double_array_bytes(longitude_values),
      record_values: [],
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
        {
          name: "time_step",
          value: NetcdfAttrDouble(netcdf_time_step_value(time_values)),
        },
      ],
      xtype: 6,
      fixed_values: Bytes::new(0),
      record_values: time_record_values,
      is_record: true,
    },
  ]
  for field in fields {
    vars.push({
      name: field.name,
      dimids: [2, 0, 1],
      attrs: [
        { name: "_FillValue", value: NetcdfAttrFloat(wgrib2_nodata_value()) },
        { name: "short_name", value: NetcdfAttrChars(field.name) },
        { name: "long_name", value: NetcdfAttrChars(field.long_name) },
        { name: "level", value: NetcdfAttrChars(field.level_name) },
        { name: "units", value: NetcdfAttrChars(field.units) },
      ],
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
  let out : Array[Byte] = []
  append_ascii_string_bytes(out, "CDF")
  out.push(b'\x01')
  append_u32_bytes(out, record_count, true)
  append_bytes(out, build_netcdf_dimension_list_bytes(dims))
  append_bytes(out, build_netcdf_attr_list_bytes(global_attrs))
  append_bytes(out, build_netcdf_variable_list_bytes(vars, placements))
  for nc_var in vars {
    if nc_var.is_record {
      continue
    }
    append_bytes(out, nc_var.fixed_values)
    append_zero_bytes(
      out,
      netcdf_padded_size(nc_var.fixed_values.length()) -
      nc_var.fixed_values.length(),
    )
  }
  for record_index in 0..<record_count {
    for nc_var in vars {
      if !nc_var.is_record {
        continue
      }
      let values = nc_var.record_values[record_index]
      append_bytes(out, values)
      append_zero_bytes(
        out,
        netcdf_padded_size(values.length()) - values.length(),
      )
    }
  }
  Ok(Bytes::from_array(out))
}

///|
fn build_single_record_netcdf_plan(
  meta : @lib.Grib2RecordMeta,
  values : Array[Double],
) -> Result[NetcdfOutputPlan, String] {
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
  let grid_bytes = match build_netcdf_float_grid_bytes(meta, values) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let variable_name = netcdf_variable_name(meta)
  let (long_name, units) = netcdf_long_name_units(meta)
  Ok({
    base_meta: meta,
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
fn build_single_record_netcdf_bytes(
  meta : @lib.Grib2RecordMeta,
  values : Array[Double],
) -> Result[Bytes, String] {
  let plan = match build_single_record_netcdf_plan(meta, values) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  build_netcdf_bytes(plan.base_meta, plan.time_values, plan.fields)
}

///|
fn build_selected_records_netcdf_plan(
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[NetcdfOutputPlan, String] {
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
    let unpacked = match @lib.unpack_submessage_data(message, submessage) {
      Ok(v) => v
      Err(_) =>
        return Err(
          "failed to unpack record " + record_index.to_string() + " (-netcdf)",
        )
    }
    return build_single_record_netcdf_plan(meta, unpacked.values)
  }
  let prepared : Array[NetcdfPreparedRecord] = []
  let mut first_meta : @lib.Grib2RecordMeta? = None
  for record_ref in refs {
    let meta_index = record_ref.record_index - 1
    if meta_index < 0 || meta_index >= metas.length() {
      return Err(
        "record not found for -netcdf: " + record_ref.record_index.to_string(),
      )
    }
    let meta = metas[meta_index]
    if meta.section3_template.id() != 0 ||
      meta.section3_ni <= 0 ||
      meta.section3_nj <= 0 {
      return Err(
        "-netcdf currently supports regular lat/lon grid (template 3.0)",
      )
    }
    match first_meta {
      Some(reference_meta) => {
        if !netcdf_records_share_grid(reference_meta, meta) {
          return Err("-netcdf requires selected records to share one grid")
        }
        if !netcdf_records_share_reference(reference_meta, meta) {
          return Err(
            "-netcdf requires selected records to share one reference time",
          )
        }
      }
      None => first_meta = Some(meta)
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let unpacked = match @lib.unpack_submessage_data(message, submessage) {
      Ok(v) => v
      Err(_) =>
        return Err(
          "failed to unpack record " +
          record_ref.record_index.to_string() +
          " (-netcdf)",
        )
    }
    let expected_points = meta.section3_ni * meta.section3_nj
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
    let grid_bytes = match
      build_netcdf_float_grid_bytes(meta, unpacked.values) {
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
  let fill_grid = match build_netcdf_fill_grid_bytes(base_meta) {
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
  Ok({ base_meta, time_values, fields })
}

///|
fn build_selected_records_netcdf_bytes(
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[Bytes, String] {
  let plan = match build_selected_records_netcdf_plan(context, selected) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  build_netcdf_bytes(plan.base_meta, plan.time_values, plan.fields)
}

///|
fn merge_existing_netcdf_with_plan(
  existing : NetcdfExistingFile,
  plan : NetcdfOutputPlan,
) -> Result[NetcdfOutputPlan, String] {
  let expected_latitudes = match build_netcdf_latitude_values(plan.base_meta) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let expected_longitudes = match
    build_netcdf_longitude_values(plan.base_meta) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let expected_latitude_bytes = build_netcdf_double_array_bytes(
    expected_latitudes,
  )
  let expected_longitude_bytes = build_netcdf_double_array_bytes(
    expected_longitudes,
  )
  if existing.latitude_bytes != expected_latitude_bytes ||
    existing.longitude_bytes != expected_longitude_bytes {
    return Err("-netcdf append requires existing file to share one grid")
  }
  if existing.reference_time != plan.base_meta.unix_rt ||
    existing.reference_time_type !=
    netcdf_record_reference_time_type(plan.base_meta) ||
    existing.reference_date !=
    netcdf_reference_date_text(plan.base_meta.reference_time_full) ||
    existing.reference_time_description !=
    netcdf_record_reference_time_description(plan.base_meta) {
    return Err(
      "-netcdf append requires existing file to share one reference time",
    )
  }
  let fill_grid = match build_netcdf_fill_grid_bytes(plan.base_meta) {
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
    base_meta: plan.base_meta,
    time_values: merged_time_values,
    fields: merged_fields,
  })
}

///|
fn build_appended_netcdf_bytes(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
) -> Result[Bytes, String] {
  let plan = match build_selected_records_netcdf_plan(context, selected) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let existing_bytes = match native_read_bytes(destination) {
    Ok(v) => v
    Err(_) =>
      return build_netcdf_bytes(plan.base_meta, plan.time_values, plan.fields)
  }
  if existing_bytes.length() == 0 {
    return build_netcdf_bytes(plan.base_meta, plan.time_values, plan.fields)
  }
  let existing = match parse_existing_netcdf_file(existing_bytes) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let merged = match merge_existing_netcdf_with_plan(existing, plan) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  build_netcdf_bytes(merged.base_meta, merged.time_values, merged.fields)
}

///|
fn write_netcdf_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let result = if append_mode {
    build_appended_netcdf_bytes(destination, context, selected)
  } else {
    build_selected_records_netcdf_bytes(context, selected)
  }
  let bytes = match result {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  native_write_bytes(destination, bytes)
}
