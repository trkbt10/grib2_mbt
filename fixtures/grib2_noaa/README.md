# NOAA GRIB2 Fixtures

This directory contains NOAA/NCEP GRIB2 sample files for parser/reader/writer tests.

## Source

Downloaded from NOMADS (NOAA) on 2026-02-21 (UTC), based on:

- `gfs.20260221/00/atmos`
- `gfs.20260221/00/wave/gridded`

Base URL:

- `https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20260221/00/`

## Files

- `gfs.t00z.pgrb2.1p00.f000.grib2`
  - Global GFS atmospheric fields (`pgrb2`, 1.00-degree grid)
- `gfs.t00z.pgrb2b.1p00.f000.grib2`
  - Additional atmospheric fields (`pgrb2b`, 1.00-degree grid)
- `gfswave.t00z.global.0p25.f000.grib2`
  - Global wave fields (0.25-degree grid)
- `gfswave.t00z.atlocn.0p16.f000.grib2`
  - Atlantic wave fields (0.16-degree regional grid, smaller fixture)

For exact URLs, sizes, and checksums, see `manifest.tsv`.
