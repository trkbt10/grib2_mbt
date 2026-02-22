///|
fn read_fixture_bytes(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("failed to read fixture " + path + ": " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
fn parse_fixture_for_writer(
  path : String,
) -> Result[@lib.Grib2FileContext, String] {
  let bytes = match read_fixture_bytes(path) {
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
fn message_with_offset(
  message : @lib.Grib2MessageContext,
  offset : Int,
) -> @lib.Grib2MessageContext {
  {
    offset,
    total_length: message.total_length,
    discipline: message.discipline,
    edition: message.edition,
    section1: message.section1,
    section8_offset: message.section8_offset,
    sections: message.sections,
    submessages: message.submessages,
    raw: message.raw,
  }
}

///|
fn with_u16_be(bytes : Bytes, offset : Int, value : Int) -> Bytes {
  let copy = bytes.to_array()
  copy[offset] = ((value >> 8) & 0xff).to_byte()
  copy[offset + 1] = (value & 0xff).to_byte()
  Bytes::from_array(copy)
}

///|
fn with_u32_be(bytes : Bytes, offset : Int, value : Int) -> Bytes {
  let copy = bytes.to_array()
  copy[offset] = ((value >> 24) & 0xff).to_byte()
  copy[offset + 1] = ((value >> 16) & 0xff).to_byte()
  copy[offset + 2] = ((value >> 8) & 0xff).to_byte()
  copy[offset + 3] = (value & 0xff).to_byte()
  Bytes::from_array(copy)
}

///|
fn fixture_paths_for_roundtrip() -> Array[String] {
  [
    "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin", "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin",
    "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin",
    "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin",
    "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2", "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2",
    "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2", "fixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2",
  ]
}

///|
fn verify_roundtrip(path : String) -> Result[Unit, String] {
  let original_bytes = match read_fixture_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => return Err(error)
  }
  let parsed = match @lib.parse_grib2_file(original_bytes) {
    Ok(context) => context
    Err(error) =>
      return Err("parse failed for " + path + ": " + error.to_string())
  }
  let raw_bytes = @lib.rebuild_raw(parsed)
  if raw_bytes != original_bytes {
    return Err("raw rebuild mismatch for " + path)
  }
  let strict_bytes = match @lib.rebuild_strict(parsed) {
    Ok(bytes) => bytes
    Err(error) =>
      return Err("strict rebuild failed for " + path + ": " + error.to_string())
  }
  if strict_bytes != original_bytes {
    return Err("strict rebuild mismatch for " + path)
  }
  let reparsed = match @lib.parse_grib2_file(strict_bytes) {
    Ok(context) => context
    Err(error) =>
      return Err("reparse failed for " + path + ": " + error.to_string())
  }
  if reparsed.message_count() != parsed.message_count() {
    return Err("message count mismatch after roundtrip for " + path)
  }
  if reparsed.record_count() != parsed.record_count() {
    return Err("record count mismatch after roundtrip for " + path)
  }
  Ok(())
}
