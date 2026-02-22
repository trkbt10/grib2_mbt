///|
pub(all) struct Grib2ProductTemplate40 {
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
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate41 {
  base : Grib2ProductTemplate40
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate42 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate43 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  cluster_identifier : Int
  cluster_for_high_resolution_control : Int
  cluster_for_low_resolution_control : Int
  total_number_of_clusters : Int
  clustering_method : Int
  northern_latitude_of_cluster_domain : Int
  southern_latitude_of_cluster_domain : Int
  eastern_longitude_of_cluster_domain : Int
  western_longitude_of_cluster_domain : Int
  number_of_forecasts_in_cluster : Int
  scale_factor_of_standard_deviation : Int
  scaled_value_of_standard_deviation : Int
  scale_factor_of_distance_from_ensemble_mean : Int
  scaled_value_of_distance_from_ensemble_mean : Int
  ensemble_forecast_numbers : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate44 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  cluster_identifier : Int
  cluster_for_high_resolution_control : Int
  cluster_for_low_resolution_control : Int
  total_number_of_clusters : Int
  clustering_method : Int
  latitude_of_central_point : Int
  longitude_of_central_point : Int
  radius_of_cluster_domain : Int
  number_of_forecasts_in_cluster : Int
  scale_factor_of_standard_deviation : Int
  scaled_value_of_standard_deviation : Int
  scale_factor_of_distance_from_ensemble_mean : Int
  scaled_value_of_distance_from_ensemble_mean : Int
  ensemble_forecast_numbers : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate45 {
  base : Grib2ProductTemplate40
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
pub(all) struct Grib2ProductTemplate46 {
  base : Grib2ProductTemplate40
  percentile_value : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate47 {
  base : Grib2ProductTemplate40
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2TimeRangeSpec {
  statistical_process : Int
  type_of_time_increment : Int
  time_range_unit : Int
  time_range_length : Int
  time_increment_unit : Int
  time_increment_length : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate48 {
  base : Grib2ProductTemplate40
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
pub(all) struct Grib2ProductTemplate49 {
  base : Grib2ProductTemplate45
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
pub(all) struct Grib2ProductTemplate410 {
  base : Grib2ProductTemplate46
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
pub(all) struct Grib2ProductTemplate411 {
  base : Grib2ProductTemplate41
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
pub(all) struct Grib2ProductTemplate412 {
  base : Grib2ProductTemplate42
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
pub(all) struct Grib2ProductTemplate413 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  cluster_identifier : Int
  cluster_for_high_resolution_control : Int
  cluster_for_low_resolution_control : Int
  total_number_of_clusters : Int
  clustering_method : Int
  northern_latitude_of_cluster_domain : Int
  southern_latitude_of_cluster_domain : Int
  eastern_longitude_of_cluster_domain : Int
  western_longitude_of_cluster_domain : Int
  number_of_forecasts_in_cluster : Int
  scale_factor_of_standard_deviation : Int
  scaled_value_of_standard_deviation : Int
  scale_factor_of_distance_from_ensemble_mean : Int
  scaled_value_of_distance_from_ensemble_mean : Int
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  ensemble_forecast_numbers : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate414 {
  base : Grib2ProductTemplate40
  derived_forecast : Int
  number_of_forecasts_in_ensemble : Int
  cluster_identifier : Int
  cluster_for_high_resolution_control : Int
  cluster_for_low_resolution_control : Int
  total_number_of_clusters : Int
  clustering_method : Int
  latitude_of_central_point : Int
  longitude_of_central_point : Int
  radius_of_cluster_domain : Int
  number_of_forecasts_in_cluster : Int
  scale_factor_of_standard_deviation : Int
  scaled_value_of_standard_deviation : Int
  scale_factor_of_distance_from_ensemble_mean : Int
  scaled_value_of_distance_from_ensemble_mean : Int
  end_year : Int
  end_month : Int
  end_day : Int
  end_hour : Int
  end_minute : Int
  end_second : Int
  number_of_time_ranges : Int
  number_of_missing_values : Int
  time_range_specs : Array[Grib2TimeRangeSpec]
  ensemble_forecast_numbers : Array[Int]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate415 {
  base : Grib2ProductTemplate40
  statistical_process_within_spatial_area : Int
  type_of_spatial_processing : Int
  number_of_data_points_used : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate420 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  number_of_radar_sites_used : Int
  indicator_of_unit_time_range : Int
  site_latitude : Int
  site_longitude : Int
  site_elevation : Int
  site_identifier_alphanumeric : Int
  site_identifier_numeric : Int
  operating_mode : Int
  reflectivity_calibration_constant : Int
  quality_control_indicator : Int
  clutter_filter_indicator : Int
  constant_antenna_elevation_angle : Int
  accumulation_interval : Int
  reference_reflectivity : Int
  range_bin_spacing : Int
  radial_angular_spacing : Int
} derive(Show)

///|
pub(all) struct Grib2SatelliteBandSpec {
  satellite_series : Int
  satellite_number : Int
  instrument_type : Int
  scale_factor_of_central_wave_number : Int
  scaled_value_of_central_wave_number : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate430 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  observation_generating_process_identifier : Int
  number_of_contributing_spectral_bands : Int
  bands : Array[Grib2SatelliteBandSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate431 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  observation_generating_process_identifier : Int
  number_of_contributing_spectral_bands : Int
  bands : Array[Grib2SatelliteBandSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate432 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  number_of_contributing_spectral_bands : Int
  bands : Array[Grib2SatelliteBandSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate433 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  number_of_contributing_spectral_bands : Int
  bands : Array[Grib2SatelliteBandSpec]
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate434 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  background_process_identifier : Int
  generating_process_identifier : Int
  hours_of_observational_data_cutoff : Int
  minutes_of_observational_data_cutoff : Int
  time_range_unit : Int
  forecast_time : Int
  number_of_contributing_spectral_bands : Int
  bands : Array[Grib2SatelliteBandSpec]
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
pub(all) struct Grib2ProductTemplate435 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  observation_generating_process_identifier : Int
  quality_value_associated_with_parameter : Int
  number_of_contributing_spectral_bands : Int
  bands : Array[Grib2SatelliteBandSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate440 {
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
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate441 {
  base : Grib2ProductTemplate440
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate442 {
  base : Grib2ProductTemplate440
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
pub(all) struct Grib2ProductTemplate443 {
  base : Grib2ProductTemplate441
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
pub(all) struct Grib2ProductTemplate444 {
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
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate445 {
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
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate446 {
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
pub(all) struct Grib2ProductTemplate447 {
  parameter_category : Int
  parameter_number : Int
  type_of_generating_process : Int
  aerosol_type : Int
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
pub(all) struct Grib2ProductTemplate448 {
  parameter_category : Int
  parameter_number : Int
  aerosol_type : Int
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
pub(all) struct Grib2ProductTemplate449 {
  parameter_category : Int
  parameter_number : Int
  aerosol_type : Int
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
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate450 {
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
} derive(Show)

///|
pub(all) struct Grib2CategoryForecastSpec {
  code_figure : Int
  type_of_interval_for_first_and_second_limit : Int
  scale_factor_of_first_limit : Int
  scaled_value_of_first_limit : Int
  scale_factor_of_second_limit : Int
  scaled_value_of_second_limit : Int
} derive(Show)

///|
pub(all) struct Grib2DistributionFunctionParameterSpec {
  scale_factor_of_fixed_distribution_function_parameter : Int
  scaled_value_of_fixed_distribution_function_parameter : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate451 {
  base : Grib2ProductTemplate40
  number_of_categories : Int
  categories : Array[Grib2CategoryForecastSpec]
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate453 {
  parameter_category : Int
  parameter_number : Int
  partition_table_number : Int
  number_of_partitions : Int
  partition_set : Array[Int]
  partition_number : Int
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
pub(all) struct Grib2ProductTemplate454 {
  parameter_category : Int
  parameter_number : Int
  partition_table_number : Int
  number_of_partitions : Int
  partition_set : Array[Int]
  partition_number : Int
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
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate455 {
  parameter_category : Int
  parameter_number : Int
  tile_classification : Int
  total_number_of_tile_attribute_pairs : Int
  number_of_used_spatial_tiles : Int
  tile_index : Int
  number_of_used_tile_attributes : Int
  tile_attribute : Int
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
pub(all) struct Grib2ProductTemplate456 {
  parameter_category : Int
  parameter_number : Int
  tile_classification : Int
  total_number_of_tile_attribute_pairs : Int
  number_of_used_spatial_tiles : Int
  tile_index : Int
  number_of_used_tile_attributes : Int
  tile_attribute : Int
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
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate457 {
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
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate458 {
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
  reserved_tail : Bytes
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate459 {
  parameter_category : Int
  parameter_number : Int
  tile_classification : Int
  total_number_of_tile_attribute_pairs : Int
  number_of_used_spatial_tiles : Int
  tile_index : Int
  number_of_used_tile_attributes : Int
  tile_attribute : Int
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
pub(all) struct Grib2ProductTemplate460 {
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
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
} derive(Show)

///|
pub(all) struct Grib2ProductTemplate461 {
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
  type_of_ensemble_forecast : Int
  perturbation_number : Int
  number_of_forecasts_in_ensemble : Int
  year_of_model_version_date : Int
  month_of_model_version_date : Int
  day_of_model_version_date : Int
  hour_of_model_version_date : Int
  minute_of_model_version_date : Int
  second_of_model_version_date : Int
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
pub(all) struct Grib2ProductTemplate462 {
  parameter_category : Int
  parameter_number : Int
  tile_classification : Int
  total_number_of_tile_attribute_pairs : Int
  number_of_used_spatial_tiles : Int
  tile_index : Int
  number_of_used_tile_attributes : Int
  tile_attribute : Int
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
pub(all) struct Grib2ProductTemplate463 {
  parameter_category : Int
  parameter_number : Int
  tile_classification : Int
  total_number_of_tile_attribute_pairs : Int
  number_of_used_spatial_tiles : Int
  tile_index : Int
  number_of_used_tile_attributes : Int
  tile_attribute : Int
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
pub(all) struct Grib2Template488AnalysisForecastSpec {
  year : Int
  month : Int
  day : Int
  hour : Int
  minute : Int
  second : Int
  forecast_time_unit : Int
  forecast_time : Int
  number_of_time_increments : Int
  time_increment_unit : Int
  time_increment_length : Int
} derive(Show)

///|
pub(all) struct Grib2WaveSequenceParameter {
  scale_factor : Int
  scaled_value : Int
} derive(Show)

///|
pub(all) struct Grib2ReferencePeriodAdditionalParameter {
  scale_factor : Int
  scaled_value : Int
} derive(Show)

///|
pub(all) struct Grib2ReferencePeriodTimeRangeSpec {
  statistical_processing_type : Int
  time_range_unit : Int
  time_range_length : Int
} derive(Show)

///|
pub(all) struct Grib2VerificationAdditionalArgument {
  scale_factor : Int
  scaled_value : Int
} derive(Show)

///|
pub(all) struct Grib2VerificationPeriodTimeRangeSpec {
  statistical_processing_type : Int
  time_range_unit : Int
  time_range_length : Int
  time_increment_unit : Int
  time_increment_length : Int
} derive(Show)

///|
pub(all) struct Grib2VerificationDefinition {
  type_of_reference_dataset : Int
  type_of_statistical_processing_over_vertical : Int
  type_of_threshold_operator : Int
  type_of_additional_arguments : Int
  number_of_additional_arguments : Int
  additional_arguments : Array[Grib2VerificationAdditionalArgument]
  start_year : Int
  start_month : Int
  start_day : Int
  start_hour : Int
  start_minute : Int
  start_second : Int
  number_of_verification_period_time_ranges : Int
  verification_period_time_range_specs : Array[
    Grib2VerificationPeriodTimeRangeSpec,
  ]
  number_of_forecasts_in_verification : Int
} derive(Show)

///|
pub(all) struct Grib2ReferencePeriodDefinition {
  type_of_reference_dataset : Int
  type_of_relation_to_reference_dataset : Int
  number_of_additional_parameters : Int
  additional_parameters : Array[Grib2ReferencePeriodAdditionalParameter]
  start_year : Int
  start_month : Int
  start_day : Int
  start_hour : Int
  start_minute : Int
  start_second : Int
  sample_size : Int
  number_of_reference_period_time_ranges : Int
  reference_period_time_range_specs : Array[Grib2ReferencePeriodTimeRangeSpec]
} derive(Show)

///|
pub(all) struct Grib2GeneralizedTileDefinition {
  tile_classification : Int
  type_of_tile : Int
  number_of_used_spatial_tiles : Int
  number_of_used_tile_attribute_combinations_for_type_of_tile : Int
  number_of_used_tile_attributes : Int
  tile_attributes : Array[Int]
  total_number_of_tile_attribute_combinations : Int
  tile_index : Int
  uuid_of_data_group : Bytes
} derive(Show)

///|
pub(all) struct Grib2SpatialVicinityDefinition {
  spatial_vicinity_type : Int
  number_of_spatial_vicinity_values : Int
  spatial_vicinity_values : Array[Int]
  spatial_vicinity_processing : Int
  spatial_vicinity_processing_argument1 : Int
  spatial_vicinity_processing_argument2 : Int
  spatial_vicinity_missing_data : Int
  temporal_vicinity_processing : Int
  temporal_vicinity_unit : Int
  temporal_vicinity_towards_past : Int
  temporal_vicinity_towards_future : Int
} derive(Show)
