///|
pub using @typed {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  type Grib2Section2Decoded,
  type Grib2Section3Decoded,
  type Grib2Section4Decoded,
  type Grib2Section5Decoded,
  type Grib2Section6Decoded,
  type Grib2Section7Decoded,
  decode_section1_bytes,
  decode_section2_bytes,
  decode_section3_bytes,
  decode_section4_bytes,
  decode_section5_bytes,
  decode_section6_bytes,
  decode_section7_bytes,
  encode_section1_bytes,
  encode_section2_bytes,
  encode_section3_bytes,
  encode_section4_bytes,
  encode_section5_bytes,
  encode_section6_bytes,
  encode_section7_bytes,
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
fn typed_read_u16_be_bridge(bytes : Bytes, offset : Int) -> Int {
  binary_read_u16_be(bytes, offset)
}

///|
pub fn decode_message_section1(
  message : Grib2MessageContext,
) -> Result[Grib2Section1Decoded, Grib2SectionCodecError] {
  decode_section1_bytes(typed_message_section_bytes(message, message.section1))
}

///|
pub fn decode_submessage_section2(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section2Decoded?, Grib2SectionCodecError] {
  match submessage.section2 {
    Some(section2) =>
      match
        decode_section2_bytes(typed_message_section_bytes(message, section2)) {
        Ok(section) => Ok(Some(section))
        Err(error) => Err(error)
      }
    None => Ok(None)
  }
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

///|
pub fn decode_submessage_section5(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section5Decoded, Grib2SectionCodecError] {
  decode_section5_bytes(
    typed_message_section_bytes(message, submessage.section5),
  )
}

///|
pub fn decode_submessage_section6(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section6Decoded, Grib2SectionCodecError] {
  decode_section6_bytes(
    typed_message_section_bytes(message, submessage.section6),
  )
}

///|
pub fn decode_submessage_section7(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section7Decoded, Grib2SectionCodecError] {
  let section5 = typed_message_section_bytes(message, submessage.section5)
  if section5.length() < 11 {
    return Err(
      InvalidSectionLength(
        "section5 too short for template number: " +
        section5.length().to_string(),
      ),
    )
  }
  let template_number = typed_read_u16_be_bridge(section5, 9)
  decode_section7_bytes(
    typed_message_section_bytes(message, submessage.section7),
    template_number,
  )
}
