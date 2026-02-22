///|
test "section4 template40 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 2,
    template: ProductTemplate40(sample_template40_base()),
    coordinate_values_raw: b"\x3f\x80\x00\x00\x40\x00\x00\x00",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_coordinate_values, content="2")
  inspect(
    decoded.coordinate_values_raw == b"\x3f\x80\x00\x00\x40\x00\x00\x00",
    content="true",
  )
  match decoded.template {
    ProductTemplate40(template40) => {
      inspect(template40.parameter_number, content="0")
      inspect(template40.forecast_time, content="6")
      inspect(template40.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.0 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41(template41) => {
      inspect(template41.type_of_ensemble_forecast, content="2")
      inspect(template41.perturbation_number, content="3")
      inspect(template41.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.1 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template42 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate42({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate42(template42) => {
      inspect(template42.derived_forecast, content="5")
      inspect(template42.number_of_forecasts_in_ensemble, content="50")
    }
    _ => fail("template4.2 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template43 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate43({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      northern_latitude_of_cluster_domain: 50000000,
      southern_latitude_of_cluster_domain: 30000000,
      eastern_longitude_of_cluster_domain: 140000000,
      western_longitude_of_cluster_domain: 120000000,
      number_of_forecasts_in_cluster: 3,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 1234,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 5678,
      ensemble_forecast_numbers: [1, 2, 3],
      reserved_tail: b"\xaa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate43(template43) => {
      inspect(template43.number_of_forecasts_in_cluster, content="3")
      inspect(template43.ensemble_forecast_numbers.length(), content="3")
      inspect(template43.reserved_tail == b"\xaa", content="true")
    }
    _ => fail("template4.3 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template44 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate44({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      latitude_of_central_point: 40000000,
      longitude_of_central_point: 130000000,
      radius_of_cluster_domain: 1000000,
      number_of_forecasts_in_cluster: 2,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 4321,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 8765,
      ensemble_forecast_numbers: [4, 5],
      reserved_tail: b"\xbb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate44(template44) => {
      inspect(template44.number_of_forecasts_in_cluster, content="2")
      inspect(template44.ensemble_forecast_numbers.length(), content="2")
      inspect(template44.reserved_tail == b"\xbb", content="true")
    }
    _ => fail("template4.4 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template45 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate45({
      base: sample_template40_base(),
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reserved_tail: b"\xcc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate45(template45) => {
      inspect(template45.forecast_probability_number, content="2")
      inspect(template45.scaled_value_of_upper_limit, content="200")
      inspect(template45.reserved_tail == b"\xcc", content="true")
    }
    _ => fail("template4.5 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template46 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate46({
      base: sample_template40_base(),
      percentile_value: 90,
      reserved_tail: b"\xee",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate46(template46) => {
      inspect(template46.percentile_value, content="90")
      inspect(template46.reserved_tail == b"\xee", content="true")
    }
    _ => fail("template4.6 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template47 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate47({
      base: sample_template40_base(),
      reserved_tail: b"\xef",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate47(template47) => {
      inspect(template47.base.forecast_time, content="6")
      inspect(template47.reserved_tail == b"\xef", content="true")
    }
    _ => fail("template4.7 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template48 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate48({
      base: sample_template40_base(),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 0,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate48(template48) => {
      inspect(template48.end_year, content="2026")
      inspect(template48.number_of_time_ranges, content="2")
      inspect(template48.time_range_specs.length(), content="2")
      inspect(template48.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template4.8 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template49 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate49({
      base: {
        base: sample_template40_base(),
        forecast_probability_number: 2,
        total_number_of_forecast_probabilities: 10,
        probability_type: 1,
        scale_factor_of_lower_limit: 0,
        scaled_value_of_lower_limit: 100,
        scale_factor_of_upper_limit: 0,
        scaled_value_of_upper_limit: 200,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate49(template49) => {
      inspect(template49.base.probability_type, content="1")
      inspect(template49.end_year, content="2026")
      inspect(template49.number_of_time_ranges, content="2")
      inspect(template49.time_range_specs.length(), content="2")
      inspect(template49.reserved_tail == b"\xfb", content="true")
    }
    _ => fail("template4.9 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template410 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate410({
      base: {
        base: sample_template40_base(),
        percentile_value: 90,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 0,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate410(template410) => {
      inspect(template410.base.percentile_value, content="90")
      inspect(template410.number_of_time_ranges, content="2")
      inspect(template410.time_range_specs.length(), content="2")
      inspect(template410.reserved_tail == b"\xfc", content="true")
    }
    _ => fail("template4.10 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template411 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate411({
      base: {
        base: sample_template40_base(),
        type_of_ensemble_forecast: 2,
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate411(template411) => {
      inspect(template411.base.type_of_ensemble_forecast, content="2")
      inspect(template411.number_of_time_ranges, content="2")
      inspect(template411.time_range_specs.length(), content="2")
      inspect(template411.reserved_tail == b"\xfd", content="true")
    }
    _ => fail("template4.11 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template412 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate412({
      base: {
        base: sample_template40_base(),
        derived_forecast: 5,
        number_of_forecasts_in_ensemble: 50,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfe",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate412(template412) => {
      inspect(template412.base.derived_forecast, content="5")
      inspect(template412.number_of_time_ranges, content="2")
      inspect(template412.time_range_specs.length(), content="2")
      inspect(template412.reserved_tail == b"\xfe", content="true")
    }
    _ => fail("template4.12 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template413 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate413({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      northern_latitude_of_cluster_domain: 50000000,
      southern_latitude_of_cluster_domain: 30000000,
      eastern_longitude_of_cluster_domain: 140000000,
      western_longitude_of_cluster_domain: 120000000,
      number_of_forecasts_in_cluster: 3,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 1234,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 5678,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      ensemble_forecast_numbers: [1, 2, 3],
      reserved_tail: b"\xde",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate413(template413) => {
      inspect(template413.number_of_forecasts_in_cluster, content="3")
      inspect(template413.number_of_time_ranges, content="2")
      inspect(template413.time_range_specs.length(), content="2")
      inspect(template413.ensemble_forecast_numbers.length(), content="3")
      inspect(template413.reserved_tail == b"\xde", content="true")
    }
    _ => fail("template4.13 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template414 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate414({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      latitude_of_central_point: 40000000,
      longitude_of_central_point: 130000000,
      radius_of_cluster_domain: 1000000,
      number_of_forecasts_in_cluster: 3,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 1234,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 5678,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      ensemble_forecast_numbers: [1, 2, 3],
      reserved_tail: b"\xdf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate414(template414) => {
      inspect(template414.radius_of_cluster_domain, content="1000000")
      inspect(template414.number_of_time_ranges, content="2")
      inspect(template414.time_range_specs.length(), content="2")
      inspect(template414.ensemble_forecast_numbers.length(), content="3")
      inspect(template414.reserved_tail == b"\xdf", content="true")
    }
    _ => fail("template4.14 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template415 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate415({
      base: sample_template40_base(),
      statistical_process_within_spatial_area: 1,
      type_of_spatial_processing: 2,
      number_of_data_points_used: 9,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate415(template415) => {
      inspect(template415.statistical_process_within_spatial_area, content="1")
      inspect(template415.type_of_spatial_processing, content="2")
      inspect(template415.number_of_data_points_used, content="9")
    }
    _ => fail("template4.15 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template420 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate420({
      parameter_category: 15,
      parameter_number: 2,
      type_of_generating_process: 4,
      number_of_radar_sites_used: 1,
      indicator_of_unit_time_range: 1,
      site_latitude: 35000000,
      site_longitude: 139000000,
      site_elevation: 50,
      site_identifier_alphanumeric: 0x4b544c58,
      site_identifier_numeric: 12,
      operating_mode: 1,
      reflectivity_calibration_constant: 25,
      quality_control_indicator: 1,
      clutter_filter_indicator: 2,
      constant_antenna_elevation_angle: 5,
      accumulation_interval: 10,
      reference_reflectivity: 20,
      range_bin_spacing: 1000,
      radial_angular_spacing: 10,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate420(template420) => {
      inspect(template420.number_of_radar_sites_used, content="1")
      inspect(template420.site_latitude, content="35000000")
      inspect(template420.site_identifier_alphanumeric, content="1263815768")
      inspect(template420.range_bin_spacing, content="1000")
    }
    _ => fail("template4.20 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
