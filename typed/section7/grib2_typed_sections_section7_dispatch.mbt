///|
pub fn decode_section7_bytes(
  section : Bytes,
  template_number : Int,
) -> Result[Grib2Section7Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 7) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let payload = section.sub(start=5).to_bytes()
  let template = if template_number == 0 {
    match typed_decode_template_70(payload) {
      Ok(template_70) => DataTemplate70(template_70)
      Err(error) => return Err(error)
    }
  } else if template_number == 1 {
    match typed_decode_template_71(payload) {
      Ok(template_71) => DataTemplate71(template_71)
      Err(error) => return Err(error)
    }
  } else if template_number == 2 {
    match typed_decode_template_72(payload) {
      Ok(template_72) => DataTemplate72(template_72)
      Err(error) => return Err(error)
    }
  } else if template_number == 3 {
    match typed_decode_template_73(payload) {
      Ok(template_73) => DataTemplate73(template_73)
      Err(error) => return Err(error)
    }
  } else if template_number == 4 {
    match typed_decode_template_74(payload) {
      Ok(template_74) => DataTemplate74(template_74)
      Err(error) => return Err(error)
    }
  } else if template_number == 40 {
    match typed_decode_template_740(payload) {
      Ok(template_740) => DataTemplate740(template_740)
      Err(error) => return Err(error)
    }
  } else if template_number == 41 {
    match typed_decode_template_741(payload) {
      Ok(template_741) => DataTemplate741(template_741)
      Err(error) => return Err(error)
    }
  } else if template_number == 42 {
    match typed_decode_template_742(payload) {
      Ok(template_742) => DataTemplate742(template_742)
      Err(error) => return Err(error)
    }
  } else if template_number == 50 {
    match typed_decode_template_750(payload) {
      Ok(template_750) => DataTemplate750(template_750)
      Err(error) => return Err(error)
    }
  } else if template_number == 51 {
    match typed_decode_template_751(payload) {
      Ok(template_751) => DataTemplate751(template_751)
      Err(error) => return Err(error)
    }
  } else if template_number == 53 {
    match typed_decode_template_753(payload) {
      Ok(template_753) => DataTemplate753(template_753)
      Err(error) => return Err(error)
    }
  } else {
    DataTemplateUnknown(template_number, payload)
  }
  Ok({ template, })
}

///|
pub fn encode_section7_bytes(section : Grib2Section7Decoded) -> Bytes {
  let payload = match section.template {
    DataTemplate70(template_70) => typed_encode_template_70(template_70)
    DataTemplate71(template_71) => typed_encode_template_71(template_71)
    DataTemplate72(template_72) => typed_encode_template_72(template_72)
    DataTemplate73(template_73) => typed_encode_template_73(template_73)
    DataTemplate74(template_74) => typed_encode_template_74(template_74)
    DataTemplate740(template_740) => typed_encode_template_740(template_740)
    DataTemplate741(template_741) => typed_encode_template_741(template_741)
    DataTemplate742(template_742) => typed_encode_template_742(template_742)
    DataTemplate750(template_750) => typed_encode_template_750(template_750)
    DataTemplate751(template_751) => typed_encode_template_751(template_751)
    DataTemplate753(template_753) => typed_encode_template_753(template_753)
    DataTemplateUnknown(_, raw) => raw
  }
  typed_build_section(7, payload)
}
