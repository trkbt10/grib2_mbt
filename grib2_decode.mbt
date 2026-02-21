///|
pub(all) enum Grib2NameLookup {
  NameKnown(String)
  NameUnknown(String)
} derive(Show)

///|
pub fn Grib2NameLookup::display(self : Grib2NameLookup) -> String {
  match self {
    NameKnown(value) => value
    NameUnknown(raw) => raw
  }
}

///|
pub(all) enum Grib2Section3Template {
  Section3TemplateKnown(Int)
  Section3TemplateUnknown(Int)
} derive(Show)

///|
pub fn Grib2Section3Template::id(self : Grib2Section3Template) -> Int {
  match self {
    Section3TemplateKnown(id) => id
    Section3TemplateUnknown(id) => id
  }
}

///|
pub fn Grib2Section3Template::is_known(self : Grib2Section3Template) -> Bool {
  match self {
    Section3TemplateKnown(_) => true
    Section3TemplateUnknown(_) => false
  }
}

///|
pub(all) enum Grib2Section4Template {
  Section4TemplateKnown(Int)
  Section4TemplateUnknown(Int)
} derive(Show)

///|
pub fn Grib2Section4Template::id(self : Grib2Section4Template) -> Int {
  match self {
    Section4TemplateKnown(id) => id
    Section4TemplateUnknown(id) => id
  }
}

///|
pub fn Grib2Section4Template::is_known(self : Grib2Section4Template) -> Bool {
  match self {
    Section4TemplateKnown(_) => true
    Section4TemplateUnknown(_) => false
  }
}

///|
pub(all) enum Grib2Section5Template {
  Section5TemplateKnown(Int)
  Section5TemplateUnknown(Int)
} derive(Show)

///|
pub fn Grib2Section5Template::id(self : Grib2Section5Template) -> Int {
  match self {
    Section5TemplateKnown(id) => id
    Section5TemplateUnknown(id) => id
  }
}

///|
pub fn Grib2Section5Template::is_known(self : Grib2Section5Template) -> Bool {
  match self {
    Section5TemplateKnown(_) => true
    Section5TemplateUnknown(_) => false
  }
}

///|
pub(all) struct Grib2RecordMeta {
  record_index : Int
  record_id : String
  message_offset : Int
  message_total_length : Int
  reference_time : String
  discipline : Int
  edition : Int
  parameter_name : Grib2NameLookup
  level_name : Grib2NameLookup
  tail : String
  section0_reserved : String
  section3_template : Grib2Section3Template
  section4_template : Grib2Section4Template
  section5_template : Grib2Section5Template
  section3_length : Int
  section3_gdef_source : Int
  section3_npts : Int
  section4_length : Int
  section4_num_coord : Int
  section5_length : Int
}

///|
fn section_slice(
  message : Grib2MessageContext,
  frame : Grib2SectionFrame,
) -> BytesView {
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  message.raw.sub(start~, end~)
}

///|
fn read_u16_be_from(bytes : BytesView, index : Int) -> Int {
  bytes.unsafe_read_uint16_be(index).to_uint().reinterpret_as_int()
}

///|
fn read_u32_be_from(bytes : BytesView, index : Int) -> Int {
  bytes.unsafe_read_uint32_be(index).reinterpret_as_int()
}

///|
fn pad2(value : Int) -> String {
  if value < 10 {
    "0" + value.to_string()
  } else {
    value.to_string()
  }
}

///|
fn pad4(value : Int) -> String {
  if value >= 1000 {
    value.to_string()
  } else if value >= 100 {
    "0" + value.to_string()
  } else if value >= 10 {
    "00" + value.to_string()
  } else {
    "000" + value.to_string()
  }
}

///|
fn hex_digit(value : Int) -> String {
  match value {
    0 => "0"
    1 => "1"
    2 => "2"
    3 => "3"
    4 => "4"
    5 => "5"
    6 => "6"
    7 => "7"
    8 => "8"
    9 => "9"
    10 => "a"
    11 => "b"
    12 => "c"
    13 => "d"
    14 => "e"
    15 => "f"
    _ => "0"
  }
}

