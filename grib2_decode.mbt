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
fn is_leap_year(year : Int) -> Bool {
  (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
}

///|
fn days_in_month(year : Int, month : Int) -> Int {
  match month {
    1 => 31
    2 => if is_leap_year(year) { 29 } else { 28 }
    3 => 31
    4 => 30
    5 => 31
    6 => 30
    7 => 31
    8 => 31
    9 => 30
    10 => 31
    11 => 30
    12 => 31
    _ => 0
  }
}

///|
fn datetime_to_unix(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Int64 {
  // Days from 1970-01-01 to the start of the year
  let mut days : Int64 = 0L
  for y in 1970..<year {
    days += if is_leap_year(y) { 366L } else { 365L }
  }
  // Days in months before current month
  for m in 1..<month {
    days += days_in_month(year, m).to_int64()
  }
  // Days in current month
  days += (day - 1).to_int64()
  // Convert to seconds and add time
  days * 86400L +
  hour.to_int64() * 3600L +
  minute.to_int64() * 60L +
  second.to_int64()
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
  match decode_message_section1(message) {
    Ok(section1) =>
      pad4(section1.reference_year) +
      pad2(section1.reference_month) +
      pad2(section1.reference_day) +
      pad2(section1.reference_hour)
    Err(_) => {
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
  }
}

///|
fn format_ref_time_yyyymmddhhmmss(message : Grib2MessageContext) -> String {
  match decode_message_section1(message) {
    Ok(section1) =>
      pad4(section1.reference_year) +
      pad2(section1.reference_month) +
      pad2(section1.reference_day) +
      pad2(section1.reference_hour) +
      pad2(section1.reference_minute) +
      pad2(section1.reference_second)
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
      pad4(year) +
      pad2(month) +
      pad2(day) +
      pad2(hour) +
      pad2(minute) +
      pad2(second)
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
pub fn decode_discipline_name(discipline : Int) -> Grib2NameLookup {
  match discipline {
    0 => NameKnown("Meteorological Products")
    1 => NameKnown("Hydrological Products")
    2 => NameKnown("Land Surface Products")
    3 => NameKnown("Satellite Remote Sensing Products")
    4 => NameKnown("Space Weather Products")
    10 => NameKnown("Oceanographic Products")
    20 => NameKnown("Health and Socioeconomic Impacts")
    191 => NameKnown("Computational Parameters")
    255 => NameKnown("Missing")
    _ => NameUnknown("discipline=" + discipline.to_string())
  }
}

///|
pub fn decode_master_table_version_name(version : Int) -> Grib2NameLookup {
  if version == 0 {
    return NameKnown("Experimental")
  }
  if version == 1 {
    return NameKnown("Operational")
  }
  if version == 255 {
    return NameKnown("Missing")
  }
  if version > 1 && version < 255 {
    return NameKnown("Version " + version.to_string())
  }
  NameUnknown("master_table_version=" + version.to_string())
}

///|
pub fn decode_local_table_version_name(version : Int) -> Grib2NameLookup {
  if version == 0 {
    return NameKnown("Not Used")
  }
  if version == 255 {
    return NameKnown("Missing")
  }
  if version > 0 && version < 255 {
    return NameKnown("Version " + version.to_string())
  }
  NameUnknown("local_table_version=" + version.to_string())
}

///|
pub fn decode_significance_of_reference_time_name(
  significance : Int,
) -> Grib2NameLookup {
  match significance {
    0 => NameKnown("Analysis")
    1 => NameKnown("Start of Forecast")
    2 => NameKnown("Verifying Time of Forecast")
    3 => NameKnown("Observation Time")
    4 => NameKnown("Local Time")
    5 => NameKnown("Simulation Start")
    6 => NameKnown("Start of Data Assimilation")
    255 => NameKnown("Missing")
    _ =>
      if significance >= 7 && significance <= 191 {
        NameKnown("Reserved")
      } else if significance >= 192 && significance <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("reference_time_significance=" + significance.to_string())
      }
  }
}

///|
pub fn decode_production_status_name(status : Int) -> Grib2NameLookup {
  match status {
    0 => NameKnown("Operational Products")
    1 => NameKnown("Operational Test Products")
    2 => NameKnown("Research Products")
    3 => NameKnown("Re-Analysis Products")
    4 => NameKnown("TIGGE")
    5 => NameKnown("TIGGE Test")
    6 => NameKnown("S2S Operational Products")
    7 => NameKnown("S2S Test Products")
    8 => NameKnown("UERRA")
    9 => NameKnown("UERRA Test")
    10 => NameKnown("Copernicus Regional Reanalysis")
    11 => NameKnown("Copernicus Regional Reanalysis Test")
    12 => NameKnown("Destination Earth")
    13 => NameKnown("Destination Earth Test")
    14 => NameKnown("LC-GCR")
    15 => NameKnown("LC-GCR Test")
    16 => NameKnown("MLMIP")
    17 => NameKnown("MLMIP Test")
    255 => NameKnown("Missing")
    _ =>
      if status >= 18 && status <= 191 {
        NameKnown("Reserved")
      } else if status >= 192 && status <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("production_status=" + status.to_string())
      }
  }
}

///|
pub fn decode_processed_data_type_name(data_type : Int) -> Grib2NameLookup {
  match data_type {
    0 => NameKnown("Analysis Products")
    1 => NameKnown("Forecast Products")
    2 => NameKnown("Analysis and Forecast Products")
    3 => NameKnown("Control Forecast Products")
    4 => NameKnown("Perturbed Forecast Products")
    5 => NameKnown("Control and Perturbed Forecast Products")
    6 => NameKnown("Processed Satellite Observations")
    7 => NameKnown("Processed Radar Observations")
    8 => NameKnown("Event Probability")
    9 => NameKnown("Experimental Data")
    10 => NameKnown("ML Based Forecast")
    192 => NameKnown("Experimental Products")
    255 => NameKnown("Missing")
    _ =>
      if data_type >= 11 && data_type <= 191 {
        NameKnown("Reserved")
      } else if data_type >= 193 && data_type <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("processed_data_type=" + data_type.to_string())
      }
  }
}

///|
pub fn decode_identification_template_number_name(
  template_number : Int,
) -> Grib2NameLookup {
  match template_number {
    0 => NameKnown("Calendar Definition")
    1 => NameKnown("Paleontological Offset")
    2 => NameKnown("Calendar Definition and Paleontological Offset")
    65535 => NameKnown("Missing")
    _ =>
      if template_number >= 3 && template_number <= 32767 {
        NameKnown("Reserved")
      } else if template_number >= 32768 && template_number <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("id_template_number=" + template_number.to_string())
      }
  }
}

///|
pub fn decode_calendar_type_name(calendar_type : Int) -> Grib2NameLookup {
  match calendar_type {
    0 => NameKnown("Gregorian")
    1 => NameKnown("360-day")
    2 => NameKnown("365-day")
    3 => NameKnown("Proleptic Gregorian")
    255 => NameKnown("Missing")
    _ =>
      if calendar_type >= 4 && calendar_type <= 191 {
        NameKnown("Reserved")
      } else if calendar_type >= 192 && calendar_type <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("calendar_type=" + calendar_type.to_string())
      }
  }
}

///|
pub fn decode_grid_definition_source_name(source : Int) -> Grib2NameLookup {
  match source {
    0 => NameKnown("Specified in Table 3.1")
    1 => NameKnown("Predetermined Grid Definition")
    255 => NameKnown("Grid Definition Does Not Apply")
    _ =>
      if source >= 2 && source <= 191 {
        NameKnown("Reserved")
      } else if source >= 192 && source <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("grid_definition_source=" + source.to_string())
      }
  }
}

///|
pub fn decode_grid_definition_template_number_name(
  template_number : Int,
) -> Grib2NameLookup {
  match template_number {
    0 => NameKnown("Latitude/Longitude")
    1 => NameKnown("Rotated Latitude/Longitude")
    2 => NameKnown("Stretched Latitude/Longitude")
    3 => NameKnown("Rotated and Stretched Latitude/Longitude")
    4 => NameKnown("Variable Resolution Latitude/Longitude")
    5 => NameKnown("Variable Resolution Rotated Latitude/Longitude")
    10 => NameKnown("Mercator")
    12 => NameKnown("Transverse Mercator")
    13 => NameKnown("Mercator with Modelling Subdomains")
    20 => NameKnown("Polar Stereographic Projection")
    23 => NameKnown("Polar Stereographic with Modelling Subdomains")
    30 => NameKnown("Lambert Conformal")
    31 => NameKnown("Albers Equal Area")
    33 => NameKnown("Lambert Conformal with Modelling Subdomains")
    40 => NameKnown("Gaussian Latitude/Longitude")
    41 => NameKnown("Rotated Gaussian Latitude/Longitude")
    42 => NameKnown("Stretched Gaussian Latitude/Longitude")
    43 => NameKnown("Rotated and Stretched Gaussian Latitude/Longitude")
    50 => NameKnown("Spherical Harmonic Coefficients")
    51 => NameKnown("Rotated Spherical Harmonic Coefficients")
    52 => NameKnown("Stretched Spherical Harmonic Coefficients")
    53 => NameKnown("Rotated and Stretched Spherical Harmonic Coefficients")
    60 => NameKnown("Cubed-Sphere Gnomonic")
    61 => NameKnown("Spectral Mercator with Modelling Subdomains")
    62 => NameKnown("Spectral Polar Stereographic with Modelling Subdomains")
    63 => NameKnown("Spectral Lambert Conformal with Modelling Subdomains")
    90 => NameKnown("Space View Perspective or Orthographic")
    100 => NameKnown("Triangular Grid Based on an Icosahedron")
    101 => NameKnown("General Unstructured Grid")
    110 => NameKnown("Equatorial Azimuthal Equidistant Projection")
    120 => NameKnown("Azimuth-Range Projection")
    140 => NameKnown("Lambert Azimuthal Equal Area Projection")
    150 => NameKnown("HEALPix")
    204 => NameKnown("Curvilinear Orthogonal Grids")
    1000 => NameKnown("Cross Section Grid")
    1100 => NameKnown("Hovmoller Diagram")
    1200 => NameKnown("Time Section Grid")
    32768 => NameKnown("Rotated Latitude/Longitude (Arakawa Staggered E-Grid)")
    32769 =>
      NameKnown("Rotated Latitude/Longitude (Arakawa Non-E Staggered Grid)")
    65535 => NameKnown("Missing")
    _ =>
      if template_number >= 0 && template_number <= 32767 {
        NameKnown("Reserved")
      } else if template_number >= 32770 && template_number <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("grid_definition_template=" + template_number.to_string())
      }
  }
}

///|
pub fn decode_shape_of_reference_system_name(shape : Int) -> Grib2NameLookup {
  match shape {
    0 => NameKnown("Spherical Earth (Radius 6367470.0 m)")
    1 => NameKnown("Spherical Earth (Radius Specified by Producer)")
    2 => NameKnown("Oblate Spheroid Earth (IAU 1965)")
    3 => NameKnown("Oblate Spheroid Earth (Axes in km by Producer)")
    4 => NameKnown("Oblate Spheroid Earth (IAG-GRS80)")
    5 => NameKnown("Earth Represented by WGS84")
    6 => NameKnown("Spherical Earth (Radius 6371229.0 m)")
    7 => NameKnown("Oblate Spheroid Earth (Axes in m by Producer)")
    8 =>
      NameKnown(
        "Spherical Earth (Radius 6371200 m) with WGS84 Latitude/Longitude Datum",
      )
    9 => NameKnown("OSGB 1936 Datum (Airy 1830)")
    10 => NameKnown("WGS84 with Corrected Geomagnetic Coordinates")
    11 => NameKnown("Sun Spherical Reference System")
    255 => NameKnown("Missing")
    _ =>
      if shape >= 12 && shape <= 191 {
        NameKnown("Reserved")
      } else if shape >= 192 && shape <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("reference_system_shape=" + shape.to_string())
      }
  }
}

///|
fn decode_flag_bit(flags : Int, bit_no : Int) -> Bool {
  let mask = 1 << (8 - bit_no)
  (flags & mask) != 0
}

///|
pub fn decode_resolution_and_component_flags_name(
  flags : Int,
) -> Grib2NameLookup {
  if flags < 0 || flags > 255 {
    return NameUnknown("resolution_component_flags=" + flags.to_string())
  }
  let i_increment = if decode_flag_bit(flags, 3) {
    "given"
  } else {
    "not_given"
  }
  let j_increment = if decode_flag_bit(flags, 4) {
    "given"
  } else {
    "not_given"
  }
  let vector_component_mode = if decode_flag_bit(flags, 5) {
    "grid_relative"
  } else {
    "earth_relative"
  }
  NameKnown(
    "i_increment=" +
    i_increment +
    ",j_increment=" +
    j_increment +
    ",vector_components=" +
    vector_component_mode,
  )
}

///|
pub fn decode_scanning_mode_name(flags : Int) -> Grib2NameLookup {
  if flags < 0 || flags > 255 {
    return NameUnknown("scanning_mode=" + flags.to_string())
  }
  let i_scan = if decode_flag_bit(flags, 1) { "-i" } else { "+i" }
  let j_scan = if decode_flag_bit(flags, 2) { "+j" } else { "-j" }
  let adjacent_consecutive = if decode_flag_bit(flags, 3) { "j" } else { "i" }
  let row_scan = if decode_flag_bit(flags, 4) { "opposite" } else { "same" }
  let odd_i_offset = if decode_flag_bit(flags, 5) {
    "di_over_2"
  } else {
    "none"
  }
  let even_i_offset = if decode_flag_bit(flags, 6) {
    "di_over_2"
  } else {
    "none"
  }
  let j_offset = if decode_flag_bit(flags, 7) { "dj_over_2" } else { "none" }
  let row_col_count = if decode_flag_bit(flags, 8) {
    "reduced_when_offset"
  } else {
    "ni_nj"
  }
  NameKnown(
    "i_scan=" +
    i_scan +
    ",j_scan=" +
    j_scan +
    ",adjacent_consecutive=" +
    adjacent_consecutive +
    ",row_scan=" +
    row_scan +
    ",odd_i_offset=" +
    odd_i_offset +
    ",even_i_offset=" +
    even_i_offset +
    ",j_offset=" +
    j_offset +
    ",row_col_count=" +
    row_col_count,
  )
}

///|
pub fn decode_projection_center_name(flags : Int) -> Grib2NameLookup {
  if flags < 0 || flags > 255 {
    return NameUnknown("projection_center=" + flags.to_string())
  }
  let pole = if decode_flag_bit(flags, 1) { "south" } else { "north" }
  let projection = if decode_flag_bit(flags, 2) {
    "bi_polar_symmetric"
  } else {
    "single_center"
  }
  NameKnown("pole=" + pole + ",projection=" + projection)
}

///|
pub fn decode_spectral_data_representation_type_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Associated Legendre Functions")
    2 => NameKnown("Bi-Fourier Representation")
    _ => NameUnknown("spectral_data_representation_type=" + value.to_string())
  }
}

///|
pub fn decode_spectral_data_representation_mode_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Complex Coefficients Stored as Re/Im Pairs")
    255 => NameKnown("Missing")
    _ =>
      if value >= 0 && value <= 254 {
        NameKnown("Reserved")
      } else {
        NameUnknown("spectral_data_representation_mode=" + value.to_string())
      }
  }
}

///|
pub fn decode_grid_point_position_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Triangle Vertices")
    1 => NameKnown("Centers of Triangles")
    2 => NameKnown("Midpoints of Triangle Sides")
    3 => NameKnown("Shape Vertices")
    4 => NameKnown("Centers of Shapes")
    5 => NameKnown("Midpoints of Shape Sides")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("grid_point_position=" + value.to_string())
      }
  }
}

///|
pub fn decode_diamond_numbering_order_name(flags : Int) -> Grib2NameLookup {
  if flags < 0 || flags > 255 {
    return NameUnknown("diamond_numbering_order=" + flags.to_string())
  }
  let orientation = if decode_flag_bit(flags, 1) {
    "counter_clockwise"
  } else {
    "clockwise"
  }
  NameKnown("orientation=" + orientation)
}

///|
pub fn decode_diamond_scanning_mode_name(flags : Int) -> Grib2NameLookup {
  if flags < 0 || flags > 255 {
    return NameUnknown("diamond_scanning_mode=" + flags.to_string())
  }
  let i_scan = if decode_flag_bit(flags, 1) {
    "equator_to_pole"
  } else {
    "pole_to_equator"
  }
  let j_scan = if decode_flag_bit(flags, 2) {
    "east_to_west"
  } else {
    "west_to_east"
  }
  let adjacent_consecutive = if decode_flag_bit(flags, 3) { "j" } else { "i" }
  NameKnown(
    "i_scan=" +
    i_scan +
    ",j_scan=" +
    j_scan +
    ",adjacent_consecutive=" +
    adjacent_consecutive,
  )
}

///|
pub fn decode_section3_appended_list_interpretation_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Appended List")
    1 => NameKnown("Points per Full Coordinate Circle")
    2 => NameKnown("Points per Coordinate Line Segment")
    3 => NameKnown("Actual Latitudes for Each Row")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 254 {
        NameKnown("Reserved")
      } else {
        NameUnknown(
          "section3_appended_list_interpretation=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_product_definition_template_number_name(
  template_number : Int,
) -> Grib2NameLookup {
  if template_number == 65535 {
    return NameKnown("Missing")
  }
  if template_number >= 32768 && template_number <= 65534 {
    return NameKnown("Reserved for Local Use")
  }
  if template_number >= 0 && template_number <= 32767 {
    match decode_section4_template(template_number) {
      Section4TemplateKnown(id) => NameKnown("Template 4." + id.to_string())
      Section4TemplateUnknown(_) => NameKnown("Reserved")
    }
  } else {
    NameUnknown("product_definition_template=" + template_number.to_string())
  }
}

///|
pub fn decode_type_of_generating_process_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Analysis")
    1 => NameKnown("Initialization")
    2 => NameKnown("Forecast")
    3 => NameKnown("Bias Corrected Forecast")
    4 => NameKnown("Ensemble Forecast")
    5 => NameKnown("Probability Forecast")
    6 => NameKnown("Forecast Error")
    7 => NameKnown("Analysis Error")
    8 => NameKnown("Observation")
    9 => NameKnown("Climatological")
    10 => NameKnown("Probability-Weighted Forecast")
    11 => NameKnown("Bias-Corrected Ensemble Forecast")
    12 => NameKnown("Post-Processed Analysis")
    13 => NameKnown("Post-Processed Forecast")
    14 => NameKnown("Nowcast")
    15 => NameKnown("Hindcast")
    16 => NameKnown("Physical Retrieval")
    17 => NameKnown("Regression Analysis")
    18 => NameKnown("Difference Between Two Forecasts")
    19 => NameKnown("First Guess")
    20 => NameKnown("Analysis Increment")
    21 => NameKnown("Initialization Increment for Analysis")
    22 => NameKnown("Blended Forecast")
    23 => NameKnown("Anomaly")
    192 => NameKnown("Forecast Confidence Indicator")
    193 => NameKnown("Probability-Matched Mean")
    194 => NameKnown("Neighborhood Probability")
    195 => NameKnown("Bias-Corrected and Downscaled Ensemble Forecast")
    196 => NameKnown("Perturbed Analysis for Ensemble Initialization")
    197 => NameKnown("Ensemble Agreement Scale Probability")
    198 => NameKnown("Post-Processed Deterministic-Expert-Weighted Forecast")
    199 => NameKnown("Ensemble Forecast Based on Counting")
    200 => NameKnown("Local Probability-Matched Mean")
    255 => NameKnown("Missing")
    _ =>
      if value >= 24 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 201 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_generating_process=" + value.to_string())
      }
  }
}

///|
pub fn decode_indicator_of_unit_of_time_range_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Minute")
    1 => NameKnown("Hour")
    2 => NameKnown("Day")
    3 => NameKnown("Month")
    4 => NameKnown("Year")
    5 => NameKnown("Decade (10 Years)")
    6 => NameKnown("Normal (30 Years)")
    7 => NameKnown("Century (100 Years)")
    10 => NameKnown("3 Hours")
    11 => NameKnown("6 Hours")
    12 => NameKnown("12 Hours")
    13 => NameKnown("Second")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 8 && value <= 9) || (value >= 14 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("indicator_of_unit_of_time_range=" + value.to_string())
      }
  }
}

///|
pub fn decode_fixed_surface_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Ground or Water Surface")
    2 => NameKnown("Cloud Base Level")
    3 => NameKnown("Level of Cloud Tops")
    4 => NameKnown("Level of 0 C Isotherm")
    5 => NameKnown("Level of Adiabatic Condensation Lifted from the Surface")
    6 => NameKnown("Maximum Wind Level")
    7 => NameKnown("Tropopause")
    8 => NameKnown("Nominal Top of the Atmosphere")
    9 => NameKnown("Sea Bottom")
    10 => NameKnown("Entire Atmosphere")
    11 => NameKnown("Cumulonimbus Base (CB)")
    12 => NameKnown("Cumulonimbus Top (CT)")
    13 =>
      NameKnown(
        "Lowest level where vertically integrated cloud cover exceeds the specified percentage",
      )
    14 => NameKnown("Level of free convection (LFC)")
    15 => NameKnown("Convection condensation level (CCL)")
    16 => NameKnown("Level of neutral buoyancy or equilibrium (LNB)")
    17 => NameKnown("Departure level of the most unstable parcel of air (MUDL)")
    18 =>
      NameKnown(
        "Departure level of a mixed layer parcel of air with specified layer depth",
      )
    19 =>
      NameKnown(
        "Lowest level where cloud cover exceeds the specified percentage",
      )
    20 => NameKnown("Isothermal Level")
    21 =>
      NameKnown("Lowest level where mass density exceeds the specified value")
    22 =>
      NameKnown("Highest level where mass density exceeds the specified value")
    23 =>
      NameKnown(
        "Lowest level where air concentration exceeds the specified value",
      )
    24 =>
      NameKnown(
        "Highest level where air concentration exceeds the specified value",
      )
    25 =>
      NameKnown(
        "Highest level where radar reflectivity exceeds the specified value",
      )
    26 => NameKnown("Convective cloud layer base")
    27 => NameKnown("Convective cloud layer top")
    30 => NameKnown("Specified radius from the centre of the Sun")
    31 => NameKnown("Solar photosphere")
    32 => NameKnown("Ionospheric D-region level")
    33 => NameKnown("Ionospheric E-region level")
    34 => NameKnown("Ionospheric F1-region level")
    35 => NameKnown("Ionospheric F2-region level")
    36 => NameKnown("Stratopause")
    100 => NameKnown("Isobaric Surface")
    101 => NameKnown("Mean Sea Level")
    102 => NameKnown("Specific Altitude Above Mean Sea Level")
    103 => NameKnown("Specified Height Level Above Ground")
    104 => NameKnown("Sigma Level")
    105 => NameKnown("Hybrid Level")
    106 => NameKnown("Depth Below Land Surface")
    107 => NameKnown("Isentropic (theta) Level")
    108 =>
      NameKnown("Level at Specified Pressure Difference from Ground to Level")
    109 => NameKnown("Potential Vorticity Surface")
    111 => NameKnown("Eta Level")
    113 => NameKnown("Logarithmic Hybrid Level")
    114 => NameKnown("Snow Level")
    115 => NameKnown("Sigma height level")
    117 => NameKnown("Mixed Layer Depth")
    118 => NameKnown("Hybrid Height Level")
    119 => NameKnown("Hybrid Pressure Level")
    150 => NameKnown("Generalized Vertical Height Coordinate")
    151 => NameKnown("Soil level")
    152 => NameKnown("Sea-ice level")
    160 => NameKnown("Depth Below Sea Level")
    161 => NameKnown("Depth Below Water Surface")
    162 => NameKnown("Lake or River Bottom")
    163 => NameKnown("Bottom Of Sediment Layer")
    164 => NameKnown("Bottom Of Thermally Active Sediment Layer")
    165 => NameKnown("Bottom Of Sediment Layer Penetrated By Thermal Wave")
    166 => NameKnown("Mixing Layer")
    167 => NameKnown("Bottom of Root Zone")
    168 => NameKnown("Ocean Model Level")
    169 =>
      NameKnown("Ocean level defined by water density (sigma-theta) difference")
    170 =>
      NameKnown("Ocean level defined by water potential temperature difference")
    171 =>
      NameKnown("Ocean level defined by vertical eddy diffusivity difference")
    172 => NameKnown("Ocean level defined by water density (rho) difference")
    173 => NameKnown("Top of Snow Over Sea Ice on Sea, Lake or River")
    174 => NameKnown("Top Surface of Ice on Sea, Lake or River")
    175 => NameKnown("Top Surface of Ice, under Snow, on Sea, Lake or River")
    176 => NameKnown("Bottom Surface (underside) Ice on Sea, Lake or River")
    177 => NameKnown("Deep Soil (of indefinite depth)")
    179 => NameKnown("Top Surface of Glacier Ice and Inland Ice")
    180 => NameKnown("Deep Inland or Glacier Ice (of indefinite depth)")
    181 => NameKnown("Grid Tile Land Fraction as a Model Surface")
    182 => NameKnown("Grid Tile Water Fraction as a Model Surface")
    183 =>
      NameKnown(
        "Grid Tile Ice Fraction on Sea, Lake or River as a Model Surface",
      )
    184 =>
      NameKnown(
        "Grid Tile Glacier Ice and Inland Ice Fraction as a Model Surface",
      )
    185 => NameKnown("Roof Level")
    186 => NameKnown("Wall level")
    187 => NameKnown("Road Level")
    188 => NameKnown("Melt pond Top Surface")
    189 => NameKnown("Melt Pond Bottom Surface")
    191 => NameKnown("Abstract Level with no Vertical Localization")
    200 => NameKnown("Entire atmosphere (considered as a single layer)")
    201 => NameKnown("Entire ocean (considered as a single layer)")
    204 => NameKnown("Highest tropospheric freezing level")
    206 => NameKnown("Grid scale cloud bottom level")
    207 => NameKnown("Grid scale cloud top level")
    209 => NameKnown("Boundary layer cloud bottom level")
    210 => NameKnown("Boundary layer cloud top level")
    211 => NameKnown("Boundary layer cloud layer")
    212 => NameKnown("Low cloud bottom level")
    213 => NameKnown("Low cloud top level")
    214 => NameKnown("Low cloud layer")
    215 => NameKnown("Cloud ceiling")
    216 => NameKnown("Effective Layer Top Level")
    217 => NameKnown("Effective Layer Bottom Level")
    218 => NameKnown("Effective Layer")
    220 => NameKnown("Planetary Boundary Layer")
    221 => NameKnown("Layer Between Two Hybrid Levels")
    222 => NameKnown("Middle cloud bottom level")
    223 => NameKnown("Middle cloud top level")
    224 => NameKnown("Middle cloud layer")
    232 => NameKnown("High cloud bottom level")
    233 => NameKnown("High cloud top level")
    234 => NameKnown("High cloud layer")
    235 => NameKnown("Ocean Isotherm Level (1/10 C)")
    236 => NameKnown("Layer between two depths below ocean surface")
    237 => NameKnown("Bottom of Ocean Mixed Layer")
    238 => NameKnown("Bottom of Ocean Isothermal Layer")
    239 => NameKnown("Layer Ocean Surface and 26C Ocean Isothermal Level")
    240 => NameKnown("Ocean Mixed Layer")
    241 => NameKnown("Ordered Sequence of Data")
    242 => NameKnown("Convective cloud bottom level")
    243 => NameKnown("Convective cloud top level")
    244 => NameKnown("Convective cloud layer")
    245 => NameKnown("Lowest level of the wet bulb zero")
    246 => NameKnown("Maximum equivalent potential temperature level")
    247 => NameKnown("Equilibrium level")
    248 => NameKnown("Shallow convective cloud bottom level")
    249 => NameKnown("Shallow convective cloud top level")
    251 => NameKnown("Deep convective cloud bottom level")
    252 => NameKnown("Deep convective cloud top level")
    253 => NameKnown("Lowest bottom level of supercooled liquid water layer")
    254 => NameKnown("Highest top level of supercooled liquid water layer")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 ||
        (value >= 28 && value <= 29) ||
        (value >= 37 && value <= 99) ||
        value == 110 ||
        value == 112 ||
        value == 116 ||
        (value >= 120 && value <= 149) ||
        (value >= 153 && value <= 159) ||
        value == 178 ||
        value == 190 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("fixed_surface_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_ensemble_forecast_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Unperturbed High-Resolution Control Forecast")
    1 => NameKnown("Unperturbed Low-Resolution Control Forecast")
    2 => NameKnown("Negatively Perturbed Forecast")
    3 => NameKnown("Positively Perturbed Forecast")
    4 => NameKnown("Multi-Model Forecast")
    5 => NameKnown("Unperturbed Forecast")
    6 => NameKnown("Perturbed Forecast")
    7 => NameKnown("Initial Conditions Perturbations")
    8 => NameKnown("Model Physics Perturbations")
    9 => NameKnown("Initial Conditions and Model Physics Perturbations")
    192 => NameKnown("Perturbed Ensemble Member")
    255 => NameKnown("Missing")
    _ =>
      if value >= 10 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 193 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_ensemble_forecast=" + value.to_string())
      }
  }
}

