///|
fn typed_decode_template_4150(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4150, Grib2SectionCodecError] {
  if template_payload.length() < 37 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.150 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  let (verification, required) = match
    typed_decode_verification_definition(template_payload, 32, "template 4.150") {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 26,
    ),
    verification_score: typed_read_u16_be_view(template_payload, 30),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4151(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4151, Grib2SectionCodecError] {
  if template_payload.length() < 42 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.151 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[37].to_uint().reinterpret_as_int()
  let time_required = 42 + n * 12
  if template_payload.length() < time_required + 2 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.151 verification-score payload too short: expected at least " +
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
      "template 4.151",
    ) {
    Ok(result) => result
    Err(error) => return Err(error)
  }
  Ok({
    base,
    derived_forecast: template_payload[25].to_uint().reinterpret_as_int(),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
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
    verification_score: typed_read_u16_be_view(template_payload, time_required),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4152(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4152, Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.152 too short: " + template_payload.length().to_string(),
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
    type_of_ensemble_forecast: template_payload[27]
    .to_uint()
    .reinterpret_as_int(),
    perturbation_number: typed_read_u32_be_view(template_payload, 28),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 32,
    ),
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
fn typed_decode_template_4153(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4153, Grib2SectionCodecError] {
  if template_payload.length() < 55 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.153 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[50].to_uint().reinterpret_as_int()
  let required = 55 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.153 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4152(template_payload.sub(end=43)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: typed_read_u16_be_view(template_payload, 43),
    end_month: template_payload[45].to_uint().reinterpret_as_int(),
    end_day: template_payload[46].to_uint().reinterpret_as_int(),
    end_hour: template_payload[47].to_uint().reinterpret_as_int(),
    end_minute: template_payload[48].to_uint().reinterpret_as_int(),
    end_second: template_payload[49].to_uint().reinterpret_as_int(),
    number_of_time_ranges: n,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 51),
    time_range_specs: typed_decode_time_range_specs(template_payload, 55, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4154(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4154, Grib2SectionCodecError] {
  if template_payload.length() < 41 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.154 too short: " + template_payload.length().to_string(),
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
    perturbation_number: typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: typed_read_u32_be_view(
      template_payload, 30,
    ),
    year_of_model_version_date: typed_read_u16_be_view(template_payload, 34),
    month_of_model_version_date: template_payload[36]
    .to_uint()
    .reinterpret_as_int(),
    day_of_model_version_date: template_payload[37]
    .to_uint()
    .reinterpret_as_int(),
    hour_of_model_version_date: template_payload[38]
    .to_uint()
    .reinterpret_as_int(),
    minute_of_model_version_date: template_payload[39]
    .to_uint()
    .reinterpret_as_int(),
    second_of_model_version_date: template_payload[40]
    .to_uint()
    .reinterpret_as_int(),
    reserved_tail: template_payload.sub(start=41).to_bytes(),
  })
}

///|
fn typed_decode_template_4155(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4155, Grib2SectionCodecError] {
  if template_payload.length() < 53 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.155 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let n = template_payload[48].to_uint().reinterpret_as_int()
  let required = 53 + n * 12
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.155 time-range payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_4154(template_payload.sub(end=41)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
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
fn typed_decode_template_4254(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4254, Grib2SectionCodecError] {
  if template_payload.length() < 6 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.254 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let number_of_characters = typed_read_u32_be_view(template_payload, 2)
  let required = 6 + number_of_characters
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.254 character payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok({
    parameter_category: template_payload[0].to_uint().reinterpret_as_int(),
    parameter_number: template_payload[1].to_uint().reinterpret_as_int(),
    number_of_characters,
    character_string: template_payload.sub(start=6, end=required).to_bytes(),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_41000(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41000, Grib2SectionCodecError] {
  if template_payload.length() < 13 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.1000 too short: " + template_payload.length().to_string(),
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
    reserved_tail: template_payload.sub(start=13).to_bytes(),
  })
}

///|
fn typed_decode_template_41001(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41001, Grib2SectionCodecError] {
  if template_payload.length() < 29 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.1001 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_41000(template_payload.sub(end=13)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 13),
    time_range_spec: typed_decode_time_range_spec(template_payload, 17),
    reserved_tail: template_payload.sub(start=29).to_bytes(),
  })
}

///|
fn typed_decode_template_41002(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41002, Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.1002 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_41000(template_payload.sub(end=13)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    horizontal_dimension_processed: template_payload[13]
    .to_uint()
    .reinterpret_as_int(),
    treatment_of_missing_data: template_payload[14]
    .to_uint()
    .reinterpret_as_int(),
    statistical_processing_type: template_payload[15]
    .to_uint()
    .reinterpret_as_int(),
    start_of_range: typed_read_u32_be_view(template_payload, 16),
    end_of_range: typed_read_u32_be_view(template_payload, 20),
    number_of_values: typed_read_u16_be_view(template_payload, 24),
    reserved_tail: template_payload.sub(start=26).to_bytes(),
  })
}

///|
fn typed_decode_template_41100(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41100, Grib2SectionCodecError] {
  if template_payload.length() < 25 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.1100 too short: " + template_payload.length().to_string(),
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
fn typed_decode_template_41101(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41101, Grib2SectionCodecError] {
  if template_payload.length() < 41 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 4.1101 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    number_of_missing_values: typed_read_u32_be_view(template_payload, 25),
    time_range_spec: typed_decode_time_range_spec(template_payload, 29),
    reserved_tail: template_payload.sub(start=41).to_bytes(),
  })
}
