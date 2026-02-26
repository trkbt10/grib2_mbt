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

// =============================================================================
// Section Accessor Functions (JSON)
// =============================================================================

///|
/// Get Section 1 data as JSON string.
/// message_index is 0-based.
/// Returns {"error":"..."} on error.
pub fn wasm_get_section1(handle : Int, message_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return section_error_to_json("invalid handle")
  }
  let context = wasm_contexts[handle]
  if message_index < 0 || message_index >= context.messages.length() {
    return section_error_to_json("message_index out of range")
  }
  let message = context.messages[message_index]
  match decode_message_section1(message) {
    Ok(s1) => section1_to_json(s1)
    Err(e) => section_error_to_json(e.to_string())
  }
}

///|
/// Get Section 3 data as JSON string.
/// record_index is 1-based.
/// Returns {"error":"..."} on error.
pub fn wasm_get_section3(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return section_error_to_json("invalid handle")
  }
  if record_index <= 0 {
    return section_error_to_json("record_index must be >= 1")
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return section_error_to_json("record_index out of range")
  }
  match decode_submessage_section3(frame.0, frame.1) {
    Ok(s3) => section3_to_json(s3)
    Err(e) => section_error_to_json(e.to_string())
  }
}

///|
/// Get Section 4 data as JSON string.
/// record_index is 1-based.
/// Returns {"error":"..."} on error.
pub fn wasm_get_section4(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return section_error_to_json("invalid handle")
  }
  if record_index <= 0 {
    return section_error_to_json("record_index must be >= 1")
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return section_error_to_json("record_index out of range")
  }
  match decode_submessage_section4(frame.0, frame.1) {
    Ok(s4) => section4_to_json(s4)
    Err(e) => section_error_to_json(e.to_string())
  }
}

///|
/// Get Section 5 data as JSON string.
/// record_index is 1-based.
/// Returns {"error":"..."} on error.
pub fn wasm_get_section5(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return section_error_to_json("invalid handle")
  }
  if record_index <= 0 {
    return section_error_to_json("record_index must be >= 1")
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return section_error_to_json("record_index out of range")
  }
  match decode_submessage_section5(frame.0, frame.1) {
    Ok(s5) => section5_to_json(s5)
    Err(e) => section_error_to_json(e.to_string())
  }
}

///|
/// Get Section 6 data as JSON string.
/// record_index is 1-based.
/// Returns {"error":"..."} on error.
pub fn wasm_get_section6(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return section_error_to_json("invalid handle")
  }
  if record_index <= 0 {
    return section_error_to_json("record_index must be >= 1")
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return section_error_to_json("record_index out of range")
  }
  match decode_submessage_section6(frame.0, frame.1) {
    Ok(s6) => section6_to_json(s6)
    Err(e) => section_error_to_json(e.to_string())
  }
}

///|
fn section_error_to_json(error : String) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"error\":\"")
  buf.write_string(escape_json_string(error))
  buf.write_string("\"}")
  buf.to_string()
}

///|
fn section1_to_json(s1 : Grib2Section1Decoded) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"center\":")
  buf.write_string(s1.center.to_string())
  buf.write_string(",\"subcenter\":")
  buf.write_string(s1.subcenter.to_string())
  buf.write_string(",\"masterTableVersion\":")
  buf.write_string(s1.master_table_version.to_string())
  buf.write_string(",\"localTableVersion\":")
  buf.write_string(s1.local_table_version.to_string())
  buf.write_string(",\"significanceOfRefTime\":")
  buf.write_string(s1.significance_of_reference_time.to_string())
  buf.write_string(",\"year\":")
  buf.write_string(s1.reference_year.to_string())
  buf.write_string(",\"month\":")
  buf.write_string(s1.reference_month.to_string())
  buf.write_string(",\"day\":")
  buf.write_string(s1.reference_day.to_string())
  buf.write_string(",\"hour\":")
  buf.write_string(s1.reference_hour.to_string())
  buf.write_string(",\"minute\":")
  buf.write_string(s1.reference_minute.to_string())
  buf.write_string(",\"second\":")
  buf.write_string(s1.reference_second.to_string())
  buf.write_string(",\"productionStatus\":")
  buf.write_string(s1.production_status.to_string())
  buf.write_string(",\"typeOfData\":")
  buf.write_string(s1.processed_data_type.to_string())
  buf.write_char('}')
  buf.to_string()
}

