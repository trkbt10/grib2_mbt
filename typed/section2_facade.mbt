///|
/// Section 2 facade: re-export the Local Use surface area —
/// `Grib2Section2Decoded` plus the `decode_section2_bytes` /
/// `encode_section2_bytes` codec functions.
pub using @section2 {
  type Grib2Section2Decoded,
  decode_section2_bytes,
  encode_section2_bytes,
}
