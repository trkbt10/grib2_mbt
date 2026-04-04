///|
fn typed_decode_template_4100(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4100, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 25, "template 4.100") { Ok(_) => (); Err(e) => return Err(e) }

  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 26 + nd * 4 + nf * 4
  match typed_validate_template_min_length(template_payload, required, "template 4.100 wave table payload") { Ok(_) => (); Err(e) => return Err(e) }

  let scaled_wave_directions : Array[Int] = []
  for i in 0..<nd {
    let offset = 25 + i * 4
    scaled_wave_directions.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  let frequency_scale_factor_offset = 25 + nd * 4
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
    perturbation_number: typed_read_u8_view(template_payload, 22),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 23),
    scale_factor_of_wave_directions: typed_read_u8_view(template_payload, 24),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: typed_read_u8_view(template_payload, frequency_scale_factor_offset),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4101(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4101, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 23, "template 4.101") { Ok(_) => (); Err(e) => return Err(e) }

  let ndsp = typed_read_u8_view(template_payload, 22)
  let direction_params_offset = 23
  let post_direction_offset = direction_params_offset + ndsp * 5
  if template_payload.length() < post_direction_offset + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.101 sequence header too short: expected at least " +
        (post_direction_offset + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let nfsp = typed_read_u8_view(template_payload, post_direction_offset + 1)
  let required = post_direction_offset + 2 + nfsp * 5
  match typed_validate_template_min_length(template_payload, required, "template 4.101 sequence payload") { Ok(_) => (); Err(e) => return Err(e) }

  let wave_direction_sequence_parameters : Array[Grib2WaveSequenceParameter] = []
  for i in 0..<ndsp {
    let offset = direction_params_offset + i * 5
    wave_direction_sequence_parameters.push({
      scale_factor: typed_read_u8_view(template_payload, offset),
      scaled_value: typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  let frequency_params_offset = post_direction_offset + 2
  let wave_frequency_sequence_parameters : Array[Grib2WaveSequenceParameter] = []
  for i in 0..<nfsp {
    let offset = frequency_params_offset + i * 5
    wave_frequency_sequence_parameters.push({
      scale_factor: typed_read_u8_view(template_payload, offset),
      scaled_value: typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: typed_read_u16_be_view(template_payload, 4),
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: typed_read_u16_be_view(template_payload, 8),
    type_of_generating_process: typed_read_u8_view(template_payload, 10),
    background_process_identifier: typed_read_u8_view(template_payload, 11),
    generating_process_identifier: typed_read_u8_view(template_payload, 12),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 13,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 15),
    time_range_unit: typed_read_u8_view(template_payload, 16),
    forecast_time: typed_read_u32_be_view(template_payload, 17),
    type_of_wave_direction_sequence: typed_read_u8_view(template_payload, 21),
    number_of_wave_direction_sequence_parameters: ndsp,
    wave_direction_sequence_parameters,
    type_of_wave_frequency_sequence: typed_read_u8_view(template_payload, post_direction_offset),
    number_of_wave_frequency_sequence_parameters: nfsp,
    wave_frequency_sequence_parameters,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4102(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4102, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 26, "template 4.102") { Ok(_) => (); Err(e) => return Err(e) }

  let ndsp = typed_read_u8_view(template_payload, 25)
  let direction_params_offset = 26
  let post_direction_offset = direction_params_offset + ndsp * 5
  if template_payload.length() < post_direction_offset + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.102 sequence header too short: expected at least " +
        (post_direction_offset + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let nfsp = typed_read_u8_view(template_payload, post_direction_offset + 1)
  let required = post_direction_offset + 2 + nfsp * 5
  match typed_validate_template_min_length(template_payload, required, "template 4.102 sequence payload") { Ok(_) => (); Err(e) => return Err(e) }

  let wave_direction_sequence_parameters : Array[Grib2WaveSequenceParameter] = []
  for i in 0..<ndsp {
    let offset = direction_params_offset + i * 5
    wave_direction_sequence_parameters.push({
      scale_factor: typed_read_u8_view(template_payload, offset),
      scaled_value: typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  let frequency_params_offset = post_direction_offset + 2
  let wave_frequency_sequence_parameters : Array[Grib2WaveSequenceParameter] = []
  for i in 0..<nfsp {
    let offset = frequency_params_offset + i * 5
    wave_frequency_sequence_parameters.push({
      scale_factor: typed_read_u8_view(template_payload, offset),
      scaled_value: typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: typed_read_u16_be_view(template_payload, 4),
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: typed_read_u16_be_view(template_payload, 8),
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
    perturbation_number: typed_read_u8_view(template_payload, 22),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 23),
    type_of_wave_direction_sequence: typed_read_u8_view(template_payload, 24),
    number_of_wave_direction_sequence_parameters: ndsp,
    wave_direction_sequence_parameters,
    type_of_wave_frequency_sequence: typed_read_u8_view(template_payload, post_direction_offset),
    number_of_wave_frequency_sequence_parameters: nfsp,
    wave_frequency_sequence_parameters,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4103(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4103, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 36, "template 4.103") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_wave_period_interval: typed_read_u8_view(template_payload, 2),
    scale_factor_of_lower_wave_period_limit: typed_read_u8_view(template_payload, 3),
    scaled_value_of_lower_wave_period_limit: typed_read_u32_be_view(
      template_payload, 4,
    ),
    scale_factor_of_upper_wave_period_limit: typed_read_u8_view(template_payload, 8),
    scaled_value_of_upper_wave_period_limit: typed_read_u32_be_view(
      template_payload, 9,
    ),
    type_of_generating_process: typed_read_u8_view(template_payload, 13),
    background_process_identifier: typed_read_u8_view(template_payload, 14),
    generating_process_identifier: typed_read_u8_view(template_payload, 15),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 16,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 18),
    time_range_unit: typed_read_u8_view(template_payload, 19),
    forecast_time: typed_read_u32_be_view(template_payload, 20),
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
fn typed_decode_template_4104(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4104, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 39, "template 4.104") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 36),
    perturbation_number: typed_read_u8_view(template_payload, 37),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 38),
  })
}

///|
fn typed_decode_template_4105(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4105, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 37, "template 4.105") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 32)
  let time_required = 37 + n * 12
  if template_payload.length() < time_required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.105 time-range payload too short: expected at least " +
        time_required.to_string() +
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
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, time_required, "template 4.105",
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
fn typed_decode_template_4106(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4106, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 40, "template 4.106") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 32)
  let time_required = 37 + n * 12
  if template_payload.length() < time_required + 3 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.106 ensemble payload too short: expected at least " +
        (time_required + 3).to_string() +
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
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload,
      time_required + 3,
      "template 4.106",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, time_required),
    perturbation_number: typed_read_u8_view(template_payload, time_required + 1),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, time_required + 2),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4107(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4107, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 39, "template 4.107") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 32)
  let time_required = 37 + n * 12
  if template_payload.length() < time_required + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.107 derived payload too short: expected at least " +
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
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload,
      time_required + 2,
      "template 4.107",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: typed_read_u8_view(template_payload, time_required),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, time_required + 1),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4108(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4108, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 36, "template 4.108") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_interval_for_wavelength: typed_read_u8_view(template_payload, 2),
    scale_factor_of_first_wavelength: typed_read_u8_view(template_payload, 3),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 4,
    ),
    scale_factor_of_second_wavelength: typed_read_u8_view(template_payload, 8),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 9,
    ),
    type_of_generating_process: typed_read_u8_view(template_payload, 13),
    background_process_identifier: typed_read_u8_view(template_payload, 14),
    generating_process_identifier: typed_read_u8_view(template_payload, 15),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 16,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 18),
    time_range_unit: typed_read_u8_view(template_payload, 19),
    forecast_time: typed_read_u32_be_view(template_payload, 20),
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
fn typed_decode_template_4109(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4109, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 39, "template 4.109") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4108(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 36),
    perturbation_number: typed_read_u8_view(template_payload, 37),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 38),
  })
}

