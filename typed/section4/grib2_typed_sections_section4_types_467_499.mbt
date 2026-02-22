///|
pub(all) struct Grib2ProductTemplate467 {
  parameter_category : Int
  parameter_number : Int
  atmospheric_chemical_constituent_type : Int
  number_of_mode_of_distribution : Int
  mode_number : Int
  type_of_distribution_function : Int
  number_of_following_function_parameters : Int
  function_parameters : Array[Grib2DistributionFunctionParameterSpec]
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
pub(all) struct Grib2ProductTemplate468 {
  parameter_category : Int
  parameter_number : Int
  atmospheric_chemical_constituent_type : Int
  number_of_mode_of_distribution : Int
  mode_number : Int
  type_of_distribution_function : Int
  number_of_following_function_parameters : Int
  function_parameters : Array[Grib2DistributionFunctionParameterSpec]
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
pub(all) struct Grib2ProductTemplate470 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
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
pub(all) struct Grib2ProductTemplate471 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
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
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate472 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
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
pub(all) struct Grib2ProductTemplate473 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
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
pub(all) struct Grib2ProductTemplate476 {
  parameter_category : Int
  parameter_number : Int
  atmospheric_chemical_constituent_type : Int
  source_or_sink : Int
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
pub(all) struct Grib2ProductTemplate477 {
  base : Grib2ProductTemplate476
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate478 {
  base : Grib2ProductTemplate476
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
pub(all) struct Grib2ProductTemplate479 {
  base : Grib2ProductTemplate477
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
pub(all) struct Grib2ProductTemplate480 {
  parameter_category : Int
  parameter_number : Int
  aerosol_type : Int
  source_or_sink : Int
  type_of_interval_for_first_and_second_size : Int
  scale_factor_of_first_size : Int
  scaled_value_of_first_size : Int
  scale_factor_of_second_size : Int
  scaled_value_of_second_size : Int
  type_of_interval_for_first_and_second_wavelength : Int
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
pub(all) struct Grib2ProductTemplate481 {
  base : Grib2ProductTemplate480
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate482 {
  parameter_category : Int
  parameter_number : Int
  aerosol_type : Int
  source_or_sink : Int
  type_of_interval_for_first_and_second_size : Int
  scale_factor_of_first_size : Int
  scaled_value_of_first_size : Int
  scale_factor_of_second_size : Int
  scaled_value_of_second_size : Int
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
pub(all) struct Grib2ProductTemplate483 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  aerosol_type : Int
  source_or_sink : Int
  type_of_interval_for_first_and_second_size : Int
  scale_factor_of_first_size : Int
  scaled_value_of_first_size : Int
  scale_factor_of_second_size : Int
  scaled_value_of_second_size : Int
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
pub(all) struct Grib2ProductTemplate484 {
  parameter_category : Int
  parameter_number : Int
  aerosol_type : Int
  source_or_sink : Int
  type_of_interval_for_first_and_second_size : Int
  scale_factor_of_first_size : Int
  scaled_value_of_first_size : Int
  scale_factor_of_second_size : Int
  scaled_value_of_second_size : Int
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
pub(all) struct Grib2ProductTemplate485 {
  parameter_category : Int
  parameter_number : Int
  aerosol_type : Int
  type_of_interval_for_first_and_second_size : Int
  scale_factor_of_first_size : Int
  scaled_value_of_first_size : Int
  scale_factor_of_second_size : Int
  scaled_value_of_second_size : Int
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
pub(all) struct Grib2ProductTemplate486 {
  parameter_category : Int
  parameter_number : Int
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
  total_number_of_quantiles : Int
  quantile_value : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate487 {
  base : Grib2ProductTemplate486
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
pub(all) struct Grib2ProductTemplate488 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_analyses_or_forecasts_used : Int
  analysis_or_forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate489 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
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
  total_number_of_quantiles : Int
  quantile_value : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate490 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
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
  total_number_of_quantiles : Int
  quantile_value : Int
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
pub(all) struct Grib2ProductTemplate491 {
  parameter_category : Int
  parameter_number : Int
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
  number_of_categories : Int
  categories : Array[Grib2CategoryForecastSpec]
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
pub(all) struct Grib2ProductTemplate492 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate493 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate494 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate495 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  statistical_process_used_to_calculate_fields_for_local_time_processing : Int
  statistical_processing_time_range_unit : Int
  statistical_processing_time_range_length : Int
  number_of_statistically_processed_fields_in_local_time_composite : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate496 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  statistical_process_used_to_calculate_fields_for_local_time_processing : Int
  statistical_processing_time_range_unit : Int
  statistical_processing_time_range_length : Int
  number_of_statistically_processed_fields_in_local_time_composite : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate497 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  statistical_process_used_to_calculate_fields_for_local_time_processing : Int
  statistical_processing_time_range_unit : Int
  statistical_processing_time_range_length : Int
  number_of_statistically_processed_fields_in_local_time_composite : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate498 {
  parameter_category : Int
  parameter_number : Int
  input_process_identifier : Int
  input_originating_centre : Int
  type_of_post_processing : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  type_of_first_fixed_surface : Int
  scale_factor_of_first_fixed_surface : Int
  scaled_value_of_first_fixed_surface : Int
  type_of_second_fixed_surface : Int
  scale_factor_of_second_fixed_surface : Int
  scaled_value_of_second_fixed_surface : Int
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  statistical_process_used_to_calculate_fields_for_local_time_processing : Int
  statistical_processing_time_range_unit : Int
  statistical_processing_time_range_length : Int
  number_of_statistically_processed_fields_in_local_time_composite : Int
  method_used_to_derive_data_field_values_at_local_time : Int
  number_of_forecasts_used : Int
  forecast_specs : Array[Grib2Template488AnalysisForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate499 {
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
  scale_factor_of_wave_directions : Int
  scaled_wave_directions : Array[Int]
  scale_factor_of_wave_frequencies : Int
  scaled_wave_frequencies : Array[Int]
  reserved_tail : Bytes
} derive(Show)
