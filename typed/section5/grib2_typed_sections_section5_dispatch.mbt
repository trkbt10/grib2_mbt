///|
pub fn decode_section5_bytes(
  section : Bytes,
) -> Result[Grib2Section5Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 5) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 11 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section5 too short: " + section.length().to_string(),
      ),
    )
  }
  let template_number = typed_read_u16_be(section, 9)
  let template_payload = section.sub(start=11).to_bytes()
  let template = if template_number == 0 {
    match typed_decode_template_50(template_payload) {
      Ok(template_50) => DataRepresentationTemplate50(template_50)
      Err(error) => return Err(error)
    }
  } else if template_number == 1 {
    match typed_decode_template_51(template_payload) {
      Ok(template_51) => DataRepresentationTemplate51(template_51)
      Err(error) => return Err(error)
    }
  } else if template_number == 2 {
    match typed_decode_template_52(template_payload) {
      Ok(template_52) => DataRepresentationTemplate52(template_52)
      Err(error) => return Err(error)
    }
  } else if template_number == 3 {
    match typed_decode_template_53(template_payload) {
      Ok(template_53) => DataRepresentationTemplate53(template_53)
      Err(error) => return Err(error)
    }
  } else if template_number == 4 {
    match typed_decode_template_54(template_payload) {
      Ok(template_54) => DataRepresentationTemplate54(template_54)
      Err(error) => return Err(error)
    }
  } else if template_number == 40 {
    match typed_decode_template_540(template_payload) {
      Ok(template_540) => DataRepresentationTemplate540(template_540)
      Err(error) => return Err(error)
    }
  } else if template_number == 41 {
    match typed_decode_template_541(template_payload) {
      Ok(template_541) => DataRepresentationTemplate541(template_541)
      Err(error) => return Err(error)
    }
  } else if template_number == 42 {
    match typed_decode_template_542(template_payload) {
      Ok(template_542) => DataRepresentationTemplate542(template_542)
      Err(error) => return Err(error)
    }
  } else if template_number == 50 {
    match typed_decode_template_550(template_payload) {
      Ok(template_550) => DataRepresentationTemplate550(template_550)
      Err(error) => return Err(error)
    }
  } else if template_number == 51 {
    match typed_decode_template_551(template_payload) {
      Ok(template_551) => DataRepresentationTemplate551(template_551)
      Err(error) => return Err(error)
    }
  } else if template_number == 53 {
    match typed_decode_template_553(template_payload) {
      Ok(template_553) => DataRepresentationTemplate553(template_553)
      Err(error) => return Err(error)
    }
  } else if template_number == 61 {
    match typed_decode_template_561(template_payload) {
      Ok(template_561) => DataRepresentationTemplate561(template_561)
      Err(error) => return Err(error)
    }
  } else if template_number == 200 {
    match typed_decode_template_5200(template_payload) {
      Ok(template_5200) => DataRepresentationTemplate5200(template_5200)
      Err(error) => return Err(error)
    }
  } else {
    DataRepresentationTemplateUnknown(template_number, template_payload)
  }
  Ok({ number_of_data_points: typed_read_u32_be(section, 5), template })
}

///|
pub fn encode_section5_bytes(section : Grib2Section5Decoded) -> Bytes {
  let payload : Array[Byte] = []
  typed_push_u32_be(payload, section.number_of_data_points)
  let (template_number, template_raw) = match section.template {
    DataRepresentationTemplate50(template_50) =>
      (0, typed_encode_template_50(template_50))
    DataRepresentationTemplate51(template_51) =>
      (1, typed_encode_template_51(template_51))
    DataRepresentationTemplate52(template_52) =>
      (2, typed_encode_template_52(template_52))
    DataRepresentationTemplate53(template_53) =>
      (3, typed_encode_template_53(template_53))
    DataRepresentationTemplate54(template_54) =>
      (4, typed_encode_template_54(template_54))
    DataRepresentationTemplate540(template_540) =>
      (40, typed_encode_template_540(template_540))
    DataRepresentationTemplate541(template_541) =>
      (41, typed_encode_template_541(template_541))
    DataRepresentationTemplate542(template_542) =>
      (42, typed_encode_template_542(template_542))
    DataRepresentationTemplate550(template_550) =>
      (50, typed_encode_template_550(template_550))
    DataRepresentationTemplate551(template_551) =>
      (51, typed_encode_template_551(template_551))
    DataRepresentationTemplate553(template_553) =>
      (53, typed_encode_template_553(template_553))
    DataRepresentationTemplate561(template_561) =>
      (61, typed_encode_template_561(template_561))
    DataRepresentationTemplate5200(template_5200) =>
      (200, typed_encode_template_5200(template_5200))
    DataRepresentationTemplateUnknown(template_number, raw) =>
      (template_number, raw)
  }
  typed_push_u16_be(payload, template_number)
  for b in template_raw {
    payload.push(b)
  }
  typed_build_section(5, Bytes::from_array(payload))
}