///|
fn typed_decode_template_4110(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4110, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 60, "template 4.110") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4108(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 43)
  let required = 48 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.110 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

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
fn typed_decode_template_4111(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4111, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 63, "template 4.111") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4109(template_payload.sub(end=39)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 46)
  let required = 51 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.111 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 39),
    end_month: typed_read_u8_view(template_payload, 41),
    end_day: typed_read_u8_view(template_payload, 42),
    end_hour: typed_read_u8_view(template_payload, 43),
    end_minute: typed_read_u8_view(template_payload, 44),
    end_second: typed_read_u8_view(template_payload, 45),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 47),
    time_range_specs: typed_decode_time_range_specs(template_payload, 51, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4112(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4112, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 37, "template 4.112") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 32)
  let time_required = 37 + n * 12
  if template_payload.length() < time_required + 13 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.112 probability payload too short: expected at least " +
        (time_required + 13).to_string() +
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
  let probability_offset = time_required
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload,
      probability_offset + 13,
      "template 4.112",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    forecast_probability_number: typed_read_u8_view(template_payload, probability_offset),
    total_number_of_forecast_probabilities: typed_read_u8_view(template_payload, probability_offset +
    1),
    probability_type: typed_read_u8_view(template_payload, probability_offset + 2),
    scale_factor_of_lower_limit: typed_read_u8_view(template_payload, probability_offset + 3),
    scaled_value_of_lower_limit: typed_read_u32_be_view(
      template_payload,
      probability_offset + 4,
    ),
    scale_factor_of_upper_limit: typed_read_u8_view(template_payload, probability_offset + 8),
    scaled_value_of_upper_limit: typed_read_u32_be_view(
      template_payload,
      probability_offset + 9,
    ),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4113_core(
  template_payload : BytesView,
  process_offset : Int,
  label : String,
) -> Result[Grib2ProductTemplate40, Grib2SectionCodecError] {
  if template_payload.length() < process_offset + 23 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " core payload too short: expected at least " +
        (process_offset + 23).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, process_offset),
    background_process_identifier: typed_read_u8_view(template_payload, process_offset + 1),
    generating_process_identifier: typed_read_u8_view(template_payload, process_offset + 2),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      process_offset + 3,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, process_offset + 5),
    time_range_unit: typed_read_u8_view(template_payload, process_offset + 6),
    forecast_time: typed_read_u32_be_view(template_payload, process_offset + 7),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, process_offset + 11),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, process_offset + 12),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      process_offset + 13,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, process_offset + 17),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, process_offset + 18),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      process_offset + 19,
    ),
  })
}

