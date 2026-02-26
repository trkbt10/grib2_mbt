///|
fn minimal_grib2_message_bytes() -> Bytes {
  b"GRIB\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x32\x00\x00\x00\x05\x01\x00\x00\x00\x05\x03\x00\x00\x00\x05\x04\x00\x00\x00\x05\x05\x00\x00\x00\x05\x06\x00\x00\x00\x05\x077777"
}

///|
test "parse JMA GSM fixture and raw roundtrip" {
  match
    @grib2support.grib2_verify_fixture_raw_roundtrip(
      @grib2support.grib2_fixture_path_jma_gsm(),
      1,
      103,
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "parse NOAA pgrb2b fixture and raw roundtrip" {
  match
    @grib2support.grib2_verify_fixture_raw_roundtrip(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
      347,
      347,
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "parse NOAA gfswave fixture and raw roundtrip" {
  match
    @grib2support.grib2_verify_fixture_raw_roundtrip(
      @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
      19,
      19,
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "wgrib2 compatibility snapshots: JMA" {
  match
    @grib2support.grib2_verify_wgrib2_snapshots(
      @grib2support.grib2_fixture_path_jma_gsm(),
      @grib2support.grib2_snapshot_dir_jma_gsm(),
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "wgrib2 compatibility snapshots: NOAA pgrb2b" {
  match
    @grib2support.grib2_verify_wgrib2_snapshots(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
      @grib2support.grib2_snapshot_dir_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "wgrib2 compatibility snapshots: NOAA wave" {
  match
    @grib2support.grib2_verify_wgrib2_snapshots(
      @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
      @grib2support.grib2_snapshot_dir_noaa_gfswave_atlocn_0p16_f000(),
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
  let broken = @lib.binary_bytes_with_u8_at(
    minimal_grib2_message_bytes(),
    49,
    56,
  )
  let rejected = match @lib.parse_grib2_file(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "parser rejects section0 high length in strict 32-bit range" {
  let broken = @lib.binary_bytes_with_u32_be_at(
    minimal_grib2_message_bytes(),
    8,
    1,
  )
  let rejected = match @lib.parse_grib2_file(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}
