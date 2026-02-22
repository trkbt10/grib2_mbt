///|
test "section4 template449 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate449({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_interval_for_first_and_second_wavelength: 2,
      scale_factor_of_first_wavelength: 0,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 0,
      scaled_value_of_second_wavelength: 700,
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate449(template449) => {
      inspect(template449.aerosol_type, content="62000")
      inspect(
        template449.type_of_interval_for_first_and_second_wavelength,
        content="2",
      )
      inspect(template449.scaled_value_of_first_wavelength, content="550")
      inspect(template449.scaled_value_of_second_wavelength, content="700")
      inspect(template449.forecast_time, content="6")
      inspect(template449.type_of_ensemble_forecast, content="2")
      inspect(template449.perturbation_number, content="3")
      inspect(template449.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.49 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template450 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate450({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate450(template450) => {
      inspect(template450.aerosol_type, content="62000")
      inspect(
        template450.type_of_interval_for_first_and_second_size,
        content="2",
      )
      inspect(template450.scaled_value_of_first_size, content="1000")
      inspect(template450.scaled_value_of_second_size, content="2000")
      inspect(template450.forecast_time, content="6")
      inspect(template450.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.50 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template451 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate451({
      base: {
        parameter_category: 3,
        parameter_number: 5,
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
      number_of_categories: 2,
      categories: [
        {
          code_figure: 1,
          type_of_interval_for_first_and_second_limit: 2,
          scale_factor_of_first_limit: 0,
          scaled_value_of_first_limit: 100,
          scale_factor_of_second_limit: 0,
          scaled_value_of_second_limit: 200,
        },
        {
          code_figure: 2,
          type_of_interval_for_first_and_second_limit: 3,
          scale_factor_of_first_limit: 1,
          scaled_value_of_first_limit: 300,
          scale_factor_of_second_limit: 1,
          scaled_value_of_second_limit: 400,
        },
      ],
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
    ProductTemplate451(template451) => {
      inspect(template451.base.parameter_category, content="3")
      inspect(template451.number_of_categories, content="2")
      inspect(template451.categories.length(), content="2")
      inspect(template451.categories[0].code_figure, content="1")
      inspect(
        template451.categories[1].type_of_interval_for_first_and_second_limit,
        content="3",
      )
      inspect(template451.reserved_tail == b"\xaa", content="true")
    }
    _ => fail("template4.51 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template453 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate453({
      parameter_category: 3,
      parameter_number: 5,
      partition_table_number: 1,
      number_of_partitions: 3,
      partition_set: [10, 20, 30],
      partition_number: 20,
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
      reserved_tail: b"\xab",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate453(template453) => {
      inspect(template453.partition_table_number, content="1")
      inspect(template453.number_of_partitions, content="3")
      inspect(template453.partition_set.length(), content="3")
      inspect(template453.partition_set[1], content="20")
      inspect(template453.partition_number, content="20")
      inspect(template453.forecast_time, content="6")
      inspect(template453.reserved_tail == b"\xab", content="true")
    }
    _ => fail("template4.53 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template454 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate454({
      parameter_category: 3,
      parameter_number: 5,
      partition_table_number: 1,
      number_of_partitions: 3,
      partition_set: [10, 20, 30],
      partition_number: 20,
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
      reserved_tail: b"\xac",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate454(template454) => {
      inspect(template454.partition_table_number, content="1")
      inspect(template454.number_of_partitions, content="3")
      inspect(template454.partition_set.length(), content="3")
      inspect(template454.partition_number, content="20")
      inspect(template454.type_of_ensemble_forecast, content="2")
      inspect(template454.perturbation_number, content="3")
      inspect(template454.number_of_forecasts_in_ensemble, content="20")
      inspect(template454.reserved_tail == b"\xac", content="true")
    }
    _ => fail("template4.54 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template455 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate455({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
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
    ProductTemplate455(template455) => {
      inspect(template455.tile_classification, content="1")
      inspect(template455.total_number_of_tile_attribute_pairs, content="5")
      inspect(template455.number_of_used_spatial_tiles, content="3")
      inspect(template455.tile_index, content="2")
      inspect(template455.number_of_used_tile_attributes, content="2")
      inspect(template455.tile_attribute, content="4")
      inspect(template455.forecast_time, content="6")
    }
    _ => fail("template4.55 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template456 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate456({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
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
    ProductTemplate456(template456) => {
      inspect(template456.tile_classification, content="1")
      inspect(template456.total_number_of_tile_attribute_pairs, content="5")
      inspect(template456.number_of_used_spatial_tiles, content="3")
      inspect(template456.tile_index, content="2")
      inspect(template456.number_of_used_tile_attributes, content="2")
      inspect(template456.tile_attribute, content="4")
      inspect(template456.perturbation_number, content="3")
      inspect(template456.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.56 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template457 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate457({
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
      reserved_tail: b"\xae",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate457(template457) => {
      inspect(
        template457.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template457.number_of_mode_of_distribution, content="2")
      inspect(template457.mode_number, content="1")
      inspect(template457.type_of_distribution_function, content="3")
      inspect(template457.number_of_following_function_parameters, content="2")
      inspect(template457.function_parameters.length(), content="2")
      inspect(
        template457.function_parameters[1].scaled_value_of_fixed_distribution_function_parameter,
        content="456",
      )
      inspect(template457.reserved_tail == b"\xae", content="true")
    }
    _ => fail("template4.57 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template458 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate458({
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
      reserved_tail: b"\xaf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate458(template458) => {
      inspect(
        template458.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template458.number_of_mode_of_distribution, content="2")
      inspect(template458.mode_number, content="1")
      inspect(template458.type_of_distribution_function, content="3")
      inspect(template458.number_of_following_function_parameters, content="2")
      inspect(template458.function_parameters.length(), content="2")
      inspect(template458.type_of_ensemble_forecast, content="2")
      inspect(template458.perturbation_number, content="3")
      inspect(template458.number_of_forecasts_in_ensemble, content="20")
      inspect(template458.reserved_tail == b"\xaf", content="true")
    }
    _ => fail("template4.58 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template459 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate459({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
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
    ProductTemplate459(template459) => {
      inspect(template459.tile_classification, content="1")
      inspect(template459.total_number_of_tile_attribute_pairs, content="5")
      inspect(template459.number_of_used_spatial_tiles, content="3")
      inspect(template459.tile_index, content="2")
      inspect(template459.number_of_used_tile_attributes, content="2")
      inspect(template459.tile_attribute, content="4")
      inspect(template459.type_of_ensemble_forecast, content="2")
      inspect(template459.perturbation_number, content="3")
      inspect(template459.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.59 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template460 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate460({
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
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      year_of_model_version_date: 2024,
      month_of_model_version_date: 5,
      day_of_model_version_date: 1,
      hour_of_model_version_date: 12,
      minute_of_model_version_date: 30,
      second_of_model_version_date: 45,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate460(template460) => {
      inspect(template460.type_of_ensemble_forecast, content="2")
      inspect(template460.perturbation_number, content="3")
      inspect(template460.number_of_forecasts_in_ensemble, content="20")
      inspect(template460.year_of_model_version_date, content="2024")
      inspect(template460.month_of_model_version_date, content="5")
      inspect(template460.day_of_model_version_date, content="1")
      inspect(template460.hour_of_model_version_date, content="12")
      inspect(template460.minute_of_model_version_date, content="30")
      inspect(template460.second_of_model_version_date, content="45")
    }
    _ => fail("template4.60 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template461 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate461({
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
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      year_of_model_version_date: 2024,
      month_of_model_version_date: 5,
      day_of_model_version_date: 1,
      hour_of_model_version_date: 12,
      minute_of_model_version_date: 30,
      second_of_model_version_date: 45,
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
      reserved_tail: b"\xb0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate461(template461) => {
      inspect(template461.type_of_ensemble_forecast, content="2")
      inspect(template461.perturbation_number, content="3")
      inspect(template461.number_of_forecasts_in_ensemble, content="20")
      inspect(template461.year_of_model_version_date, content="2024")
      inspect(template461.end_year, content="2024")
      inspect(template461.number_of_time_ranges, content="2")
      inspect(template461.time_range_specs.length(), content="2")
      inspect(template461.number_of_missing_values, content="1")
      inspect(template461.reserved_tail == b"\xb0", content="true")
    }
    _ => fail("template4.61 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template462 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate462({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
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
      reserved_tail: b"\xb1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate462(template462) => {
      inspect(template462.tile_classification, content="1")
      inspect(template462.end_year, content="2024")
      inspect(template462.number_of_time_ranges, content="2")
      inspect(template462.time_range_specs.length(), content="2")
      inspect(template462.number_of_missing_values, content="1")
      inspect(template462.reserved_tail == b"\xb1", content="true")
    }
    _ => fail("template4.62 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template463 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate463({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
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
      reserved_tail: b"\xb2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate463(template463) => {
      inspect(template463.tile_classification, content="1")
      inspect(template463.type_of_ensemble_forecast, content="2")
      inspect(template463.perturbation_number, content="3")
      inspect(template463.number_of_forecasts_in_ensemble, content="20")
      inspect(template463.end_year, content="2024")
      inspect(template463.number_of_time_ranges, content="2")
      inspect(template463.time_range_specs.length(), content="2")
      inspect(template463.number_of_missing_values, content="1")
      inspect(template463.reserved_tail == b"\xb2", content="true")
    }
    _ => fail("template4.63 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
