///|
fn typed_decode_template_430(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate430, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 5, "template 4.30") { Ok(_) => (); Err(e) => return Err(e) }

  let nb = typed_read_u8_view(template_payload, 4)
  let required = 5 + nb * 10
  match typed_validate_template_min_length(template_payload, required, "template 4.30 band payload") { Ok(_) => (); Err(e) => return Err(e) }

  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 5 + i * 10
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u8_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: typed_read_u8_view(template_payload, offset + 5),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 6,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    observation_generating_process_identifier: typed_read_u8_view(template_payload, 3),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_431(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate431, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 5, "template 4.31") { Ok(_) => (); Err(e) => return Err(e) }

  let nb = typed_read_u8_view(template_payload, 4)
  let required = 5 + nb * 11
  match typed_validate_template_min_length(template_payload, required, "template 4.31 band payload") { Ok(_) => (); Err(e) => return Err(e) }

  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 5 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: typed_read_u8_view(template_payload, offset + 6),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    observation_generating_process_identifier: typed_read_u8_view(template_payload, 3),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_432(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate432, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 14, "template 4.32") { Ok(_) => (); Err(e) => return Err(e) }

  let nb = typed_read_u8_view(template_payload, 13)
  let required = 14 + nb * 11
  match typed_validate_template_min_length(template_payload, required, "template 4.32 band payload") { Ok(_) => (); Err(e) => return Err(e) }

  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: typed_read_u8_view(template_payload, offset + 6),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    background_process_identifier: typed_read_u8_view(template_payload, 3),
    generating_process_identifier: typed_read_u8_view(template_payload, 4),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 7),
    time_range_unit: typed_read_u8_view(template_payload, 8),
    forecast_time: typed_read_u32_be_view(template_payload, 9),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_433(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate433, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 17, "template 4.33") { Ok(_) => (); Err(e) => return Err(e) }

  let nb = typed_read_u8_view(template_payload, 13)
  let required = 17 + nb * 11
  match typed_validate_template_min_length(template_payload, required, "template 4.33 payload") { Ok(_) => (); Err(e) => return Err(e) }

  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: typed_read_u8_view(template_payload, offset + 6),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  let ensemble_offset = 14 + nb * 11
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    background_process_identifier: typed_read_u8_view(template_payload, 3),
    generating_process_identifier: typed_read_u8_view(template_payload, 4),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 7),
    time_range_unit: typed_read_u8_view(template_payload, 8),
    forecast_time: typed_read_u32_be_view(template_payload, 9),
    number_of_contributing_spectral_bands: nb,
    bands,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, ensemble_offset),
    perturbation_number: typed_read_u8_view(template_payload, ensemble_offset + 1),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, ensemble_offset + 2),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_434(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate434, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 14, "template 4.34") { Ok(_) => (); Err(e) => return Err(e) }

  let nb = typed_read_u8_view(template_payload, 13)
  let ensemble_offset = 14 + nb * 11
  let required_min = 29 + nb * 11
  match typed_validate_template_min_length(template_payload, required_min, "template 4.34") { Ok(_) => (); Err(e) => return Err(e) }

  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: typed_read_u8_view(template_payload, offset + 6),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  let n = typed_read_u8_view(template_payload, ensemble_offset + 10)
  let required = required_min + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.34 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    background_process_identifier: typed_read_u8_view(template_payload, 3),
    generating_process_identifier: typed_read_u8_view(template_payload, 4),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 7),
    time_range_unit: typed_read_u8_view(template_payload, 8),
    forecast_time: typed_read_u32_be_view(template_payload, 9),
    number_of_contributing_spectral_bands: nb,
    bands,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, ensemble_offset),
    perturbation_number: typed_read_u8_view(template_payload, ensemble_offset + 1),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, ensemble_offset + 2),
    end_year: typed_read_u16_be_view(template_payload, ensemble_offset + 3),
    end_month: typed_read_u8_view(template_payload, ensemble_offset + 5),
    end_day: typed_read_u8_view(template_payload, ensemble_offset + 6),
    end_hour: typed_read_u8_view(template_payload, ensemble_offset + 7),
    end_minute: typed_read_u8_view(template_payload, ensemble_offset + 8),
    end_second: typed_read_u8_view(template_payload, ensemble_offset + 9),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      ensemble_offset + 11,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      ensemble_offset + 15,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_435(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate435, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 6, "template 4.35") { Ok(_) => (); Err(e) => return Err(e) }

  let nb = typed_read_u8_view(template_payload, 5)
  let required = 6 + nb * 11
  match typed_validate_template_min_length(template_payload, required, "template 4.35 band payload") { Ok(_) => (); Err(e) => return Err(e) }

  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 6 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: typed_read_u8_view(template_payload, offset + 6),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    observation_generating_process_identifier: typed_read_u8_view(template_payload, 3),
    quality_value_associated_with_parameter: typed_read_u8_view(template_payload, 4),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_440(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate440, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 27, "template 4.40") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    type_of_generating_process: typed_read_u8_view(template_payload, 4),
    background_process_identifier: typed_read_u8_view(template_payload, 5),
    generating_process_identifier: typed_read_u8_view(template_payload, 6),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 7,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 9),
    time_range_unit: typed_read_u8_view(template_payload, 10),
    forecast_time: typed_read_u32_be_view(template_payload, 11),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 15),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 16),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 17,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 21),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 22),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 23,
    ),
  })
}

