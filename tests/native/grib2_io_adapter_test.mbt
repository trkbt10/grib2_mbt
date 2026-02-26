///|
test "io adapter parse and render matches direct path" {
  let path = @grib2support.grib2_fixture_path_noaa_gfswave_global_0p25_f000()
  let direct = match @grib2support.grib2_fixture_context_parse(path) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let via_adapter = match
    @lib.parse_with_io(@grib2support.grib2_io_read_bytes, path) {
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
  let path = @grib2support.grib2_fixture_path_noaa_gfs_pgrb2_1p00_f000()
  let context = match
    @lib.parse_with_io(@grib2support.grib2_io_read_bytes, path) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let out_path = "target/grib2_io_adapter_test_output.grib2"
  match
    @lib.write_with_io(
      @grib2support.grib2_io_write_bytes,
      out_path,
      context,
      strict=true,
    ) {
    Ok(_) => ()
    Err(error) => fail(error.to_string())
  }
  let out_bytes = match @grib2support.grib2_io_read_bytes(out_path) {
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
    @grib2support.grib2_io_read_bytes,
    @grib2support.grib2_fixture_path_noaa_not_found(),
  )
  let has_error = match result {
    Ok(_) => false
    Err(_) => true
  }
  inspect(has_error, content="true")
}
