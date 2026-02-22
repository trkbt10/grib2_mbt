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
