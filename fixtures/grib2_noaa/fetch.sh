#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

download() {
  local out="$1"
  local url="$2"
  echo "downloading: ${out}"
  curl --http1.1 -fL -o "${ROOT_DIR}/${out}" "${url}"
}

download "gfs.t00z.pgrb2.1p00.f000.grib2" \
  "https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20260221/00/atmos/gfs.t00z.pgrb2.1p00.f000"

download "gfs.t00z.pgrb2b.1p00.f000.grib2" \
  "https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20260221/00/atmos/gfs.t00z.pgrb2b.1p00.f000"

download "gfswave.t00z.global.0p25.f000.grib2" \
  "https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20260221/00/wave/gridded/gfswave.t00z.global.0p25.f000.grib2"

download "gfswave.t00z.atlocn.0p16.f000.grib2" \
  "https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.20260221/00/wave/gridded/gfswave.t00z.atlocn.0p16.f000.grib2"

echo "done"
