///|
fn sample_template40_base() -> Grib2ProductTemplate40 {
  {
    parameter_category: 0,
    parameter_number: 0,
    type_of_generating_process: 2,
    background_process_identifier: 0,
    generating_process_identifier: 96,
    hours_of_observational_data_cutoff: 0,
    minutes_of_observational_data_cutoff: 0,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
  }
}

///|
fn sample_time_range_specs() -> Array[Grib2TimeRangeSpec] {
  [
    {
      statistical_process: 1,
      type_of_time_increment: 2,
      time_range_unit: 1,
      time_range_length: 6,
      time_increment_unit: 1,
      time_increment_length: 3,
    },
    {
      statistical_process: 3,
      type_of_time_increment: 4,
      time_range_unit: 1,
      time_range_length: 12,
      time_increment_unit: 1,
      time_increment_length: 6,
    },
  ]
}

///|
fn sample_verification_definition() -> Grib2VerificationDefinition {
  {
    type_of_reference_dataset: 2,
    type_of_statistical_processing_over_vertical: 1,
    type_of_threshold_operator: 3,
    type_of_additional_arguments: 4,
    number_of_additional_arguments: 2,
    additional_arguments: [
      { scale_factor: 0, scaled_value: 10 },
      { scale_factor: 1, scaled_value: 20 },
    ],
    start_year: 2020,
    start_month: 1,
    start_day: 2,
    start_hour: 3,
    start_minute: 4,
    start_second: 5,
    number_of_verification_period_time_ranges: 2,
    verification_period_time_range_specs: [
      {
        statistical_processing_type: 1,
        time_range_unit: 1,
        time_range_length: 6,
        time_increment_unit: 1,
        time_increment_length: 3,
      },
      {
        statistical_processing_type: 2,
        time_range_unit: 1,
        time_range_length: 12,
        time_increment_unit: 1,
        time_increment_length: 6,
      },
    ],
    number_of_forecasts_in_verification: 77,
  }
}

///|
fn sample_generalized_tile_definition() -> Grib2GeneralizedTileDefinition {
  {
    tile_classification: 3,
    type_of_tile: 258,
    number_of_used_spatial_tiles: 4,
    number_of_used_tile_attribute_combinations_for_type_of_tile: 2,
    number_of_used_tile_attributes: 2,
    tile_attributes: [11, 22],
    total_number_of_tile_attribute_combinations: 5,
    tile_index: 7,
    uuid_of_data_group: b"\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
  }
}

///|
fn sample_template4117_base() -> Grib2ProductTemplate4117 {
  {
    base: sample_template40_base(),
    type_of_ensemble_forecast: 2,
    perturbation_number: 123456,
    number_of_forecasts_in_ensemble: 987654,
    reserved_tail: b"",
  }
}

///|
fn sample_reference_period_definition() -> Grib2ReferencePeriodDefinition {
  {
    type_of_reference_dataset: 1,
    type_of_relation_to_reference_dataset: 2,
    number_of_additional_parameters: 1,
    additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
    start_year: 1991,
    start_month: 1,
    start_day: 1,
    start_hour: 0,
    start_minute: 0,
    start_second: 0,
    sample_size: 30,
    number_of_reference_period_time_ranges: 1,
    reference_period_time_range_specs: [
      {
        statistical_processing_type: 1,
        time_range_unit: 1,
        time_range_length: 24,
      },
    ],
  }
}

///|
fn sample_spatial_vicinity_definition() -> Grib2SpatialVicinityDefinition {
  {
    spatial_vicinity_type: 1,
    number_of_spatial_vicinity_values: 2,
    spatial_vicinity_values: [100, 200],
    spatial_vicinity_processing: 3,
    spatial_vicinity_processing_argument1: 10,
    spatial_vicinity_processing_argument2: 20,
    spatial_vicinity_missing_data: 1,
    temporal_vicinity_processing: 4,
    temporal_vicinity_unit: 1,
    temporal_vicinity_towards_past: 6,
    temporal_vicinity_towards_future: 9,
  }
}

