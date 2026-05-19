///|
fn typed_encode_template_50(
  template : Grib2DataRepresentationTemplate50,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_51(
  template : Grib2DataRepresentationTemplate51,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  out.push(template.matrix_bit_maps_present.to_byte())
  @section1.typed_push_u32_be(out, template.number_of_data_values)
  @section1.typed_push_u16_be(out, template.matrix_rows)
  @section1.typed_push_u16_be(out, template.matrix_columns)
  out.push(template.first_dimension_coordinate_definition.to_byte())
  out.push(template.number_of_first_dimension_values.to_byte())
  out.push(template.second_dimension_coordinate_definition.to_byte())
  out.push(template.number_of_second_dimension_values.to_byte())
  out.push(template.first_dimension_physical_significance.to_byte())
  out.push(template.second_dimension_physical_significance.to_byte())
  @section1.typed_push_u32_list(out, template.first_dimension_values_ieee)
  @section1.typed_push_u32_list(out, template.second_dimension_values_ieee)
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_52(
  template : Grib2DataRepresentationTemplate52,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  out.push(template.group_splitting_method.to_byte())
  out.push(template.missing_value_management.to_byte())
  @section1.typed_push_u32_be(out, template.primary_missing_value_substitute)
  @section1.typed_push_u32_be(out, template.secondary_missing_value_substitute)
  @section1.typed_push_u32_be(out, template.number_of_groups)
  out.push(template.reference_group_widths.to_byte())
  out.push(template.bits_used_for_group_widths.to_byte())
  @section1.typed_push_u32_be(out, template.reference_group_lengths)
  out.push(template.length_increment_group_lengths.to_byte())
  @section1.typed_push_u32_be(out, template.true_length_last_group)
  out.push(template.bits_used_for_scaled_group_lengths.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_53(
  template : Grib2DataRepresentationTemplate53,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  out.push(template.group_splitting_method.to_byte())
  out.push(template.missing_value_management.to_byte())
  @section1.typed_push_u32_be(out, template.primary_missing_value_substitute)
  @section1.typed_push_u32_be(out, template.secondary_missing_value_substitute)
  @section1.typed_push_u32_be(out, template.number_of_groups)
  out.push(template.reference_group_widths.to_byte())
  out.push(template.bits_used_for_group_widths.to_byte())
  @section1.typed_push_u32_be(out, template.reference_group_lengths)
  out.push(template.length_increment_group_lengths.to_byte())
  @section1.typed_push_u32_be(out, template.true_length_last_group)
  out.push(template.bits_used_for_scaled_group_lengths.to_byte())
  out.push(template.order_of_spatial_difference.to_byte())
  out.push(template.extra_descriptors_octet_count.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_54(
  template : Grib2DataRepresentationTemplate54,
) -> Bytes {
  let out : Array[Byte] = [template.precision.to_byte()]
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_540(
  template : Grib2DataRepresentationTemplate540,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  out.push(template.compression_type.to_byte())
  out.push(template.target_compression_ratio.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_541(
  template : Grib2DataRepresentationTemplate541,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_542(
  template : Grib2DataRepresentationTemplate542,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.original_field_value_type.to_byte())
  out.push(template.ccsds_compression_options_mask.to_byte())
  out.push(template.block_size.to_byte())
  @section1.typed_push_u16_be(out, template.reference_sample_interval)
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_550(
  template : Grib2DataRepresentationTemplate550,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  @section1.typed_push_u32_be(out, template.real_part_of_00_coefficient_ieee)
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_551(
  template : Grib2DataRepresentationTemplate551,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  @section1.typed_push_u32_be(out, template.laplacian_scaling_factor)
  @section1.typed_push_u16_be(out, template.js)
  @section1.typed_push_u16_be(out, template.ks)
  @section1.typed_push_u16_be(out, template.ms)
  @section1.typed_push_u32_be(out, template.ts)
  out.push(template.unpacked_subset_precision.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_553(
  template : Grib2DataRepresentationTemplate553,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  out.push(template.bi_fourier_sub_truncation_type.to_byte())
  out.push(template.packing_mode_for_axes.to_byte())
  @section1.typed_push_u32_be(out, template.laplacian_scaling_factor)
  @section1.typed_push_u16_be(out, template.ns)
  @section1.typed_push_u16_be(out, template.ms)
  @section1.typed_push_u32_be(out, template.s)
  out.push(template.unpacked_subset_precision.to_byte())
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_561(
  template : Grib2DataRepresentationTemplate561,
) -> Bytes {
  let out : Array[Byte] = []
  @section1.typed_push_u32_be(out, template.reference_value_ieee)
  @section1.typed_push_u16_be(out, template.binary_scale_factor)
  @section1.typed_push_u16_be(out, template.decimal_scale_factor)
  out.push(template.bits_per_value.to_byte())
  @section1.typed_push_u32_be(out, template.pre_processing_parameter_ieee)
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_5200(
  template : Grib2DataRepresentationTemplate5200,
) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.bits_per_value.to_byte())
  @section1.typed_push_u16_be(out, template.mv)
  @section1.typed_push_u16_be(out, template.mvl)
  out.push(template.decimal_scale_factor_of_representative_values.to_byte())
  @section1.typed_push_u16_list(out, template.representative_values_by_level)
  @section1.typed_push_bytes(out, template.reserved_tail)
  Bytes::from_array(out)
}
