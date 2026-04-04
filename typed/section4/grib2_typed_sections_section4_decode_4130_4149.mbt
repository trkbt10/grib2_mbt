///|
fn typed_decode_template_4130(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4130, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 42, "template 4.130") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 27, "template 4.130",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 26),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4131(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4131, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 53, "template 4.131") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 38, "template 4.131",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    forecast_probability_number: typed_read_u8_view(template_payload, 25),
    total_number_of_forecast_probabilities: typed_read_u8_view(template_payload, 26),
    probability_type: typed_read_u8_view(template_payload, 27),
    scale_factor_of_lower_limit: typed_read_u8_view(template_payload, 28),
    scaled_value_of_lower_limit: typed_read_u32_be_view(template_payload, 29),
    scale_factor_of_upper_limit: typed_read_u8_view(template_payload, 33),
    scaled_value_of_upper_limit: typed_read_u32_be_view(template_payload, 34),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4132(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4132, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 44, "template 4.132") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 29, "template 4.132",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 25),
    quantile_value: typed_read_u16_be_view(template_payload, 27),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4133(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4133, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 49, "template 4.133") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_489(template_payload.sub(end=34)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 34, "template 4.133",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4134(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4134, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 53, "template 4.134") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 36)
  let time_required = 41 + n * 12
  if template_payload.length() < time_required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.134 time-range payload too short: expected at least " +
        time_required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_487(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, time_required, "template 4.134",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4135(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4135, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 58, "template 4.135") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 41)
  let time_required = 46 + n * 12
  if template_payload.length() < time_required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.135 time-range payload too short: expected at least " +
        time_required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_490(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, time_required, "template 4.135",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4136(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4136, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 43, "template 4.136") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4119(template_payload.sub(end=43)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, reference_required) = match
    typed_decode_reference_period_definition(
      template_payload, 43, "template 4.136",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  let (spatial_vicinity, required) = match
    typed_decode_spatial_vicinity_definition(
      template_payload, reference_required, "template 4.136",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    spatial_vicinity,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4137(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4137, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 37, "template 4.137") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 26,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 30),
    month_of_model_version_date: typed_read_u8_view(template_payload, 32),
    day_of_model_version_date: typed_read_u8_view(template_payload, 33),
    hour_of_model_version_date: typed_read_u8_view(template_payload, 34),
    minute_of_model_version_date: typed_read_u8_view(template_payload, 35),
    second_of_model_version_date: typed_read_u8_view(template_payload, 36),
    reserved_tail: template_payload.sub(start=37).to_bytes(),
  })
}

///|
fn typed_decode_template_4138(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4138, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 50, "template 4.138") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 44)
  let required = 49 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.138 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4137(template_payload.sub(end=37)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 37),
    end_month: typed_read_u8_view(template_payload, 39),
    end_day: typed_read_u8_view(template_payload, 40),
    end_hour: typed_read_u8_view(template_payload, 41),
    end_minute: typed_read_u8_view(template_payload, 42),
    end_second: typed_read_u8_view(template_payload, 43),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 45),
    time_range_specs: typed_decode_time_range_specs(template_payload, 49, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4139(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4139, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 43, "template 4.139") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 36),
    month_of_model_version_date: typed_read_u8_view(template_payload, 38),
    day_of_model_version_date: typed_read_u8_view(template_payload, 39),
    hour_of_model_version_date: typed_read_u8_view(template_payload, 40),
    minute_of_model_version_date: typed_read_u8_view(template_payload, 41),
    second_of_model_version_date: typed_read_u8_view(template_payload, 42),
    reserved_tail: template_payload.sub(start=43).to_bytes(),
  })
}

///|
fn typed_decode_template_4140(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4140, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 52, "template 4.140") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 36),
    perturbation_number: typed_read_u32_be_view(template_payload, 37),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 41,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 45),
    month_of_model_version_date: typed_read_u8_view(template_payload, 47),
    day_of_model_version_date: typed_read_u8_view(template_payload, 48),
    hour_of_model_version_date: typed_read_u8_view(template_payload, 49),
    minute_of_model_version_date: typed_read_u8_view(template_payload, 50),
    second_of_model_version_date: typed_read_u8_view(template_payload, 51),
    reserved_tail: template_payload.sub(start=52).to_bytes(),
  })
}

