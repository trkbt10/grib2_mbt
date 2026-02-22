///|
fn typed_decode_template_4130(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4130, Grib2SectionCodecError] {
  if template_payload.length() < 42 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.130 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 27, "template 4.130",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4131(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4131, Grib2SectionCodecError] {
  if template_payload.length() < 53 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.131 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 38, "template 4.131",
    ) {
    Ok(result) => result
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
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4132(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4132, Grib2SectionCodecError] {
  if template_payload.length() < 44 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.132 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 29, "template 4.132",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    total_number_of_quantiles: typed_read_u16_be_view(template_payload, 25),
    quantile_value: typed_read_u16_be_view(template_payload, 27),
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4133(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4133, Grib2SectionCodecError] {
  if template_payload.length() < 49 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.133 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_489(template_payload.sub(end=34)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, 34, "template 4.133",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4134(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4134, Grib2SectionCodecError] {
  if template_payload.length() < 53 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.134 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[36].to_uint().reinterpret_as_int()
  let time_required = 41 + n * 12
  if template_payload.length() < time_required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.134 time-range payload too short: expected at least " +
        time_required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_487(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, time_required, "template 4.134",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4135(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4135, Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.135 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[41].to_uint().reinterpret_as_int()
  let time_required = 46 + n * 12
  if template_payload.length() < time_required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.135 time-range payload too short: expected at least " +
        time_required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_490(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, required) = match
    typed_decode_reference_period_definition(
      template_payload, time_required, "template 4.135",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4136(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4136, Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.136 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4119(template_payload.sub(end=43)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (reference_period, reference_required) = match
    typed_decode_reference_period_definition(
      template_payload, 43, "template 4.136",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  let (spatial_vicinity, required) = match
    typed_decode_spatial_vicinity_definition(
      template_payload, reference_required, "template 4.136",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    reference_period,
    spatial_vicinity,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4137(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4137, Grib2SectionCodecError] {
  if template_payload.length() < 37 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.137 too short: " + template_payload.length().to_string(),
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
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 26,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 30),
    month_of_model_version_date: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[35]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[36]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=37).to_bytes(),
  })
}

///|
fn typed_decode_template_4138(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4138, Grib2SectionCodecError] {
  if template_payload.length() < 50 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.138 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[44].to_uint().reinterpret_as_int()
  let required = 49 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.138 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4137(template_payload.sub(end=37)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 37),
    end_month: template_payload[39].to_uint().reinterpret_as_int(),
    end_day: template_payload[40].to_uint().reinterpret_as_int(),
    end_hour: template_payload[41].to_uint().reinterpret_as_int(),
    end_minute: template_payload[42].to_uint().reinterpret_as_int(),
    end_second: template_payload[43].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 45),
    time_range_specs: typed_decode_time_range_specs(template_payload, 49, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4139(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4139, Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.139 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 36),
    month_of_model_version_date: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[41]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[42]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=43).to_bytes(),
  })
}

///|
fn typed_decode_template_4140(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4140, Grib2SectionCodecError] {
  if template_payload.length() < 52 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.140 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[36]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 37),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 41,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 45),
    month_of_model_version_date: template_payload[47]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[48]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[49]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[50]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[51]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=52).to_bytes(),
  })
}

///|
fn typed_decode_template_4141(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4141, Grib2SectionCodecError] {
  if template_payload.length() < 30 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.141 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 30 + nd * 4 + nf * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.141 wave table payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let scaled_wave_directions : Array[Int] = []
  for i in 0..<nd {
    let offset = 29 + i * 4
    scaled_wave_directions.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  let frequency_scale_factor_offset = 29 + nd * 4
  let scaled_wave_frequencies : Array[Int] = []
  for i in 0..<nf {
    let offset = frequency_scale_factor_offset + 1 + i * 4
    scaled_wave_frequencies.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: nd,
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: nf,
    type_of_generating_process: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 13,
    ),
    minutes_of_observational_data_cutoff: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[16].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 17),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 21),
    month_of_model_version_date: template_payload[23]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[24]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[26]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_wave_directions: template_payload[28]
    .to_uint()
    .reinterpret_as_int(),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: template_payload[frequency_scale_factor_offset]
    .to_uint()
    .reinterpret_as_int(),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4142(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4142, Grib2SectionCodecError] {
  if template_payload.length() < 39 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.142 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nd = typed_read_u16_be_view(template_payload, 4)
  let nf = typed_read_u16_be_view(template_payload, 8)
  let required = 39 + nd * 4 + nf * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.142 wave table payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let scaled_wave_directions : Array[Int] = []
  for i in 0..<nd {
    let offset = 38 + i * 4
    scaled_wave_directions.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  let frequency_scale_factor_offset = 38 + nd * 4
  let scaled_wave_frequencies : Array[Int] = []
  for i in 0..<nf {
    let offset = frequency_scale_factor_offset + 1 + i * 4
    scaled_wave_frequencies.push(
      typed_read_u32_be_view(template_payload, offset),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    wave_direction_number: typed_read_u16_be_view(template_payload, 2),
    number_of_wave_directions: nd,
    wave_frequency_number: typed_read_u16_be_view(template_payload, 6),
    number_of_wave_frequencies: nf,
    type_of_generating_process: template_payload[10]
    .to_uint()
    .reinterpret_as_int(),
    background_process_identifier: template_payload[11]
    .to_uint()
    .reinterpret_as_int(),
    generating_process_identifier: template_payload[12]
    .to_uint()
    .reinterpret_as_int(),
    hours_of_observational_data_cutoff: typed_read_u16_be_view(
      template_payload, 13,
    ),
    minutes_of_observational_data_cutoff: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    time_range_unit: template_payload[16].to_uint().reinterpret_as_int(),
    forecast_time: typed_read_u32_be_view(template_payload, 17),
    type_of_ensemble_forecast: template_payload[21]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 22),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 26,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 30),
    month_of_model_version_date: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[33]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[34]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[35]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[36]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_wave_directions: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    scaled_wave_directions,
    scale_factor_of_wave_frequencies: template_payload[frequency_scale_factor_offset]
    .to_uint()
    .reinterpret_as_int(),
    scaled_wave_frequencies,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4143(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4143, Grib2SectionCodecError] {
  if template_payload.length() < 52 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.143 too short: " + template_payload.length().to_string(),
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
    random_field_number: typed_read_u16_be_view(template_payload, 13),
    total_number_of_random_fields: typed_read_u16_be_view(template_payload, 15),
    spatio_temporal_scale_number: typed_read_u16_be_view(template_payload, 17),
    total_number_of_spatio_temporal_scales: typed_read_u16_be_view(
      template_payload, 19,
    ),
    scaled_value_of_spatial_scale: typed_read_u32_be_view(template_payload, 21),
    scale_factor_of_spatial_scale: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_temporal_scale: typed_read_u32_be_view(template_payload, 26),
    scale_factor_of_temporal_scale: template_payload[30]
    .to_uint()
    .reinterpret_as_int(),
    type_of_first_fixed_surface: template_payload[31]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_first_fixed_surface: template_payload[32]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_first_fixed_surface: typed_read_u32_be_view(
      template_payload, 33,
    ),
    type_of_second_fixed_surface: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    scale_factor_of_second_fixed_surface: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    scaled_value_of_second_fixed_surface: typed_read_u32_be_view(
      template_payload, 39,
    ),
    type_of_ensemble_forecast: template_payload[43]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 44),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 48,
    ),
    reserved_tail: template_payload.sub(start=52).to_bytes(),
  })
}

