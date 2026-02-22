///|
test "section4 template490 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate490({
      parameter_category: 0,
      parameter_number: 1,
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
      total_number_of_quantiles: 100,
      quantile_value: 95,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xbf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate490(template490) => {
      inspect(template490.input_process_identifier, content="321")
      inspect(template490.input_originating_centre, content="34")
      inspect(template490.total_number_of_quantiles, content="100")
      inspect(template490.quantile_value, content="95")
      inspect(template490.end_year, content="2024")
      inspect(template490.number_of_time_ranges, content="2")
      inspect(template490.time_range_specs.length(), content="2")
      inspect(template490.number_of_missing_values, content="1")
      inspect(template490.reserved_tail == b"\xbf", content="true")
    }
    _ => fail("template4.90 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template491 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate491({
      parameter_category: 0,
      parameter_number: 1,
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
      number_of_categories: 2,
      categories: [
        {
          code_figure: 1,
          type_of_interval_for_first_and_second_limit: 1,
          scale_factor_of_first_limit: 0,
          scaled_value_of_first_limit: 10,
          scale_factor_of_second_limit: 0,
          scaled_value_of_second_limit: 20,
        },
        {
          code_figure: 2,
          type_of_interval_for_first_and_second_limit: 2,
          scale_factor_of_first_limit: 0,
          scaled_value_of_first_limit: 30,
          scale_factor_of_second_limit: 0,
          scaled_value_of_second_limit: 40,
        },
      ],
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate491(template491) => {
      inspect(template491.number_of_categories, content="2")
      inspect(template491.categories.length(), content="2")
      inspect(template491.categories[0].code_figure, content="1")
      inspect(
        template491.categories[1].scaled_value_of_second_limit,
        content="40",
      )
      inspect(template491.end_year, content="2024")
      inspect(template491.number_of_time_ranges, content="2")
      inspect(template491.time_range_specs.length(), content="2")
      inspect(template491.number_of_missing_values, content="1")
      inspect(template491.reserved_tail == b"\xc0", content="true")
    }
    _ => fail("template4.91 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template492 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate492({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate492(template492) => {
      inspect(template492.type_of_ensemble_forecast, content="2")
      inspect(template492.perturbation_number, content="3")
      inspect(template492.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template492.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template492.number_of_forecasts_used, content="2")
      inspect(template492.forecast_specs.length(), content="2")
      inspect(template492.forecast_specs[1].forecast_time, content="12")
      inspect(template492.reserved_tail == b"\xc1", content="true")
    }
    _ => fail("template4.92 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template493 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate493({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate493(template493) => {
      inspect(template493.input_process_identifier, content="321")
      inspect(template493.input_originating_centre, content="34")
      inspect(template493.type_of_post_processing, content="2")
      inspect(
        template493.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template493.number_of_forecasts_used, content="2")
      inspect(template493.forecast_specs.length(), content="2")
      inspect(template493.forecast_specs[1].forecast_time, content="12")
      inspect(template493.reserved_tail == b"\xc2", content="true")
    }
    _ => fail("template4.93 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template494 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate494({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate494(template494) => {
      inspect(template494.input_process_identifier, content="321")
      inspect(template494.input_originating_centre, content="34")
      inspect(template494.type_of_post_processing, content="2")
      inspect(template494.type_of_ensemble_forecast, content="2")
      inspect(template494.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template494.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template494.number_of_forecasts_used, content="2")
      inspect(template494.forecast_specs.length(), content="2")
      inspect(template494.forecast_specs[1].forecast_time, content="12")
      inspect(template494.reserved_tail == b"\xc3", content="true")
    }
    _ => fail("template4.94 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template495 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate495({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate495(template495) => {
      inspect(
        template495.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(template495.statistical_processing_time_range_unit, content="1")
      inspect(
        template495.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template495.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template495.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template495.number_of_forecasts_used, content="2")
      inspect(template495.forecast_specs.length(), content="2")
      inspect(template495.forecast_specs[1].forecast_time, content="12")
      inspect(template495.reserved_tail == b"\xc4", content="true")
    }
    _ => fail("template4.95 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template496 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate496({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate496(template496) => {
      inspect(template496.type_of_ensemble_forecast, content="2")
      inspect(template496.perturbation_number, content="3")
      inspect(template496.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template496.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(
        template496.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template496.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template496.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template496.number_of_forecasts_used, content="2")
      inspect(template496.forecast_specs.length(), content="2")
      inspect(template496.forecast_specs[1].forecast_time, content="12")
      inspect(template496.reserved_tail == b"\xc5", content="true")
    }
    _ => fail("template4.96 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template497 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate497({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate497(template497) => {
      inspect(template497.input_process_identifier, content="321")
      inspect(template497.input_originating_centre, content="34")
      inspect(template497.type_of_post_processing, content="2")
      inspect(
        template497.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(
        template497.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template497.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template497.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template497.number_of_forecasts_used, content="2")
      inspect(template497.forecast_specs.length(), content="2")
      inspect(template497.forecast_specs[1].forecast_time, content="12")
      inspect(template497.reserved_tail == b"\xc6", content="true")
    }
    _ => fail("template4.97 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template498 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate498({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate498(template498) => {
      inspect(template498.input_process_identifier, content="321")
      inspect(template498.input_originating_centre, content="34")
      inspect(template498.type_of_post_processing, content="2")
      inspect(template498.type_of_ensemble_forecast, content="2")
      inspect(template498.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template498.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(
        template498.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template498.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template498.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template498.number_of_forecasts_used, content="2")
      inspect(template498.forecast_specs.length(), content="2")
      inspect(template498.forecast_specs[1].forecast_time, content="12")
      inspect(template498.reserved_tail == b"\xc7", content="true")
    }
    _ => fail("template4.98 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template499 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate499({
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
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
      reserved_tail: b"\xc8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate499(template499) => {
      inspect(template499.wave_direction_number, content="2")
      inspect(template499.number_of_wave_directions, content="3")
      inspect(template499.wave_frequency_number, content="4")
      inspect(template499.number_of_wave_frequencies, content="2")
      inspect(template499.scaled_wave_directions.length(), content="3")
      inspect(template499.scaled_wave_directions[1], content="900")
      inspect(template499.scale_factor_of_wave_frequencies, content="3")
      inspect(template499.scaled_wave_frequencies.length(), content="2")
      inspect(template499.scaled_wave_frequencies[1], content="250")
      inspect(template499.reserved_tail == b"\xc8", content="true")
    }
    _ => fail("template4.99 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
