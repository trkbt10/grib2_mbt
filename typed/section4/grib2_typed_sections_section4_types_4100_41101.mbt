///|
pub(all) struct Grib2ProductTemplate4100 {
  parameter_category : Int
  parameter_number : Int
  wave_direction_number : Int
  number_of_wave_directions : Int
  wave_frequency_number : Int
  number_of_wave_frequencies : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  scale_factor_of_wave_directions : Int
  scaled_wave_directions : Array[Int]
  scale_factor_of_wave_frequencies : Int
  scaled_wave_frequencies : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4101 {
  parameter_category : Int
  parameter_number : Int
  wave_direction_number : Int
  number_of_wave_directions : Int
  wave_frequency_number : Int
  number_of_wave_frequencies : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_wave_direction_sequence : Int
  number_of_wave_direction_sequence_parameters : Int
  wave_direction_sequence_parameters : Array[Grib2WaveSequenceParameter]
  type_of_wave_frequency_sequence : Int
  number_of_wave_frequency_sequence_parameters : Int
  wave_frequency_sequence_parameters : Array[Grib2WaveSequenceParameter]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4102 {
  parameter_category : Int
  parameter_number : Int
  wave_direction_number : Int
  number_of_wave_directions : Int
  wave_frequency_number : Int
  number_of_wave_frequencies : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  type_of_wave_direction_sequence : Int
  number_of_wave_direction_sequence_parameters : Int
  wave_direction_sequence_parameters : Array[Grib2WaveSequenceParameter]
  type_of_wave_frequency_sequence : Int
  number_of_wave_frequency_sequence_parameters : Int
  wave_frequency_sequence_parameters : Array[Grib2WaveSequenceParameter]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4103 {
  parameter_category : Int
  parameter_number : Int
  type_of_wave_period_interval : Int
  scale_factor_of_lower_wave_period_limit : Int
  scaled_value_of_lower_wave_period_limit : Int
  scale_factor_of_upper_wave_period_limit : Int
  scaled_value_of_upper_wave_period_limit : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4104 {
  base : Grib2ProductTemplate4103
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4108 {
  parameter_category : Int
  parameter_number : Int
  type_of_interval_for_wavelength : Int
  scale_factor_of_first_wavelength : Int
  scaled_value_of_first_wavelength : Int
  scale_factor_of_second_wavelength : Int
  scaled_value_of_second_wavelength : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4109 {
  base : Grib2ProductTemplate4108
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4110 {
  base : Grib2ProductTemplate4108
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4111 {
  base : Grib2ProductTemplate4109
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4105 {
  base : Grib2ProductTemplate48
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4106 {
  base : Grib2ProductTemplate48
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4107 {
  base : Grib2ProductTemplate48
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4112 {
  base : Grib2ProductTemplate48
  forecast_probability_number : Int
  total_number_of_forecast_probabilities : Int
  probability_type : Int
  scale_factor_of_lower_limit : Int
  scaled_value_of_lower_limit : Int
  scale_factor_of_upper_limit : Int
  scaled_value_of_upper_limit : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4113 {
  base : Grib2ProductTemplate40
  tile : Grib2GeneralizedTileDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4114 {
  base : Grib2ProductTemplate4113
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4115 {
  base : Grib2ProductTemplate4113
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4116 {
  base : Grib2ProductTemplate4115
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4117 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4118 {
  base : Grib2ProductTemplate4117
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4119 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  number_of_forecasts_in_ensemble : Int
  forecast_probability_number : Int
  total_number_of_forecast_probabilities : Int
  probability_type : Int
  scale_factor_of_lower_limit : Int
  scaled_value_of_lower_limit : Int
  scale_factor_of_upper_limit : Int
  scaled_value_of_upper_limit : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4120 {
  base : Grib2ProductTemplate4119
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4121 {
  base : Grib2ProductTemplate4119
  spatial_vicinity : Grib2SpatialVicinityDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4122 {
  base : Grib2ProductTemplate4120
  spatial_vicinity : Grib2SpatialVicinityDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4123 {
  base : Grib2ProductTemplate48
  type_of_ensemble_forecast : Int
  number_of_forecasts_in_ensemble : Int
  forecast_probability_number : Int
  total_number_of_forecast_probabilities : Int
  probability_type : Int
  scale_factor_of_lower_limit : Int
  scaled_value_of_lower_limit : Int
  scale_factor_of_upper_limit : Int
  scaled_value_of_upper_limit : Int
  reference_period : Grib2ReferencePeriodDefinition
  spatial_vicinity : Grib2SpatialVicinityDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4124 {
  parameter_category : Int
  parameter_number : Int
  atmospheric_chemical_constituent_type : Int
  source_or_sink : Int
  transport_model_used : Int
  requested_by_entity : Int
  scenario_origin : Int
  nwp_used : Int
  release_start_year : Int
  release_start_month : Int
  release_start_day : Int
  release_start_hour : Int
  release_start_minute : Int
  wall_clock_initial_year : Int
  wall_clock_initial_month : Int
  wall_clock_initial_day : Int
  wall_clock_initial_hour : Int
  wall_clock_initial_minute : Int
  wall_clock_initial_second : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4125 {
  base : Grib2ProductTemplate4124
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4126 {
  parameter_category : Int
  parameter_number : Int
  atmospheric_chemical_constituent_type : Int
  source_or_sink : Int
  transport_model_used : Int
  requested_by_entity : Int
  scenario_origin : Int
  nwp_used : Int
  release_start_year : Int
  release_start_month : Int
  release_start_day : Int
  release_start_hour : Int
  release_start_minute : Int
  release_start_second : Int
  wall_clock_initial_year : Int
  wall_clock_initial_month : Int
  wall_clock_initial_day : Int
  wall_clock_initial_hour : Int
  wall_clock_initial_minute : Int
  wall_clock_initial_second : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4127 {
  base : Grib2ProductTemplate4126
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4128 {
  base : Grib2ProductTemplate40
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4129 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4130 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4131 {
  base : Grib2ProductTemplate40
  forecast_probability_number : Int
  total_number_of_forecast_probabilities : Int
  probability_type : Int
  scale_factor_of_lower_limit : Int
  scaled_value_of_lower_limit : Int
  scale_factor_of_upper_limit : Int
  scaled_value_of_upper_limit : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4132 {
  base : Grib2ProductTemplate40
  total_number_of_quantiles : Int
  quantile_value : Int
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4133 {
  base : Grib2ProductTemplate489
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4134 {
  base : Grib2ProductTemplate487
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4135 {
  base : Grib2ProductTemplate490
  reference_period : Grib2ReferencePeriodDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4136 {
  base : Grib2ProductTemplate4119
  reference_period : Grib2ReferencePeriodDefinition
  spatial_vicinity : Grib2SpatialVicinityDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4137 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4138 {
  base : Grib2ProductTemplate4137
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4139 {
  base : Grib2ProductTemplate4103
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4140 {
  base : Grib2ProductTemplate4103
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4141 {
  parameter_category : Int
  parameter_number : Int
  wave_direction_number : Int
  number_of_wave_directions : Int
  wave_frequency_number : Int
  number_of_wave_frequencies : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  scale_factor_of_wave_directions : Int
  scaled_wave_directions : Array[Int]
  scale_factor_of_wave_frequencies : Int
  scaled_wave_frequencies : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4142 {
  parameter_category : Int
  parameter_number : Int
  wave_direction_number : Int
  number_of_wave_directions : Int
  wave_frequency_number : Int
  number_of_wave_frequencies : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  scale_factor_of_wave_directions : Int
  scaled_wave_directions : Array[Int]
  scale_factor_of_wave_frequencies : Int
  scaled_wave_frequencies : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4143 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  random_field_number : Int
  total_number_of_random_fields : Int
  spatio_temporal_scale_number : Int
  total_number_of_spatio_temporal_scales : Int
  scaled_value_of_spatial_scale : Int
  scale_factor_of_spatial_scale : Int
  scaled_value_of_temporal_scale : Int
  scale_factor_of_temporal_scale : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4144 {
  base : Grib2ProductTemplate4103
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4145 {
  base : Grib2ProductTemplate4103
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4146 {
  base : Grib2ProductTemplate40
  verification_score : Int
  verification : Grib2VerificationDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4147 {
  base : Grib2ProductTemplate48
  verification_score : Int
  verification : Grib2VerificationDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4148 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  verification_score : Int
  verification : Grib2VerificationDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4149 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  verification_score : Int
  verification : Grib2VerificationDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4150 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  verification_score : Int
  verification : Grib2VerificationDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4151 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  verification_score : Int
  verification : Grib2VerificationDefinition
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4152 {
  parameter_category : Int
  parameter_number : Int
  atmospheric_chemical_constituent_type : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4153 {
  base : Grib2ProductTemplate4152
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4154 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4155 {
  base : Grib2ProductTemplate4154
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate4254 {
  parameter_category : Int
  parameter_number : Int
  number_of_characters : Int
  character_string : Bytes
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate41000 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate41001 {
  base : Grib2ProductTemplate41000
  number_of_missing_values : Int
  time_range_spec : Grib2TimeRangeSpec
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate41002 {
  base : Grib2ProductTemplate41000
  horizontal_dimension_processed : Int
  treatment_of_missing_data : Int
  statistical_processing_type : Int
  start_of_range : Int
  end_of_range : Int
  number_of_values : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate41100 {
  base : Grib2ProductTemplate40
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate41101 {
  base : Grib2ProductTemplate40
  number_of_missing_values : Int
  time_range_spec : Grib2TimeRangeSpec
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) enum Grib2Section4TemplateData {
  ProductTemplate40(Grib2ProductTemplate40)
  ProductTemplate41(Grib2ProductTemplate41)
  ProductTemplate42(Grib2ProductTemplate42)
  ProductTemplate43(Grib2ProductTemplate43)
  ProductTemplate44(Grib2ProductTemplate44)
  ProductTemplate45(Grib2ProductTemplate45)
  ProductTemplate46(Grib2ProductTemplate46)
  ProductTemplate47(Grib2ProductTemplate47)
  ProductTemplate48(Grib2ProductTemplate48)
  ProductTemplate49(Grib2ProductTemplate49)
  ProductTemplate410(Grib2ProductTemplate410)
  ProductTemplate411(Grib2ProductTemplate411)
  ProductTemplate412(Grib2ProductTemplate412)
  ProductTemplate413(Grib2ProductTemplate413)
  ProductTemplate414(Grib2ProductTemplate414)
  ProductTemplate415(Grib2ProductTemplate415)
  ProductTemplate420(Grib2ProductTemplate420)
  ProductTemplate430(Grib2ProductTemplate430)
  ProductTemplate431(Grib2ProductTemplate431)
  ProductTemplate432(Grib2ProductTemplate432)
  ProductTemplate433(Grib2ProductTemplate433)
  ProductTemplate434(Grib2ProductTemplate434)
  ProductTemplate435(Grib2ProductTemplate435)
  ProductTemplate440(Grib2ProductTemplate440)
  ProductTemplate441(Grib2ProductTemplate441)
  ProductTemplate442(Grib2ProductTemplate442)
  ProductTemplate443(Grib2ProductTemplate443)
  ProductTemplate444(Grib2ProductTemplate444)
  ProductTemplate445(Grib2ProductTemplate445)
  ProductTemplate446(Grib2ProductTemplate446)
  ProductTemplate447(Grib2ProductTemplate447)
  ProductTemplate448(Grib2ProductTemplate448)
  ProductTemplate449(Grib2ProductTemplate449)
  ProductTemplate450(Grib2ProductTemplate450)
  ProductTemplate451(Grib2ProductTemplate451)
  ProductTemplate453(Grib2ProductTemplate453)
  ProductTemplate454(Grib2ProductTemplate454)
  ProductTemplate455(Grib2ProductTemplate455)
  ProductTemplate456(Grib2ProductTemplate456)
  ProductTemplate457(Grib2ProductTemplate457)
  ProductTemplate458(Grib2ProductTemplate458)
  ProductTemplate459(Grib2ProductTemplate459)
  ProductTemplate460(Grib2ProductTemplate460)
  ProductTemplate461(Grib2ProductTemplate461)
  ProductTemplate462(Grib2ProductTemplate462)
  ProductTemplate463(Grib2ProductTemplate463)
  ProductTemplate467(Grib2ProductTemplate467)
  ProductTemplate468(Grib2ProductTemplate468)
  ProductTemplate470(Grib2ProductTemplate470)
  ProductTemplate471(Grib2ProductTemplate471)
  ProductTemplate472(Grib2ProductTemplate472)
  ProductTemplate473(Grib2ProductTemplate473)
  ProductTemplate476(Grib2ProductTemplate476)
  ProductTemplate477(Grib2ProductTemplate477)
  ProductTemplate478(Grib2ProductTemplate478)
  ProductTemplate479(Grib2ProductTemplate479)
  ProductTemplate480(Grib2ProductTemplate480)
  ProductTemplate481(Grib2ProductTemplate481)
  ProductTemplate482(Grib2ProductTemplate482)
  ProductTemplate483(Grib2ProductTemplate483)
  ProductTemplate484(Grib2ProductTemplate484)
  ProductTemplate485(Grib2ProductTemplate485)
  ProductTemplate486(Grib2ProductTemplate486)
  ProductTemplate487(Grib2ProductTemplate487)
  ProductTemplate488(Grib2ProductTemplate488)
  ProductTemplate489(Grib2ProductTemplate489)
  ProductTemplate490(Grib2ProductTemplate490)
  ProductTemplate491(Grib2ProductTemplate491)
  ProductTemplate492(Grib2ProductTemplate492)
  ProductTemplate493(Grib2ProductTemplate493)
  ProductTemplate494(Grib2ProductTemplate494)
  ProductTemplate495(Grib2ProductTemplate495)
  ProductTemplate496(Grib2ProductTemplate496)
  ProductTemplate497(Grib2ProductTemplate497)
  ProductTemplate498(Grib2ProductTemplate498)
  ProductTemplate499(Grib2ProductTemplate499)
  ProductTemplate4100(Grib2ProductTemplate4100)
  ProductTemplate4101(Grib2ProductTemplate4101)
  ProductTemplate4102(Grib2ProductTemplate4102)
  ProductTemplate4103(Grib2ProductTemplate4103)
  ProductTemplate4104(Grib2ProductTemplate4104)
  ProductTemplate4105(Grib2ProductTemplate4105)
  ProductTemplate4106(Grib2ProductTemplate4106)
  ProductTemplate4107(Grib2ProductTemplate4107)
  ProductTemplate4108(Grib2ProductTemplate4108)
  ProductTemplate4109(Grib2ProductTemplate4109)
  ProductTemplate4110(Grib2ProductTemplate4110)
  ProductTemplate4111(Grib2ProductTemplate4111)
  ProductTemplate4112(Grib2ProductTemplate4112)
  ProductTemplate4113(Grib2ProductTemplate4113)
  ProductTemplate4114(Grib2ProductTemplate4114)
  ProductTemplate4115(Grib2ProductTemplate4115)
  ProductTemplate4116(Grib2ProductTemplate4116)
  ProductTemplate4117(Grib2ProductTemplate4117)
  ProductTemplate4118(Grib2ProductTemplate4118)
  ProductTemplate4119(Grib2ProductTemplate4119)
  ProductTemplate4120(Grib2ProductTemplate4120)
  ProductTemplate4121(Grib2ProductTemplate4121)
  ProductTemplate4122(Grib2ProductTemplate4122)
  ProductTemplate4123(Grib2ProductTemplate4123)
  ProductTemplate4124(Grib2ProductTemplate4124)
  ProductTemplate4125(Grib2ProductTemplate4125)
  ProductTemplate4126(Grib2ProductTemplate4126)
  ProductTemplate4127(Grib2ProductTemplate4127)
  ProductTemplate4128(Grib2ProductTemplate4128)
  ProductTemplate4129(Grib2ProductTemplate4129)
  ProductTemplate4130(Grib2ProductTemplate4130)
  ProductTemplate4131(Grib2ProductTemplate4131)
  ProductTemplate4132(Grib2ProductTemplate4132)
  ProductTemplate4133(Grib2ProductTemplate4133)
  ProductTemplate4134(Grib2ProductTemplate4134)
  ProductTemplate4135(Grib2ProductTemplate4135)
  ProductTemplate4136(Grib2ProductTemplate4136)
  ProductTemplate4137(Grib2ProductTemplate4137)
  ProductTemplate4138(Grib2ProductTemplate4138)
  ProductTemplate4139(Grib2ProductTemplate4139)
  ProductTemplate4140(Grib2ProductTemplate4140)
  ProductTemplate4141(Grib2ProductTemplate4141)
  ProductTemplate4142(Grib2ProductTemplate4142)
  ProductTemplate4143(Grib2ProductTemplate4143)
  ProductTemplate4144(Grib2ProductTemplate4144)
  ProductTemplate4145(Grib2ProductTemplate4145)
  ProductTemplate4146(Grib2ProductTemplate4146)
  ProductTemplate4147(Grib2ProductTemplate4147)
  ProductTemplate4148(Grib2ProductTemplate4148)
  ProductTemplate4149(Grib2ProductTemplate4149)
  ProductTemplate4150(Grib2ProductTemplate4150)
  ProductTemplate4151(Grib2ProductTemplate4151)
  ProductTemplate4152(Grib2ProductTemplate4152)
  ProductTemplate4153(Grib2ProductTemplate4153)
  ProductTemplate4154(Grib2ProductTemplate4154)
  ProductTemplate4155(Grib2ProductTemplate4155)
  ProductTemplate4254(Grib2ProductTemplate4254)
  ProductTemplate41000(Grib2ProductTemplate41000)
  ProductTemplate41001(Grib2ProductTemplate41001)
  ProductTemplate41002(Grib2ProductTemplate41002)
  ProductTemplate41100(Grib2ProductTemplate41100)
  ProductTemplate41101(Grib2ProductTemplate41101)
  ProductTemplateUnknown(Int, Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section4Decoded {
  number_of_coordinate_values : Int
  template : Grib2Section4TemplateData
  coordinate_values_raw : Bytes
}
