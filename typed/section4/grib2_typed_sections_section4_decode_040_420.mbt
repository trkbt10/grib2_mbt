///|
fn typed_decode_template_40(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate40, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 25, "template 4.0") { Ok(_) => (); Err(e) => return Err(e) }

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
  })
}

///|
fn typed_decode_template_41(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 28, "template 4.1") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 25),
    perturbation_number: @section1.typed_read_u8_view(template_payload, 26),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 27),
  })
}

///|
fn typed_decode_template_42(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate42, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 27, "template 4.2") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 26),
  })
}

///|
fn typed_decode_template_43(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate43, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 59, "template 4.3") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = @section1.typed_read_u8_view(template_payload, 48)
  let required = 59 + nc
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.3 cluster list") { Ok(_) => (); Err(e) => return Err(e) }

  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      @section1.typed_read_u8_view(template_payload, 59 + i),
    )
  }
  Ok({
    base,
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 26),
    cluster_identifier: @section1.typed_read_u8_view(template_payload, 27),
    cluster_for_high_resolution_control: @section1.typed_read_u8_view(template_payload, 28),
    cluster_for_low_resolution_control: @section1.typed_read_u8_view(template_payload, 29),
    total_number_of_clusters: @section1.typed_read_u8_view(template_payload, 30),
    clustering_method: @section1.typed_read_u8_view(template_payload, 31),
    northern_latitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 32,
    ),
    southern_latitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 36,
    ),
    eastern_longitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 40,
    ),
    western_longitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 44,
    ),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: @section1.typed_read_u8_view(template_payload, 49),
    scaled_value_of_standard_deviation: @section1.typed_read_u32_be_view(
      template_payload, 50,
    ),
    scale_factor_of_distance_from_ensemble_mean: @section1.typed_read_u8_view(template_payload, 54),
    scaled_value_of_distance_from_ensemble_mean: @section1.typed_read_u32_be_view(
      template_payload, 55,
    ),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_44(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate44, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 55, "template 4.4") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = @section1.typed_read_u8_view(template_payload, 44)
  let required = 55 + nc
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.4 cluster list") { Ok(_) => (); Err(e) => return Err(e) }

  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      @section1.typed_read_u8_view(template_payload, 55 + i),
    )
  }
  Ok({
    base,
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 26),
    cluster_identifier: @section1.typed_read_u8_view(template_payload, 27),
    cluster_for_high_resolution_control: @section1.typed_read_u8_view(template_payload, 28),
    cluster_for_low_resolution_control: @section1.typed_read_u8_view(template_payload, 29),
    total_number_of_clusters: @section1.typed_read_u8_view(template_payload, 30),
    clustering_method: @section1.typed_read_u8_view(template_payload, 31),
    latitude_of_central_point: @section1.typed_read_u32_be_view(template_payload, 32),
    longitude_of_central_point: @section1.typed_read_u32_be_view(template_payload, 36),
    radius_of_cluster_domain: @section1.typed_read_u32_be_view(template_payload, 40),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: @section1.typed_read_u8_view(template_payload, 45),
    scaled_value_of_standard_deviation: @section1.typed_read_u32_be_view(
      template_payload, 46,
    ),
    scale_factor_of_distance_from_ensemble_mean: @section1.typed_read_u8_view(template_payload, 50),
    scaled_value_of_distance_from_ensemble_mean: @section1.typed_read_u32_be_view(
      template_payload, 51,
    ),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_45(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate45, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 38, "template 4.5") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    forecast_probability_number: @section1.typed_read_u8_view(template_payload, 25),
    total_number_of_forecast_probabilities: @section1.typed_read_u8_view(template_payload, 26),
    probability_type: @section1.typed_read_u8_view(template_payload, 27),
    scale_factor_of_lower_limit: @section1.typed_read_u8_view(template_payload, 28),
    scaled_value_of_lower_limit: @section1.typed_read_u32_be_view(template_payload, 29),
    scale_factor_of_upper_limit: @section1.typed_read_u8_view(template_payload, 33),
    scaled_value_of_upper_limit: @section1.typed_read_u32_be_view(template_payload, 34),
    reserved_tail: template_payload.sub(start=38).to_bytes(),
  })
}

///|
fn typed_decode_template_46(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate46, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 26, "template 4.6") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    percentile_value: @section1.typed_read_u8_view(template_payload, 25),
    reserved_tail: template_payload.sub(start=26).to_bytes(),
  })
}

