///|
pub fn grib2_message_with_offset(
  message : @lib.Grib2MessageContext,
  offset : Int,
) -> @lib.Grib2MessageContext {
  {
    offset,
    total_length: message.total_length,
    discipline: message.discipline,
    edition: message.edition,
    section1: message.section1,
    section8_offset: message.section8_offset,
    sections: message.sections,
    submessages: message.submessages,
    raw: message.raw,
  }
}

///|
pub fn grib2_message_with_raw(
  message : @lib.Grib2MessageContext,
  raw : Bytes,
) -> @lib.Grib2MessageContext {
  {
    offset: message.offset,
    total_length: message.total_length,
    discipline: message.discipline,
    edition: message.edition,
    section1: message.section1,
    section8_offset: message.section8_offset,
    sections: message.sections,
    submessages: message.submessages,
    raw,
  }
}

///|
pub fn grib2_message_with_section8_offset(
  message : @lib.Grib2MessageContext,
  section8_offset : Int,
) -> @lib.Grib2MessageContext {
  {
    offset: message.offset,
    total_length: message.total_length,
    discipline: message.discipline,
    edition: message.edition,
    section1: message.section1,
    section8_offset,
    sections: message.sections,
    submessages: message.submessages,
    raw: message.raw,
  }
}

///|
pub fn grib2_context_with_replaced_message0(
  context : @lib.Grib2FileContext,
  message0 : @lib.Grib2MessageContext,
) -> @lib.Grib2FileContext {
  let messages = [..context.messages]
  messages[0] = message0
  { messages, }
}
