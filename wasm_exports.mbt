///|
/// WASM FFI glue layer.
/// Provides handle-based API and latin1 binary transfer for JS consumers.
/// All actual GRIB2 logic is delegated to the @api package.

///|
let wasm_contexts : Array[@context.Grib2FileContext] = []

///|
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
pub fn wasm_parse_grib2_string(data : String) -> Int {
  wasm_parse_grib2(string_to_bytes(data))
}

///|
pub fn wasm_parse_grib2(bytes : Bytes) -> Int {
  match @api.parse(bytes) {
    Ok(context) => {
      let handle = wasm_contexts.length()
      wasm_contexts.push(context)
      handle
    }
    Err(_) => -1
  }
}

///|
pub fn wasm_get_message_count(handle : Int) -> Int {
  if handle < 0 || handle >= wasm_contexts.length() {
    return -1
  }
  wasm_contexts[handle].message_count()
}

///|
pub fn wasm_get_record_count(handle : Int) -> Int {
  if handle < 0 || handle >= wasm_contexts.length() {
    return -1
  }
  wasm_contexts[handle].record_count()
}

///|
pub fn wasm_get_section1(handle : Int, message_index : Int) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return @api.error_to_json("invalid handle")
  }
  let context = wasm_contexts[handle]
  if message_index < 0 || message_index >= context.messages.length() {
    return @api.error_to_json("message_index out of range")
  }
  match @api.get_section1_json(context.messages[message_index]) {
    Ok(json) => json
    Err(e) => @api.error_to_json(e)
  }
}

///|
fn wasm_section_accessor(
  handle : Int,
  record_index : Int,
  accessor : (
    @context.Grib2MessageContext,
    @context.Grib2SubmessageFrame,
  ) -> Result[String, String],
) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return @api.error_to_json("invalid handle")
  }
  if record_index <= 0 {
    return @api.error_to_json("record_index must be >= 1")
  }
  let context = wasm_contexts[handle]
  match @api.find_submessage(context, record_index) {
    Some(frame) =>
      match accessor(frame.0, frame.1) {
        Ok(json) => json
        Err(e) => @api.error_to_json(e)
      }
    None => @api.error_to_json("record_index out of range")
  }
}

///|
pub fn wasm_get_section3(handle : Int, record_index : Int) -> String {
  wasm_section_accessor(handle, record_index, @api.get_section3_json)
}

///|
pub fn wasm_get_section4(handle : Int, record_index : Int) -> String {
  wasm_section_accessor(handle, record_index, @api.get_section4_json)
}

///|
pub fn wasm_get_section5(handle : Int, record_index : Int) -> String {
  wasm_section_accessor(handle, record_index, @api.get_section5_json)
}

///|
pub fn wasm_get_section6(handle : Int, record_index : Int) -> String {
  wasm_section_accessor(handle, record_index, @api.get_section6_json)
}

///|
fn wasm_binary_accessor(
  handle : Int,
  record_index : Int,
  accessor : (
    @context.Grib2MessageContext,
    @context.Grib2SubmessageFrame,
  ) -> Result[Array[Double], String],
) -> String {
  if handle < 0 || handle >= wasm_contexts.length() {
    return ""
  }
  if record_index <= 0 {
    return ""
  }
  let context = wasm_contexts[handle]
  match @api.find_submessage(context, record_index) {
    Some(frame) =>
      match accessor(frame.0, frame.1) {
        Ok(values) => @core.binary_encode_f32le_latin1(values)
        Err(_) => ""
      }
    None => ""
  }
}

///|
pub fn wasm_get_latitudes(handle : Int, record_index : Int) -> String {
  wasm_binary_accessor(handle, record_index, @api.get_latitudes)
}

///|
pub fn wasm_get_longitudes(handle : Int, record_index : Int) -> String {
  wasm_binary_accessor(handle, record_index, @api.get_longitudes)
}

///|
pub fn wasm_get_grid_data(handle : Int, record_index : Int) -> String {
  wasm_binary_accessor(handle, record_index, @api.get_grid_data)
}
