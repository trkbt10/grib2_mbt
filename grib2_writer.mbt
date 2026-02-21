///|
pub(all) suberror Grib2WriteError {
  InvariantViolation(String)
} derive(Show)

///|
fn write_error(message : String) -> Grib2WriteError {
  InvariantViolation(message)
}

///|
fn writer_read_u32_be(bytes : Bytes, offset : Int) -> Int {
  bytes.unsafe_read_uint32_be(offset).reinterpret_as_int()
}

///|
fn writer_read_u8_as_int(bytes : Bytes, offset : Int) -> Int {
  bytes[offset].to_uint().reinterpret_as_int()
}

///|
fn writer_has_grib_magic(raw : Bytes) -> Bool {
  raw.length() >= 4 &&
  raw[0] == b'G' &&
  raw[1] == b'R' &&
  raw[2] == b'I' &&
  raw[3] == b'B'
}

///|
fn writer_has_end_magic(raw : Bytes) -> Bool {
  raw.length() >= 4 &&
  raw[raw.length() - 4] == b'7' &&
  raw[raw.length() - 3] == b'7' &&
  raw[raw.length() - 2] == b'7' &&
  raw[raw.length() - 1] == b'7'
}

///|
fn check_message_section(
  message : Grib2MessageContext,
  section : Grib2SectionFrame,
  message_index : Int,
  section_index : Int,
) -> Result[Unit, Grib2WriteError] {
  if section.section_number < 1 || section.section_number > 7 {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section[" +
        section_index.to_string() +
        "] has invalid section number: " +
        section.section_number.to_string(),
      ),
    )
  }
  if section.length < 5 {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section[" +
        section_index.to_string() +
        "] has invalid section length: " +
        section.length.to_string(),
      ),
    )
  }
  let local_start = section.start - message.offset
  let local_end = local_start + section.length
  let raw_len = message.raw.length()
  if local_start < 16 || local_end > raw_len - 4 {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section[" +
        section_index.to_string() +
        "] is out of message raw bounds",
      ),
    )
  }
  if local_start + 5 > raw_len {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section[" +
        section_index.to_string() +
        "] header is truncated in raw",
      ),
    )
  }
  let raw_length = writer_read_u32_be(message.raw, local_start)
  if raw_length != section.length {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section[" +
        section_index.to_string() +
        "] length mismatch: frame=" +
        section.length.to_string() +
        ", raw=" +
        raw_length.to_string(),
      ),
    )
  }
  let raw_section_number = writer_read_u8_as_int(message.raw, local_start + 4)
  if raw_section_number != section.section_number {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section[" +
        section_index.to_string() +
        "] section number mismatch: frame=" +
        section.section_number.to_string() +
        ", raw=" +
        raw_section_number.to_string(),
      ),
    )
  }
  Ok(())
}

///|
fn check_submessage_frame(
  submessage : Grib2SubmessageFrame,
  message_index : Int,
  submessage_index : Int,
) -> Result[Unit, Grib2WriteError] {
  if submessage.section3.section_number != 3 {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] submessage[" +
        submessage_index.to_string() +
        "] section3 number mismatch",
      ),
    )
  }
  if submessage.section4.section_number != 4 ||
    submessage.section5.section_number != 5 ||
    submessage.section6.section_number != 6 ||
    submessage.section7.section_number != 7 {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] submessage[" +
        submessage_index.to_string() +
        "] section4-7 number mismatch",
      ),
    )
  }
  if submessage.section4.start >= submessage.section5.start ||
    submessage.section5.start >= submessage.section6.start ||
    submessage.section6.start >= submessage.section7.start {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] submessage[" +
        submessage_index.to_string() +
        "] section4-7 order mismatch",
      ),
    )
  }
  if submessage.section3.end_offset() > submessage.section4.start {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] submessage[" +
        submessage_index.to_string() +
        "] section3 overlaps section4",
      ),
    )
  }
  match submessage.section2 {
    Some(section2) => {
      if section2.section_number != 2 {
        return Err(
          write_error(
            "message[" +
            message_index.to_string() +
            "] submessage[" +
            submessage_index.to_string() +
            "] section2 number mismatch",
          ),
        )
      }
      if section2.end_offset() > submessage.section4.start {
        return Err(
          write_error(
            "message[" +
            message_index.to_string() +
            "] submessage[" +
            submessage_index.to_string() +
            "] section2 overlaps section4",
          ),
        )
      }
      Ok(())
    }
    None => Ok(())
  }
}

