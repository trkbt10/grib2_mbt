# GRIB2 Code Structure

## Goal

Keep typed codec code maintainable while Section 3/4/5/7 templates continue to grow.

## Current Layout

- `typed/reexports.mbt`
  - facade package that re-exports typed byte APIs for root bridge
- `typed/section1/grib2_typed_section1_types.mbt`
- `typed/section1/grib2_typed_section1_core.mbt`
- `typed/section1/grib2_typed_sections_section1_test.mbt`
  - Section 1 model/codec + shared binary helpers used by Section 3/4
- `typed/section3/grib2_typed_section3_types.mbt`
- `typed/section3/grib2_typed_sections_section3_decode.mbt`
- `typed/section3/grib2_typed_sections_section3_encode.mbt`
- `typed/section3/grib2_typed_sections_section3_dispatch.mbt`
- `typed/section3/grib2_typed_sections_section3_test.mbt`
  - Section 3 model/decode/encode/dispatch
- `typed/section4/grib2_typed_sections_section4_types_040_463.mbt`
- `typed/section4/grib2_typed_sections_section4_types_467_499.mbt`
- `typed/section4/grib2_typed_sections_section4_types_4100_41101.mbt`
- `typed/section4/grib2_typed_sections_section4_decode_040_463.mbt`
- `typed/section4/grib2_typed_sections_section4_decode_467_499.mbt`
- `typed/section4/grib2_typed_sections_section4_decode_4100_41101.mbt`
- `typed/section4/grib2_typed_sections_section4_encode_040_463.mbt`
- `typed/section4/grib2_typed_sections_section4_encode_467_499.mbt`
- `typed/section4/grib2_typed_sections_section4_encode_4100_41101.mbt`
- `typed/section4/grib2_typed_sections_section4_dispatch.mbt`
- `typed/section4/grib2_typed_sections_section4_time_range_helpers.mbt`
- `typed/section4/grib2_typed_sections_section4_test.mbt`
  - Section 4 model/decode/encode/dispatch split by template ranges
- `grib2_typed_sections_bridge.mbt`
  - root-package bridge from `Grib2MessageContext` to typed byte codecs
- `grib2_typed_sections.mbt`
  - thin index file (kept for discoverability)

## Expansion Rules

- When adding new Section 4 templates:
  - add/extend types in matching `typed/section4/grib2_typed_sections_section4_types_*.mbt`
  - add decode logic in matching `typed/section4/grib2_typed_sections_section4_decode_*.mbt`
  - add encode logic in matching `typed/section4/grib2_typed_sections_section4_encode_*.mbt`
  - wire template number in `typed/section4/grib2_typed_sections_section4_dispatch.mbt`
  - add tests in `typed/section4/grib2_typed_sections_section4_test.mbt`
- If repeated binary-field patterns appear 2+ times across Section3/4, promote helper functions to `typed/section1/grib2_typed_section1_core.mbt`.
- Keep `decode -> encode` roundtrip invariant and `reserved_tail` preservation.
