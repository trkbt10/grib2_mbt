///|
fn typed_decode_template_4150(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4150, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 37, "template 4.150") { Ok(_) => (); Err(e) => return Err(e) }

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
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u32_be_view(
      template_payload, 26,
    ),
    verification_score: @section1.typed_read_u16_be_view(template_payload, 30),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4151(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4151, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 42, "template 4.151") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 37)
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
    derived_forecast: @section1.typed_read_u8_view(template_payload, 25),
    number_of_forecasts_in_ensemble: @section1.typed_read_u32_be_view(
      template_payload, 26,
    ),
    end_year: @section1.typed_read_u16_be_view(template_payload, 30),
    end_month: @section1.typed_read_u8_view(template_payload, 32),
    end_day: @section1.typed_read_u8_view(template_payload, 33),
    end_hour: @section1.typed_read_u8_view(template_payload, 34),
    end_minute: @section1.typed_read_u8_view(template_payload, 35),
    end_second: @section1.typed_read_u8_view(template_payload, 36),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 38),
    time_range_specs: typed_decode_time_range_specs(template_payload, 42, n),
    verification_score: @section1.typed_read_u16_be_view(template_payload, time_required),
    verification,
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4152(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4152, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 43, "template 4.152") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    atmospheric_chemical_constituent_type: @section1.typed_read_u16_be_view(
      template_payload, 2,
    ),
    type_of_generating_process: @section1.typed_read_u8_view(template_payload, 4),
    background_process_identifier: @section1.typed_read_u8_view(template_payload, 5),
    generating_process_identifier: @section1.typed_read_u8_view(template_payload, 6),
    hours_of_observational_data_cutoff: @section1.typed_read_u16_be_view(
      template_payload, 7,
    ),
    minutes_of_observational_data_cutoff: @section1.typed_read_u8_view(template_payload, 9),
    time_range_unit: @section1.typed_read_u8_view(template_payload, 10),
    forecast_time: @section1.typed_read_u32_be_view(template_payload, 11),
    type_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 15),
    scale_factor_of_first_fixed_surface: @section1.typed_read_u8_view(template_payload, 16),
    scaled_value_of_first_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 17,
    ),
    type_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 21),
    scale_factor_of_second_fixed_surface: @section1.typed_read_u8_view(template_payload, 22),
    scaled_value_of_second_fixed_surface: @section1.typed_read_u32_be_view(
      template_payload, 23,
    ),
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 27),
    perturbation_number: @section1.typed_read_u32_be_view(template_payload, 28),
    number_of_forecasts_in_ensemble: @section1.typed_read_u32_be_view(
      template_payload, 32,
    ),
    year_of_model_version_date: @section1.typed_read_u16_be_view(template_payload, 36),
    month_of_model_version_date: @section1.typed_read_u8_view(template_payload, 38),
    day_of_model_version_date: @section1.typed_read_u8_view(template_payload, 39),
    hour_of_model_version_date: @section1.typed_read_u8_view(template_payload, 40),
    minute_of_model_version_date: @section1.typed_read_u8_view(template_payload, 41),
    second_of_model_version_date: @section1.typed_read_u8_view(template_payload, 42),
    reserved_tail: template_payload.sub(start=43).to_bytes(),
  })
}

///|
fn typed_decode_template_4153(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4153, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 55, "template 4.153") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 50)
  let required = 55 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.153 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4152(template_payload.sub(end=43)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 43),
    end_month: @section1.typed_read_u8_view(template_payload, 45),
    end_day: @section1.typed_read_u8_view(template_payload, 46),
    end_hour: @section1.typed_read_u8_view(template_payload, 47),
    end_minute: @section1.typed_read_u8_view(template_payload, 48),
    end_second: @section1.typed_read_u8_view(template_payload, 49),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 51),
    time_range_specs: typed_decode_time_range_specs(template_payload, 55, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4154(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4154, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 41, "template 4.154") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    type_of_ensemble_forecast: @section1.typed_read_u8_view(template_payload, 25),
    perturbation_number: @section1.typed_read_u32_be_view(template_payload, 26),
    number_of_forecasts_in_ensemble: @section1.typed_read_u32_be_view(
      template_payload, 30,
    ),
    year_of_model_version_date: @section1.typed_read_u16_be_view(template_payload, 34),
    month_of_model_version_date: @section1.typed_read_u8_view(template_payload, 36),
    day_of_model_version_date: @section1.typed_read_u8_view(template_payload, 37),
    hour_of_model_version_date: @section1.typed_read_u8_view(template_payload, 38),
    minute_of_model_version_date: @section1.typed_read_u8_view(template_payload, 39),
    second_of_model_version_date: @section1.typed_read_u8_view(template_payload, 40),
    reserved_tail: template_payload.sub(start=41).to_bytes(),
  })
}

