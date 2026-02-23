///|
/// WASM exports for JavaScript integration.
/// These functions provide a simplified interface for JS consumers.

///|
/// Internal state to hold parsed context.
/// Using a simple approach with mutable state for WASM exports.
let wasm_contexts : Array[Grib2FileContext] = []

///|
/// Parse GRIB2 from a latin1-encoded string (each char = one byte).
/// This is the main entry point for browser usage with js-builtin-string.
/// Returns context handle or -1 on error.
pub fn wasm_parse_grib2_string(data : String) -> Int {
  let bytes = string_to_bytes(data)
  wasm_parse_grib2(bytes)
}

///|
/// Convert a latin1 string to Bytes (each char code becomes a byte).
fn string_to_bytes(s : String) -> Bytes {
  let len = s.length()
  let arr : Array[Byte] = Array::new(capacity=len)
  for i in 0..<len {
    let code = s[i].to_int()
    arr.push(code.to_byte())
  }
  Bytes::from_array(arr)
}

///|
/// Parse GRIB2 bytes and return a context handle (index).
/// Returns -1 on error.
pub fn wasm_parse_grib2(bytes : Bytes) -> Int {
  match parse_grib2_file(bytes) {
    Ok(context) => {
      let handle = wasm_contexts.length()
      wasm_contexts.push(context)
      handle
    }
    Err(_) => -1
  }
}

///|
/// Get message count for a parsed context.
/// Returns -1 if handle is invalid.
pub fn wasm_get_message_count(handle : Int) -> Int {
  if handle < 0 || handle >= wasm_contexts.length() {
    return -1
  }
  wasm_contexts[handle].message_count()
}

///|
/// Get record count for a parsed context.
/// Returns -1 if handle is invalid.
pub fn wasm_get_record_count(handle : Int) -> Int {
  if handle < 0 || handle >= wasm_contexts.length() {
    return -1
  }
  wasm_contexts[handle].record_count()
}

///|
/// Decode records and return as JSON string.
/// Returns empty string on error.
pub fn wasm_decode_records_json(handle : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return ""
  }
  let context = wasm_contexts[handle]
  let records = decode_records(context)
  records_to_json(records)
}

///|
/// Render inventory lines.
/// mode: 0=default, 1=short, 2=sec0, 3=sec3, 4=sec4, 5=sec5, 6=sec6, 7=seclen, 8=n, 9=range, 10=var, 11=lev, 12=ftime, 13=grid, 14=varlev
pub fn wasm_render_inventory(handle : Int, mode : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return ""
  }
  let context = wasm_contexts[handle]
  let inventory_mode = int_to_inventory_mode(mode)
  let lines = render_inventory_lines(context, inventory_mode)
  lines_to_json(lines)
}

///|
/// Decode a record's grid-point values and return as JSON string.
/// record_index is 1-based (same as decodeRecords output).
/// Returns {"error":"..."} on error.
pub fn wasm_decode_record_grid_json(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return grid_error_to_json(record_index, "invalid handle")
  }
  if record_index <= 0 {
    return grid_error_to_json(record_index, "record_index must be >= 1")
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None =>
      return grid_error_to_json(
        record_index,
        "record_index out of range: \{record_index}",
      )
  }
  let message = frame.0
  let submessage = frame.1
  let unpacked = match unpack_submessage_data(message, submessage) {
    Ok(v) => v
    Err(e) => return grid_error_to_json(record_index, unpack_error_message(e))
  }
  let section5_template = match
    decode_submessage_section5(message, submessage) {
    Ok(s5) => section5_template_id(s5)
    Err(_) => -1
  }
  let has_bitmap = match decode_submessage_section6(message, submessage) {
    Ok(s6) => s6.bitmap_indicator == 0
    Err(_) => false
  }
  grid_data_to_json(record_index, unpacked, section5_template, has_bitmap)
}

///|
fn find_submessage_by_record_index(
  context : Grib2FileContext,
  record_index : Int,
) -> (Grib2MessageContext, Grib2SubmessageFrame)? {
  let mut current = 1
  for message in context.messages {
    for submessage in message.submessages {
      if current == record_index {
        return Some((message, submessage))
      }
      current += 1
    }
  }
  None
}

///|
fn section5_template_id(section5 : Grib2Section5Decoded) -> Int {
  match section5.template {
    DataRepresentationTemplate50(_) => 0
    DataRepresentationTemplate51(_) => 1
    DataRepresentationTemplate52(_) => 2
    DataRepresentationTemplate53(_) => 3
    DataRepresentationTemplate54(_) => 4
    DataRepresentationTemplate540(_) => 40
    DataRepresentationTemplate541(_) => 41
    DataRepresentationTemplate542(_) => 42
    DataRepresentationTemplate550(_) => 50
    DataRepresentationTemplate551(_) => 51
    DataRepresentationTemplate553(_) => 53
    DataRepresentationTemplate561(_) => 61
    DataRepresentationTemplate5200(_) => 200
    DataRepresentationTemplateUnknown(id, _) => id
  }
}