///|
fn typed_decode_template_4113(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4113, Grib2SectionCodecError] {
  let (tile, process_offset) = match
    typed_decode_generalized_tile_definition(template_payload, "template 4.113") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  let base = match
    typed_decode_template_4113_core(
      template_payload, process_offset, "template 4.113",
    ) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let required = process_offset + 23
  Ok({
    base,
    tile,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4114(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4114, Grib2SectionCodecError] {
  let (tile, process_offset) = match
    typed_decode_generalized_tile_definition(template_payload, "template 4.114") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  if template_payload.length() < process_offset + 35 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.114 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_4113_core(
      template_payload, process_offset, "template 4.114",
    ) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, process_offset + 30)
  let required = process_offset + 35 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.114 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base: { base, tile, reserved_tail: b"" },
    end_year: typed_read_u16_be_view(template_payload, process_offset + 23),
    end_month: typed_read_u8_view(template_payload, process_offset + 25),
    end_day: typed_read_u8_view(template_payload, process_offset + 26),
    end_hour: typed_read_u8_view(template_payload, process_offset + 27),
    end_minute: typed_read_u8_view(template_payload, process_offset + 28),
    end_second: typed_read_u8_view(template_payload, process_offset + 29),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      process_offset + 31,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      process_offset + 35,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4115(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4115, Grib2SectionCodecError] {
  let (tile, process_offset) = match
    typed_decode_generalized_tile_definition(template_payload, "template 4.115") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  let required = process_offset + 32
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.115 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_4113_core(
      template_payload, process_offset, "template 4.115",
    ) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base: { base, tile, reserved_tail: b"" },
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, process_offset + 23),
    perturbation_number: typed_read_u32_be_view(
      template_payload,
      process_offset + 24,
    ),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload,
      process_offset + 28,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4116(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4116, Grib2SectionCodecError] {
  let (tile, process_offset) = match
    typed_decode_generalized_tile_definition(template_payload, "template 4.116") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  if template_payload.length() < process_offset + 44 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.116 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_4113_core(
      template_payload, process_offset, "template 4.116",
    ) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, process_offset + 39)
  let required = process_offset + 44 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.116 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base: {
      base: { base, tile, reserved_tail: b"" },
      type_of_ensemble_forecast: typed_read_u8_view(template_payload, process_offset + 23),
      perturbation_number: typed_read_u32_be_view(
        template_payload,
        process_offset + 24,
      ),
      number_of_forecasts_in_ensemble: typed_read_u32_be_view(
        template_payload,
        process_offset + 28,
      ),
      reserved_tail: b"",
    },
    end_year: typed_read_u16_be_view(template_payload, process_offset + 32),
    end_month: typed_read_u8_view(template_payload, process_offset + 34),
    end_day: typed_read_u8_view(template_payload, process_offset + 35),
    end_hour: typed_read_u8_view(template_payload, process_offset + 36),
    end_minute: typed_read_u8_view(template_payload, process_offset + 37),
    end_second: typed_read_u8_view(template_payload, process_offset + 38),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      process_offset + 40,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      process_offset + 44,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4117(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4117, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 34, "template 4.117") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 25),
    perturbation_number: typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 30,
    ),
    reserved_tail: template_payload.sub(start=34).to_bytes(),
  })
}