///|
pub fn decode_derived_forecast_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Unweighted Mean of All Members")
    1 => NameKnown("Weighted Mean of All Members")
    2 => NameKnown("Standard Deviation with respect to Cluster Mean")
    3 =>
      NameKnown("Standard Deviation with respect to Cluster Mean, Normalized")
    4 => NameKnown("Spread of All Members")
    5 => NameKnown("Large Anomaly Index of All Members")
    6 => NameKnown("Unweighted Mean of the Cluster Members")
    7 =>
      NameKnown(
        "Interquartile Range (Range between the 25th and 75th quantile)",
      )
    8 => NameKnown("Minimum Of All Ensemble Members")
    9 => NameKnown("Maximum Of All Ensemble Members")
    10 => NameKnown("Variance of all ensemble members")
    192 => NameKnown("Unweighted Mode of All Members")
    193 => NameKnown("Percentile value (10%) of All Members")
    194 => NameKnown("Percentile value (50%) of All Members")
    195 => NameKnown("Percentile value (90%) of All Members")
    196 => NameKnown("Statistically decided weights for each ensemble member")
    197 =>
      NameKnown(
        "Climate Percentile (percentile values from climate distribution)",
      )
    198 => NameKnown("Deviation of Ensemble Mean from Daily Climatology")
    199 => NameKnown("Extreme Forecast Index")
    200 => NameKnown("Equally Weighted Mean")
    201 => NameKnown("Percentile value (5%) of All Members")
    202 => NameKnown("Percentile value (25%) of All Members")
    203 => NameKnown("Percentile value (75%) of All Members")
    204 => NameKnown("Percentile value (95%) of All Members")
    255 => NameKnown("Missing")
    _ =>
      if value >= 11 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 205 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("derived_forecast=" + value.to_string())
      }
  }
}

///|
pub fn decode_clustering_method_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Anomoly Correlation")
    1 => NameKnown("Root Mean Square")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("clustering_method=" + value.to_string())
      }
  }
}

///|
pub fn decode_probability_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Probability of event below lower limit")
    1 => NameKnown("Probability of event above upper limit")
    2 =>
      NameKnown(
        "Probability of event between upper and lower limits (the range includes lower limit but not the upper limit)",
      )
    3 => NameKnown("Probability of event above lower limit")
    4 => NameKnown("Probability of event below upper limit")
    5 => NameKnown("Probability of event equal to lower limit")
    6 => NameKnown("Probability of event in above normal category")
    7 => NameKnown("Probability of event in near normal category")
    8 => NameKnown("Probability of event in below normal category")
    9 => NameKnown("Probability based on counts of categorical boolean")
    10 =>
      NameKnown(
        "Probability of event within the quantile of the probability distribution function",
      )
    255 => NameKnown("Missing")
    _ =>
      if value >= 11 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("probability_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_statistical_processing_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Average")
    1 => NameKnown("Accumulation")
    2 => NameKnown("Maximum")
    3 => NameKnown("Minimum")
    4 =>
      NameKnown(
        "Difference (value at the end of the time range minus value at the beginning)",
      )
    5 => NameKnown("Root Mean Square")
    6 => NameKnown("Standard Deviation")
    7 => NameKnown("Covariance (temporal variance)")
    8 =>
      NameKnown(
        "Difference (value at the beginning of the time range minus value at the end)",
      )
    9 => NameKnown("Ratio")
    10 => NameKnown("Standardized Anomaly")
    11 => NameKnown("Summation")
    12 => NameKnown("Return period")
    13 => NameKnown("Median")
    100 => NameKnown("Severity")
    101 => NameKnown("Mode")
    102 => NameKnown("Index processing")
    192 => NameKnown("Climatological Mean Value")
    193 => NameKnown("Average of N forecasts (or initialized analyses)")
    194 => NameKnown("Average of N uninitialized analyses")
    195 => NameKnown("Average of forecast accumulations (24-hour intervals)")
    196 => NameKnown("Average of successive forecast accumulations")
    197 => NameKnown("Average of forecast averages (24-hour intervals)")
    198 => NameKnown("Average of successive forecast averages")
    199 => NameKnown("Climatological Average of N analyses")
    200 => NameKnown("Climatological Average of N forecasts")
    201 => NameKnown("Climatological Root Mean Square difference")
    202 => NameKnown("Climatological Standard Deviation of N forecasts")
    203 => NameKnown("Climatological Standard Deviation of N analyses")
    204 => NameKnown("Average of forecast accumulations (6-hour intervals)")
    205 => NameKnown("Average of forecast averages (6-hour intervals)")
    206 => NameKnown("Average of forecast accumulations (12-hour intervals)")
    207 => NameKnown("Average of forecast averages (12-hour intervals)")
    208 => NameKnown("Variance")
    209 => NameKnown("Coefficient")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 14 && value <= 99) || (value >= 103 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 210 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_statistical_processing=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_time_intervals_name(value : Int) -> Grib2NameLookup {
  match value {
    1 =>
      NameKnown(
        "Successive times processed have same forecast time, start time of forecast is incremented",
      )
    2 =>
      NameKnown(
        "Successive times processed have same start time of forecast, forecast time is incremented",
      )
    3 =>
      NameKnown(
        "Successive times processed have start time of forecast incremented and forecast time decremented so that valid time remains constant",
      )
    4 =>
      NameKnown(
        "Successive times processed have start time of forecast decremented and forecast time incremented so that valid time remains constant",
      )
    5 =>
      NameKnown(
        "Floating subinterval of time between forecast time and end of overall time interval",
      )
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 6 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_time_intervals=" + value.to_string())
      }
  }
}

///|
pub fn decode_operating_mode_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Maintenance Mode")
    1 => NameKnown("Clear Air")
    2 => NameKnown("Precipitation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("operating_mode=" + value.to_string())
      }
  }
}

///|
pub fn decode_quality_control_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Quality Control Applied")
    1 => NameKnown("Quality Control Applied")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("quality_control_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_clutter_filter_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Clutter Filter Used")
    1 => NameKnown("Clutter Filter Used")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("clutter_filter_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_spatial_processing_name(value : Int) -> Grib2NameLookup {
  match value {
    0 =>
      NameKnown(
        "Data is calculated directly from the source grid with no interpolation",
      )
    1 =>
      NameKnown(
        "Bilinear interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    2 =>
      NameKnown(
        "Bicubic interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    3 =>
      NameKnown(
        "Using the value from the source grid-point which is nearest to the nominal grid-point",
      )
    4 =>
      NameKnown(
        "Budget interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    5 =>
      NameKnown(
        "Spectral interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    6 =>
      NameKnown(
        "Neighbor-budget interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    255 => NameKnown("Missing")
    _ =>
      if value >= 7 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_spatial_processing=" + value.to_string())
      }
  }
}

///|
pub fn decode_quality_value_associated_with_parameter_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Confidence index")
    1 => NameKnown("Quality indicator")
    2 => NameKnown("Correlation of Product with used Calibration Product")
    3 => NameKnown("Standard deviation")
    4 => NameKnown("Random error")
    5 => NameKnown("Probability")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "quality_value_associated_with_parameter=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_type_of_interval_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Smaller than first limit")
    1 => NameKnown("Greater than second limit")
    2 =>
      NameKnown(
        "Between first and second limit. The range includes the first limit but not the second limit.",
      )
    3 => NameKnown("Greater than first limit")
    4 => NameKnown("Smaller than second limit")
    5 => NameKnown("Smaller or equal first limit")
    6 => NameKnown("Greater or equal second limit")
    7 =>
      NameKnown(
        "Between first and second limit. The range includes the first limit and the second limit.",
      )
    8 => NameKnown("Greater or equal first limit")
    9 => NameKnown("Smaller or equal second limit")
    10 =>
      NameKnown(
        "Between first and second limit. The range includes the second limit but not the first limit.",
      )
    11 => NameKnown("Equal to first limit")
    255 => NameKnown("Missing")
    _ =>
      if value >= 12 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_interval=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_reference_dataset_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Analysis")
    1 => NameKnown("Forecast")
    2 => NameKnown("Reforecast (Hindcast)")
    3 => NameKnown("Reanalysis")
    4 => NameKnown("Climate Projection")
    5 => NameKnown("Gridded observations")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_reference_dataset=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_relationship_to_reference_dataset_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Anomaly")
    1 => NameKnown("Standardized Anomaly")
    2 => NameKnown("Significance (Wilcoxon-Mann-Whitney)")
    3 => NameKnown("Climatology")
    20 => NameKnown("Extreme Forecast Index (EFI)")
    21 => NameKnown("Shift of Tails (SOT)")
    22 => NameKnown("Anomaly of Probabilities")
    23 => NameKnown("Standardized Drought Index")
    24 => NameKnown("Crossing Point Forecast (CPF)")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 4 && value <= 19) || (value >= 25 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "type_of_relationship_to_reference_dataset=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_statistical_processing_of_reference_period_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Average")
    1 => NameKnown("Accumulation")
    2 => NameKnown("Maximum")
    3 => NameKnown("Minimum")
    4 => NameKnown("Median")
    20 => NameKnown("Model Climate")
    21 => NameKnown("Index based on normal distribution")
    22 => NameKnown("Index based on log-normal distribution")
    23 => NameKnown("Index based on generalized log-normal distribution")
    24 => NameKnown("Index based on gamma distribution")
    25 => NameKnown("Index based on logistic distribution")
    26 => NameKnown("Index based on log-logistic distribution")
    27 => NameKnown("Index based on generalized logistic distribution")
    28 => NameKnown("Index based on Weibull distribution")
    29 => NameKnown("Index based on generalized extreme value distribution")
    30 => NameKnown("Index based on Pearson III distribution")
    31 => NameKnown("Index based on empirical distribution")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 5 && value <= 19) || (value >= 32 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "statistical_processing_of_reference_period=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_spatial_vicinity_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Circle [m]")
    1 => NameKnown("Rectangle [m,m]")
    2 => NameKnown("Square [m]")
    3 => NameKnown("Wedge [m, degree, degree]")
    4 => NameKnown("Span of grid boxes centered around grid box i,j [x,y]")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("spatial_vicinity_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_spatial_and_temporal_vicinity_processing_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Average")
    2 => NameKnown("Maximum")
    3 => NameKnown("Minimum")
    4 => NameKnown("Range")
    6 => NameKnown("Standard deviation")
    11 => NameKnown("Sum")
    190 => NameKnown("Quantile")
    191 => NameKnown("Categorical (boolean)")
    255 => NameKnown("Missing")
    _ =>
      if value == 1 ||
        value == 5 ||
        (value >= 7 && value <= 10) ||
        (value >= 12 && value <= 189) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "spatial_and_temporal_vicinity_processing=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_spatial_and_temporal_vicinity_missing_data_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Ignore missing data")
    1 => NameKnown("No data")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "spatial_and_temporal_vicinity_missing_data=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_radar_data_quality_flags_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Normal operating data")
    1 => NameKnown("No data")
    2 => NameKnown("Undetected")
    3 => NameKnown("Implausible data/outliers")
    4 => NameKnown("Beam overshooting")
    5 => NameKnown("Beam blocking")
    6 => NameKnown("Ground clutter")
    7 => NameKnown("Sea clutter")
    8 => NameKnown("Beam attenuation")
    9 => NameKnown("Wet radome attenuation")
    10 => NameKnown("Wind turbines")
    11 => NameKnown("Insects/birds")
    12 => NameKnown("Ships/aircrafts")
    255 => NameKnown("Missing")
    _ =>
      if value >= 13 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("radar_data_quality_flags=" + value.to_string())
      }
  }
}

///|
pub fn decode_verification_scores_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Mean Error")
    1 => NameKnown("Root Mean Squared Error")
    2 => NameKnown("Continuous Ranked Probability Score (CRPS)")
    3 => NameKnown("Fair Continuous Ranked Probability Score")
    4 => NameKnown("Continuous Logarithmic Ignorance Score")
    5 => NameKnown("Fair Continuous Logarithmic Ignorance Score")
    6 => NameKnown("Ranked Probability Score")
    100 => NameKnown("Contingency Table (Deterministic) - Hits")
    101 => NameKnown("Contingency Table (Deterministic) - False Alarms")
    102 => NameKnown("Contingency Table (Deterministic) - Misses")
    103 => NameKnown("Contingency Table (Deterministic) - Correct Negatives")
    104 =>
      NameKnown(
        "Contingency Table (Probabilistic) - Forecast-by-n-members and observed",
      )
    105 =>
      NameKnown(
        "Contingency Table (Probabilistic) - Forecast-by-n-members and not observed",
      )
    65535 => NameKnown("Missing")
    _ =>
      if value >= 7 && value <= 99 {
        NameKnown("Reserved for Future Use")
      } else if value >= 106 && value <= 62999 {
        NameKnown("Reserved")
      } else if value >= 63000 && value <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("verification_scores=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_reference_dataset_for_verification_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Analysis Interpolated on Forecast Grid")
    1 => NameKnown("Analysis with Forecast Interpolated on Analysis Grid")
    2 =>
      NameKnown(
        "Analysis Interpolated on a Common Grid with the Forecast but Different to Original Grid",
      )
    3 => NameKnown("Gridded Observation on Forecast Grid")
    4 =>
      NameKnown(
        "Gridded Observation wih Forecast Interpolated on Observation Grid",
      )
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "type_of_reference_dataset_for_verification=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_type_of_additional_arguments_for_verification_score_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Fixed Threshold Value")
    1 => NameKnown("Threshold Specified as a Quantile of the Climatology")
    2 =>
      NameKnown("Threshold Specified as a Multiple of the Standard Deviation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "type_of_additional_arguments_for_verification_score=" +
          value.to_string(),
        )
      }
  }
}

///|
pub fn decode_precipitation_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Rain")
    2 => NameKnown("Thunderstorm")
    3 => NameKnown("Freezing Rain")
    4 => NameKnown("Mixed/Ice")
    5 => NameKnown("Snow")
    6 => NameKnown("Wet Snow")
    7 => NameKnown("Mixture of Rain and Snow")
    8 => NameKnown("Ice Pellets")
    9 => NameKnown("Graupel")
    10 => NameKnown("Hail")
    11 => NameKnown("Drizzle")
    12 => NameKnown("Freezing Drizzle")
    13 => NameKnown("Hail (< 5 mm)")
    14 => NameKnown("Hail (≥ 5 mm)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 15 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("precipitation_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_precipitable_water_category_name(value : Int) -> Grib2NameLookup {
  match value {
    255 => NameKnown("Missing")
    _ =>
      if value >= 0 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("precipitable_water_category=" + value.to_string())
      }
  }
}

///|
pub fn decode_cloud_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Clear")
    1 => NameKnown("Cumulonimbus")
    2 => NameKnown("Stratus")
    3 => NameKnown("Stratocumulus")
    4 => NameKnown("Cumulus")
    5 => NameKnown("Altostratus")
    6 => NameKnown("Nimbostratus")
    7 => NameKnown("Altocumulus")
    8 => NameKnown("Cirrostratus")
    9 => NameKnown("Cirrorcumulus")
    10 => NameKnown("Cirrus")
    11 => NameKnown("Cumulonimbus - ground-based fog beneath the lowest layer")
    12 => NameKnown("Stratus - ground-based fog beneath the lowest layer")
    13 => NameKnown("Stratocumulus - ground-based fog beneath the lowest layer")
    14 => NameKnown("Cumulus - ground-based fog beneath the lowest layer")
    15 => NameKnown("Altostratus - ground-based fog beneath the lowest layer")
    16 => NameKnown("Nimbostratus - ground-based fog beneath the lowest layer")
    17 => NameKnown("Altocumulus - ground-based fog beneath the lowest layer")
    18 => NameKnown("Cirrostratus - ground-based fog beneath the lowest layer")
    19 => NameKnown("Cirrorcumulus - ground-based fog beneath the lowest layer")
    20 => NameKnown("Cirrus - ground-based fog beneath the lowest layer")
    191 => NameKnown("Unknown")
    255 => NameKnown("Missing")
    _ =>
      if value >= 21 && value <= 190 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("cloud_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_thunderstorm_coverage_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Isolated (1-2%)")
    2 => NameKnown("Few (3-5%)")
    3 => NameKnown("Scattered (16-45%)")
    4 => NameKnown("Numerous (>45%)")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("thunderstorm_coverage=" + value.to_string())
      }
  }
}

///|
pub fn decode_presence_of_aerosol_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Aerosol not present")
    1 => NameKnown("Aerosol present")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("presence_of_aerosol=" + value.to_string())
      }
  }
}

///|
pub fn decode_volcanic_ash_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Not Present")
    1 => NameKnown("Present")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("volcanic_ash=" + value.to_string())
      }
  }
}

///|
pub fn decode_icing_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Light")
    2 => NameKnown("Moderate")
    3 => NameKnown("Severe")
    4 => NameKnown("Trace")
    5 => NameKnown("Heavy")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("icing=" + value.to_string())
      }
  }
}

///|
pub fn decode_turbulence_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Light")
    2 => NameKnown("Moderate")
    3 => NameKnown("Severe")
    4 => NameKnown("Extreme")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("turbulence=" + value.to_string())
      }
  }
}

///|
pub fn decode_planetary_boundary_layer_regime_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Stable")
    2 => NameKnown("Mechanically-Driven Turbulence")
    3 => NameKnown("Forced Convection")
    4 => NameKnown("Free Convection")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 5 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("planetary_boundary_layer_regime=" + value.to_string())
      }
  }
}

///|
pub fn decode_contrail_intensity_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Contrail Not Present")
    1 => NameKnown("Contrail Present")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("contrail_intensity=" + value.to_string())
      }
  }
}

///|
pub fn decode_contrail_engine_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Low Bypass")
    1 => NameKnown("High Bypass")
    2 => NameKnown("Non-Bypass")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("contrail_engine_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_land_use_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Urban Land")
    2 => NameKnown("Agricultural")
    3 => NameKnown("Range Land")
    4 => NameKnown("Deciduous Forest")
    5 => NameKnown("Coniferous Forest")
    6 => NameKnown("Forest/Wetland")
    7 => NameKnown("Water")
    8 => NameKnown("Wetlands")
    9 => NameKnown("Desert")
    10 => NameKnown("Tundra")
    11 => NameKnown("Ice")
    12 => NameKnown("Tropical Forest")
    13 => NameKnown("Savannah")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 14 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("land_use=" + value.to_string())
      }
  }
}

///|
pub fn decode_soil_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Sand")
    2 => NameKnown("Loamy Sand")
    3 => NameKnown("Sandy Loam")
    4 => NameKnown("Silt Loam")
    5 => NameKnown("Organic (redefined)")
    6 => NameKnown("Sandy Clay Loam")
    7 => NameKnown("Silt Clay Loam")
    8 => NameKnown("Clay Loam")
    9 => NameKnown("Sandy Clay")
    10 => NameKnown("Silty Clay")
    11 => NameKnown("Clay")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 12 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("soil_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_environmental_factor_qualifier_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Worst")
    1 => NameKnown("Very Poor")
    2 => NameKnown("Poor")
    3 => NameKnown("Average")
    4 => NameKnown("Good")
    5 => NameKnown("Excellent")
    191 => NameKnown("Unknown")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 190 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("environmental_factor_qualifier=" + value.to_string())
      }
  }
}

///|
pub fn decode_remotely_sensed_snow_coverage_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    50 => NameKnown("No-Snow/No-Cloud")
    100 => NameKnown("Clouds")
    250 => NameKnown("Snow")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 0 && value <= 49) ||
        (value >= 51 && value <= 99) ||
        (value >= 101 && value <= 249) {
        NameKnown("Reserved")
      } else if value >= 251 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("remotely_sensed_snow_coverage=" + value.to_string())
      }
  }
}

///|
pub fn decode_elevation_of_snow_covered_terrain_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    254 => NameKnown("Clouds")
    255 => NameKnown("Missing")
    _ =>
      if value >= 0 && value <= 90 {
        NameKnown("Elevation in increments of 100 m")
      } else if value >= 91 && value <= 253 {
        NameKnown("Reserved")
      } else {
        NameUnknown("elevation_of_snow_covered_terrain=" + value.to_string())
      }
  }
}

///|
pub fn decode_cloud_mask_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Clear over water")
    1 => NameKnown("Clear over land")
    2 => NameKnown("Cloud")
    3 => NameKnown("No data")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("cloud_mask_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_pixel_scene_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Scene Identified")
    1 => NameKnown("Green Needle-Leafed Forest")
    2 => NameKnown("Green Broad-Leafed Forest")
    3 => NameKnown("Deciduous Needle-Leafed Forest")
    4 => NameKnown("Deciduous Broad-Leafed Forest")
    5 => NameKnown("Deciduous Mixed Forest")
    6 => NameKnown("Closed Shrub-Land")
    7 => NameKnown("Open Shrub-Land")
    8 => NameKnown("Woody Savannah")
    9 => NameKnown("Savannah")
    10 => NameKnown("Grassland")
    11 => NameKnown("Permanent Wetland")
    12 => NameKnown("Cropland")
    13 => NameKnown("Urban")
    14 => NameKnown("Vegetation / Crops")
    15 => NameKnown("Permanent Snow / Ice")
    16 => NameKnown("Barren Desert")
    17 => NameKnown("Water Bodies")
    18 => NameKnown("Tundra")
    19 => NameKnown("Warm Liquid Water Cloud")
    20 => NameKnown("Supercooled Liquid Water Cloud")
    21 => NameKnown("Mixed Phase Cloud")
    22 => NameKnown("Optically Thin Ice Cloud")
    23 => NameKnown("Optically Thick Ice Cloud")
    24 => NameKnown("Multilayered Cloud")
    97 => NameKnown("Snow / Ice on Land")
    98 => NameKnown("Snow / Ice on Water")
    99 => NameKnown("Sun-Glint")
    100 => NameKnown("General Cloud")
    101 => NameKnown("Low Cloud / Fog / Stratus")
    102 => NameKnown("Low Cloud / Stratocumulus")
    103 => NameKnown("Low Cloud / Unknown Type")
    104 => NameKnown("Medium Cloud / Nimbostratus")
    105 => NameKnown("Medium Cloud / Altostratus")
    106 => NameKnown("Medium Cloud / Unknown Type")
    107 => NameKnown("High Cloud / Cumulus")
    108 => NameKnown("High Cloud / Cirrus")
    109 => NameKnown("High Cloud / Unknown Type")
    110 => NameKnown("Unknown Cloud Type")
    111 => NameKnown("Single Layer Water Cloud")
    112 => NameKnown("Single Layer Ice Cloud")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 25 && value <= 96) || (value >= 113 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("pixel_scene_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_cloud_top_height_quality_indicator_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Nominal Cloud Top Height Quality")
    1 => NameKnown("Fog In Segment")
    2 => NameKnown("Poor Quality Height Estimation")
    3 => NameKnown("Fog In Segment and Poor Quality Height Estimation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("cloud_top_height_quality_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_horizontal_dimension_processed_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Latitude")
    1 => NameKnown("Longitude")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("horizontal_dimension_processed=" + value.to_string())
      }
  }
}

///|
pub fn decode_treatment_of_missing_data_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Not Included")
    1 => NameKnown("Extrapolated")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("treatment_of_missing_data=" + value.to_string())
      }
  }
}

///|
pub fn decode_categorical_result_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No")
    1 => NameKnown("Yes")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("categorical_result=" + value.to_string())
      }
  }
}

///|
pub fn decode_fire_detection_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Fire Detected")
    1 => NameKnown("Possible Fire Detected")
    2 => NameKnown("Probable Fire Detected")
    3 => NameKnown("Missing")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("fire_detection_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_categorical_outlook_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Risk Area")
    2 => NameKnown("General Thunderstorm Risk Area")
    4 => NameKnown("Slight Risk Area")
    6 => NameKnown("Moderate Risk Area")
    8 => NameKnown("High Risk Area")
    11 => NameKnown("Dry Thunderstorm (Dry Lightning) Risk Area")
    14 => NameKnown("Critical Risk Area")
    18 => NameKnown("Extreamly Critical Risk Area")
    255 => NameKnown("Missing")
    _ =>
      if value == 1 ||
        value == 3 ||
        value == 5 ||
        value == 7 ||
        (value >= 9 && value <= 10) ||
        (value >= 12 && value <= 13) ||
        (value >= 15 && value <= 17) ||
        (value >= 19 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("categorical_outlook=" + value.to_string())
      }
  }
}

