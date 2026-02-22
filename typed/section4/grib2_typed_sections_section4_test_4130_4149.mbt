///|
test "section4 template4130 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4130({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 20,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4130(template4130) => {
      inspect(template4130.base.forecast_time, content="6")
      inspect(template4130.derived_forecast, content="4")
      inspect(template4130.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4130.reference_period.type_of_relation_to_reference_dataset,
        content="2",
      )
      inspect(template4130.reserved_tail == b"\xe3", content="true")
    }
    _ => fail("template4.130 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4131 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4131({
      base: sample_template40_base(),
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4131(template4131) => {
      inspect(template4131.base.forecast_time, content="6")
      inspect(template4131.forecast_probability_number, content="2")
      inspect(template4131.total_number_of_forecast_probabilities, content="10")
      inspect(template4131.scaled_value_of_upper_limit, content="200")
      inspect(
        template4131.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(template4131.reserved_tail == b"\xe4", content="true")
    }
    _ => fail("template4.131 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4132 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4132({
      base: sample_template40_base(),
      total_number_of_quantiles: 1000,
      quantile_value: 250,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4132(template4132) => {
      inspect(template4132.base.forecast_time, content="6")
      inspect(template4132.total_number_of_quantiles, content="1000")
      inspect(template4132.quantile_value, content="250")
      inspect(
        template4132.reference_period.number_of_reference_period_time_ranges,
        content="1",
      )
      inspect(template4132.reserved_tail == b"\xe5", content="true")
    }
    _ => fail("template4.132 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4133 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4133({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        input_process_identifier: 321,
        input_originating_centre: 34,
        type_of_post_processing: 2,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
        total_number_of_quantiles: 1000,
        quantile_value: 250,
      },
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4133(template4133) => {
      inspect(template4133.base.input_process_identifier, content="321")
      inspect(template4133.base.type_of_post_processing, content="2")
      inspect(template4133.base.total_number_of_quantiles, content="1000")
      inspect(template4133.base.quantile_value, content="250")
      inspect(template4133.reference_period.start_year, content="1991")
      inspect(template4133.reserved_tail == b"\xe6", content="true")
    }
    _ => fail("template4.133 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4134 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4134({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
          total_number_of_quantiles: 1000,
          quantile_value: 250,
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
        reserved_tail: b"",
      },
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4134(template4134) => {
      inspect(template4134.base.base.total_number_of_quantiles, content="1000")
      inspect(template4134.base.number_of_time_ranges, content="2")
      inspect(template4134.base.time_range_specs.length(), content="2")
      inspect(template4134.reference_period.sample_size, content="30")
      inspect(template4134.reserved_tail == b"\xe7", content="true")
    }
    _ => fail("template4.134 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4135 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4135({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        input_process_identifier: 321,
        input_originating_centre: 34,
        type_of_post_processing: 2,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
        total_number_of_quantiles: 1000,
        quantile_value: 250,
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 6,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4135(template4135) => {
      inspect(template4135.base.input_process_identifier, content="321")
      inspect(template4135.base.type_of_post_processing, content="2")
      inspect(template4135.base.number_of_time_ranges, content="2")
      inspect(template4135.base.time_range_specs.length(), content="2")
      inspect(template4135.reference_period.start_year, content="1991")
      inspect(template4135.reserved_tail == b"\xe8", content="true")
    }
    _ => fail("template4.135 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4136 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4136({
      base: {
        base: sample_template40_base(),
        type_of_ensemble_forecast: 2,
        number_of_forecasts_in_ensemble: 987654,
        forecast_probability_number: 2,
        total_number_of_forecast_probabilities: 10,
        probability_type: 1,
        scale_factor_of_lower_limit: 0,
        scaled_value_of_lower_limit: 100,
        scale_factor_of_upper_limit: 0,
        scaled_value_of_upper_limit: 200,
        reserved_tail: b"",
      },
      reference_period: sample_reference_period_definition(),
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xe9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4136(template4136) => {
      inspect(
        template4136.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(template4136.base.forecast_probability_number, content="2")
      inspect(
        template4136.reference_period.number_of_reference_period_time_ranges,
        content="1",
      )
      inspect(
        template4136.spatial_vicinity.number_of_spatial_vicinity_values,
        content="2",
      )
      inspect(template4136.reserved_tail == b"\xe9", content="true")
    }
    _ => fail("template4.136 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4137 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4137({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 987654,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      reserved_tail: b"\xea",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4137(template4137) => {
      inspect(template4137.base.forecast_time, content="6")
      inspect(template4137.derived_forecast, content="4")
      inspect(template4137.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4137.year_of_model_version_date, content="2026")
      inspect(template4137.second_of_model_version_date, content="10")
      inspect(template4137.reserved_tail == b"\xea", content="true")
    }
    _ => fail("template4.137 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4138 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4138({
      base: {
        base: sample_template40_base(),
        derived_forecast: 4,
        number_of_forecasts_in_ensemble: 987654,
        year_of_model_version_date: 2026,
        month_of_model_version_date: 2,
        day_of_model_version_date: 21,
        hour_of_model_version_date: 6,
        minute_of_model_version_date: 0,
        second_of_model_version_date: 10,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xeb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4138(template4138) => {
      inspect(template4138.base.derived_forecast, content="4")
      inspect(
        template4138.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(template4138.end_year, content="2026")
      inspect(template4138.number_of_time_ranges, content="2")
      inspect(template4138.time_range_specs.length(), content="2")
      inspect(template4138.reserved_tail == b"\xeb", content="true")
    }
    _ => fail("template4.138 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4139 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4139({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      reserved_tail: b"\xec",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4139(template4139) => {
      inspect(template4139.base.type_of_wave_period_interval, content="2")
      inspect(
        template4139.base.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4139.year_of_model_version_date, content="2026")
      inspect(template4139.second_of_model_version_date, content="10")
      inspect(template4139.reserved_tail == b"\xec", content="true")
    }
    _ => fail("template4.139 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4140 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4140({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      reserved_tail: b"\xed",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4140(template4140) => {
      inspect(template4140.base.type_of_wave_period_interval, content="2")
      inspect(template4140.type_of_ensemble_forecast, content="2")
      inspect(template4140.perturbation_number, content="123456")
      inspect(template4140.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4140.year_of_model_version_date, content="2026")
      inspect(template4140.reserved_tail == b"\xed", content="true")
    }
    _ => fail("template4.140 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4141 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4141({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
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
    ProductTemplate4141(template4141) => {
      inspect(template4141.number_of_wave_directions, content="3")
      inspect(template4141.scaled_wave_directions.length(), content="3")
      inspect(template4141.scaled_wave_directions[1], content="900")
      inspect(template4141.number_of_wave_frequencies, content="2")
      inspect(template4141.scaled_wave_frequencies[1], content="250")
      inspect(template4141.year_of_model_version_date, content="2026")
      inspect(template4141.second_of_model_version_date, content="10")
      inspect(template4141.reserved_tail == b"\xee", content="true")
    }
    _ => fail("template4.141 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4142 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4142({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
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
    ProductTemplate4142(template4142) => {
      inspect(template4142.type_of_ensemble_forecast, content="2")
      inspect(template4142.perturbation_number, content="123456")
      inspect(template4142.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4142.number_of_wave_directions, content="3")
      inspect(template4142.scaled_wave_directions.length(), content="3")
      inspect(template4142.scaled_wave_frequencies.length(), content="2")
      inspect(template4142.year_of_model_version_date, content="2026")
      inspect(template4142.reserved_tail == b"\xef", content="true")
    }
    _ => fail("template4.142 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4143 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4143({
      parameter_category: 10,
      parameter_number: 20,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      random_field_number: 7,
      total_number_of_random_fields: 20,
      spatio_temporal_scale_number: 3,
      total_number_of_spatio_temporal_scales: 8,
      scaled_value_of_spatial_scale: 1000,
      scale_factor_of_spatial_scale: 1,
      scaled_value_of_temporal_scale: 3600,
      scale_factor_of_temporal_scale: 0,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      reserved_tail: b"\xf0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4143(template4143) => {
      inspect(template4143.random_field_number, content="7")
      inspect(template4143.total_number_of_random_fields, content="20")
      inspect(template4143.spatio_temporal_scale_number, content="3")
      inspect(template4143.scaled_value_of_spatial_scale, content="1000")
      inspect(template4143.scaled_value_of_temporal_scale, content="3600")
      inspect(template4143.perturbation_number, content="123456")
      inspect(template4143.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4143.reserved_tail == b"\xf0", content="true")
    }
    _ => fail("template4.143 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4144 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4144({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xf1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4144(template4144) => {
      inspect(template4144.base.type_of_wave_period_interval, content="2")
      inspect(
        template4144.base.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4144.end_year, content="2026")
      inspect(template4144.number_of_time_ranges, content="2")
      inspect(template4144.time_range_specs.length(), content="2")
      inspect(template4144.reserved_tail == b"\xf1", content="true")
    }
    _ => fail("template4.144 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4145 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4145({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xf2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4145(template4145) => {
      inspect(template4145.base.type_of_wave_period_interval, content="2")
      inspect(template4145.type_of_ensemble_forecast, content="2")
      inspect(template4145.perturbation_number, content="123456")
      inspect(template4145.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4145.end_year, content="2026")
      inspect(template4145.time_range_specs.length(), content="2")
      inspect(template4145.reserved_tail == b"\xf2", content="true")
    }
    _ => fail("template4.145 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4146 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4146({
      base: sample_template40_base(),
      verification_score: 120,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4146(template4146) => {
      inspect(template4146.base.forecast_time, content="6")
      inspect(template4146.verification_score, content="120")
      inspect(
        template4146.verification.number_of_additional_arguments,
        content="2",
      )
      inspect(
        template4146.verification.additional_arguments.length(),
        content="2",
      )
      inspect(
        template4146.verification.number_of_verification_period_time_ranges,
        content="2",
      )
      inspect(
        template4146.verification.verification_period_time_range_specs.length(),
        content="2",
      )
      inspect(
        template4146.verification.number_of_forecasts_in_verification,
        content="77",
      )
      inspect(template4146.reserved_tail == b"\xf3", content="true")
    }
    _ => fail("template4.146 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4147 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4147({
      base: {
        base: sample_template40_base(),
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 12,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      verification_score: 121,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4147(template4147) => {
      inspect(template4147.base.number_of_time_ranges, content="2")
      inspect(template4147.base.time_range_specs.length(), content="2")
      inspect(template4147.verification_score, content="121")
      inspect(template4147.verification.start_year, content="2020")
      inspect(
        template4147.verification.additional_arguments[1].scaled_value,
        content="20",
      )
      inspect(
        template4147.verification.verification_period_time_range_specs[1].time_increment_length,
        content="6",
      )
      inspect(template4147.reserved_tail == b"\xf4", content="true")
    }
    _ => fail("template4.147 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4148 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4148({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      verification_score: 122,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4148(template4148) => {
      inspect(template4148.type_of_ensemble_forecast, content="2")
      inspect(template4148.perturbation_number, content="123456")
      inspect(template4148.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4148.verification_score, content="122")
      inspect(template4148.verification.start_year, content="2020")
      inspect(
        template4148.verification.number_of_forecasts_in_verification,
        content="77",
      )
      inspect(template4148.reserved_tail == b"\xf5", content="true")
    }
    _ => fail("template4.148 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4149 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4149({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      verification_score: 123,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4149(template4149) => {
      inspect(template4149.type_of_ensemble_forecast, content="2")
      inspect(template4149.perturbation_number, content="123456")
      inspect(template4149.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4149.end_year, content="2026")
      inspect(template4149.number_of_time_ranges, content="2")
      inspect(template4149.time_range_specs.length(), content="2")
      inspect(template4149.verification_score, content="123")
      inspect(
        template4149.verification.number_of_verification_period_time_ranges,
        content="2",
      )
      inspect(template4149.reserved_tail == b"\xf6", content="true")
    }
    _ => fail("template4.149 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
