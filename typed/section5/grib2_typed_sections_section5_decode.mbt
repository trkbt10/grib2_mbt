///|
fn typed_decode_template_50(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate50, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 10, "template 5.0") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=10).to_bytes(),
  })
}

///|
fn typed_read_u32_list(payload : Bytes, start : Int, count : Int) -> Array[Int] {
  let values : Array[Int] = []
  for i in 0..<count {
    values.push(@section1.typed_read_u32_be(payload, start + i * 4))
  }
  values
}

///|
fn typed_decode_template_51(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate51, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 25, "template 5.1") { Ok(_) => (); Err(e) => return Err(e) }

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
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    matrix_bit_maps_present: template_payload[10].to_uint().reinterpret_as_int(),
    number_of_data_values: @section1.typed_read_u32_be(template_payload, 11),
    matrix_rows: @section1.typed_read_u16_be(template_payload, 15),
    matrix_columns: @section1.typed_read_u16_be(template_payload, 17),
    first_dimension_coordinate_definition: template_payload[19].to_uint().reinterpret_as_int(),
    number_of_first_dimension_values: nc1,
    second_dimension_coordinate_definition: template_payload[21].to_uint().reinterpret_as_int(),
    number_of_second_dimension_values: nc2,
    first_dimension_physical_significance: template_payload[23].to_uint().reinterpret_as_int(),
    second_dimension_physical_significance: template_payload[24].to_uint().reinterpret_as_int(),
    first_dimension_values_ieee,
    second_dimension_values_ieee,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_52(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate52, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 36, "template 5.2") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    group_splitting_method: template_payload[10].to_uint().reinterpret_as_int(),
    missing_value_management: template_payload[11].to_uint().reinterpret_as_int(),
    primary_missing_value_substitute: @section1.typed_read_u32_be(template_payload, 12),
    secondary_missing_value_substitute: @section1.typed_read_u32_be(template_payload, 16),
    number_of_groups: @section1.typed_read_u32_be(template_payload, 20),
    reference_group_widths: template_payload[24].to_uint().reinterpret_as_int(),
    bits_used_for_group_widths: template_payload[25].to_uint().reinterpret_as_int(),
    reference_group_lengths: @section1.typed_read_u32_be(template_payload, 26),
    length_increment_group_lengths: template_payload[30].to_uint().reinterpret_as_int(),
    true_length_last_group: @section1.typed_read_u32_be(template_payload, 31),
    bits_used_for_scaled_group_lengths: template_payload[35].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=36).to_bytes(),
  })
}

///|
fn typed_decode_template_53(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate53, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 38, "template 5.3") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    group_splitting_method: template_payload[10].to_uint().reinterpret_as_int(),
    missing_value_management: template_payload[11].to_uint().reinterpret_as_int(),
    primary_missing_value_substitute: @section1.typed_read_u32_be(template_payload, 12),
    secondary_missing_value_substitute: @section1.typed_read_u32_be(template_payload, 16),
    number_of_groups: @section1.typed_read_u32_be(template_payload, 20),
    reference_group_widths: template_payload[24].to_uint().reinterpret_as_int(),
    bits_used_for_group_widths: template_payload[25].to_uint().reinterpret_as_int(),
    reference_group_lengths: @section1.typed_read_u32_be(template_payload, 26),
    length_increment_group_lengths: template_payload[30].to_uint().reinterpret_as_int(),
    true_length_last_group: @section1.typed_read_u32_be(template_payload, 31),
    bits_used_for_scaled_group_lengths: template_payload[35].to_uint().reinterpret_as_int(),
    order_of_spatial_difference: template_payload[36].to_uint().reinterpret_as_int(),
    extra_descriptors_octet_count: template_payload[37].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=38).to_bytes(),
  })
}

///|
fn typed_decode_template_54(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate54, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 1, "template 5.4") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    precision: template_payload[0].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=1).to_bytes(),
  })
}

///|
fn typed_decode_template_540(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate540, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 12, "template 5.40") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    compression_type: template_payload[10].to_uint().reinterpret_as_int(),
    target_compression_ratio: template_payload[11].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=12).to_bytes(),
  })
}

///|
fn typed_decode_template_541(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate541, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 10, "template 5.41") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=10).to_bytes(),
  })
}

///|
fn typed_decode_template_542(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate542, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 14, "template 5.42") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    original_field_value_type: template_payload[9].to_uint().reinterpret_as_int(),
    ccsds_compression_options_mask: template_payload[10].to_uint().reinterpret_as_int(),
    block_size: template_payload[11].to_uint().reinterpret_as_int(),
    reference_sample_interval: @section1.typed_read_u16_be(template_payload, 12),
    reserved_tail: template_payload.sub(start=14).to_bytes(),
  })
}

///|
fn typed_decode_template_550(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate550, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 13, "template 5.50") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    real_part_of_00_coefficient_ieee: @section1.typed_read_u32_be(template_payload, 9),
    reserved_tail: template_payload.sub(start=13).to_bytes(),
  })
}

///|
fn typed_decode_template_551(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate551, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 24, "template 5.51") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    laplacian_scaling_factor: @section1.typed_read_u32_be(template_payload, 9),
    js: @section1.typed_read_u16_be(template_payload, 13),
    ks: @section1.typed_read_u16_be(template_payload, 15),
    ms: @section1.typed_read_u16_be(template_payload, 17),
    ts: @section1.typed_read_u32_be(template_payload, 19),
    unpacked_subset_precision: template_payload[23].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=24).to_bytes(),
  })
}

///|
fn typed_decode_template_553(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate553, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 24, "template 5.53") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    bi_fourier_sub_truncation_type: template_payload[9].to_uint().reinterpret_as_int(),
    packing_mode_for_axes: template_payload[10].to_uint().reinterpret_as_int(),
    laplacian_scaling_factor: @section1.typed_read_u32_be(template_payload, 11),
    ns: @section1.typed_read_u16_be(template_payload, 15),
    ms: @section1.typed_read_u16_be(template_payload, 17),
    s: @section1.typed_read_u32_be(template_payload, 19),
    unpacked_subset_precision: template_payload[23].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=24).to_bytes(),
  })
}

///|
fn typed_decode_template_561(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate561, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 13, "template 5.61") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    reference_value_ieee: @section1.typed_read_u32_be(template_payload, 0),
    binary_scale_factor: @section1.typed_read_u16_be(template_payload, 4),
    decimal_scale_factor: @section1.typed_read_u16_be(template_payload, 6),
    bits_per_value: template_payload[8].to_uint().reinterpret_as_int(),
    pre_processing_parameter_ieee: @section1.typed_read_u32_be(template_payload, 9),
    reserved_tail: template_payload.sub(start=13).to_bytes(),
  })
}

///|
fn typed_read_u16_list(payload : Bytes, start : Int, count : Int) -> Array[Int] {
  let values : Array[Int] = []
  for i in 0..<count {
    values.push(@section1.typed_read_u16_be(payload, start + i * 2))
  }
  values
}

///|
fn typed_decode_template_5200(
  template_payload : Bytes,
) -> Result[Grib2DataRepresentationTemplate5200, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 6, "template 5.200") { Ok(_) => (); Err(e) => return Err(e) }

  let mvl = @section1.typed_read_u16_be(template_payload, 3)
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
    mv: @section1.typed_read_u16_be(template_payload, 1),
    mvl,
    decimal_scale_factor_of_representative_values: template_payload[5].to_uint().reinterpret_as_int(),
    representative_values_by_level: typed_read_u16_list(
      template_payload, 6, mvl,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
