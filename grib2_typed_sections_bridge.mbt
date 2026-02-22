///|
pub using @typed {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  type Grib2Section3Decoded,
  type Grib2Section4Decoded,
  decode_section1_bytes,
  decode_section3_bytes,
  decode_section4_bytes,
  encode_section1_bytes,
  encode_section3_bytes,
  encode_section4_bytes,
}

///|
fn typed_message_section_bytes(
  message : Grib2MessageContext,
  frame : Grib2SectionFrame,
) -> Bytes {
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  message.raw.sub(start~, end~).to_bytes()
}

///|
pub fn decode_message_section1(
  message : Grib2MessageContext,
) -> Result[Grib2Section1Decoded, Grib2SectionCodecError] {
  decode_section1_bytes(typed_message_section_bytes(message, message.section1))
}

///|
pub fn decode_submessage_section3(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section3Decoded, Grib2SectionCodecError] {
  decode_section3_bytes(
    typed_message_section_bytes(message, submessage.section3),
  )
}

///|
pub fn decode_submessage_section4(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section4Decoded, Grib2SectionCodecError] {
  decode_section4_bytes(
    typed_message_section_bytes(message, submessage.section4),
  )
}
