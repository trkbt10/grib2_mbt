///|
test "section2 mdl template21 typed decode and encode roundtrip" {
  let section2 : Grib2Section2Decoded = {
    template: MdlTemplate21({
      total_number_of_data_groups: 3,
      number_of_values_in_first_group: 42,
      reference_value_of_first_group_ieee: 1065353216,
      decimal_scale_factor: 2,
      bits_per_value: 8,
      first_group_data_type: 1,
      first_group_packed_values_raw: b"\x11\x22\x33\x44",
    }),
  }
  let encoded = encode_section2_bytes(section2)
  let decoded = match decode_section2_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    MdlTemplate21(template21) => {
      inspect(template21.total_number_of_data_groups, content="3")
      inspect(template21.number_of_values_in_first_group, content="42")
      inspect(
        template21.reference_value_of_first_group_ieee,
        content="1065353216",
      )
      inspect(template21.decimal_scale_factor, content="2")
      inspect(template21.bits_per_value, content="8")
      inspect(template21.first_group_data_type, content="1")
      inspect(
        template21.first_group_packed_values_raw == b"\x11\x22\x33\x44",
        content="true",
      )
    }
    _ => fail("template2.1 was not decoded")
  }
  let reencoded = encode_section2_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section2 unknown template preserves raw payload" {
  let section2 : Grib2Section2Decoded = {
    template: LocalUseTemplateUnknown(99, b"\xaa\xbb\xcc"),
  }
  let encoded = encode_section2_bytes(section2)
  let decoded = match decode_section2_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    LocalUseTemplateUnknown(template_number, raw) => {
      inspect(template_number, content="99")
      inspect(raw == b"\xaa\xbb\xcc", content="true")
    }
    _ => fail("unknown template was not preserved")
  }
  let reencoded = encode_section2_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
