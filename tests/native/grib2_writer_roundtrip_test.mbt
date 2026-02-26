///|
// NOTE:
// This suite is intentionally slow and is treated as final verification.
// During normal development, run grib2_writer_fast_test.mbt first.
test "roundtrip regression suite for all fixtures" {
  for path in @grib2support.grib2_fixture_paths_for_roundtrip() {
    match @grib2support.grib2_verify_roundtrip_strict(path) {
      Ok(_) => ()
      Err(error) => fail(error)
    }
  }
  inspect("ok", content="ok")
}
