///|
fn typed_encode_template_467(template : Grib2ProductTemplate467) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.atmospheric_chemical_constituent_type)
  typed_push_u16_be(out, template.number_of_mode_of_distribution)
  typed_push_u16_be(out, template.mode_number)
  typed_push_u16_be(out, template.type_of_distribution_function)
  out.push(template.number_of_following_function_parameters.to_byte())
  for parameter in template.function_parameters {
    out.push(
      parameter.scale_factor_of_fixed_distribution_function_parameter.to_byte(),
    )
    typed_push_u32_be(
      out,
      parameter.scaled_value_of_fixed_distribution_function_parameter,
    )
  }
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_468(template : Grib2ProductTemplate468) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.atmospheric_chemical_constituent_type)
  typed_push_u16_be(out, template.number_of_mode_of_distribution)
  typed_push_u16_be(out, template.mode_number)
  typed_push_u16_be(out, template.type_of_distribution_function)
  out.push(template.number_of_following_function_parameters.to_byte())
  for parameter in template.function_parameters {
    out.push(
      parameter.scale_factor_of_fixed_distribution_function_parameter.to_byte(),
    )
    typed_push_u32_be(
      out,
      parameter.scaled_value_of_fixed_distribution_function_parameter,
    )
  }
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_470(template : Grib2ProductTemplate470) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_471(template : Grib2ProductTemplate471) -> Bytes {
  let out = typed_encode_template_470({
    parameter_category: template.parameter_category,
    parameter_number: template.parameter_number,
    input_process_identifier: template.input_process_identifier,
    input_originating_centre: template.input_originating_centre,
    type_of_post_processing: template.type_of_post_processing,
    type_of_generating_process: template.type_of_generating_process,
    background_process_identifier: template.background_process_identifier,
    generating_process_identifier: template.generating_process_identifier,
    hours_of_observational_data_cutoff: template.hours_of_observational_data_cutoff,
    minutes_of_observational_data_cutoff: template.minutes_of_observational_data_cutoff,
    time_range_unit: template.time_range_unit,
    forecast_time: template.forecast_time,
    type_of_first_fixed_surface: template.type_of_first_fixed_surface,
    scale_factor_of_first_fixed_surface: template.scale_factor_of_first_fixed_surface,
    scaled_value_of_first_fixed_surface: template.scaled_value_of_first_fixed_surface,
    type_of_second_fixed_surface: template.type_of_second_fixed_surface,
    scale_factor_of_second_fixed_surface: template.scale_factor_of_second_fixed_surface,
    scaled_value_of_second_fixed_surface: template.scaled_value_of_second_fixed_surface,
  }).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_472(template : Grib2ProductTemplate472) -> Bytes {
  let out = typed_encode_template_470({
    parameter_category: template.parameter_category,
    parameter_number: template.parameter_number,
    input_process_identifier: template.input_process_identifier,
    input_originating_centre: template.input_originating_centre,
    type_of_post_processing: template.type_of_post_processing,
    type_of_generating_process: template.type_of_generating_process,
    background_process_identifier: template.background_process_identifier,
    generating_process_identifier: template.generating_process_identifier,
    hours_of_observational_data_cutoff: template.hours_of_observational_data_cutoff,
    minutes_of_observational_data_cutoff: template.minutes_of_observational_data_cutoff,
    time_range_unit: template.time_range_unit,
    forecast_time: template.forecast_time,
    type_of_first_fixed_surface: template.type_of_first_fixed_surface,
    scale_factor_of_first_fixed_surface: template.scale_factor_of_first_fixed_surface,
    scaled_value_of_first_fixed_surface: template.scaled_value_of_first_fixed_surface,
    type_of_second_fixed_surface: template.type_of_second_fixed_surface,
    scale_factor_of_second_fixed_surface: template.scale_factor_of_second_fixed_surface,
    scaled_value_of_second_fixed_surface: template.scaled_value_of_second_fixed_surface,
  }).to_array()
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_473(template : Grib2ProductTemplate473) -> Bytes {
  let out = typed_encode_template_471({
    parameter_category: template.parameter_category,
    parameter_number: template.parameter_number,
    input_process_identifier: template.input_process_identifier,
    input_originating_centre: template.input_originating_centre,
    type_of_post_processing: template.type_of_post_processing,
    type_of_generating_process: template.type_of_generating_process,
    background_process_identifier: template.background_process_identifier,
    generating_process_identifier: template.generating_process_identifier,
    hours_of_observational_data_cutoff: template.hours_of_observational_data_cutoff,
    minutes_of_observational_data_cutoff: template.minutes_of_observational_data_cutoff,
    time_range_unit: template.time_range_unit,
    forecast_time: template.forecast_time,
    type_of_first_fixed_surface: template.type_of_first_fixed_surface,
    scale_factor_of_first_fixed_surface: template.scale_factor_of_first_fixed_surface,
    scaled_value_of_first_fixed_surface: template.scaled_value_of_first_fixed_surface,
    type_of_second_fixed_surface: template.type_of_second_fixed_surface,
    scale_factor_of_second_fixed_surface: template.scale_factor_of_second_fixed_surface,
    scaled_value_of_second_fixed_surface: template.scaled_value_of_second_fixed_surface,
    type_of_ensemble_forecast: template.type_of_ensemble_forecast,
    perturbation_number: template.perturbation_number,
    number_of_forecasts_in_ensemble: template.number_of_forecasts_in_ensemble,
  }).to_array()
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_476(template : Grib2ProductTemplate476) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.atmospheric_chemical_constituent_type)
  out.push(template.source_or_sink.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_477(template : Grib2ProductTemplate477) -> Bytes {
  let out = typed_encode_template_476(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_478(template : Grib2ProductTemplate478) -> Bytes {
  let out = typed_encode_template_476(template.base).to_array()
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_479(template : Grib2ProductTemplate479) -> Bytes {
  let out = typed_encode_template_477(template.base).to_array()
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_480(template : Grib2ProductTemplate480) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
  out.push(template.source_or_sink.to_byte())
  out.push(template.type_of_interval_for_first_and_second_size.to_byte())
  out.push(template.scale_factor_of_first_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_size)
  out.push(template.scale_factor_of_second_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_size)
  out.push(template.type_of_interval_for_first_and_second_wavelength.to_byte())
  out.push(template.scale_factor_of_first_wavelength.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_wavelength)
  out.push(template.scale_factor_of_second_wavelength.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_wavelength)
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_481(template : Grib2ProductTemplate481) -> Bytes {
  let out = typed_encode_template_480(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_482(template : Grib2ProductTemplate482) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
  out.push(template.source_or_sink.to_byte())
  out.push(template.type_of_interval_for_first_and_second_size.to_byte())
  out.push(template.scale_factor_of_first_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_size)
  out.push(template.scale_factor_of_second_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_size)
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_483(template : Grib2ProductTemplate483) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
  out.push(template.source_or_sink.to_byte())
  out.push(template.type_of_interval_for_first_and_second_size.to_byte())
  out.push(template.scale_factor_of_first_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_size)
  out.push(template.scale_factor_of_second_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_size)
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_484(template : Grib2ProductTemplate484) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
  out.push(template.source_or_sink.to_byte())
  out.push(template.type_of_interval_for_first_and_second_size.to_byte())
  out.push(template.scale_factor_of_first_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_size)
  out.push(template.scale_factor_of_second_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_size)
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_485(template : Grib2ProductTemplate485) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
  out.push(template.type_of_interval_for_first_and_second_size.to_byte())
  out.push(template.scale_factor_of_first_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_size)
  out.push(template.scale_factor_of_second_size.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_size)
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_486(template : Grib2ProductTemplate486) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  typed_push_u16_be(out, template.total_number_of_quantiles)
  typed_push_u16_be(out, template.quantile_value)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_487(template : Grib2ProductTemplate487) -> Bytes {
  let out = typed_encode_template_486(template.base).to_array()
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_488(template : Grib2ProductTemplate488) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_analyses_or_forecasts_used.to_byte())
  for spec in template.analysis_or_forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_489(template : Grib2ProductTemplate489) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  typed_push_u16_be(out, template.total_number_of_quantiles)
  typed_push_u16_be(out, template.quantile_value)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_490(template : Grib2ProductTemplate490) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  typed_push_u16_be(out, template.total_number_of_quantiles)
  typed_push_u16_be(out, template.quantile_value)
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_491(template : Grib2ProductTemplate491) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.number_of_categories.to_byte())
  for category in template.categories {
    out.push(category.code_figure.to_byte())
    out.push(category.type_of_interval_for_first_and_second_limit.to_byte())
    out.push(category.scale_factor_of_first_limit.to_byte())
    typed_push_u32_be(out, category.scaled_value_of_first_limit)
    out.push(category.scale_factor_of_second_limit.to_byte())
    typed_push_u32_be(out, category.scaled_value_of_second_limit)
  }
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_492(template : Grib2ProductTemplate492) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_493(template : Grib2ProductTemplate493) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_494(template : Grib2ProductTemplate494) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_495(template : Grib2ProductTemplate495) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(
    template.statistical_process_used_to_calculate_fields_for_local_time_processing.to_byte(),
  )
  out.push(template.statistical_processing_time_range_unit.to_byte())
  typed_push_u32_be(out, template.statistical_processing_time_range_length)
  out.push(
    template.number_of_statistically_processed_fields_in_local_time_composite.to_byte(),
  )
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_496(template : Grib2ProductTemplate496) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(
    template.statistical_process_used_to_calculate_fields_for_local_time_processing.to_byte(),
  )
  out.push(template.statistical_processing_time_range_unit.to_byte())
  typed_push_u32_be(out, template.statistical_processing_time_range_length)
  out.push(
    template.number_of_statistically_processed_fields_in_local_time_composite.to_byte(),
  )
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_497(template : Grib2ProductTemplate497) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(
    template.statistical_process_used_to_calculate_fields_for_local_time_processing.to_byte(),
  )
  out.push(template.statistical_processing_time_range_unit.to_byte())
  typed_push_u32_be(out, template.statistical_processing_time_range_length)
  out.push(
    template.number_of_statistically_processed_fields_in_local_time_composite.to_byte(),
  )
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_498(template : Grib2ProductTemplate498) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(
    template.statistical_process_used_to_calculate_fields_for_local_time_processing.to_byte(),
  )
  out.push(template.statistical_processing_time_range_unit.to_byte())
  typed_push_u32_be(out, template.statistical_processing_time_range_length)
  out.push(
    template.number_of_statistically_processed_fields_in_local_time_composite.to_byte(),
  )
  out.push(
    template.method_used_to_derive_data_field_values_at_local_time.to_byte(),
  )
  out.push(template.number_of_forecasts_used.to_byte())
  for spec in template.forecast_specs {
    typed_push_u16_be(out, spec.year)
    out.push(spec.month.to_byte())
    out.push(spec.day.to_byte())
    out.push(spec.hour.to_byte())
    out.push(spec.minute.to_byte())
    out.push(spec.second.to_byte())
    out.push(spec.forecast_time_unit.to_byte())
    typed_push_u32_be(out, spec.forecast_time)
    out.push(spec.number_of_time_increments.to_byte())
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_499(template : Grib2ProductTemplate499) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.wave_direction_number)
  typed_push_u16_be(out, template.number_of_wave_directions)
  typed_push_u16_be(out, template.wave_frequency_number)
  typed_push_u16_be(out, template.number_of_wave_frequencies)
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.scale_factor_of_wave_directions.to_byte())
  for direction in template.scaled_wave_directions {
    typed_push_u32_be(out, direction)
  }
  out.push(template.scale_factor_of_wave_frequencies.to_byte())
  for frequency in template.scaled_wave_frequencies {
    typed_push_u32_be(out, frequency)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_487_core_without_tail(
  template : Grib2ProductTemplate487,
) -> Array[Byte] {
  let out = typed_encode_template_486(template.base).to_array()
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  out
}

///|
fn typed_encode_template_490_core_without_tail(
  template : Grib2ProductTemplate490,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.input_process_identifier)
  typed_push_u16_be(out, template.input_originating_centre)
  out.push(template.type_of_post_processing.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.background_process_identifier.to_byte())
  out.push(template.generating_process_identifier.to_byte())
  typed_push_u16_be(out, template.hours_of_observational_data_cutoff)
  out.push(template.minutes_of_observational_data_cutoff.to_byte())
  out.push(template.time_range_unit.to_byte())
  typed_push_u32_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  typed_push_u16_be(out, template.total_number_of_quantiles)
  typed_push_u16_be(out, template.quantile_value)
  typed_push_u16_be(out, template.end_year)
  out.push(template.end_month.to_byte())
  out.push(template.end_day.to_byte())
  out.push(template.end_hour.to_byte())
  out.push(template.end_minute.to_byte())
  out.push(template.end_second.to_byte())
  out.push(template.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, template.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(template.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  out
}
