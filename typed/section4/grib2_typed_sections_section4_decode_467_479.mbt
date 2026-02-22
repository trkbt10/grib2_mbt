///|
fn typed_decode_template_467(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate467, Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.67 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let n_offset = 41 + np * 5
  if template_payload.length() <= n_offset {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.67 missing number_of_time_ranges octet: got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[n_offset].to_uint().reinterpret_as_int()
  let required = 46 + np * 5 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.67 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let p_offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: template_payload[p_offset]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_fixed_distribution_function_parameter: typed_read_u32_be_view(
        template_payload,
        p_offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: typed_read_u16_be_view(template_payload, 4),
    mode_number: typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    end_year: typed_read_u16_be_view(template_payload, offset + 23),
    end_month: template_payload[offset + 25].to_uint().reinterpret_as_int(),
    end_day: template_payload[offset + 26].to_uint().reinterpret_as_int(),
    end_hour: template_payload[offset + 27].to_uint().reinterpret_as_int(),
    end_minute: template_payload[offset + 28].to_uint().reinterpret_as_int(),
    end_second: template_payload[offset + 29].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
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
) -> Result[Grib2ProductTemplate468, Grib2SectionCodecError] {
  if template_payload.length() < 49 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.68 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let n_offset = 44 + np * 5
  if template_payload.length() <= n_offset {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.68 missing number_of_time_ranges octet: got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[n_offset].to_uint().reinterpret_as_int()
  let required = 49 + np * 5 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.68 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let p_offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: template_payload[p_offset]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_fixed_distribution_function_parameter: typed_read_u32_be_view(
        template_payload,
        p_offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: typed_read_u16_be_view(template_payload, 4),
    mode_number: typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: template_payload[offset + 23]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[offset + 24]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[offset + 25]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, offset + 26),
    end_month: template_payload[offset + 28].to_uint().reinterpret_as_int(),
    end_day: template_payload[offset + 29].to_uint().reinterpret_as_int(),
    end_hour: template_payload[offset + 30].to_uint().reinterpret_as_int(),
    end_minute: template_payload[offset + 31].to_uint().reinterpret_as_int(),
    end_second: template_payload[offset + 32].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
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
) -> Result[Grib2ProductTemplate470, Grib2SectionCodecError] {
  if template_payload.length() != 30 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.70 expected 30 octets, got " +
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
  })
}

///|
fn typed_decode_template_471(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate471, Grib2SectionCodecError] {
  if template_payload.length() != 33 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.71 expected 33 octets, got " +
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
    type_of_ensemble_forecast: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[31].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_472(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate472, Grib2SectionCodecError] {
  if template_payload.length() < 42 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.72 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[37].to_uint().reinterpret_as_int()
  let required = 42 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.72 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
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
fn typed_decode_template_473(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate473, Grib2SectionCodecError] {
  if template_payload.length() < 45 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.73 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[40].to_uint().reinterpret_as_int()
  let required = 45 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.73 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
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
    type_of_ensemble_forecast: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[31].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 33),
    end_month: template_payload[35].to_uint().reinterpret_as_int(),
    end_day: template_payload[36].to_uint().reinterpret_as_int(),
    end_hour: template_payload[37].to_uint().reinterpret_as_int(),
    end_minute: template_payload[38].to_uint().reinterpret_as_int(),
    end_second: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 41),
    time_range_specs: typed_decode_time_range_specs(template_payload, 45, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_476(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate476, Grib2SectionCodecError] {
  if template_payload.length() != 28 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.76 expected 28 octets, got " +
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
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 8,
    ),
    minutes_of_observational_data_cutoff: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[11].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 12),
    type_of_first_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_second_fixed_surface: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 24,
    ),
  })
}

///|
fn typed_decode_template_477(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate477, Grib2SectionCodecError] {
  if template_payload.length() != 31 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.77 expected 31 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_476(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[29].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_478(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate478, Grib2SectionCodecError] {
  if template_payload.length() < 40 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.78 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_476(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[35].to_uint().reinterpret_as_int()
  let required = 40 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.78 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 28),
    end_month: template_payload[30].to_uint().reinterpret_as_int(),
    end_day: template_payload[31].to_uint().reinterpret_as_int(),
    end_hour: template_payload[32].to_uint().reinterpret_as_int(),
    end_minute: template_payload[33].to_uint().reinterpret_as_int(),
    end_second: template_payload[34].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 36),
    time_range_specs: typed_decode_time_range_specs(template_payload, 40, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_479(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate479, Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.79 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_477(template_payload.sub(end=31)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[38].to_uint().reinterpret_as_int()
  let required = 43 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.79 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 31),
    end_month: template_payload[33].to_uint().reinterpret_as_int(),
    end_day: template_payload[34].to_uint().reinterpret_as_int(),
    end_hour: template_payload[35].to_uint().reinterpret_as_int(),
    end_minute: template_payload[36].to_uint().reinterpret_as_int(),
    end_second: template_payload[37].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 39),
    time_range_specs: typed_decode_time_range_specs(template_payload, 43, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