///|
fn section3_to_json(s3 : Grib2Section3Decoded) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"gridDefinitionSource\":")
  buf.write_string(s3.source_of_grid_definition.to_string())
  buf.write_string(",\"numberOfPoints\":")
  buf.write_string(s3.number_of_data_points.to_string())
  // Extract template number and common fields
  let info = @typed.get_section3_grid_info(s3.template)
  buf.write_string(",\"template\":")
  buf.write_string(info.template_id.to_string())
  if info.ni >= 0 {
    buf.write_string(",\"ni\":")
    buf.write_string(info.ni.to_string())
    buf.write_string(",\"nj\":")
    buf.write_string(info.nj.to_string())
    buf.write_string(",\"lat1Microdeg\":")
    buf.write_string(info.la1.to_string())
    buf.write_string(",\"lon1Microdeg\":")
    buf.write_string(info.lo1.to_string())
    buf.write_string(",\"lat2Microdeg\":")
    buf.write_string(info.la2.to_string())
    buf.write_string(",\"lon2Microdeg\":")
    buf.write_string(info.lo2.to_string())
    buf.write_string(",\"diMicrodeg\":")
    buf.write_string(info.di.to_string())
    buf.write_string(",\"djMicrodeg\":")
    buf.write_string(info.dj.to_string())
    buf.write_string(",\"scanMode\":")
    buf.write_string(info.scan_mode.to_string())
    buf.write_string(",\"resolutionFlags\":")
    buf.write_string(info.res_flags.to_string())
  }
  buf.write_char('}')
  buf.to_string()
}

///|
fn section4_to_json(s4 : Grib2Section4Decoded) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  // Extract template number and common fields
  let info = @typed.get_section4_product_info(s4.template)
  buf.write_string("\"template\":")
  buf.write_string(info.template_id.to_string())
  if info.param_cat >= 0 {
    buf.write_string(",\"parameterCategory\":")
    buf.write_string(info.param_cat.to_string())
    buf.write_string(",\"parameterNumber\":")
    buf.write_string(info.param_num.to_string())
    buf.write_string(",\"typeOfGeneratingProcess\":")
    buf.write_string(info.gen_process.to_string())
    buf.write_string(",\"indicatorOfUnitOfTimeRange\":")
    buf.write_string(info.time_unit.to_string())
    buf.write_string(",\"forecastTime\":")
    buf.write_string(info.forecast_time.to_string())
    buf.write_string(",\"typeOfFirstFixedSurface\":")
    buf.write_string(info.first_surface_type.to_string())
    buf.write_string(",\"scaleFactorOfFirstFixedSurface\":")
    buf.write_string(info.first_surface_scale.to_string())
    buf.write_string(",\"scaledValueOfFirstFixedSurface\":")
    buf.write_string(info.first_surface_value.to_string())
    buf.write_string(",\"typeOfSecondFixedSurface\":")
    if info.second_surface_type >= 0 && info.second_surface_type != 255 {
      buf.write_string(info.second_surface_type.to_string())
    } else {
      buf.write_string("null")
    }
    buf.write_string(",\"scaleFactorOfSecondFixedSurface\":")
    if info.second_surface_scale >= 0 {
      buf.write_string(info.second_surface_scale.to_string())
    } else {
      buf.write_string("null")
    }
    buf.write_string(",\"scaledValueOfSecondFixedSurface\":")
    if info.second_surface_value >= 0 {
      buf.write_string(info.second_surface_value.to_string())
    } else {
      buf.write_string("null")
    }
    // Optional ensemble fields
    if info.ensemble_type >= 0 {
      buf.write_string(",\"ensembleType\":")
      buf.write_string(info.ensemble_type.to_string())
    }
    if info.perturb_num >= 0 {
      buf.write_string(",\"perturbationNumber\":")
      buf.write_string(info.perturb_num.to_string())
    }
    if info.ensemble_members >= 0 {
      buf.write_string(",\"numberOfEnsembleMembers\":")
      buf.write_string(info.ensemble_members.to_string())
    }
    if info.prob_type >= 0 {
      buf.write_string(",\"probabilityType\":")
      buf.write_string(info.prob_type.to_string())
    }
  }
  buf.write_char('}')
  buf.to_string()
}

