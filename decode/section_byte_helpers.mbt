///|
/// Slice the message-relative bytes that correspond to a given section frame.
/// The frame is expressed in absolute file offsets, hence the subtraction by
/// `message.offset`.
fn section_slice(
  message : @context.Grib2MessageContext,
  frame : @context.Grib2SectionFrame,
) -> BytesView {
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  message.raw.sub(start~, end~)
}

///|
fn read_u16_be_from(bytes : BytesView, index : Int) -> Int {
  @core.binary_read_u16_be_view(bytes, index)
}

///|
fn read_u32_be_from(bytes : BytesView, index : Int) -> Int {
  @core.binary_read_u32_be_view(bytes, index)
}

///|
fn read_i16_be_from(bytes : BytesView, index : Int) -> Int {
  let unsigned = @core.binary_read_u16_be_view(bytes, index)
  if unsigned >= 0x8000 {
    unsigned - 0x10000
  } else {
    unsigned
  }
}

///|
/// GRIB2 signed 16-bit integer (sign-magnitude representation, NOT two's
/// complement). MSB is the sign bit; the remaining 15 bits hold the magnitude.
fn read_i16_sign_magnitude_from(bytes : BytesView, index : Int) -> Int {
  let unsigned = @core.binary_read_u16_be_view(bytes, index)
  let magnitude = unsigned & 0x7FFF
  if (unsigned & 0x8000) != 0 {
    -magnitude
  } else {
    magnitude
  }
}

///|
/// GRIB2 signed 32-bit integer (sign-magnitude representation).
fn read_i32_sign_magnitude_from(bytes : BytesView, index : Int) -> Int {
  let b0 = bytes[index].to_uint().reinterpret_as_int()
  let b1 = bytes[index + 1].to_uint().reinterpret_as_int()
  let b2 = bytes[index + 2].to_uint().reinterpret_as_int()
  let b3 = bytes[index + 3].to_uint().reinterpret_as_int()
  let magnitude = ((b0 & 0x7f) << 24) | (b1 << 16) | (b2 << 8) | b3
  if (b0 & 0x80) != 0 {
    -magnitude
  } else {
    magnitude
  }
}

///|
/// GRIB2 signed byte (sign-magnitude).
fn read_signed_byte_from(bytes : BytesView, index : Int) -> Int {
  let raw = bytes[index].to_uint().reinterpret_as_int()
  let magnitude = raw & 0x7F
  if (raw & 0x80) != 0 {
    -magnitude
  } else {
    magnitude
  }
}

///|
/// Walk a Section 6 bitmap (after the 6-byte header) and count the bits that
/// are zero, i.e. the points marked as "undefined" by the bitmap.
fn count_bitmap_undefined_points(section6 : BytesView, npts : Int) -> Int {
  if npts <= 0 || section6.length() <= 6 {
    return 0
  }
  let available_bits = (section6.length() - 6) * 8
  let limit = if npts < available_bits { npts } else { available_bits }
  let mut undefined_points = 0
  for bit_index in 0..<limit {
    let byte_index = 6 + bit_index / 8
    let bit_offset = 7 - bit_index % 8
    let mask = 1 << bit_offset
    let value = section6[byte_index].to_uint().reinterpret_as_int()
    if (value & mask) == 0 {
      undefined_points += 1
    }
  }
  undefined_points
}

///|
fn in_range(value : Int, start : Int, end : Int) -> Bool {
  value >= start && value <= end
}
