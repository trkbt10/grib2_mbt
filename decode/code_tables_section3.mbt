///|
/// Code-table lookups bound to GRIB2 Section 3 (Grid Definition): grid source,
/// template number, reference-system shape, resolution/scanning-mode flag
/// tables, spectral data parameters, diamond grid metadata, and the
/// appended-list interpretation.
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