///|
fn typed_decode_template_4118(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4118, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 46, "template 4.118") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4117(template_payload.sub(end=34)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 41)
  let required = 46 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.118 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 34),
    end_month: typed_read_u8_view(template_payload, 36),
    end_day: typed_read_u8_view(template_payload, 37),
    end_hour: typed_read_u8_view(template_payload, 38),
    end_minute: typed_read_u8_view(template_payload, 39),
    end_second: typed_read_u8_view(template_payload, 40),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 42),
    time_range_specs: typed_decode_time_range_specs(template_payload, 46, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4119(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4119, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 43, "template 4.119") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 26,
    ),
    forecast_probability_number: typed_read_u8_view(template_payload, 30),
    total_number_of_forecast_probabilities: typed_read_u8_view(template_payload, 31),
    probability_type: typed_read_u8_view(template_payload, 32),
    scale_factor_of_lower_limit: typed_read_u8_view(template_payload, 33),
    scaled_value_of_lower_limit: typed_read_u32_be_view(template_payload, 34),
    scale_factor_of_upper_limit: typed_read_u8_view(template_payload, 38),
    scaled_value_of_upper_limit: typed_read_u32_be_view(template_payload, 39),
    reserved_tail: template_payload.sub(start=43).to_bytes(),
  })
}

