///|
fn section_frame_bytes(
  message : @context.Grib2MessageContext,
  frame : @context.Grib2SectionFrame,
) -> Bytes {
  @common.section_frame_bytes(message, frame)
}

///|
fn get_record_section_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  section : Int,
) -> Bytes? {
  match section {
    0 => {
      let sec0_length = message.section1.start - message.offset
      if sec0_length > 0 {
        Some(message.raw.sub(start=0, end=sec0_length).to_bytes())
      } else {
        None
      }
    }
    1 => Some(section_frame_bytes(message, message.section1))
    2 =>
      match submessage.section2 {
        Some(sec2) => Some(section_frame_bytes(message, sec2))
        None => None
      }
    3 => Some(section_frame_bytes(message, submessage.section3))
    4 => Some(section_frame_bytes(message, submessage.section4))
    5 => Some(section_frame_bytes(message, submessage.section5))
    6 => Some(section_frame_bytes(message, submessage.section6))
    7 => Some(section_frame_bytes(message, submessage.section7))
    8 => Some(Bytes::from_array([b'7', b'7', b'7', b'7']))
    _ => None
  }
}

///|
fn append_bytes(out : Array[Byte], bytes : Bytes) -> Unit {
  @common.append_bytes(out, bytes)
}

///|
fn build_sec0_with_length(
  message : @context.Grib2MessageContext,
  total_len : Int,
) -> Bytes {
  let out : Array[Byte] = []
  // Copy original section 0 bytes (16 bytes) and patch octets 9-16 with total length.
  for i in 0..<16 {
    out.push(message.raw[i])
  }
  // High 32bits are zero in this implementation.
  out[8] = b'\x00'
  out[9] = b'\x00'
  out[10] = b'\x00'
  out[11] = b'\x00'
  let low = total_len.to_uint()
  out[12] = ((low >> 24) & 0xFF).reinterpret_as_int().to_byte()
  out[13] = ((low >> 16) & 0xFF).reinterpret_as_int().to_byte()
  out[14] = ((low >> 8) & 0xFF).reinterpret_as_int().to_byte()
  out[15] = (low & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array(out)
}

///|
fn build_submessage_grib_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
) -> Bytes {
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec5 = section_frame_bytes(message, submessage.section5)
  let sec6 = section_frame_bytes(message, submessage.section6)
  let sec7 = section_frame_bytes(message, submessage.section7)
  let body_len = sec1.length() +
    sec2.length() +
    sec3.length() +
    sec4.length() +
    sec5.length() +
    sec6.length() +
    sec7.length()
  let total_len = 16 + body_len + 4
  let sec0 = build_sec0_with_length(message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  append_bytes(out, sec7)
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  Bytes::from_array(out)
}

///|
fn build_submessage_grib_bytes_with_overrides(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  section4_override : Bytes?,
  section5_override : Bytes?,
  section6_override : Bytes?,
  section7_override : Bytes?,
) -> Bytes {
  build_submessage_grib_bytes_with_section_overrides(
    message,
    submessage,
    None,
    section4_override,
    section5_override,
    section6_override,
    section7_override,
  )
}

///|
fn build_submessage_grib_bytes_with_section_overrides(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  section3_override : Bytes?,
  section4_override : Bytes?,
  section5_override : Bytes?,
  section6_override : Bytes?,
  section7_override : Bytes?,
) -> Bytes {
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = match section3_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section3)
  }
  let sec4 = match section4_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section4)
  }
  let sec5 = match section5_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section5)
  }
  let sec6 = match section6_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section6)
  }
  let sec7 = match section7_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section7)
  }
  let body_len = sec1.length() +
    sec2.length() +
    sec3.length() +
    sec4.length() +
    sec5.length() +
    sec6.length() +
    sec7.length()
  let total_len = 16 + body_len + 4
  let sec0 = build_sec0_with_length(message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  append_bytes(out, sec7)
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  Bytes::from_array(out)
}