///|
fn hex_byte(value : Byte) -> String {
  let u = value.to_uint().reinterpret_as_int()
  hex_digit((u >> 4) & 0x0f) + hex_digit(u & 0x0f)
}

///|
fn format_record_id(
  context : Grib2FileContext,
  message_index : Int,
  submessage_index : Int,
  submessage_count : Int,
  global_index : Int,
) -> String {
  if submessage_count > 1 ||
    (context.message_count() == 1 && context.record_count() > 1) {
    message_index.to_string() + "." + submessage_index.to_string()
  } else {
    global_index.to_string()
  }
}

///|
fn format_ref_time_yyyymmddhh(message : Grib2MessageContext) -> String {
  let section1 = section_slice(message, message.section1)
  if section1.length() < 20 {
    return "0000000000"
  }
  let year = read_u16_be_from(section1, 12)
  let month = section1[14].to_uint().reinterpret_as_int()
  let day = section1[15].to_uint().reinterpret_as_int()
  let hour = section1[16].to_uint().reinterpret_as_int()
  pad4(year) + pad2(month) + pad2(day) + pad2(hour)
}

///|
fn in_range(value : Int, start : Int, end : Int) -> Bool {
  value >= start && value <= end
}

///|
fn decode_section3_template(id : Int) -> Grib2Section3Template {
  if in_range(id, 0, 5) ||
    id == 10 ||
    in_range(id, 12, 13) ||
    id == 20 ||
    id == 23 ||
    in_range(id, 30, 31) ||
    id == 33 ||
    in_range(id, 40, 43) ||
    in_range(id, 50, 53) ||
    in_range(id, 60, 63) ||
    id == 90 ||
    in_range(id, 100, 101) ||
    id == 110 ||
    id == 120 ||
    id == 140 ||
    id == 150 ||
    id == 204 ||
    id == 1000 ||
    id == 1100 ||
    id == 1200 ||
    in_range(id, 32768, 32769) {
    Section3TemplateKnown(id)
  } else {
    Section3TemplateUnknown(id)
  }
}

///|
fn decode_section4_template(id : Int) -> Grib2Section4Template {
  if in_range(id, 0, 15) ||
    id == 20 ||
    in_range(id, 30, 35) ||
    in_range(id, 40, 51) ||
    in_range(id, 53, 63) ||
    in_range(id, 67, 68) ||
    in_range(id, 70, 73) ||
    in_range(id, 76, 155) ||
    id == 254 ||
    in_range(id, 1000, 1002) ||
    in_range(id, 1100, 1101) {
    Section4TemplateKnown(id)
  } else {
    Section4TemplateUnknown(id)
  }
}

///|
fn decode_section5_template(id : Int) -> Grib2Section5Template {
  if in_range(id, 0, 4) ||
    in_range(id, 40, 42) ||
    in_range(id, 50, 51) ||
    id == 53 ||
    id == 61 ||
    id == 200 {
    Section5TemplateKnown(id)
  } else {
    Section5TemplateUnknown(id)
  }
}

