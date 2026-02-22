///|
fn typed_decode_template_430(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate430, Grib2SectionCodecError] {
  if template_payload.length() < 5 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.30 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[4].to_uint().reinterpret_as_int()
  let required = 5 + nb * 10
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.30 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 5 + i * 10
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: template_payload[offset + 4]
      .to_uint()
      .reinterpret_as_int(),
      scale_factor_of_central_wave_number: template_payload[offset + 5]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 6,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    observation_generating_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_431(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate431, Grib2SectionCodecError] {
  if template_payload.length() < 5 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.31 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[4].to_uint().reinterpret_as_int()
  let required = 5 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.31 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 5 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    observation_generating_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_432(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate432, Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.32 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let required = 14 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.32 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[8].to_uint().reinterpret_as_int(),
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
  if template_payload.length() < 17 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.33 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let required = 17 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.33 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  let ensemble_offset = 14 + nb * 11
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[8].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 9),
    number_of_contributing_spectral_bands: nb,
    bands,
    type_of_ensemble_forecast: template_payload[ensemble_offset]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[ensemble_offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[ensemble_offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_434(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate434, Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.34 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let ensemble_offset = 14 + nb * 11
  let required_min = 29 + nb * 11
  if template_payload.length() < required_min {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.34 payload too short: expected at least " +
        required_min.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  let n = template_payload[ensemble_offset + 10].to_uint().reinterpret_as_int()
  let required = required_min + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.34 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[8].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 9),
    number_of_contributing_spectral_bands: nb,
    bands,
    type_of_ensemble_forecast: template_payload[ensemble_offset]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[ensemble_offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[ensemble_offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, ensemble_offset + 3),
    end_month: template_payload[ensemble_offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    end_day: template_payload[ensemble_offset + 6]
    .to_uint()
    .reinterpret_as_int(),
    end_hour: template_payload[ensemble_offset + 7]
    .to_uint()
    .reinterpret_as_int(),
    end_minute: template_payload[ensemble_offset + 8]
    .to_uint()
    .reinterpret_as_int(),
    end_second: template_payload[ensemble_offset + 9]
    .to_uint()
    .reinterpret_as_int(),
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
  if template_payload.length() < 6 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.35 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[5].to_uint().reinterpret_as_int()
  let required = 6 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.35 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 6 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    observation_generating_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    quality_value_associated_with_parameter: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_440(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate440, Grib2SectionCodecError] {
  if template_payload.length() != 27 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.40 expected 27 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    type_of_generating_process: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 7,
    ),
    minutes_of_observational_data_cutoff: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[10].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 11),
    type_of_first_fixed_surface: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 17,
    ),
    type_of_second_fixed_surface: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 23,
    ),
  })
}

///|
fn typed_decode_template_441(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate441, Grib2SectionCodecError] {
  if template_payload.length() != 30 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.41 expected 30 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_440(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[28].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_442(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate442, Grib2SectionCodecError] {
  if template_payload.length() < 39 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.42 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_440(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[34].to_uint().reinterpret_as_int()
  let required = 39 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.42 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 27),
    end_month: template_payload[29].to_uint().reinterpret_as_int(),
    end_day: template_payload[30].to_uint().reinterpret_as_int(),
    end_hour: template_payload[31].to_uint().reinterpret_as_int(),
    end_minute: template_payload[32].to_uint().reinterpret_as_int(),
    end_second: template_payload[33].to_uint().reinterpret_as_int(),
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
  if template_payload.length() < 42 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.43 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_441(template_payload.sub(end=30)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[37].to_uint().reinterpret_as_int()
  let required = 42 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.43 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 30),
    end_month: template_payload[32].to_uint().reinterpret_as_int(),
    end_day: template_payload[33].to_uint().reinterpret_as_int(),
    end_hour: template_payload[34].to_uint().reinterpret_as_int(),
    end_minute: template_payload[35].to_uint().reinterpret_as_int(),
    end_second: template_payload[36].to_uint().reinterpret_as_int(),
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
  if template_payload.length() != 36 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.44 expected 36 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u16_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 26,
    ),
    type_of_second_fixed_surface: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 32,
    ),
  })
}

///|
fn typed_decode_template_445(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate445, Grib2SectionCodecError] {
  if template_payload.length() != 41 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.45 expected 41 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_446(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate446, Grib2SectionCodecError] {
  if template_payload.length() < 50 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.46 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[45].to_uint().reinterpret_as_int()
  let required = 50 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.46 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    end_year: typed_read_u16_be_view(template_payload, 38),
    end_month: template_payload[40].to_uint().reinterpret_as_int(),
    end_day: template_payload[41].to_uint().reinterpret_as_int(),
    end_hour: template_payload[42].to_uint().reinterpret_as_int(),
    end_minute: template_payload[43].to_uint().reinterpret_as_int(),
    end_second: template_payload[44].to_uint().reinterpret_as_int(),
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
  if template_payload.length() < 53 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.47 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[48].to_uint().reinterpret_as_int()
  let required = 53 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.47 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 3),
    type_of_interval_for_first_and_second_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 41),
    end_month: template_payload[43].to_uint().reinterpret_as_int(),
    end_day: template_payload[44].to_uint().reinterpret_as_int(),
    end_hour: template_payload[45].to_uint().reinterpret_as_int(),
    end_minute: template_payload[46].to_uint().reinterpret_as_int(),
    end_second: template_payload[47].to_uint().reinterpret_as_int(),
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
  if template_payload.length() != 49 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.48 expected 49 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_interval_for_first_and_second_wavelength: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_wavelength: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 17,
    ),
    scale_factor_of_second_wavelength: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 22,
    ),
    type_of_generating_process: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 29,
    ),
    minutes_of_observational_data_cutoff: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[32].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 33),
    type_of_first_fixed_surface: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_second_fixed_surface: template_payload[43]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[44]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 45,
    ),
  })
}
