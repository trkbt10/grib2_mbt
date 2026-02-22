///|
fn parse_fixture_for_decode(
  path : String,
) -> Result[@lib.Grib2FileContext, String] {
  let bytes = try @fs.read_file_to_bytes(path) catch {
    error =>
      return Err("failed to read fixture " + path + ": " + error.to_string())
  } noraise {
    bytes => bytes
  }
  match @lib.parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(error) =>
      Err("failed to parse fixture " + path + ": " + error.to_string())
  }
}

///|
test "decode records exposes context fields" {
  let context = match
    parse_fixture_for_decode(
      "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2",
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="19")
  inspect(records[0].record_id, content="1")
  inspect(records[0].reference_time, content="2026022100")
  inspect(records[0].parameter_name.display(), content="WIND")
  inspect(records[0].level_name.display(), content="surface")
}

///|
test "template dispatch foundation: fixture templates" {
  let context = parse_fixture_for_decode(
    "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2",
  )
  let records = match context {
    Ok(context) => @lib.decode_records(context)
    Err(error) => fail(error)
  }
  inspect(records[0].section3_template.id(), content="0")
  inspect(records[0].section4_template.id(), content="0")
  inspect(records[0].section5_template.id(), content="3")
  inspect(records[0].section3_template.is_known(), content="true")
  inspect(records[0].section4_template.is_known(), content="true")
  inspect(records[0].section5_template.is_known(), content="true")
}

