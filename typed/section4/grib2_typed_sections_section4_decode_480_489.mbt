///|
fn typed_decode_template_480(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate480, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 50, "template 4.80") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: typed_read_u8_view(template_payload, 4),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 11),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    type_of_interval_for_first_and_second_wavelength: typed_read_u8_view(template_payload, 16),
    scale_factor_of_first_wavelength: typed_read_u8_view(template_payload, 17),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 18,
    ),
    scale_factor_of_second_wavelength: typed_read_u8_view(template_payload, 22),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 23,
    ),
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
  })
}

///|
fn typed_decode_template_481(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate481, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 53, "template 4.81") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_480(template_payload.sub(end=50)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 50),
    perturbation_number: typed_read_u8_view(template_payload, 51),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 52),
  })
}

///|
fn typed_decode_template_482(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate482, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 51, "template 4.82") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 46)
  let required = 51 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.82 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: typed_read_u8_view(template_payload, 4),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 11),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    type_of_generating_process: typed_read_u8_view(template_payload, 16),
    background_process_identifier: typed_read_u8_view(template_payload, 17),
    generating_process_identifier: typed_read_u8_view(template_payload, 18),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 21),
    time_range_unit: typed_read_u8_view(template_payload, 22),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 27),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 28),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 33),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 34),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
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
fn typed_decode_template_483(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate483, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 54, "template 4.83") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 49)
  let required = 54 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.83 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    type_of_generating_process: typed_read_u8_view(template_payload, 2),
    aerosol_type: typed_read_u16_be_view(template_payload, 3),
    source_or_sink: typed_read_u8_view(template_payload, 5),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 6),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 7),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 8),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 12),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 13),
    background_process_identifier: typed_read_u8_view(template_payload, 17),
    generating_process_identifier: typed_read_u8_view(template_payload, 18),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 21),
    time_range_unit: typed_read_u8_view(template_payload, 22),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 27),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 28),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 33),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 34),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 39),
    perturbation_number: typed_read_u8_view(template_payload, 40),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 41),
    end_year: typed_read_u16_be_view(template_payload, 42),
    end_month: typed_read_u8_view(template_payload, 44),
    end_day: typed_read_u8_view(template_payload, 45),
    end_hour: typed_read_u8_view(template_payload, 46),
    end_minute: typed_read_u8_view(template_payload, 47),
    end_second: typed_read_u8_view(template_payload, 48),
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
  match typed_validate_template_min_length(template_payload, 54, "template 4.84") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 49)
  let required = 54 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.84 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: typed_read_u8_view(template_payload, 0),
    parameter_number: typed_read_u8_view(template_payload, 1),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: typed_read_u8_view(template_payload, 4),
    type_of_interval_for_first_and_second_size: typed_read_u8_view(template_payload, 5),
    scale_factor_of_first_size: typed_read_u8_view(template_payload, 6),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: typed_read_u8_view(template_payload, 11),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    type_of_generating_process: typed_read_u8_view(template_payload, 16),
    background_process_identifier: typed_read_u8_view(template_payload, 17),
    generating_process_identifier: typed_read_u8_view(template_payload, 18),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: typed_read_u8_view(template_payload, 21),
    time_range_unit: typed_read_u8_view(template_payload, 22),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: typed_read_u8_view(template_payload, 27),
    scale_factor_of_first_fixed_surface: typed_read_u8_view(template_payload, 28),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: typed_read_u8_view(template_payload, 33),
    scale_factor_of_second_fixed_surface: typed_read_u8_view(template_payload, 34),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    type_of_ensemble_forecast: typed_read_u8_view(template_payload, 39),
    perturbation_number: typed_read_u8_view(template_payload, 40),
    number_of_forecasts_in_ensemble: typed_read_u8_view(template_payload, 41),
    end_year: typed_read_u16_be_view(template_payload, 42),
    end_month: typed_read_u8_view(template_payload, 44),
    end_day: typed_read_u8_view(template_payload, 45),
    end_hour: typed_read_u8_view(template_payload, 46),
    end_minute: typed_read_u8_view(template_payload, 47),
    end_second: typed_read_u8_view(template_payload, 48),
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
  match typed_validate_template_min_length(template_payload, 53, "template 4.85") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 48)
  let required = 53 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.85 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

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
fn typed_decode_template_486(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate486, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 29, "template 4.86") { Ok(_) => (); Err(e) => return Err(e) }

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
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 25),
    quantile_value: typed_read_u16_be_view(template_payload, 27),
  })
}

///|
fn typed_decode_template_487(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate487, Grib2SectionCodecError] {
  match typed_validate_template_min_length(template_payload, 41, "template 4.87") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_486(template_payload.sub(end=29)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = typed_read_u8_view(template_payload, 36)
  let required = 41 + n * 12
  match typed_validate_template_min_length(template_payload, required, "template 4.87 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 29),
    end_month: typed_read_u8_view(template_payload, 31),
    end_day: typed_read_u8_view(template_payload, 32),
    end_hour: typed_read_u8_view(template_payload, 33),
    end_minute: typed_read_u8_view(template_payload, 34),
    end_second: typed_read_u8_view(template_payload, 35),
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
  match typed_validate_template_min_length(template_payload, 37, "template 4.88") { Ok(_) => (); Err(e) => return Err(e) }

  let n = typed_read_u8_view(template_payload, 18)
  let required = 19 + n * 18
  match typed_validate_template_min_length(template_payload, required, "template 4.88 analysis/forecast payload") { Ok(_) => (); Err(e) => return Err(e) }

  let analysis_or_forecast_specs : Array[Grib2Template488AnalysisForecastSpec] = []
  for i in 0..<n {
    let offset = 19 + i * 18
    analysis_or_forecast_specs.push({
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
    method_used_to_derive_data_field_values_at_local_time: typed_read_u8_view(template_payload, 17),
    number_of_analyses_or_forecasts_used: n,
    analysis_or_forecast_specs,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_489(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate489, Grib2SectionCodecError] {
  match typed_validate_template_exact_length(template_payload, 34, "template 4.89") { Ok(_) => (); Err(e) => return Err(e) }

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
  })
}