///|
fn write_raw_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        append_bytes(out, build_submessage_grib_bytes(message, submessage))
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_grib_out_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let metas = @decode.decode_records(context)
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -grib_out record " +
            record_index.to_string(),
          )
        }
        let bytes = match
          build_grib_out_submessage_bytes(
            message,
            submessage,
            metas[meta_index],
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
priv struct GribIeeeRecordOutput {
  grb : Bytes
  head : Bytes
  tail : Bytes
  ndata : Int
  sec1_offset : Int
  sec2_offset : Int?
  sec3_offset : Int
  sec4_offset : Int
  sec5_offset : Int
  sec6_offset : Int
  sec7_offset : Int
  sec0_prefix : Bytes
  sec1 : Bytes
  sec2 : Bytes?
  sec3 : Bytes
  sec4 : Bytes
}

///|
fn grib_ieee_payload_bytes(values : Array[Double]) -> Bytes {
  let out : Array[Byte] = []
  for value in values {
    if value != value {
      out.push(b'\xff')
      out.push(b'\xff')
      out.push(b'\xff')
      out.push(b'\xff')
    } else {
      append_f32_bytes(out, value, true)
    }
  }
  Bytes::from_array(out)
}

///|
fn render_c_byte_lines(
  bytes : Bytes,
  indent : String,
  per_line : Int,
  trailing_space : Bool,
) -> Array[String] {
  let lines : Array[String] = []
  if bytes.length() == 0 {
    lines.push(indent)
    return lines
  }
  let mut current = indent
  let mut count = 0
  for i in 0..<bytes.length() {
    if count > 0 {
      current += " "
    }
    current += bytes[i].to_int().to_string() + ","
    count += 1
    if count == per_line && i + 1 < bytes.length() {
      if trailing_space {
        current += " "
      }
      lines.push(current)
      current = indent
      count = 0
    }
  }
  if count > 0 {
    if trailing_space {
      current += " "
    }
    lines.push(current)
  }
  lines
}

///|
fn render_c_inline_byte_array(bytes : Bytes) -> String {
  let parts : Array[String] = []
  for b in bytes {
    parts.push(b.to_int().to_string())
  }
  "{ " + parts.join(", ") + ", }"
}

///|
fn render_c_fixed_byte_array(bytes : Bytes) -> String {
  let parts : Array[String] = []
  for b in bytes {
    parts.push(b.to_int().to_string())
  }
  "{" + parts.join(", ") + "}"
}

///|
fn append_rendered_c_array(
  lines : Array[String],
  open_line : String,
  bytes : Bytes,
  indent : String,
  per_line : Int,
  trailing_space : Bool,
) -> Unit {
  lines.push(open_line)
  let rendered = render_c_byte_lines(bytes, indent, per_line, trailing_space)
  for i in 0..<rendered.length() {
    let suffix = if i + 1 == rendered.length() { "};" } else { "" }
    lines.push(rendered[i] + suffix)
  }
}

///|
fn build_grib_ieee_header_text(record : GribIeeeRecordOutput) -> String {
  let lines : Array[String] = []
  append_rendered_c_array(
    lines,
    "unsigned char head[] = {",
    record.head,
    " ",
    20,
    false,
  )
  lines.push("")
  lines.push(
    "unsigned char tail[4] = " + render_c_fixed_byte_array(record.tail) + ";",
  )
  lines.push("")
  lines.push("#define NDATA " + record.ndata.to_string())
  lines.push("#define SEC0 0")
  lines.push("#define DISCIPLINE 6")
  lines.push("#define EDITION 7")
  lines.push("#define SEC1 " + record.sec1_offset.to_string())
  lines.push("#define CENTER " + (record.sec1_offset + 5).to_string())
  lines.push("#define SUBCENTER " + (record.sec1_offset + 7).to_string())
  lines.push("#define MASTERTABLE " + (record.sec1_offset + 9).to_string())
  // wgrib2's emitted header keeps LOCALTABLE at the same offset as MASTERTABLE.
  lines.push("#define LOCALTABLE " + (record.sec1_offset + 9).to_string())
  lines.push("#define YEAR " + (record.sec1_offset + 12).to_string())
  lines.push("#define MONTH " + (record.sec1_offset + 14).to_string())
  lines.push("#define DAY " + (record.sec1_offset + 15).to_string())
  lines.push("#define HOUR " + (record.sec1_offset + 16).to_string())
  lines.push("#define MINUTE " + (record.sec1_offset + 17).to_string())
  lines.push("#define SECOND " + (record.sec1_offset + 18).to_string())
  match record.sec2_offset {
    Some(offset) => lines.push("#define SEC2 " + offset.to_string())
    None => ()
  }
  lines.push("#define SEC3 " + record.sec3_offset.to_string())
  lines.push("#define SEC4 " + record.sec4_offset.to_string())
  lines.push(
    "#define PRODUCTDEFTEMPLATENUM " + (record.sec4_offset + 7).to_string(),
  )
  lines.push(
    "#define PRODUCTDEFTEMPLATE " + (record.sec4_offset + 9).to_string(),
  )
  lines.push("#define PRODUCTCATEGORY " + (record.sec4_offset + 9).to_string())
  lines.push("#define PRODUCTNUMBER " + (record.sec4_offset + 10).to_string())
  lines.push("#define SEC5 " + record.sec5_offset.to_string())
  lines.push("#define SEC6 " + record.sec6_offset.to_string())
  lines.push("#define SEC7 " + record.sec7_offset.to_string())
  lines.push(
    "unsigned char sec0[] = " +
    render_c_inline_byte_array(record.sec0_prefix) +
    ";",
  )
  lines.push(
    "unsigned char sec1[] = " + render_c_inline_byte_array(record.sec1) + ";",
  )
  match record.sec2 {
    Some(sec2) =>
      lines.push(
        "unsigned char sec2[] = " + render_c_inline_byte_array(sec2) + ";",
      )
    None => ()
  }
  append_rendered_c_array(
    lines,
    "unsigned char sec3[] = { ",
    record.sec3,
    "",
    20,
    true,
  )
  append_rendered_c_array(
    lines,
    "unsigned char sec4[] = { ",
    record.sec4,
    "",
    20,
    true,
  )
  lines.push(
    "unsigned char sec7[4] = " + render_c_fixed_byte_array(record.tail) + ";",
  )
  lines.join("\n") + "\n"
}

///|
fn build_grib_ieee_record_output(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  record_index : Int,
) -> Result[GribIeeeRecordOutput, String] {
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to unpack record " +
        record_index.to_string() +
        " (-grib_ieee): " +
        unpack_error_string(e),
      )
  }
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => Some(section_frame_bytes(message, s))
    None => None
  }
  let sec2_len = match sec2 {
    Some(sec2) => sec2.length()
    None => 0
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let payload = grib_ieee_payload_bytes(unpacked.values)
  let sec5 = @decode.encode_section5_bytes({
    number_of_data_points: unpacked.values.length(),
    template: DataRepresentationTemplate54({ precision: 1, reserved_tail: b"" }),
  })
  let sec6 = @decode.encode_section6_bytes({
    bitmap_indicator: 255,
    bitmap_raw: b"",
  })
  let sec7 = @decode.encode_section7_bytes({
    template: DataTemplate74({ data_values_raw: payload }),
  })
  let grb = build_submessage_grib_bytes_with_overrides(
    message,
    submessage,
    Some(sec4),
    Some(sec5),
    Some(sec6),
    Some(sec7),
  )
  let sec0 = grb.sub(start=0, end=16).to_bytes()
  let sec7_header = sec7.sub(start=0, end=5).to_bytes()
  let head_out : Array[Byte] = []
  append_bytes(head_out, sec0)
  append_bytes(head_out, sec1)
  match sec2 {
    Some(sec2) => append_bytes(head_out, sec2)
    None => ()
  }
  append_bytes(head_out, sec3)
  append_bytes(head_out, sec4)
  append_bytes(head_out, sec5)
  append_bytes(head_out, sec6)
  append_bytes(head_out, sec7_header)
  let sec1_offset = 16
  let sec2_offset = if sec2_len > 0 {
    Some(sec1_offset + sec1.length())
  } else {
    None
  }
  let sec3_offset = sec1_offset + sec1.length() + sec2_len
  let sec4_offset = sec3_offset + sec3.length()
  let sec5_offset = sec4_offset + sec4.length()
  let sec6_offset = sec5_offset + sec5.length()
  let sec7_offset = sec6_offset + sec6.length()
  Ok({
    grb,
    head: Bytes::from_array(head_out),
    tail: Bytes::from_array([b'7', b'7', b'7', b'7']),
    ndata: unpacked.values.length(),
    sec1_offset,
    sec2_offset,
    sec3_offset,
    sec4_offset,
    sec5_offset,
    sec6_offset,
    sec7_offset,
    sec0_prefix: sec0.sub(start=0, end=8).to_bytes(),
    sec1,
    sec2,
    sec3,
    sec4,
  })
}

///|
fn write_grib_ieee_output(
  prefix : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let grb_path = prefix + ".grb"
  let head_path = prefix + ".head"
  let tail_path = prefix + ".tail"
  let h_path = prefix + ".h"
  let write_bytes = if append_mode {
    native_append_bytes
  } else {
    native_write_bytes
  }
  let write_text = if append_mode {
    native_append_string
  } else {
    native_write_string
  }
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let record = match
          build_grib_ieee_record_output(message, submessage, record_index) {
          Ok(record) => record
          Err(e) => return Err(e)
        }
        match write_bytes(grb_path, record.grb) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
        match write_bytes(head_path, record.head) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
        match write_bytes(tail_path, record.tail) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
        return write_text(h_path, build_grib_ieee_header_text(record))
      }
      record_index += 1
    }
  }
  Ok(())
}

///|
