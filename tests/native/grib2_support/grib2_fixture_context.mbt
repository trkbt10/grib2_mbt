///|
pub fn grib2_fixture_bytes_read(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("failed to read fixture " + path + ": " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
pub fn grib2_fixture_context_parse(
  path : String,
) -> Result[@lib.Grib2FileContext, String] {
  let bytes = match grib2_fixture_bytes_read(path) {
    Ok(bytes) => bytes
    Err(error) => return Err(error)
  }
  match @lib.parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(error) =>
      Err("failed to parse fixture " + path + ": " + error.to_string())
  }
}