///|
fn typed_decode_template_4120(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4120, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 55, "template 4.120") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4119(template_payload.sub(end=43)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 50)
  let required = 55 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.120 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 43),
    end_month: typed_read_u8_view(template_payload, 45),
    end_day: typed_read_u8_view(template_payload, 46),
    end_hour: typed_read_u8_view(template_payload, 47),
    end_minute: typed_read_u8_view(template_payload, 48),
    end_second: typed_read_u8_view(template_payload, 49),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 51),
    time_range_specs: typed_decode_time_range_specs(template_payload, 55, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4121(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4121, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 43, "template 4.121") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4119(template_payload.sub(end=43)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (spatial_vicinity, required) = match
    typed_decode_spatial_vicinity_definition(
      template_payload, 43, "template 4.121",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    spatial_vicinity,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4122(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4122, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 55, "template 4.122") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 50)
  let time_required = 55 + n * 12
  if template_payload.length() < time_required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.122 time-range payload too short: expected at least " +
        time_required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_4120(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (spatial_vicinity, required) = match
    typed_decode_spatial_vicinity_definition(
      template_payload, time_required, "template 4.122",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    spatial_vicinity,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4123(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4123, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 37, "template 4.123") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 32)
  let time_required = 37 + n * 12
  if template_payload.length() < time_required + 18 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.123 ensemble/probability payload too short: expected at least " +
        (time_required + 18).to_string() +
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
  let offset = time_required
  let (reference_period, reference_required) = match
    typed_decode_reference_period_definition(
      template_payload,
      offset + 18,
      "template 4.123",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  let (spatial_vicinity, required) = match
    typed_decode_spatial_vicinity_definition(
      template_payload, reference_required, "template 4.123",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, offset),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload,
      offset + 1,
    ),
    forecast_probability_number: typed_read_u8_view(template_payload, offset + 5),
    total_number_of_forecast_probabilities: typed_read_u8_view(template_payload, offset + 6),
    probability_type: typed_read_u8_view(template_payload, offset + 7),
    scale_factor_of_lower_limit: typed_read_u8_view(template_payload, offset + 8),
    scaled_value_of_lower_limit: typed_read_u32_be_view(
      template_payload,
      offset + 9,
    ),
    scale_factor_of_upper_limit: typed_read_u8_view(template_payload, offset + 13),
    scaled_value_of_upper_limit: typed_read_u32_be_view(
      template_payload,
      offset + 14,
    ),
    reference_period,
    spatial_vicinity,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4124(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4124, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 50, "template 4.124") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    source_or_sink: typed_read_u8_view(template_payload, 4),
    transport_model_used: typed_read_u16_be_view(template_payload, 5),
    requested_by_entity: typed_read_u16_be_view(template_payload, 7),
    scenario_origin: typed_read_u16_be_view(template_payload, 9),
    nwp_used: typed_read_u16_be_view(template_payload, 11),
    release_start_year: typed_read_u16_be_view(template_payload, 13),
    release_start_month: typed_read_u8_view(template_payload, 15),
    release_start_day: typed_read_u16_be_view(template_payload, 16),
    release_start_hour: typed_read_u8_view(template_payload, 18),
    release_start_minute: typed_read_u8_view(template_payload, 19),
    wall_clock_initial_year: typed_read_u16_be_view(template_payload, 20),
    wall_clock_initial_month: typed_read_u8_view(template_payload, 22),
    wall_clock_initial_day: typed_read_u8_view(template_payload, 23),
    wall_clock_initial_hour: typed_read_u8_view(template_payload, 24),
    wall_clock_initial_minute: typed_read_u8_view(template_payload, 25),
    wall_clock_initial_second: typed_read_u8_view(template_payload, 26),
    type_of_generating_process: typed_read_u8_view(template_payload, 27),
    background_process_identifier: typed_read_u8_view(template_payload, 28),
    generating_process_identifier: typed_read_u8_view(template_payload, 29),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 30,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 32),
    time_range_unit: typed_read_u8_view(template_payload, 33),
    forecast_time: typed_read_u32_be_view(template_payload, 34),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 38),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 39),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 40,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 44),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 45),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 46,
    ),
    reserved_tail: template_payload.sub(start=50).to_bytes(),
  })
}

///|
fn typed_decode_template_4125(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4125, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 53, "template 4.125") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4124(template_payload.sub(end=50)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 50),
    perturbation_number: typed_read_u8_view(template_payload, 51),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 52),
    reserved_tail: template_payload.sub(start=53).to_bytes(),
  })
}

