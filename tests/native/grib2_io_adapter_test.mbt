///|
fn fs_read_bytes(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("read failed: " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
fn fs_write_bytes(path : String, bytes : Bytes) -> Result[Unit, String] {
  try @fs.write_bytes_to_file(path, bytes) catch {
    error => Err("write failed: " + error.to_string())
  } noraise {
    _ => Ok(())
  }
}

///|
fn parse_fixture_direct(path : String) -> Result[@lib.Grib2FileContext, String] {
  let bytes = match fs_read_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => return Err(error)
  }
  match @lib.parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(error) => Err(error.to_string())
  }
}

///|
test "io adapter parse and render matches direct path" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2"
  let direct = match parse_fixture_direct(path) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let via_adapter = match @lib.parse_with_io(fs_read_bytes, path) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(via_adapter.message_count() == direct.message_count(), content="true")
  inspect(via_adapter.record_count() == direct.record_count(), content="true")
  inspect(
    @lib.render_inventory_lines(via_adapter, @lib.InventorySec3),
    content=@lib.render_inventory_lines(direct, @lib.InventorySec3).to_string(),
  )
}

///|
test "io adapter strict write emits parseable bytes" {
  let path = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let context = match @lib.parse_with_io(fs_read_bytes, path) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let out_path = "target/grib2_io_adapter_test_output.grib2"
  match @lib.write_with_io(fs_write_bytes, out_path, context, strict=true) {
    Ok(_) => ()
    Err(error) => fail(error.to_string())
  }
  let out_bytes = match fs_read_bytes(out_path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let reparsed = match @lib.parse_grib2_file(out_bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(reparsed.message_count(), content="696")
  inspect(reparsed.record_count(), content="696")
}

///|
test "io adapter read error is mapped" {
  let result = @lib.parse_with_io(
    fs_read_bytes, "fixtures/grib2_noaa/not_found.grib2",
  )
  let has_error = match result {
    Ok(_) => false
    Err(_) => true
  }
  inspect(has_error, content="true")
}