///|
fn typed_decode_template_4155(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4155, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 53, "template 4.155") { Ok(_) => (); Err(e) => return Err(e) }

  let n = @section1.typed_read_u8_view(template_payload, 48)
  let required = 53 + n * 12
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.155 time-range payload") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_4154(template_payload.sub(end=41)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    end_year: @section1.typed_read_u16_be_view(template_payload, 41),
    end_month: @section1.typed_read_u8_view(template_payload, 43),
    end_day: @section1.typed_read_u8_view(template_payload, 44),
    end_hour: @section1.typed_read_u8_view(template_payload, 45),
    end_minute: @section1.typed_read_u8_view(template_payload, 46),
    end_second: @section1.typed_read_u8_view(template_payload, 47),
    number_of_time_ranges: n,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 49),
    time_range_specs: typed_decode_time_range_specs(template_payload, 53, n),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_4254(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate4254, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 6, "template 4.254") { Ok(_) => (); Err(e) => return Err(e) }

  let number_of_characters = @section1.typed_read_u32_be_view(template_payload, 2)
  let required = 6 + number_of_characters
  match @section1.typed_validate_template_min_length(template_payload, required, "template 4.254 character payload") { Ok(_) => (); Err(e) => return Err(e) }

  Ok({
    parameter_category: @section1.typed_read_u8_view(template_payload, 0),
    parameter_number: @section1.typed_read_u8_view(template_payload, 1),
    number_of_characters,
    character_string: template_payload.sub(start=6, end=required).to_bytes(),
    reserved_tail: template_payload.sub(start=required).to_bytes(),
  })
}

///|
fn typed_decode_template_41000(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41000, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 13, "template 4.1000") { Ok(_) => (); Err(e) => return Err(e) }

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
    reserved_tail: template_payload.sub(start=13).to_bytes(),
  })
}

///|
fn typed_decode_template_41001(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41001, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 29, "template 4.1001") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_41000(template_payload.sub(end=13)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 13),
    time_range_spec: typed_decode_time_range_spec(template_payload, 17),
    reserved_tail: template_payload.sub(start=29).to_bytes(),
  })
}

///|
fn typed_decode_template_41002(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41002, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 26, "template 4.1002") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_41000(template_payload.sub(end=13)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    horizontal_dimension_processed: @section1.typed_read_u8_view(template_payload, 13),
    treatment_of_missing_data: @section1.typed_read_u8_view(template_payload, 14),
    statistical_processing_type: @section1.typed_read_u8_view(template_payload, 15),
    start_of_range: @section1.typed_read_u32_be_view(template_payload, 16),
    end_of_range: @section1.typed_read_u32_be_view(template_payload, 20),
    number_of_values: @section1.typed_read_u16_be_view(template_payload, 24),
    reserved_tail: template_payload.sub(start=26).to_bytes(),
  })
}

///|
fn typed_decode_template_41100(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41100, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 25, "template 4.1100") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({ base, reserved_tail: template_payload.sub(start=25).to_bytes() })
}

///|
fn typed_decode_template_41101(
  template_payload : BytesView,
) -> Result[Grib2ProductTemplate41101, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_template_min_length(template_payload, 41, "template 4.1101") { Ok(_) => (); Err(e) => return Err(e) }

  let base = match typed_decode_template_40(template_payload.sub(end=25)) {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok({
    base,
    number_of_missing_values: @section1.typed_read_u32_be_view(template_payload, 25),
    time_range_spec: typed_decode_time_range_spec(template_payload, 29),
    reserved_tail: template_payload.sub(start=41).to_bytes(),
  })
}