///|
fn typed_decode_template_4141(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4141, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 30, "template 4.141") { Ok(_) => (); Err(e) => return Err(e) }

  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 30 + nd * 4 + nf * 4
  match typed_validate_template_min_length(template_payload, required, "template 4.141 wave table payload") { Ok(_) => (); Err(e) => return Err(e) }

  let scaled_wave_directions : Array[Int] = []
  for i in 0..<nd {
    let offset = 29 + i * 4
    scaled_wave_directions.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  let frequency_scale_factor_offset = 29 + nd * 4
  let scaled_wave_frequencies : Array[Int] = []
  for i in 0..<nf {
    let offset = frequency_scale_factor_offset + 1 + i * 4
    scaled_wave_frequencies.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: nd,
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: nf,
    type_of_generating_process: typed_read_u8_view(template_payload, 10),
    background_process_identifier: typed_read_u8_view(template_payload, 11),
    generating_process_identifier: typed_read_u8_view(template_payload, 12),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 13,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 15),
    time_range_unit: typed_read_u8_view(template_payload, 16),
    forecast_time: typed_read_u32_be_view(template_payload, 17),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 21),
    month_of_model_version_date: typed_read_u8_view(template_payload, 23),
    day_of_model_version_date: typed_read_u8_view(template_payload, 24),
    hour_of_model_version_date: typed_read_u8_view(template_payload, 25),
    minute_of_model_version_date: typed_read_u8_view(template_payload, 26),
    second_of_model_version_date: typed_read_u8_view(template_payload, 27),
    scale_factor_of_wave_directions: typed_read_u8_view(template_payload, 28),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: typed_read_u8_view(template_payload, frequency_scale_factor_offset),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4142(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4142, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 39, "template 4.142") { Ok(_) => (); Err(e) => return Err(e) }

  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 39 + nd * 4 + nf * 4
  match typed_validate_template_min_length(template_payload, required, "template 4.142 wave table payload") { Ok(_) => (); Err(e) => return Err(e) }

  let scaled_wave_directions : Array[Int] = []
  for i in 0..<nd {
    let offset = 38 + i * 4
    scaled_wave_directions.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  let frequency_scale_factor_offset = 38 + nd * 4
  let scaled_wave_frequencies : Array[Int] = []
  for i in 0..<nf {
    let offset = frequency_scale_factor_offset + 1 + i * 4
    scaled_wave_frequencies.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: nd,
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: nf,
    type_of_generating_process: typed_read_u8_view(template_payload, 10),
    background_process_identifier: typed_read_u8_view(template_payload, 11),
    generating_process_identifier: typed_read_u8_view(template_payload, 12),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 13,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 15),
    time_range_unit: typed_read_u8_view(template_payload, 16),
    forecast_time: typed_read_u32_be_view(template_payload, 17),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 21),
    perturbation_number: typed_read_u32_be_view(template_payload, 22),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 26,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 30),
    month_of_model_version_date: typed_read_u8_view(template_payload, 32),
    day_of_model_version_date: typed_read_u8_view(template_payload, 33),
    hour_of_model_version_date: typed_read_u8_view(template_payload, 34),
    minute_of_model_version_date: typed_read_u8_view(template_payload, 35),
    second_of_model_version_date: typed_read_u8_view(template_payload, 36),
    scale_factor_of_wave_directions: typed_read_u8_view(template_payload, 37),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: typed_read_u8_view(template_payload, frequency_scale_factor_offset),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4143(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4143, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 52, "template 4.143") { Ok(_) => (); Err(e) => return Err(e) }

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
    random_field_number: typed_read_u16_be_view(template_payload, 13),
    total_number_of_random_fields: typed_read_u16_be_view(template_payload, 15),
    spatio_temporal_scale_number: typed_read_u16_be_view(template_payload, 17),
    total_number_of_spatio_temporal_scales: typed_read_u16_be_view(
      template_payload, 19,
    ),
    scaled_value_of_spatial_scale: typed_read_u32_be_view(template_payload, 21),
    scale_factor_of_spatial_scale: typed_read_u8_view(template_payload, 25),
    scaled_value_of_temporal_scale: typed_read_u32_be_view(template_payload, 26),
    scale_factor_of_temporal_scale: typed_read_u8_view(template_payload, 30),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 31),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 32),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 33,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 37),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 38),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 43),
    perturbation_number: typed_read_u32_be_view(template_payload, 44),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 48,
    ),
    reserved_tail: template_payload.sub(start=52).to_bytes(),
  })
}

///|
fn typed_decode_template_4144(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4144, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 60, "template 4.144") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 43)
  let required = 48 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.144 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 36),
    end_month: typed_read_u8_view(template_payload, 38),
    end_day: typed_read_u8_view(template_payload, 39),
    end_hour: typed_read_u8_view(template_payload, 40),
    end_minute: typed_read_u8_view(template_payload, 41),
    end_second: typed_read_u8_view(template_payload, 42),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 44),
    time_range_specs: typed_decode_time_range_specs(template_payload, 48, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4145(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4145, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 69, "template 4.145") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 52)
  let required = 57 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.145 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 36),
    perturbation_number: typed_read_u32_be_view(template_payload, 37),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 41,
    ),
    end_year: typed_read_u16_be_view(template_payload, 45),
    end_month: typed_read_u8_view(template_payload, 47),
    end_day: typed_read_u8_view(template_payload, 48),
    end_hour: typed_read_u8_view(template_payload, 49),
    end_minute: typed_read_u8_view(template_payload, 50),
    end_second: typed_read_u8_view(template_payload, 51),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 53),
    time_range_specs: typed_decode_time_range_specs(template_payload, 57, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4146(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4146, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 32, "template 4.146") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(template_payload, 27, "template 4.146") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    verification_score: typed_read_u16_be_view(template_payload, 25),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4147(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4147, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 37, "template 4.147") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 32)
  let time_required = 37 + n * 12
  if template_payload.length() < time_required + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.147 verification-score payload too short: expected at least " +
        (time_required + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_48(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(
      template_payload,
      time_required + 2,
      "template 4.147",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    verification_score: typed_read_u16_be_view(template_payload, time_required),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4148(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4148, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 41, "template 4.148") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(template_payload, 36, "template 4.148") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 25),
    perturbation_number: typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 30,
    ),
    verification_score: typed_read_u16_be_view(template_payload, 34),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4149(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4149, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 46, "template 4.149") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 41)
  let time_required = 46 + n * 12
  if template_payload.length() < time_required + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.149 verification-score payload too short: expected at least " +
        (time_required + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(
      template_payload,
      time_required + 2,
      "template 4.149",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 25),
    perturbation_number: typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 30,
    ),
    end_year: typed_read_u16_be_view(template_payload, 34),
    end_month: typed_read_u8_view(template_payload, 36),
    end_day: typed_read_u8_view(template_payload, 37),
    end_hour: typed_read_u8_view(template_payload, 38),
    end_minute: typed_read_u8_view(template_payload, 39),
    end_second: typed_read_u8_view(template_payload, 40),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 42),
    time_range_specs: typed_decode_time_range_specs(template_payload, 46, n),
    verification_score: typed_read_u16_be_view(template_payload, time_required),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
