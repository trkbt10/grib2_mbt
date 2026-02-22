///|
fn typed_decode_template_50(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate50, Grib2SectionCodecError] {
  if template_payload.length() < 10 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.0 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=10).to_bytes(),
  })
}

///|
fn typed_read_u32_list(payload : Bytes, start : Int, count : Int) -> Array[Int] {
  let values : Array[Int] = []
  for i in 0..<count {
    values.push(typed_read_u32_be(payload, start + i * 4))
  }
  values
}

///|
fn typed_decode_template_51(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate51, Grib2SectionCodecError] {
  if template_payload.length() < 25 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.1 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nc1 = template_payload[20].to_uint().reinterpret_as_int()
  let nc2 = template_payload[22].to_uint().reinterpret_as_int()
  let required = 25 + (nc1 + nc2) * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.1 coordinate payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let first_dimension_values_ieee = typed_read_u32_list(
    template_payload, 25, nc1,
  )
  let second_dimension_start = 25 + nc1 * 4
  let second_dimension_values_ieee = typed_read_u32_list(
    template_payload, second_dimension_start, nc2,
  )
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    matrix_bit_maps_present: template_payload[10].to_uint().reinterpret_as_int(),
    number_of_data_values: typed_read_u32_be(template_payload, 11),
    matrix_rows: typed_read_u16_be(template_payload, 15),
    matrix_columns: typed_read_u16_be(template_payload, 17),
    first_dimension_coordinate_definition: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    number_of_first_dimension_values: nc1,
    second_dimension_coordinate_definition: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    number_of_second_dimension_values: nc2,
    first_dimension_physical_significance: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    second_dimension_physical_significance: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    first_dimension_values_ieee,
    second_dimension_values_ieee,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_52(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate52, Grib2SectionCodecError] {
  if template_payload.length() < 36 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.2 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    group_splitting_method: template_payload[10].to_uint().reinterpret_as_int(),
    missing_value_management: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    primary_missing_value_substitute: typed_read_u32_be(template_payload, 12),
    secondary_missing_value_substitute: typed_read_u32_be(template_payload, 16),
    number_of_groups: typed_read_u32_be(template_payload, 20),
    reference_group_widths: template_payload[24].to_uint().reinterpret_as_int(),
    bits_used_for_group_widths: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    reference_group_lengths: typed_read_u32_be(template_payload, 26),
    length_increment_group_lengths: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    true_length_last_group: typed_read_u32_be(template_payload, 31),
    bits_used_for_scaled_group_lengths: template_payload[35]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=36).to_bytes(),
  })
}

///|
fn typed_decode_template_53(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate53, Grib2SectionCodecError] {
  if template_payload.length() < 38 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.3 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    group_splitting_method: template_payload[10].to_uint().reinterpret_as_int(),
    missing_value_management: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    primary_missing_value_substitute: typed_read_u32_be(template_payload, 12),
    secondary_missing_value_substitute: typed_read_u32_be(template_payload, 16),
    number_of_groups: typed_read_u32_be(template_payload, 20),
    reference_group_widths: template_payload[24].to_uint().reinterpret_as_int(),
    bits_used_for_group_widths: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    reference_group_lengths: typed_read_u32_be(template_payload, 26),
    length_increment_group_lengths: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    true_length_last_group: typed_read_u32_be(template_payload, 31),
    bits_used_for_scaled_group_lengths: template_payload[35]
    .to_uint()
    .reinterpret_as_int(),
    order_of_spatial_difference: template_payload[36]
    .to_uint()
    .reinterpret_as_int(),
    extra_descriptors_octet_count: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=38).to_bytes(),
  })
}

///|
fn typed_decode_template_54(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate54, Grib2SectionCodecError] {
  if template_payload.length() < 1 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.4 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    precision: template_payload[0].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=1).to_bytes(),
  })
}

///|
fn typed_decode_template_540(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate540, Grib2SectionCodecError] {
  if template_payload.length() < 12 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.40 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    compression_type: template_payload[10].to_uint().reinterpret_as_int(),
    target_compression_ratio: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=12).to_bytes(),
  })
}

///|
fn typed_decode_template_541(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate541, Grib2SectionCodecError] {
  if template_payload.length() < 10 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.41 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=10).to_bytes(),
  })
}

///|
fn typed_decode_template_542(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate542, Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.42 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    ccsds_compression_options_mask: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    block_size: template_payload[11].to_uint().reinterpret_as_int(),
    reference_sample_interval: typed_read_u16_be(template_payload, 12),
    reserved_tail: template_payload.sub(start=14).to_bytes(),
  })
}

///|
fn typed_decode_template_550(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate550, Grib2SectionCodecError] {
  if template_payload.length() < 13 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.50 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    real_part_of_00_coefficient_ieee: typed_read_u32_be(template_payload, 9),
    reserved_tail: template_payload.sub(start=13).to_bytes(),
  })
}

///|
fn typed_decode_template_551(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate551, Grib2SectionCodecError] {
  if template_payload.length() < 24 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.51 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    laplacian_scaling_factor: typed_read_u32_be(template_payload, 9),
    js: typed_read_u16_be(template_payload, 13),
    ks: typed_read_u16_be(template_payload, 15),
    ms: typed_read_u16_be(template_payload, 17),
    ts: typed_read_u32_be(template_payload, 19),
    unpacked_subset_precision: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=24).to_bytes(),
  })
}

///|
fn typed_decode_template_553(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate553, Grib2SectionCodecError] {
  if template_payload.length() < 24 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.53 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    bi_fourier_sub_truncation_type: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    packing_mode_for_axes: template_payload[10].to_uint().reinterpret_as_int(),
    laplacian_scaling_factor: typed_read_u32_be(template_payload, 11),
    ns: typed_read_u16_be(template_payload, 15),
    ms: typed_read_u16_be(template_payload, 17),
    s: typed_read_u32_be(template_payload, 19),
    unpacked_subset_precision: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=24).to_bytes(),
  })
}

///|
fn typed_decode_template_561(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate561, Grib2SectionCodecError] {
  if template_payload.length() < 13 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.61 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    reference_value_ieee: typed_read_u32_be(template_payload, 0),
    binary_scale_factor: typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    pre_processing_parameter_ieee: typed_read_u32_be(template_payload, 9),
    reserved_tail: template_payload.sub(start=13).to_bytes(),
  })
}

///|
fn typed_read_u16_list(payload : Bytes, start : Int, count : Int) -> Array[Int] {
  let values : Array[Int] = []
  for i in 0..<count {
    values.push(typed_read_u16_be(payload, start + i * 2))
  }
  values
}

///|
fn typed_decode_template_5200(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate5200, Grib2SectionCodecError] {
  if template_payload.length() < 6 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.200 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let mvl = typed_read_u16_be(template_payload, 3)
  let required = 6 + mvl * 2
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 5.200 level values too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    bits_per_value: template_payload[0].to_uint().reinterpret_as_int(),
    mv: typed_read_u16_be(template_payload, 1),
    mvl,
    decimal_scale_factor_of_representative_values: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    representative_values_by_level: typed_read_u16_list(
      template_payload, 6, mvl,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
