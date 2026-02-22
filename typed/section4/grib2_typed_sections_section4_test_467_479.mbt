///|
test "section4 template467 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate467({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      number_of_mode_of_distribution: 2,
      mode_number: 1,
      type_of_distribution_function: 3,
      number_of_following_function_parameters: 2,
      function_parameters: [
        {
          scale_factor_of_fixed_distribution_function_parameter: 0,
          scaled_value_of_fixed_distribution_function_parameter: 123,
        },
        {
          scale_factor_of_fixed_distribution_function_parameter: 1,
          scaled_value_of_fixed_distribution_function_parameter: 456,
        },
      ],
      type_of_generating_process: 2,
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
      reserved_tail: b"\xb3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate467(template467) => {
      inspect(
        template467.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template467.number_of_following_function_parameters, content="2")
      inspect(template467.function_parameters.length(), content="2")
      inspect(template467.end_year, content="2024")
      inspect(template467.number_of_time_ranges, content="2")
      inspect(template467.time_range_specs.length(), content="2")
      inspect(template467.number_of_missing_values, content="1")
      inspect(template467.reserved_tail == b"\xb3", content="true")
    }
    _ => fail("template4.67 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template468 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate468({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      number_of_mode_of_distribution: 2,
      mode_number: 1,
      type_of_distribution_function: 3,
      number_of_following_function_parameters: 2,
      function_parameters: [
        {
          scale_factor_of_fixed_distribution_function_parameter: 0,
          scaled_value_of_fixed_distribution_function_parameter: 123,
        },
        {
          scale_factor_of_fixed_distribution_function_parameter: 1,
          scaled_value_of_fixed_distribution_function_parameter: 456,
        },
      ],
      type_of_generating_process: 2,
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
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
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
      reserved_tail: b"\xb4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate468(template468) => {
      inspect(
        template468.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template468.number_of_following_function_parameters, content="2")
      inspect(template468.function_parameters.length(), content="2")
      inspect(template468.type_of_ensemble_forecast, content="2")
      inspect(template468.perturbation_number, content="3")
      inspect(template468.number_of_forecasts_in_ensemble, content="20")
      inspect(template468.end_year, content="2024")
      inspect(template468.number_of_time_ranges, content="2")
      inspect(template468.time_range_specs.length(), content="2")
      inspect(template468.number_of_missing_values, content="1")
      inspect(template468.reserved_tail == b"\xb4", content="true")
    }
    _ => fail("template4.68 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template470 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate470({
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate470(template470) => {
      inspect(template470.input_process_identifier, content="321")
      inspect(template470.input_originating_centre, content="34")
      inspect(template470.type_of_post_processing, content="2")
      inspect(template470.forecast_time, content="6")
      inspect(template470.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.70 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template471 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate471({
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
    ProductTemplate471(template471) => {
      inspect(template471.input_process_identifier, content="321")
      inspect(template471.input_originating_centre, content="34")
      inspect(template471.type_of_post_processing, content="2")
      inspect(template471.type_of_ensemble_forecast, content="2")
      inspect(template471.perturbation_number, content="3")
      inspect(template471.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.71 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template472 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate472({
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
      reserved_tail: b"\xb5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate472(template472) => {
      inspect(template472.input_process_identifier, content="321")
      inspect(template472.input_originating_centre, content="34")
      inspect(template472.type_of_post_processing, content="2")
      inspect(template472.end_year, content="2024")
      inspect(template472.number_of_time_ranges, content="2")
      inspect(template472.time_range_specs.length(), content="2")
      inspect(template472.number_of_missing_values, content="1")
      inspect(template472.reserved_tail == b"\xb5", content="true")
    }
    _ => fail("template4.72 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template473 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate473({
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
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
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
      reserved_tail: b"\xb6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate473(template473) => {
      inspect(template473.input_process_identifier, content="321")
      inspect(template473.input_originating_centre, content="34")
      inspect(template473.type_of_post_processing, content="2")
      inspect(template473.type_of_ensemble_forecast, content="2")
      inspect(template473.perturbation_number, content="3")
      inspect(template473.number_of_forecasts_in_ensemble, content="20")
      inspect(template473.end_year, content="2024")
      inspect(template473.number_of_time_ranges, content="2")
      inspect(template473.time_range_specs.length(), content="2")
      inspect(template473.number_of_missing_values, content="1")
      inspect(template473.reserved_tail == b"\xb6", content="true")
    }
    _ => fail("template4.73 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template476 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate476({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      source_or_sink: 2,
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate476(template476) => {
      inspect(
        template476.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template476.source_or_sink, content="2")
      inspect(template476.forecast_time, content="6")
    }
    _ => fail("template4.76 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template477 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate477({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
        source_or_sink: 2,
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
    ProductTemplate477(template477) => {
      inspect(template477.base.source_or_sink, content="2")
      inspect(template477.type_of_ensemble_forecast, content="2")
      inspect(template477.perturbation_number, content="3")
      inspect(template477.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.77 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template478 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate478({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
        source_or_sink: 2,
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
      reserved_tail: b"\xb7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate478(template478) => {
      inspect(template478.base.source_or_sink, content="2")
      inspect(template478.end_year, content="2024")
      inspect(template478.number_of_time_ranges, content="2")
      inspect(template478.time_range_specs.length(), content="2")
      inspect(template478.number_of_missing_values, content="1")
      inspect(template478.reserved_tail == b"\xb7", content="true")
    }
    _ => fail("template4.78 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template479 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate479({
      base: {
        base: {
          parameter_category: 20,
          parameter_number: 1,
          atmospheric_chemical_constituent_type: 40001,
          source_or_sink: 2,
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
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
      },
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
      reserved_tail: b"\xb8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate479(template479) => {
      inspect(template479.base.base.source_or_sink, content="2")
      inspect(template479.base.type_of_ensemble_forecast, content="2")
      inspect(template479.base.perturbation_number, content="3")
      inspect(template479.base.number_of_forecasts_in_ensemble, content="20")
      inspect(template479.end_year, content="2024")
      inspect(template479.number_of_time_ranges, content="2")
      inspect(template479.time_range_specs.length(), content="2")
      inspect(template479.number_of_missing_values, content="1")
      inspect(template479.reserved_tail == b"\xb8", content="true")
    }
    _ => fail("template4.79 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
