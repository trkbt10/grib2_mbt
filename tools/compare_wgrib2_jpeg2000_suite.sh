#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPARE_SCRIPT="${ROOT_DIR}/tools/compare_wgrib2_values.sh"

if [[ ! -x "${COMPARE_SCRIPT}" ]]; then
  echo "error: compare script not found: ${COMPARE_SCRIPT}" >&2
  exit 1
fi

WGRIB2_BIN="${WGRIB2_BIN:-wgrib2}"

run_case() {
  local fixture="$1"
  local range="$2"
  echo "== jpeg2000 compare: ${fixture} (${range}) =="
  WGRIB2_BIN="${WGRIB2_BIN}" bash "${COMPARE_SCRIPT}" "${ROOT_DIR}/${fixture}" "${range}"
  echo
}

run_case "fixtures/grib2_jpeg2000/eccodes_jpeg.grib2" "1:1"
run_case "fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2" "1:1"
run_case "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2" "1:19"
