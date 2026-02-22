///|
test "section4 template4150 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4150({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 987654,
      verification_score: 124,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4150(template4150) => {
      inspect(template4150.derived_forecast, content="4")
      inspect(template4150.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4150.verification_score, content="124")
      inspect(template4150.verification.start_year, content="2020")
      inspect(
        template4150.verification.verification_period_time_range_specs.length(),
        content="2",
      )
      inspect(template4150.reserved_tail == b"\xf7", content="true")
    }
    _ => fail("template4.150 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4151 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4151({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 987654,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      verification_score: 125,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4151(template4151) => {
      inspect(template4151.derived_forecast, content="4")
      inspect(template4151.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4151.end_year, content="2026")
      inspect(template4151.number_of_time_ranges, content="2")
      inspect(template4151.time_range_specs.length(), content="2")
      inspect(template4151.verification_score, content="125")
      inspect(template4151.verification.start_year, content="2020")
      inspect(template4151.reserved_tail == b"\xf8", content="true")
    }
    _ => fail("template4.151 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4152 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4152(sample_template4152(b"\xf9")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4152(template4152) => {
      inspect(template4152.atmospheric_chemical_constituent_type, content="230")
      inspect(template4152.perturbation_number, content="123456")
      inspect(template4152.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4152.year_of_model_version_date, content="2026")
      inspect(template4152.second_of_model_version_date, content="56")
      inspect(template4152.reserved_tail == b"\xf9", content="true")
    }
    _ => fail("template4.152 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4153 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4153({
      base: sample_template4152(b""),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4153(template4153) => {
      inspect(
        template4153.base.atmospheric_chemical_constituent_type,
        content="230",
      )
      inspect(template4153.base.year_of_model_version_date, content="2026")
      inspect(template4153.end_year, content="2026")
      inspect(template4153.number_of_time_ranges, content="2")
      inspect(template4153.time_range_specs.length(), content="2")
      inspect(template4153.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template4.153 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4154 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4154(sample_template4154(b"\xfb")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4154(template4154) => {
      inspect(template4154.base.forecast_time, content="6")
      inspect(template4154.type_of_ensemble_forecast, content="2")
      inspect(template4154.perturbation_number, content="123456")
      inspect(template4154.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4154.year_of_model_version_date, content="2026")
      inspect(template4154.reserved_tail == b"\xfb", content="true")
    }
    _ => fail("template4.154 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4155 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4155({
      base: sample_template4154(b""),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4155(template4155) => {
      inspect(template4155.base.type_of_ensemble_forecast, content="2")
      inspect(template4155.base.year_of_model_version_date, content="2026")
      inspect(template4155.end_year, content="2026")
      inspect(template4155.number_of_time_ranges, content="2")
      inspect(template4155.time_range_specs.length(), content="2")
      inspect(template4155.reserved_tail == b"\xfc", content="true")
    }
    _ => fail("template4.155 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4254 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4254({
      parameter_category: 1,
      parameter_number: 2,
      number_of_characters: 5,
      character_string: b"HELLO",
      reserved_tail: b"\xfd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4254(template4254) => {
      inspect(template4254.parameter_category, content="1")
      inspect(template4254.parameter_number, content="2")
      inspect(template4254.number_of_characters, content="5")
      inspect(template4254.character_string == b"HELLO", content="true")
      inspect(template4254.reserved_tail == b"\xfd", content="true")
    }
    _ => fail("template4.254 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41000 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41000(sample_template41000(b"\xfe")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41000(template41000) => {
      inspect(template41000.parameter_number, content="1")
      inspect(template41000.forecast_time, content="6")
      inspect(template41000.reserved_tail == b"\xfe", content="true")
    }
    _ => fail("template4.1000 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41001 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41001({
      base: sample_template41000(b""),
      number_of_missing_values: 3,
      time_range_spec: sample_time_range_specs()[0],
      reserved_tail: b"\xff",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41001(template41001) => {
      inspect(template41001.base.forecast_time, content="6")
      inspect(template41001.number_of_missing_values, content="3")
      inspect(template41001.time_range_spec.statistical_process, content="1")
      inspect(template41001.time_range_spec.time_increment_length, content="3")
      inspect(template41001.reserved_tail == b"\xff", content="true")
    }
    _ => fail("template4.1001 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41002 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41002({
      base: sample_template41000(b""),
      horizontal_dimension_processed: 1,
      treatment_of_missing_data: 2,
      statistical_processing_type: 3,
      start_of_range: 10,
      end_of_range: 20,
      number_of_values: 11,
      reserved_tail: b"\xfa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41002(template41002) => {
      inspect(template41002.base.parameter_number, content="1")
      inspect(template41002.horizontal_dimension_processed, content="1")
      inspect(template41002.treatment_of_missing_data, content="2")
      inspect(template41002.statistical_processing_type, content="3")
      inspect(template41002.start_of_range, content="10")
      inspect(template41002.end_of_range, content="20")
      inspect(template41002.number_of_values, content="11")
      inspect(template41002.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template4.1002 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41100 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41100(sample_template41100(b"\xf0")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41100(template41100) => {
      inspect(template41100.base.forecast_time, content="6")
      inspect(template41100.base.type_of_first_fixed_surface, content="100")
      inspect(template41100.reserved_tail == b"\xf0", content="true")
    }
    _ => fail("template4.1100 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41101 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41101({
      base: sample_template40_base(),
      number_of_missing_values: 3,
      time_range_spec: sample_time_range_specs()[1],
      reserved_tail: b"\xf1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41101(template41101) => {
      inspect(template41101.base.forecast_time, content="6")
      inspect(template41101.number_of_missing_values, content="3")
      inspect(template41101.time_range_spec.statistical_process, content="3")
      inspect(template41101.time_range_spec.time_range_length, content="12")
      inspect(template41101.time_range_spec.time_increment_length, content="6")
      inspect(template41101.reserved_tail == b"\xf1", content="true")
    }
    _ => fail("template4.1101 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "unknown section4 templates keep raw payloads" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 1,
    template: ProductTemplateUnknown(52000, b"\x99\x88\x77"),
    coordinate_values_raw: b"\x3f\x80\x00\x00",
  }
  let encoded4 = encode_section4_bytes(section4)
  let decoded4 = match decode_section4_bytes(encoded4) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  let reencoded4 = encode_section4_bytes(decoded4)
  inspect(reencoded4 == encoded4, content="true")
}
