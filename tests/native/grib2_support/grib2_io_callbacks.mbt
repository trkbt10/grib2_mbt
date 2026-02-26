///|
pub fn grib2_io_read_bytes(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("read failed: " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
pub fn grib2_io_write_bytes(
  path : String,
  bytes : Bytes,
) -> Result[Unit, String] {
  try @fs.write_bytes_to_file(path, bytes) catch {
    error => Err("write failed: " + error.to_string())
  } noraise {
    _ => Ok(())
  }
}
