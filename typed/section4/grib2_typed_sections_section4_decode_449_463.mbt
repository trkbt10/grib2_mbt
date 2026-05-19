///|
fn typed_decode_template_449(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate449, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 52, "template 4.49") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    aerosol_type: @section1.typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: @section1.typed_read_u8_view(template_payload, 4),
    scale_factor_of_first_size: @section1.typed_read_u8_view(template_payload, 5),
    scaled_value_of_first_size: @section1.typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: @section1.typed_read_u8_view(template_payload, 10),
    scaled_value_of_second_size: @section1.typed_read_u32_be_view(template_payload, 11),
    type_of_interval_for_first_and_second_wavelength: @section1.typed_read_u8_view(template_payload, 15),
    scale_factor_of_first_wavelength: @section1.typed_read_u8_view(template_payload, 16),
    scaled_value_of_first_wavelength: @section1.typed_read_u32_be_view(
      template_payload, 17,
    ),
    scale_factor_of_second_wavelength: @section1.typed_read_u8_view(template_payload, 21),
    scaled_value_of_second_wavelength: @section1.typed_read_u32_be_view(
      template_payload, 22,
    ),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 26),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 27),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 28),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 29,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 31),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 32),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 33),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 37),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 38),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 43),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 44),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 45,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 49),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 50),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 51),
  })
}

///|
fn typed_decode_template_450(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate450, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 38, "template 4.50") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    aerosol_type: @section1.typed_read_u16_be_view(template_payload, 2),
    type_of_interval_for_first_and_second_size: @section1.typed_read_u8_view(template_payload, 4),
    scale_factor_of_first_size: @section1.typed_read_u8_view(template_payload, 5),
    scaled_value_of_first_size: @section1.typed_read_u32_be_view(template_payload, 6),
    scale_factor_of_second_size: @section1.typed_read_u8_view(template_payload, 10),
    scaled_value_of_second_size: @section1.typed_read_u32_be_view(template_payload, 11),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 15),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 16),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 17),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 18,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 20),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 21),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 22),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 26),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 27),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 28,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 32),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 33),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 34,
    ),
  })
}

///|
fn typed_decode_template_451(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate451, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 26, "template 4.51") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = @section1.typed_read_u8_view(template_payload, 25)
  let required = 26 + nc * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.51 category payload") { Ok(_) => (); Err(e) => return Err(e) }

  let categories : Array[Grib2CategoryForecastSpec] = []
  for i in 0..<nc {
    let offset = 26 + i * 12
    categories.push({
      code_figure: @section1.typed_read_u8_view(template_payload, offset),
      type_of_interval_for_first_and_second_limit: @section1.typed_read_u8_view(template_payload, offset + 1),
      scale_factor_of_first_limit: @section1.typed_read_u8_view(template_payload, offset + 2),
      scaled_value_of_first_limit: @section1.typed_read_u32_be_view(
        template_payload,
        offset + 3,
      ),
      scale_factor_of_second_limit: @section1.typed_read_u8_view(template_payload, offset + 7),
      scaled_value_of_second_limit: @section1.typed_read_u32_be_view(
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
) -> Result[Grib2ProductTemplate453, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 29, "template 4.53") { Ok(_) => (); Err(e) => return Err(e) }

  let np = @section1.typed_read_u8_view(template_payload, 3)
  let required = 29 + np * 2
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.53 partition payload") { Ok(_) => (); Err(e) => return Err(e) }

  let partition_set : Array[Int] = []
  for i in 0..<np {
    partition_set.push(@section1.typed_read_u16_be_view(template_payload, 4 + i * 2))
  }
  let offset = 6 + np * 2
  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    partition_table_number: @section1.typed_read_u8_view(template_payload, 2),
    number_of_partitions: np,
    partition_set,
    partition_number: @section1.typed_read_u16_be_view(template_payload, 4 + np * 2),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, offset),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 1),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 2),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, offset + 5),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 11),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 12),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 17),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 18),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_454(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate454, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 32, "template 4.54") { Ok(_) => (); Err(e) => return Err(e) }

  let np = @section1.typed_read_u8_view(template_payload, 3)
  let required = 32 + np * 2
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.54 partition payload") { Ok(_) => (); Err(e) => return Err(e) }

  let partition_set : Array[Int] = []
  for i in 0..<np {
    partition_set.push(@section1.typed_read_u16_be_view(template_payload, 4 + i * 2))
  }
  let offset = 6 + np * 2
  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    partition_table_number: @section1.typed_read_u8_view(template_payload, 2),
    number_of_partitions: np,
    partition_set,
    partition_number: @section1.typed_read_u16_be_view(template_payload, 4 + np * 2),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, offset),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 1),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 2),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, offset + 5),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 11),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 12),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 17),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 18),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, offset + 23),
    perturbation_number: @section1.typed_read_u8_view(template_payload, offset + 24),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, offset + 25),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_455(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate455, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 31, "template 4.55") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    tile_classification: @section1.typed_read_u8_view(template_payload, 2),
    total_number_of_tile_attribute_pairs: @section1.typed_read_u8_view(template_payload, 3),
    number_of_used_spatial_tiles: @section1.typed_read_u8_view(template_payload, 4),
    tile_index: @section1.typed_read_u8_view(template_payload, 5),
    number_of_used_tile_attributes: @section1.typed_read_u8_view(template_payload, 6),
    tile_attribute: @section1.typed_read_u8_view(template_payload, 7),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 8),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 10),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 13),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 14),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 26),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 27,
    ),
  })
}

