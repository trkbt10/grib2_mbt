///|
fn typed_encode_template_21(template : Grib2MdlTemplate21) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u16_be(out, template.total_number_of_data_groups)
  @section1.typed_push_u32_be(out, template.number_of_values_in_first_group)
  @section1.typed_push_u32_be(out, template.reference_value_of_first_group_ieee)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.first_group_data_type.to_byte())
  @section1.typed_push_bytes(out, template.first_group_packed_values_raw)
  Bytes::from_array(out)
}
