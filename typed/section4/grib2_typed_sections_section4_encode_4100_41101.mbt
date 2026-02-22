///|
fn typed_encode_template_4100(template : Grib2ProductTemplate4100) -> Bytes {
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
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
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
fn typed_encode_template_4101(template : Grib2ProductTemplate4101) -> Bytes {
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
  out.push(template.type_of_wave_direction_sequence.to_byte())
  out.push(template.number_of_wave_direction_sequence_parameters.to_byte())
  for parameter in template.wave_direction_sequence_parameters {
    out.push(parameter.scale_factor.to_byte())
    typed_push_u32_be(out, parameter.scaled_value)
  }
  out.push(template.type_of_wave_frequency_sequence.to_byte())
  out.push(template.number_of_wave_frequency_sequence_parameters.to_byte())
  for parameter in template.wave_frequency_sequence_parameters {
    out.push(parameter.scale_factor.to_byte())
    typed_push_u32_be(out, parameter.scaled_value)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4102(template : Grib2ProductTemplate4102) -> Bytes {
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
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(template.type_of_wave_direction_sequence.to_byte())
  out.push(template.number_of_wave_direction_sequence_parameters.to_byte())
  for parameter in template.wave_direction_sequence_parameters {
    out.push(parameter.scale_factor.to_byte())
    typed_push_u32_be(out, parameter.scaled_value)
  }
  out.push(template.type_of_wave_frequency_sequence.to_byte())
  out.push(template.number_of_wave_frequency_sequence_parameters.to_byte())
  for parameter in template.wave_frequency_sequence_parameters {
    out.push(parameter.scale_factor.to_byte())
    typed_push_u32_be(out, parameter.scaled_value)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4103(template : Grib2ProductTemplate4103) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_wave_period_interval.to_byte())
  out.push(template.scale_factor_of_lower_wave_period_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_lower_wave_period_limit)
  out.push(template.scale_factor_of_upper_wave_period_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_upper_wave_period_limit)
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
fn typed_encode_template_4104(template : Grib2ProductTemplate4104) -> Bytes {
  let out = typed_encode_template_4103(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4105(template : Grib2ProductTemplate4105) -> Bytes {
  let out = typed_encode_template_48_core_without_tail(template.base)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4106(template : Grib2ProductTemplate4106) -> Bytes {
  let out = typed_encode_template_48_core_without_tail(template.base)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4107(template : Grib2ProductTemplate4107) -> Bytes {
  let out = typed_encode_template_48_core_without_tail(template.base)
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4108(template : Grib2ProductTemplate4108) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_interval_for_wavelength.to_byte())
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
fn typed_encode_template_4109(template : Grib2ProductTemplate4109) -> Bytes {
  let out = typed_encode_template_4108(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4110(template : Grib2ProductTemplate4110) -> Bytes {
  let out = typed_encode_template_4108(template.base).to_array()
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
fn typed_encode_template_4111(template : Grib2ProductTemplate4111) -> Bytes {
  let out = typed_encode_template_4109(template.base).to_array()
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
fn typed_encode_template_4112(template : Grib2ProductTemplate4112) -> Bytes {
  let out = typed_encode_template_48_core_without_tail(template.base)
  out.push(template.forecast_probability_number.to_byte())
  out.push(template.total_number_of_forecast_probabilities.to_byte())
  out.push(template.probability_type.to_byte())
  out.push(template.scale_factor_of_lower_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_lower_limit)
  out.push(template.scale_factor_of_upper_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_upper_limit)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4113_core_without_tail(
  base : Grib2ProductTemplate40,
  tile : Grib2GeneralizedTileDefinition,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(base.parameter_category.to_byte())
  out.push(base.parameter_number.to_byte())
  let tile_raw = typed_encode_generalized_tile_definition(tile)
  for b in tile_raw {
    out.push(b)
  }
  out.push(base.type_of_generating_process.to_byte())
  out.push(base.background_process_identifier.to_byte())
  out.push(base.generating_process_identifier.to_byte())
  typed_push_u16_be(out, base.hours_of_observational_data_cutoff)
  out.push(base.minutes_of_observational_data_cutoff.to_byte())
  out.push(base.time_range_unit.to_byte())
  typed_push_u32_be(out, base.forecast_time)
  out.push(base.type_of_first_fixed_surface.to_byte())
  out.push(base.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, base.scaled_value_of_first_fixed_surface)
  out.push(base.type_of_second_fixed_surface.to_byte())
  out.push(base.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, base.scaled_value_of_second_fixed_surface)
  out
}

///|
fn typed_encode_template_4113(template : Grib2ProductTemplate4113) -> Bytes {
  let out = typed_encode_template_4113_core_without_tail(
    template.base,
    template.tile,
  )
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4114(template : Grib2ProductTemplate4114) -> Bytes {
  let out = typed_encode_template_4113_core_without_tail(
    template.base.base,
    template.base.tile,
  )
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
fn typed_encode_template_4115(template : Grib2ProductTemplate4115) -> Bytes {
  let out = typed_encode_template_4113_core_without_tail(
    template.base.base,
    template.base.tile,
  )
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4116(template : Grib2ProductTemplate4116) -> Bytes {
  let out = typed_encode_template_4113_core_without_tail(
    template.base.base.base,
    template.base.base.tile,
  )
  out.push(template.base.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.base.perturbation_number)
  typed_push_u32_be(out, template.base.number_of_forecasts_in_ensemble)
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
fn typed_encode_template_4117_core_without_tail(
  template : Grib2ProductTemplate4117,
) -> Array[Byte] {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  out
}

///|
fn typed_encode_template_4117(template : Grib2ProductTemplate4117) -> Bytes {
  let out = typed_encode_template_4117_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4118(template : Grib2ProductTemplate4118) -> Bytes {
  let out = typed_encode_template_4117_core_without_tail(template.base)
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
fn typed_encode_template_4119_core_without_tail(
  template : Grib2ProductTemplate4119,
) -> Array[Byte] {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  out.push(template.forecast_probability_number.to_byte())
  out.push(template.total_number_of_forecast_probabilities.to_byte())
  out.push(template.probability_type.to_byte())
  out.push(template.scale_factor_of_lower_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_lower_limit)
  out.push(template.scale_factor_of_upper_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_upper_limit)
  out
}

///|
fn typed_encode_template_4119(template : Grib2ProductTemplate4119) -> Bytes {
  let out = typed_encode_template_4119_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4120(template : Grib2ProductTemplate4120) -> Bytes {
  let out = typed_encode_template_4119_core_without_tail(template.base)
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
fn typed_encode_template_4120_core_without_tail(
  template : Grib2ProductTemplate4120,
) -> Array[Byte] {
  let out = typed_encode_template_4119_core_without_tail(template.base)
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
fn typed_encode_template_4121(template : Grib2ProductTemplate4121) -> Bytes {
  let out = typed_encode_template_4119_core_without_tail(template.base)
  let spatial = typed_encode_spatial_vicinity_definition(
    template.spatial_vicinity,
  )
  for b in spatial {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4122(template : Grib2ProductTemplate4122) -> Bytes {
  let out = typed_encode_template_4120_core_without_tail(template.base)
  let spatial = typed_encode_spatial_vicinity_definition(
    template.spatial_vicinity,
  )
  for b in spatial {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4123(template : Grib2ProductTemplate4123) -> Bytes {
  let out = typed_encode_template_48_core_without_tail(template.base)
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  out.push(template.forecast_probability_number.to_byte())
  out.push(template.total_number_of_forecast_probabilities.to_byte())
  out.push(template.probability_type.to_byte())
  out.push(template.scale_factor_of_lower_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_lower_limit)
  out.push(template.scale_factor_of_upper_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_upper_limit)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  let spatial = typed_encode_spatial_vicinity_definition(
    template.spatial_vicinity,
  )
  for b in spatial {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4124_core_without_tail(
  template : Grib2ProductTemplate4124,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.atmospheric_chemical_constituent_type)
  out.push(template.source_or_sink.to_byte())
  typed_push_u16_be(out, template.transport_model_used)
  typed_push_u16_be(out, template.requested_by_entity)
  typed_push_u16_be(out, template.scenario_origin)
  typed_push_u16_be(out, template.nwp_used)
  typed_push_u16_be(out, template.release_start_year)
  out.push(template.release_start_month.to_byte())
  typed_push_u16_be(out, template.release_start_day)
  out.push(template.release_start_hour.to_byte())
  out.push(template.release_start_minute.to_byte())
  typed_push_u16_be(out, template.wall_clock_initial_year)
  out.push(template.wall_clock_initial_month.to_byte())
  out.push(template.wall_clock_initial_day.to_byte())
  out.push(template.wall_clock_initial_hour.to_byte())
  out.push(template.wall_clock_initial_minute.to_byte())
  out.push(template.wall_clock_initial_second.to_byte())
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
  out
}

///|
fn typed_encode_template_4124(template : Grib2ProductTemplate4124) -> Bytes {
  let out = typed_encode_template_4124_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4125(template : Grib2ProductTemplate4125) -> Bytes {
  let out = typed_encode_template_4124_core_without_tail(template.base)
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4126_core_without_tail(
  template : Grib2ProductTemplate4126,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.atmospheric_chemical_constituent_type)
  out.push(template.source_or_sink.to_byte())
  typed_push_u16_be(out, template.transport_model_used)
  typed_push_u16_be(out, template.requested_by_entity)
  typed_push_u16_be(out, template.scenario_origin)
  typed_push_u16_be(out, template.nwp_used)
  typed_push_u16_be(out, template.release_start_year)
  out.push(template.release_start_month.to_byte())
  out.push(template.release_start_day.to_byte())
  out.push(template.release_start_hour.to_byte())
  out.push(template.release_start_minute.to_byte())
  out.push(template.release_start_second.to_byte())
  typed_push_u16_be(out, template.wall_clock_initial_year)
  out.push(template.wall_clock_initial_month.to_byte())
  out.push(template.wall_clock_initial_day.to_byte())
  out.push(template.wall_clock_initial_hour.to_byte())
  out.push(template.wall_clock_initial_minute.to_byte())
  out.push(template.wall_clock_initial_second.to_byte())
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
  out
}

///|
fn typed_encode_template_4126(template : Grib2ProductTemplate4126) -> Bytes {
  let out = typed_encode_template_4126_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4127(template : Grib2ProductTemplate4127) -> Bytes {
  let base_raw = typed_encode_template_4126_core_without_tail(template.base)
  let out : Array[Byte] = []
  for i in 0..<50 {
    out.push(base_raw[i])
  }
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  for i in 50..<base_raw.length() {
    out.push(base_raw[i])
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4128_core_without_tail(
  template : Grib2ProductTemplate4128,
) -> Array[Byte] {
  let out = typed_encode_template_40(template.base).to_array()
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  out
}

///|
fn typed_encode_template_4128(template : Grib2ProductTemplate4128) -> Bytes {
  let out = typed_encode_template_4128_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4129(template : Grib2ProductTemplate4129) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4130(template : Grib2ProductTemplate4130) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4131(template : Grib2ProductTemplate4131) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.forecast_probability_number.to_byte())
  out.push(template.total_number_of_forecast_probabilities.to_byte())
  out.push(template.probability_type.to_byte())
  out.push(template.scale_factor_of_lower_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_lower_limit)
  out.push(template.scale_factor_of_upper_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_upper_limit)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4132(template : Grib2ProductTemplate4132) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  typed_push_u16_be(out, template.total_number_of_quantiles)
  typed_push_u16_be(out, template.quantile_value)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4133(template : Grib2ProductTemplate4133) -> Bytes {
  let out = typed_encode_template_489(template.base).to_array()
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4134(template : Grib2ProductTemplate4134) -> Bytes {
  let out = typed_encode_template_487_core_without_tail(template.base)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4135(template : Grib2ProductTemplate4135) -> Bytes {
  let out = typed_encode_template_490_core_without_tail(template.base)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4136(template : Grib2ProductTemplate4136) -> Bytes {
  let out = typed_encode_template_4119_core_without_tail(template.base)
  let reference = typed_encode_reference_period_definition(
    template.reference_period,
  )
  for b in reference {
    out.push(b)
  }
  let spatial = typed_encode_spatial_vicinity_definition(
    template.spatial_vicinity,
  )
  for b in spatial {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4137_core_without_tail(
  template : Grib2ProductTemplate4137,
) -> Array[Byte] {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
  out
}

///|
fn typed_encode_template_4137(template : Grib2ProductTemplate4137) -> Bytes {
  let out = typed_encode_template_4137_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4138(template : Grib2ProductTemplate4138) -> Bytes {
  let out = typed_encode_template_4137_core_without_tail(template.base)
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
fn typed_encode_template_4139_core_without_tail(
  template : Grib2ProductTemplate4139,
) -> Array[Byte] {
  let out = typed_encode_template_4103(template.base).to_array()
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
  out
}

///|
fn typed_encode_template_4139(template : Grib2ProductTemplate4139) -> Bytes {
  let out = typed_encode_template_4139_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4140(template : Grib2ProductTemplate4140) -> Bytes {
  let out = typed_encode_template_4103(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4141(template : Grib2ProductTemplate4141) -> Bytes {
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
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
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
fn typed_encode_template_4142(template : Grib2ProductTemplate4142) -> Bytes {
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
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
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
fn typed_encode_template_4143(template : Grib2ProductTemplate4143) -> Bytes {
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
  typed_push_u16_be(out, template.random_field_number)
  typed_push_u16_be(out, template.total_number_of_random_fields)
  typed_push_u16_be(out, template.spatio_temporal_scale_number)
  typed_push_u16_be(out, template.total_number_of_spatio_temporal_scales)
  typed_push_u32_be(out, template.scaled_value_of_spatial_scale)
  out.push(template.scale_factor_of_spatial_scale.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_temporal_scale)
  out.push(template.scale_factor_of_temporal_scale.to_byte())
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4144_core_without_tail(
  template : Grib2ProductTemplate4144,
) -> Array[Byte] {
  let out = typed_encode_template_4103(template.base).to_array()
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
fn typed_encode_template_4144(template : Grib2ProductTemplate4144) -> Bytes {
  let out = typed_encode_template_4144_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4145(template : Grib2ProductTemplate4145) -> Bytes {
  let out = typed_encode_template_4103(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
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
fn typed_encode_template_4146(template : Grib2ProductTemplate4146) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  typed_push_u16_be(out, template.verification_score)
  let verification = typed_encode_verification_definition(template.verification)
  for b in verification {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4147(template : Grib2ProductTemplate4147) -> Bytes {
  let out = typed_encode_template_48_core_without_tail(template.base)
  typed_push_u16_be(out, template.verification_score)
  let verification = typed_encode_verification_definition(template.verification)
  for b in verification {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4148(template : Grib2ProductTemplate4148) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.verification_score)
  let verification = typed_encode_verification_definition(template.verification)
  for b in verification {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4149(template : Grib2ProductTemplate4149) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
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
  typed_push_u16_be(out, template.verification_score)
  let verification = typed_encode_verification_definition(template.verification)
  for b in verification {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4150(template : Grib2ProductTemplate4150) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.verification_score)
  let verification = typed_encode_verification_definition(template.verification)
  for b in verification {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4151(template : Grib2ProductTemplate4151) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
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
  typed_push_u16_be(out, template.verification_score)
  let verification = typed_encode_verification_definition(template.verification)
  for b in verification {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4152_core_without_tail(
  template : Grib2ProductTemplate4152,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.atmospheric_chemical_constituent_type)
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
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
  out
}

///|
fn typed_encode_template_4152(template : Grib2ProductTemplate4152) -> Bytes {
  let out = typed_encode_template_4152_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4153(template : Grib2ProductTemplate4153) -> Bytes {
  let out = typed_encode_template_4152_core_without_tail(template.base)
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
fn typed_encode_template_4154_core_without_tail(
  template : Grib2ProductTemplate4154,
) -> Array[Byte] {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  typed_push_u32_be(out, template.perturbation_number)
  typed_push_u32_be(out, template.number_of_forecasts_in_ensemble)
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
  out
}

///|
fn typed_encode_template_4154(template : Grib2ProductTemplate4154) -> Bytes {
  let out = typed_encode_template_4154_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_4155(template : Grib2ProductTemplate4155) -> Bytes {
  let out = typed_encode_template_4154_core_without_tail(template.base)
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
fn typed_encode_template_4254(template : Grib2ProductTemplate4254) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u32_be(out, template.number_of_characters)
  for b in template.character_string {
    out.push(b)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_41000_core_without_tail(
  template : Grib2ProductTemplate41000,
) -> Array[Byte] {
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
  out
}

///|
fn typed_encode_template_41000(template : Grib2ProductTemplate41000) -> Bytes {
  let out = typed_encode_template_41000_core_without_tail(template)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_41001(template : Grib2ProductTemplate41001) -> Bytes {
  let out = typed_encode_template_41000_core_without_tail(template.base)
  typed_push_u32_be(out, template.number_of_missing_values)
  typed_push_time_range_spec(out, template.time_range_spec)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_41002(template : Grib2ProductTemplate41002) -> Bytes {
  let out = typed_encode_template_41000_core_without_tail(template.base)
  out.push(template.horizontal_dimension_processed.to_byte())
  out.push(template.treatment_of_missing_data.to_byte())
  out.push(template.statistical_processing_type.to_byte())
  typed_push_u32_be(out, template.start_of_range)
  typed_push_u32_be(out, template.end_of_range)
  typed_push_u16_be(out, template.number_of_values)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_41100(template : Grib2ProductTemplate41100) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_41101(template : Grib2ProductTemplate41101) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  typed_push_u32_be(out, template.number_of_missing_values)
  typed_push_time_range_spec(out, template.time_range_spec)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}