///|
fn typed_decode_template_456(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate456, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 33, "template 4.56") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    tile_classification: @section1.typed_read_u8_view(template_payload, 2),
    total_number_of_tile_attribute_pairs: @section1.typed_read_u8_view(template_payload, 3),
    number_of_used_spatial_tiles: @section1.typed_read_u8_view(template_payload, 4),
    tile_index: @section1.typed_read_u8_view(template_payload, 5),
    number_of_used_tile_attributes: @section1.typed_read_u8_view(template_payload, 6),
    tile_attribute: @section1.typed_read_u8_view(template_payload, 7),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 8),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 10),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 13),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 14),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 26),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 27,
    ),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 31),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 32),
  })
}

///|
fn typed_decode_template_457(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate457, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 34, "template 4.57") { Ok(_) => (); Err(e) => return Err(e) }

  let np = @section1.typed_read_u8_view(template_payload, 10)
  let required = 34 + np * 5
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.57 function parameter payload") { Ok(_) => (); Err(e) => return Err(e) }

  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: @section1.typed_read_u8_view(template_payload, offset),
      scaled_value_of_fixed_distribution_function_parameter: @section1.typed_read_u32_be_view(
        template_payload,
        offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: @section1.typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: @section1.typed_read_u16_be_view(template_payload, 4),
    mode_number: @section1.typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: @section1.typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, offset),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 1),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 2),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, offset + 5),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 11),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 12),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 17),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 18),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_458(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate458, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 37, "template 4.58") { Ok(_) => (); Err(e) => return Err(e) }

  let np = @section1.typed_read_u8_view(template_payload, 10)
  let required = 37 + np * 5
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.58 function parameter payload") { Ok(_) => (); Err(e) => return Err(e) }

  let function_parameters : Array[Grib2DistributionFunctionParameterSpec] = []
  for i in 0..<np {
    let offset = 11 + i * 5
    function_parameters.push({
      scale_factor_of_fixed_distribution_function_parameter: @section1.typed_read_u8_view(template_payload, offset),
      scaled_value_of_fixed_distribution_function_parameter: @section1.typed_read_u32_be_view(
        template_payload,
        offset + 1,
      ),
    })
  }
  let offset = 11 + np * 5
  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: @section1.typed_read_u16_be_view(
      template_payload, 2,
    ),
    number_of_mode_of_distribution: @section1.typed_read_u16_be_view(template_payload, 4),
    mode_number: @section1.typed_read_u16_be_view(template_payload, 6),
    type_of_distribution_function: @section1.typed_read_u16_be_view(template_payload, 8),
    number_of_following_function_parameters: np,
    function_parameters,
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, offset),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 1),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, offset + 2),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload,
      offset + 3,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, offset + 5),
    time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, offset + 7),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 11),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 12),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 13,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 17),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, offset + 18),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload,
      offset + 19,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, offset + 23),
    perturbation_number: @section1.typed_read_u8_view(template_payload, offset + 24),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, offset + 25),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_459(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate459, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 34, "template 4.59") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    tile_classification: @section1.typed_read_u8_view(template_payload, 2),
    total_number_of_tile_attribute_pairs: @section1.typed_read_u8_view(template_payload, 3),
    number_of_used_spatial_tiles: @section1.typed_read_u8_view(template_payload, 4),
    tile_index: @section1.typed_read_u8_view(template_payload, 5),
    number_of_used_tile_attributes: @section1.typed_read_u8_view(template_payload, 6),
    tile_attribute: @section1.typed_read_u8_view(template_payload, 7),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 8),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 10),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 13),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 14),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 26),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 27,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 31),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 32),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 33),
  })
}

