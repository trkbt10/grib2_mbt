///|
fn typed_decode_time_range_spec(
  template_payload : BytesView,
  offset : Int,
) -> Grib2TimeRangeSpec {
  {
    statistical_process: @section1.typed_read_u8_view(template_payload, offset),
    type_of_time_increment: @section1.typed_read_u8_view(template_payload, offset + 1),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 2),
    time_range_length: @section1.typed_read_u32_be_view(template_payload, offset + 3),
    time_increment_unit: @section1.typed_read_u8_view(template_payload, offset + 7),
    time_increment_length: @section1.typed_read_u32_be_view(template_payload, offset + 8),
  }
}

///|
fn typed_push_time_range_spec(
  out : Array[Byte],
  time_range_spec : Grib2TimeRangeSpec,
) -> Unit {
  out.push(time_range_spec.statistical_process.to_byte())
  out.push(time_range_spec.type_of_time_increment.to_byte())
  out.push(time_range_spec.time_range_unit.to_byte())
  @section1.typed_push_u32_be(out, time_range_spec.time_range_length)
  out.push(time_range_spec.time_increment_unit.to_byte())
  @section1.typed_push_u32_be(out, time_range_spec.time_increment_length)
}