///|
fn typed_decode_template_47(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate47, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 25, "template 4.7") { Ok(_) => (); Err(e) => return Err(e) }

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
      statistical_process: @section1.typed_read_u8_view(payload, offset),
      type_of_time_increment: @section1.typed_read_u8_view(payload, offset + 1),
      time_range_unit: @section1.typed_read_u8_view(payload, offset + 2),
      time_range_length: @section1.typed_read_u32_be_view(payload, offset + 3),
      time_increment_unit: @section1.typed_read_u8_view(payload, offset + 7),
      time_increment_length: @section1.typed_read_u32_be_view(payload, offset + 8),
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
    @section1.typed_push_u32_be(out, spec.time_range_length)
    out.push(spec.time_increment_unit.to_byte())
    @section1.typed_push_u32_be(out, spec.time_increment_length)
  }
  out
}

///|
fn typed_decode_template_48(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate48, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 37, "template 4.8") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 32)
  let required = 37 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.8 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 25),
    end_month: @section1.typed_read_u8_view(template_payload, 27),
    end_day: @section1.typed_read_u8_view(template_payload, 28),
    end_hour: @section1.typed_read_u8_view(template_payload, 29),
    end_minute: @section1.typed_read_u8_view(template_payload, 30),
    end_second: @section1.typed_read_u8_view(template_payload, 31),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 33),
    time_range_specs: typed_decode_time_range_specs(template_payload, 37, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_49(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate49, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 50, "template 4.9") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_45(template_payload.sub(end=38)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 45)
  let required = 50 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.9 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 38),
    end_month: @section1.typed_read_u8_view(template_payload, 40),
    end_day: @section1.typed_read_u8_view(template_payload, 41),
    end_hour: @section1.typed_read_u8_view(template_payload, 42),
    end_minute: @section1.typed_read_u8_view(template_payload, 43),
    end_second: @section1.typed_read_u8_view(template_payload, 44),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 46),
    time_range_specs: typed_decode_time_range_specs(template_payload, 50, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_410(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate410, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 38, "template 4.10") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_46(template_payload.sub(end=26)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 33)
  let required = 38 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.10 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 26),
    end_month: @section1.typed_read_u8_view(template_payload, 28),
    end_day: @section1.typed_read_u8_view(template_payload, 29),
    end_hour: @section1.typed_read_u8_view(template_payload, 30),
    end_minute: @section1.typed_read_u8_view(template_payload, 31),
    end_second: @section1.typed_read_u8_view(template_payload, 32),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 34),
    time_range_specs: typed_decode_time_range_specs(template_payload, 38, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_411(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate411, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 40, "template 4.11") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_41(template_payload.sub(end=28)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 35)
  let required = 40 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.11 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 28),
    end_month: @section1.typed_read_u8_view(template_payload, 30),
    end_day: @section1.typed_read_u8_view(template_payload, 31),
    end_hour: @section1.typed_read_u8_view(template_payload, 32),
    end_minute: @section1.typed_read_u8_view(template_payload, 33),
    end_second: @section1.typed_read_u8_view(template_payload, 34),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 36),
    time_range_specs: typed_decode_time_range_specs(template_payload, 40, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_412(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate412, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 39, "template 4.12") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_42(template_payload.sub(end=27)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let n = @section1.typed_read_u8_view(template_payload, 34)
  let required = 39 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.12 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 27),
    end_month: @section1.typed_read_u8_view(template_payload, 29),
    end_day: @section1.typed_read_u8_view(template_payload, 30),
    end_hour: @section1.typed_read_u8_view(template_payload, 31),
    end_minute: @section1.typed_read_u8_view(template_payload, 32),
    end_second: @section1.typed_read_u8_view(template_payload, 33),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 35),
    time_range_specs: typed_decode_time_range_specs(template_payload, 39, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_413(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate413, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 71, "template 4.13") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = @section1.typed_read_u8_view(template_payload, 48)
  let n = @section1.typed_read_u8_view(template_payload, 66)
  let required = 71 + n * 12 + nc
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.13 payload") { Ok(_) => (); Err(e) => return Err(e) }

  let list_offset = 71 + n * 12
  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      @section1.typed_read_u8_view(template_payload, list_offset + i),
    )
  }
  Ok({
    base,
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 26),
    cluster_identifier: @section1.typed_read_u8_view(template_payload, 27),
    cluster_for_high_resolution_control: @section1.typed_read_u8_view(template_payload, 28),
    cluster_for_low_resolution_control: @section1.typed_read_u8_view(template_payload, 29),
    total_number_of_clusters: @section1.typed_read_u8_view(template_payload, 30),
    clustering_method: @section1.typed_read_u8_view(template_payload, 31),
    northern_latitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 32,
    ),
    southern_latitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 36,
    ),
    eastern_longitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 40,
    ),
    western_longitude_of_cluster_domain: @section1.typed_read_u32_be_view(
      template_payload, 44,
    ),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: @section1.typed_read_u8_view(template_payload, 49),
    scaled_value_of_standard_deviation: @section1.typed_read_u32_be_view(
      template_payload, 50,
    ),
    scale_factor_of_distance_from_ensemble_mean: @section1.typed_read_u8_view(template_payload, 54),
    scaled_value_of_distance_from_ensemble_mean: @section1.typed_read_u32_be_view(
      template_payload, 55,
    ),
    end_year: @section1.typed_read_u16_be_view(template_payload, 59),
    end_month: @section1.typed_read_u8_view(template_payload, 61),
    end_day: @section1.typed_read_u8_view(template_payload, 62),
    end_hour: @section1.typed_read_u8_view(template_payload, 63),
    end_minute: @section1.typed_read_u8_view(template_payload, 64),
    end_second: @section1.typed_read_u8_view(template_payload, 65),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 67),
    time_range_specs: typed_decode_time_range_specs(template_payload, 71, n),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_414(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate414, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 67, "template 4.14") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let nc = @section1.typed_read_u8_view(template_payload, 44)
  let n = @section1.typed_read_u8_view(template_payload, 62)
  let required = 67 + n * 12 + nc
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.14 payload") { Ok(_) => (); Err(e) => return Err(e) }

  let list_offset = 67 + n * 12
  let ensemble_forecast_numbers : Array[Int] = []
  for i in 0..<nc {
    ensemble_forecast_numbers.push(
      @section1.typed_read_u8_view(template_payload, list_offset + i),
    )
  }
  Ok({
    base,
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u8_view(template_payload, 26),
    cluster_identifier: @section1.typed_read_u8_view(template_payload, 27),
    cluster_for_high_resolution_control: @section1.typed_read_u8_view(template_payload, 28),
    cluster_for_low_resolution_control: @section1.typed_read_u8_view(template_payload, 29),
    total_number_of_clusters: @section1.typed_read_u8_view(template_payload, 30),
    clustering_method: @section1.typed_read_u8_view(template_payload, 31),
    latitude_of_central_point: @section1.typed_read_u32_be_view(template_payload, 32),
    longitude_of_central_point: @section1.typed_read_u32_be_view(template_payload, 36),
    radius_of_cluster_domain: @section1.typed_read_u32_be_view(template_payload, 40),
    number_of_forecasts_in_cluster: nc,
    scale_factor_of_standard_deviation: @section1.typed_read_u8_view(template_payload, 45),
    scaled_value_of_standard_deviation: @section1.typed_read_u32_be_view(
      template_payload, 46,
    ),
    scale_factor_of_distance_from_ensemble_mean: @section1.typed_read_u8_view(template_payload, 50),
    scaled_value_of_distance_from_ensemble_mean: @section1.typed_read_u32_be_view(
      template_payload, 51,
    ),
    end_year: @section1.typed_read_u16_be_view(template_payload, 55),
    end_month: @section1.typed_read_u8_view(template_payload, 57),
    end_day: @section1.typed_read_u8_view(template_payload, 58),
    end_hour: @section1.typed_read_u8_view(template_payload, 59),
    end_minute: @section1.typed_read_u8_view(template_payload, 60),
    end_second: @section1.typed_read_u8_view(template_payload, 61),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 63),
    time_range_specs: typed_decode_time_range_specs(template_payload, 67, n),
    ensemble_forecast_numbers,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_415(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate415, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 28, "template 4.15") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    statistical_process_within_spatial_area: @section1.typed_read_u8_view(template_payload, 25),
    type_of_spatial_processing: @section1.typed_read_u8_view(template_payload, 26),
    number_of_data_points_used: @section1.typed_read_u8_view(template_payload, 27),
  })
}

