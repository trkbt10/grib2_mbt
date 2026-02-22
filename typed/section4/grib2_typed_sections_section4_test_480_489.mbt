///|
test "section4 template480 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate480({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
      type_of_interval_for_first_and_second_wavelength: 1,
      scale_factor_of_first_wavelength: 9,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 9,
      scaled_value_of_second_wavelength: 650,
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
    ProductTemplate480(template480) => {
      inspect(template480.aerosol_type, content="62000")
      inspect(template480.source_or_sink, content="2")
      inspect(template480.scaled_value_of_first_wavelength, content="550")
      inspect(template480.scaled_value_of_second_wavelength, content="650")
    }
    _ => fail("template4.80 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template481 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate481({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        aerosol_type: 62000,
        source_or_sink: 2,
        type_of_interval_for_first_and_second_size: 1,
        scale_factor_of_first_size: 1,
        scaled_value_of_first_size: 500,
        scale_factor_of_second_size: 1,
        scaled_value_of_second_size: 1500,
        type_of_interval_for_first_and_second_wavelength: 1,
        scale_factor_of_first_wavelength: 9,
        scaled_value_of_first_wavelength: 550,
        scale_factor_of_second_wavelength: 9,
        scaled_value_of_second_wavelength: 650,
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
    ProductTemplate481(template481) => {
      inspect(template481.base.aerosol_type, content="62000")
      inspect(template481.base.source_or_sink, content="2")
      inspect(template481.type_of_ensemble_forecast, content="2")
      inspect(template481.perturbation_number, content="3")
      inspect(template481.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.81 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template482 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate482({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
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
      reserved_tail: b"\xb9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate482(template482) => {
      inspect(template482.aerosol_type, content="62000")
      inspect(template482.source_or_sink, content="2")
      inspect(template482.end_year, content="2024")
      inspect(template482.number_of_time_ranges, content="2")
      inspect(template482.time_range_specs.length(), content="2")
      inspect(template482.number_of_missing_values, content="1")
      inspect(template482.reserved_tail == b"\xb9", content="true")
    }
    _ => fail("template4.82 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template483 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate483({
      parameter_category: 20,
      parameter_number: 1,
      type_of_generating_process: 4,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
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
      reserved_tail: b"\xba",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate483(template483) => {
      inspect(template483.aerosol_type, content="62000")
      inspect(template483.source_or_sink, content="2")
      inspect(template483.type_of_ensemble_forecast, content="2")
      inspect(template483.perturbation_number, content="3")
      inspect(template483.number_of_forecasts_in_ensemble, content="20")
      inspect(template483.end_year, content="2024")
      inspect(template483.number_of_time_ranges, content="2")
      inspect(template483.time_range_specs.length(), content="2")
      inspect(template483.number_of_missing_values, content="1")
      inspect(template483.reserved_tail == b"\xba", content="true")
    }
    _ => fail("template4.83 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template484 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate484({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
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
    ProductTemplate484(template484) => {
      inspect(template484.aerosol_type, content="62000")
      inspect(template484.source_or_sink, content="2")
      inspect(template484.type_of_ensemble_forecast, content="2")
      inspect(template484.perturbation_number, content="3")
      inspect(template484.number_of_forecasts_in_ensemble, content="20")
      inspect(template484.end_year, content="2024")
      inspect(template484.number_of_time_ranges, content="2")
      inspect(template484.time_range_specs.length(), content="2")
      inspect(template484.number_of_missing_values, content="1")
      inspect(template484.reserved_tail == b"\xbb", content="true")
    }
    _ => fail("template4.84 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template485 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate485({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
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
      reserved_tail: b"\xbc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate485(template485) => {
      inspect(template485.aerosol_type, content="62000")
      inspect(template485.type_of_ensemble_forecast, content="2")
      inspect(template485.perturbation_number, content="3")
      inspect(template485.number_of_forecasts_in_ensemble, content="20")
      inspect(template485.end_year, content="2024")
      inspect(template485.number_of_time_ranges, content="2")
      inspect(template485.time_range_specs.length(), content="2")
      inspect(template485.number_of_missing_values, content="1")
      inspect(template485.reserved_tail == b"\xbc", content="true")
    }
    _ => fail("template4.85 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template486 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate486({
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
      total_number_of_quantiles: 100,
      quantile_value: 95,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate486(template486) => {
      inspect(template486.type_of_generating_process, content="4")
      inspect(template486.forecast_time, content="6")
      inspect(template486.total_number_of_quantiles, content="100")
      inspect(template486.quantile_value, content="95")
    }
    _ => fail("template4.86 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template487 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate487({
      base: {
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
        total_number_of_quantiles: 100,
        quantile_value: 95,
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
      reserved_tail: b"\xbd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate487(template487) => {
      inspect(template487.base.total_number_of_quantiles, content="100")
      inspect(template487.base.quantile_value, content="95")
      inspect(template487.end_year, content="2024")
      inspect(template487.number_of_time_ranges, content="2")
      inspect(template487.time_range_specs.length(), content="2")
      inspect(template487.number_of_missing_values, content="1")
      inspect(template487.reserved_tail == b"\xbd", content="true")
    }
    _ => fail("template4.87 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template488 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate488({
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
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_analyses_or_forecasts_used: 2,
      analysis_or_forecast_specs: [
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
      reserved_tail: b"\xbe",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate488(template488) => {
      inspect(
        template488.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template488.number_of_analyses_or_forecasts_used, content="2")
      inspect(template488.analysis_or_forecast_specs.length(), content="2")
      inspect(template488.analysis_or_forecast_specs[0].year, content="2024")
      inspect(
        template488.analysis_or_forecast_specs[1].forecast_time,
        content="12",
      )
      inspect(template488.reserved_tail == b"\xbe", content="true")
    }
    _ => fail("template4.88 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template489 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate489({
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate489(template489) => {
      inspect(template489.input_process_identifier, content="321")
      inspect(template489.input_originating_centre, content="34")
      inspect(template489.type_of_post_processing, content="2")
      inspect(template489.total_number_of_quantiles, content="100")
      inspect(template489.quantile_value, content="95")
    }
    _ => fail("template4.89 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
