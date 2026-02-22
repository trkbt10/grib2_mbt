///|
test "section5 template50 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 65160,
    template: DataRepresentationTemplate50({
      reference_value_ieee: 1065353216,
      binary_scale_factor: 65534,
      decimal_scale_factor: 2,
      bits_per_value: 16,
      original_field_value_type: 0,
      reserved_tail: b"\xaa\xbb",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="65160")
  match decoded.template {
    DataRepresentationTemplate50(template50) => {
      inspect(template50.reference_value_ieee, content="1065353216")
      inspect(template50.binary_scale_factor, content="65534")
      inspect(template50.decimal_scale_factor, content="2")
      inspect(template50.bits_per_value, content="16")
      inspect(template50.original_field_value_type, content="0")
      inspect(template50.reserved_tail == b"\xaa\xbb", content="true")
    }
    _ => fail("template5.0 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template51 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 12,
    template: DataRepresentationTemplate51({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 1,
      decimal_scale_factor: 65535,
      bits_per_value: 12,
      original_field_value_type: 0,
      matrix_bit_maps_present: 1,
      number_of_data_values: 10,
      matrix_rows: 2,
      matrix_columns: 3,
      first_dimension_coordinate_definition: 0,
      number_of_first_dimension_values: 2,
      second_dimension_coordinate_definition: 1,
      number_of_second_dimension_values: 3,
      first_dimension_physical_significance: 5,
      second_dimension_physical_significance: 6,
      first_dimension_values_ieee: [1065353216, 1073741824],
      second_dimension_values_ieee: [1077936128, 1082130432, 1084227584],
      reserved_tail: b"\xfe",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="12")
  match decoded.template {
    DataRepresentationTemplate51(template51) => {
      inspect(template51.number_of_data_values, content="10")
      inspect(template51.matrix_rows, content="2")
      inspect(template51.matrix_columns, content="3")
      inspect(template51.number_of_first_dimension_values, content="2")
      inspect(template51.number_of_second_dimension_values, content="3")
      inspect(template51.first_dimension_values_ieee.length(), content="2")
      inspect(template51.second_dimension_values_ieee.length(), content="3")
      inspect(template51.second_dimension_values_ieee[2], content="1084227584")
      inspect(template51.reserved_tail == b"\xfe", content="true")
    }
    _ => fail("template5.1 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template52 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 24,
    template: DataRepresentationTemplate52({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 2,
      decimal_scale_factor: 65535,
      bits_per_value: 8,
      original_field_value_type: 0,
      group_splitting_method: 1,
      missing_value_management: 2,
      primary_missing_value_substitute: 123456789,
      secondary_missing_value_substitute: 987654321,
      number_of_groups: 4,
      reference_group_widths: 5,
      bits_used_for_group_widths: 6,
      reference_group_lengths: 7,
      length_increment_group_lengths: 8,
      true_length_last_group: 9,
      bits_used_for_scaled_group_lengths: 10,
      reserved_tail: b"\xab\xcd",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="24")
  match decoded.template {
    DataRepresentationTemplate52(template52) => {
      inspect(template52.group_splitting_method, content="1")
      inspect(template52.missing_value_management, content="2")
      inspect(template52.number_of_groups, content="4")
      inspect(template52.reference_group_lengths, content="7")
      inspect(template52.true_length_last_group, content="9")
      inspect(template52.bits_used_for_scaled_group_lengths, content="10")
      inspect(template52.reserved_tail == b"\xab\xcd", content="true")
    }
    _ => fail("template5.2 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template53 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 30,
    template: DataRepresentationTemplate53({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 3,
      decimal_scale_factor: 65534,
      bits_per_value: 10,
      original_field_value_type: 0,
      group_splitting_method: 1,
      missing_value_management: 1,
      primary_missing_value_substitute: 100,
      secondary_missing_value_substitute: 200,
      number_of_groups: 5,
      reference_group_widths: 4,
      bits_used_for_group_widths: 6,
      reference_group_lengths: 7,
      length_increment_group_lengths: 8,
      true_length_last_group: 9,
      bits_used_for_scaled_group_lengths: 10,
      order_of_spatial_difference: 2,
      extra_descriptors_octet_count: 3,
      reserved_tail: b"\xde\xad",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="30")
  match decoded.template {
    DataRepresentationTemplate53(template53) => {
      inspect(template53.number_of_groups, content="5")
      inspect(template53.reference_group_widths, content="4")
      inspect(template53.bits_used_for_group_widths, content="6")
      inspect(template53.order_of_spatial_difference, content="2")
      inspect(template53.extra_descriptors_octet_count, content="3")
      inspect(template53.reserved_tail == b"\xde\xad", content="true")
    }
    _ => fail("template5.3 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template54 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 11,
    template: DataRepresentationTemplate54({
      precision: 2,
      reserved_tail: b"\xfa",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="11")
  match decoded.template {
    DataRepresentationTemplate54(template54) => {
      inspect(template54.precision, content="2")
      inspect(template54.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template5.4 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template540 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 100,
    template: DataRepresentationTemplate540({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 1,
      decimal_scale_factor: 65535,
      bits_per_value: 12,
      original_field_value_type: 0,
      compression_type: 1,
      target_compression_ratio: 20,
      reserved_tail: b"\xbe\xef",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="100")
  match decoded.template {
    DataRepresentationTemplate540(template540) => {
      inspect(template540.bits_per_value, content="12")
      inspect(template540.compression_type, content="1")
      inspect(template540.target_compression_ratio, content="20")
      inspect(template540.reserved_tail == b"\xbe\xef", content="true")
    }
    _ => fail("template5.40 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template541 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 64,
    template: DataRepresentationTemplate541({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 2,
      decimal_scale_factor: 65535,
      bits_per_value: 16,
      original_field_value_type: 0,
      reserved_tail: b"\x11",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="64")
  match decoded.template {
    DataRepresentationTemplate541(template541) => {
      inspect(template541.bits_per_value, content="16")
      inspect(template541.original_field_value_type, content="0")
      inspect(template541.reserved_tail == b"\x11", content="true")
    }
    _ => fail("template5.41 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template542 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 64,
    template: DataRepresentationTemplate542({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 1,
      decimal_scale_factor: 65535,
      bits_per_value: 12,
      original_field_value_type: 0,
      ccsds_compression_options_mask: 16,
      block_size: 8,
      reference_sample_interval: 32,
      reserved_tail: b"\x22\x33",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="64")
  match decoded.template {
    DataRepresentationTemplate542(template542) => {
      inspect(template542.bits_per_value, content="12")
      inspect(template542.ccsds_compression_options_mask, content="16")
      inspect(template542.block_size, content="8")
      inspect(template542.reference_sample_interval, content="32")
      inspect(template542.reserved_tail == b"\x22\x33", content="true")
    }
    _ => fail("template5.42 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template550 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 256,
    template: DataRepresentationTemplate550({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 2,
      decimal_scale_factor: 65535,
      bits_per_value: 15,
      real_part_of_00_coefficient_ieee: 1065353216,
      reserved_tail: b"\x44\x55",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="256")
  match decoded.template {
    DataRepresentationTemplate550(template550) => {
      inspect(template550.bits_per_value, content="15")
      inspect(
        template550.real_part_of_00_coefficient_ieee,
        content="1065353216",
      )
      inspect(template550.reserved_tail == b"\x44\x55", content="true")
    }
    _ => fail("template5.50 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template551 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 400,
    template: DataRepresentationTemplate551({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 1,
      decimal_scale_factor: 65535,
      bits_per_value: 12,
      laplacian_scaling_factor: 250000,
      js: 60,
      ks: 40,
      ms: 20,
      ts: 12345,
      unpacked_subset_precision: 1,
      reserved_tail: b"\x66",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="400")
  match decoded.template {
    DataRepresentationTemplate551(template551) => {
      inspect(template551.bits_per_value, content="12")
      inspect(template551.laplacian_scaling_factor, content="250000")
      inspect(template551.js, content="60")
      inspect(template551.ks, content="40")
      inspect(template551.ms, content="20")
      inspect(template551.ts, content="12345")
      inspect(template551.unpacked_subset_precision, content="1")
      inspect(template551.reserved_tail == b"\x66", content="true")
    }
    _ => fail("template5.51 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template553 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 500,
    template: DataRepresentationTemplate553({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 2,
      decimal_scale_factor: 65535,
      bits_per_value: 10,
      bi_fourier_sub_truncation_type: 1,
      packing_mode_for_axes: 2,
      laplacian_scaling_factor: 120000,
      ns: 80,
      ms: 40,
      s: 22222,
      unpacked_subset_precision: 1,
      reserved_tail: b"\x77\x88",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="500")
  match decoded.template {
    DataRepresentationTemplate553(template553) => {
      inspect(template553.bits_per_value, content="10")
      inspect(template553.bi_fourier_sub_truncation_type, content="1")
      inspect(template553.packing_mode_for_axes, content="2")
      inspect(template553.laplacian_scaling_factor, content="120000")
      inspect(template553.ns, content="80")
      inspect(template553.ms, content="40")
      inspect(template553.s, content="22222")
      inspect(template553.unpacked_subset_precision, content="1")
      inspect(template553.reserved_tail == b"\x77\x88", content="true")
    }
    _ => fail("template5.53 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template561 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 320,
    template: DataRepresentationTemplate561({
      reference_value_ieee: 1056964608,
      binary_scale_factor: 2,
      decimal_scale_factor: 65535,
      bits_per_value: 11,
      pre_processing_parameter_ieee: 1048576000,
      reserved_tail: b"\x99",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="320")
  match decoded.template {
    DataRepresentationTemplate561(template561) => {
      inspect(template561.bits_per_value, content="11")
      inspect(template561.pre_processing_parameter_ieee, content="1048576000")
      inspect(template561.reserved_tail == b"\x99", content="true")
    }
    _ => fail("template5.61 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 template5200 typed decode and encode roundtrip" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 180,
    template: DataRepresentationTemplate5200({
      bits_per_value: 7,
      mv: 120,
      mvl: 4,
      decimal_scale_factor_of_representative_values: 2,
      representative_values_by_level: [10, 20, 30, 40],
      reserved_tail: b"\xaa",
    }),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="180")
  match decoded.template {
    DataRepresentationTemplate5200(template5200) => {
      inspect(template5200.bits_per_value, content="7")
      inspect(template5200.mv, content="120")
      inspect(template5200.mvl, content="4")
      inspect(
        template5200.decimal_scale_factor_of_representative_values,
        content="2",
      )
      inspect(template5200.representative_values_by_level.length(), content="4")
      inspect(template5200.representative_values_by_level[2], content="30")
      inspect(template5200.reserved_tail == b"\xaa", content="true")
    }
    _ => fail("template5.200 was not decoded")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section5 unknown template preserves raw payload" {
  let section5 : Grib2Section5Decoded = {
    number_of_data_points: 3,
    template: DataRepresentationTemplateUnknown(200, b"\x99\x88\x77\x66"),
  }
  let encoded = encode_section5_bytes(section5)
  let decoded = match decode_section5_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataRepresentationTemplateUnknown(template_number, raw) => {
      inspect(template_number, content="200")
      inspect(raw == b"\x99\x88\x77\x66", content="true")
    }
    _ => fail("unknown template was not preserved")
  }
  let reencoded = encode_section5_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
