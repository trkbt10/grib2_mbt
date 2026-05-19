///|
pub fn decode_section6_bytes(
  section : Bytes,
) -> Result[Grib2Section6Decoded, @section1.Grib2SectionCodecError] {
  match @section1.typed_validate_section_header(section, 6) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 6 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section6 too short: " + section.length().to_string(),
      ),
    )
  }
  typed_decode_section6_payload(section.sub(start=5).to_bytes())
}

///|
pub fn encode_section6_bytes(section : Grib2Section6Decoded) -> Bytes {
  @section1.typed_build_section(6, typed_encode_section6_payload(section))
}
