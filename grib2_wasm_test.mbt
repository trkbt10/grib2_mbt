///|
fn minimal_grib2_message_bytes() -> Bytes {
  b"GRIB\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x32\x00\x00\x00\x05\x01\x00\x00\x00\x05\x03\x00\x00\x00\x05\x04\x00\x00\x00\x05\x05\x00\x00\x00\x05\x06\x00\x00\x00\x05\x077777"
}

///|
fn inline_reader(_source : String) -> Result[Bytes, String] {
  Ok(minimal_grib2_message_bytes())
}

///|
test "wasm smoke: parse and raw rebuild in memory" {
  let bytes = minimal_grib2_message_bytes()
  let context = match parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(context.message_count(), content="1")
  inspect(context.record_count(), content="1")
  // Use rebuild_raw instead of rebuild_strict since minimal message
  // doesn't have valid typed section content
  let rebuilt = rebuild_raw(context)
  inspect(rebuilt == minimal_grib2_message_bytes(), content="true")
}

///|
test "wasm smoke: io adapter works with callback reader" {
  let context = match parse_with_io(inline_reader, "in-memory") {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let lines = render_inventory_lines(context, InventoryShort)
  inspect(lines.length(), content="1")
  inspect(lines[0].contains("d=0000000000"), content="true")
}

///|
test "wasm_get_section1 invalid handle returns error json" {
  let json = wasm_get_section1(-1, 0)
  inspect(json.contains("\"error\""), content="true")
}

///|
test "wasm_get_section3 invalid handle returns error json" {
  let json = wasm_get_section3(-1, 1)
  inspect(json.contains("\"error\""), content="true")
}

///|
test "wasm_get_section4 invalid handle returns error json" {
  let json = wasm_get_section4(-1, 1)
  inspect(json.contains("\"error\""), content="true")
}

///|
test "wasm_get_section5 invalid handle returns error json" {
  let json = wasm_get_section5(-1, 1)
  inspect(json.contains("\"error\""), content="true")
}

///|
test "wasm_get_section6 invalid handle returns error json" {
  let json = wasm_get_section6(-1, 1)
  inspect(json.contains("\"error\""), content="true")
}

///|
test "wasm_get_grid_data invalid handle returns empty string" {
  let result = wasm_get_grid_data(-1, 1)
  inspect(result.length(), content="0")
}

///|
test "wasm_get_latitudes invalid handle returns empty string" {
  let result = wasm_get_latitudes(-1, 1)
  inspect(result.length(), content="0")
}

///|
test "wasm_get_longitudes invalid handle returns empty string" {
  let result = wasm_get_longitudes(-1, 1)
  inspect(result.length(), content="0")
}
