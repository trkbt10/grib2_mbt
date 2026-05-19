///|
/// Per-record metadata snapshot that the inventory formatter consumes.
///
/// Every field reflects the spec-mandated position in its host section. When
/// a field is not meaningful for the current PDT/GDT/DRT it is set to -1
/// (signed) so the formatter can suppress the corresponding output column
/// the same way wgrib2 does.
pub(all) struct Grib2RecordMeta {
  record_index : Int
  record_id : String
  message_offset : Int
  message_total_length : Int
  reference_time : String
  reference_time_full : String
  unix_rt : Int64
  unix_vt : Int64
  discipline : Int
  edition : Int
  section1_center : Int
  section1_subcenter : Int
  section1_master_tables_version : Int
  section1_local_tables_version : Int
  section1_significance_of_ref_time : Int
  section1_production_status : Int
  section1_data_type : Int
  parameter_name : Grib2NameLookup
  level_name : Grib2NameLookup
  tail : String
  section0_reserved : String
  section3_template : Grib2Section3Template
  section4_template : Grib2Section4Template
  section5_template : Grib2Section5Template
  section1_length : Int
  section2_length : Int
  section3_length : Int
  section3_reused : Bool
  section3_gdef_source : Int
  section3_npts : Int
  section3_num_octets_per_optional_list : Int
  section3_interpretation_of_optional_list : Int
  // Code Table 3.6 (Spectral representation type) – PDTs 50-53 octet 27.
  section3_spectral_representation_type : Int
  // Code Table 3.7 (Spectral representation mode) – PDTs 50-53 octet 28.
  section3_spectral_representation_mode : Int
  // Code Table 3.8 (Grid point position) – PDTs 100/101 octet 32.
  section3_grid_point_position : Int
  // Code Table 3.15 (Physical meaning of vertical coordinate) – PDT 1200 octet 39.
  section3_vertical_coord_meaning : Int
  // Code Table 3.20 (Type of horizontal line) – PDT 1100 octet 60.
  section3_horizontal_line_type : Int
  // Code Table 3.21 (Vertical dimension coordinate definition) – PDT 1000 octet 64.
  section3_vertical_dim_coord_def : Int
  section3_ni : Int
  section3_nj : Int
  section3_resolution_flags : Int
  section3_lat1_microdeg : Int
  section3_lon1_microdeg : Int
  section3_lat2_microdeg : Int
  section3_lon2_microdeg : Int
  section3_di_microdeg : Int
  section3_dj_microdeg : Int
  section3_scanning_mode : Int
  section3_shape_of_earth : Int
  section3_scale_factor_radius : Int
  section3_scaled_value_radius : Int
  section3_scale_factor_major : Int
  section3_scaled_value_major : Int
  section3_scale_factor_minor : Int
  section3_scaled_value_minor : Int
  section4_length : Int
  section4_num_coord : Int
  section4_parameter_category : Int
  section4_parameter_number : Int
  section4_time_unit : Int
  section4_process_code : Int
  section4_ens_type : Int
  section4_ens_perturbation_number : Int
  section4_ens_member_count : Int
  section4_prob_forecast_index : Int
  section4_prob_total_forecasts : Int
  section4_prob_type : Int
  section4_prob_lower_scale_factor : Int
  section4_prob_lower_value : Int
  section4_prob_upper_scale_factor : Int
  section4_prob_upper_value : Int
  section4_first_surface_type : Int
  section4_second_surface_type : Int
  section4_background_process : Int
  section4_forecast_process : Int
  // Code Table 4.10 (Statistical processing) – populated for PDTs 8/9/10/11/12/13/14/15
  section4_statistical_processing : Int
  // Code Table 4.11 (Type of time increment) – populated for PDTs 8/9/10/11/12/13/14
  section4_time_increment_type : Int
  // Code Table 4.15 (Type of spatial processing) – populated for PDT 15
  section4_spatial_processing : Int
  // Code Table 4.16 (Quality value associated with parameter) – populated for PDTs
  // 35 and others that include the field. -1 when N/A.
  section4_quality_value : Int
  // Code Table 4.91 (Type of interval, first/second size) – populated for PDTs
  // 5/9/80/81/82/83/84.
  section4_interval_type : Int
  // Code Table 4.230 (Atmospheric chemical constituent type) – PDTs 40-43.
  section4_chemical_constituent : Int
  // Code Table 4.233 (Aerosol type) – PDTs 44-50.
  section4_aerosol_type : Int
  // Code Table 4.240 (Type of distribution function) – PDTs 57/58/67/68.
  section4_distribution_function : Int
  // Code Table 4.241 (Coverage attributes) – PDT 55/56 (octet 17).
  section4_coverage_attributes : Int
  // Code Table 4.242 (Tile classification) – PDT 55/56 (octet 12).
  section4_tile_classification : Int
  section5_length : Int
  section5_num_defined_points : Int
  section5_reference_value_ieee : Int
  section5_binary_scale_factor : Int
  section5_decimal_scale_factor : Int
  section5_bits_per_value : Int
  section5_original_field_type : Int
  section5_group_split_method : Int
  section5_missing_value_management : Int
  section5_spatial_diff_order : Int
  section5_ieee_precision : Int
  section6_length : Int
  section6_bitmap_indicator : Int
  section6_undef_points : Int
  section7_length : Int
}