///|
test "table lookup foundation: parameter and level known-unknown split" {
  inspect(
    @lib.decode_discipline_name(0).display(),
    content="Meteorological Products",
  )
  inspect(
    @lib.decode_discipline_name(10).display(),
    content="Oceanographic Products",
  )
  inspect(@lib.decode_discipline_name(42).display(), content="discipline=42")
  inspect(
    @lib.decode_master_table_version_name(0).display(),
    content="Experimental",
  )
  inspect(
    @lib.decode_master_table_version_name(1).display(),
    content="Operational",
  )
  inspect(
    @lib.decode_master_table_version_name(2).display(),
    content="Version 2",
  )
  inspect(
    @lib.decode_master_table_version_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_master_table_version_name(-1).display(),
    content="master_table_version=-1",
  )
  inspect(@lib.decode_local_table_version_name(0).display(), content="Not Used")
  inspect(
    @lib.decode_local_table_version_name(7).display(),
    content="Version 7",
  )
  inspect(
    @lib.decode_local_table_version_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(0).display(),
    content="Analysis",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(6).display(),
    content="Start of Data Assimilation",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(7).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_production_status_name(0).display(),
    content="Operational Products",
  )
  inspect(@lib.decode_production_status_name(16).display(), content="MLMIP")
  inspect(@lib.decode_production_status_name(190).display(), content="Reserved")
  inspect(
    @lib.decode_production_status_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_processed_data_type_name(0).display(),
    content="Analysis Products",
  )
  inspect(
    @lib.decode_processed_data_type_name(10).display(),
    content="ML Based Forecast",
  )
  inspect(
    @lib.decode_processed_data_type_name(192).display(),
    content="Experimental Products",
  )
  inspect(
    @lib.decode_processed_data_type_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_identification_template_number_name(0).display(),
    content="Calendar Definition",
  )
  inspect(
    @lib.decode_identification_template_number_name(2).display(),
    content="Calendar Definition and Paleontological Offset",
  )
  inspect(
    @lib.decode_identification_template_number_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_identification_template_number_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_identification_template_number_name(65535).display(),
    content="Missing",
  )
  inspect(@lib.decode_calendar_type_name(0).display(), content="Gregorian")
  inspect(
    @lib.decode_calendar_type_name(3).display(),
    content="Proleptic Gregorian",
  )
  inspect(@lib.decode_calendar_type_name(20).display(), content="Reserved")
  inspect(
    @lib.decode_calendar_type_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_grid_definition_source_name(0).display(),
    content="Specified in Table 3.1",
  )
  inspect(
    @lib.decode_grid_definition_source_name(1).display(),
    content="Predetermined Grid Definition",
  )
  inspect(
    @lib.decode_grid_definition_source_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_grid_definition_source_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_grid_definition_source_name(255).display(),
    content="Grid Definition Does Not Apply",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(0).display(),
    content="Latitude/Longitude",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(63).display(),
    content="Spectral Lambert Conformal with Modelling Subdomains",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(1200).display(),
    content="Time Section Grid",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(7).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(0).display(),
    content="Spherical Earth (Radius 6367470.0 m)",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(5).display(),
    content="Earth Represented by WGS84",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(11).display(),
    content="Sun Spherical Reference System",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_resolution_and_component_flags_name(0).display(),
    content="i_increment=not_given,j_increment=not_given,vector_components=earth_relative",
  )
  inspect(
    @lib.decode_resolution_and_component_flags_name(56).display(),
    content="i_increment=given,j_increment=given,vector_components=grid_relative",
  )
  inspect(
    @lib.decode_scanning_mode_name(0).display(),
    content="i_scan=+i,j_scan=-j,adjacent_consecutive=i,row_scan=same,odd_i_offset=none,even_i_offset=none,j_offset=none,row_col_count=ni_nj",
  )
  inspect(
    @lib.decode_scanning_mode_name(193).display(),
    content="i_scan=-i,j_scan=+j,adjacent_consecutive=i,row_scan=same,odd_i_offset=none,even_i_offset=none,j_offset=none,row_col_count=reduced_when_offset",
  )
  inspect(
    @lib.decode_projection_center_name(0).display(),
    content="pole=north,projection=single_center",
  )
  inspect(
    @lib.decode_projection_center_name(192).display(),
    content="pole=south,projection=bi_polar_symmetric",
  )
  inspect(
    @lib.decode_spectral_data_representation_type_name(1).display(),
    content="Associated Legendre Functions",
  )
  inspect(
    @lib.decode_spectral_data_representation_type_name(2).display(),
    content="Bi-Fourier Representation",
  )
  inspect(
    @lib.decode_spectral_data_representation_mode_name(1).display(),
    content="Complex Coefficients Stored as Re/Im Pairs",
  )
  inspect(
    @lib.decode_spectral_data_representation_mode_name(200).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_spectral_data_representation_mode_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_grid_point_position_name(0).display(),
    content="Triangle Vertices",
  )
  inspect(
    @lib.decode_grid_point_position_name(5).display(),
    content="Midpoints of Shape Sides",
  )
  inspect(
    @lib.decode_grid_point_position_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_grid_point_position_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_diamond_numbering_order_name(0).display(),
    content="orientation=clockwise",
  )
  inspect(
    @lib.decode_diamond_numbering_order_name(128).display(),
    content="orientation=counter_clockwise",
  )
  inspect(
    @lib.decode_diamond_scanning_mode_name(0).display(),
    content="i_scan=pole_to_equator,j_scan=west_to_east,adjacent_consecutive=i",
  )
  inspect(
    @lib.decode_diamond_scanning_mode_name(224).display(),
    content="i_scan=equator_to_pole,j_scan=east_to_west,adjacent_consecutive=j",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(0).display(),
    content="No Appended List",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(3).display(),
    content="Actual Latitudes for Each Row",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(200).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(0).display(),
    content="Template 4.0",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(254).display(),
    content="Template 4.254",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(1101).display(),
    content="Template 4.1101",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(52).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 0).display(),
    content="Temperature",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 192).display(),
    content="Covariance",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_category_name(1, 2).display(),
    content="Inland Water and Sediment Properties",
  )
  inspect(
    @lib.decode_parameter_category_name(2, 3).display(),
    content="Soil Products",
  )
  inspect(
    @lib.decode_parameter_category_name(3, 192).display(),
    content="Forecast Satellite Imagery",
  )
  inspect(
    @lib.decode_parameter_category_name(4, 10).display(),
    content="Space Weather Indices",
  )
  inspect(
    @lib.decode_parameter_category_name(10, 191).display(),
    content="Miscellaneous",
  )
  inspect(
    @lib.decode_parameter_category_name(20, 5).display(),
    content="Environmental Hazard Indices",
  )
  inspect(
    @lib.decode_parameter_category_name(191, 0).display(),
    content="Stochastic Parameterizations",
  )
  inspect(
    @lib.decode_parameter_category_name(191, 2).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_category_name(999, 1).display(),
    content="parameter_category=disc=999,cat=1",
  )
  inspect(@lib.decode_parameter_number_name(0, 2, 2).display(), content="UGRD")
  inspect(
    @lib.decode_parameter_number_name(0, 2, 200).display(),
    content="LAVV",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 215).display(),
    content="OMGALF",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 77).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, -1).display(),
    content="parameter_number=disc=0,cat=2,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_number_name(0, 3, 5).display(), content="HGT")
  inspect(
    @lib.decode_parameter_number_name(0, 3, 16).display(),
    content="U-GWD",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 199).display(),
    content="TSLSA",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 180).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, -1).display(),
    content="parameter_number=disc=0,cat=3,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 54).display(),
    content="DNSWRFLX",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 180).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 199).display(),
    content="CFNSF",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, -1).display(),
    content="parameter_number=disc=0,cat=4,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 6).display(),
    content="NLWRCS",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 194).display(),
    content="LWHR",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, -1).display(),
    content="parameter_number=disc=0,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 6, 1).display(), content="TCDC")
  inspect(
    @lib.decode_parameter_number_name(0, 6, 23).display(),
    content="CDCIMR",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 44).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 199).display(),
    content="FICE",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, -1).display(),
    content="parameter_number=disc=0,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 7, 6).display(), content="CAPE")
  inspect(
    @lib.decode_parameter_number_name(0, 7, 14).display(),
    content="Reserved",
  )
  inspect(@lib.decode_parameter_number_name(0, 7, 198).display(), content="LAI")
  inspect(
    @lib.decode_parameter_number_name(0, 7, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 7, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 7, -1).display(),
    content="parameter_number=disc=0,cat=7,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 0, 193).display(),
    content="TTRAD",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 0, -1).display(),
    content="parameter_number=disc=0,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 1, 2).display(), content="MIXR")
  inspect(
    @lib.decode_parameter_number_name(0, 1, 62).display(),
    content="SEVAP",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, 180).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, 243).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, -1).display(),
    content="parameter_number=disc=0,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 2, 2).display(), content="UGRD")
  inspect(@lib.decode_parameter_name(0, 0, 1).display(), content="VTMP")
  inspect(@lib.decode_parameter_name(0, 0, 17).display(), content="SKINT")
  inspect(@lib.decode_parameter_name(0, 0, 193).display(), content="TTRAD")
  inspect(@lib.decode_parameter_name(0, 0, 70).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 0, -1).display(),
    content="disc=0,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 1, 2).display(), content="MIXR")
  inspect(@lib.decode_parameter_name(0, 1, 52).display(), content="TPRATE")
  inspect(@lib.decode_parameter_name(0, 1, 143).display(), content="PERATE")
  inspect(@lib.decode_parameter_name(0, 1, 197).display(), content="MDIV")
  inspect(
    @lib.decode_parameter_name(0, 1, 243).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 1, 180).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 1, -1).display(),
    content="disc=0,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 2, 215).display(), content="OMGALF")
  inspect(
    @lib.decode_parameter_name(0, 2, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 2, 180).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 2, -1).display(),
    content="disc=0,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 3, 16).display(), content="U-GWD")
  inspect(@lib.decode_parameter_name(0, 3, 199).display(), content="TSLSA")
  inspect(@lib.decode_parameter_name(0, 3, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 3, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 3, -1).display(),
    content="disc=0,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 4, 54).display(), content="DNSWRFLX")
  inspect(@lib.decode_parameter_name(0, 4, 199).display(), content="CFNSF")
  inspect(@lib.decode_parameter_name(0, 4, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 4, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 4, -1).display(),
    content="disc=0,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 5, 6).display(), content="NLWRCS")
  inspect(@lib.decode_parameter_name(0, 5, 194).display(), content="LWHR")
  inspect(@lib.decode_parameter_name(0, 5, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 5, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 5, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 5, -1).display(),
    content="disc=0,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 6, 1).display(), content="TCDC")
  inspect(@lib.decode_parameter_name(0, 6, 23).display(), content="CDCIMR")
  inspect(@lib.decode_parameter_name(0, 6, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 6, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 6, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 6, -1).display(),
    content="disc=0,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 7, 6).display(), content="CAPE")
  inspect(@lib.decode_parameter_name(0, 7, 14).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 7, 198).display(), content="LAI")
  inspect(
    @lib.decode_parameter_name(0, 7, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 7, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 7, -1).display(),
    content="disc=0,cat=7,param=-1",
  )
  inspect(
    @lib.decode_parameter_name(0, 99, 99).display(),
    content="disc=0,cat=99,param=99",
  )
  inspect(
    @lib.decode_level_name(100, 0, 500, 255, 0, 0).display(),
    content="5 mb",
  )
  inspect(
    @lib.decode_level_name(250, 0, 0, 251, 0, 0).display(),
    content="type250-type251",
  )
}
