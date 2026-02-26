///|
pub fn grib2_verify_fixture_raw_roundtrip(
  path : String,
  expected_message_count : Int,
  expected_record_count : Int,
) -> Result[Unit, String] {
  let bytes = match grib2_fixture_bytes_read(path) {
    Ok(bytes) => bytes
    Err(error) => return Err(error)
  }
  let context = match grib2_fixture_context_parse(path) {
    Ok(context) => context
    Err(error) => return Err(error)
  }
  if context.message_count() != expected_message_count {
    return Err(
      "message count mismatch for " +
      path +
      ": actual=" +
      context.message_count().to_string() +
      ", expected=" +
      expected_message_count.to_string(),
    )
  }
  if context.record_count() != expected_record_count {
    return Err(
      "record count mismatch for " +
      path +
      ": actual=" +
      context.record_count().to_string() +
      ", expected=" +
      expected_record_count.to_string(),
    )
  }
  if @lib.rebuild_raw(context) != bytes {
    return Err("raw rebuild mismatch for " + path)
  }
  Ok(())
}
