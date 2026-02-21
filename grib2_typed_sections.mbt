///|
pub(all) suberror Grib2SectionCodecError {
  InvalidSectionLength(String)
  InvalidSectionNumber(String)
  UnsupportedTemplate(String)
} derive(Show)

///|
pub(all) enum Grib2IdTemplate {
  IdTemplateNone
  IdTemplate10(Int)
  IdTemplate11(Int)
  IdTemplate12(Int, Int)
  IdTemplateUnknown(Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section1Decoded {
  center : Int
  subcenter : Int
  master_table_version : Int
  local_table_version : Int
  significance_of_reference_time : Int
  reference_year : Int
  reference_month : Int
  reference_day : Int
  reference_hour : Int
  reference_minute : Int
  reference_second : Int
  production_status : Int
  processed_data_type : Int
  identification_template : Grib2IdTemplate
  reserved_octets_22_23 : Bytes
  reserved_tail : Bytes
}

///|
pub(all) struct Grib2U64Be {
  high : Int
  low : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate30 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  ni : Int
  nj : Int
  basic_angle : Int
  subdivisions_of_basic_angle : Int
  la1 : Int
  lo1 : Int
  resolution_and_component_flags : Int
  la2 : Int
  lo2 : Int
  di : Int
  dj : Int
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate31 {
  base : Grib2GridTemplate30
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate32 {
  base : Grib2GridTemplate30
  latitude_of_stretching_pole : Int
  longitude_of_stretching_pole : Int
  stretching_factor : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate33 {
  base : Grib2GridTemplate30
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
  latitude_of_stretching_pole : Int
  longitude_of_stretching_pole : Int
  stretching_factor : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate34 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  ni : Int
  nj : Int
  basic_angle : Int
  subdivisions_of_basic_angle : Int
  resolution_and_component_flags : Int
  scanning_mode : Int
  longitude_list : Array[Int]
  latitude_list : Array[Int]
} derive(Show)

///|
pub(all) struct Grib2GridTemplate35 {
  base : Grib2GridTemplate34
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate310 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  ni : Int
  nj : Int
  la1 : Int
  lo1 : Int
  resolution_and_component_flags : Int
  lad : Int
  la2 : Int
  lo2 : Int
  scanning_mode : Int
  orientation_of_the_grid : Int
  di : Int
  dj : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate312 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  ni : Int
  nj : Int
  lar : Int
  lor : Int
  resolution_and_component_flags : Int
  m : Int
  xr : Int
  yr : Int
  scanning_mode : Int
  di : Int
  dj : Int
  x1 : Int
  y1 : Int
  x2 : Int
  y2 : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate313 {
  base : Grib2GridTemplate310
  nux : Int
  ncx : Int
  nuy : Int
  ncy : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate320 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  nx : Int
  ny : Int
  la1 : Int
  lo1 : Int
  resolution_and_component_flags : Int
  lad : Int
  lov : Int
  dx : Int
  dy : Int
  projection_center_flag : Int
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate323 {
  base : Grib2GridTemplate320
  nux : Int
  ncx : Int
  nuy : Int
  ncy : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate330 {
  base : Grib2GridTemplate320
  latin1 : Int
  latin2 : Int
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate331 {
  base : Grib2GridTemplate330
} derive(Show)

///|
pub(all) struct Grib2GridTemplate333 {
  base : Grib2GridTemplate330
  nux : Int
  ncx : Int
  nuy : Int
  ncy : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate340 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  ni : Int
  nj : Int
  basic_angle : Int
  subdivisions_of_basic_angle : Int
  la1 : Int
  lo1 : Int
  resolution_and_component_flags : Int
  la2 : Int
  lo2 : Int
  di : Int
  n : Int
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate341 {
  base : Grib2GridTemplate340
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate342 {
  base : Grib2GridTemplate340
  latitude_of_stretching_pole : Int
  longitude_of_stretching_pole : Int
  stretching_factor : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate343 {
  base : Grib2GridTemplate340
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
  latitude_of_stretching_pole : Int
  longitude_of_stretching_pole : Int
  stretching_factor : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate350 {
  j : Int
  k : Int
  m : Int
  representation_type : Int
  representation_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate351 {
  base : Grib2GridTemplate350
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate352 {
  base : Grib2GridTemplate350
  latitude_of_stretching_pole : Int
  longitude_of_stretching_pole : Int
  stretching_factor : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate353 {
  base : Grib2GridTemplate350
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
  latitude_of_stretching_pole : Int
  longitude_of_stretching_pole : Int
  stretching_factor : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate360 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  nx : Int
  ny : Int
  nc : Int
  xshift : Int
  yshift : Int
  face_number : Int
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
  angle_of_rotation : Int
  stretching_factor : Int
  gnomonic_grid_spacing_parameter : Int
  resolution_and_component_flags : Int
  scanning_and_staggering_flags : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate361 {
  spectral_representation_type : Int
  n : Int
  m : Int
  bi_fourier_truncation_type : Int
  lx : Grib2U64Be
  lux : Grib2U64Be
  lcx : Grib2U64Be
  ly : Grib2U64Be
  luy : Grib2U64Be
  lcy : Grib2U64Be
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  la1 : Int
  lo1 : Int
  lad : Int
  la2 : Int
  lo2 : Int
  orientation_of_the_grid : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate362 {
  spectral_representation_type : Int
  n : Int
  m : Int
  bi_fourier_truncation_type : Int
  lx : Grib2U64Be
  lux : Grib2U64Be
  lcx : Grib2U64Be
  ly : Grib2U64Be
  luy : Grib2U64Be
  lcy : Grib2U64Be
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  la1 : Int
  lo1 : Int
  resolution_and_component_flags : Int
  lad : Int
  lov : Int
  projection_center_flag : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate363 {
  spectral_representation_type : Int
  n : Int
  m : Int
  bi_fourier_truncation_type : Int
  lx : Grib2U64Be
  lux : Grib2U64Be
  lcx : Grib2U64Be
  ly : Grib2U64Be
  luy : Grib2U64Be
  lcy : Grib2U64Be
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  la1 : Int
  lo1 : Int
  lad : Int
  lov : Int
  projection_center_flag : Int
  latin1 : Int
  latin2 : Int
  latitude_of_southern_pole : Int
  longitude_of_southern_pole : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate390 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  nx : Int
  ny : Int
  latitude_of_sub_satellite_point : Int
  longitude_of_sub_satellite_point : Int
  resolution_and_component_flags : Int
  dx : Int
  dy : Int
  xp : Int
  yp : Int
  scanning_mode : Int
  orientation_of_the_grid : Int
  nr : Int
  xo : Int
  yo : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3100 {
  n2 : Int
  n3 : Int
  ni : Int
  nd : Int
  latitude_of_the_pole_point : Int
  longitude_of_the_pole_point : Int
  longitude_of_the_centre_line_of_first_diamond : Int
  grid_point_position : Int
  numbering_order_of_diamonds : Int
  scanning_mode_for_one_diamond : Int
  nt : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3101 {
  shape_of_earth : Int
  number_of_grid_used : Int
  number_of_grid_in_reference : Int
  uuid_of_horizontal_grid : Bytes
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3110 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  nx : Int
  ny : Int
  latitude_of_tangency_point : Int
  longitude_of_tangency_point : Int
  resolution_and_component_flags : Int
  dx : Int
  dy : Int
  projection_center_flag : Int
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2AzimuthRangeRadial {
  starting_azimuth : Int
  azimuthal_width : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3120 {
  nb : Int
  nr : Int
  la1 : Int
  lo1 : Int
  dx : Int
  dstart : Int
  scanning_mode : Int
  radials : Array[Grib2AzimuthRangeRadial]
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3140 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  nx : Int
  ny : Int
  la1 : Int
  lo1 : Int
  standard_parallel : Int
  central_longitude : Int
  resolution_and_component_flags : Int
  dx : Int
  dy : Int
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3150 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  resolution_and_component_flags : Int
  nsides : Int
  lo : Int
  grid_point_position : Int
  numbering_order : Int
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate3204 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  ni : Int
  nj : Int
  reserved_octets_39_54 : Bytes
  resolution_and_component_flags : Int
  reserved_octets_56_71 : Bytes
  scanning_mode : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate31000 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  number_of_horizontal_points : Int
  basic_angle : Int
  subdivisions_of_basic_angle : Int
  la1 : Int
  lo1 : Int
  scanning_mode : Int
  la2 : Int
  lo2 : Int
  type_of_horizontal_line : Int
  number_of_vertical_points : Int
  physical_meaning_of_vertical_coordinate : Int
  vertical_dimension_coordinate_values_definition : Int
  nc : Int
  vertical_coordinate_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2GridTemplate31100 {
  shape_of_earth : Int
  scale_factor_radius : Int
  scaled_value_radius : Int
  scale_factor_major_axis : Int
  scaled_value_major_axis : Int
  scale_factor_minor_axis : Int
  scaled_value_minor_axis : Int
  number_of_horizontal_points : Int
  basic_angle : Int
  subdivisions_of_basic_angle : Int
  la1 : Int
  lo1 : Int
  scanning_mode : Int
  la2 : Int
  lo2 : Int
  type_of_horizontal_line : Int
  nt : Int
  unit_of_offset_from_reference_time : Int
  offset_from_reference_of_first_time : Int
  type_of_time_increment : Int
  unit_of_time_increment : Int
  time_increment : Int
  last_year : Int
  last_month : Int
  last_day : Int
  last_hour : Int
  last_minute : Int
  last_second : Int
} derive(Show)

///|
pub(all) struct Grib2GridTemplate31200 {
  nt : Int
  unit_of_offset_from_reference_time : Int
  offset_from_reference_of_first_time : Int
  type_of_time_increment : Int
  unit_of_time_increment : Int
  time_increment : Int
  last_year : Int
  last_month : Int
  last_day : Int
  last_hour : Int
  last_minute : Int
  last_second : Int
  number_of_vertical_points : Int
  physical_meaning_of_vertical_coordinate : Int
  vertical_dimension_coordinate_values_definition : Int
  nc : Int
  vertical_coordinate_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2GridTemplate332768 {
  base : Grib2GridTemplate30
} derive(Show)

///|
pub(all) struct Grib2GridTemplate332769 {
  base : Grib2GridTemplate30
  latitude_of_grid_point_ni_nj : Int
  longitude_of_grid_point_ni_nj : Int
} derive(Show)

///|
pub(all) enum Grib2Section3TemplateData {
  GridTemplate30(Grib2GridTemplate30)
  GridTemplate31(Grib2GridTemplate31)
  GridTemplate32(Grib2GridTemplate32)
  GridTemplate33(Grib2GridTemplate33)
  GridTemplate34(Grib2GridTemplate34)
  GridTemplate35(Grib2GridTemplate35)
  GridTemplate310(Grib2GridTemplate310)
  GridTemplate312(Grib2GridTemplate312)
  GridTemplate313(Grib2GridTemplate313)
  GridTemplate320(Grib2GridTemplate320)
  GridTemplate323(Grib2GridTemplate323)
  GridTemplate330(Grib2GridTemplate330)
  GridTemplate331(Grib2GridTemplate331)
  GridTemplate333(Grib2GridTemplate333)
  GridTemplate340(Grib2GridTemplate340)
  GridTemplate341(Grib2GridTemplate341)
  GridTemplate342(Grib2GridTemplate342)
  GridTemplate343(Grib2GridTemplate343)
  GridTemplate350(Grib2GridTemplate350)
  GridTemplate351(Grib2GridTemplate351)
  GridTemplate352(Grib2GridTemplate352)
  GridTemplate353(Grib2GridTemplate353)
  GridTemplate360(Grib2GridTemplate360)
  GridTemplate361(Grib2GridTemplate361)
  GridTemplate362(Grib2GridTemplate362)
  GridTemplate363(Grib2GridTemplate363)
  GridTemplate390(Grib2GridTemplate390)
  GridTemplate3100(Grib2GridTemplate3100)
  GridTemplate3101(Grib2GridTemplate3101)
  GridTemplate3110(Grib2GridTemplate3110)
  GridTemplate3120(Grib2GridTemplate3120)
  GridTemplate3140(Grib2GridTemplate3140)
  GridTemplate3150(Grib2GridTemplate3150)
  GridTemplate3204(Grib2GridTemplate3204)
  GridTemplate31000(Grib2GridTemplate31000)
  GridTemplate31100(Grib2GridTemplate31100)
  GridTemplate31200(Grib2GridTemplate31200)
  GridTemplate332768(Grib2GridTemplate332768)
  GridTemplate332769(Grib2GridTemplate332769)
  GridTemplateUnknown(Int, Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section3Decoded {
  source_of_grid_definition : Int
  number_of_data_points : Int
  optional_points_octet_count : Int
  optional_points_interpretation : Int
  template : Grib2Section3TemplateData
  optional_points_raw : Bytes
}

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
  ProductTemplateUnknown(Int, Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section4Decoded {
  number_of_coordinate_values : Int
  template : Grib2Section4TemplateData
  coordinate_values_raw : Bytes
}

///|
fn typed_read_u16_be(bytes : Bytes, offset : Int) -> Int {
  bytes.unsafe_read_uint16_be(offset).to_uint().reinterpret_as_int()
}

///|
fn typed_read_u32_be(bytes : Bytes, offset : Int) -> Int {
  bytes.unsafe_read_uint32_be(offset).reinterpret_as_int()
}

///|
fn typed_read_u16_be_view(bytes : BytesView, offset : Int) -> Int {
  bytes.unsafe_read_uint16_be(offset).to_uint().reinterpret_as_int()
}

///|
fn typed_read_u32_be_view(bytes : BytesView, offset : Int) -> Int {
  bytes.unsafe_read_uint32_be(offset).reinterpret_as_int()
}

///|
fn typed_read_u24_be_view(bytes : BytesView, offset : Int) -> Int {
  let b0 = bytes[offset].to_uint().reinterpret_as_int()
  let b1 = bytes[offset + 1].to_uint().reinterpret_as_int()
  let b2 = bytes[offset + 2].to_uint().reinterpret_as_int()
  (b0 << 16) | (b1 << 8) | b2
}

///|
fn typed_read_u64_be_view(bytes : BytesView, offset : Int) -> Grib2U64Be {
  {
    high: typed_read_u32_be_view(bytes, offset),
    low: typed_read_u32_be_view(bytes, offset + 4),
  }
}

///|
fn typed_push_u16_be(out : Array[Byte], value : Int) -> Unit {
  out.push(((value >> 8) & 0xff).to_byte())
  out.push((value & 0xff).to_byte())
}

///|
fn typed_push_u32_be(out : Array[Byte], value : Int) -> Unit {
  out.push(((value >> 24) & 0xff).to_byte())
  out.push(((value >> 16) & 0xff).to_byte())
  out.push(((value >> 8) & 0xff).to_byte())
  out.push((value & 0xff).to_byte())
}

///|
fn typed_push_u24_be(out : Array[Byte], value : Int) -> Unit {
  out.push(((value >> 16) & 0xff).to_byte())
  out.push(((value >> 8) & 0xff).to_byte())
  out.push((value & 0xff).to_byte())
}

///|
fn typed_push_u64_be(out : Array[Byte], value : Grib2U64Be) -> Unit {
  typed_push_u32_be(out, value.high)
  typed_push_u32_be(out, value.low)
}

///|
fn typed_validate_section_header(
  section : Bytes,
  expected_number : Int,
) -> Result[Unit, Grib2SectionCodecError] {
  if section.length() < 5 {
    return Err(
      InvalidSectionLength(
        "section header too short: " + section.length().to_string(),
      ),
    )
  }
  let declared = typed_read_u32_be(section, 0)
  if declared != section.length() {
    return Err(
      InvalidSectionLength(
        "declared section length mismatch: declared=" +
        declared.to_string() +
        ", actual=" +
        section.length().to_string(),
      ),
    )
  }
  let number = section[4].to_uint().reinterpret_as_int()
  if number != expected_number {
    return Err(
      InvalidSectionNumber(
        "expected section " +
        expected_number.to_string() +
        ", got " +
        number.to_string(),
      ),
    )
  }
  Ok(())
}

///|
fn typed_build_section(section_number : Int, payload : Bytes) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, 5 + payload.length())
  out.push(section_number.to_byte())
  for b in payload {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_id_template_raw(template : Grib2IdTemplate) -> Bytes {
  match template {
    IdTemplateNone => b""
    IdTemplate10(calendar_type) => Bytes::from_array([calendar_type.to_byte()])
    IdTemplate11(paleo_offset) => {
      let out : Array[Byte] = []
      typed_push_u16_be(out, paleo_offset)
      Bytes::from_array(out)
    }
    IdTemplate12(calendar_type, paleo_offset) => {
      let out : Array[Byte] = [calendar_type.to_byte()]
      typed_push_u16_be(out, paleo_offset)
      Bytes::from_array(out)
    }
    IdTemplateUnknown(raw) => raw
  }
}

///|
pub fn decode_section1_bytes(
  section : Bytes,
) -> Result[Grib2Section1Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 1) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 21 {
    return Err(
      InvalidSectionLength(
        "section1 too short: " + section.length().to_string(),
      ),
    )
  }
  let reserved_octets_22_23 = if section.length() <= 21 {
    b""
  } else if section.length() == 22 {
    section.sub(start=21, end=22).to_bytes()
  } else {
    section.sub(start=21, end=23).to_bytes()
  }
  let (identification_template, reserved_tail) = if section.length() <= 23 {
    (IdTemplateNone, b"")
  } else if section.length() == 24 {
    (IdTemplate10(section[23].to_uint().reinterpret_as_int()), b"")
  } else if section.length() == 25 {
    (IdTemplate11(typed_read_u16_be(section, 23)), b"")
  } else {
    (
      IdTemplate12(
        section[23].to_uint().reinterpret_as_int(),
        typed_read_u16_be(section, 24),
      ),
      section.sub(start=26).to_bytes(),
    )
  }
  Ok({
    center: typed_read_u16_be(section, 5),
    subcenter: typed_read_u16_be(section, 7),
    master_table_version: section[9].to_uint().reinterpret_as_int(),
    local_table_version: section[10].to_uint().reinterpret_as_int(),
    significance_of_reference_time: section[11].to_uint().reinterpret_as_int(),
    reference_year: typed_read_u16_be(section, 12),
    reference_month: section[14].to_uint().reinterpret_as_int(),
    reference_day: section[15].to_uint().reinterpret_as_int(),
    reference_hour: section[16].to_uint().reinterpret_as_int(),
    reference_minute: section[17].to_uint().reinterpret_as_int(),
    reference_second: section[18].to_uint().reinterpret_as_int(),
    production_status: section[19].to_uint().reinterpret_as_int(),
    processed_data_type: section[20].to_uint().reinterpret_as_int(),
    identification_template,
    reserved_octets_22_23,
    reserved_tail,
  })
}

///|
pub fn encode_section1_bytes(section : Grib2Section1Decoded) -> Bytes {
  let payload : Array[Byte] = []
  typed_push_u16_be(payload, section.center)
  typed_push_u16_be(payload, section.subcenter)
  payload.push(section.master_table_version.to_byte())
  payload.push(section.local_table_version.to_byte())
  payload.push(section.significance_of_reference_time.to_byte())
  typed_push_u16_be(payload, section.reference_year)
  payload.push(section.reference_month.to_byte())
  payload.push(section.reference_day.to_byte())
  payload.push(section.reference_hour.to_byte())
  payload.push(section.reference_minute.to_byte())
  payload.push(section.reference_second.to_byte())
  payload.push(section.production_status.to_byte())
  payload.push(section.processed_data_type.to_byte())
  for b in section.reserved_octets_22_23 {
    payload.push(b)
  }
  let template_raw = typed_id_template_raw(section.identification_template)
  for b in template_raw {
    payload.push(b)
  }
  for b in section.reserved_tail {
    payload.push(b)
  }
  typed_build_section(1, Bytes::from_array(payload))
}

///|
fn typed_decode_latlon_base(
  template_payload : BytesView,
  template_name : String,
) -> Result[Grib2GridTemplate30, Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      InvalidSectionLength(
        template_name + " too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let t = template_payload.sub(end=58)
  Ok({
    shape_of_earth: t[0].to_uint().reinterpret_as_int(),
    scale_factor_radius: t[1].to_uint().reinterpret_as_int(),
    scaled_value_radius: typed_read_u32_be_view(t, 2),
    scale_factor_major_axis: t[6].to_uint().reinterpret_as_int(),
    scaled_value_major_axis: typed_read_u32_be_view(t, 7),
    scale_factor_minor_axis: t[11].to_uint().reinterpret_as_int(),
    scaled_value_minor_axis: typed_read_u32_be_view(t, 12),
    ni: typed_read_u32_be_view(t, 16),
    nj: typed_read_u32_be_view(t, 20),
    basic_angle: typed_read_u32_be_view(t, 24),
    subdivisions_of_basic_angle: typed_read_u32_be_view(t, 28),
    la1: typed_read_u32_be_view(t, 32),
    lo1: typed_read_u32_be_view(t, 36),
    resolution_and_component_flags: t[40].to_uint().reinterpret_as_int(),
    la2: typed_read_u32_be_view(t, 41),
    lo2: typed_read_u32_be_view(t, 45),
    di: typed_read_u32_be_view(t, 49),
    dj: typed_read_u32_be_view(t, 53),
    scanning_mode: t[57].to_uint().reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_30(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate30, Bytes), Grib2SectionCodecError] {
  let base = match typed_decode_latlon_base(template_payload, "template 3.0") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok((base, template_payload.sub(start=58).to_bytes()))
}

///|
fn typed_decode_template_31(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      InvalidSectionLength(
        "template 3.1 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_latlon_base(template_payload, "template 3.1") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_32(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate32, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      InvalidSectionLength(
        "template 3.2 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_latlon_base(template_payload, "template 3.2") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 58,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 62,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_33(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate33, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 82 {
    return Err(
      InvalidSectionLength(
        "template 3.3 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_latlon_base(template_payload, "template 3.3") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 70,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 74,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 78),
      },
      template_payload.sub(start=82).to_bytes(),
    ),
  )
}

///|
fn typed_read_u32_list(
  payload : BytesView,
  start : Int,
  count : Int,
) -> Array[Int] {
  let values : Array[Int] = []
  for i in 0..<count {
    values.push(typed_read_u32_be_view(payload, start + i * 4))
  }
  values
}

///|
fn typed_decode_template_34(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate34, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 34 {
    return Err(
      InvalidSectionLength(
        "template 3.4 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let ni = typed_read_u32_be_view(template_payload, 16)
  let nj = typed_read_u32_be_view(template_payload, 20)
  if ni < 0 || nj < 0 {
    return Err(
      InvalidSectionLength(
        "template 3.4 negative list count: ni=" +
        ni.to_string() +
        ", nj=" +
        nj.to_string(),
      ),
    )
  }
  let list_bytes = (ni + nj) * 4
  let required = 34 + list_bytes
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 3.4 list payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let longitude_list = typed_read_u32_list(template_payload, 34, ni)
  let latitude_list = typed_read_u32_list(template_payload, 34 + ni * 4, nj)
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni,
        nj,
        basic_angle: typed_read_u32_be_view(template_payload, 24),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 28,
        ),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode: template_payload[33].to_uint().reinterpret_as_int(),
        longitude_list,
        latitude_list,
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_35(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate35, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      InvalidSectionLength(
        "template 3.5 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let ni = typed_read_u32_be_view(template_payload, 16)
  let nj = typed_read_u32_be_view(template_payload, 20)
  if ni < 0 || nj < 0 {
    return Err(
      InvalidSectionLength(
        "template 3.5 negative list count: ni=" +
        ni.to_string() +
        ", nj=" +
        nj.to_string(),
      ),
    )
  }
  let list_bytes = (ni + nj) * 4
  let required = 46 + list_bytes
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 3.5 list payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let longitude_list = typed_read_u32_list(template_payload, 46, ni)
  let latitude_list = typed_read_u32_list(template_payload, 46 + ni * 4, nj)
  Ok(
    (
      {
        base: {
          shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
          scale_factor_radius: template_payload[1]
          .to_uint()
          .reinterpret_as_int(),
          scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
          scale_factor_major_axis: template_payload[6]
          .to_uint()
          .reinterpret_as_int(),
          scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
          scale_factor_minor_axis: template_payload[11]
          .to_uint()
          .reinterpret_as_int(),
          scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
          ni,
          nj,
          basic_angle: typed_read_u32_be_view(template_payload, 24),
          subdivisions_of_basic_angle: typed_read_u32_be_view(
            template_payload, 28,
          ),
          resolution_and_component_flags: template_payload[32]
          .to_uint()
          .reinterpret_as_int(),
          scanning_mode: template_payload[33].to_uint().reinterpret_as_int(),
          longitude_list,
          latitude_list,
        },
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 34),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 38),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 42),
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_310(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate310, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      InvalidSectionLength(
        "template 3.10 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        la1: typed_read_u32_be_view(template_payload, 24),
        lo1: typed_read_u32_be_view(template_payload, 28),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        lad: typed_read_u32_be_view(template_payload, 33),
        la2: typed_read_u32_be_view(template_payload, 37),
        lo2: typed_read_u32_be_view(template_payload, 41),
        scanning_mode: template_payload[45].to_uint().reinterpret_as_int(),
        orientation_of_the_grid: typed_read_u32_be_view(template_payload, 46),
        di: typed_read_u32_be_view(template_payload, 50),
        dj: typed_read_u32_be_view(template_payload, 54),
      },
      template_payload.sub(start=58).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_312(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate312, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      InvalidSectionLength(
        "template 3.12 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        lar: typed_read_u32_be_view(template_payload, 24),
        lor: typed_read_u32_be_view(template_payload, 28),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        m: typed_read_u32_be_view(template_payload, 33),
        xr: typed_read_u32_be_view(template_payload, 37),
        yr: typed_read_u32_be_view(template_payload, 41),
        scanning_mode: template_payload[45].to_uint().reinterpret_as_int(),
        di: typed_read_u32_be_view(template_payload, 46),
        dj: typed_read_u32_be_view(template_payload, 50),
        x1: typed_read_u32_be_view(template_payload, 54),
        y1: typed_read_u32_be_view(template_payload, 58),
        x2: typed_read_u32_be_view(template_payload, 62),
        y2: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_313(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate313, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 74 {
    return Err(
      InvalidSectionLength(
        "template 3.13 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_310(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        nux: typed_read_u32_be_view(template_payload, 58),
        ncx: typed_read_u32_be_view(template_payload, 62),
        nuy: typed_read_u32_be_view(template_payload, 66),
        ncy: typed_read_u32_be_view(template_payload, 70),
      },
      template_payload.sub(start=74).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_320(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate320, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 51 {
    return Err(
      InvalidSectionLength(
        "template 3.20 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        la1: typed_read_u32_be_view(template_payload, 24),
        lo1: typed_read_u32_be_view(template_payload, 28),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        lad: typed_read_u32_be_view(template_payload, 33),
        lov: typed_read_u32_be_view(template_payload, 37),
        dx: typed_read_u32_be_view(template_payload, 41),
        dy: typed_read_u32_be_view(template_payload, 45),
        projection_center_flag: template_payload[49]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode: template_payload[50].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=51).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_323(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate323, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 67 {
    return Err(
      InvalidSectionLength(
        "template 3.23 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_320(template_payload.sub(end=51)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        nux: typed_read_u32_be_view(template_payload, 51),
        ncx: typed_read_u32_be_view(template_payload, 55),
        nuy: typed_read_u32_be_view(template_payload, 59),
        ncy: typed_read_u32_be_view(template_payload, 63),
      },
      template_payload.sub(start=67).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_330(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate330, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 67 {
    return Err(
      InvalidSectionLength(
        "template 3.30 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_320(template_payload.sub(end=51)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latin1: typed_read_u32_be_view(template_payload, 51),
        latin2: typed_read_u32_be_view(template_payload, 55),
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 59),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 63),
      },
      template_payload.sub(start=67).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_331(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate331, Bytes), Grib2SectionCodecError] {
  let (base, optional_points_raw) = match
    typed_decode_template_330(template_payload) {
    Ok((base, optional_points_raw)) => (base, optional_points_raw)
    Err(error) => return Err(error)
  }
  Ok(({ base, }, optional_points_raw))
}

///|
fn typed_decode_template_333(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate333, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 83 {
    return Err(
      InvalidSectionLength(
        "template 3.33 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_330(template_payload.sub(end=67)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        nux: typed_read_u32_be_view(template_payload, 67),
        ncx: typed_read_u32_be_view(template_payload, 71),
        nuy: typed_read_u32_be_view(template_payload, 75),
        ncy: typed_read_u32_be_view(template_payload, 79),
      },
      template_payload.sub(start=83).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_340(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate340, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      InvalidSectionLength(
        "template 3.40 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        basic_angle: typed_read_u32_be_view(template_payload, 24),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 28,
        ),
        la1: typed_read_u32_be_view(template_payload, 32),
        lo1: typed_read_u32_be_view(template_payload, 36),
        resolution_and_component_flags: template_payload[40]
        .to_uint()
        .reinterpret_as_int(),
        la2: typed_read_u32_be_view(template_payload, 41),
        lo2: typed_read_u32_be_view(template_payload, 45),
        di: typed_read_u32_be_view(template_payload, 49),
        n: typed_read_u32_be_view(template_payload, 53),
        scanning_mode: template_payload[57].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=58).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_341(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate341, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      InvalidSectionLength(
        "template 3.41 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_340(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_342(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate342, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      InvalidSectionLength(
        "template 3.42 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_340(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 58,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 62,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_343(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate343, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 82 {
    return Err(
      InvalidSectionLength(
        "template 3.43 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_340(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 70,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 74,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 78),
      },
      template_payload.sub(start=82).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_350(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate350, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      InvalidSectionLength(
        "template 3.50 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        j: typed_read_u32_be_view(template_payload, 0),
        k: typed_read_u32_be_view(template_payload, 4),
        m: typed_read_u32_be_view(template_payload, 8),
        representation_type: template_payload[12].to_uint().reinterpret_as_int(),
        representation_mode: template_payload[13].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=14).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_351(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate351, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      InvalidSectionLength(
        "template 3.51 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_350(template_payload.sub(end=14)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 14),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 18),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 22),
      },
      template_payload.sub(start=26).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_352(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate352, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      InvalidSectionLength(
        "template 3.52 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_350(template_payload.sub(end=14)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 14,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 18,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 22),
      },
      template_payload.sub(start=26).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_353(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate353, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 38 {
    return Err(
      InvalidSectionLength(
        "template 3.53 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_350(template_payload.sub(end=14)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 14),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 18),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 22),
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 26,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 30,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 34),
      },
      template_payload.sub(start=38).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_360(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate360, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 59 {
    return Err(
      InvalidSectionLength(
        "template 3.60 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        nc: typed_read_u32_be_view(template_payload, 24),
        xshift: typed_read_u32_be_view(template_payload, 28),
        yshift: typed_read_u32_be_view(template_payload, 32),
        face_number: template_payload[36].to_uint().reinterpret_as_int(),
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 37),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 41),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 45),
        stretching_factor: typed_read_u32_be_view(template_payload, 49),
        gnomonic_grid_spacing_parameter: typed_read_u32_be_view(
          template_payload, 53,
        ),
        resolution_and_component_flags: template_payload[57]
        .to_uint()
        .reinterpret_as_int(),
        scanning_and_staggering_flags: template_payload[58]
        .to_uint()
        .reinterpret_as_int(),
      },
      template_payload.sub(start=59).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_361(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate361, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 98 {
    return Err(
      InvalidSectionLength(
        "template 3.61 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        spectral_representation_type: template_payload[0]
        .to_uint()
        .reinterpret_as_int(),
        n: typed_read_u32_be_view(template_payload, 1),
        m: typed_read_u32_be_view(template_payload, 5),
        bi_fourier_truncation_type: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        lx: typed_read_u64_be_view(template_payload, 10),
        lux: typed_read_u64_be_view(template_payload, 18),
        lcx: typed_read_u64_be_view(template_payload, 26),
        ly: typed_read_u64_be_view(template_payload, 34),
        luy: typed_read_u64_be_view(template_payload, 42),
        lcy: typed_read_u64_be_view(template_payload, 50),
        shape_of_earth: template_payload[58].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[59].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 60),
        scale_factor_major_axis: template_payload[64]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 65),
        scale_factor_minor_axis: template_payload[69]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 70),
        la1: typed_read_u32_be_view(template_payload, 74),
        lo1: typed_read_u32_be_view(template_payload, 78),
        lad: typed_read_u32_be_view(template_payload, 82),
        la2: typed_read_u32_be_view(template_payload, 86),
        lo2: typed_read_u32_be_view(template_payload, 90),
        orientation_of_the_grid: typed_read_u32_be_view(template_payload, 94),
      },
      template_payload.sub(start=98).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_362(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate362, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 92 {
    return Err(
      InvalidSectionLength(
        "template 3.62 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        spectral_representation_type: template_payload[0]
        .to_uint()
        .reinterpret_as_int(),
        n: typed_read_u32_be_view(template_payload, 1),
        m: typed_read_u32_be_view(template_payload, 5),
        bi_fourier_truncation_type: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        lx: typed_read_u64_be_view(template_payload, 10),
        lux: typed_read_u64_be_view(template_payload, 18),
        lcx: typed_read_u64_be_view(template_payload, 26),
        ly: typed_read_u64_be_view(template_payload, 34),
        luy: typed_read_u64_be_view(template_payload, 42),
        lcy: typed_read_u64_be_view(template_payload, 50),
        shape_of_earth: template_payload[58].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[59].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 60),
        scale_factor_major_axis: template_payload[64]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 65),
        scale_factor_minor_axis: template_payload[69]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 70),
        la1: typed_read_u32_be_view(template_payload, 74),
        lo1: typed_read_u32_be_view(template_payload, 78),
        resolution_and_component_flags: template_payload[82]
        .to_uint()
        .reinterpret_as_int(),
        lad: typed_read_u32_be_view(template_payload, 83),
        lov: typed_read_u32_be_view(template_payload, 87),
        projection_center_flag: template_payload[91]
        .to_uint()
        .reinterpret_as_int(),
      },
      template_payload.sub(start=92).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_363(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate363, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 107 {
    return Err(
      InvalidSectionLength(
        "template 3.63 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        spectral_representation_type: template_payload[0]
        .to_uint()
        .reinterpret_as_int(),
        n: typed_read_u32_be_view(template_payload, 1),
        m: typed_read_u32_be_view(template_payload, 5),
        bi_fourier_truncation_type: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        lx: typed_read_u64_be_view(template_payload, 10),
        lux: typed_read_u64_be_view(template_payload, 18),
        lcx: typed_read_u64_be_view(template_payload, 26),
        ly: typed_read_u64_be_view(template_payload, 34),
        luy: typed_read_u64_be_view(template_payload, 42),
        lcy: typed_read_u64_be_view(template_payload, 50),
        shape_of_earth: template_payload[58].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[59].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 60),
        scale_factor_major_axis: template_payload[64]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 65),
        scale_factor_minor_axis: template_payload[69]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 70),
        la1: typed_read_u32_be_view(template_payload, 74),
        lo1: typed_read_u32_be_view(template_payload, 78),
        lad: typed_read_u32_be_view(template_payload, 82),
        lov: typed_read_u32_be_view(template_payload, 86),
        projection_center_flag: template_payload[90]
        .to_uint()
        .reinterpret_as_int(),
        latin1: typed_read_u32_be_view(template_payload, 91),
        latin2: typed_read_u32_be_view(template_payload, 95),
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 99),
        longitude_of_southern_pole: typed_read_u32_be_view(
          template_payload, 103,
        ),
      },
      template_payload.sub(start=107).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_390(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate390, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 66 {
    return Err(
      InvalidSectionLength(
        "template 3.90 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        latitude_of_sub_satellite_point: typed_read_u32_be_view(
          template_payload, 24,
        ),
        longitude_of_sub_satellite_point: typed_read_u32_be_view(
          template_payload, 28,
        ),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        dx: typed_read_u32_be_view(template_payload, 33),
        dy: typed_read_u32_be_view(template_payload, 37),
        xp: typed_read_u32_be_view(template_payload, 41),
        yp: typed_read_u32_be_view(template_payload, 45),
        scanning_mode: template_payload[49].to_uint().reinterpret_as_int(),
        orientation_of_the_grid: typed_read_u32_be_view(template_payload, 50),
        nr: typed_read_u32_be_view(template_payload, 54),
        xo: typed_read_u32_be_view(template_payload, 58),
        yo: typed_read_u32_be_view(template_payload, 62),
      },
      template_payload.sub(start=66).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3100(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3100, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 24 {
    return Err(
      InvalidSectionLength(
        "template 3.100 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        n2: template_payload[0].to_uint().reinterpret_as_int(),
        n3: template_payload[1].to_uint().reinterpret_as_int(),
        ni: typed_read_u16_be_view(template_payload, 2),
        nd: template_payload[4].to_uint().reinterpret_as_int(),
        latitude_of_the_pole_point: typed_read_u32_be_view(template_payload, 5),
        longitude_of_the_pole_point: typed_read_u32_be_view(template_payload, 9),
        longitude_of_the_centre_line_of_first_diamond: typed_read_u32_be_view(
          template_payload, 13,
        ),
        grid_point_position: template_payload[17].to_uint().reinterpret_as_int(),
        numbering_order_of_diamonds: template_payload[18]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode_for_one_diamond: template_payload[19]
        .to_uint()
        .reinterpret_as_int(),
        nt: typed_read_u32_be_view(template_payload, 20),
      },
      template_payload.sub(start=24).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3101(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3101, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 21 {
    return Err(
      InvalidSectionLength(
        "template 3.101 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        number_of_grid_used: typed_read_u24_be_view(template_payload, 1),
        number_of_grid_in_reference: template_payload[4]
        .to_uint()
        .reinterpret_as_int(),
        uuid_of_horizontal_grid: template_payload
        .sub(start=5, end=21)
        .to_bytes(),
      },
      template_payload.sub(start=21).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3110(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3110, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      InvalidSectionLength(
        "template 3.110 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        latitude_of_tangency_point: typed_read_u32_be_view(template_payload, 24),
        longitude_of_tangency_point: typed_read_u32_be_view(
          template_payload, 28,
        ),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        dx: typed_read_u32_be_view(template_payload, 33),
        dy: typed_read_u32_be_view(template_payload, 37),
        projection_center_flag: template_payload[41]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode: template_payload[42].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=43).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3120(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3120, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 25 {
    return Err(
      InvalidSectionLength(
        "template 3.120 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nr = typed_read_u32_be_view(template_payload, 4)
  let required = 25 + nr * 4
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 3.120 radial payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let radials : Array[Grib2AzimuthRangeRadial] = []
  for i in 0..<nr {
    let offset = 25 + i * 4
    radials.push({
      starting_azimuth: typed_read_u16_be_view(template_payload, offset),
      azimuthal_width: typed_read_u16_be_view(template_payload, offset + 2),
    })
  }
  Ok(
    (
      {
        nb: typed_read_u32_be_view(template_payload, 0),
        nr,
        la1: typed_read_u32_be_view(template_payload, 8),
        lo1: typed_read_u32_be_view(template_payload, 12),
        dx: typed_read_u32_be_view(template_payload, 16),
        dstart: typed_read_u32_be_view(template_payload, 20),
        scanning_mode: template_payload[24].to_uint().reinterpret_as_int(),
        radials,
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3140(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3140, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 50 {
    return Err(
      InvalidSectionLength(
        "template 3.140 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        la1: typed_read_u32_be_view(template_payload, 24),
        lo1: typed_read_u32_be_view(template_payload, 28),
        standard_parallel: typed_read_u32_be_view(template_payload, 32),
        central_longitude: typed_read_u32_be_view(template_payload, 36),
        resolution_and_component_flags: template_payload[40]
        .to_uint()
        .reinterpret_as_int(),
        dx: typed_read_u32_be_view(template_payload, 41),
        dy: typed_read_u32_be_view(template_payload, 45),
        scanning_mode: template_payload[49].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=50).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3150(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3150, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 28 {
    return Err(
      InvalidSectionLength(
        "template 3.150 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        resolution_and_component_flags: template_payload[16]
        .to_uint()
        .reinterpret_as_int(),
        nsides: typed_read_u32_be_view(template_payload, 17),
        lo: typed_read_u32_be_view(template_payload, 21),
        grid_point_position: template_payload[25].to_uint().reinterpret_as_int(),
        numbering_order: template_payload[26].to_uint().reinterpret_as_int(),
        scanning_mode: template_payload[27].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=28).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3204(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3204, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      InvalidSectionLength(
        "template 3.204 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        reserved_octets_39_54: template_payload.sub(start=24, end=40).to_bytes(),
        resolution_and_component_flags: template_payload[40]
        .to_uint()
        .reinterpret_as_int(),
        reserved_octets_56_71: template_payload.sub(start=41, end=57).to_bytes(),
        scanning_mode: template_payload[57].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=58).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_31000(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31000, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 52 {
    return Err(
      InvalidSectionLength(
        "template 3.1000 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nc = typed_read_u16_be_view(template_payload, 50)
  let required = 52 + nc * 4
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 3.1000 expected at least " +
        required.to_string() +
        " octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        number_of_horizontal_points: typed_read_u32_be_view(
          template_payload, 16,
        ),
        basic_angle: typed_read_u32_be_view(template_payload, 20),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 24,
        ),
        la1: typed_read_u32_be_view(template_payload, 28),
        lo1: typed_read_u32_be_view(template_payload, 32),
        scanning_mode: template_payload[36].to_uint().reinterpret_as_int(),
        la2: typed_read_u32_be_view(template_payload, 37),
        lo2: typed_read_u32_be_view(template_payload, 41),
        type_of_horizontal_line: template_payload[45]
        .to_uint()
        .reinterpret_as_int(),
        number_of_vertical_points: typed_read_u16_be_view(template_payload, 46),
        physical_meaning_of_vertical_coordinate: template_payload[48]
        .to_uint()
        .reinterpret_as_int(),
        vertical_dimension_coordinate_values_definition: template_payload[49]
        .to_uint()
        .reinterpret_as_int(),
        nc,
        vertical_coordinate_values_raw: template_payload
        .sub(start=52, end=required)
        .to_bytes(),
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_31100(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31100, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 68 {
    return Err(
      InvalidSectionLength(
        "template 3.1100 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        number_of_horizontal_points: typed_read_u32_be_view(
          template_payload, 16,
        ),
        basic_angle: typed_read_u32_be_view(template_payload, 20),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 24,
        ),
        la1: typed_read_u32_be_view(template_payload, 28),
        lo1: typed_read_u32_be_view(template_payload, 32),
        scanning_mode: template_payload[36].to_uint().reinterpret_as_int(),
        la2: typed_read_u32_be_view(template_payload, 37),
        lo2: typed_read_u32_be_view(template_payload, 41),
        type_of_horizontal_line: template_payload[45]
        .to_uint()
        .reinterpret_as_int(),
        nt: typed_read_u32_be_view(template_payload, 46),
        unit_of_offset_from_reference_time: template_payload[50]
        .to_uint()
        .reinterpret_as_int(),
        offset_from_reference_of_first_time: typed_read_u32_be_view(
          template_payload, 51,
        ),
        type_of_time_increment: template_payload[55]
        .to_uint()
        .reinterpret_as_int(),
        unit_of_time_increment: template_payload[56]
        .to_uint()
        .reinterpret_as_int(),
        time_increment: typed_read_u32_be_view(template_payload, 57),
        last_year: typed_read_u16_be_view(template_payload, 61),
        last_month: template_payload[63].to_uint().reinterpret_as_int(),
        last_day: template_payload[64].to_uint().reinterpret_as_int(),
        last_hour: template_payload[65].to_uint().reinterpret_as_int(),
        last_minute: template_payload[66].to_uint().reinterpret_as_int(),
        last_second: template_payload[67].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=68).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_31200(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31200, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 28 {
    return Err(
      InvalidSectionLength(
        "template 3.1200 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nc = typed_read_u16_be_view(template_payload, 26)
  let required = 28 + nc * 4
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 3.1200 expected at least " +
        required.to_string() +
        " octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        nt: typed_read_u32_be_view(template_payload, 0),
        unit_of_offset_from_reference_time: template_payload[4]
        .to_uint()
        .reinterpret_as_int(),
        offset_from_reference_of_first_time: typed_read_u32_be_view(
          template_payload, 5,
        ),
        type_of_time_increment: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        unit_of_time_increment: template_payload[10]
        .to_uint()
        .reinterpret_as_int(),
        time_increment: typed_read_u32_be_view(template_payload, 11),
        last_year: typed_read_u16_be_view(template_payload, 15),
        last_month: template_payload[17].to_uint().reinterpret_as_int(),
        last_day: template_payload[18].to_uint().reinterpret_as_int(),
        last_hour: template_payload[19].to_uint().reinterpret_as_int(),
        last_minute: template_payload[20].to_uint().reinterpret_as_int(),
        last_second: template_payload[21].to_uint().reinterpret_as_int(),
        number_of_vertical_points: typed_read_u16_be_view(template_payload, 22),
        physical_meaning_of_vertical_coordinate: template_payload[24]
        .to_uint()
        .reinterpret_as_int(),
        vertical_dimension_coordinate_values_definition: template_payload[25]
        .to_uint()
        .reinterpret_as_int(),
        nc,
        vertical_coordinate_values_raw: template_payload
        .sub(start=28, end=required)
        .to_bytes(),
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_332768(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate332768, Bytes), Grib2SectionCodecError] {
  match typed_decode_template_30(template_payload) {
    Ok((base, optional_points_raw)) => Ok(({ base, }, optional_points_raw))
    Err(error) => Err(error)
  }
}

///|
fn typed_decode_template_332769(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate332769, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 66 {
    return Err(
      InvalidSectionLength(
        "template 3.32769 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_latlon_base(template_payload, "template 3.32769") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_grid_point_ni_nj: typed_read_u32_be_view(
          template_payload, 58,
        ),
        longitude_of_grid_point_ni_nj: typed_read_u32_be_view(
          template_payload, 62,
        ),
      },
      template_payload.sub(start=66).to_bytes(),
    ),
  )
}

///|
fn typed_encode_template_30(template : Grib2GridTemplate30) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.dj)
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31(template : Grib2GridTemplate31) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_32(template : Grib2GridTemplate32) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_33(template : Grib2GridTemplate33) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_34(template : Grib2GridTemplate34) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  out.push(template.resolution_and_component_flags.to_byte())
  out.push(template.scanning_mode.to_byte())
  for value in template.longitude_list {
    typed_push_u32_be(out, value)
  }
  for value in template.latitude_list {
    typed_push_u32_be(out, value)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_35(template : Grib2GridTemplate35) -> Bytes {
  let base = template.base
  let out : Array[Byte] = []
  out.push(base.shape_of_earth.to_byte())
  out.push(base.scale_factor_radius.to_byte())
  typed_push_u32_be(out, base.scaled_value_radius)
  out.push(base.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, base.scaled_value_major_axis)
  out.push(base.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, base.scaled_value_minor_axis)
  typed_push_u32_be(out, base.ni)
  typed_push_u32_be(out, base.nj)
  typed_push_u32_be(out, base.basic_angle)
  typed_push_u32_be(out, base.subdivisions_of_basic_angle)
  out.push(base.resolution_and_component_flags.to_byte())
  out.push(base.scanning_mode.to_byte())
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  for value in base.longitude_list {
    typed_push_u32_be(out, value)
  }
  for value in base.latitude_list {
    typed_push_u32_be(out, value)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_310(template : Grib2GridTemplate310) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.orientation_of_the_grid)
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.dj)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_312(template : Grib2GridTemplate312) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.lar)
  typed_push_u32_be(out, template.lor)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.m)
  typed_push_u32_be(out, template.xr)
  typed_push_u32_be(out, template.yr)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.dj)
  typed_push_u32_be(out, template.x1)
  typed_push_u32_be(out, template.y1)
  typed_push_u32_be(out, template.x2)
  typed_push_u32_be(out, template.y2)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_313(template : Grib2GridTemplate313) -> Bytes {
  let out = typed_encode_template_310(template.base).to_array()
  typed_push_u32_be(out, template.nux)
  typed_push_u32_be(out, template.ncx)
  typed_push_u32_be(out, template.nuy)
  typed_push_u32_be(out, template.ncy)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_320(template : Grib2GridTemplate320) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.lov)
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  out.push(template.projection_center_flag.to_byte())
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_323(template : Grib2GridTemplate323) -> Bytes {
  let out = typed_encode_template_320(template.base).to_array()
  typed_push_u32_be(out, template.nux)
  typed_push_u32_be(out, template.ncx)
  typed_push_u32_be(out, template.nuy)
  typed_push_u32_be(out, template.ncy)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_330(template : Grib2GridTemplate330) -> Bytes {
  let out = typed_encode_template_320(template.base).to_array()
  typed_push_u32_be(out, template.latin1)
  typed_push_u32_be(out, template.latin2)
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_331(template : Grib2GridTemplate331) -> Bytes {
  typed_encode_template_330(template.base)
}

///|
fn typed_encode_template_333(template : Grib2GridTemplate333) -> Bytes {
  let out = typed_encode_template_330(template.base).to_array()
  typed_push_u32_be(out, template.nux)
  typed_push_u32_be(out, template.ncx)
  typed_push_u32_be(out, template.nuy)
  typed_push_u32_be(out, template.ncy)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_340(template : Grib2GridTemplate340) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.n)
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_341(template : Grib2GridTemplate341) -> Bytes {
  let out = typed_encode_template_340(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_342(template : Grib2GridTemplate342) -> Bytes {
  let out = typed_encode_template_340(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_343(template : Grib2GridTemplate343) -> Bytes {
  let out = typed_encode_template_340(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_350(template : Grib2GridTemplate350) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, template.j)
  typed_push_u32_be(out, template.k)
  typed_push_u32_be(out, template.m)
  out.push(template.representation_type.to_byte())
  out.push(template.representation_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_351(template : Grib2GridTemplate351) -> Bytes {
  let out = typed_encode_template_350(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_352(template : Grib2GridTemplate352) -> Bytes {
  let out = typed_encode_template_350(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_353(template : Grib2GridTemplate353) -> Bytes {
  let out = typed_encode_template_350(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_360(template : Grib2GridTemplate360) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.nc)
  typed_push_u32_be(out, template.xshift)
  typed_push_u32_be(out, template.yshift)
  out.push(template.face_number.to_byte())
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.stretching_factor)
  typed_push_u32_be(out, template.gnomonic_grid_spacing_parameter)
  out.push(template.resolution_and_component_flags.to_byte())
  out.push(template.scanning_and_staggering_flags.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_361(template : Grib2GridTemplate361) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.spectral_representation_type.to_byte())
  typed_push_u32_be(out, template.n)
  typed_push_u32_be(out, template.m)
  out.push(template.bi_fourier_truncation_type.to_byte())
  typed_push_u64_be(out, template.lx)
  typed_push_u64_be(out, template.lux)
  typed_push_u64_be(out, template.lcx)
  typed_push_u64_be(out, template.ly)
  typed_push_u64_be(out, template.luy)
  typed_push_u64_be(out, template.lcy)
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  typed_push_u32_be(out, template.orientation_of_the_grid)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_362(template : Grib2GridTemplate362) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.spectral_representation_type.to_byte())
  typed_push_u32_be(out, template.n)
  typed_push_u32_be(out, template.m)
  out.push(template.bi_fourier_truncation_type.to_byte())
  typed_push_u64_be(out, template.lx)
  typed_push_u64_be(out, template.lux)
  typed_push_u64_be(out, template.lcx)
  typed_push_u64_be(out, template.ly)
  typed_push_u64_be(out, template.luy)
  typed_push_u64_be(out, template.lcy)
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.lov)
  out.push(template.projection_center_flag.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_363(template : Grib2GridTemplate363) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.spectral_representation_type.to_byte())
  typed_push_u32_be(out, template.n)
  typed_push_u32_be(out, template.m)
  out.push(template.bi_fourier_truncation_type.to_byte())
  typed_push_u64_be(out, template.lx)
  typed_push_u64_be(out, template.lux)
  typed_push_u64_be(out, template.lcx)
  typed_push_u64_be(out, template.ly)
  typed_push_u64_be(out, template.luy)
  typed_push_u64_be(out, template.lcy)
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.lov)
  out.push(template.projection_center_flag.to_byte())
  typed_push_u32_be(out, template.latin1)
  typed_push_u32_be(out, template.latin2)
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_390(template : Grib2GridTemplate390) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.latitude_of_sub_satellite_point)
  typed_push_u32_be(out, template.longitude_of_sub_satellite_point)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  typed_push_u32_be(out, template.xp)
  typed_push_u32_be(out, template.yp)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.orientation_of_the_grid)
  typed_push_u32_be(out, template.nr)
  typed_push_u32_be(out, template.xo)
  typed_push_u32_be(out, template.yo)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3100(template : Grib2GridTemplate3100) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.n2.to_byte())
  out.push(template.n3.to_byte())
  typed_push_u16_be(out, template.ni)
  out.push(template.nd.to_byte())
  typed_push_u32_be(out, template.latitude_of_the_pole_point)
  typed_push_u32_be(out, template.longitude_of_the_pole_point)
  typed_push_u32_be(out, template.longitude_of_the_centre_line_of_first_diamond)
  out.push(template.grid_point_position.to_byte())
  out.push(template.numbering_order_of_diamonds.to_byte())
  out.push(template.scanning_mode_for_one_diamond.to_byte())
  typed_push_u32_be(out, template.nt)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3101(template : Grib2GridTemplate3101) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  typed_push_u24_be(out, template.number_of_grid_used)
  out.push(template.number_of_grid_in_reference.to_byte())
  for b in template.uuid_of_horizontal_grid {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3110(template : Grib2GridTemplate3110) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.latitude_of_tangency_point)
  typed_push_u32_be(out, template.longitude_of_tangency_point)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  out.push(template.projection_center_flag.to_byte())
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3120(template : Grib2GridTemplate3120) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, template.nb)
  typed_push_u32_be(out, template.nr)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dstart)
  out.push(template.scanning_mode.to_byte())
  for radial in template.radials {
    typed_push_u16_be(out, radial.starting_azimuth)
    typed_push_u16_be(out, radial.azimuthal_width)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3140(template : Grib2GridTemplate3140) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.standard_parallel)
  typed_push_u32_be(out, template.central_longitude)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3150(template : Grib2GridTemplate3150) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.nsides)
  typed_push_u32_be(out, template.lo)
  out.push(template.grid_point_position.to_byte())
  out.push(template.numbering_order.to_byte())
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3204(template : Grib2GridTemplate3204) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  for b in template.reserved_octets_39_54 {
    out.push(b)
  }
  out.push(template.resolution_and_component_flags.to_byte())
  for b in template.reserved_octets_56_71 {
    out.push(b)
  }
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31000(template : Grib2GridTemplate31000) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.number_of_horizontal_points)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  out.push(template.type_of_horizontal_line.to_byte())
  typed_push_u16_be(out, template.number_of_vertical_points)
  out.push(template.physical_meaning_of_vertical_coordinate.to_byte())
  out.push(template.vertical_dimension_coordinate_values_definition.to_byte())
  typed_push_u16_be(out, template.nc)
  for b in template.vertical_coordinate_values_raw {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31100(template : Grib2GridTemplate31100) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.number_of_horizontal_points)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  out.push(template.type_of_horizontal_line.to_byte())
  typed_push_u32_be(out, template.nt)
  out.push(template.unit_of_offset_from_reference_time.to_byte())
  typed_push_u32_be(out, template.offset_from_reference_of_first_time)
  out.push(template.type_of_time_increment.to_byte())
  out.push(template.unit_of_time_increment.to_byte())
  typed_push_u32_be(out, template.time_increment)
  typed_push_u16_be(out, template.last_year)
  out.push(template.last_month.to_byte())
  out.push(template.last_day.to_byte())
  out.push(template.last_hour.to_byte())
  out.push(template.last_minute.to_byte())
  out.push(template.last_second.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31200(template : Grib2GridTemplate31200) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, template.nt)
  out.push(template.unit_of_offset_from_reference_time.to_byte())
  typed_push_u32_be(out, template.offset_from_reference_of_first_time)
  out.push(template.type_of_time_increment.to_byte())
  out.push(template.unit_of_time_increment.to_byte())
  typed_push_u32_be(out, template.time_increment)
  typed_push_u16_be(out, template.last_year)
  out.push(template.last_month.to_byte())
  out.push(template.last_day.to_byte())
  out.push(template.last_hour.to_byte())
  out.push(template.last_minute.to_byte())
  out.push(template.last_second.to_byte())
  typed_push_u16_be(out, template.number_of_vertical_points)
  out.push(template.physical_meaning_of_vertical_coordinate.to_byte())
  out.push(template.vertical_dimension_coordinate_values_definition.to_byte())
  typed_push_u16_be(out, template.nc)
  for b in template.vertical_coordinate_values_raw {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_332768(template : Grib2GridTemplate332768) -> Bytes {
  typed_encode_template_30(template.base)
}

///|
fn typed_encode_template_332769(template : Grib2GridTemplate332769) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_grid_point_ni_nj)
  typed_push_u32_be(out, template.longitude_of_grid_point_ni_nj)
  Bytes::from_array(out)
}

///|
pub fn decode_section3_bytes(
  section : Bytes,
) -> Result[Grib2Section3Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 3) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 14 {
    return Err(
      InvalidSectionLength(
        "section3 too short: " + section.length().to_string(),
      ),
    )
  }
  let template_number = typed_read_u16_be(section, 12)
  let template_payload = section.sub(start=14)
  let (template, optional_points_raw) = if template_number == 0 {
    match typed_decode_template_30(template_payload) {
      Ok((template_30, optional_points_raw)) =>
        (GridTemplate30(template_30), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1 {
    match typed_decode_template_31(template_payload) {
      Ok((template_31, optional_points_raw)) =>
        (GridTemplate31(template_31), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 2 {
    match typed_decode_template_32(template_payload) {
      Ok((template_32, optional_points_raw)) =>
        (GridTemplate32(template_32), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 3 {
    match typed_decode_template_33(template_payload) {
      Ok((template_33, optional_points_raw)) =>
        (GridTemplate33(template_33), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 4 {
    match typed_decode_template_34(template_payload) {
      Ok((template_34, optional_points_raw)) =>
        (GridTemplate34(template_34), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 5 {
    match typed_decode_template_35(template_payload) {
      Ok((template_35, optional_points_raw)) =>
        (GridTemplate35(template_35), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 10 {
    match typed_decode_template_310(template_payload) {
      Ok((template_310, optional_points_raw)) =>
        (GridTemplate310(template_310), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 12 {
    match typed_decode_template_312(template_payload) {
      Ok((template_312, optional_points_raw)) =>
        (GridTemplate312(template_312), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 13 {
    match typed_decode_template_313(template_payload) {
      Ok((template_313, optional_points_raw)) =>
        (GridTemplate313(template_313), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 20 {
    match typed_decode_template_320(template_payload) {
      Ok((template_320, optional_points_raw)) =>
        (GridTemplate320(template_320), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 23 {
    match typed_decode_template_323(template_payload) {
      Ok((template_323, optional_points_raw)) =>
        (GridTemplate323(template_323), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 30 {
    match typed_decode_template_330(template_payload) {
      Ok((template_330, optional_points_raw)) =>
        (GridTemplate330(template_330), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 31 {
    match typed_decode_template_331(template_payload) {
      Ok((template_331, optional_points_raw)) =>
        (GridTemplate331(template_331), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 33 {
    match typed_decode_template_333(template_payload) {
      Ok((template_333, optional_points_raw)) =>
        (GridTemplate333(template_333), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 40 {
    match typed_decode_template_340(template_payload) {
      Ok((template_340, optional_points_raw)) =>
        (GridTemplate340(template_340), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 41 {
    match typed_decode_template_341(template_payload) {
      Ok((template_341, optional_points_raw)) =>
        (GridTemplate341(template_341), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 42 {
    match typed_decode_template_342(template_payload) {
      Ok((template_342, optional_points_raw)) =>
        (GridTemplate342(template_342), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 43 {
    match typed_decode_template_343(template_payload) {
      Ok((template_343, optional_points_raw)) =>
        (GridTemplate343(template_343), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 50 {
    match typed_decode_template_350(template_payload) {
      Ok((template_350, optional_points_raw)) =>
        (GridTemplate350(template_350), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 51 {
    match typed_decode_template_351(template_payload) {
      Ok((template_351, optional_points_raw)) =>
        (GridTemplate351(template_351), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 52 {
    match typed_decode_template_352(template_payload) {
      Ok((template_352, optional_points_raw)) =>
        (GridTemplate352(template_352), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 53 {
    match typed_decode_template_353(template_payload) {
      Ok((template_353, optional_points_raw)) =>
        (GridTemplate353(template_353), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 60 {
    match typed_decode_template_360(template_payload) {
      Ok((template_360, optional_points_raw)) =>
        (GridTemplate360(template_360), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 61 {
    match typed_decode_template_361(template_payload) {
      Ok((template_361, optional_points_raw)) =>
        (GridTemplate361(template_361), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 62 {
    match typed_decode_template_362(template_payload) {
      Ok((template_362, optional_points_raw)) =>
        (GridTemplate362(template_362), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 63 {
    match typed_decode_template_363(template_payload) {
      Ok((template_363, optional_points_raw)) =>
        (GridTemplate363(template_363), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 90 {
    match typed_decode_template_390(template_payload) {
      Ok((template_390, optional_points_raw)) =>
        (GridTemplate390(template_390), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 100 {
    match typed_decode_template_3100(template_payload) {
      Ok((template_3100, optional_points_raw)) =>
        (GridTemplate3100(template_3100), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 101 {
    match typed_decode_template_3101(template_payload) {
      Ok((template_3101, optional_points_raw)) =>
        (GridTemplate3101(template_3101), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 110 {
    match typed_decode_template_3110(template_payload) {
      Ok((template_3110, optional_points_raw)) =>
        (GridTemplate3110(template_3110), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 120 {
    match typed_decode_template_3120(template_payload) {
      Ok((template_3120, optional_points_raw)) =>
        (GridTemplate3120(template_3120), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 140 {
    match typed_decode_template_3140(template_payload) {
      Ok((template_3140, optional_points_raw)) =>
        (GridTemplate3140(template_3140), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 150 {
    match typed_decode_template_3150(template_payload) {
      Ok((template_3150, optional_points_raw)) =>
        (GridTemplate3150(template_3150), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 204 {
    match typed_decode_template_3204(template_payload) {
      Ok((template_3204, optional_points_raw)) =>
        (GridTemplate3204(template_3204), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1000 {
    match typed_decode_template_31000(template_payload) {
      Ok((template_31000, optional_points_raw)) =>
        (GridTemplate31000(template_31000), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1100 {
    match typed_decode_template_31100(template_payload) {
      Ok((template_31100, optional_points_raw)) =>
        (GridTemplate31100(template_31100), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1200 {
    match typed_decode_template_31200(template_payload) {
      Ok((template_31200, optional_points_raw)) =>
        (GridTemplate31200(template_31200), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 32768 {
    match typed_decode_template_332768(template_payload) {
      Ok((template_332768, optional_points_raw)) =>
        (GridTemplate332768(template_332768), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 32769 {
    match typed_decode_template_332769(template_payload) {
      Ok((template_332769, optional_points_raw)) =>
        (GridTemplate332769(template_332769), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else {
    (GridTemplateUnknown(template_number, template_payload.to_bytes()), b"")
  }
  Ok({
    source_of_grid_definition: section[5].to_uint().reinterpret_as_int(),
    number_of_data_points: typed_read_u32_be(section, 6),
    optional_points_octet_count: section[10].to_uint().reinterpret_as_int(),
    optional_points_interpretation: section[11].to_uint().reinterpret_as_int(),
    template,
    optional_points_raw,
  })
}

///|
pub fn encode_section3_bytes(section : Grib2Section3Decoded) -> Bytes {
  let payload : Array[Byte] = []
  payload.push(section.source_of_grid_definition.to_byte())
  typed_push_u32_be(payload, section.number_of_data_points)
  payload.push(section.optional_points_octet_count.to_byte())
  payload.push(section.optional_points_interpretation.to_byte())
  let (template_number, template_raw) = match section.template {
    GridTemplate30(template_30) => (0, typed_encode_template_30(template_30))
    GridTemplate31(template_31) => (1, typed_encode_template_31(template_31))
    GridTemplate32(template_32) => (2, typed_encode_template_32(template_32))
    GridTemplate33(template_33) => (3, typed_encode_template_33(template_33))
    GridTemplate34(template_34) => (4, typed_encode_template_34(template_34))
    GridTemplate35(template_35) => (5, typed_encode_template_35(template_35))
    GridTemplate310(template_310) =>
      (10, typed_encode_template_310(template_310))
    GridTemplate312(template_312) =>
      (12, typed_encode_template_312(template_312))
    GridTemplate313(template_313) =>
      (13, typed_encode_template_313(template_313))
    GridTemplate320(template_320) =>
      (20, typed_encode_template_320(template_320))
    GridTemplate323(template_323) =>
      (23, typed_encode_template_323(template_323))
    GridTemplate330(template_330) =>
      (30, typed_encode_template_330(template_330))
    GridTemplate331(template_331) =>
      (31, typed_encode_template_331(template_331))
    GridTemplate333(template_333) =>
      (33, typed_encode_template_333(template_333))
    GridTemplate340(template_340) =>
      (40, typed_encode_template_340(template_340))
    GridTemplate341(template_341) =>
      (41, typed_encode_template_341(template_341))
    GridTemplate342(template_342) =>
      (42, typed_encode_template_342(template_342))
    GridTemplate343(template_343) =>
      (43, typed_encode_template_343(template_343))
    GridTemplate350(template_350) =>
      (50, typed_encode_template_350(template_350))
    GridTemplate351(template_351) =>
      (51, typed_encode_template_351(template_351))
    GridTemplate352(template_352) =>
      (52, typed_encode_template_352(template_352))
    GridTemplate353(template_353) =>
      (53, typed_encode_template_353(template_353))
    GridTemplate360(template_360) =>
      (60, typed_encode_template_360(template_360))
    GridTemplate361(template_361) =>
      (61, typed_encode_template_361(template_361))
    GridTemplate362(template_362) =>
      (62, typed_encode_template_362(template_362))
    GridTemplate363(template_363) =>
      (63, typed_encode_template_363(template_363))
    GridTemplate390(template_390) =>
      (90, typed_encode_template_390(template_390))
    GridTemplate3100(template_3100) =>
      (100, typed_encode_template_3100(template_3100))
    GridTemplate3101(template_3101) =>
      (101, typed_encode_template_3101(template_3101))
    GridTemplate3110(template_3110) =>
      (110, typed_encode_template_3110(template_3110))
    GridTemplate3120(template_3120) =>
      (120, typed_encode_template_3120(template_3120))
    GridTemplate3140(template_3140) =>
      (140, typed_encode_template_3140(template_3140))
    GridTemplate3150(template_3150) =>
      (150, typed_encode_template_3150(template_3150))
    GridTemplate3204(template_3204) =>
      (204, typed_encode_template_3204(template_3204))
    GridTemplate31000(template_31000) =>
      (1000, typed_encode_template_31000(template_31000))
    GridTemplate31100(template_31100) =>
      (1100, typed_encode_template_31100(template_31100))
    GridTemplate31200(template_31200) =>
      (1200, typed_encode_template_31200(template_31200))
    GridTemplate332768(template_332768) =>
      (32768, typed_encode_template_332768(template_332768))
    GridTemplate332769(template_332769) =>
      (32769, typed_encode_template_332769(template_332769))
    GridTemplateUnknown(template_number, raw) => (template_number, raw)
  }
  typed_push_u16_be(payload, template_number)
  for b in template_raw {
    payload.push(b)
  }
  for b in section.optional_points_raw {
    payload.push(b)
  }
  typed_build_section(3, Bytes::from_array(payload))
}

///|
fn typed_decode_template_40(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate40, Grib2SectionCodecError] {
  if template_payload.length() != 25 {
    return Err(
      InvalidSectionLength(
        "template 4.0 expected 25 octets, got " +
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
  })
}

///|
fn typed_decode_template_41(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41, Grib2SectionCodecError] {
  if template_payload.length() != 28 {
    return Err(
      InvalidSectionLength(
        "template 4.1 expected 28 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[26].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_42(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate42, Grib2SectionCodecError] {
  if template_payload.length() != 27 {
    return Err(
      InvalidSectionLength(
        "template 4.2 expected 27 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_43(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate43, Grib2SectionCodecError] {
  if template_payload.length() < 59 {
    return Err(
      InvalidSectionLength(
        "template 4.3 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = template_payload[48].to_uint().reinterpret_as_int()
  let required = 59 + nc
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.3 cluster list too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      template_payload[59 + i].to_uint().reinterpret_as_int(),
    )
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    cluster_identifier: template_payload[27].to_uint().reinterpret_as_int(),
    cluster_for_high_resolution_control: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    cluster_for_low_resolution_control: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    total_number_of_clusters: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    clustering_method: template_payload[31].to_uint().reinterpret_as_int(),
    northern_latitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 32,
    ),
    southern_latitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 36,
    ),
    eastern_longitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 40,
    ),
    western_longitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 44,
    ),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: template_payload[49]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_standard_deviation: typed_read_u32_be_view(
      template_payload, 50,
    ),
    scale_factor_of_distance_from_ensemble_mean: template_payload[54]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_distance_from_ensemble_mean: typed_read_u32_be_view(
      template_payload, 55,
    ),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_44(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate44, Grib2SectionCodecError] {
  if template_payload.length() < 55 {
    return Err(
      InvalidSectionLength(
        "template 4.4 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = template_payload[44].to_uint().reinterpret_as_int()
  let required = 55 + nc
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.4 cluster list too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      template_payload[55 + i].to_uint().reinterpret_as_int(),
    )
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    cluster_identifier: template_payload[27].to_uint().reinterpret_as_int(),
    cluster_for_high_resolution_control: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    cluster_for_low_resolution_control: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    total_number_of_clusters: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    clustering_method: template_payload[31].to_uint().reinterpret_as_int(),
    latitude_of_central_point: typed_read_u32_be_view(template_payload, 32),
    longitude_of_central_point: typed_read_u32_be_view(template_payload, 36),
    radius_of_cluster_domain: typed_read_u32_be_view(template_payload, 40),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: template_payload[45]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_standard_deviation: typed_read_u32_be_view(
      template_payload, 46,
    ),
    scale_factor_of_distance_from_ensemble_mean: template_payload[50]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_distance_from_ensemble_mean: typed_read_u32_be_view(
      template_payload, 51,
    ),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_45(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate45, Grib2SectionCodecError] {
  if template_payload.length() < 38 {
    return Err(
      InvalidSectionLength(
        "template 4.5 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    forecast_probability_number: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    total_number_of_forecast_probabilities: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    probability_type: template_payload[27].to_uint().reinterpret_as_int(),
    scale_factor_of_lower_limit: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_lower_limit: typed_read_u32_be_view(template_payload, 29),
    scale_factor_of_upper_limit: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_upper_limit: typed_read_u32_be_view(template_payload, 34),
    reserved_tail: template_payload.sub(start=38).to_bytes(),
  })
}

///|
fn typed_decode_template_46(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate46, Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      InvalidSectionLength(
        "template 4.6 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    percentile_value: template_payload[25].to_uint().reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=26).to_bytes(),
  })
}

///|
fn typed_decode_template_47(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate47, Grib2SectionCodecError] {
  if template_payload.length() < 25 {
    return Err(
      InvalidSectionLength(
        "template 4.7 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({ base, reserved_tail: template_payload.sub(start=25).to_bytes() })
}

///|
fn typed_decode_time_range_specs(
  payload : BytesView,
  start : Int,
  count : Int,
) -> Array[Grib2TimeRangeSpec] {
  let specs : Array[Grib2TimeRangeSpec] = []
  for i in 0..<count {
    let offset = start + i * 12
    specs.push({
      statistical_process: payload[offset].to_uint().reinterpret_as_int(),
      type_of_time_increment: payload[offset + 1].to_uint().reinterpret_as_int(),
      time_range_unit: payload[offset + 2].to_uint().reinterpret_as_int(),
      time_range_length: typed_read_u32_be_view(payload, offset + 3),
      time_increment_unit: payload[offset + 7].to_uint().reinterpret_as_int(),
      time_increment_length: typed_read_u32_be_view(payload, offset + 8),
    })
  }
  specs
}

///|
fn typed_encode_time_range_specs(
  specs : Array[Grib2TimeRangeSpec],
) -> Array[Byte] {
  let out : Array[Byte] = []
  for spec in specs {
    out.push(spec.statistical_process.to_byte())
    out.push(spec.type_of_time_increment.to_byte())
    out.push(spec.time_range_unit.to_byte())
    typed_push_u32_be(out, spec.time_range_length)
    out.push(spec.time_increment_unit.to_byte())
    typed_push_u32_be(out, spec.time_increment_length)
  }
  out
}

///|
fn typed_decode_template_48(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate48, Grib2SectionCodecError] {
  if template_payload.length() < 37 {
    return Err(
      InvalidSectionLength(
        "template 4.8 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[32].to_uint().reinterpret_as_int()
  let required = 37 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.8 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 25),
    end_month: template_payload[27].to_uint().reinterpret_as_int(),
    end_day: template_payload[28].to_uint().reinterpret_as_int(),
    end_hour: template_payload[29].to_uint().reinterpret_as_int(),
    end_minute: template_payload[30].to_uint().reinterpret_as_int(),
    end_second: template_payload[31].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 33),
    time_range_specs: typed_decode_time_range_specs(template_payload, 37, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_49(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate49, Grib2SectionCodecError] {
  if template_payload.length() < 50 {
    return Err(
      InvalidSectionLength(
        "template 4.9 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_45(template_payload.sub(end=38)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[45].to_uint().reinterpret_as_int()
  let required = 50 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.9 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 38),
    end_month: template_payload[40].to_uint().reinterpret_as_int(),
    end_day: template_payload[41].to_uint().reinterpret_as_int(),
    end_hour: template_payload[42].to_uint().reinterpret_as_int(),
    end_minute: template_payload[43].to_uint().reinterpret_as_int(),
    end_second: template_payload[44].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 46),
    time_range_specs: typed_decode_time_range_specs(template_payload, 50, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_410(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate410, Grib2SectionCodecError] {
  if template_payload.length() < 38 {
    return Err(
      InvalidSectionLength(
        "template 4.10 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_46(template_payload.sub(end=26)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[33].to_uint().reinterpret_as_int()
  let required = 38 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.10 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 26),
    end_month: template_payload[28].to_uint().reinterpret_as_int(),
    end_day: template_payload[29].to_uint().reinterpret_as_int(),
    end_hour: template_payload[30].to_uint().reinterpret_as_int(),
    end_minute: template_payload[31].to_uint().reinterpret_as_int(),
    end_second: template_payload[32].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 34),
    time_range_specs: typed_decode_time_range_specs(template_payload, 38, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_411(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate411, Grib2SectionCodecError] {
  if template_payload.length() < 40 {
    return Err(
      InvalidSectionLength(
        "template 4.11 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_41(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[35].to_uint().reinterpret_as_int()
  let required = 40 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.11 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 28),
    end_month: template_payload[30].to_uint().reinterpret_as_int(),
    end_day: template_payload[31].to_uint().reinterpret_as_int(),
    end_hour: template_payload[32].to_uint().reinterpret_as_int(),
    end_minute: template_payload[33].to_uint().reinterpret_as_int(),
    end_second: template_payload[34].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 36),
    time_range_specs: typed_decode_time_range_specs(template_payload, 40, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_412(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate412, Grib2SectionCodecError] {
  if template_payload.length() < 39 {
    return Err(
      InvalidSectionLength(
        "template 4.12 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_42(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[34].to_uint().reinterpret_as_int()
  let required = 39 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.12 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 27),
    end_month: template_payload[29].to_uint().reinterpret_as_int(),
    end_day: template_payload[30].to_uint().reinterpret_as_int(),
    end_hour: template_payload[31].to_uint().reinterpret_as_int(),
    end_minute: template_payload[32].to_uint().reinterpret_as_int(),
    end_second: template_payload[33].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 35),
    time_range_specs: typed_decode_time_range_specs(template_payload, 39, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_413(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate413, Grib2SectionCodecError] {
  if template_payload.length() < 71 {
    return Err(
      InvalidSectionLength(
        "template 4.13 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = template_payload[48].to_uint().reinterpret_as_int()
  let n = template_payload[66].to_uint().reinterpret_as_int()
  let required = 71 + n * 12 + nc
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.13 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let list_offset = 71 + n * 12
  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      template_payload[list_offset + i].to_uint().reinterpret_as_int(),
    )
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    cluster_identifier: template_payload[27].to_uint().reinterpret_as_int(),
    cluster_for_high_resolution_control: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    cluster_for_low_resolution_control: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    total_number_of_clusters: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    clustering_method: template_payload[31].to_uint().reinterpret_as_int(),
    northern_latitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 32,
    ),
    southern_latitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 36,
    ),
    eastern_longitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 40,
    ),
    western_longitude_of_cluster_domain: typed_read_u32_be_view(
      template_payload, 44,
    ),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: template_payload[49]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_standard_deviation: typed_read_u32_be_view(
      template_payload, 50,
    ),
    scale_factor_of_distance_from_ensemble_mean: template_payload[54]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_distance_from_ensemble_mean: typed_read_u32_be_view(
      template_payload, 55,
    ),
    end_year: typed_read_u16_be_view(template_payload, 59),
    end_month: template_payload[61].to_uint().reinterpret_as_int(),
    end_day: template_payload[62].to_uint().reinterpret_as_int(),
    end_hour: template_payload[63].to_uint().reinterpret_as_int(),
    end_minute: template_payload[64].to_uint().reinterpret_as_int(),
    end_second: template_payload[65].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 67),
    time_range_specs: typed_decode_time_range_specs(template_payload, 71, n),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_414(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate414, Grib2SectionCodecError] {
  if template_payload.length() < 67 {
    return Err(
      InvalidSectionLength(
        "template 4.14 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = template_payload[44].to_uint().reinterpret_as_int()
  let n = template_payload[62].to_uint().reinterpret_as_int()
  let required = 67 + n * 12 + nc
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.14 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let list_offset = 67 + n * 12
  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      template_payload[list_offset + i].to_uint().reinterpret_as_int(),
    )
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    cluster_identifier: template_payload[27].to_uint().reinterpret_as_int(),
    cluster_for_high_resolution_control: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    cluster_for_low_resolution_control: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    total_number_of_clusters: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    clustering_method: template_payload[31].to_uint().reinterpret_as_int(),
    latitude_of_central_point: typed_read_u32_be_view(template_payload, 32),
    longitude_of_central_point: typed_read_u32_be_view(template_payload, 36),
    radius_of_cluster_domain: typed_read_u32_be_view(template_payload, 40),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: template_payload[45]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_standard_deviation: typed_read_u32_be_view(
      template_payload, 46,
    ),
    scale_factor_of_distance_from_ensemble_mean: template_payload[50]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_distance_from_ensemble_mean: typed_read_u32_be_view(
      template_payload, 51,
    ),
    end_year: typed_read_u16_be_view(template_payload, 55),
    end_month: template_payload[57].to_uint().reinterpret_as_int(),
    end_day: template_payload[58].to_uint().reinterpret_as_int(),
    end_hour: template_payload[59].to_uint().reinterpret_as_int(),
    end_minute: template_payload[60].to_uint().reinterpret_as_int(),
    end_second: template_payload[61].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 63),
    time_range_specs: typed_decode_time_range_specs(template_payload, 67, n),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_415(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate415, Grib2SectionCodecError] {
  if template_payload.length() != 28 {
    return Err(
      InvalidSectionLength(
        "template 4.15 expected 28 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    statistical_process_within_spatial_area: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    type_of_spatial_processing: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    number_of_data_points_used: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_430(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate430, Grib2SectionCodecError] {
  if template_payload.length() < 5 {
    return Err(
      InvalidSectionLength(
        "template 4.30 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[4].to_uint().reinterpret_as_int()
  let required = 5 + nb * 10
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.30 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 5 + i * 10
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: template_payload[offset + 4]
      .to_uint()
      .reinterpret_as_int(),
      scale_factor_of_central_wave_number: template_payload[offset + 5]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 6,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    observation_generating_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_431(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate431, Grib2SectionCodecError] {
  if template_payload.length() < 5 {
    return Err(
      InvalidSectionLength(
        "template 4.31 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[4].to_uint().reinterpret_as_int()
  let required = 5 + nb * 11
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.31 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 5 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    observation_generating_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_432(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate432, Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      InvalidSectionLength(
        "template 4.32 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let required = 14 + nb * 11
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.32 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
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
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[8].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 9),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_433(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate433, Grib2SectionCodecError] {
  if template_payload.length() < 17 {
    return Err(
      InvalidSectionLength(
        "template 4.33 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let required = 17 + nb * 11
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.33 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  let ensemble_offset = 14 + nb * 11
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
    number_of_contributing_spectral_bands: nb,
    bands,
    type_of_ensemble_forecast: template_payload[ensemble_offset]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[ensemble_offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[ensemble_offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_434(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate434, Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      InvalidSectionLength(
        "template 4.34 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let ensemble_offset = 14 + nb * 11
  let required_min = 29 + nb * 11
  if template_payload.length() < required_min {
    return Err(
      InvalidSectionLength(
        "template 4.34 payload too short: expected at least " +
        required_min.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 14 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  let n = template_payload[ensemble_offset + 10].to_uint().reinterpret_as_int()
  let required = required_min + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.34 time-range payload too short: expected at least " +
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
    number_of_contributing_spectral_bands: nb,
    bands,
    type_of_ensemble_forecast: template_payload[ensemble_offset]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[ensemble_offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[ensemble_offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, ensemble_offset + 3),
    end_month: template_payload[ensemble_offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    end_day: template_payload[ensemble_offset + 6]
    .to_uint()
    .reinterpret_as_int(),
    end_hour: template_payload[ensemble_offset + 7]
    .to_uint()
    .reinterpret_as_int(),
    end_minute: template_payload[ensemble_offset + 8]
    .to_uint()
    .reinterpret_as_int(),
    end_second: template_payload[ensemble_offset + 9]
    .to_uint()
    .reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      ensemble_offset + 11,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      ensemble_offset + 15,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_435(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate435, Grib2SectionCodecError] {
  if template_payload.length() < 6 {
    return Err(
      InvalidSectionLength(
        "template 4.35 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[5].to_uint().reinterpret_as_int()
  let required = 6 + nb * 11
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.35 band payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let bands : Array[Grib2SatelliteBandSpec] = []
  for i in 0..<nb {
    let offset = 6 + i * 11
    bands.push({
      satellite_series: typed_read_u16_be_view(template_payload, offset),
      satellite_number: typed_read_u16_be_view(template_payload, offset + 2),
      instrument_type: typed_read_u16_be_view(template_payload, offset + 4),
      scale_factor_of_central_wave_number: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_central_wave_number: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[2]
    .to_uint()
    .reinterpret_as_int(),
    observation_generating_process_identifier: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    quality_value_associated_with_parameter: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    number_of_contributing_spectral_bands: nb,
    bands,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_440(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate440, Grib2SectionCodecError] {
  if template_payload.length() != 27 {
    return Err(
      InvalidSectionLength(
        "template 4.40 expected 27 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    type_of_generating_process: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 7,
    ),
    minutes_of_observational_data_cutoff: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[10].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 11),
    type_of_first_fixed_surface: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 17,
    ),
    type_of_second_fixed_surface: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 23,
    ),
  })
}

///|
fn typed_decode_template_441(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate441, Grib2SectionCodecError] {
  if template_payload.length() != 30 {
    return Err(
      InvalidSectionLength(
        "template 4.41 expected 30 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_440(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[28].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_442(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate442, Grib2SectionCodecError] {
  if template_payload.length() < 39 {
    return Err(
      InvalidSectionLength(
        "template 4.42 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_440(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[34].to_uint().reinterpret_as_int()
  let required = 39 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.42 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 27),
    end_month: template_payload[29].to_uint().reinterpret_as_int(),
    end_day: template_payload[30].to_uint().reinterpret_as_int(),
    end_hour: template_payload[31].to_uint().reinterpret_as_int(),
    end_minute: template_payload[32].to_uint().reinterpret_as_int(),
    end_second: template_payload[33].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 35),
    time_range_specs: typed_decode_time_range_specs(template_payload, 39, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_443(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate443, Grib2SectionCodecError] {
  if template_payload.length() < 42 {
    return Err(
      InvalidSectionLength(
        "template 4.43 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_441(template_payload.sub(end=30)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[37].to_uint().reinterpret_as_int()
  let required = 42 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.43 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 30),
    end_month: template_payload[32].to_uint().reinterpret_as_int(),
    end_day: template_payload[33].to_uint().reinterpret_as_int(),
    end_hour: template_payload[34].to_uint().reinterpret_as_int(),
    end_minute: template_payload[35].to_uint().reinterpret_as_int(),
    end_second: template_payload[36].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 38),
    time_range_specs: typed_decode_time_range_specs(template_payload, 42, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_444(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate444, Grib2SectionCodecError] {
  if template_payload.length() != 36 {
    return Err(
      InvalidSectionLength(
        "template 4.44 expected 36 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u16_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 26,
    ),
    type_of_second_fixed_surface: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 32,
    ),
  })
}

///|
fn typed_decode_template_445(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate445, Grib2SectionCodecError] {
  if template_payload.length() != 41 {
    return Err(
      InvalidSectionLength(
        "template 4.45 expected 41 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_446(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate446, Grib2SectionCodecError] {
  if template_payload.length() < 50 {
    return Err(
      InvalidSectionLength(
        "template 4.46 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[45].to_uint().reinterpret_as_int()
  let required = 50 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.46 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    end_year: typed_read_u16_be_view(template_payload, 38),
    end_month: template_payload[40].to_uint().reinterpret_as_int(),
    end_day: template_payload[41].to_uint().reinterpret_as_int(),
    end_hour: template_payload[42].to_uint().reinterpret_as_int(),
    end_minute: template_payload[43].to_uint().reinterpret_as_int(),
    end_second: template_payload[44].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 46),
    time_range_specs: typed_decode_time_range_specs(template_payload, 50, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_447(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate447, Grib2SectionCodecError] {
  if template_payload.length() < 53 {
    return Err(
      InvalidSectionLength(
        "template 4.47 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[48].to_uint().reinterpret_as_int()
  let required = 53 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.47 time-range payload too short: expected at least " +
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
    aerosol_type: typed_read_u16_be_view(template_payload, 3),
    type_of_interval_for_first_and_second_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 41),
    end_month: template_payload[43].to_uint().reinterpret_as_int(),
    end_day: template_payload[44].to_uint().reinterpret_as_int(),
    end_hour: template_payload[45].to_uint().reinterpret_as_int(),
    end_minute: template_payload[46].to_uint().reinterpret_as_int(),
    end_second: template_payload[47].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 49),
    time_range_specs: typed_decode_time_range_specs(template_payload, 53, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_448(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate448, Grib2SectionCodecError] {
  if template_payload.length() != 49 {
    return Err(
      InvalidSectionLength(
        "template 4.48 expected 49 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_interval_for_first_and_second_wavelength: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_wavelength: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 17,
    ),
    scale_factor_of_second_wavelength: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 22,
    ),
    type_of_generating_process: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 29,
    ),
    minutes_of_observational_data_cutoff: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[32].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 33),
    type_of_first_fixed_surface: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_second_fixed_surface: template_payload[43]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[44]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 45,
    ),
  })
}

///|
fn typed_decode_template_449(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate449, Grib2SectionCodecError] {
  if template_payload.length() != 52 {
    return Err(
      InvalidSectionLength(
        "template 4.49 expected 52 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_interval_for_first_and_second_wavelength: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_wavelength: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 17,
    ),
    scale_factor_of_second_wavelength: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 22,
    ),
    type_of_generating_process: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 29,
    ),
    minutes_of_observational_data_cutoff: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[32].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 33),
    type_of_first_fixed_surface: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_second_fixed_surface: template_payload[43]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[44]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 45,
    ),
    type_of_ensemble_forecast: template_payload[49]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[50].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[51]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_450(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate450, Grib2SectionCodecError] {
  if template_payload.length() != 38 {
    return Err(
      InvalidSectionLength(
        "template 4.50 expected 38 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
  })
}

///|
fn typed_decode_template_451(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate451, Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      InvalidSectionLength(
        "template 4.51 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = template_payload[25].to_uint().reinterpret_as_int()
  let required = 26 + nc * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.51 category payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let categories : Array[Grib2CategoryForecastSpec] = []
  for i in 0..<nc {
    let offset = 26 + i * 12
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
  Ok({
    base,
    number_of_categories: nc,
    categories,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_453(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate453, Grib2SectionCodecError] {
  if template_payload.length() < 29 {
    return Err(
      InvalidSectionLength(
        "template 4.53 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[3].to_uint().reinterpret_as_int()
  let required = 29 + np * 2
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.53 partition payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let partition_set : Array[Int] = []
  for i in 0..<np {
    partition_set.push(typed_read_u16_be_view(template_payload, 4 + i * 2))
  }
  let offset = 6 + np * 2
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    partition_table_number: template_payload[2].to_uint().reinterpret_as_int(),
    number_of_partitions: np,
    partition_set,
    partition_number: typed_read_u16_be_view(template_payload, 4 + np * 2),
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_454(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate454, Grib2SectionCodecError] {
  if template_payload.length() < 32 {
    return Err(
      InvalidSectionLength(
        "template 4.54 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[3].to_uint().reinterpret_as_int()
  let required = 32 + np * 2
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.54 partition payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let partition_set : Array[Int] = []
  for i in 0..<np {
    partition_set.push(typed_read_u16_be_view(template_payload, 4 + i * 2))
  }
  let offset = 6 + np * 2
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    partition_table_number: template_payload[2].to_uint().reinterpret_as_int(),
    number_of_partitions: np,
    partition_set,
    partition_number: typed_read_u16_be_view(template_payload, 4 + np * 2),
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: template_payload[offset + 23]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[offset + 24]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[offset + 25]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_455(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate455, Grib2SectionCodecError] {
  if template_payload.length() != 31 {
    return Err(
      InvalidSectionLength(
        "template 4.55 expected 31 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    tile_classification: template_payload[2].to_uint().reinterpret_as_int(),
    total_number_of_tile_attribute_pairs: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_used_spatial_tiles: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    tile_index: template_payload[5].to_uint().reinterpret_as_int(),
    number_of_used_tile_attributes: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    tile_attribute: template_payload[7].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[8]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[14].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 27,
    ),
  })
}

///|
fn typed_decode_template_456(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate456, Grib2SectionCodecError] {
  if template_payload.length() != 33 {
    return Err(
      InvalidSectionLength(
        "template 4.56 expected 33 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    tile_classification: template_payload[2].to_uint().reinterpret_as_int(),
    total_number_of_tile_attribute_pairs: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_used_spatial_tiles: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    tile_index: template_payload[5].to_uint().reinterpret_as_int(),
    number_of_used_tile_attributes: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    tile_attribute: template_payload[7].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[8]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[14].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 27,
    ),
    perturbation_number: template_payload[31].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_457(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate457, Grib2SectionCodecError] {
  if template_payload.length() < 34 {
    return Err(
      InvalidSectionLength(
        "template 4.57 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let required = 34 + np * 5
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.57 function parameter payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: template_payload[offset]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_fixed_distribution_function_parameter: typed_read_u32_be_view(
        template_payload,
        offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: typed_read_u16_be_view(template_payload, 4),
    mode_number: typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_458(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate458, Grib2SectionCodecError] {
  if template_payload.length() < 37 {
    return Err(
      InvalidSectionLength(
        "template 4.58 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let required = 37 + np * 5
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.58 function parameter payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: template_payload[offset]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_fixed_distribution_function_parameter: typed_read_u32_be_view(
        template_payload,
        offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: typed_read_u16_be_view(template_payload, 4),
    mode_number: typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: template_payload[offset + 23]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[offset + 24]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[offset + 25]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_459(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate459, Grib2SectionCodecError] {
  if template_payload.length() != 34 {
    return Err(
      InvalidSectionLength(
        "template 4.59 expected 34 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    tile_classification: template_payload[2].to_uint().reinterpret_as_int(),
    total_number_of_tile_attribute_pairs: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_used_spatial_tiles: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    tile_index: template_payload[5].to_uint().reinterpret_as_int(),
    number_of_used_tile_attributes: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    tile_attribute: template_payload[7].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[8]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[14].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 27,
    ),
    type_of_ensemble_forecast: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[32].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_460(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate460, Grib2SectionCodecError] {
  if template_payload.length() != 35 {
    return Err(
      InvalidSectionLength(
        "template 4.60 expected 35 octets, got " +
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
    type_of_ensemble_forecast: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[26].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 28),
    month_of_model_version_date: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_461(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate461, Grib2SectionCodecError] {
  if template_payload.length() < 47 {
    return Err(
      InvalidSectionLength(
        "template 4.61 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[42].to_uint().reinterpret_as_int()
  let required = 47 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.61 time-range payload too short: expected at least " +
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
    type_of_ensemble_forecast: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[26].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 28),
    month_of_model_version_date: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 35),
    end_month: template_payload[37].to_uint().reinterpret_as_int(),
    end_day: template_payload[38].to_uint().reinterpret_as_int(),
    end_hour: template_payload[39].to_uint().reinterpret_as_int(),
    end_minute: template_payload[40].to_uint().reinterpret_as_int(),
    end_second: template_payload[41].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 43),
    time_range_specs: typed_decode_time_range_specs(template_payload, 47, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_462(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate462, Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      InvalidSectionLength(
        "template 4.62 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[38].to_uint().reinterpret_as_int()
  let required = 43 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.62 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    tile_classification: template_payload[2].to_uint().reinterpret_as_int(),
    total_number_of_tile_attribute_pairs: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_used_spatial_tiles: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    tile_index: template_payload[5].to_uint().reinterpret_as_int(),
    number_of_used_tile_attributes: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    tile_attribute: template_payload[7].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[8]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[14].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 27,
    ),
    end_year: typed_read_u16_be_view(template_payload, 31),
    end_month: template_payload[33].to_uint().reinterpret_as_int(),
    end_day: template_payload[34].to_uint().reinterpret_as_int(),
    end_hour: template_payload[35].to_uint().reinterpret_as_int(),
    end_minute: template_payload[36].to_uint().reinterpret_as_int(),
    end_second: template_payload[37].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 39),
    time_range_specs: typed_decode_time_range_specs(template_payload, 43, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_463(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate463, Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      InvalidSectionLength(
        "template 4.63 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[41].to_uint().reinterpret_as_int()
  let required = 46 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.63 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    tile_classification: template_payload[2].to_uint().reinterpret_as_int(),
    total_number_of_tile_attribute_pairs: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    number_of_used_spatial_tiles: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    tile_index: template_payload[5].to_uint().reinterpret_as_int(),
    number_of_used_tile_attributes: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    tile_attribute: template_payload[7].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[8]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[9]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[14].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: template_payload[19]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 27,
    ),
    type_of_ensemble_forecast: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[32].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
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
fn typed_decode_template_467(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate467, Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      InvalidSectionLength(
        "template 4.67 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let n_offset = 41 + np * 5
  if template_payload.length() <= n_offset {
    return Err(
      InvalidSectionLength(
        "template 4.67 missing number_of_time_ranges octet: got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[n_offset].to_uint().reinterpret_as_int()
  let required = 46 + np * 5 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.67 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let p_offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: template_payload[p_offset]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_fixed_distribution_function_parameter: typed_read_u32_be_view(
        template_payload,
        p_offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: typed_read_u16_be_view(template_payload, 4),
    mode_number: typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    end_year: typed_read_u16_be_view(template_payload, offset + 23),
    end_month: template_payload[offset + 25].to_uint().reinterpret_as_int(),
    end_day: template_payload[offset + 26].to_uint().reinterpret_as_int(),
    end_hour: template_payload[offset + 27].to_uint().reinterpret_as_int(),
    end_minute: template_payload[offset + 28].to_uint().reinterpret_as_int(),
    end_second: template_payload[offset + 29].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      offset + 31,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      offset + 35,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_468(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate468, Grib2SectionCodecError] {
  if template_payload.length() < 49 {
    return Err(
      InvalidSectionLength(
        "template 4.68 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let n_offset = 44 + np * 5
  if template_payload.length() <= n_offset {
    return Err(
      InvalidSectionLength(
        "template 4.68 missing number_of_time_ranges octet: got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[n_offset].to_uint().reinterpret_as_int()
  let required = 49 + np * 5 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.68 payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let p_offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: template_payload[p_offset]
      .to_uint()
      .reinterpret_as_int(),
      scaled_value_of_fixed_distribution_function_parameter: typed_read_u32_be_view(
        template_payload,
        p_offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: typed_read_u16_be_view(template_payload, 4),
    mode_number: typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: template_payload[offset]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[offset + 1]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[offset + 2]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: template_payload[offset + 5]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[offset + 6].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: template_payload[offset + 11]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[offset + 12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: template_payload[offset + 17]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[offset + 18]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: template_payload[offset + 23]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[offset + 24]
    .to_uint()
    .reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[offset + 25]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, offset + 26),
    end_month: template_payload[offset + 28].to_uint().reinterpret_as_int(),
    end_day: template_payload[offset + 29].to_uint().reinterpret_as_int(),
    end_hour: template_payload[offset + 30].to_uint().reinterpret_as_int(),
    end_minute: template_payload[offset + 31].to_uint().reinterpret_as_int(),
    end_second: template_payload[offset + 32].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(
      template_payload,
      offset + 34,
    ),
    time_range_specs: typed_decode_time_range_specs(
      template_payload,
      offset + 38,
      n,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_470(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate470, Grib2SectionCodecError] {
  if template_payload.length() != 30 {
    return Err(
      InvalidSectionLength(
        "template 4.70 expected 30 octets, got " +
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
  })
}

///|
fn typed_decode_template_471(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate471, Grib2SectionCodecError] {
  if template_payload.length() != 33 {
    return Err(
      InvalidSectionLength(
        "template 4.71 expected 33 octets, got " +
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
    type_of_ensemble_forecast: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[31].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_472(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate472, Grib2SectionCodecError] {
  if template_payload.length() < 42 {
    return Err(
      InvalidSectionLength(
        "template 4.72 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[37].to_uint().reinterpret_as_int()
  let required = 42 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.72 time-range payload too short: expected at least " +
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
    end_year: typed_read_u16_be_view(template_payload, 30),
    end_month: template_payload[32].to_uint().reinterpret_as_int(),
    end_day: template_payload[33].to_uint().reinterpret_as_int(),
    end_hour: template_payload[34].to_uint().reinterpret_as_int(),
    end_minute: template_payload[35].to_uint().reinterpret_as_int(),
    end_second: template_payload[36].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 38),
    time_range_specs: typed_decode_time_range_specs(template_payload, 42, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_473(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate473, Grib2SectionCodecError] {
  if template_payload.length() < 45 {
    return Err(
      InvalidSectionLength(
        "template 4.73 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[40].to_uint().reinterpret_as_int()
  let required = 45 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.73 time-range payload too short: expected at least " +
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
    type_of_ensemble_forecast: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[31].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 33),
    end_month: template_payload[35].to_uint().reinterpret_as_int(),
    end_day: template_payload[36].to_uint().reinterpret_as_int(),
    end_hour: template_payload[37].to_uint().reinterpret_as_int(),
    end_minute: template_payload[38].to_uint().reinterpret_as_int(),
    end_second: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 41),
    time_range_specs: typed_decode_time_range_specs(template_payload, 45, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_476(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate476, Grib2SectionCodecError] {
  if template_payload.length() != 28 {
    return Err(
      InvalidSectionLength(
        "template 4.76 expected 28 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    atmospheric_chemical_constituent_type: typed_read_u16_be_view(
      template_payload, 2,
    ),
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
    type_of_generating_process: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 8,
    ),
    minutes_of_observational_data_cutoff: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[11].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 12),
    type_of_first_fixed_surface: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 18,
    ),
    type_of_second_fixed_surface: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 24,
    ),
  })
}

///|
fn typed_decode_template_477(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate477, Grib2SectionCodecError] {
  if template_payload.length() != 31 {
    return Err(
      InvalidSectionLength(
        "template 4.77 expected 31 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_476(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[29].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_478(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate478, Grib2SectionCodecError] {
  if template_payload.length() < 40 {
    return Err(
      InvalidSectionLength(
        "template 4.78 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_476(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[35].to_uint().reinterpret_as_int()
  let required = 40 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.78 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 28),
    end_month: template_payload[30].to_uint().reinterpret_as_int(),
    end_day: template_payload[31].to_uint().reinterpret_as_int(),
    end_hour: template_payload[32].to_uint().reinterpret_as_int(),
    end_minute: template_payload[33].to_uint().reinterpret_as_int(),
    end_second: template_payload[34].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 36),
    time_range_specs: typed_decode_time_range_specs(template_payload, 40, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_479(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate479, Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      InvalidSectionLength(
        "template 4.79 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_477(template_payload.sub(end=31)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = template_payload[38].to_uint().reinterpret_as_int()
  let required = 43 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.79 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 31),
    end_month: template_payload[33].to_uint().reinterpret_as_int(),
    end_day: template_payload[34].to_uint().reinterpret_as_int(),
    end_hour: template_payload[35].to_uint().reinterpret_as_int(),
    end_minute: template_payload[36].to_uint().reinterpret_as_int(),
    end_second: template_payload[37].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 39),
    time_range_specs: typed_decode_time_range_specs(template_payload, 43, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_480(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate480, Grib2SectionCodecError] {
  if template_payload.length() != 50 {
    return Err(
      InvalidSectionLength(
        "template 4.80 expected 50 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
    type_of_interval_for_first_and_second_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    type_of_interval_for_first_and_second_wavelength: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_wavelength: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_wavelength: typed_read_u32_be_view(
      template_payload, 18,
    ),
    scale_factor_of_second_wavelength: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_wavelength: typed_read_u32_be_view(
      template_payload, 23,
    ),
    type_of_generating_process: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[29]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 30,
    ),
    minutes_of_observational_data_cutoff: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[33].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 34),
    type_of_first_fixed_surface: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 40,
    ),
    type_of_second_fixed_surface: template_payload[44]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[45]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 46,
    ),
  })
}

///|
fn typed_decode_template_481(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate481, Grib2SectionCodecError] {
  if template_payload.length() != 53 {
    return Err(
      InvalidSectionLength(
        "template 4.81 expected 53 octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_480(template_payload.sub(end=50)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[50]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[51].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[52]
    .to_uint()
    .reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_482(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate482, Grib2SectionCodecError] {
  if template_payload.length() < 51 {
    return Err(
      InvalidSectionLength(
        "template 4.82 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[46].to_uint().reinterpret_as_int()
  let required = 51 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.82 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
    type_of_interval_for_first_and_second_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    type_of_generating_process: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[22].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    end_year: typed_read_u16_be_view(template_payload, 39),
    end_month: template_payload[41].to_uint().reinterpret_as_int(),
    end_day: template_payload[42].to_uint().reinterpret_as_int(),
    end_hour: template_payload[43].to_uint().reinterpret_as_int(),
    end_minute: template_payload[44].to_uint().reinterpret_as_int(),
    end_second: template_payload[45].to_uint().reinterpret_as_int(),
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
  if template_payload.length() < 54 {
    return Err(
      InvalidSectionLength(
        "template 4.83 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[49].to_uint().reinterpret_as_int()
  let required = 54 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.83 time-range payload too short: expected at least " +
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
    aerosol_type: typed_read_u16_be_view(template_payload, 3),
    source_or_sink: template_payload[5].to_uint().reinterpret_as_int(),
    type_of_interval_for_first_and_second_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[7]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 8),
    scale_factor_of_second_size: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 13),
    background_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[22].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    type_of_ensemble_forecast: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[40].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[41]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 42),
    end_month: template_payload[44].to_uint().reinterpret_as_int(),
    end_day: template_payload[45].to_uint().reinterpret_as_int(),
    end_hour: template_payload[46].to_uint().reinterpret_as_int(),
    end_minute: template_payload[47].to_uint().reinterpret_as_int(),
    end_second: template_payload[48].to_uint().reinterpret_as_int(),
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
  if template_payload.length() < 54 {
    return Err(
      InvalidSectionLength(
        "template 4.84 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[49].to_uint().reinterpret_as_int()
  let required = 54 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.84 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    source_or_sink: template_payload[4].to_uint().reinterpret_as_int(),
    type_of_interval_for_first_and_second_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[6]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 7),
    scale_factor_of_second_size: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 12),
    type_of_generating_process: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[18]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 19,
    ),
    minutes_of_observational_data_cutoff: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[22].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 23),
    type_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 29,
    ),
    type_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 35,
    ),
    type_of_ensemble_forecast: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[40].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[41]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 42),
    end_month: template_payload[44].to_uint().reinterpret_as_int(),
    end_day: template_payload[45].to_uint().reinterpret_as_int(),
    end_hour: template_payload[46].to_uint().reinterpret_as_int(),
    end_minute: template_payload[47].to_uint().reinterpret_as_int(),
    end_second: template_payload[48].to_uint().reinterpret_as_int(),
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
  if template_payload.length() < 53 {
    return Err(
      InvalidSectionLength(
        "template 4.85 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[48].to_uint().reinterpret_as_int()
  let required = 53 + n * 12
  if template_payload.length() < required {
    return Err(
      InvalidSectionLength(
        "template 4.85 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    aerosol_type: typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_size: template_payload[5]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_size: typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_size: typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[16]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[17]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: template_payload[20]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[21].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 34,
    ),
    type_of_ensemble_forecast: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: template_payload[39].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
    end_year: typed_read_u16_be_view(template_payload, 41),
    end_month: template_payload[43].to_uint().reinterpret_as_int(),
    end_day: template_payload[44].to_uint().reinterpret_as_int(),
    end_hour: template_payload[45].to_uint().reinterpret_as_int(),
    end_minute: template_payload[46].to_uint().reinterpret_as_int(),
    end_second: template_payload[47].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 49),
    time_range_specs: typed_decode_time_range_specs(template_payload, 53, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_420(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate420, Grib2SectionCodecError] {
  if template_payload.length() != 34 {
    return Err(
      InvalidSectionLength(
        "template 4.20 expected 34 octets, got " +
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
    number_of_radar_sites_used: template_payload[3]
    .to_uint()
    .reinterpret_as_int(),
    indicator_of_unit_time_range: template_payload[4]
    .to_uint()
    .reinterpret_as_int(),
    site_latitude: typed_read_u32_be_view(template_payload, 5),
    site_longitude: typed_read_u32_be_view(template_payload, 9),
    site_elevation: typed_read_u16_be_view(template_payload, 13),
    site_identifier_alphanumeric: typed_read_u32_be_view(template_payload, 15),
    site_identifier_numeric: typed_read_u16_be_view(template_payload, 19),
    operating_mode: template_payload[21].to_uint().reinterpret_as_int(),
    reflectivity_calibration_constant: template_payload[22]
    .to_uint()
    .reinterpret_as_int(),
    quality_control_indicator: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    clutter_filter_indicator: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    constant_antenna_elevation_angle: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    accumulation_interval: typed_read_u16_be_view(template_payload, 26),
    reference_reflectivity: template_payload[28].to_uint().reinterpret_as_int(),
    range_bin_spacing: typed_read_u24_be_view(template_payload, 29),
    radial_angular_spacing: typed_read_u16_be_view(template_payload, 32),
  })
}

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

///|
pub fn decode_section4_bytes(
  section : Bytes,
) -> Result[Grib2Section4Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 4) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 9 {
    return Err(
      InvalidSectionLength(
        "section4 too short: " + section.length().to_string(),
      ),
    )
  }
  let number_of_coordinate_values = typed_read_u16_be(section, 5)
  let template_number = typed_read_u16_be(section, 7)
  let payload = section.sub(start=9)
  let coord_len = number_of_coordinate_values * 4
  if payload.length() < coord_len {
    return Err(
      InvalidSectionLength(
        "section4 coordinate payload too short: expected at least " +
        coord_len.to_string() +
        ", got " +
        payload.length().to_string(),
      ),
    )
  }
  let template_len = payload.length() - coord_len
  let template_payload = payload.sub(end=template_len)
  let coordinate_values_raw = payload.sub(start=template_len).to_bytes()
  let template = if template_number == 0 {
    match typed_decode_template_40(template_payload) {
      Ok(template_40) => ProductTemplate40(template_40)
      Err(error) => return Err(error)
    }
  } else if template_number == 1 {
    match typed_decode_template_41(template_payload) {
      Ok(template_41) => ProductTemplate41(template_41)
      Err(error) => return Err(error)
    }
  } else if template_number == 2 {
    match typed_decode_template_42(template_payload) {
      Ok(template_42) => ProductTemplate42(template_42)
      Err(error) => return Err(error)
    }
  } else if template_number == 3 {
    match typed_decode_template_43(template_payload) {
      Ok(template_43) => ProductTemplate43(template_43)
      Err(error) => return Err(error)
    }
  } else if template_number == 4 {
    match typed_decode_template_44(template_payload) {
      Ok(template_44) => ProductTemplate44(template_44)
      Err(error) => return Err(error)
    }
  } else if template_number == 5 {
    match typed_decode_template_45(template_payload) {
      Ok(template_45) => ProductTemplate45(template_45)
      Err(error) => return Err(error)
    }
  } else if template_number == 6 {
    match typed_decode_template_46(template_payload) {
      Ok(template_46) => ProductTemplate46(template_46)
      Err(error) => return Err(error)
    }
  } else if template_number == 7 {
    match typed_decode_template_47(template_payload) {
      Ok(template_47) => ProductTemplate47(template_47)
      Err(error) => return Err(error)
    }
  } else if template_number == 8 {
    match typed_decode_template_48(template_payload) {
      Ok(template_48) => ProductTemplate48(template_48)
      Err(error) => return Err(error)
    }
  } else if template_number == 9 {
    match typed_decode_template_49(template_payload) {
      Ok(template_49) => ProductTemplate49(template_49)
      Err(error) => return Err(error)
    }
  } else if template_number == 10 {
    match typed_decode_template_410(template_payload) {
      Ok(template_410) => ProductTemplate410(template_410)
      Err(error) => return Err(error)
    }
  } else if template_number == 11 {
    match typed_decode_template_411(template_payload) {
      Ok(template_411) => ProductTemplate411(template_411)
      Err(error) => return Err(error)
    }
  } else if template_number == 12 {
    match typed_decode_template_412(template_payload) {
      Ok(template_412) => ProductTemplate412(template_412)
      Err(error) => return Err(error)
    }
  } else if template_number == 13 {
    match typed_decode_template_413(template_payload) {
      Ok(template_413) => ProductTemplate413(template_413)
      Err(error) => return Err(error)
    }
  } else if template_number == 14 {
    match typed_decode_template_414(template_payload) {
      Ok(template_414) => ProductTemplate414(template_414)
      Err(error) => return Err(error)
    }
  } else if template_number == 15 {
    match typed_decode_template_415(template_payload) {
      Ok(template_415) => ProductTemplate415(template_415)
      Err(error) => return Err(error)
    }
  } else if template_number == 20 {
    match typed_decode_template_420(template_payload) {
      Ok(template_420) => ProductTemplate420(template_420)
      Err(error) => return Err(error)
    }
  } else if template_number == 30 {
    match typed_decode_template_430(template_payload) {
      Ok(template_430) => ProductTemplate430(template_430)
      Err(error) => return Err(error)
    }
  } else if template_number == 31 {
    match typed_decode_template_431(template_payload) {
      Ok(template_431) => ProductTemplate431(template_431)
      Err(error) => return Err(error)
    }
  } else if template_number == 32 {
    match typed_decode_template_432(template_payload) {
      Ok(template_432) => ProductTemplate432(template_432)
      Err(error) => return Err(error)
    }
  } else if template_number == 33 {
    match typed_decode_template_433(template_payload) {
      Ok(template_433) => ProductTemplate433(template_433)
      Err(error) => return Err(error)
    }
  } else if template_number == 34 {
    match typed_decode_template_434(template_payload) {
      Ok(template_434) => ProductTemplate434(template_434)
      Err(error) => return Err(error)
    }
  } else if template_number == 35 {
    match typed_decode_template_435(template_payload) {
      Ok(template_435) => ProductTemplate435(template_435)
      Err(error) => return Err(error)
    }
  } else if template_number == 40 {
    match typed_decode_template_440(template_payload) {
      Ok(template_440) => ProductTemplate440(template_440)
      Err(error) => return Err(error)
    }
  } else if template_number == 41 {
    match typed_decode_template_441(template_payload) {
      Ok(template_441) => ProductTemplate441(template_441)
      Err(error) => return Err(error)
    }
  } else if template_number == 42 {
    match typed_decode_template_442(template_payload) {
      Ok(template_442) => ProductTemplate442(template_442)
      Err(error) => return Err(error)
    }
  } else if template_number == 43 {
    match typed_decode_template_443(template_payload) {
      Ok(template_443) => ProductTemplate443(template_443)
      Err(error) => return Err(error)
    }
  } else if template_number == 44 {
    match typed_decode_template_444(template_payload) {
      Ok(template_444) => ProductTemplate444(template_444)
      Err(error) => return Err(error)
    }
  } else if template_number == 45 {
    match typed_decode_template_445(template_payload) {
      Ok(template_445) => ProductTemplate445(template_445)
      Err(error) => return Err(error)
    }
  } else if template_number == 46 {
    match typed_decode_template_446(template_payload) {
      Ok(template_446) => ProductTemplate446(template_446)
      Err(error) => return Err(error)
    }
  } else if template_number == 47 {
    match typed_decode_template_447(template_payload) {
      Ok(template_447) => ProductTemplate447(template_447)
      Err(error) => return Err(error)
    }
  } else if template_number == 48 {
    match typed_decode_template_448(template_payload) {
      Ok(template_448) => ProductTemplate448(template_448)
      Err(error) => return Err(error)
    }
  } else if template_number == 49 {
    match typed_decode_template_449(template_payload) {
      Ok(template_449) => ProductTemplate449(template_449)
      Err(error) => return Err(error)
    }
  } else if template_number == 50 {
    match typed_decode_template_450(template_payload) {
      Ok(template_450) => ProductTemplate450(template_450)
      Err(error) => return Err(error)
    }
  } else if template_number == 51 {
    match typed_decode_template_451(template_payload) {
      Ok(template_451) => ProductTemplate451(template_451)
      Err(error) => return Err(error)
    }
  } else if template_number == 53 {
    match typed_decode_template_453(template_payload) {
      Ok(template_453) => ProductTemplate453(template_453)
      Err(error) => return Err(error)
    }
  } else if template_number == 54 {
    match typed_decode_template_454(template_payload) {
      Ok(template_454) => ProductTemplate454(template_454)
      Err(error) => return Err(error)
    }
  } else if template_number == 55 {
    match typed_decode_template_455(template_payload) {
      Ok(template_455) => ProductTemplate455(template_455)
      Err(error) => return Err(error)
    }
  } else if template_number == 56 {
    match typed_decode_template_456(template_payload) {
      Ok(template_456) => ProductTemplate456(template_456)
      Err(error) => return Err(error)
    }
  } else if template_number == 57 {
    match typed_decode_template_457(template_payload) {
      Ok(template_457) => ProductTemplate457(template_457)
      Err(error) => return Err(error)
    }
  } else if template_number == 58 {
    match typed_decode_template_458(template_payload) {
      Ok(template_458) => ProductTemplate458(template_458)
      Err(error) => return Err(error)
    }
  } else if template_number == 59 {
    match typed_decode_template_459(template_payload) {
      Ok(template_459) => ProductTemplate459(template_459)
      Err(error) => return Err(error)
    }
  } else if template_number == 60 {
    match typed_decode_template_460(template_payload) {
      Ok(template_460) => ProductTemplate460(template_460)
      Err(error) => return Err(error)
    }
  } else if template_number == 61 {
    match typed_decode_template_461(template_payload) {
      Ok(template_461) => ProductTemplate461(template_461)
      Err(error) => return Err(error)
    }
  } else if template_number == 62 {
    match typed_decode_template_462(template_payload) {
      Ok(template_462) => ProductTemplate462(template_462)
      Err(error) => return Err(error)
    }
  } else if template_number == 63 {
    match typed_decode_template_463(template_payload) {
      Ok(template_463) => ProductTemplate463(template_463)
      Err(error) => return Err(error)
    }
  } else if template_number == 67 {
    match typed_decode_template_467(template_payload) {
      Ok(template_467) => ProductTemplate467(template_467)
      Err(error) => return Err(error)
    }
  } else if template_number == 68 {
    match typed_decode_template_468(template_payload) {
      Ok(template_468) => ProductTemplate468(template_468)
      Err(error) => return Err(error)
    }
  } else if template_number == 70 {
    match typed_decode_template_470(template_payload) {
      Ok(template_470) => ProductTemplate470(template_470)
      Err(error) => return Err(error)
    }
  } else if template_number == 71 {
    match typed_decode_template_471(template_payload) {
      Ok(template_471) => ProductTemplate471(template_471)
      Err(error) => return Err(error)
    }
  } else if template_number == 72 {
    match typed_decode_template_472(template_payload) {
      Ok(template_472) => ProductTemplate472(template_472)
      Err(error) => return Err(error)
    }
  } else if template_number == 73 {
    match typed_decode_template_473(template_payload) {
      Ok(template_473) => ProductTemplate473(template_473)
      Err(error) => return Err(error)
    }
  } else if template_number == 76 {
    match typed_decode_template_476(template_payload) {
      Ok(template_476) => ProductTemplate476(template_476)
      Err(error) => return Err(error)
    }
  } else if template_number == 77 {
    match typed_decode_template_477(template_payload) {
      Ok(template_477) => ProductTemplate477(template_477)
      Err(error) => return Err(error)
    }
  } else if template_number == 78 {
    match typed_decode_template_478(template_payload) {
      Ok(template_478) => ProductTemplate478(template_478)
      Err(error) => return Err(error)
    }
  } else if template_number == 79 {
    match typed_decode_template_479(template_payload) {
      Ok(template_479) => ProductTemplate479(template_479)
      Err(error) => return Err(error)
    }
  } else if template_number == 80 {
    match typed_decode_template_480(template_payload) {
      Ok(template_480) => ProductTemplate480(template_480)
      Err(error) => return Err(error)
    }
  } else if template_number == 81 {
    match typed_decode_template_481(template_payload) {
      Ok(template_481) => ProductTemplate481(template_481)
      Err(error) => return Err(error)
    }
  } else if template_number == 82 {
    match typed_decode_template_482(template_payload) {
      Ok(template_482) => ProductTemplate482(template_482)
      Err(error) => return Err(error)
    }
  } else if template_number == 83 {
    match typed_decode_template_483(template_payload) {
      Ok(template_483) => ProductTemplate483(template_483)
      Err(error) => return Err(error)
    }
  } else if template_number == 84 {
    match typed_decode_template_484(template_payload) {
      Ok(template_484) => ProductTemplate484(template_484)
      Err(error) => return Err(error)
    }
  } else if template_number == 85 {
    match typed_decode_template_485(template_payload) {
      Ok(template_485) => ProductTemplate485(template_485)
      Err(error) => return Err(error)
    }
  } else {
    ProductTemplateUnknown(template_number, template_payload.to_bytes())
  }
  Ok({ number_of_coordinate_values, template, coordinate_values_raw })
}

///|
pub fn encode_section4_bytes(section : Grib2Section4Decoded) -> Bytes {
  let payload : Array[Byte] = []
  typed_push_u16_be(payload, section.number_of_coordinate_values)
  let (template_number, template_raw) = match section.template {
    ProductTemplate40(template_40) => (0, typed_encode_template_40(template_40))
    ProductTemplate41(template_41) => (1, typed_encode_template_41(template_41))
    ProductTemplate42(template_42) => (2, typed_encode_template_42(template_42))
    ProductTemplate43(template_43) => (3, typed_encode_template_43(template_43))
    ProductTemplate44(template_44) => (4, typed_encode_template_44(template_44))
    ProductTemplate45(template_45) => (5, typed_encode_template_45(template_45))
    ProductTemplate46(template_46) => (6, typed_encode_template_46(template_46))
    ProductTemplate47(template_47) => (7, typed_encode_template_47(template_47))
    ProductTemplate48(template_48) => (8, typed_encode_template_48(template_48))
    ProductTemplate49(template_49) => (9, typed_encode_template_49(template_49))
    ProductTemplate410(template_410) =>
      (10, typed_encode_template_410(template_410))
    ProductTemplate411(template_411) =>
      (11, typed_encode_template_411(template_411))
    ProductTemplate412(template_412) =>
      (12, typed_encode_template_412(template_412))
    ProductTemplate413(template_413) =>
      (13, typed_encode_template_413(template_413))
    ProductTemplate414(template_414) =>
      (14, typed_encode_template_414(template_414))
    ProductTemplate415(template_415) =>
      (15, typed_encode_template_415(template_415))
    ProductTemplate420(template_420) =>
      (20, typed_encode_template_420(template_420))
    ProductTemplate430(template_430) =>
      (30, typed_encode_template_430(template_430))
    ProductTemplate431(template_431) =>
      (31, typed_encode_template_431(template_431))
    ProductTemplate432(template_432) =>
      (32, typed_encode_template_432(template_432))
    ProductTemplate433(template_433) =>
      (33, typed_encode_template_433(template_433))
    ProductTemplate434(template_434) =>
      (34, typed_encode_template_434(template_434))
    ProductTemplate435(template_435) =>
      (35, typed_encode_template_435(template_435))
    ProductTemplate440(template_440) =>
      (40, typed_encode_template_440(template_440))
    ProductTemplate441(template_441) =>
      (41, typed_encode_template_441(template_441))
    ProductTemplate442(template_442) =>
      (42, typed_encode_template_442(template_442))
    ProductTemplate443(template_443) =>
      (43, typed_encode_template_443(template_443))
    ProductTemplate444(template_444) =>
      (44, typed_encode_template_444(template_444))
    ProductTemplate445(template_445) =>
      (45, typed_encode_template_445(template_445))
    ProductTemplate446(template_446) =>
      (46, typed_encode_template_446(template_446))
    ProductTemplate447(template_447) =>
      (47, typed_encode_template_447(template_447))
    ProductTemplate448(template_448) =>
      (48, typed_encode_template_448(template_448))
    ProductTemplate449(template_449) =>
      (49, typed_encode_template_449(template_449))
    ProductTemplate450(template_450) =>
      (50, typed_encode_template_450(template_450))
    ProductTemplate451(template_451) =>
      (51, typed_encode_template_451(template_451))
    ProductTemplate453(template_453) =>
      (53, typed_encode_template_453(template_453))
    ProductTemplate454(template_454) =>
      (54, typed_encode_template_454(template_454))
    ProductTemplate455(template_455) =>
      (55, typed_encode_template_455(template_455))
    ProductTemplate456(template_456) =>
      (56, typed_encode_template_456(template_456))
    ProductTemplate457(template_457) =>
      (57, typed_encode_template_457(template_457))
    ProductTemplate458(template_458) =>
      (58, typed_encode_template_458(template_458))
    ProductTemplate459(template_459) =>
      (59, typed_encode_template_459(template_459))
    ProductTemplate460(template_460) =>
      (60, typed_encode_template_460(template_460))
    ProductTemplate461(template_461) =>
      (61, typed_encode_template_461(template_461))
    ProductTemplate462(template_462) =>
      (62, typed_encode_template_462(template_462))
    ProductTemplate463(template_463) =>
      (63, typed_encode_template_463(template_463))
    ProductTemplate467(template_467) =>
      (67, typed_encode_template_467(template_467))
    ProductTemplate468(template_468) =>
      (68, typed_encode_template_468(template_468))
    ProductTemplate470(template_470) =>
      (70, typed_encode_template_470(template_470))
    ProductTemplate471(template_471) =>
      (71, typed_encode_template_471(template_471))
    ProductTemplate472(template_472) =>
      (72, typed_encode_template_472(template_472))
    ProductTemplate473(template_473) =>
      (73, typed_encode_template_473(template_473))
    ProductTemplate476(template_476) =>
      (76, typed_encode_template_476(template_476))
    ProductTemplate477(template_477) =>
      (77, typed_encode_template_477(template_477))
    ProductTemplate478(template_478) =>
      (78, typed_encode_template_478(template_478))
    ProductTemplate479(template_479) =>
      (79, typed_encode_template_479(template_479))
    ProductTemplate480(template_480) =>
      (80, typed_encode_template_480(template_480))
    ProductTemplate481(template_481) =>
      (81, typed_encode_template_481(template_481))
    ProductTemplate482(template_482) =>
      (82, typed_encode_template_482(template_482))
    ProductTemplate483(template_483) =>
      (83, typed_encode_template_483(template_483))
    ProductTemplate484(template_484) =>
      (84, typed_encode_template_484(template_484))
    ProductTemplate485(template_485) =>
      (85, typed_encode_template_485(template_485))
    ProductTemplateUnknown(template_number, raw) => (template_number, raw)
  }
  typed_push_u16_be(payload, template_number)
  for b in template_raw {
    payload.push(b)
  }
  for b in section.coordinate_values_raw {
    payload.push(b)
  }
  typed_build_section(4, Bytes::from_array(payload))
}

///|
fn typed_message_section_bytes(
  message : Grib2MessageContext,
  frame : Grib2SectionFrame,
) -> Bytes {
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  message.raw.sub(start~, end~).to_bytes()
}

///|
pub fn decode_message_section1(
  message : Grib2MessageContext,
) -> Result[Grib2Section1Decoded, Grib2SectionCodecError] {
  decode_section1_bytes(typed_message_section_bytes(message, message.section1))
}

///|
pub fn decode_submessage_section3(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section3Decoded, Grib2SectionCodecError] {
  decode_section3_bytes(
    typed_message_section_bytes(message, submessage.section3),
  )
}

///|
pub fn decode_submessage_section4(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section4Decoded, Grib2SectionCodecError] {
  decode_section4_bytes(
    typed_message_section_bytes(message, submessage.section4),
  )
}
