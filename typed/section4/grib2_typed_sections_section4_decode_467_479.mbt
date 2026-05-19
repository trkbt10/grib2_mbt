///|
fn typed_decode_template_467(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate467, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 46, "template 4.67") { Ok(_) => (); Err(e) => return Err(e) }

  let np = @section1.typed_read_u8_view(template_payload, 10)
  let n_offset = 41 + np * 5
  if template_payload.length() <= n_offset {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.67 missing number_of_time_ranges octet: got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let n = @section1.typed_read_u8_view(template_payload, n_offset)
  let required = 46 + np * 5 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.67 payload") { Ok(_) => (); Err(e) => return Err(e) }

  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let p_offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: @section1.typed_read_u8_view(template_payload, p_offset),
      scaled_value_of_fixed_distribution_function_parameter: @section1.typed_read_u32_be_view(
        template_payload,
        p_offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: @section1.typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: @section1.typed_read_u16_be_view(template_payload, 4),
    mode_number: @section1.typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: @section1.typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, offset),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 1),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 2),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, offset + 5),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 11),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 12),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 17),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 18),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    end_year: @section1.typed_read_u16_be_view(template_payload, offset + 23),
    end_month: @section1.typed_read_u8_view(template_payload, offset + 25),
    end_day: @section1.typed_read_u8_view(template_payload, offset + 26),
    end_hour: @section1.typed_read_u8_view(template_payload, offset + 27),
    end_minute: @section1.typed_read_u8_view(template_payload, offset + 28),
    end_second: @section1.typed_read_u8_view(template_payload, offset + 29),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 31,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      offset + 35,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_468(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate468, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 49, "template 4.68") { Ok(_) => (); Err(e) => return Err(e) }

  let np = @section1.typed_read_u8_view(template_payload, 10)
  let n_offset = 44 + np * 5
  if template_payload.length() <= n_offset {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.68 missing number_of_time_ranges octet: got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let n = @section1.typed_read_u8_view(template_payload, n_offset)
  let required = 49 + np * 5 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.68 payload") { Ok(_) => (); Err(e) => return Err(e) }

  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let p_offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: @section1.typed_read_u8_view(template_payload, p_offset),
      scaled_value_of_fixed_distribution_function_parameter: @section1.typed_read_u32_be_view(
        template_payload,
        p_offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: @section1.typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: @section1.typed_read_u16_be_view(template_payload, 4),
    mode_number: @section1.typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: @section1.typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, offset),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 1),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 2),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, offset + 5),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 11),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 12),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 17),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 18),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, offset + 23),
    perturbation_number: @section1.typed_read_u8_view(template_payload, offset + 24),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, offset + 25),
    end_year: @section1.typed_read_u16_be_view(template_payload, offset + 26),
    end_month: @section1.typed_read_u8_view(template_payload, offset + 28),
    end_day: @section1.typed_read_u8_view(template_payload, offset + 29),
    end_hour: @section1.typed_read_u8_view(template_payload, offset + 30),
    end_minute: @section1.typed_read_u8_view(template_payload, offset + 31),
    end_second: @section1.typed_read_u8_view(template_payload, offset + 32),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 34,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      offset + 38,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_470(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate470, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 30, "template 4.70") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    input_process_identifier: @section1.typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: @section1.typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: @section1.typed_read_u8_view(template_payload, 6),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 7),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 8),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 10,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 12),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 13),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 14),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 18),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 20,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 24),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 26,
    ),
  })
}

///|
fn typed_decode_template_471(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate471, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 33, "template 4.71") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    input_process_identifier: @section1.typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: @section1.typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: @section1.typed_read_u8_view(template_payload, 6),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 7),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 8),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 10,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 12),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 13),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 14),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 18),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 20,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 24),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 26,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 30),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 31),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 32),
  })
}

///|
fn typed_decode_template_472(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate472, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 42, "template 4.72") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 37)
  let required = 42 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.72 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    input_process_identifier: @section1.typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: @section1.typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: @section1.typed_read_u8_view(template_payload, 6),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 7),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 8),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 10,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 12),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 13),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 14),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 18),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 20,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 24),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 26,
    ),
    end_year: @section1.typed_read_u16_be_view(template_payload, 30),
    end_month: @section1.typed_read_u8_view(template_payload, 32),
    end_day: @section1.typed_read_u8_view(template_payload, 33),
    end_hour: @section1.typed_read_u8_view(template_payload, 34),
    end_minute: @section1.typed_read_u8_view(template_payload, 35),
    end_second: @section1.typed_read_u8_view(template_payload, 36),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 38),
    time_range_specs: typed_decode_time_range_specs(template_payload, 42, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_473(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate473, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 45, "template 4.73") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 40)
  let required = 45 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.73 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    input_process_identifier: @section1.typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: @section1.typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: @section1.typed_read_u8_view(template_payload, 6),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 7),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 8),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 10,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 12),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 13),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 14),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 18),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 20,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 24),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 26,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 30),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 31),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 32),
    end_year: @section1.typed_read_u16_be_view(template_payload, 33),
    end_month: @section1.typed_read_u8_view(template_payload, 35),
    end_day: @section1.typed_read_u8_view(template_payload, 36),
    end_hour: @section1.typed_read_u8_view(template_payload, 37),
    end_minute: @section1.typed_read_u8_view(template_payload, 38),
    end_second: @section1.typed_read_u8_view(template_payload, 39),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 41),
    time_range_specs: typed_decode_time_range_specs(template_payload, 45, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_476(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate476, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 28, "template 4.76") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: @section1.typed_read_u16_be_view(
      template_payload, 2,
    ),
    source_or_sink: @section1.typed_read_u8_view(template_payload, 4),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 5),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 6),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 7),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 8,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 10),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 11),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 12),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 16),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 17),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 22),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 23),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 24,
    ),
  })
}

///|
fn typed_decode_template_477(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate477, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 31, "template 4.77") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_476(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 28),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 29),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 30),
  })
}

///|
fn typed_decode_template_478(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate478, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 40, "template 4.78") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_476(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 35)
  let required = 40 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.78 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 28),
    end_month: @section1.typed_read_u8_view(template_payload, 30),
    end_day: @section1.typed_read_u8_view(template_payload, 31),
    end_hour: @section1.typed_read_u8_view(template_payload, 32),
    end_minute: @section1.typed_read_u8_view(template_payload, 33),
    end_second: @section1.typed_read_u8_view(template_payload, 34),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 36),
    time_range_specs: typed_decode_time_range_specs(template_payload, 40, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_479(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate479, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 43, "template 4.79") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_477(template_payload.sub(end=31)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 38)
  let required = 43 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.79 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 31),
    end_month: @section1.typed_read_u8_view(template_payload, 33),
    end_day: @section1.typed_read_u8_view(template_payload, 34),
    end_hour: @section1.typed_read_u8_view(template_payload, 35),
    end_minute: @section1.typed_read_u8_view(template_payload, 36),
    end_second: @section1.typed_read_u8_view(template_payload, 37),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 39),
    time_range_specs: typed_decode_time_range_specs(template_payload, 43, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
