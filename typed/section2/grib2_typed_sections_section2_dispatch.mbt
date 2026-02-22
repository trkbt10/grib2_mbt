///|
pub fn decode_section2_bytes(
  section : Bytes,
) -> Result[Grib2Section2Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 2) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 6 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section2 too short: " + section.length().to_string(),
      ),
    )
  }
  let template_number = section[5].to_uint().reinterpret_as_int()
  let payload = section.sub(start=6).to_bytes()
  let template = if template_number == 1 {
    match typed_decode_template_21(payload) {
      Ok(template_21) => MdlTemplate21(template_21)
      Err(error) => return Err(error)
    }
  } else {
    LocalUseTemplateUnknown(template_number, payload)
  }
  Ok({ template, })
}

///|
pub fn encode_section2_bytes(section : Grib2Section2Decoded) -> Bytes {
  let out : Array[Byte] = []
  let (template_number, template_payload) = match section.template {
    MdlTemplate21(template_21) => (1, typed_encode_template_21(template_21))
    LocalUseTemplateUnknown(template_number, raw) => (template_number, raw)
  }
  out.push(template_number.to_byte())
  for b in template_payload {
    out.push(b)
  }
  typed_build_section(2, Bytes::from_array(out))
}
