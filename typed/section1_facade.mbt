///|
/// Section 1 facade: re-export the Identification surface area —
/// `Grib2SectionCodecError`, `Grib2Section1Decoded`, and the
/// `decode_section1_bytes` / `encode_section1_bytes` codec functions.
pub using @section1 {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  decode_section1_bytes,
  encode_section1_bytes,
}