///|
pub fn decode_parameter_name(
  discipline : Int,
  category : Int,
  parameter : Int,
) -> Grib2NameLookup {
  match (discipline, category, parameter) {
    (0, 0, 0) => NameKnown("TMP")
    (0, 1, 0) => NameKnown("SPFH")
    (0, 1, 1) => NameKnown("RH")
    (0, 1, 22) => NameKnown("CLMR")
    (0, 1, 23) => NameKnown("ICMR")
    (0, 1, 24) => NameKnown("RWMR")
    (0, 1, 25) => NameKnown("SNMR")
    (0, 1, 32) => NameKnown("GRLE")
    (0, 2, 0) => NameKnown("WDIR")
    (0, 2, 1) => NameKnown("WIND")
    (0, 2, 2) => NameKnown("UGRD")
    (0, 2, 3) => NameKnown("VGRD")
    (0, 2, 8) => NameKnown("VVEL")
    (0, 2, 9) => NameKnown("DZDT")
    (0, 2, 10) => NameKnown("ABSV")
    (0, 2, 192) => NameKnown("VWSH")
    (0, 3, 0) => NameKnown("PRES")
    (0, 3, 1) => NameKnown("PRMSL")
    (0, 3, 5) => NameKnown("HGT")
    (0, 6, 1) => NameKnown("TCDC")
    (0, 6, 3) => NameKnown("LCDC")
    (0, 6, 4) => NameKnown("MCDC")
    (0, 6, 5) => NameKnown("HCDC")
    (0, 14, 192) => NameKnown("O3MR")
    (2, 0, 196) => NameKnown("CNWAT")
    (2, 3, 192) => NameKnown("SOILL")
    (10, 0, 3) => NameKnown("HTSGW")
    (10, 0, 4) => NameKnown("WVDIR")
    (10, 0, 5) => NameKnown("WVHGT")
    (10, 0, 6) => NameKnown("WVPER")
    (10, 0, 7) => NameKnown("SWDIR")
    (10, 0, 8) => NameKnown("SWELL")
    (10, 0, 9) => NameKnown("SWPER")
    (10, 0, 10) => NameKnown("DIRPW")
    (10, 0, 11) => NameKnown("PERPW")
    (10, 2, 1) => NameKnown("ICETK")
    _ =>
      NameUnknown(
        "disc=" +
        discipline.to_string() +
        ",cat=" +
        category.to_string() +
        ",param=" +
        parameter.to_string(),
      )
  }
}

///|
fn format_decimal_tenths(value_x10 : Int) -> String {
  if value_x10 % 10 == 0 {
    (value_x10 / 10).to_string()
  } else {
    (value_x10 / 10).to_string() + "." + (value_x10 % 10).to_string()
  }
}

///|
pub fn decode_level_name(
  l1t : Int,
  l1sf : Int,
  l1v : Int,
  l2t : Int,
  l2sf : Int,
  l2v : Int,
) -> Grib2NameLookup {
  if l1t == 1 {
    return NameKnown("surface")
  }
  if l1t == 101 {
    return NameKnown("mean sea level")
  }
  if l1t == 241 && l1sf == 0 && l2t == 255 {
    return NameKnown(l1v.to_string() + " in sequence")
  }
  if l1t == 100 && l2t == 255 {
    let mb = if l1sf == 0 { l1v / 100 } else if l1sf == 130 { l1v } else { l1v }
    return NameKnown(mb.to_string() + " mb")
  }
  if l1t == 103 && l2t == 255 {
    return NameKnown(l1v.to_string() + " m above ground")
  }
  if l1t == 102 && l2t == 255 {
    return NameKnown(l1v.to_string() + " m above mean sea level")
  }
  if l1t == 106 && l1sf == 2 && l2t == 106 && l2sf == 2 {
    let top_x10 = l1v / 10
    let bot_x10 = l2v / 10
    return NameKnown(
      format_decimal_tenths(top_x10) +
      "-" +
      format_decimal_tenths(bot_x10) +
      " m below ground",
    )
  }
  if l1t == 108 && l1sf == 0 && l2t == 108 && l2sf == 0 {
    return NameKnown(
      (l1v / 100).to_string() +
      "-" +
      (l2v / 100).to_string() +
      " mb above ground",
    )
  }
  if l1t == 109 && l1sf == 9 && l2t == 255 {
    let magnitude = l1v & 0x7fffffff
    let pv_scaled = if l1v < 0 { -magnitude } else { magnitude }
    let pv_label = match pv_scaled {
      500 => "5e-07"
      1000 => "1e-06"
      1500 => "1.5e-06"
      -500 => "-5e-07"
      -1000 => "-1e-06"
      -1500 => "-1.5e-06"
      _ => pv_scaled.to_string() + "e-09"
    }
    return NameKnown("PV=" + pv_label + " (Km^2/kg/s) surface")
  }
  if l2t == 255 {
    return NameUnknown("type" + l1t.to_string())
  }
  NameUnknown("type" + l1t.to_string() + "-type" + l2t.to_string())
}

