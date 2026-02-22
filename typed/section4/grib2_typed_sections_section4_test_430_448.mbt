///|
test "section4 template430 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate430({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 4,
      observation_generating_process_identifier: 7,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 5,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 6,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate430(template430) => {
      inspect(template430.number_of_contributing_spectral_bands, content="2")
      inspect(template430.bands.length(), content="2")
      inspect(
        template430.bands[1].scaled_value_of_central_wave_number,
        content="654321",
      )
      inspect(template430.reserved_tail == b"\xa0", content="true")
    }
    _ => fail("template4.30 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template431 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate431({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 4,
      observation_generating_process_identifier: 7,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate431(template431) => {
      inspect(template431.number_of_contributing_spectral_bands, content="2")
      inspect(template431.bands.length(), content="2")
      inspect(template431.bands[0].instrument_type, content="300")
      inspect(template431.bands[1].instrument_type, content="400")
      inspect(template431.reserved_tail == b"\xa1", content="true")
    }
    _ => fail("template4.31 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template432 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate432({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate432(template432) => {
      inspect(template432.forecast_time, content="6")
      inspect(template432.number_of_contributing_spectral_bands, content="2")
      inspect(template432.bands.length(), content="2")
      inspect(template432.bands[0].instrument_type, content="300")
      inspect(template432.bands[1].instrument_type, content="400")
      inspect(template432.reserved_tail == b"\xa2", content="true")
    }
    _ => fail("template4.32 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template433 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate433({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xa3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate433(template433) => {
      inspect(template433.forecast_time, content="6")
      inspect(template433.number_of_contributing_spectral_bands, content="2")
      inspect(template433.bands.length(), content="2")
      inspect(template433.type_of_ensemble_forecast, content="2")
      inspect(template433.perturbation_number, content="3")
      inspect(template433.number_of_forecasts_in_ensemble, content="20")
      inspect(template433.reserved_tail == b"\xa3", content="true")
    }
    _ => fail("template4.33 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template434 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate434({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate434(template434) => {
      inspect(template434.forecast_time, content="6")
      inspect(template434.bands.length(), content="2")
      inspect(template434.type_of_ensemble_forecast, content="2")
      inspect(template434.number_of_time_ranges, content="2")
      inspect(template434.time_range_specs.length(), content="2")
      inspect(template434.number_of_missing_values, content="1")
      inspect(template434.reserved_tail == b"\xa4", content="true")
    }
    _ => fail("template4.34 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template435 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate435({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 4,
      observation_generating_process_identifier: 7,
      quality_value_associated_with_parameter: 1,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate435(template435) => {
      inspect(template435.quality_value_associated_with_parameter, content="1")
      inspect(template435.number_of_contributing_spectral_bands, content="2")
      inspect(template435.bands.length(), content="2")
      inspect(template435.bands[0].instrument_type, content="300")
      inspect(template435.bands[1].instrument_type, content="400")
      inspect(template435.reserved_tail == b"\xa5", content="true")
    }
    _ => fail("template4.35 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template440 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate440({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
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
    ProductTemplate440(template440) => {
      inspect(
        template440.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template440.forecast_time, content="6")
      inspect(template440.type_of_first_fixed_surface, content="100")
      inspect(template440.scaled_value_of_first_fixed_surface, content="50000")
    }
    _ => fail("template4.40 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template441 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate441({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
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
    ProductTemplate441(template441) => {
      inspect(
        template441.base.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template441.base.forecast_time, content="6")
      inspect(template441.type_of_ensemble_forecast, content="2")
      inspect(template441.perturbation_number, content="3")
      inspect(template441.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.41 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template442 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate442({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
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
      reserved_tail: b"\xa6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate442(template442) => {
      inspect(
        template442.base.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template442.base.forecast_time, content="6")
      inspect(template442.number_of_time_ranges, content="2")
      inspect(template442.time_range_specs.length(), content="2")
      inspect(template442.number_of_missing_values, content="1")
      inspect(template442.reserved_tail == b"\xa6", content="true")
    }
    _ => fail("template4.42 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template443 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate443({
      base: {
        base: {
          parameter_category: 20,
          parameter_number: 1,
          atmospheric_chemical_constituent_type: 40001,
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
        },
        type_of_ensemble_forecast: 2,
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
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
      reserved_tail: b"\xa7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate443(template443) => {
      inspect(
        template443.base.base.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template443.base.base.forecast_time, content="6")
      inspect(template443.base.type_of_ensemble_forecast, content="2")
      inspect(template443.number_of_time_ranges, content="2")
      inspect(template443.time_range_specs.length(), content="2")
      inspect(template443.number_of_missing_values, content="1")
      inspect(template443.reserved_tail == b"\xa7", content="true")
    }
    _ => fail("template4.43 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template444 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate444({
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
    ProductTemplate444(template444) => {
      inspect(template444.aerosol_type, content="62000")
      inspect(
        template444.type_of_interval_for_first_and_second_size,
        content="2",
      )
      inspect(template444.scaled_value_of_first_size, content="1000")
      inspect(template444.scaled_value_of_second_size, content="2000")
      inspect(template444.forecast_time, content="6")
      inspect(template444.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.44 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template445 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate445({
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
    ProductTemplate445(template445) => {
      inspect(template445.aerosol_type, content="62000")
      inspect(template445.forecast_time, content="6")
      inspect(template445.type_of_ensemble_forecast, content="2")
      inspect(template445.perturbation_number, content="3")
      inspect(template445.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.45 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template446 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate446({
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
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate446(template446) => {
      inspect(template446.aerosol_type, content="62000")
      inspect(template446.forecast_time, content="6")
      inspect(template446.number_of_time_ranges, content="2")
      inspect(template446.time_range_specs.length(), content="2")
      inspect(template446.number_of_missing_values, content="1")
      inspect(template446.reserved_tail == b"\xa8", content="true")
    }
    _ => fail("template4.46 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template447 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate447({
      parameter_category: 20,
      parameter_number: 1,
      type_of_generating_process: 2,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
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
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate447(template447) => {
      inspect(template447.type_of_generating_process, content="2")
      inspect(template447.aerosol_type, content="62000")
      inspect(template447.forecast_time, content="6")
      inspect(template447.type_of_ensemble_forecast, content="2")
      inspect(template447.number_of_time_ranges, content="2")
      inspect(template447.time_range_specs.length(), content="2")
      inspect(template447.reserved_tail == b"\xa9", content="true")
    }
    _ => fail("template4.47 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template448 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate448({
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
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate448(template448) => {
      inspect(template448.aerosol_type, content="62000")
      inspect(
        template448.type_of_interval_for_first_and_second_wavelength,
        content="2",
      )
      inspect(template448.scaled_value_of_first_wavelength, content="550")
      inspect(template448.scaled_value_of_second_wavelength, content="700")
      inspect(template448.forecast_time, content="6")
      inspect(template448.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.48 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
