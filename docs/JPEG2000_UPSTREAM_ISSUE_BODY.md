Title: Add public JPEG2000 decode API for GRIB2 template 5.40 integration

## Background

`grib2_mbt` integrates with `trkbt10/jpeg2000`.
Current public APIs are parser/metadata oriented and are enough for validation use cases.

Validation-only path:
- `parse_codestream`
- `parse_codestream_strict`

Operational GRIB2 decode path:
- Needs numeric reconstruction for Section 7 template 5.40.
- This cannot be fully migrated from `grib2_mbt` legacy decoder without a public decode API.

## Request

Please provide a public decode API that can be used by GRIB2 consumers.

### Proposed API (example)

`decode_grib2_template540(data : Bytes, reference_value_ieee : Int, binary_scale_factor : Int, decimal_scale_factor : Int, bits_per_value : Int, num_points : Int) -> Result[(Array[Double], Int), String]`

## Acceptance criteria

- Decodes raw codestream (`.j2k/.j2c`) and JP2-wrapped codestream used in GRIB2 Section 7 payloads.
- Returns reconstructed values and effective point count.
- Keeps existing parser APIs backward compatible.
- Includes corpus-based verification guidance (OpenJPEG/ecCodes-aligned fixtures).

## Why this matters

- Enables `grib2_mbt` to remove duplicated legacy JPEG2000 decode implementation.
- Keeps validation and decode responsibilities clearly separated.
