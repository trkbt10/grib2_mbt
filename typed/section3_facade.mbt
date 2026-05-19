///|
/// Section 3 facade: re-export the Grid Definition surface area —
/// `Grib2Section3Decoded`, `Grib2Section3TemplateData`,
/// `Grib2GridTemplate30` / `31`, the `decode_section3_bytes` /
/// `encode_section3_bytes` codec functions, plus the coordinate generators
/// (`CoordinateGrid`, `ScanningMode`, `generate_latlon_coordinates`,
/// `generate_rotated_latlon_coordinates`, `parse_scanning_mode`).
pub using @section3 {
  type Grib2Section3Decoded,
  type Grib2Section3TemplateData,
  type Grib2GridTemplate30,
  type Grib2GridTemplate31,
  decode_section3_bytes,
  encode_section3_bytes,
  type CoordinateGrid,
  type ScanningMode,
  generate_latlon_coordinates,
  generate_rotated_latlon_coordinates,
  parse_scanning_mode,
}