///|
fn int_to_inventory_mode(mode : Int) -> Grib2InventoryMode {
  match mode {
    0 => InventoryDefault
    1 => InventoryShort
    2 => InventorySec0
    3 => InventorySec3
    4 => InventorySec4
    5 => InventorySec5
    6 => InventorySec6
    7 => InventorySecLen
    8 => InventoryN
    9 => InventoryRange
    10 => InventoryVar
    11 => InventoryLev
    12 => InventoryFtime
    13 => InventoryGrid
    14 => InventoryVarLev
    _ => InventoryDefault
  }
}

///|
fn lines_to_json(lines : Array[String]) -> String {
  let buf = StringBuilder::new()
  buf.write_char('[')
  for i, line in lines {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_char('"')
    buf.write_string(escape_json_string(line))
    buf.write_char('"')
  }
  buf.write_char(']')
  buf.to_string()
}

///|
fn grid_error_to_json(record_index : Int, error : String) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"recordIndex\":")
  buf.write_string(record_index.to_string())
  buf.write_string(",\"error\":\"")
  buf.write_string(escape_json_string(error))
  buf.write_string("\"}")
  buf.to_string()
}

///|
fn double_to_json(value : Double) -> String {
  if value != value {
    "null"
  } else {
    value.to_string()
  }
}

///|
fn grid_data_to_json(
  record_index : Int,
  grid : UnpackedGridData,
  section5_template : Int,
  has_bitmap : Bool,
) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"recordIndex\":")
  buf.write_string(record_index.to_string())
  buf.write_string(",\"numPoints\":")
  buf.write_string(grid.num_points.to_string())
  buf.write_string(",\"section5Template\":")
  buf.write_string(section5_template.to_string())
  buf.write_string(",\"hasBitmap\":")
  buf.write_string(if has_bitmap { "true" } else { "false" })
  buf.write_string(",\"values\":")
  buf.write_char('[')
  for i, value in grid.values {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string(double_to_json(value))
  }
  buf.write_char(']')
  buf.write_char('}')
  buf.to_string()
}

///|
fn unpack_error_message(err : UnpackError) -> String {
  match err {
    InvalidBitsPerValue(msg) => msg
    InsufficientData(msg) => msg
    UnsupportedTemplate(msg) => msg
  }
}

///|
fn escape_json_string(s : String) -> String {
  let buf = StringBuilder::new()
  for c in s {
    match c {
      '"' => buf.write_string("\\\"")
      '\\' => buf.write_string("\\\\")
      '\n' => buf.write_string("\\n")
      '\r' => buf.write_string("\\r")
      '\t' => buf.write_string("\\t")
      _ => buf.write_char(c)
    }
  }
  buf.to_string()
}

///|
fn records_to_json(records : Array[Grib2RecordMeta]) -> String {
  let buf = StringBuilder::new()
  buf.write_char('[')
  for i, record in records {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string(record_to_json(record))
  }
  buf.write_char(']')
  buf.to_string()
}

///|
fn record_to_json(r : Grib2RecordMeta) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"recordIndex\":")
  buf.write_string(r.record_index.to_string())
  buf.write_string(",\"recordId\":\"")
  buf.write_string(escape_json_string(r.record_id))
  buf.write_string("\",\"messageOffset\":")
  buf.write_string(r.message_offset.to_string())
  buf.write_string(",\"messageTotalLength\":")
  buf.write_string(r.message_total_length.to_string())
  buf.write_string(",\"referenceTime\":\"")
  buf.write_string(escape_json_string(r.reference_time))
  buf.write_string("\",\"discipline\":")
  buf.write_string(r.discipline.to_string())
  buf.write_string(",\"edition\":")
  buf.write_string(r.edition.to_string())
  buf.write_string(",\"parameterName\":\"")
  buf.write_string(escape_json_string(r.parameter_name.display()))
  buf.write_string("\",\"levelName\":\"")
  buf.write_string(escape_json_string(r.level_name.display()))
  buf.write_string("\",\"section3Template\":")
  buf.write_string(r.section3_template.id().to_string())
  buf.write_string(",\"section4Template\":")
  buf.write_string(r.section4_template.id().to_string())
  buf.write_string(",\"section5Template\":")
  buf.write_string(r.section5_template.id().to_string())
  buf.write_string(",\"section3Ni\":")
  buf.write_string(r.section3_ni.to_string())
  buf.write_string(",\"section3Nj\":")
  buf.write_string(r.section3_nj.to_string())
  buf.write_string(",\"section3Lat1Microdeg\":")
  buf.write_string(r.section3_lat1_microdeg.to_string())
  buf.write_string(",\"section3Lon1Microdeg\":")
  buf.write_string(r.section3_lon1_microdeg.to_string())
  buf.write_string(",\"section3Lat2Microdeg\":")
  buf.write_string(r.section3_lat2_microdeg.to_string())
  buf.write_string(",\"section3Lon2Microdeg\":")
  buf.write_string(r.section3_lon2_microdeg.to_string())
  buf.write_string(",\"section5NumDefinedPoints\":")
  buf.write_string(r.section5_num_defined_points.to_string())
  buf.write_string(",\"forecastTail\":\"")
  buf.write_string(escape_json_string(r.tail))
  buf.write_string("\"")
  buf.write_char('}')
  buf.to_string()
}
