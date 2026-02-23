///|
fn minimal_grib2_message_bytes() -> Bytes {
  b"GRIB\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x32\x00\x00\x00\x05\x01\x00\x00\x00\x05\x03\x00\x00\x00\x05\x04\x00\x00\x00\x05\x05\x00\x00\x00\x05\x06\x00\x00\x00\x05\x077777"
}

///|
fn inline_reader(_source : String) -> Result[Bytes, String] {
  Ok(minimal_grib2_message_bytes())
}

///|
test "wasm smoke: parse and strict rebuild in memory" {
  let bytes = minimal_grib2_message_bytes()
  let context = match parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(context.message_count(), content="1")
  inspect(context.record_count(), content="1")
  let strict = match rebuild_strict(context) {
    Ok(bytes) => bytes
    Err(error) => fail(error.to_string())
  }
  inspect(strict == minimal_grib2_message_bytes(), content="true")
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
test "wasm_decode_record_grid_json invalid handle returns error json" {
  let json = wasm_decode_record_grid_json(-1, 1)
  inspect(json.contains("\"error\""), content="true")
}

///|
test "wasm_decode_record_grid_json out of range record returns error json" {
  let handle = wasm_parse_grib2(minimal_grib2_message_bytes())
  let json = wasm_decode_record_grid_json(handle, 2)
  inspect(json.contains("\"error\""), content="true")
}
