///|
fn netcdf_wgrib2_fill_tail_bytes(byte_count : Int) -> Bytes {
  let out : Array[Byte] = []
  for _ in 0..<(byte_count / 4) {
    out.push(b'\x62')
    out.push(b'\x58')
    out.push(b'\xd1')
    out.push(b'\x9a')
  }
  Bytes::from_array(out)
}

///|
test "netcdf_wgrib2_fatal_lines_for_reason matches mixed-grid fresh fatal lines" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let context = match @io.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse mixed-grid fixture: " + e.to_string())
  }
  let lines = netcdf_wgrib2_fatal_lines_for_reason(
    context,
    None,
    NetcdfMixedGridType(78, 79),
  )
  inspect(lines[0], content="1.1:0:d=2024120600:PRMSL:mean sea level:anl:")
  inspect(lines[77], content="1.78:0:d=2024120600:VVEL:100 mb:anl:")
  inspect(lines[78], content="")
  inspect(
    lines[79],
    content="*** FATAL ERROR: netcdf: only one grid type at a time ***",
  )
  inspect(lines[80], content="")
  inspect(lines[81], content="1.79:0")
}

///|
test "netcdf_wgrib2_fatal_lines_for_reason matches mixed-grid append fatal lines" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let context = match @io.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse mixed-grid fixture: " + e.to_string())
  }
  let selected : Array[Int] = []
  for i in 2..<=79 {
    selected.push(i)
  }
  let lines = netcdf_wgrib2_fatal_lines_for_reason(
    context,
    Some(selected),
    NetcdfMixedGridType(77, 79),
  )
  inspect(lines[0], content="1.2:0:d=2024120600:PRES:surface:anl:")
  inspect(lines[76], content="1.78:0:d=2024120600:VVEL:100 mb:anl:")
  inspect(lines[77], content="")
  inspect(
    lines[78],
    content="*** FATAL ERROR: netcdf: only one grid type at a time ***",
  )
  inspect(lines[79], content="")
  inspect(lines[80], content="1.79:0")
}

///|
test "run_cli mirrors wgrib2 fresh mixed-grid netcdf abort artifact" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let ref_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_prefix_ref.nc"
  let fatal_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_prefix.nc"
  let fill_tail_len = 12188
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:78:1", "-netcdf", ref_out]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:79:1", "-netcdf", fatal_out]),
    content="8",
  )
  let ref_bytes = @fs.read_file_to_bytes(ref_out) catch {
    e =>
      fail(
        "failed to read mixed-grid prefix reference netcdf: " + e.to_string(),
      )
  }
  let fatal_bytes = @fs.read_file_to_bytes(fatal_out) catch {
    e => fail("failed to read mixed-grid prefix fatal netcdf: " + e.to_string())
  }
  let preserved_len = fatal_bytes.length() - fill_tail_len
  inspect(fatal_bytes.length() == ref_bytes.length(), content="true")
  inspect(
    fatal_bytes.sub(start=0, end=preserved_len).to_bytes() ==
    ref_bytes.sub(start=0, end=preserved_len).to_bytes(),
    content="true",
  )
  inspect(fatal_bytes == ref_bytes, content="false")
  inspect(
    fatal_bytes.sub(start=preserved_len).to_bytes() ==
    netcdf_wgrib2_fill_tail_bytes(fill_tail_len),
    content="true",
  )
}

///|
test "run_cli preserves netcdf append prefix before mixed-grid fatal" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let ref_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_append_ref.nc"
  let fatal_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_append.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", ref_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:78:1", "-netcdf", ref_out,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", fatal_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:79:1", "-netcdf", fatal_out,
    ]),
    content="8",
  )
  let ref_bytes = @fs.read_file_to_bytes(ref_out) catch {
    e =>
      fail(
        "failed to read mixed-grid append reference netcdf: " + e.to_string(),
      )
  }
  let fatal_bytes = @fs.read_file_to_bytes(fatal_out) catch {
    e => fail("failed to read mixed-grid append fatal netcdf: " + e.to_string())
  }
  inspect(fatal_bytes == ref_bytes, content="true")
}
