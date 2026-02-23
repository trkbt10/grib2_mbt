///|
fn read_fixture(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("failed to read fixture " + path + ": " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
fn parse_fixture(path : String) -> Result[@lib.Grib2FileContext, String] {
  let bytes = match read_fixture(path) {
    Ok(bytes) => bytes
    Err(error) => return Err(error)
  }
  match @lib.parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(error) =>
      Err("failed to parse fixture " + path + ": " + error.to_string())
  }
}

///|
fn read_snapshot_lines(path : String) -> Result[Array[String], String] {
  try @fs.read_file_to_string(path) catch {
    error => Err("failed to read snapshot " + path + ": " + error.to_string())
  } noraise {
    content => {
      let lines : Array[String] = []
      for line in content.split("\n") {
        let text = line.to_string()
        if text != "" {
          lines.push(text)
        }
      }
      Ok(lines)
    }
  }
}

///|
fn compare_with_snapshot(
  name : String,
  actual : Array[String],
  snapshot_path : String,
) -> Result[Unit, String] {
  let expected = match read_snapshot_lines(snapshot_path) {
    Ok(expected) => expected
    Err(error) => return Err(error)
  }
  let min_len = if actual.length() < expected.length() {
    actual.length()
  } else {
    expected.length()
  }
  loop 0 {
    index => {
      if index == min_len {
        if actual.length() != expected.length() {
          return Err(
            name +
            ": line count mismatch: actual=" +
            actual.length().to_string() +
            ", expected=" +
            expected.length().to_string(),
          )
        }
        return Ok(())
      }
      if actual[index] != expected[index] {
        return Err(
          name +
          ": first mismatch at line " +
          (index + 1).to_string() +
          ", actual=\"" +
          actual[index] +
          "\", expected=\"" +
          expected[index] +
          "\"",
        )
      }
      continue index + 1
    }
  }
}

///|
fn verify_fixture_against_wgrib2_snapshots(
  fixture_path : String,
  snapshot_dir : String,
) -> Result[Unit, String] {
  let context = match parse_fixture(fixture_path) {
    Ok(context) => context
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " default",
      @lib.wgrib2_default_lines(context),
      snapshot_dir + "/default.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " s",
      @lib.wgrib2_s_lines(context),
      snapshot_dir + "/s.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " Sec0",
      @lib.wgrib2_sec0_lines(context),
      snapshot_dir + "/Sec0.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " Sec3",
      @lib.wgrib2_sec3_lines(context),
      snapshot_dir + "/Sec3.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " Sec4",
      @lib.wgrib2_sec4_lines(context),
      snapshot_dir + "/Sec4.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " Sec5",
      @lib.wgrib2_sec5_lines(context),
      snapshot_dir + "/Sec5.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " Sec6",
      @lib.wgrib2_sec6_lines(context),
      snapshot_dir + "/Sec6.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " Sec_len",
      @lib.wgrib2_sec_len_lines(context),
      snapshot_dir + "/Sec_len.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " n",
      @lib.wgrib2_n_lines(context),
      snapshot_dir + "/n.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " range",
      @lib.wgrib2_range_lines(context),
      snapshot_dir + "/range.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " var",
      @lib.wgrib2_var_lines(context),
      snapshot_dir + "/var.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " lev",
      @lib.wgrib2_lev_lines(context),
      snapshot_dir + "/lev.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " ftime",
      @lib.wgrib2_ftime_lines(context),
      snapshot_dir + "/ftime.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " grid",
      @lib.wgrib2_grid_lines(context),
      snapshot_dir + "/grid.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " pdt",
      @lib.wgrib2_pdt_lines(context),
      snapshot_dir + "/pdt.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " process",
      @lib.wgrib2_process_lines(context),
      snapshot_dir + "/process.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " ens",
      @lib.wgrib2_ens_lines(context),
      snapshot_dir + "/ens.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " prob",
      @lib.wgrib2_prob_lines(context),
      snapshot_dir + "/prob.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " disc",
      @lib.wgrib2_disc_lines(context),
      snapshot_dir + "/disc.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " center",
      @lib.wgrib2_center_lines(context),
      snapshot_dir + "/center.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " subcenter",
      @lib.wgrib2_subcenter_lines(context),
      snapshot_dir + "/subcenter.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " packing",
      @lib.wgrib2_packing_lines(context),
      snapshot_dir + "/packing.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " bitmap",
      @lib.wgrib2_bitmap_lines(context),
      snapshot_dir + "/bitmap.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " nxny",
      @lib.wgrib2_nxny_lines(context),
      snapshot_dir + "/nxny.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  match
    compare_with_snapshot(
      fixture_path + " npts",
      @lib.wgrib2_npts_lines(context),
      snapshot_dir + "/npts.txt",
    ) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  compare_with_snapshot(
    fixture_path + " var_lev",
    @lib.wgrib2_var_lev_lines(context),
    snapshot_dir + "/var_lev.txt",
  )
}

///|
fn parser_with_u8(bytes : Bytes, offset : Int, value : Int) -> Bytes {
  let copy = bytes.to_array()
  copy[offset] = value.to_byte()
  Bytes::from_array(copy)
}

///|
fn parser_with_u32_be(bytes : Bytes, offset : Int, value : Int) -> Bytes {
  let copy = bytes.to_array()
  copy[offset] = ((value >> 24) & 0xff).to_byte()
  copy[offset + 1] = ((value >> 16) & 0xff).to_byte()
  copy[offset + 2] = ((value >> 8) & 0xff).to_byte()
  copy[offset + 3] = (value & 0xff).to_byte()
  Bytes::from_array(copy)
}

///|
fn minimal_grib2_message_bytes() -> Bytes {
  b"GRIB\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x32\x00\x00\x00\x05\x01\x00\x00\x00\x05\x03\x00\x00\x00\x05\x04\x00\x00\x00\x05\x05\x00\x00\x00\x05\x06\x00\x00\x00\x05\x077777"
}

///|
test "parse JMA GSM fixture and raw roundtrip" {
  let path = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let bytes = match read_fixture(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let context = match parse_fixture(path) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  inspect(context.message_count(), content="1")
  inspect(context.record_count(), content="103")
  inspect(@lib.rebuild_raw(context) == bytes, content="true")
}

///|
test "parse NOAA pgrb2b fixture and raw roundtrip" {
  let path = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let bytes = match read_fixture(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let context = match parse_fixture(path) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  inspect(context.message_count(), content="347")
  inspect(context.record_count(), content="347")
  inspect(@lib.rebuild_raw(context) == bytes, content="true")
}

///|
test "parse NOAA gfswave fixture and raw roundtrip" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let bytes = match read_fixture(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let context = match parse_fixture(path) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  inspect(context.message_count(), content="19")
  inspect(context.record_count(), content="19")
  inspect(@lib.rebuild_raw(context) == bytes, content="true")
}

///|
test "wgrib2 compatibility snapshots: JMA" {
  match
    verify_fixture_against_wgrib2_snapshots(
      "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin",
      "fixtures/wgrib2_snapshots/jma_gsm",
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "wgrib2 compatibility snapshots: NOAA pgrb2b" {
  match
    verify_fixture_against_wgrib2_snapshots(
      "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2", "fixtures/wgrib2_snapshots/noaa_gfs_pgrb2b_1p00_f000",
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "wgrib2 compatibility snapshots: NOAA wave" {
  match
    verify_fixture_against_wgrib2_snapshots(
      "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2", "fixtures/wgrib2_snapshots/noaa_gfswave_atlocn_0p16_f000",
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "section0 and section8 minimal message parse and rebuild" {
  let bytes = minimal_grib2_message_bytes()
  let parsed = match @lib.parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(parsed.message_count(), content="1")
  inspect(parsed.record_count(), content="1")
  inspect(parsed.messages[0].total_length, content="50")
  inspect(@lib.rebuild_raw(parsed) == bytes, content="true")
}

///|
test "parser rejects broken section8 magic" {
  let broken = parser_with_u8(minimal_grib2_message_bytes(), 49, 56)
  let rejected = match @lib.parse_grib2_file(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "parser rejects section0 high length in strict 32-bit range" {
  let broken = parser_with_u32_be(minimal_grib2_message_bytes(), 8, 1)
  let rejected = match @lib.parse_grib2_file(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}
