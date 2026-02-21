#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
OUT_DIR="fixtures/wgrib2_snapshots"

if [[ ! -x "${WGRIB2_BIN}" ]]; then
  echo "error: wgrib2 not found or not executable: ${WGRIB2_BIN}" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"
rm -rf "${OUT_DIR}/jma_gsm" "${OUT_DIR}/noaa_gfs_pgrb2b_1p00_f000" "${OUT_DIR}/noaa_gfswave_atlocn_0p16_f000"
mkdir -p "${OUT_DIR}/jma_gsm" "${OUT_DIR}/noaa_gfs_pgrb2b_1p00_f000" "${OUT_DIR}/noaa_gfswave_atlocn_0p16_f000"

generate_one() {
  local fixture_id="$1"
  local file_path="$2"
  local dest="${OUT_DIR}/${fixture_id}"

  echo "generating snapshots: ${fixture_id}"

  "${WGRIB2_BIN}" "${file_path}" > "${dest}/default.txt"
  "${WGRIB2_BIN}" "${file_path}" -s > "${dest}/s.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec0 > "${dest}/Sec0.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec3 > "${dest}/Sec3.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec4 > "${dest}/Sec4.txt"
  "${WGRIB2_BIN}" "${file_path}" -var -lev > "${dest}/var_lev.txt"
}

generate_one \
  "jma_gsm" \
  "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"

generate_one \
  "noaa_gfs_pgrb2b_1p00_f000" \
  "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"

generate_one \
  "noaa_gfswave_atlocn_0p16_f000" \
  "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"

{
  echo -e "fixture_id\tfixture_path\tcommand\tsnapshot_path"
  for id in jma_gsm noaa_gfs_pgrb2b_1p00_f000 noaa_gfswave_atlocn_0p16_f000; do
    case "${id}" in
      jma_gsm)
        fixture="fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
        ;;
      noaa_gfs_pgrb2b_1p00_f000)
        fixture="fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
        ;;
      noaa_gfswave_atlocn_0p16_f000)
        fixture="fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
        ;;
      *)
        echo "error: unknown fixture id ${id}" >&2
        exit 1
        ;;
    esac
    for cmd in default s Sec0 Sec3 Sec4 var_lev; do
      echo -e "${id}\t${fixture}\t${cmd}\tfixtures/wgrib2_snapshots/${id}/${cmd}.txt"
    done
  done
} > "${OUT_DIR}/manifest.tsv"

echo "done: ${OUT_DIR}"
