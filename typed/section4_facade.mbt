///|
/// Section 4 facade: publicly re-export the Product Definition Template
/// surface area — `Grib2Section4Decoded`, `Grib2Section4TemplateData`,
/// `Grib2ProductTemplate40` / `41` / `45` / `48` / `411`, plus the
/// `decode_section4_bytes` / `encode_section4_bytes` codec entry points.
pub using @section4 {
  type Grib2Section4Decoded,
  type Grib2Section4TemplateData,
  type Grib2ProductTemplate40,
  type Grib2ProductTemplate41,
  type Grib2ProductTemplate45,
  type Grib2ProductTemplate48,
  type Grib2ProductTemplate411,
  decode_section4_bytes,
  encode_section4_bytes,
}
