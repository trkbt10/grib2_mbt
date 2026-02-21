///|
fn parse_fixture_for_decode(
  path : String,
) -> Result[@lib.Grib2FileContext, String] {
  let bytes = try @fs.read_file_to_bytes(path) catch {
    error =>
      return Err("failed to read fixture " + path + ": " + error.to_string())
  } noraise {
    bytes => bytes
  }
  match @lib.parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(error) =>
      Err("failed to parse fixture " + path + ": " + error.to_string())
  }
}

///|
test "decode records exposes context fields" {
  let context = match
    parse_fixture_for_decode(
      "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2",
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="19")
  inspect(records[0].record_id, content="1")
  inspect(records[0].reference_time, content="2026022100")
  inspect(records[0].parameter_name.display(), content="WIND")
  inspect(records[0].level_name.display(), content="surface")
}

///|
test "template dispatch foundation: fixture templates" {
  let context = parse_fixture_for_decode(
    "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2",
  )
  let records = match context {
    Ok(context) => @lib.decode_records(context)
    Err(error) => fail(error)
  }
  inspect(records[0].section3_template.id(), content="0")
  inspect(records[0].section4_template.id(), content="0")
  inspect(records[0].section5_template.id(), content="3")
  inspect(records[0].section3_template.is_known(), content="true")
  inspect(records[0].section4_template.is_known(), content="true")
  inspect(records[0].section5_template.is_known(), content="true")
}

///|
test "table lookup foundation: parameter and level known-unknown split" {
  inspect(@lib.decode_parameter_name(0, 2, 2).display(), content="UGRD")
  inspect(
    @lib.decode_parameter_name(0, 99, 99).display(),
    content="disc=0,cat=99,param=99",
  )
  inspect(
    @lib.decode_level_name(100, 0, 500, 255, 0, 0).display(),
    content="5 mb",
  )
  inspect(
    @lib.decode_level_name(250, 0, 0, 251, 0, 0).display(),
    content="type250-type251",
  )
}