///|
fn typed_decode_template_420(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate420, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_exact_length(template_payload, 34, "template 4.20") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 2),
    number_of_radar_sites_used: @section1.typed_read_u8_view(template_payload, 3),
    indicator_of_unit_time_range: @section1.typed_read_u8_view(template_payload, 4),
    site_latitude: @section1.typed_read_u32_be_view(template_payload, 5),
    site_longitude: @section1.typed_read_u32_be_view(template_payload, 9),
    site_elevation: @section1.typed_read_u16_be_view(template_payload, 13),
    site_identifier_alphanumeric: @section1.typed_read_u32_be_view(template_payload, 15),
    site_identifier_numeric: @section1.typed_read_u16_be_view(template_payload, 19),
    operating_mode: @section1.typed_read_u8_view(template_payload, 21),
    reflectivity_calibration_constant: @section1.typed_read_u8_view(template_payload, 22),
    quality_control_indicator: @section1.typed_read_u8_view(template_payload, 23),
    clutter_filter_indicator: @section1.typed_read_u8_view(template_payload, 24),
    constant_antenna_elevation_angle: @section1.typed_read_u8_view(template_payload, 25),
    accumulation_interval: @section1.typed_read_u16_be_view(template_payload, 26),
    reference_reflectivity: @section1.typed_read_u8_view(template_payload, 28),
    range_bin_spacing: @section1.typed_read_u24_be_view(template_payload, 29),
    radial_angular_spacing: @section1.typed_read_u16_be_view(template_payload, 32),
  })
}
