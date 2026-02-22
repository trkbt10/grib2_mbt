///|
fn typed_decode_template_40(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate40, Grib2SectionCodecError] {
  if template_payload.length() != 25 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
fn typed_decode_template_420(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate420, Grib2SectionCodecError] {
  if template_payload.length() != 34 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
