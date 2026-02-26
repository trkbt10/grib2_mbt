///|
pub fn grib2_verify_roundtrip_strict(path : String) -> Result[Unit, String] {
  let original_bytes = match grib2_fixture_bytes_read(path) {
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
