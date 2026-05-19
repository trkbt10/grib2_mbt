///|
/// Section 6 facade: re-export the Bitmap surface area — `Grib2Section6Decoded`
/// plus the `decode_section6_bytes` / `encode_section6_bytes` codec functions.
pub using @section6 {
  type Grib2Section6Decoded,
  decode_section6_bytes,
  encode_section6_bytes,
}