///|
fn section5_to_json(s5 : Grib2Section5Decoded) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"numberOfPoints\":")
  buf.write_string(s5.number_of_data_points.to_string())
  let info = @typed.get_section5_data_info(s5.template)
  buf.write_string(",\"template\":")
  buf.write_string(info.template_id.to_string())
  if info.reference_value_ieee >= 0 {
    buf.write_string(",\"referenceValue\":")
    buf.write_string(ieee_to_float(info.reference_value_ieee).to_string())
    buf.write_string(",\"binaryScaleFactor\":")
    buf.write_string(info.binary_scale.to_string())
    buf.write_string(",\"decimalScaleFactor\":")
    buf.write_string(info.decimal_scale.to_string())
    buf.write_string(",\"bitsPerValue\":")
    buf.write_string(info.bits_per_value.to_string())
  }
  buf.write_char('}')
  buf.to_string()
}

///|
fn ieee_to_float(ieee : Int) -> Double {
  ieee.reinterpret_as_uint().reinterpret_as_float().to_double()
}

///|
fn section6_to_json(s6 : Grib2Section6Decoded) -> String {
  let buf = StringBuilder::new()
  buf.write_char('{')
  buf.write_string("\"bitmapIndicator\":")
  buf.write_string(s6.bitmap_indicator.to_string())
  buf.write_char('}')
  buf.to_string()
}

// =============================================================================
// Binary Data Transfer (latin1)
// =============================================================================

///|
/// Get latitude coordinates as latin1 string (Float32 little-endian bytes).
/// record_index is 1-based.
/// Returns empty string on error.
pub fn wasm_get_latitudes(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return ""
  }
  if record_index <= 0 {
    return ""
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return ""
  }
  match decode_submessage_section3(frame.0, frame.1) {
    Ok(s3) =>
      match generate_coordinates(s3) {
        Some(coords) => binary_encode_f32le_latin1(coords.latitudes)
        None => ""
      }
    Err(_) => ""
  }
}

///|
/// Get longitude coordinates as latin1 string (Float32 little-endian bytes).
/// record_index is 1-based.
/// Returns empty string on error.
pub fn wasm_get_longitudes(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return ""
  }
  if record_index <= 0 {
    return ""
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return ""
  }
  match decode_submessage_section3(frame.0, frame.1) {
    Ok(s3) =>
      match generate_coordinates(s3) {
        Some(coords) => binary_encode_f32le_latin1(coords.longitudes)
        None => ""
      }
    Err(_) => ""
  }
}

///|
/// Get grid data as latin1 string (Float32 little-endian bytes).
/// record_index is 1-based.
/// Returns empty string on error.
pub fn wasm_get_grid_data(handle : Int, record_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return ""
  }
  if record_index <= 0 {
    return ""
  }
  let context = wasm_contexts[handle]
  let frame = match find_submessage_by_record_index(context, record_index) {
    Some(frame) => frame
    None => return ""
  }
  match unpack_submessage_data(frame.0, frame.1) {
    Ok(unpacked) => binary_encode_f32le_latin1(unpacked.values)
    Err(_) => ""
  }
}

///|
/// Generate coordinates from Section 3 data.
fn generate_coordinates(s3 : Grib2Section3Decoded) -> @typed.CoordinateGrid? {
  @typed.generate_coordinates_from_section3(s3.template)
}
