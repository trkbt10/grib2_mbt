///|
/// Section 5 facade: re-export the Data Representation surface area —
/// `Grib2Section5Decoded`, `Grib2Section5TemplateData`,
/// `Grib2DataRepresentationTemplate50` / `52` / `53` / `540`, plus the
/// `decode_section5_bytes` / `encode_section5_bytes` codec functions.
pub using @section5 {
  type Grib2Section5Decoded,
  type Grib2Section5TemplateData,
  type Grib2DataRepresentationTemplate50,
  type Grib2DataRepresentationTemplate52,
  type Grib2DataRepresentationTemplate53,
  type Grib2DataRepresentationTemplate540,
  decode_section5_bytes,
  encode_section5_bytes,
}
