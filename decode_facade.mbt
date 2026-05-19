///|
/// Decode facade: re-export the section-decoding surface from @decode —
/// `Grib2SectionCodecError`, the `Grib2Section{1..7}Decoded` records,
/// `Grib2RecordMeta`, `Grib2WriteError`, the per-section
/// `decode_submessage_section*` and `decode_message_section1` entry points,
/// the umbrella `decode_records`, `unpack_submessage_data`,
/// `validate_context_invariants`, `rebuild_raw`, and `rebuild_strict`.
pub using @decode {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  type Grib2Section2Decoded,
  type Grib2Section3Decoded,
  type Grib2Section4Decoded,
  type Grib2Section5Decoded,
  type Grib2Section6Decoded,
  type Grib2Section7Decoded,
  type Grib2RecordMeta,
  type Grib2WriteError,
  decode_message_section1,
  decode_submessage_section2,
  decode_submessage_section3,
  decode_submessage_section4,
  decode_submessage_section5,
  decode_submessage_section6,
  decode_submessage_section7,
  decode_records,
  unpack_submessage_data,
  validate_context_invariants,
  rebuild_raw,
  rebuild_strict,
}
