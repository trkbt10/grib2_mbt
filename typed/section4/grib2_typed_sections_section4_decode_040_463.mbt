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
fn typed_decode_template_430(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate430, Grib2SectionCodecError] {
  if template_payload.length() < 5 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.30 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[4].to_uint().reinterpret_as_int()
  let required = 5 + nb * 10
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.31 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[4].to_uint().reinterpret_as_int()
  let required = 5 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.32 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let required = 14 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.33 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let required = 17 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.34 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[13].to_uint().reinterpret_as_int()
  let ensemble_offset = 14 + nb * 11
  let required_min = 29 + nb * 11
  if template_payload.length() < required_min {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.35 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nb = template_payload[5].to_uint().reinterpret_as_int()
  let required = 6 + nb * 11
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.46 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[45].to_uint().reinterpret_as_int()
  let required = 50 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.47 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[48].to_uint().reinterpret_as_int()
  let required = 53 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.53 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[3].to_uint().reinterpret_as_int()
  let required = 29 + np * 2
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.54 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[3].to_uint().reinterpret_as_int()
  let required = 32 + np * 2
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.57 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let required = 34 + np * 5
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.58 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let np = template_payload[10].to_uint().reinterpret_as_int()
  let required = 37 + np * 5
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.61 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[42].to_uint().reinterpret_as_int()
  let required = 47 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.62 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[38].to_uint().reinterpret_as_int()
  let required = 43 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.63 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[41].to_uint().reinterpret_as_int()
  let required = 46 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
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
fn typed_decode_reference_period_definition(
  template_payload : BytesView,
  start_offset : Int,
  label : String,
) -> Result[(Grib2ReferencePeriodDefinition, Int), Grib2SectionCodecError] {
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
  let na = template_payload[start_offset + 2].to_uint().reinterpret_as_int()
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
      scale_factor: template_payload[offset].to_uint().reinterpret_as_int(),
      scaled_value: typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  let nr = template_payload[post_additional_offset + 11]
    .to_uint()
    .reinterpret_as_int()
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
      statistical_processing_type: template_payload[offset]
      .to_uint()
      .reinterpret_as_int(),
      time_range_unit: template_payload[offset + 1]
      .to_uint()
      .reinterpret_as_int(),
      time_range_length: typed_read_u32_be_view(template_payload, offset + 2),
    })
  }
  Ok(
    (
      {
        type_of_reference_dataset: template_payload[start_offset]
        .to_uint()
        .reinterpret_as_int(),
        type_of_relation_to_reference_dataset: template_payload[start_offset + 1]
        .to_uint()
        .reinterpret_as_int(),
        number_of_additional_parameters: na,
        additional_parameters,
        start_year: typed_read_u16_be_view(
          template_payload, post_additional_offset,
        ),
        start_month: template_payload[post_additional_offset + 2]
        .to_uint()
        .reinterpret_as_int(),
        start_day: template_payload[post_additional_offset + 3]
        .to_uint()
        .reinterpret_as_int(),
        start_hour: template_payload[post_additional_offset + 4]
        .to_uint()
        .reinterpret_as_int(),
        start_minute: template_payload[post_additional_offset + 5]
        .to_uint()
        .reinterpret_as_int(),
        start_second: template_payload[post_additional_offset + 6]
        .to_uint()
        .reinterpret_as_int(),
        sample_size: typed_read_u32_be_view(
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
) -> Result[(Grib2VerificationDefinition, Int), Grib2SectionCodecError] {
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
  let na = template_payload[start_offset + 4].to_uint().reinterpret_as_int()
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
      scale_factor: template_payload[offset].to_uint().reinterpret_as_int(),
      scaled_value: typed_read_u32_be_view(template_payload, offset + 1),
    })
  }
  let nv = template_payload[post_additional_offset + 7]
    .to_uint()
    .reinterpret_as_int()
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
      statistical_processing_type: template_payload[offset]
      .to_uint()
      .reinterpret_as_int(),
      time_range_unit: template_payload[offset + 1]
      .to_uint()
      .reinterpret_as_int(),
      time_range_length: typed_read_u32_be_view(template_payload, offset + 2),
      time_increment_unit: template_payload[offset + 6]
      .to_uint()
      .reinterpret_as_int(),
      time_increment_length: typed_read_u32_be_view(
        template_payload,
        offset + 7,
      ),
    })
  }
  Ok(
    (
      {
        type_of_reference_dataset: template_payload[start_offset]
        .to_uint()
        .reinterpret_as_int(),
        type_of_statistical_processing_over_vertical: template_payload[start_offset +
        1]
        .to_uint()
        .reinterpret_as_int(),
        type_of_threshold_operator: template_payload[start_offset + 2]
        .to_uint()
        .reinterpret_as_int(),
        type_of_additional_arguments: template_payload[start_offset + 3]
        .to_uint()
        .reinterpret_as_int(),
        number_of_additional_arguments: na,
        additional_arguments,
        start_year: typed_read_u16_be_view(
          template_payload, post_additional_offset,
        ),
        start_month: template_payload[post_additional_offset + 2]
        .to_uint()
        .reinterpret_as_int(),
        start_day: template_payload[post_additional_offset + 3]
        .to_uint()
        .reinterpret_as_int(),
        start_hour: template_payload[post_additional_offset + 4]
        .to_uint()
        .reinterpret_as_int(),
        start_minute: template_payload[post_additional_offset + 5]
        .to_uint()
        .reinterpret_as_int(),
        start_second: template_payload[post_additional_offset + 6]
        .to_uint()
        .reinterpret_as_int(),
        number_of_verification_period_time_ranges: nv,
        verification_period_time_range_specs,
        number_of_forecasts_in_verification: typed_read_u16_be_view(
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
) -> Result[(Grib2GeneralizedTileDefinition, Int), Grib2SectionCodecError] {
  if template_payload.length() < 8 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        label + " too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let number_of_used_tile_attributes = template_payload[7]
    .to_uint()
    .reinterpret_as_int()
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
    tile_attributes.push(template_payload[8 + i].to_uint().reinterpret_as_int())
  }
  Ok(
    (
      {
        tile_classification: template_payload[2].to_uint().reinterpret_as_int(),
        type_of_tile: typed_read_u16_be_view(template_payload, 3),
        number_of_used_spatial_tiles: template_payload[5]
        .to_uint()
        .reinterpret_as_int(),
        number_of_used_tile_attribute_combinations_for_type_of_tile: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        number_of_used_tile_attributes,
        tile_attributes,
        total_number_of_tile_attribute_combinations: template_payload[8 +
        number_of_used_tile_attributes]
        .to_uint()
        .reinterpret_as_int(),
        tile_index: template_payload[9 + number_of_used_tile_attributes]
        .to_uint()
        .reinterpret_as_int(),
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
) -> Result[(Grib2SpatialVicinityDefinition, Int), Grib2SectionCodecError] {
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
  let nsv = template_payload[start_offset + 1].to_uint().reinterpret_as_int()
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
      typed_read_u32_be_view(template_payload, values_start + i * 4),
    )
  }
  let processing_offset = values_end
  Ok(
    (
      {
        spatial_vicinity_type: template_payload[start_offset]
        .to_uint()
        .reinterpret_as_int(),
        number_of_spatial_vicinity_values: nsv,
        spatial_vicinity_values,
        spatial_vicinity_processing: template_payload[processing_offset]
        .to_uint()
        .reinterpret_as_int(),
        spatial_vicinity_processing_argument1: typed_read_u16_be_view(
          template_payload,
          processing_offset + 1,
        ),
        spatial_vicinity_processing_argument2: typed_read_u16_be_view(
          template_payload,
          processing_offset + 3,
        ),
        spatial_vicinity_missing_data: template_payload[processing_offset + 5]
        .to_uint()
        .reinterpret_as_int(),
        temporal_vicinity_processing: template_payload[processing_offset + 6]
        .to_uint()
        .reinterpret_as_int(),
        temporal_vicinity_unit: template_payload[processing_offset + 7]
        .to_uint()
        .reinterpret_as_int(),
        temporal_vicinity_towards_past: typed_read_u32_be_view(
          template_payload,
          processing_offset + 8,
        ),
        temporal_vicinity_towards_future: typed_read_u32_be_view(
          template_payload,
          processing_offset + 12,
        ),
      },
      required,
    ),
  )
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
