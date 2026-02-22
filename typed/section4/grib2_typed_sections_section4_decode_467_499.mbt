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

///|
fn typed_decode_template_490(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate490, Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.90 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[41].to_uint().reinterpret_as_int()
  let required = 46 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.90 time-range payload too short: expected at least " +
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
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 30),
    quantile_value: typed_read_u16_be_view(template_payload, 32),
    end_year: typed_read_u16_be_view(template_payload, 34),
    end_month: template_payload[36].to_uint().reinterpret_as_int(),
    end_day: template_payload[37].to_uint().reinterpret_as_int(),
    end_hour: template_payload[38].to_uint().reinterpret_as_int(),
    end_minute: template_payload[39].to_uint().reinterpret_as_int(),
    end_second: template_payload[40].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 42),
    time_range_specs: typed_decode_time_range_specs(template_payload, 46, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_491(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate491, Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.91 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nc = template_payload[25].to_uint().reinterpret_as_int()
  let categories_offset = 26
  let categories_length = nc * 12
  let post_categories_offset = categories_offset + categories_length
  if template_payload.length() < post_categories_offset + 12 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.91 category payload too short: expected at least " +
        (post_categories_offset + 12).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let categories : Array[Grib2CategoryForecastSpec] = []
  for i in 0..<nc {
    let offset = categories_offset + i * 12
    categories.push({
      code_figure: template_payload[offset].to_uint().reinterpret_as_int(),
      type_of_interval_for_first_and_second_limit: template_payload[offset + 1]
      .to_uint()
      .reinterpret_as_int(),
      scale_factor_of_first_limit: template_payload[offset + 2]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_first_limit: typed_read_u32_be_view(
        template_payload,
        offset + 3,
      ),
      scale_factor_of_second_limit: template_payload[offset + 7]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_second_limit: typed_read_u32_be_view(
        template_payload,
        offset + 8,
      ),
    })
  }
  let n = template_payload[post_categories_offset + 7]
    .to_uint()
    .reinterpret_as_int()
  let required = post_categories_offset + 12 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.91 time-range payload too short: expected at least " +
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
    number_of_categories: nc,
    categories,
    end_year: typed_read_u16_be_view(template_payload, post_categories_offset),
    end_month: template_payload[post_categories_offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    end_day: template_payload[post_categories_offset + 3]
    .to_uint()
    .reinterpret_as_int(),
    end_hour: template_payload[post_categories_offset + 4]
    .to_uint()
    .reinterpret_as_int(),
    end_minute: template_payload[post_categories_offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    end_second: template_payload[post_categories_offset + 6]
    .to_uint()
    .reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      post_categories_offset + 8,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      post_categories_offset + 12,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_492(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate492, Grib2SectionCodecError] {
  if template_payload.length() < 40 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.92 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[21].to_uint().reinterpret_as_int()
  let required = 22 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.92 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 22 + i * 18
    forecast_specs.push({
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
    type_of_ensemble_forecast: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[18].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    method_used_to_derive_data_field_values_at_local_time: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_493(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate493, Grib2SectionCodecError] {
  if template_payload.length() < 42 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.93 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[23].to_uint().reinterpret_as_int()
  let required = 24 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.93 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 24 + i * 18
    forecast_specs.push({
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
    type_of_first_fixed_surface: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    method_used_to_derive_data_field_values_at_local_time: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_494(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate494, Grib2SectionCodecError] {
  if template_payload.length() < 45 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.94 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[26].to_uint().reinterpret_as_int()
  let required = 27 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.94 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 27 + i * 18
    forecast_specs.push({
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
    type_of_first_fixed_surface: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_ensemble_forecast: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[23].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    method_used_to_derive_data_field_values_at_local_time: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_495(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate495, Grib2SectionCodecError] {
  if template_payload.length() < 44 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.95 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[25].to_uint().reinterpret_as_int()
  let required = 26 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.95 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 26 + i * 18
    forecast_specs.push({
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
    statistical_process_used_to_calculate_fields_for_local_time_processing: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_unit: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 19,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    method_used_to_derive_data_field_values_at_local_time: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_496(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate496, Grib2SectionCodecError] {
  if template_payload.length() < 47 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.96 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[28].to_uint().reinterpret_as_int()
  let required = 29 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.96 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 29 + i * 18
    forecast_specs.push({
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
    type_of_ensemble_forecast: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[18].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    statistical_process_used_to_calculate_fields_for_local_time_processing: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_unit: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 22,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    method_used_to_derive_data_field_values_at_local_time: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_497(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate497, Grib2SectionCodecError] {
  if template_payload.length() < 49 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.97 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[30].to_uint().reinterpret_as_int()
  let required = 31 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.97 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 31 + i * 18
    forecast_specs.push({
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
    type_of_first_fixed_surface: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    statistical_process_used_to_calculate_fields_for_local_time_processing: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_unit: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 24,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    method_used_to_derive_data_field_values_at_local_time: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_498(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate498, Grib2SectionCodecError] {
  if template_payload.length() < 34 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.98 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[33].to_uint().reinterpret_as_int()
  let required = 34 + n * 18
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.98 forecast payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 34 + i * 18
    forecast_specs.push({
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
    type_of_first_fixed_surface: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_ensemble_forecast: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[23].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    statistical_process_used_to_calculate_fields_for_local_time_processing: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_unit: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 27,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    method_used_to_derive_data_field_values_at_local_time: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_499(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate499, Grib2SectionCodecError] {
  if template_payload.length() < 22 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.99 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 23 + nd * 4 + nf * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.99 wave table payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let scaled_wave_directions : Array[Int] = []
  for i in 0..<nd {
    let offset = 22 + i * 4
    scaled_wave_directions.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  let frequency_scale_factor_offset = 22 + nd * 4
  let scaled_wave_frequencies : Array[Int] = []
  for i in 0..<nf {
    let offset = frequency_scale_factor_offset + 1 + i * 4
    scaled_wave_frequencies.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: nd,
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: nf,
    type_of_generating_process: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 13,
    ),
    minutes_of_observational_data_cutoff: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[16].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 17),
    scale_factor_of_wave_directions: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: template_payload[frequency_scale_factor_offset]
    .to_uint()
    .reinterpret_as_int(),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
