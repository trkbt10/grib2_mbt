///|
/// Section 7 facade: re-export the Data surface area including unpackers —
/// `Grib2Section7Decoded`, the `decode_section7_bytes` /
/// `encode_section7_bytes` codec functions, the bit reader (`BitReader`),
/// the unpacked-grid container (`UnpackedGridData`), the `UnpackError` family,
/// the IEEE-754 helpers, and the per-packing unpackers (simple, IEEE, complex,
/// complex+spatial, JPEG2000 with optional external integration, and PNG).
pub using @section7 {
  type Grib2Section7Decoded,
  decode_section7_bytes,
  encode_section7_bytes,
  type BitReader,
  type UnpackedGridData,
  type UnpackError,
  ieee754_single_to_double,
  u16_to_i16,
  unpack_ieee,
  unpack_simple,
  unpack_jpeg2000,
  unpack_jpeg2000_with_external_package,
  unpack_jpeg2000_differencing,
  unpack_png,
  get_png_raw_bytes,
  unpack_complex,
  unpack_complex_spatial,
}