///|
fn typed_decode_template_4144(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4144, Grib2SectionCodecError] {
  if template_payload.length() < 60 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.144 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[43].to_uint().reinterpret_as_int()
  let required = 48 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.144 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 36),
    end_month: template_payload[38].to_uint().reinterpret_as_int(),
    end_day: template_payload[39].to_uint().reinterpret_as_int(),
    end_hour: template_payload[40].to_uint().reinterpret_as_int(),
    end_minute: template_payload[41].to_uint().reinterpret_as_int(),
    end_second: template_payload[42].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 44),
    time_range_specs: typed_decode_time_range_specs(template_payload, 48, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4145(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4145, Grib2SectionCodecError] {
  if template_payload.length() < 69 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.145 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[52].to_uint().reinterpret_as_int()
  let required = 57 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.145 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4103(template_payload.sub(end=36)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[36]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 37),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 41,
    ),
    end_year: typed_read_u16_be_view(template_payload, 45),
    end_month: template_payload[47].to_uint().reinterpret_as_int(),
    end_day: template_payload[48].to_uint().reinterpret_as_int(),
    end_hour: template_payload[49].to_uint().reinterpret_as_int(),
    end_minute: template_payload[50].to_uint().reinterpret_as_int(),
    end_second: template_payload[51].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 53),
    time_range_specs: typed_decode_time_range_specs(template_payload, 57, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4146(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4146, Grib2SectionCodecError] {
  if template_payload.length() < 32 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.146 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(template_payload, 27, "template 4.146") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    verification_score: typed_read_u16_be_view(template_payload, 25),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4147(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4147, Grib2SectionCodecError] {
  if template_payload.length() < 37 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.147 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[32].to_uint().reinterpret_as_int()
  let time_required = 37 + n * 12
  if template_payload.length() < time_required + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.147 verification-score payload too short: expected at least " +
        (time_required + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_template_48(template_payload.sub(end=time_required)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(
      template_payload,
      time_required + 2,
      "template 4.147",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    verification_score: typed_read_u16_be_view(template_payload, time_required),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4148(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4148, Grib2SectionCodecError] {
  if template_payload.length() < 41 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.148 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(template_payload, 36, "template 4.148") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 30,
    ),
    verification_score: typed_read_u16_be_view(template_payload, 34),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4149(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4149, Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.149 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[41].to_uint().reinterpret_as_int()
  let time_required = 46 + n * 12
  if template_payload.length() < time_required + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.149 verification-score payload too short: expected at least " +
        (time_required + 2).to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(
      template_payload,
      time_required + 2,
      "template 4.149",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: template_payload[25]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 30,
    ),
    end_year: typed_read_u16_be_view(template_payload, 34),
    end_month: template_payload[36].to_uint().reinterpret_as_int(),
    end_day: template_payload[37].to_uint().reinterpret_as_int(),
    end_hour: template_payload[38].to_uint().reinterpret_as_int(),
    end_minute: template_payload[39].to_uint().reinterpret_as_int(),
    end_second: template_payload[40].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 42),
    time_range_specs: typed_decode_time_range_specs(template_payload, 46, n),
    verification_score: typed_read_u16_be_view(template_payload, time_required),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}