///|
pub fn decode_weather_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Cloud development not observed or not observable")
    1 => NameKnown("Clouds generally dissolving or becoming less developed")
    2 => NameKnown("State of sky on the whole unchanged")
    3 => NameKnown("Clouds generally forming or developing")
    4 =>
      NameKnown(
        "Visibility reduced by smoke, e.g. veldt or forest fires, industrial smoke or volcanic ashes",
      )
    5 => NameKnown("Haze")
    6 =>
      NameKnown(
        "Widespread dust in suspension in the air, not raised by wind at or near the station at the time of observation",
      )
    7 =>
      NameKnown(
        "Dust or sand raised by wind at or near the station at the time of observation, but no well-developed dust whirl(s) or sand whirl(s), and no duststorm or sandstorm seen; or, in the case of sea stations and coastal stations, blowing spray at the station",
      )
    8 =>
      NameKnown(
        "Well-developed dust whirl(s) or sand whirl(s) seen at or near the station during the preceding hour or at the same time of observation, but no duststorm or sandstorm",
      )
    9 =>
      NameKnown(
        "Duststorm or sandstorm within sight at the time of observation, or at the station during the preceding hour",
      )
    10 => NameKnown("Mist")
    11 => NameKnown("Patches")
    12 => NameKnown("More or less continuous")
    13 => NameKnown("Lightning visible, no thunder heard")
    14 =>
      NameKnown(
        "Precipitation within sight, not reaching the ground or the surface of the sea",
      )
    15 =>
      NameKnown(
        "Precipitation within sight, reaching the ground or the surface of the sea, but distant, i.e. estimated to be more than 5 km from the station",
      )
    16 =>
      NameKnown(
        "Precipitation within sight, reaching the ground or the surface of the sea, near to, but not at the station",
      )
    17 =>
      NameKnown("Thunderstorm, but no precipitation at the time of observation")
    18 => NameKnown("Squalls")
    19 => NameKnown("Funnel cloud(s)")
    20 => NameKnown("Drizzle (not freezing) or snow grains")
    21 => NameKnown("Rain (not freezing)")
    22 => NameKnown("Snow")
    23 => NameKnown("Rain and snow or ice pellets")
    24 => NameKnown("Freezing drizzle or freezing rain")
    25 => NameKnown("Shower(s) of rain")
    26 => NameKnown("Shower(s) of snow, or of rain and snow")
    27 => NameKnown("Shower(s) of hail*, or of rain and hail*")
    28 => NameKnown("Fog or ice fog")
    29 => NameKnown("Thunderstorm (with or without precipitation)")
    30 => NameKnown("Slight or moderate duststorm or sandstorm")
    31 => NameKnown("Slight or moderate duststorm or sandstorm")
    32 => NameKnown("Slight or moderate duststorm or sandstorm")
    33 => NameKnown("Severe duststorm or sandstorm")
    34 => NameKnown("Severe duststorm or sandstorm")
    35 => NameKnown("Severe duststorm or sandstorm")
    36 => NameKnown("Slight or moderate drifting snow")
    37 => NameKnown("Heavy drifting snow")
    38 => NameKnown("Slight or moderate blowing snow")
    39 => NameKnown("Heavy blowing snow")
    40 =>
      NameKnown(
        "Fog or ice fog at a distance at the time of observation, but not at the station during the preceding hour, the fog or ice fog extending to a level above that of the observer",
      )
    41 => NameKnown("Fog or ice fog in patches")
    42 => NameKnown("Fog or ice fog, sky visible")
    43 => NameKnown("Fog or ice fog, sky invisible")
    44 => NameKnown("Fog or ice fog, sky visible")
    45 => NameKnown("Fog or ice fog, sky invisible")
    46 => NameKnown("Fog or ice fog, sky visible")
    47 => NameKnown("Fog or ice fog, sky invisible")
    48 => NameKnown("Fog, depositing rime, sky visible")
    49 => NameKnown("Fog, depositing rime, sky invisible")
    50 => NameKnown("Drizzle, not freezing, intermittent")
    51 => NameKnown("Drizzle, not freezing, continuous")
    52 => NameKnown("Drizzle, not freezing, intermittent")
    53 => NameKnown("Drizzle, not freezing, continuous")
    54 => NameKnown("Drizzle, not freezing, intermittent")
    55 => NameKnown("Drizzle, not freezing, continuous")
    56 => NameKnown("Drizzle, freezing, slight")
    57 => NameKnown("Drizzle, freezing, moderate or heavy (dense)")
    58 => NameKnown("Drizzle and rain, slight")
    59 => NameKnown("Drizzle and rain, moderate or heavy")
    60 => NameKnown("Rain, not freezing, intermittent")
    61 => NameKnown("Rain, not freezing, continuous")
    62 => NameKnown("Rain, not freezing, intermittent")
    63 => NameKnown("Rain, not freezing, continuous")
    64 => NameKnown("Rain, not freezing, intermittent")
    65 => NameKnown("Rain, not freezing, continuous")
    66 => NameKnown("Rain, freezing, slight")
    67 => NameKnown("Rain, freezing, moderate or heavy")
    68 => NameKnown("Rain or drizzle and snow, slight")
    69 => NameKnown("Rain or drizzle and snow, moderate or heavy")
    70 => NameKnown("Intermittent fall of snowflakes")
    71 => NameKnown("Continuous fall of snowflakes")
    72 => NameKnown("Intermittent fall of snowflakes")
    73 => NameKnown("Continuous fall of snowflakes")
    74 => NameKnown("Intermittent fall of snowflakes")
    75 => NameKnown("Continuous fall of snowflakes")
    76 => NameKnown("Diamond dust (with or without fog)")
    77 => NameKnown("Snow grains (with or without fog)")
    78 => NameKnown("Isolated star-like snow crystals (with or without fog)")
    79 => NameKnown("Ice pellets")
    80 => NameKnown("Rain shower(s), slight")
    81 => NameKnown("Rain shower(s), moderate or heavy")
    82 => NameKnown("Rain shower(s), violent")
    83 => NameKnown("Shower(s) of rain and snow mixed, slight")
    84 => NameKnown("Shower(s) of rain and snow mixed, moderate or heavy")
    85 => NameKnown("Snow shower(s), slight")
    86 => NameKnown("Snow shower(s), moderate or heavy")
    87 =>
      NameKnown(
        "Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed",
      )
    88 =>
      NameKnown(
        "Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed",
      )
    89 =>
      NameKnown(
        "Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder",
      )
    90 =>
      NameKnown(
        "Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder",
      )
    91 => NameKnown("Slight rain at time of observation")
    92 => NameKnown("Moderate or heavy rain at time of observation")
    93 =>
      NameKnown(
        "Slight snow, or rain and snow mixed or hail* at time of observation",
      )
    94 =>
      NameKnown(
        "Moderate or heavy snow, or rain and snow mixed or hail* at time of observation",
      )
    95 =>
      NameKnown(
        "Thunderstorm, slight or moderate, without hail*, but with rain and/or snow at time of observation",
      )
    96 =>
      NameKnown(
        "Thunderstorm, slight or moderate, with hail* at time of observation",
      )
    97 =>
      NameKnown(
        "Thunderstorm, heavy, without hail*, but with rain and/or snow at time of observation",
      )
    98 =>
      NameKnown(
        "Thunderstorm combined with duststorm or sandstorm at time of observation",
      )
    99 => NameKnown("Thunderstorm, heavy, with hail* at time of observation")
    100 => NameKnown("No significant weather observed")
    101 =>
      NameKnown(
        "Clouds generally dissolving or becoming less developed during the past hour",
      )
    102 => NameKnown("State of sky on the whole unchanged during the past hour")
    103 =>
      NameKnown("Clouds generally forming or developing during the past hour")
    104 =>
      NameKnown(
        "Haze or smoke, or dust in suspension in the air, visibility equal to, or greater than, 1 km",
      )
    105 =>
      NameKnown(
        "Haze or smoke, or dust in suspension in the air, visibility less than 1 km",
      )
    110 => NameKnown("Mist")
    111 => NameKnown("Diamond dust")
    112 => NameKnown("Distant lightning")
    118 => NameKnown("Squalls")
    120 => NameKnown("Fog")
    121 => NameKnown("PRECIPITATION")
    122 => NameKnown("Drizzle (not freezing) or snow grains")
    123 => NameKnown("Rain (not freezing)")
    124 => NameKnown("Snow")
    125 => NameKnown("Freezing drizzle or freezing rain")
    126 => NameKnown("Thunderstorm (with or without precipitation)")
    127 => NameKnown("BLOWING OR DRIFTING SNOW OR SAND")
    128 =>
      NameKnown(
        "Blowing or drifting snow or sand, visibility equal to, or greater than, 1 km",
      )
    129 =>
      NameKnown("Blowing or drifting snow or sand, visibility less than 1 km")
    130 => NameKnown("FOG")
    131 => NameKnown("Fog or ice fog in patches")
    132 => NameKnown("Fog or ice fog, has become thinner during the past hour")
    133 =>
      NameKnown("Fog or ice fog, no appreciable change during the past hour")
    134 =>
      NameKnown(
        "Fog or ice fog, has begun or become thicker during the past hour",
      )
    135 => NameKnown("Fog, depositing rime")
    140 => NameKnown("PRECIPITATION")
    141 => NameKnown("Precipitation, slight or moderate")
    142 => NameKnown("Precipitation, heavy")
    143 => NameKnown("Liquid precipitation, slight or moderate")
    144 => NameKnown("Liquid precipitation, heavy")
    145 => NameKnown("Solid precipitation, slight or moderate")
    146 => NameKnown("Solid precipitation, heavy")
    147 => NameKnown("Freezing precipitation, slight or moderate")
    148 => NameKnown("Freezing precipitation, heavy")
    150 => NameKnown("DRIZZLE")
    151 => NameKnown("Drizzle, not freezing, slight")
    152 => NameKnown("Drizzle, not freezing, moderate")
    153 => NameKnown("Drizzle, not freezing, heavy")
    154 => NameKnown("Drizzle, freezing, slight")
    155 => NameKnown("Drizzle, freezing, moderate")
    156 => NameKnown("Drizzle, freezing, heavy")
    157 => NameKnown("Drizzle and rain, slight")
    158 => NameKnown("Drizzle and rain, moderate or heavy")
    160 => NameKnown("RAIN")
    161 => NameKnown("Rain, not freezing, slight")
    162 => NameKnown("Rain, not freezing, moderate")
    163 => NameKnown("Rain, not freezing, heavy")
    164 => NameKnown("Rain, freezing, slight")
    165 => NameKnown("Rain, freezing, moderate")
    166 => NameKnown("Rain, freezing, heavy")
    167 => NameKnown("Rain (or drizzle) and snow, slight")
    168 => NameKnown("Rain (or drizzle) and snow, moderate or heavy")
    170 => NameKnown("SNOW")
    171 => NameKnown("Snow, slight")
    172 => NameKnown("Snow, moderate")
    173 => NameKnown("Snow, heavy")
    174 => NameKnown("Ice pellets, slight")
    175 => NameKnown("Ice pellets, moderate")
    176 => NameKnown("Ice pellets, heavy")
    177 => NameKnown("Snow grains")
    178 => NameKnown("Ice crystals")
    180 => NameKnown("SHOWER(S) OR INTERMITTENT PRECIPITATION")
    181 => NameKnown("Rain shower(s) or intermittent rain, slight")
    182 => NameKnown("Rain shower(s) or intermittent rain, moderate")
    183 => NameKnown("Rain shower(s) or intermittent rain, heavy")
    184 => NameKnown("Rain shower(s) or intermittent rain, violent")
    185 => NameKnown("Snow shower(s) or intermittent snow, slight")
    186 => NameKnown("Snow shower(s) or intermittent snow, moderate")
    187 => NameKnown("Snow shower(s) or intermittent snow, heavy")
    189 => NameKnown("Hail")
    190 => NameKnown("THUNDERSTORM")
    191 => NameKnown("Thunderstorm, slight or moderate, with no precipitation")
    192 =>
      NameKnown(
        "Thunderstorm, slight or moderate, with rain showers and/or snow showers",
      )
    193 => NameKnown("Thunderstorm, slight or moderate, with hail")
    194 => NameKnown("Thunderstorm, heavy, with no precipitation")
    195 =>
      NameKnown("Thunderstorm, heavy, with rain showers and/or snow showers")
    196 => NameKnown("Thunderstorm, heavy, with hail")
    199 => NameKnown("Tornado")
    204 => NameKnown("Volcanic ash suspended in the air aloft")
    205 => NameKnown("Not used")
    206 => NameKnown("Thick dust haze, visibility less than 1 km")
    207 => NameKnown("Blowing spray at the station")
    208 => NameKnown("Drifting dust (sand)")
    209 => NameKnown("Wall of dust or sand in distance (like haboob)")
    210 => NameKnown("Snow haze")
    211 => NameKnown("Whiteout")
    212 => NameKnown("Not used")
    213 => NameKnown("Lightning, cloud to surface")
    217 => NameKnown("Dry thunderstorm")
    218 => NameKnown("Not used")
    219 =>
      NameKnown(
        "Tornado cloud (destructive) at or within sight of the station during preceding hour or at the time of observation",
      )
    220 => NameKnown("Deposition of volcanic ash")
    221 => NameKnown("Deposition of dust or sand")
    222 => NameKnown("Deposition of dew")
    223 => NameKnown("Deposition of wet snow")
    224 => NameKnown("Deposition of soft rime")
    225 => NameKnown("Deposition of hard rime")
    226 => NameKnown("Deposition of hoar frost")
    227 => NameKnown("Deposition of glaze")
    228 => NameKnown("Deposition of ice crust (ice slick)")
    229 => NameKnown("Not used")
    230 => NameKnown("Duststorm or sandstorm with temperature below 0 °C")
    239 =>
      NameKnown(
        "Blowing snow, impossible to determine whether snow is falling or not",
      )
    240 => NameKnown("Not used")
    241 => NameKnown("Fog on sea")
    242 => NameKnown("Fog in valleys")
    243 => NameKnown("Arctic or Antarctic sea smoke")
    244 => NameKnown("Steam fog (sea, lake or river)")
    245 => NameKnown("Steam log (land)")
    246 => NameKnown("Fog over ice or snow cover")
    247 => NameKnown("Dense fog, visibility 60-90 m")
    248 => NameKnown("Dense fog, visibility 30-60 m")
    249 => NameKnown("Dense fog, visibility less than 30 m")
    250 => NameKnown("Drizzle, rate of fall - less than 0.10 mm h-1")
    251 => NameKnown("Drizzle, rate of fall - 0.10-0.19 mm h-1")
    252 => NameKnown("Drizzle, rate of fall - 0.20-0.39 mm h-1")
    253 => NameKnown("Drizzle, rate of fall - 0.40-0.79 mm h-1")
    254 => NameKnown("Drizzle, rate of fall - 0.80-1.59 mm h-1")
    255 => NameKnown("Drizzle, rate of fall - 1.60-3.19 mm h-1")
    256 => NameKnown("Drizzle, rate of fall - 3.20-6.39 mm h-1")
    257 => NameKnown("Drizzle, rate of fall - 6.4 mm h-1 or more")
    258 => NameKnown("Not used")
    259 => NameKnown("Drizzle and snow")
    260 => NameKnown("Rain, rate of fall - less than 1.0 mm h-1")
    261 => NameKnown("Rain, rate of fall - 1.0-1.9 mm h-1")
    262 => NameKnown("Rain, rate of fall - 2.0-3.9 mm h-1")
    263 => NameKnown("Rain, rate of fall - 4.0-7.9 mm h-1")
    264 => NameKnown("Rain, rate of fall - 8.0-15.9 mm h-1")
    265 => NameKnown("Rain, rate of fall - 16.0-31.9 mm h-1")
    266 => NameKnown("Rain, rate of fall - 32.0-63.9 mm h-1")
    267 => NameKnown("Rain, rate of fall - 64.0 mm h-1 or more")
    270 => NameKnown("Snow, rate of fall - less than 1.0 cm h-1")
    271 => NameKnown("Snow, rate of fall - 1.0-1.9 cm h-1")
    272 => NameKnown("Snow, rate of fall - 2.0-3.9 cm h-1")
    273 => NameKnown("Snow, rate of fall - 4.0-7.9 cm h-1")
    274 => NameKnown("Snow, rate of fall - 8.0-15.9 cm h-1")
    275 => NameKnown("Snow, rate of fall - 16.0-31.9 cm h-1")
    276 => NameKnown("Snow, rate of fall - 32.0-63.9 cm h-1")
    277 => NameKnown("Snow, rate of fall - 64.0 cm h-1 or more")
    278 => NameKnown("Snow or ice crystal precipitation from a clear sky")
    279 => NameKnown("Wet snow, freezing on contact")
    280 => NameKnown("Precipitation of rain")
    281 => NameKnown("Precipitation of rain, freezing")
    282 => NameKnown("Precipitation of rain and snow mixed")
    283 => NameKnown("Precipitation of snow")
    284 => NameKnown("Precipitation of snow pellets or small hall")
    285 => NameKnown("Precipitation of snow pellets or small hail, with rain")
    286 =>
      NameKnown(
        "Precipitation of snow pellets or small hail, with rain and snow mixed",
      )
    287 => NameKnown("Precipitation of snow pellets or small hail, with snow")
    288 => NameKnown("Precipitation of hail")
    289 => NameKnown("Precipitation of hail, with rain")
    290 => NameKnown("Precipitation of hall, with rain and snow mixed")
    291 => NameKnown("Precipitation of hail, with snow")
    292 => NameKnown("Shower(s) or thunderstorm over sea")
    293 => NameKnown("Shower(s) or thunderstorm over mountains")
    508 =>
      NameKnown(
        "No significant phenomenon to report, present and past weather omitted",
      )
    509 =>
      NameKnown(
        "No observation, data not available, present and past weather omitted",
      )
    510 => NameKnown("Present and past weather missing, but expected")
    511 => NameKnown("Missing value")
    _ =>
      if value >= 0 && value <= 511 {
        NameKnown("Reserved")
      } else {
        NameUnknown("weather=" + value.to_string())
      }
  }
}

///|
pub fn decode_icing_scenario_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("General")
    2 => NameKnown("Convective")
    3 => NameKnown("Stratiform")
    4 => NameKnown("Freezing")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("icing_scenario=" + value.to_string())
      }
  }
}

///|
pub fn decode_icing_severity_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Trace")
    2 => NameKnown("Light")
    3 => NameKnown("Moderate")
    4 => NameKnown("Severe")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("icing_severity=" + value.to_string())
      }
  }
}

