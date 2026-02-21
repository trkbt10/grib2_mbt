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
test "editing API supports remove/insert while keeping strict writer valid" {
  let path = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let original_bytes = match read_fixture_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let original = match @lib.parse_grib2_file(original_bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let first_raw = original.messages[0].raw
  let removed = match original.remove_message(0) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(removed.message_count(), content="346")
  inspect(removed.messages[0].offset, content="0")
  let restored = match removed.insert_message_raw(0, first_raw) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(restored.message_count(), content="347")
  inspect(@lib.rebuild_raw(restored) == original_bytes, content="true")
  let strict_bytes = match @lib.rebuild_strict(restored) {
    Ok(bytes) => bytes
    Err(error) => fail(error.to_string())
  }
  inspect(strict_bytes == original_bytes, content="true")
}

///|
test "strict writer detects invariant violations" {
  let context = match
    parse_fixture_for_writer(
      "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2",
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let messages = [..context.messages]
  messages[0] = message_with_offset(messages[0], messages[0].offset + 1)
  let broken : @lib.Grib2FileContext = { messages, }
  let rejected = match @lib.rebuild_strict(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "unknown template id is preserved through parse and rebuild" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let bytes = match read_fixture_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let original = match @lib.parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let section4_template_offset = original.messages[0].submessages[0].section4.start +
    7
  let mutated_bytes = with_u16_be(bytes, section4_template_offset, 999)
  let mutated = match @lib.parse_grib2_file(mutated_bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let records = @lib.decode_records(mutated)
  inspect(records[0].section4_template.id(), content="999")
  inspect(records[0].section4_template.is_known(), content="false")
  inspect(@lib.rebuild_raw(mutated) == mutated_bytes, content="true")
  let strict_bytes = match @lib.rebuild_strict(mutated) {
    Ok(bytes) => bytes
    Err(error) => fail(error.to_string())
  }
  inspect(strict_bytes == mutated_bytes, content="true")
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

///|
test "roundtrip regression suite for all fixtures" {
  for path in fixture_paths_for_roundtrip() {
    match verify_roundtrip(path) {
      Ok(_) => ()
      Err(error) => fail(error)
    }
  }
  inspect("ok", content="ok")
}
