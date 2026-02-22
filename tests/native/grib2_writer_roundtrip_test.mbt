///|
// NOTE:
// This suite is intentionally slow and is treated as final verification.
// During normal development, run grib2_writer_fast_test.mbt first.
test "roundtrip regression suite for all fixtures" {
  for path in fixture_paths_for_roundtrip() {
    match verify_roundtrip(path) {
      Ok(_) => ()
      Err(error) => fail(error)
    }
  }
  inspect("ok", content="ok")
}
