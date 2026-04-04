///|
fn typed_decode_template_490(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate490, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 46, "template 4.90") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 41)
  let required = 46 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.90 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    input_process_identifier: typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: typed_read_u8_view(template_payload, 6),
    type_of_generating_process: typed_read_u8_view(template_payload, 7),
    background_process_identifier: typed_read_u8_view(template_payload, 8),
    generating_process_identifier: typed_read_u8_view(template_payload, 9),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 10,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 12),
    time_range_unit: typed_read_u8_view(template_payload, 13),
    forecast_time: typed_read_u32_be_view(template_payload, 14),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 18),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 19),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 20,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 24),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 25),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 26,
    ),
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 30),
    quantile_value: typed_read_u16_be_view(template_payload, 32),
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
fn typed_decode_template_491(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate491, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 26, "template 4.91") { Ok(_) => (); Err(e) => return Err(e) }

  let nc = typed_read_u8_view(template_payload, 25)
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
      code_figure: typed_read_u8_view(template_payload, offset),
      type_of_interval_for_first_and_second_limit: typed_read_u8_view(template_payload, offset + 1),
      scale_factor_of_first_limit: typed_read_u8_view(template_payload, offset + 2),
      scaled_value_of_first_limit: typed_read_u32_be_view(
        template_payload,
        offset + 3,
      ),
      scale_factor_of_second_limit: typed_read_u8_view(template_payload, offset + 7),
      scaled_value_of_second_limit: typed_read_u32_be_view(
        template_payload,
        offset + 8,
      ),
    })
  }
  let n = typed_read_u8_view(template_payload, post_categories_offset + 7)
  let required = post_categories_offset + 12 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.91 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

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
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 13),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 14),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 15,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 19),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 20),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    number_of_categories: nc,
    categories,
    end_year: typed_read_u16_be_view(template_payload, post_categories_offset),
    end_month: typed_read_u8_view(template_payload, post_categories_offset + 2),
    end_day: typed_read_u8_view(template_payload, post_categories_offset + 3),
    end_hour: typed_read_u8_view(template_payload, post_categories_offset + 4),
    end_minute: typed_read_u8_view(template_payload, post_categories_offset + 5),
    end_second: typed_read_u8_view(template_payload, post_categories_offset + 6),
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
  match typed_validate_template_min_length(template_payload, 40, "template 4.92") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 21)
  let required = 22 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.92 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 22 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    background_process_identifier: typed_read_u8_view(template_payload, 3),
    generating_process_identifier: typed_read_u8_view(template_payload, 4),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 7,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 11),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 12),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 13,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 17),
    perturbation_number: typed_read_u8_view(template_payload, 18),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 19),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 20),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_493(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate493, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 42, "template 4.93") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 23)
  let required = 24 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.93 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 24 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    input_process_identifier: typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: typed_read_u8_view(template_payload, 6),
    type_of_generating_process: typed_read_u8_view(template_payload, 7),
    background_process_identifier: typed_read_u8_view(template_payload, 8),
    generating_process_identifier: typed_read_u8_view(template_payload, 9),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 10),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 11),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 16),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 17),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 22),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_494(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate494, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 45, "template 4.94") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 26)
  let required = 27 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.94 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 27 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    input_process_identifier: typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: typed_read_u8_view(template_payload, 6),
    type_of_generating_process: typed_read_u8_view(template_payload, 7),
    background_process_identifier: typed_read_u8_view(template_payload, 8),
    generating_process_identifier: typed_read_u8_view(template_payload, 9),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 10),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 11),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 16),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 17),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 22),
    perturbation_number: typed_read_u8_view(template_payload, 23),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 24),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 25),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_495(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate495, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 44, "template 4.95") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 25)
  let required = 26 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.95 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 26 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    background_process_identifier: typed_read_u8_view(template_payload, 3),
    generating_process_identifier: typed_read_u8_view(template_payload, 4),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 7,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 11),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 12),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 13,
    ),
    statistical_process_used_to_calculate_fields_for_local_time_processing: typed_read_u8_view(template_payload, 17),
    statistical_processing_time_range_unit: typed_read_u8_view(template_payload, 18),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 19,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: typed_read_u8_view(template_payload, 23),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 24),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_496(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate496, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 47, "template 4.96") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 28)
  let required = 29 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.96 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 29 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    background_process_identifier: typed_read_u8_view(template_payload, 3),
    generating_process_identifier: typed_read_u8_view(template_payload, 4),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 7,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 11),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 12),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 13,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 17),
    perturbation_number: typed_read_u8_view(template_payload, 18),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 19),
    statistical_process_used_to_calculate_fields_for_local_time_processing: typed_read_u8_view(template_payload, 20),
    statistical_processing_time_range_unit: typed_read_u8_view(template_payload, 21),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 22,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: typed_read_u8_view(template_payload, 26),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 27),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_497(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate497, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 49, "template 4.97") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 30)
  let required = 31 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.97 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 31 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    input_process_identifier: typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: typed_read_u8_view(template_payload, 6),
    type_of_generating_process: typed_read_u8_view(template_payload, 7),
    background_process_identifier: typed_read_u8_view(template_payload, 8),
    generating_process_identifier: typed_read_u8_view(template_payload, 9),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 10),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 11),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 16),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 17),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    statistical_process_used_to_calculate_fields_for_local_time_processing: typed_read_u8_view(template_payload, 22),
    statistical_processing_time_range_unit: typed_read_u8_view(template_payload, 23),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 24,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: typed_read_u8_view(template_payload, 28),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 29),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_498(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate498, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 34, "template 4.98") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 33)
  let required = 34 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.98 forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 34 + i * 18
    forecast_specs.push({
      year: typed_read_u16_be_view(template_payload, offset),
      month: typed_read_u8_view(template_payload, offset + 2),
      day: typed_read_u8_view(template_payload, offset + 3),
      hour: typed_read_u8_view(template_payload, offset + 4),
      minute: typed_read_u8_view(template_payload, offset + 5),
      second: typed_read_u8_view(template_payload, offset + 6),
      forecast_time_unit: typed_read_u8_view(template_payload, offset + 7),
      forecast_time: typed_read_u32_be_view(template_payload, offset + 8),
      number_of_time_increments: typed_read_u8_view(template_payload, offset + 12),
      time_increment_unit: typed_read_u8_view(template_payload, offset + 13),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 14,
      ),
    })
  }
  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    input_process_identifier: typed_read_u16_be_view(template_payload, 2),
    input_originating_centre: typed_read_u16_be_view(template_payload, 4),
    type_of_post_processing: typed_read_u8_view(template_payload, 6),
    type_of_generating_process: typed_read_u8_view(template_payload, 7),
    background_process_identifier: typed_read_u8_view(template_payload, 8),
    generating_process_identifier: typed_read_u8_view(template_payload, 9),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 10),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 11),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 12,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 16),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 17),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 22),
    perturbation_number: typed_read_u8_view(template_payload, 23),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 24),
    statistical_process_used_to_calculate_fields_for_local_time_processing: typed_read_u8_view(template_payload, 25),
    statistical_processing_time_range_unit: typed_read_u8_view(template_payload, 26),
    statistical_processing_time_range_length: typed_read_u32_be_view(
      template_payload, 27,
    ),
    number_of_statistically_processed_fields_in_local_time_composite: typed_read_u8_view(template_payload, 31),
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 32),
    number_of_forecasts_used: n,
    forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_499(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate499, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 22, "template 4.99") { Ok(_) => (); Err(e) => return Err(e) }

  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 23 + nd * 4 + nf * 4
  match typed_validate_template_min_length(template_payload, required, "template 4.99 wave table payload") { Ok(_) => (); Err(e) => return Err(e) }

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
    scale_factor_of_wave_directions: typed_read_u8_view(template_payload, 21),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: typed_read_u8_view(template_payload, frequency_scale_factor_offset),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