///|
pub fn decode_aerosol_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Ozone")
    1 => NameKnown("Water Vapour")
    2 => NameKnown("Methane")
    3 => NameKnown("Carbon Dioxide")
    4 => NameKnown("Carbon Monoxide")
    5 => NameKnown("Nitrogen Dioxide")
    6 => NameKnown("Nitrous Oxide")
    7 => NameKnown("Formaldehyde")
    8 => NameKnown("Sulphur Dioxide")
    9 => NameKnown("Ammonia")
    10 => NameKnown("Ammonium")
    11 => NameKnown("Nitrogen Monoxide")
    12 => NameKnown("Atomic Oxygen")
    13 => NameKnown("Nitrate Radical")
    14 => NameKnown("Hydroperoxyl Radical")
    15 => NameKnown("Dinitrogen Pentoxide")
    16 => NameKnown("Nitrous Acid")
    17 => NameKnown("Nitric Acid")
    18 => NameKnown("Peroxynitric Acid")
    19 => NameKnown("Hydrogen Peroxide")
    20 => NameKnown("Molecular Hydrogen")
    21 => NameKnown("Atomic Nitrogen")
    22 => NameKnown("Sulphate")
    23 => NameKnown("Radon")
    24 => NameKnown("Elemental Mercury")
    25 => NameKnown("Divalent Mercury")
    26 => NameKnown("Atomic Chlorine")
    27 => NameKnown("Chlorine Monoxide")
    28 => NameKnown("Dichlorine Peroxide")
    29 => NameKnown("Hypochlorous Acid")
    30 => NameKnown("Chlorine Nitrate")
    31 => NameKnown("Chlorine Dioxide")
    32 => NameKnown("Atomic Bromide")
    33 => NameKnown("Bromine Monoxide")
    34 => NameKnown("Bromine Chloride")
    35 => NameKnown("Hydrogen Bromide")
    36 => NameKnown("Hypobromous Acid")
    37 => NameKnown("Bromine Nitrate")
    38 => NameKnown("Oxygen")
    10000 => NameKnown("Hydroxyl Radical")
    10001 => NameKnown("Methyl Peroxy Radical")
    10002 => NameKnown("Methyl Hydroperoxide")
    10004 => NameKnown("Methanol")
    10005 => NameKnown("Formic Acid")
    10006 => NameKnown("Hydrogen Cyanide")
    10007 => NameKnown("Aceto Nitrile")
    10008 => NameKnown("Ethane")
    10009 => NameKnown("Ethene (= Ethylene)")
    10010 => NameKnown("Ethyne (= Acetylene)")
    10011 => NameKnown("Ethanol")
    10012 => NameKnown("Acetic Acid")
    10013 => NameKnown("Peroxyacetyl Nitrate")
    10014 => NameKnown("Propane")
    10015 => NameKnown("Propene")
    10016 => NameKnown("Butanes")
    10017 => NameKnown("Isoprene")
    10018 => NameKnown("Alpha Pinene")
    10019 => NameKnown("Beta Pinene")
    10020 => NameKnown("Limonene")
    10021 => NameKnown("Benzene")
    10022 => NameKnown("Toluene")
    10023 => NameKnown("Xylene")
    10500 => NameKnown("Dimethyl Sulphide")
    20001 => NameKnown("Hydrogen Chloride")
    20002 => NameKnown("CFC-11")
    20003 => NameKnown("CFC-12")
    20004 => NameKnown("CFC-113")
    20005 => NameKnown("CFC-113a")
    20006 => NameKnown("CFC-114")
    20007 => NameKnown("CFC-115")
    20008 => NameKnown("HCFC-22")
    20009 => NameKnown("HCFC-141b")
    20010 => NameKnown("HCFC-142b")
    20011 => NameKnown("Halon-1202")
    20012 => NameKnown("Halon-1211")
    20013 => NameKnown("Halon-1301")
    20014 => NameKnown("Halon-2402")
    20015 => NameKnown("Methyl Chloride (HCC-40)")
    20016 => NameKnown("Carbon Tetrachloride (HCC-10)")
    20017 => NameKnown("HCC-140a")
    20018 => NameKnown("Methyl Bromide (HBC-40B1)")
    20019 => NameKnown("Hexachlorocyclohexane (HCH)")
    20020 => NameKnown("Alpha Hexachlorocyclohexane")
    20021 => NameKnown("Hexachlorobiphenyl (PCB-153)")
    30000 =>
      NameKnown("Radioactive Pollutant (Tracer, defined by originating centre)")
    60000 => NameKnown("HOx Radical (OH+HO2)")
    60001 => NameKnown("Total Inorganic and Organic Peroxy Radicals (HO2+RO2)")
    60002 => NameKnown("Passive Ozone")
    60003 => NameKnown("NOx Expressed As Nitrogen")
    60004 => NameKnown("All Nitrogen Oxides (NOy) Expressed As Nitrogen")
    60005 => NameKnown("Total Inorganic Chlorine")
    60006 => NameKnown("Total Inorganic Bromine")
    60007 => NameKnown("Total Inorganic Chlorine Except HCl, ClONO2: ClOx")
    60008 => NameKnown("Total Inorganic Bromine Except HBr, BrONO2: BrOx")
    60009 => NameKnown("Lumped Alkanes")
    60010 => NameKnown("Lumped Alkenes")
    60011 => NameKnown("Lumped Aromatic Coumpounds")
    60012 => NameKnown("Lumped Terpenes")
    60013 =>
      NameKnown("Non-Methane Volatile Organic Compounds Expressed as Carbon")
    60014 =>
      NameKnown(
        "Anthropogenic Non-Methane Volatile Organic Compounds Expressed as Carbon",
      )
    60015 =>
      NameKnown(
        "Biogenic Non-Methane Volatile Organic Compounds Expressed as Carbon",
      )
    60016 => NameKnown("Lumped Oxygenated Hydrocarbons")
    62000 => NameKnown("Total Aerosol")
    62001 => NameKnown("Dust Dry")
    62002 => NameKnown("water In Ambient")
    62003 => NameKnown("Ammonium Dry")
    62004 => NameKnown("Nitrate Dry")
    62005 => NameKnown("Nitric Acid Trihydrate")
    62006 => NameKnown("Sulphate Dry")
    62007 => NameKnown("Mercury Dry")
    62008 => NameKnown("Sea Salt Dry")
    62009 => NameKnown("Black Carbon Dry")
    62010 => NameKnown("Particulate Organic Matter Dry")
    62011 => NameKnown("Primary Particulate Organic Matter Dry")
    62012 => NameKnown("Secondary Particulate Organic Matter Dry")
    62013 => NameKnown("Black carbon hydrophilic dry")
    62014 => NameKnown("Black carbon hydrophobic dry")
    62015 => NameKnown("Particulate organic matter hydrophilic dry")
    62016 => NameKnown("Particulate organic matter hydrophobic dry")
    62017 => NameKnown("Nitrate hydrophilic dry")
    62018 => NameKnown("Nitrate hydrophobic dry")
    62020 => NameKnown("Smoke - high absorption")
    62021 => NameKnown("Smoke - low absorption")
    62022 => NameKnown("Aerosol - high absorption")
    62023 => NameKnown("Aerosol - low absorption")
    62025 => NameKnown("Volcanic ash")
    62036 => NameKnown("Brown Carbon Dry")
    65535 => NameKnown("Missing")
    _ =>
      if (value >= 39 && value <= 9999) ||
        value == 10003 ||
        (value >= 10024 && value <= 10499) ||
        (value >= 10501 && value <= 20000) ||
        (value >= 20022 && value <= 29999) ||
        (value >= 30001 && value <= 50000) ||
        (value >= 60017 && value <= 61999) ||
        value == 62019 ||
        value == 62024 ||
        (value >= 62037 && value <= 65534) {
        NameKnown("Reserved")
      } else {
        NameUnknown("aerosol_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_atmospheric_chemical_or_physical_constituent_type_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Ozone")
    1 => NameKnown("Water Vapor")
    2 => NameKnown("Methane")
    3 => NameKnown("Carbon Dioxide")
    4 => NameKnown("Carbon Monoxide")
    5 => NameKnown("Nitrogen Dioxide")
    6 => NameKnown("Nitrous Oxide")
    7 => NameKnown("Formaldehyde")
    8 => NameKnown("Sulfur Dioxide")
    9 => NameKnown("Ammonia")
    10 => NameKnown("Ammonium Cation")
    11 => NameKnown("Nitrogen Monoxide")
    12 => NameKnown("Atomic Oxygen")
    13 => NameKnown("Nitrate Radical")
    14 => NameKnown("Hydroperoxyl Radical")
    15 => NameKnown("Dinitrogen Pentoxide")
    16 => NameKnown("Nitrous Acid")
    17 => NameKnown("Nitric Acid")
    18 => NameKnown("Peroxynitric Acid")
    19 => NameKnown("Hydrogen Peroxide")
    20 => NameKnown("Dihydrogen")
    21 => NameKnown("Atomic Nitrogen")
    22 => NameKnown("Sulfate Anion")
    23 => NameKnown("Atomic Radon")
    24 => NameKnown("Mercury Vapor")
    25 => NameKnown("Mercury(II) Cation")
    26 => NameKnown("Atomic Chlorine")
    27 => NameKnown("Chlorine Monoxide")
    28 => NameKnown("Dichlorine Peroxide")
    29 => NameKnown("Hypochlorous Acid")
    30 => NameKnown("Chlorine Nitrate")
    31 => NameKnown("Chlorine Dioxide")
    32 => NameKnown("Atomic Bromine")
    33 => NameKnown("Bromine Monoxide")
    34 => NameKnown("Bromine Chloride")
    35 => NameKnown("Hydrogen Bromide")
    36 => NameKnown("Hypobromous Acid")
    37 => NameKnown("Bromine Nitrate")
    38 => NameKnown("Dioxygen")
    39 => NameKnown("Nitryl Chloride")
    40 => NameKnown("Sulfuric Acid")
    41 => NameKnown("Hydrogen Sulfide")
    42 => NameKnown("Sulfur Trioxide")
    43 => NameKnown("Bromine")
    44 => NameKnown("Hydrofluoric Acid")
    45 => NameKnown("Sulfur Hexafluoride")
    46 => NameKnown("Chlorine")
    10000 => NameKnown("Hydroxyl Radical")
    10001 => NameKnown("Methyl Peroxy Radical")
    10002 => NameKnown("Methyl Hydroperoxide")
    10004 => NameKnown("Methanol")
    10005 => NameKnown("Formic Acid")
    10006 => NameKnown("Hydrogen Cyanide")
    10007 => NameKnown("Aceto Nitrile")
    10008 => NameKnown("Ethane")
    10009 => NameKnown("Ethene (= Ethylene)")
    10010 => NameKnown("Ethyne (= Acetylene)")
    10011 => NameKnown("Ethanol")
    10012 => NameKnown("Acetic Acid")
    10013 => NameKnown("Peroxyacetyl Nitrate")
    10014 => NameKnown("Propane")
    10015 => NameKnown("Propene")
    10016 => NameKnown("Butane (all isomers)")
    10017 => NameKnown("Isoprene")
    10018 => NameKnown("Alpha Pinene")
    10019 => NameKnown("Beta Pinene")
    10020 => NameKnown("Limonene")
    10021 => NameKnown("Benzene")
    10022 => NameKnown("Toluene")
    10023 => NameKnown("Xylene")
    10024 => NameKnown("Methanesulfonic Acid")
    10025 => NameKnown("Methylglyoxal (2-Oxopropanal)")
    10026 => NameKnown("Peroxyacetyl Radical")
    10027 => NameKnown("Methacrylic Acid (2-Methylprop-2-Enoic Acid)")
    10028 => NameKnown("Methacrolein (2-Methylprop-2-Enal)")
    10029 => NameKnown("Acetone (Propan-2-One)")
    10030 => NameKnown("Ethyl Dioxidanyl Radical")
    10031 => NameKnown("Butadiene (Buta-1,3-Diene)")
    10032 => NameKnown("Acetaldehyde (Ethanal)")
    10033 => NameKnown("Glycolaldehyde (Hydroxyethanal)")
    10034 => NameKnown("Cresol (Methylphenol), All Isomers")
    10035 => NameKnown("Peracetic Acid (Ethaneperoxoic Acid)")
    10036 => NameKnown("2-Hydroxyethyl Oxidanyl Radical")
    10037 => NameKnown("2-Hydroxyethyl Dioxidanyl Radical")
    10038 => NameKnown("Glyoxal (Oxaldehyde)")
    10039 => NameKnown("Isopropyl Dioxidanyl Radical")
    10040 => NameKnown("Isopropyl Hydroperoxide (2-Hydroperoxypropane)")
    10041 => NameKnown("Hydroxyacetone (1-Hydroxypropan-2-One)")
    10042 => NameKnown("Peroxyacetic Acid (Ethaneperoxoic Acid)")
    10043 => NameKnown("Methyl Vinyl Ketone (But-3-En-2-One)")
    10044 => NameKnown("Phenoxy Radical")
    10045 => NameKnown("Methyl Radical")
    10046 => NameKnown("Carbonyl Sulfide (Carbon Oxide Sulfide)")
    10047 => NameKnown("Dibromomethane")
    10048 => NameKnown("Methoxy Radical")
    10049 => NameKnown("Tribromomethane")
    10050 => NameKnown("Formyl Radical (Oxomethyl Radical)")
    10051 => NameKnown("Hydroxymethyl Dioxidanyl Radical")
    10052 => NameKnown("Ethyl Hydroperoxide")
    10053 => NameKnown("3-Hydroxypropyl Dioxidanyl Radical")
    10054 => NameKnown("3-Hydroxypropyl Hydroperoxide")
    10055 => NameKnown("Methyl-Peroxy-Nitrate (Nitroperoxy-Methane)")
    10056 => NameKnown("4-Hydroxy-3-Methyl-1-Butene-3-Ylperoxy Radical")
    10057 => NameKnown("2-Hydroxy-1-Isopropenylethylperoxy Radical")
    10058 => NameKnown("(Z)-4-Hydroperoxy-2-Methyl-2-Butenal")
    10059 => NameKnown("(Z)-4-Hydroperoxy-3-Methyl-2-Butenal")
    10060 => NameKnown("Butene")
    10061 => NameKnown("Pentene")
    10062 => NameKnown("Hexene")
    10063 => NameKnown("Heptene")
    10064 => NameKnown("Octene")
    10065 => NameKnown("Pentane")
    10066 => NameKnown("Hexane")
    10067 => NameKnown("Heptane")
    10068 => NameKnown("Octane")
    10500 => NameKnown("Dimethyl Sulfide")
    10501 => NameKnown("Dimethyl Sulfoxide")
    20001 => NameKnown("Hydrogen Chloride")
    20002 => NameKnown("CFC-11")
    20003 => NameKnown("CFC-12")
    20004 => NameKnown("CFC-113")
    20005 => NameKnown("CFC-113a")
    20006 => NameKnown("CFC-114")
    20007 => NameKnown("CFC-115")
    20008 => NameKnown("HCFC-22")
    20009 => NameKnown("HCFC-141b")
    20010 => NameKnown("HCFC-142b")
    20011 => NameKnown("Halon-1202")
    20012 => NameKnown("Halon-1211")
    20013 => NameKnown("Halon-1301")
    20014 => NameKnown("Halon-2402")
    20015 => NameKnown("Methyl Chloride (HCC-40)")
    20016 => NameKnown("Carbon Tetrachloride (HCC-10)")
    20017 => NameKnown("HCC-140a")
    20018 => NameKnown("Methyl Bromide (HBC-40B1)")
    20019 => NameKnown("Hexachlorocyclohexane (HCH)")
    20020 => NameKnown("Alpha Hexachlorocyclohexane")
    20021 => NameKnown("Hexachlorobiphenyl (PCB-153)")
    20022 => NameKnown("HCFC-141a")
    30000 =>
      NameKnown("Radioactive Pollutant (Tracer, defined by originating centre)")
    30010 => NameKnown("Tritium (Hydrogen-3)")
    30011 => NameKnown("Tritium Organic Bonded")
    30012 => NameKnown("Tritium Inorganic")
    30013 => NameKnown("Beryllium 7")
    30014 => NameKnown("Beryllium 10")
    30015 => NameKnown("Carbon 14")
    30016 => NameKnown("Carbon 14 CO2")
    30017 => NameKnown("Carbon 14 Other Gases")
    30018 => NameKnown("Nitrogen 13")
    30019 => NameKnown("Nitrogen 16")
    30020 => NameKnown("Fluorine 18")
    30021 => NameKnown("Sodium 22")
    30022 => NameKnown("Phosphate 32")
    30023 => NameKnown("Phosphate 33")
    30024 => NameKnown("Sulfur 35")
    30025 => NameKnown("Chlorine 36")
    30026 => NameKnown("Potassium 40")
    30027 => NameKnown("Argon 41")
    30028 => NameKnown("Calcium 41")
    30029 => NameKnown("Calcium 45")
    30030 => NameKnown("Titanium 44")
    30031 => NameKnown("Scandium 46")
    30032 => NameKnown("Vanadium 48")
    30033 => NameKnown("Vanadium 49")
    30034 => NameKnown("Chrome 51")
    30035 => NameKnown("Manganese 52")
    30036 => NameKnown("Manganese 54")
    30037 => NameKnown("Iron 55")
    30038 => NameKnown("Iron 59")
    30039 => NameKnown("Cobalt 56")
    30040 => NameKnown("Cobalt 57")
    30041 => NameKnown("Cobalt 58")
    30042 => NameKnown("Cobalt 60")
    30043 => NameKnown("Nickel 59")
    30044 => NameKnown("Nickel 63")
    30045 => NameKnown("Zinc 65")
    30046 => NameKnown("Gallium 67")
    30047 => NameKnown("Gallium 68")
    30048 => NameKnown("Germanium 68")
    30049 => NameKnown("Germanium 69")
    30050 => NameKnown("Arsenic 73")
    30051 => NameKnown("Selenium 75")
    30052 => NameKnown("Selenium 79")
    30053 => NameKnown("Rubidium 81")
    30054 => NameKnown("Rubidium 83")
    30055 => NameKnown("Rubidium 84")
    30056 => NameKnown("Rubidium 86")
    30057 => NameKnown("Rubidium 87")
    30058 => NameKnown("Rubidium 88")
    30059 => NameKnown("Krypton 85")
    30060 => NameKnown("Krypton 85 metastable")
    30061 => NameKnown("Krypton 87")
    30062 => NameKnown("Krypton 88")
    30063 => NameKnown("Krypton 89")
    30064 => NameKnown("Strontium 85")
    30065 => NameKnown("Strontium 89")
    30066 => NameKnown("Strontium 89/90")
    30067 => NameKnown("Strontium 90")
    30068 => NameKnown("Strontium 91")
    30069 => NameKnown("Strontium 92")
    30070 => NameKnown("Yttrium 87")
    30071 => NameKnown("Yttrium 88")
    30072 => NameKnown("Yttrium 90")
    30073 => NameKnown("Yttrium 91")
    30074 => NameKnown("Yttrium 91 metastable")
    30075 => NameKnown("Yttrium 92")
    30076 => NameKnown("Yttrium 93")
    30077 => NameKnown("Zirconium 89")
    30078 => NameKnown("Zirconium 93")
    30079 => NameKnown("Zirconium 95")
    30080 => NameKnown("Zirconium 97")
    30081 => NameKnown("Niobium 93 metastable")
    30082 => NameKnown("Niobium 94")
    30083 => NameKnown("Niobium 95")
    30084 => NameKnown("Niobium 95 metastable")
    30085 => NameKnown("Niobium 97")
    30086 => NameKnown("Niobium 97 metastable")
    30087 => NameKnown("Molybdenum 93")
    30088 => NameKnown("Molybdenum 99")
    30089 => NameKnown("Technetium 95 metastable")
    30090 => NameKnown("Technetium 96")
    30091 => NameKnown("Technetium 99")
    30092 => NameKnown("Technetium 99 metastable")
    30093 => NameKnown("Rhodium 99")
    30094 => NameKnown("Rhodium 101")
    30095 => NameKnown("Rhodium 102 metastable")
    30096 => NameKnown("Rhodium 103 metastable")
    30097 => NameKnown("Rhodium 105")
    30098 => NameKnown("Rhodium 106")
    30099 => NameKnown("Palladium 100")
    30100 => NameKnown("Palladium 103")
    30101 => NameKnown("Palladium 107")
    30102 => NameKnown("Ruthenium 103")
    30103 => NameKnown("Ruthenium 105")
    30104 => NameKnown("Ruthenium 106")
    30105 => NameKnown("Silver 108 metastable")
    30106 => NameKnown("Silver 110 metastable")
    30107 => NameKnown("Cadmium 109")
    30108 => NameKnown("Cadmium 113 metastable")
    30109 => NameKnown("Cadmium 115 metastable")
    30110 => NameKnown("Indium 114 metastable")
    30111 => NameKnown("Tin 113")
    30112 => NameKnown("Tin 119 metastable")
    30113 => NameKnown("Tin 121 metastable")
    30114 => NameKnown("Tin 122")
    30115 => NameKnown("Tin 123")
    30116 => NameKnown("Tin 126")
    30117 => NameKnown("Antimony 124")
    30118 => NameKnown("Antimony 125")
    30119 => NameKnown("Antimony 126")
    30120 => NameKnown("Antimony 127")
    30121 => NameKnown("Antimony 129")
    30122 => NameKnown("Tellurium 123 metastable")
    30123 => NameKnown("Tellurium 125 metastable")
    30124 => NameKnown("Tellurium 127")
    30125 => NameKnown("Tellurium 127 metastable")
    30126 => NameKnown("Tellurium 129")
    30127 => NameKnown("Tellurium 129 metastable")
    30128 => NameKnown("Tellurium 131 metastable")
    30129 => NameKnown("Tellurium 132")
    30130 => NameKnown("Iodine 123")
    30131 => NameKnown("Iodine 124")
    30132 => NameKnown("Iodine 125")
    30133 => NameKnown("Iodine 126")
    30134 => NameKnown("Iodine 129")
    30135 => NameKnown("Iodine 129 elementary gaseous")
    30136 => NameKnown("Iodine 129 organic bonded")
    30137 => NameKnown("Iodine 131")
    30138 => NameKnown("Iodine 131 elementary gaseous")
    30139 => NameKnown("Iodine 131 organic bonded")
    30140 => NameKnown("Iodine 131 elementary gaseous and organic bonded")
    30141 => NameKnown("Iodine 131 aerosol")
    30142 => NameKnown("Iodine 132")
    30143 => NameKnown("Iodine 132 elementary gaseous")
    30144 => NameKnown("Iodine 132 organic bonded")
    30145 => NameKnown("Iodine 132 elementary gaseous and organic bonded")
    30146 => NameKnown("Iodine 132 aerosol")
    30147 => NameKnown("Iodine 133")
    30148 => NameKnown("Iodine 133 elementary gaseous")
    30149 => NameKnown("Iodine 133 organic bonded")
    30150 => NameKnown("Iodine 133 elementary gaseous and organic bonded")
    30151 => NameKnown("Iodine 133 aerosol")
    30152 => NameKnown("Iodine 134")
    30153 => NameKnown("Iodine 134 elementary gaseous")
    30154 => NameKnown("Iodine 134 organic bonded")
    30155 => NameKnown("Iodine 135")
    30156 => NameKnown("Iodine 135 elementary gaseous")
    30157 => NameKnown("Iodine 135 organic bonded")
    30158 => NameKnown("Iodine 135 elementary gaseous and organic bonded")
    30159 => NameKnown("Iodine 135 aerosol")
    30160 => NameKnown("Xenon 131 metastable")
    30161 => NameKnown("Xenon 133")
    30162 => NameKnown("Xenon 133 metastable")
    30163 => NameKnown("Xenon 135")
    30164 => NameKnown("Xenon 135 metastable")
    30165 => NameKnown("Xenon 137")
    30166 => NameKnown("Xenon 138")
    30167 => NameKnown("Xenon sum of all Xenon isotopes")
    30168 => NameKnown("Caesium 131")
    30169 => NameKnown("Caesium 134")
    30170 => NameKnown("Caesium 135")
    30171 => NameKnown("Caesium 136")
    30172 => NameKnown("Caesium 137")
    30173 => NameKnown("Barium 133")
    30174 => NameKnown("Barium 137 metastable")
    30175 => NameKnown("Barium 140")
    30176 => NameKnown("Cerium 139")
    30177 => NameKnown("Cerium 141")
    30178 => NameKnown("Cerium 143")
    30179 => NameKnown("Cerium 144")
    30180 => NameKnown("Lanthanum 140")
    30181 => NameKnown("Lanthanum 141")
    30182 => NameKnown("Praseodymium 143")
    30183 => NameKnown("Praseodymium 144")
    30184 => NameKnown("Praseodymium 144 metastable")
    30185 => NameKnown("Samarium 145")
    30186 => NameKnown("Samarium 147")
    30187 => NameKnown("Samarium 151")
    30188 => NameKnown("Neodymium 147")
    30189 => NameKnown("Promethium 146")
    30190 => NameKnown("Promethium 147")
    30191 => NameKnown("Promethium 151")
    30192 => NameKnown("Europium 152")
    30193 => NameKnown("Europium 154")
    30194 => NameKnown("Europium 155")
    30195 => NameKnown("Gadolinium 153")
    30196 => NameKnown("Terbium 160")
    30197 => NameKnown("Holmium 166 metastable")
    30198 => NameKnown("Thulium 170")
    30199 => NameKnown("Ytterbium 169")
    30200 => NameKnown("Hafnium 175")
    30201 => NameKnown("Hafnium 181")
    30202 => NameKnown("Tantalum 179")
    30203 => NameKnown("Tantalum 182")
    30204 => NameKnown("Rhenium 184")
    30205 => NameKnown("Iridium 192")
    30206 => NameKnown("Mercury 203")
    30207 => NameKnown("Thallium 204")
    30208 => NameKnown("Thallium 207")
    30209 => NameKnown("Thallium 208")
    30210 => NameKnown("Thallium 209")
    30211 => NameKnown("Bismuth 205")
    30212 => NameKnown("Bismuth 207")
    30213 => NameKnown("Bismuth 210")
    30214 => NameKnown("Bismuth 211")
    30215 => NameKnown("Bismuth 212")
    30216 => NameKnown("Bismuth 213")
    30217 => NameKnown("Bismuth 214")
    30218 => NameKnown("Polonium 208")
    30219 => NameKnown("Polonium 210")
    30220 => NameKnown("Polonium 212")
    30221 => NameKnown("Polonium 213")
    30222 => NameKnown("Polonium 214")
    30223 => NameKnown("Polonium 215")
    30224 => NameKnown("Polonium 216")
    30225 => NameKnown("Polonium 218")
    30226 => NameKnown("Lead 209")
    30227 => NameKnown("Lead 210")
    30228 => NameKnown("Lead 211")
    30229 => NameKnown("Lead 212")
    30230 => NameKnown("Lead 214")
    30231 => NameKnown("Astatine 217")
    30232 => NameKnown("Radon 219")
    30233 => NameKnown("Radon 220")
    30234 => NameKnown("Radon 222")
    30235 => NameKnown("Francium 221")
    30236 => NameKnown("Francium 223")
    30237 => NameKnown("Radium 223")
    30238 => NameKnown("Radium 224")
    30239 => NameKnown("Radium 225")
    30240 => NameKnown("Radium 226")
    30241 => NameKnown("Radium 228")
    30242 => NameKnown("Actinium 225")
    30243 => NameKnown("Actinium 227")
    30244 => NameKnown("Actinium 228")
    30245 => NameKnown("Thorium 227")
    30246 => NameKnown("Thorium 228")
    30247 => NameKnown("Thorium 229")
    30248 => NameKnown("Thorium 230")
    30249 => NameKnown("Thorium 231")
    30250 => NameKnown("Thorium 232")
    30251 => NameKnown("Thorium 234")
    30252 => NameKnown("Protactinium 231")
    30253 => NameKnown("Protactinium 233")
    30254 => NameKnown("Protactinium 234 metastable")
    30255 => NameKnown("Uranium 232")
    30256 => NameKnown("Uranium 233")
    30257 => NameKnown("Uranium 234")
    30258 => NameKnown("Uranium 235")
    30259 => NameKnown("Uranium 236")
    30260 => NameKnown("Uranium 237")
    30261 => NameKnown("Uranium 238")
    30262 => NameKnown("Plutonium 236")
    30263 => NameKnown("Plutonium 238")
    30264 => NameKnown("Plutonium 239")
    30265 => NameKnown("Plutonium 240")
    30266 => NameKnown("Plutonium 241")
    30267 => NameKnown("Plutonium 242")
    30268 => NameKnown("Plutonium 244")
    30269 => NameKnown("Neptunium 237")
    30270 => NameKnown("Neptunium 238")
    30271 => NameKnown("Neptunium 239")
    30272 => NameKnown("Americium 241")
    30273 => NameKnown("Americium 242")
    30274 => NameKnown("Americium 242 metastable")
    30275 => NameKnown("Americium 243")
    30276 => NameKnown("Curium 242")
    30277 => NameKnown("Curium 243")
    30278 => NameKnown("Curium 244")
    30279 => NameKnown("Curium 245")
    30280 => NameKnown("Curium 246")
    30281 => NameKnown("Curium 247")
    30282 => NameKnown("Curium 248")
    30283 => NameKnown("Curium 243/244")
    30284 => NameKnown("Plutonium 238/Americium 241")
    30285 => NameKnown("Plutonium 239/240")
    30286 => NameKnown("Berkelium 249")
    30287 => NameKnown("Californium 249")
    30288 => NameKnown("Californium 250")
    30289 => NameKnown("Californium 252")
    30290 => NameKnown("Sum Aerosol Particulates")
    30291 => NameKnown("Sum Iodine")
    30292 => NameKnown("Sum Noble Gas")
    30293 => NameKnown("Activation Gas")
    30294 => NameKnown("Cs-137 Equivalent")
    30295 => NameKnown("Carbon-13")
    30296 => NameKnown("Lead")
    30297 => NameKnown("Tellurium 131")
    30298 => NameKnown("Neodymium 137")
    30299 => NameKnown("Pseudo Radionuclide")
    30300 => NameKnown("Silver 112")
    30301 => NameKnown("Silver 115")
    30302 => NameKnown("Barium 139")
    30303 => NameKnown("Barium 141")
    30304 => NameKnown("Barium 142")
    30305 => NameKnown("Bromine 84")
    30306 => NameKnown("Cadmium 115")
    30307 => NameKnown("Cadmium 117")
    30308 => NameKnown("Cadmium 117 metastable")
    30309 => NameKnown("Cerium 145")
    30310 => NameKnown("Cerium 146")
    30311 => NameKnown("Cobalt 58 metastable")
    30312 => NameKnown("Caesium 138")
    30313 => NameKnown("Caesium 139")
    30314 => NameKnown("Iodine 130 Aerosol")
    30315 => NameKnown("Iodine 130 Elementary Gaseous")
    30316 => NameKnown("Iodine 130 Organic Bonded")
    30317 => NameKnown("Iodine 132 Metastable")
    30318 => NameKnown("Iodine 134 Metastable")
    30319 => NameKnown("Indium 115 Metastable")
    30320 => NameKnown("Indium 117 Metastable")
    30321 => NameKnown("Krypton 83 Metastable")
    30322 => NameKnown("Lanthanum 142")
    30323 => NameKnown("Lanthanum 143")
    30324 => NameKnown("Manganese 56")
    30325 => NameKnown("Molybdenum 101")
    30326 => NameKnown("Molybdenum 102")
    30327 => NameKnown("Neodymium 149")
    30328 => NameKnown("Neodymium 151")
    30329 => NameKnown("Palladium 109")
    30330 => NameKnown("Palladium 112")
    30331 => NameKnown("Praseodymium 145")
    30332 => NameKnown("Praseodymium 146")
    30333 => NameKnown("Praseodymium 147")
    30334 => NameKnown("Rubidium 89")
    30335 => NameKnown("Rubidium 90")
    30336 => NameKnown("Rubidium 90 metastable")
    30337 => NameKnown("Rhodium 105 metastable")
    30338 => NameKnown("Rhodium 107")
    30339 => NameKnown("Antimony 128")
    30340 => NameKnown("Antimony 128 metastable")
    30341 => NameKnown("Antimony 129 metastable")
    30342 => NameKnown("Antimony 130")
    30343 => NameKnown("Antimony 130 metastable")
    30344 => NameKnown("Antimony 131")
    30345 => NameKnown("Antimony 132")
    30346 => NameKnown("Antimony 132 metastable")
    30347 => NameKnown("Antimony 133")
    30348 => NameKnown("Selenium 83")
    30349 => NameKnown("Tin 127")
    30350 => NameKnown("Tin 127 metastable")
    30351 => NameKnown("Tin 128")
    30352 => NameKnown("Tin 129 metastable")
    30353 => NameKnown("Tin 130")
    30354 => NameKnown("Strontium 93")
    30355 => NameKnown("Technetium 101")
    30356 => NameKnown("Technetium 102")
    30357 => NameKnown("Technetium 104")
    30358 => NameKnown("Technetium 105")
    30359 => NameKnown("Tellurium 133")
    30360 => NameKnown("Tellurium 133 metastable")
    30361 => NameKnown("Tellurium 134")
    30362 => NameKnown("Yttrium 93 metastable")
    30363 => NameKnown("Yttrium 94")
    30364 => NameKnown("Yttrium 95")
    30365 => NameKnown("Zirconium 96")
    30366 => NameKnown("Indium 117")
    30367 => NameKnown("Lead 203")
    30368 => NameKnown("Sodium 24")
    30369 => NameKnown("Ruthenium 107")
    30370 => NameKnown("Uranium 239")
    40000 => NameKnown("Singlet Sigma Oxygen (Dioxygen (Sigma Singlet))")
    40001 => NameKnown("Singlet Delta Oxygen (Dioxygen (Delta Singlet))")
    40002 => NameKnown("Singlet Excited Oxygen Atom")
    40003 => NameKnown("Triplet Ground State Oxygen Atom")
    60000 => NameKnown("HOx Radical (OH+HO2)")
    60001 => NameKnown("Total Inorganic and Organic Peroxy Radicals (HO2+RO2)")
    60002 => NameKnown("Passive Ozone")
    60003 => NameKnown("NOx Expressed As Nitrogen")
    60004 => NameKnown("All Nitrogen Oxides (NOy) Expressed As Nitrogen")
    60005 => NameKnown("Total Inorganic Chlorine")
    60006 => NameKnown("Total Inorganic Bromine")
    60007 => NameKnown("Total Inorganic Chlorine Except HCl, ClONO2: ClOx")
    60008 => NameKnown("Total Inorganic Bromine Except HBr, BrONO2:BrOx")
    60009 => NameKnown("Lumped Alkanes")
    60010 => NameKnown("Lumped Alkenes")
    60011 => NameKnown("Lumped Aromatic Coumpounds")
    60012 => NameKnown("Lumped Terpenes")
    60013 =>
      NameKnown("Non-Methane Volatile Organic Compounds Expressed as Carbon")
    60014 =>
      NameKnown(
        "Anthropogenic Non-Methane Volatile Organic Compounds Expressed as Carbon",
      )
    60015 =>
      NameKnown(
        "Biogenic Non-Methane Volatile Organic Compounds Expressed as Carbon",
      )
    60016 => NameKnown("Lumped Oxygenated Hydrocarbons")
    60017 => NameKnown("NOx Expressed as Nirtogen Dioxide (NO2)")
    60018 => NameKnown("Organic Aldehydes")
    60019 => NameKnown("Organic Peroxides")
    60020 => NameKnown("Organic Nitrates")
    60021 => NameKnown("Ethers")
    60022 => NameKnown("Amines")
    60023 => NameKnown("Ketones")
    60024 => NameKnown("Dicarbonyls Unsaturated")
    60025 => NameKnown("Hydroxy Dicarbonyls Unsaturated")
    60026 => NameKnown("Hydroxy Ketones")
    60027 => NameKnown("Oxides")
    60028 => NameKnown("Peroxyacyl Nitrates")
    60029 => NameKnown("Aromatic Peroxide Radical (Aryl Dioxydanyl Radicals)")
    60030 => NameKnown("Biogenic Secondary Organic Compound")
    60031 => NameKnown("Anthropogenic Secondary Organic Compound")
    60032 =>
      NameKnown(
        "All Hydroxy-Peroxides Products of the Reaction of Hydroxy-Isoprene Adducts with O2",
      )
    60033 => NameKnown("Anthropogenic Volatile Organic Compounds")
    60034 => NameKnown("Biomass Burning Volatile Organic Compounds")
    62000 => NameKnown("Total Aerosol")
    62001 => NameKnown("Dust Dry")
    62002 => NameKnown("Water in Ambient")
    62003 => NameKnown("Ammonium Dry")
    62004 => NameKnown("Nitrate Dry")
    62005 => NameKnown("Nitric Acid Trihydrate")
    62006 => NameKnown("Sulfate Dry")
    62007 => NameKnown("Mercury Dry")
    62008 => NameKnown("Sea Salt Dry")
    62009 => NameKnown("Black Carbon Dry")
    62010 => NameKnown("Particulate Organic Matter Dry")
    62011 => NameKnown("Primary Particulate Organic Matter Dry")
    62012 => NameKnown("Secondary Particulate Organic Matter Dry")
    62013 => NameKnown("Black Carbon Hydrophilic Dry")
    62014 => NameKnown("Black Carbon Hydrophobic Dry")
    62015 => NameKnown("Particulate Organic Matter Hydrophilic Dry")
    62016 => NameKnown("Particulate Organic Matter Hydrophobic Dry")
    62017 => NameKnown("Nitrate Hydrophilic Dry")
    62018 => NameKnown("Nitrate Hydrophobic Dry")
    62020 => NameKnown("Smoke - High Absorption")
    62021 => NameKnown("Smoke - Low Absorption")
    62022 => NameKnown("Aerosol - High Absorption")
    62023 => NameKnown("Aerosol - High Absorption")
    62025 => NameKnown("Volcanic Ash")
    62026 => NameKnown("Particulate Matter (PM)")
    62028 => NameKnown("Total Aerosol Hydrophilic")
    62029 => NameKnown("Total Aerosol Hydrophobic")
    62030 => NameKnown("Primary Particulate Inorganic Matter Dry")
    62031 => NameKnown("Secondary Particulate Inorganic Matter Dry")
    62032 => NameKnown("Biogenic Secondary Organic Aerosol")
    62033 => NameKnown("Anthropogenic Secondary Organic Aerosol")
    62034 => NameKnown("Rain Water")
    62035 => NameKnown("Cloud Water")
    62036 => NameKnown("Brown Carbon Dry")
    62037 => NameKnown("Sea Salt Wet at 80% Relative Humidity")
    62100 => NameKnown("Alnus (Alder) Pollen")
    62101 => NameKnown("Betula (Birch) Pollen")
    62102 => NameKnown("Castanea (Chestnut) Pollen")
    62103 => NameKnown("Carpinus (Hornbeam) Pollen")
    62104 => NameKnown("Corylus (Hazel) Pollen")
    62105 => NameKnown("Fagus (Beech) Pollen")
    62106 => NameKnown("Fraxinus (Ash) Pollen")
    62107 => NameKnown("Pinus (Pine) Pollen")
    62108 => NameKnown("Platanus (Plane) Pollen")
    62109 => NameKnown("Populus (Cottonwood, Poplar) Pollen")
    62110 => NameKnown("Quercus (Oak) Pollen")
    62111 => NameKnown("Salix (Willow) Pollen")
    62112 => NameKnown("Taxus (Yew) Pollen")
    62113 => NameKnown("Tilia (Lime, Linden) Pollen")
    62114 => NameKnown("Ulmus (Elm) Pollen")
    62115 => NameKnown("Olea (Olive) Pollen")
    62200 => NameKnown("Ambrosia (Ragweed, Burr-Ragweed) Pollen")
    62201 => NameKnown("Artemisia (Sagebrush, Wormwood, Mugwort) Pollen")
    62202 =>
      NameKnown(
        "Brassica (Rape, Broccoli, Brussel Sprouts, Cabbage, Cauliflower, Collards, Kale, Kohlrabi, Mustard, Rutabaga) Pollen",
      )
    62203 => NameKnown("Plantago (Plantain) Pollen")
    62204 => NameKnown("Rumex (Dock, Sorrel) Pollen")
    62205 => NameKnown("Urtica (Nettle) Pollen")
    62300 => NameKnown("Poaceae (Grass Family) Pollen")
    65535 => NameKnown("Missing")
    _ =>
      if (value >= 47 && value <= 9999) ||
        value == 10003 ||
        (value >= 10069 && value <= 10499) ||
        (value >= 10502 && value <= 20000) ||
        (value >= 20023 && value <= 29999) ||
        (value >= 30001 && value <= 30009) ||
        (value >= 30371 && value <= 39999) ||
        (value >= 40004 && value <= 59999) ||
        (value >= 60035 && value <= 61999) ||
        value == 62019 ||
        value == 62024 ||
        value == 62027 ||
        (value >= 62038 && value <= 62099) ||
        (value >= 62116 && value <= 62199) ||
        (value >= 62206 && value <= 62299) ||
        (value >= 62301 && value <= 62999) {
        NameKnown("Reserved")
      } else if value >= 63000 && value <= 65534 {
        NameKnown("For Experimental Use at Local Level")
      } else {
        NameUnknown("constituent_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_canopy_cover_fraction_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Crops, mixed farming")
    2 => NameKnown("Short grass")
    3 => NameKnown("Evergreen needleleaf trees")
    4 => NameKnown("Deciduous needleleaf trees")
    5 => NameKnown("Deciduous broadleaf trees")
    6 => NameKnown("Evergreen broadleaf trees")
    7 => NameKnown("Tall grass")
    8 => NameKnown("Desert")
    9 => NameKnown("Tundra")
    10 => NameKnown("Irrigated corps")
    11 => NameKnown("Semidesert")
    12 => NameKnown("Ice caps and glaciers")
    13 => NameKnown("Bogs and marshes")
    14 => NameKnown("Inland water")
    15 => NameKnown("Ocean")
    16 => NameKnown("Evergreen shrubs")
    17 => NameKnown("Deciduous shrubs")
    18 => NameKnown("Mixed forest")
    19 => NameKnown("Interrupted forest")
    20 => NameKnown("Water and land mixtures")
    255 => NameKnown("Missing")
    _ =>
      if value >= 21 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("canopy_cover_fraction=" + value.to_string())
      }
  }
}