///|
fn format_tail(time_unit : Int, forecast_time : Int) -> String {
  if time_unit == 1 && forecast_time == 0 {
    "anl"
  } else if time_unit == 1 {
    forecast_time.to_string() + " hour fcst"
  } else if time_unit == 2 {
    forecast_time.to_string() + " day fcst"
  } else {
    "fcst"
  }
}

///|
pub fn decode_records(context : Grib2FileContext) -> Array[Grib2RecordMeta] {
  let records : Array[Grib2RecordMeta] = []
  let mut global_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    let submessage_count = message.submessages.length()
    let record_time = format_ref_time_yyyymmddhh(message)
    let section0_reserved = "0x" +
      hex_byte(message.raw[4]) +
      hex_byte(message.raw[5])
    for submessage_index in 0..<submessage_count {
      let submessage = message.submessages[submessage_index]
      let record_id = format_record_id(
        context,
        message_index + 1,
        submessage_index + 1,
        submessage_count,
        global_index,
      )
      let section3 = section_slice(message, submessage.section3)
      let section4 = section_slice(message, submessage.section4)
      let section5 = section_slice(message, submessage.section5)
      let section3_template_id = if section3.length() >= 14 {
        read_u16_be_from(section3, 12)
      } else {
        -1
      }
      let section3_gdef_source = if section3.length() >= 6 {
        section3[5].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_npts = if section3.length() >= 10 {
        read_u32_be_from(section3, 6)
      } else {
        0
      }
      let section4_template_id = if section4.length() >= 9 {
        read_u16_be_from(section4, 7)
      } else {
        -1
      }
      let section4_num_coord = if section4.length() >= 7 {
        read_u16_be_from(section4, 5)
      } else {
        0
      }
      let category = if section4.length() >= 11 {
        section4[9].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let parameter = if section4.length() >= 11 {
        section4[10].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let time_unit = if section4.length() >= 18 {
        section4[17].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let forecast_time = if section4.length() >= 22 {
        read_u32_be_from(section4, 18)
      } else {
        -1
      }
      let l1t = if section4.length() >= 23 {
        section4[22].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l1sf = if section4.length() >= 24 {
        section4[23].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l1v = if section4.length() >= 28 {
        read_u32_be_from(section4, 24)
      } else {
        -1
      }
      let l2t = if section4.length() >= 29 {
        section4[28].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l2sf = if section4.length() >= 30 {
        section4[29].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l2v = if section4.length() >= 34 {
        read_u32_be_from(section4, 30)
      } else {
        -1
      }
      let section5_template_id = if section5.length() >= 11 {
        read_u16_be_from(section5, 9)
      } else {
        -1
      }
      let parameter_name = if category >= 0 && parameter >= 0 {
        decode_parameter_name(message.discipline, category, parameter)
      } else {
        NameUnknown("category/parameter unavailable")
      }
      let level_name = if section4.length() >= 34 {
        decode_level_name(l1t, l1sf, l1v, l2t, l2sf, l2v)
      } else {
        NameUnknown("level unavailable")
      }
      records.push({
        record_index: global_index,
        record_id,
        message_offset: message.offset,
        message_total_length: message.total_length,
        reference_time: record_time,
        discipline: message.discipline,
        edition: message.edition,
        parameter_name,
        level_name,
        tail: format_tail(time_unit, forecast_time),
        section0_reserved,
        section3_template: decode_section3_template(section3_template_id),
        section4_template: decode_section4_template(section4_template_id),
        section5_template: decode_section5_template(section5_template_id),
        section3_length: submessage.section3.length,
        section3_gdef_source,
        section3_npts,
        section4_length: submessage.section4.length,
        section4_num_coord,
        section5_length: submessage.section5.length,
      })
      global_index += 1
    }
  }
  records
}
