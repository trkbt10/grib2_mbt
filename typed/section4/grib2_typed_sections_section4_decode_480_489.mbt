///|
fn typed_decode_template_480(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate480, Grib2SectionCodecError] {
  if template_payload.length() != 50 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.80 expected 50 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
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
    type_of_interval_for_first_and_second_wavelength: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_wavelength: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 18,
    ),
    scale_factor_of_second_wavelength: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 23,
    ),
    type_of_generating_process: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 30,
    ),
    minutes_of_observational_data_cutoff: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[33].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 34),
    type_of_first_fixed_surface: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 40,
    ),
    type_of_second_fixed_surface: template_payload[44]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[45]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 46,
    ),
  })
}

///|
fn typed_decode_template_481(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate481, Grib2SectionCodecError] {
  if template_payload.length() != 53 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.81 expected 53 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_480(template_payload.sub(end=50)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[50]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[51].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[52]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_482(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate482, Grib2SectionCodecError] {
  if template_payload.length() < 51 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.82 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[46].to_uint().reinterpret_as_int()
  let required = 51 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.82 time-range payload too short: expected at least " +
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
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
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
    type_of_generating_process: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[22].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    end_year: typed_read_u16_be_view(template_payload, 39),
    end_month: template_payload[41].to_uint().reinterpret_as_int(),
    end_day: template_payload[42].to_uint().reinterpret_as_int(),
    end_hour: template_payload[43].to_uint().reinterpret_as_int(),
    end_minute: template_payload[44].to_uint().reinterpret_as_int(),
    end_second: template_payload[45].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 47),
    time_range_specs: typed_decode_time_range_specs(template_payload, 51, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_483(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate483, Grib2SectionCodecError] {
  if template_payload.length() < 54 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.83 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[49].to_uint().reinterpret_as_int()
  let required = 54 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.83 time-range payload too short: expected at least " +
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
    source_or_sink: template_payload[5].to_uint().reinterpret_as_int(),
    type_of_interval_for_first_and_second_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 8),
    scale_factor_of_second_size: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 13),
    background_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[22].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    type_of_ensemble_forecast: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[40].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[41]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 42),
    end_month: template_payload[44].to_uint().reinterpret_as_int(),
    end_day: template_payload[45].to_uint().reinterpret_as_int(),
    end_hour: template_payload[46].to_uint().reinterpret_as_int(),
    end_minute: template_payload[47].to_uint().reinterpret_as_int(),
    end_second: template_payload[48].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 50),
    time_range_specs: typed_decode_time_range_specs(template_payload, 54, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_484(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate484, Grib2SectionCodecError] {
  if template_payload.length() < 54 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.84 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[49].to_uint().reinterpret_as_int()
  let required = 54 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.84 time-range payload too short: expected at least " +
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
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
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
    type_of_generating_process: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[22].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    type_of_ensemble_forecast: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[40].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[41]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 42),
    end_month: template_payload[44].to_uint().reinterpret_as_int(),
    end_day: template_payload[45].to_uint().reinterpret_as_int(),
    end_hour: template_payload[46].to_uint().reinterpret_as_int(),
    end_minute: template_payload[47].to_uint().reinterpret_as_int(),
    end_second: template_payload[48].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 50),
    time_range_specs: typed_decode_time_range_specs(template_payload, 54, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_485(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate485, Grib2SectionCodecError] {
  if template_payload.length() < 53 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.85 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[48].to_uint().reinterpret_as_int()
  let required = 53 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.85 time-range payload too short: expected at least " +
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
fn typed_decode_template_486(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate486, Grib2SectionCodecError] {
  if template_payload.length() != 29 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.86 expected 29 octets, got " +
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
    type_of_first_fixed_surface: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[14]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 15,
    ),
    type_of_second_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 25),
    quantile_value: typed_read_u16_be_view(template_payload, 27),
  })
}

///|
fn typed_decode_template_487(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate487, Grib2SectionCodecError] {
  if template_payload.length() < 41 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.87 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_486(template_payload.sub(end=29)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[36].to_uint().reinterpret_as_int()
  let required = 41 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.87 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 29),
    end_month: template_payload[31].to_uint().reinterpret_as_int(),
    end_day: template_payload[32].to_uint().reinterpret_as_int(),
    end_hour: template_payload[33].to_uint().reinterpret_as_int(),
    end_minute: template_payload[34].to_uint().reinterpret_as_int(),
    end_second: template_payload[35].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 37),
    time_range_specs: typed_decode_time_range_specs(template_payload, 41, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_488(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate488, Grib2SectionCodecError] {
  if template_payload.length() < 37 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.88 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[18].to_uint().reinterpret_as_int()
  let required = 19 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.88 analysis/forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let analysis_or_forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 19 + i * 18
    analysis_or_forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: template_payload[offset + 2].to_uint().reinterpret_as_int(),
      day: template_payload[offset + 3].to_uint().reinterpret_as_int(),
      hour: template_payload[offset + 4].to_uint().reinterpret_as_int(),
      minute: template_payload[offset + 5].to_uint().reinterpret_as_int(),
      second: template_payload[offset + 6].to_uint().reinterpret_as_int(),
      forecast_time_unit: template_payload[offset + 7]
      .to_uint()
      .reinterpret_as_int(),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: template_payload[offset + 12]
      .to_uint()
      .reinterpret_as_int(),
      time_increment_unit: template_payload[offset + 13]
      .to_uint()
      .reinterpret_as_int(),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
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
    type_of_first_fixed_surface: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 7,
    ),
    type_of_second_fixed_surface: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 13,
    ),
    method_used_to_derive_data_field_values_at_local_time: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    number_of_analyses_or_forecasts_used: n,
    analysis_or_forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_489(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate489, Grib2SectionCodecError] {
  if template_payload.length() != 34 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.89 expected 34 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    input_process_identifier: typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: template_payload[6].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[8]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 10,
    ),
    minutes_of_observational_data_cutoff: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[13].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 14),
    type_of_first_fixed_surface: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 20,
    ),
    type_of_second_fixed_surface: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 26,
    ),
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 30),
    quantile_value: typed_read_u16_be_view(template_payload, 32),
  })
}
