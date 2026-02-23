# JPEG2000 / PNG Fixture Guide

This note fixes template-number confusion and documents reproducible fixtures.

## Template Mapping (GRIB2 Section 5)

- `5.4`: IEEE floating-point data (not PNG)
- `5.40`: JPEG2000 codestream
- `5.41`: PNG stream

References in this repository:

- `spec/grib2/markdown/pages/grib2_temp5-4.md`
- `spec/grib2/markdown/pages/grib2_temp5-40.md`
- `spec/grib2/markdown/pages/grib2_temp5-41.md`

## Fetch 5.40 Fixtures

Run:

```sh
tools/fetch_jpeg2000_fixtures.sh
```

This script downloads (as of 2026-02-23):

- ecCodes test archive:
  - `https://sites.ecmwf.int/repository/eccodes/test-data/eccodes_test_data.tar.gz`
- Extracted fixture files:
  - `data/jpeg.grib2`
  - `data/reduced_gaussian_surface_jpeg.grib2`

Output directory:

- `fixtures/grib2_jpeg2000/`

Repository fixtures committed from this source:

- `fixtures/grib2_jpeg2000/eccodes_jpeg.grib2`
- `fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2`

Template-number reference:

- WMO GRIB2 template 5.40 (JPEG2000): `spec/grib2/markdown/pages/grib2_temp5-40.md`
- WMO GRIB2 template 5.41 (PNG): `spec/grib2/markdown/pages/grib2_temp5-41.md`

## Generate 5.41 Fixtures (PNG)

Publicly available GRIB2 files with `5.41` are rare. The stable path is to
generate them from an existing field.

Example with `cnvgrib` (if installed):

```sh
cnvgrib -g21 -p41 input.grib2 output_5p41.grib2
wgrib2 output_5p41.grib2 -Sec5 | head
```

Expected in `-Sec5` output:

- `Data Repr. Template=5.41`

If `cnvgrib` is unavailable, keep `5.41` tests as local/manual until a known
generator is added to CI.