///|
fn check_message_invariants(
  message : Grib2MessageContext,
  expected_offset : Int,
  message_index : Int,
) -> Result[Unit, Grib2WriteError] {
  let raw_len = message.raw.length()
  if raw_len < 20 {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] raw length is too small",
      ),
    )
  }
  if message.offset != expected_offset {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] offset mismatch: expected=" +
        expected_offset.to_string() +
        ", actual=" +
        message.offset.to_string(),
      ),
    )
  }
  if message.total_length != raw_len {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] total_length mismatch: total_length=" +
        message.total_length.to_string() +
        ", raw_len=" +
        raw_len.to_string(),
      ),
    )
  }
  if !writer_has_grib_magic(message.raw) {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] missing GRIB magic",
      ),
    )
  }
  if !writer_has_end_magic(message.raw) {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] missing 7777 magic",
      ),
    )
  }
  if message.section8_offset != message.offset + message.total_length - 4 {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] section8 offset mismatch",
      ),
    )
  }
  if writer_read_u8_as_int(message.raw, 6) != message.discipline {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] discipline mismatch with raw",
      ),
    )
  }
  if writer_read_u8_as_int(message.raw, 7) != message.edition {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] edition mismatch with raw",
      ),
    )
  }
  let hi = writer_read_u32_be(message.raw, 8)
  let lo = writer_read_u32_be(message.raw, 12)
  if hi != 0 {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section0 high length must be zero in strict mode",
      ),
    )
  }
  if lo != message.total_length {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section0 length mismatch: header=" +
        lo.to_string() +
        ", total_length=" +
        message.total_length.to_string(),
      ),
    )
  }
  if message.sections.length() == 0 {
    return Err(
      write_error("message[" + message_index.to_string() + "] has no sections"),
    )
  }
  if message.section1.section_number != 1 {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] section1 number mismatch",
      ),
    )
  }
  if message.section1.start != message.offset + 16 {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] section1 start mismatch",
      ),
    )
  }
  let first = message.sections[0]
  if first.section_number != 1 ||
    first.start != message.section1.start ||
    first.length != message.section1.length {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section1 frame mismatch with sections[0]",
      ),
    )
  }
  let mut cursor = message.offset + 16
  for section_index in 0..<message.sections.length() {
    let section = message.sections[section_index]
    match
      check_message_section(message, section, message_index, section_index) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    if section.start != cursor {
      return Err(
        write_error(
          "message[" +
          message_index.to_string() +
          "] section[" +
          section_index.to_string() +
          "] is not contiguous with previous section",
        ),
      )
    }
    cursor = section.end_offset()
  }
  if cursor != message.section8_offset {
    return Err(
      write_error(
        "message[" +
        message_index.to_string() +
        "] section tail does not align with section8",
      ),
    )
  }
  if message.submessages.length() == 0 {
    return Err(
      write_error(
        "message[" + message_index.to_string() + "] has no submessages",
      ),
    )
  }
  for submessage_index in 0..<message.submessages.length() {
    match
      check_submessage_frame(
        message.submessages[submessage_index],
        message_index,
        submessage_index,
      ) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
  }
  Ok(())
}

///|
pub fn validate_context_invariants(
  context : Grib2FileContext,
) -> Result[Unit, Grib2WriteError] {
  let mut expected_offset = 0
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    match check_message_invariants(message, expected_offset, message_index) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    expected_offset += message.raw.length()
  }
  Ok(())
}

///|
pub fn rebuild_raw(context : Grib2FileContext) -> Bytes {
  loop (0, b"") {
    (index, out) =>
      if index == context.messages.length() {
        out
      } else {
        continue (index + 1, out + context.messages[index].raw)
      }
  }
}

///|
pub fn rebuild_strict(
  context : Grib2FileContext,
) -> Result[Bytes, Grib2WriteError] {
  match validate_context_invariants(context) {
    Ok(_) => Ok(rebuild_raw(context))
    Err(error) => Err(error)
  }
}
