///|
pub fn import_probe() -> Int {
  let _ = @core.parse_grib2_file(b"")
  if @fs.path_exists("fixtures") {
    1
  } else {
    0
  }
}
