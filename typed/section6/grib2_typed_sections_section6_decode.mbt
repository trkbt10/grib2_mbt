///|
fn typed_decode_section6_payload(
  payload : Bytes,
) -> Result[Grib2Section6Decoded, Grib2SectionCodecError] {
  if payload.length() < 1 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section6 payload too short: " + payload.length().to_string(),
      ),
    )
  }
  Ok({
    bitmap_indicator: payload[0].to_uint().reinterpret_as_int(),
    bitmap_raw: payload.sub(start=1).to_bytes(),
  })
}
