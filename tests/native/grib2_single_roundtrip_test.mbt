///|
test "single file roundtrip: gfswave small" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  match verify_roundtrip(path) {
    Ok(_) => inspect("ok", content="ok")
    Err(error) => fail(error)
  }
}