///|
fn typed_decode_template_4126(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4126, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 62, "template 4.126") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 57)
  let required = 62 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.126 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    source_or_sink: typed_read_u8_view(template_payload, 4),
    transport_model_used: typed_read_u16_be_view(template_payload, 5),
    requested_by_entity: typed_read_u16_be_view(template_payload, 7),
    scenario_origin: typed_read_u16_be_view(template_payload, 9),
    nwp_used: typed_read_u16_be_view(template_payload, 11),
    release_start_year: typed_read_u16_be_view(template_payload, 13),
    release_start_month: typed_read_u8_view(template_payload, 15),
    release_start_day: typed_read_u8_view(template_payload, 16),
    release_start_hour: typed_read_u8_view(template_payload, 17),
    release_start_minute: typed_read_u8_view(template_payload, 18),
    release_start_second: typed_read_u8_view(template_payload, 19),
    wall_clock_initial_year: typed_read_u16_be_view(template_payload, 20),
    wall_clock_initial_month: typed_read_u8_view(template_payload, 22),
    wall_clock_initial_day: typed_read_u8_view(template_payload, 23),
    wall_clock_initial_hour: typed_read_u8_view(template_payload, 24),
    wall_clock_initial_minute: typed_read_u8_view(template_payload, 25),
    wall_clock_initial_second: typed_read_u8_view(template_payload, 26),
    type_of_generating_process: typed_read_u8_view(template_payload, 27),
    background_process_identifier: typed_read_u8_view(template_payload, 28),
    generating_process_identifier: typed_read_u8_view(template_payload, 29),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 30,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 32),
    time_range_unit: typed_read_u8_view(template_payload, 33),
    forecast_time: typed_read_u32_be_view(template_payload, 34),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 38),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 39),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 40,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 44),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 45),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 46,
    ),
    end_year: typed_read_u16_be_view(template_payload, 50),
    end_month: typed_read_u8_view(template_payload, 52),
    end_day: typed_read_u8_view(template_payload, 53),
    end_hour: typed_read_u8_view(template_payload, 54),
    end_minute: typed_read_u8_view(template_payload, 55),
    end_second: typed_read_u8_view(template_payload, 56),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 58),
    time_range_specs: typed_decode_time_range_specs(template_payload, 62, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4127(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4127, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 65, "template 4.127") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 60)
  let required = 65 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.127 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base: {
      parameter_category: typed_read_u8_view(template_payload, 0),
      parameter_number: typed_read_u8_view(template_payload, 1),
      atmospheric_chemical_constituent_type: typed_read_u16_be_view(
        template_payload, 2,
      ),
      source_or_sink: typed_read_u8_view(template_payload, 4),
      transport_model_used: typed_read_u16_be_view(template_payload, 5),
      requested_by_entity: typed_read_u16_be_view(template_payload, 7),
      scenario_origin: typed_read_u16_be_view(template_payload, 9),
      nwp_used: typed_read_u16_be_view(template_payload, 11),
      release_start_year: typed_read_u16_be_view(template_payload, 13),
      release_start_month: typed_read_u8_view(template_payload, 15),
      release_start_day: typed_read_u8_view(template_payload, 16),
      release_start_hour: typed_read_u8_view(template_payload, 17),
      release_start_minute: typed_read_u8_view(template_payload, 18),
      release_start_second: typed_read_u8_view(template_payload, 19),
      wall_clock_initial_year: typed_read_u16_be_view(template_payload, 20),
      wall_clock_initial_month: typed_read_u8_view(template_payload, 22),
      wall_clock_initial_day: typed_read_u8_view(template_payload, 23),
      wall_clock_initial_hour: typed_read_u8_view(template_payload, 24),
      wall_clock_initial_minute: typed_read_u8_view(template_payload, 25),
      wall_clock_initial_second: typed_read_u8_view(template_payload, 26),
      type_of_generating_process: typed_read_u8_view(template_payload, 27),
      background_process_identifier: typed_read_u8_view(template_payload, 28),
      generating_process_identifier: typed_read_u8_view(template_payload, 29),
      hours_of_observational_data_cutoff: typed_read_u16_be_view(
        template_payload, 30,
      ),
      minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 32),
      time_range_unit: typed_read_u8_view(template_payload, 33),
      forecast_time: typed_read_u32_be_view(template_payload, 34),
      type_of_first_fixed_surface: typed_read_u8_view(template_payload, 38),
      scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 39),
      scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
        template_payload, 40,
      ),
      type_of_second_fixed_surface: typed_read_u8_view(template_payload, 44),
      scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 45),
      scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
        template_payload, 46,
      ),
      end_year: typed_read_u16_be_view(template_payload, 53),
      end_month: typed_read_u8_view(template_payload, 55),
      end_day: typed_read_u8_view(template_payload, 56),
      end_hour: typed_read_u8_view(template_payload, 57),
      end_minute: typed_read_u8_view(template_payload, 58),
      end_second: typed_read_u8_view(template_payload, 59),
      number_of_time_ranges: n,
      number_of_missing_values: typed_read_u32_be_view(template_payload, 61),
      time_range_specs: typed_decode_time_range_specs(template_payload, 65, n),
      reserved_tail: b"",
    },
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 50),
    perturbation_number: typed_read_u8_view(template_payload, 51),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 52),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4128(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4128, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 40, "template 4.128") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 25, "template 4.128",
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
fn typed_decode_template_4129(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4129, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 43, "template 4.129") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 28, "template 4.129",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 25),
    perturbation_number: typed_read_u8_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 27),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