///|
fn typed_decode_template_441(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate441, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 30, "template 4.41") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_440(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 27),
    perturbation_number: typed_read_u8_view(template_payload, 28),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 29),
  })
}

///|
fn typed_decode_template_442(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate442, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 39, "template 4.42") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_440(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 34)
  let required = 39 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.42 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 27),
    end_month: typed_read_u8_view(template_payload, 29),
    end_day: typed_read_u8_view(template_payload, 30),
    end_hour: typed_read_u8_view(template_payload, 31),
    end_minute: typed_read_u8_view(template_payload, 32),
    end_second: typed_read_u8_view(template_payload, 33),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 35),
    time_range_specs: typed_decode_time_range_specs(template_payload, 39, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_443(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate443, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 42, "template 4.43") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_441(template_payload.sub(end=30)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 37)
  let required = 42 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.43 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 30),
    end_month: typed_read_u8_view(template_payload, 32),
    end_day: typed_read_u8_view(template_payload, 33),
    end_hour: typed_read_u8_view(template_payload, 34),
    end_minute: typed_read_u8_view(template_payload, 35),
    end_second: typed_read_u8_view(template_payload, 36),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 38),
    time_range_specs: typed_decode_time_range_specs(template_payload, 42, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_444(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate444, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 36, "template 4.44") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 4),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 5),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 10),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: typed_read_u8_view(template_payload, 15),
    background_process_identifier: typed_read_u8_view(template_payload, 16),
    generating_process_identifier: typed_read_u8_view(template_payload, 17),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 20),
    time_range_unit: typed_read_u8_view(template_payload, 21),
    forecast_time: typed_read_u16_be_view(template_payload, 22),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 24),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 25),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 26,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 30),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 31),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 32,
    ),
  })
}

///|
fn typed_decode_template_445(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate445, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 41, "template 4.45") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 4),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 5),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 10),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: typed_read_u8_view(template_payload, 15),
    background_process_identifier: typed_read_u8_view(template_payload, 16),
    generating_process_identifier: typed_read_u8_view(template_payload, 17),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 20),
    time_range_unit: typed_read_u8_view(template_payload, 21),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 26),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 27),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 32),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 33),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 38),
    perturbation_number: typed_read_u8_view(template_payload, 39),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 40),
  })
}

///|
fn typed_decode_template_446(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate446, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 50, "template 4.46") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 45)
  let required = 50 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.46 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 4),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 5),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 10),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: typed_read_u8_view(template_payload, 15),
    background_process_identifier: typed_read_u8_view(template_payload, 16),
    generating_process_identifier: typed_read_u8_view(template_payload, 17),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 20),
    time_range_unit: typed_read_u8_view(template_payload, 21),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 26),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 27),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 32),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 33),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    end_year: typed_read_u16_be_view(template_payload, 38),
    end_month: typed_read_u8_view(template_payload, 40),
    end_day: typed_read_u8_view(template_payload, 41),
    end_hour: typed_read_u8_view(template_payload, 42),
    end_minute: typed_read_u8_view(template_payload, 43),
    end_second: typed_read_u8_view(template_payload, 44),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 46),
    time_range_specs: typed_decode_time_range_specs(template_payload, 50, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_447(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate447, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 53, "template 4.47") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 48)
  let required = 53 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.47 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    aerosol_type: typed_read_u16_be_view(template_payload, 3),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 11),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    background_process_identifier: typed_read_u8_view(template_payload, 16),
    generating_process_identifier: typed_read_u8_view(template_payload, 17),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 20),
    time_range_unit: typed_read_u8_view(template_payload, 21),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 26),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 27),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 32),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 33),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 38),
    perturbation_number: typed_read_u8_view(template_payload, 39),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 40),
    end_year: typed_read_u16_be_view(template_payload, 41),
    end_month: typed_read_u8_view(template_payload, 43),
    end_day: typed_read_u8_view(template_payload, 44),
    end_hour: typed_read_u8_view(template_payload, 45),
    end_minute: typed_read_u8_view(template_payload, 46),
    end_second: typed_read_u8_view(template_payload, 47),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 49),
    time_range_specs: typed_decode_time_range_specs(template_payload, 53, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_448(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate448, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 49, "template 4.48") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 4),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 5),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 10),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_interval_for_first_and_second_wavelength: typed_read_u8_view(template_payload, 15),
    scale_factor_of_first_wavelength: typed_read_u8_view(template_payload, 16),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 17,
    ),
    scale_factor_of_second_wavelength: typed_read_u8_view(template_payload, 21),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 22,
    ),
    type_of_generating_process: typed_read_u8_view(template_payload, 26),
    background_process_identifier: typed_read_u8_view(template_payload, 27),
    generating_process_identifier: typed_read_u8_view(template_payload, 28),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 29,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 31),
    time_range_unit: typed_read_u8_view(template_payload, 32),
    forecast_time: typed_read_u32_be_view(template_payload, 33),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 37),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 38),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 43),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 44),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 45,
    ),
  })
}
