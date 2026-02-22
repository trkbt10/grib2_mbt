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
  match (discipline, category, parameter) {
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
