# JPEG2000 External API Issue Request

## Context

`grib2_mbt` now depends on `trkbt10/jpeg2000` for JPEG2000 codestream validation.
For validation-only use cases, current parser APIs are sufficient.
For full GRIB2 template 5.40 unpack, an external public decode API is still required.

## Decision matrix

- Validation only (syntax/marker compatibility, parser interoperability):
  - No new API required.
  - Use `parse_codestream` / `parse_codestream_strict`.
- Operational decode (Section 7 numeric reconstruction for GRIB2):
  - New decode API required.
  - `grib2_mbt` cannot fully migrate without it.

## Required upstream issue

Please open an issue on `trkbt10/jpeg2000` to add a stable public decode API for GRIB2 use.

- Title proposal:
  - `Add public JPEG2000 decode API for GRIB2 template 5.40 integration`
- Minimum required capability:
  - Decode codestream/JP2 payload to sample-domain coefficients.
  - Return decoded samples and effective point count.
  - Keep parser-only API behavior unchanged.
- Proposed API (example):
  - `decode_grib2_template540(data : Bytes, reference_value_ieee : Int, binary_scale_factor : Int, decimal_scale_factor : Int, bits_per_value : Int, num_points : Int) -> Result[(Array[Double], Int), String]`

## Why this is required

- `grib2_mbt` needs deterministic scalar reconstruction for operational GRIB2 data.
- Parser-only APIs are not sufficient for section 7 unpack.
- A public decode API enables replacing `grib2_mbt` legacy decoder backend entirely.
