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
  reference_time_full : String
  unix_rt : Int64
  unix_vt : Int64
  discipline : Int
  edition : Int
  section1_center : Int
  section1_subcenter : Int
  section1_master_tables_version : Int
  section1_local_tables_version : Int
  section1_significance_of_ref_time : Int
  section1_production_status : Int
  section1_data_type : Int
  parameter_name : Grib2NameLookup
  level_name : Grib2NameLookup
  tail : String
  section0_reserved : String
  section3_template : Grib2Section3Template
  section4_template : Grib2Section4Template
  section5_template : Grib2Section5Template
  section1_length : Int
  section2_length : Int
  section3_length : Int
  section3_reused : Bool
  section3_gdef_source : Int
  section3_npts : Int
  section3_ni : Int
  section3_nj : Int
  section3_resolution_flags : Int
  section3_lat1_microdeg : Int
  section3_lon1_microdeg : Int
  section3_lat2_microdeg : Int
  section3_lon2_microdeg : Int
  section3_di_microdeg : Int
  section3_dj_microdeg : Int
  section3_scanning_mode : Int
  section3_shape_of_earth : Int
  section3_scale_factor_radius : Int
  section3_scaled_value_radius : Int
  section3_scale_factor_major : Int
  section3_scaled_value_major : Int
  section3_scale_factor_minor : Int
  section3_scaled_value_minor : Int
  section4_length : Int
  section4_num_coord : Int
  section4_parameter_category : Int
  section4_parameter_number : Int
  section4_time_unit : Int
  section4_process_code : Int
  section4_ens_type : Int
  section4_ens_perturbation_number : Int
  section4_ens_member_count : Int
  section4_prob_forecast_index : Int
  section4_prob_total_forecasts : Int
  section4_prob_type : Int
  section4_prob_lower_scale_factor : Int
  section4_prob_lower_value : Int
  section4_prob_upper_scale_factor : Int
  section4_prob_upper_value : Int
  section4_first_surface_type : Int
  section4_second_surface_type : Int
  section4_background_process : Int
  section4_forecast_process : Int
  section5_length : Int
  section5_num_defined_points : Int
  section5_reference_value_ieee : Int
  section5_binary_scale_factor : Int
  section5_decimal_scale_factor : Int
  section5_bits_per_value : Int
  section6_length : Int
  section6_bitmap_indicator : Int
  section6_undef_points : Int
  section7_length : Int
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
  binary_read_u16_be_view(bytes, index)
}

///|
fn read_u32_be_from(bytes : BytesView, index : Int) -> Int {
  binary_read_u32_be_view(bytes, index)
}

///|
fn read_i16_be_from(bytes : BytesView, index : Int) -> Int {
  let unsigned = binary_read_u16_be_view(bytes, index)
  if unsigned >= 0x8000 {
    unsigned - 0x10000
  } else {
    unsigned
  }
}

///|
fn read_i16_sign_magnitude_from(bytes : BytesView, index : Int) -> Int {
  let unsigned = binary_read_u16_be_view(bytes, index)
  let magnitude = unsigned & 0x7FFF
  if (unsigned & 0x8000) != 0 {
    -magnitude
  } else {
    magnitude
  }
}

///|
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
  match decode_message_section1(message) {
    Ok(section1) =>
      pad_zero(section1.reference_year, 4) +
      pad_zero(section1.reference_month, 2) +
      pad_zero(section1.reference_day, 2) +
      pad_zero(section1.reference_hour, 2)
    Err(_) => {
      let section1 = section_slice(message, message.section1)
      if section1.length() < 20 {
        return "0000000000"
      }
      let year = read_u16_be_from(section1, 12)
      let month = section1[14].to_uint().reinterpret_as_int()
      let day = section1[15].to_uint().reinterpret_as_int()
      let hour = section1[16].to_uint().reinterpret_as_int()
      pad_zero(year, 4) + pad_zero(month, 2) + pad_zero(day, 2) + pad_zero(hour, 2)
    }
  }
}

