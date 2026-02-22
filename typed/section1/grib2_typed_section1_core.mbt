///|
pub fn typed_read_u16_be(bytes : Bytes, offset : Int) -> Int {
  bytes.unsafe_read_uint16_be(offset).to_uint().reinterpret_as_int()
}

///|
pub fn typed_read_u32_be(bytes : Bytes, offset : Int) -> Int {
  bytes.unsafe_read_uint32_be(offset).reinterpret_as_int()
}

///|
pub fn typed_read_u16_be_view(bytes : BytesView, offset : Int) -> Int {
  bytes.unsafe_read_uint16_be(offset).to_uint().reinterpret_as_int()
}

///|
pub fn typed_read_u32_be_view(bytes : BytesView, offset : Int) -> Int {
  bytes.unsafe_read_uint32_be(offset).reinterpret_as_int()
}

///|
pub fn typed_read_u24_be_view(bytes : BytesView, offset : Int) -> Int {
  let b0 = bytes[offset].to_uint().reinterpret_as_int()
  let b1 = bytes[offset + 1].to_uint().reinterpret_as_int()
  let b2 = bytes[offset + 2].to_uint().reinterpret_as_int()
  (b0 << 16) | (b1 << 8) | b2
}

///|
pub fn typed_read_u64_be_view(bytes : BytesView, offset : Int) -> Grib2U64Be {
  {
    high: typed_read_u32_be_view(bytes, offset),
    low: typed_read_u32_be_view(bytes, offset + 4),
  }
}

///|
pub fn typed_push_u16_be(out : Array[Byte], value : Int) -> Unit {
  out.push(((value >> 8) & 0xff).to_byte())
  out.push((value & 0xff).to_byte())
}

///|
pub fn typed_push_u32_be(out : Array[Byte], value : Int) -> Unit {
  out.push(((value >> 24) & 0xff).to_byte())
  out.push(((value >> 16) & 0xff).to_byte())
  out.push(((value >> 8) & 0xff).to_byte())
  out.push((value & 0xff).to_byte())
}

///|
pub fn typed_push_u24_be(out : Array[Byte], value : Int) -> Unit {
  out.push(((value >> 16) & 0xff).to_byte())
  out.push(((value >> 8) & 0xff).to_byte())
  out.push((value & 0xff).to_byte())
}

///|
pub fn typed_push_u64_be(out : Array[Byte], value : Grib2U64Be) -> Unit {
  typed_push_u32_be(out, value.high)
  typed_push_u32_be(out, value.low)
}

///|
pub fn typed_validate_section_header(
  section : Bytes,
  expected_number : Int,
) -> Result[Unit, Grib2SectionCodecError] {
  if section.length() < 5 {
    return Err(
      InvalidSectionLength(
        "section header too short: " + section.length().to_string(),
      ),
    )
  }
  let declared = typed_read_u32_be(section, 0)
  if declared != section.length() {
    return Err(
      InvalidSectionLength(
        "declared section length mismatch: declared=" +
        declared.to_string() +
        ", actual=" +
        section.length().to_string(),
      ),
    )
  }
  let number = section[4].to_uint().reinterpret_as_int()
  if number != expected_number {
    return Err(
      InvalidSectionNumber(
        "expected section " +
        expected_number.to_string() +
        ", got " +
        number.to_string(),
      ),
    )
  }
  Ok(())
}

///|
pub fn typed_build_section(section_number : Int, payload : Bytes) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, 5 + payload.length())
  out.push(section_number.to_byte())
  for b in payload {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_id_template_raw(template : Grib2IdTemplate) -> Bytes {
  match template {
    IdTemplateNone => b""
    IdTemplate10(calendar_type) => Bytes::from_array([calendar_type.to_byte()])
    IdTemplate11(paleo_offset) => {
      let out : Array[Byte] = []
      typed_push_u16_be(out, paleo_offset)
      Bytes::from_array(out)
    }
    IdTemplate12(calendar_type, paleo_offset) => {
      let out : Array[Byte] = [calendar_type.to_byte()]
      typed_push_u16_be(out, paleo_offset)
      Bytes::from_array(out)
    }
    IdTemplateUnknown(raw) => raw
  }
}

///|
pub fn decode_section1_bytes(
  section : Bytes,
) -> Result[Grib2Section1Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 1) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 21 {
    return Err(
      InvalidSectionLength(
        "section1 too short: " + section.length().to_string(),
      ),
    )
  }
  let reserved_octets_22_23 = if section.length() <= 21 {
    b""
  } else if section.length() == 22 {
    section.sub(start=21, end=22).to_bytes()
  } else {
    section.sub(start=21, end=23).to_bytes()
  }
  let (identification_template, reserved_tail) = if section.length() <= 23 {
    (IdTemplateNone, b"")
  } else if section.length() == 24 {
    (IdTemplate10(section[23].to_uint().reinterpret_as_int()), b"")
  } else if section.length() == 25 {
    (IdTemplate11(typed_read_u16_be(section, 23)), b"")
  } else {
    (
      IdTemplate12(
        section[23].to_uint().reinterpret_as_int(),
        typed_read_u16_be(section, 24),
      ),
      section.sub(start=26).to_bytes(),
    )
  }
  Ok({
    center: typed_read_u16_be(section, 5),
    subcenter: typed_read_u16_be(section, 7),
    master_table_version: section[9].to_uint().reinterpret_as_int(),
    local_table_version: section[10].to_uint().reinterpret_as_int(),
    significance_of_reference_time: section[11].to_uint().reinterpret_as_int(),
    reference_year: typed_read_u16_be(section, 12),
    reference_month: section[14].to_uint().reinterpret_as_int(),
    reference_day: section[15].to_uint().reinterpret_as_int(),
    reference_hour: section[16].to_uint().reinterpret_as_int(),
    reference_minute: section[17].to_uint().reinterpret_as_int(),
    reference_second: section[18].to_uint().reinterpret_as_int(),
    production_status: section[19].to_uint().reinterpret_as_int(),
    processed_data_type: section[20].to_uint().reinterpret_as_int(),
    identification_template,
    reserved_octets_22_23,
    reserved_tail,
  })
}

///|
pub fn encode_section1_bytes(section : Grib2Section1Decoded) -> Bytes {
  let payload : Array[Byte] = []
  typed_push_u16_be(payload, section.center)
  typed_push_u16_be(payload, section.subcenter)
  payload.push(section.master_table_version.to_byte())
  payload.push(section.local_table_version.to_byte())
  payload.push(section.significance_of_reference_time.to_byte())
  typed_push_u16_be(payload, section.reference_year)
  payload.push(section.reference_month.to_byte())
  payload.push(section.reference_day.to_byte())
  payload.push(section.reference_hour.to_byte())
  payload.push(section.reference_minute.to_byte())
  payload.push(section.reference_second.to_byte())
  payload.push(section.production_status.to_byte())
  payload.push(section.processed_data_type.to_byte())
  for b in section.reserved_octets_22_23 {
    payload.push(b)
  }
  let template_raw = typed_id_template_raw(section.identification_template)
  for b in template_raw {
    payload.push(b)
  }
  for b in section.reserved_tail {
    payload.push(b)
  }
  typed_build_section(1, Bytes::from_array(payload))
}