///|
pub fn decode_soil_texture_fraction_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Coarse")
    2 => NameKnown("Medium")
    3 => NameKnown("Medium-fine")
    4 => NameKnown("Fine")
    5 => NameKnown("Very-fine")
    6 => NameKnown("Organic")
    7 => NameKnown("Tropical-organic")
    255 => NameKnown("Missing")
    _ =>
      if value >= 8 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("soil_texture_fraction=" + value.to_string())
      }
  }
}

///|
pub fn decode_source_or_sink_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Aviation")
    2 => NameKnown("Lightning")
    3 => NameKnown("Biogenic Sources")
    4 => NameKnown("Anthropogenic sources")
    5 => NameKnown("Wild fires")
    6 => NameKnown("Natural sources")
    7 => NameKnown("Bio-fuel")
    8 => NameKnown("Volcanoes")
    9 => NameKnown("Fossil-fuel")
    10 => NameKnown("Wetlands")
    11 => NameKnown("Oceans")
    12 => NameKnown("Elevated anthropogenic sources")
    13 => NameKnown("Surface anthropogenic sources")
    14 => NameKnown("Agriculture livestock")
    15 => NameKnown("Agriculture soils")
    16 => NameKnown("Agriculture waste burning")
    17 => NameKnown("Agriculture (all)")
    18 => NameKnown("Residential, commercial and other combustion")
    19 => NameKnown("Power generation")
    20 => NameKnown("Super power stations")
    21 => NameKnown("Fugitives")
    22 => NameKnown("Industrial process")
    23 => NameKnown("Solvents")
    24 => NameKnown("Ships")
    25 => NameKnown("Wastes")
    26 => NameKnown("Road transportation")
    27 => NameKnown("Off-road transportation")
    28 => NameKnown("Nuclear power plant")
    29 => NameKnown("Nuclear weapon")
    30 => NameKnown("Commercial Building Heating")
    31 => NameKnown("Residential Heating")
    32 => NameKnown("Oil Refineries and Transformation Industry")
    33 => NameKnown("Gas Production")
    34 => NameKnown("Vegetation")
    35 => NameKnown("Biomass Burning")
    36 => NameKnown("Settlements")
    37 => NameKnown("Soil")
    38 => NameKnown("Wild Animals")
    39 => NameKnown("Savannah")
    40 => NameKnown("Tropical Forest")
    41 => NameKnown("Boreal Forest")
    42 => NameKnown("Peatland")
    43 => NameKnown("Deforestation")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 44 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("source_or_sink=" + value.to_string())
      }
  }
}

///|
pub fn decode_wetland_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Bog")
    2 => NameKnown("Drained")
    3 => NameKnown("Fen")
    4 => NameKnown("Floodplain")
    5 => NameKnown("Mangrove")
    6 => NameKnown("Marsh")
    7 => NameKnown("Rice")
    8 => NameKnown("Riverine")
    9 => NameKnown("Salt Marsh")
    10 => NameKnown("Swamp")
    11 => NameKnown("Upland")
    12 => NameKnown("Wet Tundra")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 13 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("wetland_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_distribution_function_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No specific distribution function given")
    1 =>
      NameKnown(
        "Delta functions with spatially variable concentration and fixed diameters",
      )
    2 =>
      NameKnown(
        "Delta functions with spatially variable concentration and fixed masses",
      )
    3 =>
      NameKnown(
        "Gaussian (Normal) distribution with spatially variable concentration and fixed mean diameter and variance",
      )
    4 =>
      NameKnown(
        "Gaussian (Normal) distribution with spatially variable concentration, mean diameter and variance",
      )
    5 =>
      NameKnown(
        "Log-normal distribution with spatially variable number density, mean diameter and variance",
      )
    6 =>
      NameKnown(
        "Log-normal distribution with spatially variable number density, mean diameter and fixed variance",
      )
    7 =>
      NameKnown(
        "Log-normal distribution with spatially variable number density and mass density and fixed variance and fixed particle density",
      )
    8 =>
      NameKnown(
        "No distribution function. The encoded variable is derived from variables characterized by type of distribution function No. 7",
      )
    65535 => NameKnown("Missing")
    _ =>
      if value >= 9 && value <= 49151 {
        NameKnown("Reserved")
      } else if value >= 49152 && value <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_distribution_function=" + value.to_string())
      }
  }
}

///|
pub fn decode_coverage_attributes_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Undefined")
    1 => NameKnown("Unmodified")
    2 => NameKnown("Snow Covered")
    3 => NameKnown("Flooded")
    4 => NameKnown("Ice Covered")
    5 => NameKnown("With Intercepted Water")
    6 => NameKnown("With Intercepted Snow")
    7 => NameKnown("Aggregated")
    255 => NameKnown("Missing")
    _ =>
      if value >= 8 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("coverage_attributes=" + value.to_string())
      }
  }
}

///|
pub fn decode_tile_classification_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Land use classes according to ESA-GLOBCOVER GCV2009")
    2 =>
      NameKnown(
        "Land use classes according to European Commission-Global Land Cover Project GLC2000",
      )
    3 => NameKnown("Land use classes according to ECOCLIMAP")
    4 => NameKnown("Land use classes according to ECOCLIMAP-SG")
    5 =>
      NameKnown(
        "Land use classes according to USGS EROS Global Land Cover Characterization (GLCC) v2.0 BATS Classification",
      )
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 6 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("tile_classification=" + value.to_string())
      }
  }
}

///|
pub fn decode_tile_class_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Evergreen broadleaved forest")
    2 => NameKnown("Deciduous broadleaved closed forest")
    3 => NameKnown("Deciduous broadleaved open forest")
    4 => NameKnown("Evergreen needle-leaf forest")
    5 => NameKnown("Deciduous needle-leaf forest")
    6 => NameKnown("Mixed leaf trees")
    7 => NameKnown("Fresh water flooded trees")
    8 => NameKnown("Saline water flooded trees")
    9 => NameKnown("Mosaic tree/natural vegetation")
    10 => NameKnown("Burnt tree cover")
    11 => NameKnown("Evergreen shrubs closed-open")
    12 => NameKnown("Deciduous shrubs closed-open")
    13 => NameKnown("Herbaceous vegetation closed-open")
    14 => NameKnown("Sparse herbaceous or grass")
    15 => NameKnown("Flooded shrubs or herbaceous")
    16 => NameKnown("Cultivated and managed areas")
    17 => NameKnown("Mosaic crop/tree/natural vegetation")
    18 => NameKnown("Mosaic crop/shrub/grass")
    19 => NameKnown("Bare areas")
    20 => NameKnown("Water")
    21 => NameKnown("Snow and ice")
    22 => NameKnown("Artificial surface")
    23 => NameKnown("Ocean")
    24 => NameKnown("Irrigated croplands")
    25 => NameKnown("Rainfed croplands")
    26 => NameKnown("Mosaic cropland (50-70%) - vegetation (20-50%)")
    27 => NameKnown("Mosaic vegetation (50-70%) - cropland (20-50%)")
    28 => NameKnown("Closed broadleaved evergreen forest")
    29 => NameKnown("Closed needle-leaved evergreen forest")
    30 => NameKnown("Open needle-leaved deciduous forest")
    31 => NameKnown("Mixed broadleaved and needle-leave forest")
    32 => NameKnown("Mosaic shrubland (50-70%) - grassland (20-50%)")
    33 => NameKnown("Mosaic grassland (50-70%) - shrubland (20-50%)")
    34 => NameKnown("Closed to open shrubland")
    35 => NameKnown("Sparse vegetation")
    36 => NameKnown("Closed to open forest regularly flooded")
    37 => NameKnown("Closed forest or shrubland permanently flooded")
    38 => NameKnown("Closed to open grassland regularly flooded")
    39 => NameKnown("Undefined")
    _ =>
      if value == 0 || (value >= 40 && value <= 32767) {
        NameKnown("Reserved")
      } else if value >= 32768 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("tile_class=" + value.to_string())
      }
  }
}

///|
pub fn decode_quality_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Quality Information Available")
    1 => NameKnown("Failed")
    2 => NameKnown("Passed")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("quality_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_thunderstorm_intensity_index_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No thunderstorm occurrence")
    1 => NameKnown("Weak thunderstorm")
    2 => NameKnown("Moderate thunderstorm")
    3 => NameKnown("Severe thunderstorm")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("thunderstorm_intensity_index=" + value.to_string())
      }
  }
}

///|
pub fn decode_precipitation_intensity_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No precipitation occurrence")
    1 => NameKnown("Light precipitation")
    2 => NameKnown("Moderate precipitation")
    3 => NameKnown("Heavy precipitation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("precipitation_intensity=" + value.to_string())
      }
  }
}

///|
pub fn decode_method_used_to_derive_data_value_for_local_time_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Nearest forecast or analysis time to specified local time")
    1 => NameKnown("Interpolated to be valid at the specified local time")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "method_used_to_derive_data_value_for_local_time=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_character_of_precipitation_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Showers")
    2 => NameKnown("Intermittent")
    3 => NameKnown("Continuous")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("character_of_precipitation=" + value.to_string())
      }
  }
}

///|
pub fn decode_drainage_direction_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Southwest")
    2 => NameKnown("South")
    3 => NameKnown("Southeast")
    4 => NameKnown("West")
    5 => NameKnown("No Direction")
    6 => NameKnown("East")
    7 => NameKnown("Northwest")
    8 => NameKnown("North")
    9 => NameKnown("Northeast")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 10 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("drainage_direction=" + value.to_string())
      }
  }
}

///|
pub fn decode_wave_direction_and_frequency_formulae_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Undefined Sequence")
    1 => NameKnown("Geometric Sequence")
    2 => NameKnown("Arithmetic Sequence")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "wave_direction_and_frequency_formulae=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_tile_classes_and_groupings_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Reserved")
    1 => NameKnown("Seas and Oceans")
    2 => NameKnown("Inland Water Bodies")
    3 => NameKnown("Bare Areas")
    4 => NameKnown("High Vegetation")
    5 => NameKnown("Low Vegetation")
    6 => NameKnown("Urban")
    1001 => NameKnown("Sea and Oceans")
    1002 => NameKnown("Lakes")
    1003 => NameKnown("Rivers")
    1004 => NameKnown("Bare Land")
    1005 => NameKnown("Bare Rock")
    1006 => NameKnown("Permanent Snow")
    1007 => NameKnown("Boreal Broadleaf Deciduous")
    1008 => NameKnown("Temperate Broadleaf Deciduous")
    1009 => NameKnown("Tropical Broadleaf Deciduous")
    1010 => NameKnown("Temperate Broadleaf Evergreen")
    1011 => NameKnown("Tropical Broadleaf Evergreen")
    1012 => NameKnown("Boreal Needleleaf Evergreen")
    1013 => NameKnown("Temperate Needleleaf Evergreen")
    1014 => NameKnown("Boreal Needleleaf Deciduous")
    1015 => NameKnown("Shrubs")
    1016 => NameKnown("Boreal Grassland")
    1017 => NameKnown("Temperate Grassland")
    1018 => NameKnown("Tropical Grassland")
    1019 => NameKnown("Winter C3 Crops")
    1020 => NameKnown("Summer C3 Crops")
    1021 => NameKnown("C4 Crops")
    1022 => NameKnown("Flooded Trees")
    1023 => NameKnown("Flooded Grassland")
    1024 => NameKnown("LCZ1")
    1025 => NameKnown("LCZ2")
    1026 => NameKnown("LCZ3")
    1027 => NameKnown("LCZ4")
    1028 => NameKnown("LCZ5")
    1029 => NameKnown("LCZ6")
    1030 => NameKnown("LCZ7")
    1031 => NameKnown("LCZ8")
    1032 => NameKnown("LCZ9")
    1033 => NameKnown("LCZ10")
    1034 => NameKnown("Urban Temperate Broadleaf Deciduous")
    1035 => NameKnown("Urban Tropical Broadleaf Deciduous")
    1036 => NameKnown("Urban Temperate Broadleaf Evergreen")
    1037 => NameKnown("Urban Tropical Broadleaf Evergreen")
    1038 => NameKnown("Urban Boreal Needleleaf Evergreen")
    1039 => NameKnown("Urban Temperate Needleleaf Evergreen")
    1040 => NameKnown("Urban Boreal Needleleaf Deciduous")
    1501 => NameKnown("Nature Grouping")
    1502 => NameKnown("Non-Forest Grouping")
    1503 => NameKnown("Forest Grouping")
    1504 => NameKnown("Non-Vegetated Grouping")
    1505 => NameKnown("Trees Grouping")
    1506 => NameKnown("Low Vegetation Grouping")
    1507 => NameKnown("Non-Flooded Low Vegetation Grouping")
    1508 => NameKnown("Crops Grouping")
    1509 => NameKnown("Grassland Grouping")
    1510 => NameKnown("Bare and Rock Grouping")
    1511 => NameKnown("C3 Crops Grouping")
    1512 => NameKnown("Broadleaf Forest Grouping")
    1513 => NameKnown("Needleleaf Forest Grouping")
    1514 => NameKnown("Deciduous Broadleaf Forest Grouping")
    1515 => NameKnown("Temperate Grassland Grouping")
    1516 => NameKnown("Non-Forest (no FLTR) Grouping")
    1517 => NameKnown("Broadleaf Forest (with FLTR) Grouping")
    1518 => NameKnown("Broadleaf Trees Grouping")
    1519 => NameKnown("C3/C4 Grasslands Grouping")
    1520 => NameKnown("Broadleaf Deciduous Trees Grouping")
    1521 => NameKnown("Broadleaf Evergreen Trees Grouping")
    1522 => NameKnown("Needleleaf Evergreen Trees Grouping")
    1523 => NameKnown("LCZ or urban grouping")
    1524 => NameKnown("Inland Water Grouping")
    1525 => NameKnown("Urban Parks and Gardens TEBD Grouping")
    1526 => NameKnown("Urban Parks and Gardens TRBD Grouping")
    1527 => NameKnown("Urban Parks and Gardens TEBE Grouping")
    1528 => NameKnown("Urban Parks and Gardens TRBE Grouping")
    1529 => NameKnown("Urban Parks and Gardens BONE Grouping")
    1530 => NameKnown("Urban Parks and Gardens TENE Grouping")
    1531 => NameKnown("Urban Parks and Gardens BOND Grouping")
    2001 => NameKnown("CRMF")
    2002 => NameKnown("SHGR")
    2003 => NameKnown("EVNE")
    2004 => NameKnown("DENE")
    2005 => NameKnown("DEBR")
    2006 => NameKnown("EVBR")
    2007 => NameKnown("TAGR")
    2008 => NameKnown("DESE")
    2009 => NameKnown("TUND")
    2010 => NameKnown("IRCR")
    2011 => NameKnown("SEDE")
    2012 => NameKnown("ICGL")
    2013 => NameKnown("BOMA")
    2014 => NameKnown("INWA")
    2015 => NameKnown("OCEA")
    2016 => NameKnown("EVSH")
    2017 => NameKnown("DESH")
    2018 => NameKnown("MFWO")
    2019 => NameKnown("INFO")
    2020 => NameKnown("WLMI")
    2021 => NameKnown("BASO")
    2022 => NameKnown("URBA")
    2023 => NameKnown("LORI")
    2024 => NameKnown("HIRI")
    3001 => NameKnown("PFIC")
    3002 => NameKnown("RACR")
    3003 => NameKnown("MCVE")
    3004 => NameKnown("MVCR")
    3005 => NameKnown("COBS")
    3006 => NameKnown("CLBD")
    3007 => NameKnown("OPBD")
    3008 => NameKnown("CLNE")
    3009 => NameKnown("ONDE")
    3010 => NameKnown("COBN")
    3011 => NameKnown("MFSG")
    3012 => NameKnown("MGFS")
    3013 => NameKnown("COSH")
    3014 => NameKnown("COHV")
    3015 => NameKnown("SPVE")
    3016 => NameKnown("COBFF")
    3017 => NameKnown("CLBFF")
    3018 => NameKnown("COVEF")
    3019 => NameKnown("ASAA")
    3020 => NameKnown("BAAR")
    3021 => NameKnown("WABO")
    3022 => NameKnown("PESI")
    3501 =>
      NameKnown(
        "Grouping Using the Dominant Tiles Approach (Dominant Tile Varies per Gridbox)",
      )
    4001 => NameKnown("TBECO")
    4002 => NameKnown("TBDC")
    4003 => NameKnown("TBDO")
    4004 => NameKnown("TNECO")
    4005 => NameKnown("TNDCO")
    4006 => NameKnown("TMLCO")
    4007 => NameKnown("TCOFF")
    4008 => NameKnown("TCOFS")
    4009 => NameKnown("MTVG")
    4010 => NameKnown("TBURN")
    4011 => NameKnown("SCOE")
    4012 => NameKnown("SCOD")
    4013 => NameKnown("HCCO")
    4014 => NameKnown("SHSC")
    4015 => NameKnown("FSHCO")
    4016 => NameKnown("CROP")
    4017 => NameKnown("MCTNV")
    4018 => NameKnown("MCSH")
    4019 => NameKnown("BAARE")
    4020 => NameKnown("WBNA")
    4021 => NameKnown("SINA")
    4022 => NameKnown("URAR")
    65535 => NameKnown("Missing")
    _ =>
      if (value >= 7 && value <= 1000) ||
        (value >= 1041 && value <= 1500) ||
        (value >= 1532 && value <= 2000) ||
        (value >= 2025 && value <= 2500) ||
        (value >= 2503 && value <= 3000) ||
        (value >= 3023 && value <= 3500) ||
        (value >= 3502 && value <= 4000) ||
        (value >= 4023 && value <= 4500) ||
        (value >= 4501 && value <= 5000) ||
        (value >= 5001 && value <= 32767) {
        NameKnown("Reserved")
      } else if value >= 32768 && value <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("tile_classes_and_groupings=" + value.to_string())
      }
  }
}

///|
pub fn decode_hazard_index_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Undefined")
    65535 => NameKnown("Missing")
    _ =>
      if value >= 1 && value <= 65534 {
        NameKnown("Reserved")
      } else {
        NameUnknown("hazard_index=" + value.to_string())
      }
  }
}

///|
pub fn decode_transport_dispersion_model_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("DERMA (Danish Emergency Response Model of the Atmosphere)")
    2 => NameKnown("E-EMEP (Emergency EMEP model)")
    3 => NameKnown("FLEXPART (Particle dispersion model)")
    4 => NameKnown("MLDP (Modele lagrangien de dispersion de particules)")
    5 => NameKnown("MATCH (Multi-scale Atmospheric Transport Model")
    6 =>
      NameKnown(
        "SILAM (System for Integrated modeLling of Atmospheric composition)",
      )
    7 => NameKnown("SNAP (Severe Nuclear Accident Program)")
    8 => NameKnown("WRF-Chem (Weather Research and Forecasting Chemical model)")
    9 => NameKnown("Trajectoire (Trajectory model)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 10 && value <= 254) {
        NameKnown("Reserved")
      } else {
        NameUnknown("transport_dispersion_model=" + value.to_string())
      }
  }
}

///|
pub fn decode_emission_scenario_origin_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("ARGOS (Accident Reporting and Guiding Operational System)")
    2 =>
      NameKnown(
        "JRODOS (Java version of Real time Online Decision SuppOrt System)",
      )
    3 => NameKnown("Assimilated (scenario retrieved from measurements)")
    4 => NameKnown("Center (scenario by originating center)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 5 && value <= 254) {
        NameKnown("Reserved")
      } else {
        NameUnknown("emission_scenario_origin=" + value.to_string())
      }
  }
}

///|
pub fn decode_nwp_model_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("AROME (Meso scale NWP, Meteo-France)")
    2 => NameKnown("ARPEGE (Global scale NWP, Meteo-France)")
    3 => NameKnown("GFS (Global forecast system, NCEP)")
    4 =>
      NameKnown(
        "HARMONIE (HIRLAM-ALADIN Research on Mesoscale Operational NWP)",
      )
    5 => NameKnown("HIRLAM (HIgh resolution Limited Area Model)")
    6 => NameKnown("IFS (Integrated Forecast System)")
    7 => NameKnown("GEM GDPS (Canadian Global Deterministic Prediction System)")
    8 =>
      NameKnown("GEM RDPS (Canadian Regional Deterministic Prediction System)")
    9 =>
      NameKnown(
        "GEM HRDPS (Canadian High Resolution Deterministic Prediction System)",
      )
    10 => NameKnown("WRF (Weather Research and Forecasting)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 11 && value <= 254) {
        NameKnown("Reserved")
      } else {
        NameUnknown("nwp_model=" + value.to_string())
      }
  }
}

