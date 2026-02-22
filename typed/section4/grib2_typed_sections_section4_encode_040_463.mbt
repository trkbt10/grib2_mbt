///|
fn typed_encode_template_40(template : Grib2ProductTemplate40) -> Bytes {
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
  Bytes::from_array(out)
}

///|
fn typed_encode_template_41(template : Grib2ProductTemplate41) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_42(template : Grib2ProductTemplate42) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_43(template : Grib2ProductTemplate43) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(template.cluster_identifier.to_byte())
  out.push(template.cluster_for_high_resolution_control.to_byte())
  out.push(template.cluster_for_low_resolution_control.to_byte())
  out.push(template.total_number_of_clusters.to_byte())
  out.push(template.clustering_method.to_byte())
  typed_push_u32_be(out, template.northern_latitude_of_cluster_domain)
  typed_push_u32_be(out, template.southern_latitude_of_cluster_domain)
  typed_push_u32_be(out, template.eastern_longitude_of_cluster_domain)
  typed_push_u32_be(out, template.western_longitude_of_cluster_domain)
  out.push(template.number_of_forecasts_in_cluster.to_byte())
  out.push(template.scale_factor_of_standard_deviation.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_standard_deviation)
  out.push(template.scale_factor_of_distance_from_ensemble_mean.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_distance_from_ensemble_mean)
  for forecast_number in template.ensemble_forecast_numbers {
    out.push(forecast_number.to_byte())
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_44(template : Grib2ProductTemplate44) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(template.cluster_identifier.to_byte())
  out.push(template.cluster_for_high_resolution_control.to_byte())
  out.push(template.cluster_for_low_resolution_control.to_byte())
  out.push(template.total_number_of_clusters.to_byte())
  out.push(template.clustering_method.to_byte())
  typed_push_u32_be(out, template.latitude_of_central_point)
  typed_push_u32_be(out, template.longitude_of_central_point)
  typed_push_u32_be(out, template.radius_of_cluster_domain)
  out.push(template.number_of_forecasts_in_cluster.to_byte())
  out.push(template.scale_factor_of_standard_deviation.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_standard_deviation)
  out.push(template.scale_factor_of_distance_from_ensemble_mean.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_distance_from_ensemble_mean)
  for forecast_number in template.ensemble_forecast_numbers {
    out.push(forecast_number.to_byte())
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_45(template : Grib2ProductTemplate45) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.forecast_probability_number.to_byte())
  out.push(template.total_number_of_forecast_probabilities.to_byte())
  out.push(template.probability_type.to_byte())
  out.push(template.scale_factor_of_lower_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_lower_limit)
  out.push(template.scale_factor_of_upper_limit.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_upper_limit)
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_46(template : Grib2ProductTemplate46) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.percentile_value.to_byte())
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_47(template : Grib2ProductTemplate47) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_48(template : Grib2ProductTemplate48) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
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
fn typed_encode_template_49(template : Grib2ProductTemplate49) -> Bytes {
  let out = typed_encode_template_45(template.base).to_array()
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
fn typed_encode_template_410(template : Grib2ProductTemplate410) -> Bytes {
  let out = typed_encode_template_46(template.base).to_array()
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
fn typed_encode_template_411(template : Grib2ProductTemplate411) -> Bytes {
  let out = typed_encode_template_41(template.base).to_array()
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
fn typed_encode_template_412(template : Grib2ProductTemplate412) -> Bytes {
  let out = typed_encode_template_42(template.base).to_array()
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
fn typed_encode_template_413(template : Grib2ProductTemplate413) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(template.cluster_identifier.to_byte())
  out.push(template.cluster_for_high_resolution_control.to_byte())
  out.push(template.cluster_for_low_resolution_control.to_byte())
  out.push(template.total_number_of_clusters.to_byte())
  out.push(template.clustering_method.to_byte())
  typed_push_u32_be(out, template.northern_latitude_of_cluster_domain)
  typed_push_u32_be(out, template.southern_latitude_of_cluster_domain)
  typed_push_u32_be(out, template.eastern_longitude_of_cluster_domain)
  typed_push_u32_be(out, template.western_longitude_of_cluster_domain)
  out.push(template.number_of_forecasts_in_cluster.to_byte())
  out.push(template.scale_factor_of_standard_deviation.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_standard_deviation)
  out.push(template.scale_factor_of_distance_from_ensemble_mean.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_distance_from_ensemble_mean)
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
  for forecast_number in template.ensemble_forecast_numbers {
    out.push(forecast_number.to_byte())
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_414(template : Grib2ProductTemplate414) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.derived_forecast.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  out.push(template.cluster_identifier.to_byte())
  out.push(template.cluster_for_high_resolution_control.to_byte())
  out.push(template.cluster_for_low_resolution_control.to_byte())
  out.push(template.total_number_of_clusters.to_byte())
  out.push(template.clustering_method.to_byte())
  typed_push_u32_be(out, template.latitude_of_central_point)
  typed_push_u32_be(out, template.longitude_of_central_point)
  typed_push_u32_be(out, template.radius_of_cluster_domain)
  out.push(template.number_of_forecasts_in_cluster.to_byte())
  out.push(template.scale_factor_of_standard_deviation.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_standard_deviation)
  out.push(template.scale_factor_of_distance_from_ensemble_mean.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_distance_from_ensemble_mean)
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
  for forecast_number in template.ensemble_forecast_numbers {
    out.push(forecast_number.to_byte())
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_415(template : Grib2ProductTemplate415) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.statistical_process_within_spatial_area.to_byte())
  out.push(template.type_of_spatial_processing.to_byte())
  out.push(template.number_of_data_points_used.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_430(template : Grib2ProductTemplate430) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.observation_generating_process_identifier.to_byte())
  out.push(template.number_of_contributing_spectral_bands.to_byte())
  for band in template.bands {
    typed_push_u16_be(out, band.satellite_series)
    typed_push_u16_be(out, band.satellite_number)
    out.push(band.instrument_type.to_byte())
    out.push(band.scale_factor_of_central_wave_number.to_byte())
    typed_push_u32_be(out, band.scaled_value_of_central_wave_number)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_431(template : Grib2ProductTemplate431) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.observation_generating_process_identifier.to_byte())
  out.push(template.number_of_contributing_spectral_bands.to_byte())
  for band in template.bands {
    typed_push_u16_be(out, band.satellite_series)
    typed_push_u16_be(out, band.satellite_number)
    typed_push_u16_be(out, band.instrument_type)
    out.push(band.scale_factor_of_central_wave_number.to_byte())
    typed_push_u32_be(out, band.scaled_value_of_central_wave_number)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_432(template : Grib2ProductTemplate432) -> Bytes {
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
  out.push(template.number_of_contributing_spectral_bands.to_byte())
  for band in template.bands {
    typed_push_u16_be(out, band.satellite_series)
    typed_push_u16_be(out, band.satellite_number)
    typed_push_u16_be(out, band.instrument_type)
    out.push(band.scale_factor_of_central_wave_number.to_byte())
    typed_push_u32_be(out, band.scaled_value_of_central_wave_number)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_433(template : Grib2ProductTemplate433) -> Bytes {
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
  out.push(template.number_of_contributing_spectral_bands.to_byte())
  for band in template.bands {
    typed_push_u16_be(out, band.satellite_series)
    typed_push_u16_be(out, band.satellite_number)
    typed_push_u16_be(out, band.instrument_type)
    out.push(band.scale_factor_of_central_wave_number.to_byte())
    typed_push_u32_be(out, band.scaled_value_of_central_wave_number)
  }
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_434(template : Grib2ProductTemplate434) -> Bytes {
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
  out.push(template.number_of_contributing_spectral_bands.to_byte())
  for band in template.bands {
    typed_push_u16_be(out, band.satellite_series)
    typed_push_u16_be(out, band.satellite_number)
    typed_push_u16_be(out, band.instrument_type)
    out.push(band.scale_factor_of_central_wave_number.to_byte())
    typed_push_u32_be(out, band.scaled_value_of_central_wave_number)
  }
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
fn typed_encode_template_435(template : Grib2ProductTemplate435) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.observation_generating_process_identifier.to_byte())
  out.push(template.quality_value_associated_with_parameter.to_byte())
  out.push(template.number_of_contributing_spectral_bands.to_byte())
  for band in template.bands {
    typed_push_u16_be(out, band.satellite_series)
    typed_push_u16_be(out, band.satellite_number)
    typed_push_u16_be(out, band.instrument_type)
    out.push(band.scale_factor_of_central_wave_number.to_byte())
    typed_push_u32_be(out, band.scaled_value_of_central_wave_number)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_440(template : Grib2ProductTemplate440) -> Bytes {
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
  Bytes::from_array(out)
}

///|
fn typed_encode_template_441(template : Grib2ProductTemplate441) -> Bytes {
  let out = typed_encode_template_440(template.base).to_array()
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_442(template : Grib2ProductTemplate442) -> Bytes {
  let out = typed_encode_template_440(template.base).to_array()
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
fn typed_encode_template_443(template : Grib2ProductTemplate443) -> Bytes {
  let out = typed_encode_template_441(template.base).to_array()
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
fn typed_encode_template_444(template : Grib2ProductTemplate444) -> Bytes {
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
  typed_push_u16_be(out, template.forecast_time)
  out.push(template.type_of_first_fixed_surface.to_byte())
  out.push(template.scale_factor_of_first_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_first_fixed_surface)
  out.push(template.type_of_second_fixed_surface.to_byte())
  out.push(template.scale_factor_of_second_fixed_surface.to_byte())
  typed_push_u32_be(out, template.scaled_value_of_second_fixed_surface)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_445(template : Grib2ProductTemplate445) -> Bytes {
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
  Bytes::from_array(out)
}

///|
fn typed_encode_template_446(template : Grib2ProductTemplate446) -> Bytes {
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
fn typed_encode_template_447(template : Grib2ProductTemplate447) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
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
fn typed_encode_template_448(template : Grib2ProductTemplate448) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
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
fn typed_encode_template_449(template : Grib2ProductTemplate449) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  typed_push_u16_be(out, template.aerosol_type)
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
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_450(template : Grib2ProductTemplate450) -> Bytes {
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
  Bytes::from_array(out)
}

///|
fn typed_encode_template_451(template : Grib2ProductTemplate451) -> Bytes {
  let out = typed_encode_template_40(template.base).to_array()
  out.push(template.number_of_categories.to_byte())
  for category in template.categories {
    out.push(category.code_figure.to_byte())
    out.push(category.type_of_interval_for_first_and_second_limit.to_byte())
    out.push(category.scale_factor_of_first_limit.to_byte())
    typed_push_u32_be(out, category.scaled_value_of_first_limit)
    out.push(category.scale_factor_of_second_limit.to_byte())
    typed_push_u32_be(out, category.scaled_value_of_second_limit)
  }
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_453(template : Grib2ProductTemplate453) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.partition_table_number.to_byte())
  out.push(template.number_of_partitions.to_byte())
  for partition in template.partition_set {
    typed_push_u16_be(out, partition)
  }
  typed_push_u16_be(out, template.partition_number)
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
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_454(template : Grib2ProductTemplate454) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.partition_table_number.to_byte())
  out.push(template.number_of_partitions.to_byte())
  for partition in template.partition_set {
    typed_push_u16_be(out, partition)
  }
  typed_push_u16_be(out, template.partition_number)
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
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_455(template : Grib2ProductTemplate455) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.tile_classification.to_byte())
  out.push(template.total_number_of_tile_attribute_pairs.to_byte())
  out.push(template.number_of_used_spatial_tiles.to_byte())
  out.push(template.tile_index.to_byte())
  out.push(template.number_of_used_tile_attributes.to_byte())
  out.push(template.tile_attribute.to_byte())
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
fn typed_encode_template_456(template : Grib2ProductTemplate456) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.tile_classification.to_byte())
  out.push(template.total_number_of_tile_attribute_pairs.to_byte())
  out.push(template.number_of_used_spatial_tiles.to_byte())
  out.push(template.tile_index.to_byte())
  out.push(template.number_of_used_tile_attributes.to_byte())
  out.push(template.tile_attribute.to_byte())
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
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_457(template : Grib2ProductTemplate457) -> Bytes {
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
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_458(template : Grib2ProductTemplate458) -> Bytes {
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
  for b in template.reserved_tail {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_459(template : Grib2ProductTemplate459) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.tile_classification.to_byte())
  out.push(template.total_number_of_tile_attribute_pairs.to_byte())
  out.push(template.number_of_used_spatial_tiles.to_byte())
  out.push(template.tile_index.to_byte())
  out.push(template.number_of_used_tile_attributes.to_byte())
  out.push(template.tile_attribute.to_byte())
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
  Bytes::from_array(out)
}

///|
fn typed_encode_template_460(template : Grib2ProductTemplate460) -> Bytes {
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
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_461(template : Grib2ProductTemplate461) -> Bytes {
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
  out.push(template.type_of_ensemble_forecast.to_byte())
  out.push(template.perturbation_number.to_byte())
  out.push(template.number_of_forecasts_in_ensemble.to_byte())
  typed_push_u16_be(out, template.year_of_model_version_date)
  out.push(template.month_of_model_version_date.to_byte())
  out.push(template.day_of_model_version_date.to_byte())
  out.push(template.hour_of_model_version_date.to_byte())
  out.push(template.minute_of_model_version_date.to_byte())
  out.push(template.second_of_model_version_date.to_byte())
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
fn typed_encode_template_462(template : Grib2ProductTemplate462) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.tile_classification.to_byte())
  out.push(template.total_number_of_tile_attribute_pairs.to_byte())
  out.push(template.number_of_used_spatial_tiles.to_byte())
  out.push(template.tile_index.to_byte())
  out.push(template.number_of_used_tile_attributes.to_byte())
  out.push(template.tile_attribute.to_byte())
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
fn typed_encode_template_463(template : Grib2ProductTemplate463) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.tile_classification.to_byte())
  out.push(template.total_number_of_tile_attribute_pairs.to_byte())
  out.push(template.number_of_used_spatial_tiles.to_byte())
  out.push(template.tile_index.to_byte())
  out.push(template.number_of_used_tile_attributes.to_byte())
  out.push(template.tile_attribute.to_byte())
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
fn typed_encode_reference_period_definition(
  reference_period : Grib2ReferencePeriodDefinition,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(reference_period.type_of_reference_dataset.to_byte())
  out.push(reference_period.type_of_relation_to_reference_dataset.to_byte())
  out.push(reference_period.number_of_additional_parameters.to_byte())
  for parameter in reference_period.additional_parameters {
    out.push(parameter.scale_factor.to_byte())
    typed_push_u32_be(out, parameter.scaled_value)
  }
  typed_push_u16_be(out, reference_period.start_year)
  out.push(reference_period.start_month.to_byte())
  out.push(reference_period.start_day.to_byte())
  out.push(reference_period.start_hour.to_byte())
  out.push(reference_period.start_minute.to_byte())
  out.push(reference_period.start_second.to_byte())
  typed_push_u32_be(out, reference_period.sample_size)
  out.push(reference_period.number_of_reference_period_time_ranges.to_byte())
  for spec in reference_period.reference_period_time_range_specs {
    out.push(spec.statistical_processing_type.to_byte())
    out.push(spec.time_range_unit.to_byte())
    typed_push_u32_be(out, spec.time_range_length)
  }
  out
}

///|
fn typed_encode_verification_definition(
  verification : Grib2VerificationDefinition,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(verification.type_of_reference_dataset.to_byte())
  out.push(verification.type_of_statistical_processing_over_vertical.to_byte())
  out.push(verification.type_of_threshold_operator.to_byte())
  out.push(verification.type_of_additional_arguments.to_byte())
  out.push(verification.number_of_additional_arguments.to_byte())
  for argument in verification.additional_arguments {
    out.push(argument.scale_factor.to_byte())
    typed_push_u32_be(out, argument.scaled_value)
  }
  typed_push_u16_be(out, verification.start_year)
  out.push(verification.start_month.to_byte())
  out.push(verification.start_day.to_byte())
  out.push(verification.start_hour.to_byte())
  out.push(verification.start_minute.to_byte())
  out.push(verification.start_second.to_byte())
  out.push(verification.number_of_verification_period_time_ranges.to_byte())
  for spec in verification.verification_period_time_range_specs {
    out.push(spec.statistical_processing_type.to_byte())
    out.push(spec.time_range_unit.to_byte())
    typed_push_u32_be(out, spec.time_range_length)
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  typed_push_u16_be(out, verification.number_of_forecasts_in_verification)
  out
}

///|
fn typed_encode_template_48_core_without_tail(
  base : Grib2ProductTemplate48,
) -> Array[Byte] {
  let out = typed_encode_template_40(base.base).to_array()
  typed_push_u16_be(out, base.end_year)
  out.push(base.end_month.to_byte())
  out.push(base.end_day.to_byte())
  out.push(base.end_hour.to_byte())
  out.push(base.end_minute.to_byte())
  out.push(base.end_second.to_byte())
  out.push(base.number_of_time_ranges.to_byte())
  typed_push_u32_be(out, base.number_of_missing_values)
  let time_specs = typed_encode_time_range_specs(base.time_range_specs)
  for b in time_specs {
    out.push(b)
  }
  out
}

///|
fn typed_encode_generalized_tile_definition(
  tile : Grib2GeneralizedTileDefinition,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(tile.tile_classification.to_byte())
  typed_push_u16_be(out, tile.type_of_tile)
  out.push(tile.number_of_used_spatial_tiles.to_byte())
  out.push(
    tile.number_of_used_tile_attribute_combinations_for_type_of_tile.to_byte(),
  )
  out.push(tile.number_of_used_tile_attributes.to_byte())
  for attribute in tile.tile_attributes {
    out.push(attribute.to_byte())
  }
  out.push(tile.total_number_of_tile_attribute_combinations.to_byte())
  out.push(tile.tile_index.to_byte())
  for b in tile.uuid_of_data_group {
    out.push(b)
  }
  out
}

///|
fn typed_encode_spatial_vicinity_definition(
  spatial_vicinity : Grib2SpatialVicinityDefinition,
) -> Array[Byte] {
  let out : Array[Byte] = []
  out.push(spatial_vicinity.spatial_vicinity_type.to_byte())
  out.push(spatial_vicinity.number_of_spatial_vicinity_values.to_byte())
  for value in spatial_vicinity.spatial_vicinity_values {
    typed_push_u32_be(out, value)
  }
  out.push(spatial_vicinity.spatial_vicinity_processing.to_byte())
  typed_push_u16_be(out, spatial_vicinity.spatial_vicinity_processing_argument1)
  typed_push_u16_be(out, spatial_vicinity.spatial_vicinity_processing_argument2)
  out.push(spatial_vicinity.spatial_vicinity_missing_data.to_byte())
  out.push(spatial_vicinity.temporal_vicinity_processing.to_byte())
  out.push(spatial_vicinity.temporal_vicinity_unit.to_byte())
  typed_push_u32_be(out, spatial_vicinity.temporal_vicinity_towards_past)
  typed_push_u32_be(out, spatial_vicinity.temporal_vicinity_towards_future)
  out
}

///|
fn typed_encode_template_420(template : Grib2ProductTemplate420) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.parameter_category.to_byte())
  out.push(template.parameter_number.to_byte())
  out.push(template.type_of_generating_process.to_byte())
  out.push(template.number_of_radar_sites_used.to_byte())
  out.push(template.indicator_of_unit_time_range.to_byte())
  typed_push_u32_be(out, template.site_latitude)
  typed_push_u32_be(out, template.site_longitude)
  typed_push_u16_be(out, template.site_elevation)
  typed_push_u32_be(out, template.site_identifier_alphanumeric)
  typed_push_u16_be(out, template.site_identifier_numeric)
  out.push(template.operating_mode.to_byte())
  out.push(template.reflectivity_calibration_constant.to_byte())
  out.push(template.quality_control_indicator.to_byte())
  out.push(template.clutter_filter_indicator.to_byte())
  out.push(template.constant_antenna_elevation_angle.to_byte())
  typed_push_u16_be(out, template.accumulation_interval)
  out.push(template.reference_reflectivity.to_byte())
  typed_push_u24_be(out, template.range_bin_spacing)
  typed_push_u16_be(out, template.radial_angular_spacing)
  Bytes::from_array(out)
}
