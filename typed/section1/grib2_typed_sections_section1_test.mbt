///|
test "section1 typed decode and encode roundtrip" {
  let section1 : Grib2Section1Decoded = {
    center: 34,
    subcenter: 0,
    master_table_version: 2,
    local_table_version: 1,
    significance_of_reference_time: 1,
    reference_year: 2026,
    reference_month: 2,
    reference_day: 21,
    reference_hour: 0,
    reference_minute: 0,
    reference_second: 30,
    production_status: 0,
    processed_data_type: 1,
    identification_template: IdTemplate12(24, 2),
    reserved_octets_22_23: b"\x00\x01",
    reserved_tail: b"\xaa\xbb",
  }
  let encoded = encode_section1_bytes(section1)
  inspect(encoded.length(), content="28")
  let decoded = match decode_section1_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.reference_year, content="2026")
  inspect(decoded.reference_second, content="30")
  inspect(decoded.reserved_octets_22_23 == b"\x00\x01", content="true")
  inspect(decoded.reserved_tail == b"\xaa\xbb", content="true")
  let reencoded = encode_section1_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section1 no identification template keeps reserved octets" {
  let section1 : Grib2Section1Decoded = {
    center: 7,
    subcenter: 0,
    master_table_version: 2,
    local_table_version: 1,
    significance_of_reference_time: 1,
    reference_year: 2026,
    reference_month: 2,
    reference_day: 21,
    reference_hour: 0,
    reference_minute: 0,
    reference_second: 0,
    production_status: 0,
    processed_data_type: 1,
    identification_template: IdTemplateNone,
    reserved_octets_22_23: b"\xfe\xfd",
    reserved_tail: b"",
  }
  let encoded = encode_section1_bytes(section1)
  inspect(encoded.length(), content="23")
  let decoded = match decode_section1_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.identification_template.to_string(), content="IdTemplateNone")
  inspect(decoded.reserved_octets_22_23 == b"\xfe\xfd", content="true")
  let reencoded = encode_section1_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
