///|
pub using @section1 {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  decode_section1_bytes,
  encode_section1_bytes,
}

///|
pub using @section2 {
  type Grib2Section2Decoded,
  decode_section2_bytes,
  encode_section2_bytes,
}

///|
pub using @section3 {
  type Grib2Section3Decoded,
  decode_section3_bytes,
  encode_section3_bytes,
  // Coordinate generation
  type CoordinateGrid,
  type ScanningMode,
  generate_latlon_coordinates,
  generate_rotated_latlon_coordinates,
  parse_scanning_mode,
}

///|
pub using @section4 {
  type Grib2Section4Decoded,
  decode_section4_bytes,
  encode_section4_bytes,
}

///|
pub using @section5 {
  type Grib2Section5Decoded,
  decode_section5_bytes,
  encode_section5_bytes,
}

///|
pub using @section6 {
  type Grib2Section6Decoded,
  decode_section6_bytes,
  encode_section6_bytes,
}

///|
pub using @section7 {
  type Grib2Section7Decoded,
  decode_section7_bytes,
  encode_section7_bytes,
  // Data unpacking
  type BitReader,
  type UnpackedGridData,
  type UnpackError,
  ieee754_single_to_double,
  unpack_simple,
  // JPEG2000/PNG stubs
  unpack_jpeg2000,
  unpack_jpeg2000_differencing,
  get_jpeg2000_raw_bytes,
  get_jpeg2000_params,
  unpack_png,
  get_png_raw_bytes,
}