///|
fn format_ref_time_yyyymmddhhmmss(message : Grib2MessageContext) -> String {
  match decode_message_section1(message) {
    Ok(section1) =>
      pad_zero(section1.reference_year, 4) +
      pad_zero(section1.reference_month, 2) +
      pad_zero(section1.reference_day, 2) +
      pad_zero(section1.reference_hour, 2) +
      pad_zero(section1.reference_minute, 2) +
      pad_zero(section1.reference_second, 2)
    Err(_) => {
      let section1 = section_slice(message, message.section1)
      if section1.length() < 20 {
        return "00000000000000"
      }
      let year = read_u16_be_from(section1, 12)
      let month = section1[14].to_uint().reinterpret_as_int()
      let day = section1[15].to_uint().reinterpret_as_int()
      let hour = section1[16].to_uint().reinterpret_as_int()
      let minute = section1[17].to_uint().reinterpret_as_int()
      let second = section1[18].to_uint().reinterpret_as_int()
      pad_zero(year, 4) +
      pad_zero(month, 2) +
      pad_zero(day, 2) +
      pad_zero(hour, 2) +
      pad_zero(minute, 2) +
      pad_zero(second, 2)
    }
  }
}

///|
fn compute_ref_time_unix(message : Grib2MessageContext) -> Int64 {
  match decode_message_section1(message) {
    Ok(section1) =>
      datetime_to_unix(
        section1.reference_year,
        section1.reference_month,
        section1.reference_day,
        section1.reference_hour,
        section1.reference_minute,
        section1.reference_second,
      )
    Err(_) => {
      let section1 = section_slice(message, message.section1)
      if section1.length() < 20 {
        return 0L
      }
      let year = read_u16_be_from(section1, 12)
      let month = section1[14].to_uint().reinterpret_as_int()
      let day = section1[15].to_uint().reinterpret_as_int()
      let hour = section1[16].to_uint().reinterpret_as_int()
      let minute = section1[17].to_uint().reinterpret_as_int()
      let second = section1[18].to_uint().reinterpret_as_int()
      datetime_to_unix(year, month, day, hour, minute, second)
    }
  }
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
  if discipline == 0 && category == 0 {
    return decode_parameter_number_4_2_0_0_name(parameter)
  }
  if discipline == 0 && category == 1 {
    return decode_parameter_number_4_2_0_1_name(parameter)
  }
  if discipline == 0 && category == 2 {
    return decode_parameter_number_4_2_0_2_name(parameter)
  }
  if discipline == 0 && category == 3 {
    return decode_parameter_number_4_2_0_3_name(parameter)
  }
  if discipline == 0 && category == 4 {
    return decode_parameter_number_4_2_0_4_name(parameter)
  }
  if discipline == 0 && category == 5 {
    return decode_parameter_number_4_2_0_5_name(parameter)
  }
  if discipline == 0 && category == 6 {
    return decode_parameter_number_4_2_0_6_name(parameter)
  }
  if discipline == 0 && category == 7 {
    return decode_parameter_number_4_2_0_7_name(parameter)
  }
  if discipline == 0 && category == 13 {
    return decode_parameter_number_4_2_0_13_name(parameter)
  }
  if discipline == 0 && category == 14 {
    return decode_parameter_number_4_2_0_14_name(parameter)
  }
  if discipline == 0 && category == 15 {
    return decode_parameter_number_4_2_0_15_name(parameter)
  }
  if discipline == 0 && category == 16 {
    return decode_parameter_number_4_2_0_16_name(parameter)
  }
  if discipline == 0 && category == 17 {
    return decode_parameter_number_4_2_0_17_name(parameter)
  }
  if discipline == 0 && category == 18 {
    return decode_parameter_number_4_2_0_18_name(parameter)
  }
  if discipline == 0 && category == 19 {
    return decode_parameter_number_4_2_0_19_name(parameter)
  }
  if discipline == 0 && category == 190 {
    return decode_parameter_number_4_2_0_190_name(parameter)
  }
  if discipline == 0 && category == 191 {
    return decode_parameter_number_4_2_0_191_name(parameter)
  }
  if discipline == 0 && category == 192 {
    return decode_parameter_number_4_2_0_192_name(parameter)
  }
  if discipline == 1 && category == 0 {
    return decode_parameter_number_4_2_1_0_name(parameter)
  }
  if discipline == 1 && category == 1 {
    return decode_parameter_number_4_2_1_1_name(parameter)
  }
  if discipline == 1 && category == 2 {
    return decode_parameter_number_4_2_1_2_name(parameter)
  }
  if discipline == 2 && category == 0 {
    return decode_parameter_number_4_2_2_0_name(parameter)
  }
  if discipline == 2 && category == 1 {
    return decode_parameter_number_4_2_2_1_name(parameter)
  }
  if discipline == 2 && category == 3 {
    return decode_parameter_number_4_2_2_3_name(parameter)
  }
  if discipline == 2 && category == 4 {
    return decode_parameter_number_4_2_2_4_name(parameter)
  }
  if discipline == 2 && category == 5 {
    return decode_parameter_number_4_2_2_5_name(parameter)
  }
  if discipline == 2 && category == 6 {
    return decode_parameter_number_4_2_2_6_name(parameter)
  }
  if discipline == 2 && category == 7 {
    return decode_parameter_number_4_2_2_7_name(parameter)
  }
  if discipline == 3 && category == 0 {
    return decode_parameter_number_4_2_3_0_name(parameter)
  }
  if discipline == 3 && category == 1 {
    return decode_parameter_number_4_2_3_1_name(parameter)
  }
  if discipline == 3 && category == 2 {
    return decode_parameter_number_4_2_3_2_name(parameter)
  }
  if discipline == 3 && category == 3 {
    return decode_parameter_number_4_2_3_3_name(parameter)
  }
  if discipline == 3 && category == 4 {
    return decode_parameter_number_4_2_3_4_name(parameter)
  }
  if discipline == 3 && category == 5 {
    return decode_parameter_number_4_2_3_5_name(parameter)
  }
  if discipline == 3 && category == 6 {
    return decode_parameter_number_4_2_3_6_name(parameter)
  }
  if discipline == 3 && category == 192 {
    return decode_parameter_number_4_2_3_192_name(parameter)
  }
  if discipline == 4 && category == 0 {
    return decode_parameter_number_4_2_4_0_name(parameter)
  }
  if discipline == 4 && category == 1 {
    return decode_parameter_number_4_2_4_1_name(parameter)
  }
  if discipline == 4 && category == 2 {
    return decode_parameter_number_4_2_4_2_name(parameter)
  }
  if discipline == 4 && category == 3 {
    return decode_parameter_number_4_2_4_3_name(parameter)
  }
  if discipline == 4 && category == 4 {
    return decode_parameter_number_4_2_4_4_name(parameter)
  }
  if discipline == 4 && category == 5 {
    return decode_parameter_number_4_2_4_5_name(parameter)
  }
  if discipline == 4 && category == 6 {
    return decode_parameter_number_4_2_4_6_name(parameter)
  }
  if discipline == 4 && category == 7 {
    return decode_parameter_number_4_2_4_7_name(parameter)
  }
  if discipline == 4 && category == 8 {
    return decode_parameter_number_4_2_4_8_name(parameter)
  }
  if discipline == 4 && category == 9 {
    return decode_parameter_number_4_2_4_9_name(parameter)
  }
  if discipline == 4 && category == 10 {
    return decode_parameter_number_4_2_4_10_name(parameter)
  }
  if discipline == 10 && category == 0 {
    return decode_parameter_number_4_2_10_0_name(parameter)
  }
  if discipline == 10 && category == 1 {
    return decode_parameter_number_4_2_10_1_name(parameter)
  }
  if discipline == 10 && category == 2 {
    return decode_parameter_number_4_2_10_2_name(parameter)
  }
  if discipline == 10 && category == 3 {
    return decode_parameter_number_4_2_10_3_name(parameter)
  }
  if discipline == 10 && category == 4 {
    return decode_parameter_number_4_2_10_4_name(parameter)
  }
  if discipline == 10 && category == 191 {
    return decode_parameter_number_4_2_10_191_name(parameter)
  }
  if discipline == 20 && category == 0 {
    return decode_parameter_number_4_2_20_0_name(parameter)
  }
  if discipline == 20 && category == 1 {
    return decode_parameter_number_4_2_20_1_name(parameter)
  }
  if discipline == 20 && category == 2 {
    return decode_parameter_number_4_2_20_2_name(parameter)
  }
  if discipline == 20 && category == 3 {
    return decode_parameter_number_4_2_20_3_name(parameter)
  }
  if discipline == 20 && category == 4 {
    return decode_parameter_number_4_2_20_4_name(parameter)
  }
  if discipline == 20 && category == 5 {
    return decode_parameter_number_4_2_20_5_name(parameter)
  }
  if discipline == 191 && category == 0 {
    return decode_parameter_number_4_2_191_0_name(parameter)
  }
  match (discipline, category, parameter) {
    (2, 0, 196) => NameKnown("CNWAT")
    (2, 3, 192) => NameKnown("SOILL")
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
fn trim_trailing_zeroes(text : String) -> String {
  let mut end = text.length()
  while end > 0 && text[end - 1].to_int() == '0'.to_int() {
    end -= 1
  }
  text[:end].to_string()
}

///|
fn format_scaled_decimal(value : Int, scale : Int) -> String {
  let negative = value < 0
  let magnitude = if negative { -value } else { value }
  if scale <= 0 {
    let mut out = magnitude.to_string()
    for _ in 0..<-scale {
      out += "0"
    }
    if negative {
      "-" + out
    } else {
      out
    }
  } else {
    let digits = magnitude.to_string()
    let out = if digits.length() > scale {
      let split_at = digits.length() - scale
      let whole = digits[:split_at].to_string()
      let fraction = trim_trailing_zeroes(digits[split_at:].to_string())
      if fraction == "" {
        whole
      } else {
        whole + "." + fraction
      }
    } else {
      let zeros = "0".repeat(scale - digits.length())
      let fraction = trim_trailing_zeroes(zeros + digits)
      if fraction == "" {
        "0"
      } else {
        "0." + fraction
      }
    }
    if negative {
      "-" + out
    } else {
      out
    }
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
    let scale_magnitude = l1sf & 0x7F
    let scale = if (l1sf & 0x80) != 0 {
      -scale_magnitude
    } else {
      scale_magnitude
    }
    return NameKnown(format_scaled_decimal(l1v, scale + 2) + " mb")
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
  if l1t == 104 && l2t == 104 {
    return NameKnown(
      format_scaled_decimal(l1v, l1sf) +
      "-" +
      format_scaled_decimal(l2v, l2sf) +
      " sigma layer",
    )
  }
  if l1t == 104 && l2t == 255 {
    return NameKnown(format_scaled_decimal(l1v, l1sf) + " sigma level")
  }
  if l1t == 109 && l1sf == 9 && l2t == 255 {
    let magnitude = l1v & 0x7fffffff
    let pv_scaled = if l1v < 0 { -magnitude } else { magnitude }
    let pv_label = match pv_scaled {
      500 => "5e-07"
      1000 => "1e-06"
      1500 => "1.5e-06"
      2000 => "2e-06"
      -500 => "-5e-07"
      -1000 => "-1e-06"
      -1500 => "-1.5e-06"
      -2000 => "-2e-06"
      _ => pv_scaled.to_string() + "e-09"
    }
    return NameKnown("PV=" + pv_label + " (Km^2/kg/s) surface")
  }
  // Type 105: Hybrid level
  if l1t == 105 && l2t == 255 {
    return NameKnown(l1v.to_string() + " hybrid level")
  }
  // Type 10: Entire atmosphere (considered as a single layer)
  if l1t == 10 && l2t == 255 {
    return NameKnown("entire atmosphere")
  }
  // Type 8: Nominal top of atmosphere
  if l1t == 8 && l2t == 255 {
    return NameKnown("top of atmosphere")
  }
  // Type 200: Entire atmosphere (considered as a single layer)
  if l1t == 200 && l2t == 255 {
    return NameKnown("entire atmosphere (considered as a single layer)")
  }
  // Type 214/224/234: cloud layer categories
  if l1t == 214 && l2t == 255 {
    return NameKnown("low cloud layer")
  }
  if l1t == 224 && l2t == 255 {
    return NameKnown("middle cloud layer")
  }
  if l1t == 234 && l2t == 255 {
    return NameKnown("high cloud layer")
  }
  // Type 215: cloud ceiling
  if l1t == 215 && l2t == 255 {
    return NameKnown("cloud ceiling")
  }
  // Type 220: Planetary boundary layer
  if l1t == 220 && l2t == 255 {
    return NameKnown("planetary boundary layer")
  }
  // Type 204: Highest tropospheric freezing level
  if l1t == 204 && l2t == 255 {
    return NameKnown("highest tropospheric freezing level")
  }
  // Type 2: Cloud base level
  if l1t == 2 && l2t == 255 {
    return NameKnown("cloud base")
  }
  // Type 3: Cloud top level
  if l1t == 3 && l2t == 255 {
    return NameKnown("cloud top")
  }
  // Type 6: Maximum wind level
  if l1t == 6 && l2t == 255 {
    return NameKnown("max wind")
  }
  // Type 7: Tropopause
  if l1t == 7 && l2t == 255 {
    return NameKnown("tropopause")
  }
  // Type 4: Level of 0°C isotherm
  if l1t == 4 && l2t == 255 {
    return NameKnown("0C isotherm")
  }
  if l1t == 103 && l2t == 103 {
    return NameKnown(
      l1v.to_string() + "-" + l2v.to_string() + " m above ground",
    )
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
    let record_time_full = format_ref_time_yyyymmddhhmmss(message)
    let record_unix_rt = compute_ref_time_unix(message)
    let section1 = section_slice(message, message.section1)
    let section1_center = if section1.length() >= 9 {
      read_u16_be_from(section1, 5)
    } else {
      -1
    }
    let section1_subcenter = if section1.length() >= 11 {
      read_u16_be_from(section1, 7)
    } else {
      -1
    }
    let section1_master_tables_version = if section1.length() >= 10 {
      section1[9].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_local_tables_version = if section1.length() >= 11 {
      section1[10].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_significance_of_ref_time = if section1.length() >= 12 {
      section1[11].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_production_status = if section1.length() >= 20 {
      section1[19].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_data_type = if section1.length() >= 21 {
      section1[20].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section0_reserved = "0x" +
      hex_byte(message.raw[4]) +
      hex_byte(message.raw[5])
    let mut previous_submessage_end = -1
    for submessage_index in 0..<submessage_count {
      let submessage = message.submessages[submessage_index]
      let record_id = format_record_id(
        context,
        message_index + 1,
        submessage_index + 1,
        submessage_count,
        global_index,
      )
      let section2_length = match submessage.section2 {
        Some(section2) => section2.length
        None => 0
      }
      let section3 = section_slice(message, submessage.section3)
      let section4 = section_slice(message, submessage.section4)
      let section5 = section_slice(message, submessage.section5)
      let section6 = section_slice(message, submessage.section6)
      let section3_template_id = if section3.length() >= 14 {
        read_u16_be_from(section3, 12)
      } else {
        -1
      }
      let section3_reused = if submessage_index == 0 {
        false
      } else {
        submessage.section3.start < previous_submessage_end
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
      let section3_ni = if section3_template_id == 0 && section3.length() >= 34 {
        read_u32_be_from(section3, 30)
      } else {
        -1
      }
      let section3_nj = if section3_template_id == 0 && section3.length() >= 38 {
        read_u32_be_from(section3, 34)
      } else {
        -1
      }
      let section3_resolution_flags = if section3_template_id == 0 &&
        section3.length() >= 55 {
        section3[54].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_lat1_microdeg = if section3_template_id == 0 &&
        section3.length() >= 50 {
        read_i32_sign_magnitude_from(section3, 46)
      } else {
        -1
      }
      let section3_lon1_microdeg = if section3_template_id == 0 &&
        section3.length() >= 54 {
        read_i32_sign_magnitude_from(section3, 50)
      } else {
        -1
      }
      let section3_lat2_microdeg = if section3_template_id == 0 &&
        section3.length() >= 59 {
        read_i32_sign_magnitude_from(section3, 55)
      } else {
        -1
      }
      let section3_lon2_microdeg = if section3_template_id == 0 &&
        section3.length() >= 63 {
        read_i32_sign_magnitude_from(section3, 59)
      } else {
        -1
      }
      let section3_di_microdeg = if section3_template_id == 0 &&
        section3.length() >= 67 {
        read_u32_be_from(section3, 63)
      } else {
        -1
      }
      let section3_dj_microdeg = if section3_template_id == 0 &&
        section3.length() >= 71 {
        read_u32_be_from(section3, 67)
      } else {
        -1
      }
      let section3_scanning_mode = if section3_template_id == 0 &&
        section3.length() >= 72 {
        section3[71].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Earth shape parameters from template payload (template 3.0 and similar)
      let section3_shape_of_earth = if section3.length() >= 15 {
        section3[14].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_scale_factor_radius = if section3.length() >= 16 {
        section3[15].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_scaled_value_radius = if section3.length() >= 20 {
        read_u32_be_from(section3, 16)
      } else {
        0
      }
      let section3_scale_factor_major = if section3.length() >= 21 {
        section3[20].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_scaled_value_major = if section3.length() >= 25 {
        read_u32_be_from(section3, 21)
      } else {
        0
      }
      let section3_scale_factor_minor = if section3.length() >= 26 {
        section3[25].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_scaled_value_minor = if section3.length() >= 30 {
        read_u32_be_from(section3, 26)
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
      let section4_process_code = if section4.length() >= 12 {
        section4[11].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_background_process = if section4.length() >= 13 {
        section4[12].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_forecast_process = if section4.length() >= 14 {
        section4[13].to_uint().reinterpret_as_int()
      } else {
        -1
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
      let section4_ens_type = if (
          section4_template_id == 1 ||
          section4_template_id == 11 ||
          section4_template_id == 2 ||
          section4_template_id == 12
        ) &&
        section4.length() >= 35 {
        section4[34].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_ens_perturbation_number = if (
          section4_template_id == 1 || section4_template_id == 11
        ) &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_ens_member_count = if (
          section4_template_id == 1 || section4_template_id == 11
        ) &&
        section4.length() >= 37 {
        section4[36].to_uint().reinterpret_as_int()
      } else if (section4_template_id == 2 || section4_template_id == 12) &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_forecast_index = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 35 {
        section4[34].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_total_forecasts = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_type = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 37 {
        section4[36].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_lower_scale_factor = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 38 {
        read_signed_byte_from(section4, 37)
      } else {
        0
      }
      let section4_prob_lower_value = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 42 {
        read_i32_sign_magnitude_from(section4, 38)
      } else {
        -1
      }
      let section4_prob_upper_scale_factor = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 43 {
        read_signed_byte_from(section4, 42)
      } else {
        0
      }
      let section4_prob_upper_value = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 47 {
        read_i32_sign_magnitude_from(section4, 43)
      } else {
        -1
      }
      let section5_template_id = if section5.length() >= 11 {
        read_u16_be_from(section5, 9)
      } else {
        -1
      }
      let section5_num_defined_points = if section5.length() >= 9 {
        read_u32_be_from(section5, 5)
      } else {
        0
      }
      // Section 5 scaling parameters (for templates 50, 51, 52, 53, 540, 541, 542, etc.)
      // Bytes 12-15: Reference value (IEEE 754 float stored as 4-byte int)
      // Bytes 16-17: Binary scale factor (signed 16-bit)
      // Bytes 18-19: Decimal scale factor (signed 16-bit)
      // Byte 20: Number of bits per value
      let section5_reference_value_ieee = if section5.length() >= 15 {
        read_u32_be_from(section5, 11)
      } else {
        0
      }
      let section5_binary_scale_factor = if section5.length() >= 17 {
        read_i16_sign_magnitude_from(section5, 15)
      } else {
        0
      }
      let section5_decimal_scale_factor = if section5.length() >= 19 {
        read_i16_sign_magnitude_from(section5, 17)
      } else {
        0
      }
      let section5_bits_per_value = if section5.length() >= 20 {
        section5[19].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section6_bitmap_indicator = if section6.length() >= 6 {
        section6[5].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section6_undef_points = if section6_bitmap_indicator == 0 {
        count_bitmap_undefined_points(section6, section3_npts)
      } else {
        0
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
        reference_time_full: record_time_full,
        unix_rt: record_unix_rt,
        unix_vt: record_unix_rt, // TODO: add forecast time offset for actual verification time
        discipline: message.discipline,
        edition: message.edition,
        section1_center,
        section1_subcenter,
        section1_master_tables_version,
        section1_local_tables_version,
        section1_significance_of_ref_time,
        section1_production_status,
        section1_data_type,
        parameter_name,
        level_name,
        tail: format_tail(time_unit, forecast_time),
        section0_reserved,
        section3_template: decode_section3_template(section3_template_id),
        section4_template: decode_section4_template(section4_template_id),
        section5_template: decode_section5_template(section5_template_id),
        section1_length: message.section1.length,
        section2_length,
        section3_length: submessage.section3.length,
        section3_reused,
        section3_gdef_source,
        section3_npts,
        section3_ni,
        section3_nj,
        section3_resolution_flags,
        section3_lat1_microdeg,
        section3_lon1_microdeg,
        section3_lat2_microdeg,
        section3_lon2_microdeg,
        section3_di_microdeg,
        section3_dj_microdeg,
        section3_scanning_mode,
        section3_shape_of_earth,
        section3_scale_factor_radius,
        section3_scaled_value_radius,
        section3_scale_factor_major,
        section3_scaled_value_major,
        section3_scale_factor_minor,
        section3_scaled_value_minor,
        section4_length: submessage.section4.length,
        section4_num_coord,
        section4_parameter_category: category,
        section4_parameter_number: parameter,
        section4_time_unit: time_unit,
        section4_process_code,
        section4_ens_type,
        section4_ens_perturbation_number,
        section4_ens_member_count,
        section4_prob_forecast_index,
        section4_prob_total_forecasts,
        section4_prob_type,
        section4_prob_lower_scale_factor,
        section4_prob_lower_value,
        section4_prob_upper_scale_factor,
        section4_prob_upper_value,
        section4_first_surface_type: l1t,
        section4_second_surface_type: l2t,
        section4_background_process,
        section4_forecast_process,
        section5_length: submessage.section5.length,
        section5_num_defined_points,
        section5_reference_value_ieee,
        section5_binary_scale_factor,
        section5_decimal_scale_factor,
        section5_bits_per_value,
        section6_length: submessage.section6.length,
        section6_bitmap_indicator,
        section6_undef_points,
        section7_length: submessage.section7.length,
      })
      previous_submessage_end = submessage.section7.end_offset()
      global_index += 1
    }
  }
  records
}