///|
pub fn decode_parameter_category_name(
  discipline : Int,
  category : Int,
) -> Grib2NameLookup {
  if category < 0 || category > 255 {
    return NameUnknown(
      "parameter_category=disc=" +
      discipline.to_string() +
      ",cat=" +
      category.to_string(),
    )
  }
  match discipline {
    0 =>
      match category {
        0 => NameKnown("Temperature")
        1 => NameKnown("Moisture")
        2 => NameKnown("Momentum")
        3 => NameKnown("Mass")
        4 => NameKnown("Shortwave Radiation")
        5 => NameKnown("Longwave Radiation")
        6 => NameKnown("Cloud")
        7 => NameKnown("Thermodynamic Stability Indices")
        8 => NameKnown("Kinematic Stability Indices")
        9 => NameKnown("Temperature Probabilities")
        10 => NameKnown("Moisture Probabilities")
        11 => NameKnown("Momentum Probabilities")
        12 => NameKnown("Mass Probabilities")
        13 => NameKnown("Aerosols")
        14 => NameKnown("Trace Gases")
        15 => NameKnown("Radar")
        16 => NameKnown("Forecast Radar Imagery")
        17 => NameKnown("Electrodynamics")
        18 => NameKnown("Nuclear/Radiology")
        19 => NameKnown("Physical Atmospheric Properties")
        20 => NameKnown("Atmospheric Chemical Constituents")
        21 => NameKnown("Thermodynamic Properties")
        22 => NameKnown("Drought Indices")
        190 => NameKnown("CCITT IA5 String")
        191 => NameKnown("Miscellaneous")
        192 => NameKnown("Covariance")
        255 => NameKnown("Missing")
        _ =>
          if category >= 23 && category <= 189 {
            NameKnown("Reserved")
          } else if category >= 193 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    1 =>
      match category {
        0 => NameKnown("Hydrology Basic Products")
        1 => NameKnown("Hydrology Probabilities")
        2 => NameKnown("Inland Water and Sediment Properties")
        255 => NameKnown("Missing")
        _ =>
          if category >= 3 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    2 =>
      match category {
        0 => NameKnown("Vegetation/Biomass")
        1 => NameKnown("Agricultural/Aquacultural Special Products")
        3 => NameKnown("Soil Products")
        4 => NameKnown("Fire Weather Products")
        5 => NameKnown("Land Surface Products")
        6 => NameKnown("Urban Areas")
        7 => NameKnown("Thermodynamic Properties")
        255 => NameKnown("Missing")
        _ =>
          if category >= 8 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    3 =>
      match category {
        0 => NameKnown("Image Format Products")
        1 => NameKnown("Quantitative Products")
        2 => NameKnown("Cloud Properties")
        3 => NameKnown("Flight Rules Conditions")
        4 => NameKnown("Volcanic Ash")
        5 => NameKnown("Sea Surface Temperature")
        6 => NameKnown("Solar Radiation")
        192 => NameKnown("Forecast Satellite Imagery")
        255 => NameKnown("Missing")
        _ =>
          if category >= 7 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 193 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    4 =>
      match category {
        0 => NameKnown("Temperature")
        1 => NameKnown("Momentum")
        2 => NameKnown("Charged Particle Mass and Number")
        3 => NameKnown("Electric and Magnetic Fields")
        4 => NameKnown("Energetic Particles")
        5 => NameKnown("Waves")
        6 => NameKnown("Solar Electromagnetic Emissions")
        7 => NameKnown("Terrestrial Electromagnetic Emissions")
        8 => NameKnown("Imagery")
        9 => NameKnown("Ion-Neutral Coupling")
        10 => NameKnown("Space Weather Indices")
        255 => NameKnown("Missing")
        _ =>
          if category >= 11 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    10 =>
      match category {
        0 => NameKnown("Waves")
        1 => NameKnown("Currents")
        2 => NameKnown("Ice")
        3 => NameKnown("Surface Properties")
        4 => NameKnown("Subsurface Properties")
        191 => NameKnown("Miscellaneous")
        255 => NameKnown("Missing")
        _ =>
          if category >= 5 && category <= 190 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    20 =>
      match category {
        0 => NameKnown("Health Indicators")
        1 => NameKnown("Epidemiology")
        2 => NameKnown("Socioeconomic Indicators")
        3 => NameKnown("Renewable Energy Sector")
        4 => NameKnown("Meteorological and Hydrological Hazard Indices")
        5 => NameKnown("Environmental Hazard Indices")
        255 => NameKnown("Missing")
        _ =>
          if category >= 6 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    191 =>
      match category {
        0 => NameKnown("Stochastic Parameterizations")
        255 => NameKnown("Missing")
        _ =>
          if category >= 1 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    _ =>
      NameUnknown(
        "parameter_category=disc=" +
        discipline.to_string() +
        ",cat=" +
        category.to_string(),
      )
  }
}

///|
pub fn decode_parameter_number_name(
  discipline : Int,
  category : Int,
  parameter : Int,
) -> Grib2NameLookup {
  let mapped = decode_parameter_name(discipline, category, parameter)
  match mapped {
    NameKnown(_) => mapped
    NameUnknown(_) =>
      if parameter < 0 || parameter > 255 {
        NameUnknown(
          "parameter_number=disc=" +
          discipline.to_string() +
          ",cat=" +
          category.to_string() +
          ",param=" +
          parameter.to_string(),
        )
      } else if parameter == 255 {
        NameKnown("Missing")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameKnown("Reserved")
      }
  }
}

///|
fn decode_parameter_number_4_2_0_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TMP")
    1 => NameKnown("VTMP")
    2 => NameKnown("POT")
    3 => NameKnown("EPOT")
    4 => NameKnown("TMAX")
    5 => NameKnown("TMIN")
    6 => NameKnown("DPT")
    7 => NameKnown("DEPR")
    8 => NameKnown("LAPR")
    9 => NameKnown("TMPA")
    10 => NameKnown("LHTFL")
    11 => NameKnown("SHTFL")
    12 => NameKnown("HEATX")
    13 => NameKnown("WCF")
    14 => NameKnown("MINDPD")
    15 => NameKnown("VPTMP")
    16 => NameKnown("SNOHF")
    17 => NameKnown("SKINT")
    18 => NameKnown("SNOT")
    19 => NameKnown("TTCHT")
    20 => NameKnown("TDCHT")
    21 => NameKnown("APTMP")
    22 => NameKnown("TTSWR")
    23 => NameKnown("TTLWR")
    24 => NameKnown("TTSWRCS")
    25 => NameKnown("TTLWRCS")
    26 => NameKnown("TTPARM")
    27 => NameKnown("WETBT")
    28 => NameKnown("UCTMP")
    29 => NameKnown("TMPADV")
    30 => NameKnown("LHFLXE")
    31 => NameKnown("LHFLXS")
    32 => NameKnown("WETBPT")
    192 => NameKnown("SNOHF")
    193 => NameKnown("TTRAD")
    194 => NameKnown("REV")
    195 => NameKnown("LRGHR")
    196 => NameKnown("CNVHR")
    197 => NameKnown("THFLX")
    198 => NameKnown("TTDIA")
    199 => NameKnown("TTPHY")
    200 => NameKnown("TSD1D")
    201 => NameKnown("SHAHR")
    202 => NameKnown("VDFHR")
    203 => NameKnown("THZ0")
    204 => NameKnown("TCHP")
    205 => NameKnown("ELMELT")
    206 => NameKnown("WETGLBT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 33 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 207 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SPFH")
    1 => NameKnown("RH")
    2 => NameKnown("MIXR")
    3 => NameKnown("PWAT")
    4 => NameKnown("VAPP")
    5 => NameKnown("SATD")
    6 => NameKnown("EVP")
    7 => NameKnown("PRATE")
    8 => NameKnown("APCP")
    9 => NameKnown("NCPCP")
    10 => NameKnown("ACPCP")
    11 => NameKnown("SNOD")
    12 => NameKnown("SRWEQ")
    13 => NameKnown("WEASD")
    14 => NameKnown("SNOC")
    15 => NameKnown("SNOL")
    16 => NameKnown("SNOM")
    17 => NameKnown("SNOAG")
    18 => NameKnown("ABSH")
    19 => NameKnown("PTYPE")
    20 => NameKnown("ILIQW")
    21 => NameKnown("TCOND")
    22 => NameKnown("CLMR")
    23 => NameKnown("ICMR")
    24 => NameKnown("RWMR")
    25 => NameKnown("SNMR")
    26 => NameKnown("MCONV")
    27 => NameKnown("MAXRH")
    28 => NameKnown("MAXAH")
    29 => NameKnown("ASNOW")
    30 => NameKnown("PWCAT")
    31 => NameKnown("HAIL")
    32 => NameKnown("GRLE")
    33 => NameKnown("CRAIN")
    34 => NameKnown("CFRZR")
    35 => NameKnown("CICEP")
    36 => NameKnown("CSNOW")
    37 => NameKnown("CPRAT")
    38 => NameKnown("MDIVER")
    39 => NameKnown("CPOFP")
    40 => NameKnown("PEVAP")
    41 => NameKnown("PEVPR")
    42 => NameKnown("SNOWC")
    43 => NameKnown("FRAIN")
    44 => NameKnown("RIME")
    45 => NameKnown("TCOLR")
    46 => NameKnown("TCOLS")
    47 => NameKnown("LSWP")
    48 => NameKnown("CWP")
    49 => NameKnown("TWATP")
    50 => NameKnown("TSNOWP")
    51 => NameKnown("TCWAT")
    52 => NameKnown("TPRATE")
    53 => NameKnown("TSRWE")
    54 => NameKnown("LSPRATE")
    55 => NameKnown("CSRWE")
    56 => NameKnown("LSSRWE")
    57 => NameKnown("TSRATE")
    58 => NameKnown("CSRATE")
    59 => NameKnown("LSSRATE")
    60 => NameKnown("SDWE")
    61 => NameKnown("SDEN")
    62 => NameKnown("SEVAP")
    64 => NameKnown("TCIWV")
    65 => NameKnown("RPRATE")
    66 => NameKnown("SPRATE")
    67 => NameKnown("FPRATE")
    68 => NameKnown("IPRATE")
    69 => NameKnown("TCOLW")
    70 => NameKnown("TCOLI")
    71 => NameKnown("HAILMXR")
    72 => NameKnown("TCOLH")
    73 => NameKnown("HAILPR")
    74 => NameKnown("TCOLG")
    75 => NameKnown("GPRATE")
    76 => NameKnown("CRRATE")
    77 => NameKnown("LSRRATE")
    78 => NameKnown("TCOLWA")
    79 => NameKnown("EVARATE")
    80 => NameKnown("TOTCON")
    81 => NameKnown("TCICON")
    82 => NameKnown("CIMIXR")
    83 => NameKnown("SCLLWC")
    84 => NameKnown("SCLIWC")
    85 => NameKnown("SRAINW")
    86 => NameKnown("SSNOWW")
    87 => NameKnown("STRPRATE")
    88 => NameKnown("CATCP")
    90 => NameKnown("TKMFLX")
    91 => NameKnown("UKMFLX")
    92 => NameKnown("VKMFLX")
    93 => NameKnown("RHWATER")
    94 => NameKnown("RHICE")
    95 => NameKnown("FZPRATE")
    96 => NameKnown("MASSDR")
    97 => NameKnown("MASSDS")
    98 => NameKnown("MASSDG")
    99 => NameKnown("MASSDH")
    100 => NameKnown("SPNCR")
    101 => NameKnown("SPNCS")
    102 => NameKnown("SPNCG")
    103 => NameKnown("SPNCH")
    104 => NameKnown("NUMDR")
    105 => NameKnown("NUMDS")
    106 => NameKnown("NUMDG")
    107 => NameKnown("NUMDH")
    108 => NameKnown("SHTPRM")
    109 => NameKnown("MDLWHVA")
    110 => NameKnown("SMLWHMA")
    111 => NameKnown("MMLWHDA")
    112 => NameKnown("MDLWGVA")
    113 => NameKnown("SMLWGMA")
    114 => NameKnown("MMLWGDA")
    115 => NameKnown("MDLWSVA")
    116 => NameKnown("SMLWSMA")
    117 => NameKnown("MMLWSDA")
    118 => NameKnown("UNCSH")
    119 => NameKnown("UCSCLW")
    120 => NameKnown("UCSCIW")
    121 => NameKnown("FSNOWC")
    122 => NameKnown("PIIDX")
    123 => NameKnown("DPTYPE")
    124 => NameKnown("PSHOW")
    125 => NameKnown("PBSNOW")
    126 => NameKnown("PBLIZZ")
    127 => NameKnown("ICEP")
    128 => NameKnown("TSPRATE")
    129 => NameKnown("EFRCWAT")
    130 => NameKnown("EFRRAIN")
    131 => NameKnown("EFRCICE")
    132 => NameKnown("EFRSNOW")
    133 => NameKnown("EFRGRL")
    134 => NameKnown("EFRHAIL")
    135 => NameKnown("EFRSLC")
    136 => NameKnown("EFRSICEC")
    137 => NameKnown("EFARRAIN")
    138 => NameKnown("EFARCICE")
    139 => NameKnown("EFARSNOW")
    140 => NameKnown("EFARGRL")
    141 => NameKnown("EFARHAIL")
    142 => NameKnown("EFARSIC")
    143 => NameKnown("PERATE")
    144 => NameKnown("SRWATERC")
    145 => NameKnown("SSNOWWC")
    146 => NameKnown("CICEPR")
    147 => NameKnown("CHPRECIP")
    148 => NameKnown("SNOWERAT")
    149 => NameKnown("CWATERMR")
    150 => NameKnown("CEWVMF")
    151 => NameKnown("CNWVMF")
    152 => NameKnown("CECLWMF")
    153 => NameKnown("CNCLWMF")
    154 => NameKnown("CECIMF")
    155 => NameKnown("CNCIMF")
    156 => NameKnown("CERMF")
    157 => NameKnown("CNRMF")
    158 => NameKnown("CEFMF")
    159 => NameKnown("CNSMF")
    160 => NameKnown("CDWFMF")
    161 => NameKnown("CDCLWMF")
    162 => NameKnown("CDCIMF")
    163 => NameKnown("CDRMF")
    164 => NameKnown("CDSMF")
    165 => NameKnown("CDTWMF")
    166 => NameKnown("CWVF")
    167 => NameKnown("TCSLW")
    168 => NameKnown("SSPFHW")
    169 => NameKnown("TCISSPFHW")
    170 => NameKnown("MEANHAIL")
    171 => NameKnown("MAXHAIL")
    192 => NameKnown("CRAIN")
    193 => NameKnown("CFRZR")
    194 => NameKnown("CICEP")
    195 => NameKnown("CSNOW")
    196 => NameKnown("CPRAT")
    197 => NameKnown("MDIV")
    198 => NameKnown("MINRH")
    199 => NameKnown("PEVAP")
    200 => NameKnown("PEVPR")
    201 => NameKnown("SNOWC")
    202 => NameKnown("FRAIN")
    203 => NameKnown("RIME")
    204 => NameKnown("TCOLR")
    205 => NameKnown("TCOLS")
    206 => NameKnown("TIPD")
    207 => NameKnown("NCIP")
    208 => NameKnown("SNOT")
    209 => NameKnown("TCLSW")
    210 => NameKnown("TCOLM")
    211 => NameKnown("EMNP")
    212 => NameKnown("SBSNO")
    213 => NameKnown("CNVMR")
    214 => NameKnown("SHAMR")
    215 => NameKnown("VDFMR")
    216 => NameKnown("CONDP")
    217 => NameKnown("LRGMR")
    218 => NameKnown("QZ0")
    219 => NameKnown("QMAX")
    220 => NameKnown("QMIN")
    221 => NameKnown("ARAIN")
    222 => NameKnown("SNOWT")
    223 => NameKnown("APCPN")
    224 => NameKnown("ACPCPN")
    225 => NameKnown("FRZR")
    226 => NameKnown("PWTHER")
    227 => NameKnown("FROZR")
    228 => NameKnown("FICEAC")
    229 => NameKnown("LICEAC")
    230 => NameKnown("SLACC")
    231 => NameKnown("PPINDX")
    232 => NameKnown("PROBCIP")
    233 => NameKnown("SNOWLR")
    234 => NameKnown("PCPDUR")
    235 => NameKnown("CLLMR")
    236 => NameKnown("HAILAC")
    237 => NameKnown("TCOLP")
    238 => NameKnown("PRATE1MIN")
    239 => NameKnown("PRATE5MIN")
    240 => NameKnown("PRATE10MIN")
    241 => NameKnown("TSNOW")
    242 => NameKnown("RHPW")
    245 => NameKnown("MAXVIG")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 63 ||
        parameter == 89 ||
        (parameter >= 172 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WDIR")
    1 => NameKnown("WIND")
    2 => NameKnown("UGRD")
    3 => NameKnown("VGRD")
    4 => NameKnown("STRM")
    5 => NameKnown("VPOT")
    6 => NameKnown("MNTSF")
    7 => NameKnown("SGCVV")
    8 => NameKnown("VVEL")
    9 => NameKnown("DZDT")
    10 => NameKnown("ABSV")
    11 => NameKnown("ABSD")
    12 => NameKnown("RELV")
    13 => NameKnown("RELD")
    14 => NameKnown("PVORT")
    15 => NameKnown("VUCSH")
    16 => NameKnown("VVCSH")
    17 => NameKnown("UFLX")
    18 => NameKnown("VFLX")
    19 => NameKnown("WMIXE")
    20 => NameKnown("BLYDP")
    21 => NameKnown("MAXGUST")
    22 => NameKnown("GUST")
    23 => NameKnown("UGUST")
    24 => NameKnown("VGUST")
    25 => NameKnown("VWSH")
    26 => NameKnown("MFLX")
    27 => NameKnown("USTM")
    28 => NameKnown("VSTM")
    29 => NameKnown("CD")
    30 => NameKnown("FRICV")
    31 => NameKnown("TDCMOM")
    32 => NameKnown("ETACVV")
    33 => NameKnown("WINDF")
    34 => NameKnown("NWIND")
    35 => NameKnown("TWIND")
    36 => NameKnown("AFRWE")
    37 => NameKnown("NTSS")
    38 => NameKnown("ETSS")
    39 => NameKnown("EWTPARM")
    40 => NameKnown("NWTPARM")
    41 => NameKnown("UGWIND")
    42 => NameKnown("VGWIND")
    43 => NameKnown("GEOWD")
    44 => NameKnown("GEOWS")
    45 => NameKnown("UNDIV")
    46 => NameKnown("VORTADV")
    47 => NameKnown("SFRHEAT")
    48 => NameKnown("SFRMOIST")
    49 => NameKnown("WINDSTR")
    50 => NameKnown("EWINDSTR")
    51 => NameKnown("NWINDSTR")
    52 => NameKnown("UWINDSTR")
    53 => NameKnown("VWINDSTR")
    54 => NameKnown("NLSRLH")
    55 => NameKnown("NLSRLM")
    56 => NameKnown("UNWIND")
    57 => NameKnown("VNWIND")
    58 => NameKnown("TSFCSTR")
    59 => NameKnown("VDIV")
    60 => NameKnown("DTC")
    61 => NameKnown("DEC")
    62 => NameKnown("EASTTSS")
    63 => NameKnown("NRTHTSS")
    64 => NameKnown("EASTTSSOD")
    65 => NameKnown("NRTHTSSOD")
    66 => NameKnown("EASTTSSSR")
    67 => NameKnown("NRTHTSSSR")
    68 => NameKnown("CNVGUST")
    69 => NameKnown("TURBGUST")
    192 => NameKnown("VWSH")
    193 => NameKnown("MFLX")
    194 => NameKnown("USTM")
    195 => NameKnown("VSTM")
    196 => NameKnown("CD")
    197 => NameKnown("FRICV")
    198 => NameKnown("LAUV")
    199 => NameKnown("LOUV")
    200 => NameKnown("LAVV")
    201 => NameKnown("LOVV")
    202 => NameKnown("LAPP")
    203 => NameKnown("LOPP")
    204 => NameKnown("VEDH")
    205 => NameKnown("COVMZ")
    206 => NameKnown("COVTZ")
    207 => NameKnown("COVTM")
    208 => NameKnown("VDFUA")
    209 => NameKnown("VDFVA")
    210 => NameKnown("GWDU")
    211 => NameKnown("GWDV")
    212 => NameKnown("CNVU")
    213 => NameKnown("CNVV")
    214 => NameKnown("WTEND")
    215 => NameKnown("OMGALF")
    216 => NameKnown("CNGWDU")
    217 => NameKnown("CNGWDV")
    218 => NameKnown("LMV")
    219 => NameKnown("PVMWW")
    220 => NameKnown("MAXUVV")
    221 => NameKnown("MAXDVV")
    222 => NameKnown("MAXUW")
    223 => NameKnown("MAXVW")
    224 => NameKnown("VRATE")
    225 => NameKnown("TRWSPD")
    226 => NameKnown("TRWDIR")
    227 => NameKnown("TOA10")
    228 => NameKnown("TOA50")
    229 => NameKnown("TOD50")
    230 => NameKnown("TOD90")
    231 => NameKnown("TPWDIR")
    232 => NameKnown("TPWSPD")
    233 => NameKnown("ESHR")
    234 => NameKnown("UESH")
    235 => NameKnown("VESH")
    236 => NameKnown("UEID")
    237 => NameKnown("VEID")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 70 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PRES")
    1 => NameKnown("PRMSL")
    2 => NameKnown("PTEND")
    3 => NameKnown("ICAHT")
    4 => NameKnown("GP")
    5 => NameKnown("HGT")
    6 => NameKnown("DIST")
    7 => NameKnown("HSTDV")
    8 => NameKnown("PRESA")
    9 => NameKnown("GPA")
    10 => NameKnown("DEN")
    11 => NameKnown("ALTS")
    12 => NameKnown("THICK")
    13 => NameKnown("PRESALT")
    14 => NameKnown("DENALT")
    15 => NameKnown("5WAVH")
    16 => NameKnown("U-GWD")
    17 => NameKnown("V-GWD")
    18 => NameKnown("HPBL")
    19 => NameKnown("5WAVA")
    20 => NameKnown("SDSGSO")
    21 => NameKnown("AOSGSO")
    22 => NameKnown("SSGSO")
    23 => NameKnown("GWD")
    24 => NameKnown("ASGSO")
    25 => NameKnown("NLPRES")
    26 => NameKnown("EXPRES")
    27 => NameKnown("UMFLX")
    28 => NameKnown("DMFLX")
    29 => NameKnown("UDRATE")
    30 => NameKnown("DDRATE")
    31 => NameKnown("UCLSPRS")
    32 => NameKnown("SWATERVP")
    33 => NameKnown("GAMSL")
    34 => NameKnown("GHAGRD")
    35 => NameKnown("CDTMF")
    36 => NameKnown("CETMF")
    37 => NameKnown("CNTMF")
    38 => NameKnown("SDFSO")
    39 => NameKnown("CMATMOS")
    40 => NameKnown("CEGFLUX")
    41 => NameKnown("CNGFLUX")
    42 => NameKnown("CDWGFLUX")
    43 => NameKnown("CDGFLUX")
    44 => NameKnown("HWBT")
    45 => NameKnown("WOBT")
    46 => NameKnown("PRESDHS")
    192 => NameKnown("MSLET")
    193 => NameKnown("5WAVH")
    194 => NameKnown("U-GWD")
    195 => NameKnown("V-GWD")
    196 => NameKnown("HPBL")
    197 => NameKnown("5WAVA")
    198 => NameKnown("MSLMA")
    199 => NameKnown("TSLSA")
    200 => NameKnown("PLPL")
    201 => NameKnown("LPSX")
    202 => NameKnown("LPSY")
    203 => NameKnown("HGTX")
    204 => NameKnown("HGTY")
    205 => NameKnown("LAYTH")
    206 => NameKnown("NLGSP")
    207 => NameKnown("CNVUMF")
    208 => NameKnown("CNVDMF")
    209 => NameKnown("CNVDEMF")
    210 => NameKnown("LMH")
    211 => NameKnown("HGTN")
    212 => NameKnown("PRESN")
    213 => NameKnown("ORCONV")
    214 => NameKnown("ORASW")
    215 => NameKnown("ORASS")
    216 => NameKnown("ORASSW")
    217 => NameKnown("ORASNW")
    218 => NameKnown("ORLSW")
    219 => NameKnown("ORLSS")
    220 => NameKnown("ORLSSW")
    221 => NameKnown("ORLSNW")
    222 => NameKnown("EFSH")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 47 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("NSWRS")
    1 => NameKnown("NSWRT")
    2 => NameKnown("SWAVR")
    3 => NameKnown("GRAD")
    4 => NameKnown("BRTMP")
    5 => NameKnown("LWRAD")
    6 => NameKnown("SWRAD")
    7 => NameKnown("DSWRF")
    8 => NameKnown("USWRF")
    9 => NameKnown("NSWRF")
    10 => NameKnown("PHOTAR")
    11 => NameKnown("NSWRFCS")
    12 => NameKnown("DWUVR")
    13 => NameKnown("DSWRFLX")
    14 => NameKnown("DIFSWRF")
    15 => NameKnown("UVVEARTH")
    50 => NameKnown("UVIUCS")
    51 => NameKnown("UVI")
    52 => NameKnown("DSWRFCS")
    53 => NameKnown("USWRFCS")
    54 => NameKnown("DNSWRFLX")
    55 => NameKnown("UVALBDIF")
    56 => NameKnown("UVALBDIR")
    57 => NameKnown("UBALBDIRG")
    58 => NameKnown("UVALBDIRI")
    59 => NameKnown("UVBDIRV")
    60 => NameKnown("PHOARFCS")
    61 => NameKnown("DSWRFLXCS")
    62 => NameKnown("DNSWRFLXCS")
    63 => NameKnown("DFSWRFLXCS")
    192 => NameKnown("DSWRF")
    193 => NameKnown("USWRF")
    194 => NameKnown("DUVB")
    195 => NameKnown("CDUVB")
    196 => NameKnown("CSDSF")
    197 => NameKnown("SWHR")
    198 => NameKnown("CSUSF")
    199 => NameKnown("CFNSF")
    200 => NameKnown("VBDSF")
    201 => NameKnown("VDDSF")
    202 => NameKnown("NBDSF")
    203 => NameKnown("NDDSF")
    204 => NameKnown("DTRF")
    205 => NameKnown("UTRF")
    206 => NameKnown("DFSWRFLXCS")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 16 && parameter <= 49) ||
        (parameter >= 64 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("NLWRS")
    1 => NameKnown("NLWRT")
    2 => NameKnown("LWAVR")
    3 => NameKnown("DLWRF")
    4 => NameKnown("ULWRF")
    5 => NameKnown("NLWRF")
    6 => NameKnown("NLWRCS")
    7 => NameKnown("BRTEMP")
    8 => NameKnown("DLWRFCS")
    9 => NameKnown("NIRALBDIF")
    10 => NameKnown("NIRALBDIR")
    11 => NameKnown("NIRALBDIRG")
    12 => NameKnown("NIRALBDIRI")
    13 => NameKnown("NIRALBDIRV")
    192 => NameKnown("DLWRF")
    193 => NameKnown("ULWRF")
    194 => NameKnown("LWHR")
    195 => NameKnown("CSULF")
    196 => NameKnown("CSDLF")
    197 => NameKnown("CFNLF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 14 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("CICE")
    1 => NameKnown("TCDC")
    2 => NameKnown("CDCON")
    3 => NameKnown("LCDC")
    4 => NameKnown("MCDC")
    5 => NameKnown("HCDC")
    6 => NameKnown("CWAT")
    7 => NameKnown("CDCA")
    8 => NameKnown("CDCT")
    9 => NameKnown("TMAXT")
    10 => NameKnown("THUNC")
    11 => NameKnown("CDCB")
    12 => NameKnown("CDCTOP")
    13 => NameKnown("CEIL")
    14 => NameKnown("CDLYR")
    15 => NameKnown("CWORK")
    16 => NameKnown("CUEFI")
    17 => NameKnown("TCONDO")
    18 => NameKnown("TCOLWO")
    19 => NameKnown("TCOLIO")
    20 => NameKnown("TCOLC")
    21 => NameKnown("FICE")
    22 => NameKnown("CDCC")
    23 => NameKnown("CDCIMR")
    24 => NameKnown("SUNS")
    25 => NameKnown("CBHE")
    26 => NameKnown("HCONCB")
    27 => NameKnown("HCONCT")
    28 => NameKnown("NCONCD")
    29 => NameKnown("NCCICE")
    30 => NameKnown("NDENCD")
    31 => NameKnown("NDCICE")
    32 => NameKnown("FRACCC")
    33 => NameKnown("SUNSD")
    34 => NameKnown("SLWTC")
    35 => NameKnown("SSWTC")
    36 => NameKnown("FSTRPC")
    37 => NameKnown("FCONPC")
    38 => NameKnown("MASSDCD")
    39 => NameKnown("MASSDCI")
    40 => NameKnown("MDCCWD")
    47 => NameKnown("VFRCWD")
    48 => NameKnown("VFRCICE")
    49 => NameKnown("VFRCIW")
    50 => NameKnown("FOG")
    51 => NameKnown("SUNFRAC")
    192 => NameKnown("CDLYR")
    193 => NameKnown("CWORK")
    194 => NameKnown("CUEFI")
    195 => NameKnown("TCOND")
    196 => NameKnown("TCOLW")
    197 => NameKnown("TCOLI")
    198 => NameKnown("TCOLC")
    199 => NameKnown("FICE")
    200 => NameKnown("MFLUX")
    201 => NameKnown("SUNSD")
    202 => NameKnown("FOGLWC")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 41 && parameter <= 46) ||
        (parameter >= 52 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_7_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PLI")
    1 => NameKnown("BLI")
    2 => NameKnown("KX")
    3 => NameKnown("KOX")
    4 => NameKnown("TOTALX")
    5 => NameKnown("SX")
    6 => NameKnown("CAPE")
    7 => NameKnown("CIN")
    8 => NameKnown("HLCY")
    9 => NameKnown("EHLX")
    10 => NameKnown("LFTX")
    11 => NameKnown("4LFTX")
    12 => NameKnown("RI")
    13 => NameKnown("SHWINX")
    15 => NameKnown("UPHL")
    16 => NameKnown("BLKRN")
    17 => NameKnown("GRDRN")
    18 => NameKnown("FLXRN")
    19 => NameKnown("CONAPES")
    20 => NameKnown("TIIDEX")
    21 => NameKnown("SSI")
    22 => NameKnown("RMOL")
    192 => NameKnown("LFTX")
    193 => NameKnown("4LFTX")
    194 => NameKnown("RI")
    195 => NameKnown("CWDI")
    196 => NameKnown("UVI")
    197 => NameKnown("UPHL")
    198 => NameKnown("LAI")
    199 => NameKnown("MXUPHL")
    200 => NameKnown("MNUPHL")
    201 => NameKnown("BNEGELAY")
    202 => NameKnown("BPOSELAY")
    203 => NameKnown("DCAPE")
    204 => NameKnown("EFHL")
    205 => NameKnown("ESP")
    206 => NameKnown("CANGLE")
    207 => NameKnown("E3KH")
    208 => NameKnown("STPC")
    209 => NameKnown("SIGH")
    210 => NameKnown("SCCP")
    211 => NameKnown("SIGT")
    212 => NameKnown("MLFC")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 14 || (parameter >= 23 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=7,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_13_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("AEROT")
    192 => NameKnown("PMTC")
    193 => NameKnown("PMTF")
    194 => NameKnown("LPMTF")
    195 => NameKnown("LIPMF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 1 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=13,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_14_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TOZNE")
    1 => NameKnown("O3MR")
    2 => NameKnown("TCIOZ")
    192 => NameKnown("O3MR")
    193 => NameKnown("OZCON")
    194 => NameKnown("OZCAT")
    195 => NameKnown("VDFOZ")
    196 => NameKnown("POZ")
    197 => NameKnown("TOZ")
    198 => NameKnown("POZT")
    199 => NameKnown("POZO")
    200 => NameKnown("OZMAX1")
    201 => NameKnown("OZMAX8")
    202 => NameKnown("PDMAX1")
    203 => NameKnown("PDMAX24")
    204 => NameKnown("ALD2")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=14,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_15_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("BSWID")
    1 => NameKnown("BREF")
    2 => NameKnown("BRVEL")
    3 => NameKnown("VIL")
    4 => NameKnown("LMAXBR")
    5 => NameKnown("PREC")
    6 => NameKnown("RDSP1")
    7 => NameKnown("RDSP2")
    8 => NameKnown("RDSP3")
    9 => NameKnown("RFCD")
    10 => NameKnown("RFCI")
    11 => NameKnown("RFSNOW")
    12 => NameKnown("RFRAIN")
    13 => NameKnown("RFGRPL")
    14 => NameKnown("RFHAIL")
    15 => NameKnown("HSR")
    16 => NameKnown("HSRHT")
    17 => NameKnown("PRATERAD")
    18 => NameKnown("RQI")
    19 => NameKnown("RDQF")
    20 => NameKnown("LMAXPRATE")
    192 => NameKnown("RADARVIL")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 21 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=15,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_16_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("REFZR")
    1 => NameKnown("REFZI")
    2 => NameKnown("REFZC")
    3 => NameKnown("RETOP")
    4 => NameKnown("REFD")
    5 => NameKnown("REFC")
    6 => NameKnown("PRATEFRAD")
    7 => NameKnown("LMAXPRATEF")
    8 => NameKnown("LMAXREF")
    192 => NameKnown("REFZR")
    193 => NameKnown("REFZI")
    194 => NameKnown("REFZC")
    195 => NameKnown("REFD")
    196 => NameKnown("REFC")
    197 => NameKnown("RETOP")
    198 => NameKnown("MAXREF")
    199 => NameKnown("MAXREFC")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=16,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_17_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("LTNGSD")
    1 => NameKnown("LTPINX")
    2 => NameKnown("CDGDLTFD")
    3 => NameKnown("CDCDLTFD")
    4 => NameKnown("TLGTFD")
    5 => NameKnown("SLNGPIDX")
    192 => NameKnown("LTNG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=17,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_18_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ACCES")
    1 => NameKnown("ACIOD")
    2 => NameKnown("ACRADP")
    3 => NameKnown("GDCES")
    4 => NameKnown("GDIOD")
    5 => NameKnown("GDRADP")
    6 => NameKnown("TIACCP")
    7 => NameKnown("TIACIP")
    8 => NameKnown("TIACRP")
    10 => NameKnown("AIRCON")
    11 => NameKnown("WETDEP")
    12 => NameKnown("DRYDEP")
    13 => NameKnown("TOTLWD")
    14 => NameKnown("SACON")
    15 => NameKnown("MAXACON")
    16 => NameKnown("HMXACON")
    17 => NameKnown("CIAIRC")
    18 => NameKnown("CAACL")
    19 => NameKnown("DEPACTA")
    20 => NameKnown("DEPACTE")
    21 => NameKnown("CLDACTA")
    22 => NameKnown("CLDACTE")
    23 => NameKnown("EFFDOSER")
    24 => NameKnown("THYDOSER")
    25 => NameKnown("GAMDOSER")
    26 => NameKnown("ACTEMM")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 9 || (parameter >= 27 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=18,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_19_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("VIS")
    1 => NameKnown("ALBDO")
    2 => NameKnown("TSTM")
    3 => NameKnown("MIXHT")
    4 => NameKnown("VOLASH")
    5 => NameKnown("ICIT")
    6 => NameKnown("ICIB")
    7 => NameKnown("ICI")
    8 => NameKnown("TURBT")
    9 => NameKnown("TURBB")
    10 => NameKnown("TURB")
    11 => NameKnown("TKE")
    12 => NameKnown("PBLREG")
    13 => NameKnown("CONTI")
    14 => NameKnown("CONTET")
    15 => NameKnown("CONTT")
    16 => NameKnown("CONTB")
    17 => NameKnown("MXSALB")
    18 => NameKnown("SNFALB")
    19 => NameKnown("SALBD")
    20 => NameKnown("ICIP")
    21 => NameKnown("CTP")
    22 => NameKnown("CAT")
    23 => NameKnown("SLDP")
    24 => NameKnown("CONTKE")
    25 => NameKnown("WIWW")
    26 => NameKnown("CONVO")
    27 => NameKnown("ICESC")
    28 => NameKnown("MWTURB")
    29 => NameKnown("CATEDR")
    30 => NameKnown("EDPARM")
    31 => NameKnown("MXEDPRM")
    32 => NameKnown("HIFREL")
    33 => NameKnown("VISLFOG")
    34 => NameKnown("VISIFOG")
    35 => NameKnown("VISBSN")
    36 => NameKnown("PSNOWS")
    37 => NameKnown("ICESEV")
    38 => NameKnown("SKYIDX")
    39 => NameKnown("SEEINDEX")
    40 => NameKnown("SNOWLVL")
    41 => NameKnown("DBHEIGHT")
    42 => NameKnown("TLBHEIGHT")
    43 => NameKnown("TLTHEIGHT")
    44 => NameKnown("MEANVGRTL")
    45 => NameKnown("MINVGRTL")
    46 => NameKnown("NETRADFLUX")
    47 => NameKnown("GLIRRTS")
    48 => NameKnown("PCONTT")
    49 => NameKnown("PCONTB")
    50 => NameKnown("CITEDR")
    51 => NameKnown("VISPCP")
    52 => NameKnown("HAILKEF")
    192 => NameKnown("MXSALB")
    193 => NameKnown("SNFALB")
    194 => NameKnown("SRCONO")
    195 => NameKnown("MRCONO")
    196 => NameKnown("HRCONO")
    197 => NameKnown("TORPROB")
    198 => NameKnown("HAILPROB")
    199 => NameKnown("WINDPROB")
    200 => NameKnown("STORPROB")
    201 => NameKnown("SHAILPRO")
    202 => NameKnown("SWINDPRO")
    203 => NameKnown("TSTMC")
    204 => NameKnown("MIXLY")
    205 => NameKnown("FLGHT")
    206 => NameKnown("CICEL")
    207 => NameKnown("CIVIS")
    208 => NameKnown("CIFLT")
    209 => NameKnown("LAVNI")
    210 => NameKnown("HAVNI")
    211 => NameKnown("SBSALB")
    212 => NameKnown("SWSALB")
    213 => NameKnown("NBSALB")
    214 => NameKnown("NWSALB")
    215 => NameKnown("PRSVR")
    216 => NameKnown("PRSIGSVR")
    217 => NameKnown("SIPD")
    218 => NameKnown("EPSR")
    219 => NameKnown("TPFI")
    220 => NameKnown("SVRTS")
    221 => NameKnown("PROCON")
    222 => NameKnown("CONVP")
    223 => NameKnown("CIGTOR")
    224 => NameKnown("CIGHAIL")
    225 => NameKnown("CIGWIND")
    226 => NameKnown("CIGSVR")
    232 => NameKnown("VAFTD")
    233 => NameKnown("ICPRB")
    234 => NameKnown("ICSEV")
    235 => NameKnown("JFWPRB")
    236 => NameKnown("SNOWLVL")
    237 => NameKnown("DRYTPROB")
    238 => NameKnown("ELLINX")
    239 => NameKnown("CWASP")
    240 => NameKnown("ICESEVCON")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 53 && parameter <= 191) ||
        (parameter >= 227 && parameter <= 231) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=19,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_190_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ATEXT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 1 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=190,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_191_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TSEC")
    1 => NameKnown("GEOLAT")
    2 => NameKnown("GEOLON")
    3 => NameKnown("DSLOBS")
    4 => NameKnown("TCDTRACK")
    5 => NameKnown("HURTSV")
    6 => NameKnown("TSTSV")
    7 => NameKnown("TDTSV")
    192 => NameKnown("NLAT")
    193 => NameKnown("ELON")
    194 => NameKnown("RTSEC")
    195 => NameKnown("MLYNO")
    196 => NameKnown("NLATN")
    197 => NameKnown("ELONN")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 8 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=191,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_192_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    1 => NameKnown("COVMZ")
    2 => NameKnown("COVTZ")
    3 => NameKnown("COVTM")
    4 => NameKnown("COVTW")
    5 => NameKnown("COVZZ")
    6 => NameKnown("COVMM")
    7 => NameKnown("COVQZ")
    8 => NameKnown("COVQM")
    9 => NameKnown("COVTVV")
    10 => NameKnown("COVQVV")
    11 => NameKnown("COVPSPS")
    12 => NameKnown("COVQQ")
    13 => NameKnown("COVVVVV")
    14 => NameKnown("COVTT")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 0 || (parameter >= 15 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=192,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_1_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("FFLDG")
    1 => NameKnown("FFLDRO")
    2 => NameKnown("RSSC")
    3 => NameKnown("ESCT")
    4 => NameKnown("SWEPON")
    5 => NameKnown("BGRUN")
    6 => NameKnown("SSRUN")
    7 => NameKnown("DISRS")
    8 => NameKnown("GWUPS")
    9 => NameKnown("GWLOWS")
    10 => NameKnown("SFLORC")
    11 => NameKnown("RVERSW")
    12 => NameKnown("FLDPSW")
    13 => NameKnown("DEPWSS")
    14 => NameKnown("UPAPCP")
    15 => NameKnown("UPASM")
    16 => NameKnown("PERRATE")
    17 => NameKnown("RVEROW")
    18 => NameKnown("FLDPOW")
    19 => NameKnown("FLDPATHOW")
    20 => NameKnown("WATSURF")
    21 => NameKnown("WSE")
    22 => NameKnown("GRFR")
    23 => NameKnown("RVERFLDPS")
    24 => NameKnown("DARVERVEL")
    192 => NameKnown("BGRUN")
    193 => NameKnown("SSRUN")
    194 => NameKnown("FHO")
    196 => NameKnown("AHD")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 25 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=1,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_1_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("CPPOP")
    1 => NameKnown("PPOSP")
    2 => NameKnown("POP")
    192 => NameKnown("CPOZP")
    193 => NameKnown("CPOFP")
    194 => NameKnown("PPFFG")
    195 => NameKnown("CWR")
    196 => NameKnown("QPFARI")
    197 => NameKnown("QPFFFG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=1,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_1_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WDPTHIL")
    1 => NameKnown("WTMPIL")
    2 => NameKnown("WFRACT")
    3 => NameKnown("SEDTK")
    4 => NameKnown("SEDTMP")
    5 => NameKnown("ICTKIL")
    6 => NameKnown("ICETIL")
    7 => NameKnown("ICECIL")
    8 => NameKnown("LANDIL")
    9 => NameKnown("SFSAL")
    10 => NameKnown("SFTMP")
    11 => NameKnown("ACWSR")
    12 => NameKnown("SALTIL")
    13 => NameKnown("CSAFC")
    14 => NameKnown("LNDSNOWT")
    15 => NameKnown("LDEPTH")
    16 => NameKnown("RDEPTH")
    17 => NameKnown("FLDPDEPTH")
    18 => NameKnown("FLDPFLFR")
    19 => NameKnown("FLDPFLAR")
    20 => NameKnown("RVERFR")
    21 => NameKnown("RVERAR")
    22 => NameKnown("FRCRF")
    23 => NameKnown("ARCRF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 24 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=1,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("LAND")
    1 => NameKnown("SFCR")
    2 => NameKnown("TSOIL")
    4 => NameKnown("VEG")
    5 => NameKnown("WATR")
    6 => NameKnown("EVAPT")
    7 => NameKnown("MTERH")
    8 => NameKnown("LANDU")
    9 => NameKnown("SOILW")
    10 => NameKnown("GFLUX")
    11 => NameKnown("MSTAV")
    12 => NameKnown("SFEXC")
    13 => NameKnown("CNWAT")
    14 => NameKnown("BMIXL")
    15 => NameKnown("CCOND")
    16 => NameKnown("RSMIN")
    17 => NameKnown("WILT")
    18 => NameKnown("RCS")
    19 => NameKnown("RCT")
    20 => NameKnown("RCQ")
    21 => NameKnown("RCSOL")
    23 => NameKnown("CISOILW")
    24 => NameKnown("HFLUX")
    25 => NameKnown("VSOILM")
    26 => NameKnown("WILT")
    27 => NameKnown("VWILTP")
    28 => NameKnown("LEAINX")
    29 => NameKnown("EVGFC")
    30 => NameKnown("DECFC")
    31 => NameKnown("NDVINX")
    32 => NameKnown("RDVEG")
    33 => NameKnown("WROD")
    34 => NameKnown("SFCWRO")
    35 => NameKnown("TCLASS")
    36 => NameKnown("TFRCT")
    37 => NameKnown("TPERCT")
    38 => NameKnown("SOILVIC")
    39 => NameKnown("EVAPTRAT")
    40 => NameKnown("PEVAPTRAT")
    41 => NameKnown("SMRATE")
    42 => NameKnown("WRDRATE")
    43 => NameKnown("DRAINDIR")
    44 => NameKnown("UPSAREA")
    45 => NameKnown("WETCOV")
    46 => NameKnown("WETTYPE")
    47 => NameKnown("IRRCOV")
    48 => NameKnown("CROPCOV")
    49 => NameKnown("GRASSCOV")
    50 => NameKnown("SKINRC")
    51 => NameKnown("SURFRATE")
    52 => NameKnown("SUBSRATE")
    53 => NameKnown("LOVEGCOV")
    54 => NameKnown("HIVEGCOV")
    55 => NameKnown("LAILO")
    56 => NameKnown("LAIHI")
    57 => NameKnown("TYPLOVEG")
    58 => NameKnown("TYPHIVEG")
    59 => NameKnown("NECOFLUX")
    60 => NameKnown("GROSSFLUX")
    61 => NameKnown("ECORFLUX")
    62 => NameKnown("EMISS")
    63 => NameKnown("CANTMP")
    192 => NameKnown("SOILW")
    193 => NameKnown("GFLUX")
    194 => NameKnown("MSTAV")
    195 => NameKnown("SFEXC")
    196 => NameKnown("CNWAT")
    197 => NameKnown("BMIXL")
    198 => NameKnown("VGTYP")
    199 => NameKnown("CCOND")
    200 => NameKnown("RSMIN")
    201 => NameKnown("WILT")
    202 => NameKnown("RCS")
    203 => NameKnown("RCT")
    204 => NameKnown("RCQ")
    205 => NameKnown("RCSOL")
    206 => NameKnown("RDRIP")
    207 => NameKnown("ICWAT")
    208 => NameKnown("AKHS")
    209 => NameKnown("AKMS")
    210 => NameKnown("VEGT")
    211 => NameKnown("SSTOR")
    212 => NameKnown("LSOIL")
    213 => NameKnown("EWATR")
    214 => NameKnown("GWREC")
    215 => NameKnown("QREC")
    216 => NameKnown("SFCRH")
    217 => NameKnown("NDVI")
    218 => NameKnown("LANDN")
    219 => NameKnown("AMIXL")
    220 => NameKnown("WVINC")
    221 => NameKnown("WCINC")
    222 => NameKnown("WVCONV")
    223 => NameKnown("WCCONV")
    224 => NameKnown("WVUFLX")
    225 => NameKnown("WVVFLX")
    226 => NameKnown("WCUFLX")
    227 => NameKnown("WCVFLX")
    228 => NameKnown("ACOND")
    229 => NameKnown("EVCW")
    230 => NameKnown("TRANS")
    231 => NameKnown("VEGMIN")
    232 => NameKnown("VEGMAX")
    233 => NameKnown("LANDFRC")
    234 => NameKnown("LAKEFRC")
    235 => NameKnown("PAHFLX")
    236 => NameKnown("WATERSA")
    237 => NameKnown("EIWATER")
    238 => NameKnown("PLANTTR")
    239 => NameKnown("SOILSE")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 64 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    192 => NameKnown("CANL")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 0 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SOTYP")
    1 => NameKnown("UPLST")
    2 => NameKnown("UPLSM")
    3 => NameKnown("LOWLSM")
    4 => NameKnown("BOTLST")
    5 => NameKnown("SOILL")
    6 => NameKnown("RLYRS")
    7 => NameKnown("SMREF")
    8 => NameKnown("SMDRY")
    9 => NameKnown("POROS")
    10 => NameKnown("LIQVSM")
    11 => NameKnown("VOLTSO")
    12 => NameKnown("TRANSO")
    13 => NameKnown("VOLDEC")
    14 => NameKnown("DIREC")
    15 => NameKnown("SOILP")
    16 => NameKnown("VSOSM")
    17 => NameKnown("SATOSM")
    18 => NameKnown("SOILTMP")
    19 => NameKnown("SOILMOI")
    20 => NameKnown("CISOILM")
    21 => NameKnown("SOILICE")
    22 => NameKnown("CISICE")
    23 => NameKnown("LWSNWP")
    24 => NameKnown("FRSTINX")
    25 => NameKnown("SNWDEB")
    26 => NameKnown("SHFLX")
    27 => NameKnown("SOILDEP")
    28 => NameKnown("SNOWTMP")
    29 => NameKnown("ICETEMP")
    30 => NameKnown("SWET")
    192 => NameKnown("SOILL")
    193 => NameKnown("RLYRS")
    194 => NameKnown("SLTYP")
    195 => NameKnown("SMREF")
    196 => NameKnown("SMDRY")
    197 => NameKnown("POROS")
    198 => NameKnown("EVBS")
    199 => NameKnown("LSPA")
    200 => NameKnown("BARET")
    201 => NameKnown("AVSFT")
    202 => NameKnown("RADT")
    203 => NameKnown("FLDCP")
    204 => NameKnown("MSTAVTOP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 31 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("FIREOLK")
    1 => NameKnown("FIREODT")
    2 => NameKnown("HINDEX")
    3 => NameKnown("FBAREA")
    4 => NameKnown("FOSINDX")
    5 => NameKnown("FWINX")
    6 => NameKnown("FFMCODE")
    7 => NameKnown("DUFMCODE")
    8 => NameKnown("DRTCODE")
    9 => NameKnown("INFSINX")
    10 => NameKnown("FBUPINX")
    11 => NameKnown("FDSRTE")
    12 => NameKnown("KRIDX")
    13 => NameKnown("DRFACT")
    14 => NameKnown("RATESPRD")
    15 => NameKnown("FIREDIDX")
    16 => NameKnown("SPRDCOMP")
    17 => NameKnown("BURNIDX")
    18 => NameKnown("IGNCOMP")
    19 => NameKnown("ENRELCOM")
    20 => NameKnown("BURNAREA")
    21 => NameKnown("BURNABAREA")
    22 => NameKnown("UNBURNAREA")
    23 => NameKnown("FUELLOAD")
    24 => NameKnown("COMBCO")
    25 => NameKnown("FUELMC")
    26 => NameKnown("WFIREPOT")
    27 => NameKnown("LLFL")
    28 => NameKnown("LWFL")
    29 => NameKnown("DLFL")
    30 => NameKnown("DWFL")
    31 => NameKnown("LFMC")
    32 => NameKnown("FDLMC")
    33 => NameKnown("DDLMC")
    34 => NameKnown("FDWMC")
    35 => NameKnown("DDWMC")
    36 => NameKnown("FRADPOW")
    37 => NameKnown("LFMCLV")
    38 => NameKnown("LFMCHV")
    39 => NameKnown("MEANHGTINJ")
    40 => NameKnown("HGTINJ")
    41 => NameKnown("HGTPLUMEB")
    42 => NameKnown("HGTPLUMET")
    43 => NameKnown("FDPROB")
    44 => NameKnown("IGNLTNG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 45 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("GLACCOV")
    1 => NameKnown("GLACTMP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 2 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("URBCOVER")
    1 => NameKnown("ROADCOVER")
    2 => NameKnown("BUILDCOVER")
    3 => NameKnown("BUILDHGT")
    4 => NameKnown("VZAFRAC")
    5 => NameKnown("SDBUILDHGT")
    6 => NameKnown("DDROOF")
    7 => NameKnown("DIOWALL")
    8 => NameKnown("DDROAD")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_7_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("HNETFLUX")
    1 => NameKnown("LHTFLUX")
    2 => NameKnown("SHTFLUX")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=7,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SRAD")
    1 => NameKnown("SALBEDO")
    2 => NameKnown("SBTMP")
    3 => NameKnown("SPWAT")
    4 => NameKnown("SLFTI")
    5 => NameKnown("SCTPRES")
    6 => NameKnown("SSTMP")
    7 => NameKnown("CLOUDM")
    8 => NameKnown("PIXST")
    9 => NameKnown("FIREDI")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 10 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ESTP")
    1 => NameKnown("IRRATE")
    2 => NameKnown("CTOPH")
    3 => NameKnown("CTOPHQI")
    4 => NameKnown("ESTUGRD")
    5 => NameKnown("ESTVGRD")
    6 => NameKnown("NPIXU")
    7 => NameKnown("SOLZA")
    8 => NameKnown("RAZA")
    9 => NameKnown("RFL06")
    10 => NameKnown("RFL08")
    11 => NameKnown("RFL16")
    12 => NameKnown("RFL39")
    13 => NameKnown("ATMDIV")
    14 => NameKnown("CBTMP")
    15 => NameKnown("CSBTMP")
    16 => NameKnown("CLDRAD")
    17 => NameKnown("CSKYRAD")
    19 => NameKnown("WINDS")
    20 => NameKnown("AOT06")
    21 => NameKnown("AOT08")
    22 => NameKnown("AOT16")
    23 => NameKnown("ANGCOE")
    24 => NameKnown("COSOLZA")
    27 => NameKnown("BRFLF")
    28 => NameKnown("SPBRT")
    29 => NameKnown("SCRAD")
    30 => NameKnown("RFL04")
    31 => NameKnown("CLDREF")
    32 => NameKnown("CLRREF")
    98 => NameKnown("CCMPEMRR")
    99 => NameKnown("SDMPEMRR")
    192 => NameKnown("USCT")
    193 => NameKnown("VSCT")
    194 => NameKnown("SWQI")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 18 ||
        (parameter >= 25 && parameter <= 26) ||
        (parameter >= 33 && parameter <= 97) ||
        (parameter >= 100 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("CSKPROB")
    1 => NameKnown("CTOPTMP")
    2 => NameKnown("CTOPRES")
    3 => NameKnown("CLDTYPE")
    4 => NameKnown("CLDPHAS")
    5 => NameKnown("CLDODEP")
    6 => NameKnown("CLDPER")
    7 => NameKnown("CLDLWP")
    8 => NameKnown("CLDIWP")
    9 => NameKnown("CLDALB")
    10 => NameKnown("CLDEMISS")
    11 => NameKnown("EAODR")
    30 => NameKnown("MEACST")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 12 && parameter <= 29) ||
        (parameter >= 41 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PBMVFRC")
    1 => NameKnown("PBLIFRC")
    2 => NameKnown("PBINFRC")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("VOLAPROB")
    1 => NameKnown("VOLACDTT")
    2 => NameKnown("VOLACDTP")
    3 => NameKnown("VOLACDTH")
    4 => NameKnown("VOLACDEM")
    5 => NameKnown("VOLAEADR")
    6 => NameKnown("VOLACDOD")
    7 => NameKnown("VOLACDEN")
    8 => NameKnown("VOLAPER")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ISSTMP")
    1 => NameKnown("SKSSTMP")
    2 => NameKnown("SSKSSTMP")
    3 => NameKnown("FDNSSTMP")
    4 => NameKnown("EBSSTSTD")
    5 => NameKnown("EBSDSSTS")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("GSOLIRR")
    1 => NameKnown("GSOLEXP")
    2 => NameKnown("DIRSOLIR")
    3 => NameKnown("DIRSOLEX")
    4 => NameKnown("DIFSOLIR")
    5 => NameKnown("DIFSOLEX")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_192_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SBT122")
    1 => NameKnown("SBT123")
    2 => NameKnown("SBT124")
    3 => NameKnown("SBT126")
    4 => NameKnown("SBC123")
    5 => NameKnown("SBC124")
    6 => NameKnown("SBT112")
    7 => NameKnown("SBT113")
    8 => NameKnown("SBT114")
    9 => NameKnown("SBT115")
    10 => NameKnown("AMSRE9")
    11 => NameKnown("AMSRE10")
    12 => NameKnown("AMSRE11")
    13 => NameKnown("AMSRE12")
    14 => NameKnown("SRFA161")
    15 => NameKnown("SRFA162")
    16 => NameKnown("SRFA163")
    17 => NameKnown("SRFA164")
    18 => NameKnown("SRFA165")
    19 => NameKnown("SRFA166")
    20 => NameKnown("SBTA167")
    21 => NameKnown("SBTA168")
    22 => NameKnown("SBTA169")
    23 => NameKnown("SBTA1610")
    24 => NameKnown("SBTA1611")
    25 => NameKnown("SBTA1612")
    26 => NameKnown("SBTA1613")
    27 => NameKnown("SBTA1614")
    28 => NameKnown("SBTA1615")
    29 => NameKnown("SBTA1616")
    30 => NameKnown("SRFA171")
    31 => NameKnown("SRFA172")
    32 => NameKnown("SRFA173")
    33 => NameKnown("SRFA174")
    34 => NameKnown("SRFA175")
    35 => NameKnown("SRFA176")
    36 => NameKnown("SBTA177")
    37 => NameKnown("SBTA178")
    38 => NameKnown("SBTA179")
    39 => NameKnown("SBTA1710")
    40 => NameKnown("SBTA1711")
    41 => NameKnown("SBTA1712")
    42 => NameKnown("SBTA1713")
    43 => NameKnown("SBTA1714")
    44 => NameKnown("SBTA1715")
    45 => NameKnown("SBTA1716")
    46 => NameKnown("SRFAGR1")
    47 => NameKnown("SRFAGR2")
    48 => NameKnown("SRFAGR3")
    49 => NameKnown("SRFAGR4")
    50 => NameKnown("SRFAGR5")
    51 => NameKnown("SRFAGR6")
    52 => NameKnown("SBTAGR7")
    53 => NameKnown("SBTAGR8")
    54 => NameKnown("SBTAGR9")
    55 => NameKnown("SBTAGR10")
    56 => NameKnown("SBTAGR11")
    57 => NameKnown("SBTAGR12")
    58 => NameKnown("SBTAGR13")
    59 => NameKnown("SBTAGR14")
    60 => NameKnown("SBTAGR15")
    61 => NameKnown("SBTAGR16")
    62 => NameKnown("SSMS1715")
    63 => NameKnown("SSMS1716")
    64 => NameKnown("SSMS1717")
    65 => NameKnown("SSMS1718")
    66 => NameKnown("SBTAHI7")
    67 => NameKnown("SBTAHI8")
    68 => NameKnown("SBTAHI9")
    69 => NameKnown("SBTAHI10")
    70 => NameKnown("SBTAHI11")
    71 => NameKnown("SBTAHI12")
    72 => NameKnown("SBTAHI13")
    73 => NameKnown("SBTAHI14")
    74 => NameKnown("SBTAHI15")
    75 => NameKnown("SBTAHI16")
    76 => NameKnown("SBTA187")
    77 => NameKnown("SBTA188")
    78 => NameKnown("SBTA189")
    79 => NameKnown("SBTA1810")
    80 => NameKnown("SBTA1811")
    81 => NameKnown("SBTA1812")
    82 => NameKnown("SBTA1813")
    83 => NameKnown("SBTA1814")
    84 => NameKnown("SBTA1815")
    85 => NameKnown("SBTA1816")
    86 => NameKnown("SSMS1712")
    87 => NameKnown("SSMS1713")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 88 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=192,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TMPSWP")
    1 => NameKnown("ELECTMP")
    2 => NameKnown("PROTTMP")
    3 => NameKnown("IONTMP")
    4 => NameKnown("PRATMP")
    5 => NameKnown("PRPTMP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SPEED")
    1 => NameKnown("VEL1")
    2 => NameKnown("VEL2")
    3 => NameKnown("VEL3")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 4 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PLSMDEN")
    1 => NameKnown("ELCDEN")
    2 => NameKnown("PROTDEN")
    3 => NameKnown("IONDEN")
    4 => NameKnown("VTEC")
    5 => NameKnown("ABSFRQ")
    6 => NameKnown("ABSRB")
    7 => NameKnown("SPRDF")
    8 => NameKnown("HPRIMF")
    9 => NameKnown("CRTFRQ")
    10 => NameKnown("MAXUFZ")
    11 => NameKnown("PEAKH")
    12 => NameKnown("PEAKDEN")
    13 => NameKnown("EQSLABT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 14 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("BTOT")
    1 => NameKnown("BVEC1")
    2 => NameKnown("BVEC2")
    3 => NameKnown("BVEC3")
    4 => NameKnown("ETOT")
    5 => NameKnown("EVEC1")
    6 => NameKnown("EVEC2")
    7 => NameKnown("EVEC3")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 8 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("DIFPFLUX")
    1 => NameKnown("INTPFLUX")
    2 => NameKnown("DIFEFLUX")
    3 => NameKnown("INTEFLUX")
    4 => NameKnown("DIFIFLUX")
    5 => NameKnown("INTIFLUX")
    6 => NameKnown("NTRNFLUX")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 7 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("AMPL")
    1 => NameKnown("PHASE")
    2 => NameKnown("FREQ")
    3 => NameKnown("WAVELGTH")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 4 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TSI")
    1 => NameKnown("XLONG")
    2 => NameKnown("XSHRT")
    3 => NameKnown("EUVIRR")
    4 => NameKnown("SPECIRR")
    5 => NameKnown("F107")
    6 => NameKnown("SOLRF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 7 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_7_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("LMBINT")
    1 => NameKnown("DSKINT")
    2 => NameKnown("DSKDAY")
    3 => NameKnown("DSKNGT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 4 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=7,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_8_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("XRAYRAD")
    1 => NameKnown("EUVRAD")
    2 => NameKnown("HARAD")
    3 => NameKnown("WHTRAD")
    4 => NameKnown("CAIIRAD")
    5 => NameKnown("WHTCOR")
    6 => NameKnown("HELCOR")
    7 => NameKnown("MASK")
    8 => NameKnown("SICFL")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=8,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_9_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SIGPED")
    1 => NameKnown("SIGHAL")
    2 => NameKnown("SIGPAR")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=9,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_10_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SCINIDX")
    1 => NameKnown("SCIDEXS4")
    2 => NameKnown("ROTIDX")
    3 => NameKnown("DIDXSG")
    4 => NameKnown("AATRATE")
    5 => NameKnown("KP")
    6 => NameKnown("EDISSTIX")
    7 => NameKnown("AURELEC")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 8 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=10,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WVSP1")
    1 => NameKnown("WVSP2")
    2 => NameKnown("WVSP3")
    3 => NameKnown("HTSGW")
    4 => NameKnown("WVDIR")
    5 => NameKnown("WVHGT")
    6 => NameKnown("WVPER")
    7 => NameKnown("SWDIR")
    8 => NameKnown("SWELL")
    9 => NameKnown("SWPER")
    10 => NameKnown("DIRPW")
    11 => NameKnown("PERPW")
    12 => NameKnown("DIRSW")
    13 => NameKnown("PERSW")
    14 => NameKnown("WWSDIR")
    15 => NameKnown("MWSPER")
    16 => NameKnown("CDWW")
    17 => NameKnown("FRICVW")
    18 => NameKnown("WSTR")
    19 => NameKnown("NWSTR")
    20 => NameKnown("MSSW")
    21 => NameKnown("USSD")
    22 => NameKnown("VSSD")
    23 => NameKnown("PMAXWH")
    24 => NameKnown("MAXWH")
    25 => NameKnown("IMWF")
    26 => NameKnown("IMFWW")
    27 => NameKnown("IMFTSW")
    28 => NameKnown("MZWPER")
    29 => NameKnown("MZPWW")
    30 => NameKnown("MZPTSW")
    31 => NameKnown("WDIRW")
    32 => NameKnown("DIRWWW")
    33 => NameKnown("DIRWTS")
    34 => NameKnown("PWPER")
    35 => NameKnown("PPERWW")
    36 => NameKnown("PPERTS")
    37 => NameKnown("ALTWH")
    38 => NameKnown("ALCWH")
    39 => NameKnown("ALRRC")
    40 => NameKnown("MNWSOW")
    41 => NameKnown("MWDIRW")
    42 => NameKnown("WESP")
    43 => NameKnown("KSSEW")
    44 => NameKnown("BENINX")
    45 => NameKnown("SPFTR")
    46 => NameKnown("PWAVEDIR")
    47 => NameKnown("SWHFSWEL")
    48 => NameKnown("SWHSSWEL")
    49 => NameKnown("SWHTSWEL")
    50 => NameKnown("MWPFSWEL")
    51 => NameKnown("MWPSSWEL")
    52 => NameKnown("MWPTSWEL")
    53 => NameKnown("MWDFSWEL")
    54 => NameKnown("MWDSSWEL")
    55 => NameKnown("MWDTSWEL")
    56 => NameKnown("WDWFSWEL")
    57 => NameKnown("WDWSSWEL")
    58 => NameKnown("WDWTSWEL")
    59 => NameKnown("WFWFSWEL")
    60 => NameKnown("WFWSSWEL")
    61 => NameKnown("WFWTSWEL")
    62 => NameKnown("WAVEFREW")
    63 => NameKnown("FREWWW")
    64 => NameKnown("FREWTSW")
    65 => NameKnown("PWPFSPAR")
    66 => NameKnown("PWPSSPAR")
    67 => NameKnown("PWPTSPAR")
    68 => NameKnown("PWDFSPAR")
    69 => NameKnown("PWDSSPAR")
    70 => NameKnown("PWDTSPAR")
    71 => NameKnown("PDWWAVE")
    72 => NameKnown("PDTSWELL")
    73 => NameKnown("WCAPFRAC")
    74 => NameKnown("MDTSWEL")
    75 => NameKnown("MDWWAVE")
    76 => NameKnown("CHNCK")
    77 => NameKnown("WAVESPSK")
    78 => NameKnown("WAVEFMAG")
    79 => NameKnown("WAVEFDIR")
    80 => NameKnown("RWAVEAFW")
    81 => NameKnown("FCVOCEAN")
    82 => NameKnown("AIRDENOC")
    83 => NameKnown("NEFW")
    84 => NameKnown("NSOCEAN")
    85 => NameKnown("NEFOCEAN")
    86 => NameKnown("SEVWAVE")
    87 => NameKnown("WAVEMSLC")
    88 => NameKnown("SPECWI")
    89 => NameKnown("EFWS")
    90 => NameKnown("USMFO")
    91 => NameKnown("VSMFO")
    92 => NameKnown("WAVETEFO")
    93 => NameKnown("EMIWAVE")
    94 => NameKnown("TDMCREST")
    95 => NameKnown("TDMWAVE")
    96 => NameKnown("STMCREST")
    97 => NameKnown("STMWAVE")
    98 => NameKnown("GODAPEAK")
    99 => NameKnown("BFI2D")
    100 => NameKnown("CTCORR")
    101 => NameKnown("WSTRICEX")
    102 => NameKnown("WSTRICEY")
    103 => NameKnown("UASMF")
    104 => NameKnown("VASMF")
    192 => NameKnown("WSTP")
    193 => NameKnown("WLENG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 105 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 194 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("DIRC")
    1 => NameKnown("SPC")
    2 => NameKnown("UOGRD")
    3 => NameKnown("VOGRD")
    4 => NameKnown("RIPCOP")
    5 => NameKnown("EASTCUR")
    6 => NameKnown("NRTHCUR")
    192 => NameKnown("OMLU")
    193 => NameKnown("OMLV")
    194 => NameKnown("UBARO")
    195 => NameKnown("VBARO")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 7 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 196 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ICEC")
    1 => NameKnown("ICETK")
    2 => NameKnown("DICED")
    3 => NameKnown("SICED")
    4 => NameKnown("UICE")
    5 => NameKnown("VICE")
    6 => NameKnown("ICEG")
    7 => NameKnown("ICED")
    8 => NameKnown("ICETMP")
    9 => NameKnown("ICEPRS")
    10 => NameKnown("ZVCICEP")
    11 => NameKnown("MVCICEP")
    12 => NameKnown("CICES")
    13 => NameKnown("SNOWTSI")
    14 => NameKnown("ALBDOICE")
    15 => NameKnown("SICEVOL")
    16 => NameKnown("SNVOLSI")
    17 => NameKnown("SICEHC")
    18 => NameKnown("SNCEHC")
    19 => NameKnown("ICEFTHCK")
    20 => NameKnown("ICEMPF")
    21 => NameKnown("ICEMPD")
    22 => NameKnown("ICEMPV")
    23 => NameKnown("SIFTP")
    24 => NameKnown("XICE")
    25 => NameKnown("YICE")
    26 => NameKnown("SICESAL")
    27 => NameKnown("FRZMLTPOT")
    28 => NameKnown("MLTDATE")
    29 => NameKnown("FRZDATE")
    30 => NameKnown("SICEBM")
    31 => NameKnown("DSWRFICE")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 32 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WTMP")
    1 => NameKnown("DSLM")
    2 => NameKnown("CH")
    3 => NameKnown("PRACTSAL")
    4 => NameKnown("DWHFLUX")
    5 => NameKnown("EASTWSS")
    6 => NameKnown("NORTHWSS")
    7 => NameKnown("XCOMPSS")
    8 => NameKnown("YCOMPSS")
    9 => NameKnown("THERCSSH")
    10 => NameKnown("HALOCSSH")
    11 => NameKnown("STERCSSH")
    12 => NameKnown("SEASFLUX")
    13 => NameKnown("NETUPWFLUX")
    14 => NameKnown("ESURFWVEL")
    15 => NameKnown("NSURFWVEL")
    16 => NameKnown("XSURFWVEL")
    17 => NameKnown("YSURFWVEL")
    18 => NameKnown("HFLUXCOR")
    19 => NameKnown("SSHGTPARM")
    20 => NameKnown("DSLIBARCOR")
    21 => NameKnown("SALINITY")
    22 => NameKnown("DSWRFSS")
    192 => NameKnown("SURGE")
    193 => NameKnown("ETSRG")
    194 => NameKnown("ELEV")
    195 => NameKnown("SSHG")
    196 => NameKnown("P2OMLT")
    197 => NameKnown("AOHFLX")
    198 => NameKnown("ASHFL")
    199 => NameKnown("SSTT")
    200 => NameKnown("SSST")
    201 => NameKnown("KENG")
    202 => NameKnown("SLTFL")
    203 => NameKnown("LCH")
    204 => NameKnown("FRZSPR")
    205 => NameKnown("TWLWAV")
    206 => NameKnown("RUNUP")
    207 => NameKnown("SETUP")
    208 => NameKnown("SWASH")
    209 => NameKnown("TWLDT")
    210 => NameKnown("TWLDC")
    242 => NameKnown("TCSRG20")
    243 => NameKnown("TCSRG30")
    244 => NameKnown("TCSRG40")
    245 => NameKnown("TCSRG50")
    246 => NameKnown("TCSRG60")
    247 => NameKnown("TCSRG70")
    248 => NameKnown("TCSRG80")
    249 => NameKnown("TCSRG90")
    250 => NameKnown("ETCWL")
    251 => NameKnown("TIDE")
    252 => NameKnown("EROSNP")
    253 => NameKnown("OWASHP")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 23 && parameter <= 191) ||
        (parameter >= 211 && parameter <= 241) ||
        parameter == 254 {
        NameKnown("Reserved")
      } else {
        NameUnknown("disc=10,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("MTHD")
    1 => NameKnown("MTHA")
    2 => NameKnown("TTHDP")
    3 => NameKnown("SALTY")
    4 => NameKnown("OVHD")
    5 => NameKnown("OVSD")
    6 => NameKnown("OVMD")
    7 => NameKnown("BATHY")
    11 => NameKnown("SFSALP")
    12 => NameKnown("SFTMPP")
    13 => NameKnown("ACWSRD")
    14 => NameKnown("WDEPTH")
    15 => NameKnown("WTMPSS")
    16 => NameKnown("WATERDEN")
    17 => NameKnown("WATDENA")
    18 => NameKnown("WATPTEMP")
    19 => NameKnown("WATPDEN")
    20 => NameKnown("WATPDENA")
    21 => NameKnown("PRTSAL")
    22 => NameKnown("WCHEATC")
    23 => NameKnown("EASTWVEL")
    24 => NameKnown("NRTHWVEL")
    25 => NameKnown("XCOMPWV")
    26 => NameKnown("YCOMPWV")
    27 => NameKnown("UPWWVEL")
    28 => NameKnown("VEDDYDIF")
    29 => NameKnown("BPEH")
    30 => NameKnown("FWFSW")
    31 => NameKnown("FWFC")
    32 => NameKnown("VSFSW")
    33 => NameKnown("VSFC")
    34 => NameKnown("SWTTNR")
    35 => NameKnown("SWSTNR")
    36 => NameKnown("SWTTP")
    37 => NameKnown("SWSTP")
    38 => NameKnown("ESWVP")
    39 => NameKnown("NSWVP")
    40 => NameKnown("SWTTBC")
    41 => NameKnown("SWSTBC")
    42 => NameKnown("SEAMVT")
    43 => NameKnown("SEAZVT")
    44 => NameKnown("SEACMVT")
    45 => NameKnown("SEACZVT")
    46 => NameKnown("SEAMMT")
    47 => NameKnown("SEAZMT")
    48 => NameKnown("SEACMMT")
    49 => NameKnown("SEACZMT")
    50 => NameKnown("SEACPSALT")
    51 => NameKnown("SEACSALT")
    52 => NameKnown("MLD")
    53 => NameKnown("NCOMPWVEL")
    54 => NameKnown("TCOMPWVEL")
    55 => NameKnown("SEAUVT")
    56 => NameKnown("SEAUMT")
    57 => NameKnown("SEAAGE")
    58 => NameKnown("DSWRFSEA")
    192 => NameKnown("WTMPC")
    193 => NameKnown("SALIN")
    194 => NameKnown("BKENG")
    195 => NameKnown("DBSS")
    196 => NameKnown("INTFD")
    197 => NameKnown("OHC")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 8 && parameter <= 10) ||
        (parameter >= 59 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 198 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_191_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("IRTSEC")
    1 => NameKnown("MOSF")
    3 => NameKnown("DSLOBSO")
    4 => NameKnown("BARDSF")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 2 || (parameter >= 5 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=191,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("UTHCIDX")
    1 => NameKnown("MEANRTMP")
    2 => NameKnown("WETBGTMP")
    3 => NameKnown("GLOBETMP")
    4 => NameKnown("HUMIDX")
    5 => NameKnown("EFFTEMP")
    6 => NameKnown("NOREFTMP")
    7 => NameKnown("STDEFTMP")
    8 => NameKnown("PEQUTMP")
    9 => NameKnown("UVBED")
    10 => NameKnown("UVBEDCS")
    11 => NameKnown("EHF")
    12 => NameKnown("ECF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 13 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("MALACASE")
    1 => NameKnown("MACPRATE")
    2 => NameKnown("PFEIRATE")
    3 => NameKnown("HBRATEAV")
    4 => NameKnown("MALAIMM")
    5 => NameKnown("FALPRATE")
    6 => NameKnown("DFPRATIO")
    7 => NameKnown("AVHRATIO")
    8 => NameKnown("AVECTNUM")
    9 => NameKnown("FMALVRH")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 10 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("POPDEN")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 1 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("RENPCAP")
    1 => NameKnown("RENPPROD")
    2 => NameKnown("WINDPCAP")
    3 => NameKnown("WINDPPROD")
    4 => NameKnown("SPVPCAP")
    5 => NameKnown("SPVPPROD")
    6 => NameKnown("SNPVPCAP")
    7 => NameKnown("SNPVPPROD")
    8 => NameKnown("CSPPCAP")
    9 => NameKnown("CSPPROD")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 10 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    1 => NameKnown("DBURSTHI")
    2 => NameKnown("LTNGHI")
    3 => NameKnown("TSTMHI")
    4 => NameKnown("COASTFLDHI")
    5 => NameKnown("ESTFLDHI")
    6 => NameKnown("FFLDHI")
    7 => NameKnown("FLUVFLDHI")
    8 => NameKnown("GFLDHI")
    9 => NameKnown("IJFLDHI")
    10 => NameKnown("PFLDHI")
    11 => NameKnown("SMFLDHI")
    12 => NameKnown("SWFLDHI")
    13 => NameKnown("GLOFLDHI")
    14 => NameKnown("BCHI")
    15 => NameKnown("DSTMHI")
    16 => NameKnown("FOGHI")
    17 => NameKnown("HZHI")
    18 => NameKnown("POLAIRHI")
    19 => NameKnown("SAHZHI")
    20 => NameKnown("SMOKEHI")
    21 => NameKnown("OAHI")
    22 => NameKnown("RWAVEHI")
    23 => NameKnown("SWIHI")
    24 => NameKnown("SICEHI")
    25 => NameKnown("ICEFLOWHI")
    26 => NameKnown("SEICHEHI")
    27 => NameKnown("SURGEHI")
    28 => NameKnown("STMTIDEHI")
    29 => NameKnown("TSUNAMIHI")
    30 => NameKnown("DEPRESHI")
    31 => NameKnown("ECPRESHI")
    32 => NameKnown("SUBTCPRESHI")
    33 => NameKnown("ACIDRAINHI")
    34 => NameKnown("BLIZHI")
    35 => NameKnown("DRTHI")
    36 => NameKnown("HAILHI")
    37 => NameKnown("ICESTMHI")
    38 => NameKnown("SNOWHI")
    39 => NameKnown("SNOWSTMHI")
    40 => NameKnown("CWAVEHI")
    41 => NameKnown("DZUDHI")
    42 => NameKnown("FRZHI")
    43 => NameKnown("FROSTHI")
    44 => NameKnown("FRZRHI")
    45 => NameKnown("GLAZEHI")
    46 => NameKnown("GFROSTHI")
    47 => NameKnown("HWAVEHI")
    48 => NameKnown("ICINGHI")
    49 => NameKnown("THAWHI")
    50 => NameKnown("AVALHI")
    51 => NameKnown("MUDFLOWHI")
    52 => NameKnown("RSLIDEHI")
    53 => NameKnown("DERECHOHI")
    54 => NameKnown("GALEHI")
    55 => NameKnown("SQLNHI")
    56 => NameKnown("SSTMHI")
    57 => NameKnown("TCWINDHI")
    58 => NameKnown("TSWINDHI")
    59 => NameKnown("TORHI")
    60 => NameKnown("WINDHI")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 0 || (parameter >= 61 && parameter <= 190) {
        NameKnown("Reserved")
      } else if parameter >= 191 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    1 => NameKnown("HHAIRPOLHI")
    2 => NameKnown("AIRPOLHI")
    3 => NameKnown("AAIRPOLHI")
    4 => NameKnown("LANDDEGHI")
    5 => NameKnown("SOILDEGHI")
    6 => NameKnown("RUNOFFHI")
    7 => NameKnown("SALTHI")
    8 => NameKnown("BDLOSSHI")
    9 => NameKnown("DEFORESTHI")
    10 => NameKnown("FORESTDECHI")
    11 => NameKnown("FORESTDISHI")
    12 => NameKnown("FORESTINVHI")
    13 => NameKnown("WFIREHI")
    14 => NameKnown("DESERTHI")
    15 => NameKnown("MANLOSSHI")
    16 => NameKnown("WETLOSSHI")
    17 => NameKnown("CORALBHI")
    18 => NameKnown("COMPSOILHI")
    19 => NameKnown("SOILEROHI")
    20 => NameKnown("COASTEROHI")
    21 => NameKnown("PFLOSSHI")
    22 => NameKnown("SAMINHI")
    23 => NameKnown("SLRHI")
    24 => NameKnown("EUTROPHI")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 0 || (parameter >= 25 && parameter <= 190) {
        NameKnown("Reserved")
      } else if parameter >= 191 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_191_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SPPT")
    1 => NameKnown("SPP")
    2 => NameKnown("SKEB")
    3 => NameKnown("STC")
    4 => NameKnown("SHUM")
    5 => NameKnown("STTP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=191,cat=0,param=" + parameter.to_string())
      }
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
  // Type 220: Planetary boundary layer
  if l1t == 220 && l2t == 255 {
    return NameKnown("planetary boundary layer")
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
