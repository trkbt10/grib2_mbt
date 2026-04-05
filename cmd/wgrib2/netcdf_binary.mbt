///|
fn netcdf_supported_grid_error() -> String {
  "-netcdf currently supports regular lat/lon, rotated lat/lon, Mercator, polar stereographic, Lambert conformal, and Gaussian grids (templates 3.0/3.1/3.10/3.20/3.30/3.40)"
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
