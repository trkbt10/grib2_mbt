///|
test "section4 template4100 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4100({
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
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
      reserved_tail: b"\xc9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4100(template4100) => {
      inspect(template4100.type_of_ensemble_forecast, content="2")
      inspect(template4100.perturbation_number, content="3")
      inspect(template4100.number_of_forecasts_in_ensemble, content="20")
      inspect(template4100.number_of_wave_directions, content="3")
      inspect(template4100.scaled_wave_directions.length(), content="3")
      inspect(template4100.scaled_wave_directions[1], content="900")
      inspect(template4100.scale_factor_of_wave_frequencies, content="3")
      inspect(template4100.scaled_wave_frequencies.length(), content="2")
      inspect(template4100.scaled_wave_frequencies[1], content="250")
      inspect(template4100.reserved_tail == b"\xc9", content="true")
    }
    _ => fail("template4.100 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4101 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4101({
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
      type_of_wave_direction_sequence: 1,
      number_of_wave_direction_sequence_parameters: 2,
      wave_direction_sequence_parameters: [
        { scale_factor: 0, scaled_value: 10 },
        { scale_factor: 1, scaled_value: 20 },
      ],
      type_of_wave_frequency_sequence: 2,
      number_of_wave_frequency_sequence_parameters: 2,
      wave_frequency_sequence_parameters: [
        { scale_factor: 0, scaled_value: 30 },
        { scale_factor: 1, scaled_value: 40 },
      ],
      reserved_tail: b"\xca",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4101(template4101) => {
      inspect(template4101.type_of_wave_direction_sequence, content="1")
      inspect(
        template4101.number_of_wave_direction_sequence_parameters,
        content="2",
      )
      inspect(
        template4101.wave_direction_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4101.wave_direction_sequence_parameters[1].scaled_value,
        content="20",
      )
      inspect(template4101.type_of_wave_frequency_sequence, content="2")
      inspect(
        template4101.number_of_wave_frequency_sequence_parameters,
        content="2",
      )
      inspect(
        template4101.wave_frequency_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4101.wave_frequency_sequence_parameters[1].scaled_value,
        content="40",
      )
      inspect(template4101.reserved_tail == b"\xca", content="true")
    }
    _ => fail("template4.101 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4102 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4102({
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
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      type_of_wave_direction_sequence: 1,
      number_of_wave_direction_sequence_parameters: 2,
      wave_direction_sequence_parameters: [
        { scale_factor: 0, scaled_value: 10 },
        { scale_factor: 1, scaled_value: 20 },
      ],
      type_of_wave_frequency_sequence: 2,
      number_of_wave_frequency_sequence_parameters: 2,
      wave_frequency_sequence_parameters: [
        { scale_factor: 0, scaled_value: 30 },
        { scale_factor: 1, scaled_value: 40 },
      ],
      reserved_tail: b"\xcb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4102(template4102) => {
      inspect(template4102.type_of_ensemble_forecast, content="2")
      inspect(template4102.perturbation_number, content="3")
      inspect(template4102.number_of_forecasts_in_ensemble, content="20")
      inspect(template4102.type_of_wave_direction_sequence, content="1")
      inspect(
        template4102.number_of_wave_direction_sequence_parameters,
        content="2",
      )
      inspect(
        template4102.wave_direction_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4102.wave_direction_sequence_parameters[1].scaled_value,
        content="20",
      )
      inspect(template4102.type_of_wave_frequency_sequence, content="2")
      inspect(
        template4102.number_of_wave_frequency_sequence_parameters,
        content="2",
      )
      inspect(
        template4102.wave_frequency_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4102.wave_frequency_sequence_parameters[1].scaled_value,
        content="40",
      )
      inspect(template4102.reserved_tail == b"\xcb", content="true")
    }
    _ => fail("template4.102 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4103 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4103({
      parameter_category: 10,
      parameter_number: 20,
      type_of_wave_period_interval: 2,
      scale_factor_of_lower_wave_period_limit: 0,
      scaled_value_of_lower_wave_period_limit: 5,
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4103(template4103) => {
      inspect(template4103.type_of_wave_period_interval, content="2")
      inspect(template4103.scaled_value_of_lower_wave_period_limit, content="5")
      inspect(
        template4103.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4103.forecast_time, content="6")
      inspect(template4103.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.103 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4104 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4104({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 5,
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
    ProductTemplate4104(template4104) => {
      inspect(template4104.base.type_of_wave_period_interval, content="2")
      inspect(
        template4104.base.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4104.type_of_ensemble_forecast, content="2")
      inspect(template4104.perturbation_number, content="3")
      inspect(template4104.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.104 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4105 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4105({
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
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
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
    ProductTemplate4105(template4105) => {
      inspect(template4105.base.number_of_time_ranges, content="1")
      inspect(template4105.base.time_range_specs.length(), content="1")
      inspect(
        template4105.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4105.reference_period.number_of_additional_parameters,
        content="1",
      )
      inspect(
        template4105.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4105.reference_period.additional_parameters[0].scaled_value,
        content="12",
      )
      inspect(template4105.reference_period.start_year, content="1991")
      inspect(
        template4105.reference_period.number_of_reference_period_time_ranges,
        content="1",
      )
      inspect(
        template4105.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4105.reserved_tail == b"\xcc", content="true")
    }
    _ => fail("template4.105 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4106 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4106({
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
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xcd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4106(template4106) => {
      inspect(template4106.type_of_ensemble_forecast, content="2")
      inspect(template4106.perturbation_number, content="3")
      inspect(template4106.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4106.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4106.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4106.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4106.reserved_tail == b"\xcd", content="true")
    }
    _ => fail("template4.106 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4107 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4107({
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
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 20,
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xce",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4107(template4107) => {
      inspect(template4107.derived_forecast, content="4")
      inspect(template4107.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4107.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4107.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4107.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4107.reserved_tail == b"\xce", content="true")
    }
    _ => fail("template4.107 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4108 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4108({
      parameter_category: 10,
      parameter_number: 20,
      type_of_interval_for_wavelength: 2,
      scale_factor_of_first_wavelength: 0,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 0,
      scaled_value_of_second_wavelength: 700,
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
    ProductTemplate4108(template4108) => {
      inspect(template4108.type_of_interval_for_wavelength, content="2")
      inspect(template4108.scaled_value_of_first_wavelength, content="550")
      inspect(template4108.scaled_value_of_second_wavelength, content="700")
      inspect(template4108.forecast_time, content="6")
      inspect(template4108.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.108 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4109 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4109({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_interval_for_wavelength: 2,
        scale_factor_of_first_wavelength: 0,
        scaled_value_of_first_wavelength: 550,
        scale_factor_of_second_wavelength: 0,
        scaled_value_of_second_wavelength: 700,
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
    ProductTemplate4109(template4109) => {
      inspect(template4109.base.type_of_interval_for_wavelength, content="2")
      inspect(template4109.base.scaled_value_of_first_wavelength, content="550")
      inspect(
        template4109.base.scaled_value_of_second_wavelength,
        content="700",
      )
      inspect(template4109.type_of_ensemble_forecast, content="2")
      inspect(template4109.perturbation_number, content="3")
      inspect(template4109.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.109 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4110 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4110({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_interval_for_wavelength: 2,
        scale_factor_of_first_wavelength: 0,
        scaled_value_of_first_wavelength: 550,
        scale_factor_of_second_wavelength: 0,
        scaled_value_of_second_wavelength: 700,
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
      number_of_time_ranges: 1,
      number_of_missing_values: 0,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
      ],
      reserved_tail: b"\xcf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4110(template4110) => {
      inspect(template4110.base.type_of_interval_for_wavelength, content="2")
      inspect(template4110.base.scaled_value_of_first_wavelength, content="550")
      inspect(
        template4110.base.scaled_value_of_second_wavelength,
        content="700",
      )
      inspect(template4110.number_of_time_ranges, content="1")
      inspect(template4110.time_range_specs.length(), content="1")
      inspect(template4110.time_range_specs[0].time_range_length, content="6")
      inspect(template4110.reserved_tail == b"\xcf", content="true")
    }
    _ => fail("template4.110 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4111 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4111({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_interval_for_wavelength: 2,
          scale_factor_of_first_wavelength: 0,
          scaled_value_of_first_wavelength: 550,
          scale_factor_of_second_wavelength: 0,
          scaled_value_of_second_wavelength: 700,
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
      number_of_time_ranges: 1,
      number_of_missing_values: 0,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
      ],
      reserved_tail: b"\xd0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4111(template4111) => {
      inspect(
        template4111.base.base.type_of_interval_for_wavelength,
        content="2",
      )
      inspect(
        template4111.base.base.scaled_value_of_first_wavelength,
        content="550",
      )
      inspect(template4111.base.type_of_ensemble_forecast, content="2")
      inspect(template4111.base.perturbation_number, content="3")
      inspect(template4111.base.number_of_forecasts_in_ensemble, content="20")
      inspect(template4111.number_of_time_ranges, content="1")
      inspect(template4111.time_range_specs.length(), content="1")
      inspect(template4111.time_range_specs[0].time_range_length, content="6")
      inspect(template4111.reserved_tail == b"\xd0", content="true")
    }
    _ => fail("template4.111 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4112 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4112({
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
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xd1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4112(template4112) => {
      inspect(template4112.base.number_of_time_ranges, content="1")
      inspect(template4112.base.time_range_specs.length(), content="1")
      inspect(template4112.forecast_probability_number, content="2")
      inspect(template4112.total_number_of_forecast_probabilities, content="10")
      inspect(template4112.probability_type, content="1")
      inspect(template4112.scaled_value_of_lower_limit, content="100")
      inspect(template4112.scaled_value_of_upper_limit, content="200")
      inspect(
        template4112.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4112.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4112.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4112.reserved_tail == b"\xd1", content="true")
    }
    _ => fail("template4.112 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4113 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4113({
      base: sample_template40_base(),
      tile: sample_generalized_tile_definition(),
      reserved_tail: b"\xd2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4113(template4113) => {
      inspect(template4113.tile.type_of_tile, content="258")
      inspect(template4113.tile.number_of_used_tile_attributes, content="2")
      inspect(template4113.tile.tile_attributes.length(), content="2")
      inspect(template4113.tile.uuid_of_data_group.length(), content="16")
      inspect(template4113.reserved_tail == b"\xd2", content="true")
    }
    _ => fail("template4.113 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4114 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4114({
      base: {
        base: sample_template40_base(),
        tile: sample_generalized_tile_definition(),
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
      reserved_tail: b"\xd3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4114(template4114) => {
      inspect(
        template4114.base.tile.number_of_used_tile_attributes,
        content="2",
      )
      inspect(template4114.number_of_time_ranges, content="2")
      inspect(template4114.time_range_specs.length(), content="2")
      inspect(template4114.reserved_tail == b"\xd3", content="true")
    }
    _ => fail("template4.114 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4115 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4115({
      base: {
        base: sample_template40_base(),
        tile: sample_generalized_tile_definition(),
        reserved_tail: b"",
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      reserved_tail: b"\xd4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4115(template4115) => {
      inspect(template4115.type_of_ensemble_forecast, content="2")
      inspect(template4115.perturbation_number, content="123456")
      inspect(template4115.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4115.reserved_tail == b"\xd4", content="true")
    }
    _ => fail("template4.115 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4116 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4116({
      base: {
        base: {
          base: sample_template40_base(),
          tile: sample_generalized_tile_definition(),
          reserved_tail: b"",
        },
        type_of_ensemble_forecast: 2,
        perturbation_number: 123456,
        number_of_forecasts_in_ensemble: 987654,
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
      reserved_tail: b"\xd5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4116(template4116) => {
      inspect(template4116.base.base.tile.tile_index, content="7")
      inspect(template4116.base.perturbation_number, content="123456")
      inspect(template4116.number_of_time_ranges, content="2")
      inspect(template4116.time_range_specs.length(), content="2")
      inspect(template4116.reserved_tail == b"\xd5", content="true")
    }
    _ => fail("template4.116 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4117 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4117({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      reserved_tail: b"\xd6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4117(template4117) => {
      inspect(template4117.type_of_ensemble_forecast, content="2")
      inspect(template4117.perturbation_number, content="123456")
      inspect(template4117.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4117.reserved_tail == b"\xd6", content="true")
    }
    _ => fail("template4.117 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4118 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4118({
      base: sample_template4117_base(),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xd7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4118(template4118) => {
      inspect(template4118.base.perturbation_number, content="123456")
      inspect(template4118.number_of_time_ranges, content="2")
      inspect(template4118.time_range_specs.length(), content="2")
      inspect(template4118.reserved_tail == b"\xd7", content="true")
    }
    _ => fail("template4.118 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4119 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4119({
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
      reserved_tail: b"\xd8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4119(template4119) => {
      inspect(template4119.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4119.forecast_probability_number, content="2")
      inspect(template4119.probability_type, content="1")
      inspect(template4119.scaled_value_of_upper_limit, content="200")
      inspect(template4119.reserved_tail == b"\xd8", content="true")
    }
    _ => fail("template4.119 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4120 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4120({
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
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xd9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4120(template4120) => {
      inspect(
        template4120.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(template4120.base.forecast_probability_number, content="2")
      inspect(template4120.number_of_time_ranges, content="2")
      inspect(template4120.time_range_specs.length(), content="2")
      inspect(template4120.reserved_tail == b"\xd9", content="true")
    }
    _ => fail("template4.120 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4121 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4121({
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
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xda",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4121(template4121) => {
      inspect(
        template4121.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(
        template4121.spatial_vicinity.number_of_spatial_vicinity_values,
        content="2",
      )
      inspect(
        template4121.spatial_vicinity.spatial_vicinity_values.length(),
        content="2",
      )
      inspect(
        template4121.spatial_vicinity.temporal_vicinity_towards_future,
        content="9",
      )
      inspect(template4121.reserved_tail == b"\xda", content="true")
    }
    _ => fail("template4.121 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4122 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4122({
      base: {
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
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xdb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4122(template4122) => {
      inspect(template4122.base.number_of_time_ranges, content="2")
      inspect(template4122.base.time_range_specs.length(), content="2")
      inspect(
        template4122.spatial_vicinity.spatial_vicinity_processing_argument2,
        content="20",
      )
      inspect(template4122.reserved_tail == b"\xdb", content="true")
    }
    _ => fail("template4.122 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4123 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4123({
      base: {
        base: sample_template40_base(),
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
      type_of_ensemble_forecast: 2,
      number_of_forecasts_in_ensemble: 987654,
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reference_period: sample_reference_period_definition(),
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xdc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4123(template4123) => {
      inspect(template4123.base.number_of_time_ranges, content="2")
      inspect(template4123.number_of_forecasts_in_ensemble, content="987654")
      inspect(
        template4123.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4123.spatial_vicinity.temporal_vicinity_towards_past,
        content="6",
      )
      inspect(template4123.reserved_tail == b"\xdc", content="true")
    }
    _ => fail("template4.123 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4124 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4124(sample_template4124(b"\xdd")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4124(template4124) => {
      inspect(template4124.atmospheric_chemical_constituent_type, content="230")
      inspect(template4124.transport_model_used, content="333")
      inspect(template4124.release_start_year, content="2026")
      inspect(template4124.forecast_time, content="6")
      inspect(template4124.reserved_tail == b"\xdd", content="true")
    }
    _ => fail("template4.124 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4125 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4125({
      base: sample_template4124(b""),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
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
    ProductTemplate4125(template4125) => {
      inspect(template4125.base.transport_model_used, content="333")
      inspect(template4125.base.release_start_day, content="21")
      inspect(template4125.type_of_ensemble_forecast, content="2")
      inspect(template4125.perturbation_number, content="3")
      inspect(template4125.number_of_forecasts_in_ensemble, content="20")
      inspect(template4125.reserved_tail == b"\xde", content="true")
    }
    _ => fail("template4.125 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4126 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4126(sample_template4126(b"\xdf")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4126(template4126) => {
      inspect(template4126.transport_model_used, content="333")
      inspect(template4126.release_start_second, content="45")
      inspect(template4126.end_year, content="2026")
      inspect(template4126.number_of_time_ranges, content="2")
      inspect(template4126.time_range_specs.length(), content="2")
      inspect(template4126.reserved_tail == b"\xdf", content="true")
    }
    _ => fail("template4.126 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4127 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4127({
      base: sample_template4126(b""),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xe0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4127(template4127) => {
      inspect(template4127.base.release_start_second, content="45")
      inspect(template4127.base.end_year, content="2026")
      inspect(template4127.base.number_of_time_ranges, content="2")
      inspect(template4127.type_of_ensemble_forecast, content="2")
      inspect(template4127.perturbation_number, content="3")
      inspect(template4127.number_of_forecasts_in_ensemble, content="20")
      inspect(template4127.reserved_tail == b"\xe0", content="true")
    }
    _ => fail("template4.127 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4128 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4128({
      base: sample_template40_base(),
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4128(template4128) => {
      inspect(template4128.base.forecast_time, content="6")
      inspect(
        template4128.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4128.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4128.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4128.reserved_tail == b"\xe1", content="true")
    }
    _ => fail("template4.128 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4129 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4129({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4129(template4129) => {
      inspect(template4129.base.forecast_time, content="6")
      inspect(template4129.type_of_ensemble_forecast, content="2")
      inspect(template4129.perturbation_number, content="3")
      inspect(template4129.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4129.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4129.reserved_tail == b"\xe2", content="true")
    }
    _ => fail("template4.129 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
