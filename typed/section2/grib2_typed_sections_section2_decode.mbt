///|
fn typed_decode_template_21(
  payload : Bytes,
) -> Result[Grib2MdlTemplate21, Grib2SectionCodecError] {
  if payload.length() < 14 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 2.1 too short: " + payload.length().to_string(),
      ),
    )
  }
  Ok({
    total_number_of_data_groups: typed_read_u16_be(payload, 0),
    number_of_values_in_first_group: typed_read_u32_be(payload, 2),
    reference_value_of_first_group_ieee: typed_read_u32_be(payload, 6),
    decimal_scale_factor: typed_read_u16_be(payload, 10),
    bits_per_value: payload[12].to_uint().reinterpret_as_int(),
    first_group_data_type: payload[13].to_uint().reinterpret_as_int(),
    first_group_packed_values_raw: payload.sub(start=14).to_bytes(),
  })
}