///|
fn typed_decode_template_460(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate460, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 35, "template 4.60") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 2),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 3),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 4),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 7),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 8),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 9),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 13),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 14),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 15,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 25),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 26),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 27),
    year_of_model_version_date: @section1.typed_read_u16_be_view(template_payload, 28),
    month_of_model_version_date: @section1.typed_read_u8_view(template_payload, 30),
    day_of_model_version_date: @section1.typed_read_u8_view(template_payload, 31),
    hour_of_model_version_date: @section1.typed_read_u8_view(template_payload, 32),
    minute_of_model_version_date: @section1.typed_read_u8_view(template_payload, 33),
    second_of_model_version_date: @section1.typed_read_u8_view(template_payload, 34),
  })
}

///|
fn typed_decode_template_461(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate461, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 47, "template 4.61") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 42)
  let required = 47 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.61 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 2),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 3),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 4),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 5,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 7),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 8),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 9),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 13),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 14),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 15,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 25),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 26),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 27),
    year_of_model_version_date: @section1.typed_read_u16_be_view(template_payload, 28),
    month_of_model_version_date: @section1.typed_read_u8_view(template_payload, 30),
    day_of_model_version_date: @section1.typed_read_u8_view(template_payload, 31),
    hour_of_model_version_date: @section1.typed_read_u8_view(template_payload, 32),
    minute_of_model_version_date: @section1.typed_read_u8_view(template_payload, 33),
    second_of_model_version_date: @section1.typed_read_u8_view(template_payload, 34),
    end_year: @section1.typed_read_u16_be_view(template_payload, 35),
    end_month: @section1.typed_read_u8_view(template_payload, 37),
    end_day: @section1.typed_read_u8_view(template_payload, 38),
    end_hour: @section1.typed_read_u8_view(template_payload, 39),
    end_minute: @section1.typed_read_u8_view(template_payload, 40),
    end_second: @section1.typed_read_u8_view(template_payload, 41),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 43),
    time_range_specs: typed_decode_time_range_specs(template_payload, 47, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_462(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate462, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 43, "template 4.62") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 38)
  let required = 43 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.62 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    tile_classification: @section1.typed_read_u8_view(template_payload, 2),
    total_number_of_tile_attribute_pairs: @section1.typed_read_u8_view(template_payload, 3),
    number_of_used_spatial_tiles: @section1.typed_read_u8_view(template_payload, 4),
    tile_index: @section1.typed_read_u8_view(template_payload, 5),
    number_of_used_tile_attributes: @section1.typed_read_u8_view(template_payload, 6),
    tile_attribute: @section1.typed_read_u8_view(template_payload, 7),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 8),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 10),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 13),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 14),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 26),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 27,
    ),
    end_year: @section1.typed_read_u16_be_view(template_payload, 31),
    end_month: @section1.typed_read_u8_view(template_payload, 33),
    end_day: @section1.typed_read_u8_view(template_payload, 34),
    end_hour: @section1.typed_read_u8_view(template_payload, 35),
    end_minute: @section1.typed_read_u8_view(template_payload, 36),
    end_second: @section1.typed_read_u8_view(template_payload, 37),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 39),
    time_range_specs: typed_decode_time_range_specs(template_payload, 43, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_463(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate463, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 46, "template 4.63") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 41)
  let required = 46 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.63 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    tile_classification: @section1.typed_read_u8_view(template_payload, 2),
    total_number_of_tile_attribute_pairs: @section1.typed_read_u8_view(template_payload, 3),
    number_of_used_spatial_tiles: @section1.typed_read_u8_view(template_payload, 4),
    tile_index: @section1.typed_read_u8_view(template_payload, 5),
    number_of_used_tile_attributes: @section1.typed_read_u8_view(template_payload, 6),
    tile_attribute: @section1.typed_read_u8_view(template_payload, 7),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 8),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 9),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 10),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 11,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 13),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 14),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 15),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 19),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 20),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 21,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 25),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 26),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 27,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 31),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 32),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 33),
    end_year: @section1.typed_read_u16_be_view(template_payload, 34),
    end_month: @section1.typed_read_u8_view(template_payload, 36),
    end_day: @section1.typed_read_u8_view(template_payload, 37),
    end_hour: @section1.typed_read_u8_view(template_payload, 38),
    end_minute: @section1.typed_read_u8_view(template_payload, 39),
    end_second: @section1.typed_read_u8_view(template_payload, 40),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 42),
    time_range_specs: typed_decode_time_range_specs(template_payload, 46, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_reference_period_definition(
  template_payload : BytesView,
  start_offset : Int,
  label : String,
) -> Result[(Grib2ReferencePeriodDefinition, Int), @section1.Grib2SectionCodecError] {
  if template_payload.length() < start_offset + 3 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " reference-period header too short: expected at least " +
        (start_offset + 3).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let na = @section1.typed_read_u8_view(template_payload, start_offset + 2)
  let additional_offset = start_offset + 3
  let post_additional_offset = additional_offset + na * 5
  if template_payload.length() < post_additional_offset + 12 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " reference-period body too short: expected at least " +
        (post_additional_offset + 12).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let additional_parameters : Array[Grib2ReferencePeriodAdditionalParameter] = []
  for i in 0..<na {
    let offset = additional_offset + i * 5
    additional_parameters.push({
      scale_factor: @section1.typed_read_u8_view(template_payload, offset),
      scaled_value: @section1.typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  let nr = @section1.typed_read_u8_view(template_payload, post_additional_offset + 11)
  let range_specs_offset = post_additional_offset + 12
  let required = range_specs_offset + nr * 6
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " reference-period range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let reference_period_time_range_specs : Array[
    Grib2ReferencePeriodTimeRangeSpec,
  ] = []
  for i in 0..<nr {
    let offset = range_specs_offset + i * 6
    reference_period_time_range_specs.push({
      statistical_processing_type: @section1.typed_read_u8_view(template_payload, offset),
      time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 1),
      time_range_length: @section1.typed_read_u32_be_view(template_payload, offset + 2),
    })
  }
  Ok(
    (
      {
        type_of_reference_dataset: @section1.typed_read_u8_view(template_payload, start_offset),
        type_of_relation_to_reference_dataset: @section1.typed_read_u8_view(template_payload, start_offset + 1),
        number_of_additional_parameters: na,
        additional_parameters,
        start_year: @section1.typed_read_u16_be_view(
          template_payload, post_additional_offset,
        ),
        start_month: @section1.typed_read_u8_view(template_payload, post_additional_offset + 2),
        start_day: @section1.typed_read_u8_view(template_payload, post_additional_offset + 3),
        start_hour: @section1.typed_read_u8_view(template_payload, post_additional_offset + 4),
        start_minute: @section1.typed_read_u8_view(template_payload, post_additional_offset + 5),
        start_second: @section1.typed_read_u8_view(template_payload, post_additional_offset + 6),
        sample_size: @section1.typed_read_u32_be_view(
          template_payload,
          post_additional_offset + 7,
        ),
        number_of_reference_period_time_ranges: nr,
        reference_period_time_range_specs,
      },
      required,
    ),
  )
}

///|
fn typed_decode_verification_definition(
  template_payload : BytesView,
  start_offset : Int,
  label : String,
) -> Result[(Grib2VerificationDefinition, Int), @section1.Grib2SectionCodecError] {
  if template_payload.length() < start_offset + 5 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " verification header too short: expected at least " +
        (start_offset + 5).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let na = @section1.typed_read_u8_view(template_payload, start_offset + 4)
  let additional_offset = start_offset + 5
  let post_additional_offset = additional_offset + na * 5
  if template_payload.length() < post_additional_offset + 8 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " verification period header too short: expected at least " +
        (post_additional_offset + 8).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let additional_arguments : Array[Grib2VerificationAdditionalArgument] = []
  for i in 0..<na {
    let offset = additional_offset + i * 5
    additional_arguments.push({
      scale_factor: @section1.typed_read_u8_view(template_payload, offset),
      scaled_value: @section1.typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  let nv = @section1.typed_read_u8_view(template_payload, post_additional_offset + 7)
  let verification_range_offset = post_additional_offset + 8
  let after_ranges = verification_range_offset + nv * 11
  if template_payload.length() < after_ranges + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " verification period range payload too short: expected at least " +
        (after_ranges + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let verification_period_time_range_specs : Array[
    Grib2VerificationPeriodTimeRangeSpec,
  ] = []
  for i in 0..<nv {
    let offset = verification_range_offset + i * 11
    verification_period_time_range_specs.push({
      statistical_processing_type: @section1.typed_read_u8_view(template_payload, offset),
      time_range_unit: @section1.typed_read_u8_view(template_payload, offset + 1),
      time_range_length: @section1.typed_read_u32_be_view(template_payload, offset + 2),
      time_increment_unit: @section1.typed_read_u8_view(template_payload, offset + 6),
      time_increment_length: @section1.typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok(
    (
      {
        type_of_reference_dataset: @section1.typed_read_u8_view(template_payload, start_offset),
        type_of_statistical_processing_over_vertical: @section1.typed_read_u8_view(template_payload, start_offset +
        1),
        type_of_threshold_operator: @section1.typed_read_u8_view(template_payload, start_offset + 2),
        type_of_additional_arguments: @section1.typed_read_u8_view(template_payload, start_offset + 3),
        number_of_additional_arguments: na,
        additional_arguments,
        start_year: @section1.typed_read_u16_be_view(
          template_payload, post_additional_offset,
        ),
        start_month: @section1.typed_read_u8_view(template_payload, post_additional_offset + 2),
        start_day: @section1.typed_read_u8_view(template_payload, post_additional_offset + 3),
        start_hour: @section1.typed_read_u8_view(template_payload, post_additional_offset + 4),
        start_minute: @section1.typed_read_u8_view(template_payload, post_additional_offset + 5),
        start_second: @section1.typed_read_u8_view(template_payload, post_additional_offset + 6),
        number_of_verification_period_time_ranges: nv,
        verification_period_time_range_specs,
        number_of_forecasts_in_verification: @section1.typed_read_u16_be_view(
          template_payload, after_ranges,
        ),
      },
      after_ranges + 2,
    ),
  )
}

///|
fn typed_decode_generalized_tile_definition(
  template_payload : BytesView,
  label : String,
) -> Result[(Grib2GeneralizedTileDefinition, Int), @section1.Grib2SectionCodecError] {
  if template_payload.length() < 8 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label + " too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let number_of_used_tile_attributes = @section1.typed_read_u8_view(template_payload, 7)
  let required = 26 + number_of_used_tile_attributes
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " tile payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let tile_attributes : Array[Int] = []
  for i in 0..<number_of_used_tile_attributes {
    tile_attributes.push(@section1.typed_read_u8_view(template_payload, 8 + i))
  }
  Ok(
    (
      {
        tile_classification: @section1.typed_read_u8_view(template_payload, 2),
        type_of_tile: @section1.typed_read_u16_be_view(template_payload, 3),
        number_of_used_spatial_tiles: @section1.typed_read_u8_view(template_payload, 5),
        number_of_used_tile_attribute_combinations_for_type_of_tile: @section1.typed_read_u8_view(template_payload, 6),
        number_of_used_tile_attributes,
        tile_attributes,
        total_number_of_tile_attribute_combinations: @section1.typed_read_u8_view(template_payload, 8 +
        number_of_used_tile_attributes),
        tile_index: @section1.typed_read_u8_view(template_payload, 9 + number_of_used_tile_attributes),
        uuid_of_data_group: template_payload
        .sub(
          start=10 + number_of_used_tile_attributes,
          end=26 + number_of_used_tile_attributes,
        )
        .to_bytes(),
      },
      required,
    ),
  )
}

///|
fn typed_decode_spatial_vicinity_definition(
  template_payload : BytesView,
  start_offset : Int,
  label : String,
) -> Result[(Grib2SpatialVicinityDefinition, Int), @section1.Grib2SectionCodecError] {
  if template_payload.length() < start_offset + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " spatial-vicinity header too short: expected at least " +
        (start_offset + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let nsv = @section1.typed_read_u8_view(template_payload, start_offset + 1)
  let values_start = start_offset + 2
  let values_end = values_start + nsv * 4
  let required = values_end + 16
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label +
        " spatial-vicinity payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let spatial_vicinity_values : Array[Int] = []
  for i in 0..<nsv {
    spatial_vicinity_values.push(
      @section1.typed_read_u32_be_view(template_payload, values_start + i * 4),
    )
  }
  let processing_offset = values_end
  Ok(
    (
      {
        spatial_vicinity_type: @section1.typed_read_u8_view(template_payload, start_offset),
        number_of_spatial_vicinity_values: nsv,
        spatial_vicinity_values,
        spatial_vicinity_processing: @section1.typed_read_u8_view(template_payload, processing_offset),
        spatial_vicinity_processing_argument1: @section1.typed_read_u16_be_view(
          template_payload,
          processing_offset + 1,
        ),
        spatial_vicinity_processing_argument2: @section1.typed_read_u16_be_view(
          template_payload,
          processing_offset + 3,
        ),
        spatial_vicinity_missing_data: @section1.typed_read_u8_view(template_payload, processing_offset + 5),
        temporal_vicinity_processing: @section1.typed_read_u8_view(template_payload, processing_offset + 6),
        temporal_vicinity_unit: @section1.typed_read_u8_view(template_payload, processing_offset + 7),
        temporal_vicinity_towards_past: @section1.typed_read_u32_be_view(
          template_payload,
          processing_offset + 8,
        ),
        temporal_vicinity_towards_future: @section1.typed_read_u32_be_view(
          template_payload,
          processing_offset + 12,
        ),
      },
      required,
    ),
  )
}