///|
fn sample_template4124(reserved_tail : Bytes) -> Grib2ProductTemplate4124 {
  {
    parameter_category: 20,
    parameter_number: 11,
    atmospheric_chemical_constituent_type: 230,
    source_or_sink: 1,
    transport_model_used: 333,
    requested_by_entity: 34,
    scenario_origin: 335,
    nwp_used: 336,
    release_start_year: 2026,
    release_start_month: 2,
    release_start_day: 21,
    release_start_hour: 6,
    release_start_minute: 30,
    wall_clock_initial_year: 2026,
    wall_clock_initial_month: 2,
    wall_clock_initial_day: 21,
    wall_clock_initial_hour: 5,
    wall_clock_initial_minute: 59,
    wall_clock_initial_second: 10,
    type_of_generating_process: 2,
    background_process_identifier: 1,
    generating_process_identifier: 10,
    hours_of_observational_data_cutoff: 2,
    minutes_of_observational_data_cutoff: 30,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
    reserved_tail,
  }
}

///|
fn sample_template4126(reserved_tail : Bytes) -> Grib2ProductTemplate4126 {
  {
    parameter_category: 20,
    parameter_number: 11,
    atmospheric_chemical_constituent_type: 230,
    source_or_sink: 1,
    transport_model_used: 333,
    requested_by_entity: 34,
    scenario_origin: 335,
    nwp_used: 336,
    release_start_year: 2026,
    release_start_month: 2,
    release_start_day: 21,
    release_start_hour: 6,
    release_start_minute: 30,
    release_start_second: 45,
    wall_clock_initial_year: 2026,
    wall_clock_initial_month: 2,
    wall_clock_initial_day: 21,
    wall_clock_initial_hour: 5,
    wall_clock_initial_minute: 59,
    wall_clock_initial_second: 10,
    type_of_generating_process: 2,
    background_process_identifier: 1,
    generating_process_identifier: 10,
    hours_of_observational_data_cutoff: 2,
    minutes_of_observational_data_cutoff: 30,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
    end_year: 2026,
    end_month: 2,
    end_day: 21,
    end_hour: 6,
    end_minute: 0,
    end_second: 0,
    number_of_time_ranges: 2,
    number_of_missing_values: 1,
    time_range_specs: sample_time_range_specs(),
    reserved_tail,
  }
}

///|
fn sample_template4152(reserved_tail : Bytes) -> Grib2ProductTemplate4152 {
  {
    parameter_category: 20,
    parameter_number: 11,
    atmospheric_chemical_constituent_type: 230,
    type_of_generating_process: 2,
    background_process_identifier: 1,
    generating_process_identifier: 10,
    hours_of_observational_data_cutoff: 2,
    minutes_of_observational_data_cutoff: 30,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
    type_of_ensemble_forecast: 2,
    perturbation_number: 123456,
    number_of_forecasts_in_ensemble: 987654,
    year_of_model_version_date: 2026,
    month_of_model_version_date: 2,
    day_of_model_version_date: 21,
    hour_of_model_version_date: 12,
    minute_of_model_version_date: 34,
    second_of_model_version_date: 56,
    reserved_tail,
  }
}

///|
fn sample_template4154(reserved_tail : Bytes) -> Grib2ProductTemplate4154 {
  {
    base: sample_template40_base(),
    type_of_ensemble_forecast: 2,
    perturbation_number: 123456,
    number_of_forecasts_in_ensemble: 987654,
    year_of_model_version_date: 2026,
    month_of_model_version_date: 2,
    day_of_model_version_date: 21,
    hour_of_model_version_date: 12,
    minute_of_model_version_date: 34,
    second_of_model_version_date: 56,
    reserved_tail,
  }
}

///|
fn sample_template41000(reserved_tail : Bytes) -> Grib2ProductTemplate41000 {
  {
    parameter_category: 0,
    parameter_number: 1,
    type_of_generating_process: 2,
    background_process_identifier: 0,
    generating_process_identifier: 96,
    hours_of_observational_data_cutoff: 0,
    minutes_of_observational_data_cutoff: 0,
    time_range_unit: 1,
    forecast_time: 6,
    reserved_tail,
  }
}

///|
fn sample_template41100(reserved_tail : Bytes) -> Grib2ProductTemplate41100 {
  { base: sample_template40_base(), reserved_tail }
}
