///|
pub(all) suberror Grib2ParseError {
  UnexpectedEof(String)
  InvalidMagic(String)
  InvalidSectionLength(String)
  InvalidSectionNumber(String)
  InvalidMessageLength(String)
  InvalidSectionOrder(String)
} derive(Show)

///|
pub(all) suberror Grib2ContextEditError {
  InvalidMessageIndex(String)
  InvalidRawMessage(String)
  ParseError(Grib2ParseError)
} derive(Show)

///|
pub(all) struct Grib2SectionFrame {
  section_number : Int
  start : Int
  length : Int
}

///|
pub fn Grib2SectionFrame::end_offset(self : Grib2SectionFrame) -> Int {
  self.start + self.length
}

///|
pub(all) struct Grib2SubmessageFrame {
  section2 : Grib2SectionFrame?
  section3 : Grib2SectionFrame
  section4 : Grib2SectionFrame
  section5 : Grib2SectionFrame
  section6 : Grib2SectionFrame
  section7 : Grib2SectionFrame
}

///|
pub(all) struct Grib2MessageContext {
  offset : Int
  total_length : Int
  discipline : Int
  edition : Int
  section1 : Grib2SectionFrame
  section8_offset : Int
  sections : Array[Grib2SectionFrame]
  submessages : Array[Grib2SubmessageFrame]
  raw : Bytes
}

///|
pub fn Grib2MessageContext::submessage_count(self : Grib2MessageContext) -> Int {
  self.submessages.length()
}

///|
pub(all) struct Grib2FileContext {
  messages : Array[Grib2MessageContext]
}

///|
pub fn Grib2FileContext::message_count(self : Grib2FileContext) -> Int {
  self.messages.length()
}

///|
pub fn Grib2FileContext::record_count(self : Grib2FileContext) -> Int {
  let mut total = 0
  for message in self.messages {
    total += message.submessage_count()
  }
  total
}

///|
fn shift_section_frame(
  section : Grib2SectionFrame,
  delta : Int,
) -> Grib2SectionFrame {
  {
    section_number: section.section_number,
    start: section.start + delta,
    length: section.length,
  }
}

///|
fn reindex_message(
  message : Grib2MessageContext,
  new_offset : Int,
) -> Grib2MessageContext {
  let delta = new_offset - message.offset
  let sections : Array[Grib2SectionFrame] = []
  for section in message.sections {
    sections.push(shift_section_frame(section, delta))
  }
  let submessages : Array[Grib2SubmessageFrame] = []
  for submessage in message.submessages {
    submessages.push({
      section2: match submessage.section2 {
        Some(section2) => Some(shift_section_frame(section2, delta))
        None => None
      },
      section3: shift_section_frame(submessage.section3, delta),
      section4: shift_section_frame(submessage.section4, delta),
      section5: shift_section_frame(submessage.section5, delta),
      section6: shift_section_frame(submessage.section6, delta),
      section7: shift_section_frame(submessage.section7, delta),
    })
  }
  {
    offset: new_offset,
    total_length: message.total_length,
    discipline: message.discipline,
    edition: message.edition,
    section1: shift_section_frame(message.section1, delta),
    section8_offset: message.section8_offset + delta,
    sections,
    submessages,
    raw: message.raw,
  }
}

///|
fn reindex_messages(
  messages : Array[Grib2MessageContext],
) -> Array[Grib2MessageContext] {
  let normalized : Array[Grib2MessageContext] = []
  let mut next_offset = 0
  for message in messages {
    normalized.push(reindex_message(message, next_offset))
    next_offset += message.raw.length()
  }
  normalized
}

///|
fn parse_single_message(
  raw : Bytes,
) -> Result[Grib2MessageContext, Grib2ContextEditError] {
  match parse_grib2_file(raw) {
    Ok(context) =>
      if context.messages.length() != 1 {
        Err(
          InvalidRawMessage(
            "expected exactly one message in raw bytes, found " +
            context.messages.length().to_string(),
          ),
        )
      } else {
        Ok(context.messages[0])
      }
    Err(error) => Err(ParseError(error))
  }
}

///|
pub fn Grib2FileContext::reindex_offsets(
  self : Grib2FileContext,
) -> Grib2FileContext {
  { messages: reindex_messages(self.messages) }
}

///|
pub fn Grib2FileContext::replace_message_raw(
  self : Grib2FileContext,
  message_index : Int,
  raw : Bytes,
) -> Result[Grib2FileContext, Grib2ContextEditError] {
  if message_index < 0 || message_index >= self.messages.length() {
    return Err(
      InvalidMessageIndex(
        "message index out of range: " +
        message_index.to_string() +
        " (len=" +
        self.messages.length().to_string() +
        ")",
      ),
    )
  }
  let parsed = match parse_single_message(raw) {
    Ok(message) => message
    Err(error) => return Err(error)
  }
  let messages = [..self.messages]
  messages[message_index] = parsed
  Ok({ messages: reindex_messages(messages) })
}

///|
pub fn Grib2FileContext::insert_message_raw(
  self : Grib2FileContext,
  message_index : Int,
  raw : Bytes,
) -> Result[Grib2FileContext, Grib2ContextEditError] {
  if message_index < 0 || message_index > self.messages.length() {
    return Err(
      InvalidMessageIndex(
        "message index out of range for insert: " +
        message_index.to_string() +
        " (len=" +
        self.messages.length().to_string() +
        ")",
      ),
    )
  }
  let parsed = match parse_single_message(raw) {
    Ok(message) => message
    Err(error) => return Err(error)
  }
  let messages : Array[Grib2MessageContext] = []
  for i in 0..<self.messages.length() {
    if i == message_index {
      messages.push(parsed)
    }
    messages.push(self.messages[i])
  }
  if message_index == self.messages.length() {
    messages.push(parsed)
  }
  Ok({ messages: reindex_messages(messages) })
}

///|
pub fn Grib2FileContext::append_message_raw(
  self : Grib2FileContext,
  raw : Bytes,
) -> Result[Grib2FileContext, Grib2ContextEditError] {
  self.insert_message_raw(self.messages.length(), raw)
}

///|
pub fn Grib2FileContext::remove_message(
  self : Grib2FileContext,
  message_index : Int,
) -> Result[Grib2FileContext, Grib2ContextEditError] {
  if message_index < 0 || message_index >= self.messages.length() {
    return Err(
      InvalidMessageIndex(
        "message index out of range: " +
        message_index.to_string() +
        " (len=" +
        self.messages.length().to_string() +
        ")",
      ),
    )
  }
  let messages : Array[Grib2MessageContext] = []
  for i in 0..<self.messages.length() {
    if i != message_index {
      messages.push(self.messages[i])
    }
  }
  Ok({ messages: reindex_messages(messages) })
}
